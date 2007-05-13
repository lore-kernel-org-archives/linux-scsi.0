From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/19] add data buffer accessors
Date: Sun, 13 May 2007 12:30:44 +0900
Message-ID: <200705130330.l4D3Ut3Y027684@mbox.iij4u.or.jp>
References: <20070512182805L.fujita.tomonori@lab.ntt.co.jp>
	<20070512153151.GB8088@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:33599 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbXEMDbN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 May 2007 23:31:13 -0400
In-Reply-To: <20070512153151.GB8088@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/19] add data buffer accessors
Date: Sat, 12 May 2007 16:31:51 +0100

> > +int scsi_dma_map(struct device *dev, struct scsi_cmnd *cmd)
> > +{
> > +	int nseg = 0;
> > +
> > +	if (cmd->use_sg) {
> > +		struct scatterlist *sg =
> > +			(struct scatterlist *) cmd->request_buffer;
> > +
> > +		nseg = dma_map_sg(dev, sg, cmd->use_sg, cmd->sc_data_direction);
> > +		if (unlikely(!nseg))
> > +			return -ENOMEM;
> > +	}
> > +	return nseg;
> > +}
> > +EXPORT_SYMBOL(scsi_dma_map);
> 
> As James already said the device argument should not be needed at all.
> Also please add kerneldoc comment describing exported functions.

Thanks. How about the this one?

I've also updated the drivers though I don't send them since the
changes are just about scsi_dma_map/unmap():

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git cleanups


James, do you want me to send them to the mailing list, send them
after unifying two patches for each driver, or wait for other guys'
comments for for some time?


>From 8fc2ab69fc110117b8a6a0af8fb6ba2a784b918e Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Sun, 13 May 2007 03:34:57 +0900
Subject: [PATCH] add data buffer accessors

This adds a set of accessors for the scsi data buffer. This is in
preparation for chaining sg lists and bidirectional requests (and
possibly, the mid-layer dma mapping).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c  |   38 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h |   11 +++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1f5a07b..70454b4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2290,3 +2290,41 @@ void scsi_kunmap_atomic_sg(void *virt)
 	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
 }
 EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
+
+/**
+ * scsi_dma_map - perform DMA mapping against command's sg lists
+ * @cmd:	scsi command
+ *
+ * Returns the number of sg lists actually used, zero if the sg lists
+ * is NULL, or -ENOMEM if the mapping failed.
+ */
+int scsi_dma_map(struct scsi_cmnd *cmd)
+{
+	int nseg = 0;
+
+	if (scsi_sg_count(cmd)) {
+		struct device *dev = cmd->device->host->shost_gendev.parent;
+
+		nseg = dma_map_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
+				  cmd->sc_data_direction);
+		if (unlikely(!nseg))
+			return -ENOMEM;
+	}
+	return nseg;
+}
+EXPORT_SYMBOL(scsi_dma_map);
+
+/**
+ * scsi_dma_unmap - unmap command's sg lists mapped by scsi_dma_map
+ * @cmd:	scsi command
+ */
+void scsi_dma_unmap(struct scsi_cmnd *cmd)
+{
+	if (scsi_sg_count(cmd)) {
+		struct device *dev = cmd->device->host->shost_gendev.parent;
+
+		dma_unmap_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
+			     cmd->sc_data_direction);
+	}
+}
+EXPORT_SYMBOL(scsi_dma_unmap);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a2e0c10..996ff36 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -135,4 +135,15 @@ extern void scsi_kunmap_atomic_sg(void *
 extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
 extern void scsi_free_sgtable(struct scatterlist *, int);
 
+extern int scsi_dma_map(struct scsi_cmnd *cmd);
+extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
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


