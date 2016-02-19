From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv8 20/23] scsi: Add 'access_state' attribute
Date: Fri, 19 Feb 2016 11:10:02 -0800
Message-ID: <56C7688A.2050608@sandisk.com>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
 <1455869840-122786-21-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0059.outbound.protection.outlook.com ([157.56.110.59]:2147
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030273AbcBSTKG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2016 14:10:06 -0500
In-Reply-To: <1455869840-122786-21-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 02/19/2016 12:17 AM, Hannes Reinecke wrote:
> +static ssize_t
> +sdev_show_access_state(struct device *dev,
> +		       struct device_attribute *attr,
> +		       char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	unsigned char access_state;
> +	const char *access_state_name;
> +	bool pref = false;
> +
> +	if (!sdev->handler)
> +		return -EINVAL;
> +
> +	if (sdev->access_state & SCSI_ACCESS_STATE_PREFERRED)
> +		pref = true;
> +
> +	access_state = (sdev->access_state & SCSI_ACCESS_STATE_MASK);
> +	access_state_name = scsi_access_state_name(access_state);
> +
> +	return snprintf(buf, 32, "%s%s\n",
> +			access_state_name ? access_state_name : "unknown",
> +			pref ? " preferred" : "");
> +}

Hello Hannes,

What is inelegant about the above approach is that the access_state attribute
is added to all SCSI devices, whether or not a device handler has been attached,
and that reading that attribute doesn't fail for devices to which another handler
than the ALUA handler has been attached. How about the patch below, which moves
the access_state show handler to the scsi_dh_alua.c source file, where it belongs?

[PATCH] Restrict access_state attribute to devices that support ALUA

---
 drivers/scsi/device_handler/scsi_dh_alua.c | 52 +++++++++++++++++++++++++++++
 drivers/scsi/scsi_dh.c                     | 14 ++++++++
 drivers/scsi/scsi_sysfs.c                  | 53 ------------------------------
 include/scsi/scsi_dh.h                     |  1 +
 4 files changed, 67 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 5bcdf8d..e64f6f6 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1121,6 +1121,57 @@ static void alua_bus_detach(struct scsi_device *sdev)
 	kfree(h);
 }
 
+static const struct {
+	unsigned char	value;
+	const char	*name;
+} sdev_access_states[] = {
+	{ SCSI_ACCESS_STATE_OPTIMAL,		"active/optimized" },
+	{ SCSI_ACCESS_STATE_ACTIVE,		"active/non-optimized" },
+	{ SCSI_ACCESS_STATE_STANDBY,		"standby" },
+	{ SCSI_ACCESS_STATE_UNAVAILABLE,	"unavailable" },
+	{ SCSI_ACCESS_STATE_LBA,		"lba-dependent" },
+	{ SCSI_ACCESS_STATE_OFFLINE,		"offline" },
+	{ SCSI_ACCESS_STATE_TRANSITIONING,	"transitioning" },
+};
+
+const char *scsi_access_state_name(unsigned char state)
+{
+	int i;
+	const char *name = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(sdev_access_states); i++) {
+		if (sdev_access_states[i].value == state) {
+			name = sdev_access_states[i].name;
+			break;
+		}
+	}
+	return name;
+}
+
+static ssize_t
+sdev_show_access_state(struct device *dev,
+		       struct device_attribute *attr,
+		       char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	unsigned char access_state;
+	const char *access_state_name;
+	bool pref = sdev->access_state & SCSI_ACCESS_STATE_PREFERRED;
+
+	access_state = sdev->access_state & SCSI_ACCESS_STATE_MASK;
+	access_state_name = scsi_access_state_name(access_state);
+
+	return snprintf(buf, 32, "%s%s\n",
+			access_state_name ? access_state_name : "unknown",
+			pref ? " preferred" : "");
+}
+static DEVICE_ATTR(access_state, S_IRUGO, sdev_show_access_state, NULL);
+
+static const struct attribute *alua_attrs[] = {
+	&dev_attr_access_state.attr,
+	NULL
+};
+
 static struct scsi_device_handler alua_dh = {
 	.name = ALUA_DH_NAME,
 	.module = THIS_MODULE,
@@ -1131,6 +1182,7 @@ static struct scsi_device_handler alua_dh = {
 	.activate = alua_activate,
 	.rescan = alua_rescan,
 	.set_params = alua_set_params,
+	.attrs = alua_attrs,
 };
 
 static int __init alua_init(void)
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 54d446c..73cab23 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -164,6 +167,17 @@ int scsi_dh_add_device(struct scsi_device *sdev)
 		devinfo = __scsi_dh_lookup(drv);
 	if (devinfo)
 		err = scsi_dh_handler_attach(sdev, devinfo);
+	if (err == 0 && sdev->handler && sdev->handler->attrs) {
+		err = sysfs_create_files(&sdev->sdev_gendev.kobj,
+					 sdev->handler->attrs);
+		if (err) {
+			sdev_printk(KERN_INFO, sdev,
+			"failed to add device handler sysfs attributes: %d\n",
+				    err);
+			scsi_dh_handler_detach(sdev);
+		}
+	}
+
 	return err;
 }
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 8551707..00bc721 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -81,33 +81,6 @@ const char *scsi_host_state_name(enum scsi_host_state state)
 	return name;
 }
 
