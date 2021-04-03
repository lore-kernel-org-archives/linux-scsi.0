Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9104BC43461
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CC3761360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbhDCXYN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:13 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44902 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236926AbhDCXYL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:11 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NMuw6099171;
        Sat, 3 Apr 2021 23:24:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=bq29pdC0jNtoVNhLZ3878etoiwz1Ig+czOpsuB4cuLk=;
 b=A1OU2nkjuji6Srp+ObQOokAtZS7k3vj+egbYZ1wMrd7cHdSf/1BiN+ddvepGG7ACh94M
 u0VLHtzslocJDpG5GDw0p+HrzX2WSZAvrj5phc05EGkgPqpT8N286fOE4gnl42lw0Vxf
 ln90CIqiXSwALdwnBvS1xA2o6DBAjtzw06yxTgj5L3Li8dOGzfpjP2FI+OBPRQZFHHB+
 YhDNBAg545p1CitTnSsrfpPYJLD1H3lRwlWvqoSJ4ZvuQ/E//ydSlRb5hdP2u5BfIlH3
 ywqczeiDE640ujXSlzTHpP55ZXPmsvF6s9KYG6u3WjuJLQA+SVPtEnq+jlivk7JTE2Qm 1g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37pdvb8v6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NL7pH130170;
        Sat, 3 Apr 2021 23:23:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3020.oracle.com with ESMTP id 37pg61hu90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GamR3OuKIzcBeN9kk+2JjUo9IT0HTy2sVSAKYYdYzIJqAB1hQmxKiiplBcSJW8erf1mgqc4eN9+gG6jixP4wCSUXXCDFa1/4BNlV0RdLRLvHUl5Y7hMenDNe/kQencbbFmZn6nfPQ6Y+Dvc/AlSKkGp30sgq0e6rdqLZ8r+PK+nUQw9FcvlzIQ0mS+0quo/9bR3pYuYEf4n5FVdR55fVm2EO/Ulo1a4fm0MpxbO38GzIiBf7TAvtjVxtmThpLTzSuqDGj8uU++JCYO4p9WRxQrHamZTon27+0l9uRIratg682MS/VMFthywpHOHJJIaRL7ptRWGbthAsTnyyulXCxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bq29pdC0jNtoVNhLZ3878etoiwz1Ig+czOpsuB4cuLk=;
 b=oYFrXZiJ06ihKExxUhAhpLXj0pkWGm8uVFFR82awqUcV4ZyhNURA3snJ4CNld4Oa9GQP7osfimOUrVS75QNcBPCG6a+Uln1Ma1rWVHPBePpLWHe6osDL8t0ftAoP/TqWSpMUCcegD9B7pdkDyC0/hwGWy+qtYuYS/D6fk/oQ0f5FnGbwmI4em7Jkh9AECqie6Duouznq/G6C7K/ZXp326Gx63EkaIM4p/kqxRD/ZxhpN+sP9/OU58zf03FQJ1/5ysQ1okWs/U5yGne0Yw0z5Nv2FUOkwvJfDKLKv1QWLPI1jiLoSVOeWdLwi5AvQOm8FHYv9TxRUVMAF3MDVP8sRwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bq29pdC0jNtoVNhLZ3878etoiwz1Ig+czOpsuB4cuLk=;
 b=fsY6HGxDg3ELHrXphf9cSF6LEksWwOp8ONlcm2G2zUospteZsb9On2v8fLb2g9eTRLEV6GJ7CHa+uR6yCEQmXjzifbuJ8s29jMLHmqnmQumHpfDoVc0QNsepyE7sWEgoHBPS4eanu0SyNTXekUv0GcraPpsNo7mRdJ5s/f25cCs=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:23:57 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:23:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 10/40] scsi: qedi: set scsi_host_template cmd_size
