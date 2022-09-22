Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B6AC6FA8B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiIVKHl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiIVKHd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:07:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF42D4A81
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3rUT018189;
        Thu, 22 Sep 2022 10:07:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=8NZvvA2BuU/7boMXFHyMHA+2lHqR53gLmM3lGvh0A+U=;
 b=LTb/037CztsyiP1wnApBhOn7kF9jUJFmWty1Cfl/+YM2x9Uk9GTyLMCEmNGV5StYStkp
 G1bJmvXR9/puY+tU8+jRtJ7ceTsZpRTTlniox9NvqOWHwamu0kSRbKm2EAn86bZoMd2v
 vo3GpgJffpseqnvLKsd/3Nj6peTJz5w3GofCjMIkQCJH3ImpiSjg9n9FkufeMQSl7eMM
 JjkYjQT6Gce0Wyo3zulzbwZd2KaKx1ynTNOasDaAPXW6I+P2eBw/BfHTO19qdSDHHBHf
 lm8ZxF0BPpbyOX+BWqEUuHh4DRF56T90kTj01UAQSfBMx24MYWa/zzk6G7rpcMSyvA3o 2A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kw1rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:20 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8l4nt028231;
        Thu, 22 Sep 2022 10:07:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cqdxrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8/6+ICP3ByDpLdxB5Co/cbJMtHuTl4Fj/CV3sZs3YFbY50eUoj+iiZjJpoHa9Dc2nzNklqHskJu3TLD1KCUTFUNLLpD8SwewRC34Nc9Rh6fU+T8WXmRSMR5bQ2TkaQGCj1oW0dxS6tRdUd0MuPbRKxPXSEiB6jSGTMghJHE3trS46AgFkyA4Q34SLsK5nniOmUjaPFVPAP2/yIvSXtrBL8x5uoIKwMaOLTurH6Fc0E24Q+DDgflVK01ulG04zZXIyYo5wWaZ0/EtuCEzd2ly8jzAeHQE2W78VlFzpitrPu13y+5LMMqCTsI2C2oFCPhb76N96xyMGuW2cQoTP76tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NZvvA2BuU/7boMXFHyMHA+2lHqR53gLmM3lGvh0A+U=;
 b=EAeH+/aVetcc6H8+DpCH5PzAn6rykZxfcjndGTekheMBtKMuTERUoGCmU5dNPoYfkprR7iyPYgIprso2D/rZzxcqeHmXXPhO5HzemPX7/uYod7199fl3FzK6ukmEfxnKCC9t9zB+ryiJaQj7+XAEm138DrcKkliENT6rUoKNdQcmR7er1prs1+q01nAW2YjB4ZC8X1bv0tDhc/EBx4EfC186sFN0Wv9iaIiciJYokPRFZBpZPDssn60YKW5jIpFlFi9wXry8EA0euDgMbwrbugtSWg8NDeEJ7cMtDZyBcUh/l92AUvQb7I2Ntjdzkufd94UhJ5XDiorqOVcBsHertQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NZvvA2BuU/7boMXFHyMHA+2lHqR53gLmM3lGvh0A+U=;
 b=HDOWqIaLF0xIXJLJ5JI1iZb5fG+MMPIJfG/IkuI1lZK0PUqDcJQLlssnUdPd2QeaHfd0CvKqeCGh2mjHrizVOqd/RjKEx2ibwfyxI/KKyhT+9oD4nx5xlTLWpePSOa34RA857Wl1Pw6q5DMmHdg2Eh891rlsIDfqwXxqYveLQpo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6243.namprd10.prod.outlook.com (2603:10b6:208:3a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 10:07:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:18 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 07/22] scsi: Have scsi-ml retry sd_spinup_disk errors
