Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97A6C25B0C
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbiHIAGd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244668AbiHIAGK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:06:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8991C90A;
        Mon,  8 Aug 2022 17:06:04 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278Nwhfh031116;
        Tue, 9 Aug 2022 00:04:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=TqTx2QfwuxrjITSItWRT+agtLDkFKm71vQRn21FVbiY=;
 b=lfIqTsgF3UuX7C7Zbi8/iNZ8sItwEDbU2+rGqeLaLPWYbmoiBJCfh0i0eGBVNdA7kYD0
 ymb8uQyXwrp6YazdRvYlXYlH5EydCyma9pbx8YzAJ8T45TCyojTAJjk2jJvWJS3VQF6V
 OtnYlfXDop3m8iei3Zu7r41k1hHZdHrKkTKF+tIdg7h/yYk6wZE9ZoD+rjg/xi69mE/y
 Yt0rddS1mflxWG3+SfaJoMK3bH1LMKTpIkaLwslI4LxhJdZ+m+WVz5iAEdRPsjz2L26y
 8Wn2IwJ85Ej4WQbp5Vx0H0o0wqxO31I13Xr1HKjVrm56cFruMjl2XNR07eAKqac/AsOF og== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsew155hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0hHm038083;
        Tue, 9 Aug 2022 00:04:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hu0n32vm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1MaFnrPxWNur7utypVHyqILi5Rxh7OzErMjmNrCT7+Pfnj1ff9uczwJ0e6DDCHeB0JKXumsV4qwfYov+P8+dEAUYh+U9hN177MCmCclx+LmYn47Mg8UFYx2XkF7K66DYyMBPH7h/Tyww+3eMZxzveKcaGYxtUlebPrtv56pvRrGpMQQ2x/M/H3aW43pSjf34QSVaGSaKl2W589wErjTmSiau2L0K6FfWssPDavg2yr54/2PjPN+1NAOUImdffzGOpDMSgEFofLrFxeqWRsonF1s7hMxLh8dsC5w46Ke1qNkR10cijtPpGo6VSF291NJOFABu8PWZEilUABHI2iKLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TqTx2QfwuxrjITSItWRT+agtLDkFKm71vQRn21FVbiY=;
 b=aGoVU95rqlwtckmrRPatChxAEafKaQZjLo1ZPICWCkedHhOjQCURLXcNi66bzGsHN/Gfd3w/eT71i8dHlPOOFjKQWGA37QFLCcOoFAOVmJX4R6SL93OaNMnnRwf0fQe8TlLfko2DR9XubPJHs5h1vYXIVNgHLH8MH4VuXL3Tfka7pTTRI7MDa3P8Kr51RMEp+uFbDs54uTy80SRCBeKZt2xmgMuqJwI2sxuH/lSMTd6bYO1ZBJh4Ejsu3lAaB96JGk4nRuVk6Sg/sT4xlcOEUNx+FWhrJIvEEPcWCkvcLGLUwwKaLMjjsoK/MzL0CR1ig3by2WnWo3riEtLGNl9bsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TqTx2QfwuxrjITSItWRT+agtLDkFKm71vQRn21FVbiY=;
 b=Y3h6lHV60rHVnGIXBKCpfvKzCDfQ5bFJac21uNRV1U4TIoL+P+ysn6CfPuYCaDVK2U7TGBQc6Rw6nXmUcMS4NjYXc+Hpe31Q1kiPkjCQKP9+bXfUfgEonQgHk8qhcburmCuVTyrk7FTm7Xd1Z4gkw2Xdp46+L3Ty9izmR9znE7M=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4907.namprd10.prod.outlook.com (2603:10b6:610:db::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 12/20] block,nvme,scsi,dm: Add blk_status to pr_ops callouts.
