Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA64CC48BE8
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA58B611BF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbhFIDlt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44764 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236562AbhFIDlm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1593AE2Q140897
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=9RDTU9+TyZ1wZaHBJSVtCQTa+r4NYuzMW5Fo3sW2uDY=;
 b=ylxM4HZmAsdwkzn6ILKXQso63NibAjkDaUBY8CMVV/lgEXd3rVWqbRyDa0MheJCGQvam
 v00wuGQ/61VLy9XptaGArcY6Rh6YuWNBSl6tTzd+WyqC28sqrCpgc0uTirCEl2rvQ0y6
 tsj1zOxGghHQ0y1uiBaeBUQ5sJjp89SONS4J/iQCULHc7kSUCDeFDlDlHMmIxiFABD7e
 WgMT4IpTfwMZRy84QHkkZ/VkyikY+BiuEULCnPxZfyaxABotlP0kC/F4dbkNNi8zhBj8
 +MdlcSIE4jkgAbDA6b0IbJhi7Yzt3XifJT7U55TjGlmSDqPvf5Sz7yLRxF3nIBgCzs0k 9Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 39017nfre3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z2Ka082667
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3020.oracle.com with ESMTP id 390k1rhr3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XReBLZ6lyViRt7o4dNHjVE9PdxetOMSQJZFyE3Lz2r3i1DUqMXZMLOA4nrKkqmcEy83fW+CcM86S1WjqN1d/Q5D3XTwdahM9y1xGI1F8rcffLvZ8MoeXIJuDOAd0Wql6p+riWjJ18GFpOjY1ZIRTr4HIw6kcSGlOLj0UUgI7V23gAKtw4PdYuwV6cOaJ7bP2BccQTNlgcAz8f4/ZeH1qlerd11XuQF4+3q2pPDhpULCr5YVYknJKgSRyTmDyHgtl/qpj9+XbEoBTX1+GvooPtHvOSVAShjWlymPgSVX8R2fsIFwIVohGGxEe4YCgne41+GwLrl803Y2N5YAadgTUjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RDTU9+TyZ1wZaHBJSVtCQTa+r4NYuzMW5Fo3sW2uDY=;
 b=V/xDLauXYMENzBvfMThEK9puLbZ88Bma+PJZdV6sXA+/Rk1bTJF+NbIS/VSNvtq/2sslL9vWTwzRVfkpWZ3VGQo9LHGRnZWXJe99OAPKY17FKy+HpyHu+TTd0fi73PxkxGu6CiLLI4GNXA89T88lCyjSjCZ24GZrZyIWgt+KKsCuAJRVV7VKpnvUENcgg8qvTHZni74adDW9PNDA78TlBMw0I0MtaQTddxGdYa1roo9qVrVWsfuMhIFmojrlUKc+z7Rg3vTNjZaie23XXPNk2+q5aLkddh1MSxplf8lRxgseF+zd3C3NTR+0D586tHODt7n9eaIYb6nISw9AVM2k6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RDTU9+TyZ1wZaHBJSVtCQTa+r4NYuzMW5Fo3sW2uDY=;
 b=gdrN7W+k5anSGWIE95wJJZkpDdCaJ1nCA6w76Bip/ycbsbZ1EYO7TnMtToEUj8kTZRl/gR6y20sDWcffECeClbRudnVY4rV6FTqSPWO1VCeOASibiNKp2/+hjBM7tmsDtw2i6ZtdByU4PxKJ6fFbQJZ5jcGfVV5aXJTx1k6HejM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 14/15] scsi: lpfc: Switch to scsi_get_block_count()
