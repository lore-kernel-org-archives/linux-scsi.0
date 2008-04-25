From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 08 of 16] SCSI protection information scatterlist handling
Date: Fri, 25 Apr 2008 19:12:10 -0400
Message-ID: <ea489bb64376f4420b4d.1209165130@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:44315 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759197AbYDYXR3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 19:17:29 -0400
In-Reply-To: <patchbomb.1209165122@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

3 files changed, 86 insertions(+)
drivers/scsi/Kconfig     |   15 +++++++++++++++
drivers/scsi/scsi_lib.c  |   42 ++++++++++++++++++++++++++++++++++++++++++
include/scsi/scsi_cmnd.h |   29 +++++++++++++++++++++++++++++


Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r f37e1616176b -r ea489bb64376 drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Fri Apr 25 17:39:29 2008 -0400
+++ b/drivers/scsi/Kconfig	Fri Apr 25 17:39:29 2008 -0400
@@ -260,6 +260,21 @@
 	default m
 	depends on SCSI
 	depends on MODULES
+
+config SCSI_PROTECTION
+       bool "SCSI Data Integrity Protection"
+       depends on SCSI
+       depends on BLK_DEV_INTEGRITY
+       help 
+	 Some SCSI devices support data protection features above and
+	 beyond those implemented in the transport.  Select this
+	 option to enable protection information to be transferred to
+	 and from a device.  Specifically, this option will enable DIF
+	 (Data Integrity Field) for SCSI disks.
+
+	 The SCSI protection features depend on the block layer data
+	 integrity infrastructure so the latter must be enabled for
+	 this option to work.
 
 menu "SCSI Transports"
 	depends on SCSI
diff -r f37e1616176b -r ea489bb64376 drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Fri Apr 25 17:39:29 2008 -0400
+++ b/drivers/scsi/scsi_lib.c	Fri Apr 25 17:39:29 2008 -0400
@@ -774,6 +774,13 @@
 		kmem_cache_free(scsi_sdb_cache, bidi_sdb);
 		cmd->request->next_rq->special = NULL;
 	}
+
+#if defined(CONFIG_SCSI_PROTECTION)
+	if (scsi_prot_sg_count(cmd)) {
+		scsi_free_sgtable(cmd->prot_sdb);
+		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
+	}
+#endif
 }
 EXPORT_SYMBOL(scsi_release_buffers);
 
@@ -1027,6 +1034,32 @@
 	return BLKPREP_OK;
 }
 
+#if defined(CONFIG_SCSI_PROTECTION)
+static int scsi_protect_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+{
+	struct request *req = cmd->request;
+	struct scsi_data_buffer *pdb;
+	int ivecs, count;
+
+	pdb = kmem_cache_zalloc(scsi_sdb_cache, gfp_mask);
+	if (unlikely(pdb == NULL))
+		return BLKPREP_DEFER;
+
+	ivecs = blk_rq_count_integrity_sg(req);
+
+	if (unlikely(scsi_alloc_sgtable(pdb, ivecs, gfp_mask)))
+		return BLKPREP_DEFER;
+
+	count = blk_rq_map_integrity_sg(req, pdb->table.sgl);
+	BUG_ON(unlikely(count > ivecs));
+
+	cmd->prot_sdb = pdb;
+	cmd->prot_sdb->table.nents = count;
+
+	return BLKPREP_OK;
+}
+#endif
+
 /*
  * Function:    scsi_init_io()
  *
@@ -1058,6 +1091,15 @@
 		if (error)
 			goto err_exit;
 	}
+
+#if defined(CONFIG_SCSI_PROTECTION)
+	if (blk_integrity_rq(cmd->request)) {
+		error = scsi_protect_io(cmd, gfp_mask);
+
+		if (error != BLKPREP_OK)
+			goto err_exit;
+	}
+#endif
 
 	return BLKPREP_OK ;
 
diff -r f37e1616176b -r ea489bb64376 include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h	Fri Apr 25 17:39:29 2008 -0400
+++ b/include/scsi/scsi_cmnd.h	Fri Apr 25 17:39:29 2008 -0400
@@ -71,6 +71,9 @@
 
 	/* These elements define the operation we ultimately want to perform */
 	struct scsi_data_buffer sdb;
+#if defined(CONFIG_SCSI_PROTECTION)
+	struct scsi_data_buffer *prot_sdb;
+#endif
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
 
@@ -192,4 +195,30 @@
 				 buf, buflen);
 }
 
+#if defined(CONFIG_SCSI_PROTECTION)
+
+static inline unsigned scsi_prot_sg_count(struct scsi_cmnd *cmd)
+{
+	return cmd->prot_sdb ? cmd->prot_sdb->table.nents : 0;
+}
+
+static inline struct scatterlist *scsi_prot_sglist(struct scsi_cmnd *cmd)
+{
+	return cmd->prot_sdb ? cmd->prot_sdb->table.sgl : NULL;
+}
+
+static inline struct scsi_data_buffer *scsi_prot(struct scsi_cmnd *cmd)
+{
+	return cmd->prot_sdb;
+}
+
+#define scsi_for_each_prot_sg(cmd, sg, nseg, __i)		\
+	for_each_sg(scsi_prot_sglist(cmd), sg, nseg, __i)
+
+#else /* CONFIG_SCSI_PROTECTION */
+
+#define scsi_prot_sg_count(a)		(0)
+
+#endif /* CONFIG_SCSI_PROTECTION */
+
 #endif /* _SCSI_SCSI_CMND_H */


