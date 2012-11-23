From: vikas.chaudhary@qlogic.com
Subject: [PATCH 4/5] scsi_transport_iscsi: export iscsi class session's target_id in sysfs.
Date: Fri, 23 Nov 2012 06:58:41 -0500
Message-ID: <1353671922-19090-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1353671922-19090-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:3255 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753575Ab2KWMRM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Nov 2012 07:17:12 -0500
In-Reply-To: <1353671922-19090-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 31969f2..dac7f8d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2503,6 +2503,15 @@ show_priv_session_creator(struct device *dev, struct device_attribute *attr,
 }
 static ISCSI_CLASS_ATTR(priv_sess, creator, S_IRUGO, show_priv_session_creator,
 			NULL);
+static ssize_t
+show_priv_session_target_id(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct iscsi_cls_session *session = iscsi_dev_to_session(dev->parent);
+	return sprintf(buf, "%d\n", session->target_id);
+}
+static ISCSI_CLASS_ATTR(priv_sess, target_id, S_IRUGO,
+			show_priv_session_target_id, NULL);
 
 #define iscsi_priv_session_attr_show(field, format)			\
 static ssize_t								\
@@ -2575,6 +2584,7 @@ static struct attribute *iscsi_session_attrs[] = {
 	&dev_attr_priv_sess_creator.attr,
 	&dev_attr_sess_chap_out_idx.attr,
 	&dev_attr_sess_chap_in_idx.attr,
+	&dev_attr_priv_sess_target_id.attr,
 	NULL,
 };
 
@@ -2638,6 +2648,8 @@ static umode_t iscsi_session_attr_is_visible(struct kobject *kobj,
 		return S_IRUGO;
 	else if (attr == &dev_attr_priv_sess_creator.attr)
 		return S_IRUGO;
+	else if (attr == &dev_attr_priv_sess_target_id.attr)
+		return S_IRUGO;
 	else {
 		WARN_ONCE(1, "Invalid session attr");
 		return 0;
-- 
1.7.8.GIT

