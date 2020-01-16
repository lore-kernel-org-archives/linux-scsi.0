Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35286C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 04:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0440B20748
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 04:23:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DaDbdCQv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730891AbgAPEXr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 23:23:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46310 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730174AbgAPEXr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2020 23:23:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G4Jirb161213;
        Thu, 16 Jan 2020 04:23:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=NdlaRoWW7uPd+bM98H+c1w744NsXBMWiNemF5UKKDA0=;
 b=DaDbdCQvSUbi2fDIL+713Vdfi3zQRnyBkPgmXlosUhsWDz4kIStCi0v4W6bhmp370twc
 KMqkaNTshSHUM4NMrFv4hHMklJj5iXxMx0Hb+O5uasM74XHISOO+xdF85c6qRK37Mlth
 zezBiR0adUkMvaRvq7Mkp7xk4tx7Z92yE8fp3GYXJP2nvE4Mj6Sae8r3cL1ZQf3IZ8jW
 3ws9cGZBukp/7K05Vrg5g1TDLDUNFce5FifEEHXYQ0hmKXOJGAqxrNlaa/LTQEWUY55U
 xEbPkZq9CxZtIPJCKOnGfS13zTOAo6D8+L/e8tGPz9iIyy+lgY2FSsRt+r6YewOITmpk tQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74sg33v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 04:23:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G4JSwQ096626;
        Thu, 16 Jan 2020 04:21:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xj1at0vks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 04:21:42 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G4Lej6009922;
        Thu, 16 Jan 2020 04:21:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 20:21:40 -0800
To:     Anand Lodnoor <anand.lodnoor@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, kiran-kumar.kasturi@broadcom.com,
        sankar.patra@broadcom.com, sasikumar.pc@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com
Subject: Re: [PATCH v2 00/11] megaraid_sas: driver updates to 07.713.01.00-rc1
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
Date:   Wed, 15 Jan 2020 23:21:37 -0500
In-Reply-To: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
        (Anand Lodnoor's message of "Tue, 14 Jan 2020 16:51:11 +0530")
Message-ID: <yq1zheom3ou.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=806
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=866 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160034
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Anand,

> This patchset contains few enhancements and fixes in megaraid_sas driver.
>
> v2:
>     - Fixed couple of typos and indentation issues as pointed out by Martin K.
>     - Added proper commit descriptions where ever necessary.

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
