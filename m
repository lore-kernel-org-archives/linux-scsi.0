From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH v2 03/14] qla4xxx: Fix bidirectional CHAP.
Date: Fri, 7 Oct 2011 16:55:41 -0700
Message-ID: <1318031752-3836-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:24701
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507Ab1JHAHY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2011 20:07:24 -0400
In-Reply-To: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Driver was not setting the bidirectional CHAP bit correctly in
the DDB entry.

JIRA Key: UPSISCSI-108

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    2 ++
 drivers/scsi/qla4xxx/ql4_mbx.c |    7 ++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index d2f7cd6..a80adfc 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -351,6 +351,8 @@ struct ipaddress_config {
 
 #define QL4_CHAP_MAX_NAME_LEN 256
 #define QL4_CHAP_MAX_SECRET_LEN 100
+#define LOCAL_CHAP	0
+#define BIDI_CHAP	1
 
 struct ql4_chap_format {
 	u8  intr_chap_name[QL4_CHAP_MAX_NAME_LEN];
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index de733a7..b60b903 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -872,7 +872,6 @@ void qla4xxx_get_conn_event_log(struct scsi_qla_host * ha)
 	uint32_t	max_event_log_entries;
 	uint8_t		i;
 
-
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_cmd));
 
@@ -1578,7 +1577,8 @@ int qla4xxx_set_param_ddbentry(struct scsi_qla_host *ha,
 			}
 
 			rval = qla4xxx_set_chap(ha, sess->username,
-						sess->password, idx, 0);
+						sess->password, idx,
+						LOCAL_CHAP);
 			if (rval)
 				goto exit_set_param;
 
@@ -1599,7 +1599,8 @@ int qla4xxx_set_param_ddbentry(struct scsi_qla_host *ha,
 				goto exit_set_param;
 			}
 			rval = qla4xxx_set_chap(ha, sess->username_in,
-						sess->password_in, idx, 0);
+						sess->password_in, idx,
+						BIDI_CHAP);
 			if (rval)
 				goto exit_set_param;
 		}
-- 
1.7.6


