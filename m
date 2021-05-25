Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6D6C47085
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EFDE61404
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhEYSUm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56004 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbhEYSUi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFSaY074788;
        Tue, 25 May 2021 18:18:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=OLl4vPtvepuZCjRA8gY5TV6d639SQUvny1zWKIS+hao=;
 b=hplkRMDAgwEdeyOwJtd8D/onjqkbn/blR5h1Ckpj2PzuV18tcscUYPrLHHr6aztu9Rt1
 ymAjD7IvtksMEu2buN2UP5EicfxkGHh6fe1EIrT3rNRcURuhpTgYwOh97E84ZHL9EUvG
 ysxrxzuswHsgrKvQ50N7nZDLdRDBmJ4JM+uyYi8Sb8rwRipAIoLtmwCzoMP1dBtiW5s9
 +/Lo/6vVEVzEoROUIHa5OD2cYBad+f2U5ZfCX1ltWBOBKGq8r37cS1sl081mNtsSdUiS
 eObufy4o16YIOHcop1IWt7EqeYMQ6bSBRpuzIbtHXibjjr0mj87U/dOZMatpDBiyMtb5 Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38ptkp6vmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEulm166263;
        Tue, 25 May 2021 18:18:58 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3020.oracle.com with ESMTP id 38rehaq64q-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HEIUf+5qthhCsVlQujgUxAXe2EKfHLQZQSrVMOxT5N02LIjWoBRwI7SMsxFiFyv2BsKwxmXootuoFZ73/kTaoUT0T9c5vI4Pj1HdVlfczXAz+8MlS3ftQR6O7wudY3ZdsWlu4gQb1maiG90ezKTF73pO8jwz3Hj+JVdYI6geUz6GX74YXbV+pezPGN4yvQcDwbnhIGJL9fPPwtiQOhCVZZ+5/s+orTGN+7BS16/MNPDfggHaVomULdbxgGKL8c0+3KBAKUFCGH2E1T9dS842EhbUkW9rf1zcx7FRrM9RhTBqjPOi/s1yBrbCuOd8th4QAZZquQ2Z7NKQiX6EGE2y2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLl4vPtvepuZCjRA8gY5TV6d639SQUvny1zWKIS+hao=;
 b=ZZMGjFqBogRYF5eKTv7kv8LgrPYJ0F0HtVGzgS0Z8fhRVicEQjIHwJVIRPI/9uemisPcXhfRysuTWfER7cYktVR1TY8H4kAKcEqtgRDkdo6Dj+kwQaWHJGl/55Wm1q51ONOysm459ve3NhI3wvqbRLqD2gZlDaIfz/LiTtKA4c9j9ZeZ3OWiiEQl1ZfSjjEkW6/t7s9jmw8tCMdGY1aiVFi25h3vKMiOaEIS+7GnbLZZWqjtAgnD5uTwSQMgKEPR8yxq66K2RU+P8u0EhL/X4lWPm8gouTIoiUi1jcy4ukUmeOmY6GFQHvHv5o8zmdiDqVktEUjpjcrolWqS1+AIWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLl4vPtvepuZCjRA8gY5TV6d639SQUvny1zWKIS+hao=;
 b=oP1ygcfssbzTu0ul9l5fOi44g+5nbI0/HYACbRq2SIKoi5Xuf4Q73HahG5IeDt8+PvXJJlgtl3URFaG9CizGHklxUVWOzXELX57ZpnRuHRMLCxRzss5HtzYP4zbB3l7DQAiIfSY5nnvxDW1vUsLVFJJhUtzbIQESrWDFn9ENEnE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:52 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 22/28] scsi: qedi: Fix TMF tid allocation