Date:   Tue,  8 Jun 2021 23:39:28 -0400
Message-Id: <20210609033929.3815-15-martin.petersen@oracle.com>
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
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f2eff0f-673a-4dfb-f747-08d92af838f7
X-MS-TrafficTypeDiagnostic: PH0PR10MB4421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4421802E94930F8EC54E35128E369@PH0PR10MB4421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +OPtDIT23oD1OOrmUKEaB5a+YcBJg/0tN3cg/ehvOqSs6qH4ZesLNGTyIAZ5mI5QnTgVQyAUHSGGMKT1IHSLJTkwhJ5s6ysfLOUVcfBvXVTETFD996Oo7twZ1HrG0+Roq2NfFoBxBceV5PEEUH305coxjU+klSRFp9gM91rKLzQh24kGgVlY5ZaSBvtXJr8PZ3wVCeJc0Dl9JwtVahh3T55ZAQjqSPn12yVmOjfHEUMYKYSsIZBzDTVSpeCvr/60LSZVQh9bhwhq8AvgC+HbL0qJsNMbE5icaJkjM5w7aByqx2qlpPRvoAwR+thMBOqZ/C8anEvIXtr3DI9OJxSXpzkFmhlaeWbDSJm6N15RA6MYwAyyIUxJjjCi+H3gt+5eREesYWO3wtRDWgslnxKsuzfSCg3+k+KWln9HDyFojGtwlI4SD/nt1uGPZpvMMyEVDNXjBnBl+Fe1zIyZmfSInUQhlu0GxX9k5WHl1eOWJjdJihGMPcVrH+q0Y9pG/7BocDaKULmUP+ZX9a/pK7QliETQOammYc9UJdM6zUR23hhlGhqUox7qROIj2Z9acjIzdEVTsmUvRLG5hvSO3xKEOI9/xT6IUx8UhDpiFJKZmlN7wsmVGwNTZalpgahyyTWfhciCmVzcHzVmduOnxdoRWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(8676002)(956004)(2616005)(8936002)(2906002)(6486002)(107886003)(86362001)(66946007)(52116002)(16526019)(66556008)(6666004)(66476007)(6916009)(83380400001)(478600001)(26005)(186003)(38100700002)(7696005)(38350700002)(1076003)(5660300002)(36756003)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NgNCBEukSPtsQtybtxLMMnsNkA1NkxJtxQ75P6cP2xgjVouW+Icn7mhmL2hm?=
 =?us-ascii?Q?bRcGfLITKqg46C5XPMk+/6GaLJwaw/zyv5sZmFBesOjI0zkB8Cfawzx/ej8q?=
 =?us-ascii?Q?xk42qipTl9FT4AHTdYcHD69fY4RAZDo8cPFt2zpSD91XO6eFq2Xs3f2KS/PQ?=
 =?us-ascii?Q?ovp/4j4iChGlrfqXENn0Gl4HTBvDT1QjAUOdDoYMJvISH1lQ3AUoncDlF5Cs?=
 =?us-ascii?Q?CDor7bWs/fmG2Q8f4OztsL75CmITfif5wTYUBYpPeT9UjGGQdOU78AGaVaOe?=
 =?us-ascii?Q?OYImt2Fimn4jN0bImGxcp+B4ixg0g7SN/q9fTrl8bfcstQCTX0pE0Ln2rv0h?=
 =?us-ascii?Q?ml3mNYZ5b4RC94OKqmqMSHNlJKYuLr2eWmOfyPoSK/P8+Hni9qnamv/4C+yK?=
 =?us-ascii?Q?ujWEeg4Flf6xIaElYFAIFwkwAkhDpwDe0IB12X3jtGREGlohQfUDChLf1+Zz?=
 =?us-ascii?Q?mCUtMMSo7d93Yq7bB+aobso0/LK5PWoWzm5iZvau5B8xW88UTxZRhIt0x5b/?=
 =?us-ascii?Q?T9hAY8gITzu5oCpisUWwNTtsu6sefUYlSXs2yYyY4EVmQcf/SGwwHqp1N63O?=
 =?us-ascii?Q?ss1KcDl1FIt1ZlgSCXbjJ6YfldfsDoWjg1sdVuArdZlvvBsVmIcevBw9limn?=
 =?us-ascii?Q?PpgJ9J/ln651aGaQBScWsENcKEPvMnqbO7HVkDPpp/rW2rpIlfM9KmwvSBvl?=
 =?us-ascii?Q?qa4m8S3uUobcGZojJ8A+6bqVIc77p1Nol0gg+nvscvHeyKC0UAmEUp/qamYx?=
 =?us-ascii?Q?Pj80wpFlo/mzCVwYmZWRHvrtAExkynLHVvItzCoJwtTiua7W/jUqd6O8zyBh?=
 =?us-ascii?Q?LLhAfRf8/i/91/Bs+ufCKGhvwf4DzUZP1vsajmSAJIq8j68spCriJceroE1I?=
 =?us-ascii?Q?fBoaq3qEBiOLcPvqHvpu48gfzNrpNdHwBMojZXNNViwhfLQHv1ZxodNY8sO1?=
 =?us-ascii?Q?sCgpIaEV6c/7wnlcVJiGQEbM8fz5aTVfwmfv5ff2eiPTAv3X1QgGGzTV1Jby?=
 =?us-ascii?Q?iG9b4+ksJ3ScoZyVW1f3cHqALuwdi/GIt9h36lthgCZ5DND3Gp5un3qxvXhL?=
 =?us-ascii?Q?pkDRybxU4wXIKsYDcUIUL1G3t7P/FvKEVZ11oaNhU9uWgUHVOTWrT2nivzxb?=
 =?us-ascii?Q?0Qw+v+qPOQ7Z/opVjN6gvhUr48D3hth4/3U3vJHmiPw6y1OG4S/NtEC+3oeI?=
 =?us-ascii?Q?dXv8/X7prUhsfwxYMtQdBTwC3QYAsgHSn1NhrS0DTXAAMHgbKdFgxPXtPKHi?=
 =?us-ascii?Q?KmnXID6CuVLCctfJl2o65qAy/kAltJxINmbFd3NBXUXgtEUJrm4/ZtmKgoMR?=
 =?us-ascii?Q?81lL5a9iDNSmvELk/e0DL133?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f2eff0f-673a-4dfb-f747-08d92af838f7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:44.8603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: olDmVcTjrgpxz+tacJfjdbVzGwgfXOaRk3ejhnojXQ7ZjaJ7JzTycnb08XW3ZGxw3u4mkZXWQfWTPyh+Nc31pqEIj99+eIZXC8vP1FP+LOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-GUID: gkoMexcF13M47nkx8dP3v59kFVMM8lHW
