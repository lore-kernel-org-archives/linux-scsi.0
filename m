Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC3BDFA3743
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbiJZXZq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbiJZXYy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:24:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3627DF46;
        Wed, 26 Oct 2022 16:22:30 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QMKDZf015054;
        Wed, 26 Oct 2022 23:20:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=TY1nvsvB0NjQd9Iashmui+MY80tRHLI6W93lbn90daM=;
 b=p3Eaz3nR9GkHxSL3AQIyZeAaK19qK4PFmS2n1LZ/SrhHO1Rh3SOFd63Y5nvFw1hf8XiO
 ow3ENpadmHu7Y4lEgN3OSRcXy/6QQDXCb0RLmH9LMf/k+kp5mPstsCQJXheeWIWYAaSc
 u8d18nPEBIil8S/KYsJltjbHUj5kDosB9f3Vv8M1Ft+vfu97VkA3fycwd6X5FmAsZtui
 CJKZMmXJlhmlCUF9wde05Baq7D/K+flS32ztktqer5rSIC7iuRXAFOYyXSm9XqOq7KBt
 XrR5elqb1Y79Xg6t+hvu+auv7lJGPzGODR3NhEKl+DU0rn7lZjXd3gE5unGeLEW1UjdG RA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfb0aghxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM1s5U026539;
        Wed, 26 Oct 2022 23:20:09 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagpdx95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q433YF1xdJ5NK4qRUDPaBiWE6KbUtmzWW0LbBONlxFNypdIGI+QwJbelEJRusgd7HxZ42Vsk4Nv5FK66PRYL7hW4ytbpwnd2f+GYdISMQOB7AOGCL9CChvuTCoYWqqd9l2lLOA4DNFWMsVo15WKbLhHke32mmWAxDmUq6haMBDs23wyBKAMZOAclbHcir1acCpTYGjgCvBNPUUCJOjCOeOT8k4TspAMmR6A3rfZkdq4eIDt54hgdkUEppZqJp5PPlnYeDY0M9gZlbx2MicCBug4V76OeM7Mcf+GWZnr53t0RHEocfpkNfQUfxw1zbhAGjeJ8rMuIZxM66R+kT2FCfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TY1nvsvB0NjQd9Iashmui+MY80tRHLI6W93lbn90daM=;
 b=SrI+x48oJxt9hCJrRY8bXDOZVAzKrXUwps0vXD/Okq/sm73GL/p8LmOaXrDpscJi3gZ0ArUxVoBwp27zy3nSk38jJHE4EP+AmtMXSXuJbEDiRlHwerwIgMIIrFKh5EBQeD4PaDe1DorJLaGHJBCSrAayfKRnd1jFfciHl2C+wPuL6NHiGnF3KO39zxFhhZEjON6VJfOPnN0+3bc27MA9bHZaC1kb5UInmDfGkDDxrvvoqDcLOYKXlUbwvdVRLhmaKqdjmrXDmJZ6LkNMzxtyL0QkXogPM1wXOSaCagSSAfkooaNUeb1KahB5pfOjUcF5bOyyEcf+/YHvIJbPw347Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TY1nvsvB0NjQd9Iashmui+MY80tRHLI6W93lbn90daM=;
 b=u3ZPmiY1JpdZuvixLg8R5l1BxNvEzJJPA5p2kqLT8VHJYHrmDUygzXxd39i/4XyZb6lzZ9z5WKsxbSBeRea6nRDaT4lF+wku/uKozhQ4eYPi9VFElMIE4GGbvkyAYUqhjDEue9x4BohIJweMMRj1ANLdH9UKrOYQoRhSCTJ3kCk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:20:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:20:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 12/19] block,nvme,scsi,dm: Add blk_status to pr_ops callouts
