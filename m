Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30A5C4708E
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 03:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiLHDKU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 22:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiLHDKQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 22:10:16 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCF477209;
        Wed,  7 Dec 2022 19:10:15 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7NOB1H003577;
        Thu, 8 Dec 2022 03:10:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Vkl4PJD1/2l4zl+3/i/6zdJoiOXf3yaKzUulUDtrbfc=;
 b=udYiYjclfUpEaGZbV+2leTi2fz+Ek3yI1n5LzZ5PTgO34a64WAiJ18PzFE35c1U4bFwZ
 nLv4E9mrQD2N/FuMUf4mxem0ZRX7j5TYanpc1fhqseQrG9/8PpozHmEv9rgLI5tDAfED
 UXYVvuqm6rhqz75AdFPECh9yjKuo0ewArh0KbAZ/HnIlVAi5H7UEQTangUUsGaDL3jRJ
 cmRuL7iRWJJ1lgzRvscehTGmIyI7biC8aMQ5v1rMfNlc8XTB7PmrVaAmbbOu48B42lBj
 28pXsAfhnheTNiJy49/xJP3Fdo22v/PYNYutCq3vKAc0Vy2oMp85bDIdB2vgkt0qOC3g VQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauf8hu9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B81cGc8001913;
        Thu, 8 Dec 2022 03:10:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7daqec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8RaROPOgDXyeuN0U8rVsZDTPxd81ow+eeVw+J5Qni1lDodQIG2aLBWRysELM6KRxIj8iEQUfLl6D1uquz5dCalK911GFxhbTYcgipMt54YO7Wbm+ohMlWQNenDSE0tci9g6Q1Ify3tLL6jH+6mTLBUEAF5c5JpLe6PsGccR90mWwrTa7jboPrPbJPJxhNNljvHOdwnBj3Y0QI1nr9yqyQeKTBRm2mV77tVNHUHh9NkxrsESY+w/tpxTqyrxGtghCholaSXZ3C8+vA9bC0pcODfp9QVz0CxxMo5IQ/VbkoOEKYH70kHgyw41wQak2c5d+mizXNXyW0QpcvHHgPg/zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vkl4PJD1/2l4zl+3/i/6zdJoiOXf3yaKzUulUDtrbfc=;
 b=KtvCH3M4hwZw2IS9GkS+hQcTx+ORfYfN7gccJ6HfhBpLSv/kpkE58tFwHqYdi2w0f/lc8PJph4VFVBTgwE90hH1P1hgUsrzp1rAAH2z9QWSt8TPJFZzqPZdZ6PVP3UuT3yR22hRZ1UI6MK8r4XYUxSPIv977EXRC8EfoHz9JcTM5NJqasplJUt6RNMHsW8hI6I0cBiFQHdNK45Ri+PMAdsO5KFyqmilt72tIrBKGh2xk3JAhTvhwaD51esHqTJtHBovUDlN7nUwKBYvTI6OjQMBloFozvRN942HYU0k1F9pO7vULX9BbIHhnum9Fesr+J6CczqwV2dozxZ5X3feacA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vkl4PJD1/2l4zl+3/i/6zdJoiOXf3yaKzUulUDtrbfc=;
 b=bLYS+FHxIKXGfvF76gWMMFVRF8I820df3X8QLz9A/jT72Y5DgBQTOt1EvVHjEcq6ZgFeFRvGaDc4wafFHbC2P4aK4XbvFC1xxD3FZfWNAqKNyekodcFg1iv6m6F3ndRZgq2+2AWQIVaTKfBVPW5P3oLB8TcCsgXgbXRJ5aCU6TQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5132.namprd10.prod.outlook.com (2603:10b6:610:c2::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Thu, 8 Dec 2022 03:10:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 03:10:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/7] scsi: target: Pass in cmd counter to use during cmd setup
