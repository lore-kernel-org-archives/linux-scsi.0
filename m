From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 6/7 v2] BNX2I: Added host param
 ISCSI_HOST_PARAM_IPADDRESS
Date: Thu, 1 Jul 2010 15:34:55 -0700
Message-ID: <1278023696-17817-7-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2237 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758387Ab0GAWdy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jul 2010 18:33:54 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

From: Michael Chan <mchan@broadcom.com>

This sysfs attribute is proven to be useful during pivot_root.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Benjamin Li <benli@broadcom.com>
Acked-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 0b4a59e..c079975 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1500,6 +1500,26 @@ static int bnx2i_host_get_param(struct Scsi_Host *shost,
 	case ISCSI_HOST_PARAM_NETDEV_NAME:
 		len = sprintf(buf, "%s\n", hba->netdev->name);
 		break;
+	case ISCSI_HOST_PARAM_IPADDRESS: {
+		struct list_head *active_list = &hba->ep_active_list;
+
+		read_lock_bh(&hba->ep_rdwr_lock);
+		if (!list_empty(&hba->ep_active_list)) {
+			struct bnx2i_endpoint *bnx2i_ep;
+			struct cnic_sock *csk;
+
+			bnx2i_ep = list_first_entry(active_list,
+						    struct bnx2i_endpoint,
+						    link);
+			csk = bnx2i_ep->cm_sk;
+			if (test_bit(SK_F_IPV6, &csk->flags))
+				len = sprintf(buf, "%pI6\n", csk->src_ip);
+			else
+				len = sprintf(buf, "%pI4\n", csk->src_ip);
+		}
+		read_unlock_bh(&hba->ep_rdwr_lock);
+		break;
+	}
 	default:
 		return iscsi_host_get_param(shost, param, buf);
 	}
@@ -2131,7 +2151,8 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 				  ISCSI_LU_RESET_TMO | ISCSI_TGT_RESET_TMO |
 				  ISCSI_PING_TMO | ISCSI_RECV_TMO |
 				  ISCSI_IFACE_NAME | ISCSI_INITIATOR_NAME,
-	.host_param_mask	= ISCSI_HOST_HWADDRESS | ISCSI_HOST_NETDEV_NAME,
+	.host_param_mask	= ISCSI_HOST_HWADDRESS | ISCSI_HOST_IPADDRESS |
+				  ISCSI_HOST_NETDEV_NAME,
 	.create_session		= bnx2i_session_create,
 	.destroy_session	= bnx2i_session_destroy,
 	.create_conn		= bnx2i_conn_create,
-- 
1.7.0.5


