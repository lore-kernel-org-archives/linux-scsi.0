Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715C7381AD;
	Fri,  9 Aug 2024 16:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723222051; cv=none; b=HE26nTwKqlCRhftXGosSP/rQggoLLUzVujnGnDatx8BXrPF4F4nrQT1JOlsewIIwOgwKE3KsMz8oSB75LYU/ckB/rxyaY+baUBwZw8Hq13qAPZxsOiJBInCWfSf/dti67RvBRFFA0es3EWCXpkLGe3p6FEXJwHdZyoqYyqdYbBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723222051; c=relaxed/simple;
	bh=3+edmrl4wwxBd1ZPvg8ZbZF0DTX9Ni7FD3INSR4br4A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Txa71N2pmOkwcNdF5Q4X+UFtJR+Hp3SvhMKXMCPLIEqlar5i9Z5ogF7OgtBCAWzmLLNvCdSQLr+ECQ7DuEEDXYHb/Oy7b0yQ3+aw4X6ovyux9G7KFqZcuv7eefQL5lu/kwwkACWZN133XFLzqqMbsAtcQvptD9QnPPfrl7qY1+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=GYXaanQ1; arc=none smtp.client-ip=173.37.86.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="GYXaanQ1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=26175; q=dns/txt;
  s=iport; t=1723222048; x=1724431648;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7bocTCM3/Pi62qxANQTx4Z5BN3uD9yOFm6kdBmHB7wk=;
  b=GYXaanQ1+FgwEsrxkGpg/642FbS4/KdEf6w60hQ5ctuT8inZNB+C5NFU
   rCufDdNwBF21pulucPorCbBOKg0BNqsyOgYssXz99YlGZ32ICyyW/CdKV
   8HQkCiqly2HE29Fsq9Nt2/AexyByxMsjcZmX5P53Q5NznDV0HzkE/8cIv
   4=;
X-CSE-ConnectionGUID: ynIKc5UdTKO9TNJAp1PU3Q==
X-CSE-MsgGUID: z5P7R3SCS8mgrAUgsKYQUw==
X-IronPort-AV: E=Sophos;i="6.09,276,1716249600"; 
   d="scan'208";a="238885128"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 16:46:19 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPSA id 479Ggo2b031305
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 9 Aug 2024 16:46:18 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2 06/14] scsi: fnic: Add and integrate support for FDMI
Date: Fri,  9 Aug 2024 09:42:32 -0700
Message-Id: <20240809164240.47561-7-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240809164240.47561-1-kartilak@cisco.com>
References: <20240809164240.47561-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: rcdn-core-5.cisco.com

Add support for Fabric-Device Management Interface
(FDMI) by introducing PCI device IDs for Cisco
Hardware.
Introduce a module parameter to enable/disable
FDMI support.
Integrate support for FDMI.

Reported-by: kernel test robot <lkp@intel.com>
Closes:
https://lore.kernel.org/oe-kbuild-all/202406110734.p2v8dq9v-lkp
@intel.com/

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v1 and v2:
    Incorporate review comments from Hannes from other patches:
	Replace pr_info with dev_info.
	Replace htonll() with get_unaligned_be64().
	Replace definitions with standard definitions from fc_els.h.
	Use standard definitions from scsi_transport_fc.h for
	port speeds.
	Refactor definitions in struct fnic to avoid cache holes.
	Replace memcmp with not equal to operator.
    Fix warning from kernel test robot:
	Remove version.h
---
 drivers/scsi/fnic/Makefile                |   3 +-
 drivers/scsi/fnic/fdls_disc.c             | 288 ++++++++++++++++++++++
 drivers/scsi/fnic/fnic.h                  |  72 ++++++
 drivers/scsi/fnic/fnic_fdls.h             |   1 -
 drivers/scsi/fnic/fnic_main.c             |  26 ++
 drivers/scsi/fnic/fnic_pci_subsys_devid.c | 131 ++++++++++
 6 files changed, 519 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/fnic/fnic_pci_subsys_devid.c

diff --git a/drivers/scsi/fnic/Makefile b/drivers/scsi/fnic/Makefile
index 3bd6b1c8b643..af156c69da0c 100644
--- a/drivers/scsi/fnic/Makefile
+++ b/drivers/scsi/fnic/Makefile
@@ -16,4 +16,5 @@ fnic-y	:= \
 	vnic_intr.o \
 	vnic_rq.o \
 	vnic_wq_copy.o \
-	vnic_wq.o
+	vnic_wq.o \
+	fnic_pci_subsys_devid.o
diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 10691335e4c0..e841fd21b7a0 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -12,8 +12,14 @@
 #include <linux/utsname.h>
 
 #define FC_FC4_TYPE_SCSI 0x08
