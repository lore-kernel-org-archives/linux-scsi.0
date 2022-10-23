Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4B9C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiJWDJ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiJWDJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:09:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA8774DEF
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:07:41 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKulHK017954;
        Sun, 23 Oct 2022 03:05:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=7qvoNDFMae1B9HAqFmNS0eFjffE6FFjbKNa2a64ShMk=;
 b=GEm1cXovp9qM7J1HAcwUsxo0TI90BRH5B50+viFdJwZPmDGwfTFggulkfqS6WzH+RWfS
 iQOTFIzUzjJ4yyUtoTXmI4/g1JmGYjIUhZbu4mEZIH7RAFa3KoWyrQTfXswDPnlAdc7M
 wOTgfoV2NEO3zdCENCv8YaLkaFQJlVBxdSBKp9OEwZK24w4RGrVU2jPCUjlqN4ycr6gf
 eC/GFKCzAWL9dtPlb1+Ma1VR9HGsMMsjtvq/P2mrquU4uUu5qw7QuLq3vUC3nohyBurL
 o3C80CkzytJxkYDsywKbcNFoTHstbqQ44kX+P2c/m9x75i5dtJ4OonETzstU4mLcCOpq ug== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc93918jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:05:29 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MJW0fe032103;
        Sun, 23 Oct 2022 03:05:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y30aud-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:05:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4oh342T5hc/pVHPJFFRie1pK0Fgf4Cdgp6c2gYSU82e8M34ZoSRNRsz/GcqnqXYytgSFXL3EMHh4mzoFSmW9cpGiw8AAzEqkUT/Vne5bLOrHTWV7jlXxArJm7LMtdYKDQ4dnXuU/r50l/z2yGWnNhyWog7AeOvKNrssNuZ7+vqESlS87FnfdVNYrgoUB41O0iGLFCoxcQv6nOmyI0eQq4TRgvYJ79qwH4w7wD8D+7Yg/nqHSHAK3EtiKweBsI6Qs0ZjfelTIjbA886HLkkbViDnvEF6id+uD/tEg1pIJ2dvlp6+bL2SDM76ChFD40SD8wgYRrAZH3MED1EsBD6+yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qvoNDFMae1B9HAqFmNS0eFjffE6FFjbKNa2a64ShMk=;
 b=A9wj9/RF/MV4YPSZS0Au08tVT/o6mLLHrhAgBhD/yj15CbpLXqG0fEV0g/EiKEhpF7R73RhDr+nh9g4jjZ9TloWYkcFQy2LJohhyOEQKH9UBQ1fWAv02p0setrpDJkAtnHgDQPPALSllwpNdq4bYLamnMH6jD4dLEZjyb2FoMrlQtcc2dnJdmoqG+9f0Gd9ay6e7ey17vpMYN8pYGkEtgqH7DMCRf8VDL0hadq4+elfH4ZpH78IixBRxuMFT6E7Td5ZFnolThXG32JmYYksUD/LpzyeQHl2lECKG0eClUljk2YzEZ7fnMwSEVb2GxPA9oIqbCIOye+m98dvzKIZyaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qvoNDFMae1B9HAqFmNS0eFjffE6FFjbKNa2a64ShMk=;
 b=eNx+wMDNH2+5h9NS+oxfvmAvmxvjj6VPxdjK8jrbl7jgClD3atCQuXvzjzNcTVkOPKttG1G82XFXfDRDz9NHzAZopNHlSzcFCRa7e/gYxUs+FmlDobGdGhFxa/Ds38fg0C8QTkP9kHcbKdEU4LWUBDq4k5yZ6zjECsv6riXOEeo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:05:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:05:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 34/35] scsi: sr: Have scsi-ml retry get_sectorsize errors
