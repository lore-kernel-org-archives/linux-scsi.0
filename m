Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADAA0C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiLIGNz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiLIGNr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:13:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519376BCB8
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:13:46 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8MIpO5028640;
        Fri, 9 Dec 2022 06:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=3RyRPyJWwaaQxj0yP/6Tl0/KBaDQD3jR7BjjcB86QAA=;
 b=ot2m2HLcQ7QwziuC5BsbrXPENpVFF92jq7K3bWHll6LCLavN9vmwQVWpNXcKYgZi8yQf
 v/SJaEZqrrcDyPVsTZkwSKsBcqcThW1Y2IyxcjHHulQ/HColqWGEIk34mQNaw2Ljk59s
 EW/kmdXdwOgLqg9YCjH1pw2OAejLEh83DOcxgBBHQpNeEJuCMPDUE4FTn4K7wFIX3C7G
 gC2KbdUeFZwmUB1g9IEMH7H94XDmlBORcDEGqgWGbuEUtQw2mUvxdA7Ju75Q//C54/3k
 5mI+AQpxkEBEWz8L2+pBxz1Fg6GXVaKXemZVD7XtJ+TNXxMwwpbuA3g5Yt0AAGa5ZyR1 AA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauduvcpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B9589Tj034548;
        Fri, 9 Dec 2022 06:13:34 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa4t7sku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZDWubmWtXJ8VDnx4wtml1iMkHRwdUtNOdauyBj42+wDO3siVIesu3FPJeWVsN0ldIruHCRELLg1n0KgiadAXtgWRagQERCIQPQt2Jvrur2/N2pTxztDqO8hmpd684+OtPPNr+BrwfAzCZErPaDh5Fa55EG689HY2njeqjBfbmtAKzk/3oNEBgob4q1aAPCfz0Cw39EO+6o/HKKRUVxZC4YyxwB7S99UfkCa2oBLi5OmXiXivw2vJygtdpy9z7GheM5Pf6sF7TQ4vy7qk3Zd3lcYyweuooJPKGT/TKnm2pjt6f/HYRdgCtXGVeK1P3Y3oiVhnJthtkjLWW8U+gIeRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3RyRPyJWwaaQxj0yP/6Tl0/KBaDQD3jR7BjjcB86QAA=;
 b=gWW/nPPBqys10NjvD6PKWW/NGr7q3+YzAOn6fTnBqzV/RmVnVGfwgdaC/4EpJ2aEo9gd/EZLT+L8jfbmIBVeMQY1sjokCuts68xDxtLI3vrdoMFJMkIbHdBJTiT9veHn7gwViW722CX1txzAdd5b6u+IOJQLZ6TfSoQRVdDOKF1B2xB1bcPNJkbuz83PN1HlyVKOOTvxZY1itEmuemRu3HCMEtRkSxTAWFZPtSvi4FvaRENq5FWdvu9/Wvsa8BM8F9GY9ltIwUJaojYpsb94RbXRhexWDa2AITd24TzbP3b0wJjIq0yPA2uYSN4KkzBSQx9d/ky/mJcfXAGOSr/7bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RyRPyJWwaaQxj0yP/6Tl0/KBaDQD3jR7BjjcB86QAA=;
 b=sezMWZ12syh0J5MbxVWrQdbC+6TUzjA9Wdbn/TBvJxJHYor95j21ckGQYdssy8nebSNphA+8OuL1qaR/4VZhjaW00Qq2ZIfDMUyFtaFiKIPLIPzVIa1B04Zl122I/vW4bx3yZXuBw6lzJiqLLGlpDplCukWIVPFtc7yqK47P++Q=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:32 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 02/15] scsi: libata: Convert to scsi_execute_args
