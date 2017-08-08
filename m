From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: scsi: qla2xxx: use dma_mapping_error to check map errors
Date: Tue, 8 Aug 2017 15:24:19 +0000
Message-ID: <543DFC27-27D2-4868-87C1-C941D752E966@cavium.com>
References: <1502200531-15219-1-git-send-email-bianpan2016@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502200531-15219-1-git-send-email-bianpan2016@163.com>
Content-Language: en-US
Content-ID: <04E49890295AE349B224E1DC166C4C1A@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pan Bian <bianpan2016@163.com>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> On Aug 8, 2017, at 6:55 AM, Pan Bian <bianpan2016@163.com> wrote:
>=20
> The return value of dma_map_single() should be checked by
> dma_mapping_error(). However, in function qla26xx_dport_diagnostics(), it=
s
> return value is checked against NULL, which could result in failures.
>=20
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
> drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 7c6d1a4..eafb709 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -5817,7 +5817,7 @@ struct cs84xx_mgmt_cmd {
>=20
> 	dd_dma =3D dma_map_single(&vha->hw->pdev->dev,
> 	    dd_buf, size, DMA_FROM_DEVICE);
> -	if (!dd_dma) {
> +	if (dma_mapping_error(&vha->hw->pdev->dev, dd_dma)) {
> 		ql_log(ql_log_warn, vha, 0x1194, "Failed to map dma buffer.\n");
> 		return QLA_MEMORY_ALLOC_FAILED;
> 	}
> --=20
> 1.9.1
>=20
>=20

Looks Good. Thanks for the patch=20

Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>

Thanks,
- Himanshu
