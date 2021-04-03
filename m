Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A33C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A02F6135F
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbhDCXYd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54922 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236972AbhDCXYW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NLRrm085995;
        Sat, 3 Apr 2021 23:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=I2Kgcqp8lyJVjODGK2hpuTFRPtcj2wbRwthilETgz+s=;
 b=NHrhdaSQYYKrSf4TRKFa5D0XPYz7iO6fmGJ4aU5djWLAilw0+mbGDchizPPf+OwmQOV/
 pA8OiXLuIU/hIV9k+AQCIA9B4MX/Nl+gLE79xtOvb4EGL1wJC8qvGQKhu+fspu0bUz4P
 gmT4B19h2TV096AT3Z3pkje1pTtg89N78OnoCfn2d7d2LADGUpCaWwC3/mid2d1ir24d
 UiZYQDoxjE39+ZGi33GMjf1NgD+MnofM5YzHIinsqaKXyGXuncQ9GF425TXdeAa3xAEU
 yY2N4Ik/uz0NSi9xGSyp+QhHqTCSzninh9Ud6vFbAuzmJackeYiecKktlQIv0RM3xmWN qQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37pq66rcv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKte3116979;
        Sat, 3 Apr 2021 23:24:08 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2050.outbound.protection.outlook.com [104.47.45.50])
        by userp3020.oracle.com with ESMTP id 37pfpkbspr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2dAsvmZdKIIZjMMe6B1Yjc+jOUxr7ySBOK31JO6OGVrEPpzSchmsAotLqLAW95BIQe9Zmct6tujzqIRDSUyza6bp3ivzRT9nl/N5ebctrV5qtvApyVBl60QwKcnVGrfeUdg4OE72rovsE7yohoD6REq5BtHwe1Ja1T4fVrk0l8O7Tc92J+ZRdbZFsHRsEh/RJ6QW4iQ0nEB8twbQjZ8PqSlt7GREz9r8/HJ3ZL10Bn00pp2UsNXtCuj3nHcXANX0EaWUaVph/JW1g4XS5p8t3Ly9dJgB2JpTsmqPueDE5b0ctkd7Rcx4n3C++qMBAMwyv/xpKSUYt8dLhxrMm7tnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2Kgcqp8lyJVjODGK2hpuTFRPtcj2wbRwthilETgz+s=;
 b=kdbnBwMT8zclwESoOQltSrS6VOP4+GbGcWfUA86O0XV9pqlXArh7UkHSruEyVVGn3ShX/QJgIlBX5Fv5bBEsHYXKvu7UlY+GyqtER3zhCMtUaclgVcteqJjzaDPi8zGU9+3wDTrMvKVYkyZPDMyqSs9q+WTzTyaW+Rsj2BlJ56Rs/WUSuV9by1thq6OtACTPGJqF8UypkJBtivMl5TtXC6NEzw9k1W8xvmGCFtRqZPBlAO0Mmb2opDV3LC44hMnx33M9w+qXr2hF4yOAEIraMJUTMeyZpVg7Wo8T9GXgYyDnYNb+cIYNLZwcljVrMi8lsKHe7AX4rKtroBBiDUf+FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2Kgcqp8lyJVjODGK2hpuTFRPtcj2wbRwthilETgz+s=;
 b=vx35NWIezQu/tLE/jvWYejqwhQ3UiMNbBFvki8oiduJRJDOm3/80y2AxzHTkE8ZUEWZP3b26JQ1+PVpkUfkP4m9Qej84Jr1r0x0cJf3Ahyr8U9na0xS09tOCAwEE0OiyWTqVSIzWIo1TE+pz+YMZryZ99POAZHI19k05A+kv4eA=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:24:06 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 17/40] scsi: qedi: cleanup abort handling
