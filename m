From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] cleanup qla1280_initialize_adapter
Date: Sun, 6 Jun 2004 14:58:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040606125835.GF31063@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:30410 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263567AbUFFM6h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2004 08:58:37 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org

no function changes, just some more gotos and less nested ifs to make
the code readable.


diff -Nru a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c	2004-06-06 14:47:27 +02:00
+++ b/drivers/scsi/qla1280.c	2004-06-06 14:47:27 +02:00
@@ -1812,36 +1812,24 @@
 	dprintk(1, "scsi(%ld): Configure NVRAM parameters\n", ha->host_no);
 	qla1280_nvram_config(ha);
 
-	if (!ha->flags.disable_host_adapter && !qla1280_init_rings(ha)) {
-		/* Issue SCSI reset. */
-		/* dg 03/13 if we can't reset twice then bus is dead */
-		for (bus = 0; bus < ha->ports; bus++) {
-			if (!ha->bus_settings[bus].disable_scsi_reset){
-				if (qla1280_bus_reset(ha, bus)) {
-					if (qla1280_bus_reset(ha, bus)) {
-						ha->bus_settings[bus].scsi_bus_dead = 1;
-					}
-				}
-			}
-		}
+	if (ha->flags.disable_host_adapter) {
+		status = 1;
+		goto out;
+	}
 
-		/*
-		 * qla1280_bus_reset() will take care of issueing markers,
-		 * no need to do that here as well!
-		 */
-#if 0
-		/* Issue marker command. */
-		ha->flags.reset_marker = 0;
-		for (bus = 0; bus < ha->ports; bus++) {
-			ha->bus_settings[bus].reset_marker = 0;
-			qla1280_marker(ha, bus, 0, 0, MK_SYNC_ALL);
-		}
-#endif
+	status = qla1280_init_rings(ha);
+	if (status)
+		goto out;
 
-		ha->flags.online = 1;
-	} else
-		status = 1;
+	/* Issue SCSI reset, if we can't reset twice then bus is dead */
+	for (bus = 0; bus < ha->ports; bus++) {
+		if (!ha->bus_settings[bus].disable_scsi_reset &&
+		    qla1280_bus_reset(ha, bus) &&
+		    qla1280_bus_reset(ha, bus))
+			ha->bus_settings[bus].scsi_bus_dead = 1;
+	}
 
+	ha->flags.online = 1;
  out:
 #if LINUX_VERSION_CODE >= 0x020500
 	spin_unlock_irqrestore(HOST_LOCK, flags);
