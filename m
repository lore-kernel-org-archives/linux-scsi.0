Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B89C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 02:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECE9160F46
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 02:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhHQCvC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 22:51:02 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2150 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233438AbhHQCvC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 22:51:02 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H2gE8p016760;
        Tue, 17 Aug 2021 02:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=l2IKvXVUDj2d5Z7p4OQW98L1ZVUV9pTjPsEuxlbaFoU=;
 b=wokAaH4WGUHjLBUJLVZRo99Bvd9dnwcPt5Ey/UGIaddbBo4CGp+wmugk7sOsY3Q++46y
 j5mrwF3FmLvbqiH6wm3Stqkhop+S1NX8MufGxw8lzDG2wA9F8ikCdmb0zS32Zrkdf/wF
 SaCMbzGrup5VXM8Z0ScApaBxgDL268CPqWHfiV5PKmlradHVlGY9anRPsaOAGhiw4KMQ
 8Fn7sEz0tWKMLgcRFIZAFKqO2uXNgCzPbaDPmA66ioVha6STuEhPIQbposC/MLrV6CPr
 VmVJeDtNU3L3uULbIaMr12CatNaXX3cgo4B2wEVRDW0lvosSY29/s59d/ZU1CbW1z/So pA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=l2IKvXVUDj2d5Z7p4OQW98L1ZVUV9pTjPsEuxlbaFoU=;
 b=fCd6zjkI6SfUOz3gRACbd5tZkRuwmAFEVjAFYNVUMXyVQvotCaadbI5Ewz0m4SkmvPKX
 VKwT0+NMF0rWrWbAewB5b/nq3v/0wSvZOsGIwYp/nDB/yRC1vaeWpF5UbT+LW49AyyeW
 KxXZNbLJZJYXOZpqrdk6A+JrWz+8/YdWHf6PeIx1Qke9/8dE+1Bj/ggsA8p8wIfJ6gOL
 0aKAw3oszWjOFf/61DOD8DiO8if9yKH5uKRC4lcsFobHI/670PsRbaiLuIJHPLqRBGrT
 el3HUkYF1oDJ8a6NuXmgUMYmCpv9ive7yrrci15E2dvKHvD7NlJaubfGkPDMs966gRBj nQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3af1q9bntp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 02:50:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H2ijYq132105;
        Tue, 17 Aug 2021 02:50:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3020.oracle.com with ESMTP id 3ae5n6qpax-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 02:50:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4EvjAWSbuwn0ImsZ+mBHBK8xt6FDIHfXcJIj59T7o3d8TAfmbGqXtdSo4cGDuKtSEkicZ9rYOo+JFbzpwnlspmxCYsCa5bhLWS6DEDugx4pPxJbBkLvRAfh/hKlz/CnhpevaAaJ/nDaX+4CINTBzb/B2WwUcG/WO2p3857gz18XjtSO/DEWqDjiS45SN7PGziDml345yhuCNVHmu1bD5rEwvtMqGpuxW2vDDhuzyIkVtbME3Mvz/TCAJLIWVSVcR4puc1o1yPAb0D9Uk8NmQiAQ4u6Vp5+7bG7SthhZkfBM9C+Sn6YjnHNoZ5bVZt8unyPPWSSnerGXVrWom3Kgxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2IKvXVUDj2d5Z7p4OQW98L1ZVUV9pTjPsEuxlbaFoU=;
 b=XR6e3Lpf5p64cYL154h6x4kAO3sKqrs8GyExTXEewpu/y7+V6XWmThAfUBZUaG2v72f52DKu3HqKgQa4vboBxAaJI+9MKtzhvOu7fHSWJjr0bjpt3p3/SGOVoVtH8IbWGsgIIbCCjDTA68vZYW7xhdoc1UQiiyvLf6pYxZ1zO6U0VSpm7IoYYUnzpw/5BZxNlMpMtmlTwPUfmvA30RiZLTdt/HAESD3JEsBSDTt+D6MrglK7LBdMfqAgXPrVbQFaJi7gqsWBphGpLpJly8bTml6QpmUEyWZJdIcRXrg92SIo4bR1V5Z7QdbJ0HgJP17/WsCruCld5lRF3MAzoGy3TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2IKvXVUDj2d5Z7p4OQW98L1ZVUV9pTjPsEuxlbaFoU=;
 b=XBi+cwU2V4iV7RKvywn4lRDYfm1+gzuKhOsR2u/krL2AUjRkTbCZiPCIHLM6BLvSaoOreRZk+aIHkLFeVxUSVU+JgzetJmeQT2OWIVXjxEwIeQkU5F1YiX2X52TbN5xOzISbRX2ujC5hBVq2R0CYOaMz/fUjAZDNSNTbXSqBY1g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Tue, 17 Aug
 2021 02:50:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 02:50:26 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH v3 1/2] scsi: mpt3sas: Use the proper SCSI midlayer interfaces for PI
