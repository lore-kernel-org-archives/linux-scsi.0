Return-Path: <SRS0=9nM7=7R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08934C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 10:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6803206DC
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 10:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgFDKHs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Jun 2020 06:07:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:48244 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgFDKHs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Jun 2020 06:07:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1CD49ABE2;
        Thu,  4 Jun 2020 10:07:50 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        linux-kernel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] qla2xxx: Set NVME status code for failed NVME FCP request
Date:   Thu,  4 Jun 2020 12:07:45 +0200
Message-Id: <20200604100745.89250-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The qla2xxx driver knows when request was processed successfully or
not. But it always sets the NVME status code to 0/NVME_SC_SUCCESS. The
upper layer needs to figure out from the rcv_rsplen and
transferred_length variables if the request was successfully. This is
not always possible, e.g. when the request data length is 0, the
transferred_length is also set 0 which is interpreted as success in
nvme_fc_fcpio_done(). Let's inform the upper
layer (nvme_fc_fcpio_done()) when something went wrong.

nvme_fc_fcpio_done() maps all non NVME_SC_SUCCESS status codes to
NVME_SC_HOST_PATH_ERROR. There isn't any benefit to map the QLA status
code to the NVME status code. Therefore, let's use NVME_SC_INTERNAL to
indicate an error which aligns it with the lpfc driver.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index d66d47a0f958..fa695a4007f8 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -139,11 +139,12 @@ static void qla_nvme_release_fcp_cmd_kref(struct kref *kref)
 	sp->priv = NULL;
 	if (priv->comp_status == QLA_SUCCESS) {
 		fd->rcv_rsplen = le16_to_cpu(nvme->u.nvme.rsp_pyld_len);
+		fd->status = NVME_SC_SUCCESS;
 	} else {
 		fd->rcv_rsplen = 0;
 		fd->transferred_length = 0;
+		fd->status = NVME_SC_INTERNAL;
 	}
-	fd->status = 0;
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
 	fd->done(fd);
-- 
2.16.4

