Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2731C43460
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BB2661152
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhDXWHO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53556 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbhDXWHK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6PrP124448;
        Sat, 24 Apr 2021 22:06:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ipABApYBx/qHtNmgooPAL349hnbndgGsnw3Q/t4olBM=;
 b=F7JS3Ys24CZc68/c67bmKqSQ1hL6Ugl9TdHhn1LMJc5ALs0BB+FOfE/hciFcLsrAMz+U
 Ls62I//88JA3IpQ8RxM0ODLvTFcxNbJICutemYQnC8gkHVJ0ht6e4Fr5ScGY7iuBczFW
 KYJClzhWajwoIQxQzWFuOVCqKo4bk5SEMdCbR2960KR8i4LwkUCjDe8aeFN5q+jxaqXt
 nbrs62KTidyxAQMBT4siu0p4K/5pUUjBNU9PjS7M3PILDSVVUPFou7HxXCB+OBS1flBR
 9xRKmL3RdlrHCP6/D7SSRAWnBtez1KQ7xarn3OJ8mMZx50veRhmoIDFFS3UozHNuoUoK jA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 384b9n0shj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM65rR182259;
        Sat, 24 Apr 2021 22:06:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 3849cakftw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GcsvjxvGpG2vzc71vYaqNKvbPOaGOrualTkFi46HjcDIwA3+AFodPUf1EckJjx/vr3DHIf4egWSxeLoSWraGTV4WU0jtVgZJbp+uQl6CnvIfCHVjlfRezbahW5pHilz5C43lwj+Vd1qdJHUI18ldEwSRc0WP8G2gG7fG0b54KILZLO0RIkDg2xLqC7cJ/VT5naJAVUVy5V7Z6nAmZ2e9vItERZvGouYunymhwaJ9vAzC3aHpZRkgc6ddrhBXsKO9osZ4Omz2PYD0/qoqDjNiuaHBW3j0qUPuAA3ZhnXHJwPlMsBGEio13HAmzXkkbShSBhSSwlztXhi23AE9rqhzPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipABApYBx/qHtNmgooPAL349hnbndgGsnw3Q/t4olBM=;
 b=OdFrXim049orJyoD0uTLXhSo6a69luQayzO0SYWDmqdNVydAtkKu/OdL8UKROk1gV/3kwADwyykjCZXkQ4cjdeHUiUmwzR72innaDKJRfoXHFOMW8/zRH8RZCxLnkMWGqILPetydiK2eBhj2sFZapYd6HMys4U9vyf+Hv38RzTZiDPaKwDKAmvqi8n2tO2q1n+J82LE4SQvKeF/LMh4xcBoxYdyQcrKcSYg3uAovBVzUZUPHhI8ybJ1YwZJsncQb/Hxa7+UBZ/zNqhXNN4pplqxNId+hZ2CWjM2su+rbfOyd3NpuF2FxsP12ObIi8iZYxYjx1NPpBrC/jfRZ4vTkgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipABApYBx/qHtNmgooPAL349hnbndgGsnw3Q/t4olBM=;
 b=CgnEJKewDjjxFMrERWnqSVuYD6bnw9ZjS5bGhzOkom5RPHU+Pq4T1JjUOvIgzUddMApr6SDMfMQbNW/DjqFdoDd5dutluyO2JR/OlXkJ1uZCAuIYJ+pMQAv6ks1qh8nSEycDNNY8ZRVR6+pHU7pFPbCKvqdo+ldvqrMHj/lBuI0=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:23 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 10/17] scsi: qedi: fix use after free during abort cleanup
