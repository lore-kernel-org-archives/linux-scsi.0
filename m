From: "Grant Grundler" <grundler@google.com>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Thu, 5 Jun 2008 11:34:56 -0700
Message-ID: <da824cf30806051134u4fb8d419p2ba2dafcb1ba33a7@mail.gmail.com>
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp>
	 <da824cf30806041106p1de2355fg38594fcb9dcbf203@mail.gmail.com>
	 <20080605235322L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:48034 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761281AbYFESfL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 14:35:11 -0400
Received: from spaceape7.eur.corp.google.com (spaceape7.eur.corp.google.com [172.28.16.141])
	by smtp-out.google.com with ESMTP id m55IYvU3018643
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jun 2008 19:34:57 +0100
Received: from yw-out-1718.google.com (ywm5.prod.google.com [10.192.13.5])
	by spaceape7.eur.corp.google.com with ESMTP id m55IYVGC002537
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jun 2008 19:34:56 +0100
Received: by yw-out-1718.google.com with SMTP id 5so510266ywm.72
        for <linux-scsi@vger.kernel.org>; Thu, 05 Jun 2008 11:34:56 -0700 (PDT)
In-Reply-To: <20080605235322L.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org

On Thu, Jun 5, 2008 at 7:49 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
...
>> You can easily emulate SSD drives by doing sequential 4K reads
>> from a normal SATA HD. That should result in ~7-8K IOPS since the disk
>> will recognize the sequential stream and read ahead. SAS/SCSI/FC will
>> probably work the same way with different IOP rates.
>
> Yeah, probabaly right. I thought that 10GbE give the IOMMU more
> workloads than SSD does and tried to emulate something like that.

10GbE might exercise a different code path. NICs typically use map_single
and storage devices typically use map_sg.  But they both exercise the same
underlying resource management code since it's the same IOMMU they poke at.

...
>> Sorry, I didn't see a replacement for the deferred_flush_tables.
>> Mark Gross and I agree this substantially helps with unmap performance.
>> See http://lkml.org/lkml/2008/3/3/373
>
> Yeah, I can add a nice trick in parisc sba_iommu uses. I'll try next
> time.
>
> But it probably gives the bitmap method less gain than the RB tree
> since clear the bitmap takes less time than changing the tree.
>
> The deferred_flush_tables also batches flushing TLB. The patch flushes
> TLB only when it reaches the end of the bitmap (it's a trick that some
> IOMMUs like SPARC does).

The batching of the TLB flushes is the key thing. I was being paranoid
by not marking the resource free until after the TLB was flushed. If we
know the allocation is going to be circular through the bitmap, flushing
the TLB once per iteration through the bitmap should be sufficient since
we can guarantee the IO Pdir resource won't get re-used until a full
cycle through the bitmap has been completed.

I expect this will work for parisc too and I can test that. Funny that didn't
"click" with me when I original wrote the parisc code. DaveM had even told
me the SPARC code was only flushing the IOTLB once per iteration.

...
> Agreed. VT-d can handle DMA virtual address space larger than 32 bits
> but it means that we need more memory for the bitmap. I think that the
> majority of systems don't need DMA virtual address space larger than
> 32 bits. Making it as a kernel parameter is a reasonable approach, I
> think.

Agreed. It needs a resonable default and a way to change it at runtime
for odd cases.

...
>> "32-PAGE_SHIFT_4K" expression is used in several places but I didn't see
>> an explanation of why 32. Can you add one someplace?
>
> OK, I'll do next time. Most of them are about 4GB virtual address
> space that the patch uses.

thanks! The comment should then explain why 4GB is "reasonable" (vs
1GB for example).

...
> Thanks a lot! I didn't expect this patch to be reviewed. I really
> appreciate it.

very welcome,
grant
