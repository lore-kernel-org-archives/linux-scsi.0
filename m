Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 078ECC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 08:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD0A860234
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 08:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbhHJIsq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 04:48:46 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:9780 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233034AbhHJIso (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 04:48:44 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A8f6Di022835;
        Tue, 10 Aug 2021 08:48:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=mkPL7G8DEkk4G9Y0pzISCn82wsE1lDi3T43bUCqIZiQ=;
 b=NfcQ6MJsFV9cE5hx4GSFpgUpz7jZaccSfAXHaqcXAN/dd15v9jjMZMdSUpSiEBJldMTi
 LLob5LiJ24R0car1n4s+HMs14fjZ5nZzz8XW9KxmEekIwjXqevFy+vrnXx1xp0JrHHB1
 xorBDlMnZVr/h5wzcnPf67mag0kBx7DvTjOUoUuSKNY+3lLsgm5AucCnd/IYP7zSEb5u
 L/Wn5rBCIYHQK//1lnj/3HlzTEH/kjAX3lMI8Q5efTAwyo7ki7UC3QGfnuHmrhnh8MO4
 D8KpPTCwfWq+HX024OndPcwAI0N/eGig8jBEX/38srtxTaoGLPs5NfJOmC17vyLHv4rx 9g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=mkPL7G8DEkk4G9Y0pzISCn82wsE1lDi3T43bUCqIZiQ=;
 b=rr61pfSEiqDufRqA77SS+SbE7pVHE95NFmg5vQPvWUmD2yig4xrVH5mQ9GLViQjJgfro
 2mrX75FZy84Eq6uogHQe2fmTRa+tGsmA3n3Ke2rBV1EgAN2NHU0vzWqgYaP23xXiKHkD
 dIezPaXTU9PLYjSVTCGqcNYVKIYpXe346R6N3KoyKhI8IlsNmYxhISiMYmE8iKnRvAfo
 wLqWdhRMs83MOf0nbie2h0i3TNsfQcX3yi+S9WUrVje8jaDMN5wNnG9XawVj4X/9J7zD
 o76RENt+DTj1d5ZaTZ6VLqY+VmsqsPGcW4DrFa4nlLWbiz7NJVJlEqs9u1Us+heAAnG/ Yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaqmuuf4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 08:48:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A8eWSS189603;
        Tue, 10 Aug 2021 08:48:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3030.oracle.com with ESMTP id 3aa8qsqnxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 08:48:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBgXIPzayL/DC4T1rLmr0zOGKvk8zXL3o1S5H1Bklxccqfcet/eXMgRuwjhCpxRwZ/xCrwYTTOwmPxfj8lv8kuH9QCdnKlrzsMIZ9D7nThc8EvUa270ITXcMBeLLzQoxk2Q+cEEDEK7jD4rtmz/umuFvw6IPTQbeoKBoArGr1JbWrt4/V+21sQmMNFBNRE3a0LyKTn6EfYeugeHnh7GkI9IiTZFuMG463R1riv41IJmaKqZioOS702Srp71tjO3eiRhOqRMKsOtsNaTeQggauFB/iIsXTMgZeWcXFLOih5GvtyFy1rgX15gLFbZuSEg5fb0GX4zKpnwhHyabCjVvfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkPL7G8DEkk4G9Y0pzISCn82wsE1lDi3T43bUCqIZiQ=;
 b=RvMxlPpSorufeW9HgJw5qrzSJN4LpIvbh2YvUA57l3ICekbP8u915oX4Z7eQw+3bdJf3gYMtFlCzfXUHT0HVU6nAmkB5j/ZbL3r34iqVJL6/HQoZM2osUL0Kl6E8DBIe39b35/SiTdM869p9zw4/nVcqdopi7cA3rfcskZQPhl3O9pHOPS/Em/f9Wt6TTetuhddnt1m+beJ5VbSJDzbCrdGeSKPQ6lXPFnaE14lI1BaHGVYyiwBB8paIs8bkhbsdCv39MKQkWkmGKwQlXRnw0zRk6uSd3p+SrXp5neWDSXlS2bXZ9dzr4mcQ9rD7/InJw5TRHnE1Mex6TQSzpDiiNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkPL7G8DEkk4G9Y0pzISCn82wsE1lDi3T43bUCqIZiQ=;
 b=0TAqwHfwRbcjeQ1USLB57flASMz9mlrnPCOBCFrOVGdhSQdkThS945DC70fOfPAgoiuYF+9I1fnZ77Kko6A5IC5FPX6GEwBtJSk2+vQMp7gsyvsxcIWUv6YlysdX+27RTEnqfiBQZpc1pMGGzY+M95dDs8DzvWwVLnGyAPhTxmk=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1566.namprd10.prod.outlook.com
 (2603:10b6:300:27::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Tue, 10 Aug
 2021 08:48:11 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 08:48:11 +0000
Date:   Tue, 10 Aug 2021 11:47:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <manish.rangankar@cavium.com>
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Arun Easi <arun.easi@cavium.com>,
        Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] scsi: qedi: Fix error codes in qedi_alloc_global_queues()
Message-ID: <20210810084753.GD23810@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0050.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (102.222.70.252) by ZR0P278CA0050.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 08:48:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 835c8b53-ee0c-4592-6015-08d95bdb9503
X-MS-TrafficTypeDiagnostic: MWHPR10MB1566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1566A2777BA920FFD45146AC8EF79@MWHPR10MB1566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: szo9JNG2DeJpEdcFmcdSu1wwDLpMp6i5wbgaV7Zdo57E6sA2PQgrPB2bxTM4FFAnsvr3pXBXmabKiDgInTI5zUVgxyzhEwXZCUEgbztrit8AZvkkr8ZZ6EEoceO1ZY3Xigc9EhCLjzlzju9a6jB78HqP3e7tELoS5i4MySgEG50DIJxJ4BFBA+DTH726Fv44SPz9tPM89dmL321GDxKgPaCaEc11b+bUTJm4d/mQ0f9NkdYNaKavH7NIwB9f9SxqHnOzJOIyfvrUncIIzhEy65ObsobQeBF+VYDufy4LS7bN4GY60Int1m/poPmEgvycCYqcEj8qBsNpgSDYZPALuyR0HV5t0Bna09WoFtXN10LgyQvl5Mw4KCF0Y1IvJnmxd954t7hKIav+2Qm1OOrPGG42NGmnHEqB6w54UG5ZI8dC78gegrox/6x0nurr1jLM8XTrDyDbi6oDRAfIrVGBkgsBHixeMPKbkrLsgZ6ebqhPftPosTIDshmUpMlVYCTk1ZrYHnNFqHhGiefKUihmHVRGpdJN8KYxrBGvV15uXbWctV5JBZqmAYiiCUtJiXR6zeqij1jxdWD+Dvcslz1x1bS7mseXp6m0pvStFOz7/QcIL+wvrYmI80a/XHsdKtBwF/Om3bUbZiErByjK3lAWzMYsB0PR5N7KcOnUFzP+n6oMpl9tpybn30qmJLGXDHudsFe3l2Os3qTOAxncpriVHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(346002)(396003)(38350700002)(52116002)(1076003)(55016002)(86362001)(9686003)(478600001)(6496006)(956004)(83380400001)(33716001)(44832011)(54906003)(26005)(38100700002)(110136005)(6666004)(316002)(4326008)(8936002)(9576002)(66946007)(66476007)(66556008)(2906002)(8676002)(186003)(33656002)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?joewkOvjgb/vTGpnITsirQY0MT99aojnhzjqjX1NyOeOEenQs8wWv7MkkXt5?=
 =?us-ascii?Q?QyCmsNX3qyhmBaM9VQ2H7VnqiYswyfUH5fpLifxGmsJRFEdDdFo0Kl+Vbk5m?=
 =?us-ascii?Q?Ba2rOkPUpDoM2rMHpIREn5dRNDPlfr61+yBasDPaA/Zd6ucBVjiXVdw730ja?=
 =?us-ascii?Q?FpZYPFf0PEwzd5dXB3HcFaoAIdnXmd/ThLIgXSWRhL2i2D8dvHJHqv2hq5qF?=
 =?us-ascii?Q?JJWyarNYSnzCrz0ghkr5jHbcWQttdaM9SBMOp6Te1RRXHwbjHZuBXMJmIfs5?=
 =?us-ascii?Q?Kr/zbV7Ry6tDz03Z8T5HsqAbHx4BcaaSUAqcAKwPn/Tg0CUQsQxGoo8tSuVi?=
 =?us-ascii?Q?w/j6dvr73Dx4+fIHDSH9vSvngyGVHv1/nhQPKQLU6Jov8ZNf0gdkuGmFqDYa?=
 =?us-ascii?Q?Ukii62d487HNT9BURHaPl9988KtsHDW5IgSF2Uo5RvyW9pYNbnPIAGwdbszj?=
 =?us-ascii?Q?LVddE5Jx4/XIL5BZzxzICjU1NZtO/2jvQVTi0oHOrTbrTlrE17S1Am9TQB9U?=
 =?us-ascii?Q?gerZJMfyoNxgXWo84FwyrD4jrGVIKP3JG0NJgSFEh0coJzLdRbBJc18zhV1L?=
 =?us-ascii?Q?nRRwu0JsYEMXzrauwQclSYVdAhJWDVdnXUjvTCgsCPGj8DK3xCsDFJph0rDd?=
 =?us-ascii?Q?rgyDlCEWpBgKsUDpxr0Yc7bDOBHdXULWsQoJ+PneeLj6kQyv8JrgjH6szI6A?=
 =?us-ascii?Q?XEHMAZjEPsolwgWJzhKU+R2tCfwEF1sQEkvjUzb2cxU5OOzf9eFsZbmPBq2u?=
 =?us-ascii?Q?8IufL9WrDCAkIKk8UZB63QOJNess0+Dg37Ve76yOvck0hvv3CXfwTX+gx7zI?=
 =?us-ascii?Q?nTqrjcMcmLewjBDkLhq3/Q8pC1qWHWCmftSx5puvVBguG6ZFknnRsNn/blOz?=
 =?us-ascii?Q?PspaDMgSvynbzsAegjU/2NL+PHaxe/i+n89vxl8QZO+eNOKv4QzR1GH/SPPv?=
 =?us-ascii?Q?CqJ7Jjd0iCcNUVrsGpbbsh8cOM4xdBWeY9wwNYPCCg+bDj02cw6GuQHBVeGU?=
 =?us-ascii?Q?9tsK3EOvp1+DZwDCBLFbT0bMWSIvbpupwbte8o5B3wneqQHkzywcyBH9fRQX?=
 =?us-ascii?Q?X6CTGWQmngCsSAhd8/aan8zc49IQNIqE6aPol9QKGy0O0wFJIMEf6bCYqqlF?=
 =?us-ascii?Q?cQlciUW3iU87mhLrsvB0uZdn7n3jNaeO+wg7HogAlw3Zkl/3b+WGLCpbLqAS?=
 =?us-ascii?Q?9l1REwn+W6tRxq0kUka471z7icjutpO6yR9YcRkDyZkacBZSH8kCN09QMG8V?=
 =?us-ascii?Q?21nC0mMwGSijlm6cJJ5wHNdeRWIMP4NQhtAF00CxLaQpF2Jk7ZDg3xHOKgqw?=
 =?us-ascii?Q?IMkRbza9mzMgzjC+W+l2WbI7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 835c8b53-ee0c-4592-6015-08d95bdb9503
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 08:48:10.9235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JCEngTm3nkHTIvr4XbSzzt7AOioK4GmrTLNgb7iA4ZgLQwz5RGZ0bEnvrqigMafKvznBmAxDX8aP4TnLdvMS+HnsQJguifBIOfUkNIqcoFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1566
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100054
X-Proofpoint-GUID: 1eE2uSpMID_uyg3n1in52XkOIeXcJWKG
X-Proofpoint-ORIG-GUID: 1eE2uSpMID_uyg3n1in52XkOIeXcJWKG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This function had some left over code that returned 1 on error instead
negative error codes.  Convert everything to use negative error codes.
The caller treats all non-zero returns the same so this does not affect
run time.

A couple places set "rc" instead of "status" so those error paths ended
up returning success by mistake.  Get rid of the "rc" variable and use
"status" everywhere.

Remove the bogus "status = 0" initialization, as a future proofing
measure so the compiler will warn about uninitialized error codes.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/qedi/qedi_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 0b0acb827071..e6dc0b495a82 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1621,7 +1621,7 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 {
 	u32 *list;
 	int i;
-	int status = 0, rc;
+	int status;
 	u32 *pbl;
 	dma_addr_t page;
 	int num_pages;
@@ -1632,14 +1632,14 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 	 */
 	if (!qedi->num_queues) {
 		QEDI_ERR(&qedi->dbg_ctx, "No MSI-X vectors available!\n");
-		return 1;
+		return -ENOMEM;
 	}
 
 	/* Make sure we allocated the PBL that will contain the physical
 	 * addresses of our queues
 	 */
 	if (!qedi->p_cpuq) {
-		status = 1;
+		status = -EINVAL;
 		goto mem_alloc_failure;
 	}
 
@@ -1654,13 +1654,13 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 		  "qedi->global_queues=%p.\n", qedi->global_queues);
 
 	/* Allocate DMA coherent buffers for BDQ */
-	rc = qedi_alloc_bdq(qedi);
-	if (rc)
+	status = qedi_alloc_bdq(qedi);
+	if (status)
 		goto mem_alloc_failure;
 
 	/* Allocate DMA coherent buffers for NVM_ISCSI_CFG */
-	rc = qedi_alloc_nvm_iscsi_cfg(qedi);
-	if (rc)
+	status = qedi_alloc_nvm_iscsi_cfg(qedi);
+	if (status)
 		goto mem_alloc_failure;
 
 	/* Allocate a CQ and an associated PBL for each MSI-X
-- 
2.20.1