Date:   Tue, 25 May 2021 13:18:15 -0500
Message-Id: <20210525181821.7617-23-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01fcab02-9b19-41de-93ef-08d91fa98d0f
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3891E9B40937C1DF9F957EDAF1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b4gTaMuQjQtOp2Ij0cFsw/D/3+VuH2aSJlhHetmFu/3lj2NydsiWATwkZ5uVhk90dtvDDRJcJoPb3AMkl97s1AFl8PrSA5f3+n20LTJAKhp379O9lLaf2ZRJgznJJTkPaPmTpFFgMcdTb2I+6Ne9VcYBQ/OGL7NbPdNrlb9JNJKXM/C/n9Yc2/ivs+mzGP46JMdbsaQcBVYqKQsn8FQArL1QSNV6kL9gh9yPP8+8wTlrDvml767bNlCI7ZnLqJKgAqTbp08e3ooLxJ2QxG0JpmcD2zwjAnTiW7ID/nqgJ2aKMRlALB23R5RYdvNZo3ixU+JH5lXFlOn2MrcBS49do9ohZXCelJYpyISkf9NlBfa0VLh49/Se4EAmWy+KjKXtBYYsXcRBdzwCHsTCiUy8rZZHRR2l8veP3x8kNh7RMDYQTiDoRZujrLxkPZL7PaHHXBe12MdKz/H5FmHrdPJepfLphjpq49fH3u/h4OCctdLfWxsdDPP/1YH9lULF6XseDeT4F49szXlEAaiAVD7J5sgLXbMZfGhQOZYzGLnbg/JdRhAaDLYrQx69fFolgN2u1iw9CsNIP2QtEjLgmdZDF6eNLXVrNOAZIuhbXDavp6JbXBCT/a1sjpVrbp7fM3S+Hegl/j7wxe2uQi8hbwhL7TXd4hC8ay3tfytXGB6LqG87UpA2GVFDuYjYitp8niiA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zGq1ADKYon0ChpNutwwOLSef5A7R8fJvG26rbxdzcakzrH31uGtxiDVSWhdK?=
 =?us-ascii?Q?FwLL6edtZQDODjjSMls4ceOj22SiyAWNAGyrkVk2d5Sx2dBKJKJZCKy/xrAX?=
 =?us-ascii?Q?iiFSzw7tmQh92eiGk6C0BOqE2QGHpZFF5F/Y/cnHZrj4XbDpgsemMSkpS879?=
 =?us-ascii?Q?/uv7JcgIKCoKVDvLbd2P7lvqHK6jwzSivA/L33zwuSE8yFbfny4EqCbwj7Zb?=
 =?us-ascii?Q?aPyH6AOl1/j3es4s9qZiaSPZnUdokVDehxxA5id/wYScvXyqf4B5FN/8v6Hv?=
 =?us-ascii?Q?JEni4QebOj121juQjSbLy+S2BElOBsXmLDehGBwJgS0Iup6kqrnBmOpYqQgQ?=
 =?us-ascii?Q?+or6xq3iLCx8GKXtLqlBHcoMLvebfLrkpbtvxCvt8Qj7ZJEXJt/6pjf/3M0/?=
 =?us-ascii?Q?jryI3QNO2ghproe7wRcXjsuR4b1pOzDyXlI7QHhzqU/cUsgwobbjwgsXR5F1?=
 =?us-ascii?Q?lZqeVq4dXDg098JHQvITjiO8KoxpRSmNfCcm4RgD9Gp9mXdz6K3FHO6CXmRd?=
 =?us-ascii?Q?xtUmD+ocK67Z3jqkSbnYxS1fJp6Rz7qv2Ghbzla9uzF+lcjpTJblVWR2ey5g?=
 =?us-ascii?Q?z40h2PAITE0v90QL8vjK+UL4ZZEpzV2R0qYh/LGNe7o6x7NlYlHDw0qhFUuC?=
 =?us-ascii?Q?8NoMWy6XUS5HgwgBCgzie3bk/dxsU3y/JLfeJWbR2U4PxoDVHvAIFlmtKkf7?=
 =?us-ascii?Q?gPk+7Nj4MrDxpH2M9I1E43UV3Rz8RWy/PS5I7y3CmvEwN6vYwB9/fAt7FB0m?=
 =?us-ascii?Q?5TAVYjVo3+ikI/OvP7byaQnu8dhyu2Hkb3Ag71lXyMHGQy3+S/9zUalqsVGV?=
 =?us-ascii?Q?MRTrcjhW5dBbrCxyfZOOAX+q+ieO14Yh7y83jEhWRKbZq94DPdL/r0qer8q5?=
 =?us-ascii?Q?ukhIz5Ya4r/oB4a2Pfi+lZDFPV4FpVUgpDIIZ+rHE9GMtxM7tURiAW+GhlP0?=
 =?us-ascii?Q?fOTw33AIZwDZPCf8cESJN8GMk6cDGCAIDj8XVVi6x1f4Q1jNss3VYEdLGUjQ?=
 =?us-ascii?Q?c/3piuiTFHENOVFQmftdVLUaFxAKvwP79W9zL9jFPhGH7rWBbcZbGh8odYfN?=
 =?us-ascii?Q?vpncBNAETCGpAD9sVddvAfSyTXl4PkNby09KGlQAbZMIVB+W8viFwoNgYpfY?=
 =?us-ascii?Q?bw9SnYDBJENLt+Em+Qpfye/Tgt+GUADlivz2Cc/S+84ntwd6wvPJ8fJggGGe?=
 =?us-ascii?Q?L9LjxkqZVo8LP6pyszR3elDnTVCODf6Jd8w4/z8W2OayGuMYHv7DNqT3B7ZF?=
 =?us-ascii?Q?p69YN1ouzVnCZIxwU9MKfD95X1E7lRl6Fk0oD6kT0Vr1BL/5l1Hry8wJ8c2K?=
 =?us-ascii?Q?vCurDcQMM6XLpPTZzPUxeNS5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01fcab02-9b19-41de-93ef-08d91fa98d0f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:52.7777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: euPavcSMQpO+JLMRXkaGKQk0vDjy5ZazkzcPJ/nb97GwMfRzoD9RegaiqDb4o9NQwwYzS9SBoWMAx46njNLhDFz/0VjVKVjyKOU47B0AYbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-GUID: TKgrHauBMf4JqI5HGFOYPJUMVveUcDPa
