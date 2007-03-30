From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 2/4] [SCSI]stex: extend hard reset wait time
Date: Fri, 30 Mar 2007 15:21:35 -0700
Message-ID: <NONAMEBS4HIv6EybqfA000005d4@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:2362 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933085AbXC3XLj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 19:11:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>

During hard bus reset of st_shasta controllers, 1 ms is not enough for
16-port controllers, although it's good for 8-port controllers.  Extend the
wait time to 100  ms to allow bus resets finish successfully.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 4d68533..1e8d7ac 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1055,7 +1055,12 @@ static void stex_hard_reset(struct st_hb
 	pci_read_config_byte(bus->self, PCI_BRIDGE_CONTROL, &pci_bctl);
 	pci_bctl |= PCI_BRIDGE_CTL_BUS_RESET;
 	pci_write_config_byte(bus->self, PCI_BRIDGE_CONTROL, pci_bctl);
-	msleep(1);
+
+	/*
+	 * 1 ms may be enough for 8-port controllers. But 16-port controllers
+	 * require more time to finish bus reset. Use 100 ms here for safety
+	 */
+	msleep(100);
 	pci_bctl &= ~PCI_BRIDGE_CTL_BUS_RESET;
 	pci_write_config_byte(bus->self, PCI_BRIDGE_CONTROL, pci_bctl);
 


