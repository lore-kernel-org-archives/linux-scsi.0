From: "Kalluru, Sudarsana" <Sudarsana.Kalluru@cavium.com>
Subject: RE: [PATCH] scsi: bfa: convert to strlcpy/strlcat
Date: Sat, 9 Dec 2017 07:30:19 +0000
Message-ID: <CY4PR07MB30480E8E56DB5990DD29619C8A310@CY4PR07MB3048.namprd07.prod.outlook.com>
References: <20171204144814.385412-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171204144814.385412-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "Gurumurthy, Anil" <Anil.Gurumurthy@cavium.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>, Kees Cook <keescook@chromium.org>, Benjamin Poirier <bpoirier@suse.com>, "Mody, Rasesh" <Rasesh.Mody@cavium.com>, Johannes Thumshirn <jthumshirn@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Acked-by: Sudarsana Kalluru <Sudarsana.Kalluru@cavium.com>

-----Original Message-----
From: Arnd Bergmann [mailto:arnd@arndb.de]=20
Sent: 04 December 2017 20:17
To: Gurumurthy, Anil <Anil.Gurumurthy@cavium.com>; Kalluru, Sudarsana <Suda=
rsana.Kalluru@cavium.com>; James E.J. Bottomley <jejb@linux.vnet.ibm.com>; =
Martin K. Petersen <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>; Hannes Reinecke <hare@suse.com>; Kees Co=
ok <keescook@chromium.org>; Benjamin Poirier <bpoirier@suse.com>; Mody, Ras=
esh <Rasesh.Mody@cavium.com>; Johannes Thumshirn <jthumshirn@suse.de>; linu=
x-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: bfa: convert to strlcpy/strlcat

The bfa driver has a number of real issues with string termination that gcc=
-8 now points out:

drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_iocmd_port_get_attr':
drivers/scsi/bfa/bfad_bsg.c:320:9: error: argument to 'sizeof' in 'strncpy'=
 call is the same expression as the source; did you mean to use the size of=
 the destination? [-Werror=3Dsizeof-pointer-memaccess]
drivers/scsi/bfa/bfa_fcs.c: In function 'bfa_fcs_fabric_psymb_init':
drivers/scsi/bfa/bfa_fcs.c:775:9: error: argument to 'sizeof' in 'strncat' =
call is the same expression as the source; did you mean to use the size of =
the destination? [-Werror=3Dsizeof-pointer-memaccess]
drivers/scsi/bfa/bfa_fcs.c:781:9: error: argument to 'sizeof' in 'strncat' =
call is the same expression as the source; did you mean to use the size of =
the destination? [-Werror=3Dsizeof-pointer-memaccess]
drivers/scsi/bfa/bfa_fcs.c:788:9: error: argument to 'sizeof' in 'strncat' =
call is the same expression as the source; did you mean to use the size of =
the destination? [-Werror=3Dsizeof-pointer-memaccess]
drivers/scsi/bfa/bfa_fcs.c:801:10: error: argument to 'sizeof' in 'strncat'=
 call is the same expression as the source; did you mean to use the size of=
 the destination? [-Werror=3Dsizeof-pointer-memaccess]
drivers/scsi/bfa/bfa_fcs.c:808:10: error: argument to 'sizeof' in 'strncat'=
 call is the same expression as the source; did you mean to use the size of=
 the destination? [-Werror=3Dsizeof-pointer-memaccess]
drivers/scsi/bfa/bfa_fcs.c: In function 'bfa_fcs_fabric_nsymb_init':
drivers/scsi/bfa/bfa_fcs.c:837:10: error: argument to 'sizeof' in 'strncat'=
 call is the same expression as the source; did you mean to use the size of=
 the destination? [-Werror=3Dsizeof-pointer-memaccess]
drivers/scsi/bfa/bfa_fcs.c:844:10: error: argument to 'sizeof' in 'strncat'=
 call is the same expression as the source; did you mean to use the size of=
 the destination? [-Werror=3Dsizeof-pointer-memaccess]
drivers/scsi/bfa/bfa_fcs.c:852:10: error: argument to 'sizeof' in 'strncat'=
 call is the same expression as the source; did you mean to use the size of=
 the destination? [-Werror=3Dsizeof-pointer-memaccess]
