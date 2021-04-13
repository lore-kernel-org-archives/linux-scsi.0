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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619E9C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43B176128E
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348757AbhDMXHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:07:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46418 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348751AbhDMXHi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 19:07:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjbiP055607;
        Tue, 13 Apr 2021 23:07:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ZM4/poIFL+++v55SULVeDUQFLXydEoTXfOiDX5KdoxY=;
 b=Y+fVZiSSW46EfpntMwQsKO0etbXCWGf38h2M192Rfsv7EEisVuLYAAabM7JHtWMkjM26
 EIhj+W1Feh9pZpvl+0RGHUD5IpMYOmUeVpcbvGhtRrOj7ROYjhu9Mq8H5KY9BQCoxPis
 g0am7XbU8qO9wGZuJlvvZ2J8MtwqO+OTlY5jFgRpB23c7njd3+odvmOQ2mP6RO3qKCkm
 m7SM86Ap/9guUJCe0fdWvrFyVGZRsjq6ki+urUJI/X4rM0MsEXZ+qZ3lnkIfz1G1CEHt
 4Kwtiuc5l7MN571SjYDcS3DbI2BDp2/OHr5RciLUCZo0sqW8u1gsxK4xA9BSb9A50bo0 9Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37u4nngmyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMiLaw064242;
        Tue, 13 Apr 2021 23:07:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 37unxxgjba-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Va8X7Qsj+kRFoHWstEHCaw82UWzghlYuE1V7wjbWquWVnOrhsTyWsZc4R5yKAM6pA/4JFd/VBGrIjre6croBv2Yy9/5Wq+v2BZn+TN1C7V6O9z6/nNkAkzq874fuk2dWk5OGW/m3NQrTHubPrQMb0OqwNZdEM2e44XPXkvlsjeqGJzXL2GS9BTyPbNmwGgrrDZ2raPl/O4M+bM8cssU3gOOxyI4mrdaniOLryM+53wetdFl+GYvEWRiEWFGPQAPNQ/qTb5Lq3cv8QcnmpRWh80RNNm1H+kV7GCclLVSEK4uCjYKbNA5QwpjKGhKOhL+K0IBvmA0Wr+O82kdvUlpoCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZM4/poIFL+++v55SULVeDUQFLXydEoTXfOiDX5KdoxY=;
 b=dsOriZV5lpnT/QL14/1QADMvZb0O3p+m1Rm31xpGOQ1BdRFmj7j2ZSgWIaFOTLoxmO0RiFSRrdK0SLbbICGoOB36fcLf4TiOmhI4LjS0GCmrErY9wgCkgStnHb2aU0W/n1yBytCuoYOJLobWGnwGGCbvV8VBQXmI+Wu1Dn7W2GFkAcTLWt65C56+iA4DIwdpYZlzyfhDAqPxfuPEzStu1BQeaJ9KBroD2/trce25XdzJNd+Q1VkIqfgPXb5KDGp0xpv5gOrjdPcT/Mb/W6o6lXMD/cYmF+x8DEGv/VdjeavrReqHYRGO79SG/hdzE+NsCKoHhFdudV2XmZppc80/pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZM4/poIFL+++v55SULVeDUQFLXydEoTXfOiDX5KdoxY=;
 b=XH7Wme1oM0WPCLyucN5SB+0DGIjKYtcpNPVylLcCkD5aDOEb2G3sNv+wL/QNhVOmQ/X9pQrZaLGuS8lVC/vd53txE5ac2uYBLpMHJ1eTZhoEau7MeFh2MAisme78OfBdvTZLtUciySggHB3uvVbn+aVQx4HZ3BXBDazOP7FUn8A=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3653.namprd10.prod.outlook.com (2603:10b6:a03:11d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 13 Apr
 2021 23:07:10 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:07:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 13/13] scsi: qedi: always wake up if cmd_cleanup_req is set
