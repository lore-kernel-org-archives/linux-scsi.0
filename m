Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F70BC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 15:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389860AbiDUPHJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 11:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356034AbiDUPHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 11:07:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D424C46146;
        Thu, 21 Apr 2022 08:04:18 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LD1me7020622;
        Thu, 21 Apr 2022 15:04:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=vF3JRFTTLVW8Ssv0Z2oJZnJlp7lzEHCg8bDIjNShw5k=;
 b=iOb1ZzgMMYr7ZcIjG9v4pCY9TFLtZiEQijqc0gDsqLBoHqX9fb4iXbxIg/OQQFYK32fa
 thFf0M2VrCaDPZOUaC+yPBeomFcREHVDmA4iTSU/ssvogKpvH9c/zPGcNdYBc1spoinx
 7rgIzJQDzemCVFjZDgjGlwCf1w3Dquu/y2VUxaQIiG9kNWcOgubz8fGQzJPgXvaU0Wl7
 A96cuPBfYc6E6yRlPSkfnWIKvyy/4oRkoDOsulROL5mkmneiTcrTqd4/DxRSI59DqXFo
 xn7yvRReMpt/X5c+e7dG25qa/s6tCgrO5Z6ElDaZAQgN9ex3M9hzBhXrudS075BNg+/V iA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmd1ccdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 15:04:09 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23LEuD2t006582;
        Thu, 21 Apr 2022 15:04:06 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8btey5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 15:04:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmSeVPOBSjxhtACoQJ+d4K2xKoIwd4SbRpabij/diiIPF9/4HiK7r8K6H10qMs9Qpf1YZZxFQWnx7RDkse14MmY6m8Vfj+DanUD4JfYhIH63SoCiVrLKWDjwjjci+9a1Bx/JM323MOMZ/mgm3zjUkHrdMkAjuVbv+Bvgxj9eoXCOVGLpZR8xMuhhGFeSCspTMnMdHMJ6cqoIZv7X6qjRXxlZvRGpOYbXTjkhKGa0TDal6p8298y1O/fgLvrANHjGmqQoBXkhBdfMXw8CciAuWd2FLkYAM/PZ+nIolVm1C2ywVNfSgjpiOFz3c0nutVRXCab/9LZ5JdA2eFp1ADVR2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vF3JRFTTLVW8Ssv0Z2oJZnJlp7lzEHCg8bDIjNShw5k=;
 b=YwcnzXeu3nUuiBHtKAwTs775VzkCwL4H/NY5aO5EbbSHxrdfWta8uLP5v4PIZ6QKIkkoMbo8gDsslYY5Gvx/hldtdeoOcxEzJHRYgE1V8YR54lpHpQ/FRorVSdZYaoWzASopaNuVJHuDmsAHLnHXWRcggNiiSvSJa7ld9nS17+GfeaqIZY3Vz4bI491N8qQHfuv5WxQwvKaADVdDFW6MRVJE0z6CNrqCn5S4fg+c4Eq1mzO3/XMpmJoYxoQyow4N807/4Lcfzt3YEYHhLqEJHrD9NAQnpGHWmW59q5N5QpBKcM5dDmO08u0kMDJv+kmcXNa6fHI/uanu78n+GTYG0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vF3JRFTTLVW8Ssv0Z2oJZnJlp7lzEHCg8bDIjNShw5k=;
 b=XD7BI/euRYSZnIxgGJGUQijVQD4XKdR55gUMmAFqQYjwJuM5Bf2r2RHtsP0Efbnu5o6fyTyDu2MWMe3zlysl/OfkhnlcRtZYStm20ghk3XCDMU6HWmrksee8Rkou7LQY53Rk6uFXdh4ikbXUNs4aTyGdWzVdgzQ1hlMTXRauUIg=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BY5PR10MB3763.namprd10.prod.outlook.com
 (2603:10b6:a03:1f5::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 15:04:04 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87%5]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 15:04:04 +0000
