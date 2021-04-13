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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D59AC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 753A761004
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348744AbhDMXHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:07:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49636 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348742AbhDMXHc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 19:07:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjFgu129870;
        Tue, 13 Apr 2021 23:07:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=OZncqnTwMEsV9VIuAksXb4AgpHpOr5IInC+8pBGc3zY=;
 b=OiAa6GSykNMRkHN8Mv4ElZXGvu1M0Xm+wx2IyAPv9QEpLDTo+sFoA507kquUHfd1j8I2
 9ktrzxd1ytjK2RDWY5VT2rlIfVTPTp1FWBqR/7S+7WDWKjFGfYyftpC5I1PbONy0xrIr
 vUE+xdArxGa2FNeK4Au/3LFifGueJlL5yN4VhdImkg2fqFHDOsvGMPU2Tfxn0BgsWCq+
 qh10tJ83ZnFHWkZaXYSUP0BMbzrEuq4QNbSzMagWJABHQ/UFHfe76Jl03AMNuzjYfu/d
 E+IQjCEPmFH6/z1EYJtNh24vN2L77QVzws1O0HYq9H3wg/v2+GgviBtzn2zW1PK+7SMS 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37u3ymgn94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjgav142820;
        Tue, 13 Apr 2021 23:07:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by aserp3020.oracle.com with ESMTP id 37unx0e1gr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NI2psDHP8CDFZWsAwoHyTwXhAm2Lfso1G+IHACVbFiVsOrGdFgpnMblxqsb5eUTBNswrj5AYA5rnChK16DpiLEnnpP3lGW1Rf6wH+Q4dPXVc5CVbWpMB36/05S/vPBxzXLHZQPzLCCUhRfvlVVt6Pbq0fKHVbumH9Q6KRkSpVQbHIXR8crXMxbEFoqvdSjgdaLCTeTGzvloNvCiw/ukggWfQQWyZdlAJwAoXcS7Uo/rTGcStQGqj1+6fMUJfoqnuXYdpdnngM0UYmw5XJ/8pi7iJRpu8a3b1sRhrGliPl/fhwsWQ/Wh58E3oBc/rTy3dOnY2MlSTDtAa1wUdK55ezg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZncqnTwMEsV9VIuAksXb4AgpHpOr5IInC+8pBGc3zY=;
 b=nlcISl84Gv2TV+121zXcIMFX7bUmNCUrjctjIQkasQU9JLBMHN2Kxdb+ipuCQcrwPQUw6AaQFyPSqDtyqD+4KsRdbnNBNocOIfBOlXkMIgtLK8LOpUeG+af1+2e9ilPFMH6WuwUsQX3iZZ9jsFqEKTxmvEBlIzXHUKAifboNzr0XrYsysxLrvi6hk/gbHSup0yOCgpQ9c8so43/cLs6SX1h99MCsU9XloSLsBltYA4Q2trxOAHfc89ai/Yb1IMTJ+C557eY/95OvlszBHNSm+Npfe5a7ZasVLff5VCqKSXXhPrYLWbWsJB09+YJo8NLZhWhgNnK5NtOK3lfxc/bf4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZncqnTwMEsV9VIuAksXb4AgpHpOr5IInC+8pBGc3zY=;
 b=TyTXwAflsfhfQjjKgV2nLY+HDgY7/Zs8VKSmcL4MePhSS4R8tA30AO6qKGb5dEVKlX7JJCFPa7xVIC4Uxmwyt3c5/OrqGlGPpuR4TOl87M2m7DtYc74uKVvYIOFuNNb7wGqpEuKqMPRh4DcmNr6o/XG3Wv1g49bhDYhPGUc5f/0=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2469.namprd10.prod.outlook.com (2603:10b6:a02:b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 23:07:03 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:07:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 06/13] scsi: qedi: fix use after free during abort cleanup
