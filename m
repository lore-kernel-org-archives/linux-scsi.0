Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7526C4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 04:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B163A611C6
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 04:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbhHFEA4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 00:00:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:54708 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229512AbhHFEAx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 00:00:53 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1763uvXC003359;
        Fri, 6 Aug 2021 04:00:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=x2VD5ZYiiW4lvdsyGVqRQiGCVdLxONp33LV2+ekog5I=;
 b=Z5NKNAWoM9JDXP0WdREuFgtE5qnx2dvBaT+ftyX247w6Tf/yW0dLCYQV59iEuiULPZo0
 UjMHM6YDRyuan00VjrMgpDGbS7o1offeP6Sp4EnauZd6+3mHYw9aCKKHJQZRUWCsl/CN
 /verTGgjXyJ1bv+s7vgJ9OQR+8SiSLgb05twlF58IeOx8i6ekUpzf2cG0yA0g/yawXNI
 ICviCvydK5FUTF4Qf+2ciMXGI4Q6kBjj79F/u+zfIlECjNLp+wjdmzoJMvVlfc+LZTGT
 wu+R+Pt65xAlugxv16Wa3HFMgYPni90mnPd+leQpUwHApA0PsP+VsoKFmn4DBwaWDGiF EA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=x2VD5ZYiiW4lvdsyGVqRQiGCVdLxONp33LV2+ekog5I=;
 b=Bw3+pV9uLMKhNTRMfFQkXJHbxCIxl31zncTdHpEGYA2El6ob+gwG8JM+XxxyiNdPdBKi
 A1pIwmENAwMIfhzH9l2gO4P36KrTUEt0AZ82am26G4HcLzDln8e/OLPAfb0eCeHAMxHy
 ZennYNHbitZSLFKzfNhOG88vjRe9JzHaoYb9mZOKUPnR0wZkzP4jSLUP2gPrGiUcm0Gt
 zCGIr9iygdXsctuwDilZ8x8xjqsv5jlkutLXeQTWZfBfIMF/5L988aM4y/vrkgXzqlFW
 7pfcXD05xUqzrl7lzBAGZqSsgG/Lz8aJTaf+KSDmG6+E+SYuei6VSeeNu95PEfFY9mId QA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7wqv3utc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 04:00:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1763thsY153451;
        Fri, 6 Aug 2021 04:00:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3030.oracle.com with ESMTP id 3a4un511hj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 04:00:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XAoJ72HS/vgxyzxrNeGKPGhpdbQH0jr8TLEexYX0IvLE+69Ctz3GxdCYDllcBy4/w0CZaMDsjUQkaPi/kk62kfxHx9ii4PJFvY/0R/vgxbHd7pxInj7C3QhSSYd68tSZjvrfP8Bb0h4w3vo1cARKHc9FSIrYi208LlNUIhlOEXx4nFMu/ukeb4ITg4lribiIU4TBSWNlQ5j4s7Hr2e34aXOnu4dcivv1lAzbukkV7xah44hYGHmmiyGAfiS/UbA5V6p1D0SVsrDC+e89SuWuLXBHg1MkcHFskJmrwxMmWtHaaW0Y+tFx068dSixJr9FqY4bXd/OOrnSukgZiwzZcXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2VD5ZYiiW4lvdsyGVqRQiGCVdLxONp33LV2+ekog5I=;
 b=e/HMlCpsKthVbnwVjItK46C904Uxx6eRXqKtXiNdO0T7P6IF+O4o+8E6RxXh7B5k2qxUskdxdJdEsaxO0kwUf7MNrN76UZbfVyVNYAoyHNmuicGghq0+fNWlNzt9mZ948pEJTxT2L/iap0/FZFnx4XquLd/hDJkbugRyx6OEkZ7wwZprokt4qjQh9wkDJuGJwAwGoWmm42yyhGerfu689HGYK59y78o4IFxm80WAx0COHGhgN7ROMGfzbPYr/HhgJUFSTkOQmhtKtGDA1Mn/uSOmFgshJHojWiEaZh7vwlH0wD5i5/HtOuFez8kRBun/+da0UOGE3LeumG0hYxbSWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2VD5ZYiiW4lvdsyGVqRQiGCVdLxONp33LV2+ekog5I=;
 b=WjkWJ4rrpviSkmdS4PkM3FvlnWW3y5WZmjnLzkrNAD8DoZkyD4KZE+zapZ2U0vBsydCmqJgcJ8xRZrp40grbIX2jJhr8kdMp3oeF2jCwNXJnnF3taZTMNnLG35TWQGv/VhmPi13gMeVtAQ+7ErMrjsZkaf3GIYOH7k2gxfO/f6c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 6 Aug
 2021 04:00:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 04:00:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH v2 4/5] scsi: mpt3sas: Use the proper SCSI midlayer interfaces for PI
