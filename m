Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C77C48BCF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0775E61263
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbhFIDlc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44688 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236531AbhFIDlb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1592gxEh084157
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=cSs+nux84mgTuqImBZ3h9xNH/2OU33wOmlcB3gqVfrY=;
 b=heJZVoyQG+QaRUTCJfG/Ei3Wck1hR0bsYaLE6xOffkP3OYGCbMoRuBCKVemqx7ZxhwSU
 H45x4YRpjUIZemYnMf4oQeMnRggisEc1bEzh+g0xxDPT+hD/tjjUkgf+sJk75drdH3VP
 gmzF71edkiaBcXZudPMvm1UKJAo44Lk9E/b5678asMgFMyZ4o+d2mtEXfF0SxQoFsRaC
 cQ/9JO2IAZyGAMpxqsVV2ps+vpJbxWKqlSA9RXGihlSlpn3mEuXwlEv8w4zYqB0Uy/QK
 4mUN9iIxVMcNHXrUXJ8Uf3Hbq42ACT56YHVsx/AOFo74Fh1a5MRGLD/MmGvcQtN7+aAP TQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 39017nfrdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z3h0082802
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:36 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 390k1rhr0h-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=md5T36TJ1jFT44rrHkRkpsI0MsF5FuRfnwOztDyP+yLGxaXtoTrZveMUMJBwhsPvkUQ2rNEXxkeIp4n/rn+vbYSkmNlI9OCXVS6zwUM89KiCM2KI8/TZa94LZQou2nt7uLuRZgs1LAdkZT5+6/qrps4lumYk7bmla+BtM1It5qVQeK5L74n2ToCOUhq98skcixrCq7HYEUnFsHIMeGmbPq96uhkWHZGamnMCQEMT+uQLitqvEmxO5cFKZPO6pAIp/oWADZWHqziCZrGBkE5+T7qSkUcWuiiYVrv1FuhNl2/kc9Pv4AyjRHG6L+cKFvNU9X1z4dgAcPHU6onI47TOtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSs+nux84mgTuqImBZ3h9xNH/2OU33wOmlcB3gqVfrY=;
 b=gwTnwQmPAJr5M0AFij5VaMyvMMelJ56M7+87AvBwwKTNwx74okjPKVcgFgSetG7Oa0lAgZAcrqkpf8sLH0gcsuDs+sAgvqc4BCeEaZhBLFPIDSKmtmyxFf6A1g19gT8aUYW+rsjVH4bZFpbPU3BsVQQ0NAKhwYfoZtU2qBnOYw3bVet7aANeQu0zXKmmUMXr43ocYiSRWGzFnznwE/IG1tiML41X62x04LUfD1qdEOTvNyzLSfV1Jid2cmSIVUFx+ebNzoKz7jabQS3QCaGY+YX8NZv/ltfgfOKp77O/NSFhWrHJEOuz+vOimHbAMBIvpr/u0xNMPLFpl2j6pGZK7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSs+nux84mgTuqImBZ3h9xNH/2OU33wOmlcB3gqVfrY=;
 b=vkhsewWiy4n8GayHlG0CJSiE8cb/TYIgWJtGp40APvEc7qEOMgRfHiY5ZfxgqUv4tRJVd/GkJa5tt5G/dB8UuDHZH9t8KQUJO0SKfdl/mIRDggew7EAPq+L5upUWBf1xy2tKOGy+fYq8puA4YhUV1woc8iwChUdkcpo82Jrk7ek=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 03/15] scsi: qla2xxx: Use the proper SCSI midlayer interfaces for PI