Date:   Sat,  3 Apr 2021 18:23:10 -0500
Message-Id: <20210403232333.212927-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9f36024-c2e3-49c4-3db3-08d8f6f79375
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB35261690BC5677513EB414D2F1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0b08b3M6+0OoWCHndKG79eXMCOJ2KFn6CslxyGQemS2idxAEYFEo4rQBJNErXnQFGoSWfBr/vUXX3R5W1Nz7lPGMojH18qF9eRBXWNgSZm9oZRB81OmfT9s+Ol9pns6FLsC7bLV2ajrOxEzWD79h360Re0qAaSQvZjXydi0BbhVo4Q0Zcw8AnWa4RjPqdB9zQDpSiLOUcblIZj3388jX+GlhQrKd1G4o0J4/ckTY3X2ae+6oyvNuiOwNSDcCF7+IJwO+yzGiTAgmXbB4CBtcsFg7FHqdIpyyxS73ac83yQpObGmJgAYDAjjxVhAyeAd/RXHIHSmdZx2oHLBKXOj/E1L07SmST+MMust8W9tl3/NYwsJOOFuGTmcRACqIdI2Rv92e+ln5Uo+co/WWhYcEgn9WKYvEXxAMyEZPon0CsSYJSXgVif8ZqGy4UD3pygP+QFSjlcgy0cxEWupm97oNAsI/E2kR28YvS0pC2qi6nQislyWCW8wkHIFY2STzO966CX7A1ta6Wa6SBYc1asTXZLU6iwXHqXLlaFJmqkHbawu/tIiig70+M7d6ySQkQcZ5ixhGe4PFrA8QVFh4X6qafhk/K02w1kjphjCgpMIX2mpKOvJ4pdC2OvuayuS+v10wlm4PotK6ardJfDmM4W6cieaLuHN4IYw+nIignfv7ytmwS1quJywU2GqoTgG6LU+abv6j/gqI/PpdGlCOMPlaSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(30864003)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(6666004)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?02IPJuVkQ6u2M36ImSbqkBgu8Rp49j4ezJhNKUilHUgmGil7i5CqBip1ynST?=
 =?us-ascii?Q?QG/M6nhxGLa4ot5zWPVTfOw6FHlcVEbKeQM+x4DdxhSJ4ViqssqYsBfFm4GJ?=
 =?us-ascii?Q?FFFO/JQesJFQS32EOs0Jw7XJ0JLjpouzsP2PbsdeIGdkENvH7wm0cQeQUROs?=
 =?us-ascii?Q?OtrmyZ6OdBAQo2SpZCHL+DxLFQ13trQbKXY6WumqTxLa63zPkrPsdAHJRZAd?=
 =?us-ascii?Q?RzW4hi+ODRMKLE5Af60wY3lMNfvE3qcuVy0I82sZpfc1r49gMGxLQ2gksGpD?=
 =?us-ascii?Q?LCHK4VkVih2lZkKSBzFCNYaas4JeQsWGHDnDk3shoiLtzJ9AeYX8CqtfMqYq?=
 =?us-ascii?Q?Z17p+AOWkwzDL+UoP8C9UsxKvd7z8OHIeZ+ghgbbF71HbmQUp9CWcBTQzf3f?=
 =?us-ascii?Q?DS6xfzqv/deWfT3zznZvXc5hEDaTr3lyYYLP4DV0y9dThJSFyF/QDXhlo0sm?=
 =?us-ascii?Q?BM4CU8ifrb/RIOhfPjOHK7ZV5RRfuWwWYPrtozXrWM7PCyq+rD97doVO2woK?=
 =?us-ascii?Q?VfFpIFybCg/9Z5Eduba4DImgc2oiRUGdUdALT0k1M5M9rriMeh+vK5arNOjF?=
 =?us-ascii?Q?mO67AJJPTjCy349BTTZC498gqeDGWZU/6sk1RmbWKVCI+Ff/kWQQ2ExTKeOD?=
 =?us-ascii?Q?18GuhfR/gfkITRajXV1T4jxM52R/2ORxuzodJ6C8o7ai7TaRykCV1J38+eE3?=
 =?us-ascii?Q?Y4n9U8yc4tEN0z/8X7WskEUnCMGYWAURwnKT45J5xC0HSfkZ38vV/NfxBvzk?=
 =?us-ascii?Q?bnrm6qIKyfrcFdyUy1qjLJKAtHXNY79Uc1dcFApu8Ujt+dm9KkJKlEiHX0/e?=
 =?us-ascii?Q?L8DNZcT2QN9vF9d2DKcMxPwVfoRcC1P9icFR6MSs48Bm056NEpm3uM3ZNo7l?=
 =?us-ascii?Q?H+qq+JMYqb9MTil1tv+e/M4T49sVBl27R6yAgU38OTLTzpaCwwEGh11NmRd4?=
 =?us-ascii?Q?X8wDjWJNGVRfi52Szi+jv/+ZqA4Vr6VDL2kocfTfK1/SY0E5xnZ3gImmdANe?=
 =?us-ascii?Q?tfInqKGT51HdrhL6Qu2g/lQ7WAoBZ2BTy/oTJBx6dZ/kTXJK1raSus9eqqC+?=
 =?us-ascii?Q?nIN11DIgZpaavS6e2u/kWwcEmC77p9R7q3v6ws7kDwc3OVdaizMJihXwFA1D?=
 =?us-ascii?Q?gUWBNMRUdggiY6t8bnI9K9C3ZqLAUN5+qTHR24IkkBM0C2QHjeg8sZJLbnQZ?=
 =?us-ascii?Q?mu7rElEcksHJIM8K1Zdxh7UUjhGXdi6Xwh+/Kz3+aSXDyL0AmgdNdZnZt3t0?=
 =?us-ascii?Q?dfEGdJCYsoiqp3U1Eg2Jd+ZRlypc2SCIc3AboHTI7fzm4O+P4vKPjD8d6CZj?=
 =?us-ascii?Q?m+NVFLt3++/oZBUjdovPh7ie?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f36024-c2e3-49c4-3db3-08d8f6f79375
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:06.6073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jn8aE2uA7F8NFhNagaYhff17/Q41NWH+esh4rrh7TnUzCmr/IWuuThuqm/6362mej1obUu7Y4gZiaNK5fJbiROXnijyLRH1JoaaeqrAQ8p0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: GpdZDyF3c1xXThhrsle7nkl8SuDatiab
X-Proofpoint-GUID: GpdZDyF3c1xXThhrsle7nkl8SuDatiab
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 phishscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has qedi do it's fw cleanup from the eh abort callout then call into
libiscsi to do the protocol/libiscsi cleanup.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 216 ++++++++++-----------------------
 drivers/scsi/qedi/qedi_gbl.h   |   4 +-
 drivers/scsi/qedi/qedi_iscsi.c |  48 +++++++-
 drivers/scsi/qedi/qedi_iscsi.h |   1 +
 4 files changed, 113 insertions(+), 156 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 440ddd2309f1..d8e10e8d3d08 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -14,9 +14,6 @@
 #include "qedi_fw_iscsi.h"
 #include "qedi_fw_scsi.h"
 
