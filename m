From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 02/17] Clean up scsi_ioctl_reset()
Date: Fri, 23 Jan 2015 13:06:52 +0100
Message-ID: <54C2395C.7050006@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0084.outbound.protection.outlook.com ([157.56.111.84]:57344
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750911AbbAWMG6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:06:58 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Since SG_SCSI_RESET causes a task management function to be sent
and since LLDs only check the sc_data_direction field inside the
queueucommand callback function, the sc_data_direction member
does not have to be set here. Hence remove the sc_data_direction
assignment.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/scsi/scsi_error.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 8afb016..9ee4830 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2346,8 +2346,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 
 	scmd->cmd_len			= 0;
 
-	scmd->sc_data_direction		= DMA_BIDIRECTIONAL;
-
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->tmf_in_progress = 1;
 	spin_unlock_irqrestore(shost->host_lock, flags);
-- 
2.1.2

