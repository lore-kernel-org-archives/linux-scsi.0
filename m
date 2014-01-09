From: Vaughan Cao <vaughan.cao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] iscsi: fix wrong order of opcode and itt in iscsi_handle_reject prompt
Date: Thu,  9 Jan 2014 10:21:34 +0800
Message-ID: <1389234094-6134-1-git-send-email-vaughan.cao@oracle.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncBDCN5SUNYEERBY4PXCLAKGQELFSIOOI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
Cc: JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vaughan.cao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This patch makes reject messages show right value for opcode and itt, which
is converse previously.

Signed-off-by: Vaughan Cao <vaughan.cao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/libiscsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e399561..27547ff 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1013,13 +1013,13 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "pdu (op 0x%x itt 0x%x) rejected "
 				  "due to DataDigest error.\n",
-				  rejected_pdu.itt, opcode);
+				  opcode, rejected_pdu.itt);
 		break;
 	case ISCSI_REASON_IMM_CMD_REJECT:
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "pdu (op 0x%x itt 0x%x) rejected. Too many "
 				  "immediate commands.\n",
-				  rejected_pdu.itt, opcode);
+				  opcode, rejected_pdu.itt);
 		/*
 		 * We only send one TMF at a time so if the target could not
 		 * handle it, then it should get fixed (RFC mandates that
@@ -1059,8 +1059,8 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	default:
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "pdu (op 0x%x itt 0x%x) rejected. Reason "
-				  "code 0x%x\n", rejected_pdu.itt,
-				  rejected_pdu.opcode, reject->reason);
+				  "code 0x%x\n", rejected_pdu.opcode,
+				  rejected_pdu.itt, reject->reason);
 		break;
 	}
 	return rc;
-- 
1.8.3.1

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/groups/opt_out.