Date:   Thu, 22 Sep 2022 05:06:49 -0500
Message-Id: <20220922100704.753666-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P223CA0008.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: e89bb414-df21-429f-f477-08da9c823b65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iJbPAQvFlujr4MrEr1OgqMdi7bzhdh8XW3NFQ0OXnhkGEf3rDp37zDbonwkCLnnmr/theV23dCV9zFpfmM8oMCfIX3plMY01kcuQIxJ4GZ+I7LaHqyIoVxz7Atx/uSMxRCXjL1sROw0bydZQl8yg9rYCg/+5s6ENDwtjA4lSlvWrBD9fh5PcBR0u56nebn0PvCdONjyHJC9NdAXIG1rxORg+NT1gd+yvKy8H0MlapJP0vLEnNA72N97FokXWZ1rfZ21/+0PtVbHHdXbE2WeHFOurEdAWFOiJO4Gh7WAJI2GTeLtPMqOZ9G2h1LMgwrggG3pm1Xjqs22rPV4nsstmjKwVFeI15kq6KtwQtHvaJfMrNh+UfnxCrclMNBG/Qqh3bl/bz4zxvLd0V5lfMxFilH8Hgh4fdbdYt2gF3WNBEMdzivcM7f0l8oxvUSDWkTc+vFkjsVLDmdUIiozB7R+PlfuM1eHwzk3u4/rdfkZIeTOn9cW37GbsOemDnnuDwJ+YSlJ+BsGIKzDzVGUCmF5KDFoJQepPnNrbrZ+/DTxjR3JK0z2yuUN7U5eS6SD8XBpnjem7XjSAuztY0Wbzks3IQlEXgALDsAXud+aQMt95WlO3lPmMrjcLHdwdaxuPlmf1xYwL6oSTKjeem2AYjsEbenJiw5NJZWj1qSEaFwF9EvHfu5y4R4+jnwTVLSsi4GIqqnKhgiik7lOCQsxxNq/v1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(107886003)(66476007)(38100700002)(66946007)(4326008)(41300700001)(6666004)(316002)(8676002)(66556008)(186003)(1076003)(83380400001)(8936002)(2616005)(6506007)(36756003)(6512007)(26005)(86362001)(5660300002)(2906002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HAz+bNmQkR0PydvadMZX5vB+ReOEAUCX9+g3CKKbMxta9LVrmRJMoVZJOuki?=
 =?us-ascii?Q?Q/SI8elpB8HAmsRgOTzM/IcboS0hntl/Jjk7sCCWFDCwm0lXlzCl+pYeF+06?=
 =?us-ascii?Q?ymU/8x03JSunGWFB9H62F0sVdckgDRNCJdCMT6HELIwYnmuEyt9/vtSC3SV+?=
 =?us-ascii?Q?XHyPcTKNUj1tjGwLc83ANQd/9NLfyYvlY8Vd2l2aIr5+ZxT0k6dz6uatU5ay?=
 =?us-ascii?Q?1cmzMf63oq1/bOf8OkcJ5KUxuLCkf70HCJWxA2F9Ba1M5sUIfD/9/S2tITLR?=
 =?us-ascii?Q?RB+UpaB0JVw7xrADH/xNRU83OO077saBBRI7bqmyVWVfLMyU5rLuPCRuRxO1?=
 =?us-ascii?Q?DLHeYQStwwyZft+oag6QPVWGgB435sWlnlJSRHI6jRMPy9xyAe8Hj1bHcyqc?=
 =?us-ascii?Q?DCrZstGzqEcTS86x/nJMq2gPMDlm9CYZsN4GLZ2K5fBdgyXEoLv5r6jfDXuE?=
 =?us-ascii?Q?GtLgh7qTicXAJR147UkJviNUhmueYehSVMRpSdaMoora5MDo02HpSHaQXPCs?=
 =?us-ascii?Q?kdZ+0FDSsV7nLM/81+EfxGPAnQ5uJ13GIAkEVrq04C6UD2YW6d3D3uDm3X//?=
 =?us-ascii?Q?PKOjACdjYomesPvJ0/oSATEPhtqsL7gg5bhFIoKqv1xtZcmPn4Vud8IjSr/3?=
 =?us-ascii?Q?a/ov2WUZPN8vrSQFft2DFmXrGN4v/tnBqAAb9ry4hBFQUAW5zaPrVFMyfstK?=
 =?us-ascii?Q?vozWz/4X1Mdkr7rZjIUcs6x64iK+hDtgrVHpjgxZuJnmTFR//p5S5RSmj9Ma?=
 =?us-ascii?Q?A0e7UlEHKAXZsLEpgUADweMc6DsEzDRUfleIBjRELDjZINCPWOtUlJWUJJPs?=
 =?us-ascii?Q?iwoMeLiv1yL8K3iDuyKlMrtAPHZRhYD7hpVU3zgT0EErBZi6KhEcpuyrxgly?=
 =?us-ascii?Q?DJj0AMryjocyYR0UYVAewDLFmD/49W5pRjH5lqTCNzmouM6osH3WAla/Ltv/?=
 =?us-ascii?Q?AvHi/OeR8hRA7x+dPbmewGM7Tc3obh4reELkAjpvEkgl82siLjDzbONvFrUh?=
 =?us-ascii?Q?D4vXhW1Y7AKoaFQFWBwon0oSXYXg9QoG955zdYwmz61vdgeo6ZZnCLUgcZ3U?=
 =?us-ascii?Q?0fy6antRdW3ZxIggTDAjoc4RlZ6ge7f7I0e/053Hj/L9rOuMWVHJoqUdR3+C?=
 =?us-ascii?Q?PN2F/ksIvuWzrHr4I9aglSgMoWoA48GLWUqOWLDnad7jXAfoWQb4eF5Bot32?=
 =?us-ascii?Q?Vql/HWtaBhhYXi5EfjYK6C5oLm32DXm1SL9lKi7f8YPcAcCqa/JK/mXWVlqu?=
 =?us-ascii?Q?cgndhveNY5OTxn56Uh7zrpWZCmioSIA7Hssd6ZZoXlRE3RCZXqdBPYykuHaI?=
 =?us-ascii?Q?8mB2Rrfisnyf/yljwO5eIMVNQ1Q0Ic2ZnKwnDlu7WXxU71SpAcz3z39pjU8F?=
 =?us-ascii?Q?miy7oSVMkgTBbavRhXAzvNigZeBFi/ZUWv2P/X9E7xW8cm95Lg+7z7xKpYN6?=
 =?us-ascii?Q?Y2FDXxqRDltvRFQRXfU9HG9s4UqFLGWGcDhkP8q7L1uJTaPhzDHGi8clufb/?=
 =?us-ascii?Q?vy0G2vjvYzWCf5Rcqf45MnidYoR26HuqKGxPnuX3KHvPgO1dyzulN9T+nIcT?=
 =?us-ascii?Q?GhhcMkVkaA529FAJOpoEYhO3QB9jn6kMnc6tn8QeyDK/Vh1v9UJFJ4vGNaGE?=
 =?us-ascii?Q?WQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e89bb414-df21-429f-f477-08da9c823b65
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:18.4127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ebFWcBi5td6UPtMjrEi1JOWV3WU/5m5RKZ0+pCFnQiFAEgqlv/7IViTA35n411dNWBEtLNknWx0yg67frxE3eCtlXqH6czcwhABZpM6Q8Cc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6243
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: sNL4_tPAUbnVNImp2HJl30DmsDSR3p8u
X-Proofpoint-GUID: sNL4_tPAUbnVNImp2HJl30DmsDSR3p8u
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This simplifies sd_spinup_disk so scsi-ml retries UAs. It doesn't convert
the errors we will do a msleep for since scsi-ml does not yet handle that.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 58 +++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 46383b680893..b76e0b1900a0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2045,48 +2045,48 @@ sd_spinup_disk(struct scsi_disk *sdkp)
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
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
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
 
-			the_result = scsi_execute_req(sdkp->device, cmd,
-						      DMA_NONE, NULL, 0,
-						      &sshdr, SD_TIMEOUT,
-						      sdkp->max_retries, NULL,
-						      NULL);
+		the_result = scsi_execute_req(sdkp->device, cmd, DMA_NONE, NULL,
+					      0, &sshdr, SD_TIMEOUT,
+					      sdkp->max_retries, NULL,
+					      failures);
 
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

