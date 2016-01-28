From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 07/11] qla2xxx: Avoid side effects when using
 endianizer macros.
Date: Thu, 28 Jan 2016 10:00:07 +0100
Message-ID: <20160128090007.GL27565@c203.arch.suse.de>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
 <1453914218-380-8-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbcA1JAK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 04:00:10 -0500
Content-Disposition: inline
In-Reply-To: <1453914218-380-8-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On Wed, Jan 27, 2016 at 12:03:34PM -0500, Himanshu Madhani wrote:
> From: Joe Carnuccio <joe.carnuccio@qlogic.com>
>=20
> Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c   |    4 +-
>  drivers/scsi/qla2xxx/qla_dbg.c    |  141 ++++++++++++++++++++-------=
----------
>  drivers/scsi/qla2xxx/qla_init.c   |   16 ++--
>  drivers/scsi/qla2xxx/qla_inline.h |    4 +-
>  drivers/scsi/qla2xxx/qla_mbx.c    |   16 ++--
>  drivers/scsi/qla2xxx/qla_sup.c    |   23 +++---
>  6 files changed, 106 insertions(+), 98 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/q=
la_attr.c
> index fadce04..4dc06a13 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -272,8 +272,8 @@ qla2x00_sysfs_write_nvram(struct file *filp, stru=
ct kobject *kobj,
> =20
>  		iter =3D (uint32_t *)buf;
>  		chksum =3D 0;
> -		for (cnt =3D 0; cnt < ((count >> 2) - 1); cnt++)
> -			chksum +=3D le32_to_cpu(*iter++);
> +		for (cnt =3D 0; cnt < ((count >> 2) - 1); cnt++, iter++)
> +			chksum +=3D le32_to_cpu(*iter);
>  		chksum =3D ~chksum + 1;
>  		*iter =3D cpu_to_le32(chksum);
>  	} else {
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/ql=
a_dbg.c
> index aa6694b..b64c504 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -294,8 +294,8 @@ qla24xx_read_window(struct device_reg_24xx __iome=
m *reg, uint32_t iobase,
> =20
>  	WRT_REG_DWORD(&reg->iobase_addr, iobase);
>  	dmp_reg =3D &reg->iobase_window;
> -	while (count--)
> -		*buf++ =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for ( ; count--; dmp_reg++)
> +		*buf++ =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	return buf;
>  }
> @@ -457,8 +457,8 @@ qla2xxx_read_window(struct device_reg_2xxx __iome=
m *reg, uint32_t count,
>  {
>  	uint16_t __iomem *dmp_reg =3D &reg->u.isp2300.fb_cmd;
> =20
> -	while (count--)
> -		*buf++ =3D htons(RD_REG_WORD(dmp_reg++));
> +	for ( ; count--; dmp_reg++)
> +		*buf++ =3D htons(RD_REG_WORD(dmp_reg));
>  }
> =20
>  static inline void *
> @@ -733,16 +733,18 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardw=
are_locked)
> =20
>  	if (rval =3D=3D QLA_SUCCESS) {
>  		dmp_reg =3D &reg->flash_address;
> -		for (cnt =3D 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++)
> -			fw->pbiu_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg++));
> +		for (cnt =3D 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++, dmp_reg++)
> +			fw->pbiu_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg));
> =20
>  		dmp_reg =3D &reg->u.isp2300.req_q_in;
> -		for (cnt =3D 0; cnt < sizeof(fw->risc_host_reg) / 2; cnt++)
> -			fw->risc_host_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg++));
> +		for (cnt =3D 0; cnt < sizeof(fw->risc_host_reg) / 2;
> +		    cnt++, dmp_reg++)
> +			fw->risc_host_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg));
> =20
>  		dmp_reg =3D &reg->u.isp2300.mailbox0;
> -		for (cnt =3D 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
> -			fw->mailbox_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg++));
> +		for (cnt =3D 0; cnt < sizeof(fw->mailbox_reg) / 2;
> +		    cnt++, dmp_reg++)
> +			fw->mailbox_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg));
> =20
>  		WRT_REG_WORD(&reg->ctrl_status, 0x40);
>  		qla2xxx_read_window(reg, 32, fw->resp_dma_reg);
> @@ -752,8 +754,9 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardwar=
e_locked)
> =20
>  		WRT_REG_WORD(&reg->ctrl_status, 0x00);
>  		dmp_reg =3D &reg->risc_hw;
> -		for (cnt =3D 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++)
> -			fw->risc_hdw_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg++));
> +		for (cnt =3D 0; cnt < sizeof(fw->risc_hdw_reg) / 2;
> +		    cnt++, dmp_reg++)
> +			fw->risc_hdw_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg));
> =20
>  		WRT_REG_WORD(&reg->pcr, 0x2000);
>  		qla2xxx_read_window(reg, 16, fw->risc_gp0_reg);
> @@ -896,25 +899,25 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardw=
are_locked)
>  	}
>  	if (rval =3D=3D QLA_SUCCESS) {
>  		dmp_reg =3D &reg->flash_address;
> -		for (cnt =3D 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++)
> -			fw->pbiu_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg++));
> +		for (cnt =3D 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++, dmp_reg++)
> +			fw->pbiu_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg));
> =20
>  		dmp_reg =3D &reg->u.isp2100.mailbox0;
> -		for (cnt =3D 0; cnt < ha->mbx_count; cnt++) {
> +		for (cnt =3D 0; cnt < ha->mbx_count; cnt++, dmp_reg++) {
>  			if (cnt =3D=3D 8)
>  				dmp_reg =3D &reg->u_end.isp2200.mailbox8;
> =20
> -			fw->mailbox_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg++));
> +			fw->mailbox_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg));
>  		}
> =20
>  		dmp_reg =3D &reg->u.isp2100.unused_2[0];
> -		for (cnt =3D 0; cnt < sizeof(fw->dma_reg) / 2; cnt++)
> -			fw->dma_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg++));
> +		for (cnt =3D 0; cnt < sizeof(fw->dma_reg) / 2; cnt++, dmp_reg++)
> +			fw->dma_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg));
> =20
>  		WRT_REG_WORD(&reg->ctrl_status, 0x00);
>  		dmp_reg =3D &reg->risc_hw;
> -		for (cnt =3D 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++)
> -			fw->risc_hdw_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg++));
> +		for (cnt =3D 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++, dmp_reg=
++)
> +			fw->risc_hdw_reg[cnt] =3D htons(RD_REG_WORD(dmp_reg));
> =20
>  		WRT_REG_WORD(&reg->pcr, 0x2000);
>  		qla2xxx_read_window(reg, 16, fw->risc_gp0_reg);
> @@ -1096,8 +1099,8 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardw=
are_locked)
> =20
>  	/* Host interface registers. */
>  	dmp_reg =3D &reg->flash_addr;
> -	for (cnt =3D 0; cnt < sizeof(fw->host_reg) / 4; cnt++)
> -		fw->host_reg[cnt] =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
> +		fw->host_reg[cnt] =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	/* Disable interrupts. */
>  	WRT_REG_DWORD(&reg->ictrl, 0);
> @@ -1129,8 +1132,8 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardw=
are_locked)
> =20
>  	/* Mailbox registers. */
>  	mbx_reg =3D &reg->mailbox0;
> -	for (cnt =3D 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
> -		fw->mailbox_reg[cnt] =3D htons(RD_REG_WORD(mbx_reg++));
> +	for (cnt =3D 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, dmp_reg++=
)
> +		fw->mailbox_reg[cnt] =3D htons(RD_REG_WORD(mbx_reg));
> =20
>  	/* Transfer sequence registers. */
>  	iter_reg =3D fw->xseq_gp_reg;
> @@ -1168,20 +1171,20 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int har=
dware_locked)
>  	iter_reg =3D fw->req0_dma_reg;
>  	iter_reg =3D qla24xx_read_window(reg, 0x7200, 8, iter_reg);
>  	dmp_reg =3D &reg->iobase_q;
> -	for (cnt =3D 0; cnt < 7; cnt++)
> -		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < 7; cnt++, dmp_reg++)
> +		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	iter_reg =3D fw->resp0_dma_reg;
>  	iter_reg =3D qla24xx_read_window(reg, 0x7300, 8, iter_reg);
>  	dmp_reg =3D &reg->iobase_q;
> -	for (cnt =3D 0; cnt < 7; cnt++)
> -		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < 7; cnt++, dmp_reg++)
> +		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	iter_reg =3D fw->req1_dma_reg;
>  	iter_reg =3D qla24xx_read_window(reg, 0x7400, 8, iter_reg);
>  	dmp_reg =3D &reg->iobase_q;
> -	for (cnt =3D 0; cnt < 7; cnt++)
> -		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < 7; cnt++, dmp_reg++)
> +		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	/* Transmit DMA registers. */
>  	iter_reg =3D fw->xmt0_dma_reg;
> @@ -1359,8 +1362,10 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hard=
ware_locked)
>  	RD_REG_DWORD(&reg->iobase_addr);
>  	WRT_REG_DWORD(&reg->iobase_window, 0x01);
>  	dmp_reg =3D &reg->iobase_c4;
> -	fw->pcie_regs[0] =3D htonl(RD_REG_DWORD(dmp_reg++));
> -	fw->pcie_regs[1] =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	fw->pcie_regs[0] =3D htonl(RD_REG_DWORD(dmp_reg));
> +	dmp_reg++;
> +	fw->pcie_regs[1] =3D htonl(RD_REG_DWORD(dmp_reg));
> +	dmp_reg++;
>  	fw->pcie_regs[2] =3D htonl(RD_REG_DWORD(dmp_reg));
>  	fw->pcie_regs[3] =3D htonl(RD_REG_DWORD(&reg->iobase_window));
> =20
> @@ -1369,8 +1374,8 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardw=
are_locked)
> =20
>  	/* Host interface registers. */
>  	dmp_reg =3D &reg->flash_addr;
> -	for (cnt =3D 0; cnt < sizeof(fw->host_reg) / 4; cnt++)
> -		fw->host_reg[cnt] =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
> +		fw->host_reg[cnt] =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	/* Disable interrupts. */
>  	WRT_REG_DWORD(&reg->ictrl, 0);
> @@ -1418,8 +1423,8 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardw=
are_locked)
> =20
>  	/* Mailbox registers. */
>  	mbx_reg =3D &reg->mailbox0;
> -	for (cnt =3D 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
> -		fw->mailbox_reg[cnt] =3D htons(RD_REG_WORD(mbx_reg++));
> +	for (cnt =3D 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++=
)
> +		fw->mailbox_reg[cnt] =3D htons(RD_REG_WORD(mbx_reg));
> =20
>  	/* Transfer sequence registers. */
>  	iter_reg =3D fw->xseq_gp_reg;
> @@ -1482,20 +1487,20 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int har=
dware_locked)
>  	iter_reg =3D fw->req0_dma_reg;
>  	iter_reg =3D qla24xx_read_window(reg, 0x7200, 8, iter_reg);
>  	dmp_reg =3D &reg->iobase_q;
> -	for (cnt =3D 0; cnt < 7; cnt++)
> -		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < 7; cnt++, dmp_reg++)
> +		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	iter_reg =3D fw->resp0_dma_reg;
>  	iter_reg =3D qla24xx_read_window(reg, 0x7300, 8, iter_reg);
>  	dmp_reg =3D &reg->iobase_q;
> -	for (cnt =3D 0; cnt < 7; cnt++)
> -		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < 7; cnt++, dmp_reg++)
> +		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	iter_reg =3D fw->req1_dma_reg;
>  	iter_reg =3D qla24xx_read_window(reg, 0x7400, 8, iter_reg);
>  	dmp_reg =3D &reg->iobase_q;
> -	for (cnt =3D 0; cnt < 7; cnt++)
> -		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < 7; cnt++, dmp_reg++)
> +		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	/* Transmit DMA registers. */
>  	iter_reg =3D fw->xmt0_dma_reg;
> @@ -1680,8 +1685,10 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hard=
ware_locked)
>  	RD_REG_DWORD(&reg->iobase_addr);
>  	WRT_REG_DWORD(&reg->iobase_window, 0x01);
>  	dmp_reg =3D &reg->iobase_c4;
> -	fw->pcie_regs[0] =3D htonl(RD_REG_DWORD(dmp_reg++));
> -	fw->pcie_regs[1] =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	fw->pcie_regs[0] =3D htonl(RD_REG_DWORD(dmp_reg));
> +	dmp_reg++;
> +	fw->pcie_regs[1] =3D htonl(RD_REG_DWORD(dmp_reg));
> +	dmp_reg++;
>  	fw->pcie_regs[2] =3D htonl(RD_REG_DWORD(dmp_reg));
>  	fw->pcie_regs[3] =3D htonl(RD_REG_DWORD(&reg->iobase_window));
> =20
> @@ -1690,8 +1697,8 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardw=
are_locked)
> =20
>  	/* Host interface registers. */
>  	dmp_reg =3D &reg->flash_addr;
> -	for (cnt =3D 0; cnt < sizeof(fw->host_reg) / 4; cnt++)
> -		fw->host_reg[cnt] =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
> +		fw->host_reg[cnt] =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	/* Disable interrupts. */
>  	WRT_REG_DWORD(&reg->ictrl, 0);
> @@ -1739,8 +1746,8 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardw=
are_locked)
> =20
>  	/* Mailbox registers. */
>  	mbx_reg =3D &reg->mailbox0;
> -	for (cnt =3D 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
> -		fw->mailbox_reg[cnt] =3D htons(RD_REG_WORD(mbx_reg++));
> +	for (cnt =3D 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++=
)
> +		fw->mailbox_reg[cnt] =3D htons(RD_REG_WORD(mbx_reg));
> =20
>  	/* Transfer sequence registers. */
>  	iter_reg =3D fw->xseq_gp_reg;
> @@ -1803,20 +1810,20 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int har=
dware_locked)
>  	iter_reg =3D fw->req0_dma_reg;
>  	iter_reg =3D qla24xx_read_window(reg, 0x7200, 8, iter_reg);
>  	dmp_reg =3D &reg->iobase_q;
> -	for (cnt =3D 0; cnt < 7; cnt++)
> -		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < 7; cnt++, dmp_reg++)
> +		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	iter_reg =3D fw->resp0_dma_reg;
>  	iter_reg =3D qla24xx_read_window(reg, 0x7300, 8, iter_reg);
>  	dmp_reg =3D &reg->iobase_q;
> -	for (cnt =3D 0; cnt < 7; cnt++)
> -		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < 7; cnt++, dmp_reg++)
> +		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	iter_reg =3D fw->req1_dma_reg;
>  	iter_reg =3D qla24xx_read_window(reg, 0x7400, 8, iter_reg);
>  	dmp_reg =3D &reg->iobase_q;
> -	for (cnt =3D 0; cnt < 7; cnt++)
> -		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < 7; cnt++, dmp_reg++)
> +		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	/* Transmit DMA registers. */
>  	iter_reg =3D fw->xmt0_dma_reg;
> @@ -2023,8 +2030,10 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hard=
ware_locked)
>  	RD_REG_DWORD(&reg->iobase_addr);
>  	WRT_REG_DWORD(&reg->iobase_window, 0x01);
>  	dmp_reg =3D &reg->iobase_c4;
> -	fw->pcie_regs[0] =3D htonl(RD_REG_DWORD(dmp_reg++));
> -	fw->pcie_regs[1] =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	fw->pcie_regs[0] =3D htonl(RD_REG_DWORD(dmp_reg));
> +	dmp_reg++;
> +	fw->pcie_regs[1] =3D htonl(RD_REG_DWORD(dmp_reg));
> +	dmp_reg++;
>  	fw->pcie_regs[2] =3D htonl(RD_REG_DWORD(dmp_reg));
>  	fw->pcie_regs[3] =3D htonl(RD_REG_DWORD(&reg->iobase_window));
> =20
> @@ -2033,8 +2042,8 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardw=
are_locked)
> =20
>  	/* Host interface registers. */
>  	dmp_reg =3D &reg->flash_addr;
> -	for (cnt =3D 0; cnt < sizeof(fw->host_reg) / 4; cnt++)
> -		fw->host_reg[cnt] =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
> +		fw->host_reg[cnt] =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	/* Disable interrupts. */
>  	WRT_REG_DWORD(&reg->ictrl, 0);
> @@ -2082,8 +2091,8 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardw=
are_locked)
> =20
>  	/* Mailbox registers. */
>  	mbx_reg =3D &reg->mailbox0;
> -	for (cnt =3D 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
> -		fw->mailbox_reg[cnt] =3D htons(RD_REG_WORD(mbx_reg++));
> +	for (cnt =3D 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, dmp_reg++=
)
> +		fw->mailbox_reg[cnt] =3D htons(RD_REG_WORD(mbx_reg));
> =20
>  	/* Transfer sequence registers. */
>  	iter_reg =3D fw->xseq_gp_reg;
> @@ -2178,20 +2187,20 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int har=
dware_locked)
>  	iter_reg =3D fw->req0_dma_reg;
>  	iter_reg =3D qla24xx_read_window(reg, 0x7200, 8, iter_reg);
>  	dmp_reg =3D &reg->iobase_q;
> -	for (cnt =3D 0; cnt < 7; cnt++)
> -		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < 7; cnt++, dmp_reg++)
> +		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	iter_reg =3D fw->resp0_dma_reg;
>  	iter_reg =3D qla24xx_read_window(reg, 0x7300, 8, iter_reg);
>  	dmp_reg =3D &reg->iobase_q;
> -	for (cnt =3D 0; cnt < 7; cnt++)
> -		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < 7; cnt++, dmp_reg++)
> +		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	iter_reg =3D fw->req1_dma_reg;
>  	iter_reg =3D qla24xx_read_window(reg, 0x7400, 8, iter_reg);
>  	dmp_reg =3D &reg->iobase_q;
> -	for (cnt =3D 0; cnt < 7; cnt++)
> -		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg++));
> +	for (cnt =3D 0; cnt < 7; cnt++, dmp_reg++)
> +		*iter_reg++ =3D htonl(RD_REG_DWORD(dmp_reg));
> =20
>  	/* Transmit DMA registers. */
>  	iter_reg =3D fw->xmt0_dma_reg;
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/q=
la_init.c
> index ffbc655..8001c89 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5125,8 +5125,8 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
>  	dptr =3D (uint32_t *)nv;
>  	ha->isp_ops->read_nvram(vha, (uint8_t *)dptr, ha->nvram_base,
>  	    ha->nvram_size);
> -	for (cnt =3D 0, chksum =3D 0; cnt < ha->nvram_size >> 2; cnt++)
> -		chksum +=3D le32_to_cpu(*dptr++);
> +	for (cnt =3D 0, chksum =3D 0; cnt < ha->nvram_size >> 2; cnt++, dpt=
r++)
> +		chksum +=3D le32_to_cpu(*dptr);
> =20
>  	ql_dbg(ql_dbg_init + ql_dbg_buffer, vha, 0x006a,
>  	    "Contents of NVRAM\n");
> @@ -5379,8 +5379,8 @@ uint8_t qla27xx_find_valid_image(struct scsi_ql=
a_host *vha)
>  	wptr =3D (uint32_t *)(&pri_image_status);
>  	cnt =3D size;
> =20
> -	for (chksum =3D 0; cnt; cnt--)
> -		chksum +=3D le32_to_cpu(*wptr++);
> +	for (chksum =3D 0; cnt--; wptr++)
> +		chksum +=3D le32_to_cpu(*wptr);
>  	if (chksum) {
>  		ql_dbg(ql_dbg_init, vha, 0x018c,
>  		    "Checksum validation failed for primary image (0x%x)\n",
> @@ -5407,8 +5407,8 @@ check_sec_image:
> =20
>  	wptr =3D (uint32_t *)(&sec_image_status);
>  	cnt =3D size;
> -	for (chksum =3D 0; cnt; cnt--)
> -		chksum +=3D le32_to_cpu(*wptr++);
> +	for (chksum =3D 0; cnt--; wptr++)
> +		chksum +=3D le32_to_cpu(*wptr);
>  	if (chksum) {
>  		ql_dbg(ql_dbg_init, vha, 0x018e,
>  		    "Checksum validation failed for secondary image (0x%x)\n",
> @@ -6161,8 +6161,8 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
>  	ha->isp_ops->read_optrom(vha, ha->nvram, ha->flt_region_nvram << 2,
>  	    ha->nvram_size);
>  	dptr =3D (uint32_t *)nv;
> -	for (cnt =3D 0, chksum =3D 0; cnt < ha->nvram_size >> 2; cnt++)
> -		chksum +=3D le32_to_cpu(*dptr++);
> +	for (cnt =3D 0, chksum =3D 0; cnt < ha->nvram_size >> 2; cnt++, dpt=
r++)
> +		chksum +=3D le32_to_cpu(*dptr);
> =20
>  	ql_dbg(ql_dbg_init + ql_dbg_buffer, vha, 0x0111,
>  	    "Contents of NVRAM:\n");
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx=
/qla_inline.h
> index a6b7f15..edc48f3 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -87,8 +87,8 @@ host_to_adap(uint8_t *src, uint8_t *dst, uint32_t b=
size)
>  	__le32 *odest =3D (__le32 *) dst;
>  	uint32_t iter =3D bsize >> 2;
> =20
> -	for (; iter ; iter--)
> -		*odest++ =3D cpu_to_le32(*isrc++);
> +	for ( ; iter--; isrc++)
> +		*odest++ =3D cpu_to_le32(*isrc);
>  }
> =20
>  static inline void
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/ql=
a_mbx.c
> index 3dd3398..968b846 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -2759,7 +2759,7 @@ qla2x00_get_link_status(scsi_qla_host_t *vha, u=
int16_t loop_id,
>  	int rval;
>  	mbx_cmd_t mc;
>  	mbx_cmd_t *mcp =3D &mc;
> -	uint32_t *siter, *diter, dwords;
> +	uint32_t *iter, dwords;
>  	struct qla_hw_data *ha =3D vha->hw;
> =20
>  	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1084,
> @@ -2801,9 +2801,9 @@ qla2x00_get_link_status(scsi_qla_host_t *vha, u=
int16_t loop_id,
>  			    "Done %s.\n", __func__);
>  			dwords =3D offsetof(struct link_statistics,
>  					link_up_cnt) / 4;
> -			siter =3D diter =3D &stats->link_fail_cnt;
> -			while (dwords--)
> -				*diter++ =3D le32_to_cpu(*siter++);
> +			iter =3D &stats->link_fail_cnt;
> +			for ( ; dwords--; iter++)
> +				le32_to_cpus(iter);
>  		}
>  	} else {
>  		/* Failed. */
> @@ -2820,7 +2820,7 @@ qla24xx_get_isp_stats(scsi_qla_host_t *vha, str=
uct link_statistics *stats,
>  	int rval;
>  	mbx_cmd_t mc;
>  	mbx_cmd_t *mcp =3D &mc;
> -	uint32_t *siter, *diter, dwords;
> +	uint32_t *iter, dwords;
> =20
>  	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1088,
>  	    "Entered %s.\n", __func__);
> @@ -2849,9 +2849,9 @@ qla24xx_get_isp_stats(scsi_qla_host_t *vha, str=
uct link_statistics *stats,
>  			    "Done %s.\n", __func__);
>  			/* Copy over data -- firmware data is LE. */
>  			dwords =3D sizeof(struct link_statistics) / 4;
> -			siter =3D diter =3D &stats->link_fail_cnt;
> -			while (dwords--)
> -				*diter++ =3D le32_to_cpu(*siter++);
> +			iter =3D &stats->link_fail_cnt;
> +			for ( ; dwords--; iter++)
> +				le32_to_cpus(iter);
>  		}
>  	} else {
>  		/* Failed. */
> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/ql=
a_sup.c
> index 786ead2..5e93923 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
> @@ -610,8 +610,8 @@ qla2xxx_find_flt_start(scsi_qla_host_t *vha, uint=
32_t *start)
> =20
>  	wptr =3D (uint16_t *)req->ring;
>  	cnt =3D sizeof(struct qla_flt_location) >> 1;
> -	for (chksum =3D 0; cnt; cnt--)
> -		chksum +=3D le16_to_cpu(*wptr++);
> +	for (chksum =3D 0; cnt--; wptr++)
> +		chksum +=3D le16_to_cpu(*wptr);
>  	if (chksum) {
>  		ql_log(ql_log_fatal, vha, 0x0045,
>  		    "Inconsistent FLTL detected: checksum=3D0x%x.\n", chksum);
> @@ -702,8 +702,8 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32=
_t flt_addr)
>  	}
> =20
>  	cnt =3D (sizeof(struct qla_flt_header) + le16_to_cpu(flt->length)) =
>> 1;
> -	for (chksum =3D 0; cnt; cnt--)
> -		chksum +=3D le16_to_cpu(*wptr++);
> +	for (chksum =3D 0; cnt--; wptr++)
> +		chksum +=3D le16_to_cpu(*wptr);
>  	if (chksum) {
>  		ql_log(ql_log_fatal, vha, 0x0048,
>  		    "Inconsistent FLT detected: version=3D0x%x length=3D0x%x check=
sum=3D0x%x.\n",
> @@ -930,9 +930,8 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *vha)
>  	    fdt->sig[3] !=3D 'D')
>  		goto no_flash_data;
> =20
> -	for (cnt =3D 0, chksum =3D 0; cnt < sizeof(struct qla_fdt_layout) >=
> 1;
> -	    cnt++)
> -		chksum +=3D le16_to_cpu(*wptr++);
> +	for (cnt =3D 0, chksum =3D 0; cnt < sizeof(*fdt) >> 1; cnt++, wptr+=
+)
> +		chksum +=3D le16_to_cpu(*wptr);
>  	if (chksum) {
>  		ql_dbg(ql_dbg_init, vha, 0x004c,
>  		    "Inconsistent FDT detected:"
> @@ -1027,7 +1026,8 @@ qla2xxx_get_idc_param(scsi_qla_host_t *vha)
>  		ha->fcoe_dev_init_timeout =3D QLA82XX_ROM_DEV_INIT_TIMEOUT;
>  		ha->fcoe_reset_timeout =3D QLA82XX_ROM_DRV_RESET_ACK_TIMEOUT;
>  	} else {
> -		ha->fcoe_dev_init_timeout =3D le32_to_cpu(*wptr++);
> +		ha->fcoe_dev_init_timeout =3D le32_to_cpu(*wptr);
> +		wptr++;
>  		ha->fcoe_reset_timeout =3D le32_to_cpu(*wptr);
>  	}
>  	ql_dbg(ql_dbg_init, vha, 0x004e,
> @@ -1104,10 +1104,9 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
>  	ha->isp_ops->read_optrom(vha, (uint8_t *)data,
>  	    ha->flt_region_npiv_conf << 2, NPIV_CONFIG_SIZE);
> =20
> -	cnt =3D (sizeof(struct qla_npiv_header) + le16_to_cpu(hdr.entries) =
*
> -	    sizeof(struct qla_npiv_entry)) >> 1;
> -	for (wptr =3D data, chksum =3D 0; cnt; cnt--)
> -		chksum +=3D le16_to_cpu(*wptr++);
> +	cnt =3D (sizeof(hdr) + le16_to_cpu(hdr.entries) * sizeof(*entry)) >=
> 1;
> +	for (wptr =3D data, chksum =3D 0; cnt--; wptr++)
> +		chksum +=3D le16_to_cpu(*wptr);
>  	if (chksum) {
>  		ql_dbg(ql_dbg_user, vha, 0x7092,
>  		    "Inconsistent NPIV-Config "
> --=20
> 1.7.7
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
