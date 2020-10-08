Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED79C4363D
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 03:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41AB521527
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 03:00:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CKLljqDe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbgJHDAm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 23:00:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49404 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgJHDAl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 23:00:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982xwNN142152;
        Thu, 8 Oct 2020 03:00:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=4TTN/ipW7zc2E7EReEfmGWNBMsmc+a8XS8wcUFXqs5I=;
 b=CKLljqDeMn2dz+zWEIuAqAhEna+wYpJ07WJ/1Y4PuOjSH/rfb1+pSmFd+th2Z8fCBeUN
 uuHyFGQ/UUWVWuTtHEQeJbNFzkOHn8on5+6NzaW84Mmk5ne3Q32LMFJXvjro/k1KC/DB
 Fm34S3O6Ye+KcQyJlxl+BkhtsXWzienc9v1pUvPL4rVOEQvbhphPtdC8+R9ptXEQfQM6
 8PSif+ypCDeYOq3RStqLYfBiVIxMxX7ftYhev51rThoPHKC6SmX6EIT9E7199zsSITMM
 W7kaJjK4cYXO3UqWRb7wqFZNT0w+2GELK7nOXVGiTJ/Gp6m/AZ9L/dAk75ggVHDeLaGb Wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33ym34tapk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 03:00:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982tDSR160730;
        Thu, 8 Oct 2020 03:00:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33yyjj1ker-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 03:00:33 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09830WZQ030227;
        Thu, 8 Oct 2020 03:00:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 20:00:32 -0700
To:     Ye Bin <yebin10@huawei.com>
Cc:     <hare@kernel.org>, <linux-scsi@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: myrb: Fix inconsistent of format with argument
 type in myrb.c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wo01whfd.fsf@ca-mkp.ca.oracle.com>
References: <20200930021637.2831618-1-yebin10@huawei.com>
Date:   Wed, 07 Oct 2020 23:00:30 -0400
In-Reply-To: <20200930021637.2831618-1-yebin10@huawei.com> (Ye Bin's message
        of "Wed, 30 Sep 2020 10:16:37 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ye,

> Fix follow warnings:
> [drivers/scsi/myrb.c:1052]: (warning) %d in format string (no. 1)
> 	requires 'int' but the argument type is 'unsigned int'.
> [drivers/scsi/myrb.c:1052]: (warning) %d in format string (no. 2)
> 	requires 'int' but the argument type is 'unsigned int'.
> [drivers/scsi/myrb.c:1052]: (warning) %d in format string (no. 4)
> 	requires 'int' but the argument type is 'unsigned int'.
> [drivers/scsi/myrb.c:2170]: (warning) %d in format string (no. 1)
> 	requires 'int' but the argument type is 'unsigned int'.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
