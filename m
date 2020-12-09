Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C17CC1B0D9
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED79223AA8
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732400AbgLIRYu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:24:50 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34270 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732239AbgLIRYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:24:40 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HJvni059051;
        Wed, 9 Dec 2020 17:23:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lLmlufi3oR5yqN4ZBrlnUwt1cfZzVxZ82k7wdyaBd5o=;
 b=y9f8dbgW3hNIYEkwyPVA437QdLP5RbwBqhfuCxxu6uJop4NtloBYJHdzCMRPIOl2UctH
 a0Zc5vz7VyfpSY5NFPnkBmtBrDfJuFoh0yVd1/PdEf3hqlqz59nlSARrJUXsNyq/c1L+
 OufHeS+QPnynB0dTFyzVvPWM/PqBwepcfprTqltc0pcfymTZzOS5xPkJlMn0JhWC+f7S
 k2U47j5Mwj85ZENCc1YJhfL/sjWTm7xAb80Z3J5P3bugI/w562LAZudcJmXg3JYfahxz
 W7C5DSozkM3okmbw2UL/Sfe8IYdQ44v8O0NTEbU7afrV7lPh7bS/bZxxRRdmbqRK7f+Y Uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 357yqc1fn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 17:23:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HKqjO100010;
        Wed, 9 Dec 2020 17:23:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 358ksqdjyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 17:23:53 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B9HNqwF022765;
        Wed, 9 Dec 2020 17:23:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 09:23:51 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, jt77.jang@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Adjust ufshcd_hold() during sending attribute requests
Date:   Wed,  9 Dec 2020 12:23:17 -0500
Message-Id: <160753457755.14816.13125271350264675830.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1606973132-5937-1-git-send-email-user@jang-Samsung-DeskTop-System>
References: <CGME20201203053818epcas1p2aef4dce58afcac06fb28354146254c8d@epcas1p2.samsung.com> <1606973132-5937-1-git-send-email-user@jang-Samsung-DeskTop-System>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=960 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=988
 clxscore=1011 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 3 Dec 2020 14:25:32 +0900, Jintae Jang wrote:

> Invalidation check of arguments should have been checked before
> ufshcd_hold(). It can help to prevent ufshcd_hold()/
> ufshcd_release() from being invoked unnecessarily.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: ufs: Adjust ufshcd_hold() during sending attribute requests
      https://git.kernel.org/mkp/scsi/c/8ca1a40b9f9d

-- 
Martin K. Petersen	Oracle Linux Engineering
