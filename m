From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 33/52] atp870u: Fix incorrect writeb_io access to register 0x3a
Date: Tue, 17 Nov 2015 19:24:09 +0100
Message-ID: <1447784668-23713-34-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56475 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbbKQSf7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:35:59 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

The ioport region is 0x20 bytes long so accessing 0x3a register using
writeb_io is incorrect. Use writeb_base instead.
There's no change in behavior as 870 chips have ioport = baseport.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index c4a59cc..04b29d3 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -364,9 +364,9 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 					atp_writeb_base(dev, 0x3b, atp_readb_base(dev, 0x3b) & 0x3f);
 			} else {				
 				if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a))
-					atp_writeb_io(dev, c, 0x3a, (atp_readb_io(dev, c, 0x3a) & 0xf3) | 0x08);
+					atp_writeb_base(dev, 0x3a, (atp_readb_base(dev, 0x3a) & 0xf3) | 0x08);
 				else
-					atp_writeb_io(dev, c, 0x3a, atp_readb_io(dev, c, 0x3a) & 0xf3);
+					atp_writeb_base(dev, 0x3a, atp_readb_base(dev, 0x3a) & 0xf3);
 			}	
 			j = 0;
 			id = 1;
@@ -889,9 +889,9 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 			atp_writeb_base(dev, 0x3b, atp_readb_base(dev, 0x3b) & 0x3f);
 	} else {		
 		if ((workreq->cmnd[0] == 0x08) || (workreq->cmnd[0] == 0x28) || (workreq->cmnd[0] == 0x0a) || (workreq->cmnd[0] == 0x2a))
-			atp_writeb_io(dev, c, 0x3a, (atp_readb_io(dev, c, 0x3a) & 0xf3) | 0x08);
+			atp_writeb_base(dev, 0x3a, (atp_readb_base(dev, 0x3a) & 0xf3) | 0x08);
 		else
-			atp_writeb_io(dev, c, 0x3a, atp_readb_io(dev, c, 0x3a) & 0xf3);
+			atp_writeb_base(dev, 0x3a, atp_readb_base(dev, 0x3a) & 0xf3);
 	}	
 
 	if(workreq->sc_data_direction == DMA_TO_DEVICE) {
-- 
Ondrej Zary

