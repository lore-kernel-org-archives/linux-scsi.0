From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] scsi: dpt_i2o: double free if adpt_i2o_online_hba() fails
Date: Fri, 16 Dec 2016 12:35:39 +0300
Message-ID: <20161216093539.GC13942@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There are two places where adpt_i2o_online_hba() is called.  Both
callers call adpt_i2o_delete_hba(pHba) if adpt_i2o_online_hba() fails
and since we also free it here that causes a double free bug.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This bug pre-dates git.

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 27c0dce22e72..7d32c2f07067 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2768,16 +2768,12 @@ static int adpt_i2o_activate_hba(adpt_hba* pHba)
  
 static int adpt_i2o_online_hba(adpt_hba* pHba)
 {
-	if (adpt_i2o_systab_send(pHba) < 0) {
-		adpt_i2o_delete_hba(pHba);
+	if (adpt_i2o_systab_send(pHba) < 0)
 		return -1;
-	}
 	/* In READY state */
 
-	if (adpt_i2o_enable_hba(pHba) < 0) {
-		adpt_i2o_delete_hba(pHba);
+	if (adpt_i2o_enable_hba(pHba) < 0)
 		return -1;
-	}
 
 	/* In OPERATIONAL state  */
 	return 0;
