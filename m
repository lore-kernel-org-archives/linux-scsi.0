Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D44EC2BA19
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 19:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E12C0206A2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 19:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504598AbgDNTB7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 15:01:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:49324 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504595AbgDNTB4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Apr 2020 15:01:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8AE1EAD9A;
        Tue, 14 Apr 2020 19:01:51 +0000 (UTC)
Date:   Tue, 14 Apr 2020 21:01:51 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 03/31] elx: libefc_sli: Data structures and defines
 for mbox commands
Message-ID: <20200414190151.wziq4wnal5sotgqy@carbon.lan>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-4-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412033303.29574-4-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Sat, Apr 11, 2020 at 08:32:35PM -0700, James Smart wrote:
> This patch continues the libefc_sli SLI-4 library population.
> 
> This patch adds definitions for SLI-4 mailbox commands
> and responses.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>   Changed anonymous enums to named.
>   Split gaint enums into multiple enums.
>   Single Enum to #define
>   Added Link Speed defines to accommodate upto 128G
>   SLI defines to spell out _MASK value directly.
>   Changed multiple defines to named Enums for consistency.
> ---
>  drivers/scsi/elx/libefc_sli/sli4.h | 1677 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 1677 insertions(+)
> 
> diff --git a/drivers/scsi/elx/libefc_sli/sli4.h b/drivers/scsi/elx/libefc_sli/sli4.h
> index 07eef8df9690..b360d809f144 100644
> --- a/drivers/scsi/elx/libefc_sli/sli4.h
> +++ b/drivers/scsi/elx/libefc_sli/sli4.h
> @@ -2010,4 +2010,1681 @@ enum sli4_els_cmd_type {
>  	SLI4_ELS_REQUEST64_CMD_FABRIC		= 0x0d,
>  };
>  
> +#define SLI_PAGE_SIZE				(1 << 12)	/* 4096 */

Could you add a comment why you need this definitionw and why it's not
PAGE_SIZE? From starring at the code I think it has someting todo with
SLI4_RQ_PAGE_SIZE_4096, but it's definitly not obvious for me how
those address calculation work.

> +#define SLI_SUB_PAGE_MASK			(SLI_PAGE_SIZE - 1)
> +#define SLI_ROUND_PAGE(b)	(((b) + SLI_SUB_PAGE_MASK) & ~SLI_SUB_PAGE_MASK)

Couldn't you use round_up() instead defining SLI_SUB_PAGE_MASK and
SLI_ROUND_PAGE?


> +#define SLI4_BMBX_TIMEOUT_MSEC			30000
> +#define SLI4_FW_READY_TIMEOUT_MSEC		30000
> +
> +#define SLI4_BMBX_DELAY_US			1000	/* 1 ms */
> +#define SLI4_INIT_PORT_DELAY_US			10000	/* 10 ms */
> +
> +static inline u32
> +sli_page_count(size_t bytes, u32 page_size)
> +{
> +	if (!page_size)
> +		return 0;
> +
> +	return (bytes + (page_size - 1)) >> __ffs(page_size);
> +}
> +
> +/*************************************************************************
> + * SLI-4 mailbox command formats and definitions
> + */
> +
> +struct sli4_mbox_command_header {
> +	u8	resvd0;
> +	u8	command;
> +	__le16	status;	/* Port writes to indicate success/fail */
> +};
> +
> +enum sli4_mbx_cmd_value {
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

s/0xAD/0xad/

> +};
> +
> +enum sli4_mbx_status {
> +	MBX_STATUS_SUCCESS	= 0x0000,
> +	MBX_STATUS_FAILURE	= 0x0001,
> +	MBX_STATUS_RPI_NOT_REG	= 0x1400,
> +};
> +
> +/* CONFIG_LINK */

This is not a Kconfig CONFIG flag, correct? Maybe make the comment a
bit more verbose explaining what it means.

