From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 09/52] atp870u: Untangle tmport #7
Date: Tue, 17 Nov 2015 19:23:45 +0100
Message-ID: <1447784668-23713-10-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56422 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510AbbKQSYr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:24:47 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Untangle the tmport crap so it becomes obvious what ports are accessed.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index e398ea5..f5a11f4 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -2716,7 +2716,6 @@ static int atp870u_abort(struct scsi_cmnd * SCpnt)
 {
 	unsigned char  j, k, c;
 	struct scsi_cmnd *workrequ;
-	unsigned int tmport;
 	struct atp_unit *dev;	
 	struct Scsi_Host *host;
 	host = SCpnt->device->host;
@@ -2726,18 +2725,13 @@ static int atp870u_abort(struct scsi_cmnd * SCpnt)
 	printk(" atp870u: abort Channel = %x \n", c);
 	printk("working=%x last_cmd=%x ", dev->working[c], dev->last_cmd[c]);
 	printk(" quhdu=%x quendu=%x ", dev->quhd[c], dev->quend[c]);
-	tmport = dev->ioport[c];
 	for (j = 0; j < 0x18; j++) {
-		printk(" r%2x=%2x", j, inb(tmport++));
+		printk(" r%2x=%2x", j, inb(dev->ioport[c] + j));
 	}
-	tmport += 0x04;
-	printk(" r1c=%2x", inb(tmport));
-	tmport += 0x03;
-	printk(" r1f=%2x in_snd=%2x ", inb(tmport), dev->in_snd[c]);
-	tmport= dev->pciport[c];
-	printk(" d00=%2x", inb(tmport));
-	tmport += 0x02;
-	printk(" d02=%2x", inb(tmport));
+	printk(" r1c=%2x", inb(dev->ioport[c] + 0x1c));
+	printk(" r1f=%2x in_snd=%2x ", inb(dev->ioport[c] + 0x1f), dev->in_snd[c]);
+	printk(" d00=%2x", inb(dev->pciport[c]));
+	printk(" d02=%2x", inb(dev->pciport[c] + 0x02));
 	for(j=0;j<16;j++) {
 	   if (dev->id[c][j].curr_req != NULL) {
 		workrequ = dev->id[c][j].curr_req;
-- 
Ondrej Zary

