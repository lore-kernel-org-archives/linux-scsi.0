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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5000C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B948161244
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347820AbhDMXHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:07:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46374 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348741AbhDMXHe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 19:07:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMj9wt055503;
        Tue, 13 Apr 2021 23:07:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=PUX6Stv5NxY0MT+rbcvNoY3vVaOd+2fYyROjMBmWJ0I=;
 b=tDHEWc+gpGAKR6cCpdpaTOXsxaFWFk5ygDRRELX2OcIIkXW9vK5jStHCwZqVgjguJ1Jc
 H8R26PeY6WeSqOUz6Br6t3F4h8P7SHMVAjv+zW1BOgXHUJWJhk6LM9do1zdlTEg3wd38
 7e52AajLG62m4Zqi5vjL12z+D1DvxGzCHhr25OL0osGdHMaINDW4gCLwPJWAa/vB2xiP
 luD+ZyKN4N+4yJUJ/LZay6m2fmWlloOm2CYtmlv+ZXB6Q0ClYCRjYzgJHRx4NgCs7mR2
 YZvKGq6CAXTHlGEeQMSDF4CB2WkJ5iNqPhmQu37bTuVh6tvga0f9IN5vOu7GFtPsvdvd qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nngmyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjgku142878;
        Tue, 13 Apr 2021 23:07:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3020.oracle.com with ESMTP id 37unx0e1jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eAzi55BrcbZgRFLy5ei3kZZZr+hYXSjJDwCeCYm2K8kAz0t3IWuoQIZjmdRlkGxCvL5kxedSUhN181dXIGffaFtkjRj4XlEs2qj7CEqAtNCTPyLxFZixQIHytL15MZhmx/JGUczQmI8O7wHVeoaUXReeCDtptm+lrAyGZkIhdF+7hGnARjobFv5gSvVqd0YkEpRtCeqh5N6pJBXG4L8aAVSuSp6EtV2vCKLvEKwCShRf2qy0Vg/ByMqGXnbEryO/Dy3r1fCwORsR6W4ltwVreqEAIWcmo/ZE0S7xVyCVGgKCUlCg2K+Pns4I6TtsJ6CejGahpxnNs6n1Uy7FzsPxuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUX6Stv5NxY0MT+rbcvNoY3vVaOd+2fYyROjMBmWJ0I=;
 b=ayQ4A0jB3vJ/jgS8BxVHgWaRIdf0yJmJ/gAIfukZCAahz4HU10Iyv2YH6ao2uo1ryHrrWRF3Mh3xChS3aHuMNMSXM3m2GH6Ft/Fz7hgUfIX4RGwwi+w80WC4mwRtfM3Wku3FPgffhr18yN1neCXeFrEq2r1e6DfLJSZHe2pKcYv1wF3I/wF95YKpN6b7Zxe06VnH5BG907BtC8loRnNW7w4B0A0T3XZjObgCBo5tOdvF07+lKxQkda7IsutsCWas9gfr7DUrHNeSA5aWmPlRb1CJQDUsKBxQo7AJfCwC429lahci7pHeQvjMHD90fAW9VVuyRWD7kmyN4rfxaiNqmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUX6Stv5NxY0MT+rbcvNoY3vVaOd+2fYyROjMBmWJ0I=;
 b=JEzt4r9nSDHGhrECruDdoS7MlqdrmBfyrGGt+oz6uMzPoEOFNzE6n/DURdFJ83gdMqWHPWzn77OlwOHEKMpn3oYc2zO1k2oiZQe4Se8KAM1BB5Ku68U7OJRVpBHEB6Cjg0ahsW5uJgXibh5q3uIfg1o0c9ULijtItY+cLLPhv1w=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2469.namprd10.prod.outlook.com (2603:10b6:a02:b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 23:07:04 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:07:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 07/13] scsi: qedi: fix tmf tid allocation
