From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv5 1/8] scsi_error: count medium access timeout only once per EH run
Date: Tue,  4 Apr 2017 16:26:45 +0200
Message-ID: <1491316012-105426-2-git-send-email-hare@suse.de>
References: <1491316012-105426-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37452 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754189AbdDDO04 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Apr 2017 10:26:56 -0400
In-Reply-To: <1491316012-105426-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Ewan Milne <emilne@redhat.com>, Lawrence Obermann <loberman@redhat.com>, Benjamin Block <bblock@linux.vnet.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>

The current medium access timeout counter will be increased for
each command, so if there are enough failed commands we'll hit
the medium access timeout for even a single device failure and
the following kernel message is displayed:

sd H:C:T:L: [sdXY] Medium access timeout failure. Offlining disk!

Fix this by making the timeout per EH run, ie the counter will
only be increased once per device and EH run.

Fixes: 18a4d0a ("[SCSI] Handle disk devices which can not process medium access commands")
Cc: Ewan Milne <emilne@redhat.com>
Cc: Lawrence Obermann <loberman@redhat.com>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c  | 18 ++++++++++++++++++
 drivers/scsi/sd.c          | 27 ++++++++++++++++++++++++++-
 drivers/scsi/sd.h          |  1 +
 include/scsi/scsi_driver.h |  1 +
 4 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f2cafae..370f6c0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -221,6 +221,23 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 }
 
 /**
+ * scsi_eh_reset - call into ->eh_action to reset internal counters
+ * @scmd:	scmd to run eh on.
+ *
+ * The scsi driver might be carrying internal state about the
+ * devices, so we need to call into the driver to reset the
+ * internal state once the error handler is started.
+ */
+static void scsi_eh_reset(struct scsi_cmnd *scmd)
+{
+	if (!blk_rq_is_passthrough(scmd->request)) {
+		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
+		if (sdrv->eh_reset)
+			sdrv->eh_reset(scmd);
+	}
+}
+
+/**
  * scsi_eh_scmd_add - add scsi cmd to error handling.
  * @scmd:	scmd to run eh on.
  * @eh_flag:	optional SCSI_EH flag.
@@ -249,6 +266,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
 	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
 		eh_flag &= ~SCSI_EH_CANCEL_CMD;
 	scmd->eh_eflags |= eh_flag;
+	scsi_eh_reset(scmd);
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
 	shost->host_failed++;
 	scsi_eh_wakeup(shost);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d277e86..bd2a38e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -115,6 +115,7 @@
 static int sd_init_command(struct scsi_cmnd *SCpnt);
 static void sd_uninit_command(struct scsi_cmnd *SCpnt);
 static int sd_done(struct scsi_cmnd *);
+static void sd_eh_reset(struct scsi_cmnd *);
 static int sd_eh_action(struct scsi_cmnd *, int);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
@@ -532,6 +533,7 @@ static void sd_set_flush_flag(struct scsi_disk *sdkp)
 	.uninit_command		= sd_uninit_command,
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
+	.eh_reset		= sd_eh_reset,
 };
 
 /*
@@ -1686,6 +1688,26 @@ static int sd_pr_clear(struct block_device *bdev, u64 key)
 };
 
 /**
+ *	sd_eh_reset - reset error handling callback
+ *	@scmd:		sd-issued command that has failed
+ *
+ *	This function is called by the SCSI midlayer before starting
+ *	SCSI EH. When counting medium access failures we have to be
+ *	careful to register it only only once per device and SCSI EH run;
+ *	there might be several timed out commands which will cause the
+ *	'max_medium_access_timeouts' counter to trigger after the first
+ *	SCSI EH run already and set the device to offline.
+ *	So this function resets the internal counter before starting SCSI EH.
+ **/
+static void sd_eh_reset(struct scsi_cmnd *scmd)
+{
+	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
+
+	/* New SCSI EH run, reset gate variable */
+	sdkp->ignore_medium_access_errors = false;
+}
+
+/**
  *	sd_eh_action - error handling callback
  *	@scmd:		sd-issued command that has failed
  *	@eh_disp:	The recovery disposition suggested by the midlayer
@@ -1714,7 +1736,10 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 	 * process of recovering or has it suffered an internal failure
 	 * that prevents access to the storage medium.
 	 */
-	sdkp->medium_access_timed_out++;
+	if (!sdkp->ignore_medium_access_errors) {
+		sdkp->medium_access_timed_out++;
+		sdkp->ignore_medium_access_errors = true;
+	}
 
 	/*
 	 * If the device keeps failing read/write commands but TEST UNIT
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4dac35e..0cf9680 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -106,6 +106,7 @@ struct scsi_disk {
 	unsigned	rc_basis: 2;
 	unsigned	zoned: 2;
 	unsigned	urswrz : 1;
+	unsigned	ignore_medium_access_errors : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 891a658..a5534cc 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -16,6 +16,7 @@ struct scsi_driver {
 	void (*uninit_command)(struct scsi_cmnd *);
 	int (*done)(struct scsi_cmnd *);
 	int (*eh_action)(struct scsi_cmnd *, int);
+	void (*eh_reset)(struct scsi_cmnd *);
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
-- 
1.8.5.6
