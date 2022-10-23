Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A859C04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiJWDJ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiJWDJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:09:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F56674DE9
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:07:41 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MCsDV5019473;
        Sun, 23 Oct 2022 03:05:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Lgqcu9C605h4D3Olmb5BRSzDBD20UOEPPLYwjxtLLwI=;
 b=elh4LbHFhQ6w5maHlxPfPeOxKpFgYAp1J8FrdlRCt/+3XhFEdulHsg9w/aIOAICVhEfP
 OXFECqYyWSv/lhGNYdgQiySRGCQPUvRTsS02Pt++XDz8FP/jhW6QVK4Qqe74QgYC/4AN
 Nc3PX2mNCJ3/ZQIWLCKJx/LqWD3zVOQ0vKC6mYMiWiXRxzVUBj+kc5bBBzAnvjv/CZPn
 LhCB4ovZ92OXLY6JrKOArz7GMRzLeu42XhuQf9Hs4Sz8e8sEc8sk0aq/8uacvXEXccBo
 H3Gs5J86D4FCS9i3jWLkwOARTgEi+OFHHPsnrGl2g+pEH0He2ISC3qvAz9kt3p7aLLEc 6g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc93918js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:05:28 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MJW0fb032103;
        Sun, 23 Oct 2022 03:05:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y30aud-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:05:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYNjBv0SzjoO1iJGS7rbvGHoYYoY5Ji89mMulJqobDiuA5kGDbgUizdbNqcNlg+38jSxeAY5x9wNdmMe3KNVsdSUJTIx/ai/CC/5TU6geTOBXKcvMpuHtjJf8kARGQL9fQwcrXLG0itbjaVTjvZxspONoQWeWF9rJ4+7rUUL2qYtPo5rXkZx/DBUpg9uamOMp+JwOmMzi2qIPGYEjrY7G8zSQGIicuRld4Ln/ficT8Xa1qdbzYya+v/fcIbomHik8REyd71XpokGOqGBT9gT1v0rIW6oF1ORMukCfZAwOB6n7fM48gz2xRAFeHt2PzL4jYRpfd4Kj2AIIEOW2Rl3jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lgqcu9C605h4D3Olmb5BRSzDBD20UOEPPLYwjxtLLwI=;
 b=bIZXP3/HagKs9C797rs8do1ObEPGTAGW2KJmBSuFXKpFsWLeWu4nlYg7eIaX7beRyYYp97INW1QIuYI1sDafHfQM2iD6S1AHnHQs2SCDB6Q/wnmkSpuY/BAbXraTWe9kOdec2v0tsfN6RRZkGwU9/MH9wHgySHnIwv2edb7ga72Sk7iWNlKSmrYOj/qFtGuTB4jLSWjhJy3SSBVlbsrhVYrGfnP7A9jgPyUEci/pjokdyBgA9Q5ksQ1vfthBm38TahHV4U2O6PrmPDks+3baVvDVOY/AhXxWrX0qnvL2CpCAUwaPLp6szT9pi097yEg5mWdnnWLRmWqaqQcsgsEKIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lgqcu9C605h4D3Olmb5BRSzDBD20UOEPPLYwjxtLLwI=;
 b=SIEU+32KebM1I04xlywqEZcPS3PEYTRYiluUIER4PizQrQPZh6CQCeaoTtHjVNuxnk1x0MEKG6k4I6+9QJEumlOTvD/evN6h8oLyCPT7QVAtZVh4O9Zgjz0WAJBz4gwKBMumvog9txeHqCF5dmu21aBBLPkYyCOPrLW5DgFdTDw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:05:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:05:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 32/35] scsi: sd: Have scsi-ml retry read_capacity_10 errors