Date:   Wed, 26 Oct 2022 18:19:38 -0500
Message-Id: <20221026231945.6609-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0026.namprd19.prod.outlook.com
 (2603:10b6:610:4d::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: b7b371d4-0b17-40ec-46f8-08dab7a89e22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iu3gqvnbLEwRdGTEY6RB8BdQCKdmn9xZsl6um+dPMdc6bfGvy8WZzV3ViZ+WyO3snEhvitAG6APJRaBAcyNLnYWDDM2H4dcoZdYq1VuX7V4OXGpuP01urankl0fRtJNkpwD6XtZBhCCYQ2EmGRMMduik/T5aPbdfbqveD+n5zleqXjmWdcG3VIptVM4Cq4vPR58Yk/641tdWoRLMH312OdpLSSYhPRNjM39uC523EuIFuo9tTjCZ+lIBHESj88BfE/3VN/UdfVfSZSSFdwERIgEiGRupwrDYxb90xOjDKXkge9I9hzCN9t0CEfj460NantRakGreZQUbubr/RpWDnWiwHu834pEs5r0/cj2qoBashgBpWLN56niwz/N5jEi1YQt5aybVtbdx44rod0F9eIJczcvs0QP1Oqs9RJUq00Y97qRiiRYKaE3LWG2g7OTaR1ASlhfpDefOxCtShah248DKLFBH2tCR/E7qBRQMZXL5jvs2BOgxVj3GZXcoN26euxw9x3fULubwFzDVOc16yGSVeIBwE0UQSJcTb9jAMd/npL5uF/jzEqByANLfUJqrYKYP5NiE00saq37kcKkDIjzCAGhOI0mjs+zsm7g34nKeCLSSRroW68mnXk7rZlko+uFgugG9qrA3zg1R8zdbbJELbyAYDOSn+yJQ+h9mk8fxolpaW48vkS5EiJ1oPHqBekEbCKq4n1zPcx5ioAqyAu4GtYpYQfJFxNWoVTir+KoWBYJ6I7nPNDZOBHU+34ea
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(30864003)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oUID72DVmc1CD56vWSlRIVy49n9r7oj6oQ4Q8d8OQNk/IyZ072w5ZFiR+2aO?=
 =?us-ascii?Q?f0Qgv6og3RTwnzg5+Vw0hqZj6Nv/4oLhiZPPPVZ5CcPYwCJvOp+gll8eQv6j?=
 =?us-ascii?Q?TRIgIO4GqaYtAnqrieXBnngKP3ZaDmV3Hh/CD75+yq5l1GiQqu8poPn7On5d?=
 =?us-ascii?Q?86nADMOYWh3Y7dzJLf556f5YPqflPFajn0Twjj4UMJ5TJYOJS32woDpcZEeK?=
 =?us-ascii?Q?9ZfirgpKpQeFEmd1u0AAd30Z+nKWzaUZmx3PUtFKgch9GvcTFMdaNp13fh0M?=
 =?us-ascii?Q?kp/Yn9BM2mDvflpaQFVYe9hz5bVVvEFR2k35lwq5GMJ8scx/8iVkbSN6mADi?=
 =?us-ascii?Q?+XgOSSgp5r/rHSZzGgieEr9bJ9cCKCa6tXiiIVPLzn2o1IWIrFu/493D7cZs?=
 =?us-ascii?Q?N2CuGtARxYi6qlETX2F8u/Be6MEsu0YJd+TtAUj9y9xsEqnnEoZ/LOSKECX+?=
 =?us-ascii?Q?J85UesszMRLgiJcxsSi/+Sso5Gk/mNSzf4QiCmgczTA1VkWrQyM8nq+bmhu9?=
 =?us-ascii?Q?RG+7k3AGQ+wsEK7Ip931FYbCqh6mlbQ32ZbRxmPQLVZs5YaWv5ejoiP08Ob6?=
 =?us-ascii?Q?QrbpfuxIFsw0sNdRNUXP1rBOUPnOfztUv7jKFbX4GFgVkOoUYgq9lCh4bFmN?=
 =?us-ascii?Q?pGXRdOklz7IH6DeOoQ9en4U1nn4DB90wpqRS9TTU9AIoDjgP3nrQ0a5goonV?=
 =?us-ascii?Q?9tiDJnYHhsJ7avZmZHMC23eiIHpjzwzfMuYwC6gwXNfAi4nZ4eqc6aJnLNNS?=
 =?us-ascii?Q?utQm+PNtZOW9Ypmqawc9/v0KIiBA7ppO8pcUpWjJlcsmQfdG4QJPqMg4y42X?=
 =?us-ascii?Q?vIXhC4BQlE78yV1DIpjewA5BPUONG5B1rHlH21NxFSLg5ozNCF4fryGV4W0a?=
 =?us-ascii?Q?YP+ho0cZG43KUQnJoRpkwnk7P+I6VmI0D6y+YaKYEGh8kHfqGa7BkZdXNe99?=
 =?us-ascii?Q?KFxjJdI2y+eplPxdmXZMLX3Jhbo9+oPRGdmhT/+tbPWup1MPTUAFQ2awPcvg?=
 =?us-ascii?Q?wvkPqGTq3i84Hpe/c+wTRqWupj52l0RBRTGf423wswy2PBDLU2Yk80/z/idC?=
 =?us-ascii?Q?oyv/E0qV4maCSQAzYeyeDCRppYTJljt1ghUsgdBnbBG8VNSFv1doB64SoDbz?=
 =?us-ascii?Q?hiIq4xMOOkkN3iZTnIKELlK4FCmya9fQejfjPVyMUOp66GGhbwN/sIm/eRyT?=
 =?us-ascii?Q?ZJqYV/0FYPmUr9ZCWXOkBrRQEiwpiGVxbUjKgWJjFS5g1EpP4QazdMgTgMLh?=
 =?us-ascii?Q?WfFvAO5fddLX5t52/O1jiHc3kQ1I+GEPf0jWrrey6vGgow/K3ZdtiR1PGmFp?=
 =?us-ascii?Q?ce7nT1eY/gE/W0qd/X2sVrZEAgEJr2pL0MnHvUzUMe2TSIHbMvCnMaWV20pR?=
 =?us-ascii?Q?DFQSmpPVbK5aSEeUsfNQunvFVway5j1RS+UTbWIxY2uV+QJsR0FLvw+muHP8?=
 =?us-ascii?Q?4EZPcSD74NkhOZy4v46l+TO4+KK9pSEYxAuikew3LeB9N8TE6EZRnThokTmL?=
 =?us-ascii?Q?kvJW85B93nM+Wy5N7Q+PWiSi1C37izcgZyaiN25xIY2i5K0Ilp4KkM2woKUi?=
 =?us-ascii?Q?3oTEOgObv7zsWGz7ngfNNDEbIyjXIGBmsf+0Nhftev/LZ0FL0aNUy78aL9TP?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b371d4-0b17-40ec-46f8-08dab7a89e22
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:20:06.3344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3j8XZSFuwIApxp9tqxGCbBvpLIREzxUGjgpNTAHiZLrD9NFvdSRBTccr3Ko/oDhrF4eG1KWiHX78gedsMfPs8q88EFeBSACOZ4qLAvc4k48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210260128
X-Proofpoint-GUID: 3NAig-d6zaQuHtzmppgHK4h3AGK9U7W5
X-Proofpoint-ORIG-GUID: 3NAig-d6zaQuHtzmppgHK4h3AGK9U7W5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LIO needs to be able to know if a failure was the result of a reservation
conflict and then be able to convert from the lower level's definition of
that error to SCSI so it can be returned to the initiator. Windows
clustering and test tools like libiscsi require this.

dm-multipath would also like to be able to distiguish between path
failures and reservation conflict so they can optimize their error
handlers for their pr_ops.

To do this they currently have to know the lower level device type and how
to convert between that driver's error code and SCSI. Just knowing the
device type is difficult because we can have layers like dm-multipath
between us and dm-multipath only knows the layer below it is a block
device.

To handle both cases and keep userspace compatibility, this patch adds a
blk_status_t arg to the pr_ops callouts. The lower levels will convert
their device specific error to the blk_status_t then the upper levels
can easily check that code without knowing the device type. Adding the
extra return value will then allow us to not break userspace which expects
a negative -Exyz error code if the command fails before it's sent to the
device or a device/driver specific value if the error is > 0.

This patch just wires in the blk_status_t to the pr_ops callouts. The
next patches will then have the drivers pass up a blk_status_t.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 block/ioctl.c            | 11 ++++++-----
 drivers/md/dm.c          | 41 +++++++++++++++++++++++++---------------
 drivers/nvme/host/pr.c   | 16 +++++++++-------
 drivers/scsi/sd.c        | 21 +++++++++++---------
 fs/nfs/blocklayout/dev.c |  4 ++--
 fs/nfsd/blocklayout.c    |  6 +++---
 include/linux/pr.h       | 17 ++++++++++-------
 7 files changed, 68 insertions(+), 48 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 60121e89052b..72338c56e235 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -269,7 +269,8 @@ static int blkdev_pr_register(struct block_device *bdev,
 
 	if (reg.flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
-	return ops->pr_register(bdev, reg.old_key, reg.new_key, reg.flags);
+	return ops->pr_register(bdev, reg.old_key, reg.new_key, reg.flags,
+				NULL);
 }
 
 static int blkdev_pr_reserve(struct block_device *bdev,
@@ -287,7 +288,7 @@ static int blkdev_pr_reserve(struct block_device *bdev,
 
 	if (rsv.flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
-	return ops->pr_reserve(bdev, rsv.key, rsv.type, rsv.flags);
+	return ops->pr_reserve(bdev, rsv.key, rsv.type, rsv.flags, NULL);
 }
 
 static int blkdev_pr_release(struct block_device *bdev,
@@ -305,7 +306,7 @@ static int blkdev_pr_release(struct block_device *bdev,
 
 	if (rsv.flags)
 		return -EOPNOTSUPP;
-	return ops->pr_release(bdev, rsv.key, rsv.type);
+	return ops->pr_release(bdev, rsv.key, rsv.type, NULL);
 }
 
 static int blkdev_pr_preempt(struct block_device *bdev,
@@ -323,7 +324,7 @@ static int blkdev_pr_preempt(struct block_device *bdev,
 
 	if (p.flags)
 		return -EOPNOTSUPP;
-	return ops->pr_preempt(bdev, p.old_key, p.new_key, p.type, abort);
+	return ops->pr_preempt(bdev, p.old_key, p.new_key, p.type, abort, NULL);
 }
 
 static int blkdev_pr_clear(struct block_device *bdev,
@@ -341,7 +342,7 @@ static int blkdev_pr_clear(struct block_device *bdev,
 
 	if (c.flags)
 		return -EOPNOTSUPP;
-	return ops->pr_clear(bdev, c.key);
+	return ops->pr_clear(bdev, c.key, NULL);
 }
 
 static int blkdev_flushbuf(struct block_device *bdev, fmode_t mode,
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f7f806890c92..7e77c836a61a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3079,7 +3079,8 @@ struct dm_pr {
 	bool	abort;
 	bool	fail_early;
 	int	ret;
-	enum pr_type type;
+	enum pr_type	type;
+	blk_status_t	*blk_stat;
 };
 
 static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
@@ -3130,7 +3131,8 @@ static int __dm_pr_register(struct dm_target *ti, struct dm_dev *dev,
 		return -1;
 	}
 
-	ret = ops->pr_register(dev->bdev, pr->old_key, pr->new_key, pr->flags);
+	ret = ops->pr_register(dev->bdev, pr->old_key, pr->new_key, pr->flags,
+			       pr->blk_stat);
 	if (!ret)
 		return 0;
 
@@ -3144,7 +3146,7 @@ static int __dm_pr_register(struct dm_target *ti, struct dm_dev *dev,
 }
 
 static int dm_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
-			  u32 flags)
+			  u32 flags, blk_status_t *blk_stat)
 {
 	struct dm_pr pr = {
 		.old_key	= old_key,
@@ -3152,6 +3154,7 @@ static int dm_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 		.flags		= flags,
 		.fail_early	= true,
 		.ret		= 0,
+		.blk_stat	= blk_stat,
 	};
 	int ret;
 
@@ -3189,7 +3192,8 @@ static int __dm_pr_reserve(struct dm_target *ti, struct dm_dev *dev,
 		return -1;
 	}
 
-	pr->ret = ops->pr_reserve(dev->bdev, pr->old_key, pr->type, pr->flags);
+	pr->ret = ops->pr_reserve(dev->bdev, pr->old_key, pr->type, pr->flags,
+				  pr->blk_stat);
 	if (!pr->ret)
 		return -1;
 
@@ -3197,7 +3201,7 @@ static int __dm_pr_reserve(struct dm_target *ti, struct dm_dev *dev,
 }
 
 static int dm_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
-			 u32 flags)
+			 u32 flags, blk_status_t *blk_stat)
 {
 	struct dm_pr pr = {
 		.old_key	= key,
@@ -3205,6 +3209,7 @@ static int dm_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 		.type		= type,
 		.fail_early	= false,
 		.ret		= 0,
+		.blk_stat	= blk_stat,
 	};
 	int ret;
 
@@ -3232,19 +3237,22 @@ static int __dm_pr_release(struct dm_target *ti, struct dm_dev *dev,
 		return -1;
 	}
 
-	pr->ret = ops->pr_release(dev->bdev, pr->old_key, pr->type);
+	pr->ret = ops->pr_release(dev->bdev, pr->old_key, pr->type,
+				  pr->blk_stat);
 	if (pr->ret)
 		return -1;
 
 	return 0;
 }
 
-static int dm_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
+static int dm_pr_release(struct block_device *bdev, u64 key, enum pr_type type,
+			 blk_status_t *blk_stat)
 {
 	struct dm_pr pr = {
 		.old_key	= key,
 		.type		= type,
 		.fail_early	= false,
+		.blk_stat	= blk_stat,
 	};
 	int ret;
 
@@ -3267,7 +3275,7 @@ static int __dm_pr_preempt(struct dm_target *ti, struct dm_dev *dev,
 	}
 
 	pr->ret = ops->pr_preempt(dev->bdev, pr->old_key, pr->new_key, pr->type,
-				  pr->abort);
+				  pr->abort, pr->blk_stat);
 	if (!pr->ret)
 		return -1;
 
@@ -3275,13 +3283,14 @@ static int __dm_pr_preempt(struct dm_target *ti, struct dm_dev *dev,
 }
 
 static int dm_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
-			 enum pr_type type, bool abort)
+			 enum pr_type type, bool abort, blk_status_t *blk_stat)
 {
 	struct dm_pr pr = {
 		.new_key	= new_key,
 		.old_key	= old_key,
 		.type		= type,
 		.fail_early	= false,
+		.blk_stat	= blk_stat,
 	};
 	int ret;
 
@@ -3292,7 +3301,8 @@ static int dm_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 	return pr.ret;
 }
 
-static int dm_pr_clear(struct block_device *bdev, u64 key)
+static int dm_pr_clear(struct block_device *bdev, u64 key,
+		       blk_status_t *blk_stat)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
 	const struct pr_ops *ops;
@@ -3304,7 +3314,7 @@ static int dm_pr_clear(struct block_device *bdev, u64 key)
 
 	ops = bdev->bd_disk->fops->pr_ops;
 	if (ops && ops->pr_clear)
-		r = ops->pr_clear(bdev, key);
+		r = ops->pr_clear(bdev, key, blk_stat);
 	else
 		r = -EOPNOTSUPP;
 out:
@@ -3313,7 +3323,7 @@ static int dm_pr_clear(struct block_device *bdev, u64 key)
 }
 
 static int dm_pr_read_keys(struct block_device *bdev, struct pr_keys *keys,
-			   u32 keys_len)
+			   u32 keys_len, blk_status_t *blk_stat)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
 	const struct pr_ops *ops;
@@ -3325,7 +3335,7 @@ static int dm_pr_read_keys(struct block_device *bdev, struct pr_keys *keys,
 
 	ops = bdev->bd_disk->fops->pr_ops;
 	if (ops && ops->pr_read_keys)
-		r = ops->pr_read_keys(bdev, keys, keys_len);
+		r = ops->pr_read_keys(bdev, keys, keys_len, blk_stat);
 	else
 		r = -EOPNOTSUPP;
 out:
@@ -3334,7 +3344,8 @@ static int dm_pr_read_keys(struct block_device *bdev, struct pr_keys *keys,
 }
 
 static int dm_pr_read_reservation(struct block_device *bdev,
-				  struct pr_held_reservation *rsv)
+				  struct pr_held_reservation *rsv,
+				  blk_status_t *blk_stat)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
 	const struct pr_ops *ops;
@@ -3346,7 +3357,7 @@ static int dm_pr_read_reservation(struct block_device *bdev,
 
 	ops = bdev->bd_disk->fops->pr_ops;
 	if (ops && ops->pr_read_reservation)
-		r = ops->pr_read_reservation(bdev, rsv);
+		r = ops->pr_read_reservation(bdev, rsv, blk_stat);
 	else
 		r = -EOPNOTSUPP;
 out:
diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 87a0aaf811f4..854a26ce55fe 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -86,7 +86,7 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 }
 
 static int nvme_pr_register(struct block_device *bdev, u64 old,
-		u64 new, unsigned flags)
+		u64 new, unsigned flags, blk_status_t *blk_stat)
 {
 	u32 cdw10;
 
@@ -100,7 +100,7 @@ static int nvme_pr_register(struct block_device *bdev, u64 old,
 }
 
 static int nvme_pr_reserve(struct block_device *bdev, u64 key,
-		enum pr_type type, unsigned flags)
+		enum pr_type type, unsigned flags, blk_status_t *blk_stat)
 {
 	u32 cdw10;
 
@@ -113,21 +113,23 @@ static int nvme_pr_reserve(struct block_device *bdev, u64 key,
 }
 
 static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
-		enum pr_type type, bool abort)
+		enum pr_type type, bool abort, blk_status_t *blk_stat)
 {
 	u32 cdw10 = nvme_pr_type_from_blk(type) << 8 | (abort ? 2 : 1);
 
 	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
 }
 
