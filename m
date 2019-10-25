Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E4ACA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 11:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD9C2070B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 11:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfJYLTt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 07:19:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:56028 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbfJYLTt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 07:19:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0D4A7B19E;
        Fri, 25 Oct 2019 11:19:45 +0000 (UTC)
Date:   Fri, 25 Oct 2019 13:19:44 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH 03/32] elx: libefc_sli: Data structures and defines for
 mbox commands
Message-ID: <20191025111944.hdgfnslk57njngfi@beryllium.lan>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-4-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023215557.12581-4-jsmart2021@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Wed, Oct 23, 2019 at 02:55:28PM -0700, James Smart wrote:
> This patch continues the libefc_sli SLI-4 library population.
> 
> This patch adds definitions for SLI-4 mailbox commands
> and responses.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/libefc_sli/sli4.h | 1996 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 1996 insertions(+)
> 
> diff --git a/drivers/scsi/elx/libefc_sli/sli4.h b/drivers/scsi/elx/libefc_sli/sli4.h
> index ebc6a67e9c8c..b36d67abf219 100644
> --- a/drivers/scsi/elx/libefc_sli/sli4.h
> +++ b/drivers/scsi/elx/libefc_sli/sli4.h
> @@ -2264,4 +2264,2000 @@ struct sli4_fc_xri_aborted_cqe_s {
>  #define SLI4_ELS_REQUEST64_CMD_NON_FABRIC	0x0c
>  #define SLI4_ELS_REQUEST64_CMD_FABRIC		0x0d
>  
> +#define SLI_PAGE_SIZE		(1 << 12)	/* 4096 */

So SLI_PAGE_SIZE is fixed and can't be changed...

> +#define SLI_SUB_PAGE_MASK	(SLI_PAGE_SIZE - 1)
> +#define SLI_ROUND_PAGE(b)	(((b) + SLI_SUB_PAGE_MASK) & ~SLI_SUB_PAGE_MASK)
> +
> +#define SLI4_BMBX_TIMEOUT_MSEC		30000
> +#define SLI4_FW_READY_TIMEOUT_MSEC	30000
> +
> +#define SLI4_BMBX_DELAY_US 1000 /* 1 ms */
> +#define SLI4_INIT_PORT_DELAY_US 10000 /* 10 ms */
> +
> +static inline u32
> +sli_page_count(size_t bytes, u32 page_size)

... and callers of this function pass in SLI_PAGE_SIZE.
> +{
> +	u32	mask = page_size - 1;
> +	u32	shift = 0;
> +
> +	switch (page_size) {
> +	case 4096:
> +		shift = 12;
> +		break;
> +	case 8192:
> +		shift = 13;
> +		break;
> +	case 16384:
> +		shift = 14;
> +		break;
> +	case 32768:
> +		shift = 15;
> +		break;
> +	case 65536:
> +		shift = 16;
> +		break;
> +	default:
> +		return 0;
> +	}

What about using __ffs(page_size)? But...

> +
> +	return (bytes + mask) >> shift;

... mask and shift could just be defined like SLI_PAGE_SIZE and we
safe a few instructions. Unless SLI_PAGE_SIZE will be dynamic in future.

> +}
> +
> +/*************************************************************************
> + * SLI-4 mailbox command formats and definitions
> + */
> +
> +struct sli4_mbox_command_header_s {
> +	u8	resvd0;
> +	u8	command;
> +	__le16	status;	/* Port writes to indicate success/fail */
> +};
> +
> +enum {
> +	MBX_CMD_CONFIG_LINK	= 0x07,
> +	MBX_CMD_DUMP		= 0x17,
> +	MBX_CMD_DOWN_LINK	= 0x06,
> +	MBX_CMD_INIT_LINK	= 0x05,
> +	MBX_CMD_INIT_VFI	= 0xa3,
> +	MBX_CMD_INIT_VPI	= 0xa4,
> +	MBX_CMD_POST_XRI	= 0xa7,
> +	MBX_CMD_RELEASE_XRI	= 0xac,
> +	MBX_CMD_READ_CONFIG	= 0x0b,
> +	MBX_CMD_READ_STATUS	= 0x0e,
> +	MBX_CMD_READ_NVPARMS	= 0x02,
> +	MBX_CMD_READ_REV	= 0x11,
> +	MBX_CMD_READ_LNK_STAT	= 0x12,
> +	MBX_CMD_READ_SPARM64	= 0x8d,
> +	MBX_CMD_READ_TOPOLOGY	= 0x95,
> +	MBX_CMD_REG_FCFI	= 0xa0,
> +	MBX_CMD_REG_FCFI_MRQ	= 0xaf,
> +	MBX_CMD_REG_RPI		= 0x93,
> +	MBX_CMD_REG_RX_RQ	= 0xa6,
> +	MBX_CMD_REG_VFI		= 0x9f,
> +	MBX_CMD_REG_VPI		= 0x96,
> +	MBX_CMD_RQST_FEATURES	= 0x9d,
> +	MBX_CMD_SLI_CONFIG	= 0x9b,
> +	MBX_CMD_UNREG_FCFI	= 0xa2,
> +	MBX_CMD_UNREG_RPI	= 0x14,
> +	MBX_CMD_UNREG_VFI	= 0xa1,
> +	MBX_CMD_UNREG_VPI	= 0x97,
> +	MBX_CMD_WRITE_NVPARMS	= 0x03,
> +	MBX_CMD_CFG_AUTO_XFER_RDY = 0xAD,
> +
> +	MBX_STATUS_SUCCESS	= 0x0000,
> +	MBX_STATUS_FAILURE	= 0x0001,
> +	MBX_STATUS_RPI_NOT_REG	= 0x1400,
> +};
> +
> +/**
> + * @brief CONFIG_LINK
> + */
> +enum {
> +	SLI4_CFG_LINK_BBSCN = 0xf00,
> +	SLI4_CFG_LINK_CSCN  = 0x1000,
> +};
> +
> +struct sli4_cmd_config_link_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	u8		maxbbc;		/* Max buffer-to-buffer credit */

Why stopping here documention the members?

> +	u8		rsvd5;
> +	u8		rsvd6;
> +	u8		rsvd7;
> +	u8		alpa;
> +	__le16		n_port_id;
> +	u8		rsvd11;
> +	__le32		rsvd12;
> +	__le32		e_d_tov;
> +	__le32		lp_tov;
> +	__le32		r_a_tov;
> +	__le32		r_t_tov;
> +	__le32		al_tov;
> +	__le32		rsvd36;
> +	/*
> +	 * Buffer-to-buffer state change number
> +	 * Configure BBSCN
> +	 */
> +	__le32		bbscn_dword;
> +};
> +
> +/**
> + * @brief DUMP Type 4
> + */
> +enum {
> +	SLI4_DUMP4_TYPE = 0xf,
> +};
> +
> +#define SLI4_WKI_TAG_SAT_TEM 0x1040
> +
> +struct sli4_cmd_dump4_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	__le32		type_dword;
> +	__le16		wki_selection;
> +	__le16		rsvd10;
> +	__le32		rsvd12;
> +	__le32		returned_byte_cnt;
> +	__le32		resp_data[59];
> +};
> +
> +/* INIT_LINK - initialize the link for a FC port */
> +#define FC_TOPOLOGY_FCAL	0
> +#define FC_TOPOLOGY_P2P		1
> +
> +#define SLI4_INIT_LINK_F_LOOP_BACK	(1 << 0)
> +#define SLI4_INIT_LINK_F_UNFAIR		(1 << 6)
> +#define SLI4_INIT_LINK_F_NO_LIRP	(1 << 7)
> +#define SLI4_INIT_LINK_F_LOOP_VALID_CHK	(1 << 8)
> +#define SLI4_INIT_LINK_F_NO_LISA	(1 << 9)
> +#define SLI4_INIT_LINK_F_FAIL_OVER	(1 << 10)
> +#define SLI4_INIT_LINK_F_NO_AUTOSPEED	(1 << 11)
> +#define SLI4_INIT_LINK_F_PICK_HI_ALPA	(1 << 15)
> +
> +#define SLI4_INIT_LINK_F_P2P_ONLY	1
> +#define SLI4_INIT_LINK_F_FCAL_ONLY	2
> +
> +#define SLI4_INIT_LINK_F_FCAL_FAIL_OVER	0
> +#define SLI4_INIT_LINK_F_P2P_FAIL_OVER	1
> +
> +enum {
> +	SLI4_INIT_LINK_SEL_RESET_AL_PA = 0xff,
> +	SLI4_INIT_LINK_FLAG_LOOPBACK = 0x1,
> +	SLI4_INIT_LINK_FLAG_TOPOLOGY = 0x6,
> +	SLI4_INIT_LINK_FLAG_UNFAIR   = 0x40,
> +	SLI4_INIT_LINK_FLAG_SKIP_LIRP_LILP = 0x80,
> +	SLI4_INIT_LINK_FLAG_LOOP_VALIDITY = 0x100,
> +	SLI4_INIT_LINK_FLAG_SKIP_LISA = 0x200,
> +	SLI4_INIT_LINK_FLAG_EN_TOPO_FAILOVER = 0x400,
> +	SLI4_INIT_LINK_FLAG_FIXED_SPEED = 0x800,
> +	SLI4_INIT_LINK_FLAG_SEL_HIGHTEST_AL_PA = 0x8000,
> +};
> +
> +struct sli4_cmd_init_link_s {
> +	struct sli4_mbox_command_header_s       hdr;
> +	__le32	sel_reset_al_pa_dword;
> +	__le32	flags0;
> +	__le32	link_speed_sel_code;
> +#define FC_LINK_SPEED_1G		1
> +#define FC_LINK_SPEED_2G		2
> +#define FC_LINK_SPEED_AUTO_1_2		3
> +#define FC_LINK_SPEED_4G		4
> +#define FC_LINK_SPEED_AUTO_4_1		5
> +#define FC_LINK_SPEED_AUTO_4_2		6
> +#define FC_LINK_SPEED_AUTO_4_2_1	7
> +#define FC_LINK_SPEED_8G		8
> +#define FC_LINK_SPEED_AUTO_8_1		9
> +#define FC_LINK_SPEED_AUTO_8_2		10
> +#define FC_LINK_SPEED_AUTO_8_2_1	11
> +#define FC_LINK_SPEED_AUTO_8_4		12
> +#define FC_LINK_SPEED_AUTO_8_4_1	13
> +#define FC_LINK_SPEED_AUTO_8_4_2	14
> +#define FC_LINK_SPEED_10G		16
> +#define FC_LINK_SPEED_16G		17
> +#define FC_LINK_SPEED_AUTO_16_8_4	18
> +#define FC_LINK_SPEED_AUTO_16_8		19
> +#define FC_LINK_SPEED_32G		20
> +#define FC_LINK_SPEED_AUTO_32_16_8	21
> +#define FC_LINK_SPEED_AUTO_32_16	22
> +};