Date:   Tue,  8 Jun 2021 23:39:17 -0400
Message-Id: <20210609033929.3815-4-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609033929.3815-1-martin.petersen@oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:806:120::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6635824d-43b4-4fa4-9df5-08d92af832d8
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44223DE6DA0766110361AB0C8E369@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sb2vwzip6sGrBn/zKHhl+DXAw2Zf4E3MzvzsLka13hZQFtjVsdJalz5Fmc9KjUSzNOwV+pKq1VTZA4YY+MEOULIhgkqs1nQkeYJhkmXj3Vg1rB2QyVuVUq+JTJtGDHa+12317s+PWgaIqZd3Z9QngmWndD2FSDy5dxzKVF4+vidFtYXTVN2rpnvNwVHn/wwcbtkhgRs586zLCPaTx40mxNEXiFV/bQAYj5jeo0htmVj9sELM+reRC1UATn2QAXXjpzim8/cZvFNIrXWPUlAhCp54DIJkMnX6J2BwwdClO28kFunV6xqXgKR56XLV/Ovu9BxRtHpWq6uK+guNToRSysG4tTBsEOgutlyVF6M0ACHJmPRkuLnrVfz3fUE5F/7Zqm+M9iKbiQx3ZnHGhgJ4bMRbjMdLKfTJW6dETV5SaIYwdSECN6g2wW6XkzpTTD9lcslB1yMb/nCd+t7BCzyGKuHDKAhmOmiHmm34KBfPP1H8cIwY67xi51pDmvNwgR5d/yFXXVb9z8ustsqtyUoeFv9z3oJc2QEncVuLhl+aEMq8MTm5rplDppevyX+3koZ6Y28iZb2a5ROub/G+in1e7uDxusPQxdOZws1HYMp2l5AkucljM2JZJa+9V4luyAtB93nBKJnRrHuNNR2i0jB3WA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(1076003)(4326008)(6486002)(316002)(8676002)(8936002)(66476007)(186003)(16526019)(107886003)(66946007)(38100700002)(6916009)(26005)(5660300002)(52116002)(478600001)(956004)(2906002)(2616005)(7696005)(83380400001)(66556008)(6666004)(86362001)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ib0r9zPv/xUyid1Lr6TSGmFwrEOS1hVdjM1wcgATFRweUc5Xsc6KvdOYFGfu?=
 =?us-ascii?Q?bBLPitKtbW3KqcvaNgcfDDTkYzwmmzq9yy6ECgEii6nU6U2JXqjOioq1NL4C?=
 =?us-ascii?Q?+xZY7i/w781WZNtd/q8+eQRZE0f2uicS1Nj0isBTAxu903LIxhOeRQ4AB6FG?=
 =?us-ascii?Q?2t9rs9VpxQqfTxoAQtMLgP+/4C5O9aZhJDyxol16AifbOu6x+WD/YhqBIm7Z?=
 =?us-ascii?Q?8Zx/NC3RAF0v+Fs0tG3Ne0RPYtIdbKPSF4Dra8k9g4+nwCUliANZVIkKOii8?=
 =?us-ascii?Q?obV+RyUyDoTdMzdfwi7CxzZeAMnKG6T/rQtUfbMzBY7WTW+hNuU3gt1Jk2Yb?=
 =?us-ascii?Q?9VnBAFhiCxysjFWz6nbFkTErdmQHkAeXwj8+OkF9pASxQLQErI/2NHAYzQRS?=
 =?us-ascii?Q?g8nkuIL/9HiZU/MTRH2jdTHNaBFivluV/e2iWDCy3i8H174zCNEcwKQo6NZN?=
 =?us-ascii?Q?4J5oGFEhmVzeUmzXXVnzzzWYYcs8UZH+GVAqHc62dbfsu/LeC/5w32vcXu45?=
 =?us-ascii?Q?+1HSm8hrDtdUa64sltefUn4enj9UXBSvSq0ZSsF8KYEnB31ZGFizMWWLvlhr?=
 =?us-ascii?Q?5qJ7a9jUhOjcOMiMAa35vXK+GSME4NESAje78oFz/yXXLNp5Kt4Q1QRtZb0Q?=
 =?us-ascii?Q?y115pJGRQGC6ccTrBaXmWS2SymTUz+V4vvII/0Hqcfm4vKLSxcxgW4AHhoKQ?=
 =?us-ascii?Q?eAOYR4pSxo2tQ19C3yFItVXThYoKYDSat0TUGml2esH2et+2m2HME2YWYPK3?=
 =?us-ascii?Q?PfejvWZB6qJjeS/hg6aXYc58jE8cMQibFz8T5WPugbjt8n/ve8ZfGNvIoTEo?=
 =?us-ascii?Q?nB4XvOm3enMzdo2oJNFZiAuZCTh8r22+04hqqu2E54uMb2obK719kgS3xxvE?=
 =?us-ascii?Q?qmERDWVZak5mVUzTlARVE0+SQYZn3gBG79xHHbUWdRkVB1qnAK7s0ht4QAda?=
 =?us-ascii?Q?wD+GuQ6NP1U9QpWye2pPb7nZH7DStiicBIHFSclBXgqr92vZccmu9dHbFf8n?=
 =?us-ascii?Q?zMonrrihrzZGZ7sDTxesAkouPV960KG98SX7MfRmdN5cFJdTId+zdqVwwdHV?=
 =?us-ascii?Q?ujhvOoY+RIgeHLkwEiaLfL5oX2/s4sibwBFILbWDSc7wclpkwoIGeWVTRD7C?=
 =?us-ascii?Q?uOW6GwuC+YGXyD00FbEsj5BR8Q4QXHffT/GAS1MzgBg71djXsKGmjRO5q8Ad?=
 =?us-ascii?Q?WtrBMaXS5HXt0Ii4zg+6QxAM6NGTeSJteE1v8+vSfS2NB+ont2TyoVvBCbpf?=
 =?us-ascii?Q?gPNMpjCnKOPPsvTXXl7hL/4FMDF9fekz8zc015dZOtcw2g9hiP+HP59Odmfv?=
 =?us-ascii?Q?W+OzGsHp+uFVkpVCfpqYg55j?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6635824d-43b4-4fa4-9df5-08d92af832d8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:34.4920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plcztDeC4BQBRrOK0tOh2CG9NAOJSpv9TUz3lhsL5XOmPL6qHsFIfVZ+PtgbWcMDQyfB0Swm3LwTzQ8CGuPV8sLBCARQvPbE8MBIK1Haq0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-GUID: V5wctcKNIcmHVYSxT_3nflkq6lRXcRgS
