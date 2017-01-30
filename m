From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] mvumi: remove fake transport template
Date: Mon, 30 Jan 2017 13:18:56 +0100
Message-ID: <1485778739-29036-2-git-send-email-hch@lst.de>
References: <1485778739-29036-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53928 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbdA3MTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2017 07:19:22 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cYAvM-0003oP-Q1
        for linux-scsi@vger.kernel.org; Mon, 30 Jan 2017 12:19:09 +0000
In-Reply-To: <1485778739-29036-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These days we can specify an eh_timed_out handler in the host_template,
so don't have a transport_template defintion just for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/mvumi.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 3928507..247df5e 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2225,15 +2225,12 @@ static struct scsi_host_template mvumi_template = {
 	.name = "Marvell Storage Controller",
 	.slave_configure = mvumi_slave_configure,
 	.queuecommand = mvumi_queue_command,
+	.eh_timed_out = mvumi_timed_out,
 	.eh_host_reset_handler = mvumi_host_reset,
 	.bios_param = mvumi_bios_param,
 	.this_id = -1,
 };
 
-static struct scsi_transport_template mvumi_transport_template = {
-	.eh_timed_out = mvumi_timed_out,
-};
-
 static int mvumi_cfg_hw_reg(struct mvumi_hba *mhba)
 {
 	void *base = NULL;
@@ -2451,7 +2448,6 @@ static int mvumi_io_attach(struct mvumi_hba *mhba)
 	host->cmd_per_lun = (mhba->max_io - 1) ? (mhba->max_io - 1) : 1;
 	host->max_id = mhba->max_target_id;
 	host->max_cmd_len = MAX_COMMAND_SIZE;
-	host->transportt = &mvumi_transport_template;
 
 	ret = scsi_add_host(host, &mhba->pdev->dev);
 	if (ret) {
-- 
2.1.4

