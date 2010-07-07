From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: FW: [RFC PATCH 2/2] iscsi_transport: Modidify recovery_tmo from
 sysfs
Date: Wed, 7 Jul 2010 06:16:33 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87128B124C6@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:59398 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab0GGNQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2010 09:16:36 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "james.bottomley@suse.de" <james.bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Look like following patch never made to reflector so resending.

-----Original Message-----
From: Vikas Chaudhary [mailto:vikas.chaudhary@qlogic.com] 
Sent: Tuesday, July 06, 2010 10:49 AM
To: michaelc@cs.wisc.edu
Cc: james.bottomley@suse.de; linux-scsi@vger.kernel.org; Ravi Anand; Vikas Chaudhary
Subject: [RFC PATCH 2/2] iscsi_transport: Modidify recovery_tmo from sysfs

Added support to modify session->recovery_tmo from sysfs

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c |   37 ++++++++++++++++++++++++++++++----
 1 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b9aec30..fe8704c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1786,11 +1786,33 @@ show_priv_session_##field(struct device *dev, 				\
 	return sprintf(buf, format"\n", session->field);		\
 }
 
-#define iscsi_priv_session_attr(field, format)				\
+#define iscsi_priv_session_attr_store(field)				\
+static ssize_t								\
+store_priv_session_##field(struct device *dev,				\
+			   struct device_attribute *attr,		\
+			   const char *buf, size_t count)		\
+{									\
+	int val;							\
+	char *cp;							\
+	struct iscsi_cls_session *session =				\
+		iscsi_dev_to_session(dev->parent);			\
+	if ((session->state == ISCSI_SESSION_FREE) ||			\
+	    (session->state == ISCSI_SESSION_FAILED))			\
+		return -EBUSY;						\
+	val = simple_strtoul(buf, &cp, 0);				\
+	if ((*cp && (*cp != '\n')) || (val < 0))			\
+		return -EINVAL;						\
+	session->field = val;						\
+	return count;							\
+} 
+
+#define iscsi_priv_session_rw_attr(field, format)			\
 	iscsi_priv_session_attr_show(field, format)			\
-static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO, show_priv_session_##field, \
-			NULL)
-iscsi_priv_session_attr(recovery_tmo, "%d");
+	iscsi_priv_session_attr_store(field)				\
+static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUGO,		\
+			show_priv_session_##field,			\
+			store_priv_session_##field)
+iscsi_priv_session_rw_attr(recovery_tmo, "%d");
 
 /*
  * iSCSI host attrs
@@ -1821,6 +1843,11 @@ do {									\
 	count++;							\
 } while (0)
 
+#define SETUP_PRIV_SESSION_RW_ATTR(field)				\
+do {									\
+	priv->session_attrs[count] = &dev_attr_priv_sess_##field;	\
+	count++;							\
+} while (0)
 
 #define SETUP_SESSION_RD_ATTR(field, param_flag)			\
 do {									\
@@ -2008,7 +2035,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	SETUP_SESSION_RD_ATTR(ifacename, ISCSI_IFACE_NAME);
 	SETUP_SESSION_RD_ATTR(initiatorname, ISCSI_INITIATOR_NAME);
 	SETUP_SESSION_RD_ATTR(targetalias, ISCSI_TARGET_ALIAS);
-	SETUP_PRIV_SESSION_RD_ATTR(recovery_tmo);
+	SETUP_PRIV_SESSION_RW_ATTR(recovery_tmo);
 	SETUP_PRIV_SESSION_RD_ATTR(state);
 
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
-- 
1.7.0.5

