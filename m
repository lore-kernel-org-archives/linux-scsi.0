From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] scsi: libfc: directly call ELS request handlers
Date: Fri,  7 Apr 2017 15:42:24 +0200
Message-ID: <20170407134224.14804-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Directly call ELS request handler functions in fc_lport_recv_els_req
instead of saving the pointer to the handler's receive function and then
later dereferencing this pointer.

This makes the code a bit more obvious.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/libfc/fc_lport.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index aa76f36..2fd0ec6 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -887,8 +887,6 @@ static void fc_lport_recv_flogi_req(struct fc_lport *lport,
 static void fc_lport_recv_els_req(struct fc_lport *lport,
 				  struct fc_frame *fp)
 {
-	void (*recv)(struct fc_lport *, struct fc_frame *);
-
 	mutex_lock(&lport->lp_mutex);
 
 	/*
@@ -902,31 +900,31 @@ static void fc_lport_recv_els_req(struct fc_lport *lport,
 		/*
 		 * Check opcode.
 		 */
-		recv = fc_rport_recv_req;
 		switch (fc_frame_payload_op(fp)) {
 		case ELS_FLOGI:
 			if (!lport->point_to_multipoint)
-				recv = fc_lport_recv_flogi_req;
+				fc_lport_recv_flogi_req(lport, fp);
 			break;
 		case ELS_LOGO:
 			if (fc_frame_sid(fp) == FC_FID_FLOGI)
-				recv = fc_lport_recv_logo_req;
+				fc_lport_recv_logo_req(lport, fp);
 			break;
 		case ELS_RSCN:
-			recv = lport->tt.disc_recv_req;
+			lport->tt.disc_recv_req(lport, fp);
 			break;
 		case ELS_ECHO:
-			recv = fc_lport_recv_echo_req;
+			fc_lport_recv_echo_req(lport, fp);
 			break;
 		case ELS_RLIR:
-			recv = fc_lport_recv_rlir_req;
+			fc_lport_recv_rlir_req(lport, fp);
 			break;
 		case ELS_RNID:
-			recv = fc_lport_recv_rnid_req;
+			fc_lport_recv_rnid_req(lport, fp);
+			break;
+		default:
+			fc_rport_recv_req(lport, fp);
 			break;
 		}
-
-		recv(lport, fp);
 	}
 	mutex_unlock(&lport->lp_mutex);
 }
-- 
1.8.5.6
