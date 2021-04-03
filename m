Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF993C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CDDE6135F
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236919AbhDCXYH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45054 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236894AbhDCXYH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NLVcU040082;
        Sat, 3 Apr 2021 23:23:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=5tP7zD9lOE7cHvC1wwrp0NHGNmfmUqOUhuu6zpc83Gs=;
 b=bjhCBCZlYDitA/uR/fOQNnikyJnDhXZlAj0lvadW84RzDOObgEpMv9fIqcEi3x1exaET
 f+rAXqitWS1PiYzvM29kLL35mhjMooGo074flsRUrtgb4Cqd/ZnFoqwCIZceQwt5GWnx
 kbbj3kpxsANNfb+QqfT8APLKYXXzXfW6jMUTJoviOj64C5LgddtWTqoWbZp7bCHWsBmR
 h2b+Deq0UfC+bEzXKhQNqeySSi5a7HBGM8Q74b+e12RrIBkcyIep7U7QHX4qw6dJ/csS
 YNh3uVYL1kxGkkUoV9j86M2A6NGCao5JNYmwuUZQxr1rYT61wEcJDPNUNGttV5aY+Qll 6A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37pfsrrsh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtAb116931;
        Sat, 3 Apr 2021 23:23:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3020.oracle.com with ESMTP id 37pfpkbskt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzAkDSklXUH9H5IH3JB9MI6Vw4Kb/rV9p2qTiKJfRSuwz33tEJwWvEMmP8znkpoRMElXKj/0sEvavs60Ijj+oVxmeNGTeRXUWMGrRzi54//9BrwmU+8U0RZ+sP9ru0MSl6hhP4AKrPHG+likR5C0zug4LfCX7xs6DqDwfZSi5QNOYjGuvbZbUi5JpBRrQaDFJE/hp9LimRjBkpxtlDW1eRSu5kXkHGOJFtHjBrDfrcdC9SzTFCnxuaTMnlU3yiac8AicnXVZjqnFXGmQZaDuuCJ2CTdIPJqB3lAV+MDiKWZ7il+1iqMqFEwQqOGHcFHTpOqDsmxGOMlYC3otxY78nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tP7zD9lOE7cHvC1wwrp0NHGNmfmUqOUhuu6zpc83Gs=;
 b=T9nfFoeElcSSHxa+1D49t598UrJqkkB7QL5oflYip6mmpMAGncGkSXibgSS28Xr+AnzgQjO2GH2gWDptDgOTM+uJyedaJf2l7vaMakoLE8itGfmj9ge3mCHM3PSXBc43E+9tayhaKZV9bfQErHCZipDGguF3a85Nxy6bORvgu7usHP5wEBhLyTGB4n2c1MimPBT9iEyzfnGnWmv8kl53uA7LjvBFJAxXyD3jbKn4eNawthEAWZXcQnWa5Y4wW/YpKdTeBILaVBymsKwx4rzYzGkmOgN0HTFgERIpLgsB3hrXFm+pMO0Q+Ka8lTpsE206nODj/o1DKU17/mbfMSxsaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tP7zD9lOE7cHvC1wwrp0NHGNmfmUqOUhuu6zpc83Gs=;
 b=KdxSDI22bFtXpOvg67ub+CnhmItYzbJdnIT7kGE/ADrgs0veBEyLflZa7dD5v5Elqg6pVLng0Ge2H0AIpfUwWE9MrulQ7OrcdsaLIjx3bslScBLCiZf2xvj90DvrBQU0TASXM/mJySzMZK5P1le3cTJq6JkZRF9MgA5KN95SYGA=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:23:52 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:23:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 06/40] scsi: qedi: implement alloc_task_priv/free_task_priv
