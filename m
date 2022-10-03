Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40BDC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJCR6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiJCR5U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:57:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CA040E29
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:56:39 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOYgY015780;
        Mon, 3 Oct 2022 17:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=4E+jWLkxDul2trY3gNhCf4CD1JooEgzlz2CsRZhp1YY=;
 b=AHdeaW+knmzHWrMisWx31gERADefUe6C5oDaOXX/Rmm+kT//JyTGF4prv1aD+u/QpGNf
 fwt6svy3WQZMiMRLYSb8LBttX25X6zq1DMujfQ10uJsKco4uUQbj11retkHUYH1stVZf
 L7sfiQYj/peH+YXFgYsIHR8w84QBhjjCW2SM32YfZUrYm7IcyugWPti4Hht4C6kwhPIJ
 0qFNmA1e6fWV9sU3jhleOtd9Rz9/H2SzRIao/Dfiv0ROCguIZRLyVVse+kLHD2p6rTLV
 ZAHMekETTSpTyJ8mMK3ubmyNkTECdP1P8V5J4NhtMF3tsu2VWBsgofMAC5BX43EEUI/k 6g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxdea4cxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:26 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293HoVuE028041;
        Mon, 3 Oct 2022 17:54:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09gds7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aS9S5FGzMBwhfRy9t9vNTjuuJOt1ZzwmlzoFRSCwecI5JKgOX7AWmQ3PqhUbx2UlUEg5hN+rJ1kbURUK+eblg8Vf3xTVCTK8UnX31Uwj/hqtZuBs/8tR8f9+TG83gNkUkh1SZ2HketSlL0VPOJk1W976k1xz996DB0OI56wGLvSQTQX4Hf9Ln9l5XdCoI+bs4cwPm/m0fVkdZ9S+sWsfV82sTMm1i2UEml1jfBPaXyqWjFJHSplOA6upBVG9zFlXZ21tQvNpH+4sSzdfoZrwIl7L8uzLnZYCwOD2+OPrZKHlBna+RPIE3Y7fUBvc2j1n1koiXPMtH2cp+aDTfF5/OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4E+jWLkxDul2trY3gNhCf4CD1JooEgzlz2CsRZhp1YY=;
 b=XwGtsYLFmZDE/lqBFllts2LBh93Zn1WK6O1BmP9khtI65rePqXsDW5P5QJDVwEbsE9HhOEX75aS4mXhS03ZNhpSj5vUJ26Z6xLqb5xTUP8M2IFePIojaAb3wy381Wt1xW/+BkOtr8ag4dd0EeFxeAyh2DqSwLcpap5jwtUI2yjr+40/oiz3k0gKkC0apDsC83nVSVLyNSmVWBdnTZUZBThp2HLC7L3rAhNcRt1/xh+kaVYlUXqZTWmNthuqVVdgQ8mqEN6HakhYoPycp93GQ6jA7YYxuM4TSQV1lmJaewkCe0JSSLGFKS1HYbiUdupArkvW1e/aUFX+FyM+5lAeRQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4E+jWLkxDul2trY3gNhCf4CD1JooEgzlz2CsRZhp1YY=;
 b=MEr1CepPNGdEEj1iR9jMz9FIR8vcdmSn1SP+66rt7WXnF3VLcFqQvNDzm0cT4sVcVXxdmcB94T06kf9Uw0TEcHu7Z70GJwrhTSWdZLxrGrurAaTPIiqUHWYNHQcT6OlkWbQH315+XuNIbRZLz5ApmKKSjb2B/2rByojcRydrPWU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:54:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:54:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 34/35] scsi: sr: Have scsi-ml retry get_sectorsize errors
