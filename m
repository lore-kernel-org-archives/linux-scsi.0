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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43892C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1547161244
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348745AbhDMXHd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:07:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47198 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348741AbhDMXHb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 19:07:31 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMkguk169379;
        Tue, 13 Apr 2021 23:07:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fSKfXmzBezzuIir1n114MYgYzGXMP/cHnNbr3DRfRjk=;
 b=hY2kHWr70B7zGra/msCfGibeLAvFkVm6SYJiJcO2wkevmCl+02nxaUd+w9489w/nKTzB
 gOx6SrqpolS6+JsKyDdagQ2/nCdigU2FrAWhVC1g29HgfC8Ss+kR3xkIMhewFhxe9Wou
 N8ECBfDoqjAqhuwCz981aYh8khIxjZKvDc3UJLZlAHTqPnfWlmAtI6FVRJpdbbg0zMI1
 WRKT54kBLMj5ya6A2IQ6aYTdhTmt1Z6J1cf8p/hIIgEfGC1/99P80IXgUOWBel3Dbtrl
 XbvmlmGgTA5NaTVpUZrB+MITRnvDVPMqFaUk8lxw+4AH8fPakZ0ikaXdf2AfKMIfrgzM Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37u1hbgsw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjgau142820;
        Tue, 13 Apr 2021 23:07:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by aserp3020.oracle.com with ESMTP id 37unx0e1gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhncvF50UdQrFmEChGiVCtOd5O84j9DtXHdY461TemDoFtTjaSmIyzpKiy+bNo5Xov1QVVtNgmg/GDMqw/2XSxfHEliLS0jKglB62DR/nSr0k6NDOMgjVi5B5U/JXSvSRJa6tyhoGCJQVKQWL8siENPG0TxisWXWXfWK9MAsZVIdeM5niH0uj/0toE7/VABRQ7nLk6I00CgLCGIxoeAL+lF7shb4HvRLCvQdWdPt6WyJa1NERAXaHu81nkR7XP5GVYDNSR09qVGQdrpc6O/c2kylFwFTj2DuQvo77kzkMk7CvJcioWVHQINlsL46HmDus4EgiHmXqpYJtpjg6bOJkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSKfXmzBezzuIir1n114MYgYzGXMP/cHnNbr3DRfRjk=;
 b=Mx6zt2jYLdyJp5qWLN7eyM2QaO0lT09LiafKxOJChHTZMkFYrjnx5PM+edNVQgHEJgyLg9wCBerGP91DOy3ZMk7t2aP+BZgwDJTi1F4s42INMGmLPNF4oEVF2AUziQCkoGX+pH+Yg5oZTDhR5zVUvJV1Si5lE3GJtKqBhDY7Vldxfj/lqa4RZyhQikLCsDHS291Snaa3kRdavjpDrAHaEV45h4qCDz93Nm5Ru1NKXrpqRJf74YaNkimtr/RRNjj2SvkSzhIlCHteG8V0ANnEb4D2yA4e7c/wnLoZCoo2B8aVaXNkmLM5oLs0jl1DBMus2qGtC3wFR+XeOIkgJqFjkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSKfXmzBezzuIir1n114MYgYzGXMP/cHnNbr3DRfRjk=;
 b=RzCz7ussHuJbIj5oPiKAdO+zAcLgdh99IpZ6tyq+2IgR/x0BOqgANQ87IlS3XkmsfxEUHO/laPaaS6KY90GoSuOd6ZpfVc/Ngqo5e+krYJeFwmMoE3A9KNCPifulxMl3VjUDT3iYEWx8Pc6t3FtY//tbsVr+wBFnCYiW7S2ZtEM=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2469.namprd10.prod.outlook.com (2603:10b6:a02:b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 23:07:02 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:07:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 05/13] scsi: qedi: fix abort vs cmd re-use race