+#define PORT_SPEED_BIT_8 8
+#define PORT_SPEED_BIT_9 9
+#define PORT_SPEED_BIT_14 14
+#define PORT_SPEED_BIT_15 15
 
 static void fdls_send_rpn_id(struct fnic_iport_s *iport);
+static void fdls_fdmi_register_hba(struct fnic_iport_s *iport);
+static void fdls_fdmi_register_pa(struct fnic_iport_s *iport);
 
 /* Frame initialization */
 /*
@@ -74,6 +80,66 @@ struct fc_els_prli_s fnic_prli_req = {
 	.sp = {.type = 0x08, .flags = 0x0020, .csp = 0xA2000000}
 };
 
+/*
+ * Variables:
+ * sid, port_id, port_name
+ */
+struct fc_fdmi_rhba_s fnic_fdmi_rhba = {
+	.fchdr = {.r_ctl = 0x02, .did = {0xFF, 0XFF, 0XFA}, .type = 0x20,
+			  .f_ctl = FNIC_ELS_REQ_FCTL, .ox_id = FNIC_FDMI_REG_HBA_OXID,
+			  .rx_id = 0xFFFF},
+	.fc_ct_hdr = {.rev = 0x01, .fs_type = 0xFA, .fs_subtype = 0x10,
+				  .command = 0x0002},
+	.num_ports = 0x1000000,
+	.num_hba_attributes = 0x9000000,
+	.type_nn = FNIC_FDMI_TYPE_NODE_NAME,
+	.length_nn = 0xc00,
+	.type_manu = FNIC_FDMI_TYPE_MANUFACTURER,
+	.length_manu = 0x1800,
+	.manufacturer = FNIC_FDMI_MANUFACTURER,
+	.type_serial = FNIC_FDMI_TYPE_SERIAL_NUMBER,
+	.length_serial = 0x1400,
+	.type_model = FNIC_FDMI_TYPE_MODEL,
+	.length_model = 0x1000,
+	.type_model_des = FNIC_FDMI_TYPE_MODEL_DES,
+	.length_model_des = 0x3c00,
+	.model_description = FNIC_FDMI_MODEL_DESCRIPTION,
+	.type_hw_ver = FNIC_FDMI_TYPE_HARDWARE_VERSION,
+	.length_hw_ver = 0x1400,
+	.type_dr_ver = FNIC_FDMI_TYPE_DRIVER_VERSION,
+	.length_dr_ver = 0x2000,
+	.type_rom_ver = FNIC_FDMI_TYPE_ROM_VERSION,
+	.length_rom_ver = 0xc00,
+	.type_fw_ver = FNIC_FDMI_TYPE_FIRMWARE_VERSION,
+	.length_fw_ver = 0x1400,
+};
+
+/*
+ * Variables
+ *sid, port_id, port_name
+ */
+struct fc_fdmi_rpa_s fnic_fdmi_rpa = {
+	.fchdr = {.r_ctl = 0x02, .did = {0xFF, 0xFF, 0xFA}, .type = 0x20,
+			  .f_ctl = FNIC_ELS_REQ_FCTL, .ox_id = FNIC_FDMI_RPA_OXID,
+			  .rx_id = 0xFFFF},
+	.fc_ct_hdr = {.rev = 0x01, .fs_type = 0xFA, .fs_subtype = 0x10,
+				  .command = 0x1102},
+	.num_port_attributes = 0x6000000,
+	.type_fc4 = FNIC_FDMI_TYPE_FC4_TYPES,
+	.length_fc4 = 0x2400,
+	.type_supp_speed = FNIC_FDMI_TYPE_SUPPORTED_SPEEDS,
+	.length_supp_speed = 0x800,
+	.type_cur_speed = FNIC_FDMI_TYPE_CURRENT_SPEED,
+	.length_cur_speed = 0x800,
+	.type_max_frame_size = FNIC_FDMI_TYPE_MAX_FRAME_SIZE,
+	.length_max_frame_size = 0x800,
+	.max_frame_size = 0x0080000,
+	.type_os_name = FNIC_FDMI_TYPE_OS_NAME,
+	.length_os_name = 0x1400,
+	.type_host_name = FNIC_FDMI_TYPE_HOST_NAME,
+	.length_host_name = 0x1000,
+};
+
 /*
  * Variables:
  * fh_s_id, port_id, port_name
@@ -187,6 +253,7 @@ static struct fnic_tport_s *fdls_create_tport(struct fnic_iport_s *iport,
 static void fdls_target_restart_nexus(struct fnic_tport_s *tport);
 static void fdls_start_tport_timer(struct fnic_iport_s *iport,
 					struct fnic_tport_s *tport, int timeout);
+static void fdls_send_fdmi_plogi(struct fnic_iport_s *iport);
 static void fdls_start_fabric_timer(struct fnic_iport_s *iport,
 			int timeout);
 static void fdls_tport_timer_callback(struct timer_list *t);
@@ -471,6 +538,36 @@ static void fdls_send_fabric_plogi(struct fnic_iport_s *iport)
 	fdls_start_fabric_timer(iport, 2 * iport->e_d_tov);
 }
 
+static void fdls_send_fdmi_plogi(struct fnic_iport_s *iport)
+{
+	struct fc_els_s plogi;
+	struct fc_hdr_s *fchdr = &plogi.fchdr;
+	uint8_t fcid[3];
+	struct fnic *fnic = iport->fnic;
+	u64 fdmi_tov;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "fcid: 0x%x: FDLS send FDMI PLOGI", iport->fcid);
+
+	memcpy(&plogi, &fnic_plogi_req, sizeof(plogi));
+
+	hton24(fcid, iport->fcid);
+
+	FNIC_SET_S_ID(fchdr, fcid);
+	hton24(fcid, 0XFFFFFA);
+	FNIC_SET_D_ID(fchdr, fcid);
+	FNIC_SET_OX_ID(fchdr, FNIC_PLOGI_FDMI_OXID);
+	FNIC_SET_NPORT_NAME(plogi, iport->wwpn);
+	FNIC_SET_NODE_NAME(plogi, iport->wwnn);
+	FNIC_SET_RDF_SIZE(plogi.u.csp_plogi, iport->max_payload_size);
+
+	fnic_send_fcoe_frame(iport, &plogi, sizeof(struct fc_els_s));
+
+	fdmi_tov = jiffies + msecs_to_jiffies(5000);
+	mod_timer(&iport->fabric.fdmi_timer, round_jiffies(fdmi_tov));
+	iport->fabric.fdmi_pending = 1;
+}
+
 static void fdls_send_rpn_id(struct fnic_iport_s *iport)
 {
 	struct fc_rpn_id_s rpn_id;
@@ -1015,6 +1112,95 @@ struct fnic_tport_s *fnic_find_tport_by_wwpn(struct fnic_iport_s *iport,
 	return NULL;
 }
 
+static void fdls_fdmi_register_hba(struct fnic_iport_s *iport)
+{
+	struct fc_fdmi_rhba_s fdmi_rhba;
+	uint8_t fcid[3];
+	uint16_t len;
+	int err;
+	struct fnic *fnic = iport->fnic;
+	struct vnic_devcmd_fw_info *fw_info = NULL;
+
+	memcpy(&fdmi_rhba, &fnic_fdmi_rhba, sizeof(struct fc_fdmi_rhba_s));
+
+	hton24(fcid, iport->fcid);
+	FNIC_SET_S_ID((&fdmi_rhba.fchdr), fcid);
+	fdmi_rhba.hba_identifier = get_unaligned_be64(&iport->wwpn);
+	fdmi_rhba.port_name = get_unaligned_be64(&iport->wwpn);
+	fdmi_rhba.node_name = get_unaligned_be64(&iport->wwnn);
+
+	err = vnic_dev_fw_info(fnic->vdev, &fw_info);
+	if (!err) {
+		snprintf(fdmi_rhba.serial_num, sizeof(fdmi_rhba.serial_num) - 1,
+				 "%s", fw_info->hw_serial_number);
+		snprintf(fdmi_rhba.hardware_ver,
+				 sizeof(fdmi_rhba.hardware_ver) - 1, "%s",
+				 fw_info->hw_version);
+		strscpy(fdmi_rhba.firmware_ver, fw_info->fw_version,
+				sizeof(fdmi_rhba.firmware_ver) - 1);
+
+		len = ARRAY_SIZE(fdmi_rhba.model);
+		if (fnic->subsys_desc_len >= len)
+			fnic->subsys_desc_len = len - 1;
+		memcpy(&fdmi_rhba.model, fnic->subsys_desc, fnic->subsys_desc_len);
+		fdmi_rhba.model[fnic->subsys_desc_len] = 0x00;
+	}
+
+	snprintf(fdmi_rhba.driver_ver, sizeof(fdmi_rhba.driver_ver) - 1, "%s",
+			 DRV_VERSION);
+	snprintf(fdmi_rhba.rom_ver, sizeof(fdmi_rhba.rom_ver) - 1, "%s",
+			 "N/A");
+	fnic_send_fcoe_frame(iport, &fdmi_rhba, sizeof(struct fc_fdmi_rhba_s));
+}
+
+static void fdls_fdmi_register_pa(struct fnic_iport_s *iport)
+{
+	struct fc_fdmi_rpa_s fdmi_rpa;
+
+	uint8_t fcid[3];
+	struct fnic *fnic = iport->fnic;
+	u32 port_speed_bm;
+	u32 port_speed = vnic_dev_port_speed(fnic->vdev);
+
+	memcpy(&fdmi_rpa, &fnic_fdmi_rpa, sizeof(struct fc_fdmi_rpa_s));
+	hton24(fcid, iport->fcid);
+	FNIC_SET_S_ID((&fdmi_rpa.fchdr), fcid);
+	fdmi_rpa.port_name = get_unaligned_be64(&iport->wwpn);
+
+	/* MDS does not support GIGE speed.
+	 * Bit shift standard definitions from scsi_transport_fc.h to
+	 * match FC spec.
+	 */
+	switch (port_speed) {
+	case DCEM_PORTSPEED_10G:
+	case DCEM_PORTSPEED_20G:
+		/* There is no bit for 20G */
+		port_speed_bm = FC_PORTSPEED_10GBIT << PORT_SPEED_BIT_14;
+		break;
+	case DCEM_PORTSPEED_25G:
+		port_speed_bm = FC_PORTSPEED_25GBIT << PORT_SPEED_BIT_8;
+		break;
+	case DCEM_PORTSPEED_40G:
+	case DCEM_PORTSPEED_4x10G:
+		port_speed_bm = FC_PORTSPEED_40GBIT << PORT_SPEED_BIT_9;
+		break;
+	case DCEM_PORTSPEED_100G:
+		port_speed_bm = FC_PORTSPEED_100GBIT << PORT_SPEED_BIT_8;
+		break;
+	default:
+		port_speed_bm = FC_PORTSPEED_1GBIT << PORT_SPEED_BIT_15;
+		break;
+	}
+	fdmi_rpa.supported_speed = htonl(port_speed_bm);
+	fdmi_rpa.current_speed = htonl(port_speed_bm);
+	fdmi_rpa.fc4_type[2] = 1;
+	snprintf(fdmi_rpa.os_name, sizeof(fdmi_rpa.os_name) - 1, "host%d",
+			 fnic->lport->host->host_no);
+	snprintf(fdmi_rpa.host_name, sizeof(fdmi_rpa.host_name) - 1, "%s",
+			 utsname()->nodename);
+	fnic_send_fcoe_frame(iport, &fdmi_rpa, sizeof(struct fc_fdmi_rpa_s));
+}
+
 void fdls_fabric_timer_callback(struct timer_list *t)
 {
 	struct fnic_fdls_fabric_s *fabric = from_timer(fabric, t, retry_timer);
@@ -1184,6 +1370,23 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 }
 
