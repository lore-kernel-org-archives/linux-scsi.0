From: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Subject: [PATCH 1/3] Allow SCSI hosts to be less verbose
Date: Sun, 20 Sep 2009 16:56:39 -0600
Message-ID: <20090920225639.GD3690@parisc-linux.org>
References: <20090920225348.GB3690@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090920225348.GB3690-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Introduce a 'quiet' flag in the scsi_host_template which drivers can
set to prevent (in the first instance) printing their name when they
register with the SCSI core.  Set the quiet flag in the USB Storage
driver.

Signed-off-by: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/scsi/hosts.c           |    3 ++-
 drivers/usb/storage/scsiglue.c |    3 +++
 include/scsi/scsi_host.h       |    3 +++
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 5fd2da4..7741f1d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -192,7 +192,8 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
 	struct scsi_host_template *sht = shost->hostt;
 	int error = -EINVAL;
 
-	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
+	if (!sht->quiet)
+		printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
 			sht->info ? sht->info(shost) : sht->name);
 
 	if (!shost->can_queue) {
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index cfa26d5..781fb6d 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -555,6 +555,9 @@ struct scsi_host_template usb_stor_host_template = {
 	/* we do our own delay after a device or bus reset */
 	.skip_settle_delay =		1,
 
+	/* We don't need the scsi midlayer to print our name */
+	.quiet =			1,
+
 	/* sysfs device attributes */
 	.sdev_attrs =			sysfs_device_attr_list,
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b62a097..baa527c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -446,6 +446,9 @@ struct scsi_host_template {
 	 */
 	unsigned ordered_tag:1;
 
+	/* Be less verbose */
+	unsigned quiet:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
-- 
1.6.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