Date:   Mon,  8 Aug 2022 19:04:11 -0500
Message-Id: <20220809000419.10674-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:610:59::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94268674-7043-401b-76fb-08da799ac14e
X-MS-TrafficTypeDiagnostic: CH0PR10MB4907:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBioCe4eQegoq/BAzd0UTbmqJ8/yyeekOqSbZkT1eCCEsg1LcJIIA7gkfNuCLv10DNuAmUbRbXuVZo/hq6gWp0aVbc6xTrKO5XHNsRxVGXD0E+rxrDcUd8mMT+YoQ2DOHiCo3dyoJQdSzD48RQuraZZ5tx5mcuf3xR3d5HV8sEdPJTn/K1eubhl/HlIpQDXv4ct1AtMJdQUD90ccbDcdqQSvCbpj5Yc68+GkN3QyPA5H5jv+q0DWrwbxRqgKxD65xjIS3IEsjXuwcoRZIwSMt1mKnTLabrjZu8409TChZ0/TMeq59e8lJCTCSPqS/hCfdv4SSZghyD/pyYBlPrM0Jp1JniNvZalKYXkZwsgGBPzq0GbyNIJffTAvk96D4W3JD4XHAVFSjmQ5Qy7VS6y3Hj9sKOxiqeWOxRHE6JkW951t4L4/zZ2xe4fdZ/7YrW0EuVtMREv8nfyqj1/EUk08MbLQD2DZGEILxlz8uznDRQYwXxM8v8tc42afaL8l7X8na/s8Q1g4rt4qsV7iLjjx7wGvdCdxfGbjA2RvM/jA6RhgLxo/hEj3djFEb/XvPbg7JdGmEovTCRFRpugdRKKJLGRCKbjCQ9uNkFTB2h3b+17jRBQVSwn/e0VNdQbRG7bqzQ6WEx6/1lgCK1iuL6yS+/fq9eTCgX1un4cDimIOxIznS1tT32sst4cgxRLYE3WpgTe3ID1UAlDrGBTGog/NUA579VIm3HhI5Jv99+qYNOi/uWfvtXj9xN9U30wq6FvwRUj7R5OK7QKpDslfWwkDjuHBKZmwe3Yj89y/ZyblLcw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(346002)(376002)(39860400002)(921005)(30864003)(6666004)(41300700001)(6512007)(26005)(2906002)(6506007)(83380400001)(2616005)(107886003)(38100700002)(86362001)(186003)(6486002)(1076003)(316002)(66476007)(66556008)(36756003)(8676002)(66946007)(4326008)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WxZkQG0Ys9yuX6piL/fTGOi+vnM/DC5zLWYUlONLZspohHiz1uiuwQk2yNvT?=
 =?us-ascii?Q?okhUX1QYUdLvGoE5oV1lRToDrf7pLc+flc3f9tuJ1OirIr/sDzuSCiI/G6L6?=
 =?us-ascii?Q?Pb14v7qcvGT2jwPgvZT99M4+cNlps1Pu45iSEFvFu7BW4CeEW41mbi5OKU7Z?=
 =?us-ascii?Q?/A6UxBYp51KS1QEqNZJqSnQeRHtnqkiRQaTAicYWpYNXUERJjdmfIuF6McUG?=
 =?us-ascii?Q?Ei5qxNaX9xyA09jp+bJG4eCyjfZOKnFW+07G2R/k+LN6Tc9l3yyOyG2uNWO2?=
 =?us-ascii?Q?qhDEQ2TtXO565S8AK18LOZzgRLxRddor8UGTUKw+8qHhGpqT2i663MDeQWqM?=
 =?us-ascii?Q?qZYYrpvMbrQTNm+KtICZin4UFHcIKPsO4zNkbGGYZ4OAk+LDSEl2QHVAmrq1?=
 =?us-ascii?Q?lgT6qaGxgfOtcVUdOSP8PwKV5Z5thXH/45DGzCKgnDBNCYypx4Y6ffclkpsh?=
 =?us-ascii?Q?0n9Fr2ZT2fPpXWPZDQCpWelYOlYq+Dx7USoKmo+P25vvNpq3/eOlDd0U0V81?=
 =?us-ascii?Q?Qv146jOlPol4CqihzKrx8kB4svQlFwbMfqzvA1ei9xWR2ROtXSZSIH6DKXmc?=
 =?us-ascii?Q?sDyGpVzFdUOnoeT3okKs3MFvVwNKAG+AiUy6drSthHTl7H6/PasV03gIB/03?=
 =?us-ascii?Q?Vo6Jg9tSzinN019qg/AARs0Si+fYWA0m1aCQye92Vhlfc2nN7I0ty/14DSyp?=
 =?us-ascii?Q?6611fNzXPVz87dZr6NKUxSXOO8g8PoGdVx8Ldx5c7oxmLUbWJnWQ2fpDV2r7?=
 =?us-ascii?Q?mzAMDll3S8sH3V8Bwzk+xJWbVbtDkfT0Nk8D+M57VZSHlUJlrxQ62tBhj2eH?=
 =?us-ascii?Q?RxWNVBFl8/WK7mw5qZgR9bnFMmMxobIYvDaY4i/QKVO4ZdQFJpHJJT5TcqJp?=
 =?us-ascii?Q?sOHTtufqIgNVtAmZg92X1Urj2yYhCIlu+PXkKu35IKbEJe6ZECoI6lihkC1s?=
 =?us-ascii?Q?LkzjHpeMxs91sR3GENRZpVYG5A4ZJSokOu2X0ygk1DqCPFjU/4Pto3s2gzfN?=
 =?us-ascii?Q?yd9rbvYKmNv41LN2hAXx0ma5jhkDE65SMtRyRnq+aeEZn/51xyXcem89w4Iy?=
 =?us-ascii?Q?ovwHjwfy7QOmCsoTlD89vpTfCkDGRzg75UA7CVjzExT41/iY5FmT9CZBvz6r?=
 =?us-ascii?Q?S+OVywvZqQt8+KpX7AF0vAw+bhBDDGPJ52fK18HFs8PhHNUGYbSHC+7jaCd7?=
 =?us-ascii?Q?TK70t9MzzXNPIGE17H3m4hKNLXUp9zs2qyeDfHKoIx768OeMW8t4ACoBA/1K?=
 =?us-ascii?Q?7vuVUF/jzHFYAIZZUYyGoYU/2posVXpR03pdoCO9XwSZWjylFjtMh0VExf4K?=
 =?us-ascii?Q?40HczQUIUOQKSlQeRHDIaVCXuMxVhjFc618vcX4XN4kZeLGe9aJU345+OdGx?=
 =?us-ascii?Q?pktmXxwJxsfcRWf/Mb+egxcJOfFmnf5LP2BrVwkBiv0dCmHMBtWWh9L1YA9P?=
 =?us-ascii?Q?bBz4fu4ntD2Hzcw6AlKVQ6c8TTZNQDmcO4rINerwqJm1DIlC89zw/PUPX9qK?=
 =?us-ascii?Q?rmjyqPufXlT0am+npli/OBx92eXZ/V+wLGZl0XKYnn5RdvPOsv4Q8lu3eIvh?=
 =?us-ascii?Q?4HsxA0kDzdf/YgDwtGgPBjOiVJgwK/OGnIXWpXawn65FtEPxsGZutfmLI6Mq?=
 =?us-ascii?Q?WQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94268674-7043-401b-76fb-08da799ac14e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:40.2822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qtdzf0ScS+Vi4WLMbaFpU/GjP6UWz+unUyzPxNRmXADN7sQUO6wAHHdt6ygGdeM0+qHZCdDCBEqS9RjS52fF8ME09ItBcTEbIRCEgBCL2Y4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: tH9uBTu_fO3DKVP_iPwPdgiv6VS1fukI
