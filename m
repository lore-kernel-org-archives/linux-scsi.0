Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF72C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C123721D7E
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 02:18:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ByQbn9Jd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbgIJCR4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 22:17:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54628 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730022AbgIJCMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 22:12:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2AccQ088409;
        Thu, 10 Sep 2020 02:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=0Ob3xkYnA7g87tw9QRrxEgtLXmHMT5ZuRH5gPzD9bu4=;
 b=ByQbn9JdMyJhjBqhbUKTU1FHB5qP+V2HKUbVR14Yum0o1FMdcJ2wGyiS19Fl28HagoYo
 efUT/z0KgFbzRRhUtWDnZtdhcn5qU828kCrduExDf1Fr8h8sLPAHuKsjKR0caEytaeHf
 93R0kjidhQ2o+Gxdfhb0kxOkD2etGvRas6tqUJsNSKex9y6koIvlvHKic/XMO4XK3kAK
 KngrXaUKLRV3bT8D5SCbWO7ZrS4p69fOaUe4VjuhprCCFO+Bin29BD7LmiLk4VwPawoW
 yjZp2USgw1ahg2U2OIs0KANsabWtIpcxzVz5MKtM7et1OHxYE0mlzLc8/53oSAFRQeHV Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33c2mm56ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 02:12:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2APkX082529;
        Thu, 10 Sep 2020 02:12:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33cmkyy6r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 02:12:01 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08A2BvFi012904;
        Thu, 10 Sep 2020 02:11:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 19:11:56 -0700
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     <tyreld@linux.ibm.com>, <mpe@ellerman.id.au>,
        <benh@kernel.crashing.org>, <paulus@samba.org>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ibmvfc: Fix error return in ibmvfc_probe()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1ra2xf0.fsf@ca-mkp.ca.oracle.com>
References: <20200907083949.154251-1-jingxiangfeng@huawei.com>
Date:   Wed, 09 Sep 2020 22:11:50 -0400
In-Reply-To: <20200907083949.154251-1-jingxiangfeng@huawei.com> (Jing
        Xiangfeng's message of "Mon, 7 Sep 2020 16:39:49 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jing,

> Fix to return error code PTR_ERR() from the error handling case instead
> of 0.

Applied to 5.10/scsi-staging. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
