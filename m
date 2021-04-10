Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF402C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 990F860FED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbhDJSlH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:41:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41986 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbhDJSlE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:41:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIY0TA007849;
        Sat, 10 Apr 2021 18:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=qGYOd4dDWIfBfGK7m5i1lx1pmsIPaW+4NzfN408mE0A=;
 b=GOUX6ajXVCug5Sryh3Az5tIQD5FAj69wyT/dPlw64NuM5KtCFaT26fWIS2s/UAn0K3Fr
 Ui1mWs2KBOSWG96u2khwvZlb/QvAVPIh8Ckf16Q75QPL75yh88xXxlie6xwFt1wCgybT
 H5Xws8bF3djrEi1kwP51in5XumI3W3pSRpwtlz3hRe+07JLJLNf/Nl1aKe69Qp3AefHk
 5yzfPCXeu6ZZSnj1vPTfG66cLDwFLAG7XQTIhiU7H6hIQs7dMJK9zHjgZH52MFWTR7lk
 eAMwyRgS9tfqncIiX0kM0ohnLW4WwNQqGXu/F1rqoakNgSfTrmxEBU0zyur0wj/7VlmF OA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nn8r85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIThia176766;
        Sat, 10 Apr 2021 18:40:33 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3020.oracle.com with ESMTP id 37u3u1q4dr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOEn9kQ//AhmavZTZfBmoao166kgvqnR7QOYxmD1WykinpjGzdeqL3Twf/aGtPZIiHflQ1JNN10yoK+jHhbafVBfa/2ScBosWY4gmJhnETg1xM/9Am0giqh+3SXqwqUhAGjfxw2Ym72HcBVy+vnRNFvjdXCJ1bSGWc4VCgFx5PqWJxdZ5Z4BkBMj3vohGEKehUWIm5DFwKa5IlTCH3RZwm2mSXAH/3+MI6pUYkM/P5Rjiwc2BpOTsZ+kf0US7TX6Uby6yE1PMsL0wSq+U92lRk15ZJyenGtmwYu9r/Bl+PZ9jWuHpEI7MEz9/Lc9g8GsppxZnfm0Qv+6iRoVrvzMSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGYOd4dDWIfBfGK7m5i1lx1pmsIPaW+4NzfN408mE0A=;
 b=Rln2VQR4pG4qAF5+EoLO+Nom+15PS8KddtOK9liYThfVAriRR7QwV7CPb3rFjIoxs3WH403dmANmURWBPeKh30emGAdwkXEyPn/krr3pNj9lbdjHmFFJI/8KPUpQ9a3vxn7/y0VuIIADjdgJZkAwUltlQC6OTtu4nY/XRz/RSEkb8rfnCxEbk3CReMiw/yEeR5FMeYx8+oOQGtQSJdOshC08oSHK5BhzUQd+0fo9g97j+IMjFyRZ/alqXoqHaBANnqYbEpamx+wfQh3Xv2/Pmb9zRcliWz90VWHlQaXlure6HnabwvFB6jHAqg/8xjSXTBY4bgmJg/6L3a1S9z5JgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGYOd4dDWIfBfGK7m5i1lx1pmsIPaW+4NzfN408mE0A=;
 b=lzUvpVCoIYvALUgOzn09ZQjNP3sz3PnFPem9D13eh3F2NpbxN/cRwgSqhD+s0TSznEr23yyXgBH0/96uM8SJhQfiX0mt4PVX2bb3nSFRQ3d0WACaCFJ4qM/SVv6jVeeIQFPMYmhAw3+O+b0z8cg8yN9eh2eif5cVQoxr1KxxUbA=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 18:40:32 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sat, 10 Apr 2021
 18:40:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 06/13] scsi: qedi: fix tmf tid allocation
