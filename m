From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 4.14+ merge window
Date: Wed, 22 Nov 2017 22:31:43 -0800
Message-ID: <1511418703.3169.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two basic fixes: one for the sparse problem with the blacklist flags
and another for a hang forever in bnx2i.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Chad Dupuis (1):
      scsi: bnx2fc: Fix hung task messages when a cleanup response is not received during abort

Hannes Reinecke (1):
      scsi: Use 'blist_flags_t' for scsi_devinfo flags

And the diffstat:

 drivers/scsi/bnx2fc/bnx2fc_io.c | 40 ++++++++++++++++++++++++++-------
 drivers/scsi/scsi_devinfo.c     | 18 +++++++--------
 drivers/scsi/scsi_priv.h        | 15 +++++++------
 drivers/scsi/scsi_scan.c        |  2 +-
 include/scsi/scsi_device.h      |  4 +++-
 include/scsi/scsi_devinfo.h     | 50 ++++++++++++++++++++---------------------
 6 files changed, 78 insertions(+), 51 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 5b6153f23f01..8e2f767147cb 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1084,24 +1084,35 @@ static int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
 {
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	int rc = SUCCESS;
+	unsigned int time_left;
 
 	io_req->wait_for_comp = 1;
 	bnx2fc_initiate_cleanup(io_req);
 
 	spin_unlock_bh(&tgt->tgt_lock);
 
-	wait_for_completion(&io_req->tm_done);
-
+	/*
+	 * Can't wait forever on cleanup response lest we let the SCSI error
+	 * handler wait forever
+	 */
+	time_left = wait_for_completion_timeout(&io_req->tm_done,
+						BNX2FC_FW_TIMEOUT);
 	io_req->wait_for_comp = 0;
+	if (!time_left)
+		BNX2FC_IO_DBG(io_req, "%s(): Wait for cleanup timed out.\n",
+			      __func__);
+
 	/*
-	 * release the reference taken in eh_abort to allow the
-	 * target to re-login after flushing IOs
+	 * Release reference held by SCSI command the cleanup completion
+	 * hits the BNX2FC_CLEANUP case in bnx2fc_process_cq_compl() and
+	 * thus the SCSI command is not returnedi by bnx2fc_scsi_done().
 	 */
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
 
 	spin_lock_bh(&tgt->tgt_lock);
 	return rc;
 }
+
 /**
  * bnx2fc_eh_abort - eh_abort_handler api to abort an outstanding
  *			SCSI command
@@ -1118,6 +1129,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	struct fc_lport *lport;
 	struct bnx2fc_rport *tgt;
 	int rc;
+	unsigned int time_left;
 
 	rc = fc_block_scsi_eh(sc_cmd);
 	if (rc)
@@ -1194,6 +1206,11 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		if (cancel_delayed_work(&io_req->timeout_work))
 			kref_put(&io_req->refcount,
 				 bnx2fc_cmd_release); /* drop timer hold */
+		/*
+		 * We don't want to hold off the upper layer timer so simply
+		 * cleanup the command and return that I/O was successfully
+		 * aborted.
+		 */
 		rc = bnx2fc_abts_cleanup(io_req);
 		/* This only occurs when an task abort was requested while ABTS
 		   is in progress.  Setting the IO_CLEANUP flag will skip the
@@ -1201,7 +1218,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		   was a result from the ABTS request rather than the CLEANUP
 		   request */
 		set_bit(BNX2FC_FLAG_IO_CLEANUP,	&io_req->req_flags);
-		goto out;
+		goto done;
 	}
 
 	/* Cancel the current timer running on this io_req */
@@ -1221,7 +1238,11 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	}
 	spin_unlock_bh(&tgt->tgt_lock);
 
-	wait_for_completion(&io_req->tm_done);
+	/* Wait 2 * RA_TOV + 1 to be sure timeout function hasn't fired */
+	time_left = wait_for_completion_timeout(&io_req->tm_done,
+	    (2 * rp->r_a_tov + 1) * HZ);
+	if (time_left)
+		BNX2FC_IO_DBG(io_req, "Timed out in eh_abort waiting for tm_done");
 
 	spin_lock_bh(&tgt->tgt_lock);
 	io_req->wait_for_comp = 0;
