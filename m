Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5845CC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 17:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 323102076D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 17:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MSjjNQQo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgGMREU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 13:04:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33396 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729747AbgGMREU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 13:04:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DGrAuX091072;
        Mon, 13 Jul 2020 17:04:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LQ57EjNguN4aJMw2guqoz5/rLf5uqgCo+/29oLpDYd8=;
 b=MSjjNQQo7l8WmbPNF/KY1C8MRqMPQafTgmXB1+b6D2pkDUmHSWc1zX9qxEqwtVUFyWNt
 L5kSU4v2HRfLJa62ebKvCfvtz0+DX2kqvtZjV9QX9Sh+6XT3+zoJ6l29F3g+pdsrCf87
 rzNnlzHMnudMn/piteje2qTR8sbEIZVgGxXYBTIQSI3sDhc+1SQQUZYvcGea1X0r3E5b
 TTqL9n8kr/9LiDm3p+zchXF6+YdKRMnsFH85o5Mpbvt7Wc1H0+AFmk9Oa5TrnxXGYbJo
 uJD5eXSnDWG6vMTJEoGgG2kQSAZYHv+Os9TZYTHCxs3Uqozr1geRmdZxE+dL7Horfl9s gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3275cm08tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 17:04:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DGrXOL149318;
        Mon, 13 Jul 2020 17:04:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 327q0mmp20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 17:04:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06DH4Hoi003814;
        Mon, 13 Jul 2020 17:04:17 GMT
