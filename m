Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87880C4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 04:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67F44611C5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 04:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbhHFEA5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 00:00:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55606 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235355AbhHFEAy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 00:00:54 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1763uLpi012206;
        Fri, 6 Aug 2021 04:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=YviDSQJP9md+3VbFrMcjINm5/gRY+KieCsNkmNc8Xgo=;
 b=WnczntRdEcO8qGwELSj9J4vqBW4Qc/I0kN4H2Z0VjzfoQAv0CBCk2BDtHuJNjN11v1MV
 WGiNKmCb4P36wzLHZdO2+/pXh1ikm1DLyHWX8GLWiepoSbkF+1RaDi+j48vP+eZjjqAE
 xa+6GncuU/6oMJHafchzQwwQ3Oqv2JZc9ixQxOChI/cZ6Qep84JxOUuhcbn6zbyUqRyO
 j0SVLbPNKIOF+esW+c/efs19K6EbiGcoC905ydPq1qm0DqFAuT6V1qiDhpP6BymNxSUW
 szaocwbq78qzYYxUDFkWfyEfE1lv+MQsFoaB9TehCekHJjonVi0rPuiHhQgnA5+Rh4Mw jg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=YviDSQJP9md+3VbFrMcjINm5/gRY+KieCsNkmNc8Xgo=;
 b=FYD6AXxVfU0QQKwYH1Z+45XSSwVVD4UDoyvko+E/lFHBmvmoag5/5ufu1QD/ZFS4COEI
 3KtY03Zi63vIb2iEttV3WRdBigrkotATLTfw3MwQP4vAyY5Jq2rTolNShnnbYrTOnGIM
 gwJ/JGr9oZyUjNZS1L4/+Nkz7iNQTZdmJuZPH+l+Z/jQdv38FRYgqyThCwrzYA6dQaB5
 k4C4MGdGVjuu5hkIcsiwsFFjdlxqgYFafKvs9S1M6cXUvHvKGV+QN0dS7XJ/rqjjtMnW
 L8vJQjnxNgJqnbxJy+qW1tOuHzW2h5DUs+E7oPO4JXvdccBqk4B/i7TkzLYXtMBrRJo8 lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a843pay3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 04:00:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17640L3I002843;
        Fri, 6 Aug 2021 04:00:37 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by aserp3030.oracle.com with ESMTP id 3a78d9tj6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 04:00:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bB6nD84TU+yIlrwnCtpX1lq9fZL96XsCW5p07pymYW1jZku01xuSIukCZbTmt5lY10CZftfIFn+euKEdfQV6MbM3s6qBwfB1/+J3ipg8ZtjYCL8zANY5sy3bJn89gTEWyEJTJjyPh44nvYcgyYLsaluCxJohonr2pAesofglToMTYRDK5wEFz1VKmrMK1oPL+1JolPrIv8qoHzsCLH+tdNc+M5kCjRee6jPFT0n/38DbSRDStDGEO6dZYKNvFQ0aOuq0OtNNZHDDkV3DSNiEAEBrU50wT7FRGK8703IFZuM2gCM/sFa+/qLtVFBPtLevX17/pdt3h8gwlPOIXK0FHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YviDSQJP9md+3VbFrMcjINm5/gRY+KieCsNkmNc8Xgo=;
 b=iH7hZZv8Vqx4ukoO5hnvpRZOTLJ7H95RzDz7YPrDlpygMpAC2E8wxQ0WcvQBEm3WoSnMdUmZsRX2LtW/t8ax+nsOH2RC9KfPDkWMP2Lt8N6/8tnSfq9PuuCFm7xPIm7xP8Y9gDfS63cW3Q9g6ZKaj+2LsNidOyoc2rtlYyI0LYrzCgDhzYZzACNmsf3OoJrwpYwTJgBOICyNJk3hLu97L49jJ1UZqZZ8fB9v/LO4zfRW8Hw7xqnm5WXjY5n2VVG3CulEdQI7TcYshBvORTIubzQyxrSUynnENMiDE/o/Raul3tB5LnSAy1RemLa0q0ZX3DanhYd4ntH3dpojEVDyBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YviDSQJP9md+3VbFrMcjINm5/gRY+KieCsNkmNc8Xgo=;
 b=bxBu2yrlkF7iXSlGpDiZc6YrE577DM/6xekb0yI3XJEPgcMzg32dYiPeR4RnljD+ZDYkk2LG+1tpx2QCBtwlSmLFofzFYYSY8wXUlGdEMwc0PrylpEoN8FHKKtfen3GCBtVn2WH84ntATR4sYwQgpI94XJyP9z7H3dhmeKYbRAc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5595.namprd10.prod.outlook.com (2603:10b6:510:f7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Fri, 6 Aug
 2021 04:00:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 04:00:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 5/5] scsi: lpfc: Use the proper SCSI midlayer interfaces for PI
