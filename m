From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: virtio(-scsi) vs. chained sg_lists (was Re: [PATCH] scsi: virtio-scsi:
 Fix address translation failure of HighMem pages used by sg list)
Date: Mon, 30 Jul 2012 11:56:47 +0300
Message-ID: <50164C4F.7030905@panasas.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com> <500FF412.3090600@panasas.com> <50100014.2010109@redhat.com> <50101091.5090909@panasas.com> <50103043.5050508@redhat.com> <50104614.3080002@panasas.com> <501051DF.5040907@redhat.com> <50105F60.8050707@panasas.com> <5010F07E.7050506@redhat.com> <5010F831.9030300@panasas.com> <5010F896.8090409@redhat.com> <501140A3.9090908@redhat.com> <874notoh02.fsf@rustcorp.com.au> <50124D2E.7050407@redhat.com> <87obmym8jv.fsf@rustcorp.com.au> <501633EA.603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:55601 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab2G3I5O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2012 04:57:14 -0400
In-Reply-To: <501633EA.603@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>

On 07/30/2012 10:12 AM, Paolo Bonzini wrote:

> Il 30/07/2012 01:50, Rusty Russell ha scritto:
>>> Also, being the first user of chained scatterlist doesn't exactly give
>>> me warm fuzzies.
>>
>> We're far from the first user: they've been in the kernel for well over
>> 7 years.  They were introduced for the block layer, but they tended to
>> ignore private uses of scatterlists like this one.
> 
> Yeah, but sg_chain has no users in drivers, only a private one in
> lib/scatterlist.c.  The internal API could be changed to something else
> and leave virtio-scsi screwed...
> 
>> Yes, we should do this.  But note that this means an iteration, so we
>> might as well combine the loops :)
> 
> I'm really bad at posting pseudo-code, but you can count the number of
> physically-contiguous entries at the beginning of the list only.  So if
> everything is contiguous, you use a single non-indirect buffer and save
> a kmalloc.  If you use indirect buffers, I suspect it's much less
> effective to collapse physically-contiguous entries.  More elaborate
> heuristics do need a loop, though.
> 


[All the below with a grain of salt, from my senile memory]

You must not forget some facts about the scatterlist received here at the LLD.
It has already been DMA mapped and locked by the generic layer.
Which means that the DMA engine has already collapsed physically-contiguous
entries. Those you get here are already unique physically.
(There were bugs in the past, where this was not true, please complain
 if you find them again)

A scatterlist is two different lists taking the same space, but with two
different length.
- One list is the PAGE pointers plus offset && length, which is bigger or
  equal to the 2nd list. The end marker corresponds to this list.

  This list is the input into the DMA engine.

- Second list is the physical DMA addresses list. With their physical-lengths.
  Offset is not needed because it is incorporated in the DMA address.

  This list is the output from the DMA engine.

  The reason 2nd list is shorter is because the DMA engine tries to minimize
  the physical scatter-list entries which is usually a limited HW resource.

  This list might follow chains but it's end is determined by the received
  sg_count from the DMA engine, not by the end marker.

At the time my opinion, and I think Rusty agreed, was that the scatterlist
should be split in two. The input page-ptr list is just the BIO, and the
output of the DMA-engine should just be the physical part of the sg_list,
as a separate parameter. But all this was berried under too much APIs and
the noise was two strong, for any single brave sole.

So I'd just trust blindly the returned sg_count from the DMA engine, it is
already optimized. I THINK

> Paolo


Boaz
