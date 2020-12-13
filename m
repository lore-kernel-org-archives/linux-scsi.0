Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37800C4361B
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C6F62310E
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391136AbgLMDL2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 22:11:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60434 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388075AbgLMDKB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2020 22:10:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD33uJR025227;
        Sun, 13 Dec 2020 03:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=D23mk0qRU0UVrg1eGFN94vtqjoxw5kg0wo/O2AodQU4=;
 b=qjFahGt6WitNkw3zzFHymyGNjRRNuD6pk3YgSFo/l0zevFLoRmtJ2pOSpc9j55lg45tg
 TqWoKNii5wYX+dQFFewFIRqRrDVv0u9kX4RD5+CsrRTdk0neqR/X7G0Yjnb4CLF5g1Xg
 GuzyZDAExZ8nLPzKpRQZ9ebXV7I2YUDbTIv8mtLU7tb5Fym5T0z/W8rNJ9sw/cBp3jxH
 q7UPW78o/sksZPlqkEyNTfH+cYHcG6Kzt2KLzWwBP01lJ+Zyax/1ZRWGuOAufyx26qd0
 JhpfMkZmLI2lXzc0PG9S6EvkN5MM35wmuGSyI6+TUR0Bk9DOZXqJtuKP+7Q73h7zizU6 /Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35cntkshba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Dec 2020 03:09:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD354ZQ122396;
        Sun, 13 Dec 2020 03:09:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35d7mnkn16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 03:09:10 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BD399fx010625;
        Sun, 13 Dec 2020 03:09:09 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Dec 2020 19:09:09 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [RFC PATCH 13/18] qedi: set scsi_host_template cmd_size
Date:   Sat, 12 Dec 2020 21:08:41 -0600
Message-Id: <1607828926-3658-14-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
References: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012130023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012130023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_host_template cmd_size so the block/scsi-ml layers allocate
the iscsi structs for the driver.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index a76f595..56d3775 100644
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
1.8.3.1

