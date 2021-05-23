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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C09C47082
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E929D6117A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhEWSAK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 14:00:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52014 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbhEWR7y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHusEV181997;
        Sun, 23 May 2021 17:58:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=/b0Y6QfZM5snDlg/YJiM0Da+Gu+sEC+KOLn7VIp1KCY=;
 b=p2eQsB0qS1hD1gznkhdiH1vRPiEFAgeB9VfD4eLNXhvUGny7DJJgy86J2hDzlKL9Y0gc
 2raH1VLmE9BEwqkHtxN6nXgw8y+H1jIz2ObhxiDvQ53sl1FOmSAHzJ0BGVDLLQtuks2n
 tHKr4uMnXyx7O43gK69tXChPIwjO8g66TPESRclCJoiGLGtiq5UORBdE8Cj3HyrRDSfh
 6uaRomMXY8Yhes9LmMDS8tLj2xCVbtzL+TzrFfJ8gAGmANR30YucDKQSdzjCCtBZUWh6
 3nXJqBfvMnw1yg65rjNi5/5ad5AgQhNeTvqdj5rfMNQJ9RDaw7zE2gIJPPqwMbansghe WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38q3q8ryyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHsrMf188648;
        Sun, 23 May 2021 17:58:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3030.oracle.com with ESMTP id 38pq2snq5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbSferluhuZV80hcBIe1L/zA6wGVrrqeumGU7bnJLoJc92ul4dMT+2KPOuk8f+rNh5Z52fS0NXK2iBe0v5YvefG1EtB6EOihAUuWwTGgGBX3mByAse+Ui332LXfbKhdRet/X/gzv2iiXl475PKZDqypJR3XFEnCht/SvOa7IVnM9hnY51IPRineWY1IeNW2DFf9X7ZOEvZTvAw77gsPziV2/xlx4kb6gu3NoTblO2hEfVfBhugIKZR24ZeilG0SJ0xs8S9YlLluVFAUtEFyulD5/JF6vitVbBo4aZPpWLWx8G4WzecP2Eq8MnXo4DXdZCvT/rSLWMj4MAlhr4pV7+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/b0Y6QfZM5snDlg/YJiM0Da+Gu+sEC+KOLn7VIp1KCY=;
 b=WVF5tAexF8IETDNwXja2zB03wYj7kRwbzN5yEXjlczFJz94x1YoXZnA/c3YjibFX2SaqH3t7G85Az9/FiUrRO8LIQjgv2mi6C5myN+t0+PBlyUnamYF4zEXCKgchjNkdG62uMxsJ9xij4ZYtmeM2i8gqPTYoWqj5dkuDTsi7iqodOTJ6cr8aH5/bLZg2p/bJz0QzWU28kLpiAjRu46jo5ZckXtkOEVzUtSMW9Enie1d7VxHf4zzwhehYToV0n3A2LY4SFTDJDHr5qgsmi7jODyFV8bxlAKXTLPIYXJAzRc5pXIdGCIbkHa1o1rXFSYa56T61S7LKnBP0kKKfSUWZyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/b0Y6QfZM5snDlg/YJiM0Da+Gu+sEC+KOLn7VIp1KCY=;
 b=J57sTjrJhtNpnZqL576wxN1BuAPHrFTr/mZjjf9Kl9RGIWLhBErhwInvREIVly6MFHe/uNUq5VdlKUBXEvJhFdwCi0egomwigYK+depd1Rj5lsrFCQBNCLeH/YBooZ5IyKs5wBcuSg1UtXJQDaoXny08arSlf975irB477tc9Lw=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3239.namprd10.prod.outlook.com (2603:10b6:a03:156::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sun, 23 May
 2021 17:58:17 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 26/28] scsi: qedi: Pass send_iscsi_tmf task to abort