Date:   Fri,  6 Aug 2021 00:00:22 -0400
Message-Id: <20210806040023.5355-5-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806040023.5355-1-martin.petersen@oracle.com>
References: <20210806040023.5355-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0007.namprd06.prod.outlook.com
 (2603:10b6:803:2f::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0601CA0007.namprd06.prod.outlook.com (2603:10b6:803:2f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 04:00:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cdabf94-9a6b-44b9-2a99-08d9588ebd8f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5515D6A2489A525F6C72A6168EF39@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PgreySQpeZRwp9FWHu/Uw+tgNY+3AZeXg6YksTrmJiUYfzCCk97zdjVWGhE5VCR40Mf4nFRPSNuPJqHIvVUszG9wEEpSG5JurAfBX3gxpBV5KA0H55EHuI203Q6P7n8dh/wT28+tOF/4WMt8Q9sK+mkNki4We+RRVtlS53+GuQhI62UdozYmzwhiCSYSPpF0PbFVOm0E0mcFLBJqd/6FSbe90hOAybKLUR8AqVQKnmNwRY8c9X1PV8Yge3ooihVEXIILk10XpRjcQV4yGEM2U0w0E+WulraVkRY/zjKQ8DVIDoXtfGAt+vvb7uvwpa/9wMJUzSzqs3QaJQTNYUvE8m7dRYmwCiKjZJk60Nv9ItaaEu64WvGEJ3oUCw312VBXPLB8yqgiuvOt6CrUDXaH8/M2ZlMPmGhNaCWfgUMA9SlLA/mmkuXzm1gqwt5PejoZP6BtNJVf4waztqVAjNWKs+zIjgVnWEe6k2dwBUoHEqJ7W6OkEPs0MEJ2+MZzkQ5h6s81uQpurfa55knuFv/iSZ+zIdHP64fJrAs6OSQhUWKG37KNpXk5Wny8VLJTIxD/iL2pWiwxYhFVPwAbL7rVD0OghgHVnc8iLO04hF0CkgwCSSCrwYIkbs0laS4hpkJ6pTtt4BKtsxWcavf25el8TIfKX/g4zs7t9R/kzkJldOtGhiV3SGy/jVQMyRCXfp8+IdBZSnznhcb8jlCjZEYusjF5N2t2fp6bL1/POdddRNQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(1076003)(8936002)(66946007)(8676002)(186003)(6916009)(4326008)(66476007)(66556008)(26005)(6666004)(83380400001)(38100700002)(508600001)(956004)(316002)(2616005)(36756003)(38350700002)(2906002)(54906003)(7696005)(6486002)(52116002)(5660300002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ICoKnOiEjpDvgp6mF3QoLPVQeUl7wtMAQhwX3G20RbF/02n8PkrOtt2L64Hd?=
 =?us-ascii?Q?sScd64UkSrg5lSgbk0Xfdraq6+qMXHfId0vKrMWszpAI7nBHjifu/RYKTwIO?=
 =?us-ascii?Q?1UT6wKpF8jw2qUVjLNiwm+5CEtrLh8ELCrKcrLS8gS9KSh+oTk6cG5J9KaBg?=
 =?us-ascii?Q?FiwBGoUPl3CukRWYNlDInsf9sc+0HuB6fSbbIN2jmlM5hHbCi/qk1qoOd2Yn?=
 =?us-ascii?Q?JlYJUA+5+Jbto9IQnGpS07EkcT9ToMtvZqP+yw4rXM8CYtSJAgwOq2xzW9jc?=
 =?us-ascii?Q?rqUjOhh57qCJPJPbg3ubLkfEQ8fsfsMsM+NDtV7ecAH/rPMOleFZ7pxMP5Qs?=
 =?us-ascii?Q?h/G8X6w5dX/RobUFChQQsrY4T6CB5s2RrW2k8NqDxNlcJ+XPoDIaIbiVXNfk?=
 =?us-ascii?Q?jYaNg8/UPakQPxMHgVjdVER330PE7YhTOyaGabZ84ZWhiZ/sKHOFklh4XG3g?=
 =?us-ascii?Q?P6ACBUI0xR4XQ7UZwX9q7h5S4Cp6a0umfifJ5mkQdht9GRBFMWEpabbX4wdZ?=
 =?us-ascii?Q?DCkAUcQ0rnmDVtkt2/YOxuRDIOwGUfGhavMAeJ1CUQrXXYTwXm7CqzIppEmZ?=
 =?us-ascii?Q?ywLHYDlaaqbEu8loDeHQFQ06evPzmQhXmkYL2Y7mQgO5rgl6wse97XUh03sq?=
 =?us-ascii?Q?vwyTk+7RAFr4AFP2iPMlGz032AAikMZtNxUw5fSATAEbuPeAJy4cuB7hTGee?=
 =?us-ascii?Q?zDjHnIxZrhxkdYEWenn6A7InwYxZkBuRUIhqdIUFBOxiVhsBh48BNTf11q/K?=
 =?us-ascii?Q?lfgkFeu2lAWSmjWFLUe+lvgNfGtuOsnP9iBMmhp91c2K8ffzbXBYZMuk1Ll8?=
 =?us-ascii?Q?kV9hccHUGkojpPB5IMDpQe2Pt8MRdu4osnZFtr3eoevxJjKkLodYzBtSw/jG?=
 =?us-ascii?Q?EjVcdJPPzll9tbtPu3215La3FhdVj4QNP0muXE70XJAM4Wdw4ZwepkiVYvv+?=
 =?us-ascii?Q?FiQUiBnhS0R0OT0AKXkQdt3slL6mQTDSlt9ppmrSXMBO+SX/82uwObY4CmvN?=
 =?us-ascii?Q?wbxRuYX+TcR7doBTEFNvYqhj5M0KESxyNESCIECrcwMSYCOPab6ciSPzY2h2?=
 =?us-ascii?Q?e2sPdbEv45sbBPeBev6o22kUXj2dyk4qPlhZ1bUKzUOyi2/8DK8en4l1sgK1?=
 =?us-ascii?Q?uz6mDKNx2MeKiIfPV9nfRjfJdPEUf/pELwBKFK3uJsLkgiogExR4kzcgTHle?=
 =?us-ascii?Q?wPQJmbM8t1mhQL/BiIJVLBU8AF8+BSqG19ydaVmb/Phg9TJ3hVnl7t+w7+IF?=
 =?us-ascii?Q?oLqL0PxKGqgVr9QM6JA+8GarthtsX023F+Q1oXy3eXCb45FrbDHKZtQTLboX?=
 =?us-ascii?Q?iDodPXPIbgsxA6Jpnhlno1CV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cdabf94-9a6b-44b9-2a99-08d9588ebd8f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 04:00:34.0274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5oQWwPsJ/USm8x5KGWuxddQnlOBPPo0VgKbnYEXUW2/gXRhjc90+Ygv19zfcRSKvOyL3boQGZiaUvV8CsddQw93gQwhU4l2PNTz4o9hF4rw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060024
X-Proofpoint-GUID: FeuAtUlhJHNT9C_EVxnZ6AjNKEx5rkcH
X-Proofpoint-ORIG-GUID: FeuAtUlhJHNT9C_EVxnZ6AjNKEx5rkcH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the SCSI midlayer interfaces to query protection interval, reference
tag, and per-command DIX flags.

Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 866d118f7931..a66cea57fa96 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5062,33 +5062,17 @@ _scsih_setup_eedp(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	else
 		return;
 
-	switch (prot_type) {
-	case SCSI_PROT_DIF_TYPE1:
-	case SCSI_PROT_DIF_TYPE2:
+	if (scmd->prot_op & SCSI_PROT_GUARD_CHECK)
+		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
 
-		/*
-		* enable ref/guard checking
-		* auto increment ref tag
-		*/
+	if (scmd->prot_op & SCSI_PROT_REF_CHECK) {
 		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
-		    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
-		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
+			MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG;
 		mpi_request->CDB.EEDP32.PrimaryReferenceTag =
-		    cpu_to_be32(t10_pi_ref_tag(scmd->request));
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
+	mpi_request_3v->EEDPBlockSize = scsi_prot_interval(scmd);
 
 	if (ioc->is_gen35_ioc)
 		eedp_flags |= MPI25_SCSIIO_EEDPFLAGS_APPTAG_DISABLE_MODE;
-- 
2.32.0