Date:   Sat,  3 Apr 2021 18:22:59 -0500
Message-Id: <20210403232333.212927-7-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:23:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b3beca4-f4e7-4553-4e23-08d8f6f78ac3
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3526B6B52C13DC95F79479F6F1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6JjBfCe7VDIb1HAtV1Cm6s/iRAAOEjZ19ZB/Nz0e6J6JWD5Ty0nByyFG1pRui4cmV4d5oXJ811GWT+EJ22c4ruFPExvcxaJtuKc2uzM9xv9yTMb8bPP1ZdGd3u0hKC3WH95/q4qy71p8y4XTv/fDwaWUVCLSCgvHaRNqOna4QUiN1SpMRkNw/vkrh2UQ7Ti3FJTIHEJg5mQkXm2E/mYayTN/sJUXa1UWUjX+jgW+9OIGFnqnesOxlpJtDWjeql26Wn7CDnGLBR/uCB86obJbXfVP8xb+4nELiaNdS/xZh+i1m2ctXEY4GbErkWAxJbhZfXG9stA28gZZMS2dcwj5bW5sw6vdmy/yPnn9mMUTyPgKAdffGqHpRYob6frWQLAqrtMUukwq6nV8MNq2lNqWn+Ia4qCjNJk2zG6U6ob7Xhjuv1i01opLvcUlLVB9+iHL+DsRztwd7ZEksj6k/k1FgcgKo6Ds9PwqOJvbMA4BFL7xvgsgWfudjKg96ZRQdz69a6uDvJ1iTCbk/vmozBQgEv8ETRNzPQdKOE5+Sc3e1TUdBbpbfJqnRr2VDQjo7dztQjdWpshLgNk8KcaeAjjuhkMfXhf+H3frf3ZNbVisZN4OOIVlQ/CLuCyDPRuymCQAoRRx9GeoYUgjs83W0MncXSmq7At8wnI2wpUyAJt2iBVpXtptwS2ARzkEK4ttEz/SwcZ0hGY0BXJGJZcykpcAZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?K4us9ks9U7bNRmbHHnl4NZgbRSq73RRj5gsQuJZsnPbKUgYiZ1mNEj8aVz3E?=
 =?us-ascii?Q?aJ+xfgKhMn/fRShO6k+QuK/ZjP4Te+iIWYRO6WVuxiZSi/1PQ6BE1/cigITh?=
 =?us-ascii?Q?mJET4ILWmsiPzrNdfDJnCfWbgz8squhRJJmuR5eEg1DFgaX8zqXuKek0+rPq?=
 =?us-ascii?Q?t/jmOQYboI3QKCixXtB9WN7RgfmnNqQ0F/HlDZsOTulHxrUFVMY4kVU9qRY2?=
 =?us-ascii?Q?FHq3z5svkuv3efu2b/F7YNZqJVaRybGDlAOOfI7UmwZdMm+e08RROlG3VyPV?=
 =?us-ascii?Q?U+LKcLUaNJtUShKh/A+ErzyRktZ/p0DQ+/je0+DIdY1rwjNZprIVOPS7gG5V?=
 =?us-ascii?Q?/Obcng3MIF8LgcDz6jUviUVihJz33wnz0kwSEortQNdlCe3YUIlXjLv9vf9V?=
 =?us-ascii?Q?es4QesI0twt4OR++pKn29fMBQQyu2JGweB+YyI83alse4gTwTyIgFJRy6j1j?=
 =?us-ascii?Q?jpXDc89f40kFP1Xga/VvoOJF8bp9GhppMGzb07xW+Ju3zXVTBe0pQa6khi1v?=
 =?us-ascii?Q?c1/vyKwIEzFuuQGownco0AmgMUplvc143szX8wjaFRAGSYKPE/8Jqx9SB6U+?=
 =?us-ascii?Q?1sRKL7H+MeRl5q9G9UgnT3JGps8XbzGSIinwzmO3T4pcaUfqhy3xM2GDMXP+?=
 =?us-ascii?Q?SX8/JjZ1gKsSoG5rGkGxQCdq/tLHhl+NVeYvI2TZav1Sv9qptbdZTrYwQbpl?=
 =?us-ascii?Q?XsmLUNsDY6HORez4990UMIJ98f4GfsW0AKG5clEO9CzGrzl63RPQGBdj6xx3?=
 =?us-ascii?Q?6Gc/B7AtC/r9a2dB7LJN+iV3SRwB/gFxCwrPea/nAAUijqaD3BeVKchpogqy?=
 =?us-ascii?Q?EQ2+9Pzo9Wk/fFrjrF26acgaNCYWFCzw3TvzlaLTjYBu6wPW/cowl/D/Uck/?=
 =?us-ascii?Q?JDaym6s2RrEqc9FzAJQE5rrmxdwHQIyXi7oZ3wC3H7qrYWtRyfSPhjAt7Xa/?=
 =?us-ascii?Q?bUELtveV7EtX//E1JXhXKvmL69qj03CTJgpwipl1drhCYVyWNQB/A6ZHjP+o?=
 =?us-ascii?Q?Gn9maefNZ+lGrnRgAoyCc6IMJpL1xAe5HtVzxph2kUS/0//rcxBO14JLqzEE?=
 =?us-ascii?Q?loHEQtSaETx4HHbmU1GFBdcRY+WvF4Frr/vWB+S/Z00xvkSjnzVUZhxUTqZ5?=
 =?us-ascii?Q?F0T2hLaMBvE65wSGZ7NiHxvLMBYwORB+xQpxgDSYGdcCFKuG4amt1o9ejYRd?=
 =?us-ascii?Q?TATRo93XdMpY/4H9ARzTyiDs8QMerXz3u0fBxO1JmcduJEtLl6nEcTpYRRbF?=
 =?us-ascii?Q?MRWCHO4gJMiT+ID2E8cOX9IeeAS0/v17x4TJNVAt01DHYlu9Tm9KTLS+s6Jh?=
 =?us-ascii?Q?d44uZ11Zya1Kttq33Secegql?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3beca4-f4e7-4553-4e23-08d8f6f78ac3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:23:52.0494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUjRYli5uNsDcmvLLHxbitdtpw9miEeyb8P8b3zM/Hc5lG9Wj3kREBrcpfzi9sKByW2hUj2pHUdKuV5FCiy3F43q1Se4rSeJjUUKdfnKI3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: 6c-J_sEGp7OW3VmoU1vCKE5afOESgADX