Date:   Sat, 10 Apr 2021 13:40:09 -0500
Message-Id: <20210410184016.21603-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210410184016.21603-1-michael.christie@oracle.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR15CA0036.namprd15.prod.outlook.com
 (2603:10b6:4:4b::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 18:40:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 466ab399-18de-4fdd-2d96-08d8fc501ef4
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB43241B955483553D22E4F448F1729@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YlaND1PeWSlXB52xlbh5HpHxKJurT6EVM56PfynI9p68ZuZP7zwbvaff6LA+dWEBqWJahkuU8xkhtsMKvd6effn7Y+hk884ie85zZYC8lehT78Rl5FaZWJMaiOSf5IuOYF3g4dkmnwrKUlmg6EvtV0csRTJiQfnBVwk9wF8zq93DlZH51ZqKjXD/5yM+GYKIx9uHqdO+cny7tS2+i2umTldYXWVWZ+laCt329UYQdVU2/wZ5xe4XiAgYOl9MtlnAuokR6yiGyi8N91h5Dxls+UxduJk/ra718SO/yT1XaXRj3SrzojNDFwoHLj72pBZo+BomqXlPMJCo1ld2VzS0lOzQfSWzuYXbnfttBo4b/7VAidaYBMrlm05wSF7dgmVwT+PIvAZvmuwbjZpljkzySWlaMBoTyq/dyb81/mnQq2iqMfjp1HYimxejNXf8YJkgqAYHv41y9AK4bA5BisWIMkVgDV3go7oKSWmmCvdLSdtr9OxUkVqQfyEuRLbQlC2RuO2uYPfBUPaUTyGLWhATpHvHU/dbHAV2iVIgBwIJ52N5ch5/sR4CLtkZmou0rtmX5BJE1+fxWzKjV/JBsGPSQ0iiHrax02skzKUDkK9NZwRyxten/01OsL2qUokvdgVLeZRZpVO/mCT18PoYXSFNLeNZ/o4TW3FFsb/XnrHVyXLXH4D/ODcBtreAHZeWi4Bl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(66946007)(66556008)(66476007)(69590400012)(6486002)(83380400001)(2616005)(8676002)(8936002)(16526019)(186003)(956004)(38100700002)(38350700002)(316002)(6512007)(1076003)(478600001)(52116002)(107886003)(26005)(4326008)(6666004)(86362001)(6506007)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rBamCyle9wbcZuHdVu2NFenElgzYuckxTMIzeXOhCmlobHB7Hl1dvrdsNNPH?=
 =?us-ascii?Q?r4MHkldHUhi0phcnTWzEnfXOy5hgEWSN7O0iLirij74Rznt7K2C2e6wFb99B?=
 =?us-ascii?Q?NhNgNoVqVeqPyBQhPRLBC0fmfUIHN8r2NCOKOB5ZB2Qg8+2BXHmY9jgzdCN9?=
 =?us-ascii?Q?QZI4WeABp8UYxv4YPHDVaQM7ZfcqUlLKDkYrBYzCScWhs2gEJc8fUo4cgO7w?=
 =?us-ascii?Q?dPWem3ttez9mz0c+AANfkE6eInChI6lnzBAowByCigHEzDOCcsifMZZ5wjo4?=
 =?us-ascii?Q?Are+h58CleHcpUCUkvpWnpDKKU9URyf5OQpJrQGedEU0wjwnO4rjWRyJLOJr?=
 =?us-ascii?Q?xjis4QCZRfKzfIAVx4FIU8K9RMaQul2BkxIEq7EbRuJR+Np6P7ZaVo3xG8DA?=
 =?us-ascii?Q?A7Laj0DC3bnV6weEvgXNJlmSCaUj/9cZ5NeA+YUp9rjYKeCS57wNMOaL+ddT?=
 =?us-ascii?Q?yu0Fyh+ZMH+lj2nxp/nle9trxjeb06wk76hOPQ5bMU2HYfgmS/rgDN1tFERj?=
 =?us-ascii?Q?ipCMYpiIR1p+RGsovVjCbUr/jWm64jbyx1sWdlqaUPf29aSKrYQNIJS6oFLn?=
 =?us-ascii?Q?Mb1VULN+LqQVxYO2upjN3EhXuqxWb7dcwnySFnaJUnYm8aweqKGBIkRbZbhW?=
 =?us-ascii?Q?Cy7miWbI4/gtQGfOSY94T4bYFRs4WcN2mR/oEwoZPezFL2KgdQZQYa/7il8Y?=
 =?us-ascii?Q?C1M5WGMee7mbyjAcgu+Ot8y+ZeIHzB/MJAUJ8+XQrf81tquW2gicdvzipC6u?=
 =?us-ascii?Q?0RCk7JOw3Tu3TAbrf1D6yL9Z0duygOKTFid2bVKAzsNND6kLyM3tLzAkb3NX?=
 =?us-ascii?Q?Y4yGHL9yuc+bVo2aoBYSp1E3FWKo+XEvj1FE544C3MOz/wIB0T/JhFL7Gkn2?=
 =?us-ascii?Q?fIBrN0mvTCZZPwO5pM52GeaFbQay8tp8gSfiF+rjy96MbdvY+VjXrn/nI3Bm?=
 =?us-ascii?Q?WTllyJGJ81/Ufu08/xChn/xG361g+MWv8P/JF6uHC1jD2OLZVO9PHqNzE1HZ?=
 =?us-ascii?Q?2RLSrexYsb4zY3DIP1Wwgdxt6GBVQEWr0EhQDPTDBQaBM10QeFziLn29k8lW?=
 =?us-ascii?Q?j7snYzTaKQyvUn3YdpwRBB0ZhP+N0SPyLaqGhgFtzfNwvTqKT6zSa7GXEaT+?=
 =?us-ascii?Q?nK6q+qoaJsDwAVvARpFbjhFEPtpf0CjMLmB4TPyk5bss+GiA90R0THvDm5Nk?=
 =?us-ascii?Q?vZYIDv0kS0GLY+ZVLxJHqi2rqqYCXocEU139+ouWXEgS3Sdt0u3EXkxnnxUa?=
 =?us-ascii?Q?8z7CZ8XhMxDow9kqYaW5ww+MZ5biLuvt6RYHmJM7BUPYI+2VDkNgN7kDpMDx?=
 =?us-ascii?Q?3Wd11vFnoc3RTm88rShXysbA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 466ab399-18de-4fdd-2d96-08d8fc501ef4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 18:40:32.1716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9LVRK4RVhVYTDTgjkvVBVcg734cl9UZEqgK3x8zubRGyoiTUAieFfitiChgoGafh9dptBi8a36cZrqufpBdO7wGZXV9TyI5caawOlswXaZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
X-Proofpoint-ORIG-GUID: 2kTWpnsd4INXBzftpnHUNK_oYVWLrLkt
X-Proofpoint-GUID: 2kTWpnsd4INXBzftpnHUNK_oYVWLrLkt
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104100140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qedi_iscsi_abort_work and qedi_tmf_work allocates a tid then calls
qedi_send_iscsi_tmf which also allcoates a tid. This removes the tid
allocation from the callers.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 76 ++++++++++------------------------
 drivers/scsi/qedi/qedi_gbl.h   |  3 +-
 drivers/scsi/qedi/qedi_iscsi.c |  2 +-
 3 files changed, 25 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index c5699421ec37..542255c94d96 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -14,8 +14,8 @@
 #include "qedi_fw_iscsi.h"
 #include "qedi_fw_scsi.h"
 
-static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
-			       struct iscsi_task *mtask);
+static int send_iscsi_tmf(struct qedi_conn *qedi_conn,
+			  struct iscsi_task *mtask);
 
 void qedi_iscsi_unmap_sg_list(struct qedi_cmd *cmd)
 {
@@ -1350,7 +1350,7 @@ static int qedi_wait_for_cleanup_request(struct qedi_ctx *qedi,
 	return 0;
 }
 
-static void qedi_tmf_work(struct work_struct *work)
+static void qedi_abort_work(struct work_struct *work)
 {
 	struct qedi_cmd *qedi_cmd =
 		container_of(work, struct qedi_cmd, tmf_work);
@@ -1363,7 +1363,6 @@ static void qedi_tmf_work(struct work_struct *work)
 	struct iscsi_task *ctask;
 	struct iscsi_tm *tmf_hdr;
 	s16 rval = 0;
-	s16 tid = 0;
 
 	mtask = qedi_cmd->task;
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
@@ -1404,6 +1403,7 @@ static void qedi_tmf_work(struct work_struct *work)
 	}
 
 	qedi_cmd->type = TYPEIO;
+	qedi_cmd->state = CLEANUP_WAIT;
 	list_work->qedi_cmd = qedi_cmd;
 	list_work->rtid = cmd->task_id;
 	list_work->state = QEDI_WORK_SCHEDULED;
@@ -1430,15 +1430,7 @@ static void qedi_tmf_work(struct work_struct *work)
 		goto ldel_exit;
 	}
 
