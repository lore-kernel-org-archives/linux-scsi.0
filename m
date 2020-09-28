Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 044CDC2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 21:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A36BB2100A
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 21:06:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EslA0+dU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgI1VGA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 17:06:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47446 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbgI1VGA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 17:06:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SKx5C1028250;
        Mon, 28 Sep 2020 21:05:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=eXd90FESn+7aWucN0SK42GwMeRR0mMCHgq1Lig/l2tU=;
 b=EslA0+dUBksiop0K4sgKYuuSqIlKMXxlZkpySP3pTI0BcGpjubXrq7iow8CG5g4/7ERm
 QcQoS57JvVCTgzwedCCTrazuhKdn37MrO34sH3a/IGFG60gTKyIDkHepcWIcHla/rDnC
 QeaXyA+2TLi6zLw/390dXcrvHrO9COS+raM6OZKpq2hXLBPRl1xw3nijwx3oEe4gLCsW
 aB7Qd8NEY13ghRRFNM9vcwwtapHP+RWsOEE1Dxwi6HWnY1mmxG0rC/z+haxz4PE8O0zM
 uJIBcjcUSREwvOpO6Rbq057mFrqweU9B1xMdRKM4KOus0MQ1gO7Aow1BiXkJTMR99y0W 1g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33sx9myaxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 21:05:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SL4FYq147009;
        Mon, 28 Sep 2020 21:05:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33tfhwr8br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 21:05:56 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08SL5u2q013919;
        Mon, 28 Sep 2020 21:05:56 GMT
Received: from [10.154.166.223] (/10.154.166.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 14:05:56 -0700
Subject: Re: [PATCH 6/7] qla2xxx: Fix point-to-point (N2N) device discovery
 issue
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200928055023.3950-1-njavali@marvell.com>
 <20200928055023.3950-7-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Message-ID: <794bf555-c6bd-a4da-a6c8-353d863d6a03@oracle.com>
Date:   Mon, 28 Sep 2020 16:05:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200928055023.3950-7-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280161
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/20 12:50 AM, Nilesh Javali wrote:
> From: Arun Easi <aeasi@marvell.com>
> 
> Driver was using a shorter timeout waiting for PLOGI from the
> peer in point-to-point configurations. Some devices takes
> some time (~4 seconds) to initiate the PLOGI. This peer
> initiating PLOGI is when the peer has a higher P-WWN.
> 
> Increase the wait time based on N2N R_A_TOV.
> 
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h | 2 ++
>   drivers/scsi/qla2xxx/qla_mbx.c | 3 ++-
>   drivers/scsi/qla2xxx/qla_os.c  | 2 ++
>   3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 98814a9a8ea6..b0b4228050e9 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -5147,6 +5147,8 @@ struct sff_8247_a0 {
>   	 ha->current_topology == ISP_CFG_N || \
>   	 !ha->current_topology)
>   
> +#define QLA_N2N_WAIT_TIME	5 /* 2 * ra_tov(n2n) + 1 */
> +
>   #define NVME_TYPE(fcport) \
>   	(fcport->fc4_type & FS_FC4TYPE_NVME) \
>   
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index d861d025bce1..d90880d5cf46 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -3994,7 +3994,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
>   
>   			if (fcport) {
>   				fcport->plogi_nack_done_deadline = jiffies + HZ;
> -				fcport->dm_login_expire = jiffies + 2*HZ;
> +				fcport->dm_login_expire = jiffies +
> +					QLA_N2N_WAIT_TIME * HZ;
>   				fcport->scan_state = QLA_FCPORT_FOUND;
>   				fcport->n2n_flag = 1;
>   				fcport->keep_nport_handle = 1;
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 6c4dc8eff8b8..b7a0feecac76 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -5097,6 +5097,8 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
>   
>   			fcport->fc4_type = e->u.new_sess.fc4_type;
>   			if (e->u.new_sess.fc4_type & FS_FCP_IS_N2N) {
> +				fcport->dm_login_expire = jiffies +
> +					QLA_N2N_WAIT_TIME * HZ;
>   				fcport->fc4_type = FS_FC4TYPE_FCP;
>   				fcport->n2n_flag = 1;
>   				if (vha->flags.nvme_enabled)
> 

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>


-- 
Himanshu Madhani                         Oracle Linux Engineering
