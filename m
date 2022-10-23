Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F92C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiJWDKA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiJWDJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:09:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDFC74DF0
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:07:41 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKvujD001390;
        Sun, 23 Oct 2022 03:05:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=bv2QDst3SvZ9Om5sDv86682KKPj3G+AqO8+l3f6Ty5k=;
 b=CURP3F7qUGy3iguXoadcb/Yu67lzwYHvsAOInDVBne37li+hLn6fCeIcKas4Uxp70wxO
 hA7qLtevNJCrT2Urs0WmyIJNkwxLrTFCeUovZTgNJbNTILj+E3CgLohTHRGhA4i/cYwv
 UWSIfygciOU6vIbY7iU7sfc4+oj3rDeKE3ujzId3bq/CMgfW9y9LEuOEzfQLv5v88VQh
 VT+zo4BlWu+G6qGjcW59ilnrAlmCcZztsw9dRrVVggLV+cOcJcE0cjSLhhbr6Tft7JFE
 fDO1TgiVz6HFgYHgEpaNXfgsUkaHJVOQaQWPa1tUnYn1PUteMmAI9xd+q2Jn+fmMf4Yl /Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8db95nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:05:29 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MJW0fc032103;
        Sun, 23 Oct 2022 03:05:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y30aud-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:05:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFb/QlP+eXWTEkTScw6skpmApFdEDwe8WLLRi/ENkZGxrPyzQFoZdqSr5l/vbPvcTw/5rBS3KdKRHUD0c9bSaUbdFOdqNsiT+/51KKdYXkNAE4228WXdYJbmHm/RT0tyX6sMWXn7vmZk+yhn+21Cb4Df+uhTCVHejGzOserS72nMfYFdZZZ4LCXQn8+3glDmDKZ6cc1pmsHl+1SxeS4vZFJbvtHpQqHeSO9C6oeq5uVxcpnXNgkBelW4l7qYXXG8K8sn8GBVoUpcG7wBHVMhi9nyWjnQlL/SO8FW6A4znWDvEdtf3c3O3+XP5qZxpRbrryE/iBw/+c3ySMJ9UP4DVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bv2QDst3SvZ9Om5sDv86682KKPj3G+AqO8+l3f6Ty5k=;
 b=JKaGF+5UaUmQoGULUsjZ1tepsrlrGy3EYnzL97W5kNtzOrP59IMtbeo8t6VogxB+VB1M1t4P6k+I5I/fkp9n76WPXcbaWC1Kzw1GQ9LeAcmRsAIX3ebjDMwLq73IpiITIOdPXOVQIDg3MOrTnV2WO9rVMf3rJxZLX1Trdtn7HDjqvy3sZwzmvoxbMYKCZv4iwQDPe67sHa9M3DGGmtnvH7kEKjc9HuEVR26QoMUvN+uG8mi+CKUMHyOlle4ugQG2xgb8ywFmKajEikFeUovSlrg5R8gyUjWqGJdP73xQvkneKNQxwDXzeT8MR5kJk70GSmQ3gOFMUfwvLlHtiCKqEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bv2QDst3SvZ9Om5sDv86682KKPj3G+AqO8+l3f6Ty5k=;
 b=sCI4vJwCLKfkgsbSLZ5he1XQfbel4Rzl3KPhA0Y5uA1mK8XoVrEy8ckAHXQbfMXdLockmf+wz6eQXMuDd8TUwcZ/hn9elyqFXpqlKysI4L8bCFbDDQjDOiItgx+WBWAsQdDdV0JFmTPZKA1fBf4xjwOHj4OyRzg7uKGCEGg1LdA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:05:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:05:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 33/35] scsi: ses: Have scsi-ml retry scsi_exec_req errors
