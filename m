From: timg@tpi.com (Tim Gardner)
Subject: [PATCH] mptsas: Fix namespace collisions with ARM arch headers
Date: Tue, 28 Apr 2009 15:20:32 -0600 (MDT)
Message-ID: <20090428212032.28A41F88CE@sepang.rtg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-team-bounces@lists.ubuntu.com>
List-Unsubscribe: <https://lists.ubuntu.com/mailman/listinfo/kernel-team>,
	<mailto:kernel-team-request@lists.ubuntu.com?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/kernel-team>
List-Post: <mailto:kernel-team@lists.ubuntu.com>
List-Help: <mailto:kernel-team-request@lists.ubuntu.com?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/kernel-team>,
	<mailto:kernel-team-request@lists.ubuntu.com?subject=subscribe>
Sender: kernel-team-bounces@lists.ubuntu.com
Errors-To: kernel-team-bounces@lists.ubuntu.com
To: Eric.Moore@lsi.com
Cc: DL-MPTFusionLinux@lsi.com, kernel-team@lists.ubuntu.com, support@lsi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The following changes since commit 5868612ee4797cf90665a47b93a8bb0b96a12600:
  Tim Gardner (1):
        mpt2sas: Change reset_type enum to avoid namespace collision.

are available in the git repository at:

  git://kernel.ubuntu.com/rtg/linux-2.6 mpt2sas

>From 5868612ee4797cf90665a47b93a8bb0b96a12600 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 28 Apr 2009 13:54:11 -0600
Subject: [PATCH] mpt2sas: Change reset_type enum to avoid namespace collision.

Preface the enum reset_type declarations with MPT2SAS_ in order to avoid
namespace collisions with ARM arch definitions, specifically SOFT_RESET.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c      |   16 ++++++++--------
 drivers/scsi/mpt2sas/mpt2sas_base.h      |    8 ++++----
 drivers/scsi/mpt2sas/mpt2sas_config.c    |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c       |   10 +++++-----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c     |    7 ++++---
 drivers/scsi/mpt2sas/mpt2sas_transport.c |    4 ++--
 6 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index a91f514..78ef40e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -101,7 +101,7 @@ _base_fault_reset_work(struct work_struct *work)
 	doorbell = mpt2sas_base_get_iocstate(ioc, 0);
 	if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
 		rc = mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		    MPT2SAS_FORCE_BIG_HAMMER);
 		printk(MPT2SAS_WARN_FMT "%s: hard reset: %s\n", ioc->name,
 		    __func__, (rc == 0) ? "success" : "failed");
 		doorbell = mpt2sas_base_get_iocstate(ioc, 0);
@@ -2355,7 +2355,7 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
  issue_host_reset:
 	if (issue_reset)
 		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		    MPT2SAS_FORCE_BIG_HAMMER);
 	ioc->base_cmds.status = MPT2_CMD_NOT_USED;
 	rc = -EFAULT;
  out:
@@ -2452,7 +2452,7 @@ mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
  issue_host_reset:
 	if (issue_reset)
 		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		    MPT2SAS_FORCE_BIG_HAMMER);
 	ioc->base_cmds.status = MPT2_CMD_NOT_USED;
 	rc = -EFAULT;
  out:
@@ -2987,7 +2987,7 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
  * _base_make_ioc_ready - put controller in READY state
  * @ioc: per adapter object
  * @sleep_flag: CAN_SLEEP or NO_SLEEP
- * @type: FORCE_BIG_HAMMER or SOFT_RESET
+ * @type: MPT2SAS_FORCE_BIG_HAMMER or MPT2SAS_SOFT_RESET
  *
  * Returns 0 for success, non-zero for failure.
  */
@@ -3019,7 +3019,7 @@ _base_make_ioc_ready(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 		goto issue_diag_reset;
 	}
 
-	if (type == FORCE_BIG_HAMMER)
+	if (type == MPT2SAS_FORCE_BIG_HAMMER)
 		goto issue_diag_reset;
 
 	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_OPERATIONAL)
@@ -3110,7 +3110,7 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAPTER *ioc)
 	    __func__));
 
 	_base_mask_interrupts(ioc);
