From: "David S. Miller" <davem@redhat.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Wed, 30 Oct 2002 12:35:19 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021030.123519.25407274.davem@redhat.com>
References: <20021027215433.GA30429@suse.de>
	<200210301739.g9UHdDU12308@eng2.beaverton.ibm.com>
	<20021030181627.GV3416@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021030181627.GV3416@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: badari@us.ibm.com, James.Bottomley@steeleye.com, pbadari@us.ibm.com, akpm@digeo.com, linux-scsi@vger.kernel.org, Martin.Bligh@us.ibm.com, dledford@redhat.com

   From: Jens Axboe <axboe@suse.de>
   Date: Wed, 30 Oct 2002 19:16:27 +0100

   On Wed, Oct 30 2002, Badari Pulavarty wrote:
   > What does BIOVEC_VIRT_MERGEABLE() supposed to do ? I am guessing
   > it is supposed to restrict IO crossing 4GB boundary. Is it correct ?
   
   It's only for platforms with iommu that can do funky remapping tricks
   for pages ending on certain boundaries. I'm sure davem or anton can tell
   you more about this for sparc64 or ppc64. For x86, it will always be
   true. Hmm, looking at it, I can't convince myself that it is right.
   Davem, could you please check up on this? I'll be back later tonight to
   review it as well. Things are not consistent, I agree on that.

This whole report sounds like ppc64 is setting BIO_VMERGE_BOUNDARY
incorrectly.

If the IOMMU code on ppc64 is not going to merge physical scatterlist
segments which begin/end on a page boundry into a single DMA addr/len
pair, then this port should not be setting BIO_VMERGE_BOUNDARY
non-zero.

Else, if ppc64's IOMMU code will merge such pages, BIO_VMERGE_BOUNDARY
must be defined to the page size used by the IOMMU.

I notice now that the BIO_VMERGE_BOUNDARY define is "#if 0" protected
on ppc64.  It absolutely must be in sync with how the IOMMU code on
the platform behaves.  So some ppc64 expert needs to comment :)
