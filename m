Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA52DC4708E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbiL2TEj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbiL2TE3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:04:29 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF5214094
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:04:28 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIxTur011785;
        Thu, 29 Dec 2022 19:02:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=8ffsmSpVEceiJ//dJjA2viheiVTnveuV/3Eyu5l4smQ=;
 b=UziH+sEggsjfVX5Pu34kI5mjab5QDV+Q74YYOu7Y4x+a8qbMCvjFeQ1aeATebROvZvDQ
 LzyKc1iNsn8hbEQC7RpjLofzQ23fNfrFhLpKS6SC+kEMn/nOBM315jgRiCWSt2D0enYr
 7P3LWCZJeYhWMlah1gggVQIKL5pIFMQZmZr5DgH1RDSSn3cTbZZUIngLgFZ7RKWQaWqP
 Pf7SE5kIZZ80yi5/mhe2qtNCNaZFaCxeI+Iv0e91UTtMT6E7+nHegb4digjuWUE/pe8L
 bp5WaLn8uHzn+uOuQZ3SI5Vm4gcu4/GVpQzSRIN87vmtiMKhn+wVhgEmpqP0dXBllnJi 5g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mns1tf7fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTI72c5001350;
        Thu, 29 Dec 2022 19:02:20 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv798bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jy8y4XFqhhECC5YORkDI6II+KPzrJbvYNqfA/tLmRnWGpwVtbfN5yJAlHD8wZOeCa3aJuJ45PUfwW6/3pKHRoCBJ+pyJo1aTlU/a+6XvMTuootMYSHJHSoAhFJN/J1oquO3tp/BQ6Ox11tGaJRpEj7GGy4Q76meTsxRgRFzX+mUZGXWM3zzClqJBkq9Mh6HvC0lfqTUSXuTA4yuhLPNxydYgCKR9n4ZkJPVfIBj9KHwzDQsCXD4SBk0shbNqaPG/Ezs9jQVf/rW3ds48u9QQ8i6v+oKcswGpJCLF/C5jFxWCN9gzdx5ga7Wq78qCHhNch/I0FyGNrmCECbbr8oSx2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ffsmSpVEceiJ//dJjA2viheiVTnveuV/3Eyu5l4smQ=;
 b=PCLFn3YRgs3/xkyhd07GlQLCmjszcRGqXV9YauxpZAOaHNSNL40D0AlOSKwwBD07LRTrDsbhNr/17QCSB3ZpooCOQtt0xM9m3T+cPgD+VKdWPBHGPXxaRvQXY+qyWdLs0GvM7tMiBb4BOA3wHjCnf0jQjGeCB3Ty5I62R+AGSMfIWWse93Podf7DOKVIWhyC1oOmzzV2R7uhMa1Un/45QiQwtbCo3v0QOnwH5Yim/obKNKIxPRn/HmohKNU5AZqCURMY/7siCs/oWJhWFQgJrj10C4BNyRyFBxjxKL9lsElvAiiqsVveMMg8dUjcrObbMGw8Lm6GWvdurlD6MJyQqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ffsmSpVEceiJ//dJjA2viheiVTnveuV/3Eyu5l4smQ=;
 b=IObCAvyMtJ404OcDYLqv7MtYBB5OcPGm0nkuPZemoWItVuqdhcfZCYy9r+JVj9dZZr7stWYus2nF9Is3KtuOyE4WjVjxF/gKklMQS18h7KmJ0GBzZOUZO4an85LUXD+9YQoCt8bTMa2z9/IPZ71/BH8AUDSOdX/YMsxkap942ok=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:02:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:02:19 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 13/15] scsi: target_core_pscsi: Convert to scsi_execute_cmd