X-Proofpoint-GUID: 6c-J_sEGp7OW3VmoU1vCKE5afOESgADX
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Have qedi use the alloc_task_priv/free_task_priv instead of rolling its
own loops.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 106 +++++++++++++--------------------
 1 file changed, 41 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 0a85b347297c..54c1d0a2484c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -160,32 +160,30 @@ static int qedi_conn_alloc_login_resources(struct qedi_ctx *qedi,
 	return -ENOMEM;
 }
 
-static void qedi_destroy_cmd_pool(struct qedi_ctx *qedi,
-				  struct iscsi_session *session)
+static void qedi_free_sget(struct qedi_ctx *qedi, struct qedi_cmd *cmd)
 {
-	int i;
+	if (!cmd->io_tbl.sge_tbl)
+		return;
 
-	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct qedi_cmd *cmd = task->dd_data;
-
-		if (cmd->io_tbl.sge_tbl)
-			dma_free_coherent(&qedi->pdev->dev,
-					  QEDI_ISCSI_MAX_BDS_PER_CMD *
-					  sizeof(struct scsi_sge),
-					  cmd->io_tbl.sge_tbl,
-					  cmd->io_tbl.sge_tbl_dma);
-
-		if (cmd->sense_buffer)
-			dma_free_coherent(&qedi->pdev->dev,
-					  SCSI_SENSE_BUFFERSIZE,
-					  cmd->sense_buffer,
-					  cmd->sense_buffer_dma);
-	}
+	dma_free_coherent(&qedi->pdev->dev,
+			  QEDI_ISCSI_MAX_BDS_PER_CMD * sizeof(struct scsi_sge),
+			  cmd->io_tbl.sge_tbl, cmd->io_tbl.sge_tbl_dma);
 }
 
