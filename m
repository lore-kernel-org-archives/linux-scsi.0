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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A219BC2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81F2461408
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhEYSUj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47160 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbhEYSUf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFHq6053074;
        Tue, 25 May 2021 18:18:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=63ffftDQwm4Ley7+LtqScbrVzmXMfQyceUkjv+tJxZc=;
 b=a0Pf+PtMpzq7UEc0ByMjy8yfvf4uZtqHqHnmiW/+cn1BVSN1fkmR0uQZCnIzL0oeySua
 cg5zWj0dGavyCmm80ojGzVsYfgkX2Mze1lHZfmkXwLecJW92gFJ9rh3yKsW/KSrUHT9I
 TD1Et1q5MChKZT8G74cXVkIfQvxb+bRFgppB/JkTqjqsLSBxlBUfUyB6+Qg7uq8M4YKH
 zNk3GSK6hu7UiFablP7yF+K3GePG2ItkZVFhVeFakr/44DdCg0kYwpBNBbUqwnewZZVx
 NgCDRsnHe/2Xc4A2qrXztjn/YEZp3vA2nAOQKggphzcsfcwNv1Zsu8JvWfH8yt8tmaqm aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38rne42gux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEulk166263;
        Tue, 25 May 2021 18:18:57 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3020.oracle.com with ESMTP id 38rehaq64q-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rj2keGzHIfzSCuZnS3ap62K0jRn7d9F3N3cYmdbCSmnSnMOphayMoDfr5QbWZ+a/iwwjHtyLdX5pJ48LsD9gNN6BniHogi321v40UZogWD4qxvbcqq4fHpOBmfkEVayhQqCkFDYQ5+yF2XNTe4VaIShSMun7v2Thx1O27JQekmVrXm75ll2R+wBf2kVMZLLTfUoGdQcIp7B8O42skUP49dP5n/1ZYwgrdjrxvz/oYExj4h44lSs1fsOulDiyeurVm0YyKNmQ8lTwvE0f15w1tqlFroYY5clyOL9vECFC1WjVNHCnwn2R6SlLaxJY4BJTCMYCAAJClLsIr/k03sS7+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63ffftDQwm4Ley7+LtqScbrVzmXMfQyceUkjv+tJxZc=;
 b=OAFFkama+/tf8uh/V7H6egR+BNLlWOt1IunHrArQApor+Ap4tGjcYncoEP5EjhXiYN3OdW4dV7XCmzIbGXW/bQTmSt6zrQiO1iA5Q/lCreDVbfD7sAF1gUlHzL5FboHq9bVTDSWX2ZxSO/pygz42QlCT/owebUqsfNXbOQYWnGwhXlG8EpIxHagqz5E8VfNMQa5oSVhYt48Xltos+p0a+7QQpcByzoRTFynp6MSmqqZVo6CdtxwbRVOmmAh/AhJeX4uTuY+JS2bDgmTE8QQlbFKjTPT+o7uI1R73rwXS3jz5MK8sEtDIrorxrDnB34yG8Bo9mIhETZED++tichzRCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63ffftDQwm4Ley7+LtqScbrVzmXMfQyceUkjv+tJxZc=;
 b=RHH6goP0PCNQuL9lAv0mAtolLYX6uuTTg2QuB+vVfvE4Po6BcXeUuM9pv02f/2yU3LsCG+ovdsGxvOW49mNQ3CtZT/sVlC8T/MwNeYIjZsNQh16ceeg4yV+4/EEto5/EyHleIAZAifOgx+Fmi5vjLMgq2WHQdYWLGLtVppU6jdw=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:51 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 21/28] scsi: qedi: Fix use after free during abort cleanup