-	tid = qedi_get_task_idx(qedi);
-	if (tid == -1) {
-		QEDI_ERR(&qedi->dbg_ctx, "Invalid tid, cid=0x%x\n",
-			 qedi_conn->iscsi_conn_id);
-		goto ldel_exit;
-	}
-
-	qedi_cmd->task_id = tid;
-	qedi_send_iscsi_tmf(qedi_conn, qedi_cmd->task);
+	send_iscsi_tmf(qedi_conn, qedi_cmd->task);
 
 put_task:
 	iscsi_put_task(ctask);
@@ -1468,8 +1460,7 @@ static void qedi_tmf_work(struct work_struct *work)
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 }
 
-static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
-			       struct iscsi_task *mtask)
+static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 {
 	struct iscsi_tmf_request_hdr tmf_pdu_header;
 	struct iscsi_task_params task_params;
@@ -1484,7 +1475,6 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	u32 scsi_lun[2];
 	s16 tid = 0;
 	u16 sq_idx = 0;
-	int rval = 0;
 
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 	qedi_cmd = (struct qedi_cmd *)mtask->dd_data;
@@ -1548,10 +1538,7 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	task_params.sqe = &ep->sq[sq_idx];
 
 	memset(task_params.sqe, 0, sizeof(struct iscsi_wqe));
-	rval = init_initiator_tmf_request_task(&task_params,
-					       &tmf_pdu_header);
-	if (rval)
-		return -1;
+	init_initiator_tmf_request_task(&task_params, &tmf_pdu_header);
 
 	spin_lock(&qedi_conn->list_lock);
 	list_add_tail(&qedi_cmd->io_cmd, &qedi_conn->active_cmd_list);
@@ -1563,47 +1550,30 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	return 0;
 }
 
