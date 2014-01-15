From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 29/41] hpsa: allow user to disable accelerated i/o path
Date: Wed, 15 Jan 2014 16:38:47 -0600
Message-ID: <20140115223847.5061.56685.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:45658 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaAOViu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:38:50 -0500
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Scott Teel <scott.teel@hp.com>

Allow SSD Smart Path for a controller to be disabled by
the user, regardless of settings in controller firmware
or array configuration.

To disable:     echo 0 > /sys/class/scsi_host/host<id>/acciopath_status
To re-enable:   echo 1 > /sys/class/scsi_host/host<id>/acciopath_status
To check state: cat /sys/class/scsi_host/host<id>/acciopath_status

Signed-off-by: Scott Teel <scott.teel@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 Documentation/ABI/testing/sysfs-class-scsi_host |   16 ++++++++
 drivers/scsi/hpsa.c                             |   45 ++++++++++++++++++++++-
 drivers/scsi/hpsa.h                             |    1 +
 3 files changed, 61 insertions(+), 1 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-scsi_host b/Documentation/ABI/testing/sysfs-class-scsi_host
index 29a4f89..0eb255e 100644
--- a/Documentation/ABI/testing/sysfs-class-scsi_host
+++ b/Documentation/ABI/testing/sysfs-class-scsi_host
@@ -11,3 +11,19 @@ Description:
 		guaranteed.  The 'isci_id' attribute unambiguously identifies
 		the controller index: '0' for the first controller,
 		'1' for the second.
+
+What:		/sys/class/scsi_host/hostX/acciopath_status
+Date:		November 2013
+Contact:	Stephen M. Cameron <scameron@beardog.cce.hp.com>
+Description:	This file contains the current status of the "SSD Smart Path"
+		feature of HP Smart Array RAID controllers using the hpsa
+		driver.  SSD Smart Path, when enabled permits the driver to
+		send i/o requests directly to physical devices that are part
+		of a logical drive, bypassing the controllers firmware RAID
+		stack for a performance advantage when possible.  A value of
+		'1' indicates the feature is enabled, and the controller may
+		use the direct i/o path to physical devices.  A value of zero
+		means the feature is disabled and the controller may not use
+		the direct i/o path to physical devices.  This setting is
+		controller wide, affecting all configured logical drives on the
+		controller.  This file is readable and writable.
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0109bf7..8e357f0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -287,6 +287,30 @@ static int check_for_busy(struct ctlr_info *h, struct CommandList *c)
 	return 1;
 }
 
+static ssize_t host_store_hp_ssd_smart_path_status(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	int status, len;
+	struct ctlr_info *h;
+	struct Scsi_Host *shost = class_to_shost(dev);
+	char tmpbuf[10];
+
+	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+		return -EACCES;
+	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
+	strncpy(tmpbuf, buf, len);
+	tmpbuf[len] = '\0';
+	if (sscanf(tmpbuf, "%d", &status) != 1)
+		return -EINVAL;
+	h = shost_to_hba(shost);
+	h->acciopath_status = !!status;
+	dev_warn(&h->pdev->dev,
+		"hpsa: HP SSD Smart Path %s via sysfs update.\n",
+		h->acciopath_status ? "enabled" : "disabled");
+	return count;
+}
+
 static ssize_t host_store_rescan(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
@@ -334,6 +358,17 @@ static ssize_t host_show_transport_mode(struct device *dev,
 			"performant" : "simple");
 }
 
+static ssize_t host_show_hp_ssd_smart_path_status(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct ctlr_info *h;
+	struct Scsi_Host *shost = class_to_shost(dev);
+
+	h = shost_to_hba(shost);
+	return snprintf(buf, 30, "HP SSD Smart Path %s\n",
+		(h->acciopath_status == 1) ?  "enabled" : "disabled");
+}
+
 /* List of controllers which cannot be hard reset on kexec with reset_devices */
 static u32 unresettable_controller[] = {
 	0x324a103C, /* Smart Array P712m */
@@ -546,6 +581,9 @@ static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 static DEVICE_ATTR(hp_ssd_smart_path_enabled, S_IRUGO,
 			host_show_hp_ssd_smart_path_enabled, NULL);
+static DEVICE_ATTR(hp_ssd_smart_path_status, S_IWUSR|S_IRUGO|S_IROTH,
+		host_show_hp_ssd_smart_path_status,
+		host_store_hp_ssd_smart_path_status);
 static DEVICE_ATTR(firmware_revision, S_IRUGO,
 	host_show_firmware_revision, NULL);
 static DEVICE_ATTR(commands_outstanding, S_IRUGO,
@@ -569,6 +607,7 @@ static struct device_attribute *hpsa_shost_attrs[] = {
 	&dev_attr_commands_outstanding,
 	&dev_attr_transport_mode,
 	&dev_attr_resettable,
+	&dev_attr_hp_ssd_smart_path_status,
 	NULL,
 };
 
@@ -3347,7 +3386,8 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
 	 * Retries always go down the normal I/O path.
 	 */
 	if (likely(cmd->retries == 0 &&
-		cmd->request->cmd_type == REQ_TYPE_FS)) {
+		cmd->request->cmd_type == REQ_TYPE_FS &&
+		h->acciopath_status)) {
 		if (dev->offload_enabled) {
 			rc = hpsa_scsi_ioaccel_raid_map(h, c);
 			if (rc == 0)
@@ -6333,6 +6373,9 @@ reinit_after_soft_reset:
 		goto reinit_after_soft_reset;
 	}
 
+	/* Enable Accelerated IO path at driver layer */
+	h->acciopath_status = 1;
+
 	/* Turn the interrupts on so we can service requests */
 	h->access.set_intr_mask(h, HPSA_INTR_ON);
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 45bb1ea..1d3340d 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -181,6 +181,7 @@ struct ctlr_info {
 #define HPSATMF_LOG_QRY_TSET    (1 << 24)
 #define HPSATMF_LOG_QRY_ASYNC   (1 << 25)
 	u32 events;
+	int	acciopath_status;
 };
 #define HPSA_ABORT_MSG 0
 #define HPSA_DEVICE_RESET_MSG 1