X-Proofpoint-GUID: tH9uBTu_fO3DKVP_iPwPdgiv6VS1fukI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kernel pr_ops users like LIO need to be able to know about if a failure
was a result of a reservation conflict and then be able to convert
from the lower level's definition of that error to SCSI so it can be
returned to the initiator. To do this they currently have to know the
lower level device type and this can be difficult when we have
dm-multipath between LIO and the device.

dm-multipath would also like to be able to distiguish between path
failures and reservation conflict so they can optimize their error
handlers for their pr_ops.

To handle both cases, this patch adds a blk_status_t arg to the pr_ops
callouts. The lower levels will convert their device specific error to
the blk_status_t then the upper levels can easily check that code
without knowing the device type. It also allows us to keep userspace
compat where it expects a negative -Exyz error code if the command fails
before it's sent to the device or a device/tranport specific value if the
error is > 0.

This patch just wires in the blk_status_t to the pr_ops callouts. The
next patches will then have the drivers pass up a blk_status_t.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 block/ioctl.c            | 11 ++++++-----
 drivers/md/dm.c          | 41 +++++++++++++++++++++++++---------------
 drivers/nvme/host/core.c | 16 +++++++++-------
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
index 1b15295bdf24..ac39e5d303b9 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3080,7 +3080,8 @@ struct dm_pr {
 	bool	abort;
 	bool	fail_early;
 	int	ret;
-	enum pr_type type;
+	enum pr_type	type;
+	blk_status_t	*blk_stat;
 };
 
 static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
@@ -3131,7 +3132,8 @@ static int __dm_pr_register(struct dm_target *ti, struct dm_dev *dev,
 		return -1;
 	}
 
