From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 5/6] scsi: qla2xxx: Cocci spatch "pool_zalloc-simple"
Date: Fri, 22 Sep 2017 17:25:16 +0000
Message-ID: <BE506DAC-4866-4DC6-9F61-AB58990B5B5F@cavium.com>
References: <1505974468535-2047238743-0-diffsplit-thomas@m3y3r.de>
 <1505974468535-1220930483-5-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505974468535-1220930483-5-diffsplit-thomas@m3y3r.de>
Content-Language: en-US
Content-ID: <73EFC56AC97E744FA968998E4FA5720A@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> On Sep 20, 2017, at 11:15 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
>=20
> Use *_pool_zalloc rather than *_pool_alloc followed by memset with 0.
> Found by coccinelle spatch "api/alloc/pool_zalloc-simple.cocci"
>=20
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
>=20
> diff -u -p a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -1116,14 +1116,13 @@ qla84xx_mgmt_cmd(struct bsg_job *bsg_job
> 		return -EINVAL;
> 	}
>=20
> -	mn =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
> +	mn =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
> 	if (!mn) {
> 		ql_log(ql_log_warn, vha, 0x703c,
> 		    "DMA alloc failed for fw buffer.\n");
> 		return -ENOMEM;
> 	}
>=20
> -	memset(mn, 0, sizeof(struct access_chip_84xx));
> 	mn->entry_type =3D ACCESS_CHIP_IOCB_TYPE;
> 	mn->entry_count =3D 1;
> 	ql84_mgmt =3D (void *)bsg_request + sizeof(struct fc_bsg_request);
> diff -u -p a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -812,13 +812,12 @@ int qla24xx_async_gpdb(struct scsi_qla_h
> 	sp->gen2 =3D fcport->login_gen;
> 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
>=20
> -	pd =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
> +	pd =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
> 	if (pd =3D=3D NULL) {
> 		ql_log(ql_log_warn, vha, 0xd043,
> 		    "Failed to allocate port database structure.\n");
> 		goto done_free_sp;
> 	}
> -	memset(pd, 0, max(PORT_DATABASE_SIZE, PORT_DATABASE_24XX_SIZE));
>=20
> 	mb =3D sp->u.iocb_cmd.u.mbx.out_mb;
> 	mb[0] =3D MBC_GET_PORT_DATABASE;
> diff -u -p a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -1782,13 +1782,12 @@ qla2x00_get_port_database(scsi_qla_host_
> 	    "Entered %s.\n", __func__);
>=20
> 	pd24 =3D NULL;
> -	pd =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
> +	pd =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
> 	if (pd  =3D=3D NULL) {
> 		ql_log(ql_log_warn, vha, 0x1050,
> 		    "Failed to allocate port database structure.\n");
> 		return QLA_MEMORY_ALLOC_FAILED;
> 	}
> -	memset(pd, 0, max(PORT_DATABASE_SIZE, PORT_DATABASE_24XX_SIZE));
>=20
> 	mcp->mb[0] =3D MBC_GET_PORT_DATABASE;
> 	if (opt !=3D 0 && !IS_FWI2_CAPABLE(ha))
> @@ -2255,13 +2254,12 @@ qla24xx_login_fabric(scsi_qla_host_t *vh
> 	else
> 		req =3D ha->req_q_map[0];
>=20
> -	lg =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
> +	lg =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
> 	if (lg =3D=3D NULL) {
> 		ql_log(ql_log_warn, vha, 0x1062,
> 		    "Failed to allocate login IOCB.\n");
> 		return QLA_MEMORY_ALLOC_FAILED;
> 	}
> -	memset(lg, 0, sizeof(struct logio_entry_24xx));
>=20
> 	lg->entry_type =3D LOGINOUT_PORT_IOCB_TYPE;
> 	lg->entry_count =3D 1;
> @@ -2525,13 +2523,12 @@ qla24xx_fabric_logout(scsi_qla_host_t *v
> 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x106d,
> 	    "Entered %s.\n", __func__);
>=20
> -	lg =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
> +	lg =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
> 	if (lg =3D=3D NULL) {
> 		ql_log(ql_log_warn, vha, 0x106e,
> 		    "Failed to allocate logout IOCB.\n");
> 		return QLA_MEMORY_ALLOC_FAILED;
> 	}
> -	memset(lg, 0, sizeof(struct logio_entry_24xx));
>=20
> 	req =3D vha->req;
> 	lg->entry_type =3D LOGINOUT_PORT_IOCB_TYPE;
> @@ -2820,13 +2817,12 @@ qla2x00_get_fcal_position_map(scsi_qla_h
> 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x107f,
> 	    "Entered %s.\n", __func__);
>=20
> -	pmap =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pmap_dma);
> +	pmap =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &pmap_dma);
> 	if (pmap  =3D=3D NULL) {
> 		ql_log(ql_log_warn, vha, 0x1080,
> 		    "Memory alloc failed.\n");
> 		return QLA_MEMORY_ALLOC_FAILED;
> 	}
> -	memset(pmap, 0, FCAL_MAP_SIZE);
>=20
> 	mcp->mb[0] =3D MBC_GET_FC_AL_POSITION_MAP;
> 	mcp->mb[2] =3D MSW(pmap_dma);
> @@ -3014,13 +3010,12 @@ qla24xx_abort_command(srb_t *sp)
> 		return QLA_FUNCTION_FAILED;
> 	}
>=20
> -	abt =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &abt_dma);
> +	abt =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &abt_dma);
> 	if (abt =3D=3D NULL) {
> 		ql_log(ql_log_warn, vha, 0x108d,
> 		    "Failed to allocate abort IOCB.\n");
> 		return QLA_MEMORY_ALLOC_FAILED;
> 	}
> -	memset(abt, 0, sizeof(struct abort_entry_24xx));
>=20
> 	abt->entry_type =3D ABORT_IOCB_TYPE;
> 	abt->entry_count =3D 1;
> @@ -3098,13 +3093,12 @@ __qla24xx_issue_tmf(char *name, uint32_t
> 		rsp =3D req->rsp;
> 	}
>=20
> -	tsk =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &tsk_dma);
> +	tsk =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &tsk_dma);
> 	if (tsk =3D=3D NULL) {
> 		ql_log(ql_log_warn, vha, 0x1093,
> 		    "Failed to allocate task management IOCB.\n");
> 		return QLA_MEMORY_ALLOC_FAILED;
> 	}
> -	memset(tsk, 0, sizeof(struct tsk_mgmt_cmd));
>=20
> 	tsk->p.tsk.entry_type =3D TSK_MGMT_IOCB_TYPE;
> 	tsk->p.tsk.entry_count =3D 1;
> @@ -3856,14 +3850,13 @@ qla24xx_modify_vp_config(scsi_qla_host_t
> 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10bb,
> 	    "Entered %s.\n", __func__);
>=20
> -	vpmod =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &vpmod_dma);
> +	vpmod =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &vpmod_dma);
> 	if (!vpmod) {
> 		ql_log(ql_log_warn, vha, 0x10bc,
> 		    "Failed to allocate modify VP IOCB.\n");
> 		return QLA_MEMORY_ALLOC_FAILED;
> 	}
>=20
> -	memset(vpmod, 0, sizeof(struct vp_config_entry_24xx));
> 	vpmod->entry_type =3D VP_CONFIG_IOCB_TYPE;
> 	vpmod->entry_count =3D 1;
> 	vpmod->command =3D VCT_COMMAND_MOD_ENABLE_VPS;
> @@ -3934,13 +3927,12 @@ qla24xx_control_vp(scsi_qla_host_t *vha,
> 	if (vp_index =3D=3D 0 || vp_index >=3D ha->max_npiv_vports)
> 		return QLA_PARAMETER_ERROR;
>=20
> -	vce =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &vce_dma);
> +	vce =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &vce_dma);
> 	if (!vce) {
> 		ql_log(ql_log_warn, vha, 0x10c2,
> 		    "Failed to allocate VP control IOCB.\n");
> 		return QLA_MEMORY_ALLOC_FAILED;
> 	}
> -	memset(vce, 0, sizeof(struct vp_ctrl_entry_24xx));
>=20
> 	vce->entry_type =3D VP_CTRL_IOCB_TYPE;
> 	vce->entry_count =3D 1;
> @@ -6025,13 +6017,12 @@ int qla24xx_gpdb_wait(struct scsi_qla_ho
> 	if (!vha->hw->flags.fw_started)
> 		goto done;
>=20
> -	pd =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
> +	pd =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
> 	if (pd  =3D=3D NULL) {
> 		ql_log(ql_log_warn, vha, 0xd047,
> 		    "Failed to allocate port database structure.\n");
> 		goto done_free_sp;
> 	}
> -	memset(pd, 0, max(PORT_DATABASE_SIZE, PORT_DATABASE_24XX_SIZE));
>=20
> 	memset(&mc, 0, sizeof(mc));
> 	mc.mb[0] =3D MBC_GET_PORT_DATABASE;

Looks good.

Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>

Thanks,
- Himanshu