-static const struct {
-	unsigned char	value;
-	char		*name;
-} sdev_access_states[] = {
-	{ SCSI_ACCESS_STATE_OPTIMAL, "active/optimized" },
-	{ SCSI_ACCESS_STATE_ACTIVE, "active/non-optimized" },
-	{ SCSI_ACCESS_STATE_STANDBY, "standby" },
-	{ SCSI_ACCESS_STATE_UNAVAILABLE, "unavailable" },
-	{ SCSI_ACCESS_STATE_LBA, "lba-dependent" },
-	{ SCSI_ACCESS_STATE_OFFLINE, "offline" },
-	{ SCSI_ACCESS_STATE_TRANSITIONING, "transitioning" },
-};
-
-const char *scsi_access_state_name(unsigned char state)
-{
-	int i;
-	char *name = NULL;
-
-	for (i = 0; i < ARRAY_SIZE(sdev_access_states); i++) {
-		if (sdev_access_states[i].value == state) {
-			name = sdev_access_states[i].name;
-			break;
-		}
-	}
-	return name;
-}
-
 static int check_set(unsigned long long *val, char *src)
 {
 	char *last;
@@ -1000,31 +973,6 @@ sdev_store_dh_state(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(dh_state, S_IRUGO | S_IWUSR, sdev_show_dh_state,
 		   sdev_store_dh_state);
-
-static ssize_t
-sdev_show_access_state(struct device *dev,
-		       struct device_attribute *attr,
-		       char *buf)
-{
-	struct scsi_device *sdev = to_scsi_device(dev);
-	unsigned char access_state;
-	const char *access_state_name;
-	bool pref = false;
-
-	if (!sdev->handler)
-		return -EINVAL;
-
-	if (sdev->access_state & SCSI_ACCESS_STATE_PREFERRED)
-		pref = true;
-
-	access_state = (sdev->access_state & SCSI_ACCESS_STATE_MASK);
-	access_state_name = scsi_access_state_name(access_state);
-
-	return snprintf(buf, 32, "%s%s\n",
-			access_state_name ? access_state_name : "unknown",
-			pref ? " preferred" : "");
-}
-static DEVICE_ATTR(access_state, S_IRUGO, sdev_show_access_state, NULL);
 #endif
 
 static ssize_t
@@ -1099,7 +1047,6 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_wwid.attr,
 #ifdef CONFIG_SCSI_DH
 	&dev_attr_dh_state.attr,
-	&dev_attr_access_state.attr,
 #endif
 	&dev_attr_queue_ramp_up_period.attr,
 	REF_EVT(media_change),
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index c7bba2b..4a600c6 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -72,6 +72,7 @@ struct scsi_device_handler {
 	int (*prep_fn)(struct scsi_device *, struct request *);
 	int (*set_params)(struct scsi_device *, const char *);
 	void (*rescan)(struct scsi_device *);
+	const struct attribute **attrs;
 };
 
 #ifdef CONFIG_SCSI_DH
-- 
2.7.1