Date:   Sat, 24 Apr 2021 17:05:56 -0500
Message-Id: <20210424220603.123703-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7e926f2-b1d4-4f77-91a7-08d9076d32ac
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3317AFD68DEADC8172F822C5F1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hGfBWUqE1ZFxJk6CLUPLDVt/7UJZltYpmvYkwBRP2HE1MesPyNnMDZSyeuFMSAk/pyfmGhSln2ymufJ0qLG0En0nBgj8BSLWV34510rh0WTCLDj1xgFZlhVy0mmJPrCiawGRGsRWqs8d8cz9htUpPEyrZ08Di+25D+e2AdJwHSQvZ7l+xpO2QUw/MBCWHnOZzL4sHJC9HAYz26CaSTtfBTIFCmTGzX52DRkF75VBi62ZEMsnaZk+Yw5uhmMICgpYdp/GZvBXtu0uZH6BiwayNOZ5saWHTgDF41Isnzj6EK4waXztwTA+s/aIG3YuqPwIbxKZNrSItJxTZq8mfk0sCslbt96ZLc/Q2crqRnC23aTKm95Wj8TuteEsOxrrPI+so7v1ifHyJfXl6jLLSJM7InnDIfFk8Bn/aUA1TDmEuMXCfeouLdRz94da0hOmmxhOsq6+eWveBsAPp0oVA4WrB5JDWVyymmLFrB1dUTKXoIEdlUsYSBH7s1nsvW3j/B9ay8Q/adJa/qArho3Ri/rmSlV5gUlA4dKBE5YCyaU0pzgvJkzv8zjfWfbCQInFbHrPqrK/dajiFfNEoCdbJRR/b808oY9O9BsTTLKftD4wUL8u9J8Q8YnKl2IuPlsojY/P5uHRbhNLxVCIwaZcsJ2nsqhKUUaLoFyxHqtRGTxIyoM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(4326008)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(16526019)(316002)(6512007)(8676002)(956004)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(107886003)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OW9cEcgF8jO6Fisk/zjM4YfpxJntyCqXY9lXv1V+NYeeyE6XhAd+AvNcRLSx?=
 =?us-ascii?Q?ype1GG0uau52Eb3YjNcMY7LPP8d0bfh88+Lo+FgmNXbOwlHnx8UVPQhUt7/h?=
 =?us-ascii?Q?LLWV7mTW7R79ccMNCL9fWG6lK1nl+YHZQi64E7bhHsF2vuEIPgViQBrC0I0Z?=
 =?us-ascii?Q?BeJpLh2KOCOvKOcn9U70DnjfCaYDBd/HXaDW6AKcxvesx44S+/6LafN3zbAd?=
 =?us-ascii?Q?VzrtyBJdA7wFJoNmh1lGqUREwHlKbe7bhn5t9rbMW4rwmuLOGVJJmbSNfZhZ?=
 =?us-ascii?Q?Mb+lfTAEFeIkE2tNM89MO+TMIQDz2Xc/U6GqIXf2k+Km7zZ9fTB8/EBngx7+?=
 =?us-ascii?Q?+hHY17S6Ff3sILWGstYbtUdZ23csPM3iIPBJs/Q4IpM7OOwfb3cHeYTiOQiL?=
 =?us-ascii?Q?w1ytHwJd3V0B0Ff9JuZjit6tYFhT5lNbJcA5HcHyrRWrN/vomoRqc1z6jZTT?=
 =?us-ascii?Q?fd/gnp9UbrxRidQNz1Zz6Vr5VwnGW3q/HOEX35inPV1OpsFbpsaDcRDuNKKp?=
 =?us-ascii?Q?43kpxLSXIFW9p5pU/Fmriu/6UMXt2T5iEfBNcspakgCbovx/wPTOXS0cfchw?=
 =?us-ascii?Q?7FfOCkWxPsHzmHmw01Z6ySrh8w3dk/uMtd083p3xI+z2C98nv9UnwRqJuwVI?=
 =?us-ascii?Q?yyXdC3f98jQm3hrvfedzwpu/E2D88wj72axgk26sn/W5IBKJRdCAyoCubSeg?=
 =?us-ascii?Q?Ix00350bYnPJ2K7eaIt6LGUY75U02hCzgqb3NwbUBf5Bh8ziwv5zbeCygJR0?=
 =?us-ascii?Q?7Kk+MhXLOB4IRYYiJfBXxSKdK3XikWqQsK5B703nI98KGU2ZpvA/morXVYn5?=
 =?us-ascii?Q?H0SPIT3OT42eFUswHH01jD3Tjmx2Efa+VS2FbXAnpj/UXZmyb582g+ZXyPtH?=
 =?us-ascii?Q?8GXUi9g3Q0epmeugt/C/exrWhJI3ZzrgvuJfAmweaqcTxj1i0jnvPsV2bk4Y?=
 =?us-ascii?Q?sVCETD9JvvftsE9q5hOY092DFdAIWrEc0HJPOFRRhN+9CYuOdRH8nRe9HlqK?=
 =?us-ascii?Q?qeT5KUWavkKnEJyiUxaUUUuhgE7PTbHIHzey8efrsEEMo0SOdnPxsN81sSHk?=
 =?us-ascii?Q?L3mG8oqRtfDLgfgpBwZYZrY5wG1pnNJbAJxkgqU4jiKhleU97IFkdYDWnmLP?=
 =?us-ascii?Q?VqS3W2sLpHk/Dnk4DP7NkO4S9iPLtx+1J0fpJGx/d8pUmjahgXNiGGOylhwb?=
 =?us-ascii?Q?8yahVP/bIzAIYvQnFF12cW71KX7PxgR43+xmRVuy994KTvxhZR6hOVtRMu25?=
 =?us-ascii?Q?roUX6PwbWr0a/eKf6Ax3A6rAioX+7VcwjCSbeF2UzaFoIh7ZeAL7IoO1DApS?=
 =?us-ascii?Q?YHF0KL7ZTtBeiHvOMGSjKe/b?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e926f2-b1d4-4f77-91a7-08d9076d32ac
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:23.4654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UxYURskn+wSJOKjJBBqDE9Tbp6Oc0pk6nPTa1bRiWNugAbeQLKTSrjRTyaYsEsbK+VU6NBcoa/xlJjKkmcLrbxKdeKCN09T9n8Og2Gdi7R8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: 7EMEbQcMK5yC0xU2tCXf93vr7yje9UY2
X-Proofpoint-GUID: 7EMEbQcMK5yC0xU2tCXf93vr7yje9UY2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes two bugs:

