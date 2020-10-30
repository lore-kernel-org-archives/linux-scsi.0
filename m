Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E72C2D0A3
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 02:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE0C820738
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 02:11:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R6eZ6m6D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgJ3CLA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 22:11:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45870 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgJ3CLA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 22:11:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09U29nql032280;
        Fri, 30 Oct 2020 02:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=r1Z2be8KC2in28npgG/4iHWPhv+sMMrT7mFRw6ixn9M=;
 b=R6eZ6m6DGHzeLuz3n7OK5CdMCPOFTP0FHjup7sLY8/pyMKrJGXzbapWpXsz2yb88THn0
 1fz6VtO1mA/8vu2rRD5xVwCdlWAdpFfX3g06FX/4PoymQTfQa9jeOT6D0wS8cxuswdak
 jg063hhwupC8VSRONimhGMJl6wO1pDMFtxYaZZom2rolc/7frEnFdxEsMJPRAKmxMhz2
 hXKOz8x8XJUiMXKBXOx20FvWivIOXH6M2QrrI9e5tLj/mhkY6CmtBK38V7jPmsKcVySI
 u2OaDLvCeckiJvLcR2jU0cE3b3kP6iHH/NXV4N/ADCpI0WngqstV+splk4Ew1hMKhXQx Aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7m7q9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 02:10:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09U29SiA047787;
        Fri, 30 Oct 2020 02:10:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34cx70696x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 02:10:55 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09U2AsjN030437;
        Fri, 30 Oct 2020 02:10:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 19:10:53 -0700
To:     ching Huang <ching2048@areca.com.tw>
Cc:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] scsi: arcmsr: configure the default SCSI device
 command timeout value
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zh44zcnw.fsf@ca-mkp.ca.oracle.com>
References: <53bbf27e75420ae1de09899c40b42e4c2d5edda6.camel@areca.com.tw>
Date:   Thu, 29 Oct 2020 22:10:51 -0400
In-Reply-To: <53bbf27e75420ae1de09899c40b42e4c2d5edda6.camel@areca.com.tw>
        (ching Huang's message of "Tue, 27 Oct 2020 11:27:59 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


ching,

> This patch is against to mkp's 5.10/scsi-fixes.
>
> 1. Configure the default SCSI device command timeout value.
> 2. Confirm get free ccb in spin_lock circle.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
