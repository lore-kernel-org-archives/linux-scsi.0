From: "Juergen E. Fischer" <fischer@linux-buechse.de>
Subject: Re: Kernel oops in 2.6.1 when loading aha152x_cs.ko
Date: Sat, 10 Jan 2004 18:35:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040110173542.GA24288@linux-buechse.de>
References: <6.0.0.22.0.20040109124348.01b86068@pop-server.kc.rr.com> <1073698638.2026.3.camel@opiate> <6.0.0.22.0.20040109221955.01b86f28@pop-server.kc.rr.com> <1073716698.2026.18.camel@opiate> <1073747000.1945.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.184]:29946 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S265285AbUAJRmU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2004 12:42:20 -0500
Received: from [212.227.126.162] (helo=mrelayng.kundenserver.de)
	by moutng.kundenserver.de with esmtp (Exim 3.35 #1)
	id 1AfN7q-0001ux-00
	for linux-scsi@vger.kernel.org; Sat, 10 Jan 2004 18:42:18 +0100
Received: from [217.237.20.4] (helo=linux-buechse.de)
	by mrelayng.kundenserver.de with asmtp (TLSv1:EDH-RSA-DES-CBC3-SHA:168)
	(Exim 3.35 #1)
	id 1AfN7p-00015u-00
	for linux-scsi@vger.kernel.org; Sat, 10 Jan 2004 18:42:17 +0100
Received: from beorn.linux-buechse.de (root@beorn.linux-buechse.de [192.168.50.9])
	by linux-buechse.de (8.12.10/8.12.10/Debian-6) with ESMTP id i0AHgJbX001534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 10 Jan 2004 18:42:19 +0100
Received: from beorn.linux-buechse.de (fischer@beorn [127.0.0.1])
	by beorn.linux-buechse.de (8.12.10/8.12.10/Debian-6) with ESMTP id i0AHZhqo024351
	for <linux-scsi@vger.kernel.org>; Sat, 10 Jan 2004 18:35:43 +0100
Received: (from fischer@localhost)
	by beorn.linux-buechse.de (8.12.10/8.12.10/Debian-6) id i0AHZgs2024350
	for linux-scsi@vger.kernel.org; Sat, 10 Jan 2004 18:35:42 +0100
Content-Disposition: inline
In-Reply-To: <1073747000.1945.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


--DocE+STaALJfprDB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi James,

On Sat, Jan 10, 2004 at 10:03:20 -0500, James Bottomley wrote:
> On Sat, 2004-01-10 at 01:38, Eric Kerin wrote:
> > Let's try this again, with the proper check. This one even compiles!
> 
> Actually, you're still on slightly the wrong track.  The quick fix, as I
> told Russell on this list is in aha152x_stub.c.
> 
> If you want to code that up as a patch and test it, I'll apply it.

Attached patch removed the references to the legacy stuff from the
driver.

I'm not sure if that is all that needs to be done though, and I could
only test it for the non-pcmcia case, but that works here.


Jürgen

--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="aha152x.diff"

--- orig/linux-2.6.0/drivers/scsi/aha152x.c	2004-01-10 18:25:53.000000000 +0100
+++ linux-2.6.0/drivers/scsi/aha152x.c	2004-01-10 18:28:30.000000000 +0100
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
@@ -903,13 +897,20 @@
 	if (i == ARRAY_SIZE(ports))
 		return 0;
 #endif
+	if (!request_region(setup->io_port, IO_RANGE, "aha152x"))
+		return 0;
 
 	if(aha152x_porttest(setup->io_port)) {
-          setup->tc1550=0;
+		setup->tc1550=0;
         } else if(tc1550_porttest(setup->io_port)) {
-          setup->tc1550=1;
-        } else
-          return 0;
+		setup->tc1550=1;
+	} else {
+		release_region(setup->io_port, IO_RANGE);
+		return 0;
+	}
+
+	release_region(setup->io_port, IO_RANGE);
+
 
 	if ((setup->irq < IRQ_MIN) || (setup->irq > IRQ_MAX))
 		return 0;
@@ -965,7 +966,7 @@
 {
 	struct Scsi_Host *shpnt;
 
-	shpnt = scsi_register(&aha152x_driver_template, sizeof(struct aha152x_hostdata));
+	shpnt = scsi_host_alloc(&aha152x_driver_template, sizeof(struct aha152x_hostdata));
 	if (!shpnt) {
 		printk(KERN_ERR "aha152x: scsi_register failed\n");
 		return NULL;
@@ -1080,6 +1081,9 @@
 		printk(KERN_ERR "aha152x%d: failed to reassign interrupt.\n", shpnt->host_no);
 		goto out_unregister_host;
 	}
+
+	scsi_add_host(shpnt, 0);
+	scsi_scan_host(shpnt);
 	return shpnt;	/* the pcmcia stub needs the return value; */
 
 out_unregister_host:
@@ -1087,11 +1091,11 @@
 out_release_region:
 	release_region(shpnt->io_port, IO_RANGE);
 out_unregister:
-	scsi_unregister(shpnt);
+	scsi_host_put(shpnt);
 	return NULL;
 }
 
-static int aha152x_detect(Scsi_Host_Template * tpnt)
+static int __init aha152x_init(void)
 {
 	int i, j, ok;
 #if defined(AUTOCONF)
@@ -1360,7 +1364,6 @@
 	return registered_count>0;
 }
 
-
 static int aha152x_release(struct Scsi_Host *shpnt)
 {
 	if (shpnt->irq)
@@ -1374,11 +1377,25 @@
 		pnp_device_detach(HOSTDATA(shpnt)->pnpdev);
 #endif
 
-	scsi_unregister(shpnt);
+	scsi_host_put(shpnt);
 
 	return 0;
 }
 
+static void __exit aha152x_exit(void)
+{
+	int i;
+
+	for(i=0; i<ARRAY_SIZE(setup); i++) {
+		if(aha152x_host[i]) {
+			scsi_remove_host(aha152x_host[i]);
+			aha152x_release(aha152x_host[i]);
+			aha152x_host[i]=0;
+		}
+	}
+}
+
+
 /*
  * setup controller to generate interrupts depending
  * on current state (lock has to be acquired)
@@ -3880,26 +3897,22 @@
 }
 
 static Scsi_Host_Template aha152x_driver_template = {
-	.module			= THIS_MODULE,
-	.name			= AHA152X_REVID,
-	.proc_name		= "aha152x",
-	.proc_info		= aha152x_proc_info,
-	.detect			= aha152x_detect,
-	.queuecommand		= aha152x_queue,
-	.eh_abort_handler	= aha152x_abort,
-	.eh_device_reset_handler = aha152x_device_reset,
-	.eh_bus_reset_handler	= aha152x_bus_reset,
-	.eh_host_reset_handler	= aha152x_host_reset,
-	.release		= aha152x_release,
-	.bios_param		= aha152x_biosparam,
-	.can_queue		= 1,
-	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 1,
-	.use_clustering		= DISABLE_CLUSTERING,
+	.module				= THIS_MODULE,
+	.name				= AHA152X_REVID,
+	.proc_name			= "aha152x",
+	.proc_info			= aha152x_proc_info,
+	.queuecommand			= aha152x_queue,
+	.eh_abort_handler		= aha152x_abort,
+	.eh_device_reset_handler	= aha152x_device_reset,
+	.eh_bus_reset_handler		= aha152x_bus_reset,
+	.eh_host_reset_handler		= aha152x_host_reset,
+	.bios_param			= aha152x_biosparam,
+	.can_queue			= 1,
+	.this_id			= 7,
+	.sg_tablesize			= SG_ALL,
+	.cmd_per_lun			= 1,
+	.use_clustering			= DISABLE_CLUSTERING,
 };
 
-#ifndef PCMCIA
-#define driver_template aha152x_driver_template
-#include "scsi_module.c"
-#endif
+module_init(aha152x_init);
+module_exit(aha152x_exit);

--DocE+STaALJfprDB--