-	ret = ops->pr_register(dev->bdev, pr->old_key, pr->new_key, pr->flags);
+	ret = ops->pr_register(dev->bdev, pr->old_key, pr->new_key, pr->flags,
+			       pr->blk_stat);
 	if (!ret)
 		return 0;
 
@@ -3145,7 +3147,7 @@ static int __dm_pr_register(struct dm_target *ti, struct dm_dev *dev,
 }
 
 static int dm_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
-			  u32 flags)
+			  u32 flags, blk_status_t *blk_stat)
 {
 	struct dm_pr pr = {
 		.old_key	= old_key,
@@ -3153,6 +3155,7 @@ static int dm_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 		.flags		= flags,
 		.fail_early	= true,
 		.ret		= 0,
+		.blk_stat	= blk_stat,
 	};
 	int ret;
 
@@ -3190,7 +3193,8 @@ static int __dm_pr_reserve(struct dm_target *ti, struct dm_dev *dev,
 		return -1;
 	}
 
-	pr->ret = ops->pr_reserve(dev->bdev, pr->old_key, pr->type, pr->flags);
+	pr->ret = ops->pr_reserve(dev->bdev, pr->old_key, pr->type, pr->flags,
+				  pr->blk_stat);
 	if (!pr->ret)
 		return -1;
 
@@ -3198,7 +3202,7 @@ static int __dm_pr_reserve(struct dm_target *ti, struct dm_dev *dev,
 }
 
 static int dm_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
-			 u32 flags)
+			 u32 flags, blk_status_t *blk_stat)
 {
 	struct dm_pr pr = {
 		.old_key	= key,
@@ -3206,6 +3210,7 @@ static int dm_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 		.type		= type,
 		.fail_early	= false,
 		.ret		= 0,
+		.blk_stat	= blk_stat,
 	};
 	int ret;
 
@@ -3233,19 +3238,22 @@ static int __dm_pr_release(struct dm_target *ti, struct dm_dev *dev,
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
 
@@ -3268,7 +3276,7 @@ static int __dm_pr_preempt(struct dm_target *ti, struct dm_dev *dev,
 	}
 
 	pr->ret = ops->pr_preempt(dev->bdev, pr->old_key, pr->new_key, pr->type,
-				  pr->abort);
+				  pr->abort, pr->blk_stat);
 	if (!pr->ret)
 		return -1;
 
@@ -3276,13 +3284,14 @@ static int __dm_pr_preempt(struct dm_target *ti, struct dm_dev *dev,
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
 
@@ -3293,7 +3302,8 @@ static int dm_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 	return pr.ret;
 }
 
-static int dm_pr_clear(struct block_device *bdev, u64 key)
+static int dm_pr_clear(struct block_device *bdev, u64 key,
+		       blk_status_t *blk_stat)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
 	const struct pr_ops *ops;
@@ -3305,7 +3315,7 @@ static int dm_pr_clear(struct block_device *bdev, u64 key)
 
 	ops = bdev->bd_disk->fops->pr_ops;
 	if (ops && ops->pr_clear)
-		r = ops->pr_clear(bdev, key);
+		r = ops->pr_clear(bdev, key, blk_stat);
 	else
 		r = -EOPNOTSUPP;
 out:
@@ -3314,7 +3324,7 @@ static int dm_pr_clear(struct block_device *bdev, u64 key)
 }
 
 static int dm_pr_read_keys(struct block_device *bdev, struct pr_keys *keys,
-			   u32 keys_len)
+			   u32 keys_len, blk_status_t *blk_stat)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
 	const struct pr_ops *ops;
@@ -3326,7 +3336,7 @@ static int dm_pr_read_keys(struct block_device *bdev, struct pr_keys *keys,
 
 	ops = bdev->bd_disk->fops->pr_ops;
 	if (ops && ops->pr_read_keys)
-		r = ops->pr_read_keys(bdev, keys, keys_len);
+		r = ops->pr_read_keys(bdev, keys, keys_len, blk_stat);
 	else
 		r = -EOPNOTSUPP;
 out:
@@ -3335,7 +3345,8 @@ static int dm_pr_read_keys(struct block_device *bdev, struct pr_keys *keys,
 }
 
 static int dm_pr_read_reservation(struct block_device *bdev,
-				  struct pr_held_reservation *rsv)
+				  struct pr_held_reservation *rsv,
+				  blk_status_t *blk_stat)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
 	const struct pr_ops *ops;
