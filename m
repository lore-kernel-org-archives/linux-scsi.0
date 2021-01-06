Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4723EC433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 15:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BE3523120
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 15:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbhAFPj6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 10:39:58 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:35580 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbhAFPj5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 10:39:57 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106Fd5RP189983;
        Wed, 6 Jan 2021 15:39:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=9mfIIWL4WmvGbsyRexg7UzYPbG3YBQOYpSHlLJztGqA=;
 b=oDWAYsc1+XjMGBucRpVqR3F0mL3Vf2ICjonhwcVNwlOe/XOXFYosVWuP1muFt22Gim5c
 6kVJ1dvIq2r6ThdTdu6E3FAdM5mK6SdkIiNfHwV6YCA2TmGk/Mbwy4HIjhoQfzN7EhNB
 ZC7WEEbysjXPaQXs9ah8LgxGtTTY+Pv34R5JWDK7c84PIrafDSgbpUb5gCpFVgPJQzty
 r0UdWIAUUQNW8zR1zJISZBGtHxxT3x+8XLnHNphW0YRpjkt5SgihILaLSmNxh3M5ou3N
 4ZWQNG68qvFDSJwcgaRX0Qy8vT6Ex9o3Qg6VuEfRd/CgCjThzp3iJLL2SOcItmZhAriw /A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35wcuxrukj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 15:39:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106FUScM162626;
        Wed, 6 Jan 2021 15:36:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35w3qs6abe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 15:36:05 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106Fa3gk011509;
        Wed, 6 Jan 2021 15:36:04 GMT
