Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD80C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 02:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D75620732
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 02:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AynTdYUW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgHUCYF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 22:24:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50802 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbgHUCYE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2020 22:24:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L2MYrv136110;
        Fri, 21 Aug 2020 02:23:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=1AzXLjEPpnWLYbLoMsSP3jYjnRJgSmcm895+0943qZs=;
 b=AynTdYUWeQ22HtziZ0LwfvTk6EUpthDT/KNPrM4lE7HlgiwiCWdSLnvec/s979SYvAdz
 tLbBw8RVNBa41VWQ9sMs5IzANUw4TquXkE2i2MfQvl1WyCYiVon6heGlAizJqPxSH96y
 nK/NxJAQoyp9fAk+4wtd7LD44POQyCMwbuBVWEwUz+X4EQmj9SvK7xDyPs5W4dC1VJwE
 t1/E30uOTkQwIJFqFE7TC/FLMniUEFlBD49A/UQXr3tkFUTsggFOku3mektjkRfXMcYm
 UGiz/Cnf7YduFYi0OSlj3hMCb10/UxuW//FrhGq2VBuj5HZn8CmAHE89OL3zr54pPacl /g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32x74rkx59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 02:23:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L2IL4h055415;
        Fri, 21 Aug 2020 02:21:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3325368k5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 02:21:54 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07L2LpRw000637;
        Fri, 21 Aug 2020 02:21:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 19:21:51 -0700
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <hare@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: libfc: Fix passing zero to 'PTR_ERR' warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ft8gvje1.fsf@ca-mkp.ca.oracle.com>
References: <20200818114235.51052-1-yuehaibing@huawei.com>
        <20200819020546.59172-1-yuehaibing@huawei.com>
Date:   Thu, 20 Aug 2020 22:21:49 -0400
In-Reply-To: <20200819020546.59172-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Wed, 19 Aug 2020 10:05:46 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


YueHaibing,

> diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
> index d8cbc9c0e766..574e842cefed 100644
> --- a/drivers/scsi/libfc/fc_disc.c
> +++ b/drivers/scsi/libfc/fc_disc.c
> @@ -302,7 +302,7 @@ static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
>  	unsigned long delay = 0;
>  
>  	FC_DISC_DBG(disc, "Error %ld, retries %d/%d\n",
> -		    PTR_ERR(fp), disc->retry_count,
> +		    IS_ERR(fp) ? PTR_ERR(fp) : 0, disc->retry_count,
>  		    FC_DISC_RETRY_LIMIT);
>  
>  	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {

Why not PTR_ERR_OR_ZERO()?

-- 
Martin K. Petersen	Oracle Linux Engineering