Date:   Tue, 13 Apr 2021 18:06:40 -0500
Message-Id: <20210413230648.5593-6-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 23:07:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b973306-b719-4d8f-1bbc-08d8fed0d8fd
X-MS-TrafficTypeDiagnostic: BYAPR10MB2469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB24697923663F468B044156EEF14F9@BYAPR10MB2469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CfYX88/Kh9vLrZ6cAvD4mQWFed2JzNZoyPYjDdmGikVXNR/FrXrO0LmDsSG0i/vCGtLWD8p4d2yeeSiBMiV33IY9SREaPwvlxdNfm2nPa3FoeBu/KxtQOJjuNIlygWoLSUvR5lHX1QwxjLHfRM/hZ5NADJmqrA6tPxK5b6BkyXZw2z7WV0DoCAoFlXvndSmdBFFImzW74nl8URR1k86iN/NUI3RvX3PhO1tmgZ0D2UBlMEkC3i03b9e9VDttew0Q20tzejvbZIffHBB4J+X5KpTvFSIsk8zmiJZFpNEfCKddZZaZ96YjueCFEci6ayg7AH9GauJqZbKUPeuseHvGtzYfKLDhuT6ljDMPWge2llOT0vaGG6/RKlotoZiPJWuvdksJ+m7/Y49/SQWgg/Q775eMrJk502JwoZwQP0NnDhwQ2TzpWQ04wzngu4GMJY9Hw2GODIc7BrM1U1zdfiQae4RP2C1O5GyyK2jjFNjm59LdJPXyYpCrcnDCAoUWLugCyP+KhnTEyP+XANc6sYgX3d3oIcl+5nxJBpsp5QoCJ+O4nYBERe6d+IMMP+hnxXwUSVWVRkmSxusS8Wt8PcyIWaZKSnU7Yz1MVI22SuqIsAg3mzl2JDqYNt4+Qqw3YVgkIe9pOaWlLE7eFpD1s0R+BRwutjxGsRIuGqjJkQ/0iIa3jJYPkVbWEpO0svx0UDp6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39860400002)(346002)(376002)(52116002)(6512007)(478600001)(16526019)(186003)(2616005)(8676002)(66476007)(956004)(69590400012)(4326008)(6506007)(66556008)(86362001)(8936002)(6486002)(83380400001)(107886003)(316002)(36756003)(38100700002)(6666004)(2906002)(66946007)(5660300002)(26005)(38350700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oy3adNmGUHOwpeQP5emSGUVs31tANz4IwOET4D5XMJ8Z1ukh8UC3piR96ldN?=
 =?us-ascii?Q?Run0XZI5gFR3XX9ZDnX0AHcXbkje6OsJKAdshTzjLYJGJEZyIb3Rk7ec7GjI?=
 =?us-ascii?Q?DhtX9XL+CqyhE3y3EizTUWFGn05TzKu2IGjTgfKhwiQmHB0wlToaQEU46/om?=
 =?us-ascii?Q?2n+smHT/L4+wRj7m+d2DuW/844Xz/uGRAuCKBNVaVk6u7Hshf1gQwS2A8b5Z?=
 =?us-ascii?Q?Mf5mYU4Ob3fBjjmvB8opYMoO4CHmtPCMwdjQq/EEapKpejD6RxRY8Zy8ZXm+?=
 =?us-ascii?Q?Diq34aAdrevr+0VH8VKYIwSvcaDeJCHyXIB7pAPYUb/ue/CkMlcgMS+HX5KO?=
 =?us-ascii?Q?+VUKX9Vacfvl6WaTjIjInGRQoRqTHENGBuBmtktyxRw5cysD2XalL4XZhhZU?=
 =?us-ascii?Q?4v7DXHV/91a65FmbPDKe++DCj+CY6sdvsrjQ+o37nmiYcWbM0EMMMGvQi00T?=
 =?us-ascii?Q?H3tqVCMzhPsbn2BV68jnQbZI6bqBlqFjOkzdsGqVVtSj4suF242o3IaiVelc?=
 =?us-ascii?Q?vvFjjpbKQzvYpzjVUF0AqeVoxAjBNUcYC3brCKmBagTQ+A+UAEBMUxsd/XYR?=
 =?us-ascii?Q?rNqjB6iRRnSpm5RssLt+/5rIYrJO4sACgjMaO1/J1H0e/lO963nwmlfVrZ46?=
 =?us-ascii?Q?GIIonovvT/1C7zjLGM4sBg3xZX6W5W/SOHudPTtcNw1CLv5GECFL008LgyL8?=
 =?us-ascii?Q?wAEde1Irj4ePdMwwewib8TBa8o8I2VPeXxvdpbZ0shGmIEMnB/ngxaHHjb5e?=
 =?us-ascii?Q?jAotm7p2QZKTAVMQbkvu7gs7ExMZzdOerJpFvUfvQ4K0jPMzJcxNgJS6HXLw?=
 =?us-ascii?Q?E+jjPHjth2J0irYgkhLCEw5Lt1wbu3A4gUI2N5hFEM1l22RMI8wrZhhOdnfj?=
 =?us-ascii?Q?dOYrbS+eQkdA/IrwIRC2XeHRKQwUrKld+52am1epdqt2mhpaow9Gc0c4UiQr?=
 =?us-ascii?Q?gF/3IxwaSC/6/hIiQ2r13xJOVtL1pjhnVJhP/haCrQ7Jc9xAi61LoXGUFBYx?=
 =?us-ascii?Q?Tr+R2uF20On0kH2PziAyD7U/gjx3rUwlE5wa4873CSJ+qKthlKzH0QC0HJCl?=
 =?us-ascii?Q?UJ0S0bh6V1TEkDp6LbZ0zylpAYOdOo9tfPyYtSl3b1P2ox2M+ts40F4cFmUJ?=
 =?us-ascii?Q?4p058Sxf9OoPBHAqS9GzE9qbNMHZ+nryLIoJtZvBlXmVe0JvBiPn/zPN+Vhn?=
 =?us-ascii?Q?LiVjQXFNXiSMabk1AkoiPZecPj7smtLzN/HqRdl3hm34sfiUYXxIlSAkcM61?=
 =?us-ascii?Q?5bLryADcA9L3KDusJutLLn9J4mgJopcKMKuSNsheANYM2epTTlLqkF50wAEm?=
 =?us-ascii?Q?A30jFoG+Ilti0dlN4ZvO1Ru4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b973306-b719-4d8f-1bbc-08d8fed0d8fd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 23:07:02.2113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jXnZ4I98JTnW3vFu6gv/K1EAlUV3tbMSyDB2HI4XnCjJVv2Zl+XVMSjNNiRk+wv06lqinfKv0ZpUzsJxoIR11q+NZDy2rRZKVqgXBH2ug6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130148
X-Proofpoint-GUID: v9CjcI6gVHB2A7NgLUPuFcRwFE_sXk7y
X-Proofpoint-ORIG-GUID: v9CjcI6gVHB2A7NgLUPuFcRwFE_sXk7y
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the scsi cmd completes after qedi_tmf_work calls iscsi_itt_to_task
then the qedi qedi_cmd->task_id could be freed and used for another
cmd. If we then call qedi_iscsi_cleanup_task with that task_id we will
be cleaning up the wrong cmd.

This patch has us wait to release the task_id until the last put has been
done on the iscsi_task. Because libiscsi grabs a ref to the task when
sending the abort, we know that for the non abort timeout case that the
task_id we are referencing is for the cmd that was supposed to be aborted.

The next patch will fix the case where the abort timesout while we are
running qedi_tmf_work.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 13 -------------
 drivers/scsi/qedi/qedi_iscsi.c | 20 +++++++++++++++++---
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index cf57b4e49700..ad4357e4c15d 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -73,7 +73,6 @@ static void qedi_process_logout_resp(struct qedi_ctx *qedi,
 	spin_unlock(&qedi_conn->list_lock);
 
 	cmd->state = RESPONSE_RECEIVED;
-	qedi_clear_task_idx(qedi, cmd->task_id);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
 
 	spin_unlock(&session->back_lock);
@@ -138,7 +137,6 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 	spin_unlock(&qedi_conn->list_lock);
 
 	cmd->state = RESPONSE_RECEIVED;
-	qedi_clear_task_idx(qedi, cmd->task_id);
 
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr,
 			     qedi_conn->gen_pdu.resp_buf,
@@ -164,13 +162,11 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	iscsi_block_session(session->cls_session);
 	rval = qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
 	if (rval) {
-		qedi_clear_task_idx(qedi, qedi_cmd->task_id);
 		iscsi_unblock_session(session->cls_session);
 		goto exit_tmf_resp;
 	}
 
 	iscsi_unblock_session(session->cls_session);
-	qedi_clear_task_idx(qedi, qedi_cmd->task_id);
 
 	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
@@ -245,8 +241,6 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 		goto unblock_sess;
 	}
 
-	qedi_clear_task_idx(qedi, qedi_cmd->task_id);
-
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
 	kfree(resp_hdr_ptr);
 
@@ -314,7 +308,6 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 		  "Freeing tid=0x%x for cid=0x%x\n",
 		  cmd->task_id, qedi_conn->iscsi_conn_id);
 	cmd->state = RESPONSE_RECEIVED;
