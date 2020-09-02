Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6EDCC433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 17:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75F74208C7
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 17:38:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WMjSW4na"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgIBRiM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 13:38:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48476 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbgIBRiM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 13:38:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082HXuJ1037730;
        Wed, 2 Sep 2020 17:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=nY87QS0WOA2PlMaFUteDBeKSKZcBliTK/FYDPZo4WUM=;
 b=WMjSW4naeD+11Al5OIysNTz3Ru1Ks1DJpz9gQMrybVcfm1DhaQJCOExlOhFIFyhsN1jq
 fV8ro0EFnGJyd90R6DAcyokJkaiG/FCcAKCJNJHdfCrm8Vg8tUxtAUrO47s2RA7kijpZ
 KDV9O4+ZTpH0gNrT3Pde92M4qTorI2kyL+puP7puXDLcsywRskIsGblR2kzF9Zy0R6sj
 3fPdLp66v5W5Kb68f05nbKEnGwBQPIhav7V/DSb1bVsjA/nakXgiYqZ0iiy4CdUTkAaW
 bkItIGz+Go4wC9AZoauq4Q70mn9fFjDyBo7nhE+lV6bjoI1LvwPIzQBEEGk91kaumY41 mA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 339dmn2knm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 17:38:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082HZEJB013799;
        Wed, 2 Sep 2020 17:38:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3380kqck4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 17:38:06 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 082Hc57B012484;
        Wed, 2 Sep 2020 17:38:05 GMT