Received: from [192.168.1.30] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 15:36:02 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v3 4/7] qla2xxx: Wait for ABTS response on I/O timeouts
 for NVMe
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20210105103847.25041-5-njavali@marvell.com>
Date:   Wed, 6 Jan 2021 09:36:02 -0600
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <832E5516-4AB8-4853-9B66-1592EE5BD0CE@oracle.com>
References: <20210105103847.25041-1-njavali@marvell.com>
 <20210105103847.25041-5-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060097
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jan 5, 2021, at 4:38 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Bikash Hazarika <bhazarika@marvell.com>
>=20
> FW needs to wait for an ABTS response before completing the I/O
>=20
> Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h  | 12 +++++
> drivers/scsi/qla2xxx/qla_fw.h   | 27 ++++++++--
> drivers/scsi/qla2xxx/qla_gbl.h  |  6 +++
> drivers/scsi/qla2xxx/qla_init.c |  4 ++
> drivers/scsi/qla2xxx/qla_iocb.c |  6 +++
> drivers/scsi/qla2xxx/qla_isr.c  |  8 +++
> drivers/scsi/qla2xxx/qla_mbx.c  |  6 +++
> drivers/scsi/qla2xxx/qla_nvme.c | 90 ++++++++++++++++++++++++++++++++-
> drivers/scsi/qla2xxx/qla_os.c   |  5 ++
> 9 files changed, 159 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h =
b/drivers/scsi/qla2xxx/qla_def.h
> index f2f1b0231033..17da6b436e74 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2101,6 +2101,7 @@ typedef struct {
> #define CS_COMPLETE_CHKCOND	0x30	/* Error? */
> #define CS_IOCB_ERROR		0x31	/* Generic error for IOCB =
request
> 					   failure */
> +#define CS_REJECT_RECEIVED	0x4E	/* Reject received */
> #define CS_BAD_PAYLOAD		0x80	/* Driver defined */
> #define CS_UNKNOWN		0x81	/* Driver defined */
> #define CS_RETRY		0x82	/* Driver defined */
> @@ -4150,6 +4151,17 @@ struct qla_hw_data {
> /* Bit 21 of fw_attributes decides the MCTP capabilities */
> #define IS_MCTP_CAPABLE(ha)	(IS_QLA2031(ha) && \
> 				((ha)->fw_attributes_ext[0] & BIT_0))
> +#define QLA_ABTS_FW_ENABLED(_ha)       ((_ha)->fw_attributes_ext[0] & =
BIT_14)
> +#define QLA_SRB_NVME_LS(_sp) ((_sp)->type =3D=3D SRB_NVME_LS)
> +#define QLA_SRB_NVME_CMD(_sp) ((_sp)->type =3D=3D SRB_NVME_CMD)
> +#define QLA_NVME_IOS(_sp) (QLA_SRB_NVME_CMD(_sp) || =
QLA_SRB_NVME_LS(_sp))
> +#define QLA_LS_ABTS_WAIT_ENABLED(_sp) \
> +	(QLA_SRB_NVME_LS(_sp) && =
QLA_ABTS_FW_ENABLED(_sp->fcport->vha->hw))
> +#define QLA_CMD_ABTS_WAIT_ENABLED(_sp) \
> +	(QLA_SRB_NVME_CMD(_sp) && =
QLA_ABTS_FW_ENABLED(_sp->fcport->vha->hw))
> +#define QLA_ABTS_WAIT_ENABLED(_sp) \
> +	(QLA_NVME_IOS(_sp) && QLA_ABTS_FW_ENABLED(_sp->fcport->vha->hw))
> +
> #define IS_PI_UNINIT_CAPABLE(ha)	(IS_QLA83XX(ha) || =
IS_QLA27XX(ha))
> #define IS_PI_IPGUARD_CAPABLE(ha)	(IS_QLA83XX(ha) || =
IS_QLA27XX(ha))
> #define IS_PI_DIFB_DIX0_CAPABLE(ha)	(0)
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h =
b/drivers/scsi/qla2xxx/qla_fw.h
> index 12b689e32883..49df418030e4 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -982,11 +982,18 @@ struct abort_entry_24xx {
>=20
> 	uint32_t handle;		/* System handle. */
>=20
> -	__le16	nport_handle;		/* N_PORT handle. */
> -					/* or Completion status. */
> +	union {
> +		__le16 nport_handle;            /* N_PORT handle. */
> +		__le16 comp_status;             /* Completion status. */
> +	};
>=20
> 	__le16	options;		/* Options. */
> #define AOF_NO_ABTS		BIT_0	/* Do not send any ABTS. */
> +#define AOF_NO_RRQ		BIT_1   /* Do not send RRQ. */
> +#define AOF_ABTS_TIMEOUT	BIT_2   /* Disable logout on ABTS =
timeout. */
> +#define AOF_ABTS_RTY_CNT	BIT_3   /* Use driver specified retry =
count. */
> +#define AOF_RSP_TIMEOUT		BIT_4   /* Use specified =
response timeout. */
> +
>=20
> 	uint32_t handle_to_abort;	/* System handle to abort. */
>=20
> @@ -995,8 +1002,20 @@ struct abort_entry_24xx {
>=20
> 	uint8_t port_id[3];		/* PortID of destination port. =
*/
> 	uint8_t vp_index;
> -
> -	uint8_t reserved_2[12];
> +	u8	reserved_2[4];
> +	union {
> +		struct {
> +			__le16 abts_rty_cnt;
> +			__le16 rsp_timeout;
> +		} drv;
> +		struct {
> +			u8	ba_rjt_vendorUnique;
> +			u8	ba_rjt_reasonCodeExpl;
> +			u8	ba_rjt_reasonCode;
> +			u8	reserved_3;
> +		} fw;
> +	};
> +	u8	reserved_4[4];
> };
>=20
> #define ABTS_RCV_TYPE		0x54
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h =
b/drivers/scsi/qla2xxx/qla_gbl.h
> index 708f82311b83..6486f97d649e 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -177,6 +177,7 @@ extern int ql2xexlogins;
> extern int ql2xdifbundlinginternalbuffers;
> extern int ql2xfulldump_on_mpifail;
> extern int ql2xenforce_iocb_limit;
> +extern int ql2xabts_wait_nvme;
>=20
> extern int qla2x00_loop_reset(scsi_qla_host_t *);
> extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
> @@ -941,6 +942,11 @@ int qla2x00_set_data_rate(scsi_qla_host_t *vha, =
uint16_t mode);
> extern void qla24xx_process_purex_list(struct purex_list *);
> extern void qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct =
fc_port *fp);
> extern void qla2x00_dfs_remove_rport(scsi_qla_host_t *vha, struct =
fc_port *fp);
> +extern void qla_wait_nvme_release_cmd_kref(srb_t *sp);
> +extern void qla_nvme_abort_set_option
> +		(struct abort_entry_24xx *abt, srb_t *sp);
> +extern void qla_nvme_abort_process_comp_status
> +		(struct abort_entry_24xx *abt, srb_t *sp);
>=20
> /* nvme.c */
> void qla_nvme_unregister_remote_port(struct fc_port *fcport);
> diff --git a/drivers/scsi/qla2xxx/qla_init.c =
b/drivers/scsi/qla2xxx/qla_init.c
> index 221369cdf71f..a6ab2629b7cf 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -136,6 +136,10 @@ static void qla24xx_abort_iocb_timeout(void =
*data)
> static void qla24xx_abort_sp_done(srb_t *sp, int res)
> {
> 	struct srb_iocb *abt =3D &sp->u.iocb_cmd;
> +	srb_t *orig_sp =3D sp->cmd_sp;
> +
> +	if (orig_sp)
> +		qla_wait_nvme_release_cmd_kref(orig_sp);
>=20
> 	del_timer(&sp->u.iocb_cmd.timer);
> 	if (sp->flags & SRB_WAKEUP_ON_COMP)
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c =
b/drivers/scsi/qla2xxx/qla_iocb.c
> index c532c74ca1ab..e27359b294d3 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -3571,6 +3571,7 @@ qla24xx_abort_iocb(srb_t *sp, struct =
abort_entry_24xx *abt_iocb)
> 	struct srb_iocb *aio =3D &sp->u.iocb_cmd;
> 	scsi_qla_host_t *vha =3D sp->vha;
> 	struct req_que *req =3D sp->qpair->req;
> +	srb_t *orig_sp =3D sp->cmd_sp;
>=20
> 	memset(abt_iocb, 0, sizeof(struct abort_entry_24xx));
> 	abt_iocb->entry_type =3D ABORT_IOCB_TYPE;
> @@ -3587,6 +3588,11 @@ qla24xx_abort_iocb(srb_t *sp, struct =
abort_entry_24xx *abt_iocb)
> 			    aio->u.abt.cmd_hndl);
> 	abt_iocb->vp_index =3D vha->vp_idx;
> 	abt_iocb->req_que_no =3D aio->u.abt.req_que_no;
> +
> +	/* need to pass original sp */
> +	if (orig_sp)
> +		qla_nvme_abort_set_option(abt_iocb, orig_sp);
> +
> 	/* Send the command to the firmware */
> 	wmb();
> }
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c =
b/drivers/scsi/qla2xxx/qla_isr.c
> index bfc8bbaeea46..a4a52a2d724e 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -5,6 +5,7 @@
>  */
> #include "qla_def.h"
> #include "qla_target.h"
> +#include "qla_gbl.h"
>=20
> #include <linux/delay.h>
> #include <linux/slab.h>
> @@ -3431,6 +3432,7 @@ qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, =
struct req_que *req,
> {
> 	const char func[] =3D "ABT_IOCB";
> 	srb_t *sp;
> +	srb_t *orig_sp =3D NULL;
> 	struct srb_iocb *abt;
>=20
> 	sp =3D qla2x00_get_sp_from_handle(vha, func, req, pkt);
> @@ -3439,6 +3441,12 @@ qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, =
struct req_que *req,
>=20
> 	abt =3D &sp->u.iocb_cmd;
> 	abt->u.abt.comp_status =3D pkt->nport_handle;
> +	abt->u.abt.comp_status =3D le16_to_cpu(pkt->comp_status);

Is this intentional?

abt->u.abt.comp_status has value assigned twice, once for nport_handle =
and then again with comp_status?=20

> +	orig_sp =3D sp->cmd_sp;
> +	/* Need to pass original sp */
> +	if (orig_sp)
> +		qla_nvme_abort_process_comp_status(pkt, orig_sp);
> +
> 	sp->done(sp, 0);
> }
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c =
b/drivers/scsi/qla2xxx/qla_mbx.c
> index f438cdedca23..629af6fe8c55 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -3243,6 +3243,8 @@ qla24xx_abort_command(srb_t *sp)
> 	abt->vp_index =3D fcport->vha->vp_idx;
>=20
> 	abt->req_que_no =3D cpu_to_le16(req->id);
> +	/* Need to pass original sp */
> +	qla_nvme_abort_set_option(abt, sp);
>=20
> 	rval =3D qla2x00_issue_iocb(vha, abt, abt_dma, 0);
> 	if (rval !=3D QLA_SUCCESS) {
> @@ -3265,6 +3267,10 @@ qla24xx_abort_command(srb_t *sp)
> 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1091,
> 		    "Done %s.\n", __func__);
> 	}
> +	if (rval =3D=3D QLA_SUCCESS)
> +		qla_nvme_abort_process_comp_status(abt, sp);
> +
> +	qla_wait_nvme_release_cmd_kref(sp);
>=20
> 	dma_pool_free(ha->s_dma_pool, abt, abt_dma);
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c =
b/drivers/scsi/qla2xxx/qla_nvme.c
> index eab559b3b257..1cdb7352d6db 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -245,6 +245,12 @@ static void qla_nvme_abort_work(struct =
work_struct *work)
> 	    __func__, (rval !=3D QLA_SUCCESS) ? "Failed to abort" : =
"Aborted",
> 	    sp, sp->handle, fcport, rval);
>=20
> +	/* Returned before decreasing kref so that I/O requests
> +	 * are waited until ABTS complete. This kref is decreased
> +	 * at qla24xx_abort_sp_done function.
> +	 */

