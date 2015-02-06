From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 29/36] aha1542: Change aha1542_set_bus_times parameters
Date: Fri,  6 Feb 2015 23:11:50 +0100
Message-ID: <1423260717-15944-30-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56962 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037AbbBFWPy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:15:54 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8I-0006fF-1M
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:14 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Pass struct Scsi_Host *sh and dma parameters instead of index to
aha1542_set_bus_times.
This is required for printk conversion.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 12b90a2..6e44a7f 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -756,38 +756,36 @@ static u8 dma_speed_hw(int dma_speed)
 }
 
 /* Set the Bus on/off-times as not to ruin floppy performance */
-static void aha1542_set_bus_times(int indx)
+static void aha1542_set_bus_times(struct Scsi_Host *sh, int bus_on, int bus_off, int dma_speed)
 {
-	unsigned int base_io = io[indx];
-
-	if (bus_on[indx] > 0) {
-		u8 oncmd[] = { CMD_BUSON_TIME, clamp(bus_on[indx], 2, 15) };
+	if (bus_on > 0) {
+		u8 oncmd[] = { CMD_BUSON_TIME, clamp(bus_on, 2, 15) };
 
-		aha1542_intr_reset(base_io);
-		if (aha1542_out(base_io, oncmd, 2))
+		aha1542_intr_reset(sh->io_port);
+		if (aha1542_out(sh->io_port, oncmd, 2))
 			goto fail;
 	}
 
-	if (bus_off[indx] > 0) {
-		u8 offcmd[] = { CMD_BUSOFF_TIME, clamp(bus_off[indx], 1, 64) };
+	if (bus_off > 0) {
+		u8 offcmd[] = { CMD_BUSOFF_TIME, clamp(bus_off, 1, 64) };
 
-		aha1542_intr_reset(base_io);
-		if (aha1542_out(base_io, offcmd, 2))
+		aha1542_intr_reset(sh->io_port);
+		if (aha1542_out(sh->io_port, offcmd, 2))
 			goto fail;
 	}
 
-	if (dma_speed_hw(dma_speed[indx]) != 0xff) {
-		u8 dmacmd[] = { CMD_DMASPEED, dma_speed_hw(dma_speed[indx]) };
+	if (dma_speed_hw(dma_speed) != 0xff) {
+		u8 dmacmd[] = { CMD_DMASPEED, dma_speed_hw(dma_speed) };
 
-		aha1542_intr_reset(base_io);
-		if (aha1542_out(base_io, dmacmd, 2))
+		aha1542_intr_reset(sh->io_port);
+		if (aha1542_out(sh->io_port, dmacmd, 2))
 			goto fail;
 	}
-	aha1542_intr_reset(base_io);
+	aha1542_intr_reset(sh->io_port);
 	return;
 fail:
 	printk(KERN_ERR "setting bus on/off-time failed\n");
-	aha1542_intr_reset(base_io);
+	aha1542_intr_reset(sh->io_port);
 }
 
 /* return non-zero on detection */
@@ -817,7 +815,7 @@ static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct
 	if (!aha1542_test_port(sh))
 		goto unregister;
 
-	aha1542_set_bus_times(indx);
+	aha1542_set_bus_times(sh, bus_on[indx], bus_off[indx], dma_speed[indx]);
 	if (aha1542_query(sh))
 		goto unregister;
 	if (aha1542_getconfig(sh) == -1)
-- 
Ondrej Zary

