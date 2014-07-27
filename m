From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: bfa: bfa_fcs.c:  Cleaning up missing null-terminate in conjunction with strncpy strncat
Date: Sun, 27 Jul 2014 18:44:12 +0200
Message-ID: <1406479452-13568-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replacing strncp with strlcpy to avoid strings that lacks null terminate.
And strncat with strlcat because of incorrect use,
removed same the duplicated code.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bfa/bfa_fcs.c |   80 ++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index a3ab5cc..48112ee 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -831,52 +831,41 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
 
 	/* Model name/number */
-	strncpy((char *)&port_cfg->sym_name, model,
-		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
-	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+	strlcpy((char *)&port_cfg->sym_name, model,
+		BFA_SYMNAME_MAXLEN);
+	strlcat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		BFA_SYMNAME_MAXLEN);
 
 	/* Driver Version */
-	strncat((char *)&port_cfg->sym_name, (char *)driver_info->version,
-		BFA_FCS_PORT_SYMBNAME_VERSION_SZ);
-	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+	strlcat((char *)&port_cfg->sym_name, (char *)driver_info->version,
+		BFA_SYMNAME_MAXLEN);
+	strlcat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		BFA_SYMNAME_MAXLEN);
 
 	/* Host machine name */
-	strncat((char *)&port_cfg->sym_name,
+	strlcat((char *)&port_cfg->sym_name,
 		(char *)driver_info->host_machine_name,
-		BFA_FCS_PORT_SYMBNAME_MACHINENAME_SZ);
-	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+		BFA_SYMNAME_MAXLEN);
+	strlcat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		BFA_SYMNAME_MAXLEN);
 
 	/*
 	 * Host OS Info :
 	 * If OS Patch Info is not there, do not truncate any bytes from the
 	 * OS name string and instead copy the entire OS info string (64 bytes).
 	 */
+	strlcat((char *)&port_cfg->sym_name,
+		(char *)driver_info->host_os_name,
+		BFA_SYMNAME_MAXLEN);
+	strlcat((char *)&port_cfg->sym_name,
+		BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		BFA_SYMNAME_MAXLEN);
 	if (driver_info->host_os_patch[0] == '\0') {
-		strncat((char *)&port_cfg->sym_name,
-			(char *)driver_info->host_os_name,
-			BFA_FCS_OS_STR_LEN);
-		strncat((char *)&port_cfg->sym_name,
-			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
-	} else {
-		strncat((char *)&port_cfg->sym_name,
-			(char *)driver_info->host_os_name,
-			BFA_FCS_PORT_SYMBNAME_OSINFO_SZ);
-		strncat((char *)&port_cfg->sym_name,
-			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
-
 		/* Append host OS Patch Info */
-		strncat((char *)&port_cfg->sym_name,
+		strlcat((char *)&port_cfg->sym_name,
 			(char *)driver_info->host_os_patch,
-			BFA_FCS_PORT_SYMBNAME_OSPATCH_SZ);
+			BFA_SYMNAME_MAXLEN);
 	}
-
-	/* null terminate */
-	port_cfg->sym_name.symname[BFA_SYMNAME_MAXLEN - 1] = 0;
 }
 
 /*
@@ -892,29 +881,26 @@ bfa_fcs_fabric_nsymb_init(struct bfa_fcs_fabric_s *fabric)
 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
 
 	/* Model name/number */
-	strncpy((char *)&port_cfg->node_sym_name, model,
-		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
-	strncat((char *)&port_cfg->node_sym_name,
+	strlcpy((char *)&port_cfg->node_sym_name, model,
+			BFA_SYMNAME_MAXLEN);
+	strlcat((char *)&port_cfg->node_sym_name,
 			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+			BFA_SYMNAME_MAXLEN);
 
 	/* Driver Version */
-	strncat((char *)&port_cfg->node_sym_name, (char *)driver_info->version,
-		BFA_FCS_PORT_SYMBNAME_VERSION_SZ);
-	strncat((char *)&port_cfg->node_sym_name,
+	strlcat((char *)&port_cfg->node_sym_name, (char *)driver_info->version,
+			BFA_SYMNAME_MAXLEN);
+	strlcat((char *)&port_cfg->node_sym_name,
 			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+			BFA_SYMNAME_MAXLEN);
 
 	/* Host machine name */
-	strncat((char *)&port_cfg->node_sym_name,
-		(char *)driver_info->host_machine_name,
-		BFA_FCS_PORT_SYMBNAME_MACHINENAME_SZ);
-	strncat((char *)&port_cfg->node_sym_name,
+	strlcat((char *)&port_cfg->node_sym_name,
+			(char *)driver_info->host_machine_name,
+			BFA_SYMNAME_MAXLEN);
+	strlcat((char *)&port_cfg->node_sym_name,
 			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
-
-	/* null terminate */
-	port_cfg->node_sym_name.symname[BFA_SYMNAME_MAXLEN - 1] = 0;
+			BFA_SYMNAME_MAXLEN);
 }
 
 /*
-- 
1.7.10.4
