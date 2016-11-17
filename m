From: Helge Deller <deller@gmx.de>
Subject: [PATCH] mptfusion: Fix printk continuations
Date: Thu, 17 Nov 2016 21:46:20 +0100
Message-ID: <20161117204620.GA10093@p100.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62600 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752018AbcKQUqd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Nov 2016 15:46:33 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-parisc@vger.kernel.org, John David Anglin <dave.anglin@bell.net>

Fix the printk continuations when running the mptfusion driver.
This patch brings the capabilities into one single syslog line again:
   mptbase: ioc1: Initiating bringup
   ioc1: LSI53C1030 B2: Capabilities={Initiator,Target}
   scsi host3: ioc1: LSI53C1030 B2, FwRev=01032341h, Ports=1, MaxQ=255, IRQ=67

Tested on a parisc C8000 machine.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 89c7ed1..fae96a2 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -2868,21 +2868,21 @@ MptDisplayIocCapabilities(MPT_ADAPTER *ioc)
 
 	printk(KERN_INFO "%s: ", ioc->name);
 	if (ioc->prod_name)
-		printk("%s: ", ioc->prod_name);
-	printk("Capabilities={");
+		pr_cont("%s: ", ioc->prod_name);
+	pr_cont("Capabilities={");
 
 	if (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_INITIATOR) {
-		printk("Initiator");
+		pr_cont("Initiator");
 		i++;
 	}
 
 	if (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_TARGET) {
-		printk("%sTarget", i ? "," : "");
+		pr_cont("%sTarget", i ? "," : "");
 		i++;
 	}
 
 	if (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN) {
-		printk("%sLAN", i ? "," : "");
+		pr_cont("%sLAN", i ? "," : "");
 		i++;
 	}
 
@@ -2891,12 +2891,12 @@ MptDisplayIocCapabilities(MPT_ADAPTER *ioc)
 	 *  This would probably evoke more questions than it's worth
 	 */
 	if (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_TARGET) {
-		printk("%sLogBusAddr", i ? "," : "");
+		pr_cont("%sLogBusAddr", i ? "," : "");
 		i++;
 	}
 #endif
 
-	printk("}\n");
+	pr_cont("}\n");
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
