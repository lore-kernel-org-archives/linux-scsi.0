Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904CCCA9EA0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 08:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64CCA2086D
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 08:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731718AbfJ1IrR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 04:47:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:40102 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731611AbfJ1IrR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Oct 2019 04:47:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 15622B249;
        Mon, 28 Oct 2019 08:47:13 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH] scsi: qla2xxx: Check return value of alloc_workqueue()
Date:   Mon, 28 Oct 2019 09:47:09 +0100
Message-Id: <20191028084709.81538-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do not derefence the pointer without checking it
first. alloc_workqueue() can return a NULL pointer.

Reported-by: Semmle vulnerability research team <security-reports@semmle.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 16f9b6ed574a..040f82ccacba 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3224,6 +3224,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    req->req_q_in, req->req_q_out, rsp->rsp_q_in, rsp->rsp_q_out);
 
 	ha->wq = alloc_workqueue("qla2xxx_wq", 0, 0);
+	if (!ha->wq) {
+		ret = -ENOMEM;
+		goto probe_failed;
+	}
 
 	if (ha->isp_ops->initialize_adapter(base_vha)) {
 		ql_log(ql_log_fatal, base_vha, 0x00d6,
-- 
2.16.4

