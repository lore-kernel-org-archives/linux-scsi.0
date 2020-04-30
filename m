Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76B6C83010
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B92B12076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgD3NUN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:60694 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbgD3NUG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 274A1AF19;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 10/41] scsi: make host device a first-class citizen
Date:   Thu, 30 Apr 2020 15:18:33 +0200
Message-Id: <20200430131904.5847-11-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rather than having the device created by scsi_get_host_dev() as
a weird semi-initialized device make it a first class citizen by
implementing a minimal command emulation and provide (static)
inquiry data.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c    | 24 +++++++++++++++++++
 drivers/scsi/scsi_scan.c   | 60 +++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/scsi_sysfs.c  |  3 ++-
 include/scsi/scsi_device.h |  1 +
 include/scsi/scsi_host.h   |  3 +++
 5 files changed, 76 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 30f9ca9fce22..ce9f1d83aaee 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1528,6 +1528,30 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 
 	}
 
+	if (unlikely(scsi_device_is_virtual(cmd->device))) {
+		unsigned char null_report_luns[16];
+
+		switch (cmd->cmnd[0]) {
+		case TEST_UNIT_READY:
+			cmd->result = (DID_OK << 16);
+			goto done;
+		case INQUIRY:
+			scsi_sg_copy_from_buffer(cmd, cmd->device->inquiry, 36);
+			cmd->result = (DID_OK << 16);
+			goto done;
+		case REPORT_LUNS:
+			memset(null_report_luns, 0, 16);
+			null_report_luns[3] = 0x08;
+			scsi_sg_copy_from_buffer(cmd, null_report_luns, 16);
+			cmd->result = (DID_OK << 16);
+			goto done;
+		default:
+			scsi_build_sense_buffer(0, cmd->sense_buffer,
+						ILLEGAL_REQUEST, 0x20, 0x00);
+			cmd->result = (DID_NO_CONNECT << 16);
+			goto done;
+		}
+	}
 	trace_scsi_dispatch_cmd_start(cmd);
 	rtn = host->hostt->queuecommand(host, cmd);
 	if (rtn) {
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4648fd3f80d9..fdc291c47b9b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1080,6 +1080,9 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	if (!sdev)
 		goto out;
 
+	if (sdev->hidden)
+		return SCSI_SCAN_LUN_PRESENT;
+
 	result = kmalloc(result_len, GFP_KERNEL |
 			((shost->unchecked_isa_dma) ? __GFP_DMA : 0));
 	if (!result)
@@ -1325,6 +1328,8 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 		sdev = scsi_alloc_sdev(starget, 0, NULL);
 		if (!sdev)
 			return 0;
+		if (sdev->hidden)
+			return 0;
 		if (scsi_device_get(sdev)) {
 			__scsi_remove_device(sdev);
 			return 0;
@@ -1698,6 +1703,8 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 		/* If device is already visible, skip adding it to sysfs */
 		if (sdev->is_visible)
 			continue;
+		if (sdev->hidden)
+			continue;
 		if (!scsi_host_scan_allowed(shost) ||
 		    scsi_sysfs_add_sdev(sdev) != 0)
 			__scsi_remove_device(sdev);
@@ -1861,39 +1868,48 @@ EXPORT_SYMBOL(scsi_scan_host);
 
 void scsi_forget_host(struct Scsi_Host *shost)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev, *virtual_sdev = NULL;
 	unsigned long flags;
 
  restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
+		if (scsi_device_is_virtual(sdev)) {
+			virtual_sdev = sdev;
+			continue;
+		}
 		if (sdev->sdev_state == SDEV_DEL)
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		__scsi_remove_device(sdev);
 		goto restart;
 	}
+	/* Remove virtual device last, might be needed to send commands */
+	if (virtual_sdev)
+		__scsi_remove_device(virtual_sdev);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 /**
- * scsi_get_host_dev - Create a scsi_device that points to the host adapter itself
+ * scsi_get_virtual_dev - Create a virtual scsi_device to the host adapter
  * @shost: Host that needs a scsi_device
+ * @channel: SCSI channel number for the virtual device
+ * @id: SCSI target number for the virtual device
  *
  * Lock status: None assumed.
  *
  * Returns:     The scsi_device or NULL
  *
  * Notes:
- *	Attach a single scsi_device to the Scsi_Host - this should
- *	be made to look like a "pseudo-device" that points to the
- *	HA itself.
- *
- *	Note - this device is not accessible from any high-level
- *	drivers (including generics), which is probably not
- *	optimal.  We can add hooks later to attach.
+ *	Attach a single scsi_device to the Scsi_Host. This device
+ *	has a minimal command emulation, but will never submit commands
+ *	to the LLDD. The primary aim for this device is to serve as a
+ *	container from which command tags can be allocated from; each
+ *	scsi command will carry an unused/free command tag, which then
+ *	can be used by the LLDD to format internal or passthrough commands.
  */
-struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
+struct scsi_device *scsi_get_virtual_dev(struct Scsi_Host *shost,
+	 unsigned int channel, unsigned int id)
 {
 	struct scsi_device *sdev = NULL;
 	struct scsi_target *starget;
@@ -1901,22 +1917,38 @@ struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 	mutex_lock(&shost->scan_mutex);
 	if (!scsi_host_scan_allowed(shost))
 		goto out;
-	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
+	starget = scsi_alloc_target(&shost->shost_gendev, channel, id);
 	if (!starget)
 		goto out;
 
 	sdev = scsi_alloc_sdev(starget, 0, NULL);
-	if (sdev)
+	if (sdev) {
 		sdev->borken = 0;
-	else
+		sdev->hidden = 1;
+		sdev->inquiry = (unsigned char *)scsi_null_inquiry;
+		sdev->inquiry_len = sizeof(scsi_null_inquiry);
+		scsi_device_set_state(sdev, SDEV_RUNNING);
+	} else
 		scsi_target_reap(starget);
 	put_device(&starget->dev);
  out:
 	mutex_unlock(&shost->scan_mutex);
 	return sdev;
 }
+EXPORT_SYMBOL_GPL(scsi_get_virtual_dev);
+
+struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
+{
+	return scsi_get_virtual_dev(shost, 0, shost->this_id);
+}
 EXPORT_SYMBOL(scsi_get_host_dev);
 
+bool scsi_device_is_virtual(struct scsi_device *sdev)
+{
+	return ((const unsigned char *)sdev->inquiry == scsi_null_inquiry);
+}
+EXPORT_SYMBOL_GPL(scsi_device_is_virtual);
+
 /**
  * scsi_free_host_dev - Free a scsi_device that points to the host adapter itself
  * @sdev: Host device to be freed
@@ -1927,7 +1959,7 @@ EXPORT_SYMBOL(scsi_get_host_dev);
  */
 void scsi_free_host_dev(struct scsi_device *sdev)
 {
-	BUG_ON(sdev->id != sdev->host->this_id);
+	BUG_ON(!scsi_device_is_virtual(sdev));
 
 	__scsi_remove_device(sdev);
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 163dbcb741c1..c54011c2cdda 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -485,7 +485,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 		kfree_rcu(vpd_pg80, rcu);
 	if (vpd_pg89)
 		kfree_rcu(vpd_pg89, rcu);
-	kfree(sdev->inquiry);
+	if (!scsi_device_is_virtual(sdev))
+		kfree(sdev->inquiry);
 	kfree(sdev);
 
 	if (parent)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e74c7e671aa0..6039ce7d09d7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -203,6 +203,7 @@ struct scsi_device {
 	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit for WRITE SAME */
 	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend at device
 					 * creation time */
+	unsigned hidden:1;		/* Do not register with sysfs */
 
 	bool offline_already;		/* Device offline message logged */
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 37bb7d74e4c4..6961cbc3b2c0 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -781,7 +781,10 @@ struct class_container;
  * from any high-level drivers.
  */
 extern void scsi_free_host_dev(struct scsi_device *);
+extern struct scsi_device *scsi_get_virtual_dev(struct Scsi_Host *,
+						unsigned int, unsigned int);
 extern struct scsi_device *scsi_get_host_dev(struct Scsi_Host *);
+extern bool scsi_device_is_virtual(struct scsi_device *);
 
 /*
  * DIF defines the exchange of protection information between
-- 
2.16.4

