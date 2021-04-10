Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E636CC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB7AF60FED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhDJSlC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:41:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47586 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbhDJSlB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:41:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIVXQt061819;
        Sat, 10 Apr 2021 18:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=IfTfffQlU/V7fQY6H9Hl6sSPUi57WdNa1UE/7KZ1eZ0=;
 b=I6Bq7sD8zndRPI1e3neAcOCSEtPxSj+rJC8NtIVSPMhzraeR70eNG0LwliPzaIWGEtPA
 C46u1EryE2+ZclrvSZvem8RMy0+ngbSLctoAkA7cWJqehfWJubo74Znjyr408wRzodbd
 k3erv360gfr3FsbDde97d7guV5kUQwkV8Nl1bQLBWsolNIze1Z2TndYr0XY+O+38vFR5
 dhDjdgMJQwl0r8RXPlS6UBMDVsUTv/II1EyuY/YUGoTRlQ3UCkSd/fjkbSrQ2x9y8ZdT
 63vUVqI6cr0Wn0ElMhfB6Wf/fSsUyi3nXmru0UOMkauDcKqNr3cwTGfo9HOoiKcIOmF/ Wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3er8stn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIThiZ176766;
        Sat, 10 Apr 2021 18:40:33 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3020.oracle.com with ESMTP id 37u3u1q4dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7cmcfGAnF0B0b0QPINW0RL5iOG+Y+TCUDG0Cm38BvQj2oxFC3TkPPW448D+7OOSL1KFtSikidIRrjsaiw9xaa+JQ6RGSHyLEHdKIgrT7G6MAXQFnYH4naiQ4No+MQQW25w5R0oSZ65WRNUvmPhgwSUbxplykSBLuhd4CPY2gKOrxTIt6ytYI3lDaX+rfHPI2LtLo4DYxMyrElQZlP89NMDq00yFALSceUBea4TQnIClgCKJV/cy8KB96cH/fc+tmAJdrLTWaOqrmIktlKudowWAyL6jAt16Kse1HiXmbWg8xHv9wfldj3WkJYtnyhT4I49nuVKPfVLf0eFMzG9W0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfTfffQlU/V7fQY6H9Hl6sSPUi57WdNa1UE/7KZ1eZ0=;
 b=VeavsTsZVsTzKowBLSYXi8A7/wz5MhZz6Gl7ixWq3I/fvMFVccvPJ9VY5u/B0RCNSHew6yO+wqkH8UjrlyuMksjwBvRqSPC9qAMbo4BO+cTcuWLCO9CqudQoQLCah7GQTYhi7lCJZC2e9pgv7GPHyxRgqajthiWi63XYThk1njpJeRs196UozLBdSWqrnvPz+jZ64kaOpLOXrBvypVCHNQxTOOyq8055J4VKlygoAt7opmJUVJhFFIoQVy8r0jU12woy65b/FSsIQ35TI9ug3Squ+iEirlL9YDy07z/MLhk06G58fG9Cs/kBKjLpO1N1UEgKKAtAwpNy5nVd7Tjfuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfTfffQlU/V7fQY6H9Hl6sSPUi57WdNa1UE/7KZ1eZ0=;
 b=KRoTLEfYGj5A1mq4HraP+OyeIEuaNQuuulG9eOYYs0vNDeKOBejT5YF2gzJUWsAI21BAALOj1FDLJROp7J4kM8KLNddhJFO0Vjh/2AhlyI7Ph1RZrD/1OhLC60Z6l56wtzotHd8DHx8vXeRQOVCtxNadONxqNpnFihad2vSzuAI=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 18:40:31 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sat, 10 Apr 2021
 18:40:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 05/13] scsi: qedi: fix use after free during abort cleanup
