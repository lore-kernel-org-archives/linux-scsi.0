From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] qla1280: Drop host_lock while requesting firmware
Date: Sat, 23 Jan 2010 18:40:29 +0000
Message-ID: <1264272029.373.95.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55018 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503Ab0AWSlZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jan 2010 13:41:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, 543244@bugs.debian.org

request_firmware() may sleep and it appears to be safe to release the
spinlock here.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@kernel.org
---
This change was made in Debian kernel packages to address this bug
report: <http://bugs.debian.org/543244>.  We have applied it to 2.6.31
and 2.6.32 and there have been no further bug reports on this driver.

Ben.

 drivers/scsi/qla1280.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 8371d91..49ac414 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1640,8 +1640,10 @@ qla1280_load_firmware_pio(struct scsi_qla_host *ha)
 	uint16_t mb[MAILBOX_REGISTER_COUNT], i;
 	int err;
 
+	spin_unlock_irq(ha->host->host_lock);
 	err = request_firmware(&fw, ql1280_board_tbl[ha->devnum].fwname,
 			       &ha->pdev->dev);
+	spin_lock_irq(ha->host->host_lock);
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       ql1280_board_tbl[ha->devnum].fwname, err);
@@ -1699,8 +1701,10 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 		return -ENOMEM;
 #endif
 
+	spin_unlock_irq(ha->host->host_lock);
 	err = request_firmware(&fw, ql1280_board_tbl[ha->devnum].fwname,
 			       &ha->pdev->dev);
+	spin_lock_irq(ha->host->host_lock);
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       ql1280_board_tbl[ha->devnum].fwname, err);
-- 
1.6.6