I would move the defines in front of the struct.

> +
> +/**
> + * @brief INIT_VFI - initialize the VFI resource
> + */
> +enum {
> +	SLI4_INIT_VFI_FLAG_VP = 0x1000,		/* DW1W1 */
> +	SLI4_INIT_VFI_FLAG_VF = 0x2000,
> +	SLI4_INIT_VFI_FLAG_VT = 0x4000,
> +	SLI4_INIT_VFI_FLAG_VR = 0x8000,
> +
> +	SLI4_INIT_VFI_VFID	 = 0x1fff,	/* DW3W0 */
> +	SLI4_INIT_VFI_PRI	 = 0xe000,
> +
> +	SLI4_INIT_VFI_HOP_COUNT = 0xff000000,	/* DW4 */
> +};

I would align all the '='.

> +
> +struct sli4_cmd_init_vfi_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	__le16		vfi;
> +	__le16		flags0_word;
> +	__le16		fcfi;
> +	__le16		vpi;
> +	__le32		vf_id_pri_dword;
> +	__le32		hop_cnt_dword;
> +};
> +
> +/**
> + * @brief INIT_VPI - initialize the VPI resource
> + */
> +struct sli4_cmd_init_vpi_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	__le16		vpi;
> +	__le16		vfi;
> +};
> +
> +/**
> + * @brief POST_XRI - post XRI resources to the SLI Port
> + */
> +enum {
> +	SLI4_POST_XRI_COUNT	= 0xfff,	/* DW1W1 */
> +	SLI4_POST_XRI_FLAG_ENX	= 0x1000,
> +	SLI4_POST_XRI_FLAG_DL	= 0x2000,
> +	SLI4_POST_XRI_FLAG_DI	= 0x4000,
> +	SLI4_POST_XRI_FLAG_VAL	= 0x8000,
> +};
> +
> +struct sli4_cmd_post_xri_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	__le16		xri_base;
> +	__le16		xri_count_flags;
> +};
> +
> +/**
> + * @brief RELEASE_XRI - Release XRI resources from the SLI Port
> + */
> +enum {
> +	SLI4_RELEASE_XRI_REL_XRI_CNT	= 0x1f,	/* DW1W0 */
> +	SLI4_RELEASE_XRI_COUNT		= 0x1f,	/* DW1W1 */
> +};
> +
> +struct sli4_cmd_release_xri_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	__le16		rel_xri_count_word;
> +	__le16		xri_count_word;
> +
> +	struct {
> +		__le16	xri_tag0;
> +		__le16	xri_tag1;
> +	} xri_tbl[62];
> +};
> +
> +/**
> + * @brief READ_CONFIG - read SLI port configuration parameters
> + */
> +struct sli4_cmd_read_config_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +};
> +
> +enum {
> +	SLI4_READ_CFG_RESP_RESOURCE_EXT = 0x80000000,	/* DW1 */
> +	SLI4_READ_CFG_RESP_TOPOLOGY = 0xff000000,	/* DW2 */
> +};
> +
> +struct sli4_rsp_read_config_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	__le32		ext_dword;
> +	__le32		topology_dword;
> +	__le32		resvd8;
> +	__le16		e_d_tov;
> +	__le16		resvd14;
> +	__le32		resvd16;
> +	__le16		r_a_tov;
> +	__le16		resvd22;
> +	__le32		resvd24;
> +	__le32		resvd28;
> +	__le16		lmt;
> +	__le16		resvd34;
> +	__le32		resvd36;
> +	__le32		resvd40;
> +	__le16		xri_base;
> +	__le16		xri_count;
> +	__le16		rpi_base;
> +	__le16		rpi_count;
> +	__le16		vpi_base;
> +	__le16		vpi_count;
> +	__le16		vfi_base;
> +	__le16		vfi_count;
> +	__le16		resvd60;
> +	__le16		fcfi_count;
> +	__le16		rq_count;
> +	__le16		eq_count;
> +	__le16		wq_count;
> +	__le16		cq_count;
> +	__le32		pad[45];
> +};
> +
> +#define SLI4_READ_CFG_TOPO_FC		0x1	/** FC topology unknown */
> +#define SLI4_READ_CFG_TOPO_FC_DA	0x2 /* FC Direct Attach (non FC-AL) */
> +#define SLI4_READ_CFG_TOPO_FC_AL	0x3	/** FC-AL topology */

