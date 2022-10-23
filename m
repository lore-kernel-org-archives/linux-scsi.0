Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3B9C04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiJWDHV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiJWDG4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F657287C
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:48 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKvmjt027181;
        Sun, 23 Oct 2022 03:04:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mCQ80TsAuy0hmG6ldOJJBi+B0gPmmjwea4QMlokaAIg=;
 b=Qd56hbjp1Q1Xp3eA9Qij31FU6MEf9AODMJW+Ed1kb17wP6rV+z2N98l6NWy+/ksPbO0w
 1kJKbBxjc5eGss9Qal4dmydqTZqC80IgwADDrXoTNOHcUK8T5F3h2Y26RCtq+9qIXKpA
 9zqJZPxTf+fzT3y3QoQH7/fE8MsjMHE1yKbszRrPJHaywWxeM2qac9+DHj4LTPWzynGV
 03HLx+KuSRHEKYi8eZDOfzVox+5t0nQY4zwaZ8AKq1g/bGqLVGlzfZiHPWnj24wM7xhK
 Cr0kTbd/s3x6KQu0FMjG/0bdyaegUrBuTdR9AiGYi+H7UcdGb3zxxFQTDUlK4RptV2tP CQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741h86j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MK5hQ2032154;
        Sun, 23 Oct 2022 03:04:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y30akv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOliF7Dzlll0kRQZw4/9Ziy/mV+dwldA8q4AbyqfmMBSk6hLhKabb0GvZtND8u6wgX+8vX5fMWloD3S5bSfzUD7LcO1IdaL/FfHRVj19sUP224eXhSVCgNEF/K+fB0Ow4QF/BCXAStvfrKIkfNIw5mez4QlxVr0YJibmKSMlRdpGAMkaKsoHBziMX0O2TNcbiTa9qUU57a5htbtTo6Vv1yEvYOcMoBrug5G+iOKhyeknvyxCdnBH3OrfQ5txHXHWE9DEuIjAmqzYZfkgKjYHJYl6DICPHrXAsEji911GEd+TKZhTDf7txjixtfaQEHbDe4rJONEGf4iItPn+sm5PMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCQ80TsAuy0hmG6ldOJJBi+B0gPmmjwea4QMlokaAIg=;
 b=XqFo8izZ1etQpPBK0cv5E5xs1tEH0X9v48I8dv9lSE09WgX2cHestRxadmTu+4E9JvutHZi2rSJjZlpkluHj9Ofx++pMEDg/UmGYgOXS677tvkqq+yyCwoAkRdGsXYKDvxlaqMsfU3SIzk5RxHwCIn4e6g6KJpGiLUQZLkVxe5oRYLEOO8MZnZq7Lrlp1Ff35hVAAqFWX5ScJSxwHNRK6fSsw36o/NKL1MOGirXwpWh/XNscqhHsWdwAu8rMs4F/RHWl9O8xyX6jgfQj9PwHf8nT5Z8M5dd0Qs7p/VNOP1H2XiYlFVcSlBQsj+T/Q+0SHMbiEwGBi0uRQ8FCLmOSCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCQ80TsAuy0hmG6ldOJJBi+B0gPmmjwea4QMlokaAIg=;
 b=AWsp35CH3iiMahL8EQTfOLtgeH9z3W9y8DmYoEdAU3/r2NeCBqt20AunETca7vWRWQ9DxXWE4i8GexjocxxWBpQ9ZKolam3DRHGQYuSNnnH7/JcdWQEMz/pYx1PJVwhzbrk9GI+y78G38obQCkbAVyJOTzQwno8d6M/iumUE6Lg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:04:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 21/35] scsi: retry INQUIRY after timeout
