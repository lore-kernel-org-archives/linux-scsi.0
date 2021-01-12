Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919D8C43381
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C78423101
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391018AbhALJei (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:34:38 -0500
Received: from comms.puri.sm ([159.203.221.185]:33594 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405953AbhALJeg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 04:34:36 -0500
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 3F98CDFDF1;
        Tue, 12 Jan 2021 01:33:56 -0800 (PST)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zLf_7nlhkmYV; Tue, 12 Jan 2021 01:33:55 -0800 (PST)
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        stern@rowland.harvard.edu, bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH v2 2/3] scsi: sd: add ignore_resume_medium_changed disk setting
Date:   Tue, 12 Jan 2021 10:33:28 +0100
Message-Id: <20210112093329.3639-3-martin.kepplinger@puri.sm>
In-Reply-To: <20210112093329.3639-1-martin.kepplinger@puri.sm>
References: <20210112093329.3639-1-martin.kepplinger@puri.sm>
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a userspace knob for scsi disks that deliver a MEDIA CHANGED
unit attention when the device actually only resumes from (runtime) suspend.
Those devices need the new ignore_resume_medium_changed knob set to 1
in order to be able to use runtime PM.

To enable runtime PM for an SD cardreader (here, device number 0:0:0:0),
do the following:

echo 0 > /sys/module/block/parameters/events_dfl_poll_msecs
echo 1000 > /sys/bus/scsi/devices/0:0:0:0/power/autosuspend_delay_ms
echo auto > /sys/bus/scsi/devices/0:0:0:0/power/control

Set ignore_resume_medium_changed to 1 if you experience this problem.
Otherwise the unit attention would trigger I/O failure like the following
when using the mounted disk:

[  167.603864] sd 0:0:0:0: [sda] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00
driverbyte=0x08 cmd_age=0s
[  167.603892] sd 0:0:0:0: [sda] tag#0 Sense Key : 0x6 [current]
[  167.603899] sd 0:0:0:0: [sda] tag#0 ASC=0x28 ASCQ=0x0
[  167.603909] sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x2a 2a 00 01 c4 08 98 00 00 10 00
[  167.603915] blk_update_request: I/O error, dev sda, sector 29624472 op
0x1:(WRITE) flags 0x800 phys_seg 2 prio class 0
[  167.614750] Aborting journal on device sda1-8.
[  167.619460] sd 0:0:0:0: [sda] tag#0 device offline or changed
[  167.625342] blk_update_request: I/O error, dev sda, sector 29624320 op
0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[  167.636161] Buffer I/O error on dev sda1, logical block 3702784, lost sync page write
[  167.644132] JBD2: Error -5 detected when updating journal superblock for sda1-8.

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
---
 drivers/scsi/sd.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h |  1 +
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a3d2d4bc4a3d..14b850d2af59 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -114,6 +114,7 @@ static void sd_shutdown(struct device *);
 static int sd_suspend_system(struct device *);
 static int sd_suspend_runtime(struct device *);
 static int sd_resume(struct device *);
+static int sd_resume_runtime(struct device *);
 static void sd_rescan(struct device *);
 static blk_status_t sd_init_command(struct scsi_cmnd *SCpnt);
 static void sd_uninit_command(struct scsi_cmnd *SCpnt);
@@ -375,6 +376,33 @@ thin_provisioning_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(thin_provisioning);
 
+static ssize_t
+ignore_resume_medium_changed_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	return sprintf(buf, "%u\n", sdkp->ignore_resume_medium_changed);
+}
+
+static ssize_t
+ignore_resume_medium_changed_store(struct device *dev, struct device_attribute *attr,
+		    const char *buf, size_t count)
+{
+	bool v;
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (kstrtobool(buf, &v))
+		return -EINVAL;
+
+	sdkp->ignore_resume_medium_changed = v;
+
+	return count;
+}
+static DEVICE_ATTR_RW(ignore_resume_medium_changed);
+
 /* sysfs_match_string() requires dense arrays */
 static const char *lbp_mode[] = {
 	[SD_LBP_FULL]		= "full",
@@ -591,6 +619,7 @@ static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_max_medium_access_timeouts.attr,
 	&dev_attr_zoned_cap.attr,
 	&dev_attr_max_retries.attr,
+	&dev_attr_ignore_resume_medium_changed.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(sd_disk);
@@ -608,7 +637,7 @@ static const struct dev_pm_ops sd_pm_ops = {
 	.poweroff		= sd_suspend_system,
 	.restore		= sd_resume,
 	.runtime_suspend	= sd_suspend_runtime,
-	.runtime_resume		= sd_resume,
+	.runtime_resume		= sd_resume_runtime,
 };
 
 static struct scsi_driver sd_template = {
@@ -3699,6 +3728,25 @@ static int sd_resume(struct device *dev)
 	return ret;
 }
 
+static int sd_resume_runtime(struct device *dev)
+{
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	int ret;
+
+	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
+		return 0;
+
+	/*
+	 * ignore_resume_media_change is the userspace setting and
+	 * expecting_media_change is what is checked and cleared in the
+	 * error path if we set it here.
+	 */
+	if (sdkp->ignore_resume_medium_changed)
+		sdkp->device->expecting_media_change = 1;
+
+	return sd_resume(dev);
+}
+
 /**
  *	init_sd - entry point for this driver (both when built in or when
  *	a module).
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index b59136c4125b..1b041331356c 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -125,6 +125,7 @@ struct scsi_disk {
 	unsigned	urswrz : 1;
 	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
+	unsigned	ignore_resume_medium_changed : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
-- 
2.20.1