The comments are not aligned.

> + * @brief READ_NVPARMS - read SLI port configuration parameters
> + */
> +
> +enum {
> +	SLI4_READ_NVPARAMS_HARD_ALPA	  = 0xff,
> +	SLI4_READ_NVPARAMS_PREFERRED_D_ID = 0xffffff00,
> +};
> +
> +struct sli4_cmd_read_nvparms_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	__le32		resvd0;
> +	__le32		resvd4;
> +	__le32		resvd8;
> +	__le32		resvd12;
> +	u8		wwpn[8];
> +	u8		wwnn[8];
> +	__le32		hard_alpa_d_id;
> +};
> +
> +/**
> + * @brief WRITE_NVPARMS - write SLI port configuration parameters
> + */
> +struct sli4_cmd_write_nvparms_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	__le32		resvd0;
> +	__le32		resvd4;
> +	__le32		resvd8;
> +	__le32		resvd12;
> +	u8		wwpn[8];
> +	u8		wwnn[8];
> +	__le32		hard_alpa_d_id;
> +};
> +
> +/**
> + * @brief READ_REV - read the Port revision levels
> + */
> +enum {
> +	SLI4_READ_REV_FLAG_SLI_LEVEL = 0xf,
> +	SLI4_READ_REV_FLAG_FCOEM	= 0x10,
> +	SLI4_READ_REV_FLAG_CEEV	= 0x60,
> +	SLI4_READ_REV_FLAG_VPD	= 0x2000,
> +
> +	SLI4_READ_REV_AVAILABLE_LENGTH = 0xffffff,
> +};