-static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
-			       struct iscsi_task *mtask);
-
 void qedi_iscsi_unmap_sg_list(struct qedi_cmd *cmd)
 {
 	struct scsi_cmnd *sc = cmd->scsi_cmd;
@@ -739,7 +736,6 @@ static void qedi_process_nopin_local_cmpl(struct qedi_ctx *qedi,
 
 static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 					  struct iscsi_cqe_solicited *cqe,
-					  struct iscsi_task *task,
 					  struct iscsi_conn *conn)
 {
 	struct qedi_work_map *work, *work_tmp;
@@ -752,8 +748,7 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 	u32 iscsi_cid;
 	struct qedi_conn *qedi_conn;
 	struct qedi_cmd *dbg_cmd;
-	struct iscsi_task *mtask;
-	struct iscsi_tm *tmf_hdr = NULL;
+	struct iscsi_task *task;
 
 	iscsi_cid = cqe->conn_id;
 	qedi_conn = qedi->cid_que.conn_cid_tbl[iscsi_cid];
@@ -777,8 +772,7 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 				WARN_ON(1);
 			}
 			found = 1;
-			mtask = qedi_cmd->task;
-			tmf_hdr = (struct iscsi_tm *)mtask->hdr;
+			task = work->task;
 			rtid = work->rtid;
 
 			list_del_init(&work->list);
@@ -790,49 +784,30 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 
 	if (found) {
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
-			  "TMF work, cqe->tid=0x%x, tmf flags=0x%x, cid=0x%x\n",
-			  proto_itt, tmf_hdr->flags, qedi_conn->iscsi_conn_id);
-
-		if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-		    ISCSI_TM_FUNC_ABORT_TASK) {
-			spin_lock_bh(&conn->session->back_lock);
-
-			protoitt = build_itt(get_itt(tmf_hdr->rtt),
-					     conn->session->age);
-			task = iscsi_itt_to_task(conn, protoitt);
+			  "TMF work, cqe->tid=0x%x, cid=0x%x\n",
+			  proto_itt, qedi_conn->iscsi_conn_id);
 
