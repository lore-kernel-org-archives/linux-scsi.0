From: "Grant Grundler" <grundler@google.com>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Fri, 6 Jun 2008 14:28:36 -0700
Message-ID: <da824cf30806061428t4b7ed816i74d961946d77c88b@mail.gmail.com>
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp>
	 <da824cf30806041106p1de2355fg38594fcb9dcbf203@mail.gmail.com>
	 <20080606202119.GQ15085@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:49863 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbYFFV2n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 17:28:43 -0400
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id m56LSa1a029200
	for <linux-scsi@vger.kernel.org>; Fri, 6 Jun 2008 22:28:37 +0100
Received: from wf-out-1314.google.com (wfc25.prod.google.com [10.142.3.25])
	by zps77.corp.google.com with ESMTP id m56LSIJ1027054
	for <linux-scsi@vger.kernel.org>; Fri, 6 Jun 2008 14:28:36 -0700
Received: by wf-out-1314.google.com with SMTP id 25so1075824wfc.22
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jun 2008 14:28:36 -0700 (PDT)
In-Reply-To: <20080606202119.GQ15085@il.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org

On Fri, Jun 6, 2008 at 1:21 PM, Muli Ben-Yehuda <muli@il.ibm.com> wrote:
....
>> It's possible to split up one flat address space and share the IOMMU
>> among several users. Each user gets her own segment of bitmap and
>> corresponding IO Pdir. So I don't see allocation policy as a strong
>> reason to use Red/Black Tree.
>
> Do you mean multiple users sharing the same I/O address space (but
> each user using a different segment), or multiple users, each with its
> own I/O address space, but only using a specific segment of that
> address space and using a single bitmap to represent free space in all
> segments?

Yes, I meant the former.

> If the former, then you are losing some of the benefit of
> the IOMMU since all users can DMA to other users areas (same I/O
> address space). If the latter, having a bitmap per IO address space
> seems simpler and would have the same memory consumption.


Agreed. It's a trade off.

...
>> I've never been able to come up with a good heuristic for
>> determining the size of the IOVA space. It generally does NOT need
>> to map all of Host Physical RAM.  The actual requirement depends
>> entirely on the workload, type and number of IO devices
>> installed. The problem is we don't know any of those things until
>> well after the IOMMU is already needed.
>
> Why not do what hash-tables implementation do, start small and resize
> when we approach half-full?

Historically the IOMMUs needed physically contiguous memory and
resizing essentially meant quiescing all DMA, moving the IO Pdir data
to the new bigger location,  allocating a new bitmap and cloning the
state into that as well, and then resuming DMA operations. The DMA
quiesce requirement effectively meant a reboot. My understanding of
Vt-d is the ranges can be added range at a time and thus can be easily
resized. But it will mean more complex logic in the IOMMU bitmap
handling for a domain which owns multiple bitmaps and thus a slightly
higher CPU utilization cost. At least that's my guess. I'm not working
on any IOMMU code lately...

thanks,
grant
