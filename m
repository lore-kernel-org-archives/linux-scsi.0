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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 279E7C47080
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08FFC6117A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhEWR75 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51990 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbhEWR7v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHtWKo172032;
        Sun, 23 May 2021 17:58:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=63ffftDQwm4Ley7+LtqScbrVzmXMfQyceUkjv+tJxZc=;
 b=eFZgBbWrUJ/Rzz5tzKrvvXYFybi0yZsCg9Am+XzWbUPz1BFA+D22qTVe9N9JFwqQnZtl
 jqdoR991KNmb6NYattAxrIvDdNxUR0CrGTSKMf2pyqQPMBwopP6YE1p4EsS1VrSBW8hp
 7RgwGknE0nTZ8wkvBwQmfrmM55K7LtTAt8Gl58m/cSbgyzW0K+ZQCo8su669XJwG/P11
 pp1x+IU8my/M7p3/43I+ynx2t3FjdfmfGe+CS2MJElQooQHVX8vSm3P/nk84K+DmvLbA
 GGRdjgxyybVN3fpKq8A5FupbVs/sNYjsPBCU4fyZ+1suvNMLyr32+RvMIBDw2ekYfd9t nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38q3q8ryy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHubDo161766;
        Sun, 23 May 2021 17:58:15 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3020.oracle.com with ESMTP id 38pss3qbsp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AiFsLZZayw8MQjZRqFV6eZnyFXukCHqBPX51ycdI9eAIfG1muvb5Xv5K30xAiQmkcovSAcGr/gfojaWlAD2vGawyq+6CsZHJ1aBTf/aqhGl4/J5Z8qySAQ25i9/NS0Ax1e9s9uRAK71cAAoS4gyeqLIgXHDMT/XFn2DCBRcbzu3gXl1kg2uDjEB5AxuE+G8xMvatiRVj31u6lMzlIWwuwycxPhx4C6R5S1lRdjD+UQky0sK4Il3yWyX49z5uQy221ZW2LSUWj/8bNolnuw02DZBh0YS8qAVLc5MJoBr6hrG3F7GNYUEvOObVQx+6u6rIli7v6qs+zpaOx/Rpe7oFGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63ffftDQwm4Ley7+LtqScbrVzmXMfQyceUkjv+tJxZc=;
 b=SM/PFzrBPO+4Kevtdb7MN/eI9phSB2/IybPZ7/pqRILszLfS7AvqU0hLf+QjI/3TacAutDDXsHWrCcEbWNkfZ56992H5cuqUpPJmRbEygyXE7mCfLJJ+Gld9h4/wtxE9BCKoV7sWcTAjycMeIMt5sKrX9taaCh/cF0VmWdPfOCJa3Vd/LSr/YmyJAQdUigLOsUMJS9xx83soGPT36G1heoHt2K9RjBrbbWWXVdzIC7uZClLTICpETQhh22dexS9YjeibBUo3ge0Bng9lab1TyOm5UupQ75ohPkNZpJ4yvZNjkTf0sBdoif5mfyhFN2+6euZFkbT4UMT9+E6tc3dWyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63ffftDQwm4Ley7+LtqScbrVzmXMfQyceUkjv+tJxZc=;
 b=zx7YSE63I67Q18KF4QHyOA3jxrEtDsR6l/+f4HVpxMz2ZN7WgwsNYijXnN94Z/E23gEKq10nXT0aAD4wkYsxYy+qbEn2Kp2+THU9oJwuTairahOxaIqHEeiOVyEHFMTefz9Z+m+gpTzbN5PR0BwLuPNss/4l761ZLqxI4anJkXU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3239.namprd10.prod.outlook.com (2603:10b6:a03:156::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sun, 23 May
 2021 17:58:12 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 21/28] scsi: qedi: Fix use after free during abort cleanup