+void fdls_fdmi_timer_callback(struct timer_list *t)
+{
+	struct fnic_fdls_fabric_s *fabric = from_timer(fabric, t, fdmi_timer);
+	struct fnic_iport_s *iport =
+		container_of(fabric, struct fnic_iport_s, fabric);
+	struct fnic *fnic = iport->fnic;
+
+	if (iport->fabric.fdmi_retry < 7) {
+		iport->fabric.fdmi_retry++;
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "retry fdmi timer %d", iport->fabric.fdmi_retry);
+		fdls_send_fdmi_plogi(iport);
+	} else {
+		iport->fabric.fdmi_pending = 0;
+	}
+}
+
 static void fdls_send_delete_tport_msg(struct fnic_tport_s *tport)
 {
 	struct fnic_iport_s *iport = (struct fnic_iport_s *) tport->iport;
@@ -1328,6 +1531,15 @@ static void fnic_fdls_start_plogi(struct fnic_iport_s *iport)
 	fdls_send_fabric_plogi(iport);
 	fdls_set_state((&iport->fabric), FDLS_STATE_FABRIC_PLOGI);
 	iport->fabric.flags &= ~FNIC_FDLS_FABRIC_ABORT_ISSUED;
+
+	if ((fnic_fdmi_support == 1) && (!(iport->flags & FNIC_FDMI_ACTIVE))) {
+		/* we can do FDMI at the same time */
+		iport->fabric.fdmi_retry = 0;
+		timer_setup(&iport->fabric.fdmi_timer, fdls_fdmi_timer_callback,
+					0);
+		fdls_send_fdmi_plogi(iport);
+		iport->flags |= FNIC_FDMI_ACTIVE;
+	}
 }
 
 static void