1. The scsi cmd task could be completed and the abort could timeout while
we are running qedi_tmf_work so we need to get a ref to the task.

2. If qedi_tmf_work's qedi_wait_for_cleanup_request call times out we will
also force the clean up of the qedi_work_map but
qedi_process_cmd_cleanup_resp could still be accessing the qedi_cmd for the
abort TMF. We can then race where qedi_process_cmd_cleanup_resp is still
accessing the mtask's qedi_cmd but libiscsi has escalated to session level
cleanup and is cleaning up the mtask while we are still accessing it.

To fix this issue we extend where we hold the tmf_work_lock and back_lock
so the qedi_process_cmd_cleanup_resp access is serialized with the cleanup
done in qedi_tmf_work and any completion handling for the iscsi_task.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 110 ++++++++++++++++++---------------
 drivers/scsi/qedi/qedi_iscsi.h |   1 +
 2 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index c12bb2dd5ff9..b53940af4230 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -729,7 +729,6 @@ static void qedi_process_nopin_local_cmpl(struct qedi_ctx *qedi,
 
 static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 					  struct iscsi_cqe_solicited *cqe,
-					  struct iscsi_task *task,
 					  struct iscsi_conn *conn)
 {
 	struct qedi_work_map *work, *work_tmp;
@@ -741,7 +740,7 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 	u32 iscsi_cid;
 	struct qedi_conn *qedi_conn;
 	struct qedi_cmd *dbg_cmd;
-	struct iscsi_task *mtask;
+	struct iscsi_task *mtask, *task;
 	struct iscsi_tm *tmf_hdr = NULL;
 
 	iscsi_cid = cqe->conn_id;
@@ -767,6 +766,7 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			}
 			found = 1;
 			mtask = qedi_cmd->task;
+			task = work->ctask;
 			tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 
 			list_del_init(&work->list);
@@ -774,52 +774,47 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			qedi_cmd->list_tmf_work = NULL;
 		}
 	}
