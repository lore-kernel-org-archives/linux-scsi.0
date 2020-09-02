Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AABA9C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 17:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 666CC20758
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 17:57:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZiTPoC1Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgIBR5g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 13:57:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34394 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIBR5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 13:57:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082Hdlnt042608;
        Wed, 2 Sep 2020 17:57:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=PnG3BIJRj2GBLfmLQTDiV/2UztwUzLwuCFNFlKzMJh0=;
 b=ZiTPoC1ZJjqjljA2wWey+PFWMkCcw/jEBtCslyPH2axJJEpqdZvX5RCiMncBc/RLbaIB
 AgTxwH7BYCP9biqyWQDWUBfCEZpcwI9xBfggqwY8ci3GOIpVVa8gKUi5seT2BlXizkfL
 0yNzIVo+9CAvS4/g9yTSfr/0FDaCNR/rwo+PulNpVvJ8pyCHwT/JaVdLuJ5bNX4wALzT
 WLI8ng+2TZkZNpZ2e1+yqMu5boBnvHHlfzyRsWXD50jQuSlkvNCZ3IWIde4Xvro8bnSv
 acBL/3ht/CvBP6cgUTbN+lDmIYSdA73Lt2DojcD+nQKPmUP/pYYrB1Hx2U43FiQqx8dJ nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 339dmn2q5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 17:57:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082HtEjN083751;
        Wed, 2 Sep 2020 17:57:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3380kqde3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 17:57:30 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 082HvS5L015950;
        Wed, 2 Sep 2020 17:57:29 GMT
Received: from dhcp-10-154-155-248.vpn.oracle.com (/10.154.155.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 10:57:28 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 12/13] qla2xxx: Add SLER and PI control support
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200902072548.11491-13-njavali@marvell.com>
Date:   Wed, 2 Sep 2020 12:57:27 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <43B255BF-4623-4221-B435-5032073E2876@oracle.com>
References: <20200902072548.11491-1-njavali@marvell.com>
 <20200902072548.11491-13-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=3 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=3
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020168
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 2, 2020, at 2:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Saurav Kashyap <skashyap@marvell.com>
>=20
> - BIT_13 of extended FW attribute informs about NVMe-2 support.
> - Set BIT_15 of specical feature control block for enabling SLER in =
FW.
> - Set bit 8 (SLER supported) to 1 for the service parameter =
information
>  when sending NVMe PRLI request.
> - Set BIT_14 of special feature control block for enabling
>  PI Control in FW.
> - Driver should set bit 9 (PI Control supported) to 1 for the service
>  parameter information when sending NVMe PRLI request.
> - Set BIT_13 for NVMe Async events.
>=20

Please correct the =E2=80=9C-=E2=80=9C from the commit message

> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_dbg.c  |  2 +-
> drivers/scsi/qla2xxx/qla_def.h  |  4 ++++
> drivers/scsi/qla2xxx/qla_iocb.c |  8 ++++++++
> drivers/scsi/qla2xxx/qla_mbx.c  | 21 +++++++++++++++++++--
> drivers/scsi/qla2xxx/qla_nvme.c | 16 ++++++++++++++--
> drivers/scsi/qla2xxx/qla_nvme.h |  1 +
> drivers/scsi/qla2xxx/qla_os.c   |  1 +
> 7 files changed, 48 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c =
b/drivers/scsi/qla2xxx/qla_dbg.c
> index 1be811a5d69d..369040250ab9 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -16,7 +16,7 @@
>  * | Device Discovery             |       0x2134       | 0x210e-0x2116 =
 |
>  * |				  | 		       | 0x211a         =
|
>  * |                              |                    | 0x211c-0x2128 =
 |
> - * |                              |                    | =
0x212a-0x2134  |
> + * |                              |                    | =
0x212c-0x2134  |
>  * | Queue Command and IO tracing |       0x3074       | 0x300b        =
 |
>  * |                              |                    | 0x3027-0x3028 =
 |
>  * |                              |                    | 0x303d-0x3041 =
 |
