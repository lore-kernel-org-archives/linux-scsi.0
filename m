From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: virtio(-scsi) vs. chained sg_lists (was Re: [PATCH] scsi: virtio-scsi:
 Fix address translation failure of HighMem pages used by sg list)
Date: Thu, 26 Jul 2012 09:23:42 +0200
Message-ID: <5010F07E.7050506@redhat.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com> <500FF412.3090600@panasas.com> <50100014.2010109@redhat.com> <50101091.5090909@panasas.com> <50103043.5050508@redhat.com> <50104614.3080002@panasas.com> <501051DF.5040907@redhat.com> <50105F60.8050707@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59096 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2GZHXs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2012 03:23:48 -0400
In-Reply-To: <50105F60.8050707@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>

Il 25/07/2012 23:04, Boaz Harrosh ha scritto:
>> That not all architectures have ARCH_HAS_SG_CHAIN (though all those I
>> care about do).  So I need to go through all architectures and make sure
>> they use for_each_sg, or at least to change ARCH_HAS_SG_CHAIN to a
>> Kconfig define so that dependencies can be expressed properly.
> 
> What is actually preventing ARCH_HAS_SG_CHAIN from all these ARCHES?
> is that the DMA drivers not using for_each_sg(). Sounds like easy
> to fix.
> 
> But yes a deep change would convert ARCH_HAS_SG_CHAIN to a Kconfig.
> 
> If you want to be lazy, like me, You might just put a BUILD_BUG_ON
> in code, requesting the user to disable the driver for this ARCH.
> 
> I bet there is more things to do at ARCH to enable virtualization
> then just support ARCH_HAS_SG_CHAIN. Be it just another requirement.

Actually, many arches run just fine with QEMU's binary code translation
(alpha, mips, coldfire).  And since it's already pretty slow, using
virtio to improve performance is nice even in that scenario (which does
not require any kernel change).  But it's just an icing on the cake
indeed.  I can live with a BUILD_BUG_ON or better a "depends on
HAVE_SG_CHAIN" for the time being.

>>> And BTW you won't need that new __sg_set_page API anymore.
>>
>> Kind of.
>>
>>    sg_init_table(sg, 2);
>>    sg_set_buf(sg[0], req, sizeof(req));
>>    sg_chain(sg[1], scsi_out(sc));
>>
>> is still a little bit worse than
>>
>>    __sg_set_buf(sg[0], req, sizeof(req));
>>    __sg_chain(sg[1], scsi_out(sc));
> 
> 
> I believe they are the same, specially for the
> on the stack 2 elements array. Actually I think
> In both cases you need to at least call sg_init_table()
> once after allocation, No?

Because the scatterlist here would be allocated on the stack, I would
need to call it every time if I used sg_set_buf/sg_chain.

But sg_init_table is really just memset + set SG_MAGIC + sg_mark_end.
If you use the "full-init" APIs as above, you don't need any of those
(sg_chain undoes the flag changes in sg_mark_end and vice versa).

> But please for my sake do not call it __sg_chain. Call it
> something like sg_chain_not_end(). I hate those "__" which
> for god sack means what? 
> (A good name is when I don't have to read the code, an "__"
>  means "fuck you go read the code")

Right, better call them sg_init_buf/sg_init_page/sg_init_chain.

In the meanwhile, we still have a bug to fix, and we need to choose
between Sen Wang's v1 (sg_set_page) or v2 (value assignment).  I'm still
leaning more towards v2, if only because I already tested that one myself.

Paolo
