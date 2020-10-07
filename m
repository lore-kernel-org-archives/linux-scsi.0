Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1F6C4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E854208C7
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:50:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YnWkeBDL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgJGDuh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:50:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgJGDug (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:50:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973iwaH045291;
        Wed, 7 Oct 2020 03:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/ts1uUAfqamVpoVl/NdC021SXpDDQ5rYyHqZB45up3M=;
 b=YnWkeBDLmkQ4wTHIRrFTx0EVRHQOIW6MEJDrPa/E29qUlgt8tg3azACwQX7KfcCjvkbV
 qAY5uGiQRQ6/9TinIbtKlI6dH4bdrO+Cf2N7ecL41BVR9xi0Ph+oWo3BeHSABAWDeWwP
 W6UYCkjoGHnqkfmnO7/JJQB7HuXu8Sp/kD4HI/PT46f8XfJXNcZC8+YuAlQbk2D9AAbH
 GE2w0sMFbsS5CTn6JT+uxC8Y8/ZeOVnz9q2AbDmpyCXO5pzbZrkS3ITJrMi2FYNBmgVl
 HA5901tX9x5oUG51xqbLO0OMxNXLz4PtI5y/3X4jebxGl6CvuI39NefaLoLlWRvJhHJ7 hg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33ym34mk3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:50:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973jI5Y054881;
        Wed, 7 Oct 2020 03:48:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33y2vnxxue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:27 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0973mRVT002436;
        Wed, 7 Oct 2020 03:48:27 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:26 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Ye Bin <yebin10@huawei.com>, sebaddel@cisco.com,
        satishkh@cisco.com, kartilak@cisco.com, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: fnic: Fix inconsistent of format with argument type in fnic_debugfs.c
Date:   Tue,  6 Oct 2020 23:48:04 -0400
Message-Id: <160204240576.16940.1125240849322272155.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930021919.2832860-2-yebin10@huawei.com>
References: <20200930021919.2832860-1-yebin10@huawei.com> <20200930021919.2832860-2-yebin10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 30 Sep 2020 10:19:19 +0800, Ye Bin wrote:

> fix follow warnings:
> [drivers/scsi/fnic/fnic_debugfs.c:123]: (warning) %u in format string (no. 1)
> 	requires 'unsigned int' but the argument type is 'int'.
> [drivers/scsi/fnic/fnic_debugfs.c:125]: (warning) %u in format string (no. 1)
> 	requires 'unsigned int' but the argument type is 'int'.
> [drivers/scsi/fnic/fnic_debugfs.c:127]: (warning) %u in format string (no. 1)
> 	requires 'unsigned int' but the argument type is 'int'.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: fnic: Fix inconsistent format argument type in fnic_debugfs.c
      https://git.kernel.org/mkp/scsi/c/1dfbed19455b

-- 
Martin K. Petersen	Oracle Linux Engineering