-static int nvme_pr_clear(struct block_device *bdev, u64 key)
+static int nvme_pr_clear(struct block_device *bdev, u64 key,
+		blk_status_t *blk_stat)
 {
 	u32 cdw10 = 1 | (key ? 0 : 1 << 3);
 
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
 
-static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
+static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type,
+		blk_status_t *blk_stat)
 {
 	u32 cdw10 = nvme_pr_type_from_blk(type) << 8 | (key ? 0 : 1 << 3);
 
@@ -163,7 +165,7 @@ static int nvme_pr_resv_report(struct block_device *bdev, u8 *data,
 }
 
 static int nvme_pr_read_keys(struct block_device *bdev,
-		struct pr_keys *keys_info, u32 keys_len)
+		struct pr_keys *keys_info, u32 keys_len, blk_status_t *blk_stat)
 {
 	struct nvme_reservation_status *status;
 	u32 data_len, num_ret_keys;
@@ -207,7 +209,7 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 }
 
 static int nvme_pr_read_reservation(struct block_device *bdev,
-		struct pr_held_reservation *resv)
+		struct pr_held_reservation *resv, blk_status_t *blk_stat)
 {
 	struct nvme_reservation_status tmp_status, *status;
 	int ret, i, num_regs;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 86b602399000..8a39f25e4470 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1736,7 +1736,7 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 }
 
 static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info,