-			spin_unlock_bh(&conn->session->back_lock);
+		dbg_cmd = task->dd_data;
 
-			if (!task) {
-				QEDI_NOTICE(&qedi->dbg_ctx,
-					    "IO task completed, tmf rtt=0x%x, cid=0x%x\n",
-					    get_itt(tmf_hdr->rtt),
-					    qedi_conn->iscsi_conn_id);
-				return;
-			}
-
-			dbg_cmd = task->dd_data;
-
-			QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
-				  "Abort tmf rtt=0x%x, i/o itt=0x%x, i/o tid=0x%x, cid=0x%x\n",
-				  get_itt(tmf_hdr->rtt), get_itt(task->itt),
-				  dbg_cmd->task_id, qedi_conn->iscsi_conn_id);
+		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
+			  "Abort i/o itt=0x%x, i/o tid=0x%x, cid=0x%x\n",
+			  get_itt(task->itt), dbg_cmd->task_id,
+			  qedi_conn->iscsi_conn_id);
 
-			if (qedi_cmd->state == CLEANUP_WAIT_FAILED)
-				qedi_cmd->state = CLEANUP_RECV;
+		if (qedi_cmd->state == CLEANUP_WAIT_FAILED)
+			qedi_cmd->state = CLEANUP_RECV;
 
-			qedi_clear_task_idx(qedi_conn->qedi, rtid);
+		qedi_clear_task_idx(qedi_conn->qedi, rtid);
 
-			spin_lock(&qedi_conn->list_lock);
-			if (likely(dbg_cmd->io_cmd_in_list)) {
-				dbg_cmd->io_cmd_in_list = false;
-				list_del_init(&dbg_cmd->io_cmd);
-				qedi_conn->active_cmd_count--;
-			}
-			spin_unlock(&qedi_conn->list_lock);
-			qedi_cmd->state = CLEANUP_RECV;
-			wake_up_interruptible(&qedi_conn->wait_queue);
+		spin_lock(&qedi_conn->list_lock);
+		if (likely(dbg_cmd->io_cmd_in_list)) {
+			dbg_cmd->io_cmd_in_list = false;
+			list_del_init(&dbg_cmd->io_cmd);
+			qedi_conn->active_cmd_count--;
 		}
+		spin_unlock(&qedi_conn->list_lock);
+		qedi_cmd->state = CLEANUP_RECV;
+		wake_up_interruptible(&qedi_conn->wait_queue);
 	} else if (qedi_conn->cmd_cleanup_req > 0) {
 		spin_lock_bh(&conn->session->back_lock);
 		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
@@ -959,8 +934,7 @@ void qedi_fp_process_cqes(struct qedi_work *work)
 		goto exit_fp_process;
 	case ISCSI_CQE_TYPE_TASK_CLEANUP:
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM, "CleanUp CqE\n");
-		qedi_process_cmd_cleanup_resp(qedi, &cqe->cqe_solicited, task,
-					      conn);
+		qedi_process_cmd_cleanup_resp(qedi, &cqe->cqe_solicited, conn);
 		goto exit_fp_process;
 	default:
 		QEDI_ERR(&qedi->dbg_ctx, "Error cqe.\n");