@@ -2400,6 +2612,69 @@ fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 	}
 }
 
+static void fdls_process_fdmi_plogi_rsp(struct fnic_iport_s *iport,
+								struct fc_hdr_s *fchdr)
+{
+	struct fc_els_s *plogi_rsp = (struct fc_els_s *) fchdr;
+	struct fc_els_reject_s *els_rjt = (struct fc_els_reject_s *) fchdr;
+	struct fnic *fnic = iport->fnic;
+	u64 fdmi_tov;
+
+	if (ntoh24(fchdr->sid) == 0XFFFFFA) {
+		del_timer_sync(&iport->fabric.fdmi_timer);
+		iport->fabric.fdmi_pending = 0;
+		switch (plogi_rsp->command) {
+		case ELS_LS_ACC:
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "FDLS process fdmi PLOGI response status: ELS_LS_ACC\n");
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Sending fdmi registration for port 0x%x\n",
+				 iport->fcid);
+
+			fdls_fdmi_register_hba(iport);
+			fdls_fdmi_register_pa(iport);
+			fdmi_tov = jiffies + msecs_to_jiffies(5000);
+			mod_timer(&iport->fabric.fdmi_timer, round_jiffies(fdmi_tov));
+			iport->fabric.fdmi_pending = 2;
+			break;
+		case ELS_LS_RJT:
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Fabric FDMI PLOGI returned ELS_LS_RJT reason: 0x%x",
+				 els_rjt->reason_code);
+
+			if (((els_rjt->reason_code == FC_ELS_RJT_LOGICAL_BUSY)
+				 || (els_rjt->reason_code == FC_ELS_RJT_BUSY))
+				&& (iport->fabric.fdmi_retry < 7)) {
+				iport->fabric.fdmi_retry++;
+				fdls_send_fdmi_plogi(iport);
+			}
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static void fdls_process_fdmi_reg_ack(struct fnic_iport_s *iport,
+									  struct fc_hdr_s *fchdr)
+{
+	struct fnic *fnic = iport->fnic;
+
+	if (iport->fabric.fdmi_pending > 0) {
+		iport->fabric.fdmi_pending--;
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "iport fcid: 0x%x: Received FDMI registration ack\n",
+					 iport->fcid);
+
+		if (iport->fabric.fdmi_pending == 0) {
+			del_timer_sync(&iport->fabric.fdmi_timer);
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "iport fcid: 0x%x: Canceling FDMI timer\n",
+						 iport->fcid);
+		}
+	}
+}
+
 static void
 fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 							 struct fc_hdr_s *fchdr)
