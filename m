From: brking@us.ibm.com
Subject: [PATCH 07/16] ipr: Dead adapter I/O hang fix
Date: Wed, 04 Aug 2004 17:32:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042233.i74MXPCu136800@northrelay02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:4090 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267472AbUHDWcP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 18:32:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


The following patch fixes a hang in i/o that could occur if an
adapter was ever declared "dead" by the ipr driver due to repeated
failed attempts to revive the card. The patch now allows ipr to fail
new commands when in this state rather than endlessly return
SCSI_MLQUEUE_HOST_BUSY.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_dead_ioa_hang drivers/scsi/ipr.c
--- linux-2.6.8-rc3/drivers/scsi/ipr.c~ipr_dead_ioa_hang	2004-08-04 17:17:30.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c	2004-08-04 17:17:30.000000000 -0500
@@ -3873,7 +3873,7 @@ static int ipr_queuecommand(struct scsi_
 	 * We have told the host to stop giving us new requests, but
 	 * ERP ops don't count. FIXME
 	 */
-	if (unlikely(!ioa_cfg->allow_cmds))
+	if (unlikely(!ioa_cfg->allow_cmds && !ioa_cfg->ioa_is_dead))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
 	/*
_
