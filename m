From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: bfa: bfad_attr.c:  Optimization of the code
Date: Sat,  7 Jun 2014 00:04:33 +0200
Message-ID: <1402092273-5992-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Minimized the use of snprintf()
And removed a variable that was only used for the temporary storage.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bfa/bfad_attr.c |  114 ++++++++++++++++++++++++------------------
 1 file changed, 66 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 40be670..3fe75ff 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -751,69 +751,89 @@ bfad_im_model_desc_show(struct device *dev, struct device_attribute *attr,
 	bfa_get_adapter_model(&bfad->bfa, model);
 	nports = bfa_get_nports(&bfad->bfa);
 	if (!strcmp(model, "Brocade-425"))
-		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 4Gbps PCIe dual port FC HBA");
+		strlcpy(model_descr,
+				"Brocade 4Gbps PCIe dual port FC HBA\n",
+				BFA_ADAPTER_MODEL_DESCR_LEN);
 	else if (!strcmp(model, "Brocade-825"))
-		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 8Gbps PCIe dual port FC HBA");
+		strlcpy(model_descr,
+				"Brocade 8Gbps PCIe dual port FC HBA\n",
+				BFA_ADAPTER_MODEL_DESCR_LEN);
 	else if (!strcmp(model, "Brocade-42B"))
-		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 4Gbps PCIe dual port FC HBA for HP");
+		strlcpy(model_descr,
+				"Brocade 4Gbps PCIe dual port FC HBA for HP\n",
+				BFA_ADAPTER_MODEL_DESCR_LEN);
 	else if (!strcmp(model, "Brocade-82B"))
-		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 8Gbps PCIe dual port FC HBA for HP");
+		strlcpy(model_descr,
+				"Brocade 8Gbps PCIe dual port FC HBA for HP\n",
+				BFA_ADAPTER_MODEL_DESCR_LEN);
 	else if (!strcmp(model, "Brocade-1010"))
-		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 10Gbps single port CNA");
+		strlcpy(model_descr,
+				"Brocade 10Gbps single port CNA\n",
+				BFA_ADAPTER_MODEL_DESCR_LEN);
 	else if (!strcmp(model, "Brocade-1020"))
-		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 10Gbps dual port CNA");
+		strlcpy(model_descr,
+				"Brocade 10Gbps dual port CNA\n",
+				BFA_ADAPTER_MODEL_DESCR_LEN);
 	else if (!strcmp(model, "Brocade-1007"))
-		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 10Gbps CNA for IBM Blade Center");
+		strlcpy(model_descr,
+				"Brocade 10Gbps CNA for IBM Blade Center\n",
+				BFA_ADAPTER_MODEL_DESCR_LEN);
 	else if (!strcmp(model, "Brocade-415"))
-		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 4Gbps PCIe single port FC HBA");
+		strlcpy(model_descr,
+				"Brocade 4Gbps PCIe single port FC HBA\n",
+				BFA_ADAPTER_MODEL_DESCR_LEN);
 	else if (!strcmp(model, "Brocade-815"))
-		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 8Gbps PCIe single port FC HBA");
+		strlcpy(model_descr,
+				"Brocade 8Gbps PCIe single port FC HBA\n",
+				BFA_ADAPTER_MODEL_DESCR_LEN);
 	else if (!strcmp(model, "Brocade-41B"))
-		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 4Gbps PCIe single port FC HBA for HP");
+		strlcpy(model_descr,
+				"Brocade 4Gbps PCIe single port FC HBA for HP\n",
+				BFA_ADAPTER_MODEL_DESCR_LEN);
 	else if (!strcmp(model, "Brocade-81B"))
-		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 8Gbps PCIe single port FC HBA for HP");
+		strlcpy(model_descr,
+				"Brocade 8Gbps PCIe single port FC HBA for HP\n",
+				BFA_ADAPTER_MODEL_DESCR_LEN);
 	else if (!strcmp(model, "Brocade-804"))
-		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 8Gbps FC HBA for HP Bladesystem C-class");
+		strlcpy(model_descr,
+				"Brocade 8Gbps FC HBA for HP Bladesystem C-class\n",
+				BFA_ADAPTER_MODEL_DESCR_LEN);
 	else if (!strcmp(model, "Brocade-1741"))
-		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 10Gbps CNA for Dell M-Series Blade Servers");
+		strlcpy(model_descr,
+				"Brocade 10Gbps CNA for Dell M-Series Blade Servers\n",
+				BFA_ADAPTER_MODEL_DESCR_LEN);
 	else if (strstr(model, "Brocade-1860")) {
 		if (nports == 1 && bfa_ioc_is_cna(&bfad->bfa.ioc))
-			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 10Gbps single port CNA");
+			strlcpy(model_descr,
+					"Brocade 10Gbps single port CNA\n",
+					BFA_ADAPTER_MODEL_DESCR_LEN);
 		else if (nports == 1 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
-			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 16Gbps PCIe single port FC HBA");
+			strlcpy(model_descr,
+					"Brocade 16Gbps PCIe single port FC HBA\n",
+					BFA_ADAPTER_MODEL_DESCR_LEN);
 		else if (nports == 2 && bfa_ioc_is_cna(&bfad->bfa.ioc))
-			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 10Gbps dual port CNA");
+			strlcpy(model_descr,
+					"Brocade 10Gbps dual port CNA\n",
+					BFA_ADAPTER_MODEL_DESCR_LEN);
 		else if (nports == 2 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
-			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 16Gbps PCIe dual port FC HBA");
+			strlcpy(model_descr,
+					"Brocade 16Gbps PCIe dual port FC HBA\n",
+					BFA_ADAPTER_MODEL_DESCR_LEN);
 	} else if (!strcmp(model, "Brocade-1867")) {
 		if (nports == 1 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
-			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 16Gbps PCIe single port FC HBA for IBM");
+			strlcpy(model_descr,
+					"Brocade 16Gbps PCIe single port FC HBA for IBM\n",
+					BFA_ADAPTER_MODEL_DESCR_LEN);
 		else if (nports == 2 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
-			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 16Gbps PCIe dual port FC HBA for IBM");
+			strlcpy(model_descr,
+					"Brocade 16Gbps PCIe dual port FC HBA for IBM\n",
+					BFA_ADAPTER_MODEL_DESCR_LEN);
 	} else
-		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Invalid Model");
+		strlcpy(model_descr,
+				"Invalid Model\n",
+				BFA_ADAPTER_MODEL_DESCR_LEN);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", model_descr);
+	return strlcpy(buf, model_descr, PAGE_SIZE);
 }
 
 static ssize_t
@@ -839,12 +859,10 @@ bfad_im_symbolic_name_show(struct device *dev, struct device_attribute *attr,
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
 	struct bfa_lport_attr_s port_attr;
-	char symname[BFA_SYMNAME_MAXLEN];
 
 	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
-	strncpy(symname, port_attr.port_cfg.sym_name.symname,
-			BFA_SYMNAME_MAXLEN);
-	return snprintf(buf, PAGE_SIZE, "%s\n", symname);
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+			port_attr.port_cfg.sym_name.symname);
 }
 
 static ssize_t
@@ -865,7 +883,7 @@ static ssize_t
 bfad_im_drv_version_show(struct device *dev, struct device_attribute *attr,
 				char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_VERSION);
+	return strlcpy(buf, BFAD_DRIVER_VERSION  "\n", PAGE_SIZE);
 }
 
 static ssize_t
@@ -913,7 +931,7 @@ static ssize_t
 bfad_im_drv_name_show(struct device *dev, struct device_attribute *attr,
 				char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_NAME);
+	return strlcpy(buf, BFAD_DRIVER_NAME  "\n", PAGE_SIZE);
 }
 
 static ssize_t
@@ -932,7 +950,7 @@ bfad_im_num_of_discovered_ports_show(struct device *dev,
 	rports = kzalloc(sizeof(struct bfa_rport_qualifier_s) * nrports,
 			 GFP_ATOMIC);
 	if (rports == NULL)
-		return snprintf(buf, PAGE_SIZE, "Failed\n");
+		return strlcpy(buf, "Failed\n", PAGE_SIZE);
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	bfa_fcs_lport_get_rport_quals(port->fcs_port, rports, &nrports);
-- 
1.7.10.4
