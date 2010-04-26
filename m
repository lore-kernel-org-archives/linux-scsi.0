From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: [PATCH] raid/multipath error handling for faulty drives
Date: Mon, 26 Apr 2010 19:58:36 +0900
Message-ID: <4BD571DC.9090103@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, neilb@suse.de, kusumi.tomohiro@jp.fujitsu.com
List-Id: linux-scsi@vger.kernel.org

Hi,

I've been looking for ways to minimize the impact of faulty drive in a multipath
and raid array environment. Our major problem is that it takes long time before
upper layer (dm-mpath, dm-raid or maybe other middleware kernel module by users)
can handle timed out i/o because of huge recovery operation by scsi driver's error
handler. Let me explain some details.

The scsi error recovery can be regarded as something that essentialy conflicts
with multipath or raid array environment, because in such an environment where the
system itself provides redundant path or disks, it is usually designed to use
alternative path or disks right after detecting faulty drive.

As far as I know there has been couples of approaches done in scsi or md layer
(eg. http://www.mail-archive.com/linux-raid@vger.kernel.org/msg09024.html) to
minimize recovery time although neither of them have been mereged for some reason.

This patch is a simple aproach to omit error recovery phase. Each scsi device has
no_recovery sysfs entry to select whether the device needs recovery (off course
no_recovery is disabled on default). If it is enabled, then the scsi device that
corresponds to the timed out command is rapidly offlined with DRIVER_TIMEOUT status.
This enables upper layers have chance to take care of timed out commands without
waiting for recovery to finish.

This is how it shows on /var/log/messages when no_recovery option is enabled with
all the verbose logs for scsi mldd and lldd set. If no_recovery is disabled, it takes
as much as 30 minutes or so depending on implementation of lldd and number of timed
out commands.

-----
Apr 21 19:50:47 localhost kernel: lpfc 0000:03:04.0: 0:(0):0309 Mailbox cmd x31 issue Data: x20 x700 x2
Apr 21 19:50:47 localhost kernel: lpfc 0000:03:04.0: 0:(0):0307 Mailbox cmd x31 (x0) Cmpl xf85fa862 Data: x123100 x0 x0 x0 x0 x0 x0 x0 x0
Apr 21 19:50:57 localhost kernel: lpfc 0000:03:04.0: 0:(0):0309 Mailbox cmd x31 issue Data: x20 x700 x2
Apr 21 19:50:57 localhost kernel: lpfc 0000:03:04.0: 0:(0):0307 Mailbox cmd x31 (x0) Cmpl xf85fa862 Data: x123100 x0 x0 x0 x0 x0 x0 x0 x0
Apr 21 19:51:02 localhost kernel: lpfc 0000:03:04.0: 0:(0):0309 Mailbox cmd x31 issue Data: x20 x700 x2
Apr 21 19:51:02 localhost kernel: lpfc 0000:03:04.0: 0:(0):0307 Mailbox cmd x31 (x0) Cmpl xf85fa862 Data: x123100 x0 x0 x0 x0 x0 x0 x0 x0
Apr 21 19:51:07 localhost kernel: lpfc 0000:03:04.0: 0:(0):0309 Mailbox cmd x31 issue Data: x20 x700 x2
Apr 21 19:51:07 localhost kernel: lpfc 0000:03:04.0: 0:(0):0307 Mailbox cmd x31 (x0) Cmpl xf85fa862 Data: x123100 x0 x0 x0 x0 x0 x0 x0 x0
Apr 21 19:51:10 localhost kernel: sd 3:0:0:0: Device offlined - no recovery
Apr 21 19:51:10 localhost kernel: scsi_work_offline_sdev scmd: c5bb7e00 result: 6000000
Apr 21 19:51:10 localhost kernel: sd 3:0:0:0: [sdc] Unhandled error code
Apr 21 19:51:10 localhost kernel: sd 3:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Apr 21 19:51:10 localhost kernel: sd 3:0:0:0: [sdc] CDB: Read(10): 28 00 00 02 16 e8 00 00 08 00
Apr 21 19:51:10 localhost kernel: end_request: I/O error, dev sdc, sector 136936
Apr 21 19:51:10 localhost kernel: device-mapper: multipath: Failing path 8:32.
Apr 21 19:51:10 localhost multipathd: 8:32: mark as failed
Apr 21 19:51:10 localhost multipathd: mpatha: remaining active paths: 1
Apr 21 19:51:11 localhost multipathd: dm-4: add map (uevent)
Apr 21 19:51:11 localhost multipathd: dm-4: devmap already registered
-----

If Linux's scsi driver provides lldd with eh_strategy_handler() interface to
implement its own recovery code, then I think it is also natural to provide an
interface to give up any recovery options for those who do not want it.
Any comments would be helpful, thanks.

By the way, this patch is based on the bug fix (http://lkml.org/lkml/2010/4/14/29)
that I have submitted recently. This bug fix has been merged to -mm tree.

Thanks,
Tomohiro Kusumi



Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
---

diff -aNur linux-2.6.34-rc5.org/drivers/scsi/scsi_error.c linux-2.6.34-rc5/drivers/scsi/scsi_error.c
--- linux-2.6.34-rc5.org/drivers/scsi/scsi_error.c	2010-04-20 08:29:56.000000000 +0900
+++ linux-2.6.34-rc5/drivers/scsi/scsi_error.c	2010-04-23 20:34:08.492478179 +0900
@@ -129,6 +129,11 @@
 
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
+	if (scmd->device->no_recovery) {
+		schedule_work(&scmd->tmo_work);
+		return rtn;
+	}
+
 	if (scmd->device->host->transportt->eh_timed_out)
 		rtn = scmd->device->host->transportt->eh_timed_out(scmd);
 	else if (scmd->device->host->hostt->eh_timed_out)
@@ -2104,3 +2109,25 @@
 	}
 }
 EXPORT_SYMBOL(scsi_build_sense_buffer);