@@ -3327,6 +3602,12 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 		}
 		return FNIC_FABRIC_PLOGI_RSP;
 
+	case FNIC_PLOGI_FDMI_OXID:
+		return FNIC_FDMI_PLOGI_RSP;
+	case FNIC_FDMI_REG_HBA_OXID:
+	case FNIC_FDMI_RPA_OXID:
+		return FNIC_FDMI_RSP;
+
 	case FNIC_SCR_REQ_OXID:
 		if (type == ELS_LS_ACC) {
 			if ((s_id != FC_FABRIC_CONTROLLER)
@@ -3407,6 +3688,9 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 	case FNIC_FABRIC_PLOGI_RSP:
 		fdls_process_fabric_plogi_rsp(iport, fchdr);
 		break;
+	case FNIC_FDMI_PLOGI_RSP:
+		fdls_process_fdmi_plogi_rsp(iport, fchdr);
+		break;
 	case FNIC_FABRIC_RPN_RSP:
 		fdls_process_rpn_id_rsp(iport, fchdr);
 		break;
@@ -3474,9 +3758,13 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 	case FNIC_ELS_RLS:
 		fdls_process_rls_req(iport, fchdr);
 		break;
+	case FNIC_FDMI_RSP:
+		fdls_process_fdmi_reg_ack(iport, fchdr);
+		break;
 	default:
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 			 "Received unknown FCoE frame of len: %d. Dropping frame", len);
 		break;
 	}
 }
+
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 92cd17efa40f..5d8315b24085 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -82,6 +82,72 @@
 /* Retry supported by rport (returned by PRLI service parameters) */
 #define FNIC_FC_RP_FLAGS_RETRY            0x1
 
