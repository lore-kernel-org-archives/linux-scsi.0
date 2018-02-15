From: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH v6 08/11] scsi: host template attribute groups
Date: Thu, 15 Feb 2018 14:14:08 +0200
Message-ID: <1518696851-6730-9-git-send-email-stanislav.nijnikov@wdc.com>
References: <1518696851-6730-1-git-send-email-stanislav.nijnikov@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518696851-6730-1-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, jaegeuk@kernel.org, Bart.VanAssche@wdc.com
Cc: alex.lemberg@wdc.com, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
List-Id: linux-scsi@vger.kernel.org

The patch introduces an additional field in the scsi_host_template
structure - struct attribute_group **sdev_group.
This field allows to define groups of attributes. It will provide an
ability to use binary attributes as well as device attributes and
to group them under subfolders if necessary.

Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_sysfs.c | 12 ++++++++++++
 include/scsi/scsi_host.h  |  6 ++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index cbc0fe2..d608759 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1309,6 +1309,13 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		}
 	}
 
+	if (sdev->host->hostt->sdev_groups) {
+		error = sysfs_create_groups(&sdev->sdev_gendev.kobj,
+				sdev->host->hostt->sdev_groups);
+		if (error)
+			return error;
+	}
+
 	scsi_autopm_put_device(sdev);
 	return error;
 }
@@ -1326,6 +1333,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	if (sdev->sdev_state == SDEV_DEL)
 		return;
 
+
 	if (sdev->is_visible) {
 		/*
 		 * If scsi_internal_target_block() is running concurrently,
@@ -1348,6 +1356,10 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		if (res != 0)
 			return;
 
+		if (sdev->host->hostt->sdev_groups)
+			sysfs_remove_groups(&sdev->sdev_gendev.kobj,
+					sdev->host->hostt->sdev_groups);
+
 		bsg_unregister_queue(sdev->request_queue);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 1a1df0d..1931758 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -477,6 +477,12 @@ struct scsi_host_template {
 	struct device_attribute **sdev_attrs;
 
 	/*
+	 * Pointer to the SCSI device attribute groups for this host,
+	 * NULL terminated.
+	 */
+	const struct attribute_group **sdev_groups;
+
+	/*
 	 * List of hosts per template.
 	 *
 	 * This is only for use by scsi_module.c for legacy templates.
-- 
2.7.4
