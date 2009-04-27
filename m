From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Mon, 27 Apr 2009 11:06:15 -0700
Message-ID: <20090427180615.22758.42750.sendpatchset@chandra-ubuntu>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:44371 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbZD0SF1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 14:05:27 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3RHxpEN031619
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 11:59:51 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3RI5On0045500
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 12:05:24 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3RI5NMA011485
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 12:05:23 -0600
In-Reply-To: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, hare@suse.de, Chandra Seetharaman <sekharan@us.ibm.com>

From: Peter Jones <pjones@redhat.com>

This patch allows the use of modaliases on scsi targets to correctly
load scsi device handler modules when the devices are found.

Signed-off-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Acked-by: Hannes Reinecke <hare@suse.de>

---
 drivers/scsi/scsi_sysfs.c       |   55 +++++++++++++++++++++++++++++++++++++++-
 include/linux/mod_devicetable.h |    6 ++++
 include/linux/string_helpers.h  |    2 +
 include/scsi/scsi.h             |    1 +
 include/scsi/scsi_device.h      |    9 +-----
 lib/string_helpers.c            |   32 +++++++++++++++++++++++
 scripts/mod/file2alias.c        |   38 ++++++++++++++++++++++++++++
 7 files changed, 134 insertions(+), 9 deletions(-)

Index: linux-2.6.29/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/scsi_sysfs.c
+++ linux-2.6.29/drivers/scsi/scsi_sysfs.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/device.h>
+#include <linux/string_helpers.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -362,16 +363,63 @@ static int scsi_bus_match(struct device
 	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
 }
 
