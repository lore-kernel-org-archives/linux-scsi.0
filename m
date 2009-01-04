From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] aha152x_cs: Fix regression that keeps driver from using shared
 interrupts
Date: Sat, 03 Jan 2009 23:28:25 -0600
Message-ID: <496048F9.1010601@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752880AbZADF2n@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Juergen Fischer <fischer@norbit.de>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

At some point since 2.6.22, the aha152x_cs driver stopped working and
started erring on load with the following messages:

kernel: pcmcia: request for exclusive IRQ could not be fulfilled.
kernel: pcmcia: the driver needs updating to supported shared IRQ lines.

With the following change, the driver works with shared IRQs.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>		[2.6.28], [2.6.27], [2.6.26]
---

Juergen,

If you are not the correct person to receive this, please pass it on.
I originally sent it to Dominik Brodowski, but heard nothing from him.

Thanks,

Larry
---

Index: wireless-testing/drivers/scsi/pcmcia/aha152x_stub.c
===================================================================
--- wireless-testing.orig/drivers/scsi/pcmcia/aha152x_stub.c
+++ wireless-testing/drivers/scsi/pcmcia/aha152x_stub.c
@@ -114,7 +114,7 @@ static int aha152x_probe(struct pcmcia_d
     link->io.NumPorts1 = 0x20;
     link->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
     link->io.IOAddrLines = 10;
-    link->irq.Attributes = IRQ_TYPE_EXCLUSIVE;
+    link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
     link->irq.IRQInfo1 = IRQ_LEVEL_ID;
     link->conf.Attributes = CONF_ENABLE_IRQ;
     link->conf.IntType = INT_MEMORY_AND_IO;
