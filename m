From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/3] enhance device info matching for multiple tables
Date: Wed, 17 Jun 2009 15:01:58 -0400
Message-ID: <1245265318.8585.95.camel@mulgrave.site>
References: <1245265244.8585.94.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38368 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758176AbZFQTCB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jun 2009 15:02:01 -0400
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 2FE758EE10E
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 12:02:04 -0700 (PDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
	by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0lAwKhobyh2l for <linux-scsi@vger.kernel.org>;
	Wed, 17 Jun 2009 12:02:04 -0700 (PDT)
Received: from [192.168.10.224] (newmulgrave.ext.hansenpartnership.com [192.168.10.224])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 323208EE0F1
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 12:02:03 -0700 (PDT)
In-Reply-To: <1245265244.8585.94.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The current scsi_devinfo.c matching routines use a single table for
the global blacklist.  However, we're developing a need to blacklist
from specific transports too (notably some tape drives using SPI which
don't respond well to high speed protocols).  Instead of developing
separate blacklist matching for each transport class needing it,
enhance the current list matching to permit multiple lists.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_devinfo.c |  247 +++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/scsi_priv.h    |   15 +++
 2 files changed, 240 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 8821df9..2fced8f 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -24,6 +24,13 @@ struct scsi_dev_info_list {
 	unsigned compatible; /* for use with scsi_static_device_list entries */
 };
 
+struct scsi_dev_info_list_table {
+	struct list_head node;	/* our node for being on the master list */
+	struct list_head scsi_dev_info_list; /* head of dev info list */
+	const char *name;	/* name of list for /proc (NULL for global) */
+	int key;		/* unique numeric identifier */
+};
+
 
 static const char spaces[] = "                "; /* 16 of them */
 static unsigned scsi_default_dev_flags;
@@ -247,6 +254,22 @@ static struct {
 	{ NULL, NULL, NULL, 0 },
 };
 
+static struct scsi_dev_info_list_table *scsi_devinfo_lookup_by_key(int key)
+{
+	struct scsi_dev_info_list_table *devinfo_table;
+	int found = 0;
+
+	list_for_each_entry(devinfo_table, &scsi_dev_info_list, node)
+		if (devinfo_table->key == key) {
+			found = 1;
+			break;
+		}
+	if (!found)
+		return ERR_PTR(-EINVAL);
+
+	return devinfo_table;
+}
+
 /*
  * scsi_strcpy_devinfo: called from scsi_dev_info_list_add to copy into
  * devinfo vendor and model strings.
@@ -296,7 +319,38 @@ static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
 static int scsi_dev_info_list_add(int compatible, char *vendor, char *model,
 			    char *strflags, int flags)
 {
+	return scsi_dev_info_list_add_keyed(compatible, vendor, model,
+					    strflags, flags,
+					    SCSI_DEVINFO_GLOBAL);
+}
+
+/**
+ * scsi_dev_info_list_add_keyed - add one dev_info list entry.
+ * @compatible: if true, null terminate short strings.  Otherwise space pad.
+ * @vendor:	vendor string
+ * @model:	model (product) string
+ * @strflags:	integer string
+ * @flags:	if strflags NULL, use this flag value
+ * @key:	specify list to use
+ *
+ * Description:
+ * 	Create and add one dev_info entry for @vendor, @model,
+ * 	@strflags or @flag in list specified by @key. If @compatible,
+ * 	add to the tail of the list, do not space pad, and set
+ * 	devinfo->compatible. The scsi_static_device_list entries are
+ * 	added with @compatible 1 and @clfags NULL.
+ *
+ * Returns: 0 OK, -error on failure.
+ **/
+int scsi_dev_info_list_add_keyed(int compatible, char *vendor, char *model,
+				 char *strflags, int flags, int key)
+{
 	struct scsi_dev_info_list *devinfo;
+	struct scsi_dev_info_list_table *devinfo_table =
+		scsi_devinfo_lookup_by_key(key);
+
+	if (IS_ERR(devinfo_table))
+		return PTR_ERR(devinfo_table);
 
 	devinfo = kmalloc(sizeof(*devinfo), GFP_KERNEL);
 	if (!devinfo) {
@@ -317,12 +371,15 @@ static int scsi_dev_info_list_add(int compatible, char *vendor, char *model,
 	devinfo->compatible = compatible;
 
 	if (compatible)
-		list_add_tail(&devinfo->dev_info_list, &scsi_dev_info_list);
+		list_add_tail(&devinfo->dev_info_list,
+			      &devinfo_table->scsi_dev_info_list);
 	else
-		list_add(&devinfo->dev_info_list, &scsi_dev_info_list);
+		list_add(&devinfo->dev_info_list,
+			 &devinfo_table->scsi_dev_info_list);
 
 	return 0;
 }
+EXPORT_SYMBOL(scsi_dev_info_list_add_keyed);
 
 /**
  * scsi_dev_info_list_add_str - parse dev_list and add to the scsi_dev_info_list.
@@ -382,22 +439,48 @@ static int scsi_dev_info_list_add_str(char *dev_list)
  * @model:	model name
  *
  * Description:
- *     Search the scsi_dev_info_list for an entry matching @vendor and
- *     @model, if found, return the matching flags value, else return
- *     the host or global default settings.  Called during scan time.
+ *     Search the global scsi_dev_info_list (specified by list zero)
+ *     for an entry matching @vendor and @model, if found, return the
+ *     matching flags value, else return the host or global default
+ *     settings.  Called during scan time.
  **/
 int scsi_get_device_flags(struct scsi_device *sdev,
 			  const unsigned char *vendor,
 			  const unsigned char *model)
 {
+	return scsi_get_device_flags_keyed(sdev, vendor, model,
+					   SCSI_DEVINFO_GLOBAL);
+}
+
+
+/**
+ * get_device_flags_keyed - get device specific flags from the dynamic device list.
+ * @sdev:       &scsi_device to get flags for
+ * @vendor:	vendor name
+ * @model:	model name
+ * @key:	list to look up
+ *
+ * Description:
+ *     Search the scsi_dev_info_list specified by @key for an entry
+ *     matching @vendor and @model, if found, return the matching
+ *     flags value, else return the host or global default settings.
+ *     Called during scan time.
+ **/
+int scsi_get_device_flags_keyed(struct scsi_device *sdev,
+				const unsigned char *vendor,
+				const unsigned char *model,
+				int key)
+{
 	struct scsi_dev_info_list *devinfo;
-	unsigned int bflags;
+	struct scsi_dev_info_list_table *devinfo_table;
+
+	devinfo_table = scsi_devinfo_lookup_by_key(key);
 
-	bflags = sdev->sdev_bflags;
-	if (!bflags)
-		bflags = scsi_default_dev_flags;
+	if (IS_ERR(devinfo_table))
+		return PTR_ERR(devinfo_table);
 
-	list_for_each_entry(devinfo, &scsi_dev_info_list, dev_info_list) {
+	list_for_each_entry(devinfo, &devinfo_table->scsi_dev_info_list,
+			    dev_info_list) {
 		if (devinfo->compatible) {
 			/*
 			 * Behave like the older version of get_device_flags.
@@ -447,32 +530,89 @@ int scsi_get_device_flags(struct scsi_device *sdev,
 				return devinfo->flags;
 		}
 	}
-	return bflags;
+	/* nothing found, return nothing */
+	if (key != SCSI_DEVINFO_GLOBAL)
+		return 0;
+
+	/* except for the global list, where we have an exception */
+	if (sdev->sdev_bflags)
+		return sdev->sdev_bflags;
+
+	return scsi_default_dev_flags;
 }
+EXPORT_SYMBOL(scsi_get_device_flags_keyed);
 
 #ifdef CONFIG_SCSI_PROC_FS
+struct double_list {
+	struct list_head *top;
+	struct list_head *bottom;
+};
+
 static int devinfo_seq_show(struct seq_file *m, void *v)
 {
+	struct double_list *dl = v;
+	struct scsi_dev_info_list_table *devinfo_table =
+		list_entry(dl->top, struct scsi_dev_info_list_table, node);
 	struct scsi_dev_info_list *devinfo =
-		list_entry(v, struct scsi_dev_info_list, dev_info_list);
+		list_entry(dl->bottom, struct scsi_dev_info_list,
+			   dev_info_list);
+
+	if (devinfo_table->scsi_dev_info_list.next == dl->bottom &&
+	    devinfo_table->name)
+		seq_printf(m, "[%s]:\n", devinfo_table->name);
 
 	seq_printf(m, "'%.8s' '%.16s' 0x%x\n",
-			devinfo->vendor, devinfo->model, devinfo->flags);
+		   devinfo->vendor, devinfo->model, devinfo->flags);
 	return 0;
 }
 
-static void * devinfo_seq_start(struct seq_file *m, loff_t *pos)
+static void * devinfo_seq_start(struct seq_file *m, loff_t *ppos)
 {
-	return seq_list_start(&scsi_dev_info_list, *pos);
+	struct double_list *dl = kmalloc(sizeof(*dl), GFP_KERNEL);
+	loff_t pos = *ppos;
+
+	if (!dl)
+		return NULL;
+
+	list_for_each(dl->top, &scsi_dev_info_list) {
+		struct scsi_dev_info_list_table *devinfo_table =
+			list_entry(dl->top, struct scsi_dev_info_list_table,
+				   node);
+		list_for_each(dl->bottom, &devinfo_table->scsi_dev_info_list)
+			if (pos-- == 0)
+				return dl;
+	}
+
+	kfree(dl);
+	return NULL;
 }
 
-static void * devinfo_seq_next(struct seq_file *m, void *v, loff_t *pos)
+static void *devinfo_seq_next(struct seq_file *m, void *v, loff_t *ppos)
 {
-	return seq_list_next(v, &scsi_dev_info_list, pos);
+	struct double_list *dl = v;
+	struct scsi_dev_info_list_table *devinfo_table =
+		list_entry(dl->top, struct scsi_dev_info_list_table, node);
+
+	++*ppos;
+	dl->bottom = dl->bottom->next;
+	while (&devinfo_table->scsi_dev_info_list == dl->bottom) {
+		dl->top = dl->top->next;
+		if (dl->top == &scsi_dev_info_list) {
+			kfree(dl);
+			return NULL;
+		}
+		devinfo_table = list_entry(dl->top,
+					   struct scsi_dev_info_list_table,
+					   node);
+		dl->bottom = devinfo_table->scsi_dev_info_list.next;
+	}
+
+	return dl;
 }
 
 static void devinfo_seq_stop(struct seq_file *m, void *v)
 {
+	kfree(v);
 }
 
 static const struct seq_operations scsi_devinfo_seq_ops = {
@@ -549,19 +689,78 @@ MODULE_PARM_DESC(default_dev_flags,
  **/
 void scsi_exit_devinfo(void)
 {
-	struct list_head *lh, *lh_next;
-	struct scsi_dev_info_list *devinfo;
-
 #ifdef CONFIG_SCSI_PROC_FS
 	remove_proc_entry("scsi/device_info", NULL);
 #endif
 
-	list_for_each_safe(lh, lh_next, &scsi_dev_info_list) {
+	scsi_dev_info_remove_list(SCSI_DEVINFO_GLOBAL);
+}
+
+/**
+ * scsi_dev_info_add_list - add a new devinfo list
+ * @key:	key of the list to add
+ * @name:	Name of the list to add (for /proc/scsi/device_info)
+ *
+ * Adds the requested list, returns zero on success, -EEXIST if the
+ * key is already registered to a list, or other error on failure.
+ */
+int scsi_dev_info_add_list(int key, const char *name)
+{
+	struct scsi_dev_info_list_table *devinfo_table =
+		scsi_devinfo_lookup_by_key(key);
+
+	if (!IS_ERR(devinfo_table))
+		/* list already exists */
+		return -EEXIST;
+
+	devinfo_table = kmalloc(sizeof(*devinfo_table), GFP_KERNEL);
+
+	if (!devinfo_table)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&devinfo_table->node);
+	INIT_LIST_HEAD(&devinfo_table->scsi_dev_info_list);
+	devinfo_table->name = name;
+	devinfo_table->key = key;
+	list_add_tail(&devinfo_table->node, &scsi_dev_info_list);
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_dev_info_add_list);
+
+/**
+ * scsi_dev_info_remove_list - destroy an added devinfo list
+ * @key: key of the list to destroy
+ *
+ * Iterates over the entire list first, freeing all the values, then
+ * frees the list itself.  Returns 0 on success or -EINVAL if the key
+ * can't be found.
+ */
+int scsi_dev_info_remove_list(int key)
+{
+	struct list_head *lh, *lh_next;
+	struct scsi_dev_info_list_table *devinfo_table =
+		scsi_devinfo_lookup_by_key(key);
+	
+	if (IS_ERR(devinfo_table))
+		/* no such list */
+		return -EINVAL;
+
+	/* remove from the master list */
+	list_del(&devinfo_table->node);
+
+	list_for_each_safe(lh, lh_next, &devinfo_table->scsi_dev_info_list) {
+		struct scsi_dev_info_list *devinfo;
+
 		devinfo = list_entry(lh, struct scsi_dev_info_list,
 				     dev_info_list);
 		kfree(devinfo);
 	}
+	kfree(devinfo_table);
+
+	return 0;
 }
+EXPORT_SYMBOL(scsi_dev_info_remove_list);
 
 /**
  * scsi_init_devinfo - set up the dynamic device list.
@@ -577,10 +776,14 @@ int __init scsi_init_devinfo(void)
 #endif
 	int error, i;
 
-	error = scsi_dev_info_list_add_str(scsi_dev_flags);
+	error = scsi_dev_info_add_list(SCSI_DEVINFO_GLOBAL, NULL);
 	if (error)
 		return error;
 
+	error = scsi_dev_info_list_add_str(scsi_dev_flags);
+	if (error)
+		goto out;
+
 	for (i = 0; scsi_static_device_list[i].vendor; i++) {
 		error = scsi_dev_info_list_add(1 /* compatibile */,
 				scsi_static_device_list[i].vendor,
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index fbc83be..b4e49cd 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -39,9 +39,24 @@ static inline void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 #endif
 
 /* scsi_devinfo.c */
+
+/* list of keys for the lists */
+enum {
+	SCSI_DEVINFO_GLOBAL = 0,
+};
+
 extern int scsi_get_device_flags(struct scsi_device *sdev,
 				 const unsigned char *vendor,
 				 const unsigned char *model);
+extern int scsi_get_device_flags_keyed(struct scsi_device *sdev,
+				       const unsigned char *vendor,
+				       const unsigned char *model, int key);
+extern int scsi_dev_info_list_add_keyed(int compatible, char *vendor,
+					char *model, char *strflags,
+					int flags, int key);
+extern int scsi_dev_info_add_list(int key, const char *name);
+extern int scsi_dev_info_remove_list(int key);
+
 extern int __init scsi_init_devinfo(void);
 extern void scsi_exit_devinfo(void);
 
-- 
1.6.2.4