Date:   Fri,  9 Dec 2022 00:13:12 -0600
Message-Id: <20221209061325.705999-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:610:52::32) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c650ebe-e677-4310-4e16-08dad9ac7f6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FPY8NqqGH8/Qsqe+2mPUUTc/4SMN46DI4sQuZYHVCfoJUXmgzq5prj43So0JmQfWTd/F0uVxrMYkF55/qBVZUfGm+pf6bBWRbu2Y79hVvljHcdkvfGJxZpFoGiQWtfp9al3gWc+06a/vO+1yaDBsCDD0jgkITxoPO9wDXKL/2JJ8SDvkpP1YewEf4iY8iWmDCFQvSHymLILpRz4BaDUbsbzTEfZUIf5lp1YHW19nCrJYDGfVtQdw8DAkrRHz2bc52ytg5YZXgIQdBeIGBBTyBi+aqOylP+gijHlV1inEXvuT4E6MELJYPzA3wf28FAlYRvPlI2/D1D7G3FA4BUhZAABRFoZLgzAFhiUcmAHV87e9e5aSOYxD9NY3xXKmn1E7gdepaOlbwL0PPx9bjQBXIbQuO7qj/40VL4nz9gg591mVnbaFo6St+qAut9Lbkdjrffqu+fNS3l1Uypa9q3xJwLOulSaSrDLvmpVnGWBECBAFTkCAKoFGPoUqAoDn+QIgL3sGiQz6C7pbVfNa2FwZs273xaaGdmm63H9mtHV6CtDPSIAufPSL2aq1tinMVyZPAo4zDOM2i0xECO9V/xpnfULAv0qGby3jX49V4i2ERpM9YFAdF5IFDX16NNs+1uwNKipLauTNeC6GbAlHE202NA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HhkNegEX/gs4WMIhYYAU8vtTW59jQ3SzLckpNJP/P3TIT5S5kLL0+UiCjTYG?=
 =?us-ascii?Q?Upif6d4tIOmW38g8R47cq+B43Vq6FNOBjt3yVLQxDtV6tUoGMXlo5teFbE+v?=
 =?us-ascii?Q?HZ67Dk9L45sx5M/EWzT2Mtlqe7KY66CtLCfpiR/Doz14W10kxZz+PZvEFMcG?=
 =?us-ascii?Q?7e7jPfcjnXGR7xdPkys2pT4fr4HBbAQ3FXM//VSUaRx67lo3xR6+9V1kn5Nt?=
 =?us-ascii?Q?UNaEt5cLoSOhKez72EWH4gq90ONISC9PnbOMYcl+ndbVW4JL1RRd7LLkc1xe?=
 =?us-ascii?Q?9AIymTUzjgaFMft8nAMgSCLXqIM39H+TnVI4WgMkkZD5GAEtQxKQ9adfsiaP?=
 =?us-ascii?Q?GRSF7AQWHpRNJs8bGo31DlCu7hLh+5RbfaKT0cyUIRCqMekOV/TscAywGbPJ?=
 =?us-ascii?Q?Blyweoll4lYzzcvTvt/e8giur8YLfQNmilyLc0Y/82oXoBL27SfZh0QgE0xk?=
 =?us-ascii?Q?ccdmfqsPPiv8TbEhX+sum7uA/cLqObXH6+2aRITsFLAtaBD71RLJ8g/dOU6H?=
 =?us-ascii?Q?R/VJlkiVOQSJUnS9UBsnLXFNscs7IWYXi0myvoeC1717edUCbbGgedVKhAOr?=
 =?us-ascii?Q?o328izICpQRGjJokwe5GfaZ060IX3qB2Ac6Ohu959U6OTYfl0Hkvsl04u5nF?=
 =?us-ascii?Q?Qfj2/l0IIq0cdC8RWdX8ZmRz5ZftruhBt2NXRauKdmEqK6Wb84x1pMElADLP?=
 =?us-ascii?Q?G98WxlkSxgVvC1PojdV4k4eArjqA9rp2yQCJIvhQodcS+0NJIXGzi2hKfTfw?=
 =?us-ascii?Q?4BnW33M4n9b2eCeedocTQVRoicTLnSHlOain4uExWdwnIC7aJeg4vE0MibmT?=
 =?us-ascii?Q?68uWqPLwiuCOhwffhisWoOrUCssaQo+y1UV0Pr1Pw+2zxN0/jUJJ9OesxCny?=
 =?us-ascii?Q?3+zT1zVsZ5y2vSUtVzqCNymVl8Knu22A/iieifqGXVOXcTNfffjOa71oyt00?=
 =?us-ascii?Q?muHgt7mqKfTG/fc4DBJH3Xs31yVS0KwHhWwd7atV2Ug3ySIAvl/HlkTb7s3s?=
 =?us-ascii?Q?D08VZzhFO49EO1wh2dQO8YPe7ZUoitt/g5hO68F4zyZBL5izvGyNJhZg8mO4?=
 =?us-ascii?Q?Hb+Vi7rYOEAzEVm5QUhowNLlCWvimMoE9hqCMqoiDCY2yEITZsQW+/QGNoto?=
 =?us-ascii?Q?N1Ie31lLBV9m8IIluGhIQuetGyHVld5cM70sPblHNxpkg2WK2ploDMSR4gTD?=
 =?us-ascii?Q?N37+vnWZAryks9NKatdG3BAWt3Br42gaxXplEyzl6IF/iuI+/hHGGxpB9vqt?=
 =?us-ascii?Q?5ssb7uK+bMDB/FoRknL3oO1UBsFV1MBn6hO3iVogTHhUSf33JzyQvPdDVRYI?=
 =?us-ascii?Q?1SEiRHfUNEU1aYQ3ix5FPbosOWf9k5zVrI1qrgOkeh9CdKTxlEte3qfcvHx/?=
 =?us-ascii?Q?As12+o3P03CFyKInBLXmG+MRlw/QSKHWYMIGf9P0JmLonLftOpQgpdjFUXeh?=
 =?us-ascii?Q?gQsGEKu5mcjIYwPkuubfpAlTb9uGmYk8Dd6T9dnTmRXkNCVdZBvibRFs5XND?=
 =?us-ascii?Q?JiZlU/ALoYqeYretNa8yp1D9G3RjDXbgKBNnzbypRRNJHGz/5R6pfqDbd9EX?=
 =?us-ascii?Q?9g5HtknHZsjpuK7pKej1qzidVoT1KSg/kN1n0vdkv/LRR0+rahtwpFLgf7MV?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c650ebe-e677-4310-4e16-08dad9ac7f6a
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:32.3184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nvBtJPOFwdSZyKK8fIhGv3426FeRB65SFDSaDvxSfxrdxxg7CfnYyrxZM4xWVyrXxSlIt9OR+BDhZuO2TWnGDU5s5qrQVqTF5t7BoGzdAqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-ORIG-GUID: qSGJeXJDxKLuDlsyBRMLJSmPaAgnTqSu
X-Proofpoint-GUID: qSGJeXJDxKLuDlsyBRMLJSmPaAgnTqSu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert libata to
scsi_execute_args.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/ata/libata-scsi.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 06a3d95ed8f9..1dbd02118803 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -367,8 +367,12 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
 	u8 args[4], *argbuf = NULL;
 	int argsize = 0;