+/* Cisco vendor id */
+#define PCI_VENDOR_ID_CISCO						0x1137
+#define PCI_DEVICE_ID_CISCO_VIC_FC				0x0045	/* fc vnic */
+
+/* sereno pcie switch */
+#define PCI_DEVICE_ID_CISCO_SERENO             0x004e
+#define PCI_DEVICE_ID_CISCO_CRUZ               0x007a	/* Cruz */
+#define PCI_DEVICE_ID_CISCO_BODEGA             0x0131	/* Bodega */
+#define PCI_DEVICE_ID_CISCO_BEVERLY            0x025f	/* Beverly */
+
+/* Sereno */
+#define PCI_SUBDEVICE_ID_CISCO_VASONA			0x004f	/* vasona mezz */
+#define PCI_SUBDEVICE_ID_CISCO_COTATI			0x0084	/* cotati mlom */
+#define PCI_SUBDEVICE_ID_CISCO_LEXINGTON		0x0085	/* lexington pcie */
+#define PCI_SUBDEVICE_ID_CISCO_ICEHOUSE			0x00cd	/* Icehouse */
+#define PCI_SUBDEVICE_ID_CISCO_KIRKWOODLAKE		0x00ce	/* KirkwoodLake pcie */
+#define PCI_SUBDEVICE_ID_CISCO_SUSANVILLE		0x012e	/* Susanville MLOM */
+#define PCI_SUBDEVICE_ID_CISCO_TORRANCE			0x0139	/* Torrance MLOM */
+
+/* Cruz */
+#define PCI_SUBDEVICE_ID_CISCO_CALISTOGA		0x012c	/* Calistoga MLOM */
+#define PCI_SUBDEVICE_ID_CISCO_MOUNTAINVIEW		0x0137	/* Cruz Mezz */
+/* Cruz MountTian SIOC */
+#define PCI_SUBDEVICE_ID_CISCO_MOUNTTIAN		0x014b
+#define PCI_SUBDEVICE_ID_CISCO_CLEARLAKE		0x014d	/* ClearLake pcie */
+/* Cruz MountTian2 SIOC */
+#define PCI_SUBDEVICE_ID_CISCO_MOUNTTIAN2		0x0157
+#define PCI_SUBDEVICE_ID_CISCO_CLAREMONT		0x015d	/* Claremont MLOM */
+
+/* Bodega */
+/* VIC 1457 PCIe mLOM */
+#define PCI_SUBDEVICE_ID_CISCO_BRADBURY         0x0218
+#define PCI_SUBDEVICE_ID_CISCO_BRENTWOOD        0x0217	/* VIC 1455 PCIe */
+/* VIC 1487 PCIe mLOM */
+#define PCI_SUBDEVICE_ID_CISCO_BURLINGAME       0x021a
+#define PCI_SUBDEVICE_ID_CISCO_BAYSIDE          0x0219	/* VIC 1485 PCIe */
+/* VIC 1440 Mezz mLOM */
+#define PCI_SUBDEVICE_ID_CISCO_BAKERSFIELD      0x0215
+#define PCI_SUBDEVICE_ID_CISCO_BOONVILLE        0x0216	/* VIC 1480 Mezz */
+#define PCI_SUBDEVICE_ID_CISCO_BENICIA          0x024a	/* VIC 1495 */
+#define PCI_SUBDEVICE_ID_CISCO_BEAUMONT         0x024b	/* VIC 1497 */
+#define PCI_SUBDEVICE_ID_CISCO_BRISBANE         0x02af	/* VIC 1467 */
+#define PCI_SUBDEVICE_ID_CISCO_BENTON           0x02b0	/* VIC 1477 */
+#define PCI_SUBDEVICE_ID_CISCO_TWIN_RIVER       0x02cf	/* VIC 14425 */
+#define PCI_SUBDEVICE_ID_CISCO_TWIN_PEAK        0x02d0	/* VIC 14825 */
+
+/* Beverly */
+#define PCI_SUBDEVICE_ID_CISCO_BERN             0x02de	/* VIC 15420 */
+#define PCI_SUBDEVICE_ID_CISCO_STOCKHOLM        0x02dd	/* VIC 15428 */
+#define PCI_SUBDEVICE_ID_CISCO_KRAKOW           0x02dc	/* VIC 15411 */
+#define PCI_SUBDEVICE_ID_CISCO_LUCERNE          0x02db	/* VIC 15231 */
+#define PCI_SUBDEVICE_ID_CISCO_TURKU            0x02e8	/* VIC 15238 */
+#define PCI_SUBDEVICE_ID_CISCO_TURKU_PLUS       0x02f3	/* VIC 15237 */
+#define PCI_SUBDEVICE_ID_CISCO_ZURICH           0x02df	/* VIC 15230 */
+#define PCI_SUBDEVICE_ID_CISCO_RIGA             0x02e0	/* VIC 15427 */
+#define PCI_SUBDEVICE_ID_CISCO_GENEVA           0x02e1	/* VIC 15422 */
+#define PCI_SUBDEVICE_ID_CISCO_HELSINKI         0x02e4	/* VIC 15235 */
+#define PCI_SUBDEVICE_ID_CISCO_GOTHENBURG       0x02f2	/* VIC 15425 */
+
+struct fnic_pcie_device {
+	u32 device;
+	u8 *desc;
+	u32 subsystem_device;
+	u8 *subsys_desc;
+};
+
 /*
  * fnic private data per SCSI command.
  * These fields are locked by the hashed io_req_lock.
@@ -134,6 +200,7 @@ static inline u64 fnic_flags_and_state(struct scsi_cmnd *cmd)
 #define fnic_clear_state_flags(fnicp, st_flags)  \
 	__fnic_set_state_flags(fnicp, st_flags, 1)
 
+extern unsigned int fnic_fdmi_support;
 extern unsigned int fnic_log_level;
 extern unsigned int io_completions;
 extern struct workqueue_struct *fnic_event_queue;
@@ -336,6 +403,9 @@ struct fnic {
 	struct work_struct tport_work;
 	struct list_head tport_event_list;
 
+	char subsys_desc[14];
+	int subsys_desc_len;
+
 	/*** FIP related data members  -- start ***/
 	void (*set_vlan)(struct fnic *, u16 vlan);
 	struct work_struct      fip_frame_work;
