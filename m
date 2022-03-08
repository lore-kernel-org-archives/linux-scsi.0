Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90CFBC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244216AbiCHAl1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242501AbiCHAlR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:41:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6030C3DA78
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:40:22 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227LLAl6031932;
        Tue, 8 Mar 2022 00:40:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ehqCyzYLsxgcxEhuQVNRYODXoB2YR79PeZl9pdFm8ls=;
 b=lJh/+6SvypIX9zc7Oaoe0Cuwzb9TDu0rhAbGPcxZRmryGwuTuxRVkmXHObdsR8abLYc9
 1FIpJkPW5YXLPeFfKD6JIgCJIwv0L89AvD4uZIcMUW7I3meSGcYyuEK6fwWH0mSJHqt0
 mWDGz967BZQEIWo77CtLHSqsfO7Dz+knNPdrLzuw/V7YMYl8oczZZq/tBaTaGyHj6jhN
 1lpJANd/r9xsQD4AizXoNbg1vpZnhathHMkhOjvFj6DpREFsM54TGzbkfd+d09KizXfY
 2vnSni75EdzELnfZNsWm2Azo5hGb8BXehFts3GHWH2vfDrqvgeB4UFGV0oeA3mMLyN/g Lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyrancg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:40:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280alED119127;
        Tue, 8 Mar 2022 00:40:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3020.oracle.com with ESMTP id 3em1ajmyke-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:40:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyjrLml+6+fjKGDTljzqFhKPJV3WKwav5RJtP0NB4B5MVlBoBEZhVbBcopx6urNZzBum9icxv3r06/S9M8+IIz3WAkXrkJIEgssb6Y0SDVwCUi3izRpjDbiZlrOi6gSlRvMvaaFfQsUmiEqdweYep051GmCTkcLWVGCdpvs26RUn4VYq1rmSrpOm2w1oqFySirzns7yQnY67e7niYf/SchU7i+0J7vvLZXtBa5QL4nGzLjEUDklSxS/ogVfNs21QdzSYrQEdLvppcAA5QE0hiiWyssKVymtTDfCHZpOSa2EBGMw1gZsArQB5ezSLdWmPjtX9RNF0SYb3W93fPfILtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehqCyzYLsxgcxEhuQVNRYODXoB2YR79PeZl9pdFm8ls=;
 b=GS1vtFORje5aCMmrARFcXQzx4lEd13sjLSOZFc1C7fUm+tNc2K/YMV/eWE++elnEkgVXM4wMzvRmZrnzrbE3ypSM60745BZz5HfhU3a62oroMbBBl0hSpMS17ZPeWZW2hdXYo3J8s0s4oMM0lAQ+ZJxQLFKwx0YNsNgZZpWIrnSRfaKJ95sr9ldVke0W30MGP/QhA598SIpwNiu4K8m3AHWUxPaNSgrxeuBiDbqN26ZDyyQgpnUqyDEfsgPfsSrggpfAFoOKJT7e+ReQKL+9tdGK2rS1k97tuXGs+rKhYT51roj9uphgghujySNUmxUUkTR8EXGAXTEPkz1uxVN8nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehqCyzYLsxgcxEhuQVNRYODXoB2YR79PeZl9pdFm8ls=;
 b=CB9X7FGhEj0g6NhR6P7Cfx4vzhtv8SllK0y9YKXL5iDTHIcNvGE4h1ZnxGTyxWcxgEGVW31z1XyJaCvDI3b5plcuXWTG/OgCYflQTqZmoU6zEnCfAP7AERbNMHc8q1XTx+CHTovrBVClF2mZouVYMLRGCPFBUzUX/JdacxrqCNc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (10.168.103.135) by
 MN2PR10MB3680.namprd10.prod.outlook.com (20.179.98.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Tue, 8 Mar 2022 00:40:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:40:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, lduncan@suse.com, cleech@redhat.com,
        ming.lei@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC PATCH 3/4] scsi: iscsi: Support transmit from queuecommand