Received: from dhcp-10-154-155-248.vpn.oracle.com (/10.154.155.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 10:38:05 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 11/13] qla2xxx: Add IOCB resource tracking
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200902072548.11491-12-njavali@marvell.com>
Date:   Wed, 2 Sep 2020 12:38:04 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C716B0E0-21D3-4C6C-83A5-3CD46E3BA215@oracle.com>
References: <20200902072548.11491-1-njavali@marvell.com>
 <20200902072548.11491-12-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=11 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=11
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020167
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 2, 2020, at 2:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> This patch tracks number of IOCB resources used in the IO
> fast path. If the number of used IOCBs reach a high water
> limit, driver would return the IO as busy and let upper layer
> retry. This prevents over subscription of IOCB resources where
> any future error recovery command is unable to cut through.
> Enable IOCB throttling by default.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h    | 17 ++++++++++
> drivers/scsi/qla2xxx/qla_dfs.c    | 14 ++++++++
> drivers/scsi/qla2xxx/qla_gbl.h    |  3 ++
> drivers/scsi/qla2xxx/qla_init.c   | 26 +++++++++++++++
> drivers/scsi/qla2xxx/qla_inline.h | 55 +++++++++++++++++++++++++++++++
> drivers/scsi/qla2xxx/qla_iocb.c   | 28 ++++++++++++++++
> drivers/scsi/qla2xxx/qla_isr.c    |  2 ++
> drivers/scsi/qla2xxx/qla_os.c     |  6 ++++
> 8 files changed, 151 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h =
b/drivers/scsi/qla2xxx/qla_def.h
> index 3ca8665638c4..863b9c7766e1 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -624,6 +624,12 @@ enum {
> 	TYPE_TGT_TMCMD,		/* task management */
> };
>=20
> +struct iocb_resource {
> +	u8 res_type;
> +	u8 pad;
> +	u16 iocb_cnt;
> +};
> +
> typedef struct srb {
> 	/*
> 	 * Do not move cmd_type field, it needs to
> @@ -631,6 +637,7 @@ typedef struct srb {
> 	 */
> 	uint8_t cmd_type;
> 	uint8_t pad[3];
> +	struct iocb_resource iores;
> 	struct kref cmd_kref;	/* need to migrate ref_count over to =
this */
> 	void *priv;
> 	wait_queue_head_t nvme_ls_waitq;
> @@ -3577,6 +3584,15 @@ struct req_que {
> 	uint8_t req_pkt[REQUEST_ENTRY_SIZE];
> };
>=20
> +struct qla_fw_resources {
> +	u16 iocbs_total;
> +	u16 iocbs_limit;
> +	u16 iocbs_qp_limit;
> +	u16 iocbs_used;
> +};
> +
> +#define QLA_IOCB_PCT_LIMIT 95
> +
> /*Queue pair data structure */
> struct qla_qpair {
> 	spinlock_t qp_lock;
> @@ -3629,6 +3645,7 @@ struct qla_qpair {
> 	uint64_t retry_term_jiff;
> 	struct qla_tgt_counters tgt_counters;
> 	uint16_t cpuid;
> +	struct qla_fw_resources fwres ____cacheline_aligned;
> };
>=20
> /* Place holder for FW buffer parameters */
> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c =
b/drivers/scsi/qla2xxx/qla_dfs.c
> index 118f2b223531..6f5f18fc974a 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -261,6 +261,8 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, =
void *unused)
> 	struct scsi_qla_host *vha =3D s->private;
> 	uint16_t mb[MAX_IOCB_MB_REG];
> 	int rc;
> +	struct qla_hw_data *ha =3D vha->hw;
> +	u16 iocbs_used, i;
>=20
> 	rc =3D qla24xx_res_count_wait(vha, mb, SIZEOF_IOCB_MB_REG);
> 	if (rc !=3D QLA_SUCCESS) {
> @@ -285,6 +287,18 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, =
void *unused)
> 		    mb[23]);
> 	}
>=20
> +	if (ql2xenforce_iocb_limit) {
> +		/* lock is not require. It's an estimate. */
> +		iocbs_used =3D ha->base_qpair->fwres.iocbs_used;
> +		for (i =3D 0; i < ha->max_qpairs; i++) {
> +			if (ha->queue_pair_map[i])
> +				iocbs_used +=3D =
ha->queue_pair_map[i]->fwres.iocbs_used;
> +		}
> +
> +		seq_printf(s, "Driver: estimate iocb used [%d] high =
water limit [%d]\n",
> +			   iocbs_used, =
ha->base_qpair->fwres.iocbs_limit);
> +	}
> +
> 	return 0;
> }
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h =
b/drivers/scsi/qla2xxx/qla_gbl.h
> index 3360857c4405..9c4d077edf9e 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -129,6 +129,8 @@ int =
qla2x00_reserve_mgmt_server_loop_id(scsi_qla_host_t *);
> void qla_rscn_replay(fc_port_t *fcport);
> void qla24xx_free_purex_item(struct purex_item *item);
> extern bool qla24xx_risc_firmware_invalid(uint32_t *);
> +void qla_init_iocb_limit(scsi_qla_host_t *);
> +
>=20
> /*
>  * Global Data in qla_os.c source file.
> @@ -175,6 +177,7 @@ extern int qla2xuseresexchforels;
> extern int ql2xexlogins;
> extern int ql2xdifbundlinginternalbuffers;
> extern int ql2xfulldump_on_mpifail;
> +extern int ql2xenforce_iocb_limit;
>=20
> extern int qla2x00_loop_reset(scsi_qla_host_t *);
> extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
> diff --git a/drivers/scsi/qla2xxx/qla_init.c =
b/drivers/scsi/qla2xxx/qla_init.c
> index 99f322fb74ab..a1603bad3ee6 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -3622,6 +3622,31 @@ qla24xx_detect_sfp(scsi_qla_host_t *vha)
> 	return ha->flags.lr_detected;
> }
>=20
> +void qla_init_iocb_limit(scsi_qla_host_t *vha)
> +{
> +	u16 i, num_qps;
> +	u32 limit;
> +	struct qla_hw_data *ha =3D vha->hw;
> +
> +	num_qps =3D ha->num_qpairs + 1;
> +	limit =3D (ha->orig_fw_iocb_count * QLA_IOCB_PCT_LIMIT) / 100;
> +
> +	ha->base_qpair->fwres.iocbs_total =3D ha->orig_fw_iocb_count;
> +	ha->base_qpair->fwres.iocbs_limit =3D limit;
> +	ha->base_qpair->fwres.iocbs_qp_limit =3D limit / num_qps;
> +	ha->base_qpair->fwres.iocbs_used =3D 0;
> +	for (i =3D 0; i < ha->max_qpairs; i++) {
> +		if (ha->queue_pair_map[i])  {
> +			ha->queue_pair_map[i]->fwres.iocbs_total =3D
> +				ha->orig_fw_iocb_count;
> +			ha->queue_pair_map[i]->fwres.iocbs_limit =3D =
limit;
> +			ha->queue_pair_map[i]->fwres.iocbs_qp_limit =3D
> +				limit / num_qps;
> +			ha->queue_pair_map[i]->fwres.iocbs_used =3D 0;
> +		}
> +	}
> +}
> +
> /**
>  * qla2x00_setup_chip() - Load and start RISC firmware.
>  * @vha: HA context
> @@ -3722,6 +3747,7 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
> 						    MIN_MULTI_ID_FABRIC =
- 1;
> 				}
> 				qla2x00_get_resource_cnts(vha);
> +				qla_init_iocb_limit(vha);
>=20
> 				/*
> 				 * Allocate the array of outstanding =
commands
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h =
b/drivers/scsi/qla2xxx/qla_inline.h
> index 5501b4c581ec..9e9a5d3fb802 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -373,3 +373,58 @@ qla2xxx_get_fc4_priority(struct scsi_qla_host =
*vha)
>=20
> 	return (data >> 6) & BIT_0 ? FC4_PRIORITY_FCP : =
FC4_PRIORITY_NVME;
> }
> +
> +enum {
> +	RESOURCE_NONE,
> +	RESOURCE_INI,
> +};
> +
> +static inline int
> +qla_get_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
> +{
> +	u16 iocbs_used, i;
> +	struct qla_hw_data *ha =3D qp->vha->hw;
> +
> +	if (!ql2xenforce_iocb_limit) {
> +		iores->res_type =3D RESOURCE_NONE;
> +		return 0;
> +	}
> +
> +	if ((iores->iocb_cnt + qp->fwres.iocbs_used) < =
qp->fwres.iocbs_qp_limit) {
> +		qp->fwres.iocbs_used +=3D iores->iocb_cnt;
> +		return 0;
> +	} else {
> +		/* no need to acquire qpair lock. It's just rough =
calculation */
> +		iocbs_used =3D ha->base_qpair->fwres.iocbs_used;
> +		for (i =3D 0; i < ha->max_qpairs; i++) {
> +			if (ha->queue_pair_map[i])
> +				iocbs_used +=3D =
ha->queue_pair_map[i]->fwres.iocbs_used;
> +		}
> +
> +		if ((iores->iocb_cnt + iocbs_used) < =
qp->fwres.iocbs_limit) {
> +			qp->fwres.iocbs_used +=3D iores->iocb_cnt;
> +			return 0;
> +		} else {
> +			iores->res_type =3D RESOURCE_NONE;
> +			return -ENOSPC;
> +		}
> +	}
> +}
> +
> +static inline void
> +qla_put_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
> +{
> +	switch (iores->res_type) {
> +	case RESOURCE_NONE:
> +		break;
> +	default:
> +		if (qp->fwres.iocbs_used >=3D iores->iocb_cnt) {
> +			qp->fwres.iocbs_used -=3D iores->iocb_cnt;
> +		} else {
> +			// should not happen
> +			qp->fwres.iocbs_used =3D 0;
> +		}
> +		break;
> +	}
> +	iores->res_type =3D RESOURCE_NONE;
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c =
b/drivers/scsi/qla2xxx/qla_iocb.c
> index d69e16e844aa..b60a332e5846 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -1637,6 +1637,12 @@ qla24xx_start_scsi(srb_t *sp)
>=20
> 	tot_dsds =3D nseg;
> 	req_cnt =3D qla24xx_calc_iocbs(vha, tot_dsds);
> +
> +	sp->iores.res_type =3D RESOURCE_INI;
> +	sp->iores.iocb_cnt =3D req_cnt;
> +	if (qla_get_iocbs(sp->qpair, &sp->iores))
> +		goto queuing_error;
> +
> 	if (req->cnt < (req_cnt + 2)) {
> 		cnt =3D IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
> 		    rd_reg_dword_relaxed(req->req_q_out);
> @@ -1709,6 +1715,7 @@ qla24xx_start_scsi(srb_t *sp)
> 	if (tot_dsds)
> 		scsi_dma_unmap(cmd);
>=20
> +	qla_put_iocbs(sp->qpair, &sp->iores);
> 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>=20
> 	return QLA_FUNCTION_FAILED;
> @@ -1822,6 +1829,12 @@ qla24xx_dif_start_scsi(srb_t *sp)
> 	/* Total Data and protection sg segment(s) */
> 	tot_prot_dsds =3D nseg;
> 	tot_dsds +=3D nseg;
> +
> +	sp->iores.res_type =3D RESOURCE_INI;
> +	sp->iores.iocb_cnt =3D qla24xx_calc_iocbs(vha, tot_dsds);
> +	if (qla_get_iocbs(sp->qpair, &sp->iores))
> +		goto queuing_error;
> +
> 	if (req->cnt < (req_cnt + 2)) {
> 		cnt =3D IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
> 		    rd_reg_dword_relaxed(req->req_q_out);
> @@ -1896,6 +1909,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
> 	}
> 	/* Cleanup will be performed by the caller (queuecommand) */
>=20
> +	qla_put_iocbs(sp->qpair, &sp->iores);
> 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> 	return QLA_FUNCTION_FAILED;
> }
> @@ -1957,6 +1971,12 @@ qla2xxx_start_scsi_mq(srb_t *sp)
>=20
> 	tot_dsds =3D nseg;
> 	req_cnt =3D qla24xx_calc_iocbs(vha, tot_dsds);
> +
> +	sp->iores.res_type =3D RESOURCE_INI;
> +	sp->iores.iocb_cnt =3D req_cnt;
> +	if (qla_get_iocbs(sp->qpair, &sp->iores))
> +		goto queuing_error;
> +
> 	if (req->cnt < (req_cnt + 2)) {
> 		cnt =3D IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
> 		    rd_reg_dword_relaxed(req->req_q_out);
> @@ -2029,6 +2049,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
> 	if (tot_dsds)
> 		scsi_dma_unmap(cmd);
>=20
> +	qla_put_iocbs(sp->qpair, &sp->iores);
> 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
>=20
> 	return QLA_FUNCTION_FAILED;
> @@ -2157,6 +2178,12 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
> 	/* Total Data and protection sg segment(s) */
> 	tot_prot_dsds =3D nseg;
> 	tot_dsds +=3D nseg;
> +
> +	sp->iores.res_type =3D RESOURCE_INI;
> +	sp->iores.iocb_cnt =3D qla24xx_calc_iocbs(vha, tot_dsds);
> +	if (qla_get_iocbs(sp->qpair, &sp->iores))
> +		goto queuing_error;
> +
> 	if (req->cnt < (req_cnt + 2)) {
> 		cnt =3D IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
> 		    rd_reg_dword_relaxed(req->req_q_out);
> @@ -2234,6 +2261,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
> 	}
> 	/* Cleanup will be performed by the caller (queuecommand) */
>=20
> +	qla_put_iocbs(sp->qpair, &sp->iores);
> 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
> 	return QLA_FUNCTION_FAILED;
> }
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c =
b/drivers/scsi/qla2xxx/qla_isr.c
> index a63f2000fadf..bb3beaa77d39 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2901,6 +2901,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, =
struct rsp_que *rsp, void *pkt)
> 		}
> 		return;
> 	}
> +	qla_put_iocbs(sp->qpair, &sp->iores);
>=20
> 	if (sp->cmd_type !=3D TYPE_SRB) {
> 		req->outstanding_cmds[handle] =3D NULL;
> @@ -3313,6 +3314,7 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct =
rsp_que *rsp, sts_entry_t *pkt)
> 	default:
> 		sp =3D qla2x00_get_sp_from_handle(vha, func, req, pkt);
> 		if (sp) {
> +			qla_put_iocbs(sp->qpair, &sp->iores);
> 			sp->done(sp, res);
> 			return 0;
> 		}
> diff --git a/drivers/scsi/qla2xxx/qla_os.c =
b/drivers/scsi/qla2xxx/qla_os.c
> index c53cc31cd068..a4d737b92ec1 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -40,6 +40,11 @@ module_param(ql2xfulldump_on_mpifail, int, S_IRUGO =
| S_IWUSR);
> MODULE_PARM_DESC(ql2xfulldump_on_mpifail,
> 		 "Set this to take full dump on MPI hang.");
>=20
> +int ql2xenforce_iocb_limit =3D 1;
> +module_param(ql2xenforce_iocb_limit, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(ql2xenforce_iocb_limit,
> +		 "Enforce IOCB throttling, to avoid FW congestion. =
(default: 0)");
> +
> /*
>  * CT6 CTX allocation cache
>  */
> @@ -3316,6 +3321,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const =
struct pci_device_id *id)
> 		for (i =3D 0; i < ha->max_qpairs; i++)
> 			qla2xxx_create_qpair(base_vha, 5, 0, startit);
> 	}
> +	qla_init_iocb_limit(base_vha);
>=20
> 	if (ha->flags.running_gold_fw)
> 		goto skip_dpc;
> --=20
> 2.19.0.rc0
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

