From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH_v2]_[PATCH]_drive?=
 =?utf-8?Q?rs:_scsi:_mvsas:_fix_compili?=
 =?utf-8?Q?ng_issue_by_adding_'MVS=5F'_for_"enum_pci=5Finterrupt=5Fcause"?=
Date: Wed, 21 May 2014 17:34:42 +0800 (CST)
Message-ID: <1315378557.42303.1400664882967.JavaMail.root@bj-mail03.pku.edu.cn>
References: <536C2D2B.6090501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <536C2D2B.6090501@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: JBottomley@parallels.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I checked these two files, and this patch looks good.
And, I'll put it into unicore32 repo.

Reviewed-by: Xuetao Guan <gxt@mprc.pku.edu.cn>


----- Chen Gang <gang.chen.5i5j@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> The direct cause is IRQ_SPI is already defined as a macro in unicore3=
2
> architecture (also, blackfin and mips architectures define it). The
> related error (unicore32  with allmodconfig)
>=20
>     CC [M]  drivers/scsi/mvsas/mv_94xx.o
>   In file included from drivers/scsi/mvsas/mv_94xx.c:27:
>   drivers/scsi/mvsas/mv_94xx.h:176: error: expected identifier before=
 numeric constant
>=20
> And IRQ_SAS_A and IRQ_SAS_B are used as 'u32' (although "enum
> pci_interrupt_cause" is not used directly, now).
>=20
> All together, need add 'MVS_' for "enum pci_interrupt_cause".
>=20
>=20
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/scsi/mvsas/mv_94xx.c | 10 ++++----
>  drivers/scsi/mvsas/mv_94xx.h | 58 ++++++++++++++++++++++------------=
----------
>  2 files changed, 34 insertions(+), 34 deletions(-)
>=20
> diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94x=
x.c
> index 1e4479f..9270d15 100644
> --- a/drivers/scsi/mvsas/mv_94xx.c
> +++ b/drivers/scsi/mvsas/mv_94xx.c
> @@ -564,7 +564,7 @@ static void mvs_94xx_interrupt_enable(struct mvs_=
info *mvi)
>  	u32 tmp;
> =20
>  	tmp =3D mr32(MVS_GBL_CTL);
> -	tmp |=3D (IRQ_SAS_A | IRQ_SAS_B);
> +	tmp |=3D (MVS_IRQ_SAS_A | MVS_IRQ_SAS_B);
>  	mw32(MVS_GBL_INT_STAT, tmp);
>  	writel(tmp, regs + 0x0C);
>  	writel(tmp, regs + 0x10);
> @@ -580,7 +580,7 @@ static void mvs_94xx_interrupt_disable(struct mvs=
_info *mvi)
> =20
>  	tmp =3D mr32(MVS_GBL_CTL);
> =20
> -	tmp &=3D ~(IRQ_SAS_A | IRQ_SAS_B);
> +	tmp &=3D ~(MVS_IRQ_SAS_A | MVS_IRQ_SAS_B);
>  	mw32(MVS_GBL_INT_STAT, tmp);
>  	writel(tmp, regs + 0x0C);
>  	writel(tmp, regs + 0x10);
> @@ -596,7 +596,7 @@ static u32 mvs_94xx_isr_status(struct mvs_info *m=
vi, int irq)
>  	if (!(mvi->flags & MVF_FLAG_SOC)) {
>  		stat =3D mr32(MVS_GBL_INT_STAT);
> =20
> -		if (!(stat & (IRQ_SAS_A | IRQ_SAS_B)))
> +		if (!(stat & (MVS_IRQ_SAS_A | MVS_IRQ_SAS_B)))
>  			return 0;
>  	}
>  	return stat;
> @@ -606,8 +606,8 @@ static irqreturn_t mvs_94xx_isr(struct mvs_info *=
mvi, int irq, u32 stat)
>  {
>  	void __iomem *regs =3D mvi->regs;
> =20
> -	if (((stat & IRQ_SAS_A) && mvi->id =3D=3D 0) ||
> -			((stat & IRQ_SAS_B) && mvi->id =3D=3D 1)) {
> +	if (((stat & MVS_IRQ_SAS_A) && mvi->id =3D=3D 0) ||
> +			((stat & MVS_IRQ_SAS_B) && mvi->id =3D=3D 1)) {
>  		mw32_f(MVS_INT_STAT, CINT_DONE);
> =20
>  		spin_lock(&mvi->lock);
> diff --git a/drivers/scsi/mvsas/mv_94xx.h b/drivers/scsi/mvsas/mv_94x=
x.h
> index 487aa6f..14e1974 100644
> --- a/drivers/scsi/mvsas/mv_94xx.h
> +++ b/drivers/scsi/mvsas/mv_94xx.h
> @@ -150,35 +150,35 @@ enum chip_register_bits {
> =20
>  enum pci_interrupt_cause {
>  	/*  MAIN_IRQ_CAUSE (R10200) Bits*/
> -	IRQ_COM_IN_I2O_IOP0            =3D (1 << 0),
> -	IRQ_COM_IN_I2O_IOP1            =3D (1 << 1),
> -	IRQ_COM_IN_I2O_IOP2            =3D (1 << 2),
> -	IRQ_COM_IN_I2O_IOP3            =3D (1 << 3),
> -	IRQ_COM_OUT_I2O_HOS0           =3D (1 << 4),
> -	IRQ_COM_OUT_I2O_HOS1           =3D (1 << 5),
> -	IRQ_COM_OUT_I2O_HOS2           =3D (1 << 6),
> -	IRQ_COM_OUT_I2O_HOS3           =3D (1 << 7),
> -	IRQ_PCIF_TO_CPU_DRBL0          =3D (1 << 8),
> -	IRQ_PCIF_TO_CPU_DRBL1          =3D (1 << 9),
> -	IRQ_PCIF_TO_CPU_DRBL2          =3D (1 << 10),
> -	IRQ_PCIF_TO_CPU_DRBL3          =3D (1 << 11),
> -	IRQ_PCIF_DRBL0                 =3D (1 << 12),
> -	IRQ_PCIF_DRBL1                 =3D (1 << 13),
> -	IRQ_PCIF_DRBL2                 =3D (1 << 14),
> -	IRQ_PCIF_DRBL3                 =3D (1 << 15),
> -	IRQ_XOR_A                      =3D (1 << 16),
> -	IRQ_XOR_B                      =3D (1 << 17),
> -	IRQ_SAS_A                      =3D (1 << 18),
> -	IRQ_SAS_B                      =3D (1 << 19),
> -	IRQ_CPU_CNTRL                  =3D (1 << 20),
> -	IRQ_GPIO                       =3D (1 << 21),
> -	IRQ_UART                       =3D (1 << 22),
> -	IRQ_SPI                        =3D (1 << 23),
> -	IRQ_I2C                        =3D (1 << 24),
> -	IRQ_SGPIO                      =3D (1 << 25),
> -	IRQ_COM_ERR                    =3D (1 << 29),
> -	IRQ_I2O_ERR                    =3D (1 << 30),
> -	IRQ_PCIE_ERR                   =3D (1 << 31),
> +	MVS_IRQ_COM_IN_I2O_IOP0        =3D (1 << 0),
> +	MVS_IRQ_COM_IN_I2O_IOP1        =3D (1 << 1),
> +	MVS_IRQ_COM_IN_I2O_IOP2        =3D (1 << 2),
> +	MVS_IRQ_COM_IN_I2O_IOP3        =3D (1 << 3),
> +	MVS_IRQ_COM_OUT_I2O_HOS0       =3D (1 << 4),
> +	MVS_IRQ_COM_OUT_I2O_HOS1       =3D (1 << 5),
> +	MVS_IRQ_COM_OUT_I2O_HOS2       =3D (1 << 6),
> +	MVS_IRQ_COM_OUT_I2O_HOS3       =3D (1 << 7),
> +	MVS_IRQ_PCIF_TO_CPU_DRBL0      =3D (1 << 8),
> +	MVS_IRQ_PCIF_TO_CPU_DRBL1      =3D (1 << 9),
> +	MVS_IRQ_PCIF_TO_CPU_DRBL2      =3D (1 << 10),
> +	MVS_IRQ_PCIF_TO_CPU_DRBL3      =3D (1 << 11),
> +	MVS_IRQ_PCIF_DRBL0             =3D (1 << 12),
> +	MVS_IRQ_PCIF_DRBL1             =3D (1 << 13),
> +	MVS_IRQ_PCIF_DRBL2             =3D (1 << 14),
> +	MVS_IRQ_PCIF_DRBL3             =3D (1 << 15),
> +	MVS_IRQ_XOR_A                  =3D (1 << 16),
> +	MVS_IRQ_XOR_B                  =3D (1 << 17),
> +	MVS_IRQ_SAS_A                  =3D (1 << 18),
> +	MVS_IRQ_SAS_B                  =3D (1 << 19),
> +	MVS_IRQ_CPU_CNTRL              =3D (1 << 20),
> +	MVS_IRQ_GPIO                   =3D (1 << 21),
> +	MVS_IRQ_UART                   =3D (1 << 22),
> +	MVS_IRQ_SPI                    =3D (1 << 23),
> +	MVS_IRQ_I2C                    =3D (1 << 24),
> +	MVS_IRQ_SGPIO                  =3D (1 << 25),
> +	MVS_IRQ_COM_ERR                =3D (1 << 29),
> +	MVS_IRQ_I2O_ERR                =3D (1 << 30),
> +	MVS_IRQ_PCIE_ERR               =3D (1 << 31),
>  };
> =20
>  union reg_phy_cfg {
> --=20
> 1.9.2.459.g68773ac
