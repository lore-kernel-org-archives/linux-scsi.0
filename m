Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5D5C43381
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 17:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B5A820DD4
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 17:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbhACRMi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Jan 2021 12:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbhACRMg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2021 12:12:36 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F426C0613D3
        for <linux-scsi@vger.kernel.org>; Sun,  3 Jan 2021 09:11:56 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id c79so14914572pfc.2
        for <linux-scsi@vger.kernel.org>; Sun, 03 Jan 2021 09:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dHUUv0Mxo2kIjYplfgFpjs4Hmp6LCWgLJU3rHWXoIJ0=;
        b=kSVvx5b0agrINuwMMrkd77GOWzSThutsLVfW0k6uUkCbbrdTdqPA3q1JdCnSlvj1dP
         fEVwd6Egisgh1nmN0aWYWpXaI5k5aCMNstJUgX2c3qaMvhyEnU09S5bPy8BOXVubWCa0
         ML4TXeI8Vu1H5SzMnwKJusIj+0DkogZkhW8UP2oidkUk9JBbd2CIgq1lq4UmUgKnVrHn
         OCV1IP+Um5lZKDFaU6RLFg6hb2y4sJ1YYT8nfJERJh/2hugqBKdawQIMx/FuoU2We9WF
         I5oGe9CBmqQEsMVsdDS5gUuz5BY4WKBrUZfPWCgE2JZf5Vss648DRhEKOZg9cQj1+K8q
         fmRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dHUUv0Mxo2kIjYplfgFpjs4Hmp6LCWgLJU3rHWXoIJ0=;
        b=gYFffQ06gbe+TVKfuyitbNKAV4zJ+2lNWchOfHiWa9Aj0cAdNsH7gWLsmO04N7DSli
         TIP+Ye33sts1aW8AxXuQiHSgi57if99IcaZSQwZKZ5WVr2yL2kZ+mTcuf2sRansneeOs
         uA6U4JKtoQ7UZL6FQylrfCALKTbRS5nikyURt72GxLrhBsfp38/+kRNERBUUfctU0JOf
         YXihDTemnO2Q7O2XRpDpfqKF5+7kDhJK83JfeK9o66XvqojQgCMPPBoeGGesrKISwGGd
         oc2Y8zlyGbPZ1Vz/JG6P1YfPiR2LngKY97DJHdeQa63Z7YvCRdqTlG9OlfI29iFjTzLF
         RPVg==
X-Gm-Message-State: AOAM531UxyVkhcn5IHQTYJqwntLLwqFSQ+/btJBWlnt7IdZ2Gd+7R8D8
        Rwy2kWlOE1tNZsOBDAHdLlzVREjTWEs=
X-Google-Smtp-Source: ABdhPJzSXhxBX1+JgJFyzAF0/ce0qm7zDMYx6Pp0JJRIuOD5iZ8YkGPQqv++ZrMYCZhwF+CrDndTjg==
X-Received: by 2002:a63:e049:: with SMTP id n9mr67868574pgj.339.1609693915242;
        Sun, 03 Jan 2021 09:11:55 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m4sm33145151pgv.16.2021.01.03.09.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 09:11:54 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v5 03/31] elx: libefc_sli: Data structures and defines for mbox commands
Date:   Sun,  3 Jan 2021 09:11:06 -0800
Message-Id: <20210103171134.39878-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103171134.39878-1-jsmart2021@gmail.com>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the libefc_sli SLI-4 library population.

This patch adds definitions for SLI-4 mailbox commands
and responses.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v5:
 Common naming for topology defines.
---
 drivers/scsi/elx/libefc_sli/sli4.h | 1628 +++++++++++++++++++++++++++-
 1 file changed, 1627 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/libefc_sli/sli4.h b/drivers/scsi/elx/libefc_sli/sli4.h
index d194b566b588..39b6fceed85e 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.h
+++ b/drivers/scsi/elx/libefc_sli/sli4.h
@@ -1990,6 +1990,1520 @@ enum sli4_els_cmd_type {
 	SLI4_ELS_REQUEST64_CMD_FABRIC		= 0x0d,
 };
 
