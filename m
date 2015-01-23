From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 07/17] sbp2: Fix bidi command test
Date: Fri, 23 Jan 2015 13:09:38 +0100
Message-ID: <54C23A02.9010807@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0078.outbound.protection.outlook.com ([157.56.110.78]:5563
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753573AbbAWMYW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:24:22 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>

The SCSI core never sets sc_data_direction to DMA_BIDIRECTIONAL.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 64ac8f8..ab1b114 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1467,7 +1467,7 @@ static int sbp2_scsi_queuecommand(struct Scsi_Host *shost,
 	 * Bidirectional commands are not yet implemented, and unknown
 	 * transfer direction not handled.
 	 */
-	if (cmd->sc_data_direction == DMA_BIDIRECTIONAL) {
+	if (scsi_bidi_cmnd(cmd)) {
 		dev_err(lu_dev(lu), "cannot handle bidirectional command\n");
 		cmd->result = DID_ERROR << 16;
 		cmd->scsi_done(cmd);
-- 
2.1.2

