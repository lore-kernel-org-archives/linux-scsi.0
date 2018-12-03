From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [EXT] [PATCH] scsi: qla2xxx: NULL check before some freeing
 functions is not needed.
Date: Mon, 3 Dec 2018 18:07:57 +0000
Message-ID: <E79150BB-BD16-4A01-9938-761303E15B3B@cavium.com>
References: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
 <1543760930052-275330559-13-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543760930052-275330559-13-diffsplit-thomas@m3y3r.de>
Content-Language: en-US
Content-ID: <C5F60E2152C76D4C8874DB1503106190@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> On Dec 2, 2018, at 12:52 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> External Email
>=20
> NULL check before some freeing functions is not needed.
>=20
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
>=20
> diff -u -p a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4191,12 +4191,10 @@ fail_free_nvram:
>        kfree(ha->nvram);
>        ha->nvram =3D NULL;
> fail_free_ctx_mempool:
> -       if (ha->ctx_mempool)
> -               mempool_destroy(ha->ctx_mempool);
> +       mempool_destroy(ha->ctx_mempool);
>        ha->ctx_mempool =3D NULL;
> fail_free_srb_mempool:
> -       if (ha->srb_mempool)
> -               mempool_destroy(ha->srb_mempool);
> +       mempool_destroy(ha->srb_mempool);
>        ha->srb_mempool =3D NULL;
> fail_free_gid_list:
>        dma_free_coherent(&ha->pdev->dev, qla2x00_gid_list_size(ha),
> @@ -4498,8 +4496,7 @@ qla2x00_mem_free(struct qla_hw_data *ha)
>                dma_free_coherent(&ha->pdev->dev, MCTP_DUMP_SIZE, ha->mctp=
_dump,
>                    ha->mctp_dump_dma);
>=20
> -       if (ha->srb_mempool)
> -               mempool_destroy(ha->srb_mempool);
> +       mempool_destroy(ha->srb_mempool);
>=20
>        if (ha->dcbx_tlv)
>                dma_free_coherent(&ha->pdev->dev, DCBX_TLV_DATA_SIZE,
> @@ -4531,8 +4528,7 @@ qla2x00_mem_free(struct qla_hw_data *ha)
>        if (ha->async_pd)
>                dma_pool_free(ha->s_dma_pool, ha->async_pd, ha->async_pd_d=
ma);
>=20
> -       if (ha->s_dma_pool)
> -               dma_pool_destroy(ha->s_dma_pool);
> +       dma_pool_destroy(ha->s_dma_pool);
>=20
>        if (ha->gid_list)
>                dma_free_coherent(&ha->pdev->dev, qla2x00_gid_list_size(ha=
),
> @@ -4553,14 +4549,11 @@ qla2x00_mem_free(struct qla_hw_data *ha)
>                }
>        }
>=20
> -       if (ha->dl_dma_pool)
> -               dma_pool_destroy(ha->dl_dma_pool);
> +       dma_pool_destroy(ha->dl_dma_pool);
>=20
> -       if (ha->fcp_cmnd_dma_pool)
> -               dma_pool_destroy(ha->fcp_cmnd_dma_pool);
> +       dma_pool_destroy(ha->fcp_cmnd_dma_pool);
>=20
> -       if (ha->ctx_mempool)
> -               mempool_destroy(ha->ctx_mempool);
> +       mempool_destroy(ha->ctx_mempool);
>=20
>        qlt_mem_free(ha);
>=20
> @@ -7106,8 +7099,7 @@ qla2x00_module_exit(void)
>        qla2x00_release_firmware();
>        kmem_cache_destroy(srb_cachep);
>        qlt_exit();
> -       if (ctx_cachep)
> -               kmem_cache_destroy(ctx_cachep);
> +       kmem_cache_destroy(ctx_cachep);
>        fc_release_transport(qla2xxx_transport_template);
>        fc_release_transport(qla2xxx_transport_vport_template);
> }

Looks good.=20

Acked-by: Himanshu Madhani <hmadhani@marvell.com>

Thanks,
- Himanshu
