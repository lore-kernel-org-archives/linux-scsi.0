From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Proper return codes for eh_dev_reset for SATA devices
Date: Thu, 19 Apr 2007 08:56:30 -0500
Message-ID: <45283.5589567714$1176991020@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:59612 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S637769AbXDSN4e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Apr 2007 09:56:34 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l3JDrpI3028871
	for <linux-scsi@vger.kernel.org>; Thu, 19 Apr 2007 09:53:51 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3JDuX1a144704
	for <linux-scsi@vger.kernel.org>; Thu, 19 Apr 2007 07:56:33 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3JDuWxR026002
	for <linux-scsi@vger.kernel.org>; Thu, 19 Apr 2007 07:56:33 -0600
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

 linux-2.6-bjking1/drivers/scsi/ipr.c |    7 +++++++
 1 files changed, 7 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_sata_dev_reset_fixup drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_sata_dev_reset_fixup	2007-04-18 12:45:07.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-04-18 12:46:11.000000000 -0500
@@ -3869,6 +3869,13 @@ static int __ipr_eh_dev_reset(struct scs
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