drivers/scsi/bfa/bfa_fcs.c: In function 'bfa_fcs_fabric_psymb_init':
drivers/scsi/bfa/bfa_fcs.c:778:2: error: 'strncat' output may be truncated =
copying 10 bytes from a string of length 63 [-Werror=3Dstringop-truncation]
drivers/scsi/bfa/bfa_fcs.c:784:2: error: 'strncat' output may be truncated =
copying 30 bytes from a string of length 63 [-Werror=3Dstringop-truncation]
drivers/scsi/bfa/bfa_fcs.c:803:3: error: 'strncat' output may be truncated =
copying 44 bytes from a string of length 63 [-Werror=3Dstringop-truncation]
drivers/scsi/bfa/bfa_fcs.c:811:3: error: 'strncat' output may be truncated =
copying 16 bytes from a string of length 63 [-Werror=3Dstringop-truncation]
drivers/scsi/bfa/bfa_fcs.c: In function 'bfa_fcs_fabric_nsymb_init':
drivers/scsi/bfa/bfa_fcs.c:840:2: error: 'strncat' output may be truncated =
copying 10 bytes from a string of length 63 [-Werror=3Dstringop-truncation]
drivers/scsi/bfa/bfa_fcs.c:847:2: error: 'strncat' output may be truncated =
copying 30 bytes from a string of length 63 [-Werror=3Dstringop-truncation]
drivers/scsi/bfa/bfa_fcs_lport.c: In function 'bfa_fcs_fdmi_get_hbaattr':
drivers/scsi/bfa/bfa_fcs_lport.c:2657:10: error: argument to 'sizeof' in 's=
trncat' call is the same expression as the source; did you mean to use the =
size of the destination? [-Werror=3Dsizeof-pointer-memaccess]
drivers/scsi/bfa/bfa_fcs_lport.c:2659:11: error: argument to 'sizeof' in 's=
trncat' call is the same expression as the source; did you mean to use the =
size of the destination? [-Werror=3Dsizeof-pointer-memaccess]
drivers/scsi/bfa/bfa_fcs_lport.c: In function 'bfa_fcs_lport_ms_gmal_respon=
se':
drivers/scsi/bfa/bfa_fcs_lport.c:3232:5: error: 'strncpy' output may be tru=
ncated copying 16 bytes from a string of length 247 [-Werror=3Dstringop-tru=
ncation]
drivers/scsi/bfa/bfa_fcs_lport.c: In function 'bfa_fcs_lport_ns_send_rspn_i=
d':
drivers/scsi/bfa/bfa_fcs_lport.c:4670:3: error: 'strncpy' output truncated =
before terminating nul copying as many bytes from a string as its length [-=
Werror=3Dstringop-truncation]
drivers/scsi/bfa/bfa_fcs_lport.c:4682:3: error: 'strncat' output truncated =
before terminating nul copying as many bytes from a string as its length [-=
Werror=3Dstringop-truncation]
drivers/scsi/bfa/bfa_fcs_lport.c: In function 'bfa_fcs_lport_ns_util_send_r=
spn_id':
drivers/scsi/bfa/bfa_fcs_lport.c:5206:3: error: 'strncpy' output truncated =
before terminating nul copying as many bytes from a string as its length [-=
Werror=3Dstringop-truncation]
drivers/scsi/bfa/bfa_fcs_lport.c:5215:3: error: 'strncat' output truncated =
before terminating nul copying as many bytes from a string as its length [-=
Werror=3Dstringop-truncation]
drivers/scsi/bfa/bfa_fcs_lport.c: In function 'bfa_fcs_fdmi_get_portattr':
drivers/scsi/bfa/bfa_fcs_lport.c:2751:2: error: 'strncpy' specified bound 1=
28 equals destination size [-Werror=3Dstringop-truncation]
drivers/scsi/bfa/bfa_fcbuild.c: In function 'fc_rspnid_build':
drivers/scsi/bfa/bfa_fcbuild.c:1254:2: error: 'strncpy' output truncated be=
fore terminating nul copying as many bytes from a string as its length [-We=
rror=3Dstringop-truncation]
drivers/scsi/bfa/bfa_fcbuild.c:1253:25: note: length computed here
drivers/scsi/bfa/bfa_fcbuild.c: In function 'fc_rsnn_nn_build':
drivers/scsi/bfa/bfa_fcbuild.c:1275:2: error: 'strncpy' output truncated be=
fore terminating nul copying as many bytes from a string as its length [-We=
rror=3Dstringop-truncation]