Also here I would align the '='.

> +
> +struct sli4_cmd_read_rev_s {
> +	struct sli4_mbox_command_header_s hdr;
> +	__le16		resvd0;
> +	__le16		flags0_word;
> +	__le32		first_hw_rev;
> +	__le32		second_hw_rev;
> +	__le32		resvd12;
> +	__le32		third_hw_rev;
> +	u8		fc_ph_low;
> +	u8		fc_ph_high;
> +	u8		feature_level_low;
> +	u8		feature_level_high;
> +	__le32		resvd24;
> +	__le32		first_fw_id;
> +	u8		first_fw_name[16];
> +	__le32		second_fw_id;
> +	u8		second_fw_name[16];
> +	__le32		rsvd18[30];
> +	__le32		available_length_dword;
> +	struct sli4_dmaaddr_s hostbuf;
> +	__le32		returned_vpd_length;
> +	__le32		actual_vpd_length;
> +};
> +
> +/**
> + * @brief READ_SPARM64 - read the Port service parameters
> + */
> +struct sli4_cmd_read_sparm64_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	__le32		resvd0;
> +	__le32		resvd4;
> +	struct sli4_bde_s	bde_64;
> +	__le16		vpi;
> +	__le16		resvd22;
> +	__le16		port_name_start;
> +	__le16		port_name_len;
> +	__le16		node_name_start;
> +	__le16		node_name_len;
> +};

