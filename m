From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 14/21] lpfc: Remove global lpfc_enable_npiv attribute in
 leiu of per-hba lpfc_enable_npiv
Date: Wed, 06 Jul 2016 12:36:07 -0700
Message-ID: <577d5da7./vyZx4juvghfj41Q%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38612 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbcGFTgN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:13 -0400
Received: by mail-wm0-f46.google.com with SMTP id r201so5686919wme.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:12 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id l1sm410808wjy.17.2016.07.06.12.36.09
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Remove global lpfc_enable_npiv attribute in leiu of per-hba lpfc_enable_npiv

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c |  8 ++------
 drivers/scsi/lpfc/lpfc_crtn.h |  1 -
 drivers/scsi/lpfc/lpfc_init.c | 24 +++++++++---------------
 3 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index a75404a..25d91a8 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2844,12 +2844,8 @@ MODULE_PARM_DESC(lpfc_sli_mode, "SLI mode selector:"
 		 " 2 - select SLI-2 even on SLI-3 capable HBAs,"
 		 " 3 - select SLI-3");
 
-int lpfc_enable_npiv = 1;
-module_param(lpfc_enable_npiv, int, S_IRUGO);
-MODULE_PARM_DESC(lpfc_enable_npiv, "Enable NPIV functionality");
-lpfc_param_show(enable_npiv);
-lpfc_param_init(enable_npiv, 1, 0, 1);
-static DEVICE_ATTR(lpfc_enable_npiv, S_IRUGO, lpfc_enable_npiv_show, NULL);
+LPFC_ATTR_R(enable_npiv, 1, 0, 1,
+	"Enable NPIV functionality");
 
 LPFC_ATTR_R(fcf_failover_policy, 1, 1, 2,
 	"FCF Fast failover=1 Priority failover=2");
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index bc0e2f1..b8a2ddc 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -360,7 +360,6 @@ extern struct scsi_host_template lpfc_vport_template;
 extern struct fc_function_template lpfc_transport_functions;
 extern struct fc_function_template lpfc_vport_transport_functions;
 extern int lpfc_sli_mode;
-extern int lpfc_enable_npiv;
 extern int lpfc_delay_discovery;
 
 int  lpfc_vport_symbolic_node_name(struct lpfc_vport *, char *, size_t);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f4b3548..adf61b43 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11441,21 +11441,17 @@ lpfc_init(void)
 		printk(KERN_ERR "Could not register lpfcmgmt device, "
 			"misc_register returned with status %d", error);
 
-	if (lpfc_enable_npiv) {
-		lpfc_transport_functions.vport_create = lpfc_vport_create;
-		lpfc_transport_functions.vport_delete = lpfc_vport_delete;
-	}
+	lpfc_transport_functions.vport_create = lpfc_vport_create;
+	lpfc_transport_functions.vport_delete = lpfc_vport_delete;
 	lpfc_transport_template =
 				fc_attach_transport(&lpfc_transport_functions);
 	if (lpfc_transport_template == NULL)
 		return -ENOMEM;
-	if (lpfc_enable_npiv) {
-		lpfc_vport_transport_template =
-			fc_attach_transport(&lpfc_vport_transport_functions);
-		if (lpfc_vport_transport_template == NULL) {
-			fc_release_transport(lpfc_transport_template);
-			return -ENOMEM;
-		}
+	lpfc_vport_transport_template =
+		fc_attach_transport(&lpfc_vport_transport_functions);
+	if (lpfc_vport_transport_template == NULL) {
+		fc_release_transport(lpfc_transport_template);
+		return -ENOMEM;
 	}
 
 	/* Initialize in case vector mapping is needed */
@@ -11467,8 +11463,7 @@ lpfc_init(void)
 	error = pci_register_driver(&lpfc_driver);
 	if (error) {
 		fc_release_transport(lpfc_transport_template);
-		if (lpfc_enable_npiv)
-			fc_release_transport(lpfc_vport_transport_template);
+		fc_release_transport(lpfc_vport_transport_template);
 	}
 
 	return error;
@@ -11487,8 +11482,7 @@ lpfc_exit(void)
 	misc_deregister(&lpfc_mgmt_dev);
 	pci_unregister_driver(&lpfc_driver);
 	fc_release_transport(lpfc_transport_template);
-	if (lpfc_enable_npiv)
-		fc_release_transport(lpfc_vport_transport_template);
+	fc_release_transport(lpfc_vport_transport_template);
 	if (_dump_buf_data) {
 		printk(KERN_ERR	"9062 BLKGRD: freeing %lu pages for "
 				"_dump_buf_data at 0x%p\n",
-- 
2.5.0

