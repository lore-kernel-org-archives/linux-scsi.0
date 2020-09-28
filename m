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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F176C4727F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 20:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 081632080A
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 20:52:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="teQjvJ7G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgI1Uwo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 16:52:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57260 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgI1Uwo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 16:52:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SKnemp061205;
        Mon, 28 Sep 2020 20:52:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/E5CXsWK08KAIsAjBRORBTfLpLQfAn1bYuU9lgbR53Y=;
 b=teQjvJ7GNyLUyfBYfSyEWO9qM/G5gmAdff4ycAl/tpzEgqZHxYtRLuW8l6pMIQ8rQJia
 p6EyMBEDXN8a6TZCirkzlx0a6gAYUk0zmPnjSEUbtw0w3BCQv5lAEI+rKw6BF/jxK5Dk
 YYBmd1gwSdVXZk/rsqxlSpVOpzGEmDeCzEDHAY6ZHFZjkL8lqM9MeRnRzVVvrtPW03mP
 R8XPKup1MQ5c44bnBLfqMLyCThlHdfAsB8Bd1dxFZjNP0meKKdn2Y8uPv9H+HRSPphnG
 ffQtR7hNe6Rv7KlBCKkfNUfuFDgBUpVDMDRvYf14ExCyWJcCvL+kn4f8MD898L93/v2g RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33swkkqakr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 20:52:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SKoOjf103744;
        Mon, 28 Sep 2020 20:52:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33tfhwquq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 20:52:41 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08SKqfRm005948;
        Mon, 28 Sep 2020 20:52:41 GMT
Received: from [10.154.166.223] (/10.154.166.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 13:52:41 -0700
Subject: Re: [PATCH 3/7] qla2xxx: Fix MPI reset needed message
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200928055023.3950-1-njavali@marvell.com>
 <20200928055023.3950-4-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Message-ID: <71201955-59d7-7d32-75d3-fb98b6c4ec50@oracle.com>
Date:   Mon, 28 Sep 2020 15:52:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200928055023.3950-4-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280159
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/20 12:50 AM, Nilesh Javali wrote:
> From: Arun Easi <aeasi@marvell.com>
> 
> When printing the message:
> "MPI Heartbeat stop. MPI reset is not needed.."
> 
> ..the wrong register was checked leading to always printing that MPI reset
> is not needed, even when it is needed.
> Fix the MPI reset message.
> 
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_isr.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index bb3beaa77d39..27c2a89bd2ff 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -767,7 +767,7 @@ qla27xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
>   	ql_log(ql_log_warn, vha, 0x02f0,
>   	       "MPI Heartbeat stop. MPI reset is%s needed. "
>   	       "MB0[%xh] MB1[%xh] MB2[%xh] MB3[%xh]\n",
> -	       mb[0] & BIT_8 ? "" : " not",
> +	       mb[1] & BIT_8 ? "" : " not",
>   	       mb[0], mb[1], mb[2], mb[3]);
>   
>   	if ((mb[1] & BIT_8) == 0)
> 

Following tag needs to be added

Fixes: cbb01c2f2f630 ("scsi: qla2xxx: Fix MPI failure AEN (8200) handling")
Cc: stable@vger.kernel.org


Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                         Oracle Linux Engineering
