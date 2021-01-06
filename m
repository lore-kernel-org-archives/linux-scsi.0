Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AF7C433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 15:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5D2A22BF3
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 15:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbhAFPJe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 10:09:34 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60536 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbhAFPJd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 10:09:33 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106F5RBH119108;
        Wed, 6 Jan 2021 15:08:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=RWi2S1x4Wp2BXOamwlqWOti+SQPB+kMVDmBTgG3r7bM=;
 b=fEl7nOpojxkLhq1O5oFi1qTLAL7xt0LrvQCe8qYb4zT2p1xhL/fxRfXFw000qNUPV8k4
 A/QyKKcCBDc8CeL1tFZs3OpRs9fjeWbJGW0gLwF2UksR3ApK6PrQdTtRFEVzdlqHUFQ4
 88Nc9NzHELP5o+x/ezJy+GIHos+FRjcHK5EAlIGDtD6zoCn7UyU8HLJ7xGVe3Eocyv5r
 jCX6q9zGk7anj6hqGRXUl26MgNYug9ZKAjAqOXfLqZVGTHYsLbryniNO9cBtbdhHU424
 2Eq4mINVCv0QyeV5b+e0Zn8AaOVrDtX/mKNIvkNBlYeuHSQTY/B+4AJQaX7S/zyFsvWP uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35wcuxrnpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 15:08:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106F4ppX168601;
        Wed, 6 Jan 2021 15:06:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35v1f9yxvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 15:06:47 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106F6lsa021595;
        Wed, 6 Jan 2021 15:06:47 GMT
Received: from [192.168.1.30] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 07:06:47 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v3 3/7] qla2xxx: Move some messages from debug to normal
 log level
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20210105103847.25041-4-njavali@marvell.com>
Date:   Wed, 6 Jan 2021 09:06:46 -0600
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DABC7D0B-6734-4229-9812-DB573235246F@oracle.com>
References: <20210105103847.25041-1-njavali@marvell.com>
 <20210105103847.25041-4-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060095
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Saurav,

