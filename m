Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFFBC32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbiI2C5J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbiI2C5B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:57:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC3311E0DE
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:56:58 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1TdN2004390;
        Thu, 29 Sep 2022 02:54:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=N/lAKYMc7FVaq31yjlZqvr6REsuHt/Rf+DE4RL0B5nU=;
 b=fjaGX4qR544m6GwTrvYSAuuHgAD3VxbpquMj8r1641nzfUknomZcJx27JyQX9lqNbIVE
 NENjiq2oI6szLPgVa8lppRAcp4dFeQq4EDTVlju6iMEdCWDSkf3gnEkovRqPdEL+ZUh7
 ZD3zY0hXAT8KTfRbkrRHX4JQr7gaIIps/AlLU8QcTwGizrriTGgUVfMOZOticDCmXr1y
 XseGrAEH1mWBWWNbbXA664A+BRNe5CQlvuMSRbdIrS2PJcPRY35JDAn77v8fvS9tw902
 t9DIbaXFnzj9lfa4RlTaN4ixQ0Gt6yzzxPoe/VBhHfJd1mCyQ2XI6wcX2ECFjian4GQ/ iQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssubkhj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:50 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T215Oh002239;
        Thu, 29 Sep 2022 02:54:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtps6v7jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TiLfFjz0Mh8fOWFqjo+vC81o/SLHQ5mkmxWhT45vAOM6kwyublUCfnlCVBgaR/EUbXR2QBAyOPq1XDZMCMUj7lzyRCDbXdJMyCgDOvUlf/o9Yq7Qut3Hhfpuko197S6r3j1El43/vf1ojOzUpTRSaQ6k/BaIu/kSjhMuQTulArcR4qUvOdVVHgM4mJppDzIDRarLpL4/s83slvWatMAq918QagvF8GS0ubJAwNZ0s9Vwo/YH2v/dGNkN76w0W0cLR1bz46ul2P8j1QmUUU/SiCS490sRHPOg+bDJ4c2DMBpMbJexpozyaiYJPxl0e4tdtH1Lzh9IL/g8MERD6TBKYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N/lAKYMc7FVaq31yjlZqvr6REsuHt/Rf+DE4RL0B5nU=;
 b=IqnKJ8nzNX+XmtPqfvzd5Hp8mdITaomV5veWeiYP+FaohdApXYOKzYCG8a76ZSoygmKO4WgUPUQT2JYwf2DmaDbhkHOOx0V9TEAD0oUu06hL/8NMigpiZkfie7evEWdRPboTOvF4pXy/QJcLqLaVCpPKxDG0rprWg+hypLz4yP5uBLd1b3W+WFUuQk02CkScYmXxsXIgNcSI9E/5XxJFC00ihzt8v+2V+CaIzcqq5BClpc/RoQLNONvD37z4DC4PSxJKlB9RpAykFpDL67tfsTpku2jNTyXLEk2A8GqEG0Q7om3J1tqdw5q91pbfaovAtWQFeTLWiYZMcPNvX7Nv1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/lAKYMc7FVaq31yjlZqvr6REsuHt/Rf+DE4RL0B5nU=;
 b=pof6BX1sYZcwlkMUBDq6HOvClD4cSf8/3d2Lzl+z4RQwswznIHBamshkqrx47lbK/4njNddCW1IdUr1JL6J6+5mmiCopx6U/ehirqhHSvHvMgesduwKvrzIx83ULwjDwyWRM9A+m681UdMaf9DKOXe4eQm/efkM5JZhSoIOa0EA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:54:47 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 23/35] scsi: Have scsi-ml retry sd_spinup_disk errors
