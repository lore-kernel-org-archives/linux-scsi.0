Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B50C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 17:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 896012076A
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 17:35:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RdI7Oq4T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbgFVRfK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 13:35:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57772 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729811AbgFVRfJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2020 13:35:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MHBu3U020622;
        Mon, 22 Jun 2020 17:35:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Q1XNSRdJtHYO0sAUNW020TFVUFlva0526Dg0+zGu/pQ=;
 b=RdI7Oq4T/0EHLKmiOZliFZu2yxEpFKXf0HRar9roFAgbZ1Pfd/3yOkE9RUtLNjtfo2Ut
 Pv2mrwWvMzjY0cd2bVnuftJl+fDnvkJU9ZF8oHcMx5NEAi+snVCBQeqWwOiNMJss5lsj
 vvbt0VLFdXZIYHC2wnRLRxCTRAWjdaorNxnFie2l5p1UsWbc9VY7RIx4U8NWAf5vHl/+
 pkAq9k5v1zYHyksI/QScyyVwpqiWCvhNjamSSa9FrSGBimmhWfhSUopzcZYcGxT8IuT4
 yiqxTdwNkRJmgoz4ZOGoUe+9wJwtOqqzDNAOzMfK0b2j9wbY7pffCAW2VxGxPpC4vD9H 1w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31sebbgr6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 22 Jun 2020 17:35:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MHXoMs115855;
        Mon, 22 Jun 2020 17:35:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31sv1m45bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 17:35:04 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05MHZ3xQ017313;
        Mon, 22 Jun 2020 17:35:03 GMT
Received: from [192.168.1.25] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Jun 2020 17:35:02 +0000
Subject: Re: [PATCH] qla2xxx: Set NVME status code for failed NVME FCP request
To:     Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        linux-kernel@vger.kernel.org
References: <20200604100745.89250-1-dwagner@suse.de>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <3bbe9686-acaa-ea4e-c14c-7d33fdf1d97c@oracle.com>
Date:   Mon, 22 Jun 2020 12:35:02 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200604100745.89250-1-dwagner@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006220121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 cotscore=-2147483648 mlxscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 clxscore=1011 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220120
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/4/20 5:07 AM, Daniel Wagner wrote:
> The qla2xxx driver knows when request was processed successfully or
> not. But it always sets the NVME status code to 0/NVME_SC_SUCCESS. The
> upper layer needs to figure out from the rcv_rsplen and
> transferred_length variables if the request was successfully. This is
> not always possible, e.g. when the request data length is 0, the
> transferred_length is also set 0 which is interpreted as success in
> nvme_fc_fcpio_done(). Let's inform the upper
> layer (nvme_fc_fcpio_done()) when something went wrong.
> 
> nvme_fc_fcpio_done() maps all non NVME_SC_SUCCESS status codes to
> NVME_SC_HOST_PATH_ERROR. There isn't any benefit to map the QLA status
> code to the NVME status code. Therefore, let's use NVME_SC_INTERNAL to
> indicate an error which aligns it with the lpfc driver.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>   drivers/scsi/qla2xxx/qla_nvme.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index d66d47a0f958..fa695a4007f8 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -139,11 +139,12 @@ static void qla_nvme_release_fcp_cmd_kref(struct kref *kref)
>   	sp->priv = NULL;
>   	if (priv->comp_status == QLA_SUCCESS) {
>   		fd->rcv_rsplen = le16_to_cpu(nvme->u.nvme.rsp_pyld_len);
> +		fd->status = NVME_SC_SUCCESS;
>   	} else {
>   		fd->rcv_rsplen = 0;
>   		fd->transferred_length = 0;
> +		fd->status = NVME_SC_INTERNAL;
>   	}
> -	fd->status = 0;
>   	spin_unlock_irqrestore(&priv->cmd_lock, flags);
>   
>   	fd->done(fd);
> 

Makes sense.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                     Oracle Linux Engineering