Date:   Fri,  6 Aug 2021 00:00:23 -0400
Message-Id: <20210806040023.5355-6-martin.petersen@oracle.com>
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
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0601CA0007.namprd06.prod.outlook.com (2603:10b6:803:2f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 04:00:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd01e1ff-79ab-4e3e-e1c0-08d9588ebe1e
X-MS-TrafficTypeDiagnostic: PH0PR10MB5595:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5595468FC58F6C2C00D571F98EF39@PH0PR10MB5595.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:339;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RoX+mgBJ27qD69z5gfcXIDYnv5U3x63T2bP29u8K5oLL740h9s5w4XpZwUWC05246I1xU8JmSHVhvJIRcAeP6I0QbJmJAH6iWszT7j/ZQj0CO1CwyEGvYhffgJJQBb/5BOw4N0Eipi5PZXKcuCdA/aPkBxdDpvj1DLDVlAuPOKeYI0OX06wIwWTnNcKWH2FkvQ3HFrrJ2DKIeT5WigLLAhU1MrPg4EzYN4PgfE1jd8OG6nVQ3+DCK0opWTPD0o1Izw90nvOk4FBQxx7bmV8hIF3eYh7KQ1/hXuEcej4G9BKJWCwnXCqzOzsfHFOLgjR+e6kpQetHrck/OfGPE6jW5I9QJRQjzQrfwaJQhjuEJTecs24SlZZj9q2usC3h66501FGEq/3NBAxpTkDQRn+jsLCsmF++GEr4GvtVIXP5kUzWJ8PONB0ox666Z7enyz9XqbPyugKfEM8uL8u/iPeLKj0O+B2ab40JTRPYYGcg5ZfwvW4rwEYHxZYAu/dHynK/qR9CqwpqmscGy/ri0srcMQvQn5XHVayNuQT4yac1OmGaSvVv5e026guhcZj19+2zBxuCF3Jq3x5bjQbg1gxhZ3DCPqorjz2bOdzuu1NkhXbdmBsJvny2vYdF16+A0Rqeu6lpuCo5rxAwEJDj69eD6E5Bvj+ZIyW4nPu0eTxgr5boTfv3BHl4gtji+spn4f+leabxSUj8n9MBDXHvR68yFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(346002)(376002)(366004)(8936002)(6916009)(8676002)(36756003)(52116002)(316002)(7696005)(2906002)(66946007)(54906003)(6666004)(26005)(30864003)(6486002)(186003)(2616005)(956004)(83380400001)(66476007)(86362001)(4326008)(1076003)(38100700002)(478600001)(38350700002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?53+Qlmwr8RTTp3UqTVefD5eLUr7eonbLk0WJdOkZ1JFoJHNNttIwYp/Vz7xE?=
 =?us-ascii?Q?E44QardDG1loaH0u6eDVjH3lSZSSV4/chqINXK6wGCFoV3dDVsRB8JN17GnW?=
 =?us-ascii?Q?QVhiqgmb4YUCY8ufqb0Mk01S9Azm3Z7sZpj/BCA2GeEJBLkuNdZ9mQojzA4M?=
 =?us-ascii?Q?nv8v9bq7uJL2IA0m6CuYCEQlcDUdBOqVX+Wq9Nz11u2zCPyXzseZ3oHfLK8o?=
 =?us-ascii?Q?E0lTkuZMPufcr4jRpckWBU5+r/AHOM9XKGB/J40GR5kh+P3H9zKqzC0EIakN?=
 =?us-ascii?Q?8+XxWIQ0A9ZVpsek+89N5F1E5B3qcn7kNZ82YOP4tO1x/xfdUTHmOwk1TH3J?=
 =?us-ascii?Q?zdBoYyd7znRNhwwu7VIxbqchxMF413sYHL7iU3SiI4YPF5vaCr9PPUBwPE8e?=
 =?us-ascii?Q?cg7lhbS6iZpMO2yVGSZ7L5zyopoz8pOAG9Mq9xuRjf4sNOW+mbv/Cy1sALiK?=
 =?us-ascii?Q?z0EyUWp1+TYcDnjW1DsNtPYXXEoR4KXVEv9JUsEDNYuHUUgBxo1vGGy5Dp+e?=
 =?us-ascii?Q?GCv5QB7iDTXtfWpr2TEkbPovsL1zUpxvIfRKA9qSc6Z8CrcT3aDx9Av4edAC?=
 =?us-ascii?Q?97Cdg/cPO5wzOldSPvdJcKmQXvFgkS2iS/gbPorW+1ZCacRaJnlAdIKEBZ9b?=
 =?us-ascii?Q?rlTQCIzPSB38uY3+MvhHzqrsH1f26Gdbwh2he2LyQ2mEbZE6Zwq9EN403NDG?=
 =?us-ascii?Q?nro5SOvaGsncnaSe+MbEvxCB05jv36CCbYTTjit0GMcun5NkHSgvb2vh1c6j?=
 =?us-ascii?Q?whli0aX/d9Um0BD+CTr1REfAWkeZ0OcSteXMH7l2heIQbmcMshXwCl3mLlAO?=
 =?us-ascii?Q?L44dqsSCsg42F3DPzjLl6YxYDfevOFmmLbF9ksqmIy8uS5jMqiseBWkv5kCh?=
 =?us-ascii?Q?89iKZlOF0iIsZ10VsFJOHjpXTJbI0Ca+TKvTXUWNWU3MagodvHemeJZ8J3cj?=
 =?us-ascii?Q?yIJFmMfGl4dMt6LAE/L5pD2grsXqZJTd2lrM/ODCkn7YfZKAfRNaB1t5xZ84?=
 =?us-ascii?Q?jBICvugKTvHWDUUGCuW7yvz8TB5n8cYIBiNii40FK/A+Be9ciX8QgSlkAa68?=
 =?us-ascii?Q?1O179fPJBPXImo5/El/5JZ3J/MCVbjp+Lo9isvScO86Fv+NDdqKzDuBrA3I4?=
 =?us-ascii?Q?59XQB+AMxJLOPWd2MTClA9JTN6KebFX0bfZu6DLlS3vqHQYWyvSys95w6PV6?=
 =?us-ascii?Q?OlTR4zM1VDzEl+pLwLxn1Zp8Ixt6fesqVpKJ15HLLCPjjbzRBOhFYbr20q3U?=
 =?us-ascii?Q?HRBf68G0qmDmS2YKMQAK/6/FcwrZ6tmQIjZ49yAaXWfU4GKGROMWNR71UCpd?=
 =?us-ascii?Q?DTnFSXSABdh+P/FaAIsYA/j/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd01e1ff-79ab-4e3e-e1c0-08d9588ebe1e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 04:00:34.9543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /rj1J46EIyAxjFWfoGLe38wknMCSLFlnlL5IKl9U0nJMSpyqNzvCspMkzjaF3peC/zL2JwUofVW/R/tcHztQcRt2SJ9VjxHrszm4LLxdrX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5595
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060025
X-Proofpoint-ORIG-GUID: KNjUH6MsuS7c_DTHHEhPQyJbsLWL4P-w
X-Proofpoint-GUID: KNjUH6MsuS7c_DTHHEhPQyJbsLWL4P-w
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the SCSI midlayer interfaces to query protection interval, reference
tag, per-command DIX flags, and logical block count.

CC: James Smart <james.smart@broadcom.com>
CC: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 116 ++++++++++++++--------------------
 1 file changed, 46 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index ee4ff4855866..9c27f285d86e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -96,30 +96,6 @@ static void lpfc_vmid_update_entry(struct lpfc_vport *vport, struct scsi_cmnd
 static void lpfc_vmid_assign_cs_ctl(struct lpfc_vport *vport,
 				    struct lpfc_vmid *vmid);
 
-static inline unsigned
-lpfc_cmd_blksize(struct scsi_cmnd *sc)
-{
-	return sc->device->sector_size;
-}
-
-#define LPFC_CHECK_PROTECT_GUARD	1
-#define LPFC_CHECK_PROTECT_REF		2
-static inline unsigned
-lpfc_cmd_protect(struct scsi_cmnd *sc, int flag)
-{
-	return 1;
-}
-
-static inline unsigned
-lpfc_cmd_guard_csum(struct scsi_cmnd *sc)
-{
-	if (lpfc_prot_group_type(NULL, sc) == LPFC_PG_TYPE_NO_DIF)
-		return 0;
-	if (scsi_host_get_guard(sc->device->host) == SHOST_DIX_GUARD_IP)
-		return 1;
-	return 0;
-}
-
 /**
  * lpfc_sli4_set_rsp_sgl_last - Set the last bit in the response sge.
  * @phba: Pointer to HBA object.
@@ -1046,13 +1022,13 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		return 0;
 
 	sgpe = scsi_prot_sglist(sc);
-	lba = t10_pi_ref_tag(sc->request);
+	lba = scsi_prot_ref_tag(sc);
 	if (lba == LPFC_INVALID_REFTAG)
 		return 0;
 
 	/* First check if we need to match the LBA */
 	if (phba->lpfc_injerr_lba != LPFC_INJERR_LBA_OFF) {
-		blksize = lpfc_cmd_blksize(sc);
+		blksize = scsi_prot_interval(sc);
 		numblks = (scsi_bufflen(sc) + blksize - 1) / blksize;
 
 		/* Make sure we have the right LBA if one is specified */
@@ -1441,7 +1417,7 @@ lpfc_sc_to_bg_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 {
 	uint8_t ret = 0;
 
-	if (lpfc_cmd_guard_csum(sc)) {
+	if (sc->prot_flags & SCSI_PROT_IP_CHECKSUM) {
 		switch (scsi_get_prot_op(sc)) {
 		case SCSI_PROT_READ_INSERT:
 		case SCSI_PROT_WRITE_STRIP:
@@ -1521,7 +1497,7 @@ lpfc_bg_err_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 {
 	uint8_t ret = 0;
 
-	if (lpfc_cmd_guard_csum(sc)) {
+	if (sc->prot_flags & SCSI_PROT_IP_CHECKSUM) {
 		switch (scsi_get_prot_op(sc)) {
 		case SCSI_PROT_READ_INSERT:
 		case SCSI_PROT_WRITE_STRIP:
@@ -1629,7 +1605,7 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = scsi_prot_ref_tag(sc);
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -1668,12 +1644,12 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	 * protection data is automatically generated, not checked.
 	 */
 	if (datadir == DMA_FROM_DEVICE) {
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_GUARD))
+		if (sc->prot_flags & SCSI_PROT_GUARD_CHECK)
 			bf_set(pde6_ce, pde6, checking);
 		else
 			bf_set(pde6_ce, pde6, 0);
 
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_REF))
+		if (sc->prot_flags & SCSI_PROT_REF_CHECK)
 			bf_set(pde6_re, pde6, checking);
 		else
 			bf_set(pde6_re, pde6, 0);
@@ -1791,8 +1767,8 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command */
-	blksize = lpfc_cmd_blksize(sc);
-	reftag = t10_pi_ref_tag(sc->request);
+	blksize = scsi_prot_interval(sc);
+	reftag = scsi_prot_ref_tag(sc);
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -1832,12 +1808,12 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		bf_set(pde6_optx, pde6, txop);
 		bf_set(pde6_oprx, pde6, rxop);
 
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_GUARD))
+		if (sc->prot_flags & SCSI_PROT_GUARD_CHECK)
 			bf_set(pde6_ce, pde6, checking);
 		else
 			bf_set(pde6_ce, pde6, 0);
 
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_REF))
+		if (sc->prot_flags & SCSI_PROT_REF_CHECK)
 			bf_set(pde6_re, pde6, checking);
 		else
 			bf_set(pde6_re, pde6, 0);
@@ -2023,7 +1999,7 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = scsi_prot_ref_tag(sc);
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2051,12 +2027,12 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	 * protection data is automatically generated, not checked.
 	 */
 	if (sc->sc_data_direction == DMA_FROM_DEVICE) {
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_GUARD))
+		if (sc->prot_flags & SCSI_PROT_GUARD_CHECK)
 			bf_set(lpfc_sli4_sge_dif_ce, diseed, checking);
 		else
 			bf_set(lpfc_sli4_sge_dif_ce, diseed, 0);
 
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_REF))
+		if (sc->prot_flags & SCSI_PROT_REF_CHECK)
 			bf_set(lpfc_sli4_sge_dif_re, diseed, checking);
 		else
 			bf_set(lpfc_sli4_sge_dif_re, diseed, 0);
@@ -2223,8 +2199,8 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command */
-	blksize = lpfc_cmd_blksize(sc);
-	reftag = t10_pi_ref_tag(sc->request);
+	blksize = scsi_prot_interval(sc);
+	reftag = scsi_prot_ref_tag(sc);
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2281,9 +2257,8 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		diseed->ref_tag = cpu_to_le32(reftag);
 		diseed->ref_tag_tran = diseed->ref_tag;
 
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_GUARD)) {
+		if (sc->prot_flags & SCSI_PROT_GUARD_CHECK) {
 			bf_set(lpfc_sli4_sge_dif_ce, diseed, checking);
-
 		} else {
 			bf_set(lpfc_sli4_sge_dif_ce, diseed, 0);
 			/*
@@ -2300,7 +2275,7 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		}
 
 
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_REF))
+		if (sc->prot_flags & SCSI_PROT_REF_CHECK)
 			bf_set(lpfc_sli4_sge_dif_re, diseed, checking);
 		else
 			bf_set(lpfc_sli4_sge_dif_re, diseed, 0);
@@ -2557,7 +2532,7 @@ lpfc_bg_scsi_adjust_dl(struct lpfc_hba *phba,
 	 * DIF (trailer) attached to it. Must ajust FCP data length
 	 * to account for the protection data.
 	 */
-	fcpdl += (fcpdl / lpfc_cmd_blksize(sc)) * 8;
+	fcpdl += (fcpdl / scsi_prot_interval(sc)) * 8;
 
 	return fcpdl;
 }
@@ -2811,14 +2786,14 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		 * data length is a multiple of the blksize.
 		 */
 		sgde = scsi_sglist(cmd);
-		blksize = lpfc_cmd_blksize(cmd);
+		blksize = scsi_prot_interval(cmd);
 		data_src = (uint8_t *)sg_virt(sgde);
 		data_len = sgde->length;
 		if ((data_len & (blksize - 1)) == 0)
 			chk_guard = 1;
 
 		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
-		start_ref_tag = t10_pi_ref_tag(cmd->request);
+		start_ref_tag = scsi_prot_ref_tag(cmd);
 		if (start_ref_tag == LPFC_INVALID_REFTAG)
 			goto out;
 		start_app_tag = src->app_tag;
@@ -2839,7 +2814,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 				/* First Guard Tag checking */
 				if (chk_guard) {
 					guard_tag = src->guard_tag;
-					if (lpfc_cmd_guard_csum(cmd))
+					if (cmd->prot_flags
+					    & SCSI_PROT_IP_CHECKSUM)
 						sum = lpfc_bg_csum(data_src,
 								   blksize);
 					else
@@ -2910,7 +2886,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9069 BLKGRD: reftag %x grd_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				scsi_prot_ref_tag(cmd),
 				sum, guard_tag);
 
 	} else if (err_type == BGS_REFTAG_ERR_MASK) {
@@ -2920,7 +2896,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9066 BLKGRD: reftag %x ref_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				scsi_prot_ref_tag(cmd),
 				ref_tag, start_ref_tag);
 
 	} else if (err_type == BGS_APPTAG_ERR_MASK) {
@@ -2930,7 +2906,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9041 BLKGRD: reftag %x app_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				scsi_prot_ref_tag(cmd),
 				app_tag, start_app_tag);
 	}
 }
