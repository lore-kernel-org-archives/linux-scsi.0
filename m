Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDD1C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 11:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B470206E3
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 11:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgGWL4n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 07:56:43 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:41932 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGWL4n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 07:56:43 -0400
Received: from fcoe-test11.asicdesigners.com (fcoe-test11.blr.asicdesigners.com [10.193.185.180])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06NBubgj012357;
        Thu, 23 Jul 2020 04:56:38 -0700
From:   Varun Prakash <varun@chelsio.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, dan.carpenter@oracle.com,
        dt@chelsio.com, ganji.aravind@chelsio.com, varun@chelsio.com
Subject: [next] scsi: libcxgbi: Remove unnecessary NULL checks for 'tdata' pointer
Date:   Thu, 23 Jul 2020 17:26:31 +0530
Message-Id: <1595505391-3335-1-git-send-email-varun@chelsio.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'tdata' pointer will never be NULL so remove NULL checks.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 932dbd4..71aebaf 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1899,7 +1899,7 @@ int cxgbi_conn_alloc_pdu(struct iscsi_task *task, u8 op)
 	u32 last_tdata_offset, last_tdata_count;
 	int err = 0;
 
-	if (!tcp_task || !tdata) {
+	if (!tcp_task) {
 		pr_err("task 0x%p, tcp_task 0x%p, tdata 0x%p.\n",
 		       task, tcp_task, tdata);
 		return -ENOMEM;
@@ -2155,7 +2155,7 @@ int cxgbi_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
 	struct page *pg;
 	int err;
 
-	if (!tcp_task || !tdata || tcp_task->dd_data != tdata) {
+	if (!tcp_task || (tcp_task->dd_data != tdata)) {
 		pr_err("task 0x%p,0x%p, tcp_task 0x%p, tdata 0x%p/0x%p.\n",
 		       task, task->sc, tcp_task,
 		       tcp_task ? tcp_task->dd_data : NULL, tdata);
@@ -2371,7 +2371,7 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 	u32 datalen;
 	int err;
 
-	if (!tcp_task || !tdata || (tcp_task->dd_data != tdata)) {
+	if (!tcp_task || (tcp_task->dd_data != tdata)) {
 		pr_err("task 0x%p,0x%p, tcp_task 0x%p, tdata 0x%p/0x%p.\n",
 		       task, task->sc, tcp_task,
 		       tcp_task ? tcp_task->dd_data : NULL, tdata);
@@ -2472,7 +2472,7 @@ void cxgbi_cleanup_task(struct iscsi_task *task)
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct cxgbi_task_data *tdata = iscsi_task_cxgbi_data(task);
 
-	if (!tcp_task || !tdata || (tcp_task->dd_data != tdata)) {
+	if (!tcp_task || (tcp_task->dd_data != tdata)) {
 		pr_info("task 0x%p,0x%p, tcp_task 0x%p, tdata 0x%p/0x%p.\n",
 			task, task->sc, tcp_task,
 			tcp_task ? tcp_task->dd_data : NULL, tdata);
-- 
2.0.2

