Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2551FC32771
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 03:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E979922522
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 03:04:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XzLerU3d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbgAPDEK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 22:04:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40992 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729130AbgAPDEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2020 22:04:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G33ej1088733;
        Thu, 16 Jan 2020 03:03:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=KeXhpD9A8ap0jnWZbGMJQKNJ2OG+7iix8vPQW43fGuY=;
 b=XzLerU3dluQsrbC/jr1XbcjBeDN/ZijRnvcDHPKyUISJkkybcQUctRrkHUgJGRG4GrCY
 3qsjHbcrYF8EgzQHggYH26kjEHVznlLrT0lwabIqQQn2LmZMNx1g0skD2pyInA/O4fhT
 SjwQiJIRJeTFsJTB3lyBYVkWT3RHN45ajPHp5xyEXplBdMTKGa5POvZV2X/WLIfCqBNd
 2dXQ4mhW9hjHPlS5zqObUh4w+bTnxt8MT6HhB0vkBfOi05RA+/THNEKBsAAvRYEfP2N9
 OqlvPlZiypcXJLRDyT+v7xMHr994FCuqPVf7RjBrtSfnkVN51Xf/uKlq7ybJIlHa3aD4 PQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xf73yqwan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 03:03:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G33iEc089128;
        Thu, 16 Jan 2020 03:03:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xj61ksyxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 03:03:56 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G33YRv004698;
        Thu, 16 Jan 2020 03:03:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 19:03:33 -0800
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Rahul Kundu <rahul.kundu@chelsio.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel\@vger.kernel.org" <target-devel@vger.kernel.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: Re: Trace seen on target during iSER login
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <BYAPR12MB3080466CC0D6B968D3525F5BEF270@BYAPR12MB3080.namprd12.prod.outlook.com>
        <53ca2c5e-25e1-9762-9a8e-0036c02fdb3b@acm.org>
        <BYAPR12MB3080FE52C175C69092D8428EEF3F0@BYAPR12MB3080.namprd12.prod.outlook.com>
Date:   Wed, 15 Jan 2020 22:03:29 -0500
In-Reply-To: <BYAPR12MB3080FE52C175C69092D8428EEF3F0@BYAPR12MB3080.namprd12.prod.outlook.com>
        (Rahul Kundu's message of "Tue, 7 Jan 2020 07:53:58 +0000")
Message-ID: <yq1blr4p0fy.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=800
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=852 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160024
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Bart!

> The reported trace is not observed with the patch and Patch is tested
> good.  Thanks Bart.

> From f25182525499b52db6be00b34dbfd3662d29e403 Mon Sep 17 00:00:00 2001
> From: Bart Van Assche <bvanassche@acm.org>
> Date: Mon, 30 Dec 2019 07:48:20 -0800
> Subject: [PATCH] RDMA/isert: Fix a recently introduced regression related to  logout

Are you going to submit this?

-- 
Martin K. Petersen	Oracle Linux Engineering