@@ -1233,8 +1254,12 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		/* Let the scsi-ml try to recover this command */
 		printk(KERN_ERR PFX "abort failed, xid = 0x%x\n",
 		       io_req->xid);
+		/*
+		 * Cleanup firmware residuals before returning control back
+		 * to SCSI ML.
+		 */
 		rc = bnx2fc_abts_cleanup(io_req);
-		goto out;
+		goto done;
 	} else {
 		/*
 		 * We come here even when there was a race condition
@@ -1249,7 +1274,6 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 done:
 	/* release the reference taken in eh_abort */
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
-out:
 	spin_unlock_bh(&tgt->tgt_lock);
 	return rc;
 }
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index fe5a9ea27b5e..78d4aa8df675 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -22,7 +22,7 @@ struct scsi_dev_info_list {
 	struct list_head dev_info_list;
 	char vendor[8];
 	char model[16];
-	unsigned flags;
+	blist_flags_t flags;
 	unsigned compatible; /* for use with scsi_static_device_list entries */
 };
 
@@ -35,7 +35,7 @@ struct scsi_dev_info_list_table {
 
 
 static const char spaces[] = "                "; /* 16 of them */
-static unsigned scsi_default_dev_flags;
+static blist_flags_t scsi_default_dev_flags;
 static LIST_HEAD(scsi_dev_info_list);
 static char scsi_dev_flags[256];
 
@@ -52,7 +52,7 @@ static struct {
 	char *vendor;
 	char *model;
 	char *revision;	/* revision known to be bad, unused */
-	unsigned flags;
+	blist_flags_t flags;
 } scsi_static_device_list[] __initdata = {
 	/*
 	 * The following devices are known not to tolerate a lun != 0 scan
@@ -335,7 +335,7 @@ static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
  * Returns: 0 OK, -error on failure.
  **/
 static int scsi_dev_info_list_add(int compatible, char *vendor, char *model,
-			    char *strflags, int flags)
+			    char *strflags, blist_flags_t flags)
 {
 	return scsi_dev_info_list_add_keyed(compatible, vendor, model,
 					    strflags, flags,
@@ -361,7 +361,7 @@ static int scsi_dev_info_list_add(int compatible, char *vendor, char *model,
  * Returns: 0 OK, -error on failure.
  **/
 int scsi_dev_info_list_add_keyed(int compatible, char *vendor, char *model,
-				 char *strflags, int flags, int key)
+				 char *strflags, blist_flags_t flags, int key)
 {
 	struct scsi_dev_info_list *devinfo;
 	struct scsi_dev_info_list_table *devinfo_table =
@@ -571,9 +571,9 @@ static int scsi_dev_info_list_add_str(char *dev_list)
  *     matching flags value, else return the host or global default
  *     settings.  Called during scan time.
  **/
-int scsi_get_device_flags(struct scsi_device *sdev,
-			  const unsigned char *vendor,
-			  const unsigned char *model)
+blist_flags_t scsi_get_device_flags(struct scsi_device *sdev,
+				    const unsigned char *vendor,
+				    const unsigned char *model)
 {
 	return scsi_get_device_flags_keyed(sdev, vendor, model,
 					   SCSI_DEVINFO_GLOBAL);
@@ -593,7 +593,7 @@ int scsi_get_device_flags(struct scsi_device *sdev,
  *     flags value, else return the host or global default settings.
  *     Called during scan time.
  **/
-int scsi_get_device_flags_keyed(struct scsi_device *sdev,
+blist_flags_t scsi_get_device_flags_keyed(struct scsi_device *sdev,
 				const unsigned char *vendor,
 				const unsigned char *model,
 				int key)
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index df1368aea9a3..a5946cd64caa 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -50,15 +50,16 @@ enum {
 	SCSI_DEVINFO_SPI,
 };
 
-extern int scsi_get_device_flags(struct scsi_device *sdev,
-				 const unsigned char *vendor,
-				 const unsigned char *model);
-extern int scsi_get_device_flags_keyed(struct scsi_device *sdev,
-				       const unsigned char *vendor,
-				       const unsigned char *model, int key);
+extern blist_flags_t scsi_get_device_flags(struct scsi_device *sdev,
+					   const unsigned char *vendor,
+					   const unsigned char *model);
+extern blist_flags_t scsi_get_device_flags_keyed(struct scsi_device *sdev,
+						 const unsigned char *vendor,
+						 const unsigned char *model,
+						 int key);
 extern int scsi_dev_info_list_add_keyed(int compatible, char *vendor,
 					char *model, char *strflags,
-					int flags, int key);
+					blist_flags_t flags, int key);
 extern int scsi_dev_info_list_del_keyed(char *vendor, char *model, int key);
 extern int scsi_dev_info_add_list(int key, const char *name);
 extern int scsi_dev_info_remove_list(int key);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a0f2a20ea9e9..be5e919db0e8 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -566,7 +566,7 @@ EXPORT_SYMBOL(scsi_sanitize_inquiry_string);
  *     are copied to the scsi_device any flags value is stored in *@bflags.
  **/
 static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
-			  int result_len, int *bflags)
+			  int result_len, blist_flags_t *bflags)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 1fb6ad3c5006..7ae177c8e399 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -15,6 +15,8 @@ struct scsi_cmnd;
 struct scsi_lun;
 struct scsi_sense_hdr;
 
+typedef unsigned int __bitwise blist_flags_t;
+
 struct scsi_mode_data {
 	__u32	length;
 	__u16	block_descriptor_length;
@@ -141,7 +143,7 @@ struct scsi_device {
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
-	unsigned int	sdev_bflags; /* black/white flags as also found in
+	blist_flags_t		sdev_bflags; /* black/white flags as also found in
 				 * scsi_devinfo.[hc]. For now used only to
 				 * pass settings from slave_alloc to scsi
 				 * core. */
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 3cf125b56c3a..ea67c32e870e 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -6,55 +6,55 @@
  */
 
 /* Only scan LUN 0 */
-#define BLIST_NOLUN		((__force __u32 __bitwise)(1 << 0))
+#define BLIST_NOLUN		((__force blist_flags_t)(1 << 0))
 /* Known to have LUNs, force scanning.
  * DEPRECATED: Use max_luns=N */
-#define BLIST_FORCELUN		((__force __u32 __bitwise)(1 << 1))
+#define BLIST_FORCELUN		((__force blist_flags_t)(1 << 1))
 /* Flag for broken handshaking */
-#define BLIST_BORKEN		((__force __u32 __bitwise)(1 << 2))
+#define BLIST_BORKEN		((__force blist_flags_t)(1 << 2))
 /* unlock by special command */
-#define BLIST_KEY		((__force __u32 __bitwise)(1 << 3))
+#define BLIST_KEY		((__force blist_flags_t)(1 << 3))
 /* Do not use LUNs in parallel */
-#define BLIST_SINGLELUN		((__force __u32 __bitwise)(1 << 4))
+#define BLIST_SINGLELUN		((__force blist_flags_t)(1 << 4))
 /* Buggy Tagged Command Queuing */
-#define BLIST_NOTQ		((__force __u32 __bitwise)(1 << 5))
+#define BLIST_NOTQ		((__force blist_flags_t)(1 << 5))
 /* Non consecutive LUN numbering */
-#define BLIST_SPARSELUN		((__force __u32 __bitwise)(1 << 6))
+#define BLIST_SPARSELUN		((__force blist_flags_t)(1 << 6))
 /* Avoid LUNS >= 5 */
-#define BLIST_MAX5LUN		((__force __u32 __bitwise)(1 << 7))
+#define BLIST_MAX5LUN		((__force blist_flags_t)(1 << 7))
 /* Treat as (removable) CD-ROM */
-#define BLIST_ISROM		((__force __u32 __bitwise)(1 << 8))
+#define BLIST_ISROM		((__force blist_flags_t)(1 << 8))
 /* LUNs past 7 on a SCSI-2 device */
-#define BLIST_LARGELUN		((__force __u32 __bitwise)(1 << 9))
+#define BLIST_LARGELUN		((__force blist_flags_t)(1 << 9))
 /* override additional length field */
-#define BLIST_INQUIRY_36	((__force __u32 __bitwise)(1 << 10))
+#define BLIST_INQUIRY_36	((__force blist_flags_t)(1 << 10))
 /* do not do automatic start on add */
-#define BLIST_NOSTARTONADD	((__force __u32 __bitwise)(1 << 12))
+#define BLIST_NOSTARTONADD	((__force blist_flags_t)(1 << 12))
 /* try REPORT_LUNS even for SCSI-2 devs (if HBA supports more than 8 LUNs) */
-#define BLIST_REPORTLUN2	((__force __u32 __bitwise)(1 << 17))
+#define BLIST_REPORTLUN2	((__force blist_flags_t)(1 << 17))
 /* don't try REPORT_LUNS scan (SCSI-3 devs) */
-#define BLIST_NOREPORTLUN	((__force __u32 __bitwise)(1 << 18))
+#define BLIST_NOREPORTLUN	((__force blist_flags_t)(1 << 18))
 /* don't use PREVENT-ALLOW commands */
-#define BLIST_NOT_LOCKABLE	((__force __u32 __bitwise)(1 << 19))
+#define BLIST_NOT_LOCKABLE	((__force blist_flags_t)(1 << 19))
 /* device is actually for RAID config */
-#define BLIST_NO_ULD_ATTACH	((__force __u32 __bitwise)(1 << 20))
+#define BLIST_NO_ULD_ATTACH	((__force blist_flags_t)(1 << 20))
 /* select without ATN */
-#define BLIST_SELECT_NO_ATN	((__force __u32 __bitwise)(1 << 21))
+#define BLIST_SELECT_NO_ATN	((__force blist_flags_t)(1 << 21))
 /* retry HARDWARE_ERROR */
-#define BLIST_RETRY_HWERROR	((__force __u32 __bitwise)(1 << 22))
+#define BLIST_RETRY_HWERROR	((__force blist_flags_t)(1 << 22))
 /* maximum 512 sector cdb length */
-#define BLIST_MAX_512		((__force __u32 __bitwise)(1 << 23))
+#define BLIST_MAX_512		((__force blist_flags_t)(1 << 23))
 /* Disable T10 PI (DIF) */
-#define BLIST_NO_DIF		((__force __u32 __bitwise)(1 << 25))
+#define BLIST_NO_DIF		((__force blist_flags_t)(1 << 25))
 /* Ignore SBC-3 VPD pages */
-#define BLIST_SKIP_VPD_PAGES	((__force __u32 __bitwise)(1 << 26))
+#define BLIST_SKIP_VPD_PAGES	((__force blist_flags_t)(1 << 26))
 /* Attempt to read VPD pages */
-#define BLIST_TRY_VPD_PAGES	((__force __u32 __bitwise)(1 << 28))
+#define BLIST_TRY_VPD_PAGES	((__force blist_flags_t)(1 << 28))
 /* don't try to issue RSOC */
-#define BLIST_NO_RSOC		((__force __u32 __bitwise)(1 << 29))
+#define BLIST_NO_RSOC		((__force blist_flags_t)(1 << 29))
 /* maximum 1024 sector cdb length */
-#define BLIST_MAX_1024		((__force __u32 __bitwise)(1 << 30))
+#define BLIST_MAX_1024		((__force blist_flags_t)(1 << 30))
 /* Use UNMAP limit for WRITE SAME */
-#define BLIST_UNMAP_LIMIT_WS	((__force __u32 __bitwise)(1 << 31))
+#define BLIST_UNMAP_LIMIT_WS	((__force blist_flags_t)(1 << 31))
 
 #endif
