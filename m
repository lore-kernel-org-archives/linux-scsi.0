From: madhu.iyengar@qlogic.com
Subject: [PATCH 08/12] qla2xxx: Allow an override of the registered maximum LUN.
Date: Fri,  6 May 2011 17:30:19 -0700
Message-ID: <1304728223-30817-14-git-send-email-madhu.iyengar@qlogic.com>
References: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:32818 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753608Ab1EGAnL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2011 20:43:11 -0400
In-Reply-To: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

The 'max_lun' value registered for each scsi_host is currently
capped at 0xffff.  The new module parameter can allow for
2nd-level flat-space addressing method-infrastructure to be
supported.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    1 +
 drivers/scsi/qla2xxx/qla_mid.c |    2 +-
 drivers/scsi/qla2xxx/qla_os.c  |    8 +++++++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 53968cc..79a12aa 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -103,6 +103,7 @@ extern int ql2xenabledif;
 extern int ql2xenablehba_err_chk;
 extern int ql2xtargetreset;
 extern int ql2xdontresethba;
+extern unsigned int ql2xmaxlun;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index e34d7dd..5e34391 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -456,7 +456,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	else
 		host->max_cmd_len = MAX_CMDSZ;
 	host->max_channel = MAX_BUSES - 1;
-	host->max_lun = MAX_LUNS;
+	host->max_lun = ql2xmaxlun;
 	host->unique_id = host->host_no;
 	host->max_id = MAX_TARGETS_2200;
 	host->transportt = qla2xxx_transport_vport_template;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8401a6f..f461925 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -172,6 +172,12 @@ MODULE_PARM_DESC(ql2xdontresethba,
 	" 0 (Default) -- Reset on failure.\n"
 	" 1 -- Do not reset on failure.\n");
 
+uint ql2xmaxlun = MAX_LUNS;
+module_param(ql2xmaxlun, uint, S_IRUGO);
+MODULE_PARM_DESC(ql2xmaxlun,
+		"Defines the maximum LU number to register with the SCSI "
+		"midlayer. Default is 65535.");
+
 /*
  * SCSI host template entry points
  */
@@ -2136,7 +2142,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	else
 		host->max_cmd_len = MAX_CMDSZ;
 	host->max_channel = MAX_BUSES - 1;
-	host->max_lun = MAX_LUNS;
+	host->max_lun = ql2xmaxlun;
 	host->transportt = qla2xxx_transport_template;
 	sht->vendor_id = (SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC);
 
-- 
1.6.0.2

