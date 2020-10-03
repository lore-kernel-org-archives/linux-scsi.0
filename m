Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0164DC4363C
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 03:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B2F8206E3
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 03:26:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FyLxfiqN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgJCD0j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 23:26:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53374 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgJCD0j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 23:26:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0933NhlE037956;
        Sat, 3 Oct 2020 03:26:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=VIdsnjZYpmJ3wu5mp0ICS8t+wG65dFFlzigUOjU/Vh8=;
 b=FyLxfiqNIGc1C3+D/PM8DwjRilZpHMJgqAr7I+EQYNrJ6ofaFfoVF5dJnyacJmuo9bxk
 vAkYMjp6C/NKhqoih1zfxJI3gU74WWAgz5bKgk64zGE3FYKfHkelW/RcHrXFG/5BqcIj
 VK/OydUYPJCMwH/vX9T8rPEkG/Xd6atQSmo33QN3Bc+HnQ/OQ8au8jNF7rJbPCn1eAaa
 vU8RUEIIyRjS6QmIBL0DCRlKGdmvZl2fR0UXVMZc2YhKrN4KDWRcRi1ZUNxC+PWQoKA8
 SkpilIlGbOYLHmiVVJzK+8ME470RqNrNFIs6tbKfqKEHvOsoBAtlHR2q2KUCF4vDbKK+ nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33xh8kg0a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 03 Oct 2020 03:26:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0933L1gn030901;
        Sat, 3 Oct 2020 03:26:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33xfb8k55r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Oct 2020 03:26:36 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0933QZmB004359;
        Sat, 3 Oct 2020 03:26:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 20:26:34 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v2 0/7] qla2xxx bug fixes
Date:   Fri,  2 Oct 2020 23:26:32 -0400
Message-Id: <160167976618.22934.6117382028042255227.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929102152.32278-1-njavali@marvell.com>
References: <20200929102152.32278-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 malwarescore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030029
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 29 Sep 2020 03:21:45 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx bug fixes to the scsi tree at
> your earliest convenience.
> 
> v1->v2:
> Added correct "Fixes:" and "Cc:" tags in commits
> Added Reviewed-by tag
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/7] scsi: qla2xxx: Correct the check for sscanf() return value
      https://git.kernel.org/mkp/scsi/c/7dc0f671d89c
[2/7] scsi: qla2xxx: Fix buffer-buffer credit extraction error
      https://git.kernel.org/mkp/scsi/c/44f5a37d1e3e
[3/7] scsi: qla2xxx: Fix MPI reset needed message
      https://git.kernel.org/mkp/scsi/c/7a6cdbd5e875
[4/7] scsi: qla2xxx: Fix reset of MPI firmware
      https://git.kernel.org/mkp/scsi/c/3e6efab865ac
[5/7] scsi: qla2xxx: Fix crash on session cleanup with unload
      https://git.kernel.org/mkp/scsi/c/50457dab670f
[6/7] scsi: qla2xxx: Fix point-to-point (N2N) device discovery issue
      https://git.kernel.org/mkp/scsi/c/94eda2717826
[7/7] scsi: qla2xxx: Update version to 10.02.00.103-k
      https://git.kernel.org/mkp/scsi/c/718c2fe92b20

-- 
Martin K. Petersen	Oracle Linux Engineering