Date:   Mon,  7 Mar 2022 18:39:56 -0600
Message-Id: <20220308003957.123312-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308003957.123312-1-michael.christie@oracle.com>
References: <20220308003957.123312-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:5:40::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7c566f2-ac91-4f74-8333-08da009c3114
X-MS-TrafficTypeDiagnostic: MN2PR10MB3680:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB36808AC5642E965512EFF848F1099@MN2PR10MB3680.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6DXjeYgttfBV7kQEbKyNIB/S3cwYqZeElb/+hof0uKeFC8INKtRCB2Zgi1M/1z69edsGi0Wa2Qy0Kp557mdC9e9OHVPTd/E0e4evw5gkY0JsktZWVk4qJhJCyximKpsp5igkJwVu6sm8rG4JQbjtr+TjzpucxdlrM8S5Bs2AcpQdATaz6Nr4NZg5HreR9eJ4WzS7u8ryr9ao6YjMPtsJkiCtW5slgeodAZSymoYVYqUT8GxRG9imks99d2zhlkHrgvV8aI9Ckdzon3hIj9an4F4wRMM3RVNt7RSsOFQSzYizid09B1wNO4KlKT7pJtub4jQONgoMZ/vt5ALEVj2K/CDksH+oXDmHugf7NAcJ2qraJSAK5EZ8EbSMXrC5BviPsBpA0HxDchDc/htB3/52HsJQ1CVuMDEhZmc3I+MoWQwcRBYOp3c8SmfsRlKSK5Z5WV8/WDVVOnRogY/p+tOumCGq0XDXQ8nMsrigd2gbYOHRR+7kLJ/7Xw5/n+rdALPP6EZlC3xiSwdXPbfP5Wxd5mybpu1fl/59ZwVAl0rWcTyQ6pyRLsb9zy6WUTH8+QCymOL6OcmeKvZV9RyM/w6kDBosUPWnMB/3t+C7MZ61+pqCWPx5sYRIGzE7E8KQyCH9OH95CDQ9kRAuixfYs5KR5InSvmnWWvgpEReEwn8pF1YxYRXb1gyWYtN077QCXAPVPQUoLtRHAyO8irawPfwC5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(508600001)(6506007)(52116002)(86362001)(8936002)(66556008)(6666004)(8676002)(66946007)(6486002)(6512007)(107886003)(1076003)(2906002)(26005)(186003)(4326008)(66476007)(38100700002)(38350700002)(316002)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NiA7uF3SHO2G/JuyeKxMo4DSeclBD9EfsjjMjvnNpdOyr1BFoQqp2Rl4mtnf?=
 =?us-ascii?Q?dNnRGE17GTYzgsfsY+QY28DZXqT18dQhnEHCBGQr6cfRLqalx2wa4i54r1bs?=
 =?us-ascii?Q?YGU4yH8crwjb7WdxYVY+fxWPfsnFMGf3AywnnZpr0FquELO2/qjQGIFIZSk7?=
 =?us-ascii?Q?vYd9Iovm6Y1PIImc7KeTCIjSFtl/SuDlPMAdfJFCjTRcDQEFBkw4FZxLpwWj?=
 =?us-ascii?Q?IKfpLlBa30D1bRS9K7gGfFqNNAcD2/vSURbl6djSJajpj1v9Z6KwbsO58shx?=
 =?us-ascii?Q?XGSPP46F8M2x73Edmmu+QCXWrnYaI+xtC7om5jCdVxNABLzaScCrA3h77eak?=
 =?us-ascii?Q?YB9gTIjU0ZSoegC2dan0PtDMcYSSgu/nNuyBIrF4noXIctEuwQXhbQ0WloH8?=
 =?us-ascii?Q?HfWEaCoFvvFNU/HEtKrIaTeJN6JimAG2KHLrMame+gwHgJ25SXOSNi0eXBiu?=
 =?us-ascii?Q?gwi+/fDVEXhrgCA/Ac18Bi++OKX6sGYzDD81N6jALi69F1BAkB9MrA9lSowB?=
 =?us-ascii?Q?psLLXrLJpqy5T4+YjJ/KfdCoy1ml/zdFQr/rVTxIOZ+qYpG4na+srqH2288P?=
 =?us-ascii?Q?4vBjEdvGgTKRsm9xTixMSiwvgoV+T3MBObwoKkz4mhCohjBSyqBP/LENSecc?=
 =?us-ascii?Q?/XsADRb8mrTypHXMtVNXmROuksGMfUDPcVD1jFmumRGHqW2wLz16J44OSG9E?=
 =?us-ascii?Q?az42sZG2FIiLKXY+gy7KLih1E+K1RUzeok/N70S7V17YHen8GlwoKqDnM5M6?=
 =?us-ascii?Q?Pxx53zeUq29SUzpiuBolXMJhUnoc2LixdME7QuBngFRIHmaPSy4UL3lsXdgh?=
 =?us-ascii?Q?mVX/rB+IJbfFrK8XA+pi/MTQvLZQOxCM+y9HM5q/cmfp1P13K/rPq+vf/ddE?=
 =?us-ascii?Q?EIN+Wc3zp6281566Fh8LgU66Cpgn2xchziG51j4ADecVAXDhX9insboShwZl?=
 =?us-ascii?Q?wTQ7VzJkbj5ycxeFX5LwgXeGdZx33G7yiY3+8vd/8PePN39eQYBVDmfg2y7Y?=
 =?us-ascii?Q?+q4JT3ckEx6LYv96dBBumoUFoH/06C+bcqN/qXPVjtpPj0c2f7Y6mdBQreu7?=
 =?us-ascii?Q?lDNfZyt/N/nW/qsMqmzwQxMu1ZCCJ5zDIPPnVct3/74fXXlzs6xDjMSj/VHq?=
 =?us-ascii?Q?wW6mHIDEV+H41ijEA9mj/A0aw3pAAdsiGH/XOl8x6Lc7a10P1M1XkRZpip1K?=
 =?us-ascii?Q?pErxXeic5PR9LaDzl0M7nxb8MP/kvvRGAY/5OwcKX/xGC7cfzlS2VZnX7VHu?=
 =?us-ascii?Q?jPqMyfUMvX3c/BM8jEaIIvk948Llcuk39d3ajBiv8XvjwOTXrt6rs2VsvUkK?=
 =?us-ascii?Q?YO1/oN7276WcDqznm44pBumkicQ4RMEtCgPw1w0CD+wktshgCNl+GLz31ALw?=
 =?us-ascii?Q?Q6nbcZsuMKMaw5uRuP4+qpUNlG9jywMyIxAxdZWF66oazrhMujk0b6J2y85F?=
 =?us-ascii?Q?xIGV32w0+OVnJO2kCTgkNFYfdPR+FgEy9FLQBd2qOOi37wGq8IwsAk2ep7Hk?=
 =?us-ascii?Q?7AX0za4rSYFQuHsz0NOwiS7F9AJe6G/cWE82tSMDtWcPQPW1qjEpOLYXXbkk?=
 =?us-ascii?Q?CpUppVtrLyaeCsq7KdX31qukhf78lyGwYjQ53XGuuhZsY282B5yrfbuh67EK?=
 =?us-ascii?Q?GbMBQEwwTii9+cxqkwzV5PoY/p5u2qgNDpRcHicy0cnw8p0wQXZuE4IT6siA?=
 =?us-ascii?Q?LzfHiQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c566f2-ac91-4f74-8333-08da009c3114
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:40:06.5922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EzuVTGsSfLbkSVfswK2hjBxLgpxLYC8EpW8NKbjJNUOR6JAF4vqC4xDwylNB/VRfrn4wNTMZNA9hNPt4NuhgF+axVGeClMdlQJYjTZM7p14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3680
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080000
X-Proofpoint-GUID: 54nkahjeRx7YgM4ZI1r0kqKnaZAcoAfD
X-Proofpoint-ORIG-GUID: 54nkahjeRx7YgM4ZI1r0kqKnaZAcoAfD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch alllow drivers like iscsi_tcp to transmit the task from the
queuecommand. For the case where we were going to run from kblockd and the
app and iscsi share CPUs, we can skip the extra workqueue runs and it can
result in up to 30% increase in 4K IOPs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 52 +++++++++++++++++++++++++++++++++++------
 include/scsi/libiscsi.h | 11 +++++++--
 2 files changed, 54 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 63e0d97df50f..5a2953260a94 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1700,9 +1700,13 @@ static void iscsi_xmitworker(struct work_struct *work)
 	/*
 	 * serialize Xmit worker on a per-connection basis.
 	 */
