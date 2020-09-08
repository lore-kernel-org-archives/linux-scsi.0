Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4349C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 05:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B595218AC
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 05:25:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Xvhe5Ewi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgIHFZ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 01:25:56 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21160 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726387AbgIHFZ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 01:25:56 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0885P6T2023585;
        Mon, 7 Sep 2020 22:25:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=YEpPZMPUwjCQEOiS7LdbJoPf6GPTRDhC0REuNSK83IE=;
 b=Xvhe5EwibuESP/GjYZktshgkIqYy7SkcOkhWdTpOdK5VBPQW0Xt8xVwtnYNsHVkqoiMP
 JMk+nqtchSGTAgYPYg92Azgq4vs1AX3JklktwU8/rVEQWgM3tRaeY1CQgZXWjfs9nXFh
 jnNh6vvOij8FDgONFkqndUftyE7NpwRjXZWPVeqb5Yu2lQPCNG6fTCEIubP2k7243iYr
 zajViFhP9UywSYt3vFyFuWkD9mquMJFoTJuyspmNOWxkbpPJAZ/e9LQ5LheMBQMrBxjI
 lDuCgo/Cc7X+ey8onZS+twwTAyP6zIEV0u16OccV2Q8Pq567CxXtV21oRP+2meaPS+Fm 0w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81pt6b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 22:25:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 22:25:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 22:25:49 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id F37553F703F;
        Mon,  7 Sep 2020 22:25:48 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0885PmkU021973;
        Mon, 7 Sep 2020 22:25:48 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0885Pmr9021972;
        Mon, 7 Sep 2020 22:25:48 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 3/8] qedi: Fix list_del corruption while removing active IO
Date:   Mon, 7 Sep 2020 22:24:07 -0700
Message-ID: <20200908052412.21917-4-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200908052412.21917-1-mrangankar@marvell.com>
References: <20200908052412.21917-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_02:2020-09-07,2020-09-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

While aborting the IO, the FW cleanup task timed out and driver
deleted the IO from active command list. Some time later, the FW
sends the cleanup task response and driver again deletes the IO
from active command list causing FW to send IO completion for
non-existent IO and list_del corruption of active command list.

Add fix to check if IO is present before deleting the i/o from active
command list ensuring FW sends valid i/o completion and protect the
list_del corruption.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 6ed74583b1b9..34c477bda8a4 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -816,8 +816,11 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			qedi_clear_task_idx(qedi_conn->qedi, rtid);
 
 			spin_lock(&qedi_conn->list_lock);
-			list_del_init(&dbg_cmd->io_cmd);
-			qedi_conn->active_cmd_count--;
+			if (likely(dbg_cmd->io_cmd_in_list)) {
+				dbg_cmd->io_cmd_in_list = false;
+				list_del_init(&dbg_cmd->io_cmd);
+				qedi_conn->active_cmd_count--;
+			}
 			spin_unlock(&qedi_conn->list_lock);
 			qedi_cmd->state = CLEANUP_RECV;
 			wake_up_interruptible(&qedi_conn->wait_queue);
@@ -1235,6 +1238,7 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_conn,
 		qedi_conn->cmd_cleanup_req++;
 		qedi_iscsi_cleanup_task(ctask, true);
 
+		cmd->io_cmd_in_list = false;
 		list_del_init(&cmd->io_cmd);
 		qedi_conn->active_cmd_count--;
 		QEDI_WARN(&qedi->dbg_ctx,
@@ -1446,8 +1450,11 @@ static void qedi_tmf_work(struct work_struct *work)
 	spin_unlock_bh(&qedi_conn->tmf_work_lock);
 
 	spin_lock(&qedi_conn->list_lock);
-	list_del_init(&cmd->io_cmd);
-	qedi_conn->active_cmd_count--;
+	if (likely(cmd->io_cmd_in_list)) {
+		cmd->io_cmd_in_list = false;
+		list_del_init(&cmd->io_cmd);
+		qedi_conn->active_cmd_count--;
+	}
 	spin_unlock(&qedi_conn->list_lock);
 
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
-- 
2.25.0