Date:   Sat, 22 Oct 2022 22:04:02 -0500
Message-Id: <20221023030403.33845-35-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5879230b-eaf0-4ac0-7d8c-08dab4a35faa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UPbgck7nP0H1QoUDRvcs3Jl7ef4B/8r+VFjX4Hlt+r8J9D4oNgRPUfY0mk1A/Kz1yBt5F25uyhIbvn8hzuPOcTTseAFK55RXaaOUr6ha46v3UsLU1oLuwGzIIFiU+Uobh8lOLqTZmyt8l+5l5DyyLq6S3vyk1Yj4IX3dloh9/+n2vp1FY56U1S0U6CoF882xbcqIPhIFHUch4ceBDv4GzFcKN7cfhFCYYWuPkLBUAKn+7Zn6ohqiHgHAPlkeD61Aul6eCJnFNcLcd/hCqfPHQ9bZ0Hy6MZPKEe6E3i6zSn0tfeF/yfh5ttoQmDh69ZVP7LHfAVqDZK3PYx+bpyT7S1BYewIpuq5dhmamxdT1o1HuzlySRh5mvzh/lBJgtgdR+WhmzT60OBjPfqr07YwBDyPvs3VlCZQS7uZ0a9z9vRbs8SvqN0ZUycGKgy5paZuS/bysObOklKCZzztnkRNjSo8tY2Onogj3lpm6NWEq+//bUFeJ0WX7I7U7pcvBM0wJBfN0JLf5Ya8HdGVUIbrmc0/+E16G4TBH0NttZD35v9NyUj9ecHlWtG/Rz5xZYGoA2MMG/8zm3KYUa+DAROpYcw5XFW5ugqgZ23Rhl54POHxHt5CidTrEViJu3foYXgK+4CpiJ3aomQmnmmOgfyEhX8mezM5u/vrd2P5nl2DtAHsqIZxwJRW1rhUsupfSwVVBfoUUtjs7b0lL3xh8KCT7eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7ZzNuNEcoy9yz29ZZlsRgngytDnWJRLqr1t1zq5QBmk5Nd52ONxvByiNmi43?=
 =?us-ascii?Q?/k3UzgmANbpmp7SFRzMNjJruDMVvm4upL3/ttt0bUBYVIN5wuC0OsJcufbx0?=
 =?us-ascii?Q?Gz4MmMrtrN2o5dxI7GCGYhu1Flo52P5VK9e54k7J3zzFJcGZmg7560f6woCr?=
 =?us-ascii?Q?k0ziHGFo4J90cSYE8ycJ5ViM0nCqKdv4L6DKcoltrycFQNq9IJ+Lrlfd+dTa?=
 =?us-ascii?Q?EdNlRSCnMBa1I3cqOCyuqUrYmgFpnW5xMEj2TRbfD+vuyfh+O9orVDBryFok?=
 =?us-ascii?Q?JmNBDn8i/Grd5WCiDjzRXpS5Md+u6L5pod/ErmzlC1cAeGZzj2Agyc6QEdGd?=
 =?us-ascii?Q?KxebPtUkMr7aD8Yec7u+ZKpE9VCuCmgQLahtE2sXNlwdIvj259i5JFGWklrL?=
 =?us-ascii?Q?cM4gi1plipIgmIAivuU47xcYB7CKzhw/t9i6bWXOqlZEsKJKh8pAEZXBV6uA?=
 =?us-ascii?Q?QocIpGFUIIwb7xyxbJJQn+udBbhX2SqJJYsHIIzRGh96c/ZDDnvYWpRkTXHA?=
 =?us-ascii?Q?eFW6iPCGe22MbASD8M4kJcOC4ZHdH+BOEMF+5kw8jXznBHEKjq6cCtVE6oBN?=
 =?us-ascii?Q?6FyonFGCTq2WyNdfNyE9V075NY+ABKZZ2CkCEGTmZ0WDHd/8F0VbS+/072E8?=
 =?us-ascii?Q?OvSSxSdc/vBaFFFuG1eXalWFWh5SvGkfN+1u5PfwtKF7uk3jHLVaLBFJWZY7?=
 =?us-ascii?Q?EYKLKaHLoXvH21uj1XxMPidqx5Or9VsBKFka4ZhdLzAmww+023zuZRcdEbbe?=
 =?us-ascii?Q?G2mu12KjVrY8fYSUQaxMcWZFFPF4w4CWMX7ZBU1ulrXE/v/dPBjc1346Be4A?=
 =?us-ascii?Q?YOtIoHOjK8GtodsWmqaLlseVsF76jrV1TlRw+LVTr4hmtdF4gonbO8a1uuAn?=
 =?us-ascii?Q?r2hI48RZfvPMa924GTUbDaRzU85y6ZENHPZ5L4u/g5msJ/ogZiVb9ycEkNWL?=
 =?us-ascii?Q?IKyejJFUtjm9DIMeXaQB/NnkfOCGOdXxuqlxzcCv5xtxqJtXmeyOc7BBlQ2T?=
 =?us-ascii?Q?dFTZCgcNotBOazqzT/TWC9ndFM6a9hhxEjWqjCDkjVz+qycGjOdBZEoJMj5X?=
 =?us-ascii?Q?4EAA1E+TEzccepI14fIE8cl1roQl895Ed6ommOP5XcmfG7AntvgIh9xzO/+w?=
 =?us-ascii?Q?oVSFykjwQIUQQQvUgiNhwMg87Pi9IA3+bgg6FFbCVYMY95GxKJWTP6lLar/v?=
 =?us-ascii?Q?/QDhSLHChYedGOD2kzpTiPwlNqnLX981xMM51gBPcRGZHS/6JqwlqEdDqtA/?=
 =?us-ascii?Q?3x1SjMrHMqx+faK6dV6kC1qA2lYCd7fkaNt42ibeDNoM1u6oXjSD8Xho5o7n?=
 =?us-ascii?Q?U0TnP0FNCzf+7Wmjo1ChSclSYKOO6lt+WmVqRGKbzPIsww4LnAFbd1xAjVlG?=
 =?us-ascii?Q?TREXFA5d3eJ0K9W2sVygr/AiQsdb1RpScVAJC445GldudX+v8cKrnxLkmZTm?=
 =?us-ascii?Q?zDRVvjVXUHyaG2HHDWcZCnMhK6brKHYRhG/SIt4jTFQeXsaHGmYodsyzpib7?=
 =?us-ascii?Q?8XrARZy7X90hGR1D0YRAahJRoWWYC/xAHv3jAFUCfWi1OBV2A9/o7zhxg8eC?=
 =?us-ascii?Q?Cytly8M3zeaAfTaCXpsP5fH/5jwq6tPMECFUehjnbUZ3U0BMpjVMoX8PchqY?=
 =?us-ascii?Q?nA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5879230b-eaf0-4ac0-7d8c-08dab4a35faa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:05:00.6524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0m84v4iGbyWTK/QLld0vm11XVcUDyDdFTjAY5ZFKXYJb6UJk1ElExsUso96ykLsgv3regpmh3x0QG0Dfb66iXIBFl3UxjOIJdHBSjrMwfvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230018
