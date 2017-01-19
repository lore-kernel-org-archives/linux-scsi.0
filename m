From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 2/4] mpt3sas: Fix for Crusader to achieve product targets with SAS devices.
Date: Thu, 19 Jan 2017 21:19:08 +0530
Message-ID: <1484840950-13656-3-git-send-email-chaitra.basappa@broadcom.com>
References: <1484840950-13656-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484840950-13656-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

Small glitch/degraded performance in Crusader is improved with SAS
drives by removing unnecessary spinlocks while clearing scsi command
in drivers internal lookup table.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
	       Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |    1 +
 drivers/scsi/mpt3sas/mpt3sas_base.h  |    1 +
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |    4 +++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   29 ++++++++++++++++++++++++++++-
 4 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index f00ef88..722fab9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5522,6 +5522,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		goto out_free_resources;
 
 	ioc->non_operational_loop = 0;
+	ioc->got_task_abort_from_ioctl = 0;
 	return 0;
 
  out_free_resources:
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index dcb33f4..83cfa16 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1000,6 +1000,7 @@ struct MPT3SAS_ADAPTER {
 	u8		broadcast_aen_busy;
 	u16		broadcast_aen_pending;
 	u8		shost_recovery;
+	u8		got_task_abort_from_ioctl;
 
 	struct mutex	reset_in_progress_mutex;
 	spinlock_t	ioc_reset_in_progress_lock;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 95f0f24..02fe1c4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -826,16 +826,18 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 			"TASK_MGMT: handle(0x%04x), task_type(0x%02x)\n",
 			ioc->name,
 		    le16_to_cpu(tm_request->DevHandle), tm_request->TaskType));
-
+		ioc->got_task_abort_from_ioctl = 1;
 		if (tm_request->TaskType ==
 		    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK ||
 		    tm_request->TaskType ==
 		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK) {
 			if (_ctl_set_task_mid(ioc, &karg, tm_request)) {
 				mpt3sas_base_free_smid(ioc, smid);
+				ioc->got_task_abort_from_ioctl = 0;
 				goto out;
 			}
 		}
+		ioc->got_task_abort_from_ioctl = 0;
 
 		if (test_bit(device_handle, ioc->device_remove_in_progress)) {
 			dtmprintk(ioc, pr_info(MPT3SAS_FMT
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 5ffbfb1..b3f9f7a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1096,6 +1096,27 @@ _scsih_scsi_lookup_get_clear(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 }
 
 /**
+ * _scsih_scsi_lookup_get_clear_without_lock - returns scmd entry without
+ *						holding any lock.
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Returns the smid stored scmd pointer.
+ * Then will derefrence the stored scmd pointer.
+ */
+static inline struct scsi_cmnd *
+_scsih_scsi_lookup_get_clear_without_lock(struct MPT3SAS_ADAPTER *ioc,
+		u16 smid)
+{
+	struct scsi_cmnd *scmd;
+
+	scmd = ioc->scsi_lookup[smid - 1].scmd;
+	ioc->scsi_lookup[smid - 1].scmd = NULL;
+
+	return scmd;
+}
+
+/**
  * _scsih_scsi_lookup_find_by_scmd - scmd lookup
  * @ioc: per adapter object
  * @smid: system request message index
@@ -4659,7 +4680,13 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	unsigned long flags;
 
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
-	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
+
+	if (ioc->broadcast_aen_busy || ioc->pci_error_recovery ||
+			ioc->got_task_abort_from_ioctl)
+		scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
+	else
+		scmd = _scsih_scsi_lookup_get_clear_without_lock(ioc, smid);
+
 	if (scmd == NULL)
 		return 1;
 
-- 
1.7.1
