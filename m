From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.5-rc3
Date: Thu, 11 Feb 2016 21:40:34 -0800
Message-ID: <1455255634.2358.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

A set of seven fixes.  Two regressions in the new hisi_sas arm driver,
a blacklist entry for the marvell console which was causing a reset
cascade without it, a race fix in the WRITE_SAME/DISCARD routines, a
retry fix for the rdac driver, without which, it would prematurely
return EIO and a couple of fixes for the hyper-v storvsc driver.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Hannes Reinecke (1):
      scsi_dh_rdac: always retry MODE SELECT on command lock violation

John Garry (2):
      hisi_sas: fix v1 hw check for slot error
      hisi_sas: add dependency for HAS_IOMEM

K. Y. Srinivasan (2):
      storvsc: Use the specified target ID in device lookup
      storvsc: Install the storvsc specific timeout handler for FC devices

Martin K. Petersen (1):
      block/sd: Return -EREMOTEIO when WRITE SAME and DISCARD are disabled

Mika Westerberg (1):
      SCSI: Add Marvell Console to VPD blacklist

and the diffstat:

 block/blk-core.c                           |  6 ++++--
 drivers/scsi/device_handler/scsi_dh_rdac.c |  4 +++-
 drivers/scsi/hisi_sas/Kconfig              |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c     |  9 +++------
 drivers/scsi/scsi_devinfo.c                |  1 +
 drivers/scsi/sd.c                          |  4 ++--
 drivers/scsi/storvsc_drv.c                 | 16 +++++++++++-----
 include/linux/blkdev.h                     |  9 ++++++---
 8 files changed, 31 insertions(+), 20 deletions(-)

With the full diff below.

James

---

diff --git a/block/blk-core.c b/block/blk-core.c
index ab51685..b83d297 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2455,14 +2455,16 @@ struct request *blk_peek_request(struct request_queue *q)
 
 			rq = NULL;
 			break;
-		} else if (ret == BLKPREP_KILL) {
+		} else if (ret == BLKPREP_KILL || ret == BLKPREP_INVALID) {
+			int err = (ret == BLKPREP_INVALID) ? -EREMOTEIO : -EIO;
+
 			rq->cmd_flags |= REQ_QUIET;
 			/*
 			 * Mark this request as started so we don't trigger
 			 * any debug logic in the end I/O path.
 			 */
 			blk_start_request(rq);
-			__blk_end_request_all(rq, -EIO);
+			__blk_end_request_all(rq, err);
 		} else {
 			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
 			break;
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 3613581..93880ed 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -562,7 +562,7 @@ static int mode_select_handle_sense(struct scsi_device *sdev,
 			/*
 			 * Command Lock contention
 			 */
-			err = SCSI_DH_RETRY;
+			err = SCSI_DH_IMM_RETRY;
 		break;
 	default:
 		break;
@@ -612,6 +612,8 @@ retry:
 		err = mode_select_handle_sense(sdev, h->sense);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
+		if (err == SCSI_DH_IMM_RETRY)
+			goto retry;
 	}
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index b676618..d1dd161 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -1,6 +1,6 @@
 config SCSI_HISI_SAS
 	tristate "HiSilicon SAS"
-	depends on HAS_DMA
+	depends on HAS_DMA && HAS_IOMEM
 	depends on ARM64 || COMPILE_TEST
 	select SCSI_SAS_LIBSAS
 	select BLK_DEV_INTEGRITY
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 057fdeb..eea24d7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1289,13 +1289,10 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 		goto out;
 	}
 
