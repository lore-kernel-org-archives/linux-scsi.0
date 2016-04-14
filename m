From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] scsi: ufs: silence uninitialized variable warning
Date: Thu, 14 Apr 2016 12:37:03 +0300
Message-ID: <20160414093703.GI16549@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If ufshcd_dme_get() fails then "tx_lanes" can be uninitialized.  I've
initialized it to zero so that the rest of the function turns into a
no-op in that situation.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f8fa72c..6741d9e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3038,7 +3038,9 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 
 static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
 {
-	int tx_lanes, i, err = 0;
+	int tx_lanes = 0;
+	int err = 0;
+	int i;
 
 	if (!peer)
 		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
