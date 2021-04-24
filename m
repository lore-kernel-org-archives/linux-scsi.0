Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C5CBC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51FE661370
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbhDXWHT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbhDXWHQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM5LpQ004723;
        Sat, 24 Apr 2021 22:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=RgQABGq+XqacCzfgv5Sdx3p15QKZ24X8dWjfabDnYoE=;
 b=SjNmE/g6xZoRirjpe8ezpsVnaWh/ME8MxJwMQSp5EiKvXzcdWd2X5ZMUb9xep+YQ1FGZ
 AUb0bRn0oqOp3O2AQu0kYjd96d56Ljc5l9NCKQN0aMo0EUj28YmcrdVm1N2QW9R5f/SP
 jI1TlDnqlXo2ynWhP4U4KaeQfAUletUPScdM5MsIXV11uf9MegiNbuY6iQUPGGAFaYev
 4UGegjvxl6AdQa+lb08deFsUtISIfAokUO0jvTM3pHCx2u7EXq3nR16zJsz4alJIXrWd
 Wtb9ZHteuueFvafjXMy//2pcBK0yyKzWB2KT5qnD1T7N6bRCjLB0R3PaMfNxOc2Q/tfi 6Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 384byp0rkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6B80045523;
        Sat, 24 Apr 2021 22:06:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3020.oracle.com with ESMTP id 384anj7uv3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzV8nAqwjh07IOYdF3WMTITNydd8Mw6qglzo9Q59ESXPwccEaImd/OITOoW26gDWNEIQGWd+53KiaECgFrp8jZeZby/GsQ4BavSpWCGI+xP2nMx5j5wa9k9UUCQJvX/dnGG5/Yp7Ghucv6iMzVyhnEdTEqxqvB9cbHvfQQVNzOrqtMqPofninEgKTW/Bt5j8O3ESN7G3QqQVRSiMcWUcBexL5Rp/kMYFbLk95Sjyh/kMP3jZg4spp6mPM45DrpgCHk3K1iE71RUtOOduRL712wvGOHlktShRG8cmYFSfZnUnTetuj0OtyzVwMyQEUSnHvyfTBjD0u66Nb+fYL1ULVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgQABGq+XqacCzfgv5Sdx3p15QKZ24X8dWjfabDnYoE=;
 b=NTd/WVjUhX77iuI5Lm5LrqxbzK78K/7hgX0B4oUs8/2Vmhxn9kvOrohR+6BCO+U0MRtxU0E4vMd6vWRsMwWs5J8dqQ8N4/S9htvp7qrIJpUI1PkK8ZimnXMfgwB7GFS6wqdzueZpenympWINyjPuMq+em0mpSnayb1tdn4NV8xcZCjnlw0YsZoGxCzRUAVxmPbmUp9vmj87r75JKBV2GQutPktZ6TwdLvjAbHcNcw9eps2ravI9Ry5eSI/2hhj+/S56f0DNNuRmlJHJ1NF0NOJXHNU03+Ew+U69nPd9KHZmHiPyyZ1bqO4MMzACibf8ZycjOxMFCCcO6JhK21e0ctg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgQABGq+XqacCzfgv5Sdx3p15QKZ24X8dWjfabDnYoE=;
 b=JHyxAzg+y+Q/D0IeZFOPj660u8J9qDSgyv31B8mndMCxgRYWNbV02IVqNm2Vi9sSJngKwv3eYctodPBlsZf+KX0jvi3KliSyM1nztnN4d32JA+2937yhya83AfreuN5kykF9hZA9xzV+g0brnfnNSYdC/1rzd5JeXfpkv7NbUw8=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:29 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 15/17] scsi: qedi: pass send_iscsi_tmf task to abort