X-Proofpoint-GUID: 8nnPb5SZXpYZiljng0UB1tgDY9nkyLH5
X-Proofpoint-ORIG-GUID: 8nnPb5SZXpYZiljng0UB1tgDY9nkyLH5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has get_sectorsize have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sr.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e3171f040fe1..44f1b62a230d 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -725,32 +725,31 @@ static int sr_probe(struct device *dev)
 
 static void get_sectorsize(struct scsi_cd *cd)
 {
-	unsigned char cmd[10];
+	static const u8 cmd[10] = { READ_CAPACITY };
 	unsigned char buffer[8];
-	int the_result, retries = 3;
+	int the_result;
 	int sector_size;
 	struct request_queue *queue;
+	struct scsi_failure failures[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset((void *) &cmd[1], 0, 9);
-		memset(buffer, 0, sizeof(buffer));
-
-		/* Do the command and wait.. */
-		the_result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = cd->device,
-						.cmd = cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = buffer,
-						.buf_len = sizeof(buffer),
-						.timeout = SR_TIMEOUT,
-						.retries = MAX_RETRIES }));
-
-		retries--;
-
-	} while (the_result && retries);
-
+	memset(buffer, 0, sizeof(buffer));
 
+	/* Do the command and wait.. */
+	the_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = cd->device,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = sizeof(buffer),
+					.timeout = SR_TIMEOUT,
+					.retries = MAX_RETRIES,
+					.failures = failures }));
 	if (the_result) {
 		cd->capacity = 0x1fffff;
 		sector_size = 2048;	/* A guess, just in case */
-- 
2.25.1

