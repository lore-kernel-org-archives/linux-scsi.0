Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24C3C43460
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9BFD60FED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbhDJSlP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:41:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42038 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234973AbhDJSlK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:41:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIZwsD008642;
        Sat, 10 Apr 2021 18:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=w0HA7UqT6k3/ksuJghq7+bEeq1DNdPcKwzi2lDbGGBU=;
 b=MQbedMxg5wB6mLZ1xXB/LeEIaA2V/pa3yvpotCKsNVMIEpZLGthIDS9Et6kmN1aCW6Fb
 6ybqUk8/gIiAmwPwgEz/rBAwXHelucgQh6wums4qjV/jeTnywirqZwWip6La28wcT8Mm
 sK13aLZkaW9SNwKScan4MTecfk2142qYgPttekCgM7fEk9+OHvXwa3Ygu+37GzJzAf41
 qbl6xlHfJ6ZLGUPksJwUDXDuU3RomuMcuXxwMgYcRzw7IgeujQoY660RDMqej2o85Tcm
 7QMRFG3xOEUXA8DQrB4cMrq8bWV3DvQnrAv7opYJ8Btp+2Pk7m9e9iXchHMH2ZnWhidd 1Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37u4nn8r8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIUZZW190276;
        Sat, 10 Apr 2021 18:40:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3030.oracle.com with ESMTP id 37u3g0fee1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGF6uawS6WcK9VCkpVS8HkQaz31LoMdLGqT4Mj5bVZw8RVy6ZDA7SCMowsFLrI62i9/vGsAZeL46yLvhFyuMSuU6Av+t+c+1I/W6fxKbrIAGxN+UH//pacXa5Qsm6NTyNa7mS0m404ZDxs2PYFpx4K4w7E70yzIF+YYu5AKVX63WCRXyl1rXSXu3VgQjTXLb1Rawz9rgvqoVcwVM00Tsb2LyUpOeqLMGNChqsWuQ4DsHuXq/Zl2ztchIhtlNr2zgffdorfgmcPAKBl0e3yOR3UB3O3AYrlIbNpqpGJtNc8fQH4RalNOiG349fi0HD3mCXyHE8nfbuvWhoFWisLnVew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0HA7UqT6k3/ksuJghq7+bEeq1DNdPcKwzi2lDbGGBU=;
 b=gTfppFZ9NDWC6ruHTRmGnYUdME2/Y03E40HP4ARAd8bGRwWLlYupMonnzA9pZTsUIE/jbTn83OSgHsPq5ykgekU7sKzq1Y/fwTWMpNK2sAKa2aKwaYTB5GwhGM3hzEdZkyF15H+58uWpmC8XmD+SWjvI3r8PPaRG87e4egsHgzh96V6CxxqxLPCEVIQ1qFJCX0X6PnTGHgj9oXcgW7d0p/U1v/RJYZBKvqRCN6AFa/q0m8eIcVsyBMiBMMhIrkB0O5AwY3q8EcvqrRzmE/9yYC0zT159PaJbjvYQiK1NJnL4Fqu7KpakcV72THwfj216SYm7lHjLx84bBxr5DLTBMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0HA7UqT6k3/ksuJghq7+bEeq1DNdPcKwzi2lDbGGBU=;
 b=GkK6Vbex83Jyhw8rzY4MpSoh/LUPQw5MPsUeaTklh0tockGUV9GRCMiaM5TeQs9gxDf/j0HpOkNPD4JR4N711rsNryNxyQ5vTjgWBrH6DP9Oh7ZIhrcx0PJlkkp5+uokfO2aaBQMsMNHEbBnjjSNQ8fZnfn9IqU8EBZJ3w1ZlhM=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 18:40:37 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sat, 10 Apr 2021
 18:40:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/13] scsi: qedi: pass send_iscsi_tmf task to abort
