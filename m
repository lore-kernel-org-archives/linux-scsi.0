Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7580C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A057D61404
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbhEYSVA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:21:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47190 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhEYSUl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIGHb7053628;
        Tue, 25 May 2021 18:19:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=/b0Y6QfZM5snDlg/YJiM0Da+Gu+sEC+KOLn7VIp1KCY=;
 b=B4Vgsi7iQjT2CqQrllWwzvY/QqN5XtD0FPV67820XVP/eqHv62+4rN5Nxx/ub0DwHXPJ
 4CcHqnq/9k/JXFMYRfxRbZYARlKUMGoQ8hxdgMvA09W/YI1qWMmykf7bq7u6AyAhk8Hf
 dEXBJ8vd0ahQhGPuqCcGB1jXHctJ3XqvMmmqeJBUreCoEHjjSlM20cYnTJQK2VsSLokC
 P04AyVK+yhFdM5q4FTlOjkiQQmUjX4Kg25/jpIA6CQb5zd/UR9Ggterkd2q2/vtOi9FY
 3y8W9SUNortU7Y58lxmA0le6EchcuwZmXnWsCNKEEs4boO8TqBxI31mWF/oD6iB8KUvc Dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38rne42gv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:19:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFGMo104688;
        Tue, 25 May 2021 18:19:03 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by userp3030.oracle.com with ESMTP id 38pq2ufk67-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:19:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pz+XSb0m3m+vcFdw6wajT2yPQ+1v1fMLt+DU3MExnz8lC/JW0jCBR+QwDjK+MMPaFoBEDi0EbmKwXSRizWGp4BlCwOwMgS5/H0wMjJyFzJiUOBfFceo9lmb7hxYBT4iPH3xBBUlEWTcrN0y9+kg8HpOEivpBYNweJmS3HIENUdPIMXvd5y3sQnSEvalotUKz41VqFAby62YVXgOUl/JBSumwRkKxUE5X0R5raW78sV0fVtdsjutvTMcBfXChKgJLNi9lTgEYUhXMLzRXQB7ql58aMnLEjRtBoO3AB3Cjgwgd0By4V5kokO+Qe8tvjxvYgi5eLEFvw9vopYMekJuQeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/b0Y6QfZM5snDlg/YJiM0Da+Gu+sEC+KOLn7VIp1KCY=;
 b=XDg6Y8rCzMD2j4f9EFzFx8iii4SNblSh0RZ/sQNwMd7nRDJqMy63Me/QtWcyF7Dhqig9zmCnZwFC4U3btR4hXKcTa8MhDVh74jBvsxx6oS00hdlAKB0s+g6CjxFRxJfnVB/Vhr7UiQE86hVEtJ99kly4jXUwP8VjTjpos2/wMHuO7SyjfH6ygUTUcZUHzhnmBi0PMwbxgdDlc/uA4HsDAt44mSgOt9vhlYoLEWROaCia1zjJqGkd8VcWMxnyucpLFtqY74rpiwJf8oPoxsxktmxzKUJPo1qxmUHDkybNSGGdjxf8s8Myx9u+GP0tHciMA04A95snX4PF8svGXya+1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/b0Y6QfZM5snDlg/YJiM0Da+Gu+sEC+KOLn7VIp1KCY=;
 b=MRXaxjg53G1x4w6dXTw3V0BLAop3YWLe8kwW+ECpawOuHwjmH4QkLvgfUUWiTyVYADBj5VXEoNVuTJ7ATRwN97QwhwFDTQyoxrX3iEdNtlQSPvUirkyIZTVer+5PKMMNkWV6aTbt5P8yNmC4MaO2I2Pl5xQkTqUzvuY52VSfnRk=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:57 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 26/28] scsi: qedi: Pass send_iscsi_tmf task to abort