> diff --git a/drivers/scsi/qla2xxx/qla_def.h =
b/drivers/scsi/qla2xxx/qla_def.h
> index 863b9c7766e1..19b5c0e3dc99 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2476,6 +2476,8 @@ typedef struct fc_port {
>=20
> 	struct completion nvme_del_done;
> 	uint32_t nvme_prli_service_param;
> +#define NVME_PRLI_SP_PI_CTRL	BIT_9
> +#define NVME_PRLI_SP_SLER	BIT_8
> #define NVME_PRLI_SP_CONF       BIT_7
> #define NVME_PRLI_SP_INITIATOR  BIT_5
> #define NVME_PRLI_SP_TARGET     BIT_4
> @@ -4308,6 +4310,7 @@ struct qla_hw_data {
> #define FW_ATTR_EXT0_SCM_BROCADE	0x00001000
> 	/* Cisco fabric attached */
> #define FW_ATTR_EXT0_SCM_CISCO		0x00002000
> +#define FW_ATTR_EXT0_NVME2	BIT_13
> 	uint16_t	fw_attributes_ext[2];
> 	uint32_t	fw_memory_size;
> 	uint32_t	fw_transfer_size;
> @@ -4657,6 +4660,7 @@ typedef struct scsi_qla_host {
> 		uint32_t	qpairs_rsp_created:1;
> 		uint32_t	nvme_enabled:1;
> 		uint32_t        nvme_first_burst:1;
> +		uint32_t        nvme2_enabled:1;
> 	} flags;
>=20
> 	atomic_t	loop_state;
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c =
b/drivers/scsi/qla2xxx/qla_iocb.c
> index b60a332e5846..a46f01a25582 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2378,6 +2378,14 @@ qla24xx_prli_iocb(srb_t *sp, struct =
logio_entry_24xx *logio)
> 		if (sp->vha->flags.nvme_first_burst)
> 			logio->io_parameter[0] =3D
> 				cpu_to_le32(NVME_PRLI_SP_FIRST_BURST);
> +		if (sp->vha->flags.nvme2_enabled) {
> +		/* Set service parameter BIT_8 for SLER support */
> +			logio->io_parameter[0] |=3D
> +				cpu_to_le32(NVME_PRLI_SP_SLER);
> +		/* Set service parameter BIT_9 for PI control support */
> +			logio->io_parameter[0] |=3D
> +				cpu_to_le32(NVME_PRLI_SP_PI_CTRL);
> +		}
> 	}
>=20

Comment should be at the same indentation as src to make it readable. =
Please fix it

> 	logio->nport_handle =3D cpu_to_le16(sp->fcport->loop_id);
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c =
b/drivers/scsi/qla2xxx/qla_mbx.c
> index ab7dbbc99c22..e5a47d5147fc 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -1093,6 +1093,17 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
> 			    "%s: FC-NVMe is Enabled (0x%x)\n",
> 			     __func__, ha->fw_attributes_h);
> 		}
> +
> +		/* BIT_13 of Extended FW Attributes informs about NVMe2 =
support */
> +		if (ha->fw_attributes_ext[0] & FW_ATTR_EXT0_NVME2) {
> +			ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1191,
> +			       "%s: Firmware supports NVMe2 0x%x\n",
> +			      __func__, ha->fw_attributes_ext[0]);

Why not just drop this message to reduce noise when MBX+Verbose bits are =
on, because the log message on the following line is going to be logged =
every time.

> +			ql_log(ql_log_info, vha, 0xd302,
> +			       "Firmware supports NVMe2 0x%x\n=E2=80=9D,
> +			       ha->fw_attributes_ext[0]);
> +			vha->flags.nvme2_enabled =3D 1;
> +		}
> 	}
>=20
> 	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> @@ -1122,12 +1133,18 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
> 		if (ha->flags.scm_supported_a &&
> 		    (ha->fw_attributes_ext[0] & =
FW_ATTR_EXT0_SCM_SUPPORTED)) {
> 			ha->flags.scm_supported_f =3D 1;
> -			memset(ha->sf_init_cb, 0, sizeof(struct =
init_sf_cb));
> 			ha->sf_init_cb->flags |=3D BIT_13;
> 		}
> 		ql_log(ql_log_info, vha, 0x11a3, "SCM in FW: %s\n",
> 		       (ha->flags.scm_supported_f) ? "Supported" :
> 		       "Not Supported");
> +
> +		if (vha->flags.nvme2_enabled) {
> +		/* set BIT_15 of special feature control block for SLER =
*/
> +			ha->sf_init_cb->flags |=3D BIT_15;
> +		/* set BIT_14 of special feature control block for PI =
CTRL*/
> +			ha->sf_init_cb->flags |=3D BIT_14;
> +		}
> 	}
>=20

This looks like copy paste from earlier.. Please fix it

