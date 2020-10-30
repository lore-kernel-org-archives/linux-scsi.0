Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C5B2C4363A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 02:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C77D920756
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 02:19:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PNK305Ln"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgJ3CT0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 22:19:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51742 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgJ3CT0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 22:19:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09U2H4rv058204;
        Fri, 30 Oct 2020 02:19:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=9blWy4O3mGRd1/hZavbwGDpqENic/StV9aj52Uy3YIY=;
 b=PNK305LnSo8xoTg2MIAGC+9EXsCF5+sioG0h0A0dfbPn7r3+7vjd1aBQ2l4UJPBjx1H7
 aQUP7DNZXwn0qoVg+DgEKI7MWXBq0NJe/iRqz9cv+tv2VfWQ+kNk1MmGMjG5mqCavQh1
 qStRB697kSDkrC6WKzfSQdKIDobedKzfb3g4xizNpZ4QeNvaPIm1s3JezgvasfjNTOGi
 3WZWB75Wh2GnrB9YPd0Nd3gYKVKZFZqlz5WHyI6oORMcISjrEvyzCaW8j+WUvdDYzQIt
 oFfg6T+4gY7QRaZ1goALsWGMXHcCbEZbYZInsFBENp/CgGAX7A2E3jJbHt1/9a7yrgi0 Eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7m7qvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 02:19:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09U2GXns068366;
        Fri, 30 Oct 2020 02:17:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34cwuqfmqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 02:17:23 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09U2HJAD016404;
        Fri, 30 Oct 2020 02:17:20 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 19:17:19 -0700
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 0/5] zfcp: cleanups, refactorings and features for 5.11
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8kkzcd7.fsf@ca-mkp.ca.oracle.com>
References: <cover.1603908167.git.bblock@linux.ibm.com>
Date:   Thu, 29 Oct 2020 22:17:16 -0400
In-Reply-To: <cover.1603908167.git.bblock@linux.ibm.com> (Benjamin Block's
        message of "Wed, 28 Oct 2020 19:30:47 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=901 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1011 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=931 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Benjamin,

> here is a series of changes for our zfcp driver for 5.11.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