Date:   Tue, 13 Apr 2021 18:06:48 -0500
Message-Id: <20210413230648.5593-14-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 23:07:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab0d6188-71cb-4e4f-07f4-08d8fed0dddd
X-MS-TrafficTypeDiagnostic: BYAPR10MB3653:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3653A6A2504637F83D9BB8B2F14F9@BYAPR10MB3653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f/sJwJDpHj7c16E7N2ZZK0PaRztwAJREsDiEN7ISRWnz8G0lIodurtyneRo9aB2wxrRSBt8RpP+Mtqr2aQxwvSTD/gxGglknkj/NnwFMPCd3X7J70QpufJvc8XVV6wGhbDv9lQuHTSH+gF5hXEVTPsiRicp1hBRFyJLuTYRz6juStRLUS65vZtppfwQGXJHuzTS780es4+l3yXextBuRFST6HLOBDsurLhprDxMxNGZ6dC+/ZDunpcVJjPzB6Yg5hjDH/3F9C7ajVqSLT4lObspIObL5meXJmMzHMSMGjr/W/abX4mdt2TQJBDR9lkqGQVcCKchk3lEpaJzRvu05hee1tCP0eXfPKIo/REDh9xoX7XTUG4fxm0kpT/vwZBYAr/CR8OKc2m0DCT5nYI2vkjP5EScys/IQ+AMsbqaiR89JHT01gOQVaQwgYfPldlfD6AxI0K1MTniFxIjQtlkbKXg0dH+NplAqGT2hGnu8WKegCswrWa2789yvILjtijMY9hSIctob0gcjrBzPIqtjT0jSju2d5LcD7D07y86aXf++4F5lRAyQYGejIpQbrrm1AZ226wKydzxzbJox7HIWUB617vR/a/lyIpIf1Auy6tTEO08TzE6aPl+ZbYTMMS4YmIOURr9ueqpSOH99divgPi3+9ZNUcBUEDIl8HapHThF8KzvPdPvQxZddtZhPzuq9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(39860400002)(136003)(396003)(83380400001)(16526019)(66556008)(186003)(26005)(6486002)(38100700002)(8936002)(36756003)(8676002)(316002)(38350700002)(66476007)(66946007)(4326008)(6512007)(5660300002)(478600001)(2616005)(1076003)(86362001)(956004)(52116002)(2906002)(6506007)(107886003)(69590400012)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dGnfKnQat3oN+SrGcZI3/yatonJECl/bpdZR0Ufm9H+E/WqgQoRsXEaw4Wd3?=
 =?us-ascii?Q?wW9lNjFj1IRAOHBsvlnwg+yXgEbIj4fkpg/SPeJ6gsCOJr+gZfe6w6Q3pqok?=
 =?us-ascii?Q?+VRfm0utpkuYwxHN/qUSMVAkzlYI8ypfeunBfKRB3HOfO4pP6QWTUFNMCkbp?=
 =?us-ascii?Q?2Tjphls8r1LSArt5sMkQ4m1dk4mC8Bjw2qpmvarA+8thIreo1tagZLnYIGHt?=
 =?us-ascii?Q?yKudMeWSz2nXXMIgGyPywHfxF6p/Z0Vri41ASUppjm+SvuVjQCwjH1FgV5dZ?=
 =?us-ascii?Q?rDfzt/JGLlaknbaF5dzVFeCBt2X1uGUJRuxggIb+VilDtlVguPn+vbY8fBzv?=
 =?us-ascii?Q?AitFSziswA6CJuVwr7d9sFejLFsbuHc8TnHhFimGH3WXZ2lEX0nEmyd6wRnr?=
 =?us-ascii?Q?EWN9DAZj8SqdJaJMTo6Rwj9JvBClcoHl4dGNy1OvOmTDHdZCtDyTFlT8bIr+?=
 =?us-ascii?Q?7kYwNMkMO8GL/lsohTXCLTM5s6+fT7FwSN8aUZb3sp6odhZ0Nrf5j8x1uhYF?=
 =?us-ascii?Q?cXo1XqH6ZlWyOVWpRrDhgpn3nAWt/WkBP3t3vGUKZzcYixoqKPbFi4xqvSpZ?=
 =?us-ascii?Q?X62PfAgEFJcVvBuy0UGtMUJc4qYW6ZFtnL41P9I6AkRBo2AjXKeDHUlF+vqK?=
 =?us-ascii?Q?9KBs6mj7zVygiVzrJE6k5iH2IabmerA5lKLMaIS0f1rKchx02zPG6z2qs/ev?=
 =?us-ascii?Q?7h0chPEG1vbphgzlzA2Pq8cjXHZXRCQwvpA6p4CyEqqY3bF3IIN0ShAH5kS5?=
 =?us-ascii?Q?T7Vy2uTynVD//KQm1XM5GFlEtULvhKJIM0vPxhVL3huPmGKOwyAu7n7f/5zr?=
 =?us-ascii?Q?f9zHgqWir2W8RCTg4rbGGNZc2ecp7SNkEQfT7O99JIkjnGbZzbySidHHOZij?=
 =?us-ascii?Q?QRzcu2obdoHEcHUZZ6ByIDhf3L0KlP6RHxkbkLqrU7oypaijTJugi6cvJ0/0?=
 =?us-ascii?Q?tN4NYDVjL5s8/1MyYD37YK2bGwQad7Y46Gr0hqk/jG6nHR4MKlIbZJuCJGYV?=
 =?us-ascii?Q?MpVqzp5gAxHGhO5+6o0EIpRrWGkCG7hY+eJCkKj3w9gBpTh2UHcltFDvMBdq?=
 =?us-ascii?Q?8MBStyrEyPr4GUFpd+2evR/DBXtA/XE7+Hw2WF1/7EuA5ZaZxsyDCYrNOoiA?=
 =?us-ascii?Q?FjRM5veYcyIRbgKAjG5Pk/VAPhZX/wlIOsJ30uVDQ5zOVHZIszyCVElQUWwd?=
 =?us-ascii?Q?xj+3uOmu9RfiAPFDszWaWLIvMtGuLOvUKcJxudUFCH9buNpFmCP3jm0SuXHe?=
 =?us-ascii?Q?OY1XWp82R0IE9jdE4Q9sgHfUXpIi/KL565nJxT4Kc8W23EcSptERtKmCqOTP?=
 =?us-ascii?Q?j6s96FivfNgkBxeLKUbD3bNM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab0d6188-71cb-4e4f-07f4-08d8fed0dddd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 23:07:10.3756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szuRe6ev+/OGovDlBDFYLsv0sozAKc9YI2ZjxxKp4DjhParstM9A3gc0wfjFcZCLP3sxXZGuV7wXSODTqKUR9ivdlgX6arz82XQgbSHNicU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3653
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
X-Proofpoint-ORIG-GUID: Ro4cAaWabuIipXB2OhfvLAagvdId_T5L
X-Proofpoint-GUID: Ro4cAaWabuIipXB2OhfvLAagvdId_T5L
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we got a response then we should always wake up the conn. For both
the cmd_cleanup_req == 0 or cmd_cleanup_req > 0, we shouldn't dig into
iscsi_itt_to_task because we don't know what the upper layers are doing.