+static ssize_t format_scsi_modalias(struct scsi_device *sdev, char *buffer,
+				    ssize_t len)
+{
+	char vendor[9];
+	char *hex_vendor;
+	char model[17];
+	char *hex_model;
+	int i;
+
+	strncpy(vendor, sdev->vendor, 8);
+	vendor[8] = '\0';
+	for (i = strlen(vendor) - 1; i >= 0; i--) {
+		if (vendor[i] != ' ')
+			break;
+		vendor[i] = '\0';
+	}
+	hex_vendor = string_to_hex(vendor);
+	if (!hex_vendor)
+		return -ENOMEM;
+
+	strncpy(model, sdev->model, 16);
+	model[8] = '\0';
+	for (i = strlen(model) - 1; i >= 0; i--) {
+		if (model[i] != ' ')
+			break;
+		model[i] = '\0';
+	}
+	hex_model = string_to_hex(model);
+	if (!hex_model) {
+		kfree(hex_vendor);
+		return -ENOMEM;
+	}
+
+	i = snprintf(buffer, len, "scsi:t-0x%02xv%.16sm%.32s", sdev->type,
+		 hex_vendor, hex_model);
+	kfree(hex_vendor);
+	kfree(hex_model);
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
 
@@ -697,8 +745,11 @@ static ssize_t
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
 
Index: linux-2.6.29/include/linux/mod_devicetable.h
===================================================================
--- linux-2.6.29.orig/include/linux/mod_devicetable.h
+++ linux-2.6.29/include/linux/mod_devicetable.h
@@ -454,6 +454,12 @@ struct dmi_system_id {
 
 #define DMI_MATCH(a, b)	{ a, b }
 
+struct scsi_dh_device_id {
+	unsigned char type;
+	char vendor[9];
+	char model[17];
+};
+
 #define PLATFORM_NAME_SIZE	20
 #define PLATFORM_MODULE_PREFIX	"platform:"
 
Index: linux-2.6.29/include/linux/string_helpers.h
===================================================================
--- linux-2.6.29.orig/include/linux/string_helpers.h
+++ linux-2.6.29/include/linux/string_helpers.h
@@ -13,4 +13,6 @@ enum string_size_units {
 int string_get_size(u64 size, enum string_size_units units,
 		    char *buf, int len);
 
+unsigned char *string_to_hex(const unsigned char *s);
+
 #endif
Index: linux-2.6.29/include/scsi/scsi.h
===================================================================
--- linux-2.6.29.orig/include/scsi/scsi.h
+++ linux-2.6.29/include/scsi/scsi.h
@@ -266,6 +266,7 @@ static inline int scsi_status_is_good(in
 #define TYPE_RBC	    0x0e
 #define TYPE_OSD            0x11
 #define TYPE_NO_LUN         0x7f
+#define TYPE_ANY	    0xff
 
 /* SCSI protocols; these are taken from SPC-3 section 7.5 */
 enum scsi_protocol {
Index: linux-2.6.29/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.29.orig/include/scsi/scsi_device.h
+++ linux-2.6.29/include/scsi/scsi_device.h
@@ -1,6 +1,7 @@
 #ifndef _SCSI_SCSI_DEVICE_H
 #define _SCSI_SCSI_DEVICE_H
 
+#include <linux/mod_devicetable.h>
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
@@ -169,11 +170,6 @@ struct scsi_device {
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
 
-struct scsi_dh_devlist {
-	char *vendor;
-	char *model;
-};
-
 struct scsi_device_handler {
 	/* Used by the infrastructure */
 	struct list_head list; /* list of scsi_device_handlers */
@@ -181,7 +177,7 @@ struct scsi_device_handler {
 	/* Filled by the hardware handler */
 	struct module *module;
 	const char *name;
-	const struct scsi_dh_devlist *devlist;
+	const struct scsi_dh_device_id *devlist;
 	int (*check_sense)(struct scsi_device *, struct scsi_sense_hdr *);
 	int (*attach)(struct scsi_device *);
 	void (*detach)(struct scsi_device *);
@@ -452,6 +448,5 @@ static inline int scsi_device_protection
 
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
-#define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
 
 #endif /* _SCSI_SCSI_DEVICE_H */
Index: linux-2.6.29/lib/string_helpers.c
===================================================================
--- linux-2.6.29.orig/lib/string_helpers.c
+++ linux-2.6.29/lib/string_helpers.c
@@ -66,3 +66,35 @@ int string_get_size(u64 size, const enum
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
Index: linux-2.6.29/scripts/mod/file2alias.c
===================================================================
--- linux-2.6.29.orig/scripts/mod/file2alias.c
+++ linux-2.6.29/scripts/mod/file2alias.c
@@ -51,6 +51,22 @@ do {
                 sprintf(str + strlen(str), "*");                \
 } while(0)
 
+#define ADD_HEX_STR(str, sep, cond, field)				\
+do {									\
+	strcat(str, sep);						\
+	if (cond) {							\
+		char * _s = str + strlen(str);				\
+		char * _f = field;					\
+		static const char *_hex = "0123456789ABCDEF";		\
+									\
+		for (; *_f; _f++) {					\
+			*_s++ = _hex[(*_f & 0xf0)>>4];			\
+			*_s++ = _hex[*_f & 0xf];			\
+		}							\
+	} else								\
+		strcat(str, "*");					\
+} while(0)
+
 /* Always end in a wildcard, for future extension */
 static inline void add_wildcard(char *str)
 {
@@ -718,6 +734,23 @@ static int do_platform_entry(const char
 	return 1;
 }
 
+
+/* Looks like: scsi:t-NvSmS */
+/* defining TYPE_ANY here is a gross hack to avoid moving all the scsi.h
+ * TYPE_ definitions into mod_devicetable.h */
+#define TYPE_ANY 0xff
+static int do_scsi_entry(const char *filename,
+			struct scsi_dh_device_id *id, char *alias)
+{
+	strcpy(alias, "scsi:");
+	ADD(alias, "t-", id->type != TYPE_ANY, id->type);
+	ADD_HEX_STR(alias, "v", id->vendor[0] != '\0', id->vendor);
+	ADD_HEX_STR(alias, "m", id->model[0] != '\0', id->model);
+
+	add_wildcard(alias);
+	return 1;
+}
+
 /* Ignore any prefix, eg. some architectures prepend _ */
 static inline int sym_is(const char *symbol, const char *name)
 {
@@ -744,6 +777,7 @@ static void do_table(void *symval, unsig
 	size -= id_size;
 
 	for (i = 0; i < size; i += id_size) {
+		memset(alias, '\0', 500);
 		if (do_entry(mod->name, symval+i, alias)) {
 			buf_printf(&mod->dev_table_buf,
 				   "MODULE_ALIAS(\"%s\");\n", alias);
@@ -861,6 +895,10 @@ void handle_moddevtable(struct module *m
 		do_table(symval, sym->st_size,
 			 sizeof(struct platform_device_id), "platform",
 			 do_platform_entry, mod);
+	else if (sym_is(symname, "__mod_scsi_dh_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct scsi_dh_device_id), "scsi",
+			 do_scsi_entry, mod);
 	free(zeros);
 }
 
