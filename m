Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7589FC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiKDXZk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiKDXY6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A473925C75
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj7CA013354;
        Fri, 4 Nov 2022 23:22:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=It7zWFR4Crwixio/uNBBVNDZjzxAUoXnX9vsoCer7iE=;
 b=NM0UkGAO3+JNU0WEVD7m9WQ57YhdHl7puOYkz1cxX12A1jr3LeKT/OTtnWvQOsxqC+oE
 3rB/F8xsV9Oz3il9uThQhNyXZ849gqKaJzFyMV9srJ2i+Km12DxEexfr1lK06wYKBb0N
 inwe17pPzeNwv2oJmSO/23aG+6Xn34ceoam5MV2cat8zALU7gxa6ekoiRTx3Kl9eqQnL
 B3OOpVsQ7Yi+WiYCD2P5lEF1UzrtRxaQo7WSU+pWDSLKFKe5DINsUksLbmtuhJQ7gW4c
 zCVQYmmgWQk37MEv18ODqBectdXjJmknIAUMb5H2JDN2C/rz93Ij+9VyY5Hrw4c1Obs2 8Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgv2as1m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4K0bo9033104;
        Fri, 4 Nov 2022 23:22:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmq86ge4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0xWnM875WD9d/igJechgR9RPDbpuFwlHqluZV9pcVaGCEteqE8jMJZ/q6FgpsyZ9uow/G7I6VY6G9zcmAjJqqjxjCIB7JD5TPlxbr3TanjTZdQgD1L9ibZ9R72N7gXQ6qNwv3aj3d0avpFXd2JiWIDEM+VFsFoqm/PVywphzOrVeyLRgXGhKSKGCHfEjB99RbrKDqT8uLfgXwZ7qxBCAFfYHuhLyEp0W/zKziIL9kcpXBG4R3CQqD5jx9gDkp3/HSqp01l33hxm7tWmRJcq6LGAaD9kQFyBJu/DdoKmwx8oyD8BqIi0rT7juJhWRJsU47ZcGM2xFIXfUZ7uNFH4qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=It7zWFR4Crwixio/uNBBVNDZjzxAUoXnX9vsoCer7iE=;
 b=hgkslh8etFPp76nF+deeiO+OPfhOXFNA7tinfBatW5vyZZF4dX/NwAqnH3KmmF4s1DbnsY0HXJ6q2OKPUbPPcvezwOr17v3O27M3MAC6fzErJ8WVq0kAN/STZurbMnA6czibkAtDD6FiD1YFBe9mV5uIdA71IBFytCNGQA3q2dzQ/bA2cWHVlSr2Wxkeafr7ZqAbLnz4VX/2gKUEl1oSk0aRgNZpbIH2ihBOZ98hSoLVRUn8gWV0fLmpxSDEawgTXahPp19P3FGEwvrxT1wkaCQXjB1HI8Fdr7uL0l8pY6m2SE0zxG2BaXWiRNHXl6fDqc/1nVd1ZcEJOWlGvfbQLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=It7zWFR4Crwixio/uNBBVNDZjzxAUoXnX9vsoCer7iE=;
 b=UmqeWsSeOiN4Tp/LwZzOjV7RidrRjpbeDYLH1Y13hvJtiK+jjIO0hVLZ+tSfKC9Qf9MIKeU++M90YHjzRFylVxt9MVawuoEFRpvg8JquEWbZFErwmYAbOz7dJQ9ZZ45bonTZ8QoaP1ahJLtl1fRPFFogmZeeDWE8ccQvNBIXDy4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:22:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 31/35] scsi: sd: Have scsi-ml retry read_capacity_10 errors
