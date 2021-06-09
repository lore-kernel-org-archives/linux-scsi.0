Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F17C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 683C261263
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbhFIDlc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44684 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236530AbhFIDla (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1592gg1e083742
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=TBDpIRgTPKOvL7dih0LhiNkY8Z/qM3S/CjRHvInPfHE=;
 b=CLav+OdeUNTSpj1t/XIoPM9+sL88VjI8fNfDT9PS1GcG4o+CPvyIuHAukhtEUxamV1Bf
 4O/hTLK09HD+I9nQJ3M7FRg7cCcEDjEBpachkPWV8522elzbtX0OA2yGU5N0evo3rYsS
 OJtr/U+V2knhFxoVzV8pLcXeirBq5Nqb1ff7X+W4y/ouIZqAYoMaNKGGlA2dSjPxmvQA
 WSzgUKbtxDA1q1rb/xGUgeGtEz/py88e+Mr76VVZehU2e+TSouYbWA2VTnGmbwWiIm5Y
 T1/Yd6v5Iz/M+vbCqsW5mw+7LUg8cTYfeZhr3xYi7C1/NZg6tMHInJs+wnFr1AcHr42J Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 39017nfrdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z3gx082802
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:35 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 390k1rhr0h-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lduwexcqxgNzfuh6Gy+lh7WIDEw5ptjHkzApQjlzd9rA3jHifrC3AnoPkSTGCBoXUFjO6sARhsoKPmi7U9iVwmd42IK5rHJfavI5nmrK7PrNgcaMAE+c87BQPNDyW5JSWLEKFpUTdzfK2KWSHZlu+rZXH5btK4D9rtycP2cY+lecO3dy6h6nL1oxZ4qkNViHqh76M5Lcz27IQFO4dJ2oPuTZ55JMy3mWw6jcpRVqQSBTpScNZskEIV9xoxWYUHHjpM2wy0cdwCGVkck5QiQ9XIKqlsZdhTJ/yUG/sbkmomOjwEBiIB9F5X88nGrKCxvID8KH/NubB/JK8WNd3yfNSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBDpIRgTPKOvL7dih0LhiNkY8Z/qM3S/CjRHvInPfHE=;
 b=iorrw77brlpm5AXEhLsmPCUoekR8MzsDoGafXQ5eKxs+dPezFw6pw1bwD2Hh3w1K1BPL9M658E6hguW3l5VuWxXptEfXcM6UwiS7iPgKTULthvzGd/2trhtRdQK5mMoXLv7fWyWvf9o0lUkF4inasDsmLTqWyKrz2WYg+1hlxmPonh62HEZN2I6K6oT/8WDB/cUosahJkgsZPUn4+fbido3u+Ev2RBev3XYac/r/nFbvR0utdmB/kUaKZ9l9S07AmY5/5QiAgCt3lz5FsF5o+YcySL2pJ8fPW4uZYGGK6rBecZwMAVuTqLFQjKPb7Tztzb3HQueIybr+9E8iC2HzEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBDpIRgTPKOvL7dih0LhiNkY8Z/qM3S/CjRHvInPfHE=;
 b=b9KeKGbCSX9ztLUxXUceK/r5pwlHkWYRjJ+8BWRDre8mLzRw+C90xu8VO9F27iShSTzYIgxHKT1Fpg8iHiN2CKFU4vKb4NU1fJhqs2EXrKHvjj3ChUXFdqCXYJjozsCAmGIvhWII9weDs3TOkBbUdSfPfzYwVv1TpCMzqzvpxGo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 02/15] scsi: lpfc: Use the proper SCSI midlayer interfaces for PI