Date:   Tue, 25 May 2021 13:18:14 -0500
Message-Id: <20210525181821.7617-22-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc68042f-2315-4136-0f3a-08d91fa98c70
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3891E43856544EA88F3D3A7DF1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bB3LAPocWIhS9Y7x/bo97UgdwJyVCu16JixdEzdXhcj/J5VClHXtlDLvmhIHhkvUh41e2VYvMoeoLjKBrlAQXdIyd1TSc/dLXgIUbP0kuXLcPPA6ARmhieTuKLlmMFui97/2JW0fjn51LWQcpkq/Va4+3pW/OG8r9JeFM7jYWY95sDzBk20GXbMvgPUBvBWZh1az8ECeYztweNMoI0yGC1M6BSEaLOn3zsNUJXhT4hvrRAjial6tExcyCoO/r2xU3m/BYJyuiH46s33g+macho3uoewmtfR1fN7JaCFLFNXvYEnQtLRYGprQR9pLhlokjsyHJGIB5U4NsEyTW5WcV6RUlxqqM4k5oObVxN65SOZwUVx2tP4C6e4AmAZXfUo36YdrzgpGUuqJ4DzfbEprZN/fxOi5eMpyHq3I4ECr0OBZm0cMfFkw4L8attYkGItT2mHqR2I9LJHYIDDf7Z/YJ79c+Z3oKf805Gu9SXrC+Bc0FEFyStdCsmmFTnE7HQXlLsbzffxIEB9VYIhHmLntjAp7AFIuZxLJ/4biZmoRcgwtWRLpCW0F96Iqd10fG6e1ozqXblm2NNPkNRtAPaLJ7mGMKZ3v9E1t5EYtUirKvGxC0nv4ArDRuiK5VTmrWiI2iF/yhnix0ynW9kR49RKhxh8Yq1/baCMwNFB19fdYfRfHueXf16rR8z+fpHViWOm1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ac1IjwDSF7u147RIlOpXFOSWZUzZTpJqnq8k+DAfhP/j+jWBcmQPGTR9F6pT?=
 =?us-ascii?Q?qdWyX0AyqYZvDUp1RUYZpOY8ysE8ax6ABcbZhR0rSVjwZaxUD8paP1qNQvly?=
 =?us-ascii?Q?CjrwDfpbk31QPsZYFZzLdtud5T5MZe2bRWqMuW6H9gFRhYJnTOszXYGsy0AY?=
 =?us-ascii?Q?svx3UsSr2XMY4CMLnMXMCNJRcpeLrHj41l51ytYI33aUjuWNzmJjTesmxw1f?=
 =?us-ascii?Q?wFlIycSu9OtORLfTa4Z0F72rkJkflR2nK/hb0WkH2LeUL/jf7ODjxDG+ZGeG?=
 =?us-ascii?Q?0hPQMlv5ha5gEI2bTDn3UiOLlZH1kgKv1f48ySZI7Yo4Q83GGAP4EhqBLg1N?=
 =?us-ascii?Q?T00ceG0lPawgOjgdJ1veSOYps4qSLi8Iy3/ocoy/CNvbjLMZH1Y+23VyXDD/?=
 =?us-ascii?Q?RMNlqeLC1Gy+9XwBAuypXDOhp7U/sNpYuVM5FYdS9ye4/js5n3q+ZTpoNlSZ?=
 =?us-ascii?Q?8BKH98KTNOuc/PWtiQ4jm74Pu+/N66SmuXwJklvBrHAUXZVdMpTMncK7dX+e?=
 =?us-ascii?Q?EslppW71L/YM1JwC9GUhvnld6FGHGydCcjkqn+F/KrRi2tHj9W/vSgolMl/8?=
 =?us-ascii?Q?ivppqoT3mgabGuHV/fYJ/FsgX1UyAA1m86t90wWu/oCkKwN2GpjMnn2AHWyt?=
 =?us-ascii?Q?56I8Rg4jJk6ayRLA10EL68QbRRLIvSGFq/u7N+eBpW5EeDVVhyncEDd9MdU0?=
 =?us-ascii?Q?YbMZV2hF+wZjBqgpLWp5di8KBFV0xP1RNtLpWYhAFJAnEvQrIqobEO5gf8JX?=
 =?us-ascii?Q?crkSWwsGgoAjvbW73nwYG7rYimtu0GyEpkO0H2Ye+IwZds83NF1AKDLpluqA?=
 =?us-ascii?Q?MK2OXdRBHeVTQ4cjYMYW/OFofUYv4UNo0P3vYQsMAkcoAcXM3+u41R13MB6/?=
 =?us-ascii?Q?32BrfEZ8X8rFC/E5fpYNKR5wWDpP5plxcKAzIFvT2pvlrhEEyY+2pW3VdKaS?=
 =?us-ascii?Q?NnWfqWH1D8LXa3XdyYW2j+dUeLFxtSYpDvkPzk+HWOTKwQy3c2NB+/hbPstA?=
 =?us-ascii?Q?SGQ9nfprRMqt7lhReSnAxbBBq6QkbDYw0/oXM/T/E0O4JxC1st5Qju5Lj9py?=
 =?us-ascii?Q?BizRVnrgsUZU9KceWKuMvGhDD1H1YnWuFgECzi5IpZH43QE+eyyydVEsOjHf?=
 =?us-ascii?Q?6m4jH4XNmGierP1rqi2Ac1UhTadNqI/+7kQtpL+na/iHhjViTXDDJSL0JTw7?=
 =?us-ascii?Q?15W5XqI0nl3zkTP8+KlI/yCpuUeudPibP7E5Uzmhlk8dtLWm1/7cAOFaflEB?=
 =?us-ascii?Q?/KtHiq3rEhMszlKnf0Qe0u3N2rwfw63cK32quX39wtjrvoeeKaChKaeZ4JPU?=
 =?us-ascii?Q?rw+WFbSBpm2U7627TKRhMNyY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc68042f-2315-4136-0f3a-08d91fa98c70
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:51.7183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 69Or2lQo64It/o8JvaAphPodHZgOco6tghkoAFzGr/9YytxMSZ5HYc7ZTot7T8YhklW1VLGvSBUXUogaF0XgsqX28keTTk3mNXzWFpusURc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: nNGct-Xea4esP0V8GI13KTV1o2BPetMN
X-Proofpoint-GUID: nNGct-Xea4esP0V8GI13KTV1o2BPetMN
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250112
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