-	spin_unlock_bh(&qedi_conn->tmf_work_lock);
-
-	if (found) {
-		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
-			  "TMF work, cqe->tid=0x%x, tmf flags=0x%x, cid=0x%x\n",
-			  proto_itt, tmf_hdr->flags, qedi_conn->iscsi_conn_id);
-
-		if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-		    ISCSI_TM_FUNC_ABORT_TASK) {
-			spin_lock_bh(&conn->session->back_lock);
 
-			protoitt = build_itt(get_itt(tmf_hdr->rtt),
-					     conn->session->age);
-			task = iscsi_itt_to_task(conn, protoitt);
-
-			spin_unlock_bh(&conn->session->back_lock);
+	if (!found) {
+		spin_unlock_bh(&qedi_conn->tmf_work_lock);
+		goto check_cleanup_reqs;
+	}
 
-			if (!task) {
-				QEDI_NOTICE(&qedi->dbg_ctx,
-					    "IO task completed, tmf rtt=0x%x, cid=0x%x\n",
-					    get_itt(tmf_hdr->rtt),
-					    qedi_conn->iscsi_conn_id);
-				return;
-			}
+	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
+		  "TMF work, cqe->tid=0x%x, tmf flags=0x%x, cid=0x%x\n",
+		  proto_itt, tmf_hdr->flags, qedi_conn->iscsi_conn_id);
+
+	spin_lock_bh(&conn->session->back_lock);
+	if (iscsi_task_is_completed(task)) {
+		QEDI_NOTICE(&qedi->dbg_ctx,
+			    "IO task completed, tmf rtt=0x%x, cid=0x%x\n",
+			   get_itt(tmf_hdr->rtt), qedi_conn->iscsi_conn_id);
+		goto unlock;
+	}
 
-			dbg_cmd = task->dd_data;
+	dbg_cmd = task->dd_data;
 
-			QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
-				  "Abort tmf rtt=0x%x, i/o itt=0x%x, i/o tid=0x%x, cid=0x%x\n",
-				  get_itt(tmf_hdr->rtt), get_itt(task->itt),
-				  dbg_cmd->task_id, qedi_conn->iscsi_conn_id);
+	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
+		  "Abort tmf rtt=0x%x, i/o itt=0x%x, i/o tid=0x%x, cid=0x%x\n",
+		  get_itt(tmf_hdr->rtt), get_itt(task->itt), dbg_cmd->task_id,
+		  qedi_conn->iscsi_conn_id);
 
-			if (qedi_cmd->state == CLEANUP_WAIT_FAILED)
-				qedi_cmd->state = CLEANUP_RECV;
+	spin_lock(&qedi_conn->list_lock);
+	if (likely(dbg_cmd->io_cmd_in_list)) {
+		dbg_cmd->io_cmd_in_list = false;
+		list_del_init(&dbg_cmd->io_cmd);
+		qedi_conn->active_cmd_count--;
+	}
+	spin_unlock(&qedi_conn->list_lock);
+	qedi_cmd->state = CLEANUP_RECV;
+unlock:
+	spin_unlock_bh(&conn->session->back_lock);
+	spin_unlock_bh(&qedi_conn->tmf_work_lock);
+	wake_up_interruptible(&qedi_conn->wait_queue);
+	return;
 
