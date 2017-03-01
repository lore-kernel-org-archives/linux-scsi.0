From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 1/6] scsi_error: count medium access timeout only once per EH run
Date: Wed,  1 Mar 2017 10:15:15 +0100
Message-ID: <1488359720-130871-2-git-send-email-hare@suse.de>
References: <1488359720-130871-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55421 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752024AbdCAJep (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Mar 2017 04:34:45 -0500
In-Reply-To: <1488359720-130871-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Ewan Milne <emilne@redhat.com>, Lawrence Obermann <loberman@redhat.com>, Benjamin Block <bblock@linux.vnet.ibm.com>, Steffen Maier <maier@de.ibm.com>, Hannes Reinecke <hare@suse.com>

The current medium access timeout counter will be increased for
each command, so if there are enough failed commands we'll hit
the medium access timeout for even a single failure.
Fix this by making the timeout per EH run, ie the counter will
only be increased once per device and EH run.

Cc: Ewan Milne <emilne@redhat.com>
Cc: Lawrence Obermann <loberman@redhat.com>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: Steffen Maier <maier@de.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c  | 16 +++++++++++++++-
 drivers/scsi/sd.c          | 21 +++++++++++++++++----
 drivers/scsi/sd.h          |  1 +
 include/scsi/scsi_driver.h |  2 +-
 4 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f2cafae..cec439c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -58,6 +58,7 @@
 static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
 static int scsi_try_to_abort_cmd(struct scsi_host_template *,
 				 struct scsi_cmnd *);
+static int scsi_eh_reset(struct scsi_cmnd *scmd);
 
 /* called with shost->host_lock held */
 void scsi_eh_wakeup(struct Scsi_Host *shost)
@@ -249,6 +250,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
 	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
 		eh_flag &= ~SCSI_EH_CANCEL_CMD;
 	scmd->eh_eflags |= eh_flag;
+	scsi_eh_reset(scmd);
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
 	shost->host_failed++;
 	scsi_eh_wakeup(shost);
@@ -1107,7 +1109,19 @@ static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
 	if (!blk_rq_is_passthrough(scmd->request)) {
 		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
 		if (sdrv->eh_action)
-			rtn = sdrv->eh_action(scmd, rtn);
+			rtn = sdrv->eh_action(scmd, rtn, false);
+	}
+	return rtn;
+}
+
+static int scsi_eh_reset(struct scsi_cmnd *scmd)
+{
+	int rtn = SUCCESS;
+
+	if (!blk_rq_is_passthrough(scmd->request)) {
+		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
+		if (sdrv->eh_action)
+			rtn = sdrv->eh_action(scmd, rtn, true);
 	}
 	return rtn;
 }
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c7839f6..c794686 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -115,7 +115,7 @@
 static int sd_init_command(struct scsi_cmnd *SCpnt);
 static void sd_uninit_command(struct scsi_cmnd *SCpnt);
 static int sd_done(struct scsi_cmnd *);
-static int sd_eh_action(struct scsi_cmnd *, int);
+static int sd_eh_action(struct scsi_cmnd *, int, bool);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
@@ -1689,18 +1689,28 @@ static int sd_pr_clear(struct block_device *bdev, u64 key)
  *	sd_eh_action - error handling callback
  *	@scmd:		sd-issued command that has failed
  *	@eh_disp:	The recovery disposition suggested by the midlayer
+ *	@reset:		Reset medium access counter
  *
  *	This function is called by the SCSI midlayer upon completion of an
  *	error test command (currently TEST UNIT READY). The result of sending
  *	the eh command is passed in eh_disp.  We're looking for devices that
  *	fail medium access commands but are OK with non access commands like
  *	test unit ready (so wrongly see the device as having a successful
- *	recovery)
+ *	recovery).
+ *	We have to be careful to count a medium access failure only once
+ *	per SCSI EH run; there might be several timed out commands which
+ *	will cause the 'max_medium_access_timeouts' counter to trigger
+ *	after the first SCSI EH run already and set the device to offline.
  **/
-static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
+static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp, bool reset)
 {
 	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
 
+	if (reset) {
+		/* New SCSI EH run, reset gate variable */
+		sdkp->medium_access_reset = 0;
+		return eh_disp;
+	}
 	if (!scsi_device_online(scmd->device) ||
 	    !scsi_medium_access_command(scmd) ||
 	    host_byte(scmd->result) != DID_TIME_OUT ||
@@ -1714,7 +1724,10 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 	 * process of recovering or has it suffered an internal failure
 	 * that prevents access to the storage medium.
 	 */
-	sdkp->medium_access_timed_out++;
+	if (!sdkp->medium_access_reset) {
+		sdkp->medium_access_timed_out++;
+		sdkp->medium_access_reset = 1;
+	}
 
 	/*
 	 * If the device keeps failing read/write commands but TEST UNIT
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4dac35e..6a4f75a 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -106,6 +106,7 @@ struct scsi_disk {
 	unsigned	rc_basis: 2;
 	unsigned	zoned: 2;
 	unsigned	urswrz : 1;
+	unsigned	medium_access_reset : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 891a658..d5e0012 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -15,7 +15,7 @@ struct scsi_driver {
 	int (*init_command)(struct scsi_cmnd *);
 	void (*uninit_command)(struct scsi_cmnd *);
 	int (*done)(struct scsi_cmnd *);
-	int (*eh_action)(struct scsi_cmnd *, int);
+	int (*eh_action)(struct scsi_cmnd *, int, bool);
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
-- 
1.8.5.6
