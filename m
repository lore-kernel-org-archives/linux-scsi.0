From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH v2 07/14] BNX2I: Added mutex lock protection to
 conn_get_param
Date: Thu, 18 Nov 2010 17:30:02 -0800
Message-ID: <1290130209-32133-8-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3231 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab0KSB5f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 20:57:35 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Added net_dev mutex lock protection before accessing the csk
parameters.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Benjamin Li <benli@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index a2c9b1f..07dd4f9 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1461,21 +1461,28 @@ static int bnx2i_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	struct bnx2i_conn *bnx2i_conn = conn->dd_data;
 	int len = 0;
 
+	if (!(bnx2i_conn && bnx2i_conn->ep && bnx2i_conn->ep->hba))
+		goto out;
+
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
-		if (bnx2i_conn->ep)
+		mutex_lock(&bnx2i_conn->ep->hba->net_dev_lock);
+		if (bnx2i_conn->ep->cm_sk)
 			len = sprintf(buf, "%hu\n",
 				      bnx2i_conn->ep->cm_sk->dst_port);
+		mutex_unlock(&bnx2i_conn->ep->hba->net_dev_lock);
 		break;
 	case ISCSI_PARAM_CONN_ADDRESS:
-		if (bnx2i_conn->ep)
+		mutex_lock(&bnx2i_conn->ep->hba->net_dev_lock);
+		if (bnx2i_conn->ep->cm_sk)
 			len = sprintf(buf, "%pI4\n",
 				      &bnx2i_conn->ep->cm_sk->dst_ip);
+		mutex_unlock(&bnx2i_conn->ep->hba->net_dev_lock);
 		break;
 	default:
 		return iscsi_conn_get_param(cls_conn, param, buf);
 	}
-
+out:
 	return len;
 }
 
-- 
1.7.0.5