Date:   Sat, 10 Apr 2021 13:40:14 -0500
Message-Id: <20210410184016.21603-12-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 18:40:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af392bde-12b8-4410-0854-08d8fc5021d9
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4324FD234511D5DDA2901E4BF1729@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P0Fi4LXF/DUXpdHnQPoA7XQJzyrlkvdksV6OtmUNWmRea+6Fj01BJ3hWbtOwjjriahxXHkVWgd9obwCsvXn4LHeSFjnoKvB9+bIYBpzJC3lL9lyf8Z/C1nr00Y5KD+xzKdQs/ri5/TreQA09KPDWB583ScoTkspONFdkCX8UJC3to9cVqFkij/RYhJ5qOMw3gx/1cwDO+Nj0joScabSKA0w8eP6z5XFB4NTpznoCZ0r4Jrwc3jQK7y+68Sti42QOFPuD2ZsHGEc6vtQ+TeKI0edQJFl2RdyQwHW47BzzKIgLyEAOG8eGpAFOqPMKJHGXZwMdlN0aFuUyAgpX6q6VbrMF4wb4Ww3nqHlSd7OZLpvSJE+B6sMmuFwDLH/rsjcFvC+/YHT1Xi+2DqiA6xEOe7lVvR6ZhRxwSR3bnzQI6rQnRkwpztJkAZuyYdLyUEF+AqsUSonuwrA73Grr4clZTS8dT4QTrrWuDPhAFdVRfrCN0CT5kgEwXyWMzSnv5P9Dn0gadpVB4+9ZFLL+y5gW0Pq+fkV17O9O/fK9Y+UHsseDEZGvc/gP8KLGkUBfrD3Ud1EkMch3ILPx/ZoPNrhepKvqkhoxWzsNy/949QeO1EEk3Ox2g3bF9iTeMPQ4jG1rG3CSoaxbVfpmVMFqqA5yPuk2AsAzTMWujlvGGrfIa2bBZuLPaaCIxbSFlaQArlVH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(66946007)(66556008)(66476007)(69590400012)(6486002)(83380400001)(2616005)(8676002)(8936002)(16526019)(186003)(956004)(38100700002)(38350700002)(316002)(6512007)(1076003)(478600001)(52116002)(107886003)(26005)(4326008)(6666004)(86362001)(6506007)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UL7OptSV0r7wWtqyZABQYLfbs95yXgD/URTK0Y56RcIvmmUzAqOdOuf9DvTA?=
 =?us-ascii?Q?0+Sa0488OAO6VAQEtL8o+rtGR5sVK+7vB4m5+J9VJZcCLxDoQQURGx/6K18N?=
 =?us-ascii?Q?iAgi9TyD94uxEekK+UU8EYIvtmRv1IseH9e0ULhlYU7Lkr8jI53/oM3FwWfd?=
 =?us-ascii?Q?Df2Fqs/yw8lDqfp9vhTeRem7gBVNTOCKaer2PQnJ2hTW+AJXX2vVFmIOdr1p?=
 =?us-ascii?Q?eSMmyPZOrdV2ajl2a/yo52SJ8J/HneIGnbkt/+H1T8fV56UGiqcbVXg6Sewc?=
 =?us-ascii?Q?MoYRAo9ztu+B89aAOGO7p8lv78iYUWB+Qtczd/hDUsvsIPxmtAYfPWSg8qHm?=
 =?us-ascii?Q?zpQ9IMyda4UDufQ6duFzR/Bcmlsjb1fBKSRHbQ1hq1M+FhzTNd8Ghfiy7XSl?=
 =?us-ascii?Q?EIPiXmXJsa1ps+R/n97frK7wGK4bnxFktI1s8AA+XNWTrdOR8pyIR9/1GMKG?=
 =?us-ascii?Q?/MSe+RSN1LfVVYylUaAwolcMho6mIyaOf/0E5kufyXyNJ8xGJiyx9VoOwxJs?=
 =?us-ascii?Q?Wbftn7xVLqM0cZ73tHyJt57trBTXB5oUEnPKUrBcrM76rvx2dwndK9ZieiUJ?=
 =?us-ascii?Q?ENRPbhNoThQioWq1XKF/PXyHpp42uvKnG3Tek7zSNiqhu1/wf6SUqW/0j3si?=
 =?us-ascii?Q?pl3+KUm4jHmFeKVU2ljJpvAOvdpRajr+kBu3zxiNzceWmf5ScLrK3ISfc1EG?=
 =?us-ascii?Q?j3xOAtZ5YKFIezlMDKnU3J1ocv2Xv5XP3HRKC85dNDwqXhWt0L6VCuWFzc1N?=
 =?us-ascii?Q?DZDaSDo/UpkS5KJokvAc+01Hr9t7ndsJ9sFVFqWrb/ZUMvowvAIV0D7jBsyU?=
 =?us-ascii?Q?+odD3XRFYXo4e4bITSq4QkmGgIIOccQA9qzJC/XQ33xmaveTC21lD8Wo3gH/?=
 =?us-ascii?Q?t0ofPHeb/t4eMKMi2bWBnSBiduUUub2/n9U5wMeEAlsbTHGlvjq94D4FD1LG?=
 =?us-ascii?Q?DtwZyihio0FZfgwlJYc6lG21JEEmVehON+d81ecysw0L4W5l8dgoLVY+NDjw?=
 =?us-ascii?Q?Mb4++7WWanBUNAfY5jq0XmzBfaKi45qkaRDAXYvNj0R2ZybTP+UPPObItPGk?=
 =?us-ascii?Q?YV6ZBvgBeznoRtsQquqd/9B+ofKejLBw2L7yFmxWi8DxN5azYJQnH3Xydjwi?=
 =?us-ascii?Q?iNEMkWnxI/k6tTm2hjeEhVpQUk9o1yN97HGSKEqduGsk00q5zIaSFYIPZ4fs?=
 =?us-ascii?Q?x8CIgqJXO6jWQYD6QfNSP0e0nqOJsqSdVk9V0tvf5WT7xANKin/p1dbOK7Hi?=
 =?us-ascii?Q?2gMr011KWJZ7cnYOjPPwf8nC62UlwHxhcTIkGnBhJy7aqTqFqctSR06Ci/6g?=
 =?us-ascii?Q?roHuIonXsjaSXRd9lE0S16Zv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af392bde-12b8-4410-0854-08d8fc5021d9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 18:40:37.0958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNuWeLxIqwvMJzbSjFCEEq9vutY4VpT5nr3KLYP3nJwdSLgml7huRSQ/9LX/9uWZiVEqfoTNU8/qE/YUuBBywrKl5x+T8+jZA2WEDDtm8GY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104100140
