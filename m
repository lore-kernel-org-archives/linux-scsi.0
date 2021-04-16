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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F7B2C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BB6361158
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbhDPCFs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46696 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238050AbhDPCFi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G24vdo179034;
        Fri, 16 Apr 2021 02:05:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=/AmxtKfrrWCb7CnO3FCn9o2o0AouYFIz0f5+lqQ+M8g=;
 b=Y7kcy55fzJUT0nzJ45gWMqOsew0pfl2lYF2AxVk3EHrbdfk5SGL24RObCyEW8wl4Yu/w
 6It/PolUpXM6OtJ+v2MDGlMywDXcyaO/77zon0v7SPLlE1Ij6eDCYI2tBROmm3FGn6u5
 9RhSpWUfhpYMQ10OUSoI8okORxT+n84nteyaxgn7uRqkxti/uJz53fU2aygXXXyLD01Y
 4/BEbdnNxOmyKtfTg5NAu1cE1+l/NtMW0gG5Zv2PEUHEuRmQOvlQXO/4Oy+Ky5SNZo/T
 L3MRBO3Ep/uHFoF6Bi8/Khcsx29SYnq2XuPUHqVSsW2uJOTvQBwSgfFT8iPNhO5gyoqO bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37u3ymqn0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xofP008598;
        Fri, 16 Apr 2021 02:05:07 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3020.oracle.com with ESMTP id 37unx3sp47-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4QytCye8GKIzvZ4xLhQORsunC81dAvWD71dr3BYyABfV4NqooWvON9jRrf1BOxkOC4IGq9tivygK04yYMa7aeEF5soD3BWrUVVAy4qts+Cjco7ThgxEy67toOb9T0CjDhdS88uRyR/MLQ2HPFJalWGrCI8MhbmOuyFFyRA17VIdbtDYT+QsjAw3xiWO13P8J4tYOtUF5giIkb1xvGeM9wMgkr4RUPDQAwXBeQ9XQh30E/caUdBKaaDiAyCFCAYF1nPL/qVcQ95R8yaGwAJE83ZX7sL1n9YYjaNW+pfch45nQTsv8Wj0n1/ZvENFHLkLvLl7v4zzotpuJ/DcqbEZSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/AmxtKfrrWCb7CnO3FCn9o2o0AouYFIz0f5+lqQ+M8g=;
 b=leGqLu8FZCMybHUY+oXv26IgKw/pGbAPCqQ/+Z7+eX//RLRY8CkYXaM5mYN0XD3Zvk2SmibIRsIdFarOh8Y1bKlGffmsOVOtHdUy4e0KoQ9Poe6g1um5ZdA/eNCU4ZS1ZTn9MV1UGa+DGLy1waDf96GXmzTOzN8drPNVCtx72AhOi+/d2S6FkAxNk6x01yqrssPkaHQi4u1xW9Zi2iVVIKld+EHzACWy2pywbmsF6D8StNPFk3PmBu2/3plkoBUAeTgd8akf3iy45B41BtdqV4OtcNlUL6OCSskxeAsaBOSIZnih9korI0uftjBwkgIHQobRhTxFPLA4JHOHgLLL+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/AmxtKfrrWCb7CnO3FCn9o2o0AouYFIz0f5+lqQ+M8g=;
 b=fVpEW43v6e/KbCeeXBmgo9V7+93vaTw6J5xuJlsyWFNCg7Dp3yphx9IPilLLLhLBsqlmC3sM08V8wGhhjHVCa7780wquxhSs8CcA6rZDLk7heU6O3wHucUNsKPD4C96bAd76IQ1P5ARZ9rk+Whny/ULQ9zdDJfIIQ8mibcakdT0=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3318.namprd10.prod.outlook.com (2603:10b6:a03:15d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Fri, 16 Apr
 2021 02:05:06 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:05:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 15/17] scsi: qedi: pass send_iscsi_tmf task to abort
