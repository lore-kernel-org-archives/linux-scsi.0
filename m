From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH] Hex numbers in NCR53c406a.c
Date: Wed, 26 Feb 2003 17:51:16 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200302261751.16090@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This patch makes sure that there is a "0x" in front of all hex numbers and
makes all outputs use a single style (all %x instead of mixed %x and %X).

Eike

--- linux-2.5.63/drivers/scsi/NCR53c406a.c	Mon Feb 24 20:05:32 2003
+++ linux-2.5.63-eike/drivers/scsi/NCR53c406a.c	Wed Feb 26 17:43:27 2003
@@ -472,7 +472,7 @@
 		return 0;
 	}
 
-	DEB(printk("NCR53c406a BIOS found at %X\n", (unsigned int) bios_base);
+	DEB(printk("NCR53c406a BIOS found at 0x%x\n", (unsigned int) bios_base);
 	    );
 #endif				/* USE_BIOS */
 
@@ -487,14 +487,14 @@
 	} else {
 		for (i = 0; i < PORT_COUNT && !port_base; i++) {
 			if (!request_region(ports[i], 0x10, "NCR53c406a")) {
-				DEB(printk("NCR53c406a: port %x in use\n", ports[i]));
+				DEB(printk("NCR53c406a: port 0x%x in use\n", ports[i]));
 			} else {
-				VDEB(printk("NCR53c406a: port %x available\n", ports[i]));
+				VDEB(printk("NCR53c406a: port 0x%x available\n", ports[i]));
 				outb(C5_IMG, ports[i] + 0x0d);	/* reg set 1 */
 				if ((inb(ports[i] + 0x0e) ^ inb(ports[i] + 0x0e)) == 7 && (inb(ports[i] + 0x0e) ^ inb(ports[i] + 0x0e)) == 7 && (inb(ports[i] + 0x0e) & 0xf8) == 0x58) {
 					port_base = ports[i];
 					VDEB(printk("NCR53c406a: Sig register valid\n"));
-					VDEB(printk("port_base=%x\n", port_base));
+					VDEB(printk("port_base=0x%x\n", port_base));
 					break;
 				}
 				release_region(ports[i], 0x10);
@@ -523,7 +523,7 @@
 	}
 #endif
 
-	DEB(printk("NCR53c406a: using port_base %x\n", port_base));
+	DEB(printk("NCR53c406a: using port_base 0x%x\n", port_base));
 
 	tpnt->present = 1;
 	tpnt->proc_name = "NCR53c406a";
@@ -611,11 +611,11 @@
 	for (i = 0; i < PORT_COUNT && !port_base; i++)
 		if (ports[i] == ints[1]) {
 			port_base = ints[1];
-			DEB(printk("NCR53c406a: Specified port_base 0x%X\n", port_base);
+			DEB(printk("NCR53c406a: Specified port_base 0x%x\n", port_base);
 			    )
 		}
 	if (!port_base) {
-		printk("NCR53c406a: Invalid PORTBASE 0x%X specified\n", ints[1]);
+		printk("NCR53c406a: Invalid PORTBASE 0x%x specified\n", ints[1]);
 		return;
 	}
 
@@ -638,7 +638,7 @@
 	if (ints[0] > 2)
 		fast_pio = ints[3];
 
-	DEB(printk("NCR53c406a: port_base=0x%X, irq=%d, fast_pio=%d\n", port_base, irq_level, fast_pio);)
+	DEB(printk("NCR53c406a: port_base=0x%x, irq=%d, fast_pio=%d\n", port_base, irq_level, fast_pio);)
 }
 
 __setup("ncr53c406a=", NCR53c406a_setup);
