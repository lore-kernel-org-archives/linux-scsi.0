From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH 1/1] fnic: Zero io_cmpl_skip on fw reset completion
Date: Mon, 26 Jun 2017 17:46:23 -0700
Message-ID: <1498524383-32398-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-6.cisco.com ([173.37.142.93]:37538 "EHLO
        alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdF0A4i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 20:56:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: satishkh@cisco.com, Sesidhar Baddela <sebaddel@cisco.com>

io_cmpl_skip keep track of number of completions to skip when
stats are reset. If a fw_reset happens immediately after stats
reset it could put it out of sync so need to reset io_cmpl_skip
when fw reset is completed.

Signed-off-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index d048f3b..beea14c 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -633,6 +633,7 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 
 	atomic64_set(&fnic->fnic_stats.fw_stats.active_fw_reqs, 0);
 	atomic64_set(&fnic->fnic_stats.io_stats.active_ios, 0);
+	atomic64_set(&fnic->io_cmpl_skip, 0);
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 
-- 
2.7.4
