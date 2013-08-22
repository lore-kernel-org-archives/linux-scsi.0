From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH RESEND 3/3] zfcp: remove access control tables interface (keep sysfs files)
Date: Thu, 22 Aug 2013 17:45:38 +0200
Message-ID: <1377186338-35344-4-git-send-email-maier@linux.vnet.ibm.com>
References: <1377099366.2011.23.camel@dabdike.int.hansenpartnership.com>
 <1377186338-35344-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1377186338-35344-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>, stable@vger.kernel.org.#3.11+
List-Id: linux-scsi@vger.kernel.org

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

By popular demand, this patch brings back a couple of sysfs attributes
removed by commit 663e0890e31cb85f0cca5ac1faaee0d2d52880b5
"[SCSI] zfcp: remove access control tables interface".
The content has been irrelevant for years, but the files must be
there forever for whatever user space tools that may rely on them.

Since these files always return a constant value, a new stripped
down show-macro was required. Otherwise build warnings would have
been introduced.

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org #3.11+
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_sysfs.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -27,6 +27,16 @@ static ssize_t zfcp_sysfs_##_feat##_##_n
 static ZFCP_DEV_ATTR(_feat, _name, S_IRUGO,				       \
 		     zfcp_sysfs_##_feat##_##_name##_show, NULL);
 
+#define ZFCP_DEFINE_ATTR_CONST(_feat, _name, _format, _value)		       \
+static ssize_t zfcp_sysfs_##_feat##_##_name##_show(struct device *dev,	       \
+						   struct device_attribute *at,\
+						   char *buf)		       \
+{									       \
+	return sprintf(buf, _format, _value);				       \
+}									       \
+static ZFCP_DEV_ATTR(_feat, _name, S_IRUGO,				       \
+		     zfcp_sysfs_##_feat##_##_name##_show, NULL);
+
 #define ZFCP_DEFINE_A_ATTR(_name, _format, _value)			     \
 static ssize_t zfcp_sysfs_adapter_##_name##_show(struct device *dev,	     \
 						 struct device_attribute *at,\
@@ -75,6 +85,8 @@ ZFCP_DEFINE_ATTR(zfcp_unit, unit, in_rec
 ZFCP_DEFINE_ATTR(zfcp_unit, unit, access_denied, "%d\n",
 		 (zfcp_unit_sdev_status(unit) &
 		  ZFCP_STATUS_COMMON_ACCESS_DENIED) != 0);
+ZFCP_DEFINE_ATTR_CONST(unit, access_shared, "%d\n", 0);
+ZFCP_DEFINE_ATTR_CONST(unit, access_readonly, "%d\n", 0);
 
 static ssize_t zfcp_sysfs_port_failed_show(struct device *dev,
 					   struct device_attribute *attr,
@@ -347,6 +359,8 @@ static struct attribute *zfcp_unit_attrs
 	&dev_attr_unit_in_recovery.attr,
 	&dev_attr_unit_status.attr,
 	&dev_attr_unit_access_denied.attr,
+	&dev_attr_unit_access_shared.attr,
+	&dev_attr_unit_access_readonly.attr,
 	NULL
 };
 static struct attribute_group zfcp_unit_attr_group = {