@@ -2992,7 +2968,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_logical_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -3007,7 +2983,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_logical_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -3022,7 +2998,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_logical_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -3066,7 +3042,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_logical_block_count(cmd), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
 		lpfc_calc_bg_err(phba, lpfc_cmd);
@@ -3103,8 +3079,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9072 BLKGRD: Invalid BG Profile in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_prot_ref_tag(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
 		ret = (-1);
 		goto out;
 	}
@@ -3115,8 +3091,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9073 BLKGRD: Invalid BG PDIF Block in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_prot_ref_tag(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
 		ret = (-1);
 		goto out;
 	}
@@ -3131,8 +3107,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9055 BLKGRD: Guard Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_prot_ref_tag(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -3146,8 +3122,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9056 BLKGRD: Ref Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_prot_ref_tag(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -3161,8 +3137,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9061 BLKGRD: App Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_prot_ref_tag(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -3205,8 +3181,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9057 BLKGRD: Unknown error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_prot_ref_tag(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
 		lpfc_calc_bg_err(phba, lpfc_cmd);
@@ -5553,8 +5529,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 					 "reftag x%x cnt %u pt %x\n",
 					 dif_op_str[scsi_get_prot_op(cmnd)],
 					 cmnd->cmnd[0],
-					 t10_pi_ref_tag(cmnd->request),
-					 blk_rq_sectors(cmnd->request),
+					 scsi_prot_ref_tag(cmnd),
+					 scsi_logical_block_count(cmnd),
 					 (cmnd->cmnd[1]>>5));
 		}
 		err = lpfc_bg_scsi_prep_dma_buf(phba, lpfc_cmd);
@@ -5565,8 +5541,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 					 "9038 BLKGRD: rcvd PROT_NORMAL cmd: "
 					 "x%x reftag x%x cnt %u pt %x\n",
 					 cmnd->cmnd[0],
-					 t10_pi_ref_tag(cmnd->request),
-					 blk_rq_sectors(cmnd->request),
+					 scsi_prot_ref_tag(cmnd),
+					 scsi_logical_block_count(cmnd),
 					 (cmnd->cmnd[1]>>5));
 		}
 		err = lpfc_scsi_prep_dma_buf(phba, lpfc_cmd);
-- 
2.32.0

