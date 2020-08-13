Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3219BC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 02:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B00F2053B
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 02:36:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sMGyL9+4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHMCgO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 22:36:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42762 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgHMCgO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 22:36:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07D2X1Wj133355;
        Thu, 13 Aug 2020 02:36:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=R9WFzAuAsxW++oF6tH10Aj+sh90QiCSFKrGSsIGZaoU=;
 b=sMGyL9+4NZtxChd8aiuoBwvMwBybaz5C58k2SWbZydl1dHqU5J3p8Y40CDw1j025f/7j
 x9PnPhZwvPQiUZ2ehIdcGG81yJPbm+uLrLA+n9f6O5KN+F5JZ9WJuc6biz/aRwRrktwa
 iw+YwTkA0WLRoQ1QWiDygyftGfQToHlSjGm7MUvLAxMH1FnBZeijztLUBrjLYZmV92VZ
 +xzzwCmedr7472ZQECXDUgQpN3GwdoaJK3h96LvBNLsHqBJXHqrhx1jXTO0r2eX6oiZ/
 7gaOlf7Mdz7HmkMoVVfinSicxqMlCkQrRwxigSuEeJdFXPEYY+v/A7A73b89VSnggQVl Qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32sm0mx1h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Aug 2020 02:36:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07D2Xanx039433;
        Thu, 13 Aug 2020 02:36:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32t5mr7sm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 02:36:11 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07D2aAgX013882;
        Thu, 13 Aug 2020 02:36:10 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Aug 2020 02:36:09 +0000
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com
Subject: Re: [PATCH 0/7] mpt3sas: Enhancements and bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2mji8kj.fsf@ca-mkp.ca.oracle.com>
References: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Date:   Wed, 12 Aug 2020 22:36:07 -0400
In-Reply-To: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Thu, 30 Jul 2020 13:33:42 +0530")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1011
 suspectscore=1 mlxlogscore=999 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130016
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Suganath,

> This patch set has below bug fixes and enhancements.

Applied to my staging tree. You'll get a formal merge message once 5.10
opens.

A few asks for the next submission:

 - Please revisit Documentation/process/submitting-patches.rst section 2
   about how to write commit messages.

 - Please don't include outbox driver files in the submitted patches.

 - Please build with C=1/W=1. Lots of warnings in this code.

-- 
Martin K. Petersen	Oracle Linux Engineering