Date:   Thu, 29 Dec 2022 13:01:52 -0600
Message-Id: <20221229190154.7467-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:610:54::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bd081da-57e7-4e2d-de3a-08dae9cf3559
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BS6b2WRwbPqhh5WsniH+zWo3E3PQlnfmPzFnOlnooQBeR1OJZ8dQPB//BjZ/WsSsBreDLfElCCbGuhWX7SuGocQVphkza14h6njOsYmvW08i2Ozd39uVV34Q36kLeHeplV+BwyoTENCGt8JfzSBWem5P3yLyD0aBJPt2XVQ61adHn80FAd5Lh3FueffliOzgMSTuEQLogfL5vrghEvgNtu2bKc+CrPdHReqQ7hZSuc4uG+umI54S2vRYkZWtNfH1dXUizpjlMndBjTcGgvHdFMS0mciX3mOlm6rAElHyy2OJi0Y+NJ8udGycXTyiAemYMBOkW36rhW2EGTOx5qic84Y7gPLAO5GECtLAOq7u7chc0WnvNa7ZD1E3+Zz6cSfbJ1QeN5H4sitM6pb7Dd1UoRE2l9MTvGMF4yZFrMm90hWQi1WYmb+uNeMJmLqsNVOPFdM4nNwWxn/YTLZvW/T7OrffOBDamnBFN3JAaXLlmf87mXSMXLK7j0J7OPU16cD+uLfQOZTrzhph9YkK1v5miLZ/LhTT92nnA/Qc2s8gCLT0FsjyFr/eFFHXOufImFf4bQrtm2BOIrerJn1ZJY4LzT2Jcn00syhbQaPkr7Adtg4pEy6vW3v/l0DZejsVeK07BvPiM4BhtWk0H3UZjsObsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(86362001)(83380400001)(66476007)(66556008)(66946007)(107886003)(6666004)(478600001)(6506007)(1076003)(4326008)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LSSQLZqfyvSGLrn0Vqjm7Jkk9KknnBPk9RUr30tsEKfO5AA8kzRSsLSBRi7m?=
 =?us-ascii?Q?MssswSpFYZJJXogCZ0s3bTg+8UaEortaF40r+gi4ClqREtJzZmiCi37/xwFy?=
 =?us-ascii?Q?dUglu2zqikBcZmYnUHbtt9ndr455O4Qd8HvtqBaR7zK9WaEkFmC0NH74gZSE?=
 =?us-ascii?Q?sP97j6LEF3L0hXhIjymNugi5/wURlTR5A7zDQ3GEO2Y4aBdAyaGUhXowxjbZ?=
 =?us-ascii?Q?+CGgSPE5CboPgyy1Goi7UktJYD9i2hBB7LdwhKHAzvw3tBs6xwdXiMlR97hm?=
 =?us-ascii?Q?dsKGCfwoK860FBx3f/BrWmJYHQcQ8v8KmAmPtXHyKcgwISqSENXM1O3mchhQ?=
 =?us-ascii?Q?7Cb6BV1yq9OPF/VvkfsUxmLmvjqFRQij03bX5nwQdn+tR3RORZjMMqcZP2gk?=
 =?us-ascii?Q?Me7ul8XPob0srfTa7mYCDueXYRIXjErVQ5K5ZSr8npIdFn297OXlcLn9J87w?=
 =?us-ascii?Q?LuvYLFztD63GvhNJth805RHVIAP1d8gliwCxvSQz0BZlGdRXi2YNbftqpU8C?=
 =?us-ascii?Q?JtPe2fHjU1BFVebuZZ4tr4r8+bpe+qVHgNByh9nIyGdy9TipdCgBhAxdbAjg?=
 =?us-ascii?Q?lksoLh5DonWjJxkttFfffK6PNxO/9HrTQL514GODdkK7jATI+gyWUb2URoRO?=
 =?us-ascii?Q?GR3pkHYbGu+hgECuxaIoXdaeYINpWLuRUTtP2iyoJCFFNZFhKpDaRpWCPAqL?=
 =?us-ascii?Q?UoOvQVcA7nUv56xvHFm9XznqNXBprrqgxQ/Af4fEfze/IBsdS8PIXSp89jPR?=
 =?us-ascii?Q?FHqgCI1HWEL5LqUR+Po/zBRnDvrNa+HIH7B96GozBytBqMpSeCeuguy2D49M?=
 =?us-ascii?Q?kmfcm3oxIYKs7QC9yw3vLFIF2NXkkdpyyKDGj4m6/0/pQ/DHJo39brmW4q6D?=
 =?us-ascii?Q?yT6sCLCn7akzhbQIrvsDfOU14TH3CNz47KRiN16W3dK3jcBfmtSkv1Ne9oHH?=
 =?us-ascii?Q?NQWeXNzLqmoRIFRExQ6bLhgS/G03mWT6heezqxmeGx22QmRq8n4WJkrTV1YK?=
 =?us-ascii?Q?AtTduNHfu3mub4UIyWSGtRLraUKnRG6lcyYSV8yCfafsPOOoussdkh1UNHmg?=
 =?us-ascii?Q?3dvm3gThw+kX14oAQtApe8z0Xh9rWlE3V27vS7oAzntHlPMx2C/H40khQWlb?=
 =?us-ascii?Q?jvEogF3KtKySeQYGJthYpI/LSY4MgyZhyRRBSXNBlz3NURWrEd6Z3m168/3A?=
 =?us-ascii?Q?biujr52qzr1UkvFI8zbFVu/lwDi+DQySe1Qf+8aVRI/XIyDUpSdKdQAPW1qo?=
 =?us-ascii?Q?dOgD5Qs+OfVMpOdLpwcKwKtAnPIpazKV9Vx3ybFbRrmsCuotf7tbkgw1mFlY?=
 =?us-ascii?Q?LkiJfq4PqskxW5iZugs42fv9pxb+HztkWGxDipOWSSQJmwKyaNNFlxAwtyrf?=
 =?us-ascii?Q?XUCU0Tk1OgK6ZSsMEc0IBPPqprf9cMSnk7UfidRONCtqJSmrj20rIfURB8+z?=
 =?us-ascii?Q?t++k/HSxYKf+/g3bWGcIiq65vfrp6xS3S+DaoYTX9VeGcWCGu+l6V0M9VJVr?=
 =?us-ascii?Q?zn4PHFphqMN1SWcXehyUSzNdgFWshU3cdaH6DgOqsel+jPae1gkH2RlIzu5I?=
 =?us-ascii?Q?RBSbTa5X+Rufyo0AxABhITB4LdyBlrud5CeqqV7uiQmzJ0Tafm2SRwUP+WIC?=
 =?us-ascii?Q?rw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd081da-57e7-4e2d-de3a-08dae9cf3559
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:02:18.9711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r1xEXyPfHp21ykrG5KhmP2gm+RjKqEUI6rRNkdfbhzjstj/zojo4b/42d/GoaU3jQbezmccR597I68yOPkLAgQF1R01GkLfqDCu9s52NcUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290157
X-Proofpoint-GUID: Vl4LhAVe1-VuTPTgfimpSVSy6qoNeqC7
X-Proofpoint-ORIG-GUID: Vl4LhAVe1-VuTPTgfimpSVSy6qoNeqC7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert pscsi to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_pscsi.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 69a4c9581e80..e7425549e39c 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -144,8 +144,7 @@ static void pscsi_tape_read_blocksize(struct se_device *dev,
 	cdb[0] = MODE_SENSE;
 	cdb[4] = 0x0c; /* 12 bytes */
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf, 12, NULL,
-			HZ, 1, NULL);
+	ret = scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, buf, 12, HZ, 1, NULL);
 	if (ret)
 		goto out_free;
 
@@ -195,8 +194,8 @@ pscsi_get_inquiry_vpd_serial(struct scsi_device *sdev, struct t10_wwn *wwn)
 	cdb[2] = 0x80; /* Unit Serial Number */
 	put_unaligned_be16(INQUIRY_VPD_SERIAL_LEN, &cdb[3]);
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_SERIAL_LEN, NULL, HZ, 1, NULL);
+	ret = scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, buf,
+			       INQUIRY_VPD_SERIAL_LEN, HZ, 1, NULL);
 	if (ret)
 		goto out_free;
 
@@ -230,9 +229,8 @@ pscsi_get_inquiry_vpd_device_ident(struct scsi_device *sdev,
 	cdb[2] = 0x83; /* Device Identifier */
 	put_unaligned_be16(INQUIRY_VPD_DEVICE_IDENTIFIER_LEN, &cdb[3]);
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_DEVICE_IDENTIFIER_LEN,
-			      NULL, HZ, 1, NULL);
+	ret = scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, buf,
+			       INQUIRY_VPD_DEVICE_IDENTIFIER_LEN, HZ, 1, NULL);
 	if (ret)
 		goto out;
 
-- 
2.25.1

