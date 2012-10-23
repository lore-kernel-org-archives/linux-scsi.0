From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH] LIBISCSI: Added the new boot_nic entry in the session
 sysfs
Date: Mon, 22 Oct 2012 17:53:12 -0700
Message-ID: <1350953592-29467-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4263 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195Ab2JWAxk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Oct 2012 20:53:40 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

This is the kernel part of the modification to extract the net params
from the ibft sysfs to the iface struct used for the connection
request upon sync_session in the open-iscsi util.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/libiscsi.c             |    6 ++++++
 drivers/scsi/scsi_transport_iscsi.c |    4 ++++
 include/scsi/iscsi_if.h             |    2 ++
 include/scsi/libiscsi.h             |    2 ++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 82c3fd4..4f4c154 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2809,6 +2809,7 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->targetname);
 	kfree(session->targetalias);
 	kfree(session->initiatorname);
+	kfree(session->boot_nic);
 	kfree(session->ifacename);
 
 	iscsi_destroy_session(cls_session);
@@ -3248,6 +3249,8 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		return iscsi_switch_str_param(&session->ifacename, buf);
 	case ISCSI_PARAM_INITIATOR_NAME:
 		return iscsi_switch_str_param(&session->initiatorname, buf);
+	case ISCSI_PARAM_BOOT_NIC:
+		return iscsi_switch_str_param(&session->boot_nic, buf);
 	default:
 		return -ENOSYS;
 	}
@@ -3326,6 +3329,9 @@ int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 	case ISCSI_PARAM_INITIATOR_NAME:
 		len = sprintf(buf, "%s\n", session->initiatorname);
 		break;
+	case ISCSI_PARAM_BOOT_NIC:
+		len = sprintf(buf, "%s\n", session->boot_nic);
+		break;
 	default:
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 31969f2..2cc28fe 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2484,6 +2484,7 @@ iscsi_session_attr(tgt_reset_tmo, ISCSI_PARAM_TGT_RESET_TMO, 0);
 iscsi_session_attr(ifacename, ISCSI_PARAM_IFACE_NAME, 0);
 iscsi_session_attr(initiatorname, ISCSI_PARAM_INITIATOR_NAME, 0);
 iscsi_session_attr(targetalias, ISCSI_PARAM_TARGET_ALIAS, 0);
+iscsi_session_attr(boot_nic, ISCSI_PARAM_BOOT_NIC, 0);
 
 static ssize_t
 show_priv_session_state(struct device *dev, struct device_attribute *attr,
@@ -2570,6 +2571,7 @@ static struct attribute *iscsi_session_attrs[] = {
 	&dev_attr_sess_ifacename.attr,
 	&dev_attr_sess_initiatorname.attr,
 	&dev_attr_sess_targetalias.attr,
+	&dev_attr_sess_boot_nic.attr,
 	&dev_attr_priv_sess_recovery_tmo.attr,
 	&dev_attr_priv_sess_state.attr,
 	&dev_attr_priv_sess_creator.attr,
@@ -2632,6 +2634,8 @@ static umode_t iscsi_session_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_PARAM_INITIATOR_NAME;
 	else if (attr == &dev_attr_sess_targetalias.attr)
 		param = ISCSI_PARAM_TARGET_ALIAS;
+	else if (attr == &dev_attr_sess_boot_nic.attr)
+		param = ISCSI_PARAM_BOOT_NIC;
 	else if (attr == &dev_attr_priv_sess_recovery_tmo.attr)
 		return S_IRUGO | S_IWUSR;
 	else if (attr == &dev_attr_priv_sess_state.attr)
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 917741b..874c8f3 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -452,6 +452,8 @@ enum iscsi_param {
 	ISCSI_PARAM_TGT_RESET_TMO,
 	ISCSI_PARAM_TARGET_ALIAS,
 
+	ISCSI_PARAM_BOOT_NIC,
+
 	ISCSI_PARAM_CHAP_IN_IDX,
 	ISCSI_PARAM_CHAP_OUT_IDX,
 	/* must always be last */
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 6e33386..7ba5cc8 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -287,6 +287,8 @@ struct iscsi_session {
 	char			*targetalias;
 	char			*ifacename;
 	char			*initiatorname;
+	char			*boot_nic;
+
 	/* control data */
 	struct iscsi_transport	*tt;
 	struct Scsi_Host	*host;
-- 
1.7.7.4