Date:   Tue,  8 Jun 2021 23:39:16 -0400
Message-Id: <20210609033929.3815-3-martin.petersen@oracle.com>
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
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c8976de-4d11-4fec-493b-08d92af83267
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44229262ED67C5A1318A72FD8E369@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E0r7v2SOXNfISoMJxr+rGous/rvkWyq7qrLQOcpXbfj7DH44LSlBZMrQimDan494cweei3uioJqhqeNi/Q5hSIPkg0/0w43miXF7QNYysIUKXtVNYS1QxJv1PON3+uViDzPNbU0+i78NnO1RklPs8hJDugdytC/W++1lDIJGxD5NJUgk9t8B2SC+1gcOhANUGaf+bxoDDZQTc1FHWHeZ3FAar+8f9KVJm2PuBNnClV9gxK9MmldYpYQBwz2hII18SOStHJ+FbwRiW9j8ApdV6Az9kDwwa6r46boprJ5MZR7s3/q3FM0M8gLsqkB3CoUXGvI8v84jAk+Yw2vwrvpdQ1QhoJLQIy8IwlR9KCD+nQyiS7DG0zk+J242088z/+Ph1/teH5vxs+qE1xg4d6rHYV1Sq3YHBCbIafCTyUR2IssiCuQFW6fL5RhBe2PS0OUJyzrJR/6BMy6VU0YP54p7wBGkYncmyiJF0UyeJbHOn2O+Q9AcMZZdW5xSZSnTgXUpQdLyS6nq/87fgppk08hHcfjFq3OH8GpocYHNLwPv6n+YZGm1L5eZcFI2ovo+nVNd0OUSfyA2obGKddhB2+CNDfqtsD4rRoEgcv955H8S77m05ybil2rXhcXdkUBD9mZ7eajOOdgvcQtN0Lk30cszNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(1076003)(4326008)(6486002)(316002)(8676002)(8936002)(66476007)(186003)(16526019)(107886003)(66946007)(38100700002)(6916009)(26005)(5660300002)(52116002)(478600001)(956004)(2906002)(2616005)(7696005)(83380400001)(66556008)(30864003)(6666004)(86362001)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3zi0Jnc3dNHtv0CVL/dLRf5tNuI5hzg+5DHynBZ0rv1Rlj/0Us5riNLIXqD0?=
 =?us-ascii?Q?n3nZkNJ3cD2zf4aAOBgT3pdkfq4jtmt3waOBmtRzjoCMHUr955gUiS123omT?=
 =?us-ascii?Q?r1Sx0kxrvCHAimWzUnKFbM7E4WCd0jHrgrwbOSwq0jryF+Zz48OVoNcafkbH?=
 =?us-ascii?Q?VDPigdQ14mv4oTdxBBkLcNeCcWkW5VWi4nONzoFZ1eGWAc5zKj9Xf+a0pCaF?=
 =?us-ascii?Q?1yCiXnKo+3/CbSG9EIugGrOyYszSXgxhzz4+KjgeezWxe0GRDik118TK4fGi?=
 =?us-ascii?Q?QFRbEnWUrIwXUWF2Y9y9aZxaclL/OzIhf9JN5767ASSq4k9Ua9WIPRii7shV?=
 =?us-ascii?Q?yNhP+NZlfb2ail6iFcdcvpJPG+X1VWU1SblF2Ggf0Ca0qGMdAVqs/8Gdv8Ug?=
 =?us-ascii?Q?wN5u0BfjBp2CZLPuB/GejVbNgJsAztlNBosUlRzY/bfjKvLLgq5xONemTPav?=
 =?us-ascii?Q?iZyTuSM31vfoQYt2HSqS2jkten1FSnkmpzVWVP39rjLScZX57PCDXs7MflCw?=
 =?us-ascii?Q?xC6e747m/ctvO5NUhpmk7tPC3AXpKf7K+IWB5rFPJt4Y7v/JhvlfkhShlaAz?=
 =?us-ascii?Q?nToduMVdHNM4UAdDW8w5LyxcfcXE3skpNEpCjOnyIleHZsn3ug4pYGeF6TEi?=
 =?us-ascii?Q?XgKiEmPJihjKyiKeQP2+Nbj0G1oooE/9T/CUgD/C6C0wpRLAL78WDpKJYUaW?=
 =?us-ascii?Q?WLRSwAXOQnAIaedy8Zts9PRi/rNX7kEPho8goFAspKhZHLstEWZp9PKql4cm?=
 =?us-ascii?Q?TibaWS8Rtg3/LWEkYq5WdEKAnKcY/bThXQv5IzyQgHM0f60zc2KLSr6U7oUw?=
 =?us-ascii?Q?iYoQdF7xPWvRNbxQI2vDjBGus90mTmsisMQC6uQHhbvDQNv8x79miKnHLp1n?=
 =?us-ascii?Q?yW0dOx6TUwXa2+DaGa2h7li2MBH2wISnn9EOA1t9u8HmcDZL5xgurhnaaeyw?=
 =?us-ascii?Q?ynioOQFGqQZ+K6atqoD3WJP+8n+r81PgW36uLRjFgWhCauu601C0yigksD07?=
 =?us-ascii?Q?Symc+XpEwStHZPA+m4Hh8zmmvmT63n947PmiSSEGqpR+7c+NA0dqm1R2uwwQ?=
 =?us-ascii?Q?4EaBrg2XcadWVM91HvG0/BlePpHFdCGb5czJx/om3Mlc5gwzIDlmaOLwW5vY?=
 =?us-ascii?Q?Mv3VbLw3s31Vbwm0v51gwGbTIGVK6pzNUPYiqwYePgq5KQqfHBaPIFkeuR2H?=
 =?us-ascii?Q?PUjG/FWBZjTJuFzZ8iyZgK6o/qTDVzdP0BG2bl2m55rwiZmcY/aI81B+LONL?=
 =?us-ascii?Q?416RfjzAxn5yMenD67CpvJAaui7j6RLCybZs16eRNx7XIkgmjQ6B6b/7SkZM?=
 =?us-ascii?Q?h0U/OkCvTD5mx3QjFYL25uYg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c8976de-4d11-4fec-493b-08d92af83267
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:33.7184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UtTiUZpm54oMUO5oiRYvHr00tO6wJqZZL25qzNUOQGI+7rds0gJbfPfaU6PQOfEkI8pH605R+FH1GMyYcgAh+deQehx7iqH0yLaZfYAoz38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-GUID: 1addyXBeyBwW4qPQGjTFXO2ZZW60T2pV
X-Proofpoint-ORIG-GUID: 1addyXBeyBwW4qPQGjTFXO2ZZW60T2pV
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
 drivers/scsi/lpfc/lpfc_scsi.c | 92 +++++++++++++----------------------
 1 file changed, 34 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 503919b10a6d..ca2e00e512f4 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -87,30 +87,6 @@ lpfc_release_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *psb);
 static int
 lpfc_prot_group_type(struct lpfc_hba *phba, struct scsi_cmnd *sc);
 
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
@@ -1037,13 +1013,13 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
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
@@ -1432,7 +1408,7 @@ lpfc_sc_to_bg_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 {
 	uint8_t ret = 0;
 
-	if (lpfc_cmd_guard_csum(sc)) {
+	if (sc->prot_flags & SCSI_PROT_IP_CHECKSUM) {
 		switch (scsi_get_prot_op(sc)) {
 		case SCSI_PROT_READ_INSERT:
 		case SCSI_PROT_WRITE_STRIP:
@@ -1512,7 +1488,7 @@ lpfc_bg_err_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 {
 	uint8_t ret = 0;
 
-	if (lpfc_cmd_guard_csum(sc)) {
+	if (sc->prot_flags & SCSI_PROT_IP_CHECKSUM) {
 		switch (scsi_get_prot_op(sc)) {
 		case SCSI_PROT_READ_INSERT:
 		case SCSI_PROT_WRITE_STRIP:
@@ -1620,7 +1596,7 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = scsi_prot_ref_tag(sc);
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -1659,12 +1635,12 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
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
@@ -1782,8 +1758,8 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command */
-	blksize = lpfc_cmd_blksize(sc);
-	reftag = t10_pi_ref_tag(sc->request);
+	blksize = scsi_prot_interval(sc);
+	reftag = scsi_prot_ref_tag(sc);
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -1823,12 +1799,12 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
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
@@ -2014,7 +1990,7 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command for pde*/
-	reftag = t10_pi_ref_tag(sc->request);
+	reftag = scsi_prot_ref_tag(sc);
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2042,12 +2018,12 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
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
@@ -2214,8 +2190,8 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		goto out;
 
 	/* extract some info from the scsi command */
-	blksize = lpfc_cmd_blksize(sc);
-	reftag = t10_pi_ref_tag(sc->request);
+	blksize = scsi_prot_interval(sc);
+	reftag = scsi_prot_ref_tag(sc);
 	if (reftag == LPFC_INVALID_REFTAG)
 		goto out;
 
@@ -2272,9 +2248,8 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		diseed->ref_tag = cpu_to_le32(reftag);
 		diseed->ref_tag_tran = diseed->ref_tag;
 
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_GUARD)) {
+		if (sc->prot_flags & SCSI_PROT_GUARD_CHECK) {
 			bf_set(lpfc_sli4_sge_dif_ce, diseed, checking);
-
 		} else {
 			bf_set(lpfc_sli4_sge_dif_ce, diseed, 0);
 			/*
@@ -2291,7 +2266,7 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		}
 
 
-		if (lpfc_cmd_protect(sc, LPFC_CHECK_PROTECT_REF))
+		if (sc->prot_flags & SCSI_PROT_REF_CHECK)
 			bf_set(lpfc_sli4_sge_dif_re, diseed, checking);
 		else
 			bf_set(lpfc_sli4_sge_dif_re, diseed, 0);
@@ -2548,7 +2523,7 @@ lpfc_bg_scsi_adjust_dl(struct lpfc_hba *phba,
 	 * DIF (trailer) attached to it. Must ajust FCP data length
 	 * to account for the protection data.
 	 */
-	fcpdl += (fcpdl / lpfc_cmd_blksize(sc)) * 8;
+	fcpdl += (fcpdl / scsi_prot_interval(sc)) * 8;
 
 	return fcpdl;
 }
@@ -2802,14 +2777,14 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
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
@@ -2830,7 +2805,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 				/* First Guard Tag checking */
 				if (chk_guard) {
 					guard_tag = src->guard_tag;
-					if (lpfc_cmd_guard_csum(cmd))
+					if (cmd->prot_flags
+					    & SCSI_PROT_IP_CHECKSUM)
 						sum = lpfc_bg_csum(data_src,
 								   blksize);
 					else
@@ -2901,7 +2877,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9069 BLKGRD: reftag %x grd_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				scsi_prot_ref_tag(cmd),
 				sum, guard_tag);
 
 	} else if (err_type == BGS_REFTAG_ERR_MASK) {
@@ -2911,7 +2887,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9066 BLKGRD: reftag %x ref_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				scsi_prot_ref_tag(cmd),
 				ref_tag, start_ref_tag);
 
 	} else if (err_type == BGS_APPTAG_ERR_MASK) {
@@ -2921,7 +2897,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9041 BLKGRD: reftag %x app_tag err %x != %x\n",
-				t10_pi_ref_tag(cmd->request),
+				scsi_prot_ref_tag(cmd),
 				app_tag, start_app_tag);
 	}
 }
@@ -3094,7 +3070,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9072 BLKGRD: Invalid BG Profile in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
+				scsi_prot_ref_tag(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 		ret = (-1);
 		goto out;
@@ -3106,7 +3082,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9073 BLKGRD: Invalid BG PDIF Block in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
+				scsi_prot_ref_tag(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 		ret = (-1);
 		goto out;
@@ -3122,7 +3098,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9055 BLKGRD: Guard Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
+				scsi_prot_ref_tag(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -3137,7 +3113,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9056 BLKGRD: Ref Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
+				scsi_prot_ref_tag(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -3152,7 +3128,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9061 BLKGRD: App Tag error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
+				scsi_prot_ref_tag(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 	}
 
@@ -3196,7 +3172,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"9057 BLKGRD: Unknown error in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
-				t10_pi_ref_tag(cmd->request),
+				scsi_prot_ref_tag(cmd),
 				blk_rq_sectors(cmd->request), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
@@ -5284,7 +5260,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 					 "reftag x%x cnt %u pt %x\n",
 					 dif_op_str[scsi_get_prot_op(cmnd)],
 					 cmnd->cmnd[0],
-					 t10_pi_ref_tag(cmnd->request),
+					 scsi_prot_ref_tag(cmnd),
 					 blk_rq_sectors(cmnd->request),
 					 (cmnd->cmnd[1]>>5));
 		}
@@ -5296,7 +5272,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 					 "9038 BLKGRD: rcvd PROT_NORMAL cmd: "
 					 "x%x reftag x%x cnt %u pt %x\n",
 					 cmnd->cmnd[0],
-					 t10_pi_ref_tag(cmnd->request),
+					 scsi_prot_ref_tag(cmnd),
 					 blk_rq_sectors(cmnd->request),
 					 (cmnd->cmnd[1]>>5));
 		}
-- 
2.31.1

