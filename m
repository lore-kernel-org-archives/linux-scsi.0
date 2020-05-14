Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 088F4C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 19:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D249C20675
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 19:17:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YyvfSEnT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgENTRq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 15:17:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47966 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgENTRq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 15:17:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EJHNCI037167;
        Thu, 14 May 2020 19:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=MNfjGoTX12qUf3FuZOI2HaIHDFXjp2aTGWZF+AHpJrg=;
 b=YyvfSEnTTefvIfeu/bjlBJvnvnxjyDVp632SKdhUaOSHlCYBx38C419SVZLSpy6bv4fP
 c2gNp5umCB8RA8SUysX2/JYhWbUHeChldILiegDMlAqRJxBVleA+dWr/9ro3IGzHvjiY
 K/X53lXWPpU82AMpjlVfhMchOyVsHEHVCCzRRwCHwIs6U4TOQVUIHF3yjqwFJrWepRww
 iHRQh1b/PkVZ5bgrDHUY9pfaSWJcq+OXLQz8MCCXxOrOkUcMMunjBDj2EqEoQXaWvzJF
 kFpfJ6thYgDldWABJhxUMZQA8nKRFkHuUxYoVRS5oRXnSGrHfjZUN4/hwd/Cx42wUx7+ 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3100xwmm69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 19:17:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EJCibN104005;
        Thu, 14 May 2020 19:15:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3100ypwv4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 19:15:42 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04EJFfcP024845;
        Thu, 14 May 2020 19:15:42 GMT
Received: from [192.168.1.24] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 12:15:41 -0700
Subject: Re: [PATCH 3/3] qla2xxx: Pass SCM counters to the application.
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200514101026.10040-1-njavali@marvell.com>
 <20200514101026.10040-4-njavali@marvell.com>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <1970ba0e-8c7c-3e8e-3478-10a4e7fb693d@oracle.com>
