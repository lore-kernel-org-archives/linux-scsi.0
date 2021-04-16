Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74557C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 492E761158
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbhDPCFq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48364 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238044AbhDPCFd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G24CcY098785;
        Fri, 16 Apr 2021 02:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=G0JgLjvbBaX+LnKq23JdN8gB3+ipbO4IshMwPd2anko=;
 b=G4shAoeKpyT22oG4EMPffDMUzG4Mg72vPGa08x4W/qUQEWzreSd9QwNkp9eyL0kM1N1x
 wIIBWhJIY2N5MC6zP4Lngg30vGJShCwip8mZD0/qfMPsj2CLRXA5b/X8p79a/zSIvMJf
 kNCPu4+jP6KeaQme/9Q/bbdRThI5fHYaztNGfOlxnxFwy4s/uKKcSaXIFV/4wqGY9FgY
 RrB+6e1v8suWJ7mU4r7w1VoXrt4P70qbpBu0HS6CJRACLJDg47lxv551DGMmQoIzu8e+
 PVbh13yyWEQkPlCgQX9TuNFhSet2Gf5E9+h86POBszTsmTMGTUAGd8JHR0fjmw46aSaS tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3erqpea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xoR0008624;
        Fri, 16 Apr 2021 02:05:03 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3020.oracle.com with ESMTP id 37unx3sp1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgxKrm9lru0C7ZjkaXjLyQtpfYCA7U+9nSQbOP3gXplt6vtMILcS719jWsqoJ1m35uRpxiJ+jdQbyzyy1mBHio1RVVruhxphGQtjD/txYD6hQVOe1n/Sc3UxVlVyKffbOdgPKk6eiWZ56vHGHkkbn9ePHbe5uTrGCPYx0xR6K4WH0/TGEniBTfNb3Dh74DrIy8B84FrP+v3ENoMBNaIkZrxSIQZiCXQoGu2LEwA/BLVc81Y3c32rJZQBOEw/S8HRcJyAVh84uMpIdWyucFjeKiq68X1ASJKCdTnLdddwoq5gcBPEXmIkYNd0i/W2meUYVJ9W+HnQPPk4d+v5Fq7QHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0JgLjvbBaX+LnKq23JdN8gB3+ipbO4IshMwPd2anko=;
 b=QtgayNpVFAQMeyoB/HKZocpeGLmGz9iGOVfPo3T08Pv12SM0iq/dWvI8P93SEYbavJvuzQaWvIJ4Lh7A7jq1T4Z3GhjO5iFllox508pTJc/Z9ZEbNO8yLc0vboEE53XBELXsBvqx/aq5kVTglTI+tPMntk2T25ijXiLD9dT49PoA2TNNqOeDR5NXcYYwjjrf1FBFmiDD776tVKUPFGcKbtzjKz4yvs3NFjeO6ZLGwUYPc9zrllQ6K7GwW8j78L0VhIrPs+HFHLG1IJoqG+j+2UfHM+r15IufCHp+cpAluXz/dCFLfHt9YQONvxhmRxEeFpbEw4GpmqvyJ0sYNya1DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0JgLjvbBaX+LnKq23JdN8gB3+ipbO4IshMwPd2anko=;
 b=rfTBRtYi/LDugDk+iroqCOZSF0IAI2RuFU+0cRkf0gGSYalPQEw8YCnmAHabiS4aQ9dr4IC+Tt2z/baKsgEQxgaKl7461mAV7CNaVUeX4IwvwG9nOZbvotJkCT9jnoXMf28tkQTiG8bM1G4F1sACUJtmVNDiDWQilfUXdLipCeA=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3318.namprd10.prod.outlook.com (2603:10b6:a03:15d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Fri, 16 Apr
 2021 02:05:01 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:05:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 11/17] scsi: qedi: fix TMF tid allocation
