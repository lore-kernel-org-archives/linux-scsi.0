From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6 of 7] scsi: Support devices with protection information (DIF)
Date: Sat, 07 Jun 2008 00:55:39 -0400
Message-ID: <ad65bfde4e05e43072b6.1212814539@sermon.lab.mkp.net>
References: <patchbomb.1212814533@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:38421 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbYFGE5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 7 Jun 2008 00:57:44 -0400
In-Reply-To: <patchbomb.1212814533@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

5 files changed, 90 insertions(+)
drivers/scsi/Kconfig       |   15 +++++++++++++++
drivers/scsi/scsi_lib.c    |   42 ++++++++++++++++++++++++++++++++++++++++++
drivers/scsi/scsi_scan.c   |    3 +++
include/scsi/scsi_cmnd.h   |   29 +++++++++++++++++++++++++++++
include/scsi/scsi_device.h |    1 +


 - Add support for an extra scatter-gather list containing protection
   information.

 - Remember devices with protection information turned on in INQUIRY.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r 5be7c534c954 -r ad65bfde4e05 drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Sat Jun 07 00:45:15 2008 -0400
+++ b/drivers/scsi/Kconfig	Sat Jun 07 00:45:15 2008 -0400
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
diff -r 5be7c534c954 -r ad65bfde4e05 drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Sat Jun 07 00:45:15 2008 -0400
+++ b/drivers/scsi/scsi_lib.c	Sat Jun 07 00:45:15 2008 -0400
@@ -778,6 +778,13 @@
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
 
@@ -1031,6 +1038,32 @@
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
@@ -1062,6 +1095,15 @@
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
 
diff -r 5be7c534c954 -r ad65bfde4e05 drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Sat Jun 07 00:45:15 2008 -0400
+++ b/drivers/scsi/scsi_scan.c	Sat Jun 07 00:45:15 2008 -0400
@@ -882,6 +882,9 @@
 
 	if (*bflags & BLIST_USE_10_BYTE_MS)
 		sdev->use_10_for_ms = 1;
+
+	if (inq_result[5] & 0x1)
+		sdev->protection = 1;
 
 	/* set the device running here so that slave configure
 	 * may do I/O */
diff -r 5be7c534c954 -r ad65bfde4e05 include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h	Sat Jun 07 00:45:15 2008 -0400
+++ b/include/scsi/scsi_cmnd.h	Sat Jun 07 00:45:15 2008 -0400
@@ -88,6 +88,9 @@
 
 	/* These elements define the operation we ultimately want to perform */
 	struct scsi_data_buffer sdb;
+#if defined(CONFIG_SCSI_PROTECTION)
+	struct scsi_data_buffer *prot_sdb;
+#endif
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
 
@@ -209,4 +212,30 @@
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
diff -r 5be7c534c954 -r ad65bfde4e05 include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	Sat Jun 07 00:45:15 2008 -0400
+++ b/include/scsi/scsi_device.h	Sat Jun 07 00:45:15 2008 -0400
@@ -140,6 +140,7 @@
 	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
 	unsigned last_sector_bug:1;	/* Always read last sector in a 1 sector read */
+	unsigned protection:1;		/* Data Integrity Field */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */


