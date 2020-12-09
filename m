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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF6EC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 596C723B6B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732355AbgLIRYu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:24:50 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34332 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732263AbgLIRYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:24:40 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HJYaF058918;
        Wed, 9 Dec 2020 17:23:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iOUBTb56dZV3iUV/ROljyjbXyD3b2CkEHVJQ/aRc/8Y=;
 b=oRzwzEGQZFCk6ByyY+pGNf5qlVY+EmM4iAzYXb8lV9Uqycpos4SoMd0Qqf+/RKpzk0Tz
 KnTS3Cuy4UAYFarOvyQ4i3u0eIcMFgTWvT0dO5Ph2boITbbOvVHuYA3XI0HE2Kt6mnzc
 b2n+wm8Wtp+F1Hr356Xd3UDAJzCBx8hUl9rNPtRMi4UJQGaTge9K4aLMDY+w8fp/BSmn
 RmCKBTlg97EMpVgE5U2y/5cBnwlH044+cokZcKLBOJ8MBX1NdkayWkpqJt5o/IDTlj+N
 HRCGrcyhHMNX1auqC9WDRyfEtXskbjv1kYgW95iC01QW6/vzo57Zjd/hOHSpW/uIUOgP HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 357yqc1fnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 17:23:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HKiD2142157;
        Wed, 9 Dec 2020 17:23:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 358kyv0h41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 17:23:57 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B9HNumF023126;
        Wed, 9 Dec 2020 17:23:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 09:23:56 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v2 00/15] qla2xxx bug fixes
Date:   Wed,  9 Dec 2020 12:23:20 -0500
Message-Id: <160753457756.14816.14574388679317050616.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202132312.19966-1-njavali@marvell.com>
References: <20201202132312.19966-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2 Dec 2020 05:22:57 -0800, Nilesh Javali wrote:

> Martin,
> Please apply the qla2xxx bug fixes to the scsi tree at your
> earliest convenience.
> 
> v1=>v2:
> Incorporate review comments
> Add call trace details
> Add missing Fixes and stable tag
> Add Reviewed-by tag
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[01/15] scsi: qla2xxx: Return EBUSY on fcport deletion
        https://git.kernel.org/mkp/scsi/c/305c16ce2632
[02/15] qla2xxx: Change post del message from debug level to log level
        https://git.kernel.org/mkp/scsi/c/c1599657d48c
[03/15] qla2xxx: limit interrupt vectors to number of cpu
        https://git.kernel.org/mkp/scsi/c/a6dcfe08487e
[04/15] qla2xxx: tear down session if FW say its down
        https://git.kernel.org/mkp/scsi/c/e4fc78f48d3f
[05/15] qla2xxx: Don't check for fw_started while posting nvme command
        https://git.kernel.org/mkp/scsi/c/0ce8ab50a6ed
[06/15] qla2xxx: Fix compilation issue in PPC systems
        https://git.kernel.org/mkp/scsi/c/aceba54ba0f9
[07/15] qla2xxx: Fix crash during driver load on big endian machines
        https://git.kernel.org/mkp/scsi/c/8de309e7299a
[08/15] qla2xxx: Fix FW initialization error on big endian machines
        https://git.kernel.org/mkp/scsi/c/8a78dd6ed1af
[09/15] qla2xxx: fix N2N and NVME connect retry failure
        https://git.kernel.org/mkp/scsi/c/07a5f69248e3
[10/15] qla2xxx: Handle aborts correctly for port undergoing deletion
        https://git.kernel.org/mkp/scsi/c/f795f96e725b
[11/15] qla2xxx: Fix flash update in 28XX adapters on big endian machines
        https://git.kernel.org/mkp/scsi/c/0bc17251dff4
[12/15] qla2xxx: Fix the call trace for flush workqueue
        https://git.kernel.org/mkp/scsi/c/0a6f4d762c6b
[13/15] qla2xxx: If fcport is undergoing deletion return IO with retry
        https://git.kernel.org/mkp/scsi/c/707531bc2626
[14/15] qla2xxx: Fix device loss on 4G and older HBAs.
        https://git.kernel.org/mkp/scsi/c/abd9cae9bbae
[15/15] qla2xxx: Update version to 10.02.00.104-k
        https://git.kernel.org/mkp/scsi/c/afc516dcfe52

-- 
Martin K. Petersen	Oracle Linux Engineering