-			   u32 keys_len)
+			   u32 keys_len, blk_status_t *blk_stat)
 {
 	int result, i, data_offset, num_copy_keys;
 	int data_len = keys_len + 8;
@@ -1767,7 +1767,8 @@ static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info,
 }
 
 static int sd_pr_read_reservation(struct block_device *bdev,
-				  struct pr_held_reservation *rsv)
+				  struct pr_held_reservation *rsv,
+				  blk_status_t *blk_stat)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1797,8 +1798,8 @@ static int sd_pr_read_reservation(struct block_device *bdev,
 	return 0;
 }
 
-static int sd_pr_out_command(struct block_device *bdev, u8 sa,
-		u64 key, u64 sa_key, enum scsi_pr_type type, u8 flags)
+static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
+		u64 sa_key, enum scsi_pr_type type, u8 flags)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1847,7 +1848,7 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 }
 
 static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
-		u32 flags)
+		u32 flags, blk_status_t *blk_stat)
 {
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
@@ -1857,7 +1858,7 @@ static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 }
 
 static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
-		u32 flags)
+		u32 flags, blk_status_t *blk_stat)
 {
 	if (flags)
 		return -EOPNOTSUPP;
@@ -1865,20 +1866,22 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 				 block_pr_type_to_scsi(type), 0);
 }
 