Date:   Tue, 13 Apr 2021 18:06:42 -0500
Message-Id: <20210413230648.5593-8-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 23:07:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56024905-a3a4-49b8-2b51-08d8fed0da16
X-MS-TrafficTypeDiagnostic: BYAPR10MB2469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB246967470E989310BA4AD1CDF14F9@BYAPR10MB2469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q/RRieBOXKC6Eh8UlTltpDb+2QfFEOj47e1rqVdGIv8bzeLPJjM6j6psj5bUv5GUTSTtW4RF0dFPJJtLRmp1xzwqtlAxcYIHeUCLf7kAMziGnAaYSN0nwJieq69XnhVH7DeoX1u5lgoYXRN3I3DWwT2k2n2eFZ5Yq+OsAIa4E16+C0armU+kKTXEsDRtoT4L2GrD45waID+mDzqse2BSFxEXeV2zEnI/coX4AdSAhkHrrvKUbvs79poUDwykNcp8nK4ijsYZKPjGf7qMmoeFH90aj9V3PGlEdzqku4l5FVHR4PoNlVT/toXj9uRnPW9cEx6zW03JNo7ZgaDROl2XRYJp6GrxNV8LpnTpQTXJ6CRNmRNgzQhEjNA+beH9K2Zyjt4C7knoAf3mUaENWyVL3BnguOfsxzwjTmDtvAD70rmDBcLtxLInf764KON4sw5Ppe5CmbMHahWzP1U2weJhxqxYZ+f1JbdJIhgQtyYnOyxvFRFEJsGHvgpbrL/fM7CiAtwr5719DCgbGJWDXz8xtOONPJUg5UuhkTH1zZR5XwXYZ8g/P+ar1inntd2evkV2Xyj+R0Qdnc/MV51R7GnLiBRhOhaUlQZh8gG9pR4TpRZWfyomvBZHZ93Xl8Jf6NjqBOyZI0p3uQ9XllxLA5MgmCvLWk9B0UnolTrAimIWpbVvAEC59nHmdXMzoRFrMiTY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39860400002)(346002)(376002)(52116002)(6512007)(478600001)(16526019)(186003)(2616005)(8676002)(66476007)(956004)(69590400012)(4326008)(6506007)(66556008)(86362001)(8936002)(6486002)(83380400001)(107886003)(316002)(36756003)(38100700002)(6666004)(2906002)(66946007)(5660300002)(26005)(38350700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gagPJg3oVn73OQzHJwFNRqSxdTcpiWXv+s/4f2C1dKnj06KT20dJ0pwiprkF?=
 =?us-ascii?Q?6mbF8K7XYHuWisBEdn0W5LRhpENg0ll9AcddI6IOsp9ngA3N49dNYPUMLWik?=
 =?us-ascii?Q?SE6hLO3XVR6gk9c5APL3FFoXok/PkhcRmWHU4Kd1jKmfNKzxMi/IvuF05gXg?=
 =?us-ascii?Q?XWRCtIUgqpTgj5mqKAJA6nOzkqOmGLKoJryIZYQw81SJQDmp2bfRaRCWzTT1?=
 =?us-ascii?Q?5MKV6QEVWRx2do3UQQtTGRiosXUk7RW4HhxhBGbMmrYyCoPGnPPTsmjQo5K3?=
 =?us-ascii?Q?LIUlpcf+S+sl6CoBimD0pR9ngSJWUBUTNQIw9S/hmzfeP/B6xUUXcSh4mKHy?=
 =?us-ascii?Q?mmbiC9WOxg8EGwhCR4fKqTXuxg55pcbsQ4JI925M3qMnmrmCQ2ObOKUqm5T+?=
 =?us-ascii?Q?r/TXtbHpgy1Dm+D8KQpvYdEPrpINp7pgcPL2Dfys9pbGJaCGWppgDEKeTpyJ?=
 =?us-ascii?Q?FIjx3AffDFgnuTe2hO1cqnHW+0Wk9mz9xpthSBPfUkW70co3wMhLVPI9S+rE?=
 =?us-ascii?Q?1OogWPFdzXsFOAhkrRkJ+kNdt2JPz/kVTiZ+1K8JLn6QUQFKoZ1fGXZn2r/V?=
 =?us-ascii?Q?4IGQqQbR+Yry00xAyjYZGnFawpE8VYdQqHx+yhihkJtDXEJR1Xss5gbSUpDs?=
 =?us-ascii?Q?+ZvtE2C4N8qz0OBwESlStrfmomzvrXriYtpD5hvdv5VQ421+6cQ1AwZk+xpj?=
 =?us-ascii?Q?I8iYbvEZwltyDXfZjMKJlr3JWoYMD7ElDGD8hF4csNaZ6n/7rLIYNLQ5AhtW?=
 =?us-ascii?Q?lQzVSEKdkJdFgt0627zeKkFr9CDc71b7zIn6cBum0Tg4/oTgXTcHJkVrc20k?=
 =?us-ascii?Q?DJNSrYMgzv8tC6dUDT+KUKWfWn6DHPvyQWjmNaCLZFUU6DyOsci8nXXrqpXe?=
 =?us-ascii?Q?38tHJEl9Y1sqdGKmDSnsKYmuzxb50QUl7qn9GVtmg3qnb51xd9CEbRBfttgm?=
 =?us-ascii?Q?p/Lzc3zChQ6gqu0e8olY/XSOrTVoU857puG70LR204wdZMzuRL8JXmak4FdS?=
 =?us-ascii?Q?a5p+nISbmaBy0Q6VWe+qX3txHT9zmvLcOCeNIVgXFSTMawwxurlHGjpM+Ezs?=
 =?us-ascii?Q?R4jVIAAdUM+C4nWPON81TFaI0nFYOT6c7A6Xz1+S+rVONRygIoj7m1FAcFKF?=
 =?us-ascii?Q?i3Q88GH/oJBWo11d9b4NO0Fw8yrhrm0EG9qdrUZpTFDwMDx9HXdb8IIkeACf?=
 =?us-ascii?Q?svyVyy3AEiCwwsYhmgF53l8KR8C3NN4N5S6oNUX5c4aLIA32g8PLt3YsvsGp?=
 =?us-ascii?Q?das+eM59hybhgXWxFLRtGchG6EvwEJcJx+/6+VqRIrPdL8ZD+f4ytngJRLiq?=
 =?us-ascii?Q?A8iMTZeK0zzR+P0E58CI16Rq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56024905-a3a4-49b8-2b51-08d8fed0da16
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 23:07:04.0902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HLh+cESSOhCC9UzU0doSHnYNlNR2TJSHh2/I0mG4w1w/Yhj5/AUCfBy8xFxgRH2fJn1IvrbpRlMTspup+eYd61Rduid5KKME8aX67H/Zr2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130148
X-Proofpoint-ORIG-GUID: y77Sf-ST1fgT73zLJUTaz0j5-PPHyrPb
X-Proofpoint-GUID: y77Sf-ST1fgT73zLJUTaz0j5-PPHyrPb
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qedi_iscsi_abort_work and qedi_tmf_work allocates a tid then calls
qedi_send_iscsi_tmf which also allcoates a tid. This removes the tid
allocation from the callers.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 76 ++++++++++------------------------
 drivers/scsi/qedi/qedi_gbl.h   |  3 +-
 drivers/scsi/qedi/qedi_iscsi.c |  2 +-
 3 files changed, 25 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index c5699421ec37..542255c94d96 100644
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
@@ -1350,7 +1350,7 @@ static int qedi_wait_for_cleanup_request(struct qedi_ctx *qedi,
 	return 0;
 }
 
-static void qedi_tmf_work(struct work_struct *work)
+static void qedi_abort_work(struct work_struct *work)
 {
 	struct qedi_cmd *qedi_cmd =
 		container_of(work, struct qedi_cmd, tmf_work);
@@ -1363,7 +1363,6 @@ static void qedi_tmf_work(struct work_struct *work)
 	struct iscsi_task *ctask;
 	struct iscsi_tm *tmf_hdr;
 	s16 rval = 0;
-	s16 tid = 0;
 
 	mtask = qedi_cmd->task;
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
@@ -1404,6 +1403,7 @@ static void qedi_tmf_work(struct work_struct *work)
 	}
 
 	qedi_cmd->type = TYPEIO;
+	qedi_cmd->state = CLEANUP_WAIT;
 	list_work->qedi_cmd = qedi_cmd;
 	list_work->rtid = cmd->task_id;
 	list_work->state = QEDI_WORK_SCHEDULED;
@@ -1430,15 +1430,7 @@ static void qedi_tmf_work(struct work_struct *work)
 		goto ldel_exit;
 	}
 
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
 
 put_task:
 	iscsi_put_task(ctask);