Date:   Wed,  7 Dec 2022 21:09:58 -0600
Message-Id: <20221208031002.106700-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221208031002.106700-1-michael.christie@oracle.com>
References: <20221208031002.106700-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0015.namprd08.prod.outlook.com
 (2603:10b6:610:5a::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5132:EE_
X-MS-Office365-Filtering-Correlation-Id: 7375c6ce-3c26-48b6-5018-08dad8c9b758
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5tB78H7389SxvoGdT+4yleF17TMyXDq277QcLU0vHGGXnjJpefop9iJ19BFBIcT1soj3bPiDWDbXEyXNtsMNP+d8+eOGLtd+oLf9BHqt+3kQBnzb2MGbs6XH5kWjjZAuk04Ezw3G4dNa7aCno1l0lTeoFvXFzPcb/LfraK6Z3sYmW4Zop1InTtGP0XxatMBuKZuap30JaT6g0CYekvnyaTrxg+UOyHaMru2JfixL5wYaAHIV5oL4CmL4tx9S3xV09u2j2320nU2ROOJIBfxAYStWUVe8rTvb1sLiINzUDeiGi734Gpb2lcAa/OWgA4mCG+4Kdr1N4cRHvo+/BVRIoBSTY4GN3wVouk8UxD8L32oQhlPozRmSgHTvQ4h9u7SsSxF+rKT4s7nOrKV+AHHeVA4R9feGtTEaBh3MAoZnO1KiSrvxSnmTTE07RIjDaWaKdkS1U5F+hGgpoyO4WQLCIGZYzB36ry9FVKtHvB21iYjUMjBXI4mJbACeMxLCl5bu2GaFIHW/vtxjcJqKRCZgdfS+WG75j2LnlFVQQRwQym30OYiXXliwCPmIzfybtz7jhawiVsZz9kMOjx9ut9iLqPqQoovG3sFzuB3ITAfhhldhQns0CzqYo/+Qm0hZGnWiprmrJ1vc+2k82bXYLlKC4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(396003)(376002)(39860400002)(451199015)(38100700002)(8676002)(86362001)(83380400001)(66946007)(4326008)(41300700001)(2906002)(8936002)(66556008)(66476007)(6506007)(478600001)(6512007)(26005)(107886003)(6666004)(186003)(2616005)(316002)(1076003)(6486002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RL5auG8VfdtQElFoP5bXE/twesXtMRX6ulvf73KdOnBLYoxHdgO96pGNSZrz?=
 =?us-ascii?Q?05OG9p6fsMGX7UsIJywEGwaRe9dlYrkerVfW/t+/rfkQb7N3TfBcyDrO6ZMy?=
 =?us-ascii?Q?ICDxWCpmIcGOH1WCl4G7f7Vm4aBINFaJ9S740pAXAjBX29vfsQBMtNyQDRA6?=
 =?us-ascii?Q?DC61ODhsDK7+ukSsMCX1SUpA2K/KG1WqOCfubXx2piSTWK4551v2mJakt0aD?=
 =?us-ascii?Q?l2FYq+Ht93ec7lb06R1Or3u9um1MmCfH5LFCLSxQkHdoHup/pEskKDTuK9aS?=
 =?us-ascii?Q?/h5FIE+eQav9mK+BFg7Z9GXOoiFcPMYd+OVJNLPdfvHCmey7+q30h9GelWeA?=
 =?us-ascii?Q?w5/APTaCoGauHQ9BOUtRowzgFIw3Xk6Sq4Zo3DaGM/oFnpUvzVAQ73Powd+B?=
 =?us-ascii?Q?sKsvdIl9xeYrCg4VuONdiVls5xkpoFfZ1kQLQnJHtWsmJiCKSqWDgNfb5/E8?=
 =?us-ascii?Q?0IGcS9y1bLDXl2708ZYfdp2tUKuAHSxae4A/5eL0Lnf518wolxGjPDK0lL2N?=
 =?us-ascii?Q?CkSvUxG8qdWFk9BkBY5zlPhLsuB7WdvmQW6ta0kHcbFRkwXTWu3bGZ4XsbZO?=
 =?us-ascii?Q?r44fvC7ZTltnPxGvmHtMoBnK7SE/WaPLYvL0l4rzeUyq6h4Obr9Zlr9GelLb?=
 =?us-ascii?Q?ZFtlczqchIPEuVY2/4eeiIplQ6vYSUl0kiE/w6ZLXRBGF6uOFM7bW9ZTOTYe?=
 =?us-ascii?Q?2FGVCHjipYekLKo6FjtA7PliuhnQiI0EVKTK5GJ9fHPNaFooiRFTMaf63ZfV?=
 =?us-ascii?Q?ZzBM8Go/Eonc85yRYFW3tFUaqAufU3uBeE2kVCrC1TlHpr+bDb1Kh6lsCXcu?=
 =?us-ascii?Q?/YasW5u/svxwsY5l1g0LZEOMqXZpUnIJGoscdfHFHrjOcrLkzIVgqmsnxS2W?=
 =?us-ascii?Q?sW3fpf/0+3TlzBkMgNNpdoGOiRY98Yvyw7PnFeYCHyrv3dwk88FUmSv5qNp/?=
 =?us-ascii?Q?Vg/ha019HByvru6P4SQY+T8CG9jR+0Y7WKjoAjXQcS5WMyQuWbFLoI77egYI?=
 =?us-ascii?Q?Rv1ecTrso6kYxyZ+ggg9a/mOXheOs/bi6RZrsA9L0pQARq/BuYn65lfNqmvM?=
 =?us-ascii?Q?9D2F0xM/xg7vm4weX3tF8thudMv4R2+oN/DfM/Ci3yfXm1WtQPqOS1lI4k/3?=
 =?us-ascii?Q?j2EBA+WwrjkWqx5evIhU61wXQE6KU312uapqhzAqa7p87qqdzGPFdUlOssNl?=
 =?us-ascii?Q?q3mQ1oqIHxWe8TuDupzuOEQeLfcLVW3guZNwVBBAvadkCAg4tmoSvs/5BAOU?=
 =?us-ascii?Q?fAZpge0jGjF9EKehU/xUlSlldh8rgtD+nPPC6ayVRa6hPw50H/pDac4oeMgF?=
 =?us-ascii?Q?Engch5DcdZqEycmt32ApLJRtInxdRbnv5M2qhbg/QZVOiswHGgK9pDkGU6sv?=
 =?us-ascii?Q?SAkE0Aswzl4W5J1enkv7JwqgYA+v1faDvptCMS5j42fHQpGim4FIhUm9WeWx?=
 =?us-ascii?Q?Cz0dViQ+HUkaxTXNgCisbGUolDOPEA2APWBn+fcQr+nkav9Id2O1o7fSle/3?=
 =?us-ascii?Q?KEX+cG/0pZUbA30B3JSfijp6Zep3SvfRGRZAGaWiEG+WP/eadGZnSiSGEW2h?=
 =?us-ascii?Q?b4qCujUJKQz0OQo2l+FH06ULUaQAcKxkJvYuEte5cX9M7QB8kIltDLIx2bL1?=
 =?us-ascii?Q?Bg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7375c6ce-3c26-48b6-5018-08dad8c9b758
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 03:10:10.4109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +X37qdqq9B/7jVgB8/eW+V6Mw8Kucr8YW2owlt6g3hci2+MOMbN0mO+RN+WoRCHsDPZYDrM1YKYB22XkyquK7OCBmrAzN+y3m2hAuk4dbQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_11,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080024
X-Proofpoint-ORIG-GUID: 9BHSk2WyUWA0Vw-sMt1LZXVZCuIiKF_C
X-Proofpoint-GUID: 9BHSk2WyUWA0Vw-sMt1LZXVZCuIiKF_C
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This allows target_get_sess_cmd users to pass in the cmd counter they want
to use. iSCSI will then pass in it's per connection one, and existing
users will use the default session one allocated in target_setup_session,
or for xcopy we do not use one.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c    |  5 +++--
 drivers/target/target_core_transport.c | 28 ++++++++++++--------------
 drivers/target/target_core_xcopy.c     |  8 ++++----
 drivers/usb/gadget/function/f_tcm.c    |  4 ++--
 include/target/target_core_fabric.h    |  8 +++++---
 5 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index baf4da7bb3b4..f5d498c522e0 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1192,7 +1192,8 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
 			 conn->sess->se_sess, be32_to_cpu(hdr->data_length),
 			 cmd->data_direction, sam_task_attr,
-			 cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun));
+			 cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun),
+			 NULL);
 
 	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
