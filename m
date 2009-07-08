From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 0/3] scsi_dh: Make scsi device handler modules	automatically
 inserted
Date: Wed, 08 Jul 2009 14:33:01 -0400
Message-ID: <4A54E65D.8050706@redhat.com>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu> <4A369320.2080202@redhat.com> <1245365306.4286.27.camel@mulgrave.site> <4A3BDFE8.3090003@redhat.com> <4A44D37A.10903@redhat.com> <1246986723.6277.63.camel@mulgrave.site> <4A538B13.8050809@redhat.com> <1246990464.6277.74.camel@mulgrave.site> <1246995401.9541.15.camel@chandra-ubuntu> <20090708155808.GA31204@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38101 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbZGHSdW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2009 14:33:22 -0400
In-Reply-To: <20090708155808.GA31204@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: sekharan@linux.vnet.ibm.com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hare@suse.de

On 07/08/2009 11:58 AM, Christoph Hellwig wrote:
> On Tue, Jul 07, 2009 at 12:36:41PM -0700, Chandra Seetharaman wrote:
>> I do not know of all the out-of-tree multipath solutions and how they
>> behave and at what layer they interact. In effect, I haven't tested
>> hardware handler with other multipath solutions.
> 
> It doesn't matter anyway.  We've never cared about these out of tree
> problems and they'll have to find a way by themselves to deal with any
> changes we do to offer better multipath support upstream.

That's definitely how I feel about it, but James apparently disagrees.
Anyway, to alleviate some of his concerns, here's a different starting
point that maybe we could work from.  James, tell me how you feel about
this?

From: Peter Jones <pjones@redhat.com>
Date: Tue, 7 Jul 2009 15:08:00 -0400
Subject: [PATCH] Add scsi device and vendor IDs to scsi target modaliases.

This patch adds scsi device and vendor IDs to scsi target modaliases,
including the corresponding uevents and sysfs modalias file.

This behavior is conditional on the module parameter
scsi_mod.target_modalias_has_vendor, which has its default set by the
enabling or disabling of CONFIG_SCSI_TARGET_MODALIAS_WITH_ID .
---
 drivers/scsi/Kconfig           |   10 +++++
 drivers/scsi/scsi_sysfs.c      |   72 ++++++++++++++++++++++++++++++++++++++-
 include/linux/string_helpers.h |    2 +
 include/scsi/scsi_device.h     |    1 -
 lib/string_helpers.c           |   32 ++++++++++++++++++
 5 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9c23122..b18c329 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -239,6 +239,16 @@ config SCSI_LOGGING
 	  there should be no noticeable performance impact as long as you have
 	  logging turned off.
 
+config SCSI_TARGET_MODALIAS_WITH_ID
+	bool "Include vendor/device IDs in SCSI target modalias strings"
+	default n
+	depends on SCSI
+	help
+	  The SCSI subsystem can present modalias strings for SCSI target
+	  devices either with or without vendor and device ID data.
+	  This is experimental, and make cause undesirable interactions with
+	  some device management programs.
+
 config SCSI_SCAN_ASYNC
 	bool "Asynchronous SCSI scanning"
 	depends on SCSI
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 91482f2..af4030c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/device.h>
+#include <linux/string_helpers.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -362,16 +363,80 @@ static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
 	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
 }
 