Date:   Sat, 10 Apr 2021 13:40:08 -0500
Message-Id: <20210410184016.21603-6-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 18:40:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b472931a-011b-46a4-2a8d-08d8fc501e61
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4324D9775C32908156E47137F1729@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vRFnhBnxsgww0YO3ab7G7mvH31q5y92G9ZAg8zVPMBfwcD5bYkEL/a9OabqXa2UdkqxdNUfzrP88aDoYErwfIg88/1BcxJbot1YF5Y/za/A+7AiPAQUyMAqfK2+ZBBEtCXJV+ePr7RZU967QVRSxhg1FBnQMla8q9gY0lDiCnCjqG78iWG0JdA3sGZgkR+lypK0z3tjdi9XC3ts1Cm+1qZm8pEovDPq0zdH48cCX3hWzGAefdmnhIWS4lDTUcXRyCrJtLHdTy20rFN4b4ZX2aa2Z+YUVYHICK8CE3jkqlzw+K+c2G5TlK5VjBsDqmlSfOv43oqj3Gi605ScQqLi+teDplD4d/uc44/ukcTLP3HN34NJ4kVmTIovkrPOle8t1EgMKLHC7uB3gnG/2XxSNh+7OXgyExR3ohf9nsNAQkCcvsTf6AdRLdiuJH/lPr00B6lAhTT+epQCornV8BbGvFFRQE8VDu/xBbIEx7bMunn2fP3l7PA/oJyK87ExZTUrcFJ7VVAmz4aEmWqyBB4mMh+CLuAkyetPwF+PTWJHG/ZFi3d/esIF75O8jxI0e2+MC19eq1CS963xzzFlHlGuXh47AnYaDZu9TFY8DKNNjLIAOoJc3+vDjU6ZSKa7Tpg1RtdyKjOajEVyIcnmIniZENuoHUJUHQSMbZlexrDP2c6R0RJBjKaC7oNhSe6zusxoH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(66946007)(66556008)(66476007)(69590400012)(6486002)(83380400001)(2616005)(8676002)(8936002)(16526019)(186003)(956004)(38100700002)(38350700002)(316002)(6512007)(1076003)(478600001)(52116002)(107886003)(26005)(4326008)(6666004)(86362001)(6506007)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IohmCHUeRTwA2lQKD+HA6zoccd2wnBXewqWOVyUDU5/geHZg96RI4hKvTiiq?=
 =?us-ascii?Q?wose9aTgQj0pWwXsPcBEvXd3l/BYt7UsGE6zJwfygvtSjCbfvvi63NiPbhPA?=
 =?us-ascii?Q?L1ghnnBk/dXcQLH8Tg0wUU8CsjpoR0bdoTo8lIcl1h02/Szv+XBmhlpvQGl7?=
 =?us-ascii?Q?iLuKkqT0gQCNArIBfgU10KDPs0cCxNlr8tRO76Arfaon9ZBDlm4r6eNwXZ1y?=
 =?us-ascii?Q?w9GoSicUPIryF/roKOACsQHZFDvWOfignz89caoZFBCnsxEPix742YM5Ycye?=
 =?us-ascii?Q?s6OY1YOYKOOzatPRf/kGvHbUl2R2WK5V3OHHIZI1YLxEgc2MYZRwhFeHDBrZ?=
 =?us-ascii?Q?UtgDw2KdAhNRm+Qv8yI4e+MEmwBcLwyw0ViAo2N7CydAXmqukN9zgNucPV5T?=
 =?us-ascii?Q?dhrAZ1z49mc+oaFOLIylCTuSK70Fn7TMr/RX1IpebIDIjU0Kug35lPepAkNj?=
 =?us-ascii?Q?cqrox7v7osEbVN7+lJKvIB7pbIedP0D3haG+Gyx66iBAV5av5Vdg19dg/JFV?=
 =?us-ascii?Q?aHfeDafc9D+C352VC2qCqC2TpPyjUR4whfZrDtrwhljgJu5GBnwdzoNBUBZB?=
 =?us-ascii?Q?bYTTLX8S6SZKpeo2A1zYAyrRFNq7pAQ5KAwLacsQFL2RQnTZ1TFSyT4R38b6?=
 =?us-ascii?Q?m3HbVZ+kRqD+6IEgIjDQYZ9Nm/U9NqO5MPqyri67h3L9F6vXHwVKjMokBzyQ?=
 =?us-ascii?Q?L69qYp26g45FPGTPqUCF0uYNFsnzPoFJMsCIAL93E8QlVCAwCprpEFpMOYTP?=
 =?us-ascii?Q?MZALHS9K7xbOtsv8CqJoNgM0qKOAaHScHob+kGWCvwvXFYGnhnRxKlZxtm7P?=
 =?us-ascii?Q?o7KSbDeKAriiulXHu9rt2tlwoNAISanPfr1mpL6oDCZHQBkC3wu4QIdyPgJO?=
 =?us-ascii?Q?wmwuYuEyZUrmnAbYzllDGZm+zvyrWhjvjE0mHx7M65PTK8evRvV0+MShjiPl?=
 =?us-ascii?Q?xx0DaclWkeQnfSEOW5hgTToJ8x/Y/KkwlXsYRF0ie3nfjxyiJQfe2VO8dQx4?=
 =?us-ascii?Q?oSHueVyez8w3a3I59ZFnmlUdIRPCS2LbUB7NFi5GWatLTnmdyUFNEmwE5ApU?=
 =?us-ascii?Q?jj7Axxo7Mj3CnYCI3zYdhFXBgVGIW61TdHFZbYpLZcM5ROSG21hb5DD9tHZR?=
 =?us-ascii?Q?XLF/rRnl9kMbPfiZzuYv5S1l13HCb+O/poEFZUAq2QcpZTGQmYi29gecglt6?=
 =?us-ascii?Q?FNYm2rHBytWS26flVYlDJ3APHTjntmva5Wa1yObkW2hh0y9hGHpQaRGsUSwJ?=
 =?us-ascii?Q?5ABwePRCBz8MjFrEnopjIfarfzQXSMGwGALrjEcgfiPcPNj/2NJy1n/02c2C?=
 =?us-ascii?Q?Uu1OmtI2qtB7SOlpnbRPfwT/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b472931a-011b-46a4-2a8d-08d8fc501e61
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 18:40:31.2001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nx5JYZTkr3JXsEdb+DsRS/+uDdPgV8bQ+6EX/bUuHOfYQ1iwEo2CCrDLYf+MoafCteEIOz6ut+t/GplQMQ4eH4Zt99q5Ew8HrNq54ayMuXY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
X-Proofpoint-ORIG-GUID: IxPhgS05bxsktd_1ArdTUdUdYW_s88_O
X-Proofpoint-GUID: IxPhgS05bxsktd_1ArdTUdUdYW_s88_O
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes two bugs:

