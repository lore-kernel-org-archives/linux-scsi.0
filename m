From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: qedi: fix missing return error code check on call to qedi_setup_int
Date: Tue, 28 Feb 2017 11:02:48 +0000
Message-ID: <20170228110248.19290-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The call to qedi_setup_int is not updating the return code rc yet rc
is being checked for an error. Fix this by assigning rc to the return
code from the call to qedi_setup_int.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qedi/qedi_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 5eda21d..8e3d928 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1805,7 +1805,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 	 */
 	qedi_ops->common->update_pf_params(qedi->cdev, &qedi->pf_params);
 
-	qedi_setup_int(qedi);
+	rc = qedi_setup_int(qedi);
 	if (rc)
 		goto stop_iscsi_func;
 
-- 
2.10.2
