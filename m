From: vikas.chaudhary@qlogic.com
Subject: [PATCH 09/10] qla4xxx: Fix return code for qla4xxx_session_get_param.
Date: Sun, 20 Jan 2013 23:51:04 -0500
Message-ID: <1358743865-435-10-git-send-email-vikas.chaudhary@qlogic.com>
References: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:65153 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750982Ab3AUFLk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jan 2013 00:11:40 -0500
In-Reply-To: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

While reading sysfs chap_in_idx and chap_out_idx attribute, if chap
authentication is not set we get an error as "Invalid argument".

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index b8acc40..6142729 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1337,18 +1337,18 @@ static int qla4xxx_session_get_param(struct iscsi_cls_session *cls_sess,
 					      sess->password_in, BIDI_CHAP,
 					      &idx);
 		if (rval)
-			return -EINVAL;
-
-		len = sprintf(buf, "%hu\n", idx);
+			len = sprintf(buf, "\n");
+		else
+			len = sprintf(buf, "%hu\n", idx);
 		break;
 	case ISCSI_PARAM_CHAP_OUT_IDX:
 		rval = qla4xxx_get_chap_index(ha, sess->username,
 					      sess->password, LOCAL_CHAP,
 					      &idx);
 		if (rval)
-			return -EINVAL;
-
-		len = sprintf(buf, "%hu\n", idx);
+			len = sprintf(buf, "\n");
+		else
+			len = sprintf(buf, "%hu\n", idx);
 		break;
 	default:
 		return iscsi_session_get_param(cls_sess, param, buf);
-- 
1.7.8.GIT