Date:   Sun, 23 May 2021 12:57:32 -0500
Message-Id: <20210523175739.360324-22-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0c8f064-072f-412f-3a17-08d91e1454a2
X-MS-TrafficTypeDiagnostic: BYAPR10MB3239:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB32395E91B8EAD559F9BA9BAFF1279@BYAPR10MB3239.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rsWhKDLb78fiboV0im3nrN0AC1CTYQOpZTaSEecPCaTDYCgjLdPfB3l6iPbEJgND2BLB4msQr6V086y11YT5Hu1jmke7e4bEHdDV1O5f4YB103D4mdTt1/rjCWkqdJLXDNIixsObiukyXCiLZxLQJRSIWE02flC2rfkklN2oawkr9Pi5X6IIP7bcLjELJxNYteORDaJajGxlpmcBHAlB+h35lvnWosozjvnNWzmsl3vtfCb7DnxFWWu4Iuxk01yMk2j9/IZFw8uWvQFXbm2L4z7yIchEPUSVvjq0SeJq5llIx/L3aLlhct4/KYylKH+jzLKGpjaFKfDYui6qbKnFWwvLRydyysjg+Alo6qT8XtLgp2ogxxMCRF5cppjPafVbMHKIKuRynyorbLMG8k3P9RxVzxcAo12HpM88kG77QWU7iJA2U9cObNQXqbD7iua1GBkP0+htG/PR4fMoUoDYx7HWGKBON80P4qdUdIdjvkzvDwxmLiMHiL//u6IUOy89Rm1clyfS8vEQHQGI4mC0bh1NTj6OPxDDIDmOmnKCEHVWUBKk1F9O8zYmNp4E+lMiYr5t/3/yF48IafaU7q4w7xOKlDrOK8yNLBzLqapP0j+vT9H9woAeQVNmx/rWcVdG/+7sIy31zpLbWVUZKzFqtV3Uf1n1sbiqw0GiGyhWvRdnr+G5xX8VbdqzXfTMio9g
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(52116002)(26005)(86362001)(16526019)(6506007)(2906002)(66946007)(66476007)(186003)(478600001)(2616005)(66556008)(8676002)(6666004)(1076003)(38350700002)(38100700002)(83380400001)(36756003)(316002)(8936002)(6512007)(4326008)(956004)(5660300002)(107886003)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CB9IILeea9lzjh/63XP4vFVAV9jhmXY/6OWoOpV3TQwN2Mi/iIiLC9kkoRmt?=
 =?us-ascii?Q?f58/e8A7cVkzv+y/MVQ6FKSnbS5tdiaZI2hoMsRcvWuTPBgzYsIyYX/PXJAo?=
 =?us-ascii?Q?9gBx9P0lfoIIqsZTaxz/neohze4bYMekQNVrn3r408ud2jvmfipahmf+PS3C?=
 =?us-ascii?Q?IsqZnqq5EBY/ZvzeUEOEmJYc95jdt1CHI0bRnSJacncoOiAmXxjPkncfZfit?=
 =?us-ascii?Q?qv5quP2/F14Gc+o7WnKTap3UBUWhtCMpNTrMup/8iz5WeOXnqiPL1KYw/M+L?=
 =?us-ascii?Q?Q359SG2beW9ST50hJhfi6J0VHW9ePn9llX4XCJltiM94MiroHxs7Bgo6cmgC?=
 =?us-ascii?Q?sLaGehPm9j9e45AmLVQzDmLX+mn7qboUt1lyOY3xLELqH1feSyROaSx7qT1Q?=
 =?us-ascii?Q?PKB5Q4zzY5rQo0ND2AAXdIGnl1+zqK5feoY2/uHrZst5OMYpjVdGxWUhhuRs?=
 =?us-ascii?Q?j4Z/MnVBfM8uLeLzMYi12IByKoE4ZoX+ZlN4JXZmbiKXI02gS/1kR59X4kFE?=
 =?us-ascii?Q?4pNl7XeivDsvS/tBzv/5HE8XKa/GJab3ZdRLPlo135rG74Uhrw8yiAL0PbPw?=
 =?us-ascii?Q?3gDb/ETsdb5OnPK/G6McRVPgHELivm5+JoywBdMGLFqRA6jp7m+Mw2B8G/Lg?=
 =?us-ascii?Q?O5wVOEam2QW48GNUvc9VTj44KcH5sJK3cWZvk96KaqYwsfIGPzAHiuhKT+c4?=
 =?us-ascii?Q?lLXsUwGhBWUS2+UpQebLjWcivi/GrpZwFndyXZGrKnxMYKI4juH62tzV8dkg?=
 =?us-ascii?Q?TW+M06TDgj8eLJKrwzEXnYmo0ymyFpR2W3GUUuuLPzbwEPyCEGxjMFMVe73h?=
 =?us-ascii?Q?fVWWE+SpUx1ghhgWmKOlRFf/2xf2bDsErzt4+qZU+NP3+CMgdziWuKxEP/sA?=
 =?us-ascii?Q?I0X5gBTgHE+SFeCcnK2wCtdXtA+trx6DktkhFwR3yFKkN7vJJjKi26hUI8wO?=
 =?us-ascii?Q?FQ8z4hcDVUhndTKs3HZG6Y1+8XgSbrIVie1BGfxI1MsJ9JtvUDtMisY8E5G4?=
 =?us-ascii?Q?3aspxqSYMNbizdR7ZYipXa8Xg3cx4FbXPP+MMT5EGKOsN95u7fkCFtVcTu0x?=
 =?us-ascii?Q?n4nZt5dJZsx2Z1NZ4lxxL2YZUXXaWMpgaq3zZE5KyhRp20nMAp1HQdT66GC1?=
 =?us-ascii?Q?MhN3sABzgg0HPlPwu00BB3YeirUuTyChPJ0+eTaA47b6r3Aiw6fx2dYld1ax?=
 =?us-ascii?Q?DKENlBY70bKQOCewpiOJY3AHX3W7+IjkvC+D0D6rT2/Rug8kx9zfb0MJh87K?=
 =?us-ascii?Q?pvQMd+uDeRrezYRupbHhsYWNmLzXnNxtNwPHXjcfmXIg8Ikvrzh9VK0P+rBN?=
 =?us-ascii?Q?cibG6Ps9Aan6cjyQg1rMJ0eE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0c8f064-072f-412f-3a17-08d91e1454a2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:11.8992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G++TJLzdNt9rzrqJHbiuz04gQGouKedO6zOL47RJd1m3E0eyRje3t7NpuAGSYv0eSA3IeUAttpjH1cK6w92wOrcmbyb9Z24CXkK36AjDJiQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3239
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-GUID: 7ukMT04u5G2NFM-lHsV_TEJ0KSu7Uepe
X-Proofpoint-ORIG-GUID: 7ukMT04u5G2NFM-lHsV_TEJ0KSu7Uepe
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If qedi_tmf_work's qedi_wait_for_cleanup_request call times out we will
also force the clean up of the qedi_work_map but
qedi_process_cmd_cleanup_resp could still be accessing the qedi_cmd.