X-Proofpoint-ORIG-GUID: V5wctcKNIcmHVYSxT_3nflkq6lRXcRgS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the SCSI midlayer interfaces to query protection interval,
reference tag, and per-command DIX flags.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 84 ++++++---------------------------
 1 file changed, 15 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 38b5bdde2405..42a6fbba7529 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -145,7 +145,6 @@ inline int
 qla24xx_configure_prot_mode(srb_t *sp, uint16_t *fw_prot_opts)
 {
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
-	uint8_t	guard = scsi_host_get_guard(cmd->device->host);
 
 	/* We always use DIFF Bundling for best performance */
 	*fw_prot_opts = 0;
@@ -166,7 +165,7 @@ qla24xx_configure_prot_mode(srb_t *sp, uint16_t *fw_prot_opts)
 		break;
 	case SCSI_PROT_READ_PASS:
 	case SCSI_PROT_WRITE_PASS:
-		if (guard & SHOST_DIX_GUARD_IP)
+		if (cmd->prot_flags & SCSI_PROT_IP_CHECKSUM)
 			*fw_prot_opts |= PO_MODE_DIF_TCP_CKSUM;
 		else
 			*fw_prot_opts |= PO_MODE_DIF_PASS;
@@ -176,6 +175,9 @@ qla24xx_configure_prot_mode(srb_t *sp, uint16_t *fw_prot_opts)
 		break;
 	}
 
+	if (!(cmd->prot_flags & SCSI_PROT_GUARD_CHECK))
+		*fw_prot_opts |= PO_DISABLE_GUARD_CHECK;
+
 	return scsi_prot_sg_count(cmd);
 }
 