Date:   Tue, 25 May 2021 13:18:19 -0500
Message-Id: <20210525181821.7617-27-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3b5fc7e-6fb7-4bfd-912a-08d91fa98fcb
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB389165F795D5AF8940380D49F1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wBFzGhvDB3NjfZx10pPK+yhnvJT/BpCRIjsH7CT709+W2LmJaqy48dU8ROGx3MWFJ4iwwYy1sH7ebNvL9c8u6NjeDB80pBZS7qDsOLFA3Pnb8F2utSYZzBBkAu96wJ4cWfcrDDFlL19fjcrAWQZjWFKbm2UUf5bAssyaigzfxRkev9anFXwzeTW0OSHwcLxj/yE5GBetCIw5aOkrSR/JtG5zp/tIrqvbpLCWAki8aINOgC1w4bqh/kSJGVhYg2bxkO9ykjoHzkJkM4LO50G7RG5taMQvgq2b6eOiMuXCpg2HJ45w7LC5ck4BJmkbUzZOn3ZMzjLQtpe+9xzpWyoc7PkSFi+MuGKTTQEC2gbtTnKHw4LaxdLMeYFg36bC3JSBvJNQMHXd2BwL8+gCiKDp8OjlLnBa+7wHRJtt1mPQuIDqCNyALjSEUjeMDS7kpMIDyznKl2AjMi+xBbn3nVktQ75aq/mGAjfGm5M/UoRFwxGd7TS4AzF0GRjCSj3L7rjolRU3I9SR+HaPYYxskJ0aXnY44V9Hel2MtphctpVMmvxBhOHtKQLtCXjcjMf02xYQFxMR5vUn2advvauX4tzwMVnSdfKyHNj5uWG1PGm4Aqtf7g5fulm1d5mB5NVvrrIBlqI4folYJAFybK6aFLMCLao4TuVRZe3m9DcfMde7O2uQn9uwWATR2UIEB8ALV6ja
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dRlza5i4gmdyXzBxCE6IhGUpnr7Pp4YSZ4rXIMcfK2G1Ev96UXcGE8F2MwBC?=
 =?us-ascii?Q?oANnLpAEPREjPMyaftmYKPcU1XTfcVJHHhKWKpiU1o7T5mDzzVHnoZjJfRgO?=
 =?us-ascii?Q?PqsNSnkEOc+wbXe7bONGX94kLz8AbAq8Hz8VBLlxxuFUJm4m8BqgsgeI793V?=
 =?us-ascii?Q?OybIMz1owLDfigxPWUepmoz8IRCSZ0w0Uu6Yeztsj7s65nZJZ2PQoQTi3kH3?=
 =?us-ascii?Q?CpqGyROvzShoMKAcgsLT00dAj6ecK+ORhDNObAsj4ghwdMBl1v7eaQtZ+yRX?=
 =?us-ascii?Q?lgL29O45AWn6nH/eNc2mUHGcwOgT60DY+wscB/iKLlAHoEzbn3tB8yoE0wg0?=
 =?us-ascii?Q?ibqTM7FK6kWGf4220Fs0NPIc/XXcpuXqOH5dKMIoCmcM84Orq+BovqSKUSBi?=
 =?us-ascii?Q?Cb95AnDVW7Su4W4kXbUI/KCjvAwUvgAE1FvAW6JlhZuK1O11kq1ECdve8p49?=
 =?us-ascii?Q?mfgo1gA+SQTl3AJvHltlzQ/CFFKNkvCuj7Q1/IS67Q7FasPjwVRY7U42DMn6?=
 =?us-ascii?Q?tzQK7AX3hPI4hAbQlfUM4Jj8dHVa6BbmgYV+aIm2sUo8DrWhQWAJA6lCLnav?=
 =?us-ascii?Q?xDPLsqS+ctH70fTmmJoqLE76Mr80We7itECFQhPDJGxRRRvq5MhCzRW/Knub?=
 =?us-ascii?Q?7zode5anuToELvSnmu0d/bFc4ndWX88DwaBGC+RDQVCdeOXxe4WUNUwPGmCj?=
 =?us-ascii?Q?l1QXBlmwjAL947PWcyDxe3Q25YqdKo+FLL35W3rI/KMlOKr9hpI2iLNfpIUz?=
 =?us-ascii?Q?neuVPYcU/ooqGJIJXMSYkd4W7k/MmObm4Z+zRTaLfoGlt/83bi4OnPbE97vx?=
 =?us-ascii?Q?/fZfGzc5CkeXREtMgERSFbcqE9jUQTu+odqNxNMbr1l+iJM9KPpzvgeyLA3A?=
 =?us-ascii?Q?T2PjW2nVbFcYunE2N9XuidBFF2eqEoKptsdYHOlnzwNU2clh2FFEolltAUJM?=
 =?us-ascii?Q?WxMzimXXdD5oPXnzwEk5DWzPAAbmWyaOBsmkw+YVyfeX8AmfLWd5687gKJmJ?=
 =?us-ascii?Q?JWOWqr+1H1hkAKeGvgLsjnG+4PE8f1RegX/lmi3/7cY7xP2HRah07X7Fnz3m?=
 =?us-ascii?Q?TbHebZzpLubbEkX1RsH3DT9d3r6pwifFZVDOXBtzhgj7YYtFr5hJx2iWzmOr?=
 =?us-ascii?Q?1GOniiwsdRi/Wu2tuMVUdQpQDyYI8jRor42bPKK/kZYORz0C/kgDLiDmLNDs?=
 =?us-ascii?Q?+v4b3UH2RNCC1+gVY6opjk41cOGQY3JciBopVAzHqzk1+G6dlIde2pIHXpf+?=
 =?us-ascii?Q?79zMb0VAgtX2F9DT6j6+ZwoqByzlbIYMIFUCn44wXBYTh7vARIgqlwX4ymCT?=
 =?us-ascii?Q?RdaqXdJ/GqpcI0GJsb6lRbQl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3b5fc7e-6fb7-4bfd-912a-08d91fa98fcb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:57.3362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2DymknDpjIQAs8jXlRalNygR/fd4GmoRExtCACKAUBX9B/9a1OjFDHRXqEpJ0hl7rgj6XvCZ1LUgHEkOP4sYCv7PEU2cawDo5LVo4Hfw8zc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: WivseLJ1MsaHG9tM-nOTtt2rh3ZaQvTq
