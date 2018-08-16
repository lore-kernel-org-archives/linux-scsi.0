From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: be2iscsi: remove unused variable dmsg
Date: Thu, 16 Aug 2018 15:02:54 +0100
Message-ID: <20180816140254.20955-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable dmsg is not being used and is redundant and hence can
be removed.

Cleans up clang warning:
warning: variable 'dmsg' set but not used [-Wunused-but-set-variable]

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/be2iscsi/be_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 3660059784f7..d544453aa466 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1866,7 +1866,6 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 {
 	struct be_queue_info *cq;
 	struct sol_cqe *sol;
-	struct dmsg_cqe *dmsg;
 	unsigned int total = 0;
 	unsigned int num_processed = 0;
 	unsigned short code = 0, cid = 0;
@@ -1939,7 +1938,6 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 				    "BM_%d : Received %s[%d] on CID : %d\n",
 				    cqe_desc[code], code, cid);
 
-			dmsg = (struct dmsg_cqe *)sol;
 			hwi_complete_drvr_msgs(beiscsi_conn, phba, sol);
 			break;
 		case UNSOL_HDR_NOTIFY:
-- 
2.17.1
