From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Driver for Adaptec AHA-1530P
Date: Sat, 17 Jan 2004 00:42:00 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401162013440.6170-100000@poirot.grange>
References: <14dd01c3dc05$4435ce70$060ba8c0@AldiP4>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:32420 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265936AbUAPXxi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 18:53:38 -0500
In-Reply-To: <14dd01c3dc05$4435ce70$060ba8c0@AldiP4>
List-Id: linux-scsi@vger.kernel.org
To: Kai Ruhnau <kai@tragetaschen.dyndns.org>
Cc: linux-scsi@vger.kernel.org

On Fri, 16 Jan 2004, Kai Ruhnau wrote:

> Guennadi Liakhovetski wrote:
> >
> > Please try the patch below - just to see where it fails. It looks like
> > you've got another driver claiming the 0x340 region - can you check your
> > /proc/ioports? If not - I don't understand why SuSE-7.3 detected the chip,
>
> I actually didn't integrate the patch, but I noticed a difference between my
> initrd and SuSEs initrd. And I think, it is the error, you predicted.
> The problem does not lie in the aha152x driver, but in the parameters for
> isa-pnp. To make everything work, I have to specify the parameter
> 'isapnp_reset=0' when I load isa-pnp. After that, my network-card gets
> another io-range (the same as under SuSE).

Ok, as I suspected, resourse-conflict. You have PNP, but the AHA-card is
not PNP. So, looks like the right thing to do would be just to make the
error in case of busy io-region more explicite. But the proper fix should
also, of course, replace check_region with request_region. Perhaps,
something like what's attached below. Sould you, please, test? It
compiles:-) It should just fail nicely if request_region() fails, and work
otherwise. It is against 2.6.0.

Guennadi
---
Guennadi Liakhovetski

--- drivers/scsi/aha152x.c~	Mon Nov 24 20:44:18 2003
+++ drivers/scsi/aha152x.c	Sat Jan 17 00:36:38 2004
@@ -849,9 +849,6 @@
 {
 	int i;

-	if (check_region(io_port, IO_RANGE))
-		return 0;
-
 	SETPORT(io_port + O_DMACNTRL1, 0);	/* reset stack pointer */
 	for (i = 0; i < 16; i++)
 		SETPORT(io_port + O_STACK, i);
@@ -867,9 +864,6 @@
 {
 	int i;

-	if (check_region(io_port, IO_RANGE))
-		return 0;
-
 	SETPORT(io_port + O_TC_DMACNTRL1, 0);	/* reset stack pointer */
 	for (i = 0; i < 16; i++)
 		SETPORT(io_port + O_STACK, i);
@@ -1030,9 +1024,6 @@
 	       aha->delay,
 	       aha->ext_trans ? "enabled" : "disabled");

-	if (!request_region(shost->io_port, IO_RANGE, "aha152x"))
-		goto out_unregister;
-
 	/* not expecting any interrupts */
 	SETPORT(SIMODE0, 0);
 	SETPORT(SIMODE1, 0);
@@ -1086,15 +1077,13 @@
 out_unregister_host:
 	aha152x_host[registered_count] = NULL;
 out_release_region:
-	release_region(shost->io_port, IO_RANGE);
-out_unregister:
 	scsi_unregister(shost);
 	return NULL;
 }

 static int aha152x_detect(Scsi_Host_Template * tpnt)
 {
-	int i, j, ok;
+	int i, j, ok = 0;
 #if defined(AUTOCONF)
 	aha152x_config conf;
 #ifdef __ISAPNP__
@@ -1105,12 +1094,27 @@
 	if (setup_count) {
 		printk(KERN_INFO "aha152x: processing commandline: ");

-		for (i = 0; i < setup_count; i++)
+		for (i = 0; i < setup_count; i++) {
+			if (request_region(setup[i].io_port, IO_RANGE, "aha152x") == NULL) {
+				printk("\n");
+				printk(KERN_WARNING "aha152x: port 0x%x[%d] busy\n", setup[i].io_port, IO_RANGE);
+				continue;
+			}
 			if (!checksetup(&setup[i])) {
-				printk(KERN_ERR "\naha152x: %s\n", setup[i].conf);
+				release_region(setup[i].io_port, IO_RANGE);
+				printk("\n" KERN_ERR "aha152x: %s\n", setup[i].conf);
 				printk(KERN_ERR "aha152x: invalid line\n");
+			} else {
+				ok++;
+				printk("%s, ", setup[i].tc1550 ? "tc1550" : "aha152x");
 			}
-		printk("ok\n");
+		}
+		if (ok) {
+			printk("ok\n");
+			ok = 0;
+		} else
+			/* If nothing found at command-line specified addresses, fail */
+			return 0;
 	}

 #if defined(SETUP0)
@@ -1118,7 +1122,10 @@
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
@@ -1139,7 +1146,10 @@
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
@@ -1185,9 +1195,12 @@
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
@@ -1197,6 +1210,7 @@
 			       setup[setup_count].synchronous,
 			       setup[setup_count].delay,
 			       setup[setup_count].ext_trans);
+		}
 	}

 	if (setup_count<ARRAY_SIZE(setup) && (aha152x1[0]!=0 || io[1]!=0 || irq[1]!=0)) {
@@ -1227,9 +1241,12 @@
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
@@ -1239,6 +1256,7 @@
 			       setup[setup_count].synchronous,
 			       setup[setup_count].delay,
 			       setup[setup_count].ext_trans);
+		}
 	}
 #endif

@@ -1300,7 +1318,9 @@
 			if ((setup_count == 1) && (setup[0].io_port == ports[i]))
 				continue;

-			if (aha152x_porttest(ports[i])) {
+			if (request_region(ports[i], IO_RANGE, "aha152x") == NULL)
+				printk(KERN_WARNING "aha152x: port 0x%x[%d] busy\n", ports[i], IO_RANGE);
+			else if (aha152x_porttest(ports[i])) {
 				ok++;
 				setup[setup_count].io_port = ports[i];
 				setup[setup_count].tc1550  = 0;
@@ -1338,7 +1358,8 @@
 				setup[setup_count].debug = DEBUG_DEFAULT;
 #endif
 				setup_count++;
-			}
+			} else
+				release_region(ports[i], IO_RANGE);
 		}

 		if (ok)
@@ -1349,7 +1370,8 @@
 	printk("detected %d controller(s)\n", setup_count);

 	for (i=0; i<setup_count; i++) {
-		aha152x_probe_one(&setup[i]);
+		if (aha152x_probe_one(&setup[i]) == NULL)
+			release_region(setup[i].io_port, IO_RANGE);
 		if (aha152x_host[registered_count])
 			registered_count++;
 	}

