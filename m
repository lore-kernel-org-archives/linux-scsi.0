From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] SCSI-dpt_i2o: Use common error handling code in
 adpt_hba_reset()
Date: Thu, 2 Nov 2017 18:04:04 +0100
Message-ID: <373ac00e-099e-2ced-37aa-194541eef3d8@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, aacraid@adaptec.com, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 2 Nov 2017 17:45:14 +0100

* Adjust five function calls together with a variable assignment.

* Add a jump target so that a bit of exception handling can be better
  reused at the end of this function.

  This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/dpt_i2o.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index fd172b0890d3..cbe1a36fb531 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -832,37 +832,40 @@ static int adpt_hba_reset(adpt_hba* pHba)
 	pHba->state |= DPTI_STATE_RESET;
 
 	// Activate does get status , init outbound, and get hrt
-	if ((rcode=adpt_i2o_activate_hba(pHba)) < 0) {
+	rcode = adpt_i2o_activate_hba(pHba);
+	if (rcode < 0) {
 		printk(KERN_ERR "%s: Could not activate\n", pHba->name);
-		adpt_i2o_delete_hba(pHba);
-		return rcode;
+		goto delete_hba;
 	}
 
-	if ((rcode=adpt_i2o_build_sys_table()) < 0) {
-		adpt_i2o_delete_hba(pHba);
-		return rcode;
-	}
+	rcode = adpt_i2o_build_sys_table();
+	if (rcode < 0)
+		goto delete_hba;
+
 	PDEBUG("%s: in HOLD state\n",pHba->name);
 
-	if ((rcode=adpt_i2o_online_hba(pHba)) < 0) {
-		adpt_i2o_delete_hba(pHba);	
-		return rcode;
-	}
+	rcode = adpt_i2o_online_hba(pHba);
+	if (rcode < 0)
+		goto delete_hba;
+
 	PDEBUG("%s: in OPERATIONAL state\n",pHba->name);
 
-	if ((rcode=adpt_i2o_lct_get(pHba)) < 0){
-		adpt_i2o_delete_hba(pHba);
-		return rcode;
-	}
+	rcode = adpt_i2o_lct_get(pHba);
+	if (rcode < 0)
+		goto delete_hba;
+
+	rcode = adpt_i2o_reparse_lct(pHba);
+	if (rcode < 0)
+		goto delete_hba;
 
-	if ((rcode=adpt_i2o_reparse_lct(pHba)) < 0){
-		adpt_i2o_delete_hba(pHba);
-		return rcode;
-	}
 	pHba->state &= ~DPTI_STATE_RESET;
 
 	adpt_fail_posted_scbs(pHba);
 	return 0;	/* return success */
+
+delete_hba:
+	adpt_i2o_delete_hba(pHba);
+	return rcode;
 }
 
 /*===========================================================================
-- 
2.15.0
