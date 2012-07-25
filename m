From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: virtio(-scsi) vs. chained sg_lists (was Re: [PATCH] scsi: virtio-scsi:
 Fix address translation failure of HighMem pages used by sg list)
Date: Thu, 26 Jul 2012 00:04:32 +0300
Message-ID: <50105F60.8050707@panasas.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com> <500FF412.3090600@panasas.com> <50100014.2010109@redhat.com> <50101091.5090909@panasas.com> <50103043.5050508@redhat.com> <50104614.3080002@panasas.com> <501051DF.5040907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <501051DF.5040907@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
List-Id: linux-scsi@vger.kernel.org

On 07/25/2012 11:06 PM, Paolo Bonzini wrote:

> Il 25/07/2012 21:16, Boaz Harrosh ha scritto:
>> The picture confused me. It looked like the first element is the virtio_scsi_cmd_req
>> not an sgilist-element that points to the struct's buffer.
>>
>> In that case then yes your plan of making a two-elements fragment that points to the
>> original scsi-sglist is perfect. All you have to do is that, and all you have to do
>> at virtio is use the sg_for_each macro and you are done.
>>
>> You don't need any sglist allocation or reshaping. And you can easily support
>> chaining. Looks like order of magnitude more simple then what you do now
> 
> It is.
> 
>> So what is the problem?
> 
> That not all architectures have ARCH_HAS_SG_CHAIN (though all those I
> care about do).  So I need to go through all architectures and make sure
> they use for_each_sg, or at least to change ARCH_HAS_SG_CHAIN to a
> Kconfig define so that dependencies can be expressed properly.
> 


What is actually preventing ARCH_HAS_SG_CHAIN from all these ARCHES?
is that the DMA drivers not using for_each_sg(). Sounds like easy
to fix.

But yes a deep change would convert ARCH_HAS_SG_CHAIN to a Kconfig.

If you want to be lazy, like me, You might just put a BUILD_BUG_ON
in code, requesting the user to disable the driver for this ARCH.

I bet there is more things to do at ARCH to enable virtualization
then just support ARCH_HAS_SG_CHAIN. Be it just another requirement.

If you Document it and make sure current ARCHs are fine, it should
not ever trigger.

>> And BTW you won't need that new __sg_set_page API anymore.
> 
> Kind of.
> 
>    sg_init_table(sg, 2);
>    sg_set_buf(sg[0], req, sizeof(req));
>    sg_chain(sg[1], scsi_out(sc));
> 
> is still a little bit worse than
> 
>    __sg_set_buf(sg[0], req, sizeof(req));
>    __sg_chain(sg[1], scsi_out(sc));
> 


I believe they are the same, specially for the
on the stack 2 elements array. Actually I think
In both cases you need to at least call sg_init_table()
once after allocation, No?

Your old code with big array copy and re-shaping was
a better example of the need for your new API. Which I agree.

But please for my sake do not call it __sg_chain. Call it
something like sg_chain_not_end(). I hate those "__" which
for god sack means what? 
(A good name is when I don't have to read the code, an "__"
 means "fuck you go read the code")

> Paolo


Thanks
Boaz