Date:   Mon, 16 Aug 2021 22:50:13 -0400
Message-Id: <20210817025014.12085-2-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817025014.12085-1-martin.petersen@oracle.com>
References: <20210817025014.12085-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0175.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0175.namprd11.prod.outlook.com (2603:10b6:806:1bb::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Tue, 17 Aug 2021 02:50:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0f40441-57fd-4104-9a93-08d96129c415
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54667C99F99A766D0479EBBC8EFE9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lK68dlTxmFHOy6aoBrhEqOCzEq1OzBbPsCXwOREqt212oJ1/hGmHNc3FMp2F81nQLRaj9RCq4jypS3VXgF1Rtci9BGD4z9jMBCYSNSKDB9oMgWoQbgK04EF4q5PrI3EWCAi1LNKpRpYQBWeRLGOdJGsCecrxYQGWXOc5rYSKmR5YX40QQzBDzA7Zphjwl1rwvrs3mOwx5glEGSX5AHP5Vo3TjjM36y/yT9Fo7lQmpYln1WbKw4az+ab89hygEbqayQNZJjGzncJs+/JH10UR6yKMN7i9aFaMtZFDAKaCERHeYFhenxqx9siRUpDNgIDUqPaCIgbmJN/sXZYJssJcOHUqu1wXud4SQ+06cK0nNB/znCGm154HvouCL4FJGrHgPqD10LpwuhUwqgt+MQtqXCPVbcpE/3ay9kFgrizIUOG0OpZ/AQLNTnqBhxiXLSB0B3j5U6mhZCs0Pj0SDWTUtHlLd+MFjjQGuyzJm2CQcx5WY12h2KkyyK0NFJ8rnS3CCerFvLaSbFtIigDnGKNQ8FMpsecTAChkd9lAm/Cf0d7y+v9XZyH7oq7m/+PZb+6Hq2jmhlqQCzfCFCNGLjX69WglO/4GEShNWkSe4fVXy4jn13rM//uWmpYyj2rmz/rpZvd800FEyy9TqAWTUodDevgkZ/T/8Fd0whuDd1JcIHQ/2K+EQS1c6EIC/c9puAlgMhxzD58EF4fsDfddgUejemUj2vIqs65EfxbFf1NRK8U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(396003)(346002)(366004)(6916009)(316002)(956004)(2616005)(54906003)(186003)(26005)(83380400001)(6666004)(6486002)(52116002)(7696005)(86362001)(4326008)(5660300002)(8676002)(36756003)(38100700002)(2906002)(38350700002)(66476007)(66946007)(8936002)(66556008)(478600001)(1076003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9ZeFg6NTN871b8xx5nCgPKPW7tBQOd2acML/ki4Ei2BBsKJd2lXQ5Av14tN6?=
 =?us-ascii?Q?BKbXSFVoU97JE/R0/L8uHyvFtL+i5dyKIsKr6u/i8xt1Lm4qnomCLxWGd+7C?=
 =?us-ascii?Q?09aeMGz0lvdK3SH8rSIBwRfoj6JOA8tLx4Zr5Skjd3yfVhjA6zyAVaxuJ9jI?=
 =?us-ascii?Q?goqZEehKMF+rVKuiGQotgE/5qcNmSA9owUqcLkobDfNPdrSBGMQShYyBiEhH?=
 =?us-ascii?Q?XdmDMv7WPTAgymOne3HS8zvI7WPdyaWXSzcQacDDM/apHWNobSeHcmpUE30y?=
 =?us-ascii?Q?JwNA9wFsujPz/YTpnuZQReYkO4be4WIZIJ12775HZsSvIDmEuWyGPbulUtJZ?=
 =?us-ascii?Q?IkRHHN0VkJa4nXEh2Z0mNomiolvoJFhWhTggRnKDwKPzjz+UOGVy0nqk5Llp?=
 =?us-ascii?Q?VnSG1jkoGfRCdUdWhQh1H1wElWP6CaJ/rk4lDMlfnTe/tiCVWwJpgNhGBAoS?=
 =?us-ascii?Q?SYcshUbj7vefMY4j5aqidrp/W4ZcAtN/qhEoHn9MSZJs0qh9fEI+No10ubJa?=
 =?us-ascii?Q?d5MDx180oMwmwKBExbfnSl8kJSeKHa0o759ofG3gTnnF6GhafAvH9X37ibrW?=
 =?us-ascii?Q?QL3AkOgwutGDTuPTxtbgqb0XArmgTEXHXYNsbsRNm0ZPfylS0LZ5mkwTqTMW?=
 =?us-ascii?Q?XgvJGaskMzVtjuRoCI2yoZy8+arOdEu0SyFmMq3HfFOGRdG7tlartHoA79W4?=
 =?us-ascii?Q?QUG7h1aGXGw+U0AntGtnlTZZ7OGtGnAhXvqJGd+ntGXG4mqzXsllpPdAu/cG?=
 =?us-ascii?Q?kQkPn1ktI4q1oW1+kivhZRC0tCIUYDtU2BeDutJ3l8fNBszVTmS5X9se9aTm?=
 =?us-ascii?Q?JSK3c8vFBFdCC2q2bAbE2BKMuaAWuVkQyPKsiMFZvDCW+vKmuGM8eFXJ++Sv?=
 =?us-ascii?Q?M6YJTnhmhn7Euc+JRLHwWascRrxCAuyLZEEt3+tLBwGSs8Uai7ViGyqvSWfw?=
 =?us-ascii?Q?RciTNyzvNQ0O3HAPkHrY0safWUNR20rE2Ve+kacZc5wrI9jVVoPgeARq+Bmg?=
 =?us-ascii?Q?eB25tgI4h9Ml4ADmNQNhvu57vi0MxotR/OmIWTcK/G4f5e5oY6Wukre5gU3C?=
 =?us-ascii?Q?QWklpJ74biPPJoEZ7dQS2+WCJMCqnrvv059z8MegPG+3asHXdIVknBf360Cy?=
 =?us-ascii?Q?txusyimDuRq5w5XzO4luDs0xmOEbGB0RRBYvodLRS3npCZ23bgju9HwBlQiX?=
 =?us-ascii?Q?WhemnJehD7zYZpkwcdiocGAe3QuhQ26NuAMREuWW3u/u+PRCPm9hNgSBN28h?=
 =?us-ascii?Q?S8qK2TFCcnBLUPfcyzKfju1tXu/ulsAQhKljrUdpnkrcGYJF4M4BDJtfWSY3?=
 =?us-ascii?Q?H9vRJnEtF+mFaxmvXzOu0CT4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0f40441-57fd-4104-9a93-08d96129c415
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 02:50:26.2482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1tomBf1X/JfbeswyY19M3DFkmk5ecb5pSImYA9+V1bvX1RyoLLbPQb3zAubZFmtMqGIX/B1S1JcY1wv/YlfLVBLTBYunOxWiRkUEYSo2W4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170015
X-Proofpoint-GUID: e0LUgz-ZHRfggGdINpzQKmE0sMAyYDLv
X-Proofpoint-ORIG-GUID: e0LUgz-ZHRfggGdINpzQKmE0sMAyYDLv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the SCSI midlayer interfaces to query protection interval, reference
tag, and per-command DIX flags.

Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 43 +++++++++-------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index cbc7b3d9d913..2f82b1e629af 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5048,48 +5048,31 @@ _scsih_setup_eedp(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	Mpi25SCSIIORequest_t *mpi_request)
 {
 	u16 eedp_flags;
-	unsigned char prot_op = scsi_get_prot_op(scmd);
-	unsigned char prot_type = scsi_get_prot_type(scmd);
 	Mpi25SCSIIORequest_t *mpi_request_3v =
 	   (Mpi25SCSIIORequest_t *)mpi_request;
 
-	if (prot_type == SCSI_PROT_DIF_TYPE0 || prot_op == SCSI_PROT_NORMAL)
-		return;
-
-	if (prot_op ==  SCSI_PROT_READ_STRIP)
+	switch (scsi_get_prot_op(scmd)) {
+	case SCSI_PROT_READ_STRIP:
 		eedp_flags = MPI2_SCSIIO_EEDPFLAGS_CHECK_REMOVE_OP;
-	else if (prot_op ==  SCSI_PROT_WRITE_INSERT)
+		break;
+	case SCSI_PROT_WRITE_INSERT:
 		eedp_flags = MPI2_SCSIIO_EEDPFLAGS_INSERT_OP;
-	else
+		break;
+	default:
 		return;
+	}
 
-	switch (prot_type) {
-	case SCSI_PROT_DIF_TYPE1:
-	case SCSI_PROT_DIF_TYPE2:
+	if (scmd->prot_flags & SCSI_PROT_GUARD_CHECK)
+		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
 
-		/*
-		* enable ref/guard checking
-		* auto increment ref tag
-		*/
+	if (scmd->prot_flags & SCSI_PROT_REF_CHECK) {
 		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
-		    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
-		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
+			MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG;
 		mpi_request->CDB.EEDP32.PrimaryReferenceTag =
-		    cpu_to_be32(t10_pi_ref_tag(scsi_cmd_to_rq(scmd)));
-		break;
-
-	case SCSI_PROT_DIF_TYPE3:
-
-		/*
-		* enable guard checking
-		*/
-		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
-
-		break;
+			cpu_to_be32(scsi_prot_ref_tag(scmd));
 	}
 
-	mpi_request_3v->EEDPBlockSize =
-	    cpu_to_le16(scmd->device->sector_size);
+	mpi_request_3v->EEDPBlockSize = cpu_to_le16(scsi_prot_interval(scmd));
 
 	if (ioc->is_gen35_ioc)
 		eedp_flags |= MPI25_SCSIIO_EEDPFLAGS_APPTAG_DISABLE_MODE;
-- 
2.32.0

