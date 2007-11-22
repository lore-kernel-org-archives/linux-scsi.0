From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 1/4] add accessors for segment_boundary_mask in
 device_dma_parameters
Date: Thu, 22 Nov 2007 11:43:22 +0900
Message-ID: <20071122113834B.tomof@acm.org>
References: <522edb7703e4a70374b0c689cd7bae659fb0908b.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50989 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756667AbXKVCoD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 21:44:03 -0500
In-Reply-To: <522edb7703e4a70374b0c689cd7bae659fb0908b.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, greg@kroah.com, jeff@garzik.org, fujita.tomonori@lab.ntt.co.jp

This adds new accessors for segment_boundary_mask in
device_dma_parameters structure in the same way I did for
max_segment_size. So we can easily change where to place struct
device_dma_parameters in the future.

dma_get_segment boundary returns 0xffffffff if dma_parms in struct
device isn't set up properly. 0xffffffff is the default value used in
the block layer and the scsi mid layer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/dma-mapping.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 71972ca..7d157ed 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -75,6 +75,21 @@ static inline unsigned int dma_set_max_seg_size(struct device *dev,
 		return -EIO;
 }
 
+static inline unsigned long dma_get_seg_boundary(struct device *dev)
+{
+	return dev->dma_parms ?
+		dev->dma_parms->segment_boundary_mask : 0xffffffff;
+}
+
+static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
+{
+	if (dev->dma_parms) {
+		dev->dma_parms->segment_boundary_mask = mask;
+		return 0;
+	} else
+		return -EIO;
+}
+
 /* flags for the coherent memory api */
 #define	DMA_MEMORY_MAP			0x01
 #define DMA_MEMORY_IO			0x02
-- 
1.5.3.4