Date:   Thu, 14 May 2020 14:15:40 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514101026.10040-4-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005140168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140169
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/14/20 5:10 AM, Nilesh Javali wrote:
> From: Shyam Sundar <ssundar@marvell.com>
> 
> Implement 3 functions to pass on SAN congestion management
> related counters tracked by the driver, up to the Marvell
> application using the BSG interface.
> 
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_bsg.c | 114 +++++++++++++++++++++++++++++++++
>   drivers/scsi/qla2xxx/qla_bsg.h |   3 +
>   2 files changed, 117 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index 97b51c477972..bd898bbdd44d 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2446,6 +2446,111 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
>   	return 0;
>   }
>   
> +static int
> +qla2x00_get_drv_attr(struct bsg_job *bsg_job)
> +{
> +	struct qla_drv_attr drv_attr;
> +	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
> +
> +	memset(&drv_attr, 0, sizeof(struct qla_drv_attr));
> +	/* Additional check should be added if SCM is not enabled
> +	 * by default for a given driver version.
> +	 */
> +	drv_attr.attributes |= QLA_DRV_ATTR_SCM_SUPPORTED;
> +
> +	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +			    bsg_job->reply_payload.sg_cnt, &drv_attr,
> +			    sizeof(struct qla_drv_attr));
> +
> +	bsg_reply->reply_payload_rcv_len = sizeof(struct qla_drv_attr);
> +	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_OK;
> +
> +	bsg_job->reply_len = sizeof(*bsg_job->reply);
> +	bsg_reply->result = DID_OK << 16;
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +		     bsg_reply->reply_payload_rcv_len);
> +
> +	return 0;
> +}
> +
> +static int
> +qla2x00_get_port_scm(struct bsg_job *bsg_job)
> +{
> +	struct Scsi_Host *shost = fc_bsg_to_shost(bsg_job);
> +	scsi_qla_host_t *vha = shost_priv(shost);
> +	struct qla_hw_data *ha = vha->hw;
> +	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
> +
> +	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
> +		return -EPERM;
> +
> +	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +			    bsg_job->reply_payload.sg_cnt, &vha->scm_stats,
> +			    sizeof(struct qla_scm_port));
> +
> +	bsg_reply->reply_payload_rcv_len = sizeof(struct qla_scm_port);
> +	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_OK;
> +
> +	bsg_job->reply_len = sizeof(*bsg_job->reply);
> +	bsg_reply->result = DID_OK << 16;
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +		     bsg_reply->reply_payload_rcv_len);
> +
> +	return 0;
> +}
> +
> +static int
> +qla2x00_get_target_scm(struct bsg_job *bsg_job)
> +{
> +	struct Scsi_Host *shost = fc_bsg_to_shost(bsg_job);
> +	scsi_qla_host_t *vha = shost_priv(shost);
> +	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
> +	struct qla_hw_data *ha = vha->hw;
> +	fc_port_t *fcport =  NULL;
> +	int rval;
> +	struct qla_scm_target *scm_stats = NULL;
> +
> +	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
> +		return -EPERM;
> +
> +	scm_stats = kzalloc(sizeof(*scm_stats), GFP_KERNEL);
> +	if (!scm_stats) {
> +		ql_log(ql_log_warn, vha, 0x7024,
> +		       "Failed to allocate memory for target scm stats.\n");
> +		return -ENOMEM;
> +	}
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +			  bsg_job->request_payload.sg_cnt, scm_stats,
> +			  sizeof(struct qla_scm_target));
> +
> +	fcport = qla2x00_find_fcport_by_wwpn(vha, scm_stats->wwpn, 0);
> +	if (fcport) {
> +		/* Copy SCM Target data to local struct, keep WWPN from user */
> +		memcpy(&scm_stats->current_events,
> +		       &fcport->scm_stats.current_events,
> +		       (sizeof(struct qla_scm_target) -
> +			sizeof(scm_stats->wwpn)));
> +		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +				    bsg_job->reply_payload.sg_cnt, scm_stats,
> +				    sizeof(struct qla_scm_target));
> +		rval = EXT_STATUS_OK;
> +	} else {
> +		rval = EXT_STATUS_ERR;
> +	}
> +
> +	bsg_reply->reply_payload_rcv_len = sizeof(struct qla_scm_target);
> +	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
> +
> +	bsg_job->reply_len = sizeof(*bsg_job->reply);
> +	bsg_reply->result = DID_OK << 16;
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +		     bsg_reply->reply_payload_rcv_len);
> +
> +	kfree(scm_stats);
> +	return 0;
> +}
> +
>   static int
>   qla2x00_process_vendor_specific(struct bsg_job *bsg_job)
>   {
> @@ -2522,6 +2627,15 @@ qla2x00_process_vendor_specific(struct bsg_job *bsg_job)
>   	case QL_VND_SS_GET_FLASH_IMAGE_STATUS:
>   		return qla2x00_get_flash_image_status(bsg_job);
>   
> +	case QL_VND_GET_PORT_SCM:
> +		return qla2x00_get_port_scm(bsg_job);
> +
> +	case QL_VND_GET_TARGET_SCM:
> +		return qla2x00_get_target_scm(bsg_job);
> +
> +	case QL_VND_GET_DRV_ATTR:
> +		return qla2x00_get_drv_attr(bsg_job);
> +
>   	default:
>   		return -ENOSYS;
>   	}
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
> index 0b308859047c..c7cf5f772ad3 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_bsg.h
> @@ -32,6 +32,9 @@
>   #define QL_VND_DPORT_DIAGNOSTICS	0x19
>   #define QL_VND_GET_PRIV_STATS_EX	0x1A
>   #define QL_VND_SS_GET_FLASH_IMAGE_STATUS	0x1E
> +#define QL_VND_GET_PORT_SCM		0x20
> +#define QL_VND_GET_TARGET_SCM		0x21
> +#define QL_VND_GET_DRV_ATTR		0x22
>   
>   /* BSG Vendor specific subcode returns */
>   #define EXT_STATUS_OK			0
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