Date:   Wed, 28 Sep 2022 21:53:55 -0500
Message-Id: <20220929025407.119804-24-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0007.namprd20.prod.outlook.com
 (2603:10b6:610:58::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: d23545b0-aa54-4b6e-5c28-08daa1c5f823
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DN3kSrQHFDDSoI6eG/59D0Ec64l3mdUDzkxXFQaetF0lV2ExmsZMyWj9rKqtyE4U7VxIDbyk1c+9RmPN0Xr+g3vC64XYGsoI/13t30Dr+VewjkkAGPi3c3juwcmIZyrdWG5JcMyGJpvFuzcZVNZV1CibOFKlqNz+/VIwZ8WKExHCG3RhzrWbG2PkYhy3uRKsu2PdrvP3jtOSOg1xZIu6dIiIZE+rRW/dA4F31CHpFinTygTRtg7RDgGjX+KK+cgb6aq+D9g6HzWV7x0aU3G1g4ztxCC7pgDHUpGpYyjKY2oCmgV6t9xxKwL/NN2WxMNoelNsNPfaX7u2Vs4YjyW59pUB6BxN3/7JA1OL0F0kXNwTquo22yGiK1ha+Sx1VdgLUb9im9Gu+kr8VvmbKklCMoeATAPNFoaeAMgLdAc3XMwVERACgP1XsJ6JHF0V8ptHs96lA1EpAaz8XHroP6PgmNuYNyPLexAfLidn0e63w9e4fhRP1CanEZAb4KzrzudSRjNQPCJH+8fhaqVu415jkyMwls2QwLteH8pEcTMByrukX1E5scKgmLcxSOTPTVqmt9/NnIvJtWH7ypTi3oe0TYDN0z0Z+O0wxRA7xgO5VgmGnM2yew/QxIhW9Tnn8icjm9GHuaeZEUQQToQr3Q1O4kNWumFZNmB0ZaMiCoGdpJcMslY1zrzeBwDsTs84rbhKU8rsO17PR0egzGU7h+Xh7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(6666004)(41300700001)(83380400001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QKwNa7xVp8TRvcQJ9ydYDZuq4u/Lk1HvhdllRt0uotd4ZpZUURkv//FfPW9q?=
 =?us-ascii?Q?3tmAo+iMuiWSvlm+FaIsSmv1uJ844uF18QdX2C9viAzWi7BGnJVypOYRhdnr?=
 =?us-ascii?Q?cTij78ImoHtvaaIN4yeADHiBIEV9hfBF9L60AQD6409EBzwBJd2W4ronRvbR?=
 =?us-ascii?Q?dPdwn1jw2YpKuaIG890CdCRb5zkwWLwAvdpslnPTEiAe/P4VGYhddpVrKOQu?=
 =?us-ascii?Q?8pRVNVnXF94wLbi0BhVlnqudJv9QNQab9Sqo5lErEn9wZSVHJEcVZ4eJxVLA?=
 =?us-ascii?Q?W73skuUfsPmT5sKENdVCR3es5UMR+dumKLuT1yzMMebST+QM6brQ4dSx/L+0?=
 =?us-ascii?Q?Vurn5UlLi3gjsJ55UAAL+4SljC/Gz75nfW18DthBDad6fQzOC6C0fIeKmZW1?=
 =?us-ascii?Q?eTx6NqbTQhHCQeTK9fDmQMITlRznD4yUDgPqvOnv7GpEDMwaDt+ednpkIXU+?=
 =?us-ascii?Q?pTSLpPkzIh4y4stRIof8FE+0JEwYoEchB2cZYktGkMSu9ZeubxTEI5lVeUEO?=
 =?us-ascii?Q?nyV9n1mMDnUE2VC2SS05d+Lt/sMWh/fvG7rfc9ala/fZkG0f20cWMvIuX60G?=
 =?us-ascii?Q?6K3L9sQ1nrQVmbThORXP851Tgasb82vMyi2rJrhd/YtQ/tA906toYGwItApR?=
 =?us-ascii?Q?CLr9Gm8h1wbuQYIl7mzL1WpB5eMY0DJZ2yNr897l54n7D6r9Mr1LPRrqva5S?=
 =?us-ascii?Q?hxyPWcRbrQjRrEZ3KKdjoQocatvW8cACcm7xaugrUGc5o0euETOVWqgYj/G5?=
 =?us-ascii?Q?VPcK1G3sfRRQ5/dJDixFT5lci6GvfexaCLGdWfdMMy8Th581dY4xTOa/rk3C?=
 =?us-ascii?Q?11MdtwtfNoL8nGcXPZVnKZEInU5YFAbcsZGuIRJ5UgsDRK6myR/AbM5SLqDI?=
 =?us-ascii?Q?JePlx1BCJuJtw7TVGkYRAxnkVNpVhezMyZBGOpWfXwNb8/oM84PqJ4mT1KCN?=
 =?us-ascii?Q?LZGG8o/bZEycLqzxT3ZYMCKlg5REiPCH29Q1l7Oh8QvFP6Qt2ooWgJhsBPfy?=
 =?us-ascii?Q?ptaMwr3BoAp5QM4cnzlP8vr+nJB2rIimwKFYV8bSKAEWpUwZBC7fiuUT9uPk?=
 =?us-ascii?Q?5QvgK+n1Grgl37rQM/ZQgdG7selIyV8cljxx8bMtQaO7B00f5myRYNgznHP3?=
 =?us-ascii?Q?/ODHxK8ImX5YUcJ4DJ+2swmFcswGtDS0moOcCsh+GZhCpYRwFkXIe1rBY69d?=
 =?us-ascii?Q?api2So651vZIaiuifwPkyMqGig6wOanYa2+rlBmZXH4Uj2xb29svlYse2TUM?=
 =?us-ascii?Q?Ec4DtJslZm8s4qaL1pVAsg92z2kOLP3Mm/u60PGOo+cs4avPY3FSMMM4ydl3?=
 =?us-ascii?Q?qGg6rRgkw9YZgiXYGbB52i5i5+RAiCGqb5EH06N28hv7c8KlQWpsPGZ3zAIB?=
 =?us-ascii?Q?Zc7C7s/eTIS8pkiSxE3I9Qan6nYmdK7IddWJl+DIr/yJIp8y9Ta/TuBPOw03?=
 =?us-ascii?Q?MMxqFZgygdwFAlkIp48h78/6R8VyWIl1wacZ8+Lsql4GIRs3/J+VgeX2M+Ja?=
 =?us-ascii?Q?/6kDk1YlPS/N4n+SlB/keGXxgNzApx/4GV3myH/5T6ng88DpG4WuqQGMnzON?=
 =?us-ascii?Q?iVMveIv42PMwrxBmtZiDPvOOClP6wQZBJFKxmp0q52b43Dpyr0FyTxRc7nC0?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d23545b0-aa54-4b6e-5c28-08daa1c5f823
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:47.1136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TuMy6ygydtHpjIq45S6WLW9hhZMsDAy+poZG2/nBgvU2c+0I056G8+EIEcbvy53JTB90sYoRmbdfK/28ehSPkvC4kh9kn9h+0dSvBpNWhok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-GUID: LUJfJHJit79LlgUSTyJMp4beLZPHB6nf
X-Proofpoint-ORIG-GUID: LUJfJHJit79LlgUSTyJMp4beLZPHB6nf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
we retried specifically on a UA and also if scsi_status_is_good returned
failed which could happen for all check conditions, so in this patch we
don't check for only UAs.

We do not handle the outside loop's retries because we want to sleep
between tried and we don't support that yet.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 76 ++++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a35c089c3097..716e0c8ffa57 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2064,50 +2064,64 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 {
 	unsigned char cmd[10];
 	unsigned long spintime_expire = 0;
-	int retries, spintime;
+	int spintime;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
+	struct scsi_failure failures[] = {
+		{
+			.sense = SCMD_FAILURE_SENSE_ANY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/*
+			 * Retry scsi status and host errors that return
+			 * failure in scsi_status_is_good.
+			 */
+			.result = SAM_STAT_BUSY |
+				  SAM_STAT_RESERVATION_CONFLICT |
+				  SAM_STAT_TASK_SET_FULL |
+				  SAM_STAT_ACA_ACTIVE |
+				  SAM_STAT_TASK_ABORTED |
+				  DID_NO_CONNECT << 16,
+		},
+		{},
+	};
 
 	spintime = 0;
 
 	/* Spin up drives, as required.  Only do this at boot time */
 	/* Spinup needs to be done for module loads too. */
 	do {
-		retries = 0;
-
-		do {
-			bool media_was_present = sdkp->media_present;
+		bool media_was_present = sdkp->media_present;
 
-			cmd[0] = TEST_UNIT_READY;
-			memset((void *) &cmd[1], 0, 9);
+		cmd[0] = TEST_UNIT_READY;
+		memset((void *) &cmd[1], 0, 9);
 
-			the_result = scsi_exec_req(((struct scsi_exec_args) {
-							.sdev = sdkp->device,
-							.cmd = cmd,
-							.data_dir = DMA_NONE,
-							.sshdr = &sshdr,
-							.timeout = SD_TIMEOUT,
-							.retries = sdkp->max_retries }));
+		the_result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdkp->device,
+						.cmd = cmd,
+						.data_dir = DMA_NONE,
+						.sshdr = &sshdr,
+						.timeout = SD_TIMEOUT,
+						.retries = sdkp->max_retries,
+						.failures = failures }));
 
-			/*
-			 * If the drive has indicated to us that it
-			 * doesn't have any media in it, don't bother
-			 * with any more polling.
-			 */
-			if (media_not_present(sdkp, &sshdr)) {
-				if (media_was_present)
-					sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
-				return;
-			}
+		/*
+		 * If the drive has indicated to us that it doesn't have any
+		 * media in it, don't bother  with any more polling.
+		 */
+		if (media_not_present(sdkp, &sshdr)) {
+			if (media_was_present)
+				sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
+			return;
+		}
 
-			if (the_result)
-				sense_valid = scsi_sense_valid(&sshdr);
-			retries++;
-		} while (retries < 3 &&
-			 (!scsi_status_is_good(the_result) ||
-			  (scsi_status_is_check_condition(the_result) &&
-			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
+		if (the_result)
+			sense_valid = scsi_sense_valid(&sshdr);
 
 		if (!scsi_status_is_check_condition(the_result)) {
 			/* no sense, TUR either succeeded or failed
-- 
2.25.1

