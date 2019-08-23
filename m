Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F01C3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 13:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D48A621848
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 13:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389408AbfHWNRJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 09:17:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5646 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388055AbfHWNRI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 09:17:08 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C68DDA000D629C65E82D;
        Fri, 23 Aug 2019 21:16:33 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Fri, 23 Aug 2019
 21:16:23 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <QLogic-Storage-Upstream@qlogic.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 2/3] scsi: bnx2fc: remove set but not used variables 'lport','host'
Date:   Fri, 23 Aug 2019 21:22:52 +0800
Message-ID: <1566566573-49300-3-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566566573-49300-1-git-send-email-zhengbin13@huawei.com>
References: <1566566573-49300-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/bnx2fc/bnx2fc_io.c: In function bnx2fc_initiate_seq_cleanup:
drivers/scsi/bnx2fc/bnx2fc_io.c:932:19: warning: variable lport set but not used [-Wunused-but-set-variable]
drivers/scsi/bnx2fc/bnx2fc_io.c: In function bnx2fc_initiate_cleanup:
drivers/scsi/bnx2fc/bnx2fc_io.c:1001:19: warning: variable lport set but not used [-Wunused-but-set-variable]
drivers/scsi/bnx2fc/bnx2fc_io.c: In function bnx2fc_process_scsi_cmd_compl:
drivers/scsi/bnx2fc/bnx2fc_io.c:1882:20: warning: variable host set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 9e50e5b..da00ca5 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -930,7 +930,6 @@ int bnx2fc_initiate_abts(struct bnx2fc_cmd *io_req)
 int bnx2fc_initiate_seq_cleanup(struct bnx2fc_cmd *orig_io_req, u32 offset,
 				enum fc_rctl r_ctl)
 {
-	struct fc_lport *lport;
 	struct bnx2fc_rport *tgt = orig_io_req->tgt;
 	struct bnx2fc_interface *interface;
 	struct fcoe_port *port;
@@ -948,7 +947,6 @@ int bnx2fc_initiate_seq_cleanup(struct bnx2fc_cmd *orig_io_req, u32 offset,

 	port = orig_io_req->port;
 	interface = port->priv;
-	lport = port->lport;

 	cb_arg = kzalloc(sizeof(struct bnx2fc_els_cb_arg), GFP_ATOMIC);
 	if (!cb_arg) {
@@ -999,7 +997,6 @@ int bnx2fc_initiate_seq_cleanup(struct bnx2fc_cmd *orig_io_req, u32 offset,

 int bnx2fc_initiate_cleanup(struct bnx2fc_cmd *io_req)
 {
-	struct fc_lport *lport;
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	struct bnx2fc_interface *interface;
 	struct fcoe_port *port;
@@ -1015,7 +1012,6 @@ int bnx2fc_initiate_cleanup(struct bnx2fc_cmd *io_req)

 	port = io_req->port;
 	interface = port->priv;
-	lport = port->lport;

 	cleanup_io_req = bnx2fc_elstm_alloc(tgt, BNX2FC_CLEANUP);
 	if (!cleanup_io_req) {
@@ -1927,8 +1923,6 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 	struct fcoe_fcp_rsp_payload *fcp_rsp;
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	struct scsi_cmnd *sc_cmd;
-	struct Scsi_Host *host;
-

 	/* scsi_cmd_cmpl is called with tgt lock held */

@@ -1957,7 +1951,6 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 	/* parse fcp_rsp and obtain sense data from RQ if available */
 	bnx2fc_parse_fcp_rsp(io_req, fcp_rsp, num_rq);

-	host = sc_cmd->device->host;
 	if (!sc_cmd->SCp.ptr) {
 		printk(KERN_ERR PFX "SCp.ptr is NULL\n");
 		return;
--
2.7.4

