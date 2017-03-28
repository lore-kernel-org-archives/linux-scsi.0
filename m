From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: hisi_sas: add missing break in switch statement
Date: Tue, 28 Mar 2017 12:12:22 +0100
Message-ID: <20170328111222.17303-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

It appears that a break in the TRANS_TX_OPEN_CNX_ERR_NO_DESTINATION
case got accidentally removed in an earlier commit, as it stands,
the ts->stat and ts->open_rej_reason are being updated twice for this
case which looks incorrect.  Fix this by adding in the missing break
statement.

Detected by CoverityScan, CID#1422110 ("Missing break in switch")

Fixes: 634a9585f49c7 ("scsi: hisi_sas: process error codes according to their priority")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index a3af380dde9e..66c2de8b7b64 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1709,6 +1709,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 		{
 			ts->stat = SAS_OPEN_REJECT;
 			ts->open_rej_reason = SAS_OREJ_NO_DEST;
+			break;
 		}
 		case TRANS_TX_OPEN_CNX_ERR_PROTOCOL_NOT_SUPPORTED:
 		{
-- 
2.11.0