I would also ident all members (except hdr I guess) to the same level.

> +
> +#define SLI4_READ_SPARM64_VPI_DEFAULT	0
> +#define SLI4_READ_SPARM64_VPI_SPECIAL	U16_MAX
> +
> +#define SLI4_READ_SPARM64_WWPN_OFFSET	(4 * sizeof(u32))
> +#define SLI4_READ_SPARM64_WWNN_OFFSET	(SLI4_READ_SPARM64_WWPN_OFFSET \
> +					+ sizeof(uint64_t))
> +/**
> + * @brief READ_TOPOLOGY - read the link event information
> + */
> +enum {
> +	SLI4_READTOPO_ATTEN_TYPE	= 0xff,		/* DW2 */
> +	SLI4_READTOPO_FLAG_IL		= 0x100,
> +	SLI4_READTOPO_FLAG_PB_RECVD	= 0x200,
> +
> +	SLI4_READTOPO_LINKSTATE_RECV	= 0x3,
> +	SLI4_READTOPO_LINKSTATE_TRANS	= 0xc,
> +	SLI4_READTOPO_LINKSTATE_MACHINE	= 0xf0,
> +	SLI4_READTOPO_LINKSTATE_SPEED	= 0xff00,
> +	SLI4_READTOPO_LINKSTATE_TF	= 0x40000000,
> +	SLI4_READTOPO_LINKSTATE_LU	= 0x80000000,
> +
> +	SLI4_READTOPO_SCN_BBSCN		= 0xf,		/* DW9W1B0 */
> +	SLI4_READTOPO_SCN_CBBSCN	= 0xf0,
> +
> +	SLI4_READTOPO_R_T_TOV		= 0x1ff,	/* DW10WO */
> +	SLI4_READTOPO_AL_TOV		= 0xf000,
> +
> +	SLI4_READTOPO_PB_FLAG		= 0x80,
> +
> +	SLI4_READTOPO_INIT_N_PORTID	= 0xffffff,
> +};
> +
> +struct sli4_cmd_read_topology_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	__le32		event_tag;
> +	__le32		dw2_attentype;
> +	u8		topology;
> +	u8		lip_type;
> +	u8		lip_al_ps;
> +	u8		al_pa_granted;
> +	struct sli4_bde_s	bde_loop_map;
> +	__le32		linkdown_state;
> +	__le32		currlink_state;
> +	u8		max_bbc;
> +	u8		init_bbc;
> +	u8		scn_flags;
> +	u8		rsvd39;
> +	__le16		dw10w0_al_rt_tov;
> +	__le16		lp_tov;
> +	u8		acquired_al_pa;
> +	u8		pb_flags;
> +	__le16		specified_al_pa;
> +	__le32		dw12_init_n_port_id;
> +};

also here same ident level for all (except hdr, I suppose).

> +
> +#define SLI4_MIN_LOOP_MAP_BYTES	128
> +
> +#define SLI4_READ_TOPOLOGY_LINK_UP	0x1
> +#define SLI4_READ_TOPOLOGY_LINK_DOWN	0x2
> +#define SLI4_READ_TOPOLOGY_LINK_NO_ALPA	0x3
> +
> +#define SLI4_READ_TOPOLOGY_UNKNOWN	0x0
> +#define SLI4_READ_TOPOLOGY_NPORT	0x1
> +#define SLI4_READ_TOPOLOGY_FC_AL	0x2
> +
> +#define SLI4_READ_TOPOLOGY_SPEED_NONE	0x00
> +#define SLI4_READ_TOPOLOGY_SPEED_1G	0x04
> +#define SLI4_READ_TOPOLOGY_SPEED_2G	0x08
> +#define SLI4_READ_TOPOLOGY_SPEED_4G	0x10
> +#define SLI4_READ_TOPOLOGY_SPEED_8G	0x20
> +#define SLI4_READ_TOPOLOGY_SPEED_10G	0x40
> +#define SLI4_READ_TOPOLOGY_SPEED_16G	0x80
> +#define SLI4_READ_TOPOLOGY_SPEED_32G	0x90
> +
> +/**
> + * @brief REG_FCFI - activate a FC Forwarder
> + */
> +struct sli4_cmd_reg_fcfi_rq_cfg {
> +	u8	r_ctl_mask;
> +	u8	r_ctl_match;
> +	u8	type_mask;
> +	u8	type_match;
> +};
> +
> +enum {
> +	SLI4_REGFCFI_VLAN_TAG		= 0xfff,
> +	SLI4_REGFCFI_VLANTAG_VALID	= 0x1000,
> +};
> +
> +#define SLI4_CMD_REG_FCFI_NUM_RQ_CFG	4
> +struct sli4_cmd_reg_fcfi_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	__le16		fcf_index;
> +	__le16		fcfi;
> +	__le16		rqid1;
> +	__le16		rqid0;
> +	__le16		rqid3;
> +	__le16		rqid2;
> +	struct sli4_cmd_reg_fcfi_rq_cfg rq_cfg[SLI4_CMD_REG_FCFI_NUM_RQ_CFG];