+
+/**
+ * scsi_work_offline_sdev - offline device and finish timed out command
+ * @work:	work_struct for scsi command to get rid of
+ **/
+void scsi_work_offline_sdev(struct work_struct *work)
+{
+	struct scsi_cmnd *scmd = container_of(work, struct scsi_cmnd, tmo_work);
+
+	if (scmd->device->sdev_state == SDEV_RUNNING) {
+		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
+		sdev_printk(KERN_INFO, scmd->device,
+			    "Device offlined - no recovery\n");
+	}
+
+	if (!scmd->result)
+		scmd->result |= (DRIVER_TIMEOUT << 24);
+
+	SCSI_LOG_ERROR_RECOVERY(1, printk("%s scmd: %p result: %x\n",
+				__func__, scmd, scmd->result));
+	scsi_finish_command(scmd);
+}
diff -aNur linux-2.6.34-rc5.org/drivers/scsi/scsi_lib.c linux-2.6.34-rc5/drivers/scsi/scsi_lib.c
--- linux-2.6.34-rc5.org/drivers/scsi/scsi_lib.c	2010-04-20 08:29:56.000000000 +0900
+++ linux-2.6.34-rc5/drivers/scsi/scsi_lib.c	2010-04-23 20:34:08.493478584 +0900
@@ -1038,6 +1038,7 @@
 	cmd->request = req;
 
 	cmd->cmnd = req->cmd;
+	INIT_WORK(&cmd->tmo_work, scsi_work_offline_sdev);
 
 	return cmd;
 }
diff -aNur linux-2.6.34-rc5.org/drivers/scsi/scsi_priv.h linux-2.6.34-rc5/drivers/scsi/scsi_priv.h
--- linux-2.6.34-rc5.org/drivers/scsi/scsi_priv.h	2010-04-20 08:29:56.000000000 +0900
+++ linux-2.6.34-rc5/drivers/scsi/scsi_priv.h	2010-04-23 20:34:08.493478584 +0900
@@ -73,6 +73,7 @@
 int scsi_eh_get_sense(struct list_head *work_q,
 		      struct list_head *done_q);
 int scsi_noretry_cmd(struct scsi_cmnd *scmd);
+void scsi_work_offline_sdev(struct work_struct*);
 
 /* scsi_lib.c */
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
diff -aNur linux-2.6.34-rc5.org/drivers/scsi/scsi_scan.c linux-2.6.34-rc5/drivers/scsi/scsi_scan.c
--- linux-2.6.34-rc5.org/drivers/scsi/scsi_scan.c	2010-04-20 08:29:56.000000000 +0900
+++ linux-2.6.34-rc5/drivers/scsi/scsi_scan.c	2010-04-23 20:34:08.494477948 +0900
@@ -257,6 +257,7 @@
 	sdev->lun = lun;
 	sdev->channel = starget->channel;
 	sdev->sdev_state = SDEV_CREATED;
+	sdev->no_recovery = 0;
 	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
 	INIT_LIST_HEAD(&sdev->cmd_list);
diff -aNur linux-2.6.34-rc5.org/drivers/scsi/scsi_sysfs.c linux-2.6.34-rc5/drivers/scsi/scsi_sysfs.c
--- linux-2.6.34-rc5.org/drivers/scsi/scsi_sysfs.c	2010-04-23 19:59:21.896228214 +0900
+++ linux-2.6.34-rc5/drivers/scsi/scsi_sysfs.c	2010-04-23 20:36:27.120227650 +0900
@@ -544,6 +544,7 @@
 sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");
+sdev_rw_attr (no_recovery, "%d\n");
 
 /*
  * TODO: can we make these symlinks to the block layer ones?
@@ -738,6 +739,7 @@
 	&dev_attr_iodone_cnt.attr,
 	&dev_attr_ioerr_cnt.attr,
 	&dev_attr_modalias.attr,
+	&dev_attr_no_recovery.attr,
 	REF_EVT(media_change),
 	NULL
 };
diff -aNur linux-2.6.34-rc5.org/include/scsi/scsi_cmnd.h linux-2.6.34-rc5/include/scsi/scsi_cmnd.h
--- linux-2.6.34-rc5.org/include/scsi/scsi_cmnd.h	2010-04-20 08:29:56.000000000 +0900
+++ linux-2.6.34-rc5/include/scsi/scsi_cmnd.h	2010-04-23 20:34:08.495478045 +0900
@@ -129,6 +129,8 @@
 	int result;		/* Status code from lower level driver */
 
 	unsigned char tag;	/* SCSI-II queued command tag */
+
+	struct work_struct tmo_work;	/* work for no recovery on timeout */
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
diff -aNur linux-2.6.34-rc5.org/include/scsi/scsi_device.h linux-2.6.34-rc5/include/scsi/scsi_device.h
--- linux-2.6.34-rc5.org/include/scsi/scsi_device.h	2010-04-20 08:29:56.000000000 +0900
+++ linux-2.6.34-rc5/include/scsi/scsi_device.h	2010-04-23 20:35:29.255569542 +0900
@@ -163,6 +163,8 @@
 	atomic_t iodone_cnt;
 	atomic_t ioerr_cnt;
 
+	int no_recovery; /* no error recovery on timeout if set */
+
 	struct device		sdev_gendev,
 				sdev_dev;
