From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 2/9] scsi: qla2xxx: Use zeroing allocator rather than
 allocator/memset
Date: Tue, 2 Jan 2018 17:01:55 +0000
Message-ID: <A0B01AD5-CD76-4E3A-BD78-141B81B12003@cavium.com>
References: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
 <1514647712-6332-3-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514647712-6332-3-git-send-email-himanshujha199640@gmail.com>
Content-Language: en-US
Content-ID: <353ED7323B02A14BAEF6D3A9FEE234CD@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "aacraid@adaptec.com" <aacraid@adaptec.com>, "Gurumurthy, Anil" <Anil.Gurumurthy@cavium.com>, "Kalluru, Sudarsana" <Sudarsana.Kalluru@cavium.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "satishkh@cisco.com" <satishkh@cisco.com>, "sebaddel@cisco.com" <sebaddel@cisco.com>, "kartilak@cisco.com" <kartilak@cisco.com>Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> On Dec 30, 2017, at 7:28 AM, Himanshu Jha <himanshujha199640@gmail.com> w=
rote:
>=20
> Use dma_zalloc_coherent and vzalloc instead of dma_alloc_coherent and
> vmalloc respectively, followed by memset 0.
>=20
> Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
>=20
> Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> ---
> drivers/scsi/qla2xxx/qla_attr.c    | 5 ++---
> drivers/scsi/qla2xxx/qla_bsg.c     | 9 +++------
> drivers/scsi/qla2xxx/tcm_qla2xxx.c | 5 +----
> 3 files changed, 6 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 9ce28c4..f46b015 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1843,14 +1843,13 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost=
)
> 	if (qla2x00_reset_active(vha))
> 		goto done;
>=20
> -	stats =3D dma_alloc_coherent(&ha->pdev->dev,
> -	    sizeof(*stats), &stats_dma, GFP_KERNEL);
> +	stats =3D dma_zalloc_coherent(&ha->pdev->dev, sizeof(*stats),
> +				    &stats_dma, GFP_KERNEL);
> 	if (!stats) {
> 		ql_log(ql_log_warn, vha, 0x707d,
> 		    "Failed to allocate memory for stats.\n");
> 		goto done;
> 	}
> -	memset(stats, 0, sizeof(*stats));
>=20
> 	rval =3D QLA_FUNCTION_FAILED;
> 	if (IS_FWI2_CAPABLE(ha)) {
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index e3ac707..e2d5d3c 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -1435,7 +1435,7 @@ qla2x00_optrom_setup(struct bsg_job *bsg_job, scsi_=
qla_host_t *vha,
> 		ha->optrom_state =3D QLA_SREADING;
> 	}
>=20
> -	ha->optrom_buffer =3D vmalloc(ha->optrom_region_size);
> +	ha->optrom_buffer =3D vzalloc(ha->optrom_region_size);
> 	if (!ha->optrom_buffer) {
> 		ql_log(ql_log_warn, vha, 0x7059,
> 		    "Read: Unable to allocate memory for optrom retrieval "
> @@ -1445,7 +1445,6 @@ qla2x00_optrom_setup(struct bsg_job *bsg_job, scsi_=
qla_host_t *vha,
> 		return -ENOMEM;
> 	}
>=20
> -	memset(ha->optrom_buffer, 0, ha->optrom_region_size);
> 	return 0;
> }
>=20
> @@ -2314,16 +2313,14 @@ qla2x00_get_priv_stats(struct bsg_job *bsg_job)
> 	if (!IS_FWI2_CAPABLE(ha))
> 		return -EPERM;
>=20
> -	stats =3D dma_alloc_coherent(&ha->pdev->dev,
> -		sizeof(*stats), &stats_dma, GFP_KERNEL);
> +	stats =3D dma_zalloc_coherent(&ha->pdev->dev, sizeof(*stats),
> +				    &stats_dma, GFP_KERNEL);
> 	if (!stats) {
> 		ql_log(ql_log_warn, vha, 0x70e2,
> 		    "Failed to allocate memory for stats.\n");
> 		return -ENOMEM;
> 	}
>=20
> -	memset(stats, 0, sizeof(*stats));
> -
> 	rval =3D qla24xx_get_isp_stats(base_vha, stats, stats_dma, options);
>=20
> 	if (rval =3D=3D QLA_SUCCESS) {
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tc=
m_qla2xxx.c
> index 3f82ea1..aadfeaa 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1635,16 +1635,13 @@ static int tcm_qla2xxx_init_lport(struct tcm_qla2=
xxx_lport *lport)
> 		return rc;
> 	}
>=20
> -	lport->lport_loopid_map =3D vmalloc(sizeof(struct tcm_qla2xxx_fc_loopid=
) *
> -				65536);
> +	lport->lport_loopid_map =3D vzalloc(sizeof(struct tcm_qla2xxx_fc_loopid=
) * 65536);
> 	if (!lport->lport_loopid_map) {
> 		pr_err("Unable to allocate lport->lport_loopid_map of %zu bytes\n",
> 		    sizeof(struct tcm_qla2xxx_fc_loopid) * 65536);
> 		btree_destroy32(&lport->lport_fcport_map);
> 		return -ENOMEM;
> 	}
> -	memset(lport->lport_loopid_map, 0, sizeof(struct tcm_qla2xxx_fc_loopid)
> -	       * 65536);
> 	pr_debug("qla2xxx: Allocated lport_loopid_map of %zu bytes\n",
> 	       sizeof(struct tcm_qla2xxx_fc_loopid) * 65536);
> 	return 0;
> --=20
> 2.7.4
>=20

Looks good

Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>=
