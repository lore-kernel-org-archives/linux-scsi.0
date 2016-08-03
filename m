From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] qla2xxx: small cleanup in qla2x00_wait_for_hba_ready()
Date: Wed, 3 Aug 2016 21:42:32 +0300
Message-ID: <20160803184232.GA775@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, Sawan Chandak <sawan.chandak@qlogic.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The "if (test_bit(UNLOADING..." line was indented one tab more than it
should have been.  There was an extra parenthesis around the
qla2x00_reset_active() function call.  I lined up the conditions a bit
so that it shows how they group together.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2674f4c..1dd8650 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -899,12 +899,12 @@ qla2x00_wait_for_hba_ready(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
-	while (((qla2x00_reset_active(vha)) || ha->dpc_active ||
-	    ha->flags.mbox_busy) ||
-		test_bit(FX00_RESET_RECOVERY, &vha->dpc_flags) ||
-		test_bit(FX00_TARGET_SCAN, &vha->dpc_flags)) {
-			if (test_bit(UNLOADING, &base_vha->dpc_flags))
-				break;
+	while ((qla2x00_reset_active(vha) || ha->dpc_active ||
+		ha->flags.mbox_busy) ||
+	       test_bit(FX00_RESET_RECOVERY, &vha->dpc_flags) ||
+	       test_bit(FX00_TARGET_SCAN, &vha->dpc_flags)) {
+		if (test_bit(UNLOADING, &base_vha->dpc_flags))
+			break;
 		msleep(1000);
 	}
 }