-			spin_lock(&qedi_conn->list_lock);
-			if (likely(dbg_cmd->io_cmd_in_list)) {
-				dbg_cmd->io_cmd_in_list = false;
-				list_del_init(&dbg_cmd->io_cmd);
-				qedi_conn->active_cmd_count--;
-			}
-			spin_unlock(&qedi_conn->list_lock);
-			qedi_cmd->state = CLEANUP_RECV;
-			wake_up_interruptible(&qedi_conn->wait_queue);
-		}
-	} else if (qedi_conn->cmd_cleanup_req > 0) {
+check_cleanup_reqs:
+	if (qedi_conn->cmd_cleanup_req > 0) {
 		spin_lock_bh(&conn->session->back_lock);
 		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
 		protoitt = build_itt(ptmp_itt, conn->session->age);
@@ -842,6 +837,7 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
 			  "Freeing tid=0x%x for cid=0x%x\n",
 			  cqe->itid, qedi_conn->iscsi_conn_id);
+		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
 
 	} else {
 		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
@@ -944,8 +940,7 @@ void qedi_fp_process_cqes(struct qedi_work *work)
 		goto exit_fp_process;
 	case ISCSI_CQE_TYPE_TASK_CLEANUP:
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM, "CleanUp CqE\n");
-		qedi_process_cmd_cleanup_resp(qedi, &cqe->cqe_solicited, task,
-					      conn);
+		qedi_process_cmd_cleanup_resp(qedi, &cqe->cqe_solicited, conn);
 		goto exit_fp_process;
 	default:
 		QEDI_ERR(&qedi->dbg_ctx, "Error cqe.\n");
@@ -1372,12 +1367,22 @@ static void qedi_tmf_work(struct work_struct *work)
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 
-	ctask = iscsi_itt_to_task(conn, tmf_hdr->rtt);
-	if (!ctask || !ctask->sc) {
+	spin_lock_bh(&conn->session->back_lock);
+	ctask = iscsi_itt_to_ctask(conn, tmf_hdr->rtt);
+	if (!ctask || iscsi_task_is_completed(ctask)) {
+		spin_unlock_bh(&conn->session->back_lock);
 		QEDI_ERR(&qedi->dbg_ctx, "Task already completed\n");
-		goto abort_ret;
+		goto clear_cleanup;
 	}
 
+	/*
+	 * libiscsi gets a ref before sending the abort, but if libiscsi times
+	 * it out then it could release it and the cmd could complete from
+	 * under us.
+	 */
+	__iscsi_get_task(ctask);
+	spin_unlock_bh(&conn->session->back_lock);
+
 	cmd = (struct qedi_cmd *)ctask->dd_data;
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 		  "Abort tmf rtt=0x%x, cmd itt=0x%x, cmd tid=0x%x, cid=0x%x\n",
@@ -1387,19 +1392,20 @@ static void qedi_tmf_work(struct work_struct *work)
 	if (qedi_do_not_recover) {
 		QEDI_ERR(&qedi->dbg_ctx, "DONT SEND CLEANUP/ABORT %d\n",
 			 qedi_do_not_recover);
-		goto abort_ret;
+		goto put_task;
 	}
 
 	list_work = kzalloc(sizeof(*list_work), GFP_ATOMIC);
 	if (!list_work) {
 		QEDI_ERR(&qedi->dbg_ctx, "Memory allocation failed\n");
-		goto abort_ret;
+		goto put_task;
 	}
 
 	qedi_cmd->type = TYPEIO;
 	list_work->qedi_cmd = qedi_cmd;
 	list_work->rtid = cmd->task_id;
 	list_work->state = QEDI_WORK_SCHEDULED;
+	list_work->ctask = ctask;
 	qedi_cmd->list_tmf_work = list_work;
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
@@ -1432,7 +1438,9 @@ static void qedi_tmf_work(struct work_struct *work)
 	qedi_cmd->task_id = tid;
 	qedi_send_iscsi_tmf(qedi_conn, qedi_cmd->task);
 
-abort_ret:
+put_task:
+	iscsi_put_task(ctask);
+clear_cleanup:
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 	return;
 
@@ -1453,6 +1461,8 @@ static void qedi_tmf_work(struct work_struct *work)
 	}
 	spin_unlock(&qedi_conn->list_lock);
 
+	iscsi_put_task(ctask);
+
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 }
 
diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscsi.h
index 39dc27c85e3c..68ef519f5480 100644
--- a/drivers/scsi/qedi/qedi_iscsi.h
+++ b/drivers/scsi/qedi/qedi_iscsi.h
@@ -212,6 +212,7 @@ struct qedi_cmd {
 struct qedi_work_map {
 	struct list_head list;
 	struct qedi_cmd *qedi_cmd;
+	struct iscsi_task *ctask;
 	int rtid;
 
 	int state;
-- 
2.25.1