@@ -2055,7 +2056,7 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
 			  conn->sess->se_sess, 0, DMA_NONE,
 			  TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
-			  scsilun_to_int(&hdr->lun));
+			  scsilun_to_int(&hdr->lun), NULL);
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 314e384f4ee6..0db70e265d02 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1443,14 +1443,12 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
  *
  * Preserves the value of @cmd->tag.
  */
-void __target_init_cmd(
-	struct se_cmd *cmd,
-	const struct target_core_fabric_ops *tfo,
-	struct se_session *se_sess,
-	u32 data_length,
-	int data_direction,
-	int task_attr,
-	unsigned char *sense_buffer, u64 unpacked_lun)
+void __target_init_cmd(struct se_cmd *cmd,
+		       const struct target_core_fabric_ops *tfo,
+		       struct se_session *se_sess, u32 data_length,
+		       int data_direction, int task_attr,
+		       unsigned char *sense_buffer, u64 unpacked_lun,
+		       struct target_cmd_counter *cmd_cnt)
 {
 	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_qf_node);
@@ -1470,6 +1468,7 @@ void __target_init_cmd(
 	cmd->sam_task_attr = task_attr;
 	cmd->sense_buffer = sense_buffer;
 	cmd->orig_fe_lun = unpacked_lun;
+	cmd->cmd_cnt = cmd_cnt;
 
 	if (!(cmd->se_cmd_flags & SCF_USE_CPUID))
 		cmd->cpuid = raw_smp_processor_id();
@@ -1689,7 +1688,8 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * target_core_fabric_ops->queue_status() callback
 	 */
 	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, data_length,
-			  data_dir, task_attr, sense, unpacked_lun);
+			  data_dir, task_attr, sense, unpacked_lun,
+			  se_sess->cmd_cnt);
 
 	/*
 	 * Obtain struct se_cmd->cmd_kref reference. A second kref_get here is
@@ -1984,7 +1984,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	BUG_ON(!se_tpg);
 
 	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun);
+			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun,
+			  se_sess->cmd_cnt);
 	/*
 	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
 	 * allocation failure.
@@ -2988,7 +2989,6 @@ EXPORT_SYMBOL(transport_generic_free_cmd);
  */
 int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 {
-	struct se_session *se_sess = se_cmd->se_sess;
 	int ret = 0;
 
 	/*
@@ -3005,11 +3005,9 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 	 * Users like xcopy do not use counters since they never do a stop
 	 * and wait.
 	 */
-	if (se_sess->cmd_cnt) {
-		if (!percpu_ref_tryget_live(&se_sess->cmd_cnt->refcnt))
+	if (se_cmd->cmd_cnt) {
+		if (!percpu_ref_tryget_live(&se_cmd->cmd_cnt->refcnt))
 			ret = -ESHUTDOWN;
-		else
-			se_cmd->cmd_cnt = se_sess->cmd_cnt;
 	}
 	if (ret && ack_kref)
 		target_put_sess_cmd(se_cmd);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 49a83500c8b7..91ed015b588c 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -591,8 +591,8 @@ static int target_xcopy_read_source(
 		(unsigned long long)src_lba, transfer_length_block, src_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, src_bytes,
-			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
-
+			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0,
+			  NULL);
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, src_dev, &cdb[0],
 				remote_port);
 	if (rc < 0) {
@@ -636,8 +636,8 @@ static int target_xcopy_write_destination(
 		(unsigned long long)dst_lba, transfer_length_block, dst_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, dst_bytes,
-			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
-
+			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0,
+			  NULL);
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, dst_dev, &cdb[0],
 				remote_port);
 	if (rc < 0) {
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 658e2e21fdd0..c21acebe8aae 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1054,7 +1054,7 @@ static void usbg_cmd_work(struct work_struct *work)
 				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
 				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
 				  cmd->prio_attr, cmd->sense_iu.sense,
-				  cmd->unpacked_lun);
+				  cmd->unpacked_lun, NULL);
 		goto out;
 	}
 
@@ -1183,7 +1183,7 @@ static void bot_cmd_work(struct work_struct *work)
 				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
 				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
 				  cmd->prio_attr, cmd->sense_iu.sense,
-				  cmd->unpacked_lun);
+				  cmd->unpacked_lun, NULL);
 		goto out;
 	}
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index ff2ff7703aa6..ddfe2070708f 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -149,9 +149,11 @@ void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
 
 
-void	__target_init_cmd(struct se_cmd *,
-		const struct target_core_fabric_ops *,
-		struct se_session *, u32, int, int, unsigned char *, u64);
+void	__target_init_cmd(struct se_cmd *cmd,
+		const struct target_core_fabric_ops *tfo,
+		struct se_session *sess, u32 data_length, int data_direction,
+		int task_attr, unsigned char *sense_buffer, u64 unpacked_lun,
+		struct target_cmd_counter *cmd_cnt);
 int	target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun, u32 data_length,
 		int task_attr, int data_dir, int flags);
-- 
2.25.1