> failed:
> @@ -1823,7 +1840,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, =
uint16_t size)
> 		mcp->out_mb |=3D MBX_14|MBX_13|MBX_12|MBX_11|MBX_10;
> 	}
>=20
> -	if (ha->flags.scm_supported_f) {
> +	if (ha->flags.scm_supported_f || vha->flags.nvme2_enabled) {
> 		mcp->mb[1] |=3D BIT_1;
> 		mcp->mb[16] =3D MSW(ha->sf_init_cb_dma);
> 		mcp->mb[17] =3D LSW(ha->sf_init_cb_dma);
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c =
b/drivers/scsi/qla2xxx/qla_nvme.c
> index 675f2b1180e8..0d73c285a4d1 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -69,6 +69,14 @@ int qla_nvme_register_remote(struct scsi_qla_host =
*vha, struct fc_port *fcport)
> 		return ret;
> 	}
>=20
> +	if (fcport->nvme_prli_service_param & NVME_PRLI_SP_SLER)
> +		ql_log(ql_log_info, vha, 0x212a,
> +		       "PortID:%06x Supports SLER\n", req.port_id);
> +
> +	if (fcport->nvme_prli_service_param & NVME_PRLI_SP_PI_CTRL)
> +		ql_log(ql_log_info, vha, 0x212b,
> +		       "PortID:%06x Supports PI control\n", =
req.port_id);
> +
> 	rport =3D fcport->nvme_remote_port->private;
> 	rport->fcport =3D fcport;
>=20
> @@ -368,6 +376,7 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
> 	struct srb_iocb *nvme =3D &sp->u.iocb_cmd;
> 	struct scatterlist *sgl, *sg;
> 	struct nvmefc_fcp_req *fd =3D nvme->u.nvme.desc;
> +	struct nvme_fc_cmd_iu *cmd =3D fd->cmdaddr;
> 	uint32_t        rval =3D QLA_SUCCESS;
>=20
> 	/* Setup qpair pointers */
> @@ -399,8 +408,6 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
> 	}
>=20
> 	if (unlikely(!fd->sqid)) {
> -		struct nvme_fc_cmd_iu *cmd =3D fd->cmdaddr;
> -
> 		if (cmd->sqe.common.opcode =3D=3D =
nvme_admin_async_event) {
> 			nvme->u.nvme.aen_op =3D 1;
> 			atomic_inc(&ha->nvme_active_aen_cnt);
> @@ -446,6 +453,11 @@ static inline int qla2x00_start_nvme_mq(srb_t =
*sp)
> 	} else if (fd->io_dir =3D=3D 0) {
> 		cmd_pkt->control_flags =3D 0;
> 	}
> +	/* Set BIT_13 of control flags for Async event */
> +	if (vha->flags.nvme2_enabled &&
> +	    cmd->sqe.common.opcode =3D=3D nvme_admin_async_event) {
> +		cmd_pkt->control_flags |=3D =
cpu_to_le16(CF_ADMIN_ASYNC_EVENT);
> +	}
>=20
> 	/* Set NPORT-ID */
> 	cmd_pkt->nport_handle =3D cpu_to_le16(sp->fcport->loop_id);
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.h =
b/drivers/scsi/qla2xxx/qla_nvme.h
> index cf45a5b277f1..5d5f115a77c3 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.h
> +++ b/drivers/scsi/qla2xxx/qla_nvme.h
> @@ -54,6 +54,7 @@ struct cmd_nvme {
> 	uint64_t rsvd;
>=20
> 	__le16	control_flags;		/* Control Flags */
> +#define CF_ADMIN_ASYNC_EVENT		BIT_13
> #define CF_NVME_FIRST_BURST_ENABLE	BIT_11
> #define CF_DIF_SEG_DESCR_ENABLE         BIT_3
> #define CF_DATA_SEG_DESCR_ENABLE        BIT_2
> diff --git a/drivers/scsi/qla2xxx/qla_os.c =
b/drivers/scsi/qla2xxx/qla_os.c
> index a4d737b92ec1..a186c3a55088 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4231,6 +4231,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, =
uint16_t req_len, uint16_t rsp_len,
> 						&ha->sf_init_cb_dma);
> 		if (!ha->sf_init_cb)
> 			goto fail_sf_init_cb;
> +		memset(ha->sf_init_cb, 0, sizeof(struct init_sf_cb));
> 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0199,
> 			   "sf_init_cb=3D%p.\n", ha->sf_init_cb);
> 	}
> --=20
> 2.19.0.rc0
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

