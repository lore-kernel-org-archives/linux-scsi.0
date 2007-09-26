From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 3/5] add sg segment limitation info to device structure
Date: Wed, 26 Sep 2007 17:58:01 +0900
Message-ID: <20070925142157B.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:39667 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbXIZI6g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 04:58:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp

iommu code merges sg segments without considering lld's sg segment
restrictions. iommu code can't access to the limitations because they
are in request_queue. This patch adds max_segment_size to device
structure. seg_boundary_mask will be added too later.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/device.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 3a38d1f..8046b60 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -443,6 +443,13 @@ struct device {
 
 	struct dma_coherent_mem	*dma_mem; /* internal for coherent mem
 					     override */
+
+	/*
+	 * a low level driver may set these to teach IOMMU code about
+	 * sg limitations.
+	 */
+	unsigned int max_segment_size;
+
 	/* arch specific additions */
 	struct dev_archdata	archdata;
 
-- 
1.5.2.4

