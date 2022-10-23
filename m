Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F8BFC04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiJWDIa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiJWDHR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:07:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6521172EE3
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:07:01 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MCsDV2019473;
        Sun, 23 Oct 2022 03:04:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=X6ScgZ68v8bhnU3PlrE8DP4QpmE7KwuFmbi/7VZv2Ss=;
 b=1rmtMkLzZfodzzXYgdVC31uZm6pYJh9fZ1t9654NvLrJx8jB9u82niM4p7GZYUJyEKPY
 ijU2EN0JTGCzbU42ZJMxX1K4tErujsUPgP05r5bcNJ5cN45VkjZrNMa12wD+ftbEiver
 c3X3W4z2VrpGNyMTyEMeiN0moSko8m4vusZk1af+nzUdKMwzuuVKx3mfjULlGz1gXv2Z
 /PmSuRwibnZ92cSGkuDD9A9D6ycWbo+losV5HbORAGV9hAGvgO16SzsN5uLC4AZ4BIM6
 Vmb207BgFKYOLtdU4VBKodCd0fCwtDhifFXylOxoQ+shVSP8M7sPLTHa66OmghXGngP5 4g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc93918jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MJEUvb040828;
        Sun, 23 Oct 2022 03:04:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8gs4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lF/KU9HHBxOKu/Fpl/iGVyGQyQ3uhieWZJ/n/DQWrlUY4A67Ucv3AgCZw2ofsh0HE6/HQrBEj/DSXSb69zrNf+QtDMveRfvxJJ9vsY+hDja1vQia4Ia8DIix2T+E2U1EgEHTu3690FoCohsnWGvSaDa5rEO12j8QZRxOE52BUtJf9vM53IAHx3MEiqU9ZyO/ykloMYcm91cSwcAwklLUriFnnBkF3LXwgb6iR38vm6kLKJ0t2kqvpBQQAWMYY3HPMC8QkFf/o3x/+yMOdjlDaeUAWdf+3fjzb429GWcOBA+fkql6sQA6nrZLpOPEFWurqfEEyBlmxxuacQdTt5mOcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6ScgZ68v8bhnU3PlrE8DP4QpmE7KwuFmbi/7VZv2Ss=;
 b=UPplli3x4TuecRDgUu/UbfRo5cD4sBAZW3hnsnKxi7Mzgc8PU8OOw330mODHuoQS2nRFI8jZ2y+5W4GR/DqQrMmCmpSm/cyPdl3obJEVN2wWw9Qo6QZKY0uVSUQRfGnazy9UDrvj+ALXn85mlWx8vHhetVKttI3u7ZuIeeWrFVp6F3yDM7afOSvpRrbJy7EwpTJhX9yI946yQ8pTANwcRoXXz2xRwlm3hAq1cDj+iUH2PfVC0T+ddO1wYN0TnUiECfTbPOb0YPF3iSrWn/qClYDIqpbgcHEuIb7ZVmE6f2qhgHi1oIgNLFEuMb1xLtDhmQeV8oRxm9uk3CJmgtAPJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6ScgZ68v8bhnU3PlrE8DP4QpmE7KwuFmbi/7VZv2Ss=;
 b=d2MyuAmDVrMJHASsCu/W7SfEUntm+2966tX/0DcUHM1Pk8s1fhD9hVcdXStmXD20cBELTRntyDJz0dLSSFrB2t7XwfbQxixW698kraW3amZ7lqioBgYcJuqMbyQFlL079Bl2zYmgg5T54j3ML24Qp+Qf00t1+xNN39PpblCx0Ss=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:04:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 22/35] scsi: Have scsi-ml retry read_capacity_16 errors
