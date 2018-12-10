From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: qla2xxx: fix unused function warning
Date: Mon, 10 Dec 2018 21:51:43 +0100
Message-ID: <20181210205215.2703138-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Laurence Oberman <loberman@redhat.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, Himanshu Madhani <hmadhani@marvell.com>, Quinn Tran <quinn.tran@cavium.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Darren Trapp <darren.trapp@cavium.com>, Bill Kuzeja <William.Kuzeja@stratus.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In what seems to be a mismatch between the scsi-fixes branch and
the scsi-mkp/for-next branch, a newly introduced variable from
one patch got obsoleted in another one:

drivers/scsi/qla2xxx/qla_os.c: In function '__qla2x00_abort_all_cmds':
drivers/scsi/qla2xxx/qla_os.c:1791:11: error: unused variable 'status' [-Werror=unused-variable]

Remove the variable again.

Fixes: c4e521b654e1 ("scsi: qla2xxx: Split the __qla2x00_abort_all_cmds() function")
Fixes: f2ffd4e5bc7b ("scsi: qla2xxx: Timeouts occur on surprise removal of QLogic adapter")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Maybe check carefully that the merge in linux-next is otherwise correct
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 63c47bc7ae59..db331cb5ba3c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1788,7 +1788,7 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 static void
 __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 {
-	int cnt, status;
+	int cnt;
 	unsigned long flags;
 	srb_t *sp;
 	scsi_qla_host_t *vha = qp->vha;
-- 
2.20.0
