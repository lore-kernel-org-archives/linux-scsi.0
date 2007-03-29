From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 06/12] ipr: Fix for oops following SATA request sense
Date: Thu, 29 Mar 2007 12:43:17 -0500
Message-ID: <200703291743.l2THhHOS005163@d01av03.pok.ibm.com>
References: <11751901593854-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54259 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934308AbXC2RnT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Mar 2007 13:43:19 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2THhIih021590
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:43:18 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2THhIc5258044
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:43:18 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2THhHaE005206
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:43:18 -0400
In-Reply-To: <11751901593854-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


This patch fixes a problem discovered on a system with some
bad SATA devices attached. If a command to a SATAPI device
times out and the device gets reset as part of error recovery,
its possible that ipr will set err_mask to indicate a device
error has occurred. If this happens, a request sense will get
issued by libata. Since scsi core thinks this scsi command is
now completed, because the device reset handler completed successfully,
scsi core will free the associated scsi command, which may
cause an oops when that request sense is completed later
by ipr. This patch ensures that any commands that get aborted
as a result of a device reset set err_mask appropriately so
that the request sense does not get sent.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_sata_req_sense_oops drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_sata_req_sense_oops	2007-03-23 15:24:19.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-03-23 15:24:19.000000000 -0500
@@ -3846,6 +3846,8 @@ static int __ipr_eh_dev_reset(struct scs
 		if (ipr_cmd->ioarcb.res_handle == res->cfgte.res_handle) {
 			if (ipr_cmd->scsi_cmd)
 				ipr_cmd->done = ipr_scsi_eh_done;
+			if (ipr_cmd->qc)
+				ipr_cmd->done = ipr_sata_eh_done;
 			if (ipr_cmd->qc && !(ipr_cmd->qc->flags & ATA_QCFLAG_FAILED)) {
 				ipr_cmd->qc->err_mask |= AC_ERR_TIMEOUT;
 				ipr_cmd->qc->flags |= ATA_QCFLAG_FAILED;
_
