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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D2F3C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11B7061246
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348756AbhDMXHo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:07:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48298 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348750AbhDMXHh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 19:07:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMj0hJ013468;
        Tue, 13 Apr 2021 23:07:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=/AmxtKfrrWCb7CnO3FCn9o2o0AouYFIz0f5+lqQ+M8g=;
 b=J5Lqufce5y4OSWZ18PNGi93CM6ZNuXPMUpQbvnfQanEW+RUUSowu6Pj0Aa6fnwn3SW2T
 wFxSD0KcXa8qRlbN7kbHUQJV+YECJGir5qpFMYIb/0We55Y5kmPu2k9Ei6XZYBlKcBTl
 nbj2PLyNIeq9Ua/VrPeBW6zM23Pf+31B4LWg9Tvvy7jMHSCo8/HYe6fXAWcesoJ2ZRfe
 n0iD/vQPyYwcCNtncO8bd0RqIqo8IVkmIZ4ckxxCrjQatsx75KC/y2Pzqhh5FYVP2kqB
 Vldm45fCdLlbDC/stFJt3x0LN4RvwztonO17Bp9TPRIONFWt3WmMv+DY5wlnjIH4SYBe lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37u3ergpfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMiLau064242;
        Tue, 13 Apr 2021 23:07:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 37unxxgjba-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1fp6eqtQVkIDfuf4t9ZfP+V79/12Yw3KGwlMDIZMYS91DqJmy3lwpOUOmodManWthAY0/kICS09QIGGvuVvJzXfJvWwPdThxBzEXpjwEbAxBvuAO9nrfNeyQYqLirR63wxBX+gjJ5DpvcWtIyfdjoqIxgU5ye9N04HF9qQfj5h2yqvxaCPNwAmbeP5C+g2hiEAmm6OnMA3MoG3E5VKZcZ8cv29RP+CBj/FF2PjBLJMaePEYf+SNANnSag7k4dPfYVIcEKu35G2mdHxlD2Ka9PRjuOVqhhJXWmKSdlhpeV3u1TYiYt2YX6Lk/ieUi3yy5JQ35RrGtqYncNc6Lqkd4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/AmxtKfrrWCb7CnO3FCn9o2o0AouYFIz0f5+lqQ+M8g=;
 b=efW6RxCwsBaM6YqFRhtVdEvTEly51jPfKFLqNf6Qa0Y1sBD8QmwzOPwH8fmQ49gpl0xs1ZoJI35wOkJ50I3/W7svIPp0Zb2CHbua2+f5jeiSQ68lrYN+VQjak3UnGyrdlWqvudNywIsi2zK9qiTEUfXdwAkfSJnKs6kEv9Ee5P7zN6a+zozHfvcOjPmvjqG7X9TLor/u3tyImFP9dNNP9gp0T98ZuYA75Xi7SCIXhQHuMcJZ/JgW/5nmjUWVvDjT7zSx6R+OIy5f855LdiBaDsKnwI9gQpv+kleFRYiG+cwnyNz5aFfVVkz5t8Ng5lqq/WHRxXSsBYCdbq3GQqy4Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/AmxtKfrrWCb7CnO3FCn9o2o0AouYFIz0f5+lqQ+M8g=;
 b=TJ3E1xQEUbsNzWqpk1XDSGcVGrXDYoIm/hUK4KheRYswLU87ZbdKO8c3CvX8wHImrKIr7heI/osr/BOYKAELFg6Jjd0ljRHjr0u1ityihNr3Un+NLBwyqBvDV2RepgnI+V3ngAbFMjGHmuSnldqZo8VSBVIknWsaN688jU/rDnM=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3653.namprd10.prod.outlook.com (2603:10b6:a03:11d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 13 Apr
 2021 23:07:08 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:07:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/13] scsi: qedi: pass send_iscsi_tmf task to abort