-static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
+static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type,
+		blk_status_t *blk_stat)
 {
 	return sd_pr_out_command(bdev, 0x02, key, 0,
 				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
-		enum pr_type type, bool abort)
+		enum pr_type type, bool abort, blk_status_t *blk_stat)
 {
 	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
 				 block_pr_type_to_scsi(type), 0);
 }
 
-static int sd_pr_clear(struct block_device *bdev, u64 key)
+static int sd_pr_clear(struct block_device *bdev, u64 key,
+		blk_status_t *blk_stat)
 {
 	return sd_pr_out_command(bdev, 0x03, key, 0, 0, 0);
 }
diff --git a/fs/nfs/blocklayout/dev.c b/fs/nfs/blocklayout/dev.c
index fea5f8821da5..516436446f5d 100644
--- a/fs/nfs/blocklayout/dev.c
+++ b/fs/nfs/blocklayout/dev.c
@@ -29,7 +29,7 @@ bl_free_device(struct pnfs_block_dev *dev)
 			int error;
 
 			error = ops->pr_register(dev->bdev, dev->pr_key, 0,
-				false);
+				false, NULL);
 			if (error)
 				pr_err("failed to unregister PR key.\n");
 		}
@@ -362,7 +362,7 @@ bl_parse_scsi(struct nfs_server *server, struct pnfs_block_dev *d,
 		goto out_blkdev_put;
 	}
 
