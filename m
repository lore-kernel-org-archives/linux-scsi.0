Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34ECBC531DC
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 19:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347860AbjHQT30 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 15:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353078AbjHQT3K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 15:29:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC8D2D79;
        Thu, 17 Aug 2023 12:29:09 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HI4q24032738;
        Thu, 17 Aug 2023 19:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=YjIS24pW8p1kRuBwoMzCh/4NzZsSt38hLZjhiydeSuk=;
 b=TIERCeVUKlQVj7pXIs82AC4F3ORKK8Yc8GCcYa+5sLIyf6ISiDqA+lDGkKc1P6BN9vZo
 q8/LYvNeshXtrahwok7sRwI1budawDRxJxbpFeKW15BZblP9qk1ORyn5VkZq1O3WKAPh
 wlSJVz6CWGsSMhyWehdp5i7o3mRmpK51h1G82QawGpG5iBpBy/STaV1Av0y1GlfAfuXv
 kbS3Hqbxm7S+iw3d+NQo+AK0Jo02DgSGjY1axGJSiclPmCEaYh/YApw918MO1KEwUvG6
 +UOcTWPmKvjf1aikIOkh/kMclHPU0mqqoGHQ6G/XGYekY1nVYPvSzI7aOv5rABmVTRlT EA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3se2w62cc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Aug 2023 19:29:08 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37HIT5Ao003743;
        Thu, 17 Aug 2023 19:29:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sexyn22er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Aug 2023 19:29:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LfgK6xG+pfntw++T+ypm3JXgGrBJoefs7F7DRAwiAd4aaG04fkSdEr6ZV0pPqi8yZzXGX9BJoUBDRRoVUA12oFNg2DtBezbIx3URu0m8IVNTXI20jZcwiL4XjCYDvqcwoZNhBNWLPFxnnBt9T1YHCbJPdQ0L2ZLQE2vVqUq06vZtZ1owHRrWtz0VlRujFRTnQIWnyKkboc/ucZ3wvAZd6W9e+mY1kzILJRkYEdTdD9HB825gIHsLvAeHCK8MZPd/c1HD2J2CC6YfOXAZXqWheoApMnTSDEZCw9FURhCqWtiTSrrFKmRLp17fF7GSdkUyrB1fhrqbM964floAQHX+JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjIS24pW8p1kRuBwoMzCh/4NzZsSt38hLZjhiydeSuk=;
 b=B1K+334851RH8qkf6LEAnYkoto80kYLD2/C4xhGIK36aw+Dvjaq0a+pvqe9W7ZVDe4J7nznA06F+h7AApA3XgTePn6IC3MqT7xU4q1u6MFjTLtNS2y0Dt7mAQ5bkAG905DkZ0K8bVNu2yLwBPiQDNzPTgC8QAlfRxxwPdVBBc2qfKJCKD1Ry8c/gX2VFscg9QY/MDvavev0wqcCQxZD9QDhPYGGUko3Ma6dv0FZoVeStDDJVVb3RuEUNjvcX6AIEdPznb0Wx03cLDw/TskoGLsv2b/Q61A27VSU+Lw4DNsNcQQNYMaImHdrmeIgI89oWjqmormAKHFN71+fI7z1Kog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjIS24pW8p1kRuBwoMzCh/4NzZsSt38hLZjhiydeSuk=;
 b=Cm4Qq0BViup1+xRTZi4mbSoC707jiYVRM9zF5mt4sAj3IJ4himwDd0o7Rxoqg4iFV2l6tBmJpmLzw80VGdc6Zpu5VqJaZ2/VxlQNFkv+Mku1jDcQn04cI+WhHgOE4SKl6O8Duk/T0m0pZBo9s8qFaxe8WJHIO4TB39TcfXvJjhQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CY8PR10MB6876.namprd10.prod.outlook.com (2603:10b6:930:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Thu, 17 Aug
 2023 19:29:05 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6678.029; Thu, 17 Aug 2023
 19:29:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: target: Fix write perf due to unneeded throttling
Date:   Thu, 17 Aug 2023 14:29:02 -0500
Message-Id: <20230817192902.346791-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0055.namprd05.prod.outlook.com
 (2603:10b6:8:2f::15) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CY8PR10MB6876:EE_
X-MS-Office365-Filtering-Correlation-Id: 213490e1-60b2-4041-bb8a-08db9f5837ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3QhN9z+j3gLbrkg5JjLbKGG2/hsehD0wKd0FNqxC+DuR7BJ+vHvo9ySuPK8aH4Sz4GUfJWOjk0erdiHteGlibr6rUC1yLyVpHciN0BDYHFD/jxj4/V8CMzw05SXVTKr5zZuKiDnVMPDxlPTKbvtqJYE5PDJxVbCpRhaRdhxFkAKNdQKtmaqCDG6TmJl7jIlBGXli+yYJXvNP4BP9n5CLxtfWOs806wnOWP2htKY0ejnKTzejfRCOlYRn3qApCPUid/cW+r7nXwiq6J2zJQ3Ff1RGiB295EYtYcUOINMU5+cCirxxl1aCLKe74xS6yCJL7gReh2sQI+P/BrOt1ilWy9OeEzCkeXFT+a5K317Z6j+5p9TeKP8I6ulKXfm26M9hJ7itIRD9VUu94IQQ30Eymp/Z8hmnT7t+pDYGWbpcbBOoDXtF70QFa/FLHITbAaURzrWD4gC1hiuOVUxLnPHccUH5MpkHgLD+BnfSYq4hpqynSeKaZqCOaEqFtzDigOFkF7jIt6fKHXyWE2gjV/2SGRKNdofLdkgKuOfhi3qJBdMivR93pi7x5JU+G0p5ytcv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199024)(1800799009)(186009)(83380400001)(66556008)(38100700002)(66946007)(316002)(66476007)(478600001)(2906002)(450100002)(41300700001)(8676002)(4326008)(8936002)(5660300002)(6512007)(6506007)(6486002)(107886003)(26005)(1076003)(2616005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pYWKiSrrEwoJA5jGTpiQaklL0tGxQpx9N1XxzHL26cle2Zh6eRdTBii46KB6?=
 =?us-ascii?Q?cVqzGIAs2EnkIfaykupgvsAEiJW7in1O2g0D5WcG7QSFLuj9BNAPi/+MCV3p?=
 =?us-ascii?Q?M1x/t4aEORKzn+KEV0a1Dw/45jpwStMjuiUASNQBUGHlA2yMwTC9IFXVUd5u?=
 =?us-ascii?Q?p+6zbdj9bOZWjIOnklUeH+WEwWIWmTpcw+JzQBUeCjx4Fo+37DTw32J2zZLe?=
 =?us-ascii?Q?1X2tSUxhyb3MUq2BMhnwiAi9JgJSYWofZ4N/F12heHU54NNdYr6xxrV0NJeh?=
 =?us-ascii?Q?327ElXv25y97P32AZgc6gwuPTsYI7yVeLhE/55IQkVihV+f+GQoV/i7PBhtX?=
 =?us-ascii?Q?Qhyv8PsNQh7FnQzTbYbKbSzS8GLHEJ2XLYVD+yBj/hygVvuy0yO95sgHe+zm?=
 =?us-ascii?Q?v7OPVtTO8C1AQ8/xiD21I3nY8iTE8/4XMplsyePHX4N3/K0BqsFpgk9OAVjo?=
 =?us-ascii?Q?uiFmTbl6nWCXUrJoursvO1EiG3gUtReBRp0+hwFrKWlsOiXO4fLWiXZP0o8D?=
 =?us-ascii?Q?zZwqxNfDn2tcE0ddfpd2XivKlwOp5hPnuTIJUbs5sriPv+NyNDiDlidvWKs3?=
 =?us-ascii?Q?SbFIW2eHUlqfUl3gKh+N5MRtSh4+rXPvuN4PaPiAaZilyhiO7tjAUKl5wvjh?=
 =?us-ascii?Q?Bh+2UOHV1U1PVBazvwfG/5/AqfmabR5Qg9GVALilX6jKYccMSC2vcfNgKXgk?=
 =?us-ascii?Q?wF3wlxLnD5a3QZwRxK/jUKtHyhNnJJVrkUnB7NeHWA2eb3BF1bUB02C06uLQ?=
 =?us-ascii?Q?1nYbPJwMtow6gDMwOpBMMul+grdY0eBPTqe+XKUOtW8ji7FN9zVGmLEyAwwa?=
 =?us-ascii?Q?V9IVBfr78Lzz0PtssisfHgeXznGJODHuL005CDwHHrP/5GHnznQmQnl7xUVH?=
 =?us-ascii?Q?8JLFq/YSn24pzHzl3R/hBJI7AUXhhTO479qUjQ4PW6jnfoRnKBAQgXUnN51q?=
 =?us-ascii?Q?yKAJKDs4H+WYIW5y0uCwU0yJEH6C3ijhmQEr5BByyZbVc3sSdwtkXIVUl+Se?=
 =?us-ascii?Q?ZCFyDVnaUn/WMcrHHmYR4v025ges5SLaz9vpCAYK5lLhFsvM/tYfwLN4eSqK?=
 =?us-ascii?Q?cOWOQdPRjycplXOtWimD9+Shah5/+SM/jFsuCZxKTYowv5IRhu4Bj1qugURI?=
 =?us-ascii?Q?ucID4OC4n6fnNa4XbZPmQP8fL5QWMq8tjBiEfQYTWIJSKjVk/1KKrSI/PsEy?=
 =?us-ascii?Q?a43w9S5l5bwqxHknfWXdWUdMoIAx95N5ZvrZP5R8rnzsQ6DLHmKO+6U1v2aj?=
 =?us-ascii?Q?t+PqKIHlx16NOq4sz83JCvKiOUwOOg/4R1gB26FxiV3MqPmEhGO0gxxH1rBq?=
 =?us-ascii?Q?UB5vMcED6tFuWpT8Cf/DngrZKcVx9/9Y5lCfV3ObMxi5n2i4xupVL7hq6QyW?=
 =?us-ascii?Q?kmE8Du/iW7ciNwYyZESxrcarI1v40H55pSg34RV9nbLv2EtAuuAaAVplJJPA?=
 =?us-ascii?Q?ciw5AMm4sa/RV0WOV95sGOiuZ6CXKHHc+JrewShaDoklBYUfEeCmUMW0AZY3?=
 =?us-ascii?Q?NYg/zgsFu6SOj/oTUZGbNV/WlTiY098lZlLy5WB+o4gr0PFlQ0n1vrCsowoe?=
 =?us-ascii?Q?S9uBjoxD3dPj7OjdSugQZGU+29V+p4dMX3OjDJUT+GSHzDLUIKsZY8Lez+dX?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: REQ2vl/cfs3ZhfMi6BUhpGZys+4B0DR3Ez7nzqbgarCpn3LCaUgpflve/PuqbbAp+9uF7X6H8cdGFVu52GsscXGbWJ8yVSRW1lEMmbto70+zHxY7RkiXG8fenno+MrmTGIIvT6121cbRXl1pUgOKtrAgrxvH8yk+XNkoFCuZHKkrKb6HBtt+y4Y7nMSmI7KleLuH8pU2rWOJ5mPqJ5CqTjkziuPXp+SjNjMG7Mb8kG5eC0TP/uW6muexYtFdkGv7I9WWuIi30UDgr6OCkKaa82udHJt5kMyHk7AtTCb6k4KutV4BP/SCkurb3uyjC0csFfYU+O9m7yxR7riBYexMtwCnucZGsLiOScwQYBth56mhNcbmKOdt5sCghaMo4kLTp24ihXNDVArcw0tZnfEWdlts4I/ec5t0XbCda48M/1k4O7OCJ/MMw84O+0iQsxF51FKPZpz61/5afdXMl+THICFLzet+gLG/K4Q1NhoXZe8oS/gsfJbw1vY2dyJ4sH00PP6E6lFKnOV0tl4yDQoH+2f7pqcAbQ1GQvUWrmXdPkAqTRU+sH3XgnL+y1niCCTpGb6hVdOWskVJtZkIa/fWRaT7AfKDyKyfszDp0j5a0YZ6zG8VF+EorcR+r//YSzmRWje+wPOU2CahFhfjytNOVxvcoaAbvB4BeG7HDrSha721FEJMwcdQn66ARPv1i6kce8Izj7T+JYD/yFTttlffdXsvCzn9E405P9BBCDYgQZHRaQg3f1Jaaf5N87/EtcZJpYWJqd32/coVXJtazi5w1Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 213490e1-60b2-4041-bb8a-08db9f5837ae
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 19:29:04.4646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ilb6fKT6I4g/8D+SBD/omhRqBZGd7u45xRm3PDVA05By4p5bRMcFx2k/g1sqIYFNaSs4w2MeG+wJMmmRMBujJwEQWsrcCAtCnnch3v4bYXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6876
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_15,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308170175
X-Proofpoint-ORIG-GUID: 2VUTVHNjH5EtJpqVKakxpcDhDS4zi0Jd
X-Proofpoint-GUID: 2VUTVHNjH5EtJpqVKakxpcDhDS4zi0Jd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The write back throttling (WBT) code checks if REQ_SYNC | REQ_IDLE is set
to determine if a write is O_DIRECT vs buffered. If the bits are not set
then it assumes it's a buffered write and will throttle LIO if we hit
certain metrics. LIO itself is not using the buffer cache and is doing
direct IO, so this has us set the direct bits so we are not throttled.

When the initiator application is doing direct IO this can greatly
improve performance. It depends on the backend device but we have seen
where the WBT code is throttling writes to only 20K IOPs with 4K IOs when
the device can support 100K+.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_iblock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 3d1b511ea284..5937a7ed6989 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -740,11 +740,16 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	if (data_direction == DMA_TO_DEVICE) {
 		struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+
+		/*
+		 * Set bits to indicate WRITE_ODIRECT so we are not throttled
+		 * by WBT.
+		 */
+		opf = REQ_OP_WRITE | REQ_SYNC | REQ_IDLE;
 		/*
 		 * Force writethrough using REQ_FUA if a volatile write cache
 		 * is not enabled, or if initiator set the Force Unit Access bit.
 		 */
-		opf = REQ_OP_WRITE;
 		miter_dir = SG_MITER_TO_SG;
 		if (bdev_fua(ib_dev->ibd_bd)) {
 			if (cmd->se_cmd_flags & SCF_FUA)
-- 
2.34.1