+#ifdef CONFIG_SCSI_TARGET_MODALIAS_WITH_ID
+static unsigned int scsi_target_modalias_has_vendor = 1;
+#else
+static unsigned int scsi_target_modalias_has_vendor = 0;
+#endif
+
+module_param_named(target_modalias_has_vendor, scsi_target_modalias_has_vendor,
+		   uint, S_IRUGO|S_IWUSR);
+MODULE_PARAM_DESC(target_modalias_has_vendor, "control presense of vendor and device ID in scsi target modaliases");
+
+static ssize_t format_scsi_modalias(struct scsi_device *sdev, char *buffer,
+				    ssize_t len)
+{
+	int i = 0;
+
+	if (scsi_target_modalias_has_vendor) {
+		int j;
+		char vendor[9];
+		char *hex_vendor;
+		char model[17];
+		char *hex_model;
+	
+		strncpy(vendor, sdev->vendor, 8);
+		vendor[8] = '\0';
+		for (j = strlen(vendor) - 1; j >= 0; j--) {
+			if (vendor[j] != ' ')
+				break;
+			vendor[j] = '\0';
+		}
+		hex_vendor = string_to_hex(vendor);
+		if (!hex_vendor)
+			return -ENOMEM;
+	
+		strncpy(model, sdev->model, 16);
+		model[8] = '\0';
+		for (j = strlen(model) - 1; j >= 0; j--) {
+			if (model[j] != ' ')
+				break;
+			model[j] = '\0';
+		}
+		hex_model = string_to_hex(model);
+		if (!hex_model) {
+			kfree(hex_vendor);
+			return -ENOMEM;
+		}
+	
+		i = snprintf(buffer, len, "scsi:t-0x%02xv%.16sm%.32s",
+			sdev->type, hex_vendor, hex_model);
+		kfree(hex_vendor);
+		kfree(hex_model);
+	} else {
+		i = snprintf(buffer, len, "scsi:t-0x%02x" sdev->type);
+	}
+
+	return i;
+}
+
 static int scsi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct scsi_device *sdev;
+	char buffer[501];
+	int rc;
 
 	if (dev->type != &scsi_dev_type)
 		return 0;
 
 	sdev = to_scsi_device(dev);
 
-	add_uevent_var(env, "MODALIAS=" SCSI_DEVICE_MODALIAS_FMT, sdev->type);
+	buffer[500] = '\0';
+	rc = format_scsi_modalias(sdev, buffer, 500);
+	if (rc < 0)
+		return rc;
+
+	add_uevent_var(env, "MODALIAS=%s", buffer);
 	return 0;
 }
 
@@ -680,8 +745,11 @@ static ssize_t
 sdev_show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev;
+	ssize_t rc;
+
 	sdev = to_scsi_device(dev);
-	return snprintf (buf, 20, SCSI_DEVICE_MODALIAS_FMT "\n", sdev->type);
+	rc = format_scsi_modalias(sdev, buf, 500);
+	return rc;
 }
 static DEVICE_ATTR(modalias, S_IRUGO, sdev_show_modalias, NULL);
 
diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index a3eb2f6..46a7594 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -13,4 +13,6 @@ enum string_size_units {
 int string_get_size(u64 size, enum string_size_units units,
 		    char *buf, int len);
 
+unsigned char *string_to_hex(const unsigned char *s);
+
 #endif
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3f566af..ffa7746 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -452,6 +452,5 @@ static inline int scsi_device_protection(struct scsi_device *sdev)
 
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
-#define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
 
 #endif /* _SCSI_SCSI_DEVICE_H */
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index ab431d4..2ecd500 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -66,3 +66,35 @@ int string_get_size(u64 size, const enum string_size_units units,
 	return 0;
 }
 EXPORT_SYMBOL(string_get_size);
+
+/**
+ * string_to_hex - convert a string to a series of hexidecimal values
+ * @s:	The string to operate on
+ *
+ * This function returns a GFP_KERNEL allocated buffer filled with
+ * the hexidecimal representation of the value of each character in @s .
+ * Returns a pointer to the allocated string on success and NULL on error,
+ * and the returned string is zero terminated.
+ *
+ */
+unsigned char *string_to_hex(const unsigned char *s)
+{
+	unsigned char *ret, *ptr;
+	static const unsigned char *hex = "0123456789ABCDEF";
+	int len;
+
+	len = strlen(s);
+
+	ret = ptr = kmalloc(len * 2 + 1, GFP_KERNEL);
+	if (!ret)
+		return NULL;
+
+	for (; *s; s++) {
+		*ptr++ = hex[(*s & 0xf0)>>4];
+		*ptr++ = hex[*s & 0x0f];
+	}
+	*ptr = '\0';
+
+	return ret;
+}
+EXPORT_SYMBOL(string_to_hex);
-- 
1.6.2.2

-- 
        Peter

Growth for the sake of growth is the ideology of the cancer cell.
