From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 09/20] qla2xxx: Change check_stop_free to always return 1
Date: Mon, 7 Dec 2015 19:48:56 -0500
Message-ID: <1449535747-2850-10-git-send-email-himanshu.madhani@qlogic.com>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

change tcm_qla2xxx_check_stop_free to always return 1
to prevent transport_cmd_finish_abort from accidently
taking extra kref_put.

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 74c6e9b..366142a 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -314,7 +314,8 @@ static int tcm_qla2xxx_check_stop_free(struct se_cmd *se_cmd)
 		cmd->cmd_flags |= BIT_14;
 	}
 
-	return target_put_sess_cmd(se_cmd);
+	target_put_sess_cmd(se_cmd);
+	return 1;
 }
 
 /* tcm_qla2xxx_release_cmd - Callback from TCM Core to release underlying
-- 
1.7.7