@@ -1368,59 +1342,41 @@ static int qedi_wait_for_cleanup_request(struct qedi_ctx *qedi,
 	return 0;
 }
 
-static void qedi_tmf_work(struct work_struct *work)
+int qedi_fw_cleanup_cmd(struct iscsi_task *ctask)
 {
-	struct qedi_cmd *qedi_cmd =
-		container_of(work, struct qedi_cmd, tmf_work);
-	struct qedi_conn *qedi_conn = qedi_cmd->conn;
+	struct iscsi_conn *conn = ctask->conn;
+	struct qedi_conn *qedi_conn = conn->dd_data;
 	struct qedi_ctx *qedi = qedi_conn->qedi;
-	struct iscsi_conn *conn = qedi_conn->cls_conn->dd_data;
-	struct qedi_work_map *list_work = NULL;
-	struct iscsi_task *mtask;
-	struct qedi_cmd *cmd;
-	struct iscsi_task *ctask;
-	struct iscsi_tm *tmf_hdr;
+	struct qedi_work_map *list_work;
+	struct qedi_cmd *cmd, qedi_cmd;
 	s16 rval = 0;
-	s16 tid = 0;
-
-	mtask = qedi_cmd->task;
-	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
-	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
-
-	ctask = iscsi_itt_to_task(conn, tmf_hdr->rtt);
-	if (!ctask || !ctask->sc) {
-		QEDI_ERR(&qedi->dbg_ctx, "Task already completed\n");
-		goto abort_ret;
-	}
 
-	cmd = (struct qedi_cmd *)ctask->dd_data;
+	cmd = ctask->dd_data;
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
-		  "Abort tmf rtt=0x%x, cmd itt=0x%x, cmd tid=0x%x, cid=0x%x\n",
-		  get_itt(tmf_hdr->rtt), get_itt(ctask->itt), cmd->task_id,
-		  qedi_conn->iscsi_conn_id);
+		  "abort tmf cmd itt=0x%x, cmd tid=0x%x, cid=0x%x\n",
+		  get_itt(ctask->itt), cmd->task_id, qedi_conn->iscsi_conn_id);
 
-	if (qedi_do_not_recover) {
-		QEDI_ERR(&qedi->dbg_ctx, "DONT SEND CLEANUP/ABORT %d\n",
-			 qedi_do_not_recover);
-		goto abort_ret;
-	}
-
-	list_work = kzalloc(sizeof(*list_work), GFP_ATOMIC);
+	list_work = kzalloc(sizeof(*list_work), GFP_NOIO);
 	if (!list_work) {
-		QEDI_ERR(&qedi->dbg_ctx, "Memory allocation failed\n");
-		goto abort_ret;
+		QEDI_ERR(&qedi->dbg_ctx, "memory allocation failed\n");
+		return -ENOMEM;
 	}
 
-	qedi_cmd->type = TYPEIO;
-	list_work->qedi_cmd = qedi_cmd;
+	memset(&qedi_cmd, 0, sizeof(struct qedi_cmd));
+	qedi_cmd.conn = qedi_conn;
+	qedi_cmd.type = TYPEIO;
+	qedi_cmd.list_tmf_work = list_work;
+	qedi_cmd.state = CLEANUP_WAIT;
+
+	INIT_LIST_HEAD(&list_work->list);
+	list_work->task = ctask;
+	list_work->qedi_cmd = &qedi_cmd;
 	list_work->rtid = cmd->task_id;
 	list_work->state = QEDI_WORK_SCHEDULED;
