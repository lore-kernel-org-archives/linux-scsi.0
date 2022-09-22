Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8120FC6FA82
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiIVKHy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiIVKHf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:07:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4EDD5762
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:32 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3saq006440;
        Thu, 22 Sep 2022 10:07:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=6aZEL8wZHhLAsrXO68Ck/3k99YVtiwJpLZpgj+Q/qZ8=;
 b=mgceesFiZoE9tZbCuxGTbzxOGt3TbrpYJ3KED5xXx4uRt7xaZeD6vdYxnNr2bA7RSgPK
 alhm8nIYWTamFuQaD1WeQ0xPY+y9amuNXM389Jfm13r79ixrFu+yRlAF8AVLI7dr+wzs
 JehYM6b+HeCMwp+dKCEaPlyNOpNnGzJtBhGNk0/4YzbTxvv83xCYmObNFbrmzMHV52Vw
 0MEo/YcjDL82QLkF/fdKZjWl7H2298reKVp9ZFYyHnOlwQgQQzHNLaxhXyqy1lHYkPn0
 XDg/pg+N5eyMK95VN3zT8OuJq83hHpeMrPLvLwkEwX7HLSejbEWktXmhNLAn6tRaYrdn OQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68md27p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:24 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8l36X001239;
        Thu, 22 Sep 2022 10:07:23 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cb3frc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHJxKJ9dBADUpZO6qD6+Yo4RaFfBxVJzzJogKv8uU9c764XqoOfxZeQog6RIErCzlwpQaZRMd/r8WlRqim/dU8MH9fapUbN3CdSE0QygNKjTWdZ2tkuh8Mg8JK2og0BP5WEmCDmgqBqjYkh5fUBR9i6Q36iyLbWnVF13w4eGhsWsYvIvimkhJqTTVJnXnZ4S1s2mSaLIFM/ShCpy2wo4/f1w9QWw4p35mZNYNCgjKbkzdyZWegQNyy+wUL5L9svbNymT8GSi2V0DQ6XQ0fp+7s5krEIzFuTfoJU3e1Bk2+YWOKkCgrQrt17t0emf8BM0dAcCdBjZMU6ifSXfAygxVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6aZEL8wZHhLAsrXO68Ck/3k99YVtiwJpLZpgj+Q/qZ8=;
 b=M9lR8sVi7swLC+03YsZiVB/+Z4dkKvQ5uE86lIwjM9DcAjAPp3u2GXpuemTw2k4b0BcMHzF+lOyauJv0J/h4vhhVQJlWeujRpRw0FAKnOkpfcoc7gOQE1IIZmU/hwhy94e6MT972QfQMaOnm+DY6SDDZoY523g9wrAEbo0cbZ0D084cNd9gUnnCRdgXVfNLCx9A40m9Uyzh+LpMM4kA+cxrBNzBtX2dnfH4f6G2QnRvESECzvv4br4LpLZ+S9KE+WU3GWXS9+dRVqBFMn3/xBhXb6aLZ83xhI9+bkvzZDeoQo1Xz4TCTEI7K9xhg4J0MhhhZQLtq5D3zVX6a/54fKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6aZEL8wZHhLAsrXO68Ck/3k99YVtiwJpLZpgj+Q/qZ8=;
 b=kA0zjFMy5sNfuS6a2t2Kqetnvrxg7/Fzuwex7LXiW/GgYhqG1AZr5SueciK6iggpYf/PGJOzU1rL/WMoFaxKYqNX1TurtkNcsa8oI8bX47ZrJZ106rS8VaFwP8OmURLKlaC23gEtxY6mOHNbw7iXW9h4TVT8bRa4gbLZpIPS9g4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6243.namprd10.prod.outlook.com (2603:10b6:208:3a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 10:07:21 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:21 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 09/22] scsi: hp_sw: Have scsi-ml retry hp_sw_start_stop errors
