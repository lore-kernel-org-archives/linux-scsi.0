From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 35/36] aha1542: Fix bus reset
Date: Fri,  6 Feb 2015 23:11:56 +0100
Message-ID: <1423260717-15944-36-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56979 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758404AbbBFWQ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:16:28 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8J-0006fF-28
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:15 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Bus reset always fails because aha1542_reset waits for the controller to assert
the INIT bit (Mailbox Initialization Required) which it never does. This bit is
asserted only after host reset.

Remove the requirement for INIT bit (we really need only the IDLE bit).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 7b5d396..af821f3 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -867,7 +867,7 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 	outb(reset_cmd, CONTROL(cmd->device->host->io_port));
 
 	if (!wait_mask(STATUS(cmd->device->host->io_port),
-	     STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0)) {
+	     STATMASK, IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0)) {
 		spin_unlock_irqrestore(sh->host_lock, flags);
 		return FAILED;
 	}
-- 
Ondrej Zary

