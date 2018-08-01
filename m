From: Colin King <colin.king@canonical.com>
Subject: [PATCH] [SCSI] sym53c8xx: remove some redundant variables
Date: Wed,  1 Aug 2018 15:58:41 +0100
Message-ID: <20180801145841.5877-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variables scriptb0 and dp_sgmin are being assigned but are never
used hence they are redundant and can be removed.

Cleans up clang warnings:
warning: variable 'scriptb0' set but not used [-Wunused-but-set-variable]
warning: variable 'dp_sgmin' set but not used [-Wunused-but-set-variable]

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/sym53c8xx_2/sym_fw.c   | 4 ----
 drivers/scsi/sym53c8xx_2/sym_hipd.c | 3 +--
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_fw.c b/drivers/scsi/sym53c8xx_2/sym_fw.c
index 190770bdc194..91db17727963 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw.c
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.c
@@ -295,10 +295,8 @@ static void
 sym_fw1_setup(struct sym_hcb *np, struct sym_fw *fw)
 {
 	struct sym_fw1a_scr *scripta0;
-	struct sym_fw1b_scr *scriptb0;
 
 	scripta0 = (struct sym_fw1a_scr *) np->scripta0;
-	scriptb0 = (struct sym_fw1b_scr *) np->scriptb0;
 
 	/*
 	 *  Fill variable parts in scripts.
@@ -319,10 +317,8 @@ static void
 sym_fw2_setup(struct sym_hcb *np, struct sym_fw *fw)
 {
 	struct sym_fw2a_scr *scripta0;
-	struct sym_fw2b_scr *scriptb0;
 
 	scripta0 = (struct sym_fw2a_scr *) np->scripta0;
-	scriptb0 = (struct sym_fw2b_scr *) np->scriptb0;
 
 	/*
 	 *  Fill variable parts in scripts.
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 378af306fda1..bd3f6e2d6834 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -3855,7 +3855,7 @@ static void sym_modify_dp(struct sym_hcb *np, struct sym_tcb *tp, struct sym_ccb
 
 int sym_compute_residual(struct sym_hcb *np, struct sym_ccb *cp)
 {
-	int dp_sg, dp_sgmin, resid = 0;
+	int dp_sg, resid = 0;
 	int dp_ofs = 0;
 
 	/*
@@ -3902,7 +3902,6 @@ int sym_compute_residual(struct sym_hcb *np, struct sym_ccb *cp)
 	 *  We are now full comfortable in the computation 
 	 *  of the data residual (2's complement).
 	 */
-	dp_sgmin = SYM_CONF_MAX_SG - cp->segments;
 	resid = -cp->ext_ofs;
 	for (dp_sg = cp->ext_sg; dp_sg < SYM_CONF_MAX_SG; ++dp_sg) {
 		u_int tmp = scr_to_cpu(cp->phys.data[dp_sg].size);
-- 
2.17.1
