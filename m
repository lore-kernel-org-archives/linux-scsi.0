Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D11E80AB0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 14:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjI0OSq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbjI0OSk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 10:18:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD78FC;
        Wed, 27 Sep 2023 07:18:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D6EC433C8;
        Wed, 27 Sep 2023 14:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695824318;
        bh=NuiEFKy2TaqTCoWMvtNze3V7cRoGP6fplZo2KulM11s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mrx2QcR8mIqD1a0Fsc3CxGaEVB5ZRc3oFox24Ijltd97pj+vIj3d9TmRoi5Ap2Hdw
         5FlRDvcVyFmSGggTol9M07tcNmbJWzVA5A5eqF6mHV2P8X35UJf4tbCwD2im0ylerS
         dxTeWWohWUD0ERFgrg93vhqDn8safgwM8uqthEJ7DTCm+wepTABeBqvfNm4qBGBrDC
         BaPG2ooLgPBlnx8jUX0RX4ckvCKmO/VrNfKe+7yNIKSpiDyZJdFxO2x7PMDk/LLDOU
         VmUZNxAnhSuMoGjHOhHN9Sbki/3yC1HxWSNOxOnocQ/Sth4nSuHcmYNFCOCBtLt2hM
         ayBapyooCc0nA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: [PATCH v8 04/23] scsi: sd: Differentiate system and runtime start/stop management
Date:   Wed, 27 Sep 2023 23:18:09 +0900
Message-ID: <20230927141828.90288-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230927141828.90288-1-dlemoal@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The underlying device and driver of a SCSI disk may have different
system and runtime power mode control requirements. This is because
runtime power management affects only the SCSI disk, while sustem level
power management affects all devices, including the controller for the
SCSI disk.

For instance, issuing a START STOP UNIT command when a SCSI disk is
runtime suspended and resumed is fine: the command is translated to a
STANDBY IMMEDIATE command to spin down the ATA disk and to a VERIFY
command to wake it up. The SCSI disk runtime operations have no effect
on the ata port device used to connect the ATA disk. However, for
system suspend/resume operations, the ATA port used to connect the
device will also be suspended and resumed, with the resume operation
requiring re-validating the device link and the device itself. In this
case, issuing a VERIFY command to spinup the disk must be done before
starting to revalidate the device, when the ata port is being resumed.
In such case, we must not allow the SCSI disk driver to issue START STOP
UNIT commands.

Allow a low level driver to refine the SCSI disk start/stop management
by differentiating system and runtime cases with two new SCSI device
flags: manage_system_start_stop and manage_runtime_start_stop. These new
flags replace the current manage_start_stop flag. Drivers setting the
manage_start_stop are modifed to set both new flags, thus preserving the
existing start/stop management behavior. For backward compatibility, the
old manage_start_stop sysfs device attribute is kept as a read-only
attribute showing a value of 1 for devices enabling both new flags and 0
otherwise.

Fixes: 0a8589055936 ("ata,scsi: do not issue START STOP UNIT on resume")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-scsi.c  |  3 +-
 drivers/firewire/sbp2.c    |  9 ++--
 drivers/scsi/sd.c          | 90 ++++++++++++++++++++++++++++++--------
 include/scsi/scsi_device.h |  5 ++-
 4 files changed, 84 insertions(+), 23 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8b43290ca2cd..73428ad0c8d2 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1056,7 +1056,8 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
 		 * will be woken up by ata_port_pm_resume() with a port reset
 		 * and device revalidation.
 		 */
-		sdev->manage_start_stop = 1;
+		sdev->manage_system_start_stop = true;
+		sdev->manage_runtime_start_stop = true;
 		sdev->no_start_on_resume = 1;
 	}
 
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 26db5b8dfc1e..749868b9e80d 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -81,7 +81,8 @@ MODULE_PARM_DESC(exclusive_login, "Exclusive login to sbp2 device "
  *
  * - power condition
  *   Set the power condition field in the START STOP UNIT commands sent by
- *   sd_mod on suspend, resume, and shutdown (if manage_start_stop is on).
+ *   sd_mod on suspend, resume, and shutdown (if manage_system_start_stop or
+ *   manage_runtime_start_stop is on).
  *   Some disks need this to spin down or to resume properly.
  *
  * - override internal blacklist
@@ -1517,8 +1518,10 @@ static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
 
 	sdev->use_10_for_rw = 1;
 
-	if (sbp2_param_exclusive_login)
-		sdev->manage_start_stop = 1;
+	if (sbp2_param_exclusive_login) {
+		sdev->manage_system_start_stop = true;
+		sdev->manage_runtime_start_stop = true;
+	}
 
 	if (sdev->type == TYPE_ROM)
 		sdev->use_10_for_ms = 1;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c92a317ba547..a1ef4eef904f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -201,18 +201,32 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
-manage_start_stop_show(struct device *dev, struct device_attribute *attr,
-		       char *buf)
+manage_start_stop_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct scsi_device *sdp = sdkp->device;
 
-	return sprintf(buf, "%u\n", sdp->manage_start_stop);
+	return sprintf(buf, "%u\n",
+		       sdp->manage_system_start_stop &&
+		       sdp->manage_runtime_start_stop);
 }
+static DEVICE_ATTR_RO(manage_start_stop);
 
 static ssize_t