Small nit: Can you please use separate line for comment start=20

> +	if (ql2xabts_wait_nvme && QLA_ABTS_WAIT_ENABLED(sp))
> +		return;
> out:
> 	/* kref_get was done before work was schedule. */
> 	kref_put(&sp->cmd_kref, sp->put_fn);
> @@ -284,7 +290,6 @@ static int qla_nvme_ls_req(struct =
nvme_fc_local_port *lport,
> 	struct qla_hw_data *ha;
> 	srb_t           *sp;
>=20
> -
> 	if (!fcport || (fcport && fcport->deleted))
> 		return rval;
>=20
> @@ -591,6 +596,7 @@ static int qla_nvme_post_cmd(struct =
nvme_fc_local_port *lport,
> 	sp->put_fn =3D qla_nvme_release_fcp_cmd_kref;
> 	sp->qpair =3D qpair;
> 	sp->vha =3D vha;
> +	sp->cmd_sp =3D sp;
> 	nvme =3D &sp->u.iocb_cmd;
> 	nvme->u.nvme.desc =3D fd;
>=20
> @@ -744,3 +750,85 @@ int qla_nvme_register_hba(struct scsi_qla_host =
*vha)
>=20
> 	return ret;
> }
> +
> +void qla_nvme_abort_set_option(struct abort_entry_24xx *abt, srb_t =
*orig_sp)
> +{
> +	struct qla_hw_data *ha;
> +
> +	if (!(ql2xabts_wait_nvme && QLA_ABTS_WAIT_ENABLED(orig_sp)))
> +		return;
> +
> +	ha =3D orig_sp->fcport->vha->hw;
> +
> +	WARN_ON_ONCE(abt->options & cpu_to_le16(BIT_0));
> +	/* Use Driver Specified Retry Count */
> +	abt->options |=3D cpu_to_le16(AOF_ABTS_RTY_CNT);
> +	abt->drv.abts_rty_cnt =3D cpu_to_le16(2);
> +	/* Use specified response timeout */
> +	abt->options |=3D cpu_to_le16(AOF_RSP_TIMEOUT);
> +	/* set it to 2 * r_a_tov in secs */
> +	abt->drv.rsp_timeout =3D cpu_to_le16(2 * (ha->r_a_tov / 10));
> +}
> +
> +void qla_nvme_abort_process_comp_status(struct abort_entry_24xx *abt, =
srb_t *orig_sp)
> +{
> +	u16	comp_status;
> +	struct scsi_qla_host *vha;
> +
> +	if (!(ql2xabts_wait_nvme && QLA_ABTS_WAIT_ENABLED(orig_sp)))
> +		return;
> +
> +	vha =3D orig_sp->fcport->vha;
> +
> +	comp_status =3D le16_to_cpu(abt->comp_status);
> +	switch (comp_status) {
> +	case CS_RESET:		/* reset event aborted */
> +	case CS_ABORTED:	/* IOCB was cleaned */
> +	/* N_Port handle is not currently logged in */
> +	case CS_TIMEOUT:
> +	/* N_Port handle was logged out while waiting for ABTS to =
complete */
> +	case CS_PORT_UNAVAILABLE:
> +	/* Firmware found that the port name changed */
> +	case CS_PORT_LOGGED_OUT:
> +	/* BA_RJT was received for the ABTS */
> +	case CS_PORT_CONFIG_CHG:
> +		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf09d,
> +		       "Abort I/O IOCB completed with error, =
comp_status=3D%x\n",
> +		comp_status);
> +		break;
> +
> +	/* BA_RJT was received for the ABTS */
> +	case CS_REJECT_RECEIVED:
> +		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf09e,
> +		       "BA_RJT was received for the ABTS =
rjt_vendorUnique =3D %u",
> +			abt->fw.ba_rjt_vendorUnique);
> +		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf09e,
> +		       "ba_rjt_reasonCodeExpl =3D %u, ba_rjt_reasonCode =
=3D %u\n",
> +		       abt->fw.ba_rjt_reasonCodeExpl, =
abt->fw.ba_rjt_reasonCode);
> +		break;
> +
> +	case CS_COMPLETE:
> +		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf09f,
> +		       "IOCB request is completed successfully =
comp_status=3D%x\n",
> +		comp_status);
> +		break;
> +
> +	case CS_IOCB_ERROR:
> +		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf0a0,
> +		       "IOCB request is failed, comp_status=3D%x\n", =
comp_status);
> +		break;
> +
> +	default:
> +		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf0a1,
> +		       "Invalid Abort IO IOCB Completion Status %x\n",
> +		comp_status);
> +		break;
> +	}
> +}
> +
> +inline void qla_wait_nvme_release_cmd_kref(srb_t *orig_sp)
> +{
> +	if (!(ql2xabts_wait_nvme && QLA_ABTS_WAIT_ENABLED(orig_sp)))
> +		return;
> +	kref_put(&orig_sp->cmd_kref, orig_sp->put_fn);
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_os.c =
b/drivers/scsi/qla2xxx/qla_os.c
> index a760cb38e487..3cfd83fce9c5 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -327,6 +327,11 @@ MODULE_PARM_DESC(ql2xrdpenable,
> 		"Enables RDP responses. "
> 		"0 - no RDP responses (default). "
> 		"1 - provide RDP responses.");
> +int ql2xabts_wait_nvme =3D 1;
> +module_param(ql2xabts_wait_nvme, int, 0444);
> +MODULE_PARM_DESC(ql2xabts_wait_nvme,
> +		 "To wait for ABTS response on I/O timeouts for NVMe. =
(default: 1)");
> +
>=20
> static void qla2x00_clear_drv_active(struct qla_hw_data *);
> static void qla2x00_free_device(scsi_qla_host_t *);
> --=20
> 2.19.0.rc0
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

