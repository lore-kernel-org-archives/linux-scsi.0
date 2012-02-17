From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH] qla2xxx: Fix NULL pointer dereference
Date: Fri, 17 Feb 2012 15:39:39 -0500
Message-ID: <20120217203939.GA955@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

Afaics the assignment does not need to be protected by ha->tgt_mutex and
we definitely should check for NULL before dereferencing sess.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/qla2xxx/qla_target.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ac203ef..4bbfa88 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2586,12 +2586,12 @@ static void qla_tgt_do_work(struct work_struct *work)
 
 		mutex_lock(&ha->tgt_mutex);
 		cmd->sess = sess = qla_tgt_make_local_sess(vha, s_id, loop_id);
-		cmd->loop_id = sess->loop_id;
 		/* sess has got an extra creation ref */
 		mutex_unlock(&ha->tgt_mutex);
 
 		if (!sess)
 			goto out_term;
+		cmd->loop_id = sess->loop_id;
 	}
 
 	if (tgt->tgt_stop)
-- 
1.7.8.3
