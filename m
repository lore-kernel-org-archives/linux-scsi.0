From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/8] qla2xxx: Defer explicit interrupt-polling processing to init-time scenarios.
Date: Fri, 19 Oct 2007 15:59:14 -0700
Message-ID: <1192834760-573-2-git-send-email-andrew.vasquez@qlogic.com>
References: <20071019225824.GG24197@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29143 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965782AbXJSW7g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 18:59:36 -0400
In-Reply-To: <20071019225824.GG24197@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

As the intermixing may cause issues where HCCR bits could be
cleared inappropriately during MSI/MSI-X interrupt handling.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 7f6a89b..024c662 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -525,7 +525,7 @@ qla2x00_req_pkt(scsi_qla_host_t *ha)
 
 		/* Check for pending interrupts. */
 		/* During init we issue marker directly */
-		if (!ha->marker_needed)
+		if (!ha->marker_needed && !ha->flags.init_done)
 			qla2x00_poll(ha);
 
 		spin_lock_irq(&ha->hardware_lock);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index c53ec67..ccd662a 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -252,7 +252,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 	/* Clean up */
 	ha->mcp = NULL;
 
-	if (!abort_active) {
+	if (abort_active || !io_lock_on) {
 		DEBUG11(printk("%s(%ld): checking for additional resp "
 		    "interrupt.\n", __func__, ha->host_no));
 
-- 
1.5.3.4.206.g58ba4

