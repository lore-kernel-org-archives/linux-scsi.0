Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9236C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiKDXY6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKDXYa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41ECB26559
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:21 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4KhrE5027170;
        Fri, 4 Nov 2022 23:22:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5uqhdzGgE/rCoB/SUdvG85da4KdSfqB+65Z2+kJdvik=;
 b=VZKiL4OUopD2MCqtoPTGG9ABfmJbkmihapxdGVwKsAno2+0DCgrxPk074ApFFaJseQJn
 4gDaC5JPPTp/B8zEtMCCwDXS94bf+y/VxhHNS27HSfiKS1AeYA+qDu3Z74G08RZjne/Q
 ztQo2p6z1Ou2spj3r5M1LRp2p6bb4mlCAKUZCSoGDPIOeFwE0upsfYaaYoIjJoXfFgaT
 d/ecuAl3k0N172GngeNPmMuUgl5ykoHvJ3joPLJEK5wbiTURZ6AUW8qvQCfSGX9P1+Hr
 Z/m8IHhMSnQRvl+6R/efyyNBLKCk7k4PPp/7DyfJkuOJGwwaxmuPN7c1BXdkc7DEugvy Qw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgust16e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4K9fXe012210;
        Fri, 4 Nov 2022 23:22:13 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpwn8cyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdEUYBL+/TVnOmmMFUSBuYoH3nBDnr14DRFITRID+zQ0zHZ42yQ4GEQ5bjUrNrh2tI4u2ZmxSyDMwyTqTmbQleuwsq6zwV66fijU5+IEhv1S1OOxUP/lp6z4w0gyTdaH+EE6c2ReVvjRCY5CHbOrN7CFBWlIE9n2uHJFKIrJ8pUz0yR7ddKZs0gnGPwQsfWFwcxxOiANipL8ryDLP8785j5kfDf++6bac7/pabI3FutlZPPpvboNe8V5Uc+PlrjFSSNFWWbkvVVu2/qt6jfBySqOv9IV9fuM5ZCLGYFA31IrEqwyzH+vmUZ4EcyKXUXjoElIHAp7dTIKHNnkXok+xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uqhdzGgE/rCoB/SUdvG85da4KdSfqB+65Z2+kJdvik=;
 b=dptvjxc+20g50LAXe7l+6kIY+BMHq9tWVYtaYUW6ZKc1CxNpVDPJTYND71KsOZckgl0GU6xWMte74drpyjBPapY+RINGBfIMN1Nq1o7uI+2cUEm7xB9FAJJuTSuQa6nOYwhlG8/HTD3WgzuH7wadZ1p/xu3DiX6SFH5dSxso8dOlwr9w2mQlx06wfs4865ZY8bpBsKRMnTDgGocXGew/lFKdug5E6Fja/X5ei6RHNEy5YxTQs9Amjg+Eo1KSXlvf7Jtp9+3AwEfX+5l47/Yd+j88dfqUYhWl2aNE6Bu1BX/cNYnFcms5S/GWhlRuB7qXS4rqaPoHIucGg1dOG1Q53Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uqhdzGgE/rCoB/SUdvG85da4KdSfqB+65Z2+kJdvik=;
 b=b31tkc1PxdtSgZLr8Lksmk3t9bYp3N5tmdWRlQvT57gsZEjOJyllkJunzRX80cUDXNEiru5Tyhny1ykchttJK0RmA1d2NMlBOznvLMJ/nFtF2lWI8yh8L4L6jny6Nmto/P01GymcsWY8/gZNf8rlOjXmW1PSuaflGCH3YfDeJNs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:22:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 22/35] scsi: Have scsi-ml retry sd_spinup_disk errors