-	qedi_clear_task_idx(qedi, cmd->task_id);
 }
 
 static void qedi_get_rq_bdq_buf(struct qedi_ctx *qedi,
@@ -468,7 +461,6 @@ static int qedi_process_nopin_mesg(struct qedi_ctx *qedi,
 		}
 
 		spin_unlock(&qedi_conn->list_lock);
-		qedi_clear_task_idx(qedi, cmd->task_id);
 	}
 
 done:
@@ -673,7 +665,6 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 	if (qedi_io_tracing)
 		qedi_trace_io(qedi, task, cmd->task_id, QEDI_IO_TRACE_RSP);
 
-	qedi_clear_task_idx(qedi, cmd->task_id);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
 			     conn->data, datalen);
 error:
@@ -730,7 +721,6 @@ static void qedi_process_nopin_local_cmpl(struct qedi_ctx *qedi,
 		  cqe->itid, cmd->task_id);
 
 	cmd->state = RESPONSE_RECEIVED;
-	qedi_clear_task_idx(qedi, cmd->task_id);
 
 	spin_lock_bh(&session->back_lock);
 	__iscsi_put_task(task);
@@ -821,8 +811,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			if (qedi_cmd->state == CLEANUP_WAIT_FAILED)
 				qedi_cmd->state = CLEANUP_RECV;
 