-	enum dma_data_direction data_dir;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.sense = sensebuf,
+		.sense_len = sizeof(sensebuf),
+	};
 	int cmd_result;
 
 	if (arg == NULL)
@@ -391,11 +395,9 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 		scsi_cmd[1]  = (4 << 1); /* PIO Data-in */
 		scsi_cmd[2]  = 0x0e;     /* no off.line or cc, read from dev,
 					    block count in sector count field */
-		data_dir = DMA_FROM_DEVICE;
 	} else {
 		scsi_cmd[1]  = (3 << 1); /* Non-data */
 		scsi_cmd[2]  = 0x20;     /* cc but no off.line or data xfer */
-		data_dir = DMA_NONE;
 	}
 
 	scsi_cmd[0] = ATA_16;
@@ -413,9 +415,8 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
-				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_execute_args(scsidev, scsi_cmd, REQ_OP_DRV_IN, argbuf,
+				       argsize, 10 * HZ, 5, exec_args);
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
@@ -475,6 +476,11 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	u8 args[7];
 	struct scsi_sense_hdr sshdr;
 	int cmd_result;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.sense = sensebuf,
+		.sense_len = sizeof(sensebuf),
+	};
 
 	if (arg == NULL)
 		return -EINVAL;
@@ -497,9 +503,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
-				sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_execute_args(scsidev, scsi_cmd, REQ_OP_DRV_IN, NULL,
+				       0, 10 * HZ, 5, exec_args);
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
-- 
2.25.1