Date:   Thu, 21 Apr 2022 18:03:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: iscsi: fix harmless double shift bug
Message-ID: <YmFyWHf8nrrx+SHa@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0062.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef2c61b5-8e32-4d30-43f9-08da23a82ce9
X-MS-TrafficTypeDiagnostic: BY5PR10MB3763:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB3763A55AEEDFAA3863A4EDA98EF49@BY5PR10MB3763.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Ii796dVVhlfjUD8As6slB8BbN2CvM5RVfT0NzYmEuPBf0PQJh3Nj5/hj9Wv4ke5uOekl2YQOtNj1kFjzh+l/Sx/VdwNbkyV1GGxUmNkWC1Lj5ZGjAeJsmDXjhxzTfxdX6W5NaBojijeOgqgaUDBCoSj9PYuMt21OLC35V3hKm93vmFWJ5850emzCde3Rg4yhjzO2pSVd1naJSptUUPWD0mFXm4Hza6z7kwHiFBobhiz91jQR8rdMA625Qpql3wZhUZ5lYwSVzTdndftIytJMfsZVFADguqZnx69iZC/jFKwA9GObo0LxbTAK2pBTYKbQGgJo5dK3YLCycGNb0WvML5gRKo12PK5ZOCQvJ4QGKKwfBMA7y6yQoyvumKJWHpqleyClOEYD5zaygg+EwJ0x/fuUEEVzmT7fzceIAWyP8b7gcGUPl4GMyLKlnhx+yiKF1/t7TRS/Z4YlEBFKzdLLtXcLMhfG97KWaSsfi9F4MYAN3W+C1HyDMrgn4X+LU5Z9O1nPIUqcJmGn+BWlwdnabAkCafn5UYMNGXemBF96F4XCq3qbBfYLs7VnLMQ51HEPnTBDzYw+8j/2X4ktwpY/GNw7kF2t8HoqXnTyLofZh6pHPnXInHLlLPD0Nb2dqx3YJCAz628MUtN4Aia5ZHNhCMxr14+rKQojXfyX0mUaqPzPcUBpyMflXrJ7YU6Jhgoi8N5nBC/O30kUeg1zvGfGOG6kCA+DS3S2lad24M/rsc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6486002)(38100700002)(38350700002)(508600001)(8936002)(110136005)(54906003)(86362001)(6636002)(316002)(4326008)(83380400001)(52116002)(44832011)(66556008)(26005)(4744005)(6506007)(9686003)(6512007)(2906002)(66946007)(5660300002)(186003)(6666004)(33716001)(66476007)(8676002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+SRoUSITzRZl3kJ/LZDlbuOSE7uiN34588p0ZpzDPfZ+R1PtNFSeNUL6Wlja?=
 =?us-ascii?Q?EUVH5J7Fv86xgAmv3LxRnSVppQ9+aI5nBumVuxR/Cw8Jwp5xDO0GAyuXXMKa?=
 =?us-ascii?Q?PX4qW9VRrPHytUXNJ9NRNR1TJS4V8GSDp8DjbE0zLrqGg4bgB5qQHcafU4f4?=
 =?us-ascii?Q?7l3cP+kF1Z4FO1rMfw8TOQ75sw06HX/KR99V4xDE2sKeqZHsydIDr0n+HenI?=
 =?us-ascii?Q?sWa4TqwI6NQO7wdlQ6QdhicE2XRm+Yrkmq1isjCTUHObJtiI5Vbr2RGgbpc+?=
 =?us-ascii?Q?XaunLkiQXUGAvqBC2YdoVRySfOOibTx6ApoMCc3ykzwNVyRQRurjw89Bo9BA?=
 =?us-ascii?Q?5GtkdsPj6X1oc80lveIXRFbODM5mtF72MoIzYsv+LcmmC0zf2w7WgOEZ6VrJ?=
 =?us-ascii?Q?St4kI0A5NztpT2ofsl1voo9U4Y86k/9v15ixAG53tPlUt7IgtL46febQtjde?=
 =?us-ascii?Q?hCgG+b4mA6Mj7Gbtei2QoPR8eMyiP5Dpt0r/bV15FBWFcgUegbMi1XnLOMtf?=
 =?us-ascii?Q?P8sS2Y05eVTDdVQUHd4kXpZdi5+ExenPKUQF7fMH9IABRZBK/OAafvJH9U1t?=
 =?us-ascii?Q?H+iRv1iicgYRcDf6GMXBPOXGuRWKluiKQXSh5SY3CP4lZqfOw2Kj1Tr5DZHc?=
 =?us-ascii?Q?2cz4mhR6zxMZLl/PBsDw1CP+NqNDPJmr2m2XF2gZ+F8NIVeovp/yo6PHn4HL?=
 =?us-ascii?Q?+E/+rAKH51aC4um2NscbnsALGfF6BdCmxhBTFS2VrrjkEBmeg14tk40o9S+q?=
 =?us-ascii?Q?3qwTkxfZiANeIHyeqMabvBe0ZYC295npf9Mt3D+fEY3m12W2qRTIi5FkYQrf?=
 =?us-ascii?Q?c+WIOfXmL+2nmHX7UmFoLVseLvI1aDWCsKNJgLV+2WR+NiL6wdjM55xn46yk?=
 =?us-ascii?Q?JWFNI7Rqvg4ilnIbA5f0Jd0tZP92QxxjpoiZUs7a6Zde9T1h+ZmFDrWrraNV?=
 =?us-ascii?Q?o1f4jTW8XvJS2Zcr4yyGzFZ/CPkPINa9CzI67esfXiG5DWGqVcXuKF60p+ce?=
 =?us-ascii?Q?uk12DPMv8u+bvq/e7x05KV+j9JxwoJD+V6JtPUlLUYT9wJ61epC6fA45an6I?=
 =?us-ascii?Q?eni+TIKJ6ppu0uf8apim5WibZn6Uq/TtEvTfyhgF1YP/0T9w64uzwyUSGGnv?=
 =?us-ascii?Q?I7KA8fX/2TtmA3ryZR/YICOA9o8MqR8b0mVHyI4tzf/bcz8LTeujtJH6UsLQ?=
 =?us-ascii?Q?vP/GdZ1xDX4NNjzq2SzJK5xSxDswuYfsLqg8AMoJ//yAdqnuuDGkJ7KrqGrK?=
 =?us-ascii?Q?SYAszLh1gzp+jbJb0OkO4KVmmvDv7HrTMHMFsW2Qfdz96LS5wgQif41PqGS6?=
 =?us-ascii?Q?1DkUBDlfQz7yf57NTzqXJZEzOY9hsZZmD1Dh3hDTvqNfzCTXMTuh9hpNOZfY?=
 =?us-ascii?Q?aHMqsAyeUxPyIF3v2vP0K6mtlnc/WrhDP4p0RoWiAlZmOpkUdNfYjKkAnNDw?=
 =?us-ascii?Q?HXM7WTRpertVaBCrXNNFFG8HRWdu4m9a3zPK3737FMw0LJ/ArwyYkeY6QTyt?=
 =?us-ascii?Q?VjIgrz9t4Fw5T5rESxxfC/pCx6N1ZsxuumOl0o7VIkaR27HI07Hc8t3j468t?=
 =?us-ascii?Q?RViEYRLx5Jq2gMPZlwAYmE+lmgYde/T2GF246A2ONNlwF/xUvQyEe8SfIwgf?=
 =?us-ascii?Q?WFZJaICC+7LhrH9wzr5NgtFMU4VDFoeWmrsDBUXTOIlJck6gLH6iTbjwQEdH?=
 =?us-ascii?Q?OGJS8IDKwOHPuJhI4FpHdocVqzJJI8eFh/E3f2wMotbEX11G8yVQpFa2jGJh?=
 =?us-ascii?Q?PrrJpgGtEjIAbpVPlBKItu3zAiCSJH8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef2c61b5-8e32-4d30-43f9-08da23a82ce9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 15:04:04.4277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pxZksvPQwYhtkLH1o3w+dsH72WOEjZ1PL0GhVY7aAj6fAx65nM/PobR6OYFLYCr9ZWtLfvZlw2Q3rFrwPjzI4D4HBZh59PEv7GY9gbdpZcY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3763
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_01:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=954 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210081
X-Proofpoint-ORIG-GUID: Vsh3MrLZPvuQ-r3einaAdwS7Umkg7DAC
X-Proofpoint-GUID: Vsh3MrLZPvuQ-r3einaAdwS7Umkg7DAC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These flags are supposed to be bit numbers.  Right now they cause a
double shift bug where we use BIT(BIT(2)) instead of BIT(2).
Fortunately, the bit numbers are small and it's done consistently so it
does not cause an issue at run time.

Fixes: 5bd856256f8c ("scsi: iscsi: Merge suspend fields")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 include/scsi/libiscsi.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index d0a24779c52d..c0703cd20a99 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -54,9 +54,9 @@ enum {
 #define ISID_SIZE			6
 
 /* Connection flags */
-#define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
-#define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
-#define ISCSI_CONN_FLAG_BOUND		BIT(2)
+#define ISCSI_CONN_FLAG_SUSPEND_TX	0
+#define ISCSI_CONN_FLAG_SUSPEND_RX	1
+#define ISCSI_CONN_FLAG_BOUND		2
 
 #define ISCSI_ITT_MASK			0x1fff
 #define ISCSI_TOTAL_CMDS_MAX		4096
-- 
2.20.1