-	qedi_cmd->list_tmf_work = list_work;
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
-		  "Queue tmf work=%p, list node=%p, cid=0x%x, tmf flags=0x%x\n",
-		  list_work->ptr_tmf_work, list_work, qedi_conn->iscsi_conn_id,
-		  tmf_hdr->flags);
+		  "queue tmf work=%p, list node=%p, cid=0x%x\n",
+		  list_work->ptr_tmf_work, list_work, qedi_conn->iscsi_conn_id);
 
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
 	list_add_tail(&list_work->list, &qedi_conn->tmf_work_list);
@@ -1428,34 +1384,21 @@ static void qedi_tmf_work(struct work_struct *work)
 
 	qedi_iscsi_cleanup_task(ctask, false);
 
-	rval = qedi_wait_for_cleanup_request(qedi, qedi_conn, ctask, qedi_cmd,
+	rval = qedi_wait_for_cleanup_request(qedi, qedi_conn, ctask, &qedi_cmd,
 					     list_work);
 	if (rval == -1) {
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
-			  "FW cleanup got escalated, cid=0x%x\n",
+			  "fw cleanup got escalated, cid=0x%x\n",
 			  qedi_conn->iscsi_conn_id);
-		goto ldel_exit;
+		goto force_cleanup;
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
-
-abort_ret:
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
-	return;
+	return 0;
 
-ldel_exit:
+force_cleanup:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
-	if (!qedi_cmd->list_tmf_work) {
+	if (!qedi_cmd.list_tmf_work) {
 		list_del_init(&list_work->list);
-		qedi_cmd->list_tmf_work = NULL;
 		kfree(list_work);
 	}
 	spin_unlock_bh(&qedi_conn->tmf_work_lock);
@@ -1468,11 +1411,10 @@ static void qedi_tmf_work(struct work_struct *work)
 	}
 	spin_unlock(&qedi_conn->list_lock);
 
-	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
+	return -1;
 }
 
-static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
-			       struct iscsi_task *mtask)
+int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 {
 	struct iscsi_tmf_request_hdr tmf_pdu_header;
 	struct iscsi_task_params task_params;
@@ -1491,6 +1433,19 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 	qedi_cmd = (struct qedi_cmd *)mtask->dd_data;
+
+	switch (tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
+	case ISCSI_TM_FUNC_ABORT_TASK:
+	case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
+	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
+	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
+		break;
+	default:
+		QEDI_ERR(&qedi->dbg_ctx, "Invalid tmf, cid=0x%x\n",
+			 qedi_conn->iscsi_conn_id);
+		return -EINVAL;
+	}
+
 	ep = qedi_conn->ep;
 	if (!ep)
 		return -ENODEV;
@@ -1566,49 +1521,6 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	return 0;
 }
 
-int qedi_iscsi_abort_work(struct qedi_conn *qedi_conn,
-			  struct iscsi_task *mtask)
-{
-	struct qedi_ctx *qedi = qedi_conn->qedi;
-	struct iscsi_tm *tmf_hdr;
-	struct qedi_cmd *qedi_cmd = (struct qedi_cmd *)mtask->dd_data;
-	s16 tid = 0;
-
-	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
-	qedi_cmd->task = mtask;
-
-	/* If abort task then schedule the work and return */
-	if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
-	    ISCSI_TM_FUNC_ABORT_TASK) {
-		qedi_cmd->state = CLEANUP_WAIT;
-		INIT_WORK(&qedi_cmd->tmf_work, qedi_tmf_work);
-		queue_work(qedi->tmf_thread, &qedi_cmd->tmf_work);
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
-		QEDI_ERR(&qedi->dbg_ctx, "Invalid tmf, cid=0x%x\n",
-			 qedi_conn->iscsi_conn_id);
-		return -1;
-	}
-
-	return 0;
-}
-
 int qedi_send_iscsi_text(struct qedi_conn *qedi_conn,
 			 struct iscsi_task *task)
 {
diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index 116645c08c71..a3b72e7ff9d9 100644
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
@@ -60,6 +59,7 @@ void qedi_mark_device_available(struct iscsi_cls_session *cls_session);
 void qedi_reset_host_mtu(struct qedi_ctx *qedi, u16 mtu);
 int qedi_recover_all_conns(struct qedi_ctx *qedi);
 void qedi_fp_process_cqes(struct qedi_work *work);
+int qedi_fw_cleanup_cmd(struct iscsi_task *ctask);
 int qedi_cleanup_all_io(struct qedi_ctx *qedi,
 			struct qedi_conn *qedi_conn,
 			struct iscsi_task *task, bool in_recovery);
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 36e81eb567b2..0f3704c4c985 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -43,13 +43,57 @@ static int qedi_eh_host_reset(struct scsi_cmnd *cmd)
 	return qedi_recover_all_conns(qedi);
 }
 
