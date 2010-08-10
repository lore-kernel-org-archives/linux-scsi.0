From: "Eddie Wai" <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/5] BNX2I: Fixed a protocol violation on nopout
 responses
Date: Tue, 10 Aug 2010 12:09:30 -0700
Message-ID: <1281467374-6182-2-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCKiEw6yjEhCXx4bjBBoEbSB4Wg-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>,
	<mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

According to RFC3720, nopout packet sent in response to unsolicited
nopin packet requesting a response must retain the TTT of the requester.

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Acked-by: Benjamin Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/bnx2i/bnx2i.h       |    2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c   |    5 ++---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    2 --
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 00c0335..b6345d9 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -753,7 +753,7 @@ extern int bnx2i_send_iscsi_tmf(struct bnx2i_conn *conn,
 extern int bnx2i_send_iscsi_scsicmd(struct bnx2i_conn *conn,
 				    struct bnx2i_cmd *cmnd);
 extern int bnx2i_send_iscsi_nopout(struct bnx2i_conn *conn,
-				   struct iscsi_task *mtask, u32 ttt,
+				   struct iscsi_task *mtask,
 				   char *datap, int data_len, int unsol);
 extern int bnx2i_send_iscsi_logout(struct bnx2i_conn *conn,
 				   struct iscsi_task *mtask);
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 58cd7fc..ece2b62 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -464,7 +464,6 @@ int bnx2i_send_iscsi_scsicmd(struct bnx2i_conn *bnx2i_conn,
  * @conn:		iscsi connection
  * @cmd:		driver command structure which is requesting
  *			a WQE to sent to chip for further processing
- * @ttt:		TTT to be used when building pdu header
  * @datap:		payload buffer pointer
  * @data_len:		payload data length
  * @unsol:		indicated whether nopout pdu is unsolicited pdu or
@@ -473,7 +472,7 @@ int bnx2i_send_iscsi_scsicmd(struct bnx2i_conn *bnx2i_conn,
  * prepare and post a nopout request WQE to CNIC firmware
  */
 int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
-			    struct iscsi_task *task, u32 ttt,
+			    struct iscsi_task *task,
 			    char *datap, int data_len, int unsol)
 {
 	struct bnx2i_endpoint *ep = bnx2i_conn->ep;
@@ -498,7 +497,7 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
 	nopout_wqe->itt = ((u16)task->itt |
 			   (ISCSI_TASK_TYPE_MPATH <<
 			    ISCSI_TMF_REQUEST_TYPE_SHIFT));
-	nopout_wqe->ttt = ttt;
+	nopout_wqe->ttt = nopout_hdr->ttt;
 	nopout_wqe->flags = 0;
 	if (!unsol)
 		nopout_wqe->flags = ISCSI_NOP_OUT_REQUEST_LOCAL_COMPLETION;
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index c079975..02743d0 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1078,11 +1078,9 @@ static int bnx2i_iscsi_send_generic_request(struct iscsi_task *task)
 		buf = bnx2i_conn->gen_pdu.req_buf;
 		if (data_len)
 			rc = bnx2i_send_iscsi_nopout(bnx2i_conn, task,
-						     RESERVED_ITT,
 						     buf, data_len, 1);
 		else
 			rc = bnx2i_send_iscsi_nopout(bnx2i_conn, task,
-						     RESERVED_ITT,
 						     NULL, 0, 1);
 		break;
 	case ISCSI_OP_LOGOUT:
-- 
1.7.0.5


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
