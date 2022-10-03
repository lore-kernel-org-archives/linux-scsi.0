Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B1EAC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiJCR5c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiJCR5I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:57:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97143FA27
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:56:09 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOJiB014340;
        Mon, 3 Oct 2022 17:53:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=b0U1oImN5LFDNG6yM4xWNPykdCqsQiSkC6ivTxDFbd4=;
 b=XQv3/y0gqT21cVasZSVG6w4Tv3riYi2OGhAbIYHQw91nQ4cQzwyxC87zpLx7ZPXbYHZX
 cO1fn0cEoIdxE0pkcI2D50Q0i68Tu5hPac5Voj2c9vqRIJTZrGbx7SytKndPtGcjsKt5
 3qsAGQIT9vt0Tjr5zjieRyA+Cw0hSwVxLb9yE+LvkF3F/r2iNqMVyAkfLBygoMb/HVDx
 8XTdURQ5Ng+4lT4cWkE+WTIU0ndQaZhT9bey1s/ZAMpFMEKBtrGH0E48EsZym5EGwbNi
 ALf0w+Fmcd/90RMlt8aKDNeQDvT1pbWKk2gf6bJ1EunDYkcYRSpgPE0IVWkjOmb/P8Uk HA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc51vj32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:58 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293HSotM030286;
        Mon, 3 Oct 2022 17:53:57 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09rj2n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tl8JAtnJ+OYIp5+VvazFkDPyYUCANcOP8e0/xE2nG1uviNUkG2UUqYLCoTsUFDpq9vu9MZTcDarzXtBsuoN4lBtN0l0zSC4HOQ7wE62C4JxPWup4erVsbd6+pFznMxhRyRFxJMc3zjczMot72V3Gp4g2X92DWqj8xmA/eQK22PoExOB7HiPq1cZfAiJkQPhIYMzlhAr95yIVp3m1ef0rsrzsntxEFj9dH806U+BBrBAGvpntqtUvl17NhyaGBouDU4fDTNMuscSrZ089MiTrcaxLp2XH5uSyy9sy0kEjWeu4/6yHwCTxCADqxd21jia+Fq5Xl4YBxLwk1KT8auP2Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0U1oImN5LFDNG6yM4xWNPykdCqsQiSkC6ivTxDFbd4=;
 b=c5RiF1xUBtUWeZHgBCPdaVc/qudU7+XCNkWhOK8YShFDw+tnebhwhSun6EKdGZmqMhA9A+D/ALqzPC0NkhNtB1J8VbCfe6r0YJo7lLlrV/n2MDCqxWUWqEke381KQEY1N3bLt/pKnq5UHmf6oujtWjUHr9k/7LDZ5RQe2stZJJh7/nqN7FBP/7CZk0lzZZ/uQk6dn6A7+0QANnGmi3chh5yo8bvANpW7DsM2bTDQpF74Wog0KrxHqdRNOLCEmXsvmskZp6DtNzfR9E4sn2xmSPrMw2qXcTdxHJrD4sq7WwXtkq3x9vBwjpSd2zfKqYrC+sJTWA+7iJW1uf+gBqvL2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0U1oImN5LFDNG6yM4xWNPykdCqsQiSkC6ivTxDFbd4=;
 b=zVbm9B06krWP4sPcs8WqZ0dypckUljdLQE44DOMEyc8X4Dq4b3Vo43KiTNLm5Pbv9shSi2L7fPfnHj5+1Wj4D3nLWlIc+Y7qFi31KXtG5wRLhAwTg+8zR1+5AgRX6RHnn5QkpQMVjeJIr2GS1wuoXXVmYJlzoIQhjTYvuGyXnPc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:55 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 21/35] scsi: retry INQUIRY after timeout
