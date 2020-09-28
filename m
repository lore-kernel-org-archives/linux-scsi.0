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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC52C2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 20:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68079208D5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 20:50:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RwUYi4EY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgI1UuX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 16:50:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55478 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgI1UuW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 16:50:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SKnfYa061270;
        Mon, 28 Sep 2020 20:50:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=IWXiQu6jFTij7MOJI8v+KvE87tI7yDjG0O/ivhXnAMk=;
 b=RwUYi4EYSFxfOF4lwjIKK+IifHJVYs9YVJDSN2yiGqJr5QQ/qHZoAThSnTg2m99m2aJj
 qbt4sY8vjGsJVuofVVUk7fygyRMLlc7KzTMtknEqEwjXss8ozazrvgKIJzhZA+aMoQ4O
 aWAX8OnSpIyFw07mgSFVhhYibqE++/YP1xwBYbyDRHGWF2cxg5rvNOpYiiSUwo9zPa2x
 P4lPwu3eV8ENluDIzkYwxJOer3EjTpOs+hifqy15BpdrWc8LjLK6tbq8nf77H8dvBwF0
 t8O8MIvLXaeaHPPjboNnyP0jrQXtYyEcuYl49RyxJKAue047voTA4JhhuLdi2EVRBDgR ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33swkkqa98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 20:50:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SKYnR0071795;
        Mon, 28 Sep 2020 20:50:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33tf7ksudm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 20:50:20 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SKoJZ8005543;
        Mon, 28 Sep 2020 20:50:19 GMT
Received: from [10.154.166.223] (/10.154.166.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 13:50:19 -0700
Subject: Re: [PATCH 1/7] qla2xxx: Correct the check for sscanf return value
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200928055023.3950-1-njavali@marvell.com>
 <20200928055023.3950-2-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Message-ID: <933061e1-9378-8d62-cc57-c28ababf29e7@oracle.com>
Date:   Mon, 28 Sep 2020 15:50:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200928055023.3950-2-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280158
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
> From: Saurav Kashyap <skashyap@marvell.com>
> 
> Since the version string is modified sscanf returns 4 instead of 6.
> 
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_tmpl.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
> index 8dc82cfd38b2..591df89a4d13 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
> @@ -906,8 +906,8 @@ qla27xx_driver_info(struct qla27xx_fwdt_template *tmp)
>   	uint8_t v[] = { 0, 0, 0, 0, 0, 0 };
>   
>   	WARN_ON_ONCE(sscanf(qla2x00_version_str,
> -			    "%hhu.%hhu.%hhu.%hhu.%hhu.%hhu",
> -			    v+0, v+1, v+2, v+3, v+4, v+5) != 6);
> +			    "%hhu.%hhu.%hhu.%hhu",
> +			    v + 0, v + 1, v + 2, v + 3) != 4);
>   
>   	tmp->driver_info[0] = cpu_to_le32(
>   		v[3] << 24 | v[2] << 16 | v[1] << 8 | v[0]);
> 

Looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                         Oracle Linux Engineering