+	mutex_lock(&conn->xmit_mutex);
+
 	do {
 		rc = iscsi_data_xmit(conn);
 	} while (rc >= 0 || rc == -EAGAIN);
+
+	mutex_unlock(&conn->xmit_mutex);
 }
 
 static inline struct iscsi_task *iscsi_alloc_task(struct iscsi_conn *conn,
@@ -1832,9 +1836,16 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto reject;
 	}
 
-	if (!ihost->workq) {
+	session->queued_cmdsn++;
+
+	if (!ihost->workq ||
+	    (ihost->xmit_from_qc && !conn->task &&
+	     list_empty(&conn->cmdqueue) && mutex_trylock(&conn->xmit_mutex))) {
 		reason = iscsi_prep_scsi_cmd_pdu(task);
 		if (reason) {
+			if (ihost->workq)
+				mutex_unlock(&conn->xmit_mutex);
+
 			if (reason == -ENOMEM ||  reason == -EACCES) {
 				reason = FAILURE_OOM;
 				goto prepd_reject;
@@ -1843,21 +1854,27 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 				goto prepd_fault;
 			}
 		}
-		if (session->tt->xmit_task(task, true)) {
-			session->cmdsn--;
-			reason = FAILURE_SESSION_NOT_READY;
-			goto prepd_reject;
+
+		if (!ihost->workq) {
+			if (session->tt->xmit_task(task, true)) {
+				session->cmdsn--;
+				reason = FAILURE_SESSION_NOT_READY;
+				goto prepd_reject;
+			}
+		} else {
+			iscsi_xmit_task(conn, task, false, true);
+			mutex_unlock(&conn->xmit_mutex);
 		}
 	} else {
 		list_add_tail(&task->running, &conn->cmdqueue);
 		iscsi_conn_queue_xmit(conn);
 	}
 
-	session->queued_cmdsn++;
 	spin_unlock_bh(&session->frwd_lock);
 	return 0;
 
 prepd_reject:
+	session->queued_cmdsn--;
 	spin_lock_bh(&session->back_lock);
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
@@ -1868,6 +1885,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 prepd_fault:
+	session->queued_cmdsn--;
 	spin_lock_bh(&session->back_lock);
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
@@ -2558,11 +2576,17 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 
 	iscsi_suspend_tx(conn);
 
+	/*
+	 * If this is called from a SG ioctl the host may not be fully stopped.
+	 * Take the xmit_mutex in case we are xmitting from iscsi_queuecommand.
+	 */
+	mutex_lock(&conn->xmit_mutex);
 	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
 	fail_scsi_tasks(conn, sc->device->lun, DID_ERROR);
 	session->tmf_state = TMF_INITIAL;
 	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&conn->xmit_mutex);
 
 	iscsi_start_tx(conn);
 	goto done;
@@ -2720,11 +2744,17 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 
 	iscsi_suspend_tx(conn);
 
+	/*
+	 * If this is called from a SG ioctl the host may not be fully stopped.
+	 * Take the xmit_mutex in case we are xmitting from iscsi_queuecommand.
+	 */
+	mutex_lock(&conn->xmit_mutex);
 	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
 	fail_scsi_tasks(conn, -1, DID_ERROR);
 	session->tmf_state = TMF_INITIAL;
 	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&conn->xmit_mutex);
 
 	iscsi_start_tx(conn);
 	goto done;
