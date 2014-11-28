From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 07/16] target: Add target_core_backend_configfs.h helper macros
Date: Fri, 28 Nov 2014 09:06:33 +0000
Message-ID: <1417165602-32359-8-git-send-email-nab@daterainc.com>
References: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Jerome Martin <tramjoe.merin@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a number of configfs e-attr macros following
what existing target_core_configfs.c code does for internal
target_backend_dev_attrib setup, and similar to how target
fabric drivers allow for external config_item_type + cit->ct_attrs.
assignment.

This is useful for backend drivers like PSCSI who need to only
expose a small subset of device attributes, while still retaining
a default list of attributes for other backend drivers like
IBLOCK, FILEIO, RAMDISK, and TCMU.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/target/target_core_backend_configfs.h | 53 +++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 include/target/target_core_backend_configfs.h

diff --git a/include/target/target_core_backend_configfs.h b/include/target/target_core_backend_configfs.h
new file mode 100644
index 0000000..f91935b
--- /dev/null
+++ b/include/target/target_core_backend_configfs.h
@@ -0,0 +1,53 @@
+#ifndef TARGET_CORE_BACKEND_CONFIGFS_H
+#define TARGET_CORE_BACKEND_CONFIGFS_H
+
+#include <target/configfs_macros.h>
+
+#define DEF_TB_DEV_ATTRIB_SHOW(_backend, _name)				\
+static ssize_t _backend##_dev_show_attr_##_name(			\
+	struct se_dev_attrib *da,					\
+	char *page)							\
+{									\
+	return snprintf(page, PAGE_SIZE, "%u\n",			\
+			(u32)da->da_dev->dev_attrib._name);		\
+}
+
+#define DEF_TB_DEV_ATTRIB_STORE(_backend, _name)			\
+static ssize_t _backend##_dev_store_attr_##_name(			\
+	struct se_dev_attrib *da,					\
+	const char *page,						\
+	size_t count)							\
+{									\
+	unsigned long val;						\
+	int ret;							\
+									\
+	ret = kstrtoul(page, 0, &val);					\
+	if (ret < 0) {							\
+		pr_err("kstrtoul() failed with ret: %d\n", ret);	\
+		return -EINVAL;						\
+	}								\
+	ret = se_dev_set_##_name(da->da_dev, (u32)val);			\
+									\
+	return (!ret) ? count : -EINVAL;				\
+}
+
+#define DEF_TB_DEV_ATTRIB(_backend, _name)				\
+DEF_TB_DEV_ATTRIB_SHOW(_backend, _name);				\
+DEF_TB_DEV_ATTRIB_STORE(_backend, _name);
+
+#define DEF_TB_DEV_ATTRIB_RO(_backend, name)				\
+DEF_TB_DEV_ATTRIB_SHOW(_backend, name);
+
+CONFIGFS_EATTR_STRUCT(target_backend_dev_attrib, se_dev_attrib);
+#define TB_DEV_ATTR(_backend, _name, _mode)				\
+static struct target_backend_dev_attrib_attribute _backend##_dev_attrib_##_name = \
+		__CONFIGFS_EATTR(_name, _mode,				\
+		_backend##_dev_show_attr_##_name,			\
+		_backend##_dev_store_attr_##_name);
+
+#define TB_DEV_ATTR_RO(_backend, _name)						\
+static struct target_backend_dev_attrib_attribute _backend##_dev_attrib_##_name = \
+	__CONFIGFS_EATTR_RO(_name,					\
+	_backend##_dev_show_attr_##_name);
+
+#endif /* TARGET_CORE_BACKEND_CONFIGFS_H */
-- 
1.9.1