+#define SLI_PAGE_SIZE				SZ_4K
+
+#define SLI4_BMBX_TIMEOUT_MSEC			30000
+#define SLI4_FW_READY_TIMEOUT_MSEC		30000
+
+#define SLI4_BMBX_DELAY_US			1000	/* 1 ms */
+#define SLI4_INIT_PORT_DELAY_US			10000	/* 10 ms */
+
+static inline u32
+sli_page_count(size_t bytes, u32 page_size)
+{
+	if (!page_size)
+		return 0;
+
+	return (bytes + (page_size - 1)) >> __ffs(page_size);
+}
+
+/*************************************************************************
+ * SLI-4 mailbox command formats and definitions
+ */
+
+struct sli4_mbox_command_header {
+	u8	resvd0;
+	u8	command;
+	__le16	status;	/* Port writes to indicate success/fail */
+};
+
+enum sli4_mbx_cmd_value {
+	SLI4_MBX_CMD_CONFIG_LINK	= 0x07,
+	SLI4_MBX_CMD_DUMP		= 0x17,
+	SLI4_MBX_CMD_DOWN_LINK		= 0x06,
+	SLI4_MBX_CMD_INIT_LINK		= 0x05,
+	SLI4_MBX_CMD_INIT_VFI		= 0xa3,
+	SLI4_MBX_CMD_INIT_VPI		= 0xa4,
+	SLI4_MBX_CMD_POST_XRI		= 0xa7,
+	SLI4_MBX_CMD_RELEASE_XRI	= 0xac,
+	SLI4_MBX_CMD_READ_CONFIG	= 0x0b,
+	SLI4_MBX_CMD_READ_STATUS	= 0x0e,
+	SLI4_MBX_CMD_READ_NVPARMS	= 0x02,
+	SLI4_MBX_CMD_READ_REV		= 0x11,
+	SLI4_MBX_CMD_READ_LNK_STAT	= 0x12,
+	SLI4_MBX_CMD_READ_SPARM64	= 0x8d,
+	SLI4_MBX_CMD_READ_TOPOLOGY	= 0x95,
+	SLI4_MBX_CMD_REG_FCFI		= 0xa0,
+	SLI4_MBX_CMD_REG_FCFI_MRQ	= 0xaf,
+	SLI4_MBX_CMD_REG_RPI		= 0x93,
+	SLI4_MBX_CMD_REG_RX_RQ		= 0xa6,
+	SLI4_MBX_CMD_REG_VFI		= 0x9f,
+	SLI4_MBX_CMD_REG_VPI		= 0x96,
+	SLI4_MBX_CMD_RQST_FEATURES	= 0x9d,
+	SLI4_MBX_CMD_SLI_CONFIG		= 0x9b,
+	SLI4_MBX_CMD_UNREG_FCFI		= 0xa2,
+	SLI4_MBX_CMD_UNREG_RPI		= 0x14,
+	SLI4_MBX_CMD_UNREG_VFI		= 0xa1,
+	SLI4_MBX_CMD_UNREG_VPI		= 0x97,
+	SLI4_MBX_CMD_WRITE_NVPARMS	= 0x03,
+	SLI4_MBX_CMD_CFG_AUTO_XFER_RDY	= 0xad,
+};
+
+enum sli4_mbx_status {
+	SLI4_MBX_STATUS_SUCCESS		= 0x0000,
+	SLI4_MBX_STATUS_FAILURE		= 0x0001,
+	SLI4_MBX_STATUS_RPI_NOT_REG	= 0x1400,
+};
+
+/* CONFIG_LINK - configure link-oriented parameters,
+ * such as default N_Port_ID address and various timers
+ */
+enum sli4_cmd_config_link_flags {
+	SLI4_CFG_LINK_BBSCN = 0xf00,
+	SLI4_CFG_LINK_CSCN  = 0x1000,
+};
+
+struct sli4_cmd_config_link {
+	struct sli4_mbox_command_header	hdr;
+	u8		maxbbc;
+	u8		rsvd5;
+	u8		rsvd6;
+	u8		rsvd7;
+	u8		alpa;
+	__le16		n_port_id;
+	u8		rsvd11;
+	__le32		rsvd12;
+	__le32		e_d_tov;
+	__le32		lp_tov;
+	__le32		r_a_tov;
+	__le32		r_t_tov;
+	__le32		al_tov;
+	__le32		rsvd36;
+	__le32		bbscn_dword;
+};
+
+#define SLI4_DUMP4_TYPE		0xf
+
+#define SLI4_WKI_TAG_SAT_TEM	0x1040
+
+struct sli4_cmd_dump4 {
+	struct sli4_mbox_command_header	hdr;
+	__le32		type_dword;
+	__le16		wki_selection;
+	__le16		rsvd10;
+	__le32		rsvd12;
+	__le32		returned_byte_cnt;
+	__le32		resp_data[59];
+};
+
+/* INIT_LINK - initialize the link for a FC port */
+enum sli4_init_link_flags {
+	SLI4_INIT_LINK_F_LOOPBACK	= 1 << 0,
+
+	SLI4_INIT_LINK_F_P2P_ONLY	= 1 << 1,
+	SLI4_INIT_LINK_F_FCAL_ONLY	= 2 << 1,
+	SLI4_INIT_LINK_F_FCAL_FAIL_OVER	= 0 << 1,
+	SLI4_INIT_LINK_F_P2P_FAIL_OVER	= 1 << 1,
+
+	SLI4_INIT_LINK_F_UNFAIR		= 1 << 6,
+	SLI4_INIT_LINK_F_NO_LIRP	= 1 << 7,
+	SLI4_INIT_LINK_F_LOOP_VALID_CHK	= 1 << 8,
+	SLI4_INIT_LINK_F_NO_LISA	= 1 << 9,
+	SLI4_INIT_LINK_F_FAIL_OVER	= 1 << 10,
+	SLI4_INIT_LINK_F_FIXED_SPEED	= 1 << 11,
+	SLI4_INIT_LINK_F_PICK_HI_ALPA	= 1 << 15,
+
+};
+
+enum sli4_fc_link_speed {
+	SLI4_LINK_SPEED_1G = 1,
+	SLI4_LINK_SPEED_2G,
+	SLI4_LINK_SPEED_AUTO_1_2,
+	SLI4_LINK_SPEED_4G,
+	SLI4_LINK_SPEED_AUTO_4_1,
+	SLI4_LINK_SPEED_AUTO_4_2,
+	SLI4_LINK_SPEED_AUTO_4_2_1,
+	SLI4_LINK_SPEED_8G,
+	SLI4_LINK_SPEED_AUTO_8_1,
+	SLI4_LINK_SPEED_AUTO_8_2,
+	SLI4_LINK_SPEED_AUTO_8_2_1,
+	SLI4_LINK_SPEED_AUTO_8_4,
+	SLI4_LINK_SPEED_AUTO_8_4_1,
+	SLI4_LINK_SPEED_AUTO_8_4_2,
+	SLI4_LINK_SPEED_10G,
+	SLI4_LINK_SPEED_16G,
+	SLI4_LINK_SPEED_AUTO_16_8_4,
+	SLI4_LINK_SPEED_AUTO_16_8,
+	SLI4_LINK_SPEED_32G,
+	SLI4_LINK_SPEED_AUTO_32_16_8,
+	SLI4_LINK_SPEED_AUTO_32_16,
+	SLI4_LINK_SPEED_64G,
+	SLI4_LINK_SPEED_AUTO_64_32_16,
+	SLI4_LINK_SPEED_AUTO_64_32,
+	SLI4_LINK_SPEED_128G,
+	SLI4_LINK_SPEED_AUTO_128_64_32,
+	SLI4_LINK_SPEED_AUTO_128_64,
+};
+
+struct sli4_cmd_init_link {
+	struct sli4_mbox_command_header       hdr;
+	__le32	sel_reset_al_pa_dword;
+	__le32	flags0;
+	__le32	link_speed_sel_code;
+};
+
+/* INIT_VFI - initialize the VFI resource */
+enum sli4_init_vfi_flags {
+	SLI4_INIT_VFI_FLAG_VP	= 0x1000,
+	SLI4_INIT_VFI_FLAG_VF	= 0x2000,
+	SLI4_INIT_VFI_FLAG_VT	= 0x4000,
+	SLI4_INIT_VFI_FLAG_VR	= 0x8000,
+
+	SLI4_INIT_VFI_VFID	= 0x1fff,
+	SLI4_INIT_VFI_PRI	= 0xe000,
+
+	SLI4_INIT_VFI_HOP_COUNT = 0xff000000,
+};
+
+struct sli4_cmd_init_vfi {
+	struct sli4_mbox_command_header	hdr;
+	__le16		vfi;
+	__le16		flags0_word;
+	__le16		fcfi;
+	__le16		vpi;
+	__le32		vf_id_pri_dword;
+	__le32		hop_cnt_dword;
+};
+
+/* INIT_VPI - initialize the VPI resource */
+struct sli4_cmd_init_vpi {
+	struct sli4_mbox_command_header	hdr;
+	__le16		vpi;
+	__le16		vfi;
+};
+
+/* POST_XRI - post XRI resources to the SLI Port */
+enum sli4_post_xri_flags {
+	SLI4_POST_XRI_COUNT	= 0xfff,
+	SLI4_POST_XRI_FLAG_ENX	= 0x1000,
+	SLI4_POST_XRI_FLAG_DL	= 0x2000,
+	SLI4_POST_XRI_FLAG_DI	= 0x4000,
+	SLI4_POST_XRI_FLAG_VAL	= 0x8000,
+};
+
+struct sli4_cmd_post_xri {
+	struct sli4_mbox_command_header	hdr;
+	__le16		xri_base;
+	__le16		xri_count_flags;
+};
+
+/* RELEASE_XRI - Release XRI resources from the SLI Port */
+enum sli4_release_xri_flags {
+	SLI4_RELEASE_XRI_REL_XRI_CNT	= 0x1f,
+	SLI4_RELEASE_XRI_COUNT		= 0x1f,
+};
+
+struct sli4_cmd_release_xri {
+	struct sli4_mbox_command_header	hdr;
+	__le16		rel_xri_count_word;
+	__le16		xri_count_word;
+
+	struct {
+		__le16	xri_tag0;
+		__le16	xri_tag1;
+	} xri_tbl[62];
+};
+
+/* READ_CONFIG - read SLI port configuration parameters */
+struct sli4_cmd_read_config {
+	struct sli4_mbox_command_header	hdr;
+};
+
+enum sli4_read_cfg_resp_flags {
+	SLI4_READ_CFG_RESP_RESOURCE_EXT = 0x80000000,	/* DW1 */
+	SLI4_READ_CFG_RESP_TOPOLOGY	= 0xff000000,	/* DW2 */
+};
+
+enum sli4_read_cfg_topo {
+	SLI4_READ_CFG_TOPO_FC		= 0x1,	/* FC topology unknown */
+	SLI4_READ_CFG_TOPO_NON_FC_AL	= 0x2,	/* FC point-to-point or fabric */
+	SLI4_READ_CFG_TOPO_FC_AL	= 0x3,	/* FC-AL topology */
+};
+
+struct sli4_rsp_read_config {
+	struct sli4_mbox_command_header	hdr;
+	__le32		ext_dword;
+	__le32		topology_dword;
+	__le32		resvd8;
+	__le16		e_d_tov;
+	__le16		resvd14;
+	__le32		resvd16;
+	__le16		r_a_tov;
+	__le16		resvd22;
+	__le32		resvd24;
+	__le32		resvd28;
+	__le16		lmt;
+	__le16		resvd34;
+	__le32		resvd36;
+	__le32		resvd40;
+	__le16		xri_base;
+	__le16		xri_count;
+	__le16		rpi_base;
+	__le16		rpi_count;
+	__le16		vpi_base;
+	__le16		vpi_count;
+	__le16		vfi_base;
+	__le16		vfi_count;
+	__le16		resvd60;
+	__le16		fcfi_count;
+	__le16		rq_count;
+	__le16		eq_count;
+	__le16		wq_count;
+	__le16		cq_count;
+	__le32		pad[45];
+};
+
+/* READ_NVPARMS - read SLI port configuration parameters */
+enum sli4_read_nvparms_flags {
+	SLI4_READ_NVPARAMS_HARD_ALPA	  = 0xff,
+	SLI4_READ_NVPARAMS_PREFERRED_D_ID = 0xffffff00,
+};
+
+struct sli4_cmd_read_nvparms {
+	struct sli4_mbox_command_header	hdr;
+	__le32		resvd0;
+	__le32		resvd4;
+	__le32		resvd8;
+	__le32		resvd12;
+	u8		wwpn[8];
+	u8		wwnn[8];
+	__le32		hard_alpa_d_id;
+};
+
+/* WRITE_NVPARMS - write SLI port configuration parameters */
+struct sli4_cmd_write_nvparms {
+	struct sli4_mbox_command_header	hdr;
+	__le32		resvd0;
+	__le32		resvd4;
+	__le32		resvd8;
+	__le32		resvd12;
+	u8		wwpn[8];
+	u8		wwnn[8];
+	__le32		hard_alpa_d_id;
+};
+
+/* READ_REV - read the Port revision levels */
+enum {
+	SLI4_READ_REV_FLAG_SLI_LEVEL	= 0xf,
+	SLI4_READ_REV_FLAG_FCOEM	= 0x10,
+	SLI4_READ_REV_FLAG_CEEV		= 0x60,
+	SLI4_READ_REV_FLAG_VPD		= 0x2000,
+
+	SLI4_READ_REV_AVAILABLE_LENGTH	= 0xffffff,
+};
+
+struct sli4_cmd_read_rev {
+	struct sli4_mbox_command_header	hdr;
+	__le16			resvd0;
+	__le16			flags0_word;
+	__le32			first_hw_rev;
+	__le32			second_hw_rev;
+	__le32			resvd12;
+	__le32			third_hw_rev;
+	u8			fc_ph_low;
+	u8			fc_ph_high;
+	u8			feature_level_low;
+	u8			feature_level_high;
+	__le32			resvd24;
+	__le32			first_fw_id;
+	u8			first_fw_name[16];
+	__le32			second_fw_id;
+	u8			second_fw_name[16];
+	__le32			rsvd18[30];
+	__le32			available_length_dword;
+	struct sli4_dmaaddr	hostbuf;
+	__le32			returned_vpd_length;
+	__le32			actual_vpd_length;
+};
+
+/* READ_SPARM64 - read the Port service parameters */
+#define SLI4_READ_SPARM64_WWPN_OFFSET	(4 * sizeof(u32))
+#define SLI4_READ_SPARM64_WWNN_OFFSET	(6 * sizeof(u32))
+
+struct sli4_cmd_read_sparm64 {
+	struct sli4_mbox_command_header hdr;
+	__le32			resvd0;
+	__le32			resvd4;
+	struct sli4_bde		bde_64;
+	__le16			vpi;
+	__le16			resvd22;
+	__le16			port_name_start;
+	__le16			port_name_len;
+	__le16			node_name_start;
+	__le16			node_name_len;
+};
+
+/* READ_TOPOLOGY - read the link event information */
+enum sli4_read_topo_e {
+	SLI4_READTOPO_ATTEN_TYPE	= 0xff,
+	SLI4_READTOPO_FLAG_IL		= 0x100,
+	SLI4_READTOPO_FLAG_PB_RECVD	= 0x200,
+
+	SLI4_READTOPO_LINKSTATE_RECV	= 0x3,
+	SLI4_READTOPO_LINKSTATE_TRANS	= 0xc,
+	SLI4_READTOPO_LINKSTATE_MACHINE	= 0xf0,
+	SLI4_READTOPO_LINKSTATE_SPEED	= 0xff00,
+	SLI4_READTOPO_LINKSTATE_TF	= 0x40000000,
+	SLI4_READTOPO_LINKSTATE_LU	= 0x80000000,
+
+	SLI4_READTOPO_SCN_BBSCN		= 0xf,
+	SLI4_READTOPO_SCN_CBBSCN	= 0xf0,
+
+	SLI4_READTOPO_R_T_TOV		= 0x1ff,
+	SLI4_READTOPO_AL_TOV		= 0xf000,
+
+	SLI4_READTOPO_PB_FLAG		= 0x80,
+
+	SLI4_READTOPO_INIT_N_PORTID	= 0xffffff,
+};
+
+#define SLI4_MIN_LOOP_MAP_BYTES	128
+
+struct sli4_cmd_read_topology {
+	struct sli4_mbox_command_header	hdr;
+	__le32			event_tag;
+	__le32			dw2_attentype;
+	u8			topology;
+	u8			lip_type;
+	u8			lip_al_ps;
+	u8			al_pa_granted;
+	struct sli4_bde		bde_loop_map;
+	__le32			linkdown_state;
+	__le32			currlink_state;
+	u8			max_bbc;
+	u8			init_bbc;
+	u8			scn_flags;
+	u8			rsvd39;
+	__le16			dw10w0_al_rt_tov;
+	__le16			lp_tov;
+	u8			acquired_al_pa;
+	u8			pb_flags;
+	__le16			specified_al_pa;
+	__le32			dw12_init_n_port_id;
+};
+
+enum sli4_read_topo_link {
+	SLI4_READ_TOPOLOGY_LINK_UP	= 0x1,
+	SLI4_READ_TOPOLOGY_LINK_DOWN,
+	SLI4_READ_TOPOLOGY_LINK_NO_ALPA,
+};
+
+enum sli4_read_topo {
+	SLI4_READ_TOPO_UNKNOWN		= 0x0,
+	SLI4_READ_TOPO_NON_FC_AL,
+	SLI4_READ_TOPO_FC_AL,
+};
+
+enum sli4_read_topo_speed {
+	SLI4_READ_TOPOLOGY_SPEED_NONE	= 0x00,
+	SLI4_READ_TOPOLOGY_SPEED_1G	= 0x04,
+	SLI4_READ_TOPOLOGY_SPEED_2G	= 0x08,
+	SLI4_READ_TOPOLOGY_SPEED_4G	= 0x10,
+	SLI4_READ_TOPOLOGY_SPEED_8G	= 0x20,
+	SLI4_READ_TOPOLOGY_SPEED_10G	= 0x40,
+	SLI4_READ_TOPOLOGY_SPEED_16G	= 0x80,
+	SLI4_READ_TOPOLOGY_SPEED_32G	= 0x90,
+	SLI4_READ_TOPOLOGY_SPEED_64G	= 0xa0,
+	SLI4_READ_TOPOLOGY_SPEED_128G	= 0xb0,
+};
+
+/* REG_FCFI - activate a FC Forwarder */
+struct sli4_cmd_reg_fcfi_rq_cfg {
+	u8	r_ctl_mask;
+	u8	r_ctl_match;
+	u8	type_mask;
+	u8	type_match;
+};
+
+enum sli4_regfcfi_tag {
+	SLI4_REGFCFI_VLAN_TAG		= 0xfff,
+	SLI4_REGFCFI_VLANTAG_VALID	= 0x1000,
+};
+
+#define SLI4_CMD_REG_FCFI_NUM_RQ_CFG	4
+struct sli4_cmd_reg_fcfi {
+	struct sli4_mbox_command_header	hdr;
+	__le16		fcf_index;
+	__le16		fcfi;
+	__le16		rqid1;
+	__le16		rqid0;
+	__le16		rqid3;
+	__le16		rqid2;
+	struct sli4_cmd_reg_fcfi_rq_cfg
+			rq_cfg[SLI4_CMD_REG_FCFI_NUM_RQ_CFG];
+	__le32		dw8_vlan;
+};
+
+#define SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG	4
+#define SLI4_CMD_REG_FCFI_MRQ_MAX_NUM_RQ	32
+#define SLI4_CMD_REG_FCFI_SET_FCFI_MODE		0
+#define SLI4_CMD_REG_FCFI_SET_MRQ_MODE		1
+
+enum sli4_reg_fcfi_mrq {
+	SLI4_REGFCFI_MRQ_VLAN_TAG	= 0xfff,
+	SLI4_REGFCFI_MRQ_VLANTAG_VALID	= 0x1000,
+	SLI4_REGFCFI_MRQ_MODE		= 0x2000,
+
+	SLI4_REGFCFI_MRQ_MASK_NUM_PAIRS	= 0xff,
+	SLI4_REGFCFI_MRQ_FILTER_BITMASK = 0xf00,
+	SLI4_REGFCFI_MRQ_RQ_SEL_POLICY	= 0xf000,
+};
+
+struct sli4_cmd_reg_fcfi_mrq {
+	struct sli4_mbox_command_header	hdr;
+	__le16		fcf_index;
+	__le16		fcfi;
+	__le16		rqid1;
+	__le16		rqid0;
+	__le16		rqid3;
+	__le16		rqid2;
+	struct sli4_cmd_reg_fcfi_rq_cfg
+			rq_cfg[SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG];
+	__le32		dw8_vlan;
+	__le32		dw9_mrqflags;
+};
+
+struct sli4_cmd_rq_cfg {
+	__le16	rq_id;
+	u8	r_ctl_mask;
+	u8	r_ctl_match;
+	u8	type_mask;
+	u8	type_match;
+};
+
+/* REG_RPI - register a Remote Port Indicator */
+enum sli4_reg_rpi {
+	SLI4_REGRPI_REMOTE_N_PORTID	= 0xffffff,	/* DW2 */
+	SLI4_REGRPI_UPD			= 0x1000000,
+	SLI4_REGRPI_ETOW		= 0x8000000,
+	SLI4_REGRPI_TERP		= 0x20000000,
+	SLI4_REGRPI_CI			= 0x80000000,
+};
+
+struct sli4_cmd_reg_rpi {
+	struct sli4_mbox_command_header	hdr;
+	__le16			rpi;
+	__le16			rsvd2;
+	__le32			dw2_rportid_flags;
+	struct sli4_bde		bde_64;
+	__le16			vpi;
+	__le16			rsvd26;
+};
+
+#define SLI4_REG_RPI_BUF_LEN		0x70
+
+/* REG_VFI - register a Virtual Fabric Indicator */
+enum sli_reg_vfi {
+	SLI4_REGVFI_VP			= 0x1000,	/* DW1 */
+	SLI4_REGVFI_UPD			= 0x2000,
+
+	SLI4_REGVFI_LOCAL_N_PORTID	= 0xffffff,	/* DW10 */
+};
+
+struct sli4_cmd_reg_vfi {
+	struct sli4_mbox_command_header	hdr;
+	__le16			vfi;
+	__le16			dw0w1_flags;
+	__le16			fcfi;
+	__le16			vpi;
+	u8			wwpn[8];
+	struct sli4_bde		sparm;
+	__le32			e_d_tov;
+	__le32			r_a_tov;
+	__le32			dw10_lportid_flags;
+};
+
+/* REG_VPI - register a Virtual Port Indicator */
+enum sli4_reg_vpi {
+	SLI4_REGVPI_LOCAL_N_PORTID	= 0xffffff,
+	SLI4_REGVPI_UPD			= 0x1000000,
+};
+
+struct sli4_cmd_reg_vpi {
+	struct sli4_mbox_command_header	hdr;
+	__le32		rsvd0;
+	__le32		dw2_lportid_flags;
+	u8		wwpn[8];
+	__le32		rsvd12;
+	__le16		vpi;
+	__le16		vfi;
+};
+
+/* REQUEST_FEATURES - request / query SLI features */
+enum sli4_req_features_flags {
+	SLI4_REQFEAT_QRY	= 0x1,		/* Dw1 */
+
+	SLI4_REQFEAT_IAAB	= 1 << 0,	/* DW2 & DW3 */
+	SLI4_REQFEAT_NPIV	= 1 << 1,
+	SLI4_REQFEAT_DIF	= 1 << 2,
+	SLI4_REQFEAT_VF		= 1 << 3,
+	SLI4_REQFEAT_FCPI	= 1 << 4,
+	SLI4_REQFEAT_FCPT	= 1 << 5,
+	SLI4_REQFEAT_FCPC	= 1 << 6,
+	SLI4_REQFEAT_RSVD	= 1 << 7,
+	SLI4_REQFEAT_RQD	= 1 << 8,
+	SLI4_REQFEAT_IAAR	= 1 << 9,
+	SLI4_REQFEAT_HLM	= 1 << 10,
+	SLI4_REQFEAT_PERFH	= 1 << 11,
+	SLI4_REQFEAT_RXSEQ	= 1 << 12,
+	SLI4_REQFEAT_RXRI	= 1 << 13,
+	SLI4_REQFEAT_DCL2	= 1 << 14,
+	SLI4_REQFEAT_RSCO	= 1 << 15,
+	SLI4_REQFEAT_MRQP	= 1 << 16,
+};
+
+struct sli4_cmd_request_features {
+	struct sli4_mbox_command_header	hdr;
+	__le32		dw1_qry;
+	__le32		cmd;
+	__le32		resp;
+};
+
+/*
+ * SLI_CONFIG - submit a configuration command to Port
+ *
+ * Command is either embedded as part of the payload (embed) or located
+ * in a separate memory buffer (mem)
+ */
+enum sli4_sli_config {
+	SLI4_SLICONF_EMB		= 0x1,		/* DW1 */
+	SLI4_SLICONF_PMDCMD_SHIFT	= 3,
+	SLI4_SLICONF_PMDCMD_MASK	= 0xf8,
+	SLI4_SLICONF_PMDCMD_VAL_1	= 8,
+	SLI4_SLICONF_PMDCNT		= 0xf8,
+
+	SLI4_SLICONF_PMD_LEN		= 0x00ffffff,
+};
+
+struct sli4_cmd_sli_config {
+	struct sli4_mbox_command_header	hdr;
+	__le32		dw1_flags;
+	__le32		payload_len;
+	__le32		rsvd12[3];
+	union {
+		u8 embed[58 * sizeof(u32)];
+		struct sli4_bufptr mem;
+	} payload;
+};
+
+/* READ_STATUS - read tx/rx status of a particular port */
+#define SLI4_READSTATUS_CLEAR_COUNTERS	0x1
+
+struct sli4_cmd_read_status {
+	struct sli4_mbox_command_header	hdr;
+	__le32		dw1_flags;
+	__le32		rsvd4;
+	__le32		trans_kbyte_cnt;
+	__le32		recv_kbyte_cnt;
+	__le32		trans_frame_cnt;
+	__le32		recv_frame_cnt;
+	__le32		trans_seq_cnt;
+	__le32		recv_seq_cnt;
+	__le32		tot_exchanges_orig;
+	__le32		tot_exchanges_resp;
+	__le32		recv_p_bsy_cnt;
+	__le32		recv_f_bsy_cnt;
+	__le32		no_rq_buf_dropped_frames_cnt;
+	__le32		empty_rq_timeout_cnt;
+	__le32		no_xri_dropped_frames_cnt;
+	__le32		empty_xri_pool_cnt;
+};
+
+/* READ_LNK_STAT - read link status of a particular port */
+enum sli4_read_link_stats_flags {
+	SLI4_READ_LNKSTAT_REC	= 1u << 0,
+	SLI4_READ_LNKSTAT_GEC	= 1u << 1,
+	SLI4_READ_LNKSTAT_W02OF	= 1u << 2,
+	SLI4_READ_LNKSTAT_W03OF	= 1u << 3,
+	SLI4_READ_LNKSTAT_W04OF	= 1u << 4,
+	SLI4_READ_LNKSTAT_W05OF	= 1u << 5,
+	SLI4_READ_LNKSTAT_W06OF	= 1u << 6,
+	SLI4_READ_LNKSTAT_W07OF	= 1u << 7,
+	SLI4_READ_LNKSTAT_W08OF	= 1u << 8,
+	SLI4_READ_LNKSTAT_W09OF	= 1u << 9,
+	SLI4_READ_LNKSTAT_W10OF = 1u << 10,
+	SLI4_READ_LNKSTAT_W11OF = 1u << 11,
+	SLI4_READ_LNKSTAT_W12OF	= 1u << 12,
+	SLI4_READ_LNKSTAT_W13OF	= 1u << 13,
+	SLI4_READ_LNKSTAT_W14OF	= 1u << 14,
+	SLI4_READ_LNKSTAT_W15OF	= 1u << 15,
+	SLI4_READ_LNKSTAT_W16OF	= 1u << 16,
+	SLI4_READ_LNKSTAT_W17OF	= 1u << 17,
+	SLI4_READ_LNKSTAT_W18OF	= 1u << 18,
+	SLI4_READ_LNKSTAT_W19OF	= 1u << 19,
+	SLI4_READ_LNKSTAT_W20OF	= 1u << 20,
+	SLI4_READ_LNKSTAT_W21OF	= 1u << 21,
+	SLI4_READ_LNKSTAT_CLRC	= 1u << 30,
+	SLI4_READ_LNKSTAT_CLOF	= 1u << 31,
+};
+
+struct sli4_cmd_read_link_stats {
+	struct sli4_mbox_command_header	hdr;
+	__le32	dw1_flags;
+	__le32	linkfail_errcnt;
+	__le32	losssync_errcnt;
+	__le32	losssignal_errcnt;
+	__le32	primseq_errcnt;
+	__le32	inval_txword_errcnt;
+	__le32	crc_errcnt;
+	__le32	primseq_eventtimeout_cnt;
+	__le32	elastic_bufoverrun_errcnt;
+	__le32	arbit_fc_al_timeout_cnt;
+	__le32	adv_rx_buftor_to_buf_credit;
+	__le32	curr_rx_buf_to_buf_credit;
+	__le32	adv_tx_buf_to_buf_credit;
+	__le32	curr_tx_buf_to_buf_credit;
+	__le32	rx_eofa_cnt;
+	__le32	rx_eofdti_cnt;
+	__le32	rx_eofni_cnt;
+	__le32	rx_soff_cnt;
+	__le32	rx_dropped_no_aer_cnt;
+	__le32	rx_dropped_no_avail_rpi_rescnt;
+	__le32	rx_dropped_no_avail_xri_rescnt;
+};
+
+/* Format a WQE with WQ_ID Association performance hint */
+static inline void
+sli_set_wq_id_association(void *entry, u16 q_id)
+{
+	u32 *wqe = entry;
+
+	/*
+	 * Set Word 10, bit 0 to zero
+	 * Set Word 10, bits 15:1 to the WQ ID
+	 */
+	wqe[10] &= ~0xffff;
+	wqe[10] |= q_id << 1;
+}
+
+/* UNREG_FCFI - unregister a FCFI */
+struct sli4_cmd_unreg_fcfi {
+	struct sli4_mbox_command_header	hdr;
+	__le32		rsvd0;
+	__le16		fcfi;
+	__le16		rsvd6;
+};
+
+/* UNREG_RPI - unregister one or more RPI */
+enum sli4_unreg_rpi {
+	SLI4_UNREG_RPI_DP	= 0x2000,
+	SLI4_UNREG_RPI_II_SHIFT	= 14,
+	SLI4_UNREG_RPI_II_MASK	= 0xc000,
+	SLI4_UNREG_RPI_II_RPI	= 0x0000,
+	SLI4_UNREG_RPI_II_VPI	= 0x4000,
+	SLI4_UNREG_RPI_II_VFI	= 0x8000,
+	SLI4_UNREG_RPI_II_FCFI	= 0xc000,
+
+	SLI4_UNREG_RPI_DEST_N_PORTID_MASK = 0x00ffffff,
+};
+
+struct sli4_cmd_unreg_rpi {
+	struct sli4_mbox_command_header	hdr;
+	__le16		index;
+	__le16		dw1w1_flags;
+	__le32		dw2_dest_n_portid;
+};
+
+/* UNREG_VFI - unregister one or more VFI */
+enum sli4_unreg_vfi {
+	SLI4_UNREG_VFI_II_SHIFT	= 14,
+	SLI4_UNREG_VFI_II_MASK	= 0xc000,
+	SLI4_UNREG_VFI_II_VFI	= 0x0000,
+	SLI4_UNREG_VFI_II_FCFI	= 0xc000,
+};
+
+struct sli4_cmd_unreg_vfi {
+	struct sli4_mbox_command_header	hdr;
+	__le32		rsvd0;
+	__le16		index;
+	__le16		dw2_flags;
+};
+
+enum sli4_unreg_type {
+	SLI4_UNREG_TYPE_PORT,
+	SLI4_UNREG_TYPE_DOMAIN,
+	SLI4_UNREG_TYPE_FCF,
+	SLI4_UNREG_TYPE_ALL
+};
+
+/* UNREG_VPI - unregister one or more VPI */
+enum sli4_unreg_vpi {
+	SLI4_UNREG_VPI_II_SHIFT	= 14,
+	SLI4_UNREG_VPI_II_MASK	= 0xc000,
+	SLI4_UNREG_VPI_II_VPI	= 0x0000,
+	SLI4_UNREG_VPI_II_VFI	= 0x8000,
+	SLI4_UNREG_VPI_II_FCFI	= 0xc000,
+};
+
+struct sli4_cmd_unreg_vpi {
+	struct sli4_mbox_command_header	hdr;
+	__le32		rsvd0;
+	__le16		index;
+	__le16		dw2w0_flags;
+};
+
+/* AUTO_XFER_RDY - Configure the auto-generate XFER-RDY feature */
+struct sli4_cmd_config_auto_xfer_rdy {
+	struct sli4_mbox_command_header	hdr;
+	__le32		rsvd0;
+	__le32		max_burst_len;
+};
+
+#define SLI4_CONFIG_AUTO_XFERRDY_BLKSIZE	0xffff
+
+struct sli4_cmd_config_auto_xfer_rdy_hp {
+	struct sli4_mbox_command_header	hdr;
+	__le32		rsvd0;
+	__le32		max_burst_len;
+	__le32		dw3_esoc_flags;
+	__le16		block_size;
+	__le16		rsvd14;
+};
+
+/*************************************************************************
+ * SLI-4 common configuration command formats and definitions
+ */
+
+/*
+ * Subsystem values.
+ */
+enum sli4_subsystem {
+	SLI4_SUBSYSTEM_COMMON	= 0x01,
+	SLI4_SUBSYSTEM_LOWLEVEL	= 0x0b,
+	SLI4_SUBSYSTEM_FC	= 0x0c,
+	SLI4_SUBSYSTEM_DMTF	= 0x11,
+};
+
+#define	SLI4_OPC_LOWLEVEL_SET_WATCHDOG		0X36
+
+/*
+ * Common opcode (OPC) values.
+ */
+enum sli4_cmn_opcode {
+	SLI4_CMN_FUNCTION_RESET		= 0x3d,
+	SLI4_CMN_CREATE_CQ		= 0x0c,
+	SLI4_CMN_CREATE_CQ_SET		= 0x1d,
+	SLI4_CMN_DESTROY_CQ		= 0x36,
+	SLI4_CMN_MODIFY_EQ_DELAY	= 0x29,
+	SLI4_CMN_CREATE_EQ		= 0x0d,
+	SLI4_CMN_DESTROY_EQ		= 0x37,
+	SLI4_CMN_CREATE_MQ_EXT		= 0x5a,
+	SLI4_CMN_DESTROY_MQ		= 0x35,
+	SLI4_CMN_GET_CNTL_ATTRIBUTES	= 0x20,
+	SLI4_CMN_NOP			= 0x21,
+	SLI4_CMN_GET_RSC_EXTENT_INFO	= 0x9a,
+	SLI4_CMN_GET_SLI4_PARAMS	= 0xb5,
+	SLI4_CMN_QUERY_FW_CONFIG	= 0x3a,
+	SLI4_CMN_GET_PORT_NAME		= 0x4d,
+
+	SLI4_CMN_WRITE_FLASHROM		= 0x07,
+	/* TRANSCEIVER Data */
+	SLI4_CMN_READ_TRANS_DATA	= 0x49,
+	SLI4_CMN_GET_CNTL_ADDL_ATTRS	= 0x79,
+	SLI4_CMN_GET_FUNCTION_CFG	= 0xa0,
+	SLI4_CMN_GET_PROFILE_CFG	= 0xa4,
+	SLI4_CMN_SET_PROFILE_CFG	= 0xa5,
+	SLI4_CMN_GET_PROFILE_LIST	= 0xa6,
+	SLI4_CMN_GET_ACTIVE_PROFILE	= 0xa7,
+	SLI4_CMN_SET_ACTIVE_PROFILE	= 0xa8,
+	SLI4_CMN_READ_OBJECT		= 0xab,
+	SLI4_CMN_WRITE_OBJECT		= 0xac,
+	SLI4_CMN_DELETE_OBJECT		= 0xae,
+	SLI4_CMN_READ_OBJECT_LIST	= 0xad,
+	SLI4_CMN_SET_DUMP_LOCATION	= 0xb8,
+	SLI4_CMN_SET_FEATURES		= 0xbf,
+	SLI4_CMN_GET_RECFG_LINK_INFO	= 0xc9,
+	SLI4_CMN_SET_RECNG_LINK_ID	= 0xca,
+};
+
+/* DMTF opcode (OPC) values */
+#define DMTF_EXEC_CLP_CMD 0x01
+
+/*
+ * COMMON_FUNCTION_RESET
+ *
+ * Resets the Port, returning it to a power-on state. This configuration
+ * command does not have a payload and should set/expect the lengths to
+ * be zero.
+ */
+struct sli4_rqst_cmn_function_reset {
+	struct sli4_rqst_hdr	hdr;
+};
+
+struct sli4_rsp_cmn_function_reset {
+	struct sli4_rsp_hdr	hdr;
+};
+
+
+/*
+ * COMMON_GET_CNTL_ATTRIBUTES
+ *
+ * Query for information about the SLI Port
+ */
+enum sli4_cntrl_attr_flags {
+	SLI4_CNTL_ATTR_PORTNUM	= 0x3f,
+	SLI4_CNTL_ATTR_PORTTYPE	= 0xc0,
+};
+
+struct sli4_rsp_cmn_get_cntl_attributes {
+	struct sli4_rsp_hdr	hdr;
+	u8		version_str[32];
+	u8		manufacturer_name[32];
+	__le32		supported_modes;
+	u8		eprom_version_lo;
+	u8		eprom_version_hi;
+	__le16		rsvd17;
+	__le32		mbx_ds_version;
+	__le32		ep_fw_ds_version;
+	u8		ncsi_version_str[12];
+	__le32		def_extended_timeout;
+	u8		model_number[32];
+	u8		description[64];
+	u8		serial_number[32];
+	u8		ip_version_str[32];
+	u8		fw_version_str[32];
+	u8		bios_version_str[32];
+	u8		redboot_version_str[32];
+	u8		driver_version_str[32];
+	u8		fw_on_flash_version_str[32];
+	__le32		functionalities_supported;
+	__le16		max_cdb_length;
+	u8		asic_revision;
+	u8		generational_guid0;
+	__le32		generational_guid1_12[3];
+	__le16		generational_guid13_14;
+	u8		generational_guid15;
+	u8		hba_port_count;
+	__le16		default_link_down_timeout;
+	u8		iscsi_version_min_max;
+	u8		multifunctional_device;
+	u8		cache_valid;
+	u8		hba_status;
+	u8		max_domains_supported;
+	u8		port_num_type_flags;
+	__le32		firmware_post_status;
+	__le32		hba_mtu;
+	u8		iscsi_features;
+	u8		rsvd121[3];
+	__le16		pci_vendor_id;
+	__le16		pci_device_id;
+	__le16		pci_sub_vendor_id;
+	__le16		pci_sub_system_id;
+	u8		pci_bus_number;
+	u8		pci_device_number;
+	u8		pci_function_number;
+	u8		interface_type;
+	__le64		unique_identifier;
+	u8		number_of_netfilters;
+	u8		rsvd122[3];
+};
+
+/*
+ * COMMON_GET_CNTL_ATTRIBUTES
+ *
+ * This command queries the controller information from the Flash ROM.
+ */
+struct sli4_rqst_cmn_get_cntl_addl_attributes {
+	struct sli4_rqst_hdr	hdr;
+};
+
+struct sli4_rsp_cmn_get_cntl_addl_attributes {
+	struct sli4_rsp_hdr	hdr;
+	__le16		ipl_file_number;
+	u8		ipl_file_version;
+	u8		rsvd4;
+	u8		on_die_temperature;
+	u8		rsvd5[3];
+	__le32		driver_advanced_features_supported;
+	__le32		rsvd7[4];
+	char		universal_bios_version[32];
+	char		x86_bios_version[32];
+	char		efi_bios_version[32];
+	char		fcode_version[32];
+	char		uefi_bios_version[32];
+	char		uefi_nic_version[32];
+	char		uefi_fcode_version[32];
+	char		uefi_iscsi_version[32];
+	char		iscsi_x86_bios_version[32];
+	char		pxe_x86_bios_version[32];
+	u8		default_wwpn[8];
+	u8		ext_phy_version[32];
+	u8		fc_universal_bios_version[32];
+	u8		fc_x86_bios_version[32];
+	u8		fc_efi_bios_version[32];
+	u8		fc_fcode_version[32];
+	u8		ext_phy_crc_label[8];
+	u8		ipl_file_name[16];
+	u8		rsvd139[72];
+};
+
+/*
+ * COMMON_NOP
+ *
+ * This command does not do anything; it only returns
+ * the payload in the completion.
+ */
+struct sli4_rqst_cmn_nop {
+	struct sli4_rqst_hdr	hdr;
+	__le32			context[2];
+};
+
+struct sli4_rsp_cmn_nop {
+	struct sli4_rsp_hdr	hdr;
+	__le32			context[2];
+};
+
+struct sli4_rqst_cmn_get_resource_extent_info {
+	struct sli4_rqst_hdr	hdr;
+	__le16	resource_type;
+	__le16	rsvd16;
+};
+
+enum sli4_rsc_type {
+	SLI4_RSC_TYPE_VFI	= 0x20,
+	SLI4_RSC_TYPE_VPI	= 0x21,
+	SLI4_RSC_TYPE_RPI	= 0x22,
+	SLI4_RSC_TYPE_XRI	= 0x23,
+};
+
+struct sli4_rsp_cmn_get_resource_extent_info {
+	struct sli4_rsp_hdr	hdr;
+	__le16		resource_extent_count;
+	__le16		resource_extent_size;
+};
+
+#define SLI4_128BYTE_WQE_SUPPORT	0x02
+
+#define GET_Q_CNT_METHOD(m) \
+	(((m) & SLI4_PARAM_Q_CNT_MTHD_MASK) >> SLI4_PARAM_Q_CNT_MTHD_SHFT)
+#define GET_Q_CREATE_VERSION(v) \
+	(((v) & SLI4_PARAM_QV_MASK) >> SLI4_PARAM_QV_SHIFT)
+
+enum sli4_rsp_get_params_e {
+	/*GENERIC*/
+	SLI4_PARAM_Q_CNT_MTHD_SHFT	= 24,
+	SLI4_PARAM_Q_CNT_MTHD_MASK	= 0xf << 24,
+	SLI4_PARAM_QV_SHIFT		= 14,
+	SLI4_PARAM_QV_MASK		= 3 << 14,
+
+	/* DW4 */
+	SLI4_PARAM_PROTO_TYPE_MASK	= 0xff,
+	/* DW5 */
+	SLI4_PARAM_FT			= 1 << 0,
+	SLI4_PARAM_SLI_REV_MASK		= 0xf << 4,
+	SLI4_PARAM_SLI_FAM_MASK		= 0xf << 8,
+	SLI4_PARAM_IF_TYPE_MASK		= 0xf << 12,
+	SLI4_PARAM_SLI_HINT1_MASK	= 0xff << 16,
+	SLI4_PARAM_SLI_HINT2_MASK	= 0x1f << 24,
+	/* DW6 */
+	SLI4_PARAM_EQ_PAGE_CNT_MASK	= 0xf << 0,
+	SLI4_PARAM_EQE_SZS_MASK		= 0xf << 8,
+	SLI4_PARAM_EQ_PAGE_SZS_MASK	= 0xff << 16,
+	/* DW8 */
+	SLI4_PARAM_CQ_PAGE_CNT_MASK	= 0xf << 0,
+	SLI4_PARAM_CQE_SZS_MASK		= 0xf << 8,
+	SLI4_PARAM_CQ_PAGE_SZS_MASK	= 0xff << 16,
+	/* DW10 */
+	SLI4_PARAM_MQ_PAGE_CNT_MASK	= 0xf << 0,
+	SLI4_PARAM_MQ_PAGE_SZS_MASK	= 0xff << 16,
+	/* DW12 */
+	SLI4_PARAM_WQ_PAGE_CNT_MASK	= 0xf << 0,
+	SLI4_PARAM_WQE_SZS_MASK		= 0xf << 8,
+	SLI4_PARAM_WQ_PAGE_SZS_MASK	= 0xff << 16,
+	/* DW14 */
+	SLI4_PARAM_RQ_PAGE_CNT_MASK	= 0xf << 0,
+	SLI4_PARAM_RQE_SZS_MASK		= 0xf << 8,
+	SLI4_PARAM_RQ_PAGE_SZS_MASK	= 0xff << 16,
+	/* DW15W1*/
+	SLI4_PARAM_RQ_DB_WINDOW_MASK	= 0xf000,
+	/* DW16 */
+	SLI4_PARAM_FC			= 1 << 0,
+	SLI4_PARAM_EXT			= 1 << 1,
+	SLI4_PARAM_HDRR			= 1 << 2,
+	SLI4_PARAM_SGLR			= 1 << 3,
+	SLI4_PARAM_FBRR			= 1 << 4,
+	SLI4_PARAM_AREG			= 1 << 5,
+	SLI4_PARAM_TGT			= 1 << 6,
+	SLI4_PARAM_TERP			= 1 << 7,
+	SLI4_PARAM_ASSI			= 1 << 8,
+	SLI4_PARAM_WCHN			= 1 << 9,
+	SLI4_PARAM_TCCA			= 1 << 10,
+	SLI4_PARAM_TRTY			= 1 << 11,
+	SLI4_PARAM_TRIR			= 1 << 12,
+	SLI4_PARAM_PHOFF		= 1 << 13,
+	SLI4_PARAM_PHON			= 1 << 14,
+	SLI4_PARAM_PHWQ			= 1 << 15,
+	SLI4_PARAM_BOUND_4GA		= 1 << 16,
+	SLI4_PARAM_RXC			= 1 << 17,
+	SLI4_PARAM_HLM			= 1 << 18,
+	SLI4_PARAM_IPR			= 1 << 19,
+	SLI4_PARAM_RXRI			= 1 << 20,
+	SLI4_PARAM_SGLC			= 1 << 21,
+	SLI4_PARAM_TIMM			= 1 << 22,
+	SLI4_PARAM_TSMM			= 1 << 23,
+	SLI4_PARAM_OAS			= 1 << 25,
+	SLI4_PARAM_LC			= 1 << 26,
+	SLI4_PARAM_AGXF			= 1 << 27,
+	SLI4_PARAM_LOOPBACK_MASK	= 0xf << 28,
+	/* DW18 */
+	SLI4_PARAM_SGL_PAGE_CNT_MASK	= 0xf << 0,
+	SLI4_PARAM_SGL_PAGE_SZS_MASK	= 0xff << 8,
+	SLI4_PARAM_SGL_PP_ALIGN_MASK	= 0xff << 16,
+};
+
+struct sli4_rqst_cmn_get_sli4_params {
+	struct sli4_rqst_hdr	hdr;
+};
+
+struct sli4_rsp_cmn_get_sli4_params {
+	struct sli4_rsp_hdr	hdr;
+	__le32		dw4_protocol_type;
+	__le32		dw5_sli;
+	__le32		dw6_eq_page_cnt;
+	__le16		eqe_count_mask;
+	__le16		rsvd26;
+	__le32		dw8_cq_page_cnt;
+	__le16		cqe_count_mask;
+	__le16		rsvd34;
+	__le32		dw10_mq_page_cnt;
+	__le16		mqe_count_mask;
+	__le16		rsvd42;
+	__le32		dw12_wq_page_cnt;
+	__le16		wqe_count_mask;
+	__le16		rsvd50;
+	__le32		dw14_rq_page_cnt;
+	__le16		rqe_count_mask;
+	__le16		dw15w1_rq_db_window;
+	__le32		dw16_loopback_scope;
+	__le32		sge_supported_length;
+	__le32		dw18_sgl_page_cnt;
+	__le16		min_rq_buffer_size;
+	__le16		rsvd75;
+	__le32		max_rq_buffer_size;
+	__le16		physical_xri_max;
+	__le16		physical_rpi_max;
+	__le16		physical_vpi_max;
+	__le16		physical_vfi_max;
+	__le32		rsvd88;
+	__le16		frag_num_field_offset;
+	__le16		frag_num_field_size;
+	__le16		sgl_index_field_offset;
+	__le16		sgl_index_field_size;
+	__le32		chain_sge_initial_value_lo;
+	__le32		chain_sge_initial_value_hi;
+};
+
+/*Port Types*/
+enum sli4_port_types {
+	SLI4_PORT_TYPE_ETH	= 0,
+	SLI4_PORT_TYPE_FC	= 1,
+};
+
+struct sli4_rqst_cmn_get_port_name {
+	struct sli4_rqst_hdr	hdr;
+	u8	port_type;
+	u8	rsvd4[3];
+};
+
+struct sli4_rsp_cmn_get_port_name {
+	struct sli4_rsp_hdr	hdr;
+	char	port_name[4];
+};
+
+struct sli4_rqst_cmn_write_flashrom {
+	struct sli4_rqst_hdr	hdr;
+	__le32		flash_rom_access_opcode;
+	__le32		flash_rom_access_operation_type;
+	__le32		data_buffer_size;
+	__le32		offset;
+	u8		data_buffer[4];
+};
+
+/*
+ * COMMON_READ_TRANSCEIVER_DATA
+ *
+ * This command reads SFF transceiver data(Format is defined
+ * by the SFF-8472 specification).
+ */
+struct sli4_rqst_cmn_read_transceiver_data {
+	struct sli4_rqst_hdr	hdr;
+	__le32			page_number;
+	__le32			port;
+};
+
+struct sli4_rsp_cmn_read_transceiver_data {
+	struct sli4_rsp_hdr	hdr;
+	__le32			page_number;
+	__le32			port;
+	u8			page_data[128];
+	u8			page_data_2[128];
+};
+
+#define SLI4_REQ_DESIRE_READLEN		0xffffff
+
+struct sli4_rqst_cmn_read_object {
+	struct sli4_rqst_hdr	hdr;
+	__le32			desired_read_length_dword;
+	__le32			read_offset;
+	u8			object_name[104];
+	__le32			host_buffer_descriptor_count;
+	struct sli4_bde		host_buffer_descriptor[0];
+};
+
+#define RSP_COM_READ_OBJ_EOF		0x80000000
+
+struct sli4_rsp_cmn_read_object {
+	struct sli4_rsp_hdr	hdr;
+	__le32			actual_read_length;
+	__le32			eof_dword;
+};
+
+enum sli4_rqst_write_object_flags {
+	SLI4_RQ_DES_WRITE_LEN		= 0xffffff,
+	SLI4_RQ_DES_WRITE_LEN_NOC	= 0x40000000,
+	SLI4_RQ_DES_WRITE_LEN_EOF	= 0x80000000,
+};
+
+struct sli4_rqst_cmn_write_object {
+	struct sli4_rqst_hdr	hdr;
+	__le32			desired_write_len_dword;
+	__le32			write_offset;
+	u8			object_name[104];
+	__le32			host_buffer_descriptor_count;
+	struct sli4_bde		host_buffer_descriptor[0];
+};
+
+#define	RSP_CHANGE_STATUS		0xff
+
+struct sli4_rsp_cmn_write_object {
+	struct sli4_rsp_hdr	hdr;
+	__le32			actual_write_length;
+	__le32			change_status_dword;
+};
+
+struct sli4_rqst_cmn_delete_object {
+	struct sli4_rqst_hdr	hdr;
+	__le32			rsvd4;
+	__le32			rsvd5;
+	u8			object_name[104];
+};
+
+#define SLI4_RQ_OBJ_LIST_READ_LEN	0xffffff
+
+struct sli4_rqst_cmn_read_object_list {
+	struct sli4_rqst_hdr	hdr;
+	__le32			desired_read_length_dword;
+	__le32			read_offset;
+	u8			object_name[104];
+	__le32			host_buffer_descriptor_count;
+	struct sli4_bde		host_buffer_descriptor[0];
+};
+
+enum sli4_rqst_set_dump_flags {
+	SLI4_CMN_SET_DUMP_BUFFER_LEN	= 0xffffff,
+	SLI4_CMN_SET_DUMP_FDB		= 0x20000000,
+	SLI4_CMN_SET_DUMP_BLP		= 0x40000000,
+	SLI4_CMN_SET_DUMP_QRY		= 0x80000000,
+};
+
+struct sli4_rqst_cmn_set_dump_location {
+	struct sli4_rqst_hdr	hdr;
+	__le32			buffer_length_dword;
+	__le32			buf_addr_low;
+	__le32			buf_addr_high;
+};
+
+struct sli4_rsp_cmn_set_dump_location {
+	struct sli4_rsp_hdr	hdr;
+	__le32			buffer_length_dword;
+};
+
+enum sli4_dump_level {
+	SLI4_DUMP_LEVEL_NONE,
+	SLI4_CHIP_LEVEL_DUMP,
+	SLI4_FUNC_DESC_DUMP,
+};
+
+enum sli4_dump_state {
+	SLI4_DUMP_STATE_NONE,
+	SLI4_CHIP_DUMP_STATE_VALID,
+	SLI4_FUNC_DUMP_STATE_VALID,
+};
+
+enum sli4_dump_status {
+	SLI4_DUMP_READY_STATUS_NOT_READY,
+	SLI4_DUMP_READY_STATUS_DD_PRESENT,
+	SLI4_DUMP_READY_STATUS_FDB_PRESENT,
+	SLI4_DUMP_READY_STATUS_SKIP_DUMP,
+	SLI4_DUMP_READY_STATUS_FAILED = -1,
+};
+
+enum sli4_set_features {
+	SLI4_SET_FEATURES_DIF_SEED			= 0x01,
+	SLI4_SET_FEATURES_XRI_TIMER			= 0x03,
+	SLI4_SET_FEATURES_MAX_PCIE_SPEED		= 0x04,
+	SLI4_SET_FEATURES_FCTL_CHECK			= 0x05,
+	SLI4_SET_FEATURES_FEC				= 0x06,
+	SLI4_SET_FEATURES_PCIE_RECV_DETECT		= 0x07,
+	SLI4_SET_FEATURES_DIF_MEMORY_MODE		= 0x08,
+	SLI4_SET_FEATURES_DISABLE_SLI_PORT_PAUSE_STATE	= 0x09,
+	SLI4_SET_FEATURES_ENABLE_PCIE_OPTIONS		= 0x0a,
+	SLI4_SET_FEAT_CFG_AUTO_XFER_RDY_T10PI		= 0x0c,
+	SLI4_SET_FEATURES_ENABLE_MULTI_RECEIVE_QUEUE	= 0x0d,
+	SLI4_SET_FEATURES_SET_FTD_XFER_HINT		= 0x0f,
+	SLI4_SET_FEATURES_SLI_PORT_HEALTH_CHECK		= 0x11,
+};
+
+struct sli4_rqst_cmn_set_features {
+	struct sli4_rqst_hdr	hdr;
+	__le32			feature;
+	__le32			param_len;
+	__le32			params[8];
+};
+
+struct sli4_rqst_cmn_set_features_dif_seed {
+	__le16		seed;
+	__le16		rsvd16;
+};
+
+enum sli4_rqst_set_mrq_features {
+	SLI4_RQ_MULTIRQ_ISR		 = 0x1,
+	SLI4_RQ_MULTIRQ_AUTOGEN_XFER_RDY = 0x2,
+
+	SLI4_RQ_MULTIRQ_NUM_RQS		 = 0xff,
+	SLI4_RQ_MULTIRQ_RQ_SELECT	 = 0xf00,
+};
+
+struct sli4_rqst_cmn_set_features_multirq {
+	__le32		auto_gen_xfer_dword;
+	__le32		num_rqs_dword;
+};
+
+enum sli4_rqst_health_check_flags {
+	SLI4_RQ_HEALTH_CHECK_ENABLE	= 0x1,
+	SLI4_RQ_HEALTH_CHECK_QUERY	= 0x2,
+};
+
+struct sli4_rqst_cmn_set_features_health_check {
+	__le32		health_check_dword;
+};
+
+struct sli4_rqst_cmn_set_features_set_fdt_xfer_hint {
+	__le32		fdt_xfer_hint;
+};
+
+struct sli4_rqst_dmtf_exec_clp_cmd {
+	struct sli4_rqst_hdr	hdr;
+	__le32			cmd_buf_length;
+	__le32			resp_buf_length;
+	__le32			cmd_buf_addr_low;
+	__le32			cmd_buf_addr_high;
+	__le32			resp_buf_addr_low;
+	__le32			resp_buf_addr_high;
+};
+
+struct sli4_rsp_dmtf_exec_clp_cmd {
+	struct sli4_rsp_hdr	hdr;
+	__le32			rsvd4;
+	__le32			resp_length;
+	__le32			rsvd6;
+	__le32			rsvd7;
+	__le32			rsvd8;
+	__le32			rsvd9;
+	__le32			clp_status;
+	__le32			clp_detailed_status;
+};
+
+#define SLI4_PROTOCOL_FC		0x10
+#define SLI4_PROTOCOL_DEFAULT		0xff
+
+struct sli4_rspource_descriptor_v1 {
+	u8		descriptor_type;
+	u8		descriptor_length;
+	__le16		rsvd16;
+	__le32		type_specific[0];
+};
+
+enum sli4_pcie_desc_flags {
+	SLI4_PCIE_DESC_IMM		= 0x4000,
+	SLI4_PCIE_DESC_NOSV		= 0x8000,
+
+	SLI4_PCIE_DESC_PF_NO		= 0x3ff0000,
+
+	SLI4_PCIE_DESC_MISSN_ROLE	= 0xff,
+	SLI4_PCIE_DESC_PCHG		= 0x8000000,
+	SLI4_PCIE_DESC_SCHG		= 0x10000000,
+	SLI4_PCIE_DESC_XCHG		= 0x20000000,
+	SLI4_PCIE_DESC_XROM		= 0xc0000000
+};
+
+struct sli4_pcie_resource_descriptor_v1 {
+	u8		descriptor_type;
+	u8		descriptor_length;
+	__le16		imm_nosv_dword;
+	__le32		pf_number_dword;
+	__le32		rsvd3;
+	u8		sriov_state;
+	u8		pf_state;
+	u8		pf_type;
+	u8		rsvd4;
+	__le16		number_of_vfs;
+	__le16		rsvd5;
+	__le32		mission_roles_dword;
+	__le32		rsvd7[16];
+};
+
+struct sli4_rqst_cmn_get_function_config {
+	struct sli4_rqst_hdr  hdr;
+};
+
+struct sli4_rsp_cmn_get_function_config {
+	struct sli4_rsp_hdr	hdr;
+	__le32			desc_count;
+	__le32			desc[54];
+};
+
+/* Link Config Descriptor for link config functions */
+struct sli4_link_config_descriptor {
+	u8		link_config_id;
+	u8		rsvd1[3];
+	__le32		config_description[8];
+};
+
+#define MAX_LINK_DES	10
+
+struct sli4_rqst_cmn_get_reconfig_link_info {
+	struct sli4_rqst_hdr  hdr;
+};
+
+struct sli4_rsp_cmn_get_reconfig_link_info {
+	struct sli4_rsp_hdr	hdr;
+	u8			active_link_config_id;
+	u8			rsvd17;
+	u8			next_link_config_id;
+	u8			rsvd19;
+	__le32			link_configuration_descriptor_count;
+	struct sli4_link_config_descriptor
+				desc[MAX_LINK_DES];
+};
+
+enum sli4_set_reconfig_link_flags {
+	SLI4_SET_RECONFIG_LINKID_NEXT	= 0xff,
+	SLI4_SET_RECONFIG_LINKID_FD	= 1u << 31,
+};
+
+struct sli4_rqst_cmn_set_reconfig_link_id {
+	struct sli4_rqst_hdr  hdr;
+	__le32			dw4_flags;
+};
+
+struct sli4_rsp_cmn_set_reconfig_link_id {
+	struct sli4_rsp_hdr	hdr;
+};
+
+struct sli4_rqst_lowlevel_set_watchdog {
+	struct sli4_rqst_hdr	hdr;
+	__le16			watchdog_timeout;
+	__le16			rsvd18;
+};
+
+struct sli4_rsp_lowlevel_set_watchdog {
+	struct sli4_rsp_hdr	hdr;
+	__le32			rsvd;
+};
+
+/* FC opcode (OPC) values */
+enum sli4_fc_opcodes {
+	SLI4_OPC_WQ_CREATE		= 0x1,
+	SLI4_OPC_WQ_DESTROY		= 0x2,
+	SLI4_OPC_POST_SGL_PAGES		= 0x3,
+	SLI4_OPC_RQ_CREATE		= 0x5,
+	SLI4_OPC_RQ_DESTROY		= 0x6,
+	SLI4_OPC_READ_FCF_TABLE		= 0x8,
+	SLI4_OPC_POST_HDR_TEMPLATES	= 0xb,
+	SLI4_OPC_REDISCOVER_FCF		= 0x10,
+};
+
+/* Use the default CQ associated with the WQ */
+#define SLI4_CQ_DEFAULT 0xffff
+
+/*
+ * POST_SGL_PAGES
+ *
+ * Register the scatter gather list (SGL) memory and
+ * associate it with an XRI.
+ */
+struct sli4_rqst_post_sgl_pages {
+	struct sli4_rqst_hdr	hdr;
+	__le16			xri_start;
+	__le16			xri_count;
+	struct {
+		__le32		page0_low;
+		__le32		page0_high;
+		__le32		page1_low;
+		__le32		page1_high;
+	} page_set[10];
+};
+
+struct sli4_rsp_post_sgl_pages {
+	struct sli4_rsp_hdr	hdr;
+};
+
+struct sli4_rqst_post_hdr_templates {
+	struct sli4_rqst_hdr	hdr;
+	__le16			rpi_offset;
+	__le16			page_count;
+	struct sli4_dmaaddr	page_descriptor[0];
+};
+
+#define SLI4_HDR_TEMPLATE_SIZE		64
+
+enum sli4_io_flags {
+/* The XRI associated with this IO is already active */
+	SLI4_IO_CONTINUATION		= 1 << 0,
+/* Automatically generate a good RSP frame */
+	SLI4_IO_AUTO_GOOD_RESPONSE	= 1 << 1,
+	SLI4_IO_NO_ABORT		= 1 << 2,
+/* Set the DNRX bit because no auto xref rdy buffer is posted */
+	SLI4_IO_DNRX			= 1 << 3,
+};
+
+enum sli4_callback {
+	SLI4_CB_LINK,
+	SLI4_CB_MAX,
+};
+
+enum sli4_link_status {
+	SLI4_LINK_STATUS_UP,
+	SLI4_LINK_STATUS_DOWN,
+	SLI4_LINK_STATUS_NO_ALPA,
+	SLI4_LINK_STATUS_MAX,
+};
+
+enum sli4_link_topology {
+	SLI4_LINK_TOPO_NON_FC_AL = 1,
+	SLI4_LINK_TOPO_FC_AL,
+	SLI4_LINK_TOPO_LOOPBACK_INTERNAL,
+	SLI4_LINK_TOPO_LOOPBACK_EXTERNAL,
+	SLI4_LINK_TOPO_NONE,
+	SLI4_LINK_TOPO_MAX,
+};
+
+enum sli4_link_medium {
+	SLI4_LINK_MEDIUM_ETHERNET,
+	SLI4_LINK_MEDIUM_FC,
+	SLI4_LINK_MEDIUM_MAX,
+};
 /******Driver specific structures******/
 
 struct sli4_queue {
@@ -2020,7 +3534,7 @@ struct sli4_queue {
 	} u;
 };
 