-	_base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
+	_base_make_ioc_ready(ioc, CAN_SLEEP, MPT2SAS_SOFT_RESET);
 	if (ioc->pci_irq) {
 		synchronize_irq(pdev->irq);
 		free_irq(ioc->pci_irq, ioc);
@@ -3145,7 +3145,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	if (r)
 		return r;
 
-	r = _base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
+	r = _base_make_ioc_ready(ioc, CAN_SLEEP, MPT2SAS_SOFT_RESET);
 	if (r)
 		goto out_free_resources;
 
@@ -3381,7 +3381,7 @@ _wait_for_commands_to_complete(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
  * mpt2sas_base_hard_reset_handler - reset controller
  * @ioc: Pointer to MPT_ADAPTER structure
  * @sleep_flag: CAN_SLEEP or NO_SLEEP
- * @type: FORCE_BIG_HAMMER or SOFT_RESET
+ * @type: MPT2SAS_FORCE_BIG_HAMMER or MPT2SAS_SOFT_RESET
  *
  * Returns 0 for success, non-zero for failure.
  */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 6945ff4..37ba4b0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -355,12 +355,12 @@ struct _sas_node {
 
 /**
  * enum reset_type - reset state
- * @FORCE_BIG_HAMMER: issue diagnostic reset
- * @SOFT_RESET: issue message_unit_reset, if fails to to big hammer
+ * @MPT2SAS_FORCE_BIG_HAMMER: issue diagnostic reset
+ * @MPT2SAS_SOFT_RESET: issue message_unit_reset, if fails to to big hammer
  */
 enum reset_type {
-	FORCE_BIG_HAMMER,
-	SOFT_RESET,
+	MPT2SAS_FORCE_BIG_HAMMER,
+	MPT2SAS_SOFT_RESET,
 };
 
 /**
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 58cfb97..bb990c2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -308,7 +308,7 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
  issue_host_reset:
 	if (issue_reset)
 		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		    MPT2SAS_FORCE_BIG_HAMMER);
 	ioc->config_cmds.status = MPT2_CMD_NOT_USED;
 	if (!retry_count) {
 		printk(MPT2SAS_INFO_FMT "%s: attempting retry\n",
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 2d4f85c..8fd8160 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -860,7 +860,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 			mutex_unlock(&ioc->tm_cmds.mutex);
 		} else
 			mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-			    FORCE_BIG_HAMMER);
+			    MPT2SAS_FORCE_BIG_HAMMER);
 	}
 
  out:
@@ -1070,7 +1070,7 @@ _ctl_do_reset(void __user *arg)
 	    __func__));
 
 	retval = mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-	    FORCE_BIG_HAMMER);
+	    MPT2SAS_FORCE_BIG_HAMMER);
 	printk(MPT2SAS_INFO_FMT "host reset: %s\n",
 	    ioc->name, ((!retval) ? "SUCCESS" : "FAILED"));
 	return 0;
@@ -1382,7 +1382,7 @@ _ctl_diag_register(void __user *arg, enum block_state state)
  issue_host_reset:
 	if (issue_reset)
 		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		    MPT2SAS_FORCE_BIG_HAMMER);
 
  out:
 
@@ -1690,7 +1690,7 @@ _ctl_diag_release(void __user *arg, enum block_state state)
  issue_host_reset:
 	if (issue_reset)
 		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		    MPT2SAS_FORCE_BIG_HAMMER);
 
  out:
 
@@ -1861,7 +1861,7 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
  issue_host_reset:
 	if (issue_reset)
 		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		    MPT2SAS_FORCE_BIG_HAMMER);
 
  out:
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 0c463c4..866bbed 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1821,7 +1821,8 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint lun,
 	}
 	return;
  issue_host_reset:
-	mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP, FORCE_BIG_HAMMER);
+	mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
+		MPT2SAS_FORCE_BIG_HAMMER);
 }
 
 /**
@@ -1980,7 +1981,7 @@ scsih_host_reset(struct scsi_cmnd *scmd)
 	scsi_print_command(scmd);
 
 	retval = mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-	    FORCE_BIG_HAMMER);
+	    MPT2SAS_FORCE_BIG_HAMMER);
 	r = (retval < 0) ? FAILED : SUCCESS;
 	printk(MPT2SAS_INFO_FMT "host reset: %s scmd(%p)\n",
 	    ioc->name, ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
@@ -5590,7 +5591,7 @@ scsih_resume(struct pci_dev *pdev)
 	if (r)
 		return r;
 
-	mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP, SOFT_RESET);
+	mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP, MPT2SAS_SOFT_RESET);
 	scsi_unblock_requests(shost);
 	return 0;
 }
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index e03dc0b..d08b174 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -447,7 +447,7 @@ transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
  issue_host_reset:
 	if (issue_reset)
 		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		    MPT2SAS_FORCE_BIG_HAMMER);
  out:
 	ioc->transport_cmds.status = MPT2_CMD_NOT_USED;
 	if (data_out)
@@ -1182,7 +1182,7 @@ transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
  issue_host_reset:
 	if (issue_reset) {
 		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
+		    MPT2SAS_FORCE_BIG_HAMMER);
 		rc = -ETIMEDOUT;
 	}
 
-- 
1.5.6.3
