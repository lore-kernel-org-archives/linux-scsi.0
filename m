From: "Eddie Wai" <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 08/16] BNX2I: Added mutex lock protection to
 conn_get_param
Date: Wed, 10 Nov 2010 15:04:49 -0800
Message-ID: <1289430297-30221-9-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCKiEw6yjEhCtyezmBBoE6Qaq7Q-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: James Bottomley <JBottomley-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Ben Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Added net_dev mutex lock protection before accessing the csk
parameters.

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Benjamin Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 6a87a83..6951969 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1473,21 +1473,30 @@ static int bnx2i_conn_get_param(struct iscsi_cls_conn *cls_conn,
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
-		return iscsi_conn_get_param(cls_conn, param, buf);
+		len = iscsi_conn_get_param(cls_conn, param, buf);
+		if (len == -ENOSYS)
+			len = 0;
 	}
-
+out:
 	return len;
 }
 
-- 
1.7.0.5


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