-static int qedi_alloc_sget(struct qedi_ctx *qedi, struct iscsi_session *session,
-			   struct qedi_cmd *cmd)
+static void qedi_free_task_priv(struct iscsi_session *session,
+				struct iscsi_task *task)
+{
+	struct qedi_ctx *qedi = iscsi_host_priv(session->host);
+	struct qedi_cmd *cmd = task->dd_data;
+
+	qedi_free_sget(qedi, cmd);
+
+	if (cmd->sense_buffer)
+		dma_free_coherent(&qedi->pdev->dev, SCSI_SENSE_BUFFERSIZE,
+				  cmd->sense_buffer, cmd->sense_buffer_dma);
+}
+
+static int qedi_alloc_sget(struct qedi_ctx *qedi, struct qedi_cmd *cmd)
 {
 	struct qedi_io_bdt *io = &cmd->io_tbl;
 	struct scsi_sge *sge;
@@ -195,8 +193,8 @@ static int qedi_alloc_sget(struct qedi_ctx *qedi, struct iscsi_session *session,
 					 sizeof(*sge),
 					 &io->sge_tbl_dma, GFP_KERNEL);
 	if (!io->sge_tbl) {
-		iscsi_session_printk(KERN_ERR, session,
-				     "Could not allocate BD table.\n");
+		shost_printk(KERN_ERR, qedi->shost,
+			    "Could not allocate BD table.\n");
 		return -ENOMEM;
 	}
 
@@ -204,33 +202,29 @@ static int qedi_alloc_sget(struct qedi_ctx *qedi, struct iscsi_session *session,
 	return 0;
 }
 
-static int qedi_setup_cmd_pool(struct qedi_ctx *qedi,
-			       struct iscsi_session *session)
+static int qedi_alloc_task_priv(struct iscsi_session *session,
+				struct iscsi_task *task)
 {
-	int i;
+	struct qedi_ctx *qedi = iscsi_host_priv(session->host);
+	struct qedi_cmd *cmd = task->dd_data;
 
-	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct qedi_cmd *cmd = task->dd_data;
+	task->hdr = &cmd->hdr;
+	task->hdr_max = sizeof(struct iscsi_hdr);
 
-		task->hdr = &cmd->hdr;
-		task->hdr_max = sizeof(struct iscsi_hdr);
+	if (qedi_alloc_sget(qedi, cmd))
+		return -ENOMEM;
 
-		if (qedi_alloc_sget(qedi, session, cmd))
-			goto free_sgets;
-
-		cmd->sense_buffer = dma_alloc_coherent(&qedi->pdev->dev,
-						       SCSI_SENSE_BUFFERSIZE,
-						       &cmd->sense_buffer_dma,
-						       GFP_KERNEL);
-		if (!cmd->sense_buffer)
-			goto free_sgets;
-	}
+	cmd->sense_buffer = dma_alloc_coherent(&qedi->pdev->dev,
+					       SCSI_SENSE_BUFFERSIZE,
+					       &cmd->sense_buffer_dma,
+					       GFP_KERNEL);
+	if (!cmd->sense_buffer)
+		goto free_sgets;
 
 	return 0;
 
 free_sgets:
-	qedi_destroy_cmd_pool(qedi, session);
+	qedi_free_sget(qedi, cmd);
 	return -ENOMEM;
 }
 
@@ -264,27 +258,7 @@ qedi_session_create(struct iscsi_endpoint *ep, u16 cmds_max,
 		return NULL;
 	}
 
-	if (qedi_setup_cmd_pool(qedi, cls_session->dd_data)) {
-		QEDI_ERR(&qedi->dbg_ctx,
-			 "Failed to setup cmd pool for ep=%p\n", qedi_ep);
-		goto session_teardown;
-	}
-
 	return cls_session;
-
-session_teardown:
-	iscsi_session_teardown(cls_session);
-	return NULL;
-}
-
-static void qedi_session_destroy(struct iscsi_cls_session *cls_session)
-{
-	struct iscsi_session *session = cls_session->dd_data;
-	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
-	struct qedi_ctx *qedi = iscsi_host_priv(shost);
-
-	qedi_destroy_cmd_pool(qedi, session);
-	iscsi_session_teardown(cls_session);
 }
 
 static struct iscsi_cls_conn *
@@ -1398,7 +1372,7 @@ struct iscsi_transport qedi_iscsi_transport = {
 	.caps = CAP_RECOVERY_L0 | CAP_HDRDGST | CAP_MULTI_R2T | CAP_DATADGST |
 		CAP_DATA_PATH_OFFLOAD | CAP_TEXT_NEGO,
 	.create_session = qedi_session_create,
-	.destroy_session = qedi_session_destroy,
+	.destroy_session = iscsi_session_teardown,
 	.create_conn = qedi_conn_create,
 	.bind_conn = qedi_conn_bind,
 	.start_conn = qedi_conn_start,
@@ -1410,6 +1384,8 @@ struct iscsi_transport qedi_iscsi_transport = {
 	.get_session_param = iscsi_session_get_param,
 	.get_host_param = qedi_host_get_param,
 	.send_pdu = iscsi_conn_send_pdu,
+	.alloc_task_priv = qedi_alloc_task_priv,
+	.free_task_priv = qedi_free_task_priv,
 	.get_stats = qedi_conn_get_stats,
 	.xmit_task = qedi_task_xmit,
 	.cleanup_task = qedi_cleanup_task,
@@ -1626,7 +1602,7 @@ void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
 
 	qedi_conn_destroy(qedi_conn->cls_conn);
 
-	qedi_session_destroy(cls_sess);
+	iscsi_session_teardown(cls_sess);
 }
 
 void qedi_process_tcp_error(struct qedi_endpoint *ep,
-- 
2.25.1

