From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/8] scsi_transport: Export CHAP index as sysfs attribute
Date: Mon, 27 Feb 2012 03:08:53 -0800
Message-ID: <1330340938-12893-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1330340938-12893-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:54010
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753410Ab2B0LWa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2012 06:22:30 -0500
In-Reply-To: <1330340938-12893-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Mike Christie <michaelc@cs.wisc.edu>

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c |    8 ++++++++
 include/scsi/iscsi_if.h             |    3 +++
 2 files changed, 11 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 7bf0dec..fac3173 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2475,6 +2475,8 @@ iscsi_session_attr(username, ISCSI_PARAM_USERNAME, 1);
 iscsi_session_attr(username_in, ISCSI_PARAM_USERNAME_IN, 1);
 iscsi_session_attr(password, ISCSI_PARAM_PASSWORD, 1);
 iscsi_session_attr(password_in, ISCSI_PARAM_PASSWORD_IN, 1);
+iscsi_session_attr(chap_out_idx, ISCSI_PARAM_CHAP_OUT_IDX, 1);
+iscsi_session_attr(chap_in_idx, ISCSI_PARAM_CHAP_IN_IDX, 1);
 iscsi_session_attr(fast_abort, ISCSI_PARAM_FAST_ABORT, 0);
 iscsi_session_attr(abort_tmo, ISCSI_PARAM_ABORT_TMO, 0);
 iscsi_session_attr(lu_reset_tmo, ISCSI_PARAM_LU_RESET_TMO, 0);
@@ -2571,6 +2573,8 @@ static struct attribute *iscsi_session_attrs[] = {
 	&dev_attr_priv_sess_recovery_tmo.attr,
 	&dev_attr_priv_sess_state.attr,
 	&dev_attr_priv_sess_creator.attr,
+	&dev_attr_sess_chap_out_idx.attr,
+	&dev_attr_sess_chap_in_idx.attr,
 	NULL,
 };
 
@@ -2602,6 +2606,10 @@ static umode_t iscsi_session_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_PARAM_TARGET_NAME;
 	else if (attr == &dev_attr_sess_tpgt.attr)
 		param = ISCSI_PARAM_TPGT;
+	else if (attr == &dev_attr_sess_chap_in_idx.attr)
+		param = ISCSI_PARAM_CHAP_IN_IDX;
+	else if (attr == &dev_attr_sess_chap_out_idx.attr)
+		param = ISCSI_PARAM_CHAP_OUT_IDX;
 	else if (attr == &dev_attr_sess_password.attr)
 		param = ISCSI_PARAM_USERNAME;
 	else if (attr == &dev_attr_sess_password_in.attr)
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 228a8af..9c23ee8 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -450,6 +450,9 @@ enum iscsi_param {
 
 	ISCSI_PARAM_TGT_RESET_TMO,
 	ISCSI_PARAM_TARGET_ALIAS,
+
+	ISCSI_PARAM_CHAP_IN_IDX,
+	ISCSI_PARAM_CHAP_OUT_IDX,
 	/* must always be last */
 	ISCSI_PARAM_MAX,
 };
-- 
1.7.9.1.265.gb3a76


