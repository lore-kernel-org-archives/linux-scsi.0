Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FED6C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 22:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiEQWZ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 18:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiEQWZM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 18:25:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF0552B2F
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 15:25:11 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKTuFt012482;
        Tue, 17 May 2022 22:25:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=K10sKvF1Z2pT+NmvyTDNczHpstHlMiLonlmnWg0odeU=;
 b=DoLpqql0Sqq7fx4A+hFtjKhhOzpT7eU1bjcnxPkIgsaxWVcT87CQotRRF/byUIl+Zw5y
 qtQ3ftIEKiVomZV2IVjv7eyrGSv48AwU26ZVK0JlPlc8Gb3u+gVK5GhT9ZQ/oToBosz4
 FPEd/lrrmG2Aag8n7XyM3kLHa3pi84S/wP09WHxaWH0WSTZKeoTUvGLGHx6QHiaVSJIY
 i5ogj44stcAnmUiGCZEgp/0C6ofY3Ae89Q2BG1H19leGCYhe/Xahima70yA5YHsP0WEk
 XAgIiQVKQscqNG/9Ahvmc8T2HmXkzAYBn0yWVPtU2nTnvn7bPpyXdwNBXVtOcjhm08ym og== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytqqv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMP12E008394;
        Tue, 17 May 2022 22:25:02 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3m138-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBPIhJ1tPngpb+8QmRJerDHcSJy/bG1BiHE9VXqLk/u5iVnti9Hc4J3v5pn/UPu1e1kLwKoVy8iSMs9XdkHfdDoMbQTNDrRm+YmAaUz0y3bo4S/bp7TGbmwV6tJRatBTpCgndiiQelS1WF3NPiHt5DT+YDDXwVZpPAuQH9rBMNHYu0JhWrORpya11v7pbDnD8sB4oIkzL+B/98drvBO2Degrop+xeKcOVRWzpIKhr0gncsd+HoLfhZMW6KzoZFqgxV7zYOTFRd362yrM6nq10oPftPUoGK/lfPK5zcMqpcNRjPpWDQfNc/dT6Jmz7mWUZyaG7vnnbXx6/bDJxS92iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K10sKvF1Z2pT+NmvyTDNczHpstHlMiLonlmnWg0odeU=;
 b=gSSyMpNixWlyn2xdNcb9p3WgyXwa1TuD90JzNvlGH/j0iD8BXezpw9YQBoeJfy0NaoDb9Ck6oet+GJe3+xDARPj9wgMXdspn76lYTOGimH/r4eZSMX6cjtc+D4h0oPm5yCdfwYSrn5qXAHUaK3qJV6F4Wz5ZOASP7DbB+k/9Apkq1icO83XcVUq+9SVaAqTeuoxkCEEkc5NxdzsGL+a37H/YaaXK13v8dfd5d089BUEwwrW8P2x4B17RqvvYDmJIdWpSdnqMWPQX2rIIphmiQRSeyTuvQI8GeTcn3ek4+8+4puGGP/+wqW5DAsIYuifmxrgCHBcNzlNbkLstIu34/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K10sKvF1Z2pT+NmvyTDNczHpstHlMiLonlmnWg0odeU=;
 b=BZicvJyHlxbKItW7uFG9J33DG5aUpQTLxShavPpoHGuckYNaNvIAvrByU6kpU8xIQtZUlACSRsd3UKYMb8QqdakjAWV4SjwOACPLXNY6LknVvIA5YGX741x2GBiEGli/Tvrs03qWQ7DDunf3yuHpCv7VGW5sLMDa+Z/f3oeMhqQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 22:25:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 22:25:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/13] scsi: iscsi_tcp: Tell net when there's more data
