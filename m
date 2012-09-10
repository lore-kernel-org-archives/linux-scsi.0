From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.6-rc5
Date: Mon, 10 Sep 2012 17:07:14 +0100
Message-ID: <1347293234.3038.67.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40282 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757686Ab2IJQHS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Sep 2012 12:07:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Just a note to everyone:  I had actually prepared this fix set before I
left for KS + Plumbers, so it's been incubating much longer than it
should have.  I'll be picking up my three week backlog this week, so
more fixes will then be forthcoming

This set consist of three minor and one fairly major (the device not
ready causing offlining problem which is a serious regression introduced
by the media change update) fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

James Bottomley (1):
      Fix 'Device not ready' issue on mpt2sas

Kashyap Desai (1):
      megaraid_sas: Move poll_aen_lock initializer

Mike Snitzer (1):
      scsi_lib: fix scsi_io_completion's SG_IO error propagation

sreekanth.reddy@lsi.com (1):
      mpt2sas: Fix for Driver oops, when loading driver with max_queue_depth command line option to a very small value

And the diffstat:

 drivers/scsi/megaraid/megaraid_sas_base.c |  3 ++-
 drivers/scsi/mpt2sas/mpt2sas_base.c       | 13 ++++++++-----
 drivers/scsi/scsi_error.c                 | 10 ++++++++++
 drivers/scsi/scsi_lib.c                   |  5 ++++-
 drivers/scsi/scsi_scan.c                  | 10 ++++++++++
 5 files changed, 34 insertions(+), 7 deletions(-)

Full diff is below.

James

---

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index dc27598..ed38454 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4066,7 +4066,6 @@ megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&instance->cmd_pool_lock);
 	spin_lock_init(&instance->hba_lock);
 	spin_lock_init(&instance->completion_lock);
-	spin_lock_init(&poll_aen_lock);
 
 	mutex_init(&instance->aen_mutex);
 	mutex_init(&instance->reset_mutex);
@@ -5392,6 +5391,8 @@ static int __init megasas_init(void)
 	printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
 	       MEGASAS_EXT_VERSION);
 
+	spin_lock_init(&poll_aen_lock);
+
 	support_poll_for_event = 2;
 	support_device_change = 1;
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 9d46fcb..b25757d 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2424,10 +2424,13 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	}
 
 	/* command line tunables  for max controller queue depth */
-	if (max_queue_depth != -1)
-		max_request_credit = (max_queue_depth < facts->RequestCredit)
-		    ? max_queue_depth : facts->RequestCredit;
-	else
+	if (max_queue_depth != -1 && max_queue_depth != 0) {
+		max_request_credit = min_t(u16, max_queue_depth +
+			ioc->hi_priority_depth + ioc->internal_depth,
+			facts->RequestCredit);
+		if (max_request_credit > MAX_HBA_QUEUE_DEPTH)
+			max_request_credit =  MAX_HBA_QUEUE_DEPTH;
+	} else
 		max_request_credit = min_t(u16, facts->RequestCredit,
 		    MAX_HBA_QUEUE_DEPTH);
 
@@ -2502,7 +2505,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	/* set the scsi host can_queue depth
 	 * with some internal commands that could be outstanding
 	 */
-	ioc->shost->can_queue = ioc->scsiio_depth - (2);
+	ioc->shost->can_queue = ioc->scsiio_depth;
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scsi host: "
 	    "can_queue depth (%d)\n", ioc->name, ioc->shost->can_queue));
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4a6381c..de2337f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -42,6 +42,8 @@
 
 #include <trace/events/scsi.h>
 
+static void scsi_eh_done(struct scsi_cmnd *scmd);
+
 #define SENSE_TIMEOUT		(10*HZ)
 
 /*
@@ -241,6 +243,14 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
 
+	if (scmd->cmnd[0] == TEST_UNIT_READY && scmd->scsi_done != scsi_eh_done)
+		/*
+		 * nasty: for mid-layer issued TURs, we need to return the
+		 * actual sense data without any recovery attempt.  For eh
+		 * issued ones, we need to try to recover and interpret
+		 */
+		return SUCCESS;
+
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ffd7773..faa790f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -776,7 +776,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC) { /* SG_IO ioctl from block level */
-		req->errors = result;
 		if (result) {
 			if (sense_valid && req->sense) {
 				/*
@@ -792,6 +791,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			if (!sense_deferred)
 				error = __scsi_error_from_host_byte(cmd, result);
 		}
+		/*
+		 * __scsi_error_from_host_byte may have reset the host_byte
+		 */
+		req->errors = cmd->result;
 
 		req->resid_len = scsi_get_resid(cmd);
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 56a9379..d947ffc 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -764,6 +764,16 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->model = (char *) (sdev->inquiry + 16);
 	sdev->rev = (char *) (sdev->inquiry + 32);
 
+	if (strncmp(sdev->vendor, "ATA     ", 8) == 0) {
+		/*
+		 * sata emulation layer device.  This is a hack to work around
+		 * the SATL power management specifications which state that
+		 * when the SATL detects the device has gone into standby
+		 * mode, it shall respond with NOT READY.
+		 */
+		sdev->allow_restart = 1;
+	}
+
 	if (*bflags & BLIST_ISROM) {
 		sdev->type = TYPE_ROM;
 		sdev->removable = 1;


