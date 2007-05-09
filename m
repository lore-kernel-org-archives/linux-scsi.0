From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Proper return codes for eh_dev_reset for SATA devices
Date: Wed, 09 May 2007 15:36:35 -0500
Message-ID: <40433.2773098305$1178743008@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55522 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbXEIUgj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 May 2007 16:36:39 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l49KadUh018807
	for <linux-scsi@vger.kernel.org>; Wed, 9 May 2007 16:36:39 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l49Kaacx558542
	for <linux-scsi@vger.kernel.org>; Wed, 9 May 2007 16:36:38 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l49KaaqX029774
	for <linux-scsi@vger.kernel.org>; Wed, 9 May 2007 16:36:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Currently ipr always returns success from eh_dev_reset when
called for a SATA device. If ata_do_eh is unable to recover
for some reason, this can result in commands that are still
outstanding when ata_do_eh returns. Change ipr to verify no
commands are outstanding before returning success.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

James,

Looks like this one got dropped. This is a resend.

Thanks,

Brian
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_sata_dev_reset_fixup drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_sata_dev_reset_fixup	2007-05-09 09:39:19.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-05-09 09:39:19.000000000 -0500
@@ -3954,6 +3954,13 @@ static int __ipr_eh_dev_reset(struct scs
 		spin_unlock_irq(scsi_cmd->device->host->host_lock);
 		ata_do_eh(ap, NULL, NULL, ipr_sata_reset, NULL);
 		spin_lock_irq(scsi_cmd->device->host->host_lock);
+
+		list_for_each_entry(ipr_cmd, &ioa_cfg->pending_q, queue) {
+			if (ipr_cmd->ioarcb.res_handle == res->cfgte.res_handle) {
+				rc = -EIO;
+				break;
+			}
+		}
 	} else
 		rc = ipr_device_reset(ioa_cfg, res);
 	res->resetting_device = 0;
_