Date:   Tue, 13 Apr 2021 18:06:41 -0500
Message-Id: <20210413230648.5593-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413230648.5593-1-michael.christie@oracle.com>
References: <20210413230648.5593-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0212.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::7) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 23:07:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68a5eea1-1342-40c2-e28f-08d8fed0d987
X-MS-TrafficTypeDiagnostic: BYAPR10MB2469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB24698D1C880746BFE82E67C6F14F9@BYAPR10MB2469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sbhzmUJnSMpnRUw0wmtQ4IAGlIorWzrvdeuxrLMBKSLWLYX2g28wj3AAHSkrxJMv5WVoSHBLUZSiWB429BBzMRFEgFtr7mpQ6lGyDVgOur4vdcQYhUINowYEn2TKVq5rVIBmqKSr/VrOmeYgzfnnG762tbwcVl0obuUj3CZbchY522yy3xMl5HFeNphdzygZOhZDycjP3rexFWMKYIIPGMNtKIjx6pEXAC7djTLWIuWNDL69VOyWGG93DnIpCBoVgKgpl7ufqafKGwxPX1Z67yr7YYE1McTl7MdxnNmZkJT04nDXvXUAqk+VDfvv6hoWg9tHm+h9lStksFp7ztfECjT5P3kY75qYDXbaFhKBuhvEJcQB9W+I5eDWvpBcUXdTI0GkX+4g0GIN3nxRJqpsdw48gxUQN5GzyQkq2wOxL+6ru6E8Ea7hoYfn7B2f0g9AutYq31GES6dJOD6EPurr7pUlTdy/nR8ET69QQM0P7mlAU+Qq5v3PkgIgELxsay+PYjfOkmvqfcsyNEAudbszuh+9NjeNlLR5x56cDsR3SNOqsT6jnQmrab4GI91m+c1mxhVN4HiHy+VOB8RTaeEtMBfLYbmaQnRPZYQJ9M/rz+L5PDkbJkYIQMy8tARDmPGIT3K+0nhHNKNR2xw3R/o12IGMZgc63L0EqWGdtJ4+qRjg3+xNXxXtVquS/Nufq+No
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39860400002)(346002)(376002)(52116002)(6512007)(478600001)(16526019)(186003)(2616005)(8676002)(66476007)(956004)(69590400012)(4326008)(6506007)(66556008)(86362001)(8936002)(6486002)(83380400001)(107886003)(316002)(36756003)(38100700002)(6666004)(2906002)(66946007)(5660300002)(26005)(38350700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?M2lR9GT1WgXXDLJ71BY/hI7BbRgopuWU0PfkS4z+0b7vu97QayvHwOuFBamq?=
 =?us-ascii?Q?HU73Hvj/X1V8to6xy5+M8ccWlHsTCLZvFRizaUfYzyCudcuUFhPSayNfmJgX?=
 =?us-ascii?Q?3md8Wxbq956aGGa1YZdNt6gOfdvrSD53JxXAyiDF8KSxjyejyxs8sQbAiJGa?=
 =?us-ascii?Q?BtFZLUwkhKJeUAGm5mqmp33HA/DbzRzq2+s7GcNRxNS2zphZVG/4ICV2z2JW?=
 =?us-ascii?Q?4ZbfoXIHj1R+mQ9PyvXHTo96WYfW6OAIwteyEzNMIGYf81eLMmaPbSjFIoiH?=
 =?us-ascii?Q?zuKNXRNcqZFRBsxjpNvhheQMrmdnxgSbqpkrrhfq/3k/CgE/5FYRPaIxsQbP?=
 =?us-ascii?Q?UrWqBsi3C9zt6zYl1kdsPwdFe+dys6R4Bbxkmyz59hlZ082m28QHb54P4oG+?=
 =?us-ascii?Q?HoJc4hi3/I5ipYE6G/w1aTVjYSI3eOHe6JhnpeM/AgT9G4y7sYn7DlHGqARZ?=
 =?us-ascii?Q?0E98f3fXzGmEKTaUKSuKUKNb0YVDgtGJ/aR8uV7ACR6SfKCaLXenKG/782FQ?=
 =?us-ascii?Q?3jdYFEZJ7etilbIIFLTzybYUvImOniJxUrv5+9izLXUe32uVehWqyZkgbTyL?=
 =?us-ascii?Q?tRZgAUUjPYqOjXjc984EMOQ1jFkQ/Ol7dyNWX/0wnlEEeYynyTrEvNy4061y?=
 =?us-ascii?Q?QCg2YdIn9yHaIZHbHLzfbd6YQfCYUFrWn9QvtBFkDyGd+2teYNnsjlOHnWaw?=
 =?us-ascii?Q?+FdYo9vG4PtwLga91nFbqeyfiXcTg+hpWM77tstIOx1W8nwM/ZPA+M62Wc5c?=
 =?us-ascii?Q?IlTcOqtlK0r+aXt9MVPnujp/3J1XO51aRCU5gC80dnz/lik7iXIdRXpWHKkq?=
 =?us-ascii?Q?ffPI8n8XO7zE3h9nXDLmEhC7DyRyC7dXz3cx8tfGbfEciYrpa6byzLEkTrQX?=
 =?us-ascii?Q?xBW67CjMsQbDC6SU+W5Xdjp0Er3zUsiGP/hLts5SRJ0DgPUegZMS/RsW+JhM?=
 =?us-ascii?Q?Bq1K0I3qEXUC2vkvaAAnvge7VqeJh1Z3bxu3F/TBvtXVp+WnXXIMM8/W35v9?=
 =?us-ascii?Q?/HaVtk8HpgvkQxsZP70Vwolc2IMDA+kKWFCe0sBhSs+G1ostPRf8qoIOhcGh?=
 =?us-ascii?Q?LYL6dITEHHRBcUVI+7n533I8Q6f6yLdhhPdvTfY+hZOcXM2Vyltj4j2TSKvA?=
 =?us-ascii?Q?aR+hShdrE0EiKXv4LiH3Wr+U79xUEGWrKLcnDf50eamBAl5cz91wRqYJPGfg?=
 =?us-ascii?Q?fgXAH0MultI0UErYenM/naf+DmiOFt5Y4m9st4ROEvk+Y/zv4YpXK8qRf9PY?=
 =?us-ascii?Q?ZcY8nl27WAaWHjdz7mI1MinCNWj6hhDVslDhLxbiO7UQVH5XGRbTlS9TOjfj?=
 =?us-ascii?Q?qQUWehOcH+62mEgUoSy5hXyz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68a5eea1-1342-40c2-e28f-08d8fed0d987
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 23:07:03.0998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wN45jPgEZYOPmybSyKI0suYIi/OYXTw34pc8a8kPGD1PXFDTkSUsRcojnTPSMq2FJ5S/JYIrkbuaYXQT6rp6Z4CR7atupAC/DwJjSGEwXP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130148
X-Proofpoint-GUID: ht_jQyVmkrMkBt2-qgFCwnHIhcxpq8wr
X-Proofpoint-ORIG-GUID: ht_jQyVmkrMkBt2-qgFCwnHIhcxpq8wr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
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
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
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

