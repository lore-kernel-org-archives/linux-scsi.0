From: Colin King <colin.king@canonical.com>
Subject: [PATCH][scsi-next] scsi: qla2xxx: remove redundant assignment of d
Date: Fri,  5 Jan 2018 15:50:37 +0000
Message-ID: <20180105155037.17981-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The initialization of d is redundant as this value is never read
and it is overwritten inside the subsequent for-loop.  Remove this
redundant assignment.

Cleans up clang warning:
drivers/scsi/qla2xxx/qla_gs.c:3985:29: warning: Value stored to 'd'
during its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 6bfe24eeb402..f40ea8f120b7 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3982,7 +3982,7 @@ static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
 		(struct ct_sns_req *)sp->u.iocb_cmd.u.ctarg.req;
 	struct ct_sns_gpnft_rsp *ct_rsp =
 		(struct ct_sns_gpnft_rsp *)sp->u.iocb_cmd.u.ctarg.rsp;
-	struct ct_sns_gpn_ft_data *d = &ct_rsp->entries[0];
+	struct ct_sns_gpn_ft_data *d;
 	struct fab_scan_rp *rp;
 	int i, j, k;
 	u16 cmd = be16_to_cpu(ct_req->command);
-- 
2.15.1
