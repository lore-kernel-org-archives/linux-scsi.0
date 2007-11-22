From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 0/4] fix iommu segment boundary problems
Date: Thu, 22 Nov 2007 11:43:14 +0900
Message-ID: <522edb7703e4a70374b0c689cd7bae659fb0908b.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:51062 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbXKVCoc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 21:44:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, greg@kroah.com, jeff@garzik.org, tony.luck@intel.com, airlied@linux.ie, tglx@linutronix.de, mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp

This is the latter half of my iommu work to make the IOMMUs respect
LLDs restrictions.

IOMMUs allocate memory areas without considering a low level driver's
segment boundary limits. So we have some workarounds: splitting sg
segments again in LLDs; reserving all I/O space spanning 4GB boundary
in IOMMUs (with assumption that all the LLDs have 4GB boundary
restrictions). The goal is killing all the workarounds.

This patchset adds new accessors for segment_boundary_mask in
device_dma_parameters structure in the same way as the first half of
my work did for max_segment_size.

Currently, I fixed only swiotlb. Next, I'll generalize swiotlb's free
area management and convert all the IOMMUs to use it. Or I'll
generalize a free area management to use bitmap that most of the
IOMMUs use and convert them to use it.

This is against 2.6.24-rc3-mm1.

The first half of my iommu work is:

http://thread.gmane.org/gmane.linux.scsi/35602