Date:   Fri,  4 Nov 2022 18:19:23 -0500
Message-Id: <20221104231927.9613-32-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0008.namprd18.prod.outlook.com
 (2603:10b6:610:4f::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 263ff192-31c1-4ef1-ca01-08dabebb6acc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KZ91g+Fkwvk4az9xeXO+ZuDWfaB6k7f+l1RVUou6D88tQgO348xLoN598W1WPaA4xdB6+6g8vXifmVd1FYidlFqbk2pkURbGYGhsHzLW/M1Hi5wHRB7tcMCIclL+CgSV9866yi8ao1xLX2lkOOn4X4r8s37rshFOw+62JP1CzaAx7Ne0EqYbdsKYpFzdnqYLFE9jyu+6POgd9Slckevvk9Sep/BarfO/z5TFzAFN1ito/0X1uxwTmZsDdoz5hNMGfNYYUHVQAtrRpZkFbA8HXplr6pXtuaaeaHHnWpWV3LNhWLIwm31xRIhN00xx9+SI9+3wUsIDbcsXbIm+z96PpgVqJmBNl8cCBzRHfHX1tIjHqiIVBkgHFnuCZSpLyG1c9lEzjbP3Zt9D2rcF1eouOf/vwwmWUNocK0GKPbv7qOzVnK4oPBwTw0DurJJyzdE0ZjQ++1y+wgrN2eTUjCNyGSztiAsIR0kmLn46h5W8exdpISTjpHGVSQDttiNf92oEUmpPhUqdRJuaZ2iQ38QyfxHuChfzLgWqSgUB3gRvZJbdCfpMJOJjBJBap2+l0XxyWuJIe+fHhZfs4Hbe56pcpQR2uQg/4xSnSwmfYjvzyfgldxKKVamjL9NNmENQ8Qay2Kkx5PxuIjM1J3J/m3Q1ef6rmD7Hj3EbdqHJ7jtHYQMYkif++ygFZn7F+67GY/+/wA/1XECe3mjIf0guIRdX2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(86362001)(478600001)(107886003)(8676002)(36756003)(186003)(1076003)(2616005)(4326008)(6512007)(26005)(6506007)(316002)(2906002)(66946007)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zuxuw7YfHuoUGmAqDiS0hymLEGOJApkZpTi9Y3hxGqYd2UhRnmJYOU3h56eA?=
 =?us-ascii?Q?xQ4kcVaLNLGxqvaMmIeO6EgUhr42LG04Y0UDgwAmmKY4jp+muvnXOiooPcoZ?=
 =?us-ascii?Q?8Z9WtZ/hk7zCgmDXAXIR9LMSxyKfeb1Jf/2qV9DGVc8iD+RKuMPTnRV58ljA?=
 =?us-ascii?Q?9Kcq8ORidYQ80YI6IE6YnppnAlROpP7VgSe6BoY+h5aQtyo5OcrVFjKpEPmT?=
 =?us-ascii?Q?lmNmhPUdEBIpg2TJi9NHvYU7FDylk/r7I5IJlwup9JFHhDgit6oSBxhnIuFj?=
 =?us-ascii?Q?+JSI62VfvgWtexSRx3uNv2GvdPzIR1o/e/3b6inP1mSjsh4Y1GUvqwKGJmN/?=
 =?us-ascii?Q?bGXtZMgYpqd4nVxf6iHWHMXrUV7y06nXpLtdWDCcuOZEhui6MJLE0qvAmJdI?=
 =?us-ascii?Q?lBT5B0Yzq8FRd8511mN8TXbgZQm+4AP7lnRBynTgDGA4iIcYvmxzDdN8uotr?=
 =?us-ascii?Q?l9xq53efElh4ze37Qeth5gIK7K/4OoaN9OPQm4MRMVA7ArelIZoIpR5kAQwH?=
 =?us-ascii?Q?JPG5MY2y+d3tLZ2U8wyQFNNaprpnHsYUNslRpxaJSOD35bBxA6FRWQduYAf/?=
 =?us-ascii?Q?lr3kq2uX50ivwYqQNa1sit8PnZt4IwlO1v8XsApB3E0CnypX8mxcFEqwbh5K?=
 =?us-ascii?Q?Kirya7+4BMe7+ZdLIwKxczDADV9Ze3kALw1LgKRg4wZwRb6dRMC1MRFUfsLC?=
 =?us-ascii?Q?rJ22+2hdWGOQvcWzxs3681R5a1GGuZo8D2xEZBMHMAJlSFcS0HOvnEJG+mTy?=
 =?us-ascii?Q?d6QGxAzKucFu+oikA+QO0LbhR/3mLMeX3K4zYZ88EWe8+ohjUsksStAVlcMH?=
 =?us-ascii?Q?oD+YVqfrIytZ7U7zTqbbZuEvf4zjdzmzQusrUKtXHZwjHqk8HN62d0APOB+k?=
 =?us-ascii?Q?ogRhnaH308u8mY1AMCfCWQGl+vgmm0t9S2KFwLknCZAPg4C2s6v4yvrkfUJv?=
 =?us-ascii?Q?kFM4JgZedPMxDv7t5z/0G0H7xLSJn/FvzObgv0Weaq5BW8a+G8QnZsddoLmX?=
 =?us-ascii?Q?Ezm1zZ9J3SGq4U0Csc5hP2Ob9euRFQs7/kIpdp/j3lKWgtND/dAOEC89xuhX?=
 =?us-ascii?Q?p4/x00rSDqJjTgBFFkAMmMKvbwjT6ECWaMvdXoBH0JkrGkP6wN/bdq64u3OD?=
 =?us-ascii?Q?BEO9XH6HPHNkXWmVHL0lWHKsSxlmfZnEdkh2A6I5szDtyq8d9u4tY/62JBQc?=
 =?us-ascii?Q?YVy4yz9EwC/fpiyu8dgGBGQDyi2zjcBGIqj4MKhmW7Y65Q1goVgB7ran86+L?=
 =?us-ascii?Q?6Dj10oAFREOMZeJnliN8PCDSLQQSG7ytTYm5uOSe9uWodQotSGkK8LYbjiou?=
 =?us-ascii?Q?Rlp1RqWWAzMUiT4aFHmk2e1EFgxuFzmuMXPOSWAILsIdTpDeZGaWoLz79lad?=
 =?us-ascii?Q?2EWQG7aWJlpmUvLRoHZbzzsZZfUB4Gzzujk30iwN+b6WlILiwl2IHbP33n/a?=
 =?us-ascii?Q?P73FaDMv3505i3KfsdDDJW70WPVXzCzRmLO9xZwptHrwPfZ6AVTiIsoeNn/W?=
 =?us-ascii?Q?srVtc+spxsBeiMoEhZTVuhFIUElS+5btPEIm20WirtovEmrY8EnDbivNTdrT?=
 =?us-ascii?Q?81Obui3W7jTMDyCMJ2ihJg0dAJSxR63E1C4xVrWTnkrL4RTiChOn7QhtA0Gh?=
 =?us-ascii?Q?sQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 263ff192-31c1-4ef1-ca01-08dabebb6acc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:22:18.7407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4h8p+5L3Ce0/e64OfRYootSCVxtiW7Z3OUK4EmQ2zgd0R2IxbKKA28JTGpJjgdaPzLc85hJUtOV5pkFNqTUKfF6F9N9cVVbESQGyJHEM+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: 43p2uTiwrSO5PEszk_MLbfuw_GgVSHHq
X-Proofpoint-GUID: 43p2uTiwrSO5PEszk_MLbfuw_GgVSHHq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_10 have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 76 ++++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0545fadde8c5..96cf5189dea3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2435,45 +2435,59 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[10] = { READ_CAPACITY };
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	sector_t lba;
 	unsigned sector_size;
+	struct scsi_failure failures[] = {
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Any other error not listed above retry */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset(&cmd[1], 0, 9);
-		memset(buffer, 0, 8);
-
-		the_result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdp,
-						.cmd = cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = buffer,
-						.buf_len = 8,
-						.sshdr = &sshdr,
-						.timeout = SD_TIMEOUT,
-						.retries = sdkp->max_retries }));
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
+	memset(buffer, 0, 8);
 
-		if (the_result > 0) {
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	the_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = 8,
+					.sshdr = &sshdr,
+					.timeout = SD_TIMEOUT,
+					.retries = sdkp->max_retries,
+					.failures = failures }));
 
-	} while (the_result && retries);
+	if (media_not_present(sdkp, &sshdr))
+		return -ENODEV;
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
-- 
2.25.1

