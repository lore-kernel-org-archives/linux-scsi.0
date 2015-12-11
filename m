From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2] hisi_sas: use platform_get_irq()
Date: Fri, 11 Dec 2015 12:56:43 +0100
Message-ID: <20151211115643.GA31151@c203.arch.suse.de>
References: <1449835401-200442-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449835401-200442-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, robh@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 11, 2015 at 08:03:21PM +0800, John Garry wrote:
> It is preferred that drivers use platform_get_irq()
> instead of irq_of_parse_and_map(), so replace.
>=20
> Signed-off-by: John Garry <john.garry@huawei.com>
> Acked-by: Rob Herring <robh@kernel.org>
>=20
> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas=
/hisi_sas.h
> index 30a9ab9..5af2e41 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas.h
> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
> @@ -16,7 +16,6 @@
>  #include <linux/mfd/syscon.h>
>  #include <linux/module.h>
>  #include <linux/of_address.h>
> -#include <linux/of_irq.h>
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
>  #include <scsi/libsas.h>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hi=
si_sas/hisi_sas_v1_hw.c
> index 0ed2f92..d543811 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> @@ -1673,19 +1673,16 @@ static irq_handler_t fatal_interrupts[HISI_SA=
S_MAX_QUEUES] =3D {
> =20
>  static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
>  {
> -	struct device *dev =3D &hisi_hba->pdev->dev;
> -	struct device_node *np =3D dev->of_node;
> +	struct platform_device *pdev =3D hisi_hba->pdev;
> +	struct device *dev =3D &pdev->dev;
>  	int i, j, irq, rc, idx;
> =20
> -	if (!np)
> -		return -ENOENT;
> -
>  	for (i =3D 0; i < hisi_hba->n_phy; i++) {
>  		struct hisi_sas_phy *phy =3D &hisi_hba->phy[i];
> =20
>  		idx =3D i * HISI_SAS_PHY_INT_NR;
>  		for (j =3D 0; j < HISI_SAS_PHY_INT_NR; j++, idx++) {
> -			irq =3D irq_of_parse_and_map(np, idx);
> +			irq =3D platform_get_irq(pdev, idx);
>  			if (!irq) {
>  				dev_err(dev,
>  					"irq init: fail map phy interrupt %d\n",
> @@ -1706,7 +1703,7 @@ static int interrupt_init_v1_hw(struct hisi_hba=
 *hisi_hba)
> =20
>  	idx =3D hisi_hba->n_phy * HISI_SAS_PHY_INT_NR;
>  	for (i =3D 0; i < hisi_hba->queue_count; i++, idx++) {
> -		irq =3D irq_of_parse_and_map(np, idx);
> +		irq =3D platform_get_irq(pdev, idx);
>  		if (!irq) {
>  			dev_err(dev, "irq init: could not map cq interrupt %d\n",
>  				idx);
> @@ -1724,7 +1721,7 @@ static int interrupt_init_v1_hw(struct hisi_hba=
 *hisi_hba)
> =20
>  	idx =3D (hisi_hba->n_phy * HISI_SAS_PHY_INT_NR) + hisi_hba->queue_c=
ount;
>  	for (i =3D 0; i < HISI_SAS_FATAL_INT_NR; i++, idx++) {
> -		irq =3D irq_of_parse_and_map(np, idx);
> +		irq =3D platform_get_irq(pdev, idx);
>  		if (!irq) {
>  			dev_err(dev, "irq init: could not map fatal interrupt %d\n",
>  				idx);
> --=20
> 1.9.1
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
