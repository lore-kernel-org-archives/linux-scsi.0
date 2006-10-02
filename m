From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bugme-new] [Bug 7246] New: 3w-xxxx, IOMMU and >1go RAM
Date: Mon, 02 Oct 2006 13:58:07 -0500
Message-ID: <1159815487.3460.36.camel@mulgrave.il.steeleye.com>
References: <200610021508.k92F8bmq011159@fire-2.osdl.org>
	 <200610022017.59697.ak@suse.de>
	 <1159813447.3460.28.camel@mulgrave.il.steeleye.com>
	 <200610022035.55482.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:23952 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964875AbWJBS6W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 14:58:22 -0400
In-Reply-To: <200610022035.55482.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: adam radford <aradford@gmail.com>, Andrew Morton <akpm@osdl.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2006-10-02 at 20:35 +0200, Andi Kleen wrote:
> Yes, but it can't when the bounce code is not compiled in.
> In this case it just printks and you saw those printks.

That's this bit of subversion in ll_rw_blk.c:blk_queue_bounce_limit()

#if BITS_PER_LONG == 64
	/* Assume anything <= 4GB can be handled by IOMMU.
	   Actually some IOMMUs can handle everything, but I don't
	   know of a way to test this here. */
	if (bounce_pfn < (min_t(u64,0xffffffff,BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
		dma = 1;
	q->bounce_pfn = max_low_pfn;
#else

?

That really looks wrong ... it will fail, as we've seen for 64 bit
platforms with no iommu.  We should init the isa pool in that case.

James


