From: "Eddie Wai" <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/5] BNX2I: Recouple the CFC delete cleanup with
 cm_abort/close completion
Date: Tue, 10 Aug 2010 12:09:32 -0700
Message-ID: <1281467374-6182-4-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCKiEw6yjEhCWx4bjBBoEGqUR5g-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

Specific to the Broadcom 10g chipset, the CFC delete operation must be
coupled with the cm_abort/close with does the SRC delete/terminate offload
operation prior.

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Acked-by: Benjamin Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 02743d0..40f3758 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1996,11 +1996,13 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 	else
 		close_ret = cnic->cm_abort(bnx2i_ep->cm_sk);
 
+	/* No longer allow CFC delete if cm_close/abort fails the request */
 	if (close_ret)
-		bnx2i_ep->state = EP_STATE_DISCONN_COMPL;
-
-	/* wait for option-2 conn teardown */
-	wait_event_interruptible(bnx2i_ep->ofld_wait,
+		printk(KERN_ALERT "bnx2i: %s close/abort(%d) returned %d\n",
+			bnx2i_ep->hba->netdev->name, close, close_ret);
+	else
+		/* wait for option-2 conn teardown */
+		wait_event_interruptible(bnx2i_ep->ofld_wait,
 				 bnx2i_ep->state != EP_STATE_DISCONN_START);
 
 	if (signal_pending(current))
-- 
1.7.0.5


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