X-Proofpoint-ORIG-GUID: TKgrHauBMf4JqI5HGFOYPJUMVveUcDPa
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qedi_iscsi_abort_work and qedi_tmf_work allocates a tid then calls
qedi_send_iscsi_tmf which also allcoates a tid. This removes the tid
allocation from the callers.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 76 ++++++++++------------------------
 drivers/scsi/qedi/qedi_gbl.h   |  3 +-
 drivers/scsi/qedi/qedi_iscsi.c |  2 +-
 3 files changed, 25 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 61c1ebb3004c..6812dc023def 100644
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
@@ -1348,7 +1348,7 @@ static int qedi_wait_for_cleanup_request(struct qedi_ctx *qedi,
 	return 0;
 }
 
-static void qedi_tmf_work(struct work_struct *work)
+static void qedi_abort_work(struct work_struct *work)
 {
 	struct qedi_cmd *qedi_cmd =
 		container_of(work, struct qedi_cmd, tmf_work);
@@ -1361,7 +1361,6 @@ static void qedi_tmf_work(struct work_struct *work)
 	struct iscsi_task *ctask;
 	struct iscsi_tm *tmf_hdr;
 	s16 rval = 0;
-	s16 tid = 0;
 
 	mtask = qedi_cmd->task;
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
@@ -1406,6 +1405,7 @@ static void qedi_tmf_work(struct work_struct *work)
 	}
 
 	qedi_cmd->type = TYPEIO;
+	qedi_cmd->state = CLEANUP_WAIT;
 	list_work->qedi_cmd = qedi_cmd;
 	list_work->rtid = cmd->task_id;
 	list_work->state = QEDI_WORK_SCHEDULED;
@@ -1433,15 +1433,7 @@ static void qedi_tmf_work(struct work_struct *work)
 	}
 
 send_tmf:
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
 
 clear_cleanup:
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
@@ -1467,8 +1459,7 @@ static void qedi_tmf_work(struct work_struct *work)
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 }
 
-static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
-			       struct iscsi_task *mtask)
+static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 {
 	struct iscsi_tmf_request_hdr tmf_pdu_header;
 	struct iscsi_task_params task_params;
@@ -1483,7 +1474,6 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	u32 scsi_lun[2];
 	s16 tid = 0;
 	u16 sq_idx = 0;
-	int rval = 0;
 
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 	qedi_cmd = (struct qedi_cmd *)mtask->dd_data;
@@ -1547,10 +1537,7 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	task_params.sqe = &ep->sq[sq_idx];
 
 	memset(task_params.sqe, 0, sizeof(struct iscsi_wqe));
-	rval = init_initiator_tmf_request_task(&task_params,
-					       &tmf_pdu_header);
-	if (rval)
-		return -1;
+	init_initiator_tmf_request_task(&task_params, &tmf_pdu_header);
 
 	spin_lock(&qedi_conn->list_lock);
 	list_add_tail(&qedi_cmd->io_cmd, &qedi_conn->active_cmd_list);
@@ -1562,47 +1549,30 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
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
index 5304a028db0a..0ece2c3b105b 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -753,7 +753,7 @@ static int qedi_iscsi_send_generic_request(struct iscsi_task *task)
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

