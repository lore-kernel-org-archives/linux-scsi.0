From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 1/2] qla1280: firmware load deadlocks kdump
Date: Mon, 08 Feb 2010 15:21:52 -0600
Message-ID: <4B708070.2090407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:39318 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751390Ab0BHVWA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2010 16:22:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, Tony Ernst <tee@sgi.com>, Jes Sorensen <jes@trained-monkey.org>, Jes Sorensen <jes@sgi.com>


The qla1280 driver calls request_firmware() holding the host_lock.  As this lock
is released during the process of loading the firmware into the board, it can be
released (and reacquired) around the call to request_firmware().  Doing so
eliminates the dump_stack() which occurs in local_bh_enable() due to holding
a spinlock.  It also corrects the deadlock which occurs attempting to capture
a kdump with kernel options "irqpoll maxcpus=1".

Signed-off-by: Michael Reed <mdr@sgi.com>


--- linux-2.6.32.5-0.1-a/drivers/scsi/qla1280.c	2009-12-02 21:51:21.000000000 -0600
+++ linux-2.6.32.5-0.1-b/drivers/scsi/qla1280.c	2010-02-04 16:23:10.831352910 -0600
@@ -1640,8 +1640,10 @@ qla1280_load_firmware_pio(struct scsi_ql
 	uint16_t mb[MAILBOX_REGISTER_COUNT], i;
 	int err;
 
+	spin_unlock_irq(ha->host->host_lock);
 	err = request_firmware(&fw, ql1280_board_tbl[ha->devnum].fwname,
 			       &ha->pdev->dev);
+	spin_lock_irq(ha->host->host_lock);
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       ql1280_board_tbl[ha->devnum].fwname, err);
@@ -1699,8 +1701,10 @@ qla1280_load_firmware_dma(struct scsi_ql
 		return -ENOMEM;
 #endif
 
+	spin_unlock_irq(ha->host->host_lock);
 	err = request_firmware(&fw, ql1280_board_tbl[ha->devnum].fwname,
 			       &ha->pdev->dev);
+	spin_lock_irq(ha->host->host_lock);
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       ql1280_board_tbl[ha->devnum].fwname, err);
