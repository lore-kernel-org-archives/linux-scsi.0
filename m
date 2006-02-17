From: Brian King <brking@us.ibm.com>
Subject: [PATCH 13/16] ipr: Simplify status area dumping
Date: Fri, 17 Feb 2006 16:21:05 -0600
Message-ID: <200602172221.k1HML6mS005349@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:33467 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751850AbWBQWVH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Feb 2006 17:21:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


Simplify the dumping of the command status area by
removing some device specific information that has proven
to not be worthwhile.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   39 +++--------------------------------
 1 files changed, 4 insertions(+), 35 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_dump_ioasa_simplify drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_dump_ioasa_simplify	2006-01-31 16:53:22.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-01-31 16:53:22.000000000 -0600
@@ -164,29 +164,6 @@ MODULE_PARM_DESC(auto_create, "Auto-crea
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IPR_DRIVER_VERSION);
 
-static const char *ipr_gpdd_dev_end_states[] = {
-	"Command complete",
-	"Terminated by host",
-	"Terminated by device reset",
-	"Terminated by bus reset",
-	"Unknown",
-	"Command not started"
-};
-
-static const char *ipr_gpdd_dev_bus_phases[] = {
-	"Bus free",
-	"Arbitration",
-	"Selection",
-	"Message out",
-	"Command",
-	"Message in",
-	"Data out",
-	"Data in",
-	"Status",
-	"Reselection",
-	"Unknown"
-};
-
 /*  A constant array of IOASCs/URCs/Error Messages */
 static const
 struct ipr_error_table_t ipr_error_table[] = {
@@ -3938,6 +3915,7 @@ static void ipr_erp_cancel_all(struct ip
  * ipr_dump_ioasa - Dump contents of IOASA
  * @ioa_cfg:	ioa config struct
  * @ipr_cmd:	ipr command struct
+ * @res:		resource entry struct
  *
  * This function is invoked by the interrupt handler when ops
  * fail. It will log the IOASA if appropriate. Only called
@@ -3947,7 +3925,7 @@ static void ipr_erp_cancel_all(struct ip
  * 	none
  **/
 static void ipr_dump_ioasa(struct ipr_ioa_cfg *ioa_cfg,
-			   struct ipr_cmnd *ipr_cmd)
+			   struct ipr_cmnd *ipr_cmd, struct ipr_resource_entry *res)
 {
 	int i;
 	u16 data_len;
@@ -3975,16 +3953,7 @@ static void ipr_dump_ioasa(struct ipr_io
 			return;
 	}
 
-	ipr_sdev_err(ipr_cmd->scsi_cmd->device, "%s\n",
-		     ipr_error_table[error_index].error);
-
-	if ((ioasa->u.gpdd.end_state <= ARRAY_SIZE(ipr_gpdd_dev_end_states)) &&
-	    (ioasa->u.gpdd.bus_phase <=  ARRAY_SIZE(ipr_gpdd_dev_bus_phases))) {
-		ipr_sdev_err(ipr_cmd->scsi_cmd->device,
-			     "Device End state: %s Phase: %s\n",
-			     ipr_gpdd_dev_end_states[ioasa->u.gpdd.end_state],
-			     ipr_gpdd_dev_bus_phases[ioasa->u.gpdd.bus_phase]);
-	}
+	ipr_res_err(ioa_cfg, res, "%s\n", ipr_error_table[error_index].error);
 
 	if (sizeof(struct ipr_ioasa) < be16_to_cpu(ioasa->ret_stat_len))
 		data_len = sizeof(struct ipr_ioasa);
@@ -4141,7 +4110,7 @@ static void ipr_erp_start(struct ipr_ioa
 	}
 
 	if (ipr_is_gscsi(res))
-		ipr_dump_ioasa(ioa_cfg, ipr_cmd);
+		ipr_dump_ioasa(ioa_cfg, ipr_cmd, res);
 	else
 		ipr_gen_sense(ipr_cmd);
 
_
