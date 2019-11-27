Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449A8C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 02:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10EA8206CC
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 02:45:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pqK4ca2c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfK0CpM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 21:45:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45320 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfK0CpM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 21:45:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR2iUXP019496;
        Wed, 27 Nov 2019 02:45:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=3dLSz5VlM2jsZP6lyNOIkd8bypmWpog4+bkPM32MxGA=;
 b=pqK4ca2cbnIeY7YFSU0Y7ATfv27Pr8hIqyw/n9H5zHTjJReAwLbAJ2DiYtQ86IFxmPUF
 bDWD0nPo98kBxwelsip1rZjyY8EPjCRxkLlT+lLLm5eSTHvFSf7CuQQbyYaGvlLVv2Vp
 y3fChhbiSzxaBOsK+3pBmK0AlGO8ic9+++rmSFR/QyNR9C6bhWinbimNHDZMAuQ1Zsbz
 Nr1qIry35l2nIb9/5+nhOrI5pu3sFM2D3O58gK192qS9PS4PUkH8pQlDj73sMowAdgv0
 J9nG8K7mwyr0LdrzEl0a97J+GXBvfS016xL4hgh2GXvJHevL2pXrePUHvgB8Ia4SPqjh 3w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wewdradj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 02:45:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR2iYQY079414;
        Wed, 27 Nov 2019 02:45:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wgvfkqxqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 02:45:01 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAR2j0aX012739;
        Wed, 27 Nov 2019 02:45:00 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 18:44:59 -0800
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <megaraidlinux.pdl@broadcom.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: megaraid_sas: Make poll_aen_lock static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191125144454.22680-1-yuehaibing@huawei.com>
Date:   Tue, 26 Nov 2019 21:44:56 -0500
In-Reply-To: <20191125144454.22680-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Mon, 25 Nov 2019 22:44:54 +0800")
Message-ID: <yq1h82q82c7.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=862
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911270021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=944 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911270021
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


YueHaibing,

> Fix sparse warning:
>
> drivers/scsi/megaraid/megaraid_sas_base.c:187:12:
>  warning: symbol 'poll_aen_lock' was not declared. Should it be static?

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