Date:   Sat, 24 Apr 2021 17:06:01 -0500
Message-Id: <20210424220603.123703-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 761bbcd2-a543-4d8d-afc9-08d9076d35ed
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33178E5C89C51DD021C918EFF1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fUodTzIbBc/vxtrRXeD8qBeai1w8EA0p7D62QL91Gun1xdqlqDLChltigjuxB0JcPApNpJVBsBaj8K/uPhEgqPJfV7wAd8+3h5F/491m10mo21m38zKwevgu0Ge2a8WdHd5swi1ik9gjSVCgW0reUIiirWDa249WL5oPQ0PtWfNXhS4WQ9AWHhGmy40OEbWzNBzRA+LKGymbJTT7+MCya4++FaAqRJQqyXFlGaEhHg2nbzfWMVbQh8ILZVtacfPz8xqV7rpp0YypVpI1FqfmpgCawbwnBU79A+CcvOS1ECjdHIWtzSx4BGv1hugjir5wGFa1zgzQzYreqAt1TTTff/YiunNhVvPiZkHO1abnU0CSGwdzi08dOhqU4WotV7UwCzeMCalHTjEk/3LsNhZghE13lJT+wsf8UjdMoaYS/sqWMiSDyN7/8xhSm9w/QLR033GA8rzfljKNtBAWu8thxRS4L7zUORbNdbGvPXegzlHpVqga/uFo5j0OlH1j8t+MdcjvJyhPfV/pJuKtpK8HQALASdYSdLFiZFUwYNo8JeSdvzORy2NwH7wbGCFKlN9N9ut7tXzb7yyzIv5Fku4PgpnlJgbpZKyJaEsoCXC+MOZvGqTfNJCxi7O2k3+gHwBxxdUIt+ExCzntgw6xcpaWfOEL2QcGk3rN2O+M0HtI+i5mdxEpLr0qfPx8en2UrqfP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(4326008)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(16526019)(316002)(6512007)(8676002)(956004)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(107886003)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kB2wMGm8i5noFlABhRsR3URVOd3yP6d0P5CB+NQYTf5uAvZoBovECzta9oYT?=
 =?us-ascii?Q?ia2yXznYsaax01sIVAvT8ovknqMT005LpHqglKmPo2uJBCAjGk7i0KaMVd9H?=
 =?us-ascii?Q?u8ysRgnWviTq6KURKveLzx6fVpR+SqAROwaZEH4P1hNcIUshsn/u/TONjttZ?=
 =?us-ascii?Q?Lby9B0wVEnf/0rLfJfWuQSfJD+7GTZHGUMcknSvhJ/3viiJcneG3tokJ79lq?=
 =?us-ascii?Q?DMuJZs8tryfpYo+rCO9dZWzOhLuT1pb0E7BJYIC3QIEguB+8lVB2TifIvBxV?=
 =?us-ascii?Q?I3KekYyJVH3NxvBt+fWCASoBOGFuo1PsT45ktOCvWh7EJv0Mij2VrTjcr+9K?=
 =?us-ascii?Q?xgJrUBFeDBaUvr7HOfmLgxumpmFHk5g5bhYr+jQvJ8ikaFlovi543VQq+zE2?=
 =?us-ascii?Q?AH6sP6UZ1P4lHnojMm75KsLEwL0T7nofoS0O7KTGRtX52GBJmso4UVduoeNt?=
 =?us-ascii?Q?7Ild5efbGdS6iiTV7p4J99tumazcLDdWYLV6kqVhiG6Xo/UcUgrckPePnXhp?=
 =?us-ascii?Q?XOgmButwtsVI4oIWkNcmYOX6x81H+zz0fFnu4UIk06TsVygw4bPck5w8Evvz?=
 =?us-ascii?Q?/kc+2s6OG205vZiDmLlHuE9naZWUTYM5j4kCI5jWE9aV/v3L1xQ740kZCA+S?=
 =?us-ascii?Q?Tfo37WXAs6uvzftd3D5WFmVfaJxJpUVSwDprn3NXQGpy75VXFT9AxWIQEWto?=
 =?us-ascii?Q?I3KuCMxW7kZ+X8HDjQzj5Gehr1RVopdOfGCqT7X/M7BeXCvJlaZBTWi+ECxg?=
 =?us-ascii?Q?7UsqOQpw/F1KfJxhOb3Xt+lawXH8TAMR+0aUTHhG6eZaIrTNHnVoHt4b13a6?=
 =?us-ascii?Q?27AhNZkFqjmnWkoyJrEKGHM4Ty8p5dinttWTXgTrblkrsxAQBGnOPGq06im3?=
 =?us-ascii?Q?/YepNPxS4usc4PaDn7EjEAEcWzWZWvheVakrY+kiI0v9ZP+KcqE5gJ9xDDwL?=
 =?us-ascii?Q?pWYpJ+17+uZIoIQtLC4/PHyidFzqT3vC9Z/3xutG5rkNP43Ej/lPP+CfqRZj?=
 =?us-ascii?Q?9k7UafzuvbNOupB9ykgXFRHjVWdeMyKJx4vcIpnYQDnc1NK9msSy2idKhQ6F?=
 =?us-ascii?Q?ldVaasdVSBfS6ONihxdRB6W3ncwsGXN12KtS789N4TdYPB/uY//Kh9iZVpVA?=
 =?us-ascii?Q?dOYlvuzBWjkNAV/8QJQhSj3lMkm5cgspNWpX/F8o2t4lgmrsE4cRlMX4ipkp?=
 =?us-ascii?Q?g3l4SEt7YZ8xGBFqJU/G6/3gAc6aeRIOgZLMM1S+ODmD57UZggo8xqfDPJAl?=
 =?us-ascii?Q?rwYTBBD7fu8jOfD9py3Lhqg0Sa+T9bad8gng2xEp2QQ5VvjpK9pTVpfDJl28?=
 =?us-ascii?Q?Lc8gNTw3IsaaBHVGywjACzvm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 761bbcd2-a543-4d8d-afc9-08d9076d35ed
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:28.9123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XR55AB3dYl/rukrZYDJjULlktpy9WCXJfjyGV+2oHgeL+xHmF3E2yk3avT6DtkmlvtGfEzzft2DlCy9p6EWkg+rbAw//KoNHakaDZn2Na1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: dGrhis9FQVE66Cfz_2jmYiZOIDtx_EhB
X-Proofpoint-GUID: dGrhis9FQVE66Cfz_2jmYiZOIDtx_EhB
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
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
index f9c0fa94859d..0ce4bf0d16a8 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -15,7 +15,7 @@
 #include "qedi_fw_scsi.h"
 
 static int send_iscsi_tmf(struct qedi_conn *qedi_conn,
-			  struct iscsi_task *mtask);
+			  struct iscsi_task *mtask, struct iscsi_task *ctask);
 
 void qedi_iscsi_unmap_sg_list(struct qedi_cmd *cmd)
 {
@@ -1423,7 +1423,7 @@ static void qedi_abort_work(struct work_struct *work)
 		goto ldel_exit;
 	}
 
-	send_iscsi_tmf(qedi_conn, qedi_cmd->task);
+	send_iscsi_tmf(qedi_conn, qedi_cmd->task, ctask);
 
 put_task:
 	iscsi_put_task(ctask);
@@ -1453,14 +1453,13 @@ static void qedi_abort_work(struct work_struct *work)
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
@@ -1500,12 +1499,6 @@ static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 
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
@@ -1558,7 +1551,7 @@ int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
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