-int qedi_iscsi_abort_work(struct qedi_conn *qedi_conn,
-			  struct iscsi_task *mtask)
+int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 {
+	struct iscsi_tm *tmf_hdr = (struct iscsi_tm *)mtask->hdr;
+	struct qedi_cmd *qedi_cmd = mtask->dd_data;
 	struct qedi_ctx *qedi = qedi_conn->qedi;
-	struct iscsi_tm *tmf_hdr;
-	struct qedi_cmd *qedi_cmd = (struct qedi_cmd *)mtask->dd_data;
-	s16 tid = 0;
+	int rc = 0;
 
-	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
-	qedi_cmd->task = mtask;
-
-	/* If abort task then schedule the work and return */
-	if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-	    ISCSI_TM_FUNC_ABORT_TASK) {
-		qedi_cmd->state = CLEANUP_WAIT;
-		INIT_WORK(&qedi_cmd->tmf_work, qedi_tmf_work);
+	switch (tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
+	case ISCSI_TM_FUNC_ABORT_TASK:
+		INIT_WORK(&qedi_cmd->tmf_work, qedi_abort_work);
 		queue_work(qedi->tmf_thread, &qedi_cmd->tmf_work);
-
-	} else if (((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-		    ISCSI_TM_FUNC_LOGICAL_UNIT_RESET) ||
-		   ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-		    ISCSI_TM_FUNC_TARGET_WARM_RESET) ||
-		   ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-		    ISCSI_TM_FUNC_TARGET_COLD_RESET)) {
-		tid = qedi_get_task_idx(qedi);
-		if (tid == -1) {
-			QEDI_ERR(&qedi->dbg_ctx, "Invalid tid, cid=0x%x\n",
-				 qedi_conn->iscsi_conn_id);
-			return -1;
-		}
-		qedi_cmd->task_id = tid;
-
-		qedi_send_iscsi_tmf(qedi_conn, qedi_cmd->task);
-
-	} else {
+		break;
+	case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
+	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
+	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
+		rc = send_iscsi_tmf(qedi_conn, mtask);
+		break;
+	default:
 		QEDI_ERR(&qedi->dbg_ctx, "Invalid tmf, cid=0x%x\n",
 			 qedi_conn->iscsi_conn_id);
-		return -1;
+		return -EINVAL;
 	}
 
-	return 0;
+	return rc;
 }
 
 int qedi_send_iscsi_text(struct qedi_conn *qedi_conn,
diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index 116645c08c71..fb44a282613e 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -31,8 +31,7 @@ int qedi_send_iscsi_login(struct qedi_conn *qedi_conn,
 			  struct iscsi_task *task);
 int qedi_send_iscsi_logout(struct qedi_conn *qedi_conn,
 			   struct iscsi_task *task);
-int qedi_iscsi_abort_work(struct qedi_conn *qedi_conn,
-			  struct iscsi_task *mtask);
+int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask);
 int qedi_send_iscsi_text(struct qedi_conn *qedi_conn,
 			 struct iscsi_task *task);
 int qedi_send_iscsi_nopout(struct qedi_conn *qedi_conn,
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index d1da34a938da..821225f9beb0 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -742,7 +742,7 @@ static int qedi_iscsi_send_generic_request(struct iscsi_task *task)
 		rc = qedi_send_iscsi_logout(qedi_conn, task);
 		break;
 	case ISCSI_OP_SCSI_TMFUNC:
-		rc = qedi_iscsi_abort_work(qedi_conn, task);
+		rc = qedi_send_iscsi_tmf(qedi_conn, task);
 		break;
 	case ISCSI_OP_TEXT:
 		rc = qedi_send_iscsi_text(qedi_conn, task);
-- 
2.25.1

