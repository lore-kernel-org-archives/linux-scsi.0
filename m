From: Colin King <colin.king@canonical.com>
Subject: [PATCH] qla2xxx: rename {vendor|hba}_indentifer to {vendor|hba}_identifer
Date: Thu, 29 Dec 2016 22:20:38 +0000
Message-ID: <20161229222038.29984-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Rename the vendor_indentifer and hba_indentifer fields to correct spelling.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 4 ++--
 drivers/scsi/qla2xxx/qla_gs.c  | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f7df01b..ef699b6 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2247,7 +2247,7 @@ struct ct_fdmiv2_hba_attr {
 		uint32_t num_ports;
 		uint8_t fabric_name[WWN_SIZE];
 		uint8_t bios_name[32];
-		uint8_t vendor_indentifer[8];
+		uint8_t vendor_identifier[8];
 	} a;
 };
 
@@ -2422,7 +2422,7 @@ struct ct_sns_req {
 		} rsnn_nn;
 
 		struct {
-			uint8_t hba_indentifier[8];
+			uint8_t hba_identifier[8];
 		} ghat;
 
 		struct {
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 94e8a85..ee3df87 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1939,15 +1939,15 @@ qla2x00_fdmiv2_rhba(scsi_qla_host_t *vha)
 	/* Vendor Identifier */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_TYPE_VENDOR_IDENTIFIER);
-	snprintf(eiter->a.vendor_indentifer, sizeof(eiter->a.vendor_indentifer),
+	snprintf(eiter->a.vendor_identifier, sizeof(eiter->a.vendor_identifier),
 	    "%s", "QLGC");
-	alen = strlen(eiter->a.vendor_indentifer);
+	alen = strlen(eiter->a.vendor_identifier);
 	alen += 4 - (alen & 3);
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20b1,
-	    "Vendor Identifier = %s.\n", eiter->a.vendor_indentifer);
+	    "Vendor Identifier = %s.\n", eiter->a.vendor_identifier);
 
 	/* Update MS request size. */
 	qla2x00_update_ms_fdmi_iocb(vha, size + 16);
-- 
2.10.2