Date:   Thu, 22 Sep 2022 05:06:51 -0500
Message-Id: <20220922100704.753666-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0022.namprd20.prod.outlook.com
 (2603:10b6:610:58::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: c09c4b15-626d-4ef1-99d1-08da9c823d3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qli6miKdVzjjWqjyqP87Bdwqwt0fh8TjVp+BgWIB4u/PMHNC8KCWA8t8j7v4wsWOJ7M7B3GczrT5t1sru3h7T4mvfkoAD5GSzeM/YPLUZLAeu7gdbUCKyu5hpEjvLa6WziH8p6GVM01YTaurbUQi7paVbmbtt2mvEcO2bQuW0E33cU9BZHpDs1Ure9ElUwQllBXmmszmImEOoFVt0I63lHxFHRsGOA44amckehMXdwYNFRJQGnjUDud5pvGk8pbzW4f0R+nLr8F6cp5WtQjxxWEk7R3q6D1TQct0r7LzdvCJapo3CTbWV+hXqQy9pSGYqPz3bW63LdtRDuf5LyzWuYF7oRfOmnie/8Jmj1BDVjbci4AwZPuF9YqoI+luIzO/YtT2gCsnMMdWC6uMJnZ7dCFcqHvVCGZVw43M+JC3XzgydqzyrOcgQwagO1LsRY5YgXereAPs12S5YDFrRKbprvnD9ivDcx5aXAelGhqDDg04xMZ9wCgTpoc3R0mra824RuKdjb9iekL1zqoKCaLVmbew0R7Ef6KaNxpMeuXWWRm1XcyASm9DvjT4Cncokf1v14Ott+ePRbdVJKX/w1MfIHbJlIrq3W8ffNzw+G6j1bK97xYZSUR2O5XAchpLDUfUWOEPXQjD7AJ9XFVsgpeJsJuLdXaKYzxNoGDuwhj7plDxZL2L9sHZyg21XqMMOiMpwhbvGmg1oKFA6u8zN8Pdvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(107886003)(66476007)(38100700002)(66946007)(4326008)(41300700001)(6666004)(316002)(8676002)(66556008)(186003)(1076003)(83380400001)(8936002)(2616005)(6506007)(36756003)(6512007)(26005)(86362001)(5660300002)(2906002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vkw+pLS5TFaLETjw0FMZCT9Pki1ke6Eqzq+4t83UfoEqSwQrqCDyb7RIMc4a?=
 =?us-ascii?Q?9/99CmELBIfwUTAGkYU0R2ren6hir5wb6uDXGVHmeqGXOe3LyuQlm48EcmIQ?=
 =?us-ascii?Q?9uwjg8XT5uSYrheyVxlwhCrd33Ie0BOiqVvpk+i/wiNpiQj7izEZNeWPCGag?=
 =?us-ascii?Q?v/LCbzSnBreQqU7eFXsn6tS1xIgBYBYDLU6E8afVbYF8pcGe0osdTWDIN9fq?=
 =?us-ascii?Q?Khf1tklkUau2Ts3uecOJAHK+DrntA2wQtejZP0xP6Bc4D/EMz3k9YBkc69ky?=
 =?us-ascii?Q?vPF6FxotBSOMqLIt2YhjXJnVjTh3/o2tqmshf93BPZT9q6NDwgV19UU8a+oU?=
 =?us-ascii?Q?UAJdxfxt3QRRcQB5RiHLQJGw0Cs15tJ2WKBCT4z7H7QG+xePuP6OEOwWzZyS?=
 =?us-ascii?Q?5T2LaYMU70ieAu1U3+y0ispyR7TojwZgFT6XP63N1LW6/DPVvfRMGP7VG3OT?=
 =?us-ascii?Q?1f8J0kZyZZqDzWnRmsSLO/JSUrVp2j8BOY+nrhKm9JD/B6DDkdT+qFhJ+4gc?=
 =?us-ascii?Q?+NUR+77cU/r7FHcbuvnb/SyZU3lLjk/Ttw8kIOAV7dp/BpjKvq5UHwgCKi0w?=
 =?us-ascii?Q?gV2BBUMCRmShgGRX+2JfatXk/iNo+yEmAseviARqoHHNeCdaMYMLzmrKyKYs?=
 =?us-ascii?Q?80KshSQ4Ypxf64AceABEzc0eaGmLBJivXPS7UcQo2XzHtoBX/6nLAaZ+AMKB?=
 =?us-ascii?Q?MHbAZDAF5XubcKiZBoERqw6J+Gra0QFGIEnu/Eqn3uBmVmIUZGFQGtbVG6qe?=
 =?us-ascii?Q?AmY7/hu7vZtHKWbPsKW0aPX/2A+tCnMmbVwiaka6yPnh0Pt+vLZGHfmX7Ye0?=
 =?us-ascii?Q?Irquna2wxny/h8u+elhEy6vgE8kRNWkzW0azi7UYgTKulxt4dIcv8ZtvevCd?=
 =?us-ascii?Q?eob5vZ4w/oh8nWdufHlGwVdcHTuNmRiWKHDYTTfRy1AzRU22AsQItH8jSBUP?=
 =?us-ascii?Q?k0VMQVH517H5YiIIxP6FKoR3XnrIH4m0ovSG/xctxIQZm0o/DlI787b/hna3?=
 =?us-ascii?Q?q0dVasZD30o8pwxoKMoDJdBV8OM+sl7zAbga0kKXzjTH1K9WZQQCaw8fMe97?=
 =?us-ascii?Q?t4Ml4zWa6HtWh4Ge+XhCNzyuuHJR8pHFJIZQdr5b0wXZ2v9UYL09U2Pw/ken?=
 =?us-ascii?Q?Z4Vp48q2XbtpjjSFDv7kqVetUcUK05dRkeeTjZNbtucl97zLPKFImF1fVeJh?=
 =?us-ascii?Q?je7xE/uj/Yg7Sg7nOqaUi7NJH345CHwrQ4eLsfrAQ87+EcZ2SLi6aniw/bsY?=
 =?us-ascii?Q?dnRzNnpk3lm22wFaRc4K4cEBbvokI3adLNu6B6kVS3uCXDVAnHJQOmOGk5lb?=
 =?us-ascii?Q?JjqEd94y1wGL+92XuQKSneNkjq9t7WWJZZdoPn3yIwV3WJACl5j3Kp4UUXke?=
 =?us-ascii?Q?HuAWPStgW627vw4+iKN2P8JzNTvzrE9t33t9u2NALMD8m8gzC19UI7sYjZLA?=
 =?us-ascii?Q?vLTacJnA+Yi+UFVdIQj2nJpXPvPc+b+eX59qQ9X3Crug6IQgc+YrTLxGOc4F?=
 =?us-ascii?Q?Tt3U0ID0FsWqCws2WK0O7/z/Z6btTjXBh42zN03eWfBtrgfwoCtnM4vRqh0g?=
 =?us-ascii?Q?gsitrQlNI1Smys7XKfARWZGk7jaxmX7RNIqRaprQHr8tzpcb1xe4rWxBYUqf?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09c4b15-626d-4ef1-99d1-08da9c823d3b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:21.4437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EJNjCyZlZAhlZIFDhD/bodsp3lEeI3ppKbovYXlt+UBneJRXRe5usuV/Epoav05ChrnaS6YQnmWFYHV3nFEMhwfOKjDZZf4mhKQ4rpFdMVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6243
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: GheACFuUCJEZ4LpYJPpDTtHshjqmWuiA
X-Proofpoint-GUID: GheACFuUCJEZ4LpYJPpDTtHshjqmWuiA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has hp_sw_start_stop have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 26 +++++++++++++--------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 64345f9125ca..07f3129abe4e 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -121,14 +121,27 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
 	int res, rc = SCSI_DH_OK;
-	int retry_cnt = HP_SW_RETRIES;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x03,
+			.allowed = HP_SW_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-retry:
 	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
 			   HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL,
-			   NULL);
+			   failures);
 	if (res) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
@@ -139,13 +152,6 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 		switch (sshdr.sense_key) {
 		case NOT_READY:
 			if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
-				/*
-				 * LUN not ready - manual intervention required
-				 *
-				 * Switch-over in progress, retry.
-				 */
-				if (--retry_cnt)
-					goto retry;
 				rc = SCSI_DH_RETRY;
 				break;
 			}
-- 
2.25.1