+static int qedi_eh_abort(struct scsi_cmnd *cmd)
+{
+	struct Scsi_Host *shost = cmd->device->host;
+	struct qedi_ctx *qedi = iscsi_host_priv(shost);
+	struct iscsi_cls_session *cls_session;
+	struct iscsi_session *session;
+	struct qedi_conn *qedi_conn;
+	struct iscsi_task *task;
+	int rc;
+
+	cls_session = starget_to_session(scsi_target(cmd->device));
+	session = cls_session->dd_data;
+
+	if (qedi_do_not_recover) {
+		QEDI_ERR(&qedi->dbg_ctx, "dont send cleanup/abort %d\n",
+			 qedi_do_not_recover);
+		return FAILED;
+	}
+
+	/* check if we raced, task just got cleaned up under us */
+	spin_lock_bh(&session->back_lock);
+	task = (struct iscsi_task *)cmd->SCp.ptr;
+	if (!task || !task->sc) {
+		spin_unlock_bh(&session->back_lock);
+		return SUCCESS;
+	}
+
+	__iscsi_get_task(task);
+	spin_unlock_bh(&session->back_lock);
+
+	qedi_conn = task->conn->dd_data;
+	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
+
+	rc = qedi_fw_cleanup_cmd(task);
+
+	iscsi_put_task(task);
+	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
+
+	if (rc)
+		return FAILED;
+
+	return iscsi_eh_abort(cmd);
+}
+
 struct scsi_host_template qedi_host_template = {
 	.module = THIS_MODULE,
 	.name = "QLogic QEDI 25/40/100Gb iSCSI Initiator Driver",
 	.proc_name = QEDI_MODULE_NAME,
 	.queuecommand = iscsi_queuecommand,
 	.eh_timed_out = iscsi_eh_cmd_timed_out,
-	.eh_abort_handler = iscsi_eh_abort,
+	.eh_abort_handler = qedi_eh_abort,
 	.eh_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.eh_host_reset_handler = qedi_eh_host_reset,
@@ -746,7 +790,7 @@ static int qedi_iscsi_send_generic_request(struct iscsi_task *task)
 		rc = qedi_send_iscsi_logout(qedi_conn, task);
 		break;
 	case ISCSI_OP_SCSI_TMFUNC:
-		rc = qedi_iscsi_abort_work(qedi_conn, task);
+		rc = qedi_send_iscsi_tmf(qedi_conn, task);
 		break;
 	case ISCSI_OP_TEXT:
 		rc = qedi_send_iscsi_text(qedi_conn, task);
diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscsi.h
index 39dc27c85e3c..8a96c1fde630 100644
--- a/drivers/scsi/qedi/qedi_iscsi.h
+++ b/drivers/scsi/qedi/qedi_iscsi.h
@@ -212,6 +212,7 @@ struct qedi_cmd {
 struct qedi_work_map {
 	struct list_head list;
 	struct qedi_cmd *qedi_cmd;
+	struct iscsi_task *task;
 	int rtid;
 
 	int state;
-- 
2.25.1

