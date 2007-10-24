From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 01/11] add device_dma_parameters structure
Date: Wed, 24 Oct 2007 19:48:01 +0900
Message-ID: <20071024174021G.tomof@acm.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:38545 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbXJXK6A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 06:58:00 -0400
In-Reply-To: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, greg@kroah.com, jeff@garzik.org, fujita.tomonori@lab.ntt.co.jp

iommu code merges scatter/gather segments without considering a low
level driver's restrictions. The problem is that iommu code can't
access to the limitations because they are in request_queue.

This patch adds a new structure, device_dma_parameters, including dma
information. A pointer to device_dma_parameters is added to struct
device.

- there are only max_segment_size and segment_boundary_mask there but
we'll move more dma stuff in struct device (like dma_mask) to struct
device_dma_parameters later. segment_boundary_mask is not supported
yet.

- new accessors for the dma parameters are added. So we can easily
change where to place struct device_dma_parameters in the future.

- dma_get_max_seg_size returns 64K if dma_parms in struct device isn't
set up properly. 64K is the default max_segment_size in the block
layer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/device.h      |   11 +++++++++++
 include/linux/dma-mapping.h |   15 +++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 2e15822..9eb883f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -397,6 +397,15 @@ extern int devres_release_group(struct device *dev, void *id);
 extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
 extern void devm_kfree(struct device *dev, void *p);
 
+struct device_dma_parameters {
+	/*
+	 * a low level driver may set these to teach IOMMU code about
+	 * sg limitations.
+	 */
+	unsigned int max_segment_size;
+	unsigned long segment_boundary_mask;
+};
+
 struct device {
 	struct klist		klist_children;
 	struct klist_node	knode_parent;		/* node in sibling list */
@@ -432,6 +441,8 @@ struct device {
 					     64 bit addresses for consistent
 					     allocations such descriptors. */
 
+	struct device_dma_parameters *dma_parms;
+
 	struct list_head	dma_pools;	/* dma pools (if dma'ble) */
 
 	struct dma_coherent_mem	*dma_mem; /* internal for coherent mem
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 101a2d4..71972ca 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -60,6 +60,21 @@ static inline int is_device_dma_capable(struct device *dev)
 
 extern u64 dma_get_required_mask(struct device *dev);
 
+static inline unsigned int dma_get_max_seg_size(struct device *dev)
+{
+	return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;
+}
+
+static inline unsigned int dma_set_max_seg_size(struct device *dev,
+						unsigned int size)
+{
+	if (dev->dma_parms) {
+		dev->dma_parms->max_segment_size = size;
+		return 0;
+	} else
+		return -EIO;
+}
+
 /* flags for the coherent memory api */
 #define	DMA_MEMORY_MAP			0x01
 #define DMA_MEMORY_IO			0x02
-- 
1.5.2.4