Received: from [10.154.152.183] (/10.154.152.183)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 10:04:17 -0700
Subject: Re: [PATCH] qla2xxx: Address a set of sparse warnings.
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200708162515.29805-1-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <831effa7-0fab-ef90-f585-c3f9d489b7b5@oracle.com>
Date:   Mon, 13 Jul 2020 12:04:16 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708162515.29805-1-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130122
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 7/8/20 11:25 AM, Nilesh Javali wrote:
> From: Shyam Sundar <ssundar@marvell.com>
> 
> Fix sparse warnings,
> drivers/scsi/qla2xxx/qla_isr.c:881:23: warning: restricted __le16 degrades
> to integer
> drivers/scsi/qla2xxx/qla_isr.c:881:23: warning: cast to restricted __le16
> 
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h | 36 +++++++++++++++++-----------------
>   drivers/scsi/qla2xxx/qla_fw.h  | 28 +++++++++++++-------------
>   drivers/scsi/qla2xxx/qla_isr.c |  4 ++--
>   3 files changed, 34 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index f6b8502a35ab..297291624ffb 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -1997,13 +1997,13 @@ typedef struct {
>   	uint8_t sys_define;		/* System defined. */
>   	uint8_t entry_status;		/* Entry Status. */
>   	uint32_t handle;		/* System handle. */
> -	uint16_t scsi_status;		/* SCSI status. */
> -	uint16_t comp_status;		/* Completion status. */
> -	uint16_t state_flags;		/* State flags. */
> -	uint16_t status_flags;		/* Status flags. */
> -	uint16_t rsp_info_len;		/* Response Info Length. */
> -	uint16_t req_sense_length;	/* Request sense data length. */
> -	uint32_t residual_length;	/* Residual transfer length. */
> +	__le16 scsi_status;		/* SCSI status. */
> +	__le16 comp_status;		/* Completion status. */
> +	__le16 state_flags;		/* State flags. */
> +	__le16 status_flags;		/* Status flags. */
> +	__le16 rsp_info_len;		/* Response Info Length. */
> +	__le16 req_sense_length;	/* Request sense data length. */
> +	__le32 residual_length;		/* Residual transfer length. */
>   	uint8_t rsp_info[8];		/* FCP response information. */
>   	uint8_t req_sense_data[32];	/* Request sense data. */
>   } sts_entry_t;
> @@ -2193,20 +2193,20 @@ struct mbx_entry {
>   	uint32_t handle;
>   	target_id_t loop_id;
>   
> -	uint16_t status;
> -	uint16_t state_flags;
> -	uint16_t status_flags;
> +	__le16 status;
> +	__le16 state_flags;
> +	__le16 status_flags;
>   
>   	uint32_t sys_define2[2];
>   
> -	uint16_t mb0;
> -	uint16_t mb1;
> -	uint16_t mb2;
> -	uint16_t mb3;
> -	uint16_t mb6;
> -	uint16_t mb7;
> -	uint16_t mb9;
> -	uint16_t mb10;
> +	__le16 mb0;
> +	__le16 mb1;
> +	__le16 mb2;
> +	__le16 mb3;
> +	__le16 mb6;
> +	__le16 mb7;
> +	__le16 mb9;
> +	__le16 mb10;
>   	uint32_t reserved_2[2];
>   	uint8_t node_name[WWN_SIZE];
>   	uint8_t port_name[WWN_SIZE];
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
> index a0d83c67dc23..bc37539a77b5 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -604,32 +604,32 @@ struct sts_entry_24xx {
>   
>   	uint32_t handle;		/* System handle. */
>   
> -	uint16_t comp_status;		/* Completion status. */
> -	uint16_t ox_id;			/* OX_ID used by the firmware. */
> +	__le16 comp_status;		/* Completion status. */
> +	__le16 ox_id;			/* OX_ID used by the firmware. */
>   
> -	uint32_t residual_len;		/* FW calc residual transfer length. */
> +	__le32 residual_len;		/* FW calc residual transfer length. */
>   
>   	union {
> -		uint16_t reserved_1;
> -		uint16_t nvme_rsp_pyld_len;
> +		__le16 reserved_1;
> +		__le16 nvme_rsp_pyld_len;
>   	};
>   
> -	uint16_t state_flags;		/* State flags. */
> +	__le16 state_flags;		/* State flags. */
>   #define SF_TRANSFERRED_DATA	BIT_11
>   #define SF_NVME_ERSP            BIT_6
>   #define SF_FCP_RSP_DMA		BIT_0
>   
> -	uint16_t retry_delay;
> -	uint16_t scsi_status;		/* SCSI status. */
> +	__le16 retry_delay;
> +	__le16 scsi_status;		/* SCSI status. */
>   #define SS_CONFIRMATION_REQ		BIT_12
>   
> -	uint32_t rsp_residual_count;	/* FCP RSP residual count. */
> +	__le32 rsp_residual_count;	/* FCP RSP residual count. */
>   
> -	uint32_t sense_len;		/* FCP SENSE length. */
> +	__le32 sense_len;		/* FCP SENSE length. */
>   
>   	union {
>   		struct {
> -			uint32_t rsp_data_len;	/* FCP response data length  */
> +			__le32 rsp_data_len;	/* FCP response data length  */
>   			uint8_t data[28];	/* FCP rsp/sense information */
>   		};
>   		struct nvme_fc_ersp_iu nvme_ersp;
> @@ -742,10 +742,10 @@ struct purex_entry_24xx {
>   	uint16_t status_flags;
>   	uint16_t nport_handle;
>   
> -	uint16_t frame_size;
> -	uint16_t trunc_frame_size;
> +	__le16 frame_size;
> +	__le16 trunc_frame_size;
>   
> -	uint32_t rx_xchg_addr;
> +	__le32 rx_xchg_addr;
>   
>   	uint8_t d_id[3];
>   	uint8_t r_ctl;
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 039099ddc472..1c923ee75441 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -791,7 +791,7 @@ qla27xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
>   	}
>   }
>   
> -struct purex_item *
> +static struct purex_item *
>   qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
>   {
>   	struct purex_item *item = NULL;
> @@ -879,7 +879,7 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
>   	struct purex_item *item;
>   	void *fpin_pkt = NULL;
>   
> -	total_bytes = le16_to_cpu(purex->frame_size & 0x0FFF)
> +	total_bytes = (le16_to_cpu(purex->frame_size) & 0x0FFF)
>   	    - PURX_ELS_HEADER_SIZE;
>   	pending_bytes = total_bytes;
>   	entry_count = entry_count_remaining = purex->entry_count;
> 

Looks Good.

Reviewed-by: Himanshu Madhani  <himanshu.madhani@oracle.com>
-- 
Himanshu Madhani                     Oracle Linux Engineering