1. The scsi cmd task could be completed and the abort could timeout
while we are running qedi_tmf_work so we need to get a ref to the task.

2. If qedi_tmf_work's qedi_wait_for_cleanup_request call times out then
we will also force the clean up of the qedi_work_map but
qedi_process_cmd_cleanup_resp could still be accessing the qedi_cmd
for the abort tmf. We can then race where qedi_process_cmd_cleanup_resp is
still accessing the mtask's qedi_cmd but libiscsi has escalated to session
level cleanup and is cleaning up the mtask while we are still accessing it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 110 ++++++++++++++++++---------------
 drivers/scsi/qedi/qedi_iscsi.h |   1 +
 2 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index ad4357e4c15d..c5699421ec37 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -729,7 +729,6 @@ static void qedi_process_nopin_local_cmpl(struct qedi_ctx *qedi,
 
 static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 					  struct iscsi_cqe_solicited *cqe,
-					  struct iscsi_task *task,
 					  struct iscsi_conn *conn)
 {
 	struct qedi_work_map *work, *work_tmp;
@@ -742,7 +741,7 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 	u32 iscsi_cid;
 	struct qedi_conn *qedi_conn;
 	struct qedi_cmd *dbg_cmd;
-	struct iscsi_task *mtask;
+	struct iscsi_task *mtask, *task;
 	struct iscsi_tm *tmf_hdr = NULL;
 
 	iscsi_cid = cqe->conn_id;
@@ -768,6 +767,7 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			}
 			found = 1;
 			mtask = qedi_cmd->task;
+			task = work->ctask;
 			tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 			rtid = work->rtid;
 
@@ -776,52 +776,47 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
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
@@ -844,6 +839,7 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
 			  "Freeing tid=0x%x for cid=0x%x\n",
 			  cqe->itid, qedi_conn->iscsi_conn_id);
+		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
 
 	} else {
 		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
@@ -946,8 +942,7 @@ void qedi_fp_process_cqes(struct qedi_work *work)
 		goto exit_fp_process;
 	case ISCSI_CQE_TYPE_TASK_CLEANUP:
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM, "CleanUp CqE\n");
-		qedi_process_cmd_cleanup_resp(qedi, &cqe->cqe_solicited, task,
-					      conn);
+		qedi_process_cmd_cleanup_resp(qedi, &cqe->cqe_solicited, conn);
 		goto exit_fp_process;
 	default:
 		QEDI_ERR(&qedi->dbg_ctx, "Error cqe.\n");
@@ -1374,12 +1369,22 @@ static void qedi_tmf_work(struct work_struct *work)
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
@@ -1389,19 +1394,20 @@ static void qedi_tmf_work(struct work_struct *work)
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
@@ -1434,7 +1440,9 @@ static void qedi_tmf_work(struct work_struct *work)
 	qedi_cmd->task_id = tid;
 	qedi_send_iscsi_tmf(qedi_conn, qedi_cmd->task);
 
-abort_ret:
+put_task:
+	iscsi_put_task(ctask);
+clear_cleanup:
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 	return;
 
@@ -1455,6 +1463,8 @@ static void qedi_tmf_work(struct work_struct *work)
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