Date:   Sat, 22 Oct 2022 22:03:49 -0500
Message-Id: <20221023030403.33845-22-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0009.namprd08.prod.outlook.com
 (2603:10b6:610:5a::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b813f3e-2143-4e83-473f-08dab4a352c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ElLRRPHPBz5MNUI1knjYsaw6rvFW0AvlnmylrDKM2mYk2Q2R7B1Pgs3nKYwhmFsWc/WVT2SB9kjABNOHHJrPohbp270FRmiMsPjuuwfAtuuOBLY99Xw7nZtTiDIfKEn9pS21zLA3Jb2Soh7OgIBffJLPAh/wwYfaWyCSRPfFwibdQqi+IIrxfFdK5nS8XVCFPwT2C74TwNHqswjzijJifTwQ/O0dOjEe/TxKLQPkdzrTWwfYFhGISrkRwM9dOHPT+Lj7GSiHyJTJJgo7TV70WNtemzPbApmv+zKkJCrOnPNUg+Bv8Faka3FZA39Y5LJexwdbboGIce7J2550PZItLiNgDCGbk0OreQ2A8WnOxzIjOSLWMG4JPPxzlvkVYYgjPfY52PwiFLbvMmilQ5LJvDxQlU6YCn6u1jyPK0xswNHOvGs8HlknVc9q9yLPM4ZNt9tsAa27Ch7Z1wDks+YecOiTvebhiRB/8MUCGQCt8MS7xZWpN2QPWgj/pAftc4NAkG9/sZaIYQa236srO2JDqdIq0krXDl3GE/QccpZSXS/jp1NYCEuaHu40F63Gu7y8twN3u+2Iy0rnWlmxlry4EtWmFJzmQ1JR350et2GIG9UE7sZnLJ2V1cXrAEfL6gj3ngvZTylpO1MSVB1yb8TGE7aCjXyUBjGrxKR2KQU0W8xQ2Deahvwo8gwRbZzT7IXH2lQIWV/igJsLc3JB2S3d5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(4744005)(2616005)(26005)(41300700001)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iuP0KNgJHCGu9H+ewq6z89vT9nvc98bQ5Un4u55epL1netARkRDBuww4zyUN?=
 =?us-ascii?Q?lSVY4ZIO3LmQRUhMG9lq+qfFOuiZIpEgC7N52a2/3V1zbuNs+wfyYWMExX+4?=
 =?us-ascii?Q?X6Zccs2GbCdORPzFapoZu6D+Qg462F3ULceQvDpynHu8nU0tV9vjfC/QSCMf?=
 =?us-ascii?Q?uL729SMEG48moZgrAK7I8L7saOjEQv3wlRFKI92lVh3kPz+B+lk3x0mhgJTY?=
 =?us-ascii?Q?ZPXVh8EZydo9qjwjbljUUC4aAnk8/0Z17h7nqLyBf6BoBR2b7RBB1pJQeRxh?=
 =?us-ascii?Q?oIpkZSw7Ej9MMpEr1Fo9MuUrCCFaqh7geTWxCKVGjGDPNE8k8th216/djPbo?=
 =?us-ascii?Q?i6NwpAPH1v3sIZUUwPclj7WUllZ6ZbY98/9lo2URYdCubhaZAa6CLdTzheUL?=
 =?us-ascii?Q?d/12BfxXL1LJkDPzJrkszOQzLxlmjAUVA/7oxXQxWijiIgm1O47i1spQjy7A?=
 =?us-ascii?Q?HLsPOnWEhb/On5mHAxKGQaLx/UvCMttj4X0+FiWmsxpx/GY2Cto5ORnpbeJU?=
 =?us-ascii?Q?OF95ia7LxmFZ3kjXpc35PeA8rbRfGVJ0nJrgMIAOVLYScPif9eQv/mynbipR?=
 =?us-ascii?Q?jYjJ5jLyC4Rj6cIEEMhy/4mb5n/2wQcdm4+HaszSVO1yCXH6K04E3SvkiC+Q?=
 =?us-ascii?Q?w9sDwG9wwGwRpmlffHxrrnF/m3tTBgF+O8CGnjRr3CQwd+fkIcNAwZd4awRT?=
 =?us-ascii?Q?/tcWZs2Eget7ww+VNXiNkkMwe26LhBoIXYJfjoZB+H0hDArIG2WsjWMCZQzw?=
 =?us-ascii?Q?1bjYjmnYijLe57fnK2xK8lQ4SYmEr5JGvtc+N0wAHcO02Ub65i1Nkkwv/F18?=
 =?us-ascii?Q?g3xpHFs0qSXFrLD/VwjKQljH7JFRLdaKU6CZIMd92f2U8zB7LQGMyrUSW+tK?=
 =?us-ascii?Q?2qNPWJu2M64ZBjqGnjyCpbqdes1HFQoDx5YP2eLQh9yLoA+l0SZE9/3+PMvn?=
 =?us-ascii?Q?xad5I1bYGRcF/C9IX1aQ3hW1rCrhvawa8Cqwvq9++Ybn0JEK6Rivh75gwEpD?=
 =?us-ascii?Q?XPWOL1hhN5QDyVHQSksPlWI1NLBO82VRuXUWctcM9fnnbnqx6iHe7ACft3Bj?=
 =?us-ascii?Q?C6FQxn2VZQu+eWnndSK9/J5vO9YL7oj+04vzlm6qWbC9lIf4gVNAsSAi70mj?=
 =?us-ascii?Q?NUSqR79I96vuQ2Z+XTlAM/DEnV9xSSc2MSwKYXEXv6tmLpUO7SzzRssfbgkG?=
 =?us-ascii?Q?qg+JgQ34zQ6hNwjMKGlrpwHEOaVueQaGTlm3zeTUt1H8iHcoVXXj19LKTxp/?=
 =?us-ascii?Q?LWN2tv9CRztXqDoNTm/sTdDueUnXd2llM3qaJkr8UFsyu9MncH8Vsuvx/nzi?=
 =?us-ascii?Q?HOlscH0QppmoHGBLRZm064dqpZ1OMZmczlCEsFvYyptoBJiI6KIApoPrKStd?=
 =?us-ascii?Q?37djfumz8TsZrA7ALhPQBBzff+5KU+0VqPpwHqs/WgvcmRd915q2rYpCf33b?=
 =?us-ascii?Q?3QyR+EU/p+DOZ+HntmAQKdBjh2M87gjuEhqmmIt07xxwcddcOAk6KIcTQKMi?=
 =?us-ascii?Q?xHlt34u45hS6z9vpT5VfIVPDU1q9SN6pvj9N6qPjBr6rI5BGZOXSt3JV73cq?=
 =?us-ascii?Q?11QODz2rkCV/k3fX2OVdMORUphwSmXfm8eP1TArh3yB8bQd+nEzXNB2+BuDj?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b813f3e-2143-4e83-473f-08dab4a352c2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:38.8729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9XfPYOBnYLtEP7JGx0Mi+NdW928hGGEJDuT1eUQhQsU8jzmWhQvQUWNJY5dVtDVDWyVew2v7dM4aH5pGShukYge61QP+RhcK8bJZZPWc2Tw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230018
X-Proofpoint-GUID: KwRJhLxNlKdxQ17sfGFwttcY8YfMkWPN
X-Proofpoint-ORIG-GUID: KwRJhLxNlKdxQ17sfGFwttcY8YfMkWPN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Description from: Martin Wilck <mwilck@suse.com>:

The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
scsi_noretry_cmd()). Packet loss in the fabric can cause spurious timeouts
during SCSI device probing, causing device probing to fail. This has been
observed in FCoE uplink failover tests, for example.

This patch fixes the issue by retrying the INQUIRY up to 3 times (in
practice, we never observed more than a single retry),

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ffdb043bda5f..28d53efc192b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -674,6 +674,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			.allowed = 3,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
+		{
+			.allowed = 1,
+			.result = DID_TIME_OUT << 16,
+		},
 		{},
 	};
 
-- 
2.25.1

