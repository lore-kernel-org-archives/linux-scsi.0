Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268F6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 03:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiGSDJJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 23:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbiGSDJH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 23:09:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19ECC252A2
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 20:09:07 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IL13te008482;
        Tue, 19 Jul 2022 03:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=yMYM/qpGAO+tEct8TrdJGb6qqwDlaot/ZGb3GdWCGT4=;
 b=FSzbUAS6mT4V84UmuHAWG/DYHDxiXO+uyLQWWj8gs+u4SRA55J0i174/Sqm9VyGDr1G/
 4lG+3GMg+TkdPx4B1eOYY5+GGA6vfFzok5zv7YpkRiFpIfkYW8RyXz1j/G9cxV5/qH4Q
 jtEEy7NvW45Z9lZ+HjpuhyleACAmf+xmr1Rc7OQnYKmmAfyAYodnCAV/7QJk9Eyp0wGY
 4gw9Zx7lC5yAXuMQTiTkNB51WRsMR0C5Lr6520kWzyMIAXqGRmJKmgKxBO7vvdNSJvb6
 rii4+N3w9ebKQsZopDGScXZUjXJrwAjfivD2+KLMLw15Ji7O7gTM8uflvBDYeAVPxAKS 0g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkrc4wub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 03:09:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26J0icb2001311;
        Tue, 19 Jul 2022 03:09:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2yptv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 03:09:04 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26J391U9016855;
        Tue, 19 Jul 2022 03:09:04 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3hc1k2ypt1-5;
        Tue, 19 Jul 2022 03:09:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH 00/10] qla2xxx bug fixes
Date:   Mon, 18 Jul 2022 23:08:58 -0400
Message-Id: <165820009735.29375.8892352149991049428.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713052045.10683-1-njavali@marvell.com>
References: <20220713052045.10683-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207190011
X-Proofpoint-GUID: VPS8A5-bMWvVSORbicSbbA_MgpYMkZJG
X-Proofpoint-ORIG-GUID: VPS8A5-bMWvVSORbicSbbA_MgpYMkZJG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Jul 2022 22:20:35 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver bug fixes to the scsi tree
> at your earliest convenience.
> 
> Thanks,
> Nilesh
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[01/10] Revert "scsi: qla2xxx: Fix disk failure to rediscover"
        https://git.kernel.org/mkp/scsi/c/5bc7b01c513a
[02/10] qla2xxx: Fix incorrect display of max frame size
        https://git.kernel.org/mkp/scsi/c/cf3b4fb65579
[03/10] qla2xxx: zero undefined mailbox IN registers
        https://git.kernel.org/mkp/scsi/c/6c96a3c7d495
[04/10] qla2xxx: Fix response queue handler reading stale packets
        https://git.kernel.org/mkp/scsi/c/b1f707146923
[05/10] qla2xxx: edif: Fix dropped IKE message
        https://git.kernel.org/mkp/scsi/c/c019cd656e71
[06/10] qla2xxx: Fix imbalance vha->vref_count
        https://git.kernel.org/mkp/scsi/c/63fa7f2644b4
[07/10] qla2xxx: Fix discovery issues in FC-AL topology
        https://git.kernel.org/mkp/scsi/c/47ccb113cead
[08/10] qla2xxx: fix sparse warning for dport_data
        https://git.kernel.org/mkp/scsi/c/166d74b876b7
[09/10] qla2xxx: update manufacturer details
        https://git.kernel.org/mkp/scsi/c/1ccad27716ec
[10/10] qla2xxx: Update version to 10.02.07.800-k
        https://git.kernel.org/mkp/scsi/c/6c20cc4885c5

-- 
Martin K. Petersen	Oracle Linux Engineering
