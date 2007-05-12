From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/19] add data buffer accessors
Date: Sat, 12 May 2007 19:05:42 +0900 (JST)
Message-ID: <20070512182805L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55500 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbXELKF7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, hch@infradead.org

Add a set of accessors for the scsi data buffer. This is in
preparation for chaining sg lists and bidirectional requests (and
possibly, the mid-layer dma mapping).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c  |   26 ++++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h |   11 +++++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1f5a07b..a2ebe61 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2290,3 +2290,29 @@ void scsi_kunmap_atomic_sg(void *virt)
 	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
 }
 EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
+
+int scsi_dma_map(struct device *dev, struct scsi_cmnd *cmd)
+{
+	int nseg = 0;
+
+	if (cmd->use_sg) {
+		struct scatterlist *sg =
+			(struct scatterlist *) cmd->request_buffer;
+
+		nseg = dma_map_sg(dev, sg, cmd->use_sg, cmd->sc_data_direction);
+		if (unlikely(!nseg))
+			return -ENOMEM;
+	}
+	return nseg;
+}
+EXPORT_SYMBOL(scsi_dma_map);
+
+void scsi_dma_unmap(struct device *dev, struct scsi_cmnd *cmd)
+{
+	if (cmd->use_sg) {
+		struct scatterlist *sg =
+			(struct scatterlist *) cmd->request_buffer;
+		dma_unmap_sg(dev, sg, cmd->use_sg, cmd->sc_data_direction);
+	}
+}
+EXPORT_SYMBOL(scsi_dma_unmap);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a2e0c10..5f5a179 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -135,4 +135,15 @@ extern void scsi_kunmap_atomic_sg(void *
 extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
 extern void scsi_free_sgtable(struct scatterlist *, int);
 
+extern int scsi_dma_map(struct device *dev, struct scsi_cmnd *cmd);
+extern void scsi_dma_unmap(struct device *dev, struct scsi_cmnd *cmd);
+
+#define scsi_sg_count(cmd) ((cmd)->use_sg)
+#define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
+#define scsi_bufflen(cmd) ((cmd)->request_bufflen)
+#define scsi_resid(cmd) ((cmd)->resid)
+
+#define scsi_for_each_sg(cmd, sg, nseg, __i)			\
+	for (__i = 0, sg = scsi_sglist(cmd); __i < (nseg); __i++, (sg)++)
+
 #endif /* _SCSI_SCSI_CMND_H */
-- 
1.4.3.2