@@ -3347,7 +3358,7 @@ static int dm_pr_read_reservation(struct block_device *bdev,
 
 	ops = bdev->bd_disk->fops->pr_ops;
 	if (ops && ops->pr_read_reservation)
-		r = ops->pr_read_reservation(bdev, rsv);
+		r = ops->pr_read_reservation(bdev, rsv, blk_stat);
 	else
 		r = -EOPNOTSUPP;
 out:
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 5bbc1d84a87e..49bd745d28e2 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2148,7 +2148,7 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 }
 
 static int nvme_pr_register(struct block_device *bdev, u64 old,
-		u64 new, unsigned flags)
+		u64 new, unsigned flags, blk_status_t *blk_stat)
 {
 	u32 cdw10;
 
@@ -2162,7 +2162,7 @@ static int nvme_pr_register(struct block_device *bdev, u64 old,
 }
 
 static int nvme_pr_reserve(struct block_device *bdev, u64 key,
-		enum pr_type type, unsigned flags)
+		enum pr_type type, unsigned flags, blk_status_t *blk_stat)
 {
 	u32 cdw10;
 
@@ -2175,21 +2175,23 @@ static int nvme_pr_reserve(struct block_device *bdev, u64 key,
 }
 
 static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
-		enum pr_type type, bool abort)
+		enum pr_type type, bool abort, blk_status_t *blk_stat)
 {
 	u32 cdw10 = nvme_pr_type(type) << 8 | (abort ? 2 : 1);
 
 	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
 }
 
-static int nvme_pr_clear(struct block_device *bdev, u64 key)
+static int nvme_pr_clear(struct block_device *bdev, u64 key,
+		blk_status_t *blk_stat)
 {
 	u32 cdw10 = 1 | (key ? 1 << 3 : 0);
 
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_register);
 }
 
-static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
+static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type,
+		blk_status_t *blk_stat)
 {
 	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 1 << 3 : 0);
 
@@ -2224,7 +2226,7 @@ static int nvme_pr_resv_report(struct block_device *bdev, u8 *data,
 }
 
 static int nvme_pr_read_keys(struct block_device *bdev,
-		struct pr_keys *keys_info, u32 keys_len)
+		struct pr_keys *keys_info, u32 keys_len, blk_status_t *blk_stat)
 {
 	struct nvme_reservation_status *status;
 	u32 data_len, num_ret_keys;
@@ -2268,7 +2270,7 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 }
 
 static int nvme_pr_read_reservation(struct block_device *bdev,
-		struct pr_held_reservation *resv)
+		struct pr_held_reservation *resv, blk_status_t *blk_stat)
 {
 	struct nvme_reservation_status tmp_status, *status;
 	int ret, i, num_regs;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f1d4d0568075..bf080de9866d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1708,7 +1708,7 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 }
 
 static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info,
-			   u32 keys_len)
+			   u32 keys_len, blk_status_t *blk_stat)
 {
 	int result, i, data_offset, num_copy_keys;
 	int data_len = keys_len + 8;
@@ -1739,7 +1739,8 @@ static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info,
 }
 
 static int sd_pr_read_reservation(struct block_device *bdev,
-				  struct pr_held_reservation *rsv)
+				  struct pr_held_reservation *rsv,
+				  blk_status_t *blk_stat)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1769,8 +1770,8 @@ static int sd_pr_read_reservation(struct block_device *bdev,
 	return 0;
 }
 
-static int sd_pr_out_command(struct block_device *bdev, u8 sa,
-		u64 key, u64 sa_key, u8 type, u8 flags)
+static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
+		u64 sa_key, u8 type, u8 flags)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1801,7 +1802,7 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 }
 
 static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
-		u32 flags)
+		u32 flags, blk_status_t *blk_stat)
 {
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
@@ -1811,7 +1812,7 @@ static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 }
 
 static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
-		u32 flags)
+		u32 flags, blk_status_t *blk_stat)
 {
 	if (flags)
 		return -EOPNOTSUPP;
@@ -1819,20 +1820,22 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
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
index 5e56da748b2a..8726c1473d55 100644
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
@@ -382,7 +382,7 @@ bl_parse_scsi(struct nfs_server *server, struct pnfs_block_dev *d,
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
index 79b3d2853a20..2cbe97f06490 100644
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
2.18.2

