From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: bfa: bfa_fcs_lport.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 27 Jul 2014 17:44:59 +0200
Message-ID: <1406475899-13097-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
In some cases modified to copy one character less than the overall
length, as the entire area is already zeroed. And replacing strncat
with strlcat because of incorrect use.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |   47 +++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index ff75ef8..89e97ee 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -2631,10 +2631,10 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 					hba_attr->fw_version);
 
 	strncpy(hba_attr->driver_version, (char *)driver_info->version,
-		sizeof(hba_attr->driver_version));
+		sizeof(hba_attr->driver_version) - 1);
 
 	strncpy(hba_attr->os_name, driver_info->host_os_name,
-		sizeof(hba_attr->os_name));
+		sizeof(hba_attr->os_name) - 1);
 
 	/*
 	 * If there is a patch level, append it
@@ -2652,12 +2652,13 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 	hba_attr->max_ct_pyld = fcs_port_attr.max_frm_size;
 
 	strncpy(hba_attr->node_sym_name.symname,
-		port->port_cfg.node_sym_name.symname, BFA_SYMNAME_MAXLEN);
+		port->port_cfg.node_sym_name.symname, BFA_SYMNAME_MAXLEN - 1);
 	strcpy(hba_attr->vendor_info, "BROCADE");
 	hba_attr->num_ports =
 		cpu_to_be32(bfa_ioc_get_nports(&port->fcs->bfa->ioc));
 	hba_attr->fabric_name = port->fabric->lps->pr_nwwn;
-	strncpy(hba_attr->bios_ver, hba_attr->option_rom_ver, BFA_VERSION_LEN);
+	strncpy(hba_attr->bios_ver, hba_attr->option_rom_ver,
+			BFA_VERSION_LEN - 1);
 
 }
 
@@ -2725,19 +2726,20 @@ bfa_fcs_fdmi_get_portattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 	 * OS device Name
 	 */
 	strncpy(port_attr->os_device_name, (char *)driver_info->os_device_name,
-		sizeof(port_attr->os_device_name));
+		sizeof(port_attr->os_device_name) - 1);
 
 	/*
 	 * Host name
 	 */
 	strncpy(port_attr->host_name, (char *)driver_info->host_machine_name,
-		sizeof(port_attr->host_name));
+		sizeof(port_attr->host_name) - 1);
 
 	port_attr->node_name = bfa_fcs_lport_get_nwwn(port);
 	port_attr->port_name = bfa_fcs_lport_get_pwwn(port);
 
 	strncpy(port_attr->port_sym_name.symname,
-		(char *)&bfa_fcs_lport_get_psym_name(port), BFA_SYMNAME_MAXLEN);
+		(char *)&bfa_fcs_lport_get_psym_name(port),
+		BFA_SYMNAME_MAXLEN - 1);
 	bfa_fcs_lport_get_attr(port, &lport_attr);
 	port_attr->port_type = cpu_to_be32(lport_attr.port_type);
 	port_attr->scos = pport_attr.cos_supported;
@@ -3217,7 +3219,7 @@ bfa_fcs_lport_ms_gmal_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 					rsp_str[gmal_entry->len-1] = 0;
 
 				/* copy IP Address to fabric */
-				strncpy(bfa_fcs_lport_get_fabric_ipaddr(port),
+				strlcpy(bfa_fcs_lport_get_fabric_ipaddr(port),
 					gmal_entry->ip_addr,
 					BFA_FCS_FABRIC_IPADDR_SZ);
 				break;
@@ -4655,21 +4657,15 @@ bfa_fcs_lport_ns_send_rspn_id(void *ns_cbarg, struct bfa_fcxp_s *fcxp_alloced)
 		 * to that of the base port.
 		 */
 
-		strncpy((char *)psymbl,
+		strlcpy((char *)psymbl,
 			(char *) &
 			(bfa_fcs_lport_get_psym_name
 			 (bfa_fcs_get_base_port(port->fcs))),
-			strlen((char *) &
-			       bfa_fcs_lport_get_psym_name(bfa_fcs_get_base_port
-							  (port->fcs))));
-
-		/* Ensure we have a null terminating string. */
-		((char *)psymbl)[strlen((char *) &
-			bfa_fcs_lport_get_psym_name(bfa_fcs_get_base_port
-						(port->fcs)))] = 0;
-		strncat((char *)psymbl,
+			sizeof(symbl));
+
+		strlcat((char *)psymbl,
 			(char *) &(bfa_fcs_lport_get_psym_name(port)),
-		strlen((char *) &bfa_fcs_lport_get_psym_name(port)));
+			sizeof(symbl));
 	} else {
 		psymbl = (u8 *) &(bfa_fcs_lport_get_psym_name(port));
 	}
@@ -5191,18 +5187,13 @@ bfa_fcs_lport_ns_util_send_rspn_id(void *cbarg, struct bfa_fcxp_s *fcxp_alloced)
 		 * For Vports, we append the vport's port symbolic name
 		 * to that of the base port.
 		 */
-		strncpy((char *)psymbl, (char *)&(bfa_fcs_lport_get_psym_name
+		strlcpy((char *)psymbl, (char *)&(bfa_fcs_lport_get_psym_name
 			(bfa_fcs_get_base_port(port->fcs))),
-			strlen((char *)&bfa_fcs_lport_get_psym_name(
-			bfa_fcs_get_base_port(port->fcs))));
-
-		/* Ensure we have a null terminating string. */
-		((char *)psymbl)[strlen((char *)&bfa_fcs_lport_get_psym_name(
-		 bfa_fcs_get_base_port(port->fcs)))] = 0;
+			sizeof(symbl));
 
-		strncat((char *)psymbl,
+		strlcat((char *)psymbl,
 			(char *)&(bfa_fcs_lport_get_psym_name(port)),
-			strlen((char *)&bfa_fcs_lport_get_psym_name(port)));
+			sizeof(symbl));
 	}
 
 	len = fc_rspnid_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
-- 
1.7.10.4