@@ -1468,8 +1460,7 @@ static void qedi_tmf_work(struct work_struct *work)
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 }
 
-static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
-			       struct iscsi_task *mtask)
+static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 {
 	struct iscsi_tmf_request_hdr tmf_pdu_header;
 	struct iscsi_task_params task_params;
@@ -1484,7 +1475,6 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	u32 scsi_lun[2];
 	s16 tid = 0;
 	u16 sq_idx = 0;
-	int rval = 0;
 
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 	qedi_cmd = (struct qedi_cmd *)mtask->dd_data;
@@ -1548,10 +1538,7 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	task_params.sqe = &ep->sq[sq_idx];
 
 	memset(task_params.sqe, 0, sizeof(struct iscsi_wqe));
-	rval = init_initiator_tmf_request_task(&task_params,
-					       &tmf_pdu_header);
-	if (rval)
-		return -1;
+	init_initiator_tmf_request_task(&task_params, &tmf_pdu_header);
 
 	spin_lock(&qedi_conn->list_lock);
 	list_add_tail(&qedi_cmd->io_cmd, &qedi_conn->active_cmd_list);
@@ -1563,47 +1550,30 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
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
index 9b794afbdead..b06ebbb3ed39 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -742,7 +742,7 @@ static int qedi_iscsi_send_generic_request(struct iscsi_task *task)
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

