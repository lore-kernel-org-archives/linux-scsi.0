From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/5] libiscsi: Added support to show targetalias in sysfs
Date: Thu, 19 Jan 2012 03:06:53 -0800
Message-ID: <1326971217-14323-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1326971217-14323-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:9503 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2ASLW1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2012 06:22:27 -0500
In-Reply-To: <1326971217-14323-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

sysfs patch to view target alias:
  /sys/class/iscsi_session/session*/targetalias

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/libiscsi.c |    6 ++++++
 include/scsi/libiscsi.h |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 143bbe4..00592e3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2807,6 +2807,7 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->username);
 	kfree(session->username_in);
 	kfree(session->targetname);
+	kfree(session->targetalias);
 	kfree(session->initiatorname);
 	kfree(session->ifacename);
 
@@ -3233,6 +3234,8 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		return iscsi_switch_str_param(&session->password_in, buf);
 	case ISCSI_PARAM_TARGET_NAME:
 		return iscsi_switch_str_param(&session->targetname, buf);
+	case ISCSI_PARAM_TARGET_ALIAS:
+		return iscsi_switch_str_param(&session->targetalias, buf);
 	case ISCSI_PARAM_TPGT:
 		sscanf(buf, "%d", &session->tpgt);
 		break;
@@ -3299,6 +3302,9 @@ int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 	case ISCSI_PARAM_TARGET_NAME:
 		len = sprintf(buf, "%s\n", session->targetname);
 		break;
+	case ISCSI_PARAM_TARGET_ALIAS:
+		len = sprintf(buf, "%s\n", session->targetalias);
+		break;
 	case ISCSI_PARAM_TPGT:
 		len = sprintf(buf, "%d\n", session->tpgt);
 		break;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index cedcff3..2e42e9a 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -284,6 +284,7 @@ struct iscsi_session {
 	char			*password;
 	char			*password_in;
 	char			*targetname;
+	char			*targetalias;
 	char			*ifacename;
 	char			*initiatorname;
 	/* control data */
-- 
1.7.8.rc2.3.g0911


