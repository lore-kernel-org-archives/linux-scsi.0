Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30CAC433E8
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 22:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C91B82065F
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 22:14:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I2pdeThF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgGOWOw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 18:14:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47624 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOWOr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 18:14:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMD0R9130200;
        Wed, 15 Jul 2020 22:14:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=6ABihcnl9ArYEF+iR0+jb342UUR1x7boxOxZTCxrTBg=;
 b=I2pdeThFJuracK98fLqVL93UQN9Jh+806oaJAvkGnXDhDtfbxSpFfDGge3OAy+B1Is4O
 WoBmmnOtP1Z1muHaolmeGVwTy5pQn08IymSw1AXhlCIKCv2My6bYuDhaeMOjd+Zi+VKx
 32fAxA15l5LhDy0ULZpSd+6xA/vGcuHu/HOVc+8FUGNINrZiVrc05UFe1ClR5qmnJN7V
 FGd/eJW8uOTe/FQRhnUxdNzNhCnNBE/Vv6AQ9v0xsQMEQqIya37k2VC5I+r7+Sm16nWC
 5dyBLuvYw0/bE0+2KJfwXFLmjAfa5+Qc44KO7Brkysqh7uXGVe40LHfL2IoUvEvV1Tpo Rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3275cme19s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 22:14:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMDfxI152223;
        Wed, 15 Jul 2020 22:14:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 327q0s3mkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 22:14:44 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06FMEhmO001056;
        Wed, 15 Jul 2020 22:14:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 15:14:42 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v2] qla2xxx: Address a set of sparse warnings.
Date:   Wed, 15 Jul 2020 18:14:35 -0400
Message-Id: <159484884354.21107.3310997545783057055.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715043358.21668-1-njavali@marvell.com>
References: <20200715043358.21668-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=952 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=974 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Jul 2020 21:33:58 -0700, Nilesh Javali wrote:

> v1->v2:
> - Rebase on 5.9/scsi-queue
> 
> Fix sparse warnings,
> drivers/scsi/qla2xxx/qla_isr.c:881:23: warning: restricted __le16 degrades
> to integer
> drivers/scsi/qla2xxx/qla_isr.c:881:23: warning: cast to restricted __le16

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Address a set of sparse warnings
      https://git.kernel.org/mkp/scsi/c/58101f1504ad

-- 
Martin K. Petersen	Oracle Linux Engineering
