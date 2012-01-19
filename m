From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 2/5] qla4xxx: Added support to show targetalias in sysfs
Date: Thu, 19 Jan 2012 03:06:54 -0800
Message-ID: <1326971217-14323-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1326971217-14323-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:56537 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2ASLWP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2012 06:22:15 -0500
In-Reply-To: <1326971217-14323-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ce6d3b7..2bd9f1d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1552,6 +1552,8 @@ static void qla4xxx_copy_fwddb_param(struct scsi_qla_host *ha,
 			(char *)ha->name_string, buflen);
 	iscsi_set_param(cls_conn, ISCSI_PARAM_PERSISTENT_ADDRESS,
 			(char *)ip_addr, buflen);
+	iscsi_set_param(cls_conn, ISCSI_PARAM_TARGET_ALIAS,
+			(char *)fw_ddb_entry->iscsi_alias, buflen);
 }
 
 void qla4xxx_update_session_conn_fwddb_param(struct scsi_qla_host *ha,
@@ -1666,6 +1668,9 @@ void qla4xxx_update_session_conn_param(struct scsi_qla_host *ha,
 	memcpy(sess->initiatorname, ha->name_string,
 	       min(sizeof(ha->name_string), sizeof(sess->initiatorname)));
 
+	iscsi_set_param(cls_conn, ISCSI_PARAM_TARGET_ALIAS,
+			(char *)fw_ddb_entry->iscsi_alias, 0);
+
 exit_session_conn_param:
 	if (fw_ddb_entry)
 		dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
-- 
1.7.8.rc2.3.g0911


