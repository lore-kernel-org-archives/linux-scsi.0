Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A59C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbiI2C4h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234929AbiI2C4U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:56:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4210FDF05A
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:56:13 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiRnI003459;
        Thu, 29 Sep 2022 02:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=zFn8foNjeDxfl5X2fIKbSUnmirBJ9dDysJY2YUIKjAE=;
 b=PZoBi+OtcA78L21bJSNyjNjhEtimt4PIx0+IVRCnGgsEnJlkw95b6Cq2fV3uz/tItTQO
 BVTQl7g/numlctMfDp2oHdR7SB/IvusUUr7Ii5jvhDm2X25p6xTreVtXxtgWaR+ezfrq
 TJ0EIuqv5SyD9CwebM/KDsZCSfuDpigsGLlPhpjkE4XFoRDrqY31tdeVa3vvU8ELP2BR
 eHDb/pZQ0nIL4dguybmBtc4YI8fTCuwcVnmil/lqLpdNvSGiQhADYEHVYx70dp67asca
 CxZSiCgFkgzIXkgV3Unj0eZjQQnWZYnqeZBAeR5Vmi/BhHYrmd2UiTJgJULypZQnoDj2 nw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssrwkjct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SM5fAo040308;
        Thu, 29 Sep 2022 02:54:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpubbpjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/cie8V2lZ3D8oGGJLSzvftclumPsvTI94zLY/6ZvBaEHbzPmor6DoVJyGUSPrlQiq/pp0uK1a+nZV9Zwp13IBFNLBfNuc/NhkSRpdcdawHf36DZxjTnUtG8+gVs2MHGDrfY3t7xZz77r5QFlgd+YtjlamjTlitE83HAnrpht+ttuDVbUXMhnSYdjZ59Ww2jaNP7e6EX6FIV7ZcwvgAFIVEUGN1i9xz94hOuTw4gIkv0ZDcVLyroPkV7rQceQtswEdu07cr2YoT2EdocUewkrcKzC+YN4rMQs1emHSsLEg2NSkow8FodmqpwCpDSOaINfRIlLMWsW5ZqUEyCwMj/eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFn8foNjeDxfl5X2fIKbSUnmirBJ9dDysJY2YUIKjAE=;
 b=n0zrZ3elTO6aCk1hzRBU61QZ/z2Dsp/sU5e/vv70TLrin9yebXAk0zRba/ypa41ns+sNzfg5kFWzfwuIommA+OYZrB3b2MFnLdiEBMrGFghnb2gkTCOhjvKTb21e5IllBaEulS7N+XdFXxdE9Kt6eqXmuRM4nirYYzdH9EibX3xQASoTatKEiqPMyNPQt5CyXaHAb0p3Zwv149SyckdpQiii+XUhcr2BzqXtuYtQ+eqVA0qH8RdqGmChVv5GMI0KYP6qdtp4T5p9KwL+TdcKyjbtK1uJ+zdgQqIgHOTGkYuHUIDjb0NWOfDuQcr3Xlxi957HyB9dhOoIi4e6lJHcdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFn8foNjeDxfl5X2fIKbSUnmirBJ9dDysJY2YUIKjAE=;
 b=ebRuGxkHiYcExgxxgLPvPL7XZZ+8/WiAGxM4BevUE1y6oVF2ERHzcEapJwL71LJrBPrzLl0y9txmgFPJwx1IozxIJladnPUQiiwd/ynIEJVKUUK+K6jmoJjolJ/Z9Fbqq3kCVOskOF/Bhocv8MBxv3XzAGlDD/yZIvDoxSMHLow=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:54:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 30/35] scsi: Have scsi-ml retry scsi_report_lun_scan errors