X-Proofpoint-ORIG-GUID: gkoMexcF13M47nkx8dP3v59kFVMM8lHW
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_get_block_count() for places where the I/O size needs to be
expressed in units of the logical block size.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index ca2e00e512f4..5f19eccaad24 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2959,7 +2959,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_get_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -2974,7 +2974,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_get_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -2989,7 +2989,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_get_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -3033,7 +3033,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				" 0x%x lba 0x%llx blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				(unsigned long long)scsi_get_lba(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_get_block_count(cmd), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
 		lpfc_calc_bg_err(phba, lpfc_cmd);
@@ -3071,7 +3071,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				scsi_prot_ref_tag(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_get_block_count(cmd), bgstat, bghm);
 		ret = (-1);
 		goto out;
 	}
@@ -3083,7 +3083,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				scsi_prot_ref_tag(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_get_block_count(cmd), bgstat, bghm);
 		ret = (-1);
 		goto out;
 	}
@@ -3099,7 +3099,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				scsi_prot_ref_tag(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_get_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -3114,7 +3114,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				scsi_prot_ref_tag(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_get_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -3129,7 +3129,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				scsi_prot_ref_tag(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_get_block_count(cmd), bgstat, bghm);
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -3173,7 +3173,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 				"0x%x reftag 0x%x blk cnt 0x%x "
 				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
 				scsi_prot_ref_tag(cmd),
-				blk_rq_sectors(cmd->request), bgstat, bghm);
+				scsi_get_block_count(cmd), bgstat, bghm);
 
 		/* Calcuate what type of error it was */
 		lpfc_calc_bg_err(phba, lpfc_cmd);
@@ -5261,7 +5261,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 					 dif_op_str[scsi_get_prot_op(cmnd)],
 					 cmnd->cmnd[0],
 					 scsi_prot_ref_tag(cmnd),
-					 blk_rq_sectors(cmnd->request),
+					 scsi_get_block_count(cmnd),
 					 (cmnd->cmnd[1]>>5));
 		}
 		err = lpfc_bg_scsi_prep_dma_buf(phba, lpfc_cmd);
@@ -5273,7 +5273,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 					 "x%x reftag x%x cnt %u pt %x\n",
 					 cmnd->cmnd[0],
 					 scsi_prot_ref_tag(cmnd),
-					 blk_rq_sectors(cmnd->request),
+					 scsi_get_block_count(cmnd),
 					 (cmnd->cmnd[1]>>5));
 		}
 		err = lpfc_scsi_prep_dma_buf(phba, lpfc_cmd);
-- 
2.31.1

