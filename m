From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] qla2xxx: print the right array elements
Date: Wed, 04 Jul 2012 16:35:35 +0100
Message-ID: <20120704153528.4098.49179.stgit@bluebook>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: bzhao@marvell.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Coverity id 793583

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/scsi/qla2xxx/qla_target.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 6986552..c5fd001 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4003,9 +4003,9 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	{
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03b,
 		    "qla_target(%d): Async LOOP_UP occured "
-		    "(m[1]=%x, m[2]=%x, m[3]=%x, m[4]=%x)", vha->vp_idx,
-		    le16_to_cpu(mailbox[1]), le16_to_cpu(mailbox[2]),
-		    le16_to_cpu(mailbox[3]), le16_to_cpu(mailbox[4]));
+		    "(m[0]=%x, m[1]=%x, m[2]=%x, m[3]=%x)", vha->vp_idx,
+		    le16_to_cpu(mailbox[0]), le16_to_cpu(mailbox[1]),
+		    le16_to_cpu(mailbox[2]), le16_to_cpu(mailbox[3]));
 		if (tgt->link_reinit_iocb_pending) {
 			qlt_send_notify_ack(vha, (void *)&tgt->link_reinit_iocb,
 			    0, 0, 0, 0, 0, 0);
@@ -4020,18 +4020,19 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	case MBA_RSCN_UPDATE:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03c,
 		    "qla_target(%d): Async event %#x occured "
-		    "(m[1]=%x, m[2]=%x, m[3]=%x, m[4]=%x)", vha->vp_idx, code,
-		    le16_to_cpu(mailbox[1]), le16_to_cpu(mailbox[2]),
-		    le16_to_cpu(mailbox[3]), le16_to_cpu(mailbox[4]));
+		    "(m[0]=%x, m[1]=%x, m[2]=%x, m[3]=%x)", vha->vp_idx, code,
+		    le16_to_cpu(mailbox[0]), le16_to_cpu(mailbox[1]),
+		    le16_to_cpu(mailbox[2]), le16_to_cpu(mailbox[3]));
 		break;
 
 	case MBA_PORT_UPDATE:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03d,
 		    "qla_target(%d): Port update async event %#x "
-		    "occured: updating the ports database (m[1]=%x, m[2]=%x, "
-		    "m[3]=%x, m[4]=%x)", vha->vp_idx, code,
-		    le16_to_cpu(mailbox[1]), le16_to_cpu(mailbox[2]),
-		    le16_to_cpu(mailbox[3]), le16_to_cpu(mailbox[4]));
+		    "occured: updating the ports database (m[0]=%x, m[1]=%x, "
+		    "m[2]=%x, m[3]=%x)", vha->vp_idx, code,
+		    le16_to_cpu(mailbox[0]), le16_to_cpu(mailbox[1]),
+		    le16_to_cpu(mailbox[2]), le16_to_cpu(mailbox[3]));
+                /* Check: was the reasoncode also one out ? */
 		reason_code = le16_to_cpu(mailbox[2]);
 		if (reason_code == 0x4)
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03e,
@@ -4044,9 +4045,9 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	default:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf040,
 		    "qla_target(%d): Async event %#x occured: "
-		    "ignore (m[1]=%x, m[2]=%x, m[3]=%x, m[4]=%x)", vha->vp_idx,
-		    code, le16_to_cpu(mailbox[1]), le16_to_cpu(mailbox[2]),
-		    le16_to_cpu(mailbox[3]), le16_to_cpu(mailbox[4]));
+		    "ignore (m[0]=%x, m[1]=%x, m[2]=%x, m[3]=%x)", vha->vp_idx,
+		    code, le16_to_cpu(mailbox[0]), le16_to_cpu(mailbox[1]),
+		    le16_to_cpu(mailbox[2]), le16_to_cpu(mailbox[3]));
 		break;
 	}
 
