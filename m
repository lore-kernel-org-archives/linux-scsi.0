From: brking@us.ibm.com
Subject: [PATCH 15/16] ipr: Properly retry aborted reponse
Date: Wed, 04 Aug 2004 17:33:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042234.i74MYADg107288@northrelay04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:30347 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267482AbUHDWdK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 18:33:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


The ipr device driver runs tagged queuing with QERR=1. When a check condition
occurs on a device running tagged queuing, the other queued commands get aborted
by the ipr driver and will be returned by the adapter with the
IPR_IOASC_ABORTED_CMD_TERM_BY_HOST response. These commands should be retried by
the midlayer and their retry counter not decremented.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_aborted_response drivers/scsi/ipr.c
--- linux-2.6.8-rc3/drivers/scsi/ipr.c~ipr_aborted_response	2004-08-04 17:17:41.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c	2004-08-04 17:17:41.000000000 -0500
@@ -3728,7 +3728,7 @@ static void ipr_erp_start(struct ipr_ioa
 
 	switch (ioasc & IPR_IOASC_IOASC_MASK) {
 	case IPR_IOASC_ABORTED_CMD_TERM_BY_HOST:
-		scsi_cmd->result |= (DID_ERROR << 16);
+		scsi_cmd->result |= (DID_IMM_RETRY << 16);
 		break;
 	case IPR_IOASC_IR_RESOURCE_HANDLE:
 		scsi_cmd->result |= (DID_NO_CONNECT << 16);
_
