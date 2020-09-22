Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2AAC4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9D2323A34
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:59:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KOsL0BuI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgIVD70 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:59:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33766 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgIVD70 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:59:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3wdXg060444;
        Tue, 22 Sep 2020 03:59:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=OmRPBChgEZQvcHEyNXmcsJ6IME16/kfUUBcmwZVLnS8=;
 b=KOsL0BuIDtTML84Do/HhJv1DnrGAm/ftBio5YP920VSw0g5UTtW7NUG8uEg87yI/B++7
 rBghNkpYiW77w+my6AtNcpo5iT43nwoyXECF+JbohiNwe0LK1fjbE/NnPa8Kt00wImXQ
 xBQE9bopmtP7PYhZsW/5ZjTTuqvhnLDSwWptI79/rasxZ3B62rGugP8VtgpnpmfwaGqz
 ArlSN+HxXErL4LVEKwvEm3tkRpvvXTIWdkDpBBFzzfJE4BTQssBnTmwSor64wpwMkn/W
 MC8j05TFCs9FeFNtrlgnMhUMRjsbI1YHtLe8xqCg2iNNd+yGmz4+Y9/f94djckcICH3p cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33ndnuagt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:59:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3uIc4149662;
        Tue, 22 Sep 2020 03:57:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33nujmm8pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:23 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vL1p032569;
        Tue, 22 Sep 2020 03:57:22 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:21 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com
Subject: Re: [PATCH v1] mpt3sas: Add support for Non-secure Aero and Sea PCI IDs
Date:   Mon, 21 Sep 2020 23:56:52 -0400
Message-Id: <160074695009.411.6943759401440342120.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200814130426.2741171-1-sreekanth.reddy@broadcom.com>
References: <20200814130426.2741171-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=821 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=835 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220031
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 14 Aug 2020 13:04:26 +0000, Sreekanth Reddy wrote:

> This patch will add support for Non-secure Aero & Sea adapters' PCI IDs.
> Driver will throw an warning message when a non-secure type controller
> is detected. Purpose of this interface is to avoid interacting with
> any firmware which is not secured/signed by Broadcom. Any tampering on
> Firmware component will be detected by hardware and it will be
> communicated to the driver to avoid any further interaction with
> that component.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Detect tampered Aero and Sea adapters
      https://git.kernel.org/mkp/scsi/c/f38c43a0e900

-- 
Martin K. Petersen	Oracle Linux Engineering