Date:   Tue, 13 Apr 2021 18:06:46 -0500
Message-Id: <20210413230648.5593-12-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 23:07:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb247e67-83b9-46fb-eb88-08d8fed0dcc0
X-MS-TrafficTypeDiagnostic: BYAPR10MB3653:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB365333FA9316CCDBB64BAF9EF14F9@BYAPR10MB3653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zw9u+ChkGAHUVc2wek7y3E4Yw2bqAWlFKHOWjI56cW/vNzOaIkOUCwXk00LeuwIal3Sb8nIyJiR1oT/8zzfQj3KfXMJozveXZfoSCbTVgxnOvDa+8HVwp9YorR0Q0YlLzYxIsxLhBhdN9a9YfcRH9TdhIp94e8rE9MiYERJ2BFAU+sl6/OrCnBy9vhypHzVLMa7njaFaEYrogmLFc5zxRZif5CnREN3MEGKPU/223dj2ocZuHfKUMtCmSHv6aPEK4omJUm6Yt8mx9t0LHv8I4AHecPz2JrSWvlkkASPU3fazg5jpdOBRVPmsOLXijko0124Ej4d9Xo27OCjXINl+nbRWeCUkcAJceqE2eCPz8qNzyAH3j97HoxmPq4vWSbg1N0zhv96nwjmxUxcXMQaYhln/VlWo5doe/xIsl7Hk+0DD5GPN4+9+rZfD+Ny6BEY+7PDUstijGUG166DhDMjZFZMSfl0hiBeexeQhp51qbZLuhSj0kTHTv/OBzyuh2JVSdnTYQA2cUUyUzIy6ukWny0LBrJ68iwTr6J5YkJb3JwVg10kwORxOp68FU1wIc+JLjKxG9vu1TuHlc9RBcQNpFcoWSeUs11Mh6tHhHl26LelZJ6Hr8Ib1fNTdk7E3gf1v4QLBlGYJoxuGp9zu2cqVKeDTIPaMixC6Kxvg2SXWud3O/63MMaQpRso2/o4g8a2N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(39860400002)(136003)(396003)(83380400001)(16526019)(66556008)(186003)(26005)(6486002)(38100700002)(8936002)(36756003)(8676002)(316002)(38350700002)(66476007)(66946007)(4326008)(6512007)(5660300002)(478600001)(2616005)(1076003)(86362001)(956004)(52116002)(2906002)(6506007)(107886003)(69590400012)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PXvWeWmTT+Nf0W5/TCna7w9AIxrbPACQlRdRxAqrk7EiHdihoX8bP4isFqEQ?=
 =?us-ascii?Q?XXJRuYqSztNcxNmArPcb0LhVUzAJqi0qBFXLee+sPV/YhWFrE+YlK1Kcq1uq?=
 =?us-ascii?Q?/qKTz2Npv0t+BAtk/jg6qUZK4AQsA0M+DG7+Ji+13bIFE2eZRgQiGlbX95do?=
 =?us-ascii?Q?ioAvCx35DoVRO2G3Zn1tvbLz9qj95FCaiNHPh+J76sJELzvfNDtmxY4W4kPh?=
 =?us-ascii?Q?0A+Zla4X+75B1dIZqH0SrG5IUtNZ3XbwMCh1/GfLqzQ+J5l/tyNXd5jeY95j?=
 =?us-ascii?Q?5uJR1/3+zUeVlVcfy4bqxIp+59pwwoAhsd/OGuZf7htlp+vhXoxe7DtPG3Bh?=
 =?us-ascii?Q?IGh1V9M6eIMVcL09KS02+zlobkG6QSOsGfgN7C6btT/f+NBfAX+iTTdjXm3q?=
 =?us-ascii?Q?4Gomio36kBH+v62fcYZAPe/dHrc0qUF1cynea+cx/4GPmCYoRZVALFf42bpI?=
 =?us-ascii?Q?oxU7vykuXIoVI7jj75voQUTjGxfDXVI0PkOFva0941dNtEEZuT7sJVM+ElkJ?=
 =?us-ascii?Q?gOGVVKOtYzMNy9N/lb//5Hx0vHmyUt5zVb6PzbRJhihQWn54u3yFBhnYoTVi?=
 =?us-ascii?Q?NVjLnqpXbtqHUejPafPA4FIxutD8IO9JKNEMeYKxrrKzZDIOIObMEhwKU0RD?=
 =?us-ascii?Q?hxynmFlWCPkHsWf1nOhwMNG4bOhTVf0hMSuWR6mdknJxaUd2gEUA/uFz1U8I?=
 =?us-ascii?Q?e3ftjQXJ6mPr/HRLhgEpbBuWCe7hPK08GzqoFwP5BgLRHJ3xIxxt+VjACzOG?=
 =?us-ascii?Q?eUuMw0EGcF6HXZOMkF1gH8nCPYXbkJEibG+hzzIjRiLEwFpogtdiNVgRELgJ?=
 =?us-ascii?Q?6domVWEyq9M0CoWIYrGaVQgC4oOCs+P9ge4dsvjCL4gLKLgIy2BZbWcdH42r?=
 =?us-ascii?Q?3D65aSWSNrztE0YZstQmY9Qsg6kRynfhfil/dMGLMmbZEOaiH3hb06J5Q51p?=
 =?us-ascii?Q?OdTmwx/USNEEpvCJdVzbwEKomgxVaheU0UIkd1VIy1q0wnTkUAJxJJjXc5/8?=
 =?us-ascii?Q?1yBUIXsNYICN2oi9Jedt7sIdvv2ouMfXbiOUOBd9J0+KPxyt0EOzHZUXAYwQ?=
 =?us-ascii?Q?vX5ALlXmatQcYoPxkY2PW5cM11NEweZfowNeLtAoeZ8j5sDTNJHph3OgRWZ8?=
 =?us-ascii?Q?QqG6YWju9xCj90i3ls+EHbaljqqXvMX36e6xgGZEU8co8Ypizh/BasvRvfCj?=
 =?us-ascii?Q?INdagpfO9pMIBTMKl7xWbwUkosXuW5NT9Diu1JNnzJtvmYn0Y3Khy5jjuQrd?=
 =?us-ascii?Q?ZY6xo1erw3e/fpIVs5Q8w0VoXPsHGK2/FFm1n5IjyIRNrs2HSPilho472S63?=
 =?us-ascii?Q?Pou0lK7RMq5XgpKDQ4KOMfIw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb247e67-83b9-46fb-eb88-08d8fed0dcc0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 23:07:08.5597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BWz1CzlgUxnKggj0q89mteHI2nmQNtwMZOw3N+4xPPMEomyKu3ygwseTtnag0jiXIy1zn/tWvDqBN1l3LhYgLLVP6dDarFRahVipvFrOFs0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3653
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
X-Proofpoint-ORIG-GUID: WTl22rEFe8tbyDzTeC-OaCioLxs78Dx0
X-Proofpoint-GUID: WTl22rEFe8tbyDzTeC-OaCioLxs78Dx0
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
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

