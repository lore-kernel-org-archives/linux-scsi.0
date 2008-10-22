From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: PATCH] [ConfigFS]: Extend CONFIGFS_ATTR_STRUCT() and
	CONFIGFS_ATTR_OPS() macros
Date: Wed, 22 Oct 2008 15:06:29 -0700
Message-ID: <1224713189.24358.111.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:26141 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752980AbYJVWGc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2008 18:06:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <joel.becker@oracle.com>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

Hi Joel,

What do you think..?

Also, here is the drivers/lio-core/iscsi_target_configfs.c commit to
convert to use to new parameters for CONFIGFS_ATTR_STRUCT() and
CONFIGFS_ATTR_OPS():

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=e305460ebaa92ce1f8542a55bd62648904fb2fd6

I don't see anyone except for drivers/lio-core and
Documentation/filesystems/configfs/ using these macros..  If I can get
an ACK I would be happy to update the examples.

--nab


>From 71fc659e337dcc5941f6f64f6c8abfb6b477fd7c Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 22 Oct 2008 14:49:01 -0700
Subject: [PATCH] [ConfigFS]: Extend CONFIGFS_ATTR_STRUCT() and CONFIGFS_ATTR_OPS() macros

Extend CONFIGFS_ATTR_STRUCT() and CONFIGFS_ATTR_OPS() macros to allow
multiple struct config_item or struct config_group to hang off the same
structure.  This means the previous '_item' arguement gets split into
'_name' (for function and attribute structure names) and '_item' (the
struct _item used throughout the macros that contains
struct _item->my_config_group.

This patch also removed the requirement for code using these macros to
provide their own 'to_<name>()' function, which is now defined by
CONFIGFS_ATTR_OPS() by passing the '_item_member' argument which is
used inside of to_##_name() for locating struct _item *_item = container_of().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 include/linux/configfs.h |   51 ++++++++++++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 7f62777..2eab7ef 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -132,11 +132,13 @@ struct configfs_attribute {
  * attributes, containing a configfs_attribute member and function pointers
  * for the show() and store() operations on that attribute. If they don't
  * need anything else on the extended attribute structure, they can use
- * this macro to define it  The argument _item is the name of the
- * config_item structure.
+ * this macro to define it.  The argument _name isends up as
+ * 'struct _name_attribute, as well as names of to CONFIGFS_ATTR_OPS() below.
+ * The argument _item is the name of the structure containing the
+ * struct config_item or struct config_group structure members
  */
-#define CONFIGFS_ATTR_STRUCT(_item)					\
-struct _item##_attribute {						\
+#define CONFIGFS_ATTR_STRUCT(_name, _item)				\
+struct _name##_attribute {						\
 	struct configfs_attribute attr;					\
 	ssize_t (*show)(struct _item *, char *);			\
 	ssize_t (*store)(struct _item *, const char *, size_t);		\
@@ -175,35 +177,44 @@ struct _item##_attribute {						\
  * With these extended attributes, the simple show_attribute() and
  * store_attribute() operations need to call the show() and store() of the
  * attributes.  This is a common pattern, so we provide a macro to define
- * them.  The argument _item is the name of the config_item structure.
- * This macro expects the attributes to be named "struct <name>_attribute"
- * and the function to_<name>() to exist;
+ * them.  The argument _name is the name of the attribute defined by
+ * CONFIGFS_ATTR_STRUCT(). The argument _item is the name of the structure
+ * containing the struct config_item or struct config_group structure member.
+ * The argument _item_member is the actual name of the struct config_* struct
+ * in your _item structure.  Meaning  my_structure->some_config_group.
+ *		                      ^^_item^^^^^  ^^_item_member^^^
+ * This macro expects the attributes to be named "struct <name>_attribute".
  */
-#define CONFIGFS_ATTR_OPS(_item)					\
-static ssize_t _item##_attr_show(struct config_item *item,		\
+#define CONFIGFS_ATTR_OPS(_name, _item, _item_member)			\
+static struct _item *to_##_name(struct config_item *ci)			\
+{									\
+	return((ci) ? container_of(to_config_group(ci), struct _item,	\
+		_item_member) : NULL);					\
+}									\
+static ssize_t _name##_attr_show(struct config_item *item,		\
 				 struct configfs_attribute *attr,	\
 				 char *page)				\
 {									\
-	struct _item *_item = to_##_item(item);				\
-	struct _item##_attribute *_item##_attr =			\
-		container_of(attr, struct _item##_attribute, attr);	\
+	struct _item *_item = to_##_name(item);				\
+	struct _name##_attribute *_name##_attr =			\
+		container_of(attr, struct _name##_attribute, attr);	\
 	ssize_t ret = 0;						\
 									\
-	if (_item##_attr->show)						\
-		ret = _item##_attr->show(_item, page);			\
+	if (_name##_attr->show)						\
+		ret = _name##_attr->show(_item, page);			\
 	return ret;							\
 }									\
-static ssize_t _item##_attr_store(struct config_item *item,		\
+static ssize_t _name##_attr_store(struct config_item *item,		\
 				  struct configfs_attribute *attr,	\
 				  const char *page, size_t count)	\
 {									\
-	struct _item *_item = to_##_item(item);				\
-	struct _item##_attribute *_item##_attr =			\
-		container_of(attr, struct _item##_attribute, attr);	\
+	struct _item *_item = to_##_name(item);				\
+	struct _name##_attribute *_name##_attr =			\
+		container_of(attr, struct _name##_attribute, attr);	\
 	ssize_t ret = -EINVAL;						\
 									\
-	if (_item##_attr->store)					\
-		ret = _item##_attr->store(_item, page, count);		\
+	if (_name##_attr->store)					\
+		ret = _name##_attr->store(_item, page, count);		\
 	return ret;							\
 }
 
-- 
1.5.4.1



