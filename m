From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] aha152x-2.6.1
Date: Sat, 17 Jan 2004 23:25:51 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401172318380.963-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:34973 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265898AbUAQW0f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jan 2004 17:26:35 -0500
Received: from lyakh (helo=localhost)
	by poirot.grange with local-esmtp (Exim 3.35 #1 (Debian))
	id 1Ahyt5-0000Nh-00
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2004 23:25:51 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

Below is a patch for aha152x to fix check / request_region, plus make it
fail explicitly in the case of busy address-range. Compiles, untested
(yet).

While on that - what about the advansys-patch with a similar (check_region
vs. request_region) scope, I sent earlier to the list - was it wrong, or
just not important enough?

Guennadi
---
Guennadi Liakhovetski

--- linux-2.6.1/drivers/scsi/aha152x.c~	Sat Jan 17 22:47:27 2004
+++ linux-2.6.1/drivers/scsi/aha152x.c	Sat Jan 17 23:12:22 2004
@@ -860,9 +860,6 @@
 {
 	int i;

-	if (check_region(io_port, IO_RANGE))
-		return 0;
-
 	SETPORT(io_port + O_DMACNTRL1, 0);	/* reset stack pointer */
 	for (i = 0; i < 16; i++)
 		SETPORT(io_port + O_STACK, i);
@@ -878,9 +875,6 @@
 {
 	int i;

-	if (check_region(io_port, IO_RANGE))
-		return 0;
-
 	SETPORT(io_port + O_TC_DMACNTRL1, 0);	/* reset stack pointer */
 	for (i = 0; i < 16; i++)
 		SETPORT(io_port + O_STACK, i);
@@ -1033,9 +1027,6 @@
 	       DELAY,
 	       EXT_TRANS ? "enabled" : "disabled");

-	if (!request_region(shpnt->io_port, IO_RANGE, "aha152x"))
-		goto out_unregister;
-
 	/* not expecting any interrupts */
 	SETPORT(SIMODE0, 0);
 	SETPORT(SIMODE1, 0);
@@ -1085,15 +1076,13 @@
 out_unregister_host:
 	aha152x_host[registered_count] = NULL;
 out_release_region:
-	release_region(shpnt->io_port, IO_RANGE);
-out_unregister:
 	scsi_unregister(shpnt);
 	return NULL;
 }

 static int aha152x_detect(Scsi_Host_Template * tpnt)
 {
-	int i, j, ok;
+	int i, j, ok = 0;
 #if defined(AUTOCONF)
 	aha152x_config conf;
 #endif
@@ -1102,14 +1091,22 @@
 #endif

 	if (setup_count) {
-		printk(KERN_INFO "aha152x: processing commandline: ");
+		printk(KERN_INFO "aha152x: processing commandline:\n");

 		for (i = 0; i < setup_count; i++)
-			if (!checksetup(&setup[i])) {
-				printk(KERN_ERR "\naha152x: %s\n", setup[i].conf);
+			if (request_region(setup[i].io_port, IO_RANGE, "aha152x") == NULL)
+				printk(KERN_WARNING "aha152x: port 0x%x[%d] busy\n", setup[i].io_port, IO_RANGE);
+			else if (!checksetup(&setup[i])) {
+				release_region(setup[i].io_port, IO_RANGE);
+				printk(KERN_ERR "aha152x: %s\n", setup[i].conf);
 				printk(KERN_ERR "aha152x: invalid line\n");
+			} else {
+				ok++;
+				printk("aha152x: 0x%x: ok\n", setup[i].io_port);
 			}
-		printk("ok\n");
+		/* If nothing found at command-line specified addresses, fail */
+		if (!ok)
+			return 0;
 	}

 #if defined(SETUP0)
@@ -1117,7 +1114,10 @@
 		struct aha152x_setup override = SETUP0;

 		if (setup_count == 0 || (override.io_port != setup[0].io_port)) {
-			if (!checksetup(&override)) {
+			if (request_region(override.io_port, IO_RANGE, "aha152x") == NULL)
+				printk(KERN_WARNING "aha152x: port 0x%x[%d] busy\n", override.io_port, IO_RANGE);
+			else if (!checksetup(&override)) {
+				release_region(override.io_port, IO_RANGE);
 				printk(KERN_ERR "\naha152x: invalid override SETUP0={0x%x,%d,%d,%d,%d,%d,%d,%d}\n",
 				       override.io_port,
 				       override.irq,
@@ -1138,7 +1138,10 @@
 		struct aha152x_setup override = SETUP1;

 		if (setup_count == 0 || (override.io_port != setup[0].io_port)) {
-			if (!checksetup(&override)) {
+			if (request_region(override.io_port, IO_RANGE, "aha152x") == NULL)
+				printk(KERN_WARNING "aha152x: port 0x%x[%d] busy\n", override.io_port, IO_RANGE);
+			else if (!checksetup(&override)) {
+				release_region(override.io_port, IO_RANGE);
 				printk(KERN_ERR "\naha152x: invalid override SETUP1={0x%x,%d,%d,%d,%d,%d,%d,%d}\n",
 				       override.io_port,
 				       override.irq,
@@ -1184,9 +1187,12 @@
 #endif
 		}

-          	if (checksetup(&setup[setup_count]))
+		if (request_region(setup[setup_count].io_port, IO_RANGE, "aha152x") == NULL)
+			printk(KERN_WARNING "aha152x: port 0x%x[%d] busy\n", setup[setup_count].io_port, IO_RANGE);
+		else if (checksetup(&setup[setup_count]))
 			setup_count++;
-		else
+		else {
+			release_region(setup[setup_count].io_port, IO_RANGE);
 			printk(KERN_ERR "aha152x: invalid module params io=0x%x, irq=%d,scsiid=%d,reconnect=%d,parity=%d,sync=%d,delay=%d,exttrans=%d\n",
 			       setup[setup_count].io_port,
 			       setup[setup_count].irq,
@@ -1196,6 +1202,7 @@
 			       setup[setup_count].synchronous,
 			       setup[setup_count].delay,
 			       setup[setup_count].ext_trans);
+		}
 	}

 	if (setup_count<ARRAY_SIZE(setup) && (aha152x1[0]!=0 || io[1]!=0 || irq[1]!=0)) {
@@ -1226,9 +1233,12 @@
 			setup[setup_count].debug       = debug[1];
 #endif
 		}
-		if (checksetup(&setup[setup_count]))
+		if (request_region(setup[setup_count].io_port, IO_RANGE, "aha152x") == NULL)
+			printk(KERN_WARNING "aha152x: port 0x%x[%d] busy\n", setup[setup_count].io_port, IO_RANGE);
+		else if (checksetup(&setup[setup_count]))
 			setup_count++;
-		else
+		else {
+			release_region(setup[setup_count].io_port, IO_RANGE);
 			printk(KERN_ERR "aha152x: invalid module params io=0x%x, irq=%d,scsiid=%d,reconnect=%d,parity=%d,sync=%d,delay=%d,exttrans=%d\n",
 			       setup[setup_count].io_port,
 			       setup[setup_count].irq,
@@ -1238,6 +1248,7 @@
 			       setup[setup_count].synchronous,
 			       setup[setup_count].delay,
 			       setup[setup_count].ext_trans);
+		}
 	}
 #endif

@@ -1298,7 +1309,9 @@
 			if ((setup_count == 1) && (setup[0].io_port == ports[i]))
 				continue;

-			if (aha152x_porttest(ports[i])) {
+			if (request_region(ports[i], IO_RANGE, "aha152x") == NULL)
+				printk(KERN_WARNING "aha152x: port 0x%x[%d] busy\n", ports[i], IO_RANGE);
+			else if (aha152x_porttest(ports[i])) {
 				ok++;
 				setup[setup_count].io_port = ports[i];
 				setup[setup_count].tc1550  = 0;
@@ -1336,7 +1349,8 @@
 				setup[setup_count].debug = DEBUG_DEFAULT;
 #endif
 				setup_count++;
-			}
+			} else
+				release_region(ports[i], IO_RANGE);
 		}

 		if (ok)
@@ -1347,7 +1361,8 @@
 	printk("detected %d controller(s)\n", setup_count);

 	for (i=0; i<setup_count; i++) {
-		aha152x_probe_one(&setup[i]);
+		if (aha152x_probe_one(&setup[i]) == NULL)
+			release_region(setup[i].io_port, IO_RANGE);
 		if (aha152x_host[registered_count]) {
 #ifdef __ISAPNP__
 			if(pnpdev[i])