-			qedi_clear_task_idx(qedi_conn->qedi, rtid);
-
 			spin_lock(&qedi_conn->list_lock);
 			if (likely(dbg_cmd->io_cmd_in_list)) {
 				dbg_cmd->io_cmd_in_list = false;
@@ -856,7 +844,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
 			  "Freeing tid=0x%x for cid=0x%x\n",
 			  cqe->itid, qedi_conn->iscsi_conn_id);
-		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
 
 	} else {
 		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 8ed1852627e7..9b794afbdead 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -772,7 +772,6 @@ static int qedi_mtask_xmit(struct iscsi_conn *conn, struct iscsi_task *task)
 	}
 
 	cmd->conn = conn->dd_data;
-	cmd->scsi_cmd = NULL;
 	return qedi_iscsi_send_generic_request(task);
 }
 
@@ -783,6 +782,10 @@ static int qedi_task_xmit(struct iscsi_task *task)
 	struct qedi_cmd *cmd = task->dd_data;
 	struct scsi_cmnd *sc = task->sc;
 
+	/* Clear now so in cleanup_task we know it didn't make it */
+	cmd->scsi_cmd = NULL;
+	cmd->task_id = -1;
+
 	if (test_bit(QEDI_IN_SHUTDOWN, &qedi_conn->qedi->flags))
 		return -ENODEV;
 
@@ -1383,13 +1386,24 @@ static umode_t qedi_attr_is_visible(int param_type, int param)
 
 static void qedi_cleanup_task(struct iscsi_task *task)
 {
-	if (!task->sc || task->state == ISCSI_TASK_PENDING) {
+	struct qedi_cmd *cmd;
+
+	if (task->state == ISCSI_TASK_PENDING) {
 		QEDI_INFO(NULL, QEDI_LOG_IO, "Returning ref_cnt=%d\n",
 			  refcount_read(&task->refcount));
 		return;
 	}
 
-	qedi_iscsi_unmap_sg_list(task->dd_data);
+	if (task->sc)
+		qedi_iscsi_unmap_sg_list(task->dd_data);
+
+	cmd = task->dd_data;
+	if (cmd->task_id != -1)
+		qedi_clear_task_idx(iscsi_host_priv(task->conn->session->host),
+				    cmd->task_id);
+
+	cmd->task_id = -1;
+	cmd->scsi_cmd = NULL;
 }
 
 struct iscsi_transport qedi_iscsi_transport = {
-- 
2.25.1

