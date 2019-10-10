Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653A1C10F14
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 03:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C4FD20B7C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 03:29:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LMgUmOwb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfJJD3R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 23:29:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46528 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfJJD3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2019 23:29:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A38tIk108239;
        Thu, 10 Oct 2019 03:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=2bMiyWLf2q1A7RihKsVGMJG4+omBJQQ5Zi2Zpii0Pyk=;
 b=LMgUmOwbDB7jUYIEioa6b6wB1Ioq90xJNTIOeQZssd4WfpzZIGI0s/wLsVNtETbjNude
 XYR7/I1ZlD4CMPRWn9v/QrWtnotfu+9s0uYQruO2K+6xdBgZrJ/5mSBxteOLJg3tJXWm
 Y75VF3aZ2a5GHOv+exjWFP2kxZmcFmybV+Dt59DBxj1tn/95r0ZT/RgaSiK6sYt3Ek7c
 3P5kL80TgLv59n/DnvMl24YhqKdMGZYxCfVkZ0zjSNCINK8az/owfJrq0KnuxLk5HS7I
 bIhsjeL10etqQ3cZM/teaMpIYz2xPXwzVKgwwJmJHqtYnCYGNeQFw6WVP91HBUrvUuRG Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vejkurcwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 03:29:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A3T4EZ109669;
        Thu, 10 Oct 2019 03:29:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vh8k201gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 03:29:12 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9A3SXOi006631;
        Thu, 10 Oct 2019 03:28:33 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Oct 2019 03:28:32 +0000
To:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com, kiran-kumar.kasturi@broadcom.com,
        sankar.patra@broadcom.com, sasikumar.pc@broadcom.com
Subject: Re: [PATCH v2] megaraid_sas: unique names for MSIx vectors
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191007051828.12294-1-chandrakanth.patil@broadcom.com>
Date:   Wed, 09 Oct 2019 23:28:30 -0400
In-Reply-To: <20191007051828.12294-1-chandrakanth.patil@broadcom.com>
        (Chandrakanth Patil's message of "Mon, 7 Oct 2019 10:48:28 +0530")
Message-ID: <yq1pnj5i8ip.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=18 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=803
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=18 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=885 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910100030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chandrakanth,

> Currently, MSIx vectors name appears in /proc/interrupts is "megasas"
> which is same for all the vectors. This patch provides the unique
> name to all megaraid_sas controllers and its associated MSIx interrupts.
>
> Suggested-by: Konstantin Shalygin <k0ste@k0ste.ru>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

Next time, please make sure you put a "---" separator before the patch
changelog.

> v2:

[...]

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