-manage_start_stop_store(struct device *dev, struct device_attribute *attr,
-			const char *buf, size_t count)
+manage_system_start_stop_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	struct scsi_device *sdp = sdkp->device;
+
+	return sprintf(buf, "%u\n", sdp->manage_system_start_stop);
+}
+
+static ssize_t
+manage_system_start_stop_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct scsi_device *sdp = sdkp->device;
@@ -224,11 +238,42 @@ manage_start_stop_store(struct device *dev, struct device_attribute *attr,
 	if (kstrtobool(buf, &v))
 		return -EINVAL;
 
-	sdp->manage_start_stop = v;
+	sdp->manage_system_start_stop = v;
 
 	return count;
 }
-static DEVICE_ATTR_RW(manage_start_stop);
+static DEVICE_ATTR_RW(manage_system_start_stop);
+
+static ssize_t
+manage_runtime_start_stop_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	struct scsi_device *sdp = sdkp->device;
+
+	return sprintf(buf, "%u\n", sdp->manage_runtime_start_stop);
+}
+
+static ssize_t
+manage_runtime_start_stop_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	struct scsi_device *sdp = sdkp->device;
+	bool v;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (kstrtobool(buf, &v))
+		return -EINVAL;
+
+	sdp->manage_runtime_start_stop = v;
+
+	return count;
+}
+static DEVICE_ATTR_RW(manage_runtime_start_stop);
 
 static ssize_t
 allow_restart_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -560,6 +605,8 @@ static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_FUA.attr,
 	&dev_attr_allow_restart.attr,
 	&dev_attr_manage_start_stop.attr,
+	&dev_attr_manage_system_start_stop.attr,
+	&dev_attr_manage_runtime_start_stop.attr,
 	&dev_attr_protection_type.attr,
 	&dev_attr_protection_mode.attr,
 	&dev_attr_app_tag_own.attr,
@@ -3771,13 +3818,20 @@ static void sd_shutdown(struct device *dev)
 		sd_sync_cache(sdkp, NULL);
 	}
 
-	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
+	if (system_state != SYSTEM_RESTART &&
+	    sdkp->device->manage_system_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
 }
 
-static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
+static inline bool sd_do_start_stop(struct scsi_device *sdev, bool runtime)
+{
+	return (sdev->manage_system_start_stop && !runtime) ||
+		(sdev->manage_runtime_start_stop && runtime);
+}
+
+static int sd_suspend_common(struct device *dev, bool runtime)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 	struct scsi_sense_hdr sshdr;
@@ -3809,12 +3863,12 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 		}
 	}
 
-	if (sdkp->device->manage_start_stop) {
+	if (sd_do_start_stop(sdkp->device, runtime)) {
 		if (!sdkp->device->silence_suspend)
 			sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		/* an error is not worth aborting a system sleep */
 		ret = sd_start_stop_device(sdkp, 0);
-		if (ignore_stop_errors)
+		if (!runtime)
 			ret = 0;
 	}
 
@@ -3826,23 +3880,23 @@ static int sd_suspend_system(struct device *dev)
 	if (pm_runtime_suspended(dev))
 		return 0;
 
-	return sd_suspend_common(dev, true);
+	return sd_suspend_common(dev, false);
 }
 
 static int sd_suspend_runtime(struct device *dev)
 {
-	return sd_suspend_common(dev, false);
+	return sd_suspend_common(dev, true);
 }
 
-static int sd_resume(struct device *dev)
+static int sd_resume(struct device *dev, bool runtime)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	int ret = 0;
+	int ret;
 
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
 
-	if (!sdkp->device->manage_start_stop)
+	if (!sd_do_start_stop(sdkp->device, runtime))
 		return 0;
 
 	if (!sdkp->device->no_start_on_resume) {
@@ -3860,7 +3914,7 @@ static int sd_resume_system(struct device *dev)
 	if (pm_runtime_suspended(dev))
 		return 0;
 
-	return sd_resume(dev);
+	return sd_resume(dev, false);
 }
 
 static int sd_resume_runtime(struct device *dev)
@@ -3887,7 +3941,7 @@ static int sd_resume_runtime(struct device *dev)
 				  "Failed to clear sense data\n");
 	}
 
-	return sd_resume(dev);
+	return sd_resume(dev, true);
 }
 
 static const struct dev_pm_ops sd_pm_ops = {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index b9230b6add04..fd41fdac0a8e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -161,6 +161,10 @@ struct scsi_device {
 				 * pass settings from slave_alloc to scsi
 				 * core. */
 	unsigned int eh_timeout; /* Error handling timeout */
+
+	bool manage_system_start_stop; /* Let HLD (sd) manage system start/stop */
+	bool manage_runtime_start_stop; /* Let HLD (sd) manage runtime start/stop */
+
 	unsigned removable:1;
 	unsigned changed:1;	/* Data invalid due to media change */
 	unsigned busy:1;	/* Used to prevent races */
@@ -193,7 +197,6 @@ struct scsi_device {
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
-	unsigned manage_start_stop:1;	/* Let HLD (sd) manage start/stop */
 	unsigned no_start_on_resume:1; /* Do not issue START_STOP_UNIT on resume */
 	unsigned start_stop_pwr_cond:1;	/* Set power cond. in START_STOP_UNIT */
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
-- 
2.41.0