@@ -2909,6 +2939,8 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 			2, shost->host_no);
 		if (!ihost->workq)
 			goto free_host;
+	} else {
+		ihost->xmit_from_qc = true;
 	}
 
 	spin_lock_init(&ihost->lock);
@@ -3165,6 +3197,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	INIT_LIST_HEAD(&conn->cmdqueue);
 	INIT_LIST_HEAD(&conn->requeue);
 	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
+	mutex_init(&conn->xmit_mutex);
 
 	/* allocate login_task used for the login/text sequences */
 	spin_lock_bh(&session->frwd_lock);
@@ -3395,13 +3428,18 @@ void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	}
 
 	/*
-	 * flush queues.
+	 * When flushing the queues we don't wait for the block to complete
+	 * above because it can be expensive when there are lots of devices.
+	 * To make sure there is not an xmit from iscsi_queuecommand running
+	 * take the xmit_mutex.
 	 */
+	mutex_lock(&conn->xmit_mutex);
 	spin_lock_bh(&session->frwd_lock);
 	fail_scsi_tasks(conn, -1, DID_TRANSPORT_DISRUPTED);
 	fail_mgmt_tasks(session, conn);
 	memset(&session->tmhdr, 0, sizeof(session->tmhdr));
 	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&conn->xmit_mutex);
 	mutex_unlock(&session->eh_mutex);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_stop);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 412722f44747..1f2accf2bc1b 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -198,6 +198,12 @@ struct iscsi_conn {
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
+	/*
+	 * This must be held while calling the xmit_task callout if it can
+	 * called from the iscsi_q workqueue. It must be taken after the
+	 * eh_mutex if both mutex's are needed.
+	 */
+	struct mutex		xmit_mutex;
 	/* recv */
 	struct work_struct	recvwork;
 	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
@@ -267,8 +273,8 @@ struct iscsi_session {
 	struct iscsi_cls_session *cls_session;
 	/*
 	 * Syncs up the scsi eh thread with the iscsi eh thread when sending
-	 * task management functions. This must be taken before the session
-	 * and recv lock.
+	 * task management functions. This must be taken before the conn's
+	 * xmit_mutex.
 	 */
 	struct mutex		eh_mutex;
 	/* abort */
@@ -370,6 +376,7 @@ struct iscsi_host {
 	int			num_sessions;
 	int			state;
 
+	bool			xmit_from_qc;
 	struct workqueue_struct	*workq;
 };
 
-- 
2.25.1