Date:   Fri,  4 Nov 2022 18:19:14 -0500
Message-Id: <20221104231927.9613-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0102.namprd04.prod.outlook.com
 (2603:10b6:610:75::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: edef3e1e-190e-4f9e-ad04-08dabebb634d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CrdslY9izpnsOaWDha2gZ5kLQh7Ib6AkCIGcqa0QsnhzPw+hXLeLFQCFG52JyOSxe8E9LUtO8/qLwD0pFiJuhvc/LuwmmuDdRak9GYbh9zaMk2Br++PdZBpkQHM8Mj3P9lcEv6ai8KdKA9lrbUo+ZQOLHniezzymOEzzu0Xx9SExAYzM/6lX2Lvf9Kssk7rj/mV18BTqHZFQ6E805PgRfkxnjLrHNyinx3mOXvujRd59NYKT2iyhIVGc9i7byfiILOCY/A0UaXu+DX5+uWLOYKFOp76EI1uXXEP6KYvDl4Pn8iMkGkUt7na17Vd+63j2WVyuMh8Qt2lfXdzFuJ5FhDdrVR0Dq0otmp+18SO1/1Ao9mUHjQ7UwDsLxXRi5aUCMzHkdJbmI5uzbEUyboJSyRcSQRCqRFICekkmfg2vsYbSZJK/yehglRhQ2+LDHDG19/vSXkJRgkz8pNDoT4GB3HZiAvD8o2VpoQrK2oJ/PYU8Fr8WO0otjrOrOpNkYAhqWeYPAd/I/N6koEKohtdyx2BarNfI0SNuPEjcc04KEnXYbaRb+pOPKN7DwwFbM2IssJ6xF8COjgd2hUCQBuOd0IU2i9TxRgoqZD1SfGuYokciCGdYfuVQq2lIsAzAEW4CdRd7a1HFV8pXG1B1xkYUQenz33N+VERhxVUjSjZHo8YLaQ7jTPIhdNodcdULYe5yPF8gJc/CwcHo5dz0FvGzhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sESacUDFSxM6XMbUcYJCANiKLgmIbKwvbQjTEoyQpzHt+POUCM2NxSBUnv9u?=
 =?us-ascii?Q?Jeb0iYRphxLcI0oYf+lRX71iPBKgSp/eHiaZv9wWPnMRJHDkxYMTUGCFqyIN?=
 =?us-ascii?Q?xsvKCG0lOQqUoUYB+cu0gKkI0n6bU0k/Nab+JFuez0qFJkv6DssM5PrtjcMj?=
 =?us-ascii?Q?Re/yJm7fqDvOL6xno0ciC1OYGdGmXnFVXdokLvpNIosLWlYeCPvEksRvZ7YD?=
 =?us-ascii?Q?64XaYAmThCE3t2OcwToxjCggpy8sA32OQara8LhTk89mUWqHW2lyUsQpO9Ob?=
 =?us-ascii?Q?nu9hajSJvED6mrMpKlAQQpaSCuU9+5iujHTMcrqA7FARSwUkuE0z+xtGl3kj?=
 =?us-ascii?Q?rPxecg242VmZsa6N8Io40x1gFca4hXw+4K3zWTmRCsS5Y6whcQyH3yg/xb3q?=
 =?us-ascii?Q?WidHBWTdf1pKIj3xfZJH9DddlaUyj2NJVIBZCyCTMtGs2xnstGPqiV0EPbX4?=
 =?us-ascii?Q?xTLMLIuDRw/IXEmosU3Y/OvtlUz8JlARlZjUz5tMwSBVQ5xGDP95/6xvFCze?=
 =?us-ascii?Q?xsOPldPhqZ6GGz17nTRJvQW5xLUq+E9ME2wG3Vc2N2nggQA+AGd4opuUHYgl?=
 =?us-ascii?Q?9JyjAuJWYqHe8Yqg3yGf6JL0ZMptxQzaNkeTfZhDcM8/i7kohvXZstGbL0Xs?=
 =?us-ascii?Q?qihnTomD5etFq3S47IMcHudypkAWtY7kE2IQcc+4k7DymqKcCrRJNgO/YEk9?=
 =?us-ascii?Q?h3wdz0EglOzsVTo7/6CJH4Gxx/WBbcl/IF4D7U7LRhCh3M7t9vHMJGUZUSWc?=
 =?us-ascii?Q?oS41PBENMDmxpuBHmUpSQRMnfqSe2V80qup+XBWcYuse1JloVbdon7+Ln/SO?=
 =?us-ascii?Q?sGaPDo042RGDEfH4yuy26TzWDeFiN3/qKi5Xoozb9XcfSvRlD2Glq5BGI0sh?=
 =?us-ascii?Q?mUVmGdxrbp8mr7TgWW577pU9lFKWd/kz390RT2VXoP8PTRmKHJlYd6pVv4Ef?=
 =?us-ascii?Q?2USARM6RVqpYU5UuLdfE165DaFXWo/wZWzih3gkgyn3S53JqhWAdI3VOfCvW?=
 =?us-ascii?Q?Cym9Tjaakc1LzpxeEuRIvBrnA6uWqIyjW1b7bgndQnBwvUzU4MIaJW3ucI5d?=
 =?us-ascii?Q?2B1lEp42tDaL1cBo1pyFzsR2C/V0yACUMnaWE0Vb9Z2AIy7xxKVDPFCGpDls?=
 =?us-ascii?Q?Dlc73tw5bwh6fUomUH8dL3l0U1T1lfshY1WHAQ7voJHFU5Bn1G5aHoooH8T8?=
 =?us-ascii?Q?NAo112pKWDBwhiOF1OxZdbroy13/nju6uJlA/QJnl0yXEP+J2DFSV4kxxD0O?=
 =?us-ascii?Q?5EPjJ6d9zH46yjK1d0dgAFI+a6HTI6q1mSmet/k9OyWVQgVxZLSHAf06Usmz?=
 =?us-ascii?Q?yFyjNO44xMkRn4bBQH7zOo6YM2dMAmSh6JwPdF7SA9deCzzgVXDb+PfpA9Tn?=
 =?us-ascii?Q?tHwUFLX/EZBAPWE/oLz/ZnfahlImdDdEcZr9HhwaYqHDkzz6o0aADphfKN9v?=
 =?us-ascii?Q?MZdAYpbdJhahvXRsUTmkVNF47PWJX7s6Vq6OBEX2i7ArGzbS7bWhnJ9ODsW1?=
 =?us-ascii?Q?b252wgVKK+XPqdCCchPO1Dv4iPcI0Z6XIOo+fS5pn+wWfUY/luZroB0boTIZ?=
 =?us-ascii?Q?t52rYcutzzQYr+GF8OTSPCJt5DNQtE/j7VGf3Qzfi/PX/74ZhhwHGjcwT9fZ?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edef3e1e-190e-4f9e-ad04-08dabebb634d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:22:06.1636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2BTGH+r8Lsl+P6U/2LgMAWW8HJjKrQuPAyGyjr3LkOOu4VXzbZV9aBZrF/P9mtemqcQZ9gYEe6RI2qoJ3bw3BkzBU8k2sx+eccEeYYQY7xE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: 4ymY257TrNK_PSN2nvSk9OkvP6XUk5pI
X-Proofpoint-GUID: 4ymY257TrNK_PSN2nvSk9OkvP6XUk5pI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
we retried specifically on a UA and also if scsi_status_is_good returned
failed which would happen for all check conditions. In this patch we use
SCMD_FAILURE_STAT_ANY which will trigger for the same conditions as
when scsi_status_is_good returns false. This will cover all CCs including
UAs so there is no explicit failures arrary entry for UAs.

We do not handle the outside loop's retries because we want to sleep
between tried and we don't support that yet.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 93 +++++++++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 54e599529a3c..66f1bc03e219 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2062,52 +2062,66 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 static void
 sd_spinup_disk(struct scsi_disk *sdkp)
 {
-	unsigned char cmd[10];
+	static const u8 cmd[10] = { TEST_UNIT_READY };
 	unsigned long spintime_expire = 0;
-	int retries, spintime;
+	int spintime;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
-	int sense_valid = 0;
+	int sense_valid = 0, i;
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
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = 3,
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
+		for (i = 0; i < ARRAY_SIZE(failures); i++)
+			failures[i].retries = 0;
 
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
@@ -2138,16 +2152,15 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * Issue command to spin up drive when not ready
 			 */
 			if (!spintime) {
+				/* Return immediately and start spin cycle */
+				const u8 start_cmd[10] = { START_STOP, 1, 0, 0,
+					sdkp->device->start_stop_pwr_cond ?
+					0x11 : 1 };
+
 				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
-				cmd[0] = START_STOP;
-				cmd[1] = 1;	/* Return immediately */
-				memset((void *) &cmd[2], 0, 8);
-				cmd[4] = 1;	/* Start spin cycle */
-				if (sdkp->device->start_stop_pwr_cond)
-					cmd[4] |= 1 << 4;
 				scsi_exec_req(((struct scsi_exec_args) {
 						.sdev = sdkp->device,
-						.cmd = cmd,
+						.cmd = start_cmd,
 						.data_dir = DMA_NONE,
 						.sshdr = &sshdr,
 						.timeout = SD_TIMEOUT,
-- 
2.25.1