> On Jan 5, 2021, at 4:38 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Saurav Kashyap <skashyap@marvell.com>
>=20
> This change will aid in debugging issues where debug level is not set.
>=20
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 10 +++----
> drivers/scsi/qla2xxx/qla_isr.c  | 52 ++++++++++++++++-----------------
> 2 files changed, 30 insertions(+), 32 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c =
b/drivers/scsi/qla2xxx/qla_init.c
> index 410ff5534a59..221369cdf71f 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -347,11 +347,11 @@ qla2x00_async_login(struct scsi_qla_host *vha, =
fc_port_t *fcport,
> 	if (NVME_TARGET(vha->hw, fcport))
> 		lio->u.logio.flags |=3D SRB_LOGIN_SKIP_PRLI;
>=20
> -	ql_dbg(ql_dbg_disc, vha, 0x2072,
> -	    "Async-login - %8phC hdl=3D%x, loopid=3D%x =
portid=3D%02x%02x%02x "
> -		"retries=3D%d.\n", fcport->port_name, sp->handle, =
fcport->loop_id,
> -	    fcport->d_id.b.domain, fcport->d_id.b.area, =
fcport->d_id.b.al_pa,
> -	    fcport->login_retry);
> +	ql_log(ql_log_warn, vha, 0x2072,
> +	       "Async-login - %8phC hdl=3D%x, loopid=3D%x =
portid=3D%02x%02x%02x retries=3D%d.\n",
> +	       fcport->port_name, sp->handle, fcport->loop_id,
> +	       fcport->d_id.b.domain, fcport->d_id.b.area, =
fcport->d_id.b.al_pa,
> +	       fcport->login_retry);
>=20
> 	rval =3D qla2x00_start_sp(sp);
> 	if (rval !=3D QLA_SUCCESS) {
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c =
b/drivers/scsi/qla2xxx/qla_isr.c
> index 9cf8326ab9fc..bfc8bbaeea46 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1455,9 +1455,9 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct =
rsp_que *rsp, uint16_t *mb)
> 		if (ha->flags.npiv_supported && vha->vp_idx !=3D (mb[3] =
& 0xff))
> 			break;
>=20
> -		ql_dbg(ql_dbg_async, vha, 0x5013,
> -		    "RSCN database changed -- %04x %04x %04x.\n",
> -		    mb[1], mb[2], mb[3]);
> +		ql_log(ql_log_warn, vha, 0x5013,
> +		       "RSCN database changed -- %04x %04x %04x.\n",
> +		       mb[1], mb[2], mb[3]);
>=20
> 		rscn_entry =3D ((mb[1] & 0xff) << 16) | mb[2];
> 		host_pid =3D (vha->d_id.b.domain << 16) | =
(vha->d_id.b.area << 8)
> @@ -2221,12 +2221,12 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, =
struct req_que *req,
> 		break;
> 	}
>=20
> -	ql_dbg(ql_dbg_async, sp->vha, 0x5037,
> -	    "Async-%s failed: handle=3D%x pid=3D%06x wwpn=3D%8phC =
comp_status=3D%x iop0=3D%x iop1=3D%x\n",
> -	    type, sp->handle, fcport->d_id.b24, fcport->port_name,
> -	    le16_to_cpu(logio->comp_status),
> -	    le32_to_cpu(logio->io_parameter[0]),
> -	    le32_to_cpu(logio->io_parameter[1]));
> +	ql_log(ql_log_warn, sp->vha, 0x5037,
> +	       "Async-%s failed: handle=3D%x pid=3D%06x wwpn=3D%8phC =
comp_status=3D%x iop0=3D%x iop1=3D%x\n",
> +	       type, sp->handle, fcport->d_id.b24, fcport->port_name,
> +	       le16_to_cpu(logio->comp_status),
> +	       le32_to_cpu(logio->io_parameter[0]),
> +	       le32_to_cpu(logio->io_parameter[1]));
>=20
> logio_done:
> 	sp->done(sp, 0);
> @@ -2389,9 +2389,9 @@ static void =
qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
>=20
> 		tgt_xfer_len =3D be32_to_cpu(rsp_iu->xfrd_len);
> 		if (fd->transferred_length !=3D tgt_xfer_len) {
> -			ql_dbg(ql_dbg_io, fcport->vha, 0x3079,
> -				"Dropped frame(s) detected =
(sent/rcvd=3D%u/%u).\n",
> -				tgt_xfer_len, fd->transferred_length);
> +			ql_log(ql_log_warn, fcport->vha, 0x3079,
> +			       "Dropped frame(s) detected =
(sent/rcvd=3D%u/%u).\n",
> +			       tgt_xfer_len, fd->transferred_length);
> 			logit =3D 1;
> 		} else if (le16_to_cpu(comp_status) =3D=3D =
CS_DATA_UNDERRUN) {
> 			/*
> @@ -3112,9 +3112,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, =
struct rsp_que *rsp, void *pkt)
> 		scsi_set_resid(cp, resid);
> 		if (scsi_status & SS_RESIDUAL_UNDER) {
> 			if (IS_FWI2_CAPABLE(ha) && fw_resid_len !=3D =
resid_len) {
> -				ql_dbg(ql_dbg_io, fcport->vha, 0x301d,
> -				    "Dropped frame(s) detected (0x%x of =
0x%x bytes).\n",
> -				    resid, scsi_bufflen(cp));
> +				ql_log(ql_log_warn, fcport->vha, 0x301d,
> +				       "Dropped frame(s) detected (0x%x =
of 0x%x bytes).\n",
> +				       resid, scsi_bufflen(cp));
>=20
> 				vha->interface_err_cnt++;
>=20
> @@ -3139,9 +3139,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, =
struct rsp_que *rsp, void *pkt)
> 			 * task not completed.
> 			 */
>=20
> -			ql_dbg(ql_dbg_io, fcport->vha, 0x301f,
> -			    "Dropped frame(s) detected (0x%x of 0x%x =
bytes).\n",
> -			    resid, scsi_bufflen(cp));
> +			ql_log(ql_log_warn, fcport->vha, 0x301f,
> +			       "Dropped frame(s) detected (0x%x of 0x%x =
bytes).\n",
> +			       resid, scsi_bufflen(cp));
>=20
> 			vha->interface_err_cnt++;
>=20
> @@ -3257,15 +3257,13 @@ qla2x00_status_entry(scsi_qla_host_t *vha, =
struct rsp_que *rsp, void *pkt)
>=20
> out:
> 	if (logit)
> -		ql_dbg(ql_dbg_io, fcport->vha, 0x3022,
> -		    "FCP command status: 0x%x-0x%x (0x%x) =
nexus=3D%ld:%d:%llu "
> -		    "portid=3D%02x%02x%02x oxid=3D0x%x cdb=3D%10phN =
len=3D0x%x "
> -		    "rsp_info=3D0x%x resid=3D0x%x fw_resid=3D0x%x sp=3D%p =
cp=3D%p.\n",
> -		    comp_status, scsi_status, res, vha->host_no,
> -		    cp->device->id, cp->device->lun, =
fcport->d_id.b.domain,
> -		    fcport->d_id.b.area, fcport->d_id.b.al_pa, ox_id,
> -		    cp->cmnd, scsi_bufflen(cp), rsp_info_len,
> -		    resid_len, fw_resid_len, sp, cp);
> +		ql_log(ql_log_warn, fcport->vha, 0x3022,
> +		       "FCP command status: 0x%x-0x%x (0x%x) =
nexus=3D%ld:%d:%llu portid=3D%02x%02x%02x oxid=3D0x%x cdb=3D%10phN =
len=3D0x%x rsp_info=3D0x%x resid=3D0x%x fw_resid=3D0x%x sp=3D%p =
cp=3D%p.\n",
> +		       comp_status, scsi_status, res, vha->host_no,
> +		       cp->device->id, cp->device->lun, =
fcport->d_id.b.domain,
> +		       fcport->d_id.b.area, fcport->d_id.b.al_pa, ox_id,
> +		       cp->cmnd, scsi_bufflen(cp), rsp_info_len,
> +		       resid_len, fw_resid_len, sp, cp);
>=20
> 	if (rsp->status_srb =3D=3D NULL)
> 		sp->done(sp, res);
> --=20
> 2.19.0.rc0
>=20

I like the direction of this patch.=20

Can you consider removing "logit" variable. Since logit was designed to =
print messages only when a specific debug (IO bits in this case) was =
set.

--
Himanshu Madhani	 Oracle Linux Engineering

