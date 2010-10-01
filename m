From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: [PATCH] block: set the bounce_pfn to the actual DMA limit
 rather than to max memory
Date: Thu, 30 Sep 2010 19:30:24 -0700
Message-ID: <20101001023024.GA1828@us.ibm.com>
References: <c9516154fabc03112353.1285107750@malahal>
 <4C9CAE68.4060706@fusionio.com>
 <20100924170532.GA29071@us.ibm.com>
 <4C9CEDE5.902@fusionio.com>
 <20100924192059.GA550@us.ibm.com>
 <4C9CFB4B.10404@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44417 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab0JACa1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2010 22:30:27 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o912FEYb013885
	for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2010 22:15:14 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o912UQBq1998986
	for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2010 22:30:26 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o912UPfn025964
	for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2010 22:30:26 -0400
Content-Disposition: inline
In-Reply-To: <4C9CFB4B.10404@fusionio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Jens Axboe [jaxboe@fusionio.com] wrote:
> On 2010-09-24 21:20, Malahal Naineni wrote:
> > Jens Axboe [jaxboe@fusionio.com] wrote:
> >>> This patch also _fixed_ our problem. So we are fine with either patch,
> >>> but this patch is preferred as it enables more request merges. Also,
> >>> both patches maybe needed for some configurations.
> >>
> >> Plus it doesn't needlessly bounce, that's the real problem you want to
> >> fix. I have applied this thread patch to for-2.6.37/core, thanks.
> > 
> > There is a shortcut check in blk_queue_bounce() that uses blk_max_pfn to
> > return without doing anything.  blk_max_pfn is not updated when we do
> > hot-plug memory add, so bounce buffers are NOT really used in our case
> > (thankfully)! 
> 
> Any reason we can't just add a hot mem add notifier and update the block
> copies when we need to?

Actually it is quite simple, but power arch guys decided not to update
max_pfn and max_low_pfn when someone adds or removes memory. They do
seem to indicate that it is not an over sight! On the other hand, x86
arch does update those.

Another approach would be defining max_possible_pfn (maximum allowable
memory) which would be constant (based on architecture) and hopefully
adapters that we care still take the short-cut.

Also, this patch broke some USB hosts. Can you please back out this
patch and apply the one below instead:

http://thread.gmane.org/gmane.linux.kernel.next/14158

Thank you very much,
Malahal.
