From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: qla2xxx: Remove unnecessary self assignment
Date: Thu, 20 Sep 2018 15:17:06 -0700
Message-ID: <20180920221706.4948-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Clang warns when a variable is assigned to itself.

drivers/scsi/qla2xxx/qla_mbx.c:1514:4: warning: explicitly assigning
value of variable of type 'uint64_t' (aka 'unsigned long long') to
itself [-Wself-assign]
        l = l;
        ~ ^ ~
1 warning generated.

This construct is usually used to avoid unused variable warnings, which
I assume is the case here. -Wunused-parameter is hidden behind -Wextra
with GCC 4.6, which is the minimum version to compile the kernel as of
commit cafa0010cd51 ("Raise the minimum required gcc version to 4.6").
Just remove this line to silence Clang.

Link: https://github.com/ClangBuiltLinux/linux/issues/83
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index e016ee9c6d8e..f801aae84cef 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1511,7 +1511,6 @@ qla2x00_abort_target(struct fc_port *fcport, uint64_t l, int tag)
 	struct req_que *req;
 	struct rsp_que *rsp;
 
-	l = l;
 	vha = fcport->vha;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x103e,
-- 
2.19.0
