From: "Eddie Wai" <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] LIBISCSI: Added new boot entries in the session sysfs
Date: Mon, 10 Jun 2013 11:34:41 -0700
Message-ID: <1370889281-22597-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncBCUIJQ5MUMJBBU5Y3CGQKGQE6S4Y4DI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <Eddie Wai>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This is the kernel part of the modification to extract the net params
from the ibft sysfs to the iface struct used for the connection
request upon sync_session in the open-iscsi util.

Three new session sysfs params are defined:
boot_root - holds the name of the /sys/firmware/ibft or iscsi_rootN
boot_nic  - holds the ethernetN name
boot_target - holds the targetN name

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/libiscsi.c             |   18 ++++++++++++++++++
 drivers/scsi/scsi_transport_iscsi.c |   12 ++++++++++++
 include/scsi/iscsi_if.h             |    4 ++++
 include/scsi/libiscsi.h             |    4 ++++
 4 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5de9469..ae69dfc 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2808,6 +2808,9 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->targetname);
 	kfree(session->targetalias);
 	kfree(session->initiatorname);
+	kfree(session->boot_root);
+	kfree(session->boot_nic);
+	kfree(session->boot_target);
 	kfree(session->ifacename);
 
 	iscsi_destroy_session(cls_session);
@@ -3248,6 +3251,12 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		return iscsi_switch_str_param(&session->ifacename, buf);
 	case ISCSI_PARAM_INITIATOR_NAME:
 		return iscsi_switch_str_param(&session->initiatorname, buf);
+	case ISCSI_PARAM_BOOT_ROOT:
+		return iscsi_switch_str_param(&session->boot_root, buf);
+	case ISCSI_PARAM_BOOT_NIC:
+		return iscsi_switch_str_param(&session->boot_nic, buf);
+	case ISCSI_PARAM_BOOT_TARGET:
+		return iscsi_switch_str_param(&session->boot_target, buf);
 	default:
 		return -ENOSYS;
 	}
@@ -3326,6 +3335,15 @@ int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 	case ISCSI_PARAM_INITIATOR_NAME:
 		len = sprintf(buf, "%s\n", session->initiatorname);
 		break;
+	case ISCSI_PARAM_BOOT_ROOT:
+		len = sprintf(buf, "%s\n", session->boot_root);
+		break;
+	case ISCSI_PARAM_BOOT_NIC:
+		len = sprintf(buf, "%s\n", session->boot_nic);
+		break;
+	case ISCSI_PARAM_BOOT_TARGET:
+		len = sprintf(buf, "%s\n", session->boot_target);
+		break;
 	default:
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 133926b..abf7c40 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3473,6 +3473,9 @@ iscsi_session_attr(tgt_reset_tmo, ISCSI_PARAM_TGT_RESET_TMO, 0);
 iscsi_session_attr(ifacename, ISCSI_PARAM_IFACE_NAME, 0);
 iscsi_session_attr(initiatorname, ISCSI_PARAM_INITIATOR_NAME, 0);
 iscsi_session_attr(targetalias, ISCSI_PARAM_TARGET_ALIAS, 0);
+iscsi_session_attr(boot_root, ISCSI_PARAM_BOOT_ROOT, 0);
+iscsi_session_attr(boot_nic, ISCSI_PARAM_BOOT_NIC, 0);
+iscsi_session_attr(boot_target, ISCSI_PARAM_BOOT_TARGET, 0);
 
 static ssize_t
 show_priv_session_state(struct device *dev, struct device_attribute *attr,
@@ -3568,6 +3571,9 @@ static struct attribute *iscsi_session_attrs[] = {
 	&dev_attr_sess_ifacename.attr,
 	&dev_attr_sess_initiatorname.attr,
 	&dev_attr_sess_targetalias.attr,
+	&dev_attr_sess_boot_root.attr,
+	&dev_attr_sess_boot_nic.attr,
+	&dev_attr_sess_boot_target.attr,
 	&dev_attr_priv_sess_recovery_tmo.attr,
 	&dev_attr_priv_sess_state.attr,
 	&dev_attr_priv_sess_creator.attr,
@@ -3631,6 +3637,12 @@ static umode_t iscsi_session_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_PARAM_INITIATOR_NAME;
 	else if (attr == &dev_attr_sess_targetalias.attr)
 		param = ISCSI_PARAM_TARGET_ALIAS;
+	else if (attr == &dev_attr_sess_boot_root.attr)
+		param = ISCSI_PARAM_BOOT_ROOT;
+	else if (attr == &dev_attr_sess_boot_nic.attr)
+		param = ISCSI_PARAM_BOOT_NIC;
+	else if (attr == &dev_attr_sess_boot_target.attr)
+		param = ISCSI_PARAM_BOOT_TARGET;
 	else if (attr == &dev_attr_priv_sess_recovery_tmo.attr)
 		return S_IRUGO | S_IWUSR;
 	else if (attr == &dev_attr_priv_sess_state.attr)
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index fe7f06c..f9cc89b 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -487,6 +487,10 @@ enum iscsi_param {
 	ISCSI_PARAM_TGT_RESET_TMO,
 	ISCSI_PARAM_TARGET_ALIAS,
 
+	ISCSI_PARAM_BOOT_ROOT,
+	ISCSI_PARAM_BOOT_NIC,
+	ISCSI_PARAM_BOOT_TARGET,
+
 	ISCSI_PARAM_CHAP_IN_IDX,
 	ISCSI_PARAM_CHAP_OUT_IDX,
 	/* must always be last */
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 09c041e..4265a4b 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -287,6 +287,10 @@ struct iscsi_session {
 	char			*targetalias;
 	char			*ifacename;
 	char			*initiatorname;
+	char			*boot_root;
+	char			*boot_nic;
+	char			*boot_target;
+
 	/* control data */
 	struct iscsi_transport	*tt;
 	struct Scsi_Host	*host;
-- 
1.7.7.4


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi?hl=en.
For more options, visit https://groups.google.com/groups/opt_out.