below in struct sli4_cmd_reg_fcfi_mrq_s the member is on a new line,
maybe make it here too? Consistency :)

> +	__le32		dw8_vlan;
> +};
> +
> +#define SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG	4
> +#define SLI4_CMD_REG_FCFI_MRQ_MAX_NUM_RQ	32
> +#define SLI4_CMD_REG_FCFI_SET_FCFI_MODE		0
> +#define SLI4_CMD_REG_FCFI_SET_MRQ_MODE		1
> +
> +enum {
> +	SLI4_REGFCFI_MRQ_VLAN_TAG	= 0xfff,
> +	SLI4_REGFCFI_MRQ_VLANTAG_VALID	= 0x1000,
> +	SLI4_REGFCFI_MRQ_MODE		= 0x2000,
> +
> +	SLI4_REGFCFI_MRQ_MASK_NUM_PAIRS	= 0xff,
> +	SLI4_REGFCFI_MRQ_FILTER_BITMASK = 0xf00,
> +	SLI4_REGFCFI_MRQ_RQ_SEL_POLICY	= 0xf000,
> +};
> +
> +struct sli4_cmd_reg_fcfi_mrq_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	__le16		fcf_index;
> +	__le16		fcfi;
> +	__le16		rqid1;
> +	__le16		rqid0;
> +	__le16		rqid3;
> +	__le16		rqid2;
> +	struct sli4_cmd_reg_fcfi_rq_cfg
> +				rq_cfg[SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG];
> +	__le32		dw8_vlan;
> +	__le32		dw9_mrqflags;
> +};
> +
> +/**
> + * @brief REG_RPI - register a Remote Port Indicator
> + */
> +enum {
> +	SLI4_REGRPI_REMOTE_N_PORTID	= 0xffffff,	/* DW2 */
> +	SLI4_REGRPI_UPD			= 0x1000000,
> +	SLI4_REGRPI_ETOW		= 0x8000000,
> +	SLI4_REGRPI_TERP		= 0x20000000,
> +	SLI4_REGRPI_CI			= 0x80000000,
> +};
> +
> +struct sli4_cmd_reg_rpi_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	__le16		rpi;
> +	__le16		rsvd2;
> +	__le32		dw2_rportid_flags;
> +	struct sli4_bde_s	bde_64;
> +	__le16		vpi;
> +	__le16		rsvd26;
> +};

Again all members the same ident level?

> +
> +#define SLI4_REG_RPI_BUF_LEN			0x70
> +
> +/**
> + * @brief REG_VFI - register a Virtual Fabric Indicator
> + */
> +enum {
> +	SLI4_REGVFI_VP		= 0x1000,	/* DW1 */
> +	SLI4_REGVFI_UPD		= 0x2000,
> +
> +	SLI4_REGVFI_LOCAL_N_PORTID = 0xffffff,	/* DW10 */
> +};

ditto.

> +
> +struct sli4_cmd_reg_vfi_s {
> +	struct sli4_mbox_command_header_s	hdr;
> +	__le16		vfi;
> +	__le16		dw0w1_flags;
> +	__le16		fcfi;
> +	__le16		vpi;			/* vp=TRUE */
> +	u8		wwpn[8];
> +	struct sli4_bde_s sparm;
> +	__le32		e_d_tov;
> +	__le32		r_a_tov;
> +	__le32		dw10_lportid_flags;
> +};

and here.