-	error = ops->pr_register(d->bdev, 0, d->pr_key, true);
+	error = ops->pr_register(d->bdev, 0, d->pr_key, true, NULL);
 	if (error) {
 		pr_err("pNFS: failed to register key for block device %s.",
 				d->bdev->bd_disk->disk_name);
diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index b6d01d51a746..a302ea026f72 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -277,7 +277,7 @@ nfsd4_block_get_device_info_scsi(struct super_block *sb,
 		goto out_free_dev;
 	}
 
-	ret = ops->pr_register(sb->s_bdev, 0, NFSD_MDS_PR_KEY, true);
+	ret = ops->pr_register(sb->s_bdev, 0, NFSD_MDS_PR_KEY, true, NULL);
 	if (ret) {
 		pr_err("pNFS: failed to register key for device %s.\n",
 			sb->s_id);
@@ -285,7 +285,7 @@ nfsd4_block_get_device_info_scsi(struct super_block *sb,
 	}
 
 	ret = ops->pr_reserve(sb->s_bdev, NFSD_MDS_PR_KEY,
-			PR_EXCLUSIVE_ACCESS_REG_ONLY, 0);
+			PR_EXCLUSIVE_ACCESS_REG_ONLY, 0, NULL);
 	if (ret) {
 		pr_err("pNFS: failed to reserve device %s.\n",
 			sb->s_id);
@@ -331,7 +331,7 @@ nfsd4_scsi_fence_client(struct nfs4_layout_stateid *ls)
 	struct block_device *bdev = ls->ls_file->nf_file->f_path.mnt->mnt_sb->s_bdev;
 
 	bdev->bd_disk->fops->pr_ops->pr_preempt(bdev, NFSD_MDS_PR_KEY,
-			nfsd4_scsi_pr_key(clp), 0, true);
+			nfsd4_scsi_pr_key(clp), 0, true, NULL);
 }
 
 const struct nfsd4_layout_ops scsi_layout_ops = {
diff --git a/include/linux/pr.h b/include/linux/pr.h
index 55c9ab7a202b..954544200a57 100644
--- a/include/linux/pr.h
+++ b/include/linux/pr.h
@@ -18,14 +18,15 @@ struct pr_held_reservation {
 
 struct pr_ops {
 	int (*pr_register)(struct block_device *bdev, u64 old_key, u64 new_key,
-			u32 flags);
+			u32 flags, blk_status_t *blk_stat);
 	int (*pr_reserve)(struct block_device *bdev, u64 key,
-			enum pr_type type, u32 flags);
+			enum pr_type type, u32 flags, blk_status_t *blk_stat);
 	int (*pr_release)(struct block_device *bdev, u64 key,
-			enum pr_type type);
+			enum pr_type type, blk_status_t *blk_stat);
 	int (*pr_preempt)(struct block_device *bdev, u64 old_key, u64 new_key,
-			enum pr_type type, bool abort);
-	int (*pr_clear)(struct block_device *bdev, u64 key);
+			enum pr_type type, bool abort, blk_status_t *blk_stat);
+	int (*pr_clear)(struct block_device *bdev, u64 key,
+			blk_status_t *blk_stat);
 	/*
 	 * pr_read_keys - Read the registered keys and return them in the
 	 * pr_keys->keys array. The keys array will have been allocated at the
@@ -35,9 +36,11 @@ struct pr_ops {
 	 * contains, so the caller can retry with a larger array.
 	 */
 	int (*pr_read_keys)(struct block_device *bdev,
-			struct pr_keys *keys_info, u32 keys_len);
+			struct pr_keys *keys_info, u32 keys_len,
+			blk_status_t *blk_stat);
 	int (*pr_read_reservation)(struct block_device *bdev,
-			struct pr_held_reservation *rsv);
+			struct pr_held_reservation *rsv,
+			blk_status_t *blk_stat);
 };
 
 #endif /* LINUX_PR_H */
-- 
2.25.1