Date:   Sat,  3 Apr 2021 18:23:03 -0500
Message-Id: <20210403232333.212927-11-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:23:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 595161be-6682-41d4-b466-08d8f6f78df6
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB35269E8CDFD2FD45C6819449F1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WpeKDlwbRhJCZzf/FXAlMDHd2cmZ2vZoiLAl7+xkXZ8sMzAEaoZoSmGWOKqzRg++XGz1WtgvdNeJCz/aqvKtDxtKtT4WAxlRtAmbS7QMyD3VzYwLuRR/BgVc2SC2VmJzOhQZLZ4hYD2R18hwRXL4UwVRDWMXQpcviWAg4suFeRkVUQ0Hz47Cduu1oX+3iHQWlitxXc38qI4ony9HFxtaGwF3k+tQWkajPMIy/p5lD2GHTDgs+IsfqPfUlgRr7l7RbS+azE8q7/hZ7f7ajdCux9Jh642QAgk/fDEuGJzMK3GHjDtmlnEW3ugdvBxQ/42/ofmwmnbeo1oTrPP9mey1eKPHF4n1KYcCeHFQ8kAmK+im3meKt3hj0Uu28fAn3Au7/uLPv1/Lvjixi+RUFvwCCqp3g7BkFIC+PwnumUDo0ap9afVGQPdLaKQB/hNiGrIy6uN6ky8gAhxTqG0au6UeO3VIgcVBo6nE9a+oyHfbZQ2WoxEGEO/2TwY3TFqu9FxztliUpuwXW3ed896hha86Sw9wZ6TXhwudMeuXmab0hemQgVOjaB86DjfxsSd8e5zZV0dPsj7ZIWQhAJpvKPLzFm8s4pC7/FuWqmc5EbV+aw9lyOKG3Nx+GfWBRsuLjsW2fv1mly73U1sBu1PhKwqW44/p6sQk5e2nWiLpXQJ5TsNYMyF6iI5Xhtn7mSzW2gyxpUhfmxsNpJQkbsPfy+F2MQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(6666004)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DsAXcfnBoXVGP8AmVk9xWDdLkovaThNEDQ8dOFAzydEfvPMoTY++x7lKxjtp?=
 =?us-ascii?Q?pqCjBzIz7lQLG571UBFyfCtJmIIbWBRXYRmyz5r/LEPderyOWggJqF5z83rZ?=
 =?us-ascii?Q?IMCcpzFfOwdDPA2prIgM/Cv6ba0AFjIUsSrrw+XFCDscWOXKc21wox0JpwIK?=
 =?us-ascii?Q?sXcC3wAA2qOC6YFae5ihNFw5NiWTNYokfp/Ui2gOTLeV1iBDfxAhca7RnvsX?=
 =?us-ascii?Q?vU+n+h9xlCJk1vjtzEC8jEV1zg9LpEHcf8eOuhoG7G6p4Jo0AdrNPBT31zm2?=
 =?us-ascii?Q?Sa0YRvzEekjvy3w3/0ARqZgr4i76kE/kBT8h5pKtJxgNrQeuxK1C3JAukPWD?=
 =?us-ascii?Q?0fR9vBHHjbA0DW/U7E/X42V9Z456+chEW5vIm7a+J9yKgc09jPVZIl5YSIFn?=
 =?us-ascii?Q?DkqgUBhRJtUdiBkep/J2Q2QfjGb3Pmnu2FekEXLqec7IVbcpHh/9mleu1kPr?=
 =?us-ascii?Q?U/49PvoXKNETzpAGM+1OtS61tdMYZqcsPypNFNf/QHpCfpy07V1Szp83wHsI?=
 =?us-ascii?Q?BKSFsYhBBA7H22BdNrZ9mY4CIXPgHJMEpf12BhQnXvGz05CjIVYg9/gaTj8K?=
 =?us-ascii?Q?/6SZBugtrI1MuB8nG0wof3mHPmU9SBqkB0zXNJ5UyyVPAurixVwEPMO2b0FP?=
 =?us-ascii?Q?qqkJUS9tZVullNpl/3ExdiWHQavyVsJ7nLpwxhWWlQy6TO2UwddP71bvKQpP?=
 =?us-ascii?Q?+EagDNlV5FjB0E+s5LR1kJjvjUYtviKnkxlX2NfePdpH13OwTj9teF2PHD8d?=
 =?us-ascii?Q?tgP2WOZZfQBEHqDPDcwVPnXBXduPvZXmmcg3HWm6NGQXZI7OdDIyv7TcE2ng?=
 =?us-ascii?Q?v1o11utvambJTt0r/8Hw2glLz+lH5Qs+0p6EwsfM7ZzLAmfXn+8zec7IEkev?=
 =?us-ascii?Q?H0lyDqxZTuopMDNwOaXzoVDBK52/uV68S98w1jHRo9jZrgSWczqv//IxI+qP?=
 =?us-ascii?Q?O2HeYpxy2Wld8dWeWxbbdcG237BosB+4Sb8/hdy0szFYDuLy2P6EaAdutfYb?=
 =?us-ascii?Q?5y8K/xASFlfQC36BG4ry9xgq3s9vdvpafUIzUVOBFngEAg1yoscINCvGF4BC?=
 =?us-ascii?Q?uDQXJQsBOFX5YsHpmkkosrRSxqEXWaqRPSm/ZoKcpNSWtz0pPFBtu7QXc2s4?=
 =?us-ascii?Q?r4FzTgchA7LTNu03c4C5RSw5O3YcHmyTjEMpzt5D7dSSReaYGLmtUeXZ2CGX?=
 =?us-ascii?Q?yl9iFxKk/YnaHepLHzGmxlK5NpG3E7qugmROUdD0J/4IIeQxLUC8pneF2U70?=
 =?us-ascii?Q?PU6kr38MOLuy5/hiDVP7eBccxK3voZSBbJFoH5kXQuOJFyGZm/IuKHXwu6QH?=
 =?us-ascii?Q?g2wrgXcfoRUxC7YfjIsVDiV9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 595161be-6682-41d4-b466-08d8f6f78df6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:23:57.4114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQsTqkqyj8lxqW0dg17vxIPZCxXXst9V9kxipiCt0UptJPDB3iDSvZMg5AB6xvmH3jYf38cTSZNQTYNgPqW+JWBK4G6fgScyb+J37J4up+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-GUID: Td3M8OuZpHTBTDkU-EchgQxAOnilX0uB