To fix this issue we extend where we hold the tmf_work_lock and back_lock
so the qedi_process_cmd_cleanup_resp access is serialized with the cleanup
done in qedi_tmf_work and any completion handling for the iscsi_task.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 113 ++++++++++++++++++---------------
 drivers/scsi/qedi/qedi_iscsi.h |   1 +
 2 files changed, 63 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index c12bb2dd5ff9..61c1ebb3004c 100644
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
-
-			protoitt = build_itt(get_itt(tmf_hdr->rtt),
-					     conn->session->age);
-			task = iscsi_itt_to_task(conn, protoitt);
 
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
@@ -1372,11 +1367,25 @@ static void qedi_tmf_work(struct work_struct *work)
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 
-	ctask = iscsi_itt_to_task(conn, tmf_hdr->rtt);
-	if (!ctask || !ctask->sc) {
-		QEDI_ERR(&qedi->dbg_ctx, "Task already completed\n");
-		goto abort_ret;
+	spin_lock_bh(&conn->session->back_lock);
+	ctask = iscsi_itt_to_ctask(conn, tmf_hdr->rtt);
+	if (!ctask) {
+		spin_unlock_bh(&conn->session->back_lock);
+		QEDI_ERR(&qedi->dbg_ctx, "Invalid RTT. Letting abort timeout.\n");
+		goto clear_cleanup;
+	}
+
+	if (iscsi_task_is_completed(ctask)) {
+		spin_unlock_bh(&conn->session->back_lock);
+		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+			  "Task already completed\n");
+		/*
+		 * We have to still send the TMF because libiscsi needs the
+		 * response to avoid a timeout.
+		 */
+		goto send_tmf;
 	}
+	spin_unlock_bh(&conn->session->back_lock);
 
 	cmd = (struct qedi_cmd *)ctask->dd_data;
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
@@ -1387,19 +1396,20 @@ static void qedi_tmf_work(struct work_struct *work)
 	if (qedi_do_not_recover) {
 		QEDI_ERR(&qedi->dbg_ctx, "DONT SEND CLEANUP/ABORT %d\n",
 			 qedi_do_not_recover);
-		goto abort_ret;
+		goto clear_cleanup;
 	}
 
 	list_work = kzalloc(sizeof(*list_work), GFP_ATOMIC);
 	if (!list_work) {
 		QEDI_ERR(&qedi->dbg_ctx, "Memory allocation failed\n");
-		goto abort_ret;
+		goto clear_cleanup;
 	}
 
 	qedi_cmd->type = TYPEIO;
 	list_work->qedi_cmd = qedi_cmd;
 	list_work->rtid = cmd->task_id;
 	list_work->state = QEDI_WORK_SCHEDULED;
+	list_work->ctask = ctask;
 	qedi_cmd->list_tmf_work = list_work;
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
@@ -1422,6 +1432,7 @@ static void qedi_tmf_work(struct work_struct *work)
 		goto ldel_exit;
 	}
 
+send_tmf:
 	tid = qedi_get_task_idx(qedi);
 	if (tid == -1) {
 		QEDI_ERR(&qedi->dbg_ctx, "Invalid tid, cid=0x%x\n",
@@ -1432,7 +1443,7 @@ static void qedi_tmf_work(struct work_struct *work)
 	qedi_cmd->task_id = tid;
 	qedi_send_iscsi_tmf(qedi_conn, qedi_cmd->task);
 
-abort_ret:
+clear_cleanup:
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 	return;
 
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