Date:   Sat, 22 Oct 2022 22:03:50 -0500
Message-Id: <20221023030403.33845-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0429.namprd03.prod.outlook.com
 (2603:10b6:610:10e::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 285dc738-eb72-4f37-d22e-08dab4a353d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Qigzue2Fjy1xio7DjNYm8pnkqKhrES3NyDYIbNGTOF2T24KmdL23wBXfJGjPmPxTi6A5uG+6HOs6zljtJ24dbewaMc78vUS7HpWdVbQ8/pvozOYT9PFWq7jtQ8mqeov6IhdRFNiQd/Nvm+lr3o+TocLC1eKzZ/Q4JS6Alxz2E8WFtO7vjTkr+gXakTLDwmh8zJkuaqfy1eS19ee8YLzp2T8u5pBEVHReV3xGioP2BucsRV7VR6js8nRjZpHo6kj90gMHXJzLWxbWO8UqBCHziPRD32H0UVCj9xyzroDKFaF0cRT7paOOu01KBEZRMt9mhLbpiUTFjwx4QwKB+p7//XWGGxNMYCLgf/7nXRwrMYNbX/evd/Ki3Np8mFyOsR3swlMpHEwYvJQ1gm6p/etYTKTjo+Dc3VGGbYa3CEmpW+iKIzBK98D4rJhl9eWC4qaPGelWV2rHuEvcOF29kY2Uo9CvgXQcRbb5R2NAcEtR7o2+NlnifxtFq9qz+J5D1nimP0e/pTXeBtmLp8HPxIvvqd3Youa0QbNkddPRIBEWayulkDwOC/GdMxWWCwIaVwEhohC0YXvd4NJ6KXf8uZ09zuXPZ3lQMVgOb4rXb6kzDi+teltTDyfNyOj1g1sooQXIsjx/fIzeCWUQqUJYTY1YkWE1HwNw8M3Ex9I6jje2ad7xEDULdj34FhFbo1nUcAsWLMAMv+fkD+ZjwYRIWWtQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?38ghKRjR2GjIqqdly+i3/l75dudWXGatijmBvfLLNLJ51tdMqrtHeMgTQmzM?=
 =?us-ascii?Q?tS0bpmP+AnWGlik8hYJc5l9fXyjTPvCyPzAizY6tbc8uK6UowBEcJKwMtUVN?=
 =?us-ascii?Q?Iv7tXnnvv3iCelCZiAULELX0Q8V0KBg0x1OaP8t21aSSl3W1wxodHGCwItdC?=
 =?us-ascii?Q?t1bA7BTKL4/uZLYQltNONTkNozLEzktdVCjgnmM+isvSdqJEKlnsxHTTsFVO?=
 =?us-ascii?Q?7ynsn/y+ZndMcY2q8jOX0HTudBxhWj6s7FClKR28q3GpR7lNbhcgmhN6tBFp?=
 =?us-ascii?Q?ket3mfnoAW0ezEBmSzkWiK7c+VooDPQTJhJ5k3HmBXM0XqsiICuwI0GIpEbQ?=
 =?us-ascii?Q?WkhPzmmJgOhYuyLphFIF0k+3F6iLRz8O/G9KkNsE9UbNqnWJlpwU7BLrRUFu?=
 =?us-ascii?Q?f8kc001yPB+8YSsE9d/dE8LNINERkNBws5AKDAdO+fJFdayxD/2tHxMiCRfG?=
 =?us-ascii?Q?MzJeTbhMHGXHb1RR+X5df2eBS11LQEfZb9ZDGU4h0rs1JspuFnGbnmE+x+uY?=
 =?us-ascii?Q?neS8AxhMcoz9P+A5BoWne1jXYyeAc2jRfyBsD147cDzlSrx9TO0Ogmue42KJ?=
 =?us-ascii?Q?TTeiFcu5+NfHtuAWUW+WH4lCH09ur0qQG7bm4Kd8LkH3y6/KtP8sA+zvzGYH?=
 =?us-ascii?Q?I5W2Djj8uy9W4yVURJVqHnO1NF4qRihpmswef+drS4rMc2lwcT4McyTNXDeB?=
 =?us-ascii?Q?0Xei75BCoA2k6rer79oeaMx94UfSEizKws57L9py8/kv8dXPj3N7Mo9ryCiX?=
 =?us-ascii?Q?80vjL6tuBY0lVY1yq6l0jI5SXWRzyJnUnH6j6+5mDtc8ViUjjsR+2AMci0X1?=
 =?us-ascii?Q?HHL5QLsGobXBLQN2PPVR+kk5vDRERMob9nAs0CuId2I3brRSx5f7Kfl36GLq?=
 =?us-ascii?Q?ehQc8PIXwtMH5eu2aPOVwgBwqNGaPrgNMJHBNX/tYp7U/9uRkVEFE9m5AzH0?=
 =?us-ascii?Q?4cIs2oqotphBdCsZuK2E6UWcFsJopO1avxwVzGBufsoO9XPlCxOwQr6FEipu?=
 =?us-ascii?Q?8rY3NfBwd9qLKHhBUclQXwBf9qVeXqrDf0OSOcG0nXJ4zpdMDE5DMK8FiNEv?=
 =?us-ascii?Q?9TLsO4m9uAodkcG6TbY/Ke+Au+FJ4g45xCvX3GRBdatzmOG6/gCGnQp0QJaH?=
 =?us-ascii?Q?XofRFexA9jl9yTeENeXFC2GVAlwqhEBYWXP4pdC5z3gSu1lXl6pgoIHFPdku?=
 =?us-ascii?Q?Z5JcXWRLPQq3QqB2YrII4jRJQI+l9NuhtcWbAkSNVG/Cyb+lSo7G+YMABy8O?=
 =?us-ascii?Q?/cmoHQoGZn3mwHYMCdN9ikibkQl3CgMEZNfgyoCpEeCUap+6YtaqRz2+tRpP?=
 =?us-ascii?Q?wf4FZzpqA/ykkpo1G3F5F1lvXV6PM4KcLekrLaK6hT4qR374caFZIrXxbgDR?=
 =?us-ascii?Q?lL/fP7Avz+iilrPNbLaOd2rPhFflvjuCqYZu9ySYY2tCIdja2cp6bGFsUUIK?=
 =?us-ascii?Q?pZlXcB5MoUG4pksIEjfwCLmCR6mzNS2DPlMoSg0gillRGcul+A+BaxuflO9p?=
 =?us-ascii?Q?EBK/cDhNgnmluWszkkYjyzg4jZ9WcMsdJNjhcuujTzgMvyIwXI0PvQvkLGca?=
 =?us-ascii?Q?L4zyDahn6PtYYJ/A6n02FgJGWx5Sh7HiFNPzohlrxlY6hd4IjOSO80+HCK22?=
 =?us-ascii?Q?GQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 285dc738-eb72-4f37-d22e-08dab4a353d6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:40.6540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iYisKMKrdGphy38HqTHTXFtz+YmoAplRh+u5C4k/tKRgpAhTzFVJTN8WE7xfYfnZR7Vme50JBgf4rYp5ZiYl8C+BceWc9kKmWJ/U1zob8ek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-GUID: E_VHi-wrA-8k_OHCZnYxVA1mNDmcYrkL
X-Proofpoint-ORIG-GUID: E_VHi-wrA-8k_OHCZnYxVA1mNDmcYrkL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_16 have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 115 +++++++++++++++++++++++++++++-----------------
 1 file changed, 74 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 37eafa968116..c94c3cdffa90 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2279,59 +2279,92 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[16] = { SERVICE_ACTION_IN_16, SAI_READ_CAPACITY_16,
+				    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, RC16_LEN };
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
+	struct scsi_failure failures[] = {
+		/*
+		 * Fail immediately for Invalid Command Operation Code or
+		 * Invalid Field in CDB.
+		 */
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x20,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x24,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
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
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
-	do {
-		memset(cmd, 0, 16);
-		cmd[0] = SERVICE_ACTION_IN_16;
-		cmd[1] = SAI_READ_CAPACITY_16;
-		cmd[13] = RC16_LEN;
-		memset(buffer, 0, RC16_LEN);
-
-		the_result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdp,
-						.cmd = cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = buffer,
-						.buf_len = RC16_LEN,
-						.sshdr = &sshdr,
-						.timeout = SD_TIMEOUT,
-						.retries = sdkp->max_retries }));
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
+	the_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = RC16_LEN,
+					.sshdr = &sshdr,
+					.timeout = SD_TIMEOUT,
+					.retries = sdkp->max_retries,
+					.failures = failures }));
 
-		if (the_result > 0) {
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == ILLEGAL_REQUEST &&
-			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-			    sshdr.ascq == 0x00)
-				/* Invalid Command Operation Code or
-				 * Invalid Field in CDB, just retry
-				 * silently with RC10 */
-				return -EINVAL;
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	if (media_not_present(sdkp, &sshdr))
+		return -ENODEV;
 
-	} while (the_result && retries);
+	if (the_result > 0) {
+		sense_valid = scsi_sense_valid(&sshdr);
+		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
+		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+		     sshdr.ascq == 0x00)
+			/*
+			 * Invalid Command Operation Code or Invalid Field in
+			 * CDB, just retry silently with RC10
+			 */
+			return -EINVAL;
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-- 
2.25.1