X-Proofpoint-ORIG-GUID: Td3M8OuZpHTBTDkU-EchgQxAOnilX0uB
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_host_template cmd_size so the block/scsi-ml layers allocate the
iscsi structs for the driver.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 42 +++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 54c1d0a2484c..36e81eb567b2 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -14,6 +14,9 @@
 #include "qedi_iscsi.h"
 #include "qedi_gbl.h"
 
+static int qedi_exit_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc);
+static int qedi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc);
+
 int qedi_recover_all_conns(struct qedi_ctx *qedi)
 {
 	struct qedi_conn *qedi_conn;
@@ -59,6 +62,9 @@ struct scsi_host_template qedi_host_template = {
 	.dma_boundary = QEDI_HW_DMA_BOUNDARY,
 	.cmd_per_lun = 128,
 	.shost_attrs = qedi_shost_attrs,
+	.cmd_size = sizeof(struct qedi_cmd) + sizeof(struct iscsi_task),
+	.init_cmd_priv = qedi_init_cmd_priv,
+	.exit_cmd_priv = qedi_exit_cmd_priv,
 };
 
 static void qedi_conn_free_login_resources(struct qedi_ctx *qedi,
@@ -170,10 +176,10 @@ static void qedi_free_sget(struct qedi_ctx *qedi, struct qedi_cmd *cmd)
 			  cmd->io_tbl.sge_tbl, cmd->io_tbl.sge_tbl_dma);
 }
 
-static void qedi_free_task_priv(struct iscsi_session *session,
-				struct iscsi_task *task)
+static void __qedi_free_task_priv(struct Scsi_Host *shost,
+				  struct iscsi_task *task)
 {
-	struct qedi_ctx *qedi = iscsi_host_priv(session->host);
+	struct qedi_ctx *qedi = iscsi_host_priv(shost);
 	struct qedi_cmd *cmd = task->dd_data;
 
 	qedi_free_sget(qedi, cmd);
@@ -183,6 +189,18 @@ static void qedi_free_task_priv(struct iscsi_session *session,
 				  cmd->sense_buffer, cmd->sense_buffer_dma);
 }
 
+static void qedi_free_task_priv(struct iscsi_session *session,
+				struct iscsi_task *task)
+{
+	return __qedi_free_task_priv(session->host, task);
+}
+
+static int qedi_exit_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+{
+	__qedi_free_task_priv(shost, scsi_cmd_priv(sc));
+	return 0;
+}
+
 static int qedi_alloc_sget(struct qedi_ctx *qedi, struct qedi_cmd *cmd)
 {
 	struct qedi_io_bdt *io = &cmd->io_tbl;
@@ -202,10 +220,10 @@ static int qedi_alloc_sget(struct qedi_ctx *qedi, struct qedi_cmd *cmd)
 	return 0;
 }
 
-static int qedi_alloc_task_priv(struct iscsi_session *session,
-				struct iscsi_task *task)
+static int __qedi_alloc_task_priv(struct Scsi_Host *shost,
+				  struct iscsi_task *task)
 {
-	struct qedi_ctx *qedi = iscsi_host_priv(session->host);
+	struct qedi_ctx *qedi = iscsi_host_priv(shost);
 	struct qedi_cmd *cmd = task->dd_data;
 
 	task->hdr = &cmd->hdr;
@@ -228,6 +246,18 @@ static int qedi_alloc_task_priv(struct iscsi_session *session,
 	return -ENOMEM;
 }
 
+static int qedi_alloc_task_priv(struct iscsi_session *session,
+				struct iscsi_task *task)
+{
+	return __qedi_alloc_task_priv(session->host, task);
+}
+
+static int qedi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+{
+	iscsi_init_cmd_priv(shost, sc);
+	return __qedi_alloc_task_priv(shost, scsi_cmd_priv(sc));
+}
+
 static struct iscsi_cls_session *
 qedi_session_create(struct iscsi_endpoint *ep, u16 cmds_max,
 		    u16 qdepth, uint32_t initial_cmdsn)
-- 
2.25.1

