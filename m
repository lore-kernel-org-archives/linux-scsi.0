From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH] qla2xxx: Fix warning reported by static checker
Date: Wed, 20 Jan 2016 15:11:27 -0500
Message-ID: <1453320687-15708-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com
List-Id: linux-scsi@vger.kernel.org

This patch fixes following warning

drivers/scsi/qla2xxx/qla_target.c:3587 qlt_do_ctio_completion()
warn: impossible condition '(logged_out == 41) => (0-1 == 41)'

drivers/scsi/qla2xxx/qla_target.c
 3580                  case CTIO_PORT_LOGGED_OUT:
 3581                  case CTIO_PORT_UNAVAILABLE:
 3582                  {
 3583                          bool logged_out = (status & 0xFFFF);
 3584                          ql_dbg(ql_dbg_tgt_mgt, vha, 0xf059,
 3585				   "qla_target(%d): CTIO with %s status %x "
 3586                              "received (state %x, se_cmd %p)\n", vha->vp_idx,
 3587                              (logged_out == CTIO_PORT_LOGGED_OUT) ?
 				    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				    Bool cannot equal 0x26.
 3588				   "PORT LOGGED OUT" : "PORT UNAVAILABLE",

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 80651cd..829b534 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3597,12 +3597,13 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 		case CTIO_PORT_LOGGED_OUT:
 		case CTIO_PORT_UNAVAILABLE:
 		{
-			bool logged_out = (status & 0xFFFF);
+			bool logged_out =
+			    (status & 0xFFFF) == CTIO_PORT_LOGGED_OUT;
+
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf059,
 			    "qla_target(%d): CTIO with %s status %x "
 			    "received (state %x, se_cmd %p)\n", vha->vp_idx,
-			    (logged_out == CTIO_PORT_LOGGED_OUT) ?
-			    "PORT LOGGED OUT" : "PORT UNAVAILABLE",
+			    logged_out ? "PORT LOGGED OUT" : "PORT UNAVAILABLE",
 			    status, cmd->state, se_cmd);
 
 			if (logged_out && cmd->sess) {
-- 
1.7.1
