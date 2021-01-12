Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03DEC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 16:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DDEA2311B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 16:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403778AbhALQ73 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 11:59:29 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37794 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbhALQ72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 11:59:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CGrqKR174179;
        Tue, 12 Jan 2021 16:58:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=+67yr+SXzA8WF6jodVFfGesjRtmmo5Gwkp8GZmx87Us=;
 b=O8iOXlzh6GJPp3OzuGNAOAdnSLv3R0h8krsvJAHzzYIEG+uVOCr9+f0P5+I3b7D5IT2o
 s5dWrPfs2j6LTJSyXHHgFCvfccL6ylrxKGXk/EpxmYhLA281nlSIK4PvTsgxx6YN9tTA
 TRMY1Hsos9D2LW9/k0tDiYPJHbmBgTYu3AAfbWOCxQl58DIks+LEM8LoGyZbOisrqH5b
 CkhI625WQVynEasnCHu1SCpyzn6sqcMrOqS4FP7y2Adf48NgZJtprHYOuclLJI69iO7P
 JveaEZRWu6MLLKMb4ic76HC+WAqPpxeQ0UoX4q+FdXSxLxpbeAXTN+mRr3jVqCblflGW +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 360kg1qd0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 16:58:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CGtYse101274;
        Tue, 12 Jan 2021 16:58:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 360ke6tq0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 16:58:39 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10CGwd6t002239;
        Tue, 12 Jan 2021 16:58:39 GMT