> +/**
> + * @brief COMMON_GET_SLI4_PARAMETERS
> + */
> +
> +#define GET_Q_CNT_METHOD(val)\
> +	((val & RSP_GET_PARAM_Q_CNT_MTHD_MASK)\
> +	>> RSP_GET_PARAM_Q_CNT_MTHD_SHFT)
> +#define GET_Q_CREATE_VERSION(val)\
> +	((val & RSP_GET_PARAM_QV_MASK)\
> +	>> RSP_GET_PARAM_QV_SHIFT)

This time there is no space in front of '\'. Does the expresssion not
fit on one line? Would be easier to read:

#define GET_Q_CREATE_VERSION(val) \
	((val & RSP_GET_PARAM_QV_MASK) >> RSP_GET_PARAM_QV_SHIFT)


> +#define SLI4_FUNCTION_MODE_INI_MODE 0x40
> +#define SLI4_FUNCTION_MODE_TGT_MODE 0x80
> +#define SLI4_FUNCTION_MODE_DUA_MODE      0x800

Just one space between _MODE and 0x800

> +struct sli4_rqst_cmn_read_object_s {
> +	struct sli4_rqst_hdr_s	hdr;
> +	__le32		desired_read_length_dword;
> +	__le32		read_offset;
> +	u8		object_name[104];
> +	__le32		host_buffer_descriptor_count;
> +	struct sli4_bde_s	host_buffer_descriptor[0];
> +};

Same ident for all members?

> +
> +enum {
> +	RSP_COM_READ_OBJ_EOF = 0x80000000
> +
> +};
> +
> +struct sli4_rsp_cmn_read_object_s {
> +	struct sli4_rsp_hdr_s	hdr;
> +	__le32		actual_read_length;
> +	__le32		eof_dword;
> +};

Also here?

> +/**
> + * @brief COMMON_WRITE_OBJECT
> + */
> +
> +enum {
> +	SLI4_RQ_DES_WRITE_LEN = 0xFFFFFF,
> +	SLI4_RQ_DES_WRITE_LEN_NOC = 0x40000000,
> +	SLI4_RQ_DES_WRITE_LEN_EOF = 0x80000000
> +
> +};

New line too much and I would also add the ',' to the last member as
it was done above.  Furhtermore aligment of '='?

> +
> +struct sli4_rqst_cmn_write_object_s {
> +	struct sli4_rqst_hdr_s	hdr;
> +	__le32		desired_write_len_dword;
> +	__le32		write_offset;
> +	u8		object_name[104];
> +	__le32		host_buffer_descriptor_count;
> +	struct sli4_bde_s	host_buffer_descriptor[0];
> +};

Aligment of the members?

> +enum {
> +	RSP_CHANGE_STATUS = 0xFF
> +
> +};

One newline too much and ',' on the member?

> +
> +struct sli4_rsp_cmn_write_object_s {
> +	struct sli4_rsp_hdr_s	hdr;
> +	__le32		actual_write_length;
> +	__le32		change_status_dword;
> +};

One more aligment thingy

> +
> +/**
> + * @brief COMMON_DELETE_OBJECT
> + */
> +struct sli4_rqst_cmn_delete_object_s {
> +	struct sli4_rqst_hdr_s	hdr;
> +	__le32		rsvd4;
> +	__le32		rsvd5;
> +	u8		object_name[104];
> +};
> +
> +/**
> + * @brief COMMON_READ_OBJECT_LIST
> + */
> +
> +enum {
> +	SLI4_RQ_OBJ_LIST_READ_LEN = 0xFFFFFF
> +
> +};

Newline too much and and missing ','

> +
> +struct sli4_rqst_cmn_read_object_list_s {
> +	struct sli4_rqst_hdr_s	hdr;
> +	__le32		desired_read_length_dword;
> +	__le32		read_offset;
> +	u8		object_name[104];
> +	__le32		host_buffer_descriptor_count;
> +	struct sli4_bde_s	host_buffer_descriptor[0];
> +};

aliment of the members

> +
> +/**
> + * @brief COMMON_SET_DUMP_LOCATION
> + */
> +
> +enum {
> +	SLI4_RQ_COM_SET_DUMP_BUFFER_LEN = 0xFFFFFF,
> +	SLI4_RQ_COM_SET_DUMP_FDB = 0x20000000,
> +	SLI4_RQ_COM_SET_DUMP_BLP = 0x40000000,
> +	SLI4_RQ_COM_SET_DUMP_QRY = 0x80000000,
> +
> +};

Newline too much

> +
> +struct sli4_rqst_cmn_set_dump_location_s {
> +	struct sli4_rqst_hdr_s	hdr;
> +	__le32		buffer_length_dword;
> +	__le32		buf_addr_low;
> +	__le32		buf_addr_high;
> +};