X-Proofpoint-ORIG-GUID: 2_zfuriJ27w8q-fU7S2Qj11DkjGI3lyg
X-Proofpoint-GUID: 2_zfuriJ27w8q-fU7S2Qj11DkjGI3lyg
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104100140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qedi_abort_work knows what task to abort so just pass it to send_iscsi_tmf.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index f13f8af6d931..475cb7823cf1 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -15,7 +15,7 @@
 #include "qedi_fw_scsi.h"
 
 static int send_iscsi_tmf(struct qedi_conn *qedi_conn,
-			  struct iscsi_task *mtask);
+			  struct iscsi_task *mtask, struct iscsi_task *ctask);
 
 void qedi_iscsi_unmap_sg_list(struct qedi_cmd *cmd)
 {
@@ -1425,7 +1425,7 @@ static void qedi_abort_work(struct work_struct *work)
 		goto ldel_exit;
 	}
 
-	send_iscsi_tmf(qedi_conn, qedi_cmd->task);
+	send_iscsi_tmf(qedi_conn, qedi_cmd->task, ctask);
 
 put_task:
 	iscsi_put_task(ctask);
@@ -1455,14 +1455,13 @@ static void qedi_abort_work(struct work_struct *work)
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
@@ -1502,12 +1501,6 @@ static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 
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
@@ -1560,7 +1553,7 @@ int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
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