Date:   Thu, 15 Apr 2021 21:04:38 -0500
Message-Id: <20210416020440.259271-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416020440.259271-1-michael.christie@oracle.com>
References: <20210416020440.259271-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0100.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::41) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:05:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f51a5ff9-5e9e-4b67-577f-08d9007c0ddf
X-MS-TrafficTypeDiagnostic: BYAPR10MB3318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3318A778E11CA55A6F979C60F14C9@BYAPR10MB3318.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 61+nHtv/YoZXHRp3+mRUYwEFOp0+pbPrv/+TJaXGYfQQaVSuePQg9A/hY24BeVltP9LliBkGVwJbF6vukoKsoJmgHv040x63AKcBjMu2yzP6Ig1txWigx4b0Nc+6ffz5QRS9NzoIVK0q8/154x7KpppDxF7JG4PU7HN+fHKxYGAg0ErZ7RmDR00u+ncug2jG3/O4vTE6NmJ1I96v7IcygTUozbinRR+YqYOySaKNB0XHISnRNkTy7TYvMc+2jCx+IixXj9LUTXhZ2XcH8aOzhtbed3xsFu2hc5xyeIctpSNWslDoh2yNmGQL+V4ciGJI536caQ27/717dSO4B+OylW8a32/dVbxWiyg5FkILNmBMRSna02f2bDbSAgxOouZ2NPjivU7odVDMSH5VGfhyyy4LVz31vciUlKCOB+qN/ird0YVRNaVzPG7lBqaSWdTNfjuSIrDaCUjj80h/8gS9Vha9s/nWIYzz6pAMoa6WCNGzWo3LeG2vBJNvl2HjpyuHrOCqI9sp7+D/XA2LCOFhWwQ7f1mOEvK0kg9CEzN2TOggfBYQKfSaisc4K7zbvWb+wTb2L/N7q0j35PMTAxK8LSjRmLHWcmAe7QewCPoYDdYBEEViLTKNm5v5w1ap047uq0cFEawGW4VxBFCXF2gS/NW9oywN3/iNNGdUtC+pwtwv26BF1jPjnp99Xi0JYNX2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(366004)(396003)(38350700002)(38100700002)(52116002)(8936002)(6666004)(2906002)(107886003)(26005)(186003)(1076003)(36756003)(6486002)(6512007)(6506007)(8676002)(86362001)(69590400012)(83380400001)(508600001)(5660300002)(956004)(316002)(66476007)(66946007)(2616005)(4326008)(66556008)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?s/c7E+gSLbQlOINQWSpa+9q/rHNXp81VljP5uN9Ggtb2ooPr9hYMLHZy6VO9?=
 =?us-ascii?Q?XlSzAMfNvH/moqJKQRMOV5aIr9TQBs37coGXO7nLrQVJl+dnzPzH5NSw8mpc?=
 =?us-ascii?Q?DrDYYPJruVhLbWgDdvN3LL+073xmlM4Wpbtx18mg2rAIFlMEnX+/eMJfwh50?=
 =?us-ascii?Q?xD45phqzzd90rmykzBjW9hk1IXbicC8U3bmLLMzfa6XZ0uq+nBkpousHkMQG?=
 =?us-ascii?Q?Wvn9bp4yZ8Sny6lH7jSd/d4SPahXJTIfOwBVnAcTQ+2vLCB2sLe0iA03TrWB?=
 =?us-ascii?Q?5EoJ7SwFBYYXUMefwdvOA422Mxan8fza3hHsjNYelYys5W6BJs3P5Tpj3FJe?=
 =?us-ascii?Q?r1bN0skz7bUK4ghRQdUeuMi75gxLeHk7n0kgFFAR97FjnQkhb5Gv5VJ2lGQH?=
 =?us-ascii?Q?k6Pnt4Gt9lcilUooQkJj68hP8jXq5Df9zC3idYX4VJo8uxY4s4ia/VXzNxZK?=
 =?us-ascii?Q?5oMOULO8cSP5DBleWHvyV3+6vjfq0zs4uPMeEFSrqPqzVV2cqsXhTHU8oFuB?=
 =?us-ascii?Q?bXA2vk8jhBfByr8UBSzkBf3cRi7UF/YOOUpTTi8dgYTXTkRpJm2lP4+FjomJ?=
 =?us-ascii?Q?xdxOW6UonVoxD9YGuJ4J6xqGviQyt1UJuDsDDg8XJDBaLkpGL9f/kP1NNW+M?=
 =?us-ascii?Q?PMvr0e4O90zgBoNPzonJrNLXFZglLRrAgYXGaYSkdeGuMCgjsy04LkkR6fJf?=
 =?us-ascii?Q?jEy7hdZ6uSNVvwT++nUVNjgPeadUNyYCMU7X7q/KEd1yubtz6l8aFQsNdsPU?=
 =?us-ascii?Q?HQp4izAW0vm7tFfr//APKbS5qXt38afejbmPZ0ra/xYz94vSVI3ubiVYj5aX?=
 =?us-ascii?Q?PBQauxI39A6+FuS09bZqDUQr9lW1Jcc7BRtzTWHJox9zpHVIAD7+B/6AHG5H?=
 =?us-ascii?Q?x+I4EKCtWlIIZw80/F/QCcCzNQROUD2QcDy5AffnBlwr3RzCAVUdBAv4XNRV?=
 =?us-ascii?Q?D5Q1wfdawvqBWSdTF1ETv7woTbs4OyHLJTlSARja/2kDeJyeMc99IzVadQ5F?=
 =?us-ascii?Q?uST95M9CSNLx9RFpJMHiYMMAPGlHw02cmjCHJyMSgDCetQnQMtpi5L3aS9H5?=
 =?us-ascii?Q?nO0NL5vPuRoYi9L6mDtZJCssvxG3maqUczVVf+N0ATO+L6cNPAXoN/bHK57n?=
 =?us-ascii?Q?i1LEfeALGuqdA1RJ+U6JVhFn4QPfmKJpxYxDxe+MwqNNfg92EllsIEU2Qj8a?=
 =?us-ascii?Q?5x5cHlpc7U4fTYg930aztVXWaLanLvfT/JO6BqgViKzY0+Pc1xFh6qL/1KpK?=
 =?us-ascii?Q?RZoUqE8AGcyDQK6byDiC9J2GA6U+R6q2IVGzBaztgDgjmwO8HNqQGo/MYc+5?=
 =?us-ascii?Q?FbE9/RO5XOJ+ahBhXOu/xPJC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f51a5ff9-5e9e-4b67-577f-08d9007c0ddf
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:05:06.2259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8etKTk3dPghhFdYgcmRSMp7fqwB1iXluq/EKKpT9AQrjbaerYNRnyQCGQDuC3s7SGSi1noKKgS6fCXEQEJ5dPsqR48cNZW9Demi2CIo3MHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3318
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-GUID: dFq78nRV--QFEBQWQ7ehf92Yjgbcnx3w
X-Proofpoint-ORIG-GUID: dFq78nRV--QFEBQWQ7ehf92Yjgbcnx3w
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qedi_abort_work knows what task to abort so just pass it to send_iscsi_tmf.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
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