Date:   Mon,  3 Oct 2022 12:53:20 -0500
Message-Id: <20221003175321.8040-35-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0067.namprd05.prod.outlook.com
 (2603:10b6:610:38::44) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: a25a86b9-2e64-4a46-f6cc-08daa56848ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EQeTGQ9OaFsjYOb+PCobXWLJSZWSy5TehTgFupZ5o5hRVrXoQU6baKrNRLJu6T6GRLsQ73HRfm/7SdgreR389AnoVnmngg0VGIOOYSz7971EaOFV7AhL/pWdF4XIL1hgnI/uF2qs5mPgU3J9WQScTiIonHDKw+PRwoXMiGPyR9QOAxpPQskbm6jbu193VHCUfmlGv5E/Kfvz4KE4sNaPPjipoqH8u/+IGQjy7BxXauS/aUoPEScIHuGhNNnmGQQDhPpOXUN02YXEGrp4bjqGcuFL6ewq5WUL6DfoxGVj9DxM9pz5Cx/PkyrpW/oZ/iwSPF3C6WirQW2dEQ2I4O8mOa8dQ/Fu7RNLJHOtboiF2wvq4YBgM5s+GJER9uMas4RNWKowU82wfmtO0zAcrNdYDo3ZicYpHABok85UmBC7W+o8RLScqOToeZ8md+53EzKl1CJzbpDb7Tnz29/WIXx3bJyTPsZWED3FYLHLoYny2Mx/minKzgXNXSf5fFGe1yCauXqZK6tQjabm4JQ/3sRaumF5/pbwxNLaN+Tw9nIKZrTbHuJz2boft/k1ciBPeko/PwHxJc0G6uAmMV5dZF7GzcZarFuwDmzJU8UOEhTywCQNqeSRQyWnZJRz3rC6nozaixsoP2IonteIOwwDrDB1hNJv798bTzHgfjP+Q+N7QrMSAEFw34zbfYu6/XWDrR/eGN39kJVPkwLDadQ/IXv4xQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(83380400001)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(6666004)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tAPWNsESd5N+Ab/VWM4SlwxmcL0CyIRyufJYNTqS3zfiXJjybIU/GZHSPjdk?=
 =?us-ascii?Q?RlM9gQhSmwRW33ObIcEyYQTvlyNVbMC2BI/Sr3nhSv4hO3tqa44GSOYTFBS3?=
 =?us-ascii?Q?vIHh6tkTSULmzXhCse7G1niPacIkPSS+quyxS3ydqD1GeHrbH4Hshv2LLEW0?=
 =?us-ascii?Q?53vnyk3BZqCkn8gDrbIAxNLX8NiRZfidGLO01yNV22Ul7Xcj00lo3glxcunY?=
 =?us-ascii?Q?JtEqwJSSMjdzokrRXQwI1Lxvdl0Mop0KTSy1bli3aTibXlc+RgT0V6ITGYmK?=
 =?us-ascii?Q?ThKzw3T2bfSUiX2ObWknEMS0mVrtLTHhQwiqYptvW5ihPcHbaoH2CKkltXoV?=
 =?us-ascii?Q?3OYvvLclwOsdw4bwDav5/TEbZ2+yvw7XgSpF1f2iCVWJEVqlAfQeZjXq+yzP?=
 =?us-ascii?Q?8zGgHVYTVEbc6nz1pZUP70aUTWcNJQhyj1rO0q4nyQAYKtfTGVuIxYOxmR2a?=
 =?us-ascii?Q?JJfWdCyz5xpW+WjKfiPZhKvliTWajDfXMaTrXDQ4/C7fdDTDbsl/PMfcahLT?=
 =?us-ascii?Q?ipdUfe6pbBj3JfF0pFXtq+oZrKaEWBiOy1qiZP+u2QwtadU6agjmj/CXxOY9?=
 =?us-ascii?Q?atzFy2V33aA5WdsNLfDX3FxGOiX1Uq4rV25y4whaS7w5JAsdA3mEYu5902TZ?=
 =?us-ascii?Q?B7Hrk4uP3gwpepuA3zOGY6X2CxT/jxDah71n+lodzID6uycEpCbxNxJkMM2P?=
 =?us-ascii?Q?64dpYZYY7yspw9FtwOxuandWPna3h7OhwzPGGnCXKzYslnJ+WdEuCzpcNELV?=
 =?us-ascii?Q?k3BT86ARf0OzLbXpf0GOhFj5QIeSJnopHxMropJFrX/gMHFNYmwWMxCZR+ki?=
 =?us-ascii?Q?0jvV1C/8irWor/gls8SHbpygPh6/NJYEnFPhiwgeOWJmEGLK8ewBYG8WC3dA?=
 =?us-ascii?Q?4y07YqMIpNSVOupFRwR6Ot4ZBAHjZkq+3gkJd3DLZ//zpm6Fl74harw2zCJY?=
 =?us-ascii?Q?bGPulcRR6bPpP0KzbmzOV8m6QQu2MDfdT3K/tkBKwN4JBtrOE7k5WpnC8CWo?=
 =?us-ascii?Q?YVUd9qM0BETXT6sWn4v8/U5Iq/R5CHdwkdMOl3XJSb4pC9taCMCwI8//88qH?=
 =?us-ascii?Q?KmAN9GvQYgM2nXwYLPRF/LGTt3x+1yZ9lDFgLmOxnkb5bj6gIdSWChu6NstF?=
 =?us-ascii?Q?LdpWBtHcl7+H2qYsl/cImO4XOjgjFl2SMA779+miYh3PliDJYuB2LNR4EDus?=
 =?us-ascii?Q?ZobRNhb3jeVpp65WCsLd2PSI1PHzKH4iwTGdHKJMqJSrDVPrwZvLtNGFRSu6?=
 =?us-ascii?Q?tyRVVuT4sdZUVNMOH3NhvlfESnNpNmGsJ9fJXpp0FW0cbIAPjBBY+HVDnYua?=
 =?us-ascii?Q?7Tu0L9R/2GAoN44KG/jJ4OvrGyDyxsZYpyEoPmht1lTQ4ZsHoQA/PjmXw1jz?=
 =?us-ascii?Q?CeX754DjYQjwMa0GW891nlzNlX/lpiro68wHbrH6TZO11zA2dbMG6C6mFXeD?=
 =?us-ascii?Q?r7UFgFhxq0ztIoA4+STqoiZFM0nH7ITq/5ux+VlYep3F5DcJVYWWC4vsOff/?=
 =?us-ascii?Q?AEiqt0i96uFarP59kW9eevzpjLUmSyY7UPAWOz2Pwy3d4v4fc2pGOfjSFHvA?=
 =?us-ascii?Q?0DBtAX21mZ2/nR3C1MtHh3ztRp8+xs6vqh+FAQIQpsBQpCDcir2ir669nOdN?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a25a86b9-2e64-4a46-f6cc-08daa56848ee
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:54:14.6086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+QrLmS6Rpnk5BSOy4PuQHkrhYf0AWnbwbkSGLfmkMCnu4VUSma/jEaBZcSjQZEurUF/TTfUzTObwPL1jowIGCbMY/yPApQ4Afev09rUfs0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: bVW5vPcnec6yYK5PUGvJenZnDIjLwIuo
X-Proofpoint-ORIG-GUID: bVW5vPcnec6yYK5PUGvJenZnDIjLwIuo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has get_sectorsize have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sr.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e3171f040fe1..8e21ad83e938 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -727,30 +727,31 @@ static void get_sectorsize(struct scsi_cd *cd)
 {
 	unsigned char cmd[10];
 	unsigned char buffer[8];
-	int the_result, retries = 3;
+	int the_result;
 	int sector_size;
 	struct request_queue *queue;
+	struct scsi_failure failures[] = {
+		{
+			.result = SCMD_FAILURE_ANY,
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
+	cmd[0] = READ_CAPACITY;
+	memset((void *) &cmd[1], 0, 9);
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

