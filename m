Received: from rcdn-iport-3.cisco.com (rcdn-iport-3.cisco.com [173.37.86.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0EA1C1AA6;
	Fri, 27 Sep 2024 18:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462956; cv=none; b=Yx5H1tqmIbUHUE5g7EVSHCjxjKf8h06HFspl+/OfgerQ+zdpXfqsCTZzvNsVGVhxG82mksEkb3z05Mk120LOFJEX4Z6/54q0g73NC2KfAEjzDs60GVKiVD4uSIKdovVQTzjmNbz89j0zDu1i0ME40WU8Vg0SuKqZQVR+OtrDP/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462956; c=relaxed/simple;
	bh=fvMgX986tUVxwpP22TgR3jua+TVhct+8EPAJ1oLq2Tk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NhfiSrZlxRRqz7M9BAWmVrkOs9aeU2Nbe2ipGYnZ9d3bTrb6aobboEZ0TrRtJbjZh2X+GRCIYotuLax934IvSEPQ4hTkrVIXwdxywdH/GlXTjVagrMDwiItr+S81rUPde81shCYC7a5cBDRgXm7vkfxYjKD5IW88+PgL6WtDyzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=gUAC7GZy; arc=none smtp.client-ip=173.37.86.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="gUAC7GZy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=27275; q=dns/txt;
  s=iport; t=1727462953; x=1728672553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vkuQPIEGzE6PnYxb7iXPs+d94C/9sMRzO0zzleLcfqg=;
  b=gUAC7GZyr/G0GUcyQNwtFrba4ZCDVan7auAJjcKqAIzWjn96ZszgAOB0
   A0DTKfAxw83RlsVyj29CGGRFaDmJb75nmo/qXjHznZeCY8SMfMvAY5LTL
   q0hscJPyV/ToZ9B42+DzxjsGJLei2eAY2FNAvfEmlZjfgdJFbXBWM+vjH
   w=;
X-CSE-ConnectionGUID: H9cSUZT+QvKUImy9a7J9Eg==
X-CSE-MsgGUID: N+t4cpSvTb+drRbL557d2w==
X-IronPort-AV: E=Sophos;i="6.11,159,1725321600"; 
   d="scan'208";a="267608677"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2024 18:48:03 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPSA id 48RIkQaj022754
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 27 Sep 2024 18:48:03 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v3 02/14] scsi: fnic: Add headers and definitions for FDLS
Date: Fri, 27 Sep 2024 11:46:01 -0700
Message-Id: <20240927184613.52172-3-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240927184613.52172-1-kartilak@cisco.com>
References: <20240927184613.52172-1-kartilak@cisco.com>
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

Add headers and definitions for FDLS (Fabric Discovery and Login
Services).

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Gian Carlo Boffa <gcboffa@cisco.com>
Signed-off-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Signed-off-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v2 and v3:
    Incorporate review comments from Hannes:
	Replace redundant structure definitions with standard
	definitions.
	Remove multiple endian macro copies.
	Remove static OXIDs macro definitions.

Changes between v1 and v2:
    Incorporate review comments from Hannes:
	Remove redundant patch description.
	Replace htonll() with get_unaligned_be64().
	Replace raw values with macro names.
	Remove fnic_del_fabric_timer_sync macro.
	Remove fnic_del_tport_timer_sync macro.
	Add fnic_del_fabric_timer_sync function declaration.
	Add fnic_del_tport_timer_sync function declaration.
	Replace definitions with standard definitions from fc_els.h.
	Move FDMI function declaration to this patch.
    Incorporate review comments from John:
	Replace int return value with void.
---
 drivers/scsi/fnic/fdls_fc.h   | 381 ++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_fdls.h | 431 ++++++++++++++++++++++++++++++++++
 2 files changed, 812 insertions(+)
 create mode 100644 drivers/scsi/fnic/fdls_fc.h
 create mode 100644 drivers/scsi/fnic/fnic_fdls.h

diff --git a/drivers/scsi/fnic/fdls_fc.h b/drivers/scsi/fnic/fdls_fc.h
new file mode 100644
index 000000000000..25dc89a4fc2f
--- /dev/null
+++ b/drivers/scsi/fnic/fdls_fc.h
@@ -0,0 +1,381 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
+ */
+
+#ifndef _FDLS_FC_H_
+#define _FDLS_FC_H_
+
+/* This file contains the declarations for FC fabric services
+ * and target discovery
+ *
+ * Request and Response for
+ * 1. FLOGI
+ * 2. PLOGI to Fabric Controller
+ * 3. GPN_ID, GPN_FT
+ * 4. RSCN
+ * 5. PLOGI to Target
+ * 6. PRLI to Target
+ */
+
+#include <scsi/scsi.h>
+#include <scsi/fc/fc_els.h>
+#include <uapi/scsi/fc/fc_fs.h>
+#include <uapi/scsi/fc/fc_ns.h>
+#include <uapi/scsi/fc/fc_gs.h>
+#include <scsi/fc/fc_ms.h>
+
+#ifndef MIN
+#define MIN(x, y) (x < y ? x : y)
+#endif				/* MIN */
+
+#define FNIC_FCP_SP_RD_XRDY_DIS 0x00000002
+#define FNIC_FCP_SP_TARGET      0x00000010
+#define FNIC_FCP_SP_INITIATOR   0x00000020
+#define FNIC_FCP_SP_CONF_CMPL   0x00000080
+#define FNIC_FCP_SP_RETRY       0x00000100
+
+#define FNIC_E_D_TOV           (0x7d0)
+#define FNIC_FC_CONCUR_SEQS    (0xFF)
+#define FNIC_FC_RO_INFO        (0x1F)
+
+/* Little Endian */
+#define FNIC_UNSUPPORTED_RESP_OXID   (0xffff)
+#define FNIC_UNASSIGNED_RXID	(0xffff)
+#define FNIC_ELS_REQ_FCTL      (0x000029)
+#define FNIC_ELS_REP_FCTL      (0x000099)
+
+#define FNIC_FCP_RSP_FCTL      (0x000099)
+#define FNIC_REQ_ABTS_FCTL     (0x000009)
+
+#define FNIC_FC_PH_VER_HI      (0x20)
+#define FNIC_FC_PH_VER_LO      (0x20)
+#define FNIC_FC_PH_VER         (0x2020)
+#define FNIC_FC_B2B_CREDIT     (0x0A)
+#define FNIC_FC_B2B_RDF_SZ     (0x0800)
+
+#define FNIC_FC_FEATURES       (0x0080)
+
+#define ETH_TYPE_FCOE			0x8906
+#define ETH_TYPE_FIP			0x8914
+
+#define FC_DIR_SERVER          0xFFFFFC
+#define FC_FABRIC_CONTROLLER   0xFFFFFD
+#define FC_DOMAIN_CONTR        0xFFFFFE
+
+#define FNIC_FC_GPN_LAST_ENTRY (0x80)
+
+#define FNIC_BA_ACC_RCTL        0x84
+#define FNIC_BA_RJT_RCTL        0x85
+#define FC_ABTS_RCTL            0x81
+
+/* FNIC FDMI Register HBA Macros */
+#define FNIC_FDMI_NUM_PORTS 0x1000000
+#define FNIC_FDMI_NUM_HBA_ATTRS 0x9000000
+#define FNIC_FDMI_TYPE_NODE_NAME	0X100
+#define FNIC_FDMI_TYPE_MANUFACTURER	0X200
+#define FNIC_FDMI_MANUFACTURER		"Cisco Systems"
+#define FNIC_FDMI_TYPE_SERIAL_NUMBER	0X300
+#define FNIC_FDMI_TYPE_MODEL		0X400
+#define FNIC_FDMI_TYPE_MODEL_DES	0X500
+#define FNIC_FDMI_MODEL_DESCRIPTION	"Cisco Virtual Interface Card"
+#define FNIC_FDMI_TYPE_HARDWARE_VERSION	0X600
+#define FNIC_FDMI_TYPE_DRIVER_VERSION	0X700
+#define FNIC_FDMI_TYPE_ROM_VERSION	0X800
+#define FNIC_FDMI_TYPE_FIRMWARE_VERSION	0X900
+#define FNIC_FDMI_NN_LEN 0xc00
+#define FNIC_FDMI_MANU_LEN 0x1800
+#define FNIC_FDMI_SERIAL_LEN 0x1400
+#define FNIC_FDMI_MODEL_LEN 0x1000
+#define FNIC_FDMI_MODEL_DES_LEN 0x3c00
+#define FNIC_FDMI_HW_VER_LEN 0x1400
+#define FNIC_FDMI_DR_VER_LEN 0x2000
+#define FNIC_FDMI_ROM_VER_LEN 0xc00
+#define FNIC_FDMI_FW_VER_LEN 0x1400
+
+/* FNIC FDMI Register PA Macros */
+#define FNIC_FDMI_TYPE_FC4_TYPES	0X100
+#define FNIC_FDMI_TYPE_SUPPORTED_SPEEDS 0X200
+#define FNIC_FDMI_TYPE_CURRENT_SPEED	0X300
+#define FNIC_FDMI_TYPE_MAX_FRAME_SIZE	0X400
+#define FNIC_FDMI_TYPE_OS_NAME		0X500
+#define FNIC_FDMI_TYPE_HOST_NAME	0X600
+#define FNIC_FDMI_NUM_PORT_ATTRS 0x6000000
+#define FNIC_FDMI_FC4_LEN 0x2400
+#define FNIC_FDMI_SUPP_SPEED_LEN 0x800
+#define FNIC_FDMI_CUR_SPEED_LEN 0x800
+#define FNIC_FDMI_MFS_LEN 0x800
+#define FNIC_FDMI_MFS 0x0080000
+#define FNIC_FDMI_OS_NAME_LEN 0x1400
+#define FNIC_FDMI_HN_LEN 0x1C00
+
+#define FNIC_LOGI_RDF_SIZE(_logi) ((_logi)->fl_csp.sp_bb_data)
+#define FNIC_LOGI_R_A_TOV(_logi) ((_logi)->fl_csp.sp_r_a_tov)
+#define FNIC_LOGI_E_D_TOV(_logi) ((_logi)->fl_csp.sp_e_d_tov)
+#define FNIC_LOGI_FEATURES(_logi) ((_logi)->fl_csp.sp_features)
+#define FNIC_LOGI_PORT_NAME(_logi) ((_logi)->fl_wwpn)
+#define FNIC_LOGI_NODE_NAME(_logi) ((_logi)->fl_wwnn)
+
+#define FNIC_LOGI_SET_NPORT_NAME(_logi, _pName) \
+	(FNIC_LOGI_PORT_NAME(_logi) = get_unaligned_be64(&_pName))
+#define FNIC_LOGI_SET_NODE_NAME(_logi, _pName) \
+	(FNIC_LOGI_NODE_NAME(_logi) = get_unaligned_be64(&_pName))
+#define FNIC_LOGI_SET_RDF_SIZE(_logi, _rdf_size) \
+	(FNIC_LOGI_RDF_SIZE(_logi) = cpu_to_be16(_rdf_size))
+#define FNIC_LOGI_SET_E_D_TOV(_logi, _e_d_tov) \
+	(FNIC_LOGI_E_D_TOV(_logi) = htonl(_e_d_tov))
+#define FNIC_LOGI_SET_R_A_TOV(_logi, _r_a_tov) \
+	(FNIC_LOGI_R_A_TOV(_logi) = htonl(_r_a_tov))
+
+#define FNIC_STD_SET_S_ID(_fchdr, _sid)        memcpy((_fchdr)->fh_s_id, _sid, 3)
+#define FNIC_STD_SET_D_ID(_fchdr, _did)        memcpy((_fchdr)->fh_d_id, _did, 3)
+#define FNIC_STD_SET_OX_ID(_fchdr, _oxid)      ((_fchdr)->fh_ox_id = _oxid)
+#define FNIC_STD_SET_RX_ID(_fchdr, _rxid)      ((_fchdr)->fh_rx_id = _rxid)
+
+#define FNIC_STD_SET_R_CTL(_fchdr, _rctl)	((_fchdr)->fh_r_ctl = _rctl)
+#define FNIC_STD_SET_TYPE(_fchdr, _type)	((_fchdr)->fh_type = _type)
+#define FNIC_STD_SET_F_CTL(_fchdr, _fctl) \
+	put_unaligned_be24(_fctl, (_fchdr)->fh_f_ctl)
+
+#define FNIC_STD_SET_NPORT_NAME(_ptr, _wwpn)	put_unaligned_be64(_wwpn, _ptr)
+#define FNIC_STD_SET_NODE_NAME(_ptr, _wwnn)	put_unaligned_be64(_wwnn, _ptr)
+#define FNIC_STD_SET_PORT_ID(__req, __portid) \
+	memcpy(__req->fr_fid.fp_fid, __portid, 3)
+#define FNIC_STD_SET_PORT_NAME(_req, _pName) \
+	(put_unaligned_be64(_pName, &_req->fr_wwn))
+
+#define FNIC_STD_GET_OX_ID(_fchdr)		((_fchdr)->fh_ox_id)
+#define FNIC_STD_GET_RX_ID(_fchdr)		((_fchdr)->fh_rx_id)
+#define FNIC_STD_GET_S_ID(_fchdr)		((_fchdr)->fh_s_id)
+#define FNIC_STD_GET_D_ID(_fchdr)		((_fchdr)->fh_d_id)
+#define FNIC_STD_GET_TYPE(_fchdr)		((_fchdr)->fh_type)
+#define FNIC_STD_GET_F_CTL(_fchdr)		((_fchdr)->fh_f_ctl)
+#define FNIC_STD_GET_R_CTL(_fchdr)		((_fchdr)->fh_r_ctl)
+
+#define FNIC_STD_GET_FC_CT_CMD(__fcct_hdr)  (be16_to_cpu(__fcct_hdr->ct_cmd))
+
+#define FNIC_FCOE_SOF         (0x2E)
+#define FNIC_FCOE_EOF         (0x42)
+
+#define FNIC_FCOE_MAX_FRAME_SZ  (2048)
+#define FNIC_FCOE_MIN_FRAME_SZ  (280)
+#define FNIC_FC_MAX_PAYLOAD_LEN (2048)
+#define FNIC_MIN_DATA_FIELD_SIZE  (256)
+#define FNIC_R_A_TOV_DEF        (10 * 1000) /* msec */
+#define FNIC_E_D_TOV_DEF        (2 * 1000)  /* msec */
+
+#define FNIC_FC_EDTOV_NSEC    (0x400)
+#define FNIC_NSEC_TO_MSEC     (0x1000000)
+#define FCP_PRLI_FUNC_TARGET	(0x0010)
+
+#define FNIC_FC_R_CTL_SOLICITED_DATA			(0x21)
+#define FNIC_FC_F_CTL_LAST_END_SEQ				(0x98)
+#define FNIC_FC_F_CTL_LAST_END_SEQ_INT			(0x99)
+#define FNIC_FC_F_CTL_FIRST_LAST_SEQINIT		(0x29)
+#define FNIC_FC_R_CTL_FC4_SCTL					(0x03)
+#define FNIC_FC_CS_CTL							(0x00)
+
+#define FNIC_FC_FRAME_UNSOLICITED(_fchdr)				\
+		(_fchdr->fh_r_ctl == FC_RCTL_ELS_REQ)
+#define FNIC_FC_FRAME_SOLICITED_DATA(_fchdr)			\
+		(_fchdr->fh_r_ctl == FNIC_FC_R_CTL_SOLICITED_DATA)
+#define FNIC_FC_FRAME_SOLICITED_CTRL_REPLY(_fchdr)		\
+		(_fchdr->fh_r_ctl == FC_RCTL_ELS_REP)
+#define FNIC_FC_FRAME_FCTL_LAST_END_SEQ(_fchdr)			\
+		(_fchdr->fh_f_ctl[0] == FNIC_FC_F_CTL_LAST_END_SEQ)
+#define FNIC_FC_FRAME_FCTL_LAST_END_SEQ_INT(_fchdr)		\
+		(_fchdr->fh_f_ctl[0] == FNIC_FC_F_CTL_LAST_END_SEQ_INT)
+#define FNIC_FC_FRAME_FCTL_FIRST_LAST_SEQINIT(_fchdr)	\
+		(_fchdr->fh_f_ctl[0] == FNIC_FC_F_CTL_FIRST_LAST_SEQINIT)
+#define FNIC_FC_FRAME_FC4_SCTL(_fchdr)					\
+		(_fchdr->fh_r_ctl == FNIC_FC_R_CTL_FC4_SCTL)
+#define FNIC_FC_FRAME_TYPE_BLS(_fchdr) (_fchdr->fh_type == FC_TYPE_BLS)
+#define FNIC_FC_FRAME_TYPE_ELS(_fchdr) (_fchdr->fh_type == FC_TYPE_ELS)
+#define FNIC_FC_FRAME_TYPE_FC_GS(_fchdr) (_fchdr->fh_type == FC_TYPE_CT)
+#define FNIC_FC_FRAME_CS_CTL(_fchdr) (_fchdr->fh_cs_ctl == FNIC_FC_CS_CTL)
+
+#define FNIC_FC_C3_RDF         (0xfff)
+#define FNIC_FC_PLOGI_RSP_RDF(_plogi_rsp) \
+	(MIN(_plogi_rsp->u.csp_plogi.b2b_rdf_size, \
+	(_plogi_rsp->spc3[4] & FNIC_FC_C3_RDF)))
+#define FNIC_FC_PLOGI_RSP_CONCUR_SEQ(_plogi_rsp) \
+	(MIN(_plogi_rsp->els.fl_csp.sp_tot_seq, \
+	 (be16_to_cpu(_plogi_rsp->els.fl_cssp[2].cp_con_seq) & 0xff)))
+
+/* Frame header */
+struct fnic_eth_hdr_s {
+	uint8_t		dst_mac[6];
+	uint8_t		src_mac[6];
+	uint16_t	ether_type;
+}  __packed;
+
+struct	fnic_fcoe_hdr_s	{
+	uint8_t		ver;
+	uint8_t		rsvd[12];
+	uint8_t		sof;
+} __packed;
+
+/* FLOGI/PLOGI struct */
+struct fc_std_flogi {
+	struct fc_frame_header fchdr;
+	struct fc_els_flogi els;
+} __packed;
+
+#define FC_ELS_RSP_ACC_SIZE (sizeof(struct fc_frame_header) + \
+		sizeof(struct fc_els_ls_acc))
+#define FC_ELS_RSP_REJ_SIZE (sizeof(struct fc_frame_header) + \
+		sizeof(struct fc_els_ls_rjt))
+
+struct fc_std_els_rsp {
+	struct fc_frame_header fchdr;
+	union	{
+	u8 rsp_cmd;
+	struct fc_els_ls_acc acc;
+	struct fc_els_ls_rjt rej;
+	}	u;
+} __packed;
+
+struct fc_std_els_adisc {
+	struct fc_frame_header fchdr;
+	struct fc_els_adisc els;
+} __packed;
+
+struct fc_std_rls_acc {
+	struct fc_frame_header fchdr;
+	struct fc_els_rls_resp els;
+} __packed;
+
+struct fc_std_abts_ba_acc {
+	struct fc_frame_header fchdr;
+	struct fc_ba_acc acc;
+} __packed;
+
+struct fc_std_abts_ba_rjt {
+	struct fc_frame_header fchdr;
+	struct fc_ba_rjt rjt;
+} __packed;
+
+struct fc_std_els_prli {
+	struct fc_frame_header fchdr;
+	struct fc_els_prli els_prli;
+	struct fc_els_spp sp;
+}	 __packed;
+
+struct fc_std_rpn_id {
+	struct fc_frame_header fchdr;
+	struct fc_ct_hdr fc_std_ct_hdr;
+	struct fc_ns_rn_id rpn_id;
+} __packed;
+
+struct fc_std_fdmi_rhba {
+	struct fc_frame_header fchdr;
+	struct fc_ct_hdr fc_std_ct_hdr;
+	uint64_t	hba_identifier;
+	uint32_t	num_ports;
+	uint64_t	port_name;
+	uint32_t	num_hba_attributes;
+	uint16_t	type_nn;
+	uint16_t	length_nn;
+	uint64_t	node_name;
+	uint16_t	type_manu;
+	uint16_t	length_manu;
+	uint8_t		manufacturer[20];
+	uint16_t	type_serial;
+	uint16_t	length_serial;
+	uint8_t		serial_num[16];
+	uint16_t	type_model;
+	uint16_t	length_model;
+	uint8_t		model[12];
+	uint16_t	type_model_des;
+	uint16_t	length_model_des;
+	uint8_t		model_description[56];
+	uint16_t	type_hw_ver;
+	uint16_t	length_hw_ver;
+	uint8_t		hardware_ver[16];
+	uint16_t	type_dr_ver;
+	uint16_t	length_dr_ver;
+	uint8_t		driver_ver[28];
+	uint16_t	type_rom_ver;
+	uint16_t	length_rom_ver;
+	uint8_t		rom_ver[8];
+	uint16_t	type_fw_ver;
+	uint16_t	length_fw_ver;
+	uint8_t		firmware_ver[16];
+} __packed;
+
+struct fc_std_fdmi_rpa {
+	struct fc_frame_header fchdr;
+	struct fc_ct_hdr fc_std_ct_hdr;
+	uint64_t	port_name;
+	uint32_t	num_port_attributes;
+	uint16_t	type_fc4;
+	uint16_t	length_fc4;
+	uint8_t		fc4_type[32];
+	uint16_t	type_supp_speed;
+	uint16_t	length_supp_speed;
+	uint32_t	supported_speed;
+	uint16_t	type_cur_speed;
+	uint16_t	length_cur_speed;
+	uint32_t	current_speed;
+	uint16_t	type_max_frame_size;
+	uint16_t	length_max_frame_size;
+	uint32_t	max_frame_size;
+	uint16_t	type_os_name;
+	uint16_t	length_os_name;
+	uint8_t		os_name[16];
+	uint16_t	type_host_name;
+	uint16_t	length_host_name;
+	uint8_t host_name[24];
+}	 __packed;
+
+struct fc_std_rft_id {
+	struct fc_frame_header fchdr;
+	struct fc_ct_hdr fc_std_ct_hdr;
+	struct fc_ns_rft_id rft_id;
+} __packed;
+
+struct fc_std_rff_id {
+	struct fc_frame_header fchdr;
+	struct fc_ct_hdr fc_std_ct_hdr;
+	struct fc_ns_rff_id rff_id;
+} __packed;
+
+struct fc_std_gpn_ft {
+	struct fc_frame_header fchdr;
+	struct fc_ct_hdr fc_std_ct_hdr;
+	struct fc_ns_gid_ft gpn_ft;
+} __packed;
+
+/* Accept CT_IU	for	GPN_FT	*/
+struct fc_gpn_ft_rsp_iu {
+	uint8_t		ctrl;
+	uint8_t		fcid[3];
+	uint32_t	rsvd;
+	uint64_t	wwpn;
+} __packed;
+
+struct fc_std_rls {
+	struct fc_frame_header fchdr;
+	struct fc_els_rls els;
+} __packed;
+
+struct fc_std_scr {
+	struct fc_frame_header fchdr;
+	struct fc_els_scr scr;
+} __packed;
+
+struct fc_std_rscn {
+	struct fc_frame_header fchdr;
+	struct fc_els_rscn els;
+} __packed;
+
+struct fc_std_logo {
+	struct fc_frame_header fchdr;
+	struct fc_els_logo els;
+} __packed;
+
+#define	FNIC_FCOE_FCHDR_OFFSET	\
+	(sizeof(struct	fnic_eth_hdr_s)	+	sizeof(struct	fnic_fcoe_hdr_s))
+
+#endif	/*	_FDLS_FC_H	*/
diff --git a/drivers/scsi/fnic/fnic_fdls.h b/drivers/scsi/fnic/fnic_fdls.h
new file mode 100644
index 000000000000..0097ba836ff1
--- /dev/null
+++ b/drivers/scsi/fnic/fnic_fdls.h
@@ -0,0 +1,431 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
+ */
+
+#ifndef _FNIC_FDLS_H_
+#define _FNIC_FDLS_H_
+
+#include "fnic_stats.h"
+#include "fdls_fc.h"
+
+/* FDLS - Fabric discovery and login services
+ * -> VLAN discovery
+ *   -> retry every retry delay seconds until it succeeds.
+ *                        <- List of VLANs
+ *
+ * -> Solicitation
+ *                        <- Solicitation response (Advertisement)
+ *
+ * -> FCF selection & FLOGI ( FLOGI timeout - 2 * E_D_TOV)
+ *                        <- FLOGI response
+ *
+ * -> FCF keep alive
+ *                         <- FCF keep alive
+ *
+ * -> PLOGI to FFFFFC (DNS) (PLOGI timeout - 2 * R_A_TOV)
+ *    -> ABTS if timeout (ABTS tomeout - 2 * R_A_TOV)
+ *                        <- PLOGI response
+ *    -> Retry PLOGI to FFFFFC (DNS) - Number of retries from vnic.cfg
+ *
+ * -> SCR to FFFFFC (DNS) (SCR timeout - 2 * R_A_TOV)
+ *    -> ABTS if timeout (ABTS tomeout - 2 * R_A_TOV)
+ *                        <- SCR response
+ *    -> Retry SCR - Number of retries 2
+ *
+ * -> GPN_FT to FFFFFC (GPN_FT timeout - 2 * R_A_TOV)a
+ *    -> Retry on BUSY until it succeeds
+ *    -> Retry on BUSY until it succeeds
+ *    -> 2 retries on timeout
+ *
+ * -> RFT_ID to FFFFFC (DNS)        (RFT_ID timeout - 3 * R_A_TOV)
+ *    -> ABTS if timeout (ABTS tomeout - 2 * R_A_TOV)
+ *    -> Retry RFT_ID to FFFFFC (DNS) (Number of retries 2 )
+ *    -> Ignore if both retires fail.
+ *
+ *        Session establishment with targets
+ * For each PWWN
+ *   -> PLOGI to FCID of that PWWN (PLOGI timeout 2 * R_A_TOV)
+ *    -> ABTS if timeout (ABTS tomeout - 2 * R_A_TOV)
+ *                        <- PLOGI response
+ *    -> Retry PLOGI. Num retries using vnic.cfg
+ *
+ *   -> PRLI to FCID of that PWWN (PRLI timeout 2 * R_A_TOV)
+ *    -> ABTS if timeout (ABTS tomeout - 2 * R_A_TOV)
+ *                        <- PRLI response
+ *    -> Retry PRLI. Num retries using vnic.cfg
+ *
+ */
+
+#define FDLS_RETRY_COUNT 2
+
+#define FDLS_FABRIC_OXID_POOL_SZ (32)
+#define FDLS_FABRIC_OXID_POOL_BASE (0x1000)
+#define FDLS_FABRIC_OXID_POOL_END (FDLS_FABRIC_OXID_POOL_BASE + FDLS_FABRIC_OXID_POOL_SZ - 1)
+
+#define FDLS_FDMI_OXID_POOL_BASE (FDLS_FABRIC_OXID_POOL_END + 1)
+#define FDLS_FDMI_OXID_POOL_SZ (8)
+#define FDLS_FDMI_OXID_POOL_END (FDLS_FDMI_OXID_POOL_BASE + FDLS_FDMI_OXID_POOL_SZ - 1)
+
+#define FDLS_TGT_OXID_BLOCK_SZ  (0x200)
+#define FDLS_PLOGI_OXID_BASE    (0x2000)
+#define FDLS_PRLI_OXID_BASE     (0x2200)
+#define FDLS_ADISC_OXID_BASE    (0x2400)
+#define FDLS_TGT_OXID_POOL_END  (FDLS_PLOGI_OXID_BASE + FDLS_TGT_OXID_POOL_SZ)
+#define FDLS_TGT_OXID_POOL_SZ   (0x800)
+
+#define FNIC_FDLS_FABRIC_ABORT_ISSUED     0x1
+#define FNIC_FDLS_FPMA_LEARNT             0x2
+
+/* tport flags */
+#define FNIC_FDLS_TPORT_IN_GPN_FT_LIST 0x1
+#define FNIC_FDLS_TGT_ABORT_ISSUED     0x2
+#define FNIC_FDLS_TPORT_SEND_ADISC     0x4
+#define FNIC_FDLS_RETRY_FRAME          0x8
+#define FNIC_FDLS_TPORT_BUSY	       0x10
+#define FNIC_FDLS_TPORT_TERMINATING      0x20
+#define FNIC_FDLS_TPORT_DELETED        0x40
+#define FNIC_FDLS_SCSI_REGISTERED      0x200
+#define FNIC_TPORT_CAN_BE_FREED        0x400
+
+/* Retry supported by rport(returned by prli service parameters) */
+#define FDLS_FC_RP_FLAGS_RETRY 0x1
+
+#define fdls_set_state(_fdls_fabric, _state)  ((_fdls_fabric)->state = _state)
+#define fdls_get_state(_fdls_fabric)          ((_fdls_fabric)->state)
+
+#define FNIC_FDMI_ACTIVE    0x8
+#define FNIC_FIRST_LINK_UP    0x2
+
+#define fdls_set_tport_state(_tport, _state)    (_tport->state = _state)
+#define fdls_get_tport_state(_tport)            (_tport->state)
+
+#define FNIC_PORTSPEED_10GBIT   1
+#define FNIC_FRAME_HT_ROOM     (2148)
+#define FNIC_FCOE_FRAME_MAXSZ   (2112)
+
+struct fnic_fip_fcf_s {
+	uint16_t vlan_id;
+	uint8_t fcf_mac[6];
+	uint8_t fcf_priority;
+	uint32_t fka_adv_period;
+	uint8_t ka_disabled;
+};
+
+enum fnic_fdls_state_e {
+	FDLS_STATE_INIT = 0,
+	FDLS_STATE_LINKDOWN,
+	FDLS_STATE_FABRIC_LOGO,
+	FDLS_STATE_FLOGO_DONE,
+	FDLS_STATE_FABRIC_FLOGI,
+	FDLS_STATE_FABRIC_PLOGI,
+	FDLS_STATE_RPN_ID,
+	FDLS_STATE_REGISTER_FC4_TYPES,
+	FDLS_STATE_REGISTER_FC4_FEATURES,
+	FDLS_STATE_SCR,
+	FDLS_STATE_GPN_FT,
+	FDLS_STATE_TGT_DISCOVERY,
+	FDLS_STATE_RSCN_GPN_FT,
+	FDLS_STATE_SEND_GPNFT
+};
+
+struct fnic_fdls_fabric_s {
+	enum fnic_fdls_state_e state;
+	uint32_t flags;
+	struct list_head tport_list; /* List of discovered tports */
+	struct timer_list retry_timer;
+	int del_timer_inprogress;
+	int del_fdmi_timer_inprogress;
+	int retry_counter;
+	int timer_pending;
+	int fdmi_retry;
+	struct timer_list fdmi_timer;
+	int fdmi_pending;
+};
+
+struct fnic_fdls_fip_s {
+	uint32_t state;
+	uint32_t flogi_retry;
+};
+
+/* Message to tport_event_handler */
+enum fnic_tgt_msg_id {
+	TGT_EV_NONE = 0,
+	TGT_EV_RPORT_ADD,
+	TGT_EV_RPORT_DEL,
+	TGT_EV_TPORT_DELETE,
+	TGT_EV_REMOVE
+};
+
+struct fnic_tport_event_s {
+	struct list_head links;
+	enum fnic_tgt_msg_id event;
+	void *arg1;
+};
+
+enum fdls_tgt_state_e {
+	FDLS_TGT_STATE_INIT = 0,
+	FDLS_TGT_STATE_PLOGI,
+	FDLS_TGT_STATE_PRLI,
+	FDLS_TGT_STATE_READY,
+	FDLS_TGT_STATE_LOGO_RECEIVED,
+	FDLS_TGT_STATE_ADISC,
+	FDL_TGT_STATE_PLOGO,
+	FDLS_TGT_STATE_OFFLINING,
+	FDLS_TGT_STATE_OFFLINE
+};
+
+struct fnic_tport_s {
+	struct list_head links; /* To link the tports */
+	enum fdls_tgt_state_e state;
+	uint32_t flags;
+	uint32_t fcid;
+	uint64_t wwpn;
+	uint64_t wwnn;
+	uint16_t oxid_used;
+	uint16_t tgt_flags;
+	atomic_t in_flight; /* io counter */
+	uint16_t max_payload_size;
+	uint16_t r_a_tov;
+	uint16_t e_d_tov;
+	uint16_t lun0_delay;
+	int max_concur_seqs;
+	uint32_t fcp_csp;
+	struct timer_list retry_timer;
+	int del_timer_inprogress;
+	int retry_counter;
+	int timer_pending;
+	unsigned int num_pending_cmds;
+	int nexus_restart_count;
+	int exch_reset_in_progress;
+	void *iport;
+	struct work_struct tport_del_work;
+	struct completion *tport_del_done;
+	struct delayed_work tport_scan_work;
+	struct fc_rport *rport;
+	char str_wwpn[20];
+	char str_wwnn[20];
+};
+
+/* OXID pool related structures */
+struct reclaim_entry_s {
+	struct list_head links;
+	uint16_t oxid;		/* oxid that needs to be freed after 2*r_a_tov */
+	unsigned long timestamp;	/* in jiffies. Use this to waiting time */
+};
+
+/* this data structure contains all other info about the pool */
+struct fnic_oxid_pool_meta_s {
+	/* Base of the oxid pool before encoding with expected rsp type */
+	uint16_t oxid_base;
+	int sz;			/* size of the pool or block */
+	int next_idx;		/* used for cycling through the oxid pool */
+	struct list_head reclaim_list;	/* list of oxids to be reclaimed later */
+};
+
+/* used for allocating oxids for fabric and fdmi requests */
+struct fnic_fabric_oxid_pool_s {
+	DECLARE_BITMAP(bitmap, FDLS_FABRIC_OXID_POOL_SZ);
+	struct fnic_oxid_pool_meta_s meta;
+
+	/*
+	 * fabric reqs are serialized and only one req at a time.
+	 * Tracking the oxid for sending abort
+	 */
+	uint16_t active_oxid_fabric_req;
+
+	/* fdmi only */
+	uint16_t active_oxid_fdmi_plogi;
+	uint16_t active_oxid_fdmi_rhba;
+	uint16_t active_oxid_fdmi_rpa;
+};
+
+/* used for allocating oxids for target requests */
+struct fnic_tgt_oxid_pool_s {
+	DECLARE_BITMAP(bitmap, FDLS_TGT_OXID_BLOCK_SZ);
+	struct fnic_oxid_pool_meta_s meta;	/* contains all other info */
+};
+
+/* iport */
+enum fnic_iport_state_e {
+	FNIC_IPORT_STATE_INIT = 0,
+	FNIC_IPORT_STATE_LINK_WAIT,
+	FNIC_IPORT_STATE_FIP,
+	FNIC_IPORT_STATE_FABRIC_DISC,
+	FNIC_IPORT_STATE_READY
+};
+
+struct fnic_iport_s {
+	enum fnic_iport_state_e state;
+	struct fnic *fnic;
+	uint64_t boot_time;
+	uint32_t flags;
+	int usefip;
+	uint8_t hwmac[6]; /* HW MAC Addr */
+	uint8_t fpma[6]; /* Fabric Provided MA */
+	uint8_t fcfmac[6]; /* MAC addr of Fabric */
+	uint16_t vlan_id;
+	uint32_t fcid;
+
+	/* oxid pool for fabric reqs */
+	struct fnic_fabric_oxid_pool_s fabric_oxid_pool;
+	/* oxid pool for fdmi */
+	struct fnic_fabric_oxid_pool_s fdmi_oxid_pool;
+	/* oxid pool for target plogi */
+	struct fnic_tgt_oxid_pool_s plogi_oxid_pool;
+	/* oxid pool for target prli */
+	struct fnic_tgt_oxid_pool_s prli_oxid_pool;
+	/* oxid pool for target adisc */
+	struct fnic_tgt_oxid_pool_s adisc_oxid_pool;
+
+	struct fnic_fip_fcf_s selected_fcf;
+	struct fnic_fdls_fip_s fip;
+	struct fnic_fdls_fabric_s fabric;
+	struct list_head tport_list;
+	struct list_head tport_list_pending_del;
+	/* list of tports for which we are yet to send PLOGO */
+	struct list_head inprocess_tport_list;
+	struct list_head deleted_tport_list;
+	struct work_struct tport_event_work;
+	uint32_t e_d_tov; /* msec */
+	uint32_t r_a_tov; /* msec */
+	uint32_t link_supported_speeds;
+	uint32_t max_flogi_retries;
+	uint32_t max_plogi_retries;
+	uint32_t plogi_timeout;
+	uint32_t service_params;
+	uint64_t wwpn;
+	uint64_t wwnn;
+	uint16_t max_payload_size;
+	spinlock_t deleted_tport_lst_lock;
+	struct completion *flogi_reg_done;
+	char str_wwpn[20];
+	char str_wwnn[20];
+	};
+	struct rport_dd_data_s {
+	struct fnic_tport_s *tport;
+	struct fnic_iport_s *iport;
+};
+
+enum fnic_recv_frame_type_e {
+	FNIC_FABRIC_FLOGI_RSP = 1,
+	FNIC_FABRIC_PLOGI_RSP,
+	FNIC_FABRIC_RPN_RSP,
+	FNIC_FABRIC_RFT_RSP,
+	FNIC_FABRIC_RFF_RSP,
+	FNIC_FABRIC_SCR_RSP,
+	FNIC_FABRIC_GPN_FT_RSP,
+	FNIC_FDMI_PLOGI_RSP,
+	FNIC_FDMI_REG_HBA_RSP,
+	FNIC_FDMI_RPA_RSP,
+	FNIC_TPORT_PLOGI_RSP,
+	FNIC_TPORT_PRLI_RSP,
+	FNIC_TPORT_ADISC_RSP,
+	FNIC_TPORT_LOGO_RSP,
+	FNIC_BLS_ABTS_REQ,
+	FNIC_FABRIC_LOGO_RSP,
+	FNIC_BLS_ABTS_RSP,
+	FNIC_ELS_PLOGI_REQ,
+	FNIC_ELS_RSCN_REQ,
+	FNIC_ELS_LOGO_REQ,
+	FNIC_ELS_ECHO_REQ,
+	FNIC_ELS_ADISC,
+	FNIC_ELS_RLS,
+	FNIC_ELS_RRQ,
+	FNIC_ELS_UNSUPPORTED_REQ,
+};
+
+enum fnic_port_speeds {
+	DCEM_PORTSPEED_NONE = 0,
+	DCEM_PORTSPEED_1G = 1000,
+	DCEM_PORTSPEED_2G = 2000,
+	DCEM_PORTSPEED_4G = 4000,
+	DCEM_PORTSPEED_8G = 8000,
+	DCEM_PORTSPEED_10G = 10000,
+	DCEM_PORTSPEED_16G = 16000,
+	DCEM_PORTSPEED_20G = 20000,
+	DCEM_PORTSPEED_25G = 25000,
+	DCEM_PORTSPEED_32G = 32000,
+	DCEM_PORTSPEED_40G = 40000,
+	DCEM_PORTSPEED_4x10G = 41000,
+	DCEM_PORTSPEED_50G = 50000,
+	DCEM_PORTSPEED_64G = 64000,
+	DCEM_PORTSPEED_100G = 100000,
+	DCEM_PORTSPEED_128G = 128000,
+};
+
+/* Function Declarations */
+/* fdls_disc.c */
+void fnic_fdls_disc_init(struct fnic_iport_s *iport);
+void fnic_fdls_disc_start(struct fnic_iport_s *iport);
+void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
+			  int len, int fchdr_offset);
+void fnic_fdls_link_down(struct fnic_iport_s *iport);
+void fdls_init_tgt_oxid_pool(struct fnic_iport_s *iport);
+void fdls_init_oxid_pool(struct fnic_iport_s *iport);
+uint16_t fdls_alloc_oxid(struct fnic_iport_s *iport,
+	struct fnic_oxid_pool_meta_s *meta, unsigned long *bitmap);
+uint16_t fdls_alloc_fabric_oxid(struct fnic_iport_s *iport,
+	struct fnic_fabric_oxid_pool_s *oxid_pool, int exp_rsp_type);
+int fnic_fdls_expected_rsp(struct fnic_iport_s *iport, uint16_t oxid);
+void fdls_free_fabric_oxid(struct fnic_iport_s *iport,
+					struct fnic_fabric_oxid_pool_s *oxid_pool,
+					uint16_t oxid);
+void fdls_free_oxid(struct fnic_iport_s *iport,
+					struct fnic_oxid_pool_meta_s *meta,
+					unsigned long *bitmap, uint16_t oxid);
+void fdls_tgt_logout(struct fnic_iport_s *iport,
+		     struct fnic_tport_s *tport);
+inline void fnic_del_fabric_timer_sync(struct fnic *fnic);
+inline void fnic_del_tport_timer_sync(struct fnic *fnic,
+							struct fnic_tport_s *tport);
+void fdls_send_fabric_logo(struct fnic_iport_s *iport);
+int fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
+					  void *rx_frame, int len,
+					  int fchdr_offset);
+void fdls_send_tport_abts(struct fnic_iport_s *iport,
+			  struct fnic_tport_s *tport);
+bool fdls_delete_tport(struct fnic_iport_s *iport,
+		       struct fnic_tport_s *tport);
+void fdls_fdmi_timer_callback(struct timer_list *t);
+
+/* fnic_fcs.c */
+void fnic_fdls_init(struct fnic *fnic, int usefip);
+void fnic_send_fcoe_frame(struct fnic_iport_s *iport, void *payload,
+	int payload_sz);
+void fnic_fcoe_send_vlan_req(struct fnic *fnic);
+int fnic_send_fip_frame(struct fnic_iport_s *iport,
+	void *payload, int payload_sz);
+void fnic_fdls_learn_fcoe_macs(struct fnic_iport_s *iport, void *rx_frame,
+	uint8_t *fcid);
+
+void fnic_fdls_add_tport(struct fnic_iport_s *iport,
+		struct fnic_tport_s *tport, unsigned long flags);
+void fnic_fdls_remove_tport(struct fnic_iport_s *iport,
+			    struct fnic_tport_s *tport,
+			    unsigned long flags);
+
+/* fip.c */
+void fnic_fcoe_send_vlan_req(struct fnic *fnic);
+void fnic_common_fip_cleanup(struct fnic *fnic);
+int fdls_fip_recv_frame(struct fnic *fnic, void *frame);
+void fnic_handle_fcs_ka_timer(struct timer_list *t);
+void fnic_handle_enode_ka_timer(struct timer_list *t);
+void fnic_handle_vn_ka_timer(struct timer_list *t);
+void fnic_handle_fip_timer(struct timer_list *t);
+extern void fdls_fabric_timer_callback(struct timer_list *t);
+
+/* fnic_scsi.c */
+void fnic_scsi_fcpio_reset(struct fnic *fnic);
+extern void fdls_fabric_timer_callback(struct timer_list *t);
+void fnic_rport_exch_reset(struct fnic *fnic, u32 fcid);
+int fnic_fdls_register_portid(struct fnic_iport_s *iport, u32 port_id,
+		void *fp);
+struct fnic_tport_s *fnic_find_tport_by_fcid(struct fnic_iport_s *iport,
+		uint32_t fcid);
+struct fnic_tport_s *fnic_find_tport_by_wwpn(struct fnic_iport_s *iport,
+		uint64_t  wwpn);
+
+#endif /* _FNIC_FDLS_H_ */
+
-- 
2.31.1