Date:   Sun, 23 May 2021 12:57:37 -0500
Message-Id: <20210523175739.360324-27-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e41c5fbc-1089-484b-09d7-08d91e1457e3
X-MS-TrafficTypeDiagnostic: BYAPR10MB3239:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB323914389BE185355446C9B3F1279@BYAPR10MB3239.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aofiCPMDaJkFPtCX70npUzUFIUzzFNHcsbvQvnKODrHoVpS52jU9Mb0MMeq+qkCtnF7pHQTomHoA24+1QFgUxGxVCVynIUhUDaAbUsFfGOC8HI/cvh5lnBXLtchwvxHSeIocG+2Wg0eaii7GBitDE7ko2EdnlLt3CjKdFEvjCKW0MO+yiSwLSjYc8ASwMUE+nWF8S0ok4nCTe11+hpckW+miscfRJOrm/QN3rHKhFNKvMv9/vVb6KoBoSH8m89/kWA9F50qbm3IlLXOjAXRYePRLQoFx5oTmz0a+vvofCdKBQR0EurxNv6l4oNnGN5hPjY8kDq35jWKblF94HP11AHy6X4WXlAwXBRCMlBLYwqNNygJhN0ZqIpHjwTho7yRUojacwfZg5ufXfpT7qZFM3sQTGwYMyWBzY9sNdOG6HUCnOXcbKVXWLZyHdSWwVPIUJ98LH2PFrMWWopSBDdKX0SIzCcvV+t8jV2zvyrCUmjaqboTYCHvhmQaWs5g1S74oAgfwCWv1zyZ+ef5qZ22TzWk60wlEYnCrxKCawGk/ISILJ8FoCSeE8ZWVbNPdlEsUZ9X4ssH9JtrVmLtZ22VF5NaqCKc5suwKQkPF7hvPCE/Lyo0ctqCc69Jma5CBYn5xauChK6HZJhbV8FXB5CBA1rbG12jnC7pRYK9JR+3WfZoNE0WosRwK9/m3nePG/DyO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(52116002)(26005)(86362001)(16526019)(6506007)(2906002)(66946007)(66476007)(186003)(478600001)(2616005)(66556008)(8676002)(6666004)(1076003)(38350700002)(38100700002)(83380400001)(36756003)(316002)(8936002)(6512007)(4326008)(956004)(5660300002)(107886003)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jSn998ocGcBQDrzmB3w2Mjfz8+ZgTr1VWISw8qVJZxwU9yttrjPvKaTIlzSu?=
 =?us-ascii?Q?F2DjEOvouxLuC8vOV3oNJNySa7pqnJZviEaZ1IUspu16pfTNY3m8noaQIfuF?=
 =?us-ascii?Q?aMlVogMZBS6Y+HEq/kl75IDG/oxxhpea0wkREgj/HZVKL55LGT1B5N5YaJ85?=
 =?us-ascii?Q?ykb1JTz701Br4fWy2LILxcJraCjKpQzpkWgWEaVv8U9lx1ROrcmSKL5ZtyaX?=
 =?us-ascii?Q?gEzNlT4IHPBPfGEtMfP2/1Dc5iXnbhTW7oVmn20kJHfp2F0o5RzUJE7qFppN?=
 =?us-ascii?Q?KAZWJ8jAr3rgfOB4umczDeJDegLDgsi0SBR1dlr3pqSvqeLFwiTivYqEtp+x?=
 =?us-ascii?Q?Ep7YmhG94/1btnRZreSESxLfNT1kUKJ2x4P9nmhf6WPgrJduYsNSfxbOdk1Z?=
 =?us-ascii?Q?s/l7moWK4QjW0YxZc4O9sjxRDntHLSeJgvkXJCBVZWPV2sY0mx3KM7W24Nxc?=
 =?us-ascii?Q?QUVRVGfEph5RHsec+azmPA7acoezbz3w/NxHwF9fgi++pp+GN2WTALU+WnNc?=
 =?us-ascii?Q?C/0fBRejyJiWXbzCnZP/AwSipl7qr5YnQ4JS/Dda47VAhloPTn/qyMe6ItyJ?=
 =?us-ascii?Q?H20Zwx7noMBBKWkQqXtfcT3L/djcUAvj3++NpNWm/7poSGjStfU8hqiIgHKj?=
 =?us-ascii?Q?a02IimVtybvyiw6Co1G9X+1X7bvDNfrC1Tv1AN/3OUkliQO7nH97Aa2BceTR?=
 =?us-ascii?Q?WGtn4HqKD5ErroinPUdQxauX87cMXFi9rCPjuQa+ouIHyU07fDbN33id1Ows?=
 =?us-ascii?Q?vQqBsP98BYzxA+grcLes8Qlf6c1MkMESVM4KmesAH0FZAk1z4S9ClQccb/Uu?=
 =?us-ascii?Q?51uhVpRlIeWiqhIicrFUGLgysp4Nv1Wz2OvJdbNskMtg//cWbbalSfRyDad8?=
 =?us-ascii?Q?pE6iI+AjtGW77kojr/mrvTeLU4vd/IdRMLfyZfTEnl00xSz+Z5hT1/h2pGDX?=
 =?us-ascii?Q?MZf98NqjtsBWi2tQQlqnSXH3zI3np2fNGIxYw78BsSnZdQip15rgw+CTSkvd?=
 =?us-ascii?Q?3W+Qr3g/UnDa+8gCz+cpTaQq8x6r7PFB1yAgmaYwXRblIv6OmQl/gLt6FGkG?=
 =?us-ascii?Q?uYCEZIzOVd4dN5sUvsduN1HgF/c4a22wlOSD+U6bJd5tRn+688coEN6vOYP7?=
 =?us-ascii?Q?u6HWyuqGzdPN503GKBTa1AS8NN1gOafYeXOYhlE/PgAxfdEfJSKQTjjjsnpV?=
 =?us-ascii?Q?1IFhjdw0vnxVOS12zx/7jjO8v3Z73R2nwF3w1BHs1+JZ1mXxejy0SVbmwCKY?=
 =?us-ascii?Q?BenLGZAGafDg9WKAR550nkzjXOdtwYnso1ccMCAMEi4zHtjZE5pCeynwLZ/w?=
 =?us-ascii?Q?JTmRJ/nvBm2cm9wm5mxX3WzM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e41c5fbc-1089-484b-09d7-08d91e1457e3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:17.4041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBGPh1zy2PQvqIfluRUvBUZZjXcjt8kSeivb+7GwvU070MBADyVS+HTAj8ReYIANXUUxJlgpw8P7r4DczDwMwvie++/geGd6+mnYjxfXc0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3239
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
X-Proofpoint-GUID: TKmSPCgv2G8UWYDUhCb5iKMVzmbAw8ge
X-Proofpoint-ORIG-GUID: TKmSPCgv2G8UWYDUhCb5iKMVzmbAw8ge
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
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