Date:   Mon,  3 Oct 2022 12:53:07 -0500
Message-Id: <20221003175321.8040-22-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0224.namprd03.prod.outlook.com
 (2603:10b6:610:e7::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: dc32acf6-c75c-4986-cc50-08daa5683da0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: msjKEYvnmAGdb6LbX51xU4bPWeeCzcSr36Q7gEZZWYUKDDe49aDhaKlG6JXDYOBOMwcu+JxSvNDCtCEUOKa0EFbAUnftjXvUvj+JxPgyuxwkQcPKYYIxa7878o/WZ6AOH2GcotONi9DwISAphnXDjhkhQ4UvDilaB0okPXPRr4Bs+QM02F6/5zaQyOCBqlEM6sNxug710K3u+xA3Z4Js64nHfIWe32i6PXbaP9Q4o7cJWu6vktbskWLweEH7WYVYbq85I4cEE5e6f1YEXWciOaKmvbhP+DaleiuJBo+2mxrowqY6rNKoEBj8Rjrladtmr7XY19khaPWsehamhuuAqEn6B51F/HAhoy4LY/lbrCO/6YT0fGhW0/uUoMEVIdMo+KSD+vmaQBFujJzctazl9fgqmuvF+LX4jHy4XJuDEE6Kyu2J5jCNGNttGrCHvG115v2mvzm7OTbrvsPrrcuwf9iQ5aJFKMSfO+l8lYLrXtxdYBE2V9E3PX6pmElEbiZVzhH141GSxYIrICcVpOVKtmDmCVEORrRZ/+fHLBtMlXp98F7leMkPk9ERORvkWo/nMPZwRFPDbgZmOd050H0uz9gPywaSdWfUFSyNpurUGZ9QJr+fX/4LBcH1PQwPp3p7fhVdaBzTiQzAIF0OI3sCHibkRTVPAY88iYTSPVGqZEttrGbNEMIcs5Bjk+DyfoyjF2NtGQ/qJmVXEwTHyrKC2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(4744005)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(6666004)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2A12Yit8CjH43mQJTC58v44GSAWCtWAGAXn9BS1iR4KkYgG/qTEq0enVrxZW?=
 =?us-ascii?Q?/HGMcFPqhIhRH6IWnBiOpn6BkqgnE0ag26NIs9TgWs5xxiAq3EhSGgEJdgvQ?=
 =?us-ascii?Q?6TrVttJNP8+6vK4HSyZbKA7k4xBeN0xF1fOHqb55PNzFCdnpbYum/M13pHSf?=
 =?us-ascii?Q?EaSTvlwoiexKSyw4nKPn4ovA4p376nn0nBdsCmd/Zvc/shEvD3yt17sG4t5A?=
 =?us-ascii?Q?jGjTQB7JXW9HKh3+kiHCWWW0NHPLleEyAoKxWNXzwbXjrC0e6QVZd5aiQGSR?=
 =?us-ascii?Q?1sZz5obvc5idDy7F5J1+2pj/J23sXtFpvGzOc94x2AD9eKxdGguv+X1gltvC?=
 =?us-ascii?Q?Wc+Th7/OcZb8yp5xK7V7hiSrcwS1FdfWJIOZ3+m1wxTAFfhmOt3MZEPMjtwW?=
 =?us-ascii?Q?0o/odRELYD7KDQmtX1ZRhgUimlh+yP6RURrdX5uzmEMgfqGGZJp5zd2mgkRR?=
 =?us-ascii?Q?+RcIaNI5jwbhl2UDW46ETwz8lAT2tCTLHOEN8vxPBzconGuISGhXd1w2xGzJ?=
 =?us-ascii?Q?BpuM97Xyaz/IrJV1zoCWaDIwVgRxQ1L8X53djA5f6xnUgOjUK6SnTN5vkKuV?=
 =?us-ascii?Q?o/IVOliLSU8UvmT4D2IdA+spbEpN2Mx6uXQJGbd9AzpnIvNUAQ9OSn/TR/PD?=
 =?us-ascii?Q?P6drqEXki7qy7RUMwCyu/sinc8Nz3ZV0sr+jg7zdPbc8eMkuTnh3gvsoHZTW?=
 =?us-ascii?Q?LMiBI0A0kZfiMUNaJwxnamfVKoJ2S5mxRx7+0UdROyz8j4wXYCdS7q3C+fiI?=
 =?us-ascii?Q?5JIqGvRqBUZPXn4AnYnfDkKCXS8L0QidKyBAwfwGJYBR825ZzFxVg5xUTO05?=
 =?us-ascii?Q?Pb9LtBWeCDoGgCUAaLSXXCKpt0sBpi0D5U8o+mrbct9B6xUWQNW2Rhsk6zon?=
 =?us-ascii?Q?4jdMg3oRIfnHaixvS3YVCs28My5rpoGAoQsoUE3X/K3EYiUr53WBRyve0oCI?=
 =?us-ascii?Q?E/Ol0ojNXo+cmw+dQEXrmQH66a2gFNvmYUKOCC7noyUsqAWKfJw5fTKDnA8l?=
 =?us-ascii?Q?lfbhEon8A+L1wia2F67SOUSz12/txYxEYyMjzbgkcfpVdS0zHrS+KBzqdw0T?=
 =?us-ascii?Q?mK0RckpIS1CAljss3hr4n9ztSIIdYDL6YFnBf5slMHA3DNDfPG28lWE+yfMq?=
 =?us-ascii?Q?y1BpTBa22YP1jETRdW1QifL1iBJHip2G7jGpoyDSOVXGGgiwLgSN6Uq7juZl?=
 =?us-ascii?Q?LOS+umEq6jiM20nzEBz7d30qPrYr+7Nr58b0GhnUHCD0CyuGBj8BYAU5SRj7?=
 =?us-ascii?Q?DYbwRNhsfVAIVEbxWY8rETUjJuXIBCby626MIgc6y/9l6oA0wmd14OjuzeJS?=
 =?us-ascii?Q?h94NouCI5sfQhjz6Vzznp6BDu+7sVjIV61XWplkLZlY/yFUoB1gAL70uGG+5?=
 =?us-ascii?Q?8msq5r4aDQMhmb1MhNnfCP63h2+Iu7ocZZ8FmJV7Y0lgW0KI+/FZw1Ifau3i?=
 =?us-ascii?Q?4kMOjhGNdoHQlLSeRjhIM4Y+CKjlieBSxS7LMASeYLb65QVYUldLjWckDE5y?=
 =?us-ascii?Q?tIl7y0sjUonaTXCn42BeAY0xy75vHhJSU0E3gSGmOP91eqKn4cjE8ZRHOVpL?=
 =?us-ascii?Q?7fcQVI6PcYu21o1BBgBkl2RE6x5admNOWeEHLEEwKBFG2aRVjlw/2eJKguDf?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc32acf6-c75c-4986-cc50-08daa5683da0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:55.6882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ht662AblJfqTu7gsO4QamcZ17qj9iVzf3H4PIpl9GxTnGkYzp97dW+7tT+gG1V2QHGGzPPRHJfTCkaOlj0B1kIp64SxW/rOqZL5VjRhGW2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: f5GWT83mBKbLgTXEdrPC1H67bQDFvjAZ
X-Proofpoint-ORIG-GUID: f5GWT83mBKbLgTXEdrPC1H67bQDFvjAZ
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
index 83f33b215e4c..c45646da6c71 100644
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