@@ -433,5 +503,7 @@ fnic_chk_state_flags_locked(struct fnic *fnic, unsigned long st_flags)
 void __fnic_set_state_flags(struct fnic *, unsigned long, unsigned long);
 void fnic_dump_fchost_stats(struct Scsi_Host *, struct fc_host_statistics *);
 void fnic_free_txq(struct list_head *head);
+int fnic_get_desc_by_devid(struct pci_dev *pdev, char **desc,
+						   char **subsys_desc);
 
 #endif /* _FNIC_H_ */
diff --git a/drivers/scsi/fnic/fnic_fdls.h b/drivers/scsi/fnic/fnic_fdls.h
index bb3e9d26c18a..42fea3d69a83 100644
--- a/drivers/scsi/fnic/fnic_fdls.h
+++ b/drivers/scsi/fnic/fnic_fdls.h
@@ -354,4 +354,3 @@ struct fnic_tport_s *fnic_find_tport_by_wwpn(struct fnic_iport_s *iport,
 		uint64_t  wwpn);
 
 #endif /* _FNIC_FDLS_H_ */
-
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index fd0b00fea813..b0ddb7a816f8 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -62,6 +62,9 @@ unsigned int fnic_log_level;
 module_param(fnic_log_level, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(fnic_log_level, "bit mask of fnic logging levels");
 
+unsigned int fnic_fdmi_support = 1;
+module_param(fnic_fdmi_support, int, 0644);
+MODULE_PARM_DESC(fnic_fdmi_support, "FDMI support");
 
 unsigned int io_completions = FNIC_DFLT_IO_COMPLETIONS;
 module_param(io_completions, int, S_IRUGO|S_IWUSR);
@@ -607,6 +610,8 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int i;
 	unsigned long flags;
 	int hwq;
+	char *desc, *subsys_desc;
+	int len;
 
 	/*
 	 * Allocate SCSI Host and set up association between host,
@@ -640,6 +645,23 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fnic->fnic_num = fnic_id;
 	fnic_stats_debugfs_init(fnic);
 
+	/* Find model name from PCIe subsys ID */
+	if (fnic_get_desc_by_devid(pdev, &desc, &subsys_desc) == 0) {
+		dev_info(&fnic->pdev->dev, "Model: %s\n", subsys_desc);
+
+		/* Update FDMI model */
+		fnic->subsys_desc_len = strlen(subsys_desc);
+		len = ARRAY_SIZE(fnic->subsys_desc);
+		if (fnic->subsys_desc_len > len)
+			fnic->subsys_desc_len = len;
+		memcpy(fnic->subsys_desc, subsys_desc, fnic->subsys_desc_len);
+		dev_info(&fnic->pdev->dev, "FDMI Model: %s\n", fnic->subsys_desc);
+	} else {
+		fnic->subsys_desc_len = 0;
+		dev_info(&fnic->pdev->dev, "Model: %s subsys_id: 0x%04x\n", "Unknown",
+				pdev->subsystem_device);
+	}
+
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "Cannot enable PCI device, aborting.\n");
@@ -1014,6 +1036,9 @@ static void fnic_remove(struct pci_dev *pdev)
 		fnic_fcoe_evlist_free(fnic);
 	}
 