Date:   Wed, 28 Sep 2022 21:54:02 -0500
Message-Id: <20220929025407.119804-31-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0048.namprd07.prod.outlook.com
 (2603:10b6:610:5b::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 0694b26e-f4f5-486f-c576-08daa1c5fe67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xKaAZowMFcwEYNgMzXZQXSpr1xWX5/jn8x6idTev5yWFz/sPJEbLp7K9K3ElGXZsvENcmV8iGhZXJ5huPLfzvJ6rYyNn68kWdc6G6Kfkn8JdeKohrpBQb7rxDPSgXAzSaqz0N3tBXreFAb8R1IuU7C7OQnUnAcpJ2l0ofsvGL/LjnBwLwdqMyv4AkgHaG7e/rP5Ws+uPMJvrWHch5BAqdZg7dxAUZ8OAILUIwJsNBsud+UzgPPH98YzZKBwf0EEKC64suQtbBoJBBYxMwFx+sJl3eQV2qg+y7NcvWGBvxuNy779NokU10OlerZ4LNO7In1CIjP/o7AzdSW5GT8jaqxW/Wkz/nY6O8qrt5HyJP20n3xETr3sB9SLo9FeoqsiZ/QIwtz9CRa9cW6vuNi7wugMdWuMlQJ1aU87Ow8nL3zlIZbnJGE7IjH+LWy/iuW+QAgoou0So5OzNJ5y4eF1yt688u8blQ2+Gw+0sKPb1qYQ8RNxNXSDlUJQMhoj6RGIEZqZGp1FAs7gndj/yl5UQgwL8XK4gJg6DD+sCCQlWaqfNYaQ3r2f53GxKb0WZgckDCYVGO9ZGBq0McUCabSy2LprSLYGe8ou7KdalK8S190lK0c+/2FE3UVHZCvvetXbnM8G8laINzTRA129PM+RbBuOzIR5K/Jp6YZBssNKKeSnxUmBgO8l7HQW7DmEQ0aRcoUO46IElEyveNLn3yYkupg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(6666004)(41300700001)(83380400001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R+VQ7bFftG9x29c59iVfaUE8oY93LLfolgnLjusrzBVpQiirQJbx55KkZLCb?=
 =?us-ascii?Q?gQf9ftaXN55DDxJdEok1KpP0qLltICaFBBI9Hlu8HbSCDCdHX+4vmzpWT087?=
 =?us-ascii?Q?+EClIQStK2o4exgkk4WVuncInyHDvajPZ746J1X2QKjrqaQ98hrhb7LjcPuT?=
 =?us-ascii?Q?PAIrn1HKpzIyKE9gdBYwqIrQiJ6tg3Zombqx9vkmCAJ9OOURhIJYteKZuKkV?=
 =?us-ascii?Q?dHKzoDHJ+t1T6JhgcZZVJKd5y1WAkpf9puo7Fix5gfGAaGQKE93gdo7xhWJE?=
 =?us-ascii?Q?hCKLwgZzIRx1AUFbNZ+5jdLZCUc5V1X/eym6E5jUhjAPZk0jkJ6AaMhK0zYP?=
 =?us-ascii?Q?tvCoNEx+cDs9eFKX2zUy1cYWNFcpylgPhhGa6fZouRChf4tqgIaDMPExmBmZ?=
 =?us-ascii?Q?S/DAx6/7E3mUIQikI8b/o7GO9L/OYORKjo7ofzi88cqW3FA9yEzzq8rumEcz?=
 =?us-ascii?Q?rgvqf3oRMeeEe69Lg1SdEwgX/gKdcJj6YzN1tNFLAU7ErxipoWR5VyXz1nU/?=
 =?us-ascii?Q?rH+3UUNNkSoyoWya+8jbJUXdrvLOtOUMkuZ2svELUYOObWeVZfQTWqZZMIBb?=
 =?us-ascii?Q?lm4h5YKGIFgdNSSi48YDczrBd/Fn8bDflDH9vrltWdN3Zy6deg1d5sY90WQV?=
 =?us-ascii?Q?oFjYXPqQR0hFNLaVm9oYkyjTBJxN/q/YXAIcRcVN4C0wEdANl3FW+880sO4u?=
 =?us-ascii?Q?Sb/r8lVq/KgrgHve+5ucK6jc9vboYueCeBmwVld/fdN3+98aG5i3f+6uF3qc?=
 =?us-ascii?Q?gjxxm1EFxEpof7oCnGhrkZs/HRkgTDCWeHFGB/Xj4geqK3Z3O/uPU8p/p/hf?=
 =?us-ascii?Q?1jm+EYqPW5wdwA99ZT7ZfsE4T9UiHObF9Nwil1t6nYNq4LxhLtBatOs/8b1K?=
 =?us-ascii?Q?Q+daPTAIh3P2BaiD3XOy3ghYEDtGJ+O8a7M5MhmNOSW9NHsGsWj+OFE94PFO?=
 =?us-ascii?Q?+wLfS4961p6jsd9CH8ZWPqZO4HQ7qZMFYafckbUo0fyF6popPTV8Ave5fI2S?=
 =?us-ascii?Q?nnTp8Msp7LsPfOZwpMpEgCg8LNzF3nDRDH3SOEk7CaPi6FLUnMEtarC0FkDb?=
 =?us-ascii?Q?Q1XQ0NL/9gN+jloomYoKTNMxXN6l5PLtg/Pqgy8GaeGqzFUwe+q9QMheT3T2?=
 =?us-ascii?Q?iUmw5Endf4CYuTwCNDz9dlHwfkarb4JZrYD/W1lKe571FulJvIe7N32axDPg?=
 =?us-ascii?Q?24qw9lJt9DIZrPqI4Bf7GYnJWPM2RCir9R98PJzzb0RC/GcuTW+Tjv50wbfH?=
 =?us-ascii?Q?C8stt474OFDr6wrsoR4Bq9wvmSNSr4UxW5nE7ehlkCfyghwi0kvZm4nIugKv?=
 =?us-ascii?Q?7F2mFm2M7Vr3/4Hv33Rel34hc9GAQOMgtjNobLnA1KHHZhzHrRIfehzYnz+Z?=
 =?us-ascii?Q?elmXA28/JMzpPPvYxLV7ypad9QA2LM4oplJttDAUD1iKpb/KeUgb+E9x0rkw?=
 =?us-ascii?Q?HhZIFJ1eydyP1gDk8V7w5EM9fYl2ypMAS+NZQuGGd9naRnBGIxi84rEvzYC4?=
 =?us-ascii?Q?ncbd83WE+AMkmyxopFEkdQ2qwsX7p3rdlJTTF7UQ1NjGazSvtUA1qKwEwK9c?=
 =?us-ascii?Q?1SdUDmL1/rk7hmOf9ZhwqgRifNf4DqurJcS5kXC+TW1lpSxNUOLuwmKr5/Ed?=
 =?us-ascii?Q?wg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0694b26e-f4f5-486f-c576-08daa1c5fe67
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:57.6283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ETbaka4wHvcJBZkZkfmze1IyQcErZUkALgo5Z7F2Ely2yaZmHq88L2SMTjzHGKGhNOG9wohvWb9Za6skpgO/hCVQt3/AiBeFekjDpPzjFYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: mc0rXSaLYkMyk2xVy0VP-68U7OdFdXvJ
X-Proofpoint-GUID: mc0rXSaLYkMyk2xVy0VP-68U7OdFdXvJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_report_lun_scan have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 54 +++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4c2e8d1baf43..b783360c38cc 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1420,13 +1420,21 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	unsigned int length;
 	u64 lun;
 	unsigned int num_luns;
-	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
-	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	int ret = 0;
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
 
 	/*
 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
@@ -1495,34 +1503,22 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	 * should come through as a check condition, and will not generate
 	 * a retry.
 	 */
-	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: Sending REPORT LUNS to (try %d)\n",
-				retries));
-
-		result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdev,
-						.cmd = scsi_cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = lun_data,
-						.buf_len = length,
-						.sshdr = &sshdr,
-						.timeout = SCSI_REPORT_LUNS_TIMEOUT,
-						.retries = 3 }));
-
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n",
-				result ?  "failed" : "successful",
-				retries, result));
-		if (result == 0)
-			break;
-		else if (scsi_sense_valid(&sshdr)) {
-			if (sshdr.sense_key != UNIT_ATTENTION)
-				break;
-		}
-	}
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: Sending REPORT LUNS\n"));
+
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = scsi_cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = lun_data,
+					.buf_len = length,
+					.timeout = SCSI_REPORT_LUNS_TIMEOUT,
+					.retries = 3,
+					.failures = failures }));
 
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: REPORT LUNS %s result 0x%x\n",
+			  result ?  "failed" : "successful", result));
 	if (result) {
 		/*
 		 * The device probably does not support a REPORT LUN command
-- 
2.25.1

