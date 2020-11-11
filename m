Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B40C388F7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 995A8216C4
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:59:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="y9dbq4/J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgKKC7S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 21:59:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50282 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgKKC7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 21:59:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2sgps159077;
        Wed, 11 Nov 2020 02:59:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DKG5ZCjPxEwe67zXNt0WJN+hblWtMpvZfC5iw1A3b5o=;
 b=y9dbq4/JMPgRPx8TG8rD7Bk5+fr6EsdqhS7zy847Ajd6bNFrjg+60xRTo+HG+ZLz0ALH
 W39z6oxxEdJ0OJPMo88fOfc1KyHgA52w8njLUSmCdSTDslttxwmFKTzAdmZyC5CC1t88
 jOXETtDu5APaaN797zqYQ+x0fcLjUsUJdT1/nFXu0FFKcdvxeExIlQBHbyZi6I9vPX8U
 9aBs/VBnfqCn7Ivf62jS3B6ege3cf4+4rKMRiuanitrOGfKyoTY3dttXnahvXjBeLsEm
 eKhK3iWfdouF15FN725zmsLvNKE6XVW+lUR4fO+anojDniqPme5wfd6zXsr3x5/+8wW2 Pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34nkhkxwrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 02:59:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2srRq153454;
        Wed, 11 Nov 2020 02:59:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34p5g15jqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 02:59:14 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB2xDAW024083;
        Wed, 11 Nov 2020 02:59:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 18:59:13 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v3 0/5] SAN Congestion Management (SCM) statistics
Date:   Tue, 10 Nov 2020 21:59:08 -0500
Message-Id: <160506354081.14637.12655667889411386799.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201021092715.22669-1-njavali@marvell.com>
References: <20201021092715.22669-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Oct 2020 02:27:10 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the attached patchset implementing the SAN Congestion
> Management (SCM) statistics to the scsi tree at your earliest
> convenience.
> 
> v2->v3:
> Incorporate review comments for patch v2 3/5.
> Added Reviewed-by tag for other patches.
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/5] scsi: fc: Update formal FPIN descriptor definitions
      https://git.kernel.org/mkp/scsi/c/874163aab75a
[2/5] scsi: fc: Add FPIN statistics to fc_host and fc_rport objects
      https://git.kernel.org/mkp/scsi/c/547aab51a914
[3/5] scsi: fc: Parse FPIN packets and update statistics
      https://git.kernel.org/mkp/scsi/c/3dcfe0de5a97
[4/5] scsi: fc: Add mechanism to update FPIN signal statistics
      https://git.kernel.org/mkp/scsi/c/846101960fdb
[5/5] scsi: fc: Update documentation of sysfs nodes for FPIN stats
      https://git.kernel.org/mkp/scsi/c/434ee4251950

-- 
Martin K. Petersen	Oracle Linux Engineering
