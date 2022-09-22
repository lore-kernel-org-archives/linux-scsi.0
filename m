Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AB4C6FA8B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiIVKJM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiIVKII (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:08:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B5CD62C8
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:08:00 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3sZU006437;
        Thu, 22 Sep 2022 10:07:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=KerVW7+FQJZBZooJ5aW6BJa3Hw3itlQgKI4HlUWYIDc=;
 b=UWmZMbkAiPwlVaZ+B/LdVfk4D3SMaILrjLef1stG6NLGpBjvpAE3EqWdAmdXSTpGLcxA
 1rakSUp8XnauUNUaX1iJkgpWoyIp7k3JIcKFksr47vXAWNIJNx9ndhnoj91iQ8VJ0p86
 tQD2C7+bs+kkFmCmv+ggu+e1Ii+l+7YaL6FWvMbZW0rFb+oVztN2V3r/TL8n0vsZFh0t
 bfD3zXtXrDQFfBIfIWPR/kxaN7+clW1zYBLan8G9AG3CLermWH5lTHzNvUI/DU4zr2DV
 RwkoJ/oqnUKK8hYnWIXslpfuLIq011wiKWxFb2rs4Y8Us/xNObxIYm5mnunsHhLwRjtE rw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68md28e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8l4L3028266;
        Thu, 22 Sep 2022 10:07:34 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cqdxyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Anua3tkGXo7DIB4vBwXKzRR6h1rXDlEMn8Ttt7CL7ENi8VYPkR3luv2lrFrkvmggMgsdr2NIjo+guhhOhkaxPv9C6ay3T/2CCjoyg7At27Bc+kV795UHf4MRhLfPpDgAv6C3ubIxkMiMhH2WVnf6TP6LPfg4XpbtROBrdK8A74hZUxid0Kixfg/W8njMORQsFTU/nB9aZYLt2NbYR9Sju3V3jGAN/EJRn5s50lee9wvtTAKN7iUqyhmWVRNuUAdj0Mnhkq1zeOc08w/SOMqE7ualkRLCM6L1ueDo2mxISfdArZzuLvL3WtZt+EcygRkLaGcklBA48tiubsp2lhFGzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KerVW7+FQJZBZooJ5aW6BJa3Hw3itlQgKI4HlUWYIDc=;
 b=bDQjIV1ir/Dd8XDag4rEJDb2NCtGu0YS82YVKyshtdZxaJr8nYlxhXaBooZRX1wVsgKj2geB4asatZC0Foa7FhsICThTEQ9sWBOzn6lEuAjGA3TUhpGNwMJz1xbscFKVKQ05qcOM2K2qq4RkzV2xeGPej0YawpDwpnLw/MMzfFzHp/W2Aun01aQ7WaV9rfqUpdgsJrZZiuMU3BvZwJHzfP8YyiZn3eByj0THBdDwokAuGs3g0F9NQu7DZ/yVStkjKfQZqls7MWg1XrTmgHihmDyawITrsYo6dkZmKw2k49Xo8V2lp59dZzORMDzeVvHO1xvSzOZzUpfONYOf6pzdEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KerVW7+FQJZBZooJ5aW6BJa3Hw3itlQgKI4HlUWYIDc=;
 b=BCYzEmpjvr4Hq1bopQTg+f3SkcjQzi43k3nKmIwDS8vJ4tCACDodL67yDkZIoYv3TxFv7mqGmRfi7STkUKNlcgGQHYntF8715A17oDZy5Qa2gROwhf3A9uf7roPBAm+PcBmgtM4n7DMXejwEZaiovKwUHe5xCmd9KJ4gMewp4yM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6528.namprd10.prod.outlook.com (2603:10b6:510:228::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 10:07:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 16/22] scsi: Have scsi-ml retry scsi_mode_sense errors
Date:   Thu, 22 Sep 2022 05:06:58 -0500
Message-Id: <20220922100704.753666-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P223CA0019.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::7) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: 91174a77-bbd7-46a7-c2da-08da9c824400
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fLOpbPElyBdfQdvIlMK01wuklHSzIshLkN3wugkprR5F0/RPYaKN0Uk9qNaq8ztIjpIQo3bwC1uugYXbiNa7qov+pfIrjBQbAtk9T2YoReh1xKpQ4pwy1hE0xehxtfLTvnW06gSu+phcz+3HSi1E9r6FsUxWQiBW0YfrjCekWGZ73o1yMQRp8nXoqFFqvjG9TNKQaQQEKM68IYuXUaGDjO8OLCGmG5CfBmWqUU1KTjjIaeZ1aUeMQBXoOnx/te+bwS+7IB9dmS4L3boPYwKUCk28pQNcI+L2hrF2K7WJSqCqW+0jjsXkEOz7xkBJRY9CrJ9sXN0SnnDrqxhuE0HWBKiBxX606nHRzVgik9mBzmU01U4zFKPvDkhGGs0Gw30KjXYCus3ZjYqDzCTP0lkDRA0/2E2/FyNmBn3ibtecQ6cvLXPFXDhsVQ3ZEEjtzfW9sVn1gcMPTEHFeODSSZb/GVDgq3eit+28ZLM+M65b1FQznnr/L/iQfP0y4UyQVroeIcXvEiREAT+WNw+A04JNQ3saR/7Hggf/njj+NDM+yec1h4HhTd30eVQa8wQOnHsFPcB1DYR72jrM+8ZLFvkG9jtSaYN/XM4BsYkGKrkYjS69zUxP4TiUUZFVoYCeOgJbpYf8AG31UsScGSLUHXRihGqysg8xf2QrrAYubZJQl6eoOIf/BYb8emFoNr9wGwlj9P6P+iHbeRzpSwb4U4VU2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199015)(38100700002)(2906002)(6486002)(478600001)(8936002)(316002)(5660300002)(4326008)(66946007)(66476007)(66556008)(8676002)(36756003)(26005)(6512007)(6666004)(6506007)(41300700001)(83380400001)(107886003)(186003)(1076003)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KYEqXdSVewL1/4jddCrEwjGFbDSq2qw7V5CESBKcMi0JGZT+N0/Jz5z5SU35?=
 =?us-ascii?Q?9sjq320/qvCnvcZdAJuBnDjo8BVVtPZSuGv2LsEiWZBLtz3FmSm7GgPKQv+P?=
 =?us-ascii?Q?qEnxi5qZnV+tHo0pfVxJkT8LHY98OmJMsq+rjLyCTseY2rrnOUYJtqkO771T?=
 =?us-ascii?Q?5RCjOh3ivdvtt4AqDJFExC5Iuv2D2R6sS4IqJvu+8hISp9EL7Eaz4n8bZwYQ?=
 =?us-ascii?Q?OXEMAF9FpVQ1UcC6mCKY1TIRQXSIZoe9M3Knoykbd4skLMw270OW/Smrr/R1?=
 =?us-ascii?Q?yzhf5PSI8QXm6iIzyhBs0Vxn7j44LjGGuz2DSzNyrXB0y2l7eVAx+BbcaE0O?=
 =?us-ascii?Q?Wut9XR3EePmGZFsvdT00OkSoTW2ExjkW+wHR2glIvuxNK1AUlauKOVcAqf4K?=
 =?us-ascii?Q?YH4RzpBfIGiBAGkvG0L46bJ/m2hH+RHB/hy4d1KBVeXRckzFm4jez5ArZDZv?=
 =?us-ascii?Q?mjs34U3AKwACiGrRYCB7THwCzP5F1ClAsuT27PEM5ZIk3GkDg/oxPayMvSH6?=
 =?us-ascii?Q?YoqzX9U3v9volv6ArCQIe1YbuBJ4LdTTUEA8ya4rQxw1Bfunwmy/a1KIiw6p?=
 =?us-ascii?Q?7aZbBhTarZgmJexjYPyId+pnQLRZmJdPyhwR0gGhMtscusayPYfdvfHPTT03?=
 =?us-ascii?Q?etTm5ibSD3F1YqivaJdSd3GaMwk8yy4rtP4fjKDInqy9BGd9VoABLDq8svcq?=
 =?us-ascii?Q?yd1zqFi6Lo1/VrLHqWuoGJLSx9lCLG11N6jGlV4wfP93YcQ/VpEniVGTtSoS?=
 =?us-ascii?Q?77oyApYCcP0lg5FNrkkk3QiFJ3oeYad78A5mBYlalSMruw3ZY5LfCFsM7/Yt?=
 =?us-ascii?Q?E4zqjNvrIY8/oNpzolWi/8ux8ZakqJ590kSzEZdnoO28u0x41EyebSAD51ct?=
 =?us-ascii?Q?eb3P0NbJHBva+SCq7ujNHxpYZgper1vmzSwgJ9PlhqWyy/fqPXCs5AbInvQf?=
 =?us-ascii?Q?0sZE1T+otffruSthRuA+NWyTt9WuBAQ0U8RgfV3rxwZSmfdvX1b230jW84Wd?=
 =?us-ascii?Q?xKgvIosp0b9vB/fvqdJ7U+xccpOUWQciOpZAqjVV5KqRr/dc67IE8aTZUaUJ?=
 =?us-ascii?Q?wG4L0cYPKza9vVA5Fe6rtDIFD7CpCecaH4kR1ADjrnzqxIoxCLnk6Wpr0emk?=
 =?us-ascii?Q?VnjdLhdl7E9pDno9iTefGWohgqYcM7b03TMWIIkHzD9Pxon85J+8pgcoewt+?=
 =?us-ascii?Q?Wjn/QXlcPR4q/lU/hw8PLm8i0BQA6kNOcRorQPsjHIEsEGLlolHhs+v4NQZK?=
 =?us-ascii?Q?yZ35NCKDIcnO3ETX6/XUosaxD3r7xdez8O0KOrcoHZdnPklyuaQUNGSsiGO5?=
 =?us-ascii?Q?ssWTZo/jEL1F0Qmo1WpYBHJ9wpmYGtOh0l6c+q24M4thuCZFF0RqULoN4g7s?=
 =?us-ascii?Q?g2v01E9i+fzeVe6/GaQOk7RvwXeTMdTL7vgmS9J2nsnP1Me7JAnnDTyUOi57?=
 =?us-ascii?Q?Z2okzewQMREm+DpSOTH3RCAt2SBkFigm8qC3UpbPWlsH3ZKTAehcf/dHPOjA?=
 =?us-ascii?Q?UiTEm0bQa0bAZsZtbH117We0zlTSZSrWHFXdS5bV8bGlDOI60zfOu+dMkNNo?=
 =?us-ascii?Q?pYWBjOD8Zt27h/AB7Ju8UXZmudirE1d7a9uPgBh2O4gc+U5ApbcTKz+nPLFY?=
 =?us-ascii?Q?5A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91174a77-bbd7-46a7-c2da-08da9c824400
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:33.1147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 02Yp0AzqVw4yxIurNTuI6aNIjp7GlMboeMVjzCFwQL4Kabprmgc02JpodIxFSCD2ygvxrORpiFrei4CHsoWstEFAaZI8JqsxkutyXZv2UM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6528
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: -1NY-tbQ8Fro4ScRFtu06qJ-NN1R1MGV
X-Proofpoint-GUID: -1NY-tbQ8Fro4ScRFtu06qJ-NN1R1MGV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_mode_sense have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7e4cc0b28f61..c708503d574e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2170,8 +2170,18 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
-	int result, retry_count = retries;
+	int result;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = retries,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	memset(data, 0, sizeof(*data));
 	memset(&cmd[0], 0, 12);
@@ -2206,7 +2216,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	memset(buffer, 0, len);
 
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
-				  sshdr, timeout, retries, NULL, NULL);
+				  sshdr, timeout, retries, NULL, failures);
 	if (result < 0)
 		return result;
 
@@ -2233,12 +2243,6 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 					goto retry;
 				}
 			}
-			if (scsi_status_is_check_condition(result) &&
-			    sshdr->sense_key == UNIT_ATTENTION &&
-			    retry_count) {
-				retry_count--;
-				goto retry;
-			}
 		}
 		return -EIO;
 	}
-- 
2.25.1