@@ -772,74 +774,18 @@ qla24xx_set_t10dif_tags(srb_t *sp, struct fw_dif_context *pkt,
 {
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 
-	switch (scsi_get_prot_type(cmd)) {
-	case SCSI_PROT_DIF_TYPE0:
-		/*
-		 * No check for ql2xenablehba_err_chk, as it would be an
-		 * I/O error if hba tag generation is not done.
-		 */
-		pkt->ref_tag = cpu_to_le32((uint32_t)
-		    (0xffffffff & scsi_get_lba(cmd)));
-
-		if (!qla2x00_hba_err_chk_enabled(sp))
-			break;
-
-		pkt->ref_tag_mask[0] = 0xff;
-		pkt->ref_tag_mask[1] = 0xff;
-		pkt->ref_tag_mask[2] = 0xff;
-		pkt->ref_tag_mask[3] = 0xff;
-		break;
-
-	/*
-	 * For TYPE 2 protection: 16 bit GUARD + 32 bit REF tag has to
-	 * match LBA in CDB + N
-	 */
-	case SCSI_PROT_DIF_TYPE2:
-		pkt->app_tag = cpu_to_le16(0);
-		pkt->app_tag_mask[0] = 0x0;
-		pkt->app_tag_mask[1] = 0x0;
-
-		pkt->ref_tag = cpu_to_le32((uint32_t)
-		    (0xffffffff & scsi_get_lba(cmd)));
+	pkt->ref_tag = cpu_to_le32(scsi_prot_ref_tag(cmd));
 
-		if (!qla2x00_hba_err_chk_enabled(sp))
-			break;
-
-		/* enable ALL bytes of the ref tag */
-		pkt->ref_tag_mask[0] = 0xff;
-		pkt->ref_tag_mask[1] = 0xff;
-		pkt->ref_tag_mask[2] = 0xff;
-		pkt->ref_tag_mask[3] = 0xff;
-		break;
-
-	/* For Type 3 protection: 16 bit GUARD only */
-	case SCSI_PROT_DIF_TYPE3:
-		pkt->ref_tag_mask[0] = pkt->ref_tag_mask[1] =
-			pkt->ref_tag_mask[2] = pkt->ref_tag_mask[3] =
-								0x00;
-		break;
-
-	/*
-	 * For TYpe 1 protection: 16 bit GUARD tag, 32 bit REF tag, and
-	 * 16 bit app tag.
-	 */
-	case SCSI_PROT_DIF_TYPE1:
-		pkt->ref_tag = cpu_to_le32((uint32_t)
-		    (0xffffffff & scsi_get_lba(cmd)));
-		pkt->app_tag = cpu_to_le16(0);
-		pkt->app_tag_mask[0] = 0x0;
-		pkt->app_tag_mask[1] = 0x0;
-
-		if (!qla2x00_hba_err_chk_enabled(sp))
-			break;
-
-		/* enable ALL bytes of the ref tag */
-		pkt->ref_tag_mask[0] = 0xff;
-		pkt->ref_tag_mask[1] = 0xff;
-		pkt->ref_tag_mask[2] = 0xff;
-		pkt->ref_tag_mask[3] = 0xff;
-		break;
+	if (cmd->prot_flags & SCSI_PROT_REF_CHECK) {
+                pkt->ref_tag_mask[0] = 0xff;
+                pkt->ref_tag_mask[1] = 0xff;
+                pkt->ref_tag_mask[2] = 0xff;
+                pkt->ref_tag_mask[3] = 0xff;
 	}
+
+	pkt->app_tag = __constant_cpu_to_le16(0);
+	pkt->app_tag_mask[0] = 0x0;
+	pkt->app_tag_mask[1] = 0x0;
 }
 
 int
@@ -905,7 +851,7 @@ qla24xx_walk_and_build_sglist_no_difb(struct qla_hw_data *ha, srb_t *sp,
 	memset(&sgx, 0, sizeof(struct qla2_sgx));
 	if (sp) {
 		cmd = GET_CMD_SP(sp);
-		prot_int = cmd->device->sector_size;
+		prot_int = scsi_prot_interval(cmd);
 
 		sgx.tot_bytes = scsi_bufflen(cmd);
 		sgx.cur_sg = scsi_sglist(cmd);
-- 
2.31.1