Date:   Tue, 17 May 2022 17:24:43 -0500
Message-Id: <20220517222448.25612-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517222448.25612-1-michael.christie@oracle.com>
References: <20220517222448.25612-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ed48b78-7359-4360-bfc9-08da38541444
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB55175B281A1EDC0C4B76EFC5F1CE9@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jb53UUjQDwjmZ3BHnq1J6Htz+haQ8AVdOPpML5ydlbAyZSe1yy6ql9hNpqprxGQw7cbxJbUzrzDtgzyaeVAVtcUafBJz7T6WQz8fxyTBxLztWUJH18GyFNG0LWuTIEJ0Y2LXkn0ZPEA7aY8UU+12Y7Wef6//3EiE6YCs4vVoUmOvd4S4vzaqsf9cw9mbPH0Qv7J6VuQ8cvRDMSlrcHeSPUStEOPLVXy5D/spHhH0iwVX0TUL59Fnek4cpvRacg7Ebo51XSg8EZZ2v3tIUu4aXTln5MhYbtif0+/U2mqm5oF60kyI2cIKOmWUV8cjax04PF7Ur5zvy3pNsBJPg9AgrKJ9e6w+Bl/DKNq19oZUc2K3xG2MdsOM5M8Wc71uzgQsHwTlrFLdBitbH1v5UqmN0wzfJjuiaEi5H7wSzO73AZ8mM9h11t+zu86GdKA7MaXH2ALqOvnVOV/cWPXDb3HQurv7Ov90MrSmmXW2w8k8z2DS3pZiuiBvhE/TGfkB1nWnGIxy9400c0bgh2rjRpqui0yacCHoPj33kvX/X4HNgFJ3U5LpYQ8edmdVHGq/Sgfo89eaKNiZCiN78plqOGpjTSb14VJlA6UdH99gRJqs6lAYPdxn5dHcAtTF9NcTN8STBy2kQMRhXIowt3ysi3EMyqjh/b2+Qj3/jal+sjMg/0Q2vqX+Y8AmltRNuyVwN6oMyPulCvUYYUF4vyVsxO9DBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66556008)(4744005)(66476007)(2616005)(8676002)(2906002)(26005)(6512007)(6506007)(1076003)(316002)(6486002)(186003)(83380400001)(8936002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(107886003)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d8FpGnqlZq6Ua3k17HpPkTZh1mJAHeDYRsUQQr0uTn7W6y6NvbOxSB1GB9mQ?=
 =?us-ascii?Q?fnir7rQ/jlkh2/oBos/brYan/5jKqrwHHYqzwYoigC5xzBCdGXHsGyBg5/bU?=
 =?us-ascii?Q?KB6B5I+AkirVFYMQWqzm83+qRXSrWW8RN6Mxwn0REmmMHIANOzr89Jxz0e88?=
 =?us-ascii?Q?m7NfAgH7Qo+xWijl4exfUu9srRYqGRdgl10S5P7hUWBU+h8KTZoQ2AxK4Ycg?=
 =?us-ascii?Q?HwJyCTgX25Gb6xkVt8We/7JuTS4dIy7s/5fbh9vifyVBtt0IrOZiC8lbrxCB?=
 =?us-ascii?Q?DsO4qR2gN7XR4+Qm8s8wb/0CqraLN0bAxYnVyPa++UZJ+ErJRnSoIKn8zKKk?=
 =?us-ascii?Q?2CnionfqsfM3lfV5njUpqwYf9gZL9Kflz8IroGVujiT7Ak0CNcTmNTmKBTzt?=
 =?us-ascii?Q?5ApgHZT/ydD4SNVjCYsIHAwyjqO9PZxsj5t6iKMiy/OsumWhJ/GnDFKjVWfb?=
 =?us-ascii?Q?b5MRLsLkHGiciymtpU82aozlZyzWQ83AuI19txtVuNyOF+sSPwSDdqPPP5hw?=
 =?us-ascii?Q?ooeIsT2dZaPPushuZhIy7pHRaTKtQVBJ4punaYWioIb5LlORvz6cCRQ289ED?=
 =?us-ascii?Q?c4ilgB6pUXePOPNX7BmBo961bh69pL2Yg2EXsI0GtERzr4l046uBrAEcRkH4?=
 =?us-ascii?Q?4PHjtf12X1zOCNnvGFFP+RvXA44xCgZT6jMWZDBFIi8xgz2Qv6E7tdEDHnTp?=
 =?us-ascii?Q?3p9tmvNXO4nJ8yuU243GnIKRGTfETZoS7ATevTPBprQ4UQh0RfEL4c3gqpyf?=
 =?us-ascii?Q?Cz4XH+LxOwOa+qOYdBiTKryTxArWgEXNIrKR4a/2WEN0G3ER6ANuizUA2nkB?=
 =?us-ascii?Q?2hMZqVZ8AabKT8k7ReZzUQUj9kCF/eaSIDNZE9j9c8FJuTd92X9J1h1IFfds?=
 =?us-ascii?Q?25HcrxQygw3TCeF1OG55aALlPVBGGN2SbmeMXvgpJnBRyANm+g0GU1IUCI8i?=
 =?us-ascii?Q?8tFAuFqZZhWjVbARiMwnxIO9k1YRFuFO6ejsGAfyUjtwx5r+XQJ9zwuh5kKP?=
 =?us-ascii?Q?SJErJELn2JzpW8cVHMbUOkde0VM3CS2/qTzJfIZtM4dj4KcUeRFpNp4YI75Z?=
 =?us-ascii?Q?bl3tKEwPCzjMPed7TAHB2BunhRwIUcxIous95Nrh3kvtLAr8IZ7ePO7lvtov?=
 =?us-ascii?Q?lWC/rWlv7/jwARHhYe9lKgA2dbII0eeG9LmZ6ytdjqn+udfgHx5RYk4OECFy?=
 =?us-ascii?Q?9KGqXS+8apmqqWSPRNnjJSCqtlZWQdYiAcWVmw8b923EGMn865DMo1HUK786?=
 =?us-ascii?Q?CKrsM2Tg0DMNUWf8lptQLPltFNuls8eKSNRXNlYeB/nbalhkFrYs+x3U1u5f?=
 =?us-ascii?Q?ne/vAHF1Kl/bHvgSi0ogueRD0nUWw8xy7W56D81V2+LnA3exxArtq8djBcFb?=
 =?us-ascii?Q?HvbEYLnXSxEG04Sk1I8DDvzUxt/jTO2qJb3PeE8zJO/YQ50G8jpdJIudl7LH?=
 =?us-ascii?Q?6w1nK76fgdD0c4AkwyIvTuvBW8ilnd/FHSgzWeFUh6nfZQIYDilMQJ65EiXv?=
 =?us-ascii?Q?+admD2iOQjlnYUB2nj7frWkQMdcv360azbPy/GQ1Svn2PUkl6kyMcIEEgmzx?=
 =?us-ascii?Q?ToIjwcBfnsRwDx6k7imb/shn/nooPF8YpoU4n3/dd6Ys3R+r8k+r02YnCcel?=
 =?us-ascii?Q?itXAi1hyg3okKEMxbv6mx+Ibsdew7s/SA8gABxa6mHgiZAZOiKcnkU6WE9cr?=
 =?us-ascii?Q?oBVboKtHXrOgsMQ/wYjAwOPERuVHKFcZ/hBXEk2oT6b2nZZh0qAnjUvgHuXW?=
 =?us-ascii?Q?OdyafmCZcv/TicfJ9dYRjRPINcUfCFo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed48b78-7359-4360-bfc9-08da38541444
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:24:59.6210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9fVHBtR9CenWFTAXbODPJMIevi/Zm1jQ3XgB1R6ACsViIE9LdaVC4gb70PJ448baEne3udDdhTjp61Dko0+EJ1XY2Ea9wzq3YTc47OzHlKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170130
X-Proofpoint-GUID: JW1xU-bVxi3Nz8lLzmdr3BO0zjbp9Voa
X-Proofpoint-ORIG-GUID: JW1xU-bVxi3Nz8lLzmdr3BO0zjbp9Voa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we have more data set the MSG_SENDPAGE_NOTLAST in case we go down the
sendpage path.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 10d7f2b7dd0e..5e3b59ecf5b0 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -306,7 +306,7 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 		copy = segment->size - offset;
 
 		if (segment->total_copied + segment->size < segment->total_size)
-			flags |= MSG_MORE;
+			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
 
 		if (tcp_sw_conn->queue_recv)
 			flags |= MSG_DONTWAIT;
-- 
2.25.1