same comment as above

> +
> +enum {
> +	RSP_SET_DUMP_BUFFER_LEN = 0xFFFFFF
> +
> +};

same comment as above

> +
> +struct sli4_rsp_cmn_set_dump_location_s {
> +	struct sli4_rsp_hdr_s	hdr;
> +	__le32		buffer_length_dword;
> +};

same comment as above

> +
> +/**
> + * @brief COMMON_SET_SET_FEATURES
> + */
> +#define SLI4_SET_FEATURES_DIF_SEED			0x01
> +#define SLI4_SET_FEATURES_XRI_TIMER			0x03
> +#define SLI4_SET_FEATURES_MAX_PCIE_SPEED		0x04
> +#define SLI4_SET_FEATURES_FCTL_CHECK			0x05
> +#define SLI4_SET_FEATURES_FEC				0x06
> +#define SLI4_SET_FEATURES_PCIE_RECV_DETECT		0x07
> +#define SLI4_SET_FEATURES_DIF_MEMORY_MODE		0x08
> +#define SLI4_SET_FEATURES_DISABLE_SLI_PORT_PAUSE_STATE	0x09
> +#define SLI4_SET_FEATURES_ENABLE_PCIE_OPTIONS		0x0A
> +#define SLI4_SET_FEAT_CFG_AUTO_XFER_RDY_T10PI	0x0C
> +#define SLI4_SET_FEATURES_ENABLE_MULTI_RECEIVE_QUEUE	0x0D
> +#define SLI4_SET_FEATURES_SET_FTD_XFER_HINT		0x0F
> +#define SLI4_SET_FEATURES_SLI_PORT_HEALTH_CHECK		0x11
> +
> +struct sli4_rqst_cmn_set_features_s {
> +	struct sli4_rqst_hdr_s	hdr;
> +	__le32		feature;
> +	__le32		param_len;
> +	__le32		params[8];
> +};

same comment as above

> +
> +struct sli4_rqst_cmn_set_features_dif_seed_s {
> +	__le16		seed;
> +	__le16		rsvd16;
> +};
> +
> +enum {
> +	SLI4_RQ_COM_SET_T10_PI_MEM_MODEL = 0x1
> +
> +};

same comment as above

> +
> +struct sli4_rqst_cmn_set_features_t10_pi_mem_model_s {
> +	__le32		tmm_dword;
> +};
> +
> +enum {
> +	SLI4_RQ_MULTIRQ_ISR = 0x1,
> +	SLI4_RQ_MULTIRQ_AUTOGEN_XFER_RDY = 0x2,
> +
> +	SLI4_RQ_MULTIRQ_NUM_RQS = 0xFF,
> +	SLI4_RQ_MULTIRQ_RQ_SELECT = 0xF00
> +};

aligment of '='?

> +
> +struct sli4_rqst_cmn_set_features_multirq_s {
> +	__le32		auto_gen_xfer_dword; /* Include Sequence Reporting */
> +					/* Auto Generate XFER-RDY Enabled */
> +	__le32		num_rqs_dword;
> +};

Aligment of the comment?

> +
> +enum {
> +	SLI4_SETFEAT_XFERRDY_T10PI_RTC	= (1 << 0),	/* DW0 */
> +	SLI4_SETFEAT_XFERRDY_T10PI_ATV	= (1 << 1),
> +	SLI4_SETFEAT_XFERRDY_T10PI_TMM	= (1 << 2),
> +	SLI4_SETFEAT_XFERRDY_T10PI_PTYPE = (0x7 << 4),
> +	SLI4_SETFEAT_XFERRDY_T10PI_BLKSIZ = (0x7 << 7),
> +};

Aligment of the '='

> +
> +struct sli4_rqst_cmn_set_features_xfer_rdy_t10pi_s {
> +	__le32		dw0_flags;
> +	__le16		app_tag;
> +	__le16		rsvd6;
> +};
> +
> +enum {
> +	SLI4_RQ_HEALTH_CHECK_ENABLE = 0x1,
> +	SLI4_RQ_HEALTH_CHECK_QUERY = 0x2
> +
> +};

Newline and missing ',' on the last entry.

I stop here pointing out the same issues for the rest of this
patch. There are few more of those alignment issues in my opinion.q

> +struct sli4_s {
> +	void	*os;
> +	struct pci_dev	*pcidev;
> +#define	SLI_PCI_MAX_REGS		6

I would move the define in front of the struct.

> +	void __iomem *reg[SLI_PCI_MAX_REGS];
> +

Thanks,
Daniel