Date:   Thu, 15 Apr 2021 21:04:34 -0500
Message-Id: <20210416020440.259271-12-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:05:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4374ab0a-ce1b-4e8e-9911-08d9007c0adc
X-MS-TrafficTypeDiagnostic: BYAPR10MB3318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3318E70EA594245C8F41BEE9F14C9@BYAPR10MB3318.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wFum6NeeF+RGR4r0REyjXgluEG3gVEW3onalu1vgHXa5bvP9NU1cPysNCvxyXBK7l/HN5jEImorFko59sIqxmxMkY46rn0nMUpftalD3QLKMBOK2OWAVY2SDhoRrAaO0S+BToFFrG69Ma6EnySiz7RtI8gD5jSTvNgCfRzsBlR0IjPnFqUFO0lQk4rRN+YxAEai62sfqFQgXllgravFWH1w/IerOftyUgIv8mT+wj391kQr9t2kDphQG4DSpgyb2r5OnkyYJqRElkvReQ/Vk93Dws8+8wB2bbd5dRLicBSuHehZeunIH3pj2Qn2sKsRSfKQJUO7IFLqhrVV5nodCvotX2lc9O+eMk879oWicAbT/Uq9OafhlIa+eUbGOH62KrnriV99sB6XqoVRNsvmtC4XiBoG+QdIZUsnzu6j+fdRaV8xPA2MdbUbr0EkAQLv2nD4eAsBtM8K1sBcsB+Ojm3LCLSdPB8CKEDgkpAlZDwMun4JlXlmzeB6ygWlG1a8BVgMsVqiI5UBXThSheRFDm88LvK5HYgmbCBZ7HITWcHilz3Ya3Srgj4nq/lX9gTOW0mrDMKc7rN1KDyXgxDvKVgdK21WHsfiFfXKRv5F9tzjB3oNbYfh/bLUJwn7MduNG9ROcouWpSjoio9j656sfk9xFyeoFNH04dYs8yQ0/Ls0BNcPgJ+3JCOhTtzAMdK1W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(366004)(396003)(38350700002)(38100700002)(52116002)(8936002)(6666004)(2906002)(107886003)(26005)(186003)(1076003)(36756003)(6486002)(6512007)(6506007)(8676002)(86362001)(69590400012)(83380400001)(508600001)(5660300002)(956004)(316002)(66476007)(66946007)(2616005)(4326008)(66556008)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yyXug4Jbgh/duqBe19ASA4wY7E67Wx5U2XtgSCD1FKkwp/zv0D+MBB6SN8YK?=
 =?us-ascii?Q?wbv0TgEV6pdkOeCZQTLocj1tnoJ0yI/wtdTspps5S0EKI6pqCad72G6DzCXL?=
 =?us-ascii?Q?ziUMRnARUsPZS4TTypLV+3ud8vTqmTMP6/C/+usf+MIwCOObrgV4Z+U7oXGu?=
 =?us-ascii?Q?WVW7+3vtT8Trsz3SyYI5W3RFALBiMgG8CIbI4jtuyTgA+kIUsI3i7wDfYOjW?=
 =?us-ascii?Q?UtdyZH0jkiltD8TGF+nFeXh2/zbYrcgFkCp5rgqlMbIlqNMFMEZzRNmOp6SR?=
 =?us-ascii?Q?AMnS5ghOaBimUAUG8yXcc8OVFsCUvUwlY0bWIZUMIX0WRZf0xCW15IU9iVrk?=
 =?us-ascii?Q?pAFMwk5ksQAvYC/5WKK3e0TLv4CuQilAE2i1EIUGwufImxIGDxM08vZqEr0g?=
 =?us-ascii?Q?5K2rD3uLZ5VX/uB2+JJrbPKz9qARklcyqQqSNFs9MCaPe2axDJE3BK848O8X?=
 =?us-ascii?Q?aDbH3CHKNCUEMuprZnKZViLrkrIBLT+gjQO8EQz7+7yCPr1yRfLoWKoxHtUu?=
 =?us-ascii?Q?WIRrQfl6d8XADEbMPt6SFhoOSyb4mbzZdHXfPak5RrQDkpW2zqRfUtpfyLmA?=
 =?us-ascii?Q?nccBl8EpLv1QUw6YATqCJ3EJxUt7chje3gf+s97oz73ZTNeqGb79zSn6kaRX?=
 =?us-ascii?Q?a9V22fY0jtIqSCdk2A07CeIQwW6VyZculRubVds0yYxL5xBzDg187HDuYn+C?=
 =?us-ascii?Q?CkRCY339mPJNaQuHd61wOqTS/2z4n7cV/UCDr5BFZUvKzwYGgD4Zw78O5acP?=
 =?us-ascii?Q?50Fi4y3i8tzzDwse6xBiOaJa/OUUKXgzjLJoyg8P9IrXWlSl4uQS10Zy+Uuk?=
 =?us-ascii?Q?2EZ8YnYi2GMYxes68mVEJO8FTW/Qw5lDnd5ydv+HBV0+HeHkr3RPfv/YyKv1?=
 =?us-ascii?Q?YN6M6YazH8iTlBfvORpx5cmwwa3xbB9PVzTNKUiPnqp6pf5uqPqLB04+Iv0z?=
 =?us-ascii?Q?psci3dMPy0Qy8xSPTAfW0YNaXaSxY9maGk6ZJerfllH5eDmfQEsyux9AbLcY?=
 =?us-ascii?Q?x+rlcpO6F1Mpt0yrSDVKx540TK+ooDK5dPKbCVUcYAedHt0FvgTGEUORN8id?=
 =?us-ascii?Q?VoEP+ghgeemadta4V9nTpGKfZk+WE9O6fGxQRvrIciAOTdRNhCm3w5ESbEm3?=
 =?us-ascii?Q?PMBHP+g+TehHHkG+MONqXlsxwHX8I0066U6ah3qx0qPunACyRdUw2QVq6/Z6?=
 =?us-ascii?Q?eq81DCV8yGHjBPBARdvtqFaRrtCJY77JzZOHAD0l4h1RrHOS7R/Fzkb5y/87?=
 =?us-ascii?Q?UHZcA7k+s9WkqV098QUwsqUwDzL8qvw1NMozgnVmVRj7hwGQgKShCU9SHhK7?=
 =?us-ascii?Q?JmevdN6Hf9B70F/esQm/h+iy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4374ab0a-ce1b-4e8e-9911-08d9007c0adc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:05:01.1877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 84lgzPrVNXpUsk73i+Z/PXd0/Bgo8lbATuJOzjN4eoxFxIaX7SB+gZ20o6JGRfiw89b01u++GqjhgNcDp1bJlPG3R1zoXVb8i6HJtO+i98E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3318
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-ORIG-GUID: bjdJ8tgx7_Fcf87ArHKsj5WAYKLS3pJM
X-Proofpoint-GUID: bjdJ8tgx7_Fcf87ArHKsj5WAYKLS3pJM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160015
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
index 416202bc4241..0061866614b4 100644
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

