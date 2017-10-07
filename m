From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.14-rc3
Date: Sat, 07 Oct 2017 09:21:02 -0700
Message-ID: <1507393262.3080.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35282 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751258AbdJGQVU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Oct 2017 12:21:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

A couple of serious fixes (use after free and blacklist for WRITE
SAME).  One error leg fix (write_pending failure) and one user
experience problem (do not override max_sectors_kb) and one minor
unused function removal (iscsi_destroy_session).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bryant G. Ly (1):
      scsi: ibmvscsis: Fix write_pending failure path

Khazhismel Kumykov (2):
      scsi: libiscsi: Remove iscsi_destroy_session
      scsi: libiscsi: Fix use-after-free race during iscsi_session_teardown

Martin K. Petersen (2):
      scsi: sd: Do not override max_sectors_kb sysfs setting
      scsi: sd: Implement blacklist option for WRITE SAME w/ UNMAP

And the diffstat:

 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c |  2 +-
 drivers/scsi/libiscsi.c                  |  8 ++++----
 drivers/scsi/scsi_scan.c                 |  3 +++
 drivers/scsi/scsi_transport_iscsi.c      | 16 ---------------
 drivers/scsi/sd.c                        | 35 ++++++++++++++++++++++++--------
 include/scsi/scsi_device.h               |  1 +
 include/scsi/scsi_devinfo.h              |  1 +
 include/scsi/scsi_transport_iscsi.h      |  1 -
 8 files changed, 36 insertions(+), 31 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 785fb42f6650..2799a6b08f73 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3767,7 +3767,7 @@ static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
 	 */
 	if ((vscsi->flags & (CLIENT_FAILED | RESPONSE_Q_DOWN))) {
 		pr_err("write_pending failed since: %d\n", vscsi->flags);
-		return 0;
+		return -EIO;
 	}
 
 	rc = srp_transfer_data(cmd, &vio_iu(iue)->srp.cmd, ibmvscsis_rdma,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index bd4605a34f54..c62e8d111fd9 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2851,9 +2851,6 @@ EXPORT_SYMBOL_GPL(iscsi_session_setup);
 /**
  * iscsi_session_teardown - destroy session, host, and cls_session
  * @cls_session: iscsi session
- *
- * The driver must have called iscsi_remove_session before
- * calling this.
  */
 void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 {
@@ -2863,6 +2860,8 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 
 	iscsi_pool_free(&session->cmdpool);
 
+	iscsi_remove_session(cls_session);
+
 	kfree(session->password);
 	kfree(session->password_in);
 	kfree(session->username);
@@ -2877,7 +2876,8 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->portal_type);
 	kfree(session->discovery_parent_type);
 
-	iscsi_destroy_session(cls_session);
+	iscsi_free_session(cls_session);
+
 	iscsi_host_dec_session_cnt(shost);
 	module_put(owner);
 }
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e7818afeda2b..15590a063ad9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -956,6 +956,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_NO_DIF)
 		sdev->no_dif = 1;
 
+	if (*bflags & BLIST_UNMAP_LIMIT_WS)
+		sdev->unmap_limit_for_ws = 1;
+
 	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
 
 	if (*bflags & BLIST_TRY_VPD_PAGES)
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0190aeff5f7f..7404d26895f5 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2211,22 +2211,6 @@ void iscsi_free_session(struct iscsi_cls_session *session)
 EXPORT_SYMBOL_GPL(iscsi_free_session);
 
 /**
- * iscsi_destroy_session - destroy iscsi session
- * @session: iscsi_session
- *
- * Can be called by a LLD or iscsi_transport. There must not be
- * any running connections.
- */
-int iscsi_destroy_session(struct iscsi_cls_session *session)
-{
-	iscsi_remove_session(session);
-	ISCSI_DBG_TRANS_SESSION(session, "Completing session destruction\n");
-	iscsi_free_session(session);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(iscsi_destroy_session);
-
-/**
  * iscsi_create_conn - create iscsi class connection
  * @session: iscsi cls session
  * @dd_size: private driver data size
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fb9f8b5f4673..d175c5c5ccf8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -715,13 +715,21 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		break;
 
 	case SD_LBP_WS16:
-		max_blocks = min_not_zero(sdkp->max_ws_blocks,
-					  (u32)SD_MAX_WS16_BLOCKS);
+		if (sdkp->device->unmap_limit_for_ws)
+			max_blocks = sdkp->max_unmap_blocks;
+		else
+			max_blocks = sdkp->max_ws_blocks;
+
+		max_blocks = min_not_zero(max_blocks, (u32)SD_MAX_WS16_BLOCKS);
 		break;
 
 	case SD_LBP_WS10:
-		max_blocks = min_not_zero(sdkp->max_ws_blocks,
-					  (u32)SD_MAX_WS10_BLOCKS);
+		if (sdkp->device->unmap_limit_for_ws)
+			max_blocks = sdkp->max_unmap_blocks;
+		else
+			max_blocks = sdkp->max_ws_blocks;
+
+		max_blocks = min_not_zero(max_blocks, (u32)SD_MAX_WS10_BLOCKS);
 		break;
 
 	case SD_LBP_ZERO:
@@ -3099,8 +3107,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_security(sdkp, buffer);
 	}
 
-	sdkp->first_scan = 0;
-
 	/*
 	 * We now have all cache related info, determine how we deal
 	 * with flush requests.
@@ -3115,7 +3121,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	q->limits.max_dev_sectors = logical_to_sectors(sdp, dev_max);
 
 	/*
-	 * Use the device's preferred I/O size for reads and writes
+	 * Determine the device's preferred I/O size for reads and writes
 	 * unless the reported value is unreasonably small, large, or
 	 * garbage.
 	 */
@@ -3129,8 +3135,19 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		rw_max = min_not_zero(logical_to_sectors(sdp, dev_max),
 				      (sector_t)BLK_DEF_MAX_SECTORS);
 
-	/* Combine with controller limits */
-	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
+	/* Do not exceed controller limit */
+	rw_max = min(rw_max, queue_max_hw_sectors(q));
+
+	/*
+	 * Only update max_sectors if previously unset or if the current value
+	 * exceeds the capabilities of the hardware.
+	 */
+	if (sdkp->first_scan ||
+	    q->limits.max_sectors > q->limits.max_dev_sectors ||
+	    q->limits.max_sectors > q->limits.max_hw_sectors)
+		q->limits.max_sectors = rw_max;
+
+	sdkp->first_scan = 0;
 
 	set_capacity(disk, logical_to_sectors(sdp, sdkp->capacity));
 	sd_config_write_same(sdkp);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 82e93ee94708..67c5a9f223f7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -192,6 +192,7 @@ struct scsi_device {
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
 	unsigned broken_fua:1;		/* Don't set FUA bit */
 	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */
+	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit for WRITE SAME */
 
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 9592570e092a..36b03013d629 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -29,5 +29,6 @@
 #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
 #define BLIST_MAX_1024		0x40000000 /* maximum 1024 sector cdb length */
+#define BLIST_UNMAP_LIMIT_WS	0x80000000 /* Use UNMAP limit for WRITE SAME */
 
 #endif
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 6183d20a01fb..b266d2a3bcb1 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -434,7 +434,6 @@ extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
 						unsigned int target_id);
 extern void iscsi_remove_session(struct iscsi_cls_session *session);
 extern void iscsi_free_session(struct iscsi_cls_session *session);
-extern int iscsi_destroy_session(struct iscsi_cls_session *session);
 extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
 						int dd_size, uint32_t cid);
 extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
