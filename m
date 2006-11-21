From: Brian King <brking@us.ibm.com>
Subject: [PATCH 01/10] ipr: SATA reset - wait for host reset completion
Date: Tue, 21 Nov 2006 10:27:58 -0600
Message-ID: <48343.049726873$1164126518@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:6376 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1031054AbWKUQ2B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 11:28:01 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kALGS0YN000482
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:00 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kALGRx8R354460
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 09:27:59 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kALGRxUZ018434
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 09:27:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


If an ipr adapter hits a fatal microcode error requiring a reset
while a SATA device is going through EH, it can result in a command
getting issued to the ipr adapter while it is getting reset, which
can cause PCI bus errors. Wait for any outstanding adapter reset
to finish prior to issuing a SATA device reset.

---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   12 ++++++++++++
 1 files changed, 12 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_sata_reset_wait_for_host_reset drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_sata_reset_wait_for_host_reset	2006-11-14 16:55:29.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-11-14 16:59:54.000000000 -0600
@@ -3573,6 +3573,12 @@ static int ipr_sata_reset(struct ata_por
 
 	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	while(ioa_cfg->in_reset_reload) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	}
+
 	res = sata_port->res;
 	if (res) {
 		rc = ipr_device_reset(ioa_cfg, res);
@@ -4776,6 +4782,12 @@ static void ipr_ata_post_internal(struct
 	unsigned long flags;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	while(ioa_cfg->in_reset_reload) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	}
+
 	list_for_each_entry(ipr_cmd, &ioa_cfg->pending_q, queue) {
 		if (ipr_cmd->qc == qc) {
 			ipr_device_reset(ioa_cfg, sata_port->res);
_