-	if (cmplt_hdr_data & CMPLT_HDR_ERR_RCRD_XFRD_MSK) {
-		if (!(cmplt_hdr_data & CMPLT_HDR_CMD_CMPLT_MSK) ||
-		    !(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK))
-			ts->stat = SAS_DATA_OVERRUN;
-		else
-			slot_err_v1_hw(hisi_hba, task, slot);
+	if (cmplt_hdr_data & CMPLT_HDR_ERR_RCRD_XFRD_MSK &&
+		!(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK)) {
 
+		slot_err_v1_hw(hisi_hba, task, slot);
 		goto out;
 	}
 
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 47b9d13..da2e068 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -205,6 +205,7 @@ static struct {
 	{"Intel", "Multi-Flex", NULL, BLIST_NO_RSOC},
 	{"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
 	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
+	{"Marvell", "Console", NULL, BLIST_SKIP_VPD_PAGES},
 	{"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"MATSHITA", "DMC-LC5", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
 	{"MATSHITA", "DMC-LC40", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bb669d3..d749da7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -761,7 +761,7 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 		break;
 
 	default:
-		ret = BLKPREP_KILL;
+		ret = BLKPREP_INVALID;
 		goto out;
 	}
 
@@ -839,7 +839,7 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	int ret;
 
 	if (sdkp->device->no_write_same)
-		return BLKPREP_KILL;
+		return BLKPREP_INVALID;
 
 	BUG_ON(bio_offset(bio) || bio_iovec(bio).bv_len != sdp->sector_size);
 
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 55627d0..292c04e 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -42,6 +42,7 @@
 #include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_transport.h>
 
 /*
  * All wire protocol details (storage protocol between the guest and the host)
@@ -477,19 +478,18 @@ struct hv_host_device {
 struct storvsc_scan_work {
 	struct work_struct work;
 	struct Scsi_Host *host;
-	uint lun;
+	u8 lun;
+	u8 tgt_id;
 };
 
 static void storvsc_device_scan(struct work_struct *work)
 {
 	struct storvsc_scan_work *wrk;
-	uint lun;
 	struct scsi_device *sdev;
 
 	wrk = container_of(work, struct storvsc_scan_work, work);
-	lun = wrk->lun;
 
-	sdev = scsi_device_lookup(wrk->host, 0, 0, lun);
+	sdev = scsi_device_lookup(wrk->host, 0, wrk->tgt_id, wrk->lun);
 	if (!sdev)
 		goto done;
 	scsi_rescan_device(&sdev->sdev_gendev);
@@ -540,7 +540,7 @@ static void storvsc_remove_lun(struct work_struct *work)
 	if (!scsi_host_get(wrk->host))
 		goto done;
 
-	sdev = scsi_device_lookup(wrk->host, 0, 0, wrk->lun);
+	sdev = scsi_device_lookup(wrk->host, 0, wrk->tgt_id, wrk->lun);
 
 	if (sdev) {
 		scsi_remove_device(sdev);
@@ -940,6 +940,7 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 
 	wrk->host = host;
 	wrk->lun = vm_srb->lun;
+	wrk->tgt_id = vm_srb->target_id;
 	INIT_WORK(&wrk->work, process_err_fn);
 	schedule_work(&wrk->work);
 }
@@ -1770,6 +1771,11 @@ static int __init storvsc_drv_init(void)
 	fc_transport_template = fc_attach_transport(&fc_transport_functions);
 	if (!fc_transport_template)
 		return -ENODEV;
+
+	/*
+	 * Install Hyper-V specific timeout handler.
+	 */
+	fc_transport_template->eh_timed_out = storvsc_eh_timed_out;
 #endif
 
 	ret = vmbus_driver_register(&storvsc_drv);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 29189ae..4571ef1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -682,9 +682,12 @@ static inline bool blk_write_same_mergeable(struct bio *a, struct bio *b)
 /*
  * q->prep_rq_fn return values
  */
-#define BLKPREP_OK		0	/* serve it */
-#define BLKPREP_KILL		1	/* fatal error, kill */
-#define BLKPREP_DEFER		2	/* leave on queue */
+enum {
+	BLKPREP_OK,		/* serve it */
+	BLKPREP_KILL,		/* fatal error, kill, return -EIO */
+	BLKPREP_DEFER,		/* leave on queue */
+	BLKPREP_INVALID,	/* invalid command, kill, return -EREMOTEIO */
+};
 
 extern unsigned long blk_max_low_pfn, blk_max_pfn;
 
