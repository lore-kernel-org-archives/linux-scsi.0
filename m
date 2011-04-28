From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH] bnx2fc: setup em for npiv port
Date: Thu, 28 Apr 2011 15:55:44 -0700
Message-ID: <1304031344.10064.39.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4191 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab1D1Wzv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2011 18:55:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

From: Vasu Dev <vasu.dev@intel.com>

Use fc_exch_mgr_list_clone to setup em for npiv port.

Also remove redundant vport and lport initializations.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---

 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index e476e87..71842a7 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1296,20 +1296,17 @@ setup_err:
 static struct fc_lport *bnx2fc_if_create(struct bnx2fc_hba *hba,
 				  struct device *parent, int npiv)
 {
-	struct fc_lport		*lport = NULL;
+	struct fc_lport		*lport, *n_port;
 	struct fcoe_port	*port;
 	struct Scsi_Host	*shost;
 	struct fc_vport		*vport = dev_to_vport(parent);
 	int			rc = 0;
 
 	/* Allocate Scsi_Host structure */
-	if (!npiv) {
-		lport = libfc_host_alloc(&bnx2fc_shost_template,
-					  sizeof(struct fcoe_port));
-	} else {
-		lport = libfc_vport_create(vport,
-					   sizeof(struct fcoe_port));
-	}
+	if (!npiv)
+		lport = libfc_host_alloc(&bnx2fc_shost_template, sizeof(*port));
+	else
+		lport = libfc_vport_create(vport, sizeof(*port));
 
 	if (!lport) {
 		printk(KERN_ERR PFX "could not allocate scsi host structure\n");
@@ -1327,7 +1324,6 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_hba *hba,
 		goto lp_config_err;
 
 	if (npiv) {
-		vport = dev_to_vport(parent);
 		printk(KERN_ERR PFX "Setting vport names, 0x%llX 0x%llX\n",
 			vport->node_name, vport->port_name);
 		fc_set_wwnn(lport, vport->node_name);
@@ -1356,12 +1352,17 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_hba *hba,
 	fc_host_port_type(lport->host) = FC_PORTTYPE_UNKNOWN;
 
 	/* Allocate exchange manager */
-	if (!npiv) {
+	if (!npiv)
 		rc = bnx2fc_em_config(lport);
-		if (rc) {
-			printk(KERN_ERR PFX "Error on bnx2fc_em_config\n");
-			goto shost_err;
-		}
+	else {
+		shost = vport_to_shost(vport);
+		n_port = shost_priv(shost);
+		rc = fc_exch_mgr_list_clone(n_port, lport);
+	}
+
+	if (rc) {
+		printk(KERN_ERR PFX "Error on bnx2fc_em_config\n");
+		goto shost_err;
 	}
 
 	bnx2fc_interface_get(hba);



