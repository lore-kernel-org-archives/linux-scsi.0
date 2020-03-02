Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15299C3F2D1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 18:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E091821D56
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 18:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgCBSk7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 13:40:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:39340 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727389AbgCBSk7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 13:40:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 937CEB2C1;
        Mon,  2 Mar 2020 18:40:56 +0000 (UTC)
Date:   Mon, 2 Mar 2020 19:40:55 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 3/4] qla2xxx: Fix endianness annotations in source files
Message-ID: <20200302184055.dtjktj4sbsyysk5m@beryllium.lan>
References: <20200302033023.27718-1-bvanassche@acm.org>
 <20200302033023.27718-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302033023.27718-4-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Mar 01, 2020 at 07:30:22PM -0800, Bart Van Assche wrote:
> Fix all endianness complaints reported by sparse (C=2).

[...]

>  int
> -qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
> -    uint32_t ram_dwords, void **nxt)
> +qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be32 *ram,
> +		 uint32_t ram_dwords, void **nxt)
>  {
>  	int rval = QLA_FUNCTION_FAILED;
>  	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
>  	dma_addr_t dump_dma = ha->gid_list_dma;
> -	uint32_t *chunk = (void *)ha->gid_list;
> +	uint32_t *chunk = (uint32_t *)ha->gid_list;
>  	uint32_t dwords = qla2x00_gid_list_size(ha) / 4;
>  	uint32_t stat;
>  	ulong i, j, timer = 6000000;
> @@ -252,9 +252,9 @@ qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
>  			return rval;
>  		}
>  		for (j = 0; j < dwords; j++) {
> -			ram[i + j] =
> -			    (IS_QLA27XX(ha) || IS_QLA28XX(ha)) ?
> -			    chunk[j] : swab32(chunk[j]);
> +			ram[i + j] = (__force __be32)
> +				((IS_QLA27XX(ha) || IS_QLA28XX(ha)) ?
> +				 chunk[j] : swab32(chunk[j]));

Isn't this assuming the host runs in little endian mode? Because later down...

>  		}
>  	}
>  
> @@ -263,8 +263,8 @@ qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
>  }
>  
>  static int
> -qla24xx_dump_memory(struct qla_hw_data *ha, uint32_t *code_ram,
> -    uint32_t cram_size, void **nxt)
> +qla24xx_dump_memory(struct qla_hw_data *ha, __be32 *code_ram,
> +		    uint32_t cram_size, void **nxt)
>  {
>  	int rval;
>  
> @@ -284,11 +284,11 @@ qla24xx_dump_memory(struct qla_hw_data *ha, uint32_t *code_ram,
>  	return rval;
>  }
>  
> -static uint32_t *
> +static __be32 *
>  qla24xx_read_window(struct device_reg_24xx __iomem *reg, uint32_t iobase,
> -    uint32_t count, uint32_t *buf)
> +		    uint32_t count, __be32 *buf)
>  {
> -	uint32_t __iomem *dmp_reg;
> +	__le32 __iomem *dmp_reg;
>  
>  	WRT_REG_DWORD(&reg->iobase_addr, iobase);
>  	dmp_reg = &reg->iobase_window;
> @@ -366,7 +366,7 @@ qla24xx_soft_reset(struct qla_hw_data *ha)
>  }
>  
>  static int
> -qla2xxx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint16_t *ram,
> +qla2xxx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be16 *ram,
>      uint32_t ram_words, void **nxt)
>  {
>  	int rval;
> @@ -374,7 +374,7 @@ qla2xxx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint16_t *ram,
>  	uint16_t mb0;
>  	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
>  	dma_addr_t dump_dma = ha->gid_list_dma;
> -	uint16_t *dump = (uint16_t *)ha->gid_list;
> +	__le16 *dump = (__force __le16 *)ha->gid_list;
>  
>  	rval = QLA_SUCCESS;
>  	mb0 = 0;
> @@ -439,7 +439,7 @@ qla2xxx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint16_t *ram,
>  		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
>  			rval = mb0 & MBS_MASK;
>  			for (idx = 0; idx < words; idx++)
> -				ram[cnt + idx] = swab16(dump[idx]);
> +				ram[cnt + idx] = cpu_to_be16(le16_to_cpu(dump[idx]));

... cpu_to_be16() is used.

> @@ -7705,7 +7707,7 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
>  	ql_dbg(ql_dbg_init, vha, 0x008b,
>  	    "FW: Loading firmware from flash (%x).\n", faddr);
>  
> -	dcode = (void *)req->ring;
> +	dcode = (uint32_t *)req->ring;
>  	qla24xx_read_flash_data(vha, dcode, faddr, 8);
>  	if (qla24xx_risc_firmware_invalid(dcode)) {
>  		ql_log(ql_log_fatal, vha, 0x008c,
> @@ -7718,18 +7720,18 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
>  		return QLA_FUNCTION_FAILED;
>  	}
>  
> -	dcode = (void *)req->ring;
> +	dcode = (uint32_t *)req->ring;
>  	*srisc_addr = 0;
>  	segments = FA_RISC_CODE_SEGMENTS;
>  	for (j = 0; j < segments; j++) {
>  		ql_dbg(ql_dbg_init, vha, 0x008d,
>  		    "-> Loading segment %u...\n", j);
>  		qla24xx_read_flash_data(vha, dcode, faddr, 10);
> -		risc_addr = be32_to_cpu(dcode[2]);
> -		risc_size = be32_to_cpu(dcode[3]);
> +		risc_addr = swab32(dcode[2]);
> +		risc_size = swab32(dcode[3]);
>  		if (!*srisc_addr) {
>  			*srisc_addr = risc_addr;
> -			risc_attr = be32_to_cpu(dcode[9]);
> +			risc_attr = swab32(dcode[9]);
>  		}

also here, this looks like hardcoded endianess.

> @@ -7769,9 +7772,9 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
>  		fwdt->template = NULL;
>  		fwdt->length = 0;
>  
> -		dcode = (void *)req->ring;
> +		dcode = (uint32_t *)req->ring;
>  		qla24xx_read_flash_data(vha, dcode, faddr, 7);
> -		risc_size = be32_to_cpu(dcode[2]);
> +		risc_size = swab32(dcode[2]);

dito.

>  		ql_dbg(ql_dbg_init, vha, 0x0161,
>  		    "-> fwdt%u template array at %#x (%#x dwords)\n",
>  		    j, faddr, risc_size);
> @@ -7840,7 +7843,8 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
>  {
>  	int	rval;
>  	int	i, fragment;
> -	uint16_t *wcode, *fwcode;
> +	uint16_t *wcode;
> +	__be16 *fwcode;
>  	uint32_t risc_addr, risc_size, fwclen, wlen, *seg;
>  	struct fw_blob *blob;
>  	struct qla_hw_data *ha = vha->hw;
> @@ -7860,7 +7864,7 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
>  
>  	wcode = (uint16_t *)req->ring;
>  	*srisc_addr = 0;
> -	fwcode = (uint16_t *)blob->fw->data;
> +	fwcode = (__force __be16 *)blob->fw->data;
>  	fwclen = 0;
>  
>  	/* Validate firmware image by checking version. */
> @@ -7908,7 +7912,7 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
>  			    "words 0x%x.\n", risc_addr, wlen);
>  
>  			for (i = 0; i < wlen; i++)
> -				wcode[i] = swab16(fwcode[i]);
> +				wcode[i] = swab16((__force u32)fwcode[i]);

dito.

> @@ -3216,7 +3217,7 @@ qla82xx_start_scsi(srb_t *sp)
>  	uint16_t	tot_dsds;
>  	struct device_reg_82xx __iomem *reg;
>  	uint32_t dbval;
> -	uint32_t *fcp_dl;
> +	__be32 *fcp_dl;
>  	uint8_t additional_cdb_len;
>  	struct ct6_dsd *ctx;
>  	struct scsi_qla_host *vha = sp->vha;
> @@ -3398,7 +3399,7 @@ qla82xx_start_scsi(srb_t *sp)
>  
>  		memcpy(ctx->fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
>  
> -		fcp_dl = (uint32_t *)(ctx->fcp_cmnd->cdb + 16 +
> +		fcp_dl = (void *)(ctx->fcp_cmnd->cdb + 16 +
>  		    additional_cdb_len);

Shouldn't this be (__be32*)?

>  		*fcp_dl = htonl((uint32_t)scsi_bufflen(cmd));



> @@ -3537,7 +3540,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
>  	}
>  
>  	for (i = 0; i < 4; i++)
> -		ha->gold_fw_version[i] = be32_to_cpu(dcode[4+i]);
> +		ha->gold_fw_version[i] = swab32(dcode[4+i]);
>  
>  	return ret;
>  }

Here again why the swab32() call.

Thanks,
Daniel

/me brain hurts now