-/* Prameters used to populate WQE*/
+/* Parameters used to populate WQE*/
 struct sli_bls_params {
 	u32		s_id;
 	u32		d_id;
@@ -2081,4 +3595,116 @@ struct sli_fcp_tgt_params {
 	u16		tag;
 };
 
+struct sli4_link_event {
+	enum sli4_link_status	status;
+	enum sli4_link_topology	topology;
+	enum sli4_link_medium	medium;
+	u32			speed;
+	u8			*loop_map;
+	u32			fc_id;
+};
+
+enum sli4_resource {
+	SLI4_RSRC_VFI,
+	SLI4_RSRC_VPI,
+	SLI4_RSRC_RPI,
+	SLI4_RSRC_XRI,
+	SLI4_RSRC_FCFI,
+	SLI4_RSRC_MAX,
+};
+
+struct sli4_extent {
+	u32		number;
+	u32		size;
+	u32		n_alloc;
+	u32		*base;
+	unsigned long	*use_map;
+	u32		map_size;
+};
+
+struct sli4_queue_info {
+	u16	max_qcount[SLI4_QTYPE_MAX];
+	u32	max_qentries[SLI4_QTYPE_MAX];
+	u16	count_mask[SLI4_QTYPE_MAX];
+	u16	count_method[SLI4_QTYPE_MAX];
+	u32	qpage_count[SLI4_QTYPE_MAX];
+};
+
+struct sli4_params {
+	u8	has_extents;
+	u8	auto_reg;
+	u8	auto_xfer_rdy;
+	u8	hdr_template_req;
+	u8	perf_hint;
+	u8	perf_wq_id_association;
+	u8	cq_create_version;
+	u8	mq_create_version;
+	u8	high_login_mode;
+	u8	sgl_pre_registered;
+	u8	sgl_pre_reg_required;
+	u8	t10_dif_inline_capable;
+	u8	t10_dif_separate_capable;
+};
+
+struct sli4 {
+	void			*os;
+	struct pci_dev		*pci;
+	void __iomem		*reg[PCI_STD_NUM_BARS];
+
+	u32			sli_rev;
+	u32			sli_family;
+	u32			if_type;
+
+	u16			asic_type;
+	u16			asic_rev;
+
+	u16			e_d_tov;
+	u16			r_a_tov;
+	struct sli4_queue_info	qinfo;
+	u16			link_module_type;
+	u8			rq_batch;
+	u8			port_number;
+	char			port_name[2];
+	u16			rq_min_buf_size;
+	u32			rq_max_buf_size;
+	u8			topology;
+	u8			wwpn[8];
+	u8			wwnn[8];
+	u32			fw_rev[2];
+	u8			fw_name[2][16];
+	char			ipl_name[16];
+	u32			hw_rev[3];
+	char			modeldesc[64];
+	char			bios_version_string[32];
+	u32			wqe_size;
+	u32			vpd_length;
+	/*
+	 * Tracks the port resources using extents metaphor. For
+	 * devices that don't implement extents (i.e.
+	 * has_extents == FALSE), the code models each resource as
+	 * a single large extent.
+	 */
+	struct sli4_extent	ext[SLI4_RSRC_MAX];
+	u32			features;
+	struct sli4_params	params;
+	u32			sge_supported_length;
+	u32			sgl_page_sizes;
+	u32			max_sgl_pages;
+
+	/*
+	 * Callback functions
+	 */
+	int			(*link)(void *ctx, void *event);
+	void			*link_arg;
+
+	struct efc_dma		bmbx;
+
+	/* Save pointer to physical memory descriptor for non-embedded
+	 * SLI_CONFIG commands for BMBX dumping purposes
+	 */
+	struct efc_dma		*bmbx_non_emb_pmd;
+
+	struct efc_dma		vpd_data;
+};
+
 #endif /* !_SLI4_H */
-- 
2.26.2