Received: from [192.168.1.30] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 08:58:38 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v4 1/7] qla2xxx: Implementation to get and manage host,
 target stats and initiator port
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20210111093134.1206-2-njavali@marvell.com>
Date:   Tue, 12 Jan 2021 10:58:37 -0600
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <30764BC8-C2DD-4880-9DD8-33055CA9E57E@oracle.com>
References: <20210111093134.1206-1-njavali@marvell.com>
 <20210111093134.1206-2-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120098
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jan 11, 2021, at 3:31 AM, Nilesh Javali <njavali@marvell.com> =
wrote:
>=20
> From: Saurav Kashyap <skashyap@marvell.com>
>=20
> This statistics will help in debugging process and checking specific
> error counts. It also provides a capability to isolate the port or =
bring it
> out of isolation.
>=20
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
> drivers/scsi/qla2xxx/qla_attr.c |   9 +
> drivers/scsi/qla2xxx/qla_bsg.c  | 342 ++++++++++++++++++++++++++++++++
> drivers/scsi/qla2xxx/qla_bsg.h  |   5 +
> drivers/scsi/qla2xxx/qla_def.h  |  71 +++++++
> drivers/scsi/qla2xxx/qla_gbl.h  |  23 +++
> drivers/scsi/qla2xxx/qla_gs.c   |   1 +
> drivers/scsi/qla2xxx/qla_init.c | 216 ++++++++++++++++++++
> drivers/scsi/qla2xxx/qla_isr.c  |  22 ++
> drivers/scsi/qla2xxx/qla_mbx.c  |   9 +
> drivers/scsi/qla2xxx/qla_os.c   |  20 ++
> 10 files changed, 718 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c =
b/drivers/scsi/qla2xxx/qla_attr.c
> index ab45ac1e5a72..63391c9be05d 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -710,6 +710,12 @@ qla2x00_sysfs_write_reset(struct file *filp, =
struct kobject *kobj,
> 		ql_log(ql_log_info, vha, 0x706e,
> 		    "Issuing ISP reset.\n");
>=20
> +		if (vha->hw->flags.port_isolated) {
> +			ql_log(ql_log_info, vha, 0x706e,
> +			       "Port is isolated, returning.\n");
> +			return -EINVAL;
> +		}
> +
> 		scsi_block_requests(vha->host);
> 		if (IS_QLA82XX(ha)) {
> 			ha->flags.isp82xx_no_md_cap =3D 1;
> @@ -2717,6 +2723,9 @@ qla2x00_issue_lip(struct Scsi_Host *shost)
> 	if (IS_QLAFX00(vha->hw))
> 		return 0;
>=20
> +	if (vha->hw->flags.port_isolated)
> +		return 0;
> +
> 	qla2x00_loop_reset(vha);
> 	return 0;
> }
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c =
b/drivers/scsi/qla2xxx/qla_bsg.c
> index 23b604832a54..e45da05383cd 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -4,6 +4,7 @@
>  * Copyright (c)  2003-2014 QLogic Corporation
>  */
> #include "qla_def.h"
> +#include "qla_gbl.h"
>=20
> #include <linux/kthread.h>
> #include <linux/vmalloc.h>
> @@ -2444,6 +2445,323 @@ qla2x00_get_flash_image_status(struct bsg_job =
*bsg_job)
> 	return 0;
> }
>=20
> +static int
> +qla2x00_manage_host_stats(struct bsg_job *bsg_job)
> +{
> +	scsi_qla_host_t *vha =3D shost_priv(fc_bsg_to_shost(bsg_job));
> +	struct fc_bsg_reply *bsg_reply =3D bsg_job->reply;
> +	struct ql_vnd_mng_host_stats_param *req_data;
> +	struct ql_vnd_mng_host_stats_resp rsp_data;
> +	u32 req_data_len;
> +	int ret =3D 0;
> +
> +	if (!vha->flags.online) {
> +		ql_log(ql_log_warn, vha, 0x0000, "Host is not =
online.\n");
> +		return -EIO;
> +	}
> +
> +	req_data_len =3D bsg_job->request_payload.payload_len;
> +
> +	if (req_data_len !=3D sizeof(struct =
ql_vnd_mng_host_stats_param)) {
> +		ql_log(ql_log_warn, vha, 0x0000, "req_data_len =
invalid.\n");
> +		return -EIO;
> +	}
> +
> +	req_data =3D kzalloc(sizeof(*req_data), GFP_KERNEL);
> +	if (!req_data) {
> +		ql_log(ql_log_warn, vha, 0x0000, "req_data memory =
allocation failure.\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Copy the request buffer in req_data */
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +			  bsg_job->request_payload.sg_cnt, req_data,
> +			  req_data_len);
> +
> +	switch (req_data->action) {
> +	case QLA_STOP:
> +		ret =3D qla2xxx_stop_stats(vha->host, =
req_data->stat_type);
> +		break;
> +	case QLA_START:
> +		ret =3D qla2xxx_start_stats(vha->host, =
req_data->stat_type);
> +		break;
> +	case QLA_CLEAR:
> +		ret =3D qla2xxx_reset_stats(vha->host, =
req_data->stat_type);
> +		break;
> +	default:
> +		ql_log(ql_log_warn, vha, 0x0000, "Invalid action.\n");
> +		ret =3D -EIO;
> +		break;
> +	}
> +
> +	kfree(req_data);
> +
> +	/* Prepare response */
> +	rsp_data.status =3D ret;
> +	bsg_job->reply_payload.payload_len =3D sizeof(struct =
ql_vnd_mng_host_stats_resp);
> +
> +	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D =
EXT_STATUS_OK;
> +	bsg_reply->reply_payload_rcv_len =3D
> +		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +				    bsg_job->reply_payload.sg_cnt,
> +				    &rsp_data,
> +				    sizeof(struct =
ql_vnd_mng_host_stats_resp));
> +
> +	bsg_reply->result =3D DID_OK;
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +		     bsg_reply->reply_payload_rcv_len);
> +
> +	return ret;
> +}
> +
> +static int
> +qla2x00_get_host_stats(struct bsg_job *bsg_job)
> +{
> +	scsi_qla_host_t *vha =3D shost_priv(fc_bsg_to_shost(bsg_job));
> +	struct fc_bsg_reply *bsg_reply =3D bsg_job->reply;
> +	struct ql_vnd_stats_param *req_data;
> +	struct ql_vnd_host_stats_resp rsp_data;
> +	u32 req_data_len;
> +	int ret =3D 0;
> +	u64 ini_entry_count =3D 0;
> +	u64 entry_count =3D 0;
> +	u64 tgt_num =3D 0;
> +	u64 tmp_stat_type =3D 0;
> +	u64 response_len =3D 0;
> +	void *data;
> +
> +	req_data_len =3D bsg_job->request_payload.payload_len;
> +
> +	if (req_data_len !=3D sizeof(struct ql_vnd_stats_param)) {
> +		ql_log(ql_log_warn, vha, 0x0000, "req_data_len =
invalid.\n");
> +		return -EIO;
> +	}
> +
> +	req_data =3D kzalloc(sizeof(*req_data), GFP_KERNEL);
> +	if (!req_data) {
> +		ql_log(ql_log_warn, vha, 0x0000, "req_data memory =
allocation failure.\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Copy the request buffer in req_data */
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +			  bsg_job->request_payload.sg_cnt, req_data, =
req_data_len);
> +
> +	/* Copy stat type to work on it */
> +	tmp_stat_type =3D req_data->stat_type;
> +
> +	if (tmp_stat_type & QLA2XX_TGT_SHT_LNK_DOWN) {
> +		/* Num of tgts connected to this host */
> +		tgt_num =3D qla2x00_get_num_tgts(vha);
> +		/* unset BIT_17 */
> +		tmp_stat_type &=3D ~(1 << 17);
> +	}
> +
> +	/* Total ini stats */
> +	ini_entry_count =3D qla2x00_count_set_bits(tmp_stat_type);
> +
> +	/* Total number of entries */
> +	entry_count =3D ini_entry_count + tgt_num;
> +
> +	response_len =3D sizeof(struct ql_vnd_host_stats_resp) +
> +		(sizeof(struct ql_vnd_stat_entry) * entry_count);
> +
> +	if (response_len > bsg_job->reply_payload.payload_len) {
> +		rsp_data.status =3D EXT_STATUS_BUFFER_TOO_SMALL;
> +		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D =
EXT_STATUS_BUFFER_TOO_SMALL;
> +		bsg_job->reply_payload.payload_len =3D sizeof(struct =
ql_vnd_mng_host_stats_resp);
> +
> +		bsg_reply->reply_payload_rcv_len =3D
> +			=
sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +					    =
bsg_job->reply_payload.sg_cnt, &rsp_data,
> +					    sizeof(struct =
ql_vnd_mng_host_stats_resp));
> +
> +		bsg_reply->result =3D DID_OK;
> +		bsg_job_done(bsg_job, bsg_reply->result,
> +			     bsg_reply->reply_payload_rcv_len);
> +		goto host_stat_out;
> +	}
> +
> +	data =3D kzalloc(response_len, GFP_KERNEL);
> +
> +	ret =3D qla2xxx_get_ini_stats(fc_bsg_to_shost(bsg_job), =
req_data->stat_type,
> +				    data, response_len);
> +
> +	rsp_data.status =3D EXT_STATUS_OK;
> +	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D =
EXT_STATUS_OK;
> +
> +	bsg_reply->reply_payload_rcv_len =3D =
sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +							       =
bsg_job->reply_payload.sg_cnt,
> +							       data, =
response_len);
> +	bsg_reply->result =3D DID_OK;
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +		     bsg_reply->reply_payload_rcv_len);
> +
> +	kfree(data);
> +host_stat_out:
> +	kfree(req_data);
> +	return ret;
> +}
> +
> +static struct fc_rport *
> +qla2xxx_find_rport(scsi_qla_host_t *vha, uint32_t tgt_num)
> +{
> +	fc_port_t *fcport =3D NULL;
> +
> +	list_for_each_entry(fcport, &vha->vp_fcports, list) {
> +		if (fcport->rport->number =3D=3D tgt_num)
> +			return fcport->rport;
> +	}
> +	return NULL;
> +}
> +
> +static int
> +qla2x00_get_tgt_stats(struct bsg_job *bsg_job)
> +{
> +	scsi_qla_host_t *vha =3D shost_priv(fc_bsg_to_shost(bsg_job));
> +	struct fc_bsg_reply *bsg_reply =3D bsg_job->reply;
> +	struct ql_vnd_tgt_stats_param *req_data;
> +	u32 req_data_len;
> +	int ret =3D 0;
> +	u64 response_len =3D 0;
> +	struct ql_vnd_tgt_stats_resp *data =3D NULL;
> +	struct fc_rport *rport =3D NULL;
> +
> +	if (!vha->flags.online) {
> +		ql_log(ql_log_warn, vha, 0x0000, "Host is not =
online.\n");
> +		return -EIO;
> +	}
> +
> +	req_data_len =3D bsg_job->request_payload.payload_len;
> +
> +	if (req_data_len !=3D sizeof(struct ql_vnd_stat_entry)) {
> +		ql_log(ql_log_warn, vha, 0x0000, "req_data_len =
invalid.\n");
> +		return -EIO;
> +	}
> +
> +	req_data =3D kzalloc(sizeof(*req_data), GFP_KERNEL);
> +	if (!req_data) {
> +		ql_log(ql_log_warn, vha, 0x0000, "req_data memory =
allocation failure.\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Copy the request buffer in req_data */
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +			  bsg_job->request_payload.sg_cnt,
> +			  req_data, req_data_len);
> +
> +	response_len =3D sizeof(struct ql_vnd_tgt_stats_resp) +
> +		sizeof(struct ql_vnd_stat_entry);
> +
> +	/* structure + size for one entry */
> +	data =3D kzalloc(response_len, GFP_KERNEL);
> +	if (!data) {
> +		kfree(req_data);
> +		return -ENOMEM;
> +	}
> +
> +	if (response_len > bsg_job->reply_payload.payload_len) {
> +		data->status =3D EXT_STATUS_BUFFER_TOO_SMALL;
> +		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D =
EXT_STATUS_BUFFER_TOO_SMALL;
> +		bsg_job->reply_payload.payload_len =3D sizeof(struct =
ql_vnd_mng_host_stats_resp);
> +
> +		bsg_reply->reply_payload_rcv_len =3D
> +			=
sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +					    =
bsg_job->reply_payload.sg_cnt, &data,
> +					    sizeof(struct =
ql_vnd_tgt_stats_resp));
> +
> +		bsg_reply->result =3D DID_OK;
> +		bsg_job_done(bsg_job, bsg_reply->result,
> +			     bsg_reply->reply_payload_rcv_len);
> +		goto tgt_stat_out;
> +	}
> +
> +	rport =3D qla2xxx_find_rport(vha, req_data->tgt_id);
> +	if (!rport) {
> +		ql_log(ql_log_warn, vha, 0x0000, "target %d not =
found.\n", req_data->tgt_id);
> +		ret =3D EXT_STATUS_INVALID_PARAM;
> +		data->status =3D EXT_STATUS_INVALID_PARAM;
> +		goto reply;
> +	}
> +
> +	ret =3D qla2xxx_get_tgt_stats(fc_bsg_to_shost(bsg_job), =
req_data->stat_type,
> +				    rport, (void *)data, response_len);
> +
> +	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D =
EXT_STATUS_OK;
> +reply:
> +	bsg_reply->reply_payload_rcv_len =3D
> +		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +				    bsg_job->reply_payload.sg_cnt, data,
> +				    response_len);
> +	bsg_reply->result =3D DID_OK;
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +		     bsg_reply->reply_payload_rcv_len);
> +
> +tgt_stat_out:
> +	kfree(data);
> +	kfree(req_data);
> +
> +	return ret;
> +}
> +
> +static int
> +qla2x00_manage_host_port(struct bsg_job *bsg_job)
> +{
> +	scsi_qla_host_t *vha =3D shost_priv(fc_bsg_to_shost(bsg_job));
> +	struct fc_bsg_reply *bsg_reply =3D bsg_job->reply;
> +	struct ql_vnd_mng_host_port_param *req_data;
> +	struct ql_vnd_mng_host_port_resp rsp_data;
> +	u32 req_data_len;
> +	int ret =3D 0;
> +
> +	req_data_len =3D bsg_job->request_payload.payload_len;
> +
> +	if (req_data_len !=3D sizeof(struct ql_vnd_mng_host_port_param)) =
{
> +		ql_log(ql_log_warn, vha, 0x0000, "req_data_len =
invalid.\n");
> +		return -EIO;
> +	}
> +
> +	req_data =3D kzalloc(sizeof(*req_data), GFP_KERNEL);
> +	if (!req_data) {
> +		ql_log(ql_log_warn, vha, 0x0000, "req_data memory =
allocation failure.\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Copy the request buffer in req_data */
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +			  bsg_job->request_payload.sg_cnt, req_data, =
req_data_len);
> +
> +	switch (req_data->action) {
> +	case QLA_ENABLE:
> +		ret =3D qla2xxx_enable_port(vha->host);
> +		break;
> +	case QLA_DISABLE:
> +		ret =3D qla2xxx_disable_port(vha->host);
> +		break;
> +	default:
> +		ql_log(ql_log_warn, vha, 0x0000, "Invalid action.\n");
> +		ret =3D -EIO;
> +		break;
> +	}
> +
> +	kfree(req_data);
> +
> +	/* Prepare response */
> +	rsp_data.status =3D ret;
> +	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D =
EXT_STATUS_OK;
> +	bsg_job->reply_payload.payload_len =3D sizeof(struct =
ql_vnd_mng_host_port_resp);
> +
> +	bsg_reply->reply_payload_rcv_len =3D
> +		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +				    bsg_job->reply_payload.sg_cnt, =
&rsp_data,
> +				    sizeof(struct =
ql_vnd_mng_host_port_resp));
> +	bsg_reply->result =3D DID_OK;
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +		     bsg_reply->reply_payload_rcv_len);
> +
> +	return ret;
> +}
> +
> static int
> qla2x00_process_vendor_specific(struct bsg_job *bsg_job)
> {
> @@ -2520,6 +2838,18 @@ qla2x00_process_vendor_specific(struct bsg_job =
*bsg_job)
> 	case QL_VND_SS_GET_FLASH_IMAGE_STATUS:
> 		return qla2x00_get_flash_image_status(bsg_job);
>=20
> +	case QL_VND_MANAGE_HOST_STATS:
> +		return qla2x00_manage_host_stats(bsg_job);
> +
> +	case QL_VND_GET_HOST_STATS:
> +		return qla2x00_get_host_stats(bsg_job);
> +
> +	case QL_VND_GET_TGT_STATS:
> +		return qla2x00_get_tgt_stats(bsg_job);
> +
> +	case QL_VND_MANAGE_HOST_PORT:
> +		return qla2x00_manage_host_port(bsg_job);
> +
> 	default:
> 		return -ENOSYS;
> 	}
> @@ -2547,6 +2877,17 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
> 		vha =3D shost_priv(host);
> 	}
>=20
> +	/* Disable port will bring down the chip, allow enable command =
*/
> +	if (bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D =
QL_VND_MANAGE_HOST_PORT ||
> +	    bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D =
QL_VND_GET_HOST_STATS)
> +		goto skip_chip_chk;
> +
> +	if (vha->hw->flags.port_isolated) {
> +		bsg_reply->result =3D DID_ERROR;
> +		/* operation not permitted */
> +		return -EPERM;
> +	}
> +
> 	if (qla2x00_chip_is_down(vha)) {
> 		ql_dbg(ql_dbg_user, vha, 0x709f,
> 		    "BSG: ISP abort active/needed -- cmd=3D%d.\n",
> @@ -2554,6 +2895,7 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
> 		return -EBUSY;
> 	}
>=20
> +skip_chip_chk:
> 	ql_dbg(ql_dbg_user, vha, 0x7000,
> 	    "Entered %s msgcode=3D0x%x.\n", __func__, =
bsg_request->msgcode);
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.h =
b/drivers/scsi/qla2xxx/qla_bsg.h
> index 1a09b5512267..0274e99e4a12 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_bsg.h
> @@ -31,6 +31,10 @@
> #define QL_VND_DPORT_DIAGNOSTICS	0x19
> #define QL_VND_GET_PRIV_STATS_EX	0x1A
> #define QL_VND_SS_GET_FLASH_IMAGE_STATUS	0x1E
> +#define QL_VND_MANAGE_HOST_STATS	0x23
> +#define QL_VND_GET_HOST_STATS		0x24
> +#define QL_VND_GET_TGT_STATS		0x25
> +#define QL_VND_MANAGE_HOST_PORT		0x26
>=20
> /* BSG Vendor specific subcode returns */
> #define EXT_STATUS_OK			0
> @@ -40,6 +44,7 @@
> #define EXT_STATUS_DATA_OVERRUN		7
> #define EXT_STATUS_DATA_UNDERRUN	8
> #define EXT_STATUS_MAILBOX		11
> +#define EXT_STATUS_BUFFER_TOO_SMALL	16
> #define EXT_STATUS_NO_MEMORY		17
> #define EXT_STATUS_DEVICE_OFFLINE	22
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h =
b/drivers/scsi/qla2xxx/qla_def.h
> index 30c7e5e63851..ca67be8b62ec 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2557,6 +2557,10 @@ typedef struct fc_port {
> 	u16 n2n_chip_reset;
>=20
> 	struct dentry *dfs_rport_dir;
> +
> +	u64 tgt_short_link_down_cnt;
> +	u64 tgt_link_down_time;
> +	u64 dev_loss_tmo;
> } fc_port_t;
>=20
> enum {
> @@ -3922,6 +3926,7 @@ struct qla_hw_data {
> 		uint32_t	scm_enabled:1;
> 		uint32_t	max_req_queue_warned:1;
> 		uint32_t	plogi_template_valid:1;
> +		uint32_t	port_isolated:1;
> 	} flags;
>=20
> 	uint16_t max_exchg;
> @@ -4851,6 +4856,13 @@ typedef struct scsi_qla_host {
> 	uint8_t	scm_fabric_connection_flags;
>=20
> 	unsigned int irq_offset;
> +
> +	u64 hw_err_cnt;
> +	u64 interface_err_cnt;
> +	u64 cmd_timeout_cnt;
> +	u64 reset_cmd_err_cnt;
> +	u64 link_down_time;
> +	u64 short_link_down_cnt;
> } scsi_qla_host_t;
>=20
> struct qla27xx_image_status {
> @@ -5174,6 +5186,65 @@ struct sff_8247_a0 {
> #define PRLI_PHASE(_cls) \
> 	((_cls =3D=3D DSC_LS_PRLI_PEND) || (_cls =3D=3D =
DSC_LS_PRLI_COMP))
>=20
> +enum ql_vnd_host_stat_action {
> +	QLA_STOP =3D 0,
> +	QLA_START,
> +	QLA_CLEAR,
> +};
> +
> +struct ql_vnd_mng_host_stats_param {
> +	u32 stat_type;
> +	enum ql_vnd_host_stat_action action;
> +} __packed;
> +
> +struct ql_vnd_mng_host_stats_resp {
> +	u32 status;
> +} __packed;
> +
> +struct ql_vnd_stats_param {
> +	u32 stat_type;
> +} __packed;
> +
> +struct ql_vnd_tgt_stats_param {
> +	s32 tgt_id;
> +	u32 stat_type;
> +} __packed;
> +
> +enum ql_vnd_host_port_action {
> +	QLA_ENABLE =3D 0,
> +	QLA_DISABLE,
> +};
> +
> +struct ql_vnd_mng_host_port_param {
> +	enum ql_vnd_host_port_action action;
> +} __packed;
> +
> +struct ql_vnd_mng_host_port_resp {
> +	u32 status;
> +} __packed;
> +
> +struct ql_vnd_stat_entry {
> +	u32 stat_type;	/* Failure type */
> +	u32 tgt_num;	/* Target Num */
> +	u64 cnt;	/* Counter value */
> +} __packed;
> +
> +struct ql_vnd_stats {
> +	u64 entry_count; /* Num of entries */
> +	u64 rservd;
> +	struct ql_vnd_stat_entry entry[0]; /* Place holder of entries */
> +} __packed;
> +
> +struct ql_vnd_host_stats_resp {
> +	u32 status;
> +	struct ql_vnd_stats stats;
> +} __packed;
> +
> +struct ql_vnd_tgt_stats_resp {
> +	u32 status;
> +	struct ql_vnd_stats stats;
> +} __packed;
> +
> #include "qla_target.h"
> #include "qla_gbl.h"
> #include "qla_dbg.h"
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h =
b/drivers/scsi/qla2xxx/qla_gbl.h
> index e39b4f2da73a..708f82311b83 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -945,4 +945,27 @@ extern void =
qla2x00_dfs_remove_rport(scsi_qla_host_t *vha, struct fc_port *fp);
> /* nvme.c */
> void qla_nvme_unregister_remote_port(struct fc_port *fcport);
> void qla_handle_els_plogi_done(scsi_qla_host_t *vha, struct event_arg =
*ea);
> +
> +#define QLA2XX_HW_ERROR			BIT_0
> +#define QLA2XX_SHT_LNK_DWN		BIT_1
> +#define QLA2XX_INT_ERR			BIT_2
> +#define QLA2XX_CMD_TIMEOUT		BIT_3
> +#define QLA2XX_RESET_CMD_ERR		BIT_4
> +#define QLA2XX_TGT_SHT_LNK_DOWN		BIT_17
> +
> +#define QLA2XX_MAX_LINK_DOWN_TIME	100
> +
> +int qla2xxx_start_stats(struct Scsi_Host *shost, u32 flags);
> +int qla2xxx_stop_stats(struct Scsi_Host *shost, u32 flags);
> +int qla2xxx_reset_stats(struct Scsi_Host *shost, u32 flags);
> +
> +int qla2xxx_get_ini_stats(struct Scsi_Host *shost, u32 flags, void =
*data, u64 size);
> +int qla2xxx_get_tgt_stats(struct Scsi_Host *shost, u32 flags,
> +			  struct fc_rport *rport, void *data, u64 size);
> +int qla2xxx_disable_port(struct Scsi_Host *shost);
> +int qla2xxx_enable_port(struct Scsi_Host *shost);
> +
> +uint64_t qla2x00_get_num_tgts(scsi_qla_host_t *vha);
> +uint64_t qla2x00_count_set_bits(u32 num);
> +
> #endif /* _QLA_GBL_H */
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c =
b/drivers/scsi/qla2xxx/qla_gs.c
> index 391ac75e3de3..517d358b0031 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3563,6 +3563,7 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t =
*vha, srb_t *sp)
> 					       __func__, __LINE__,
> 					       fcport->port_name);
>=20
> +					fcport->tgt_link_down_time =3D =
0;
> 					=
qlt_schedule_sess_for_deletion(fcport);
> 					continue;
> 				}
> diff --git a/drivers/scsi/qla2xxx/qla_init.c =
b/drivers/scsi/qla2xxx/qla_init.c
> index dcc0f0d823db..410ff5534a59 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4993,6 +4993,9 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t =
flags)
> 	fcport->login_retry =3D vha->hw->login_retry_count;
> 	fcport->chip_reset =3D vha->hw->base_qpair->chip_reset;
> 	fcport->logout_on_delete =3D 1;
> +	fcport->tgt_link_down_time =3D QLA2XX_MAX_LINK_DOWN_TIME;
> +	fcport->tgt_short_link_down_cnt =3D 0;
> +	fcport->dev_loss_tmo =3D 0;
>=20
> 	if (!fcport->ct_desc.ct_sns) {
> 		ql_log(ql_log_warn, vha, 0xd049,
> @@ -5490,6 +5493,7 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, =
fc_port_t *fcport)
> 	spin_lock_irqsave(fcport->vha->host->host_lock, flags);
> 	*((fc_port_t **)rport->dd_data) =3D fcport;
> 	spin_unlock_irqrestore(fcport->vha->host->host_lock, flags);
> +	fcport->dev_loss_tmo =3D rport->dev_loss_tmo;
>=20
> 	rport->supported_classes =3D fcport->supported_classes;
>=20
> @@ -5548,6 +5552,11 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, =
fc_port_t *fcport)
> 		fcport->logout_on_delete =3D 1;
> 	fcport->n2n_chip_reset =3D fcport->n2n_link_reset_cnt =3D 0;
>=20
> +	if (fcport->tgt_link_down_time < fcport->dev_loss_tmo) {
> +		fcport->tgt_short_link_down_cnt++;
> +		fcport->tgt_link_down_time =3D =
QLA2XX_MAX_LINK_DOWN_TIME;
> +	}
> +
> 	switch (vha->hw->current_topology) {
> 	case ISP_CFG_N:
> 	case ISP_CFG_NL:
> @@ -6908,6 +6917,9 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
> 	if (vha->flags.online) {
> 		qla2x00_abort_isp_cleanup(vha);
>=20
> +		if (vha->hw->flags.port_isolated)
> +			return status;
> +
> 		if (test_and_clear_bit(ISP_ABORT_TO_ROM, =
&vha->dpc_flags)) {
> 			ha->flags.chip_reset_done =3D 1;
> 			vha->flags.online =3D 1;
> @@ -7029,6 +7041,11 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
>=20
> 	}
>=20
> +	if (vha->hw->flags.port_isolated) {
> +		qla2x00_abort_isp_cleanup(vha);
> +		return status;
> +	}
> +
> 	if (!status) {
> 		ql_dbg(ql_dbg_taskm, vha, 0x8022, "%s succeeded.\n", =
__func__);
> 		qla2x00_configure_hba(vha);
> @@ -9171,3 +9188,202 @@ int qla2xxx_delete_qpair(struct scsi_qla_host =
*vha, struct qla_qpair *qpair)
> fail:
> 	return ret;
> }
> +
> +uint64_t
> +qla2x00_count_set_bits(uint32_t num)
> +{
> +	/* Brian Kernighan's Alogorithm */
> +	u64 count =3D 0;
> +
> +	while (num) {
> +		num &=3D (num - 1);
> +		count++;
> +	}
> +	return count;
> +}
> +
> +uint64_t
> +qla2x00_get_num_tgts(scsi_qla_host_t *vha)
> +{
> +	fc_port_t *f, *tf;
> +	u64 count =3D 0;
> +
> +	f =3D NULL;
> +	tf =3D NULL;
> +
> +	list_for_each_entry_safe(f, tf, &vha->vp_fcports, list) {
> +		if (f->port_type !=3D FCT_TARGET)
> +			continue;
> +		count++;
> +	}
> +	return count;
> +}
> +
> +int qla2xxx_reset_stats(struct Scsi_Host *host, u32 flags)
> +{
> +	scsi_qla_host_t *vha =3D shost_priv(host);
> +	fc_port_t *fcport =3D NULL;
> +	unsigned long int_flags;
> +
> +	if (flags & QLA2XX_HW_ERROR)
> +		vha->hw_err_cnt =3D 0;
> +	if (flags & QLA2XX_SHT_LNK_DWN)
> +		vha->short_link_down_cnt =3D 0;
> +	if (flags & QLA2XX_INT_ERR)
> +		vha->interface_err_cnt =3D 0;
> +	if (flags & QLA2XX_CMD_TIMEOUT)
> +		vha->cmd_timeout_cnt =3D 0;
> +	if (flags & QLA2XX_RESET_CMD_ERR)
> +		vha->reset_cmd_err_cnt =3D 0;
> +	if (flags & QLA2XX_TGT_SHT_LNK_DOWN) {
> +		spin_lock_irqsave(&vha->hw->tgt.sess_lock, int_flags);
> +		list_for_each_entry(fcport, &vha->vp_fcports, list) {
> +			fcport->tgt_short_link_down_cnt =3D 0;
> +			fcport->tgt_link_down_time =3D =
QLA2XX_MAX_LINK_DOWN_TIME;
> +		}
> +		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, =
int_flags);
> +	}
> +	vha->link_down_time =3D QLA2XX_MAX_LINK_DOWN_TIME;
> +	return 0;
> +}
> +
> +int qla2xxx_start_stats(struct Scsi_Host *host, u32 flags)
> +{
> +	return qla2xxx_reset_stats(host, flags);
> +}
> +
> +int qla2xxx_stop_stats(struct Scsi_Host *host, u32 flags)
> +{
> +	return qla2xxx_reset_stats(host, flags);
> +}
> +
> +int qla2xxx_get_ini_stats(struct Scsi_Host *host, u32 flags,
> +			  void *data, u64 size)
> +{
> +	scsi_qla_host_t *vha =3D shost_priv(host);
> +	struct ql_vnd_host_stats_resp *resp =3D (struct =
ql_vnd_host_stats_resp *)data;
> +	struct ql_vnd_stats *rsp_data =3D &resp->stats;
> +	u64 ini_entry_count =3D 0;
> +	u64 i =3D 0;
> +	u64 entry_count =3D 0;
> +	u64 num_tgt =3D 0;
> +	u32 tmp_stat_type =3D 0;
> +	fc_port_t *fcport =3D NULL;
> +	unsigned long int_flags;
> +
> +	/* Copy stat type to work on it */
> +	tmp_stat_type =3D flags;
> +
> +	if (tmp_stat_type & BIT_17) {
> +		num_tgt =3D qla2x00_get_num_tgts(vha);
> +		/* unset BIT_17 */
> +		tmp_stat_type &=3D ~(1 << 17);
> +	}
> +	ini_entry_count =3D qla2x00_count_set_bits(tmp_stat_type);
> +
> +	entry_count =3D ini_entry_count + num_tgt;
> +
> +	rsp_data->entry_count =3D entry_count;
> +
> +	i =3D 0;
> +	if (flags & QLA2XX_HW_ERROR) {
> +		rsp_data->entry[i].stat_type =3D QLA2XX_HW_ERROR;
> +		rsp_data->entry[i].tgt_num =3D 0x0;
> +		rsp_data->entry[i].cnt =3D vha->hw_err_cnt;
> +		i++;
> +	}
> +
> +	if (flags & QLA2XX_SHT_LNK_DWN) {
> +		rsp_data->entry[i].stat_type =3D QLA2XX_SHT_LNK_DWN;
> +		rsp_data->entry[i].tgt_num =3D 0x0;
> +		rsp_data->entry[i].cnt =3D vha->short_link_down_cnt;
> +		i++;
> +	}
> +
> +	if (flags & QLA2XX_INT_ERR) {
> +		rsp_data->entry[i].stat_type =3D QLA2XX_INT_ERR;
> +		rsp_data->entry[i].tgt_num =3D 0x0;
> +		rsp_data->entry[i].cnt =3D vha->interface_err_cnt;
> +		i++;
> +	}
> +
> +	if (flags & QLA2XX_CMD_TIMEOUT) {
> +		rsp_data->entry[i].stat_type =3D QLA2XX_CMD_TIMEOUT;
> +		rsp_data->entry[i].tgt_num =3D 0x0;
> +		rsp_data->entry[i].cnt =3D vha->cmd_timeout_cnt;
> +		i++;
> +	}
> +
> +	if (flags & QLA2XX_RESET_CMD_ERR) {
> +		rsp_data->entry[i].stat_type =3D QLA2XX_RESET_CMD_ERR;
> +		rsp_data->entry[i].tgt_num =3D 0x0;
> +		rsp_data->entry[i].cnt =3D vha->reset_cmd_err_cnt;
> +		i++;
> +	}
> +
> +	/* i will continue from previous loop, as target
> +	 * entries are after initiator
> +	 */
> +	if (flags & QLA2XX_TGT_SHT_LNK_DOWN) {
> +		spin_lock_irqsave(&vha->hw->tgt.sess_lock, int_flags);
> +		list_for_each_entry(fcport, &vha->vp_fcports, list) {
> +			if (fcport->port_type !=3D FCT_TARGET)
> +				continue;
> +			if (!fcport->rport)
> +				continue;
> +			rsp_data->entry[i].stat_type =3D =
QLA2XX_TGT_SHT_LNK_DOWN;
> +			rsp_data->entry[i].tgt_num =3D =
fcport->rport->number;
> +			rsp_data->entry[i].cnt =3D =
fcport->tgt_short_link_down_cnt;
> +			i++;
> +		}
> +		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, =
int_flags);
> +	}
> +	resp->status =3D EXT_STATUS_OK;
> +
> +	return 0;
> +}
> +
> +int qla2xxx_get_tgt_stats(struct Scsi_Host *host, u32 flags,
> +			  struct fc_rport *rport, void *data, u64 size)
> +{
> +	struct ql_vnd_tgt_stats_resp *tgt_data =3D data;
> +	fc_port_t *fcport =3D *(fc_port_t **)rport->dd_data;
> +
> +	tgt_data->status =3D 0;
> +	tgt_data->stats.entry_count =3D 1;
> +	tgt_data->stats.entry[0].stat_type =3D flags;
> +	tgt_data->stats.entry[0].tgt_num =3D rport->number;
> +	tgt_data->stats.entry[0].cnt =3D =
fcport->tgt_short_link_down_cnt;
> +
> +	return 0;
> +}
> +
> +int qla2xxx_disable_port(struct Scsi_Host *host)
> +{
> +	scsi_qla_host_t *vha =3D shost_priv(host);
> +
> +	vha->hw->flags.port_isolated =3D 1;
> +
> +	if (qla2x00_chip_is_down(vha))
> +		return 0;
> +
> +	if (vha->flags.online) {
> +		qla2x00_abort_isp_cleanup(vha);
> +		qla2x00_wait_for_sess_deletion(vha);
> +	}
> +
> +	return 0;
> +}
> +
> +int qla2xxx_enable_port(struct Scsi_Host *host)
> +{
> +	scsi_qla_host_t *vha =3D shost_priv(host);
> +
> +	vha->hw->flags.port_isolated =3D 0;
> +	/* Set the flag to 1, so that isp_abort can proceed */
> +	vha->flags.online =3D 1;
> +	set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
> +	qla2xxx_wake_dpc(vha);
> +
> +	return 0;
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c =
b/drivers/scsi/qla2xxx/qla_isr.c
> index f9142dbec112..9cf8326ab9fc 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1059,6 +1059,9 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct =
rsp_que *rsp, uint16_t *mb)
>=20
> 	case MBA_SYSTEM_ERR:		/* System Error */
> 		mbx =3D 0;
> +
> +		vha->hw_err_cnt++;
> +
> 		if (IS_QLA81XX(ha) || IS_QLA83XX(ha) ||
> 		    IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> 			u16 m[4];
> @@ -1112,6 +1115,8 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct =
rsp_que *rsp, uint16_t *mb)
> 		ql_log(ql_log_warn, vha, 0x5006,
> 		    "ISP Request Transfer Error (%x).\n",  mb[1]);
>=20
> +		vha->hw_err_cnt++;
> +
> 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
> 		break;
>=20
> @@ -1119,6 +1124,8 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct =
rsp_que *rsp, uint16_t *mb)
> 		ql_log(ql_log_warn, vha, 0x5007,
> 		    "ISP Response Transfer Error (%x).\n", mb[1]);
>=20
> +		vha->hw_err_cnt++;
> +
> 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
> 		break;
>=20
> @@ -1176,12 +1183,18 @@ qla2x00_async_event(scsi_qla_host_t *vha, =
struct rsp_que *rsp, uint16_t *mb)
> 		vha->flags.management_server_logged_in =3D 0;
> 		qla2x00_post_aen_work(vha, FCH_EVT_LINKUP, =
ha->link_data_rate);
>=20
> +		if (vha->link_down_time < =
vha->hw->port_down_retry_count) {
> +			vha->short_link_down_cnt++;
> +			vha->link_down_time =3D =
QLA2XX_MAX_LINK_DOWN_TIME;
> +		}
> +
> 		break;
>=20
> 	case MBA_LOOP_DOWN:		/* Loop Down Event */
> 		SAVE_TOPO(ha);
> 		ha->flags.lip_ae =3D 0;
> 		ha->current_topology =3D 0;
> +		vha->link_down_time =3D 0;
>=20
> 		mbx =3D (IS_QLA81XX(ha) || IS_QLA8031(ha))
> 			? rd_reg_word(&reg24->mailbox4) : 0;
> @@ -1503,6 +1516,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct =
rsp_que *rsp, uint16_t *mb)
> 		ql_dbg(ql_dbg_async, vha, 0x5016,
> 		    "Discard RND Frame -- %04x %04x %04x.\n",
> 		    mb[1], mb[2], mb[3]);
> +		vha->interface_err_cnt++;
> 		break;
>=20
> 	case MBA_TRACE_NOTIFICATION:
> @@ -1592,6 +1606,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct =
rsp_que *rsp, uint16_t *mb)
>=20
> 	case MBA_IDC_AEN:
> 		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +			vha->hw_err_cnt++;
> 			qla27xx_handle_8200_aen(vha, mb);
> 		} else if (IS_QLA83XX(ha)) {
> 			mb[4] =3D rd_reg_word(&reg24->mailbox4);
> @@ -3101,6 +3116,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, =
struct rsp_que *rsp, void *pkt)
> 				    "Dropped frame(s) detected (0x%x of =
0x%x bytes).\n",
> 				    resid, scsi_bufflen(cp));
>=20
> +				vha->interface_err_cnt++;
> +
> 				res =3D DID_ERROR << 16 | lscsi_status;
> 				goto check_scsi_status;
> 			}
> @@ -3126,6 +3143,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, =
struct rsp_que *rsp, void *pkt)
> 			    "Dropped frame(s) detected (0x%x of 0x%x =
bytes).\n",
> 			    resid, scsi_bufflen(cp));
>=20
> +			vha->interface_err_cnt++;
> +
> 			res =3D DID_ERROR << 16 | lscsi_status;
> 			goto check_scsi_status;
> 		} else {
> @@ -3208,6 +3227,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, =
struct rsp_que *rsp, void *pkt)
>=20
> 	case CS_TRANSPORT:
> 		res =3D DID_ERROR << 16;
> +		vha->hw_err_cnt++;
>=20
> 		if (!IS_PI_SPLIT_DET_CAPABLE(ha))
> 			break;
> @@ -3228,6 +3248,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, =
struct rsp_que *rsp, void *pkt)
> 		ql_dump_buffer(ql_dbg_tgt + ql_dbg_verbose, vha, 0xe0ee,
> 		    pkt, sizeof(*sts24));
> 		res =3D DID_ERROR << 16;
> +		vha->hw_err_cnt++;
> 		break;
> 	default:
> 		res =3D DID_ERROR << 16;
> @@ -3839,6 +3860,7 @@ qla24xx_msix_default(int irq, void *dev_id)
> 			    hccr);
>=20
> 			qla2xxx_check_risc_status(vha);
> +			vha->hw_err_cnt++;
>=20
> 			ha->isp_ops->fw_dump(vha);
> 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c =
b/drivers/scsi/qla2xxx/qla_mbx.c
> index d7d4ab65009c..f438cdedca23 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -180,6 +180,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, =
mbx_cmd_t *mcp)
> 		ql_log(ql_log_warn, vha, 0xd035,
> 		    "Cmd access timeout, cmd=3D0x%x, Exiting.\n",
> 		    mcp->mb[0]);
> +		vha->hw_err_cnt++;
> 		atomic_dec(&ha->num_pend_mbx_stage1);
> 		return QLA_FUNCTION_TIMEOUT;
> 	}
> @@ -307,6 +308,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, =
mbx_cmd_t *mcp)
> 				atomic_dec(&ha->num_pend_mbx_stage2);
> 				ql_dbg(ql_dbg_mbx, vha, 0x1012,
> 				    "Pending mailbox timeout, =
exiting.\n");
> +				vha->hw_err_cnt++;
> 				rval =3D QLA_FUNCTION_TIMEOUT;
> 				goto premature_exit;
> 			}
> @@ -418,6 +420,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, =
mbx_cmd_t *mcp)
> 			    "mb[0-3]=3D[0x%x 0x%x 0x%x 0x%x] mb7 0x%x =
host_status 0x%x hccr 0x%x\n",
> 			    command, ictrl, jiffies, mb[0], mb[1], =
mb[2], mb[3],
> 			    mb[7], host_status, hccr);
> +			vha->hw_err_cnt++;
>=20
> 		} else {
> 			mb[0] =3D RD_MAILBOX_REG(ha, &reg->isp, 0);
> @@ -425,6 +428,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, =
mbx_cmd_t *mcp)
> 			ql_dbg(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1119,
> 			    "MBX Command timeout for cmd %x, =
iocontrol=3D%x jiffies=3D%lx "
> 			    "mb[0]=3D0x%x\n", command, ictrl, jiffies, =
mb[0]);
> +			vha->hw_err_cnt++;
> 		}
> 		ql_dump_regs(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1019);
>=20
> @@ -497,6 +501,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, =
mbx_cmd_t *mcp)
> 				    "mb[0]=3D0x%x, eeh_busy=3D0x%x. =
Scheduling ISP "
> 				    "abort.\n", command, mcp->mb[0],
> 				    ha->flags.eeh_busy);
> +				vha->hw_err_cnt++;
> 				set_bit(ISP_ABORT_NEEDED, =
&vha->dpc_flags);
> 				qla2xxx_wake_dpc(vha);
> 			}
> @@ -521,6 +526,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, =
mbx_cmd_t *mcp)
> 				    "Mailbox cmd timeout occurred, =
cmd=3D0x%x, "
> 				    "mb[0]=3D0x%x. Scheduling ISP abort =
",
> 				    command, mcp->mb[0]);
> +				vha->hw_err_cnt++;
> 				set_bit(ABORT_ISP_ACTIVE, =
&vha->dpc_flags);
> 				clear_bit(ISP_ABORT_NEEDED, =
&vha->dpc_flags);
> 				/* Allow next mbx cmd to come in. */
> @@ -625,6 +631,7 @@ qla2x00_load_ram(scsi_qla_host_t *vha, dma_addr_t =
req_dma, uint32_t risc_addr,
> 		ql_dbg(ql_dbg_mbx, vha, 0x1023,
> 		    "Failed=3D%x mb[0]=3D%x mb[1]=3D%x.\n",
> 		    rval, mcp->mb[0], mcp->mb[1]);
> +		vha->hw_err_cnt++;
> 	} else {
> 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1024,
> 		    "Done %s.\n", __func__);
> @@ -736,6 +743,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t =
risc_addr)
>=20
> 		ql_dbg(ql_dbg_mbx, vha, 0x1026,
> 		    "Failed=3D%x mb[0]=3D%x.\n", rval, mcp->mb[0]);
> +		vha->hw_err_cnt++;
> 		return rval;
> 	}
>=20
> @@ -1313,6 +1321,7 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *vha)
> 	if (rval !=3D QLA_SUCCESS) {
> 		/*EMPTY*/
> 		ql_dbg(ql_dbg_mbx, vha, 0x1033, "Failed=3D%x.\n", rval);
> +		vha->hw_err_cnt++;
> 	} else {
> 		/*EMPTY*/
> 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1034,
> diff --git a/drivers/scsi/qla2xxx/qla_os.c =
b/drivers/scsi/qla2xxx/qla_os.c
> index f80abe28f35a..a760cb38e487 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1274,6 +1274,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
> 	sp =3D scsi_cmd_priv(cmd);
> 	qpair =3D sp->qpair;
>=20
> +	vha->cmd_timeout_cnt++;
> +
> 	if ((sp->fcport && sp->fcport->deleted) || !qpair)
> 		return SUCCESS;
>=20
> @@ -1442,6 +1444,7 @@ __qla2xxx_eh_generic_reset(char *name, enum =
nexus_wait_type type,
> 	    "%s RESET FAILED: %s nexus=3D%ld:%d:%llu cmd=3D%p.\n", name,
> 	    reset_errors[err], vha->host_no, cmd->device->id, =
cmd->device->lun,
> 	    cmd);
> +	vha->reset_cmd_err_cnt++;
> 	return FAILED;
> }
>=20
> @@ -3141,6 +3144,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const =
struct pci_device_id *id)
> 	ha->mr.fcport.supported_classes =3D FC_COS_UNSPECIFIED;
> 	ha->mr.fcport.scan_state =3D 1;
>=20
> +	qla2xxx_reset_stats(host, QLA2XX_HW_ERROR | QLA2XX_SHT_LNK_DWN |
> +			    QLA2XX_INT_ERR | QLA2XX_CMD_TIMEOUT |
> +			    QLA2XX_RESET_CMD_ERR | =
QLA2XX_TGT_SHT_LNK_DOWN);
> +
> 	/* Set the SG table size based on ISP type */
> 	if (!IS_FWI2_CAPABLE(ha)) {
> 		if (IS_QLA2100(ha))
> @@ -5090,6 +5097,7 @@ void qla24xx_create_new_sess(struct =
scsi_qla_host *vha, struct qla_work_evt *e)
> 			fcport->d_id =3D e->u.new_sess.id;
> 			fcport->flags |=3D FCF_FABRIC_DEVICE;
> 			fcport->fw_login_state =3D DSC_LS_PLOGI_PEND;
> +			fcport->tgt_short_link_down_cnt =3D 0;
>=20
> 			memcpy(fcport->port_name, =
e->u.new_sess.port_name,
> 			    WWN_SIZE);
> @@ -7061,6 +7069,8 @@ qla2x00_timer(struct timer_list *t)
> 	uint16_t        w;
> 	struct qla_hw_data *ha =3D vha->hw;
> 	struct req_que *req;
> +	unsigned long flags;
> +	fc_port_t *fcport =3D NULL;
>=20
> 	if (ha->flags.eeh_busy) {
> 		ql_dbg(ql_dbg_timer, vha, 0x6000,
> @@ -7092,6 +7102,16 @@ qla2x00_timer(struct timer_list *t)
> 	if (!vha->vp_idx && IS_QLAFX00(ha))
> 		qlafx00_timer_routine(vha);
>=20
> +	if (vha->link_down_time < QLA2XX_MAX_LINK_DOWN_TIME)
> +		vha->link_down_time++;
> +
> +	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
> +	list_for_each_entry(fcport, &vha->vp_fcports, list) {
> +		if (fcport->tgt_link_down_time < =
QLA2XX_MAX_LINK_DOWN_TIME)
> +			fcport->tgt_link_down_time++;
> +	}
> +	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
> +
> 	/* Loop down handler. */
> 	if (atomic_read(&vha->loop_down_timer) > 0 &&
> 	    !(test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags)) &&
> --=20
> 2.19.0.rc0
>=20

Looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