+	if ((fnic_fdmi_support == 1) && (fnic->iport.fabric.fdmi_pending > 0))
+		del_timer_sync(&fnic->iport.fabric.fdmi_timer);
+
 	/*
 	 * Log off the fabric. This stops all remote ports, dns port,
 	 * logs off the fabric. This flushes all rport, disc, lport work
@@ -1199,3 +1224,4 @@ static void __exit fnic_cleanup_module(void)
 
 module_init(fnic_init_module);
 module_exit(fnic_cleanup_module);
+
diff --git a/drivers/scsi/fnic/fnic_pci_subsys_devid.c b/drivers/scsi/fnic/fnic_pci_subsys_devid.c
new file mode 100644
index 000000000000..36a2c1268422
--- /dev/null
+++ b/drivers/scsi/fnic/fnic_pci_subsys_devid.c
@@ -0,0 +1,131 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
+ */
+
+#include <linux/module.h>
+#include <linux/mempool.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/kthread.h>
+#include <linux/if_ether.h>
+#include "fnic.h"
+
+static struct fnic_pcie_device fnic_pcie_device_table[] = {
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno", PCI_SUBDEVICE_ID_CISCO_VASONA,
+	 "VIC 1280"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno", PCI_SUBDEVICE_ID_CISCO_COTATI,
+	 "VIC 1240"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno",
+	 PCI_SUBDEVICE_ID_CISCO_LEXINGTON, "VIC 1225"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno", PCI_SUBDEVICE_ID_CISCO_ICEHOUSE,
+	 "VIC 1285"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno",
+	 PCI_SUBDEVICE_ID_CISCO_KIRKWOODLAKE, "VIC 1225T"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno",
+	 PCI_SUBDEVICE_ID_CISCO_SUSANVILLE, "VIC 1227"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno", PCI_SUBDEVICE_ID_CISCO_TORRANCE,
+	 "VIC 1227T"},
+
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_CALISTOGA,
+	 "VIC 1340"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_MOUNTAINVIEW,
+	 "VIC 1380"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_MOUNTTIAN,
+	 "C3260-SIOC"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_CLEARLAKE,
+	 "VIC 1385"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_MOUNTTIAN2,
+	 "C3260-SIOC"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_CLAREMONT,
+	 "VIC 1387"},
+
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BRADBURY,
+	 "VIC 1457"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_BRENTWOOD, "VIC 1455"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_BURLINGAME, "VIC 1487"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BAYSIDE,
+	 "VIC 1485"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_BAKERSFIELD, "VIC 1440"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_BOONVILLE, "VIC 1480"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BENICIA,
+	 "VIC 1495"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BEAUMONT,
+	 "VIC 1497"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BRISBANE,
+	 "VIC 1467"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BENTON,
+	 "VIC 1477"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_TWIN_RIVER, "VIC 14425"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_TWIN_PEAK, "VIC 14825"},
+
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_BERN,
+	 "VIC 15420"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_STOCKHOLM, "VIC 15428"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_KRAKOW,
+	 "VIC 15411"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_LUCERNE, "VIC 15231"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_TURKU,
+	 "VIC 15238"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_GENEVA,
+	 "VIC 15422"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_HELSINKI, "VIC 15235"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_GOTHENBURG, "VIC 15425"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_TURKU_PLUS, "VIC 15237"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_ZURICH,
+	 "VIC 15230"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_RIGA,
+	 "VIC 15427"},
+
+	{0,}
+};
+
+int fnic_get_desc_by_devid(struct pci_dev *pdev, char **desc,
+						   char **subsys_desc)
+{
+	unsigned short device = PCI_DEVICE_ID_CISCO_VIC_FC;
+	int max = ARRAY_SIZE(fnic_pcie_device_table);
+	struct fnic_pcie_device *t = fnic_pcie_device_table;
+	int index = 0;
+
+	if (pdev->device != device)
+		return 1;
+
+	while (t->device != 0) {
+		if (memcmp
+			((char *) &pdev->subsystem_device,
+			 (char *) &t->subsystem_device, sizeof(short)) == 0)
+			break;
+		t++;
+		index++;
+	}
+
+	if (index >= max - 1) {
+		*desc = NULL;
+		*subsys_desc = NULL;
+		return 1;
+	}
+
+	*desc = fnic_pcie_device_table[index].desc;
+	*subsys_desc = fnic_pcie_device_table[index].subsys_desc;
+	return 0;
+}
-- 
2.31.1