We can also remove the qedi_clear_task_idx call here because once we
signal success libiscsi will loop over the affected commands and end
up calling the cleanup_task callout which will release it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c | 31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 13dd06915d74..13d1250951a6 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -739,7 +739,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 {
 	struct qedi_work_map *work, *work_tmp;
 	u32 proto_itt = cqe->itid;
-	u32 ptmp_itt = 0;
 	itt_t protoitt = 0;
 	int found = 0;
 	struct qedi_cmd *qedi_cmd = NULL;
@@ -823,37 +822,15 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 
 check_cleanup_reqs:
 	if (qedi_conn->cmd_cleanup_req > 0) {
-		spin_lock_bh(&conn->session->back_lock);
-		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
-		protoitt = build_itt(ptmp_itt, conn->session->age);
-		task = iscsi_itt_to_task(conn, protoitt);
-		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
-			  "cleanup io itid=0x%x, protoitt=0x%x, cmd_cleanup_cmpl=%d, cid=0x%x\n",
-			  cqe->itid, protoitt, qedi_conn->cmd_cleanup_cmpl,
-			  qedi_conn->iscsi_conn_id);
-
-		spin_unlock_bh(&conn->session->back_lock);
-		if (!task) {
-			QEDI_NOTICE(&qedi->dbg_ctx,
-				    "task is null, itid=0x%x, cid=0x%x\n",
-				    cqe->itid, qedi_conn->iscsi_conn_id);
-			return;
-		}
-		qedi_conn->cmd_cleanup_cmpl++;
-		wake_up(&qedi_conn->wait_queue);
-
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
 			  "Freeing tid=0x%x for cid=0x%x\n",
 			  cqe->itid, qedi_conn->iscsi_conn_id);
-		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
-
+		qedi_conn->cmd_cleanup_cmpl++;
+		wake_up(&qedi_conn->wait_queue);
 	} else {
-		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
-		protoitt = build_itt(ptmp_itt, conn->session->age);
-		task = iscsi_itt_to_task(conn, protoitt);
 		QEDI_ERR(&qedi->dbg_ctx,
-			 "Delayed or untracked cleanup response, itt=0x%x, tid=0x%x, cid=0x%x, task=%p\n",
-			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id, task);
+			 "Delayed or untracked cleanup response, itt=0x%x, tid=0x%x, cid=0x%x\n",
+			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id);
 	}
 }
 
-- 
2.25.1