In most cases, this can be addressed by correctly calling strlcpy and strlc=
at instead of strncpy/strncat, with the size of the destination buffer as t=
he last argument.

For consistency, I'm changing the other callers of strncpy() in this driver=
 the same way.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/bfa/bfa_fcbuild.c   |  8 ++---
 drivers/scsi/bfa/bfa_fcs.c       | 78 ++++++++++++++++++++----------------=
----
 drivers/scsi/bfa/bfa_fcs_lport.c | 62 +++++++++++++-------------------
 drivers/scsi/bfa/bfa_ioc.c       |  2 +-
 drivers/scsi/bfa/bfa_svc.c       |  4 +--
 drivers/scsi/bfa/bfad.c          | 20 +++++------
 drivers/scsi/bfa/bfad_attr.c     |  2 +-
 drivers/scsi/bfa/bfad_bsg.c      |  6 ++--
 8 files changed, 84 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.=
c index b8dadc9cc993..d3b00a475aeb 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -1250,8 +1250,8 @@ fc_rspnid_build(struct fchs_s *fchs, void *pyld, u32 =
s_id, u16 ox_id,
 	memset(rspnid, 0, sizeof(struct fcgs_rspnid_req_s));
=20
 	rspnid->dap =3D s_id;
-	rspnid->spn_len =3D (u8) strlen((char *)name);
-	strncpy((char *)rspnid->spn, (char *)name, rspnid->spn_len);
+	strlcpy(rspnid->spn, name, sizeof(rspnid->spn));
+	rspnid->spn_len =3D (u8) strlen(rspnid->spn);
=20
 	return sizeof(struct fcgs_rspnid_req_s) + sizeof(struct ct_hdr_s);  } @@ =
-1271,8 +1271,8 @@ fc_rsnn_nn_build(struct fchs_s *fchs, void *pyld, u32 s_=
id,
 	memset(rsnn_nn, 0, sizeof(struct fcgs_rsnn_nn_req_s));
=20
 	rsnn_nn->node_name =3D node_name;
-	rsnn_nn->snn_len =3D (u8) strlen((char *)name);
-	strncpy((char *)rsnn_nn->snn, (char *)name, rsnn_nn->snn_len);
+	strlcpy(rsnn_nn->snn, name, sizeof(rsnn_nn->snn));
+	rsnn_nn->snn_len =3D (u8) strlen(rsnn_nn->snn);
=20
 	return sizeof(struct fcgs_rsnn_nn_req_s) + sizeof(struct ct_hdr_s);  } di=
ff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c index 4a=
a61e20e82d..932feb0ed4da 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -769,23 +769,23 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fa=
bric)
 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
=20
 	/* Model name/number */