Date:   Sat, 22 Oct 2022 22:04:01 -0500
Message-Id: <20221023030403.33845-34-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0021.namprd15.prod.outlook.com
 (2603:10b6:610:51::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a7de117-a906-41d9-8c0d-08dab4a35ed1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o+NRyLWnvyQZq7iXeJEc4kI7p2kxCfP5FQrZS0QeR3isOcRgO8+0lpnrsnEZYDyqRv6Rt4GlGqLgYA4UiQGkxqK533cJkVb4OYAsM8dKr8FoLieFjOmzzYkWnk63BBJLR1UbIdx4wys25SD0Tu5i/zkVbn8XEgjwfJBzUkSKv7o2y6g591oO3mqu0LLZcN2TojYuWmW8ldI6E7ZRCEgOaLaPqtMHKDwtWQ0yHYUr7PPRltBXb4iGwnuf/0OvNoLrdVGaeiUxaQ+0Lx1f4VDA9jAwI0frbzvs0VZhinm8LZDIBwvpjVAFH6WXrPvUlTkblrTpXuIH/vdVR5fHv6pjeKxypeBoidPP9ap9/N95l5odq4qmk4OadHkktHEIegpFhoWzWfXUsWbXISkPPSa6inBlyUoo9viEYHNa3w7ql9SQtCIce5Izq0uNw7xL6pTQRg8j/FtWSbuXrw5ulPDf1utaREWmKbXtHh1kNEMVQ2rKlDR9Aowx9XYPKTJbaspgATf2einfAjeWRkWPOBF3BctVVsZGiR74lsqweP7BEP+kHZ/N65raz4Q1x4G6Nx7/JG1nszK3lrhyRW+KCyiX5230fWpaj8ZaMI+4/2qzEDnBnZokuTTk+nqB/KZOV5I435tjKAolN92/3AXDPFWnnuonS3xX3+is55K/yzPjpeDH/JihfGEghFGCpTIk6j8ZDPBASFF1lf3Q5plO9ECS2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sPNWBPLBqTp5m4n6MY/Fc/KdoOlaElZDUeiUP7fVrWDIQgU7MRkhfr0dew5I?=
 =?us-ascii?Q?1kMzn/o7uqnxf1y696tdiM2qMZTQpYxEmHlin+IbP9KngwJpg5Bnt3gb0Tb+?=
 =?us-ascii?Q?nrwgUurwTs2d/2X36RGvAB8UuLJ3Br8iDE7zzVBJj623MeiRjHOAEBUwcbE/?=
 =?us-ascii?Q?tX2zOQopWrmNKP8HVuu5jnl4LyMyxsfCwWhgYnrep1gKJIRW7+l7exu0EH1l?=
 =?us-ascii?Q?xCMUY/2Qt3MW03Zti5hCcqVXGrv8uQmsbvpWP/zySppJKkA8G1wAW3WUzif0?=
 =?us-ascii?Q?QSi3GhTo0LWOa4JQZVz5aQFUZUjTjieXzJ9WJfcgsFDZNzya9Lk014CywPqa?=
 =?us-ascii?Q?R9RO2uxZTQmxcAzRjuM1xfwX/kzLYNBeoMZumwve94aoi1MUjcsaxp/nnqPY?=
 =?us-ascii?Q?m+2cdeSWwpnrII+Qx4t3ATKrqBXITP+yL6T5a7JaFvOWVGawjf7uFDFO/QFM?=
 =?us-ascii?Q?Qd3zwIDB47dUjL/JbWTm7aoE5cQNgrfxAKzVAYe8HYXKR6ga41jyP5gz7D0f?=
 =?us-ascii?Q?5hyRoRUZRc6o2FbumHmlDnQWeYWznJ7FRBn2ST21E1iZs0kRFbqrtORjCVh2?=
 =?us-ascii?Q?6FaUVsKHSME9m6m4ZKLzKkhwvKX4xXrAxMmVv2ftuzYZBqlKOMPV6ZnhPMv+?=
 =?us-ascii?Q?6d6zE5lgde5QnM/IUCJmFSUpujHGKllgQsAHkJsYT2qef6XOxA0b9/Qthxzc?=
 =?us-ascii?Q?koNPaqJIPHGqlrd4zYyx3hkyDiENX6ZO8huG9hq2dYzW94/FSQHpKPBkjcT5?=
 =?us-ascii?Q?priDGGlmw4T7edAqc/3ks6PeLEZ7LTtZi1hsYSbY/Vlw6V3hJBXCgIpg7GLw?=
 =?us-ascii?Q?mVF79YJokYvV+mvX5XWE+Xh17NRjcO0XFgknBJ+vLa+TSelcBDHqfTWIHdVI?=
 =?us-ascii?Q?JDpO8vKOmNIN/cM8rS6z+ULwEfTC/P59U25xIKtVAiHxGq8y8UveE0phSgKf?=
 =?us-ascii?Q?Ht2yjJQ3PpSikmUlONIHnjxmtEaoe21CayqFgRZ64KaBmxgCBnFHkjHy7IF4?=
 =?us-ascii?Q?n/Z0LkQVyt+mCYjwtfN29sjZEp5qUig9GiBHb0y6RG5MJKYMD+8PFgS5/HOp?=
 =?us-ascii?Q?PquzRgcvtLQT2oRTw1HiJa5OPhPa5+3rk35J+8Jam4n+8u9aXXOPd/VuzgQp?=
 =?us-ascii?Q?mZPgoyJnlBKstON85SGnRdUujMOMky2ONr+QfqDTtNb0BrqXsQ/tuDxx/Dg6?=
 =?us-ascii?Q?KnVX6cW6GC3OLTLiHQRcLXpBEhuvyW1vmzWE2kdqfF0eqNviQkYuX4naUtBM?=
 =?us-ascii?Q?9g3AQS9KuCqUhNCjq3WO72gcK8wDz+SHdlno7b2vjjfIHkJ8KHsO+pOL+n9q?=
 =?us-ascii?Q?FpaWJ/Z2Ykk+whsfJxZl3ahNvx+My/ev3Kcf9nvaumz+0K+pS5EBI6oGMgkw?=
 =?us-ascii?Q?h3seVqEqg0gt1mNNVertU2Rw9HmzLTPmS35Aox393bkgp2AZHmqrFM22/rXm?=
 =?us-ascii?Q?X+eUjMxFuvleuDzE+9n04LKghKdkP+7WxRuaZeVwBjmhZkQsNWJ257lIbtV1?=
 =?us-ascii?Q?bQ3tHUsf3fOGJodwtJpGJDS1zHR9BpNFj7DzNlS7tHUGaWjwocZ+GUi1/CGK?=
 =?us-ascii?Q?11XhclDR1MkVYBLht6i2wDlAiWCCrBIRqOcRfRLi2U1zDivqMKSllt6rEhTD?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a7de117-a906-41d9-8c0d-08dab4a35ed1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:59.1681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GeIRfETez4TFHUBhvnBQLUKVoNKPNDcaUF8NCTSs8ZTfaFsJlNXEdIS00hXa9u2siNG/UAqAUIWAPQwSriGlX11LedHR46BRmGHljQ5nIM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230018
X-Proofpoint-ORIG-GUID: O3JJHfQI9K_k-hf7TzfSIuX2Ux8J8xKE
X-Proofpoint-GUID: O3JJHfQI9K_k-hf7TzfSIuX2Ux8J8xKE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ses have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/ses.c | 84 ++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c90722aa552c..d8b31c0b0125 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,23 +87,33 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
-	unsigned int retries = SES_RETRIES;
-	struct scsi_sense_hdr sshdr;
-
-	do {
-		ret = scsi_exec_req(((struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cmd,
-					.data_dir = DMA_FROM_DEVICE,
-					.buf = buf,
-					.buf_len = bufflen,
-					.sshdr = &sshdr,
-					.timeout = SES_TIMEOUT,
-					.retries = 1 }));
-	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buf,
+				.buf_len = bufflen,
+				.timeout = SES_TIMEOUT,
+				.retries = 1,
+				.failures = failures }));
 	if (unlikely(ret))
 		return ret;
 
@@ -135,23 +145,33 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
-	struct scsi_sense_hdr sshdr;
-	unsigned int retries = SES_RETRIES;
-
-	do {
-		result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdev,
-						.cmd = cmd,
-						.data_dir = DMA_TO_DEVICE,
-						.buf = buf,
-						.buf_len = bufflen,
-						.sshdr = &sshdr,
-						.timeout = SES_TIMEOUT,
-						.retries = 1 }));
-	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = buf,
+					.buf_len = bufflen,
+					.timeout = SES_TIMEOUT,
+					.retries = 1,
+					.failures = failures }));
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.25.1