X-Proofpoint-GUID: WivseLJ1MsaHG9tM-nOTtt2rh3ZaQvTq
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qedi_abort_work knows what task to abort so just pass it to send_iscsi_tmf.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index f08fe967bcfe..4ee1ce1dcdef 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -15,7 +15,7 @@
 #include "qedi_fw_scsi.h"
 
 static int send_iscsi_tmf(struct qedi_conn *qedi_conn,
-			  struct iscsi_task *mtask);
+			  struct iscsi_task *mtask, struct iscsi_task *ctask);
 
 void qedi_iscsi_unmap_sg_list(struct qedi_cmd *cmd)
 {
@@ -1428,7 +1428,7 @@ static void qedi_abort_work(struct work_struct *work)
 	}
 
 send_tmf:
-	send_iscsi_tmf(qedi_conn, qedi_cmd->task);
+	send_iscsi_tmf(qedi_conn, qedi_cmd->task, ctask);
 
 clear_cleanup:
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
@@ -1454,14 +1454,13 @@ static void qedi_abort_work(struct work_struct *work)
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 }
 
-static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
+static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask,
+			  struct iscsi_task *ctask)
 {
 	struct iscsi_tmf_request_hdr tmf_pdu_header;
 	struct iscsi_task_params task_params;
 	struct qedi_ctx *qedi = qedi_conn->qedi;
 	struct e4_iscsi_task_context *fw_task_ctx;
-	struct iscsi_conn *conn = qedi_conn->cls_conn->dd_data;
-	struct iscsi_task *ctask;
 	struct iscsi_tm *tmf_hdr;
 	struct qedi_cmd *qedi_cmd;
 	struct qedi_cmd *cmd;
@@ -1501,12 +1500,6 @@ static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 
 	if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
 	     ISCSI_TM_FUNC_ABORT_TASK) {
-		ctask = iscsi_itt_to_task(conn, tmf_hdr->rtt);
-		if (!ctask || !ctask->sc) {
-			QEDI_ERR(&qedi->dbg_ctx,
-				 "Could not get reference task\n");
-			return 0;
-		}
 		cmd = (struct qedi_cmd *)ctask->dd_data;
 		tmf_pdu_header.rtt =
 				qedi_set_itt(cmd->task_id,
@@ -1559,7 +1552,7 @@ int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 	case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
 	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
 	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
-		rc = send_iscsi_tmf(qedi_conn, mtask);
+		rc = send_iscsi_tmf(qedi_conn, mtask, NULL);
 		break;
 	default:
 		QEDI_ERR(&qedi->dbg_ctx, "Invalid tmf, cid=0x%x\n",
-- 
2.25.1