-	strncpy((char *)&port_cfg->sym_name, model,
-		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
-	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+	strlcpy(port_cfg->sym_name.symname, model,
+		BFA_SYMNAME_MAXLEN);
+	strlcat(port_cfg->sym_name.symname, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		BFA_SYMNAME_MAXLEN);
=20
 	/* Driver Version */
-	strncat((char *)&port_cfg->sym_name, (char *)driver_info->version,
-		BFA_FCS_PORT_SYMBNAME_VERSION_SZ);
-	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+	strlcat(port_cfg->sym_name.symname, driver_info->version,
+		BFA_SYMNAME_MAXLEN);
+	strlcat(port_cfg->sym_name.symname, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		BFA_SYMNAME_MAXLEN);
=20
 	/* Host machine name */
-	strncat((char *)&port_cfg->sym_name,
-		(char *)driver_info->host_machine_name,
-		BFA_FCS_PORT_SYMBNAME_MACHINENAME_SZ);
-	strncat((char *)&port_cfg->sym_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+	strlcat(port_cfg->sym_name.symname,
+		driver_info->host_machine_name,
+		BFA_SYMNAME_MAXLEN);
+	strlcat(port_cfg->sym_name.symname, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+		BFA_SYMNAME_MAXLEN);
=20
 	/*
 	 * Host OS Info :
@@ -793,24 +793,24 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fa=
bric)
 	 * OS name string and instead copy the entire OS info string (64 bytes).
 	 */
 	if (driver_info->host_os_patch[0] =3D=3D '\0') {
-		strncat((char *)&port_cfg->sym_name,
-			(char *)driver_info->host_os_name,
-			BFA_FCS_OS_STR_LEN);
-		strncat((char *)&port_cfg->sym_name,
+		strlcat(port_cfg->sym_name.symname,
+			driver_info->host_os_name,
+			BFA_SYMNAME_MAXLEN);
+		strlcat(port_cfg->sym_name.symname,
 			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+			BFA_SYMNAME_MAXLEN);
 	} else {
-		strncat((char *)&port_cfg->sym_name,
-			(char *)driver_info->host_os_name,
-			BFA_FCS_PORT_SYMBNAME_OSINFO_SZ);
-		strncat((char *)&port_cfg->sym_name,
+		strlcat(port_cfg->sym_name.symname,
+			driver_info->host_os_name,
+			BFA_SYMNAME_MAXLEN);
+		strlcat(port_cfg->sym_name.symname,
 			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+			BFA_SYMNAME_MAXLEN);
=20
 		/* Append host OS Patch Info */
-		strncat((char *)&port_cfg->sym_name,
-			(char *)driver_info->host_os_patch,
-			BFA_FCS_PORT_SYMBNAME_OSPATCH_SZ);
+		strlcat(port_cfg->sym_name.symname,
+			driver_info->host_os_patch,
+			BFA_SYMNAME_MAXLEN);
 	}
=20
 	/* null terminate */
@@ -830,26 +830,26 @@ bfa_fcs_fabric_nsymb_init(struct bfa_fcs_fabric_s *fa=
bric)
 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
=20
 	/* Model name/number */
-	strncpy((char *)&port_cfg->node_sym_name, model,
-		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
-	strncat((char *)&port_cfg->node_sym_name,
+	strlcpy(port_cfg->node_sym_name.symname, model,
+		BFA_SYMNAME_MAXLEN);
+	strlcat(port_cfg->node_sym_name.symname,
 			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+			BFA_SYMNAME_MAXLEN);
=20
 	/* Driver Version */
-	strncat((char *)&port_cfg->node_sym_name, (char *)driver_info->version,
-		BFA_FCS_PORT_SYMBNAME_VERSION_SZ);
-	strncat((char *)&port_cfg->node_sym_name,
+	strlcat(port_cfg->node_sym_name.symname, (char *)driver_info->version,
+		BFA_SYMNAME_MAXLEN);
+	strlcat(port_cfg->node_sym_name.symname,
 			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+			BFA_SYMNAME_MAXLEN);
=20
 	/* Host machine name */
-	strncat((char *)&port_cfg->node_sym_name,
-		(char *)driver_info->host_machine_name,
-		BFA_FCS_PORT_SYMBNAME_MACHINENAME_SZ);
-	strncat((char *)&port_cfg->node_sym_name,
+	strlcat(port_cfg->node_sym_name.symname,
+		driver_info->host_machine_name,
+		BFA_SYMNAME_MAXLEN);
+	strlcat(port_cfg->node_sym_name.symname,
 			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
+			BFA_SYMNAME_MAXLEN);
=20
 	/* null terminate */
 	port_cfg->node_sym_name.symname[BFA_SYMNAME_MAXLEN - 1] =3D 0; diff --git=
 a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 638c0a2857f7..b4f2c1d8742e 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -2642,10 +2642,10 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_=
s *fdmi,
 	bfa_ioc_get_adapter_fw_ver(&port->fcs->bfa->ioc,
 					hba_attr->fw_version);
=20
-	strncpy(hba_attr->driver_version, (char *)driver_info->version,
+	strlcpy(hba_attr->driver_version, (char *)driver_info->version,
 		sizeof(hba_attr->driver_version));
=20
-	strncpy(hba_attr->os_name, driver_info->host_os_name,
+	strlcpy(hba_attr->os_name, driver_info->host_os_name,
 		sizeof(hba_attr->os_name));
=20
 	/*
@@ -2653,23 +2653,23 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_=
s *fdmi,
 	 * to the os name along with a separator
 	 */
 	if (driver_info->host_os_patch[0] !=3D '\0') {
-		strncat(hba_attr->os_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
-		strncat(hba_attr->os_name, driver_info->host_os_patch,
-				sizeof(driver_info->host_os_patch));
+		strlcat(hba_attr->os_name, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
+			sizeof(hba_attr->os_name));
+		strlcat(hba_attr->os_name, driver_info->host_os_patch,
+				sizeof(hba_attr->os_name));
 	}
=20
 	/* Retrieve the max frame size from the port attr */
 	bfa_fcs_fdmi_get_portattr(fdmi, &fcs_port_attr);
 	hba_attr->max_ct_pyld =3D fcs_port_attr.max_frm_size;
=20
-	strncpy(hba_attr->node_sym_name.symname,
+	strlcpy(hba_attr->node_sym_name.symname,
 		port->port_cfg.node_sym_name.symname, BFA_SYMNAME_MAXLEN);
 	strcpy(hba_attr->vendor_info, "QLogic");
 	hba_attr->num_ports =3D
 		cpu_to_be32(bfa_ioc_get_nports(&port->fcs->bfa->ioc));
 	hba_attr->fabric_name =3D port->fabric->lps->pr_nwwn;
-	strncpy(hba_attr->bios_ver, hba_attr->option_rom_ver, BFA_VERSION_LEN);
+	strlcpy(hba_attr->bios_ver, hba_attr->option_rom_ver,=20
+BFA_VERSION_LEN);
=20
 }
=20
@@ -2736,20 +2736,20 @@ bfa_fcs_fdmi_get_portattr(struct bfa_fcs_lport_fdmi=
_s *fdmi,
 	/*
 	 * OS device Name
 	 */
-	strncpy(port_attr->os_device_name, (char *)driver_info->os_device_name,
+	strlcpy(port_attr->os_device_name, driver_info->os_device_name,
 		sizeof(port_attr->os_device_name));
=20
 	/*
 	 * Host name
 	 */
-	strncpy(port_attr->host_name, (char *)driver_info->host_machine_name,
+	strlcpy(port_attr->host_name, driver_info->host_machine_name,
 		sizeof(port_attr->host_name));
=20
 	port_attr->node_name =3D bfa_fcs_lport_get_nwwn(port);
 	port_attr->port_name =3D bfa_fcs_lport_get_pwwn(port);
=20
-	strncpy(port_attr->port_sym_name.symname,
-		(char *)&bfa_fcs_lport_get_psym_name(port), BFA_SYMNAME_MAXLEN);
+	strlcpy(port_attr->port_sym_name.symname,
+		bfa_fcs_lport_get_psym_name(port).symname, BFA_SYMNAME_MAXLEN);
 	bfa_fcs_lport_get_attr(port, &lport_attr);
 	port_attr->port_type =3D cpu_to_be32(lport_attr.port_type);
 	port_attr->scos =3D pport_attr.cos_supported; @@ -3229,7 +3229,7 @@ bfa_f=
cs_lport_ms_gmal_response(void *fcsarg, struct bfa_fcxp_s *fcxp,
 					rsp_str[gmal_entry->len-1] =3D 0;
=20
 				/* copy IP Address to fabric */
-				strncpy(bfa_fcs_lport_get_fabric_ipaddr(port),
+				strlcpy(bfa_fcs_lport_get_fabric_ipaddr(port),
 					gmal_entry->ip_addr,
 					BFA_FCS_FABRIC_IPADDR_SZ);
 				break;
@@ -4667,21 +4667,13 @@ bfa_fcs_lport_ns_send_rspn_id(void *ns_cbarg, struc=
t bfa_fcxp_s *fcxp_alloced)
 		 * to that of the base port.
 		 */
=20
-		strncpy((char *)psymbl,
-			(char *) &
-			(bfa_fcs_lport_get_psym_name
+		strlcpy(symbl,
+			(char *)&(bfa_fcs_lport_get_psym_name
 			 (bfa_fcs_get_base_port(port->fcs))),
-			strlen((char *) &
-			       bfa_fcs_lport_get_psym_name(bfa_fcs_get_base_port
-							  (port->fcs))));
-
-		/* Ensure we have a null terminating string. */
-		((char *)psymbl)[strlen((char *) &
-			bfa_fcs_lport_get_psym_name(bfa_fcs_get_base_port
-						(port->fcs)))] =3D 0;
-		strncat((char *)psymbl,
-			(char *) &(bfa_fcs_lport_get_psym_name(port)),
-		strlen((char *) &bfa_fcs_lport_get_psym_name(port)));
+			sizeof(symbl));
+
+		strlcat(symbl, (char *)&(bfa_fcs_lport_get_psym_name(port)),
+			sizeof(symbl));
 	} else {
 		psymbl =3D (u8 *) &(bfa_fcs_lport_get_psym_name(port));
 	}
@@ -5173,7 +5165,6 @@ bfa_fcs_lport_ns_util_send_rspn_id(void *cbarg, struc=
t bfa_fcxp_s *fcxp_alloced)
 	struct fchs_s fchs;
 	struct bfa_fcxp_s *fcxp;
 	u8 symbl[256];
-	u8 *psymbl =3D &symbl[0];
 	int len;
=20
 	/* Avoid sending RSPN in the following states. */ @@ -5203,22 +5194,17 @@=
 bfa_fcs_lport_ns_util_send_rspn_id(void *cbarg, struct bfa_fcxp_s *fcxp_al=
loced)
 		 * For Vports, we append the vport's port symbolic name
 		 * to that of the base port.
 		 */
-		strncpy((char *)psymbl, (char *)&(bfa_fcs_lport_get_psym_name
+		strlcpy(symbl, (char *)&(bfa_fcs_lport_get_psym_name
 			(bfa_fcs_get_base_port(port->fcs))),
-			strlen((char *)&bfa_fcs_lport_get_psym_name(
-			bfa_fcs_get_base_port(port->fcs))));
-
-		/* Ensure we have a null terminating string. */
-		((char *)psymbl)[strlen((char *)&bfa_fcs_lport_get_psym_name(
-		 bfa_fcs_get_base_port(port->fcs)))] =3D 0;
+			sizeof(symbl));
=20
-		strncat((char *)psymbl,
+		strlcat(symbl,
 			(char *)&(bfa_fcs_lport_get_psym_name(port)),
-			strlen((char *)&bfa_fcs_lport_get_psym_name(port)));
+			sizeof(symbl));
 	}
=20
 	len =3D fc_rspnid_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
-			      bfa_fcs_lport_get_fcid(port), 0, psymbl);
+			      bfa_fcs_lport_get_fcid(port), 0, symbl);
=20
 	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
 		      FC_CLASS_3, len, &fchs, NULL, NULL, FC_MAX_PDUSZ, 0); diff --git a=
/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c index 117332537763=
..16d3aeb0e572 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2805,7 +2805,7 @@ void
 bfa_ioc_get_adapter_manufacturer(struct bfa_ioc_s *ioc, char *manufacturer=
)  {
 	memset((void *)manufacturer, 0, BFA_ADAPTER_MFG_NAME_LEN);
-	strncpy(manufacturer, BFA_MFG_NAME, BFA_ADAPTER_MFG_NAME_LEN);
+	strlcpy(manufacturer, BFA_MFG_NAME, BFA_ADAPTER_MFG_NAME_LEN);
 }
=20
 void
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c index =
9d20d2c92e8c..6fc34fb20f00 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -338,8 +338,8 @@ bfa_plog_str(struct bfa_plog_s *plog, enum bfa_plog_mid=
 mid,
 		lp.eid =3D event;
 		lp.log_type =3D BFA_PL_LOG_TYPE_STRING;
 		lp.misc =3D misc;
-		strncpy(lp.log_entry.string_log, log_str,
-			BFA_PL_STRING_LOG_SZ - 1);
+		strlcpy(lp.log_entry.string_log, log_str,
+			BFA_PL_STRING_LOG_SZ);
 		lp.log_entry.string_log[BFA_PL_STRING_LOG_SZ - 1] =3D '\0';
 		bfa_plog_add(plog, &lp);
 	}
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c index cf0466=
686804..bac18f68759a 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -981,20 +981,20 @@ bfad_start_ops(struct bfad_s *bfad) {
=20
 	/* Fill the driver_info info to fcs*/
 	memset(&driver_info, 0, sizeof(driver_info));
-	strncpy(driver_info.version, BFAD_DRIVER_VERSION,
-		sizeof(driver_info.version) - 1);
+	strlcpy(driver_info.version, BFAD_DRIVER_VERSION,
+		sizeof(driver_info.version));
 	if (host_name)
-		strncpy(driver_info.host_machine_name, host_name,
-			sizeof(driver_info.host_machine_name) - 1);
+		strlcpy(driver_info.host_machine_name, host_name,
+			sizeof(driver_info.host_machine_name));
 	if (os_name)
-		strncpy(driver_info.host_os_name, os_name,
-			sizeof(driver_info.host_os_name) - 1);
+		strlcpy(driver_info.host_os_name, os_name,
+			sizeof(driver_info.host_os_name));
 	if (os_patch)
-		strncpy(driver_info.host_os_patch, os_patch,
-			sizeof(driver_info.host_os_patch) - 1);
+		strlcpy(driver_info.host_os_patch, os_patch,
+			sizeof(driver_info.host_os_patch));
=20
-	strncpy(driver_info.os_device_name, bfad->pci_name,
-		sizeof(driver_info.os_device_name) - 1);
+	strlcpy(driver_info.os_device_name, bfad->pci_name,
+		sizeof(driver_info.os_device_name));
=20
 	/* FCS driver info init */
 	spin_lock_irqsave(&bfad->bfad_lock, flags); diff --git a/drivers/scsi/bfa=
/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c index 13db3b7bc873..d0a504af5b4=
f 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -843,7 +843,7 @@ bfad_im_symbolic_name_show(struct device *dev, struct d=
evice_attribute *attr,
 	char symname[BFA_SYMNAME_MAXLEN];
=20
 	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
-	strncpy(symname, port_attr.port_cfg.sym_name.symname,
+	strlcpy(symname, port_attr.port_cfg.sym_name.symname,
 			BFA_SYMNAME_MAXLEN);
 	return snprintf(buf, PAGE_SIZE, "%s\n", symname);  } diff --git a/drivers=
/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c index 01fc51a70356..1d01=
dd610454 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -127,7 +127,7 @@ bfad_iocmd_ioc_get_attr(struct bfad_s *bfad, void *cmd)
=20
 	/* fill in driver attr info */
 	strcpy(iocmd->ioc_attr.driver_attr.driver, BFAD_DRIVER_NAME);
-	strncpy(iocmd->ioc_attr.driver_attr.driver_ver,
+	strlcpy(iocmd->ioc_attr.driver_attr.driver_ver,
 		BFAD_DRIVER_VERSION, BFA_VERSION_LEN);
 	strcpy(iocmd->ioc_attr.driver_attr.fw_ver,
 		iocmd->ioc_attr.adapter_attr.fw_ver);
@@ -315,9 +315,9 @@ bfad_iocmd_port_get_attr(struct bfad_s *bfad, void *cmd=
)
 	iocmd->attr.port_type =3D port_attr.port_type;
 	iocmd->attr.loopback =3D port_attr.loopback;
 	iocmd->attr.authfail =3D port_attr.authfail;
-	strncpy(iocmd->attr.port_symname.symname,
+	strlcpy(iocmd->attr.port_symname.symname,
 		port_attr.port_cfg.sym_name.symname,
-		sizeof(port_attr.port_cfg.sym_name.symname));
+		sizeof(iocmd->attr.port_symname.symname));
=20
 	iocmd->status =3D BFA_STATUS_OK;
 	return 0;
--
2.9.0
