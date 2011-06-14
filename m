From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 03/07] mpt2sas: Set max_sector count from module para
Date: Tue, 14 Jun 2011 10:56:12 +0530
Message-ID: <20110614052609.GE14349@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:57633 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081Ab1FNFLD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2011 01:11:03 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

This feature is to override the default
max_sectors setting at load time, taking max_sectors as an
command line option when loading the driver.  The setting is
currently hard-coded in the driver to 8192 sectors (4MB transfers).
If max_sectors is specified at load time, minimum specified
setting will be 64, and the maximum is 8192.  The driver will
modify the setting to be on even boundary. If max_sectors is not
specified, the driver will default to 8192.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index c88ee83..ff0178a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -94,6 +94,10 @@ static u32 logging_level;
 MODULE_PARM_DESC(logging_level, " bits for enabling additional logging info "
     "(default=0)");
 
+static ushort max_sectors = 0xFFFF;
+module_param(max_sectors, ushort, 0);
+MODULE_PARM_DESC(max_sectors, "max sectors, range 64 to 8192  default=8192");
+
 /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
 #define MPT2SAS_MAX_LUN (16895)
 static int max_lun = MPT2SAS_MAX_LUN;
@@ -7400,6 +7404,25 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->transportt = mpt2sas_transport_template;
 	shost->unique_id = ioc->id;
 
+	if (max_sectors != 0xFFFF) {
+		if (max_sectors < 64) {
+			shost->max_sectors = 64;
+			printk(MPT2SAS_WARN_FMT "Invalid value %d passed "
+			    "for max_sectors, range is 64 to 8192. Assigning "
+			    "value of 64.\n", ioc->name, max_sectors);
+		} else if (max_sectors > 8192) {
+			shost->max_sectors = 8192;
+			printk(MPT2SAS_WARN_FMT "Invalid value %d passed "
+			    "for max_sectors, range is 64 to 8192. Assigning "
+			    "default value of 8192.\n", ioc->name,
+			    max_sectors);
+		} else {
+			shost->max_sectors = max_sectors & 0xFFFE;
+			printk(MPT2SAS_INFO_FMT "The max_sectors value is "
+			    "set to %d\n", ioc->name, shost->max_sectors);
+		}
+	}
+
 	if ((scsi_add_host(shost, &pdev->dev))) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