Date:   Sat, 22 Oct 2022 22:04:00 -0500
Message-Id: <20221023030403.33845-33-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0240.namprd03.prod.outlook.com
 (2603:10b6:610:e7::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ce43062-cb95-452b-73af-08dab4a35df1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +W+C93hF/lgGRrBq09uRveJeAHXqQHOcjht4kLe1PdCFxWETh9UWB90dqlhOW+PgJIpsUne8FMcXZ3QWeMFktFZ7A90ZKyWDIG5lQiRtkiOcZwi/YI9Eg2+SQQ8Zjzpys3dW/AaMIOYP8ehddK5Zg+p/u4kQfJu8+ipE3c07bduNCqCoczAvXA64VEBdx8t9TuiWxuTdmqxxufbjZuw/+FvzrzslMY1bz+Qr1czaBptafIIb7JULET3Gs4d47vZ1Bt+4aVkakn050wyxDYAtkwC7cH4U86wubVE3XhGGuQiCBHj7wfaa+2LJLmYj3+tROkHfutcojRtCgnTRQTCljFcSAOaKW4MBq0b+nhn+KyMT0bJ+kn7VWmRWBqJSXWrQq9zdHwBH/xj/cm90xtEzxaYll9jr38FNLgpf1sl4/ePTBFM2Wl9iwyItRbIgMRQA8EZTad+UqFiZyxA9jlIvke98g/kaXZmaLWD99urgvq55I2Z+iCwGFZ9oPe2D6XJ+O2aj+wBDZjctZmFjC7eTlBDboHLyWbU/2+G/jPYCANYJEZp7EnstIizREX+p69lbnM+En9X1HLmJRWNhRxLpIB4r5HU6RnOEalFY5/AHdGalaVPg9zn06DLbNtUENYHM7cRSIs6jWkgw1UgOda+/+Y/brgqNckZDzuJmZwZab8A+KRhEuV99kHocCRnl+dVfgF2/st84oDs+LkDu0Pc7JA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pd1tkXTnf5md49VbeSS50ckfqxHmnNK/l/TdJCXXi6EoBgofDZ/CjlMLuyDE?=
 =?us-ascii?Q?fSTrCFtADfNLnFb16oH1ngLRMLoh5a/d16aNdUH1238/OP9k6qzl+dHi+Tr4?=
 =?us-ascii?Q?wojSeurK+qL/oCCrHp1RjqhVGc9jZ9v5ztCNbEVVsAjwGUbveYcWv+nthVsl?=
 =?us-ascii?Q?3vKXmq89baul4PH0H9paLCkPIzuqj5AEnRgi3aZ6G1mM9d6sSBLm7wBeH2TR?=
 =?us-ascii?Q?O0NkDNW7F+lgT2yxMezkeQtPS6QLK8QxWuNigB2syGCIOtjB19biJnpCbw82?=
 =?us-ascii?Q?TFR0k4aSLWISuvfF/Gtvupp1BqsobL8uvej+MoauM0iWS5UYJmcMTgR0IWxY?=
 =?us-ascii?Q?REbsNGFvteEuszdYtoKGHFVvo/tZy7SV6fv6L3ThdxGp13l/Q/U7CrE0HLDo?=
 =?us-ascii?Q?ZNWpQQBKmRx9dV43XLfbOpuOILHOEgtJs/JGseP8KFsQiH0Zyp1ypr3SmnG9?=
 =?us-ascii?Q?AXV6QfM4Nk+ypFFrxx17IimXG4l+0gybAEWIoP6tZ04EcEtuMtWvyW9znDKS?=
 =?us-ascii?Q?7O3uhkUaFy7N12Nl596MIcBia9izXOfpXemIr+zpnWn5xHGwwmRdGUwV5iYC?=
 =?us-ascii?Q?zop8MFHordgTfJgGxe7P9pxW/FZ2HMsLBRo2/b/rkUmT3IDPyHulRg7H8xFW?=
 =?us-ascii?Q?ryzCJrhr0h5Axm14gmC0RlRxVz25upnI6rrr4rsQVf4eHPkrK1f0xbV2jl9a?=
 =?us-ascii?Q?KtzjwbMUph/+QtrdXmGwYsLp56rHR2zFZdjyrD03T4oqNRQgyCs9nB1LFRIu?=
 =?us-ascii?Q?R0KszB9QXasmiDnxn6rPNH+7w4+ucX3iQE5o3M/CK5DR60fcY3oUUdbHjlXD?=
 =?us-ascii?Q?WxuN+Uq/2qhRZDgHDATzspaAxy/lqh7j1H8OyJ9715tpidZGhrzybIqO4Wmw?=
 =?us-ascii?Q?IzLjyo0Qj2nzLDPJt+4/x4uDNFkMKYOnnCVAKt9d0AJlVfu7mlLVYCGVijtR?=
 =?us-ascii?Q?HUctBXQ3W7uELn7muSbqlUVFpmbWMHB6qIqWKYO38NPktIlLNiOmuqrKwD0/?=
 =?us-ascii?Q?/X5u8Yr99LJjz5En0OL7Qvj4rJhvW5BobU2OfmNloD9lPrSdNHg7J2NjmgKz?=
 =?us-ascii?Q?goNZAtgeOs4Vfds8AortPX5wX9f5BjLuXFND7Nf60UIRAUzFh7jI2xSfDaNV?=
 =?us-ascii?Q?IcRd1QvCfADNXfhUax504Q6CupJdO7p7dqg8nhh6qf+sj7OO+GPnWkdlWP+M?=
 =?us-ascii?Q?RoBi41bNAIGyEu5BdqtiS8oxNSkk4lob6PmHlVZDMs3UbFXiOW/jOfTpApNy?=
 =?us-ascii?Q?1p4TkLP784nM5XvVgvZyxrJ12r5I78C18SDej6USxkYVG0hI2vpYS4Ru8hzk?=
 =?us-ascii?Q?njhqiGzSUSluURq45/2EbD0p3vd0Uj7NFb9Bi3KI6esNQNQCDRyON0uMF7My?=
 =?us-ascii?Q?YFtoIVEfYTaAx913LLk4loVeK5NqSJQEoWTILUalLlzAvqku/BMQVn4qyBnZ?=
 =?us-ascii?Q?piULxtrolIhgPgwvQ+LH+7/aKHoQmd+PJcoY8WWtqRIhbEWxPjr8RnAa5VYm?=
 =?us-ascii?Q?WngHPWlsgmgydmsQeLR1eK+7k9YwWzmUSHeha5gmpZpTQ2yIPo3sealONM8O?=
 =?us-ascii?Q?Ou+/asn1qgt29JTodSiV65HVIkN4H3EJXUH+eB42uWWYayKvzEw/wmGNDMWV?=
 =?us-ascii?Q?cw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ce43062-cb95-452b-73af-08dab4a35df1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:57.6213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kX/1+hpVw0Pkmq1ZEhcuDO0wkK0A29uWYsFLGWzjJDCe4w4RSourIHMTR9l/4VZ0wL359k9BV0zGvvrYVSUFz2HMdhv+HKD0zrY6fnijCaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230018
X-Proofpoint-GUID: VAX0zsxLtppTujlV9UwkmAz9Gs7F47er
X-Proofpoint-ORIG-GUID: VAX0zsxLtppTujlV9UwkmAz9Gs7F47er
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
index 3c05ea3cf109..187b4fe2bc2b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2433,45 +2433,59 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
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