> +enum sli4_cmd_config_link_flags {
> +	SLI4_CFG_LINK_BBSCN = 0xf00,
> +	SLI4_CFG_LINK_CSCN  = 0x1000,
> +};
> +
> +struct sli4_cmd_config_link {
> +	struct sli4_mbox_command_header	hdr;
> +	u8		maxbbc;
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
> +	__le32		bbscn_dword;
> +};
> +
> +#define SLI4_DUMP4_TYPE		0xf
> +
> +#define SLI4_WKI_TAG_SAT_TEM	0x1040
> +
> +struct sli4_cmd_dump4 {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32		type_dword;
> +	__le16		wki_selection;
> +	__le16		rsvd10;
> +	__le32		rsvd12;
> +	__le32		returned_byte_cnt;
> +	__le32		resp_data[59];
> +};
> +
> +/* INIT_LINK - initialize the link for a FC port */
> +enum sli4_init_link_flags {
> +	SLI4_INIT_LINK_F_LOOPBACK	= (1 << 0),
> +
> +	SLI4_INIT_LINK_F_P2P_ONLY	= (1 << 1),
> +	SLI4_INIT_LINK_F_FCAL_ONLY	= (2 << 1),
> +	SLI4_INIT_LINK_F_FCAL_FAIL_OVER	= (0 << 1),
> +	SLI4_INIT_LINK_F_P2P_FAIL_OVER	= (1 << 1),
> +
> +	SLI4_INIT_LINK_F_UNFAIR		= (1 << 6),
> +	SLI4_INIT_LINK_F_NO_LIRP	= (1 << 7),
> +	SLI4_INIT_LINK_F_LOOP_VALID_CHK	= (1 << 8),
> +	SLI4_INIT_LINK_F_NO_LISA	= (1 << 9),
> +	SLI4_INIT_LINK_F_FAIL_OVER	= (1 << 10),
> +	SLI4_INIT_LINK_F_FIXED_SPEED	= (1 << 11),
> +	SLI4_INIT_LINK_F_PICK_HI_ALPA	= (1 << 15),
> +
> +};
> +
> +enum sli4_fc_link_speed {
> +	FC_LINK_SPEED_1G = 1,
> +	FC_LINK_SPEED_2G,
> +	FC_LINK_SPEED_AUTO_1_2,
> +	FC_LINK_SPEED_4G,
> +	FC_LINK_SPEED_AUTO_4_1,
> +	FC_LINK_SPEED_AUTO_4_2,
> +	FC_LINK_SPEED_AUTO_4_2_1,
> +	FC_LINK_SPEED_8G,
> +	FC_LINK_SPEED_AUTO_8_1,
> +	FC_LINK_SPEED_AUTO_8_2,
> +	FC_LINK_SPEED_AUTO_8_2_1,
> +	FC_LINK_SPEED_AUTO_8_4,
> +	FC_LINK_SPEED_AUTO_8_4_1,
> +	FC_LINK_SPEED_AUTO_8_4_2,
> +	FC_LINK_SPEED_10G,
> +	FC_LINK_SPEED_16G,
> +	FC_LINK_SPEED_AUTO_16_8_4,
> +	FC_LINK_SPEED_AUTO_16_8,
> +	FC_LINK_SPEED_32G,
> +	FC_LINK_SPEED_AUTO_32_16_8,
> +	FC_LINK_SPEED_AUTO_32_16,
> +	FC_LINK_SPEED_64G,
> +	FC_LINK_SPEED_AUTO_64_32_16,
> +	FC_LINK_SPEED_AUTO_64_32,
> +	FC_LINK_SPEED_128G,
> +	FC_LINK_SPEED_AUTO_128_64_32,
> +	FC_LINK_SPEED_AUTO_128_64,
> +};
> +
> +struct sli4_cmd_init_link {
> +	struct sli4_mbox_command_header       hdr;
> +	__le32	sel_reset_al_pa_dword;
> +	__le32	flags0;
> +	__le32	link_speed_sel_code;
> +};
> +
> +/* INIT_VFI - initialize the VFI resource */
> +enum sli4_init_vfi_flags {
> +	SLI4_INIT_VFI_FLAG_VP	= 0x1000,
> +	SLI4_INIT_VFI_FLAG_VF	= 0x2000,
> +	SLI4_INIT_VFI_FLAG_VT	= 0x4000,
> +	SLI4_INIT_VFI_FLAG_VR	= 0x8000,
> +
> +	SLI4_INIT_VFI_VFID	= 0x1fff,
> +	SLI4_INIT_VFI_PRI	= 0xe000,
> +
> +	SLI4_INIT_VFI_HOP_COUNT = 0xff000000,
> +};
> +
> +struct sli4_cmd_init_vfi {
> +	struct sli4_mbox_command_header	hdr;
> +	__le16		vfi;
> +	__le16		flags0_word;
> +	__le16		fcfi;
> +	__le16		vpi;
> +	__le32		vf_id_pri_dword;
> +	__le32		hop_cnt_dword;
> +};
> +
> +/* INIT_VPI - initialize the VPI resource */
> +struct sli4_cmd_init_vpi {
> +	struct sli4_mbox_command_header	hdr;
> +	__le16		vpi;
> +	__le16		vfi;
> +};
> +
> +/* POST_XRI - post XRI resources to the SLI Port */
> +enum sli4_post_xri_flags {
> +	SLI4_POST_XRI_COUNT	= 0xfff,
> +	SLI4_POST_XRI_FLAG_ENX	= 0x1000,
> +	SLI4_POST_XRI_FLAG_DL	= 0x2000,
> +	SLI4_POST_XRI_FLAG_DI	= 0x4000,
> +	SLI4_POST_XRI_FLAG_VAL	= 0x8000,
> +};
> +
> +struct sli4_cmd_post_xri {
> +	struct sli4_mbox_command_header	hdr;
> +	__le16		xri_base;
> +	__le16		xri_count_flags;
> +};
> +
> +/* RELEASE_XRI - Release XRI resources from the SLI Port */
> +enum sli4_release_xri_flags {
> +	SLI4_RELEASE_XRI_REL_XRI_CNT	= 0x1f,
> +	SLI4_RELEASE_XRI_COUNT		= 0x1f,
> +};
> +
> +struct sli4_cmd_release_xri {
> +	struct sli4_mbox_command_header	hdr;
> +	__le16		rel_xri_count_word;
> +	__le16		xri_count_word;
> +
> +	struct {
> +		__le16	xri_tag0;
> +		__le16	xri_tag1;
> +	} xri_tbl[62];
> +};
> +
> +/* READ_CONFIG - read SLI port configuration parameters */
> +struct sli4_cmd_read_config {
> +	struct sli4_mbox_command_header	hdr;
> +};
> +
> +enum sli4_read_cfg_resp_flags {
> +	SLI4_READ_CFG_RESP_RESOURCE_EXT = 0x80000000,	/* DW1 */
> +	SLI4_READ_CFG_RESP_TOPOLOGY	= 0xff000000,	/* DW2 */
> +};
> +
> +enum sli4_read_cfg_topo {
> +	SLI4_READ_CFG_TOPO_FC		= 0x1,	/* FC topology unknown */
> +	SLI4_READ_CFG_TOPO_FC_DA	= 0x2,	/* FC Direct Attach */
> +	SLI4_READ_CFG_TOPO_FC_AL	= 0x3,	/* FC-AL topology */
> +};
> +
> +struct sli4_rsp_read_config {
> +	struct sli4_mbox_command_header	hdr;
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
> +/* READ_NVPARMS - read SLI port configuration parameters */
> +enum sli4_read_nvparms_flags {
> +	SLI4_READ_NVPARAMS_HARD_ALPA	  = 0xff,
> +	SLI4_READ_NVPARAMS_PREFERRED_D_ID = 0xffffff00,
> +};
> +
> +struct sli4_cmd_read_nvparms {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32		resvd0;
> +	__le32		resvd4;
> +	__le32		resvd8;
> +	__le32		resvd12;
> +	u8		wwpn[8];
> +	u8		wwnn[8];
> +	__le32		hard_alpa_d_id;
> +};
> +
> +/* WRITE_NVPARMS - write SLI port configuration parameters */
> +struct sli4_cmd_write_nvparms {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32		resvd0;
> +	__le32		resvd4;
> +	__le32		resvd8;
> +	__le32		resvd12;
> +	u8		wwpn[8];
> +	u8		wwnn[8];
> +	__le32		hard_alpa_d_id;
> +};
> +
> +/* READ_REV - read the Port revision levels */
> +enum {
> +	SLI4_READ_REV_FLAG_SLI_LEVEL	= 0xf,
> +	SLI4_READ_REV_FLAG_FCOEM	= 0x10,
> +	SLI4_READ_REV_FLAG_CEEV		= 0x60,
> +	SLI4_READ_REV_FLAG_VPD		= 0x2000,
> +
> +	SLI4_READ_REV_AVAILABLE_LENGTH	= 0xffffff,
> +};
> +
> +struct sli4_cmd_read_rev {
> +	struct sli4_mbox_command_header	hdr;
> +	__le16			resvd0;
> +	__le16			flags0_word;
> +	__le32			first_hw_rev;
> +	__le32			second_hw_rev;
> +	__le32			resvd12;
> +	__le32			third_hw_rev;
> +	u8			fc_ph_low;
> +	u8			fc_ph_high;
> +	u8			feature_level_low;
> +	u8			feature_level_high;
> +	__le32			resvd24;
> +	__le32			first_fw_id;
> +	u8			first_fw_name[16];
> +	__le32			second_fw_id;
> +	u8			second_fw_name[16];
> +	__le32			rsvd18[30];
> +	__le32			available_length_dword;
> +	struct sli4_dmaaddr	hostbuf;
> +	__le32			returned_vpd_length;
> +	__le32			actual_vpd_length;
> +};
> +
> +/* READ_SPARM64 - read the Port service parameters */
> +#define SLI4_READ_SPARM64_WWPN_OFFSET	(4 * sizeof(u32))
> +#define SLI4_READ_SPARM64_WWNN_OFFSET	(6 * sizeof(u32))
> +
> +struct sli4_cmd_read_sparm64 {
> +	struct sli4_mbox_command_header hdr;
> +	__le32			resvd0;
> +	__le32			resvd4;
> +	struct sli4_bde	bde_64;

I find these kind of strange code indention pattern unnecessary. I
assume bde_64 is not indenteded as resvd4 because it is a struct.

> +	__le16			vpi;
> +	__le16			resvd22;
> +	__le16			port_name_start;
> +	__le16			port_name_len;
> +	__le16			node_name_start;
> +	__le16			node_name_len;
> +};
> +
> +/* READ_TOPOLOGY - read the link event information */
> +enum sli4_read_topo_e {
> +	SLI4_READTOPO_ATTEN_TYPE	= 0xff,
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
> +	SLI4_READTOPO_SCN_BBSCN		= 0xf,
> +	SLI4_READTOPO_SCN_CBBSCN	= 0xf0,
> +
> +	SLI4_READTOPO_R_T_TOV		= 0x1ff,
> +	SLI4_READTOPO_AL_TOV		= 0xf000,
> +
> +	SLI4_READTOPO_PB_FLAG		= 0x80,
> +
> +	SLI4_READTOPO_INIT_N_PORTID	= 0xffffff,
> +};
> +
> +#define SLI4_MIN_LOOP_MAP_BYTES	128
> +
> +struct sli4_cmd_read_topology {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32			event_tag;
> +	__le32			dw2_attentype;
> +	u8			topology;
> +	u8			lip_type;
> +	u8			lip_al_ps;
> +	u8			al_pa_granted;
> +	struct sli4_bde	bde_loop_map;

and here again

> +	__le32			linkdown_state;
> +	__le32			currlink_state;
> +	u8			max_bbc;
> +	u8			init_bbc;
> +	u8			scn_flags;
> +	u8			rsvd39;
> +	__le16			dw10w0_al_rt_tov;
> +	__le16			lp_tov;
> +	u8			acquired_al_pa;
> +	u8			pb_flags;
> +	__le16			specified_al_pa;
> +	__le32			dw12_init_n_port_id;
> +};
> +
> +enum sli4_read_topo_link {
> +	SLI4_READ_TOPOLOGY_LINK_UP	= 0x1,
> +	SLI4_READ_TOPOLOGY_LINK_DOWN,
> +	SLI4_READ_TOPOLOGY_LINK_NO_ALPA,
> +};
> +
> +enum sli4_read_topo {
> +	SLI4_READ_TOPOLOGY_UNKNOWN	= 0x0,
> +	SLI4_READ_TOPOLOGY_NPORT,
> +	SLI4_READ_TOPOLOGY_FC_AL,
> +};
> +
> +enum sli4_read_topo_speed {
> +	SLI4_READ_TOPOLOGY_SPEED_NONE	= 0x00,
> +	SLI4_READ_TOPOLOGY_SPEED_1G	= 0x04,
> +	SLI4_READ_TOPOLOGY_SPEED_2G	= 0x08,
> +	SLI4_READ_TOPOLOGY_SPEED_4G	= 0x10,
> +	SLI4_READ_TOPOLOGY_SPEED_8G	= 0x20,
> +	SLI4_READ_TOPOLOGY_SPEED_10G	= 0x40,
> +	SLI4_READ_TOPOLOGY_SPEED_16G	= 0x80,
> +	SLI4_READ_TOPOLOGY_SPEED_32G	= 0x90,
> +};
> +
> +/* REG_FCFI - activate a FC Forwarder */
> +struct sli4_cmd_reg_fcfi_rq_cfg {
> +	u8	r_ctl_mask;
> +	u8	r_ctl_match;
> +	u8	type_mask;
> +	u8	type_match;
> +};
> +
> +enum sli4_regfcfi_tag {
> +	SLI4_REGFCFI_VLAN_TAG		= 0xfff,
> +	SLI4_REGFCFI_VLANTAG_VALID	= 0x1000,
> +};
> +
> +#define SLI4_CMD_REG_FCFI_NUM_RQ_CFG	4
> +struct sli4_cmd_reg_fcfi {
> +	struct sli4_mbox_command_header	hdr;
> +	__le16		fcf_index;
> +	__le16		fcfi;
> +	__le16		rqid1;
> +	__le16		rqid0;
> +	__le16		rqid3;
> +	__le16		rqid2;
> +	struct sli4_cmd_reg_fcfi_rq_cfg
> +			rq_cfg[SLI4_CMD_REG_FCFI_NUM_RQ_CFG];

and here it rq_cfg is aligned.

> +	__le32		dw8_vlan;
> +};
> +
> +#define SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG	4
> +#define SLI4_CMD_REG_FCFI_MRQ_MAX_NUM_RQ	32
> +#define SLI4_CMD_REG_FCFI_SET_FCFI_MODE		0
> +#define SLI4_CMD_REG_FCFI_SET_MRQ_MODE		1
> +
> +enum sli4_reg_fcfi_mrq {
> +	SLI4_REGFCFI_MRQ_VLAN_TAG	= 0xfff,
> +	SLI4_REGFCFI_MRQ_VLANTAG_VALID	= 0x1000,
> +	SLI4_REGFCFI_MRQ_MODE		= 0x2000,
> +
> +	SLI4_REGFCFI_MRQ_MASK_NUM_PAIRS	= 0xff,
> +	SLI4_REGFCFI_MRQ_FILTER_BITMASK = 0xf00,
> +	SLI4_REGFCFI_MRQ_RQ_SEL_POLICY	= 0xf000,
> +};
> +
> +struct sli4_cmd_reg_fcfi_mrq {
> +	struct sli4_mbox_command_header	hdr;
> +	__le16		fcf_index;
> +	__le16		fcfi;
> +	__le16		rqid1;
> +	__le16		rqid0;
> +	__le16		rqid3;
> +	__le16		rqid2;
> +	struct sli4_cmd_reg_fcfi_rq_cfg
> +			rq_cfg[SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG];
> +	__le32		dw8_vlan;
> +	__le32		dw9_mrqflags;
> +};
> +
> +struct sli4_cmd_rq_cfg {
> +	__le16	rq_id;
> +	u8	r_ctl_mask;
> +	u8	r_ctl_match;
> +	u8	type_mask;
> +	u8	type_match;
> +};
> +
> +/* REG_RPI - register a Remote Port Indicator */
> +enum sli4_reg_rpi {
> +	SLI4_REGRPI_REMOTE_N_PORTID	= 0xffffff,	/* DW2 */
> +	SLI4_REGRPI_UPD			= 0x1000000,
> +	SLI4_REGRPI_ETOW		= 0x8000000,
> +	SLI4_REGRPI_TERP		= 0x20000000,
> +	SLI4_REGRPI_CI			= 0x80000000,
> +};
> +
> +struct sli4_cmd_reg_rpi {
> +	struct sli4_mbox_command_header	hdr;
> +	__le16			rpi;
> +	__le16			rsvd2;
> +	__le32			dw2_rportid_flags;
> +	struct sli4_bde	bde_64;
> +	__le16			vpi;
> +	__le16			rsvd26;
> +};
> +
> +#define SLI4_REG_RPI_BUF_LEN		0x70
> +
> +/* REG_VFI - register a Virtual Fabric Indicator */
> +enum sli_reg_vfi {
> +	SLI4_REGVFI_VP			= 0x1000,	/* DW1 */
> +	SLI4_REGVFI_UPD			= 0x2000,
> +
> +	SLI4_REGVFI_LOCAL_N_PORTID	= 0xffffff,	/* DW10 */
> +};
> +
> +struct sli4_cmd_reg_vfi {
> +	struct sli4_mbox_command_header	hdr;
> +	__le16			vfi;
> +	__le16			dw0w1_flags;
> +	__le16			fcfi;
> +	__le16			vpi;
> +	u8			wwpn[8];
> +	struct sli4_bde	sparm;
> +	__le32			e_d_tov;
> +	__le32			r_a_tov;
> +	__le32			dw10_lportid_flags;
> +};
> +
> +/* REG_VPI - register a Virtual Port Indicator */
> +enum sli4_reg_vpi {
> +	SLI4_REGVPI_LOCAL_N_PORTID	= 0xffffff,
> +	SLI4_REGVPI_UPD			= 0x1000000,
> +};
> +
> +struct sli4_cmd_reg_vpi {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32		rsvd0;
> +	__le32		dw2_lportid_flags;
> +	u8		wwpn[8];
> +	__le32		rsvd12;
> +	__le16		vpi;
> +	__le16		vfi;
> +};
> +
> +/* REQUEST_FEATURES - request / query SLI features */
> +enum sli4_req_features_flags {
> +	SLI4_REQFEAT_QRY	= 0x1,		/* Dw1 */
> +
> +	SLI4_REQFEAT_IAAB	= (1 << 0),	/* DW2 & DW3 */
> +	SLI4_REQFEAT_NPIV	= (1 << 1),
> +	SLI4_REQFEAT_DIF	= (1 << 2),
> +	SLI4_REQFEAT_VF		= (1 << 3),
> +	SLI4_REQFEAT_FCPI	= (1 << 4),
> +	SLI4_REQFEAT_FCPT	= (1 << 5),
> +	SLI4_REQFEAT_FCPC	= (1 << 6),
> +	SLI4_REQFEAT_RSVD	= (1 << 7),
> +	SLI4_REQFEAT_RQD	= (1 << 8),
> +	SLI4_REQFEAT_IAAR	= (1 << 9),
> +	SLI4_REQFEAT_HLM	= (1 << 10),
> +	SLI4_REQFEAT_PERFH	= (1 << 11),
> +	SLI4_REQFEAT_RXSEQ	= (1 << 12),
> +	SLI4_REQFEAT_RXRI	= (1 << 13),
> +	SLI4_REQFEAT_DCL2	= (1 << 14),
> +	SLI4_REQFEAT_RSCO	= (1 << 15),
> +	SLI4_REQFEAT_MRQP	= (1 << 16),
> +};
> +
> +struct sli4_cmd_request_features {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32		dw1_qry;
> +	__le32		cmd;
> +	__le32		resp;
> +};
> +
> +/*
> + * SLI_CONFIG - submit a configuration command to Port
> + *
> + * Command is either embedded as part of the payload (embed) or located
> + * in a separate memory buffer (mem)
> + */
> +enum sli4_sli_config {
> +	SLI4_SLICONF_EMB		= 0x1,		/* DW1 */
> +	SLI4_SLICONF_PMDCMD_SHIFT	= 3,
> +	SLI4_SLICONF_PMDCMD_MASK	= 0xF8,
> +	SLI4_SLICONF_PMDCMD_VAL_1	= 8,
> +	SLI4_SLICONF_PMDCNT		= 0xF8,
> +
> +	SLI4_SLICONFIG_PMD_LEN		= 0x00ffffff,
> +};
> +
> +struct sli4_cmd_sli_config {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32		dw1_flags;
> +	__le32		payload_len;
> +	__le32		rsvd12[3];
> +	union {
> +		u8 embed[58 * sizeof(u32)];
> +		struct sli4_bufptr mem;
> +	} payload;
> +};
> +
> +/* READ_STATUS - read tx/rx status of a particular port */
> +#define SLI4_READSTATUS_CLEAR_COUNTERS	0x1
> +
> +struct sli4_cmd_read_status {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32		dw1_flags;
> +	__le32		rsvd4;
> +	__le32		trans_kbyte_cnt;
> +	__le32		recv_kbyte_cnt;
> +	__le32		trans_frame_cnt;
> +	__le32		recv_frame_cnt;
> +	__le32		trans_seq_cnt;
> +	__le32		recv_seq_cnt;
> +	__le32		tot_exchanges_orig;
> +	__le32		tot_exchanges_resp;
> +	__le32		recv_p_bsy_cnt;
> +	__le32		recv_f_bsy_cnt;
> +	__le32		no_rq_buf_dropped_frames_cnt;
> +	__le32		empty_rq_timeout_cnt;
> +	__le32		no_xri_dropped_frames_cnt;
> +	__le32		empty_xri_pool_cnt;
> +};
> +
> +/* READ_LNK_STAT - read link status of a particular port */
> +enum sli4_read_link_stats_flags {
> +	SLI4_READ_LNKSTAT_REC	= (1 << 0),
> +	SLI4_READ_LNKSTAT_GEC	= (1 << 1),
> +	SLI4_READ_LNKSTAT_W02OF	= (1 << 2),
> +	SLI4_READ_LNKSTAT_W03OF	= (1 << 3),
> +	SLI4_READ_LNKSTAT_W04OF	= (1 << 4),
> +	SLI4_READ_LNKSTAT_W05OF	= (1 << 5),
> +	SLI4_READ_LNKSTAT_W06OF	= (1 << 6),
> +	SLI4_READ_LNKSTAT_W07OF	= (1 << 7),
> +	SLI4_READ_LNKSTAT_W08OF	= (1 << 8),
> +	SLI4_READ_LNKSTAT_W09OF	= (1 << 9),
> +	SLI4_READ_LNKSTAT_W10OF = (1 << 10),
> +	SLI4_READ_LNKSTAT_W11OF = (1 << 11),
> +	SLI4_READ_LNKSTAT_W12OF	= (1 << 12),
> +	SLI4_READ_LNKSTAT_W13OF	= (1 << 13),
> +	SLI4_READ_LNKSTAT_W14OF	= (1 << 14),
> +	SLI4_READ_LNKSTAT_W15OF	= (1 << 15),
> +	SLI4_READ_LNKSTAT_W16OF	= (1 << 16),
> +	SLI4_READ_LNKSTAT_W17OF	= (1 << 17),
> +	SLI4_READ_LNKSTAT_W18OF	= (1 << 18),
> +	SLI4_READ_LNKSTAT_W19OF	= (1 << 19),
> +	SLI4_READ_LNKSTAT_W20OF	= (1 << 20),
> +	SLI4_READ_LNKSTAT_W21OF	= (1 << 21),
> +	SLI4_READ_LNKSTAT_CLRC	= (1 << 30),
> +	SLI4_READ_LNKSTAT_CLOF	= (1 << 31),
> +};
> +
> +struct sli4_cmd_read_link_stats {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32	dw1_flags;
> +	__le32	linkfail_errcnt;
> +	__le32	losssync_errcnt;
> +	__le32	losssignal_errcnt;
> +	__le32	primseq_errcnt;
> +	__le32	inval_txword_errcnt;
> +	__le32	crc_errcnt;
> +	__le32	primseq_eventtimeout_cnt;
> +	__le32	elastic_bufoverrun_errcnt;
> +	__le32	arbit_fc_al_timeout_cnt;
> +	__le32	adv_rx_buftor_to_buf_credit;
> +	__le32	curr_rx_buf_to_buf_credit;
> +	__le32	adv_tx_buf_to_buf_credit;
> +	__le32	curr_tx_buf_to_buf_credit;
> +	__le32	rx_eofa_cnt;
> +	__le32	rx_eofdti_cnt;
> +	__le32	rx_eofni_cnt;
> +	__le32	rx_soff_cnt;
> +	__le32	rx_dropped_no_aer_cnt;
> +	__le32	rx_dropped_no_avail_rpi_rescnt;
> +	__le32	rx_dropped_no_avail_xri_rescnt;
> +};
> +
> +/* Format a WQE with WQ_ID Association performance hint */
> +static inline void
> +sli_set_wq_id_association(void *entry, u16 q_id)
> +{
> +	u32 *wqe = entry;
> +
> +	/*
> +	 * Set Word 10, bit 0 to zero
> +	 * Set Word 10, bits 15:1 to the WQ ID
> +	 */
> +	wqe[10] &= ~0xffff;
> +	wqe[10] |= q_id << 1;
> +}
> +
> +/* UNREG_FCFI - unregister a FCFI */
> +struct sli4_cmd_unreg_fcfi {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32		rsvd0;
> +	__le16		fcfi;
> +	__le16		rsvd6;
> +};
> +
> +/* UNREG_RPI - unregister one or more RPI */
> +enum sli4_unreg_rpi {
> +	UNREG_RPI_DP		= 0x2000,
> +	UNREG_RPI_II_SHIFT	= 14,
> +	UNREG_RPI_II_MASK	= 0xC000,
> +	UNREG_RPI_II_RPI	= 0x0000,
> +	UNREG_RPI_II_VPI	= 0x4000,
> +	UNREG_RPI_II_VFI	= 0x8000,
> +	UNREG_RPI_II_FCFI	= 0xC000,
> +
> +	UNREG_RPI_DEST_N_PORTID_MASK = 0x00ffffff,
> +};
> +
> +struct sli4_cmd_unreg_rpi {
> +	struct sli4_mbox_command_header	hdr;
> +	__le16		index;
> +	__le16		dw1w1_flags;
> +	__le32		dw2_dest_n_portid;
> +};
> +
> +/* UNREG_VFI - unregister one or more VFI */
> +enum sli4_unreg_vfi {
> +	UNREG_VFI_II_SHIFT	= 14,
> +	UNREG_VFI_II_MASK	= 0xC000,
> +	UNREG_VFI_II_VFI	= 0x0000,
> +	UNREG_VFI_II_FCFI	= 0xC000,
> +};
> +
> +struct sli4_cmd_unreg_vfi {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32		rsvd0;
> +	__le16		index;
> +	__le16		dw2_flags;
> +};
> +
> +enum sli4_unreg_type {
> +	SLI4_UNREG_TYPE_PORT,
> +	SLI4_UNREG_TYPE_DOMAIN,
> +	SLI4_UNREG_TYPE_FCF,
> +	SLI4_UNREG_TYPE_ALL
> +};
> +
> +/* UNREG_VPI - unregister one or more VPI */
> +enum sli4_unreg_vpi {
> +	UNREG_VPI_II_SHIFT	= 14,
> +	UNREG_VPI_II_MASK	= 0xC000,
> +	UNREG_VPI_II_VPI	= 0x0000,
> +	UNREG_VPI_II_VFI	= 0x8000,
> +	UNREG_VPI_II_FCFI	= 0xC000,
> +};
> +
> +struct sli4_cmd_unreg_vpi {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32		rsvd0;
> +	__le16		index;
> +	__le16		dw2w0_flags;
> +};
> +
> +/* AUTO_XFER_RDY - Configure the auto-generate XFER-RDY feature */
> +struct sli4_cmd_config_auto_xfer_rdy {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32		rsvd0;
> +	__le32		max_burst_len;
> +};
> +
> +#define SLI4_CONFIG_AUTO_XFERRDY_BLKSIZE	0xffff
> +
> +struct sli4_cmd_config_auto_xfer_rdy_hp {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32		rsvd0;
> +	__le32		max_burst_len;
> +	__le32		dw3_esoc_flags;
> +	__le16		block_size;
> +	__le16		rsvd14;
> +};
> +
> +/*************************************************************************
> + * SLI-4 common configuration command formats and definitions
> + */
> +
> +/*
> + * Subsystem values.
> + */
> +enum sli4_subsystem {
> +	SLI4_SUBSYSTEM_COMMON	= 0x01,
> +	SLI4_SUBSYSTEM_LOWLEVEL	= 0x0B,
> +	SLI4_SUBSYSTEM_FC	= 0x0C,
> +	SLI4_SUBSYSTEM_DMTF	= 0x11,
> +};
> +
> +#define	SLI4_OPC_LOWLEVEL_SET_WATCHDOG		0X36
> +
> +/*
> + * Common opcode (OPC) values.
> + */
> +enum sli4_cmn_opcode {
> +	CMN_FUNCTION_RESET	= 0x3d,
> +	CMN_CREATE_CQ		= 0x0c,
> +	CMN_CREATE_CQ_SET	= 0x1d,
> +	CMN_DESTROY_CQ		= 0x36,
> +	CMN_MODIFY_EQ_DELAY	= 0x29,
> +	CMN_CREATE_EQ		= 0x0d,
> +	CMN_DESTROY_EQ		= 0x37,
> +	CMN_CREATE_MQ_EXT	= 0x5a,
> +	CMN_DESTROY_MQ		= 0x35,
> +	CMN_GET_CNTL_ATTRIBUTES	= 0x20,
> +	CMN_NOP			= 0x21,
> +	CMN_GET_RSC_EXTENT_INFO = 0x9a,
> +	CMN_GET_SLI4_PARAMS	= 0xb5,
> +	CMN_QUERY_FW_CONFIG	= 0x3a,
> +	CMN_GET_PORT_NAME	= 0x4d,
> +
> +	CMN_WRITE_FLASHROM	= 0x07,
> +	/* TRANSCEIVER Data */
> +	CMN_READ_TRANS_DATA	= 0x49,
> +	CMN_GET_CNTL_ADDL_ATTRS = 0x79,
> +	CMN_GET_FUNCTION_CFG	= 0xa0,
> +	CMN_GET_PROFILE_CFG	= 0xa4,
> +	CMN_SET_PROFILE_CFG	= 0xa5,
> +	CMN_GET_PROFILE_LIST	= 0xa6,
> +	CMN_GET_ACTIVE_PROFILE	= 0xa7,
> +	CMN_SET_ACTIVE_PROFILE	= 0xa8,
> +	CMN_READ_OBJECT		= 0xab,
> +	CMN_WRITE_OBJECT	= 0xac,
> +	CMN_DELETE_OBJECT	= 0xae,
> +	CMN_READ_OBJECT_LIST	= 0xad,
> +	CMN_SET_DUMP_LOCATION	= 0xb8,
> +	CMN_SET_FEATURES	= 0xbf,
> +	CMN_GET_RECFG_LINK_INFO = 0xc9,
> +	CMN_SET_RECNG_LINK_ID	= 0xca,
> +};
> +
> +/* DMTF opcode (OPC) values */
> +#define DMTF_EXEC_CLP_CMD 0x01
> +
> +/*
> + * COMMON_FUNCTION_RESET
> + *
> + * Resets the Port, returning it to a power-on state. This configuration
> + * command does not have a payload and should set/expect the lengths to
> + * be zero.
> + */
> +struct sli4_rqst_cmn_function_reset {
> +	struct sli4_rqst_hdr	hdr;
> +};
> +
> +struct sli4_rsp_cmn_function_reset {
> +	struct sli4_rsp_hdr	hdr;
> +};
> +
> +
> +/*
> + * COMMON_GET_CNTL_ATTRIBUTES
> + *
> + * Query for information about the SLI Port
> + */
> +enum sli4_cntrl_attr_flags {
> +	SLI4_CNTL_ATTR_PORTNUM	= 0x3f,
> +	SLI4_CNTL_ATTR_PORTTYPE	= 0xc0,
> +};
> +
> +struct sli4_rsp_cmn_get_cntl_attributes {
> +	struct sli4_rsp_hdr	hdr;
> +	u8			version_str[32];
> +	u8			manufacturer_name[32];
> +	__le32			supported_modes;
> +	u8			eprom_version_lo;
> +	u8			eprom_version_hi;
> +	__le16			rsvd17;
> +	__le32			mbx_ds_version;
> +	__le32			ep_fw_ds_version;
> +	u8			ncsi_version_str[12];
> +	__le32			def_extended_timeout;
> +	u8			model_number[32];
> +	u8			description[64];
> +	u8			serial_number[32];
> +	u8			ip_version_str[32];
> +	u8			fw_version_str[32];
> +	u8			bios_version_str[32];
> +	u8			redboot_version_str[32];
> +	u8			driver_version_str[32];
> +	u8			fw_on_flash_version_str[32];
> +	__le32			functionalities_supported;
> +	__le16			max_cdb_length;
> +	u8			asic_revision;
> +	u8			generational_guid0;
> +	__le32			generational_guid1_12[3];
> +	__le16			generational_guid13_14;
> +	u8			generational_guid15;
> +	u8			hba_port_count;
> +	__le16			default_link_down_timeout;
> +	u8			iscsi_version_min_max;
> +	u8			multifunctional_device;
> +	u8			cache_valid;
> +	u8			hba_status;
> +	u8			max_domains_supported;
> +	u8			port_num_type_flags;
> +	__le32			firmware_post_status;
> +	__le32			hba_mtu;
> +	u8			iscsi_features;
> +	u8			rsvd121[3];
> +	__le16			pci_vendor_id;
> +	__le16			pci_device_id;
> +	__le16			pci_sub_vendor_id;
> +	__le16			pci_sub_system_id;
> +	u8			pci_bus_number;
> +	u8			pci_device_number;
> +	u8			pci_function_number;
> +	u8			interface_type;
> +	__le64			unique_identifier;
> +	u8			number_of_netfilters;
> +	u8			rsvd122[3];
> +};
> +
> +/*
> + * COMMON_GET_CNTL_ATTRIBUTES
> + *
> + * This command queries the controller information from the Flash ROM.
> + */
> +struct sli4_rqst_cmn_get_cntl_addl_attributes {
> +	struct sli4_rqst_hdr	hdr;
> +};
> +
> +struct sli4_rsp_cmn_get_cntl_addl_attributes {
> +	struct sli4_rsp_hdr	hdr;
> +	__le16		ipl_file_number;
> +	u8		ipl_file_version;
> +	u8		rsvd4;
> +	u8		on_die_temperature;
> +	u8		rsvd5[3];
> +	__le32		driver_advanced_features_supported;
> +	__le32		rsvd7[4];
> +	char		universal_bios_version[32];
> +	char		x86_bios_version[32];
> +	char		efi_bios_version[32];
> +	char		fcode_version[32];
> +	char		uefi_bios_version[32];
> +	char		uefi_nic_version[32];
> +	char		uefi_fcode_version[32];
> +	char		uefi_iscsi_version[32];
> +	char		iscsi_x86_bios_version[32];
> +	char		pxe_x86_bios_version[32];
> +	u8		default_wwpn[8];
> +	u8		ext_phy_version[32];
> +	u8		fc_universal_bios_version[32];
> +	u8		fc_x86_bios_version[32];
> +	u8		fc_efi_bios_version[32];
> +	u8		fc_fcode_version[32];
> +	u8		ext_phy_crc_label[8];
> +	u8		ipl_file_name[16];
> +	u8		rsvd139[72];
> +};
> +
> +/*
> + * COMMON_NOP
> + *
> + * This command does not do anything; it only returns
> + * the payload in the completion.
> + */
> +struct sli4_rqst_cmn_nop {
> +	struct sli4_rqst_hdr	hdr;
> +	__le32			context[2];
> +};
> +
> +struct sli4_rsp_cmn_nop {
> +	struct sli4_rsp_hdr	hdr;
> +	__le32			context[2];
> +};
> +
> +struct sli4_rqst_cmn_get_resource_extent_info {
> +	struct sli4_rqst_hdr	hdr;
> +	__le16	resource_type;
> +	__le16	rsvd16;
> +};
> +
> +enum sli4_rsc_type {
> +	SLI4_RSC_TYPE_VFI	= 0x20,
> +	SLI4_RSC_TYPE_VPI	= 0x21,
> +	SLI4_RSC_TYPE_RPI	= 0x22,
> +	SLI4_RSC_TYPE_XRI	= 0x23,
> +};
> +
> +struct sli4_rsp_cmn_get_resource_extent_info {
> +	struct sli4_rsp_hdr	hdr;
> +	__le16			resource_extent_count;
> +	__le16			resource_extent_size;
> +};
> +
> +#define SLI4_128BYTE_WQE_SUPPORT	0x02
> +
> +#define GET_Q_CNT_METHOD(m) \
> +	(((m) & RSP_GET_PARAM_Q_CNT_MTHD_MASK) >> RSP_GET_PARAM_Q_CNT_MTHD_SHFT)
> +#define GET_Q_CREATE_VERSION(v) \
> +	(((v) & RSP_GET_PARAM_QV_MASK) >> RSP_GET_PARAM_QV_SHIFT)
> +
> +enum sli4_rsp_get_params_e {
> +	/*GENERIC*/
> +	RSP_GET_PARAM_Q_CNT_MTHD_SHFT	= 24,
> +	RSP_GET_PARAM_Q_CNT_MTHD_MASK	= (0xF << 24),
> +	RSP_GET_PARAM_QV_SHIFT		= 14,
> +	RSP_GET_PARAM_QV_MASK		= (3 << 14),
> +
> +	/* DW4 */
> +	RSP_GET_PARAM_PROTO_TYPE_MASK	= 0xFF,
> +	/* DW5 */
> +	RSP_GET_PARAM_FT		= (1 << 0),
> +	RSP_GET_PARAM_SLI_REV_MASK	= (0xF << 4),
> +	RSP_GET_PARAM_SLI_FAM_MASK	= (0xF << 8),
> +	RSP_GET_PARAM_IF_TYPE_MASK	= (0xF << 12),
> +	RSP_GET_PARAM_SLI_HINT1_MASK	= (0xFF << 16),
> +	RSP_GET_PARAM_SLI_HINT2_MASK	= (0x1F << 24),
> +	/* DW6 */
> +	RSP_GET_PARAM_EQ_PAGE_CNT_MASK	= (0xF << 0),
> +	RSP_GET_PARAM_EQE_SZS_MASK	= (0xF << 8),
> +	RSP_GET_PARAM_EQ_PAGE_SZS_MASK	= (0xFF << 16),
> +	/* DW8 */
> +	RSP_GET_PARAM_CQ_PAGE_CNT_MASK	= (0xF << 0),
> +	RSP_GET_PARAM_CQE_SZS_MASK	= (0xF << 8),
> +	RSP_GET_PARAM_CQ_PAGE_SZS_MASK	= (0xFF << 16),
> +	/* DW10 */
> +	RSP_GET_PARAM_MQ_PAGE_CNT_MASK	= (0xF << 0),
> +	RSP_GET_PARAM_MQ_PAGE_SZS_MASK	= (0xFF << 16),
> +	/* DW12 */
> +	RSP_GET_PARAM_WQ_PAGE_CNT_MASK	= (0xF << 0),
> +	RSP_GET_PARAM_WQE_SZS_MASK	= (0xF << 8),
> +	RSP_GET_PARAM_WQ_PAGE_SZS_MASK	= (0xFF << 16),
> +	/* DW14 */
> +	RSP_GET_PARAM_RQ_PAGE_CNT_MASK	= (0xF << 0),
> +	RSP_GET_PARAM_RQE_SZS_MASK	= (0xF << 8),
> +	RSP_GET_PARAM_RQ_PAGE_SZS_MASK	= (0xFF << 16),
> +	/* DW15W1*/
> +	RSP_GET_PARAM_RQ_DB_WINDOW_MASK	= 0xF000,
> +	/* DW16 */
> +	RSP_GET_PARAM_FC		= (1 << 0),
> +	RSP_GET_PARAM_EXT		= (1 << 1),
> +	RSP_GET_PARAM_HDRR		= (1 << 2),
> +	RSP_GET_PARAM_SGLR		= (1 << 3),
> +	RSP_GET_PARAM_FBRR		= (1 << 4),
> +	RSP_GET_PARAM_AREG		= (1 << 5),
> +	RSP_GET_PARAM_TGT		= (1 << 6),
> +	RSP_GET_PARAM_TERP		= (1 << 7),
> +	RSP_GET_PARAM_ASSI		= (1 << 8),
> +	RSP_GET_PARAM_WCHN		= (1 << 9),
> +	RSP_GET_PARAM_TCCA		= (1 << 10),
> +	RSP_GET_PARAM_TRTY		= (1 << 11),
> +	RSP_GET_PARAM_TRIR		= (1 << 12),
> +	RSP_GET_PARAM_PHOFF		= (1 << 13),
> +	RSP_GET_PARAM_PHON		= (1 << 14),
> +	RSP_GET_PARAM_PHWQ		= (1 << 15),
> +	RSP_GET_PARAM_BOUND_4GA		= (1 << 16),
> +	RSP_GET_PARAM_RXC		= (1 << 17),
> +	RSP_GET_PARAM_HLM		= (1 << 18),
> +	RSP_GET_PARAM_IPR		= (1 << 19),
> +	RSP_GET_PARAM_RXRI		= (1 << 20),
> +	RSP_GET_PARAM_SGLC		= (1 << 21),
> +	RSP_GET_PARAM_TIMM		= (1 << 22),
> +	RSP_GET_PARAM_TSMM		= (1 << 23),
> +	RSP_GET_PARAM_OAS		= (1 << 25),
> +	RSP_GET_PARAM_LC		= (1 << 26),
> +	RSP_GET_PARAM_AGXF		= (1 << 27),
> +	RSP_GET_PARAM_LOOPBACK_MASK	= (0xF << 28),
> +	/* DW18 */
> +	RSP_GET_PARAM_SGL_PAGE_CNT_MASK = (0xF << 0),
> +	RSP_GET_PARAM_SGL_PAGE_SZS_MASK = (0xFF << 8),
> +	RSP_GET_PARAM_SGL_PP_ALIGN_MASK = (0xFF << 16),
> +};
> +
> +struct sli4_rqst_cmn_get_sli4_params {
> +	struct sli4_rqst_hdr	hdr;
> +};
> +
> +struct sli4_rsp_cmn_get_sli4_params {
> +	struct sli4_rsp_hdr	hdr;
> +	__le32		dw4_protocol_type;
> +	__le32		dw5_sli;
> +	__le32		dw6_eq_page_cnt;
> +	__le16		eqe_count_mask;
> +	__le16		rsvd26;
> +	__le32		dw8_cq_page_cnt;
> +	__le16		cqe_count_mask;
> +	__le16		rsvd34;
> +	__le32		dw10_mq_page_cnt;
> +	__le16		mqe_count_mask;
> +	__le16		rsvd42;
> +	__le32		dw12_wq_page_cnt;
> +	__le16		wqe_count_mask;
> +	__le16		rsvd50;
> +	__le32		dw14_rq_page_cnt;
> +	__le16		rqe_count_mask;
> +	__le16		dw15w1_rq_db_window;
> +	__le32		dw16_loopback_scope;
> +	__le32		sge_supported_length;
> +	__le32		dw18_sgl_page_cnt;
> +	__le16		min_rq_buffer_size;
> +	__le16		rsvd75;
> +	__le32		max_rq_buffer_size;
> +	__le16		physical_xri_max;
> +	__le16		physical_rpi_max;
> +	__le16		physical_vpi_max;
> +	__le16		physical_vfi_max;
> +	__le32		rsvd88;
> +	__le16		frag_num_field_offset;
> +	__le16		frag_num_field_size;
> +	__le16		sgl_index_field_offset;
> +	__le16		sgl_index_field_size;
> +	__le32		chain_sge_initial_value_lo;
> +	__le32		chain_sge_initial_value_hi;
> +};
> +
> +/*
> + * COMMON_QUERY_FW_CONFIG
> + *
> + * This command retrieves firmware configuration parameters and adapter
> + * resources available to the driver.
> + */
> +struct sli4_rqst_cmn_query_fw_config {
> +	struct sli4_rqst_hdr	hdr;
> +};
> +
> +struct sli4_rsp_cmn_query_fw_config {
> +	struct sli4_rsp_hdr	hdr;
> +	__le32		config_number;
> +	__le32		asic_rev;
> +	__le32		physical_port;
> +	__le32		function_mode;
> +	__le32		ulp0_mode;
> +	__le32		ulp0_nic_wqid_base;
> +	__le32		ulp0_nic_wq_total; /* DW10 */
> +	__le32		ulp0_toe_wqid_base;
> +	__le32		ulp0_toe_wq_total;
> +	__le32		ulp0_toe_rqid_base;
> +	__le32		ulp0_toe_rq_total;
> +	__le32		ulp0_toe_defrqid_base;
> +	__le32		ulp0_toe_defrq_total;
> +	__le32		ulp0_lro_rqid_base;
> +	__le32		ulp0_lro_rq_total;
> +	__le32		ulp0_iscsi_icd_base;
> +	__le32		ulp0_iscsi_icd_total; /* DW20 */
> +	__le32		ulp1_mode;
> +	__le32		ulp1_nic_wqid_base;
> +	__le32		ulp1_nic_wq_total;
> +	__le32		ulp1_toe_wqid_base;
> +	__le32		ulp1_toe_wq_total;
> +	__le32		ulp1_toe_rqid_base;
> +	__le32		ulp1_toe_rq_total;
> +	__le32		ulp1_toe_defrqid_base;
> +	__le32		ulp1_toe_defrq_total;
> +	__le32		ulp1_lro_rqid_base; /* DW30 */
> +	__le32		ulp1_lro_rq_total;
> +	__le32		ulp1_iscsi_icd_base;
> +	__le32		ulp1_iscsi_icd_total;
> +	__le32		function_capabilities;
> +	__le32		ulp0_cq_base;
> +	__le32		ulp0_cq_total;
> +	__le32		ulp0_eq_base;
> +	__le32		ulp0_eq_total;
> +	__le32		ulp0_iscsi_chain_icd_base;
> +	__le32		ulp0_iscsi_chain_icd_total; /* DW40 */
> +	__le32		ulp1_iscsi_chain_icd_base;
> +	__le32		ulp1_iscsi_chain_icd_total;
> +};
> +
> +/*Port Types*/
> +enum sli4_port_types {
> +	PORT_TYPE_ETH	= 0,
> +	PORT_TYPE_FC	= 1,
> +};
> +
> +struct sli4_rqst_cmn_get_port_name {
> +	struct sli4_rqst_hdr	hdr;
> +	u8      port_type;
> +	u8      rsvd4[3];
> +};
> +
> +struct sli4_rsp_cmn_get_port_name {
> +	struct sli4_rsp_hdr	hdr;
> +	char		port_name[4];
> +};
> +
> +struct sli4_rqst_cmn_write_flashrom {
> +	struct sli4_rqst_hdr	hdr;
> +	__le32		flash_rom_access_opcode;
> +	__le32		flash_rom_access_operation_type;
> +	__le32		data_buffer_size;
> +	__le32		offset;
> +	u8		data_buffer[4];
> +};
> +
> +/*
> + * COMMON_READ_TRANSCEIVER_DATA
> + *
> + * This command reads SFF transceiver data(Format is defined
> + * by the SFF-8472 specification).
> + */
> +struct sli4_rqst_cmn_read_transceiver_data {
> +	struct sli4_rqst_hdr	hdr;
> +	__le32			page_number;
> +	__le32			port;
> +};
> +
> +struct sli4_rsp_cmn_read_transceiver_data {
> +	struct sli4_rsp_hdr	hdr;
> +	__le32			page_number;
> +	__le32			port;
> +	u8			page_data[128];
> +	u8			page_data_2[128];
> +};
> +
> +#define SLI4_REQ_DESIRE_READLEN		0xFFFFFF
> +
> +struct sli4_rqst_cmn_read_object {
> +	struct sli4_rqst_hdr	hdr;
> +	__le32			desired_read_length_dword;
> +	__le32			read_offset;
> +	u8			object_name[104];
> +	__le32			host_buffer_descriptor_count;
> +	struct sli4_bde	host_buffer_descriptor[0];
> +};
> +
> +#define RSP_COM_READ_OBJ_EOF		0x80000000
> +
> +struct sli4_rsp_cmn_read_object {
> +	struct sli4_rsp_hdr	hdr;
> +	__le32			actual_read_length;
> +	__le32			eof_dword;
> +};
> +
> +enum sli4_rqst_write_object_flags {
> +	SLI4_RQ_DES_WRITE_LEN		= 0xFFFFFF,
> +	SLI4_RQ_DES_WRITE_LEN_NOC	= 0x40000000,
> +	SLI4_RQ_DES_WRITE_LEN_EOF	= 0x80000000,
> +};
> +
> +struct sli4_rqst_cmn_write_object {
> +	struct sli4_rqst_hdr	hdr;
> +	__le32			desired_write_len_dword;
> +	__le32			write_offset;
> +	u8			object_name[104];
> +	__le32			host_buffer_descriptor_count;
> +	struct sli4_bde	host_buffer_descriptor[0];
> +};
> +
> +#define	RSP_CHANGE_STATUS		0xFF
> +
> +struct sli4_rsp_cmn_write_object {
> +	struct sli4_rsp_hdr	hdr;
> +	__le32			actual_write_length;
> +	__le32			change_status_dword;
> +};
> +
> +struct sli4_rqst_cmn_delete_object {
> +	struct sli4_rqst_hdr	hdr;
> +	__le32			rsvd4;
> +	__le32			rsvd5;
> +	u8			object_name[104];
> +};
> +
> +#define SLI4_RQ_OBJ_LIST_READ_LEN	0xFFFFFF
> +
> +struct sli4_rqst_cmn_read_object_list {
> +	struct sli4_rqst_hdr	hdr;
> +	__le32			desired_read_length_dword;
> +	__le32			read_offset;
> +	u8			object_name[104];
> +	__le32			host_buffer_descriptor_count;
> +	struct sli4_bde	host_buffer_descriptor[0];
> +};
> +
> +enum sli4_rqst_set_dump_flags {
> +	SLI4_CMN_SET_DUMP_BUFFER_LEN	= 0xFFFFFF,
> +	SLI4_CMN_SET_DUMP_FDB		= 0x20000000,
> +	SLI4_CMN_SET_DUMP_BLP		= 0x40000000,
> +	SLI4_CMN_SET_DUMP_QRY		= 0x80000000,
> +};
> +
> +struct sli4_rqst_cmn_set_dump_location {
> +	struct sli4_rqst_hdr	hdr;
> +	__le32			buffer_length_dword;
> +	__le32			buf_addr_low;
> +	__le32			buf_addr_high;
> +};
> +
> +struct sli4_rsp_cmn_set_dump_location {
> +	struct sli4_rsp_hdr	hdr;
> +	__le32			buffer_length_dword;
> +};
> +
> +enum sli4_dump_level {
> +	SLI4_DUMP_LEVEL_NONE,
> +	SLI4_CHIP_LEVEL_DUMP,
> +	SLI4_FUNC_DESC_DUMP,
> +};
> +
> +enum sli4_dump_state {
> +	SLI4_DUMP_STATE_NONE,
> +	SLI4_CHIP_DUMP_STATE_VALID,
> +	SLI4_FUNC_DUMP_STATE_VALID,
> +};
> +
> +enum sli4_dump_status {
> +	SLI4_DUMP_READY_STATUS_NOT_READY,
> +	SLI4_DUMP_READY_STATUS_DD_PRESENT,
> +	SLI4_DUMP_READY_STATUS_FDB_PRESENT,
> +	SLI4_DUMP_READY_STATUS_SKIP_DUMP,
> +	SLI4_DUMP_READY_STATUS_FAILED = -1,
> +};
> +
> +enum sli4_set_features {
> +	SLI4_SET_FEATURES_DIF_SEED			= 0x01,
> +	SLI4_SET_FEATURES_XRI_TIMER			= 0x03,
> +	SLI4_SET_FEATURES_MAX_PCIE_SPEED		= 0x04,
> +	SLI4_SET_FEATURES_FCTL_CHECK			= 0x05,
> +	SLI4_SET_FEATURES_FEC				= 0x06,
> +	SLI4_SET_FEATURES_PCIE_RECV_DETECT		= 0x07,
> +	SLI4_SET_FEATURES_DIF_MEMORY_MODE		= 0x08,
> +	SLI4_SET_FEATURES_DISABLE_SLI_PORT_PAUSE_STATE	= 0x09,
> +	SLI4_SET_FEATURES_ENABLE_PCIE_OPTIONS		= 0x0A,
> +	SLI4_SET_FEAT_CFG_AUTO_XFER_RDY_T10PI		= 0x0C,
> +	SLI4_SET_FEATURES_ENABLE_MULTI_RECEIVE_QUEUE	= 0x0D,
> +	SLI4_SET_FEATURES_SET_FTD_XFER_HINT		= 0x0F,
> +	SLI4_SET_FEATURES_SLI_PORT_HEALTH_CHECK		= 0x11,
> +};
> +
> +struct sli4_rqst_cmn_set_features {
> +	struct sli4_rqst_hdr	hdr;
> +	__le32			feature;
> +	__le32			param_len;
> +	__le32			params[8];
> +};
> +
> +struct sli4_rqst_cmn_set_features_dif_seed {
> +	__le16		seed;
> +	__le16		rsvd16;
> +};
> +
> +enum sli4_rqst_set_mrq_features {
> +	SLI4_RQ_MULTIRQ_ISR		 = 0x1,
> +	SLI4_RQ_MULTIRQ_AUTOGEN_XFER_RDY = 0x2,
> +
> +	SLI4_RQ_MULTIRQ_NUM_RQS		 = 0xFF,
> +	SLI4_RQ_MULTIRQ_RQ_SELECT	 = 0xF00,
> +};
> +
> +struct sli4_rqst_cmn_set_features_multirq {
> +	__le32		auto_gen_xfer_dword;
> +	__le32		num_rqs_dword;
> +};
> +
> +enum sli4_rqst_health_check_flags {
> +	SLI4_RQ_HEALTH_CHECK_ENABLE	= 0x1,
> +	SLI4_RQ_HEALTH_CHECK_QUERY	= 0x2,
> +};
> +
> +struct sli4_rqst_cmn_set_features_health_check {
> +	__le32		health_check_dword;
> +};
> +
> +struct sli4_rqst_cmn_set_features_set_fdt_xfer_hint {
> +	__le32		fdt_xfer_hint;
> +};
> +
> +struct sli4_rqst_dmtf_exec_clp_cmd {
> +	struct sli4_rqst_hdr	hdr;
> +	__le32			cmd_buf_length;
> +	__le32			resp_buf_length;
> +	__le32			cmd_buf_addr_low;
> +	__le32			cmd_buf_addr_high;
> +	__le32			resp_buf_addr_low;
> +	__le32			resp_buf_addr_high;
> +};
> +
> +struct sli4_rsp_dmtf_exec_clp_cmd {
> +	struct sli4_rsp_hdr	hdr;
> +	__le32			rsvd4;
> +	__le32			resp_length;
> +	__le32			rsvd6;
> +	__le32			rsvd7;
> +	__le32			rsvd8;
> +	__le32			rsvd9;
> +	__le32			clp_status;
> +	__le32			clp_detailed_status;
> +};
> +
> +#define SLI4_PROTOCOL_FC		0x10
> +#define SLI4_PROTOCOL_DEFAULT		0xff
> +
> +struct sli4_rspource_descriptor_v1 {
> +	u8		descriptor_type;
> +	u8		descriptor_length;
> +	__le16		rsvd16;
> +	__le32		type_specific[0];
> +};
> +
> +enum sli4_pcie_desc_flags {
> +	SLI4_PCIE_DESC_IMM		= 0x4000,
> +	SLI4_PCIE_DESC_NOSV		= 0x8000,
> +
> +	SLI4_PCIE_DESC_PF_NO		= 0x3FF0000,
> +
> +	SLI4_PCIE_DESC_MISSN_ROLE	= 0xFF,
> +	SLI4_PCIE_DESC_PCHG		= 0x8000000,
> +	SLI4_PCIE_DESC_SCHG		= 0x10000000,
> +	SLI4_PCIE_DESC_XCHG		= 0x20000000,
> +	SLI4_PCIE_DESC_XROM		= 0xC0000000
> +};
> +
> +struct sli4_pcie_resource_descriptor_v1 {
> +	u8		descriptor_type;
> +	u8		descriptor_length;
> +	__le16		imm_nosv_dword;
> +	__le32		pf_number_dword;
> +	__le32		rsvd3;
> +	u8		sriov_state;
> +	u8		pf_state;
> +	u8		pf_type;
> +	u8		rsvd4;
> +	__le16		number_of_vfs;
> +	__le16		rsvd5;
> +	__le32		mission_roles_dword;
> +	__le32		rsvd7[16];
> +};
> +
> +struct sli4_rqst_cmn_get_function_config {
> +	struct sli4_rqst_hdr  hdr;
> +};
> +
> +struct sli4_rsp_cmn_get_function_config {
> +	struct sli4_rsp_hdr	hdr;
> +	__le32			desc_count;
> +	__le32			desc[54];
> +};
> +
> +/* Link Config Descriptor for link config functions */
> +struct sli4_link_config_descriptor {
> +	u8		link_config_id;
> +	u8		rsvd1[3];
> +	__le32		config_description[8];
> +};
> +
> +#define MAX_LINK_DES	10
> +
> +struct sli4_rqst_cmn_get_reconfig_link_info {
> +	struct sli4_rqst_hdr  hdr;
> +};
> +
> +struct sli4_rsp_cmn_get_reconfig_link_info {
> +	struct sli4_rsp_hdr	hdr;
> +	u8			active_link_config_id;
> +	u8			rsvd17;
> +	u8			next_link_config_id;
> +	u8			rsvd19;
> +	__le32			link_configuration_descriptor_count;
> +	struct sli4_link_config_descriptor
> +				desc[MAX_LINK_DES];
> +};
> +
> +enum sli4_set_reconfig_link_flags {
> +	SLI4_SET_RECONFIG_LINKID_NEXT	= 0xff,
> +	SLI4_SET_RECONFIG_LINKID_FD	= (1 << 31),
> +};
> +
> +struct sli4_rqst_cmn_set_reconfig_link_id {
> +	struct sli4_rqst_hdr  hdr;
> +	__le32			dw4_flags;
> +};
> +
> +struct sli4_rsp_cmn_set_reconfig_link_id {
> +	struct sli4_rsp_hdr	hdr;
> +};
> +
> +struct sli4_rqst_lowlevel_set_watchdog {
> +	struct sli4_rqst_hdr	hdr;
> +	__le16			watchdog_timeout;
> +	__le16			rsvd18;
> +};
> +
> +struct sli4_rsp_lowlevel_set_watchdog {
> +	struct sli4_rsp_hdr	hdr;
> +	__le32			rsvd;
> +};
> +
> +/* FC opcode (OPC) values */
> +enum sli4_fc_opcodes {
> +	SLI4_OPC_WQ_CREATE		= 0x1,
> +	SLI4_OPC_WQ_DESTROY		= 0x2,
> +	SLI4_OPC_POST_SGL_PAGES		= 0x3,
> +	SLI4_OPC_RQ_CREATE		= 0x5,
> +	SLI4_OPC_RQ_DESTROY		= 0x6,
> +	SLI4_OPC_READ_FCF_TABLE		= 0x8,
> +	SLI4_OPC_POST_HDR_TEMPLATES	= 0xb,
> +	SLI4_OPC_REDISCOVER_FCF		= 0x10,
> +};
> +
> +/* Use the default CQ associated with the WQ */
> +#define SLI4_CQ_DEFAULT 0xffff
> +
> +/*
> + * POST_SGL_PAGES
> + *
> + * Register the scatter gather list (SGL) memory and
> + * associate it with an XRI.
> + */
> +struct sli4_rqst_post_sgl_pages {
> +	struct sli4_rqst_hdr	hdr;
> +	__le16			xri_start;
> +	__le16			xri_count;
> +	struct {
> +		__le32		page0_low;
> +		__le32		page0_high;
> +		__le32		page1_low;
> +		__le32		page1_high;
> +	} page_set[10];
> +};
> +
> +struct sli4_rsp_post_sgl_pages {
> +	struct sli4_rsp_hdr	hdr;
> +};
> +
> +struct sli4_rqst_post_hdr_templates {
> +	struct sli4_rqst_hdr	hdr;
> +	__le16			rpi_offset;
> +	__le16			page_count;
> +	struct sli4_dmaaddr	page_descriptor[0];
> +};
> +
> +#define SLI4_HDR_TEMPLATE_SIZE		64
> +
> +enum sli4_io_flags {
> +/* The XRI associated with this IO is already active */
> +	SLI4_IO_CONTINUATION		= (1 << 0),
> +/* Automatically generate a good RSP frame */
> +	SLI4_IO_AUTO_GOOD_RESPONSE	= (1 << 1),
> +	SLI4_IO_NO_ABORT		= (1 << 2),
> +/* Set the DNRX bit because no auto xref rdy buffer is posted */
> +	SLI4_IO_DNRX			= (1 << 3),
> +};
> +
> +enum sli4_callback {
> +	SLI4_CB_LINK,
> +	SLI4_CB_MAX,
> +};
> +
> +enum sli4_link_status {
> +	SLI_LINK_STATUS_UP,
> +	SLI_LINK_STATUS_DOWN,
> +	SLI_LINK_STATUS_NO_ALPA,
> +	SLI_LINK_STATUS_MAX,
> +};
> +
> +enum sli4_link_topology {
> +	SLI_LINK_TOPO_NPORT = 1,
> +	SLI_LINK_TOPO_LOOP,
> +	SLI_LINK_TOPO_LOOPBACK_INTERNAL,
> +	SLI_LINK_TOPO_LOOPBACK_EXTERNAL,
> +	SLI_LINK_TOPO_NONE,
> +	SLI_LINK_TOPO_MAX,
> +};
> +
> +enum sli4_link_medium {
> +	SLI_LINK_MEDIUM_ETHERNET,
> +	SLI_LINK_MEDIUM_FC,
> +	SLI_LINK_MEDIUM_MAX,
> +};
> +
> +/*Driver specific structures*/
> +
> +struct sli4_link_event {
> +	enum sli4_link_status		status;
> +	enum sli4_link_topology	topology;

Code idention

> +	enum sli4_link_medium		medium;
> +	u32				speed;
> +	u8				*loop_map;
> +	u32				fc_id;
> +};
> +
> +enum sli4_resource {
> +	SLI_RSRC_VFI,
> +	SLI_RSRC_VPI,
> +	SLI_RSRC_RPI,
> +	SLI_RSRC_XRI,
> +	SLI_RSRC_FCFI,
> +	SLI_RSRC_MAX,
> +};
> +
> +struct sli4_extent {
> +	u32		number;
> +	u32		size;
> +	u32		n_alloc;
> +	u32		*base;
> +	unsigned long	*use_map;
> +	u32		map_size;
> +};
> +
> +struct sli4_queue_info {
> +	u16	max_qcount[SLI_QTYPE_MAX];
> +	u32	max_qentries[SLI_QTYPE_MAX];
> +	u16	count_mask[SLI_QTYPE_MAX];
> +	u16	count_method[SLI_QTYPE_MAX];
> +	u32	qpage_count[SLI_QTYPE_MAX];
> +};
> +
> +#define	SLI_PCI_MAX_REGS		6

 PCI_STD_NUM_BARS ?

> +struct sli4 {
> +	void				*os;
> +	struct pci_dev			*pcidev;

s/pcidev/pci/ as this seems to be a more common pattern.

> +	void __iomem			*reg[SLI_PCI_MAX_REGS];
> +
> +	u32				sli_rev;
> +	u32				sli_family;
> +	u32				if_type;

ahhh the if_type member from the other comment

> +
> +	u16				asic_type;
> +	u16				asic_rev;
> +
> +	u16				e_d_tov;
> +	u16				r_a_tov;
> +	struct sli4_queue_info	qinfo;

Please align it with the rest.

> +	u16				link_module_type;
> +	u8				rq_batch;
> +	u16				rq_min_buf_size;
> +	u32				rq_max_buf_size;
> +	u8				topology;
> +	u8				wwpn[8];
> +	u8				wwnn[8];
> +	u32				fw_rev[2];
> +	u8				fw_name[2][16];
> +	char				ipl_name[16];
> +	u32				hw_rev[3];
> +	u8				port_number;
> +	char				port_name[2];
> +	char				modeldesc[64];
> +	char				bios_version_string[32];
> +	/*
> +	 * Tracks the port resources using extents metaphor. For
> +	 * devices that don't implement extents (i.e.
> +	 * has_extents == FALSE), the code models each resource as
> +	 * a single large extent.
> +	 */
> +	struct sli4_extent		extent[SLI_RSRC_MAX];
> +	u32				features;
> +	u32				has_extents:1,
> +					auto_reg:1,
> +					auto_xfer_rdy:1,
> +					hdr_template_req:1,
> +					perf_hint:1,
> +					perf_wq_id_association:1,
> +					cq_create_version:2,
> +					mq_create_version:2,
> +					high_login_mode:1,
> +					sgl_pre_registered:1,
> +					sgl_pre_registration_required:1,
> +					t10_dif_inline_capable:1,
> +					t10_dif_separate_capable:1;

Why features and the bitfields?

> +	u32				sge_supported_length;
> +	u32				sgl_page_sizes;
> +	u32				max_sgl_pages;
> +	u32				wqe_size;
> +
> +	/*
> +	 * Callback functions
> +	 */
> +	int				(*link)(void *ctx, void *event);
> +	void				*link_arg;
> +
> +	struct efc_dma		bmbx;
> +
> +	/* Save pointer to physical memory descriptor for non-embedded
> +	 * SLI_CONFIG commands for BMBX dumping purposes
> +	 */
> +	struct efc_dma		*bmbx_non_emb_pmd;
> +
> +	struct efc_dma		vpd_data;
> +	u32			vpd_length;
> +};
> +
>  #endif /* !_SLI4_H */
> -- 
> 2.16.4

Thanks,
Daniel
