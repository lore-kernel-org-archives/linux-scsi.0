From: "Juergen E. Fischer" <fischer@linux-buechse.de>
Subject: Re: Driver for Adaptec AHA-1530P
Date: Mon, 19 Jan 2004 00:11:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040118231107.GA27828@linux-buechse.de>
References: <Pine.LNX.4.44.0401162013440.6170-100000@poirot.grange> <028001c3de16$30c41730$060ba8c0@AldiP4>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:33759 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S264271AbUARXLU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 18:11:20 -0500
Received: from [212.227.126.205] (helo=mrelayng.kundenserver.de)
	by moutng.kundenserver.de with esmtp (Exim 3.35 #1)
	id 1AiM4d-0008HZ-00
	for linux-scsi@vger.kernel.org; Mon, 19 Jan 2004 00:11:19 +0100
Received: from [217.84.250.28] (helo=linux-buechse.de)
	by mrelayng.kundenserver.de with asmtp (TLSv1:EDH-RSA-DES-CBC3-SHA:168)
	(Exim 3.35 #1)
	id 1AiM4Z-0002Mo-00
	for linux-scsi@vger.kernel.org; Mon, 19 Jan 2004 00:11:16 +0100
Received: from beorn.linux-buechse.de (root@beorn.linux-buechse.de [192.168.50.9])
	by linux-buechse.de (8.12.11.Beta0/8.12.11.Beta0/Debian-2) with ESMTP id i0INBjo2002638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2004 00:11:45 +0100
Received: from beorn.linux-buechse.de (fischer@beorn [127.0.0.1])
	by beorn.linux-buechse.de (8.12.11.Beta0/8.12.11.Beta0/Debian-2) with ESMTP id i0INB7xm027935
	for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2004 00:11:07 +0100
Received: (from fischer@localhost)
	by beorn.linux-buechse.de (8.12.11.Beta0/8.12.11.Beta0/Debian-2) id i0INB7C4027934
	for linux-scsi@vger.kernel.org; Mon, 19 Jan 2004 00:11:07 +0100
Content-Disposition: inline
In-Reply-To: <028001c3de16$30c41730$060ba8c0@AldiP4>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kai,

On Sun, Jan 18, 2004 at 23:55:36 +0100, Kai Ruhnau wrote:
> But the kernel also oopses, when I use the original aha152x.c.

Please try the attached patch.
=20

J=FCrgen

--=20
"I hear that if you play the NT 4.0 CD backwards, you get a satanic message=
".
"That's nothing. If you play it forward, it installs NT 4.0!"
  -- unknown

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="aha152x.diff"
Content-Transfer-Encoding: quoted-printable

Changes:
- move code not used for PCMCIA (detection and configuration) to the end of=
 the
  file (which is the main reason for the size of the patch)
- migration to new scsi host api (remove legacy code)
- move request_region for non-pcmia case to detection
- cleanup pcmcia stub module: remove release_region hack and let the core
  module add/remove the host
- default to synchronous transfers also for pcmcia
- fix: free host scribble before scsi_done
- fix error handling

diff -udr orig/linux-2.6.0/drivers/scsi/aha152x.c linux-2.6.0/drivers/scsi/=
aha152x.c
--- orig/linux-2.6.0/drivers/scsi/aha152x.c	2004-01-18 17:03:33.000000000 +=
0100
+++ linux-2.6.0/drivers/scsi/aha152x.c	2004-01-18 17:34:05.000000000 +0100
@@ -1,6 +1,6 @@
 /* aha152x.c -- Adaptec AHA-152x driver
  * Author: J=FCrgen E. Fischer, fischer@norbit.de
- * Copyright 1993-2000 J=FCrgen E. Fischer
+ * Copyright 1993-2004 J=FCrgen E. Fischer
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -344,7 +344,8 @@
 MODULE_DESCRIPTION(AHA152X_REVID);
 MODULE_LICENSE("GPL");
=20
-#if defined(MODULE) && !defined(PCMCIA)
+#if !defined(PCMCIA)
+#if defined(MODULE)
 MODULE_PARM(io, "1-2i");
 MODULE_PARM_DESC(io,"base io address of controller");
 static int io[] =3D {0, 0};
@@ -398,7 +399,7 @@
 MODULE_PARM_DESC(aha152x1, "parameters for second controller");
 static int aha152x1[]  =3D {0, 11, 7, 1, 1, 1, DELAY_DEFAULT, 0, DEBUG_DEF=
AULT};
 #endif /* !defined(AHA152X_DEBUG) */
-#endif /* MODULE && !PCMCIA */
+#endif /* MODULE */
=20
 #ifdef __ISAPNP__
 static struct isapnp_device_id id_table[] __devinitdata =3D {
@@ -408,11 +409,10 @@
 MODULE_DEVICE_TABLE(isapnp, id_table);
 #endif /* ISAPNP */
=20
-/* set by aha152x_setup according to the command line */
-static int setup_count;
-static int registered_count;
-static struct aha152x_setup setup[2];
-static struct Scsi_Host *aha152x_host[2];
+#endif /* !PCMCIA */
+
+static int registered_count=3D0;
+static struct Scsi_Host *aha152x_host[2] =3D {0, 0};
 static Scsi_Host_Template aha152x_driver_template;
=20
 /*
@@ -658,7 +658,6 @@
 static void reset_ports(struct Scsi_Host *shpnt);
 static void aha152x_error(struct Scsi_Host *shpnt, char *msg);
 static void done(struct Scsi_Host *shpnt, int error);
-static int checksetup(struct aha152x_setup *setup);
=20
 /* diagnostics */
 static void disp_ports(struct Scsi_Host *shpnt);
@@ -666,66 +665,6 @@
 static void show_queues(struct Scsi_Host *shpnt);
 static void disp_enintr(struct Scsi_Host *shpnt);
=20
-/* possible i/o addresses for the AIC-6260; default first */
-static unsigned short ports[] =3D { 0x340, 0x140 };
-
-#if !defined(SKIP_BIOSTEST)
-/* possible locations for the Adaptec BIOS; defaults first */
-static unsigned int addresses[] =3D
-{
-	0xdc000,		/* default first */
-	0xc8000,
-	0xcc000,
-	0xd0000,
-	0xd4000,
-	0xd8000,
-	0xe0000,
-	0xeb800,		/* VTech Platinum SMP */
-	0xf0000,
-};
-
-/* signatures for various AIC-6[23]60 based controllers.
-   The point in detecting signatures is to avoid useless and maybe
-   harmful probes on ports. I'm not sure that all listed boards pass
-   auto-configuration. For those which fail the BIOS signature is
-   obsolete, because user intervention to supply the configuration is
-   needed anyway.  May be an information whether or not the BIOS supports
-   extended translation could be also useful here. */
-static struct signature {
-	unsigned char *signature;
-	int sig_offset;
-	int sig_length;
-} signatures[] =3D
-{
-	{ "Adaptec AHA-1520 BIOS",	0x102e, 21 },
-		/* Adaptec 152x */
-	{ "Adaptec AHA-1520B",		0x000b, 17 },
-		/* Adaptec 152x rev B */
-	{ "Adaptec AHA-1520B",		0x0026, 17 },
-		/* Iomega Jaz Jet ISA (AIC6370Q) */
-	{ "Adaptec ASW-B626 BIOS",	0x1029, 21 },
-		/* on-board controller */
-	{ "Adaptec BIOS: ASW-B626",	0x000f, 22 },
-		/* on-board controller */
-	{ "Adaptec ASW-B626 S2",	0x2e6c, 19 },
-		/* on-board controller */
-	{ "Adaptec BIOS:AIC-6360",	0x000c, 21 },
-		/* on-board controller */
-	{ "ScsiPro SP-360 BIOS",	0x2873, 19 },
-		/* ScsiPro-Controller  */
-	{ "GA-400 LOCAL BUS SCSI BIOS", 0x102e, 26 },
-		/* Gigabyte Local-Bus-SCSI */
-	{ "Adaptec BIOS:AVA-282X",	0x000c, 21 },
-		/* Adaptec 282x */
-	{ "Adaptec IBM Dock II SCSI",	0x2edd, 24 },
-		/* IBM Thinkpad Dock II */
-	{ "Adaptec BIOS:AHA-1532P",	0x001c, 22 },
-		/* IBM Thinkpad Dock II SCSI */
-	{ "DTC3520A Host Adapter BIOS", 0x318a, 26 },
-		/* DTC 3520A ISA SCSI */
-};
-#endif
-
=20
 /*
  *  queue services:
@@ -799,140 +738,6 @@
 	return ptr;
 }
=20
-#if defined(PCMCIA) || !defined(MODULE)
-static void aha152x_setup(char *str, int *ints)
-{
-	if(setup_count>=3DARRAY_SIZE(setup)) {
-		printk(KERN_ERR "aha152x: you can only configure up to two controllers\n=
");
-		return;
-	}
-
-	setup[setup_count].conf        =3D str;
-	setup[setup_count].io_port     =3D ints[0] >=3D 1 ? ints[1] : 0x340;
-	setup[setup_count].irq         =3D ints[0] >=3D 2 ? ints[2] : 11;
-	setup[setup_count].scsiid      =3D ints[0] >=3D 3 ? ints[3] : 7;
-	setup[setup_count].reconnect   =3D ints[0] >=3D 4 ? ints[4] : 1;
-	setup[setup_count].parity      =3D ints[0] >=3D 5 ? ints[5] : 1;
-	setup[setup_count].synchronous =3D ints[0] >=3D 6 ? ints[6] : 1;
-	setup[setup_count].delay       =3D ints[0] >=3D 7 ? ints[7] : DELAY_DEFAU=
LT;
-	setup[setup_count].ext_trans   =3D ints[0] >=3D 8 ? ints[8] : 0;
-#if defined(AHA152X_DEBUG)
-	setup[setup_count].debug       =3D ints[0] >=3D 9 ? ints[9] : DEBUG_DEFAU=
LT;
-	if (ints[0] > 9) {
-		printk(KERN_NOTICE "aha152x: usage: aha152x=3D<IOBASE>[,<IRQ>[,<SCSI ID>"
-		       "[,<RECONNECT>[,<PARITY>[,<SYNCHRONOUS>[,<DELAY>[,<EXT_TRANS>[,<D=
EBUG>]]]]]]]]\n");
-#else
-	if (ints[0] > 8) {                                                /*}*/
-		printk(KERN_NOTICE "aha152x: usage: aha152x=3D<IOBASE>[,<IRQ>[,<SCSI ID>"
-		       "[,<RECONNECT>[,<PARITY>[,<SYNCHRONOUS>[,<DELAY>[,<EXT_TRANS>]]]]=
]]]\n");
-#endif
-	} else {
-		setup_count++;
-	}
-}
-#endif
-
-#if !defined(MODULE)
-static int __init do_setup(char *str)
-{
-
-#if defined(AHA152X_DEBUG)
-	int ints[11];
-#else
-	int ints[10];
-#endif
-	int count=3Dsetup_count;
-
-	get_options(str, ARRAY_SIZE(ints), ints);
-	aha152x_setup(str,ints);
-
-	return count<setup_count;
-}
-
-__setup("aha152x=3D", do_setup);
-#endif
-
-/*
- * Test, if port_base is valid.
- *
- */
-static int aha152x_porttest(int io_port)
-{
-	int i;
-
-	if (check_region(io_port, IO_RANGE))
-		return 0;
-
-	SETPORT(io_port + O_DMACNTRL1, 0);	/* reset stack pointer */
-	for (i =3D 0; i < 16; i++)
-		SETPORT(io_port + O_STACK, i);
-
-	SETPORT(io_port + O_DMACNTRL1, 0);	/* reset stack pointer */
-	for (i =3D 0; i < 16 && GETPORT(io_port + O_STACK) =3D=3D i; i++)
-		;
-
-	return (i =3D=3D 16);
-}
-
-static int tc1550_porttest(int io_port)
-{
-	int i;
-
-	if (check_region(io_port, IO_RANGE))
-		return 0;
-
-	SETPORT(io_port + O_TC_DMACNTRL1, 0);	/* reset stack pointer */
-	for (i =3D 0; i < 16; i++)
-		SETPORT(io_port + O_STACK, i);
-
-	SETPORT(io_port + O_TC_DMACNTRL1, 0);	/* reset stack pointer */
-	for (i =3D 0; i < 16 && GETPORT(io_port + O_TC_STACK) =3D=3D i; i++)
-		;
-
-	return (i =3D=3D 16);
-}
-
-static int checksetup(struct aha152x_setup *setup)
-{
-
-#if !defined(PCMCIA)
-	int i;
-	for (i =3D 0; i < ARRAY_SIZE(ports) && (setup->io_port !=3D ports[i]); i+=
+)
-		;
-
-	if (i =3D=3D ARRAY_SIZE(ports))
-		return 0;
-#endif
-
-	if(aha152x_porttest(setup->io_port)) {
-          setup->tc1550=3D0;
-        } else if(tc1550_porttest(setup->io_port)) {
-          setup->tc1550=3D1;
-        } else
-          return 0;
-
-	if ((setup->irq < IRQ_MIN) || (setup->irq > IRQ_MAX))
-		return 0;
-
-	if ((setup->scsiid < 0) || (setup->scsiid > 7))
-		return 0;
-
-	if ((setup->reconnect < 0) || (setup->reconnect > 1))
-		return 0;
-
-	if ((setup->parity < 0) || (setup->parity > 1))
-		return 0;
-
-	if ((setup->synchronous < 0) || (setup->synchronous > 1))
-		return 0;
-
-	if ((setup->ext_trans < 0) || (setup->ext_trans > 1))
-		return 0;
-
-
-	return 1;
-}
-
 static inline struct Scsi_Host *lookup_irq(int irqno)
 {
 	int i;
@@ -949,7 +754,6 @@
 	struct Scsi_Host *shpnt =3D lookup_irq(irqno);
=20
 	if (!shpnt) {
-		/* no point using HOSTNO here! */
         	printk(KERN_ERR "aha152x: catched software interrupt %d for unkno=
wn controller.\n", irqno);
 		return IRQ_NONE;
 	}
@@ -960,17 +764,19 @@
 	return IRQ_HANDLED;
 }
=20
-
 struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 {
 	struct Scsi_Host *shpnt;
=20
-	shpnt =3D scsi_register(&aha152x_driver_template, sizeof(struct aha152x_h=
ostdata));
+	shpnt =3D	scsi_host_alloc(&aha152x_driver_template, sizeof(struct aha152x=
_hostdata));
 	if (!shpnt) {
-		printk(KERN_ERR "aha152x: scsi_register failed\n");
+		printk(KERN_ERR "aha152x: scsi_host_alloc failed\n");
 		return NULL;
 	}
=20
+	/* need to have host registered before triggering any interrupt */
+	aha152x_host[registered_count] =3D shpnt;
+
 	memset(HOSTDATA(shpnt), 0, sizeof *HOSTDATA(shpnt));
=20
 	shpnt->io_port   =3D setup->io_port;
@@ -1033,24 +839,19 @@
 	       DELAY,
 	       EXT_TRANS ? "enabled" : "disabled");
=20
-	if (!request_region(shpnt->io_port, IO_RANGE, "aha152x"))
-		goto out_unregister;
-
 	/* not expecting any interrupts */
 	SETPORT(SIMODE0, 0);
 	SETPORT(SIMODE1, 0);
=20
-	if (request_irq(shpnt->irq, swintr, SA_INTERRUPT|SA_SHIRQ, "aha152x", shp=
nt) < 0) {
+	if( request_irq(shpnt->irq, swintr, SA_INTERRUPT|SA_SHIRQ, "aha152x", shp=
nt) ) {
 		printk(KERN_ERR "aha152x%d: driver needs an IRQ.\n", shpnt->host_no);
-		goto out_release_region;
+		goto out_host_put;
 	}
=20
 	HOSTDATA(shpnt)->swint =3D 0;
=20
 	printk(KERN_INFO "aha152x%d: trying software interrupt, ", shpnt->host_no=
);
=20
-	/* need to have host registered before triggering any interrupt */
-	aha152x_host[registered_count] =3D shpnt;
 	mb();
 	SETPORT(DMACNTRL0, SWINT|INTEN);
 	mdelay(1000);
@@ -1067,7 +868,7 @@
=20
 		printk(KERN_ERR "aha152x%d: IRQ %d possibly wrong.  "
 				"Please verify.\n", shpnt->host_no, shpnt->irq);
-		goto out_unregister_host;
+		goto out_host_put;
 	}
 	printk("ok.\n");
=20
@@ -1076,309 +877,53 @@
 	SETPORT(SSTAT0, 0x7f);
 	SETPORT(SSTAT1, 0xef);
=20
-	if (request_irq(shpnt->irq, intr, SA_INTERRUPT|SA_SHIRQ, "aha152x", shpnt=
) < 0) {
+	if ( request_irq(shpnt->irq, intr, SA_INTERRUPT|SA_SHIRQ, "aha152x", shpn=
t) ) {
 		printk(KERN_ERR "aha152x%d: failed to reassign interrupt.\n", shpnt->hos=
t_no);
-		goto out_unregister_host;
-	}
-	return shpnt;	/* the pcmcia stub needs the return value; */
-
-out_unregister_host:
-	aha152x_host[registered_count] =3D NULL;
-out_release_region:
-	release_region(shpnt->io_port, IO_RANGE);
-out_unregister:
-	scsi_unregister(shpnt);
-	return NULL;
-}
-
-static int aha152x_detect(Scsi_Host_Template * tpnt)
-{
-	int i, j, ok;
-#if defined(AUTOCONF)
-	aha152x_config conf;
-#endif
-#ifdef __ISAPNP__
-	struct pnp_dev *dev=3D0, *pnpdev[2] =3D {0, 0};
-#endif
-
-	if (setup_count) {
-		printk(KERN_INFO "aha152x: processing commandline: ");
-
-		for (i =3D 0; i < setup_count; i++)
-			if (!checksetup(&setup[i])) {
-				printk(KERN_ERR "\naha152x: %s\n", setup[i].conf);
-				printk(KERN_ERR "aha152x: invalid line\n");
-			}
-		printk("ok\n");
-	}
-
-#if defined(SETUP0)
-	if (setup_count < ARRAY_SIZE(setup)) {
-		struct aha152x_setup override =3D SETUP0;
-
-		if (setup_count =3D=3D 0 || (override.io_port !=3D setup[0].io_port)) {
-			if (!checksetup(&override)) {
-				printk(KERN_ERR "\naha152x: invalid override SETUP0=3D{0x%x,%d,%d,%d,%=
d,%d,%d,%d}\n",
-				       override.io_port,
-				       override.irq,
-				       override.scsiid,
-				       override.reconnect,
-				       override.parity,
-				       override.synchronous,
-				       override.delay,
-				       override.ext_trans);
-			} else
-				setup[setup_count++] =3D override;
-		}
-	}
-#endif
-
-#if defined(SETUP1)
-	if (setup_count < ARRAY_SIZE(setup)) {
-		struct aha152x_setup override =3D SETUP1;
-
-		if (setup_count =3D=3D 0 || (override.io_port !=3D setup[0].io_port)) {
-			if (!checksetup(&override)) {
-				printk(KERN_ERR "\naha152x: invalid override SETUP1=3D{0x%x,%d,%d,%d,%=
d,%d,%d,%d}\n",
-				       override.io_port,
-				       override.irq,
-				       override.scsiid,
-				       override.reconnect,
-				       override.parity,
-				       override.synchronous,
-				       override.delay,
-				       override.ext_trans);
-			} else
-				setup[setup_count++] =3D override;
-		}
-	}
-#endif
-
-#if defined(MODULE) && !defined(PCMCIA)
-	if (setup_count<ARRAY_SIZE(setup) && (aha152x[0]!=3D0 || io[0]!=3D0 || ir=
q[0]!=3D0)) {
-		if(aha152x[0]!=3D0) {
-			setup[setup_count].conf        =3D "";
-			setup[setup_count].io_port     =3D aha152x[0];
-			setup[setup_count].irq         =3D aha152x[1];
-			setup[setup_count].scsiid      =3D aha152x[2];
-			setup[setup_count].reconnect   =3D aha152x[3];
-			setup[setup_count].parity      =3D aha152x[4];
-			setup[setup_count].synchronous =3D aha152x[5];
-			setup[setup_count].delay       =3D aha152x[6];
-			setup[setup_count].ext_trans   =3D aha152x[7];
-#if defined(AHA152X_DEBUG)
-			setup[setup_count].debug       =3D aha152x[8];
-#endif
-	  	} else if(io[0]!=3D0 || irq[0]!=3D0) {
-			if(io[0]!=3D0)  setup[setup_count].io_port =3D io[0];
-			if(irq[0]!=3D0) setup[setup_count].irq     =3D irq[0];
-
-	    		setup[setup_count].scsiid      =3D scsiid[0];
-	    		setup[setup_count].reconnect   =3D reconnect[0];
-	    		setup[setup_count].parity      =3D parity[0];
-	    		setup[setup_count].synchronous =3D sync[0];
-	    		setup[setup_count].delay       =3D delay[0];
-	    		setup[setup_count].ext_trans   =3D exttrans[0];
-#if defined(AHA152X_DEBUG)
-			setup[setup_count].debug       =3D debug[0];
-#endif
-		}
-
-          	if (checksetup(&setup[setup_count]))
-			setup_count++;
-		else
-			printk(KERN_ERR "aha152x: invalid module params io=3D0x%x, irq=3D%d,scs=
iid=3D%d,reconnect=3D%d,parity=3D%d,sync=3D%d,delay=3D%d,exttrans=3D%d\n",
-			       setup[setup_count].io_port,
-			       setup[setup_count].irq,
-			       setup[setup_count].scsiid,
-			       setup[setup_count].reconnect,
-			       setup[setup_count].parity,
-			       setup[setup_count].synchronous,
-			       setup[setup_count].delay,
-			       setup[setup_count].ext_trans);
-	}
-
-	if (setup_count<ARRAY_SIZE(setup) && (aha152x1[0]!=3D0 || io[1]!=3D0 || i=
rq[1]!=3D0)) {
-		if(aha152x1[0]!=3D0) {
-			setup[setup_count].conf        =3D "";
-			setup[setup_count].io_port     =3D aha152x1[0];
-			setup[setup_count].irq         =3D aha152x1[1];
-			setup[setup_count].scsiid      =3D aha152x1[2];
-			setup[setup_count].reconnect   =3D aha152x1[3];
-			setup[setup_count].parity      =3D aha152x1[4];
-			setup[setup_count].synchronous =3D aha152x1[5];
-			setup[setup_count].delay       =3D aha152x1[6];
-			setup[setup_count].ext_trans   =3D aha152x1[7];
-#if defined(AHA152X_DEBUG)
-			setup[setup_count].debug       =3D aha152x1[8];
-#endif
-	  	} else if(io[1]!=3D0 || irq[1]!=3D0) {
-			if(io[1]!=3D0)  setup[setup_count].io_port =3D io[1];
-			if(irq[1]!=3D0) setup[setup_count].irq     =3D irq[1];
-
-	    		setup[setup_count].scsiid      =3D scsiid[1];
-	    		setup[setup_count].reconnect   =3D reconnect[1];
-	    		setup[setup_count].parity      =3D parity[1];
-	    		setup[setup_count].synchronous =3D sync[1];
-	    		setup[setup_count].delay       =3D delay[1];
-	    		setup[setup_count].ext_trans   =3D exttrans[1];
-#if defined(AHA152X_DEBUG)
-			setup[setup_count].debug       =3D debug[1];
-#endif
-		}
-		if (checksetup(&setup[setup_count]))
-			setup_count++;
-		else
-			printk(KERN_ERR "aha152x: invalid module params io=3D0x%x, irq=3D%d,scs=
iid=3D%d,reconnect=3D%d,parity=3D%d,sync=3D%d,delay=3D%d,exttrans=3D%d\n",
-			       setup[setup_count].io_port,
-			       setup[setup_count].irq,
-			       setup[setup_count].scsiid,
-			       setup[setup_count].reconnect,
-			       setup[setup_count].parity,
-			       setup[setup_count].synchronous,
-			       setup[setup_count].delay,
-			       setup[setup_count].ext_trans);
+		goto out_host_put;
 	}
-#endif
=20
-#ifdef __ISAPNP__
-	while ( setup_count<ARRAY_SIZE(setup) && (dev=3Dpnp_find_dev(NULL, ISAPNP=
_VENDOR('A','D','P'), ISAPNP_FUNCTION(0x1505), dev)) ) {
-		if (pnp_device_attach(dev) < 0)
-			continue;
-		if (pnp_activate_dev(dev) < 0) {
-			pnp_device_detach(dev);
-			continue;
-		}
-		if (!pnp_port_valid(dev, 0)) {
-			pnp_device_detach(dev);
-			continue;
-		}
-		if (setup_count=3D=3D1 && pnp_port_start(dev, 0)=3D=3Dsetup[0].io_port) {
-			pnp_device_detach(dev);
-			continue;
-		}
-		setup[setup_count].io_port     =3D pnp_port_start(dev, 0);
-		setup[setup_count].irq         =3D pnp_irq(dev, 0);
-		setup[setup_count].scsiid      =3D 7;
-		setup[setup_count].reconnect   =3D 1;
-		setup[setup_count].parity      =3D 1;
-		setup[setup_count].synchronous =3D 1;
-		setup[setup_count].delay       =3D DELAY_DEFAULT;
-		setup[setup_count].ext_trans   =3D 0;
-#if defined(AHA152X_DEBUG)
-		setup[setup_count].debug       =3D DEBUG_DEFAULT;
-#endif
-		pnpdev[setup_count]            =3D dev;
-		printk (KERN_INFO
-			"aha152x: found ISAPnP AVA-1505A at io=3D0x%03x, irq=3D%d\n",
-			setup[setup_count].io_port, setup[setup_count].irq);
-		setup_count++;
+	if( scsi_add_host(shpnt, 0) ) {
+		free_irq(shpnt->irq, shpnt);
+		printk(KERN_ERR "aha152x%d: failed to add host.\n", shpnt->host_no);
+		goto out_host_put;
 	}
-#endif
-
-#if defined(AUTOCONF)
-	if (setup_count<ARRAY_SIZE(setup)) {
-#if !defined(SKIP_BIOSTEST)
-		ok =3D 0;
-		for (i =3D 0; i < ARRAY_SIZE(addresses) && !ok; i++)
-			for (j =3D 0; j<ARRAY_SIZE(signatures) && !ok; j++)
-				ok =3D isa_check_signature(addresses[i] + signatures[j].sig_offset,
-								signatures[j].signature, signatures[j].sig_length);
=20
-		if (!ok && setup_count =3D=3D 0)
-			return 0;
-
-		printk(KERN_INFO "aha152x: BIOS test: passed, ");
-#else
-		printk(KERN_INFO "aha152x: ");
-#endif				/* !SKIP_BIOSTEST */
-
-		ok =3D 0;
-		for (i =3D 0; i < ARRAY_SIZE(ports) && setup_count < 2; i++) {
-			if ((setup_count =3D=3D 1) && (setup[0].io_port =3D=3D ports[i]))
-				continue;
-
-			if (aha152x_porttest(ports[i])) {
-				ok++;
-				setup[setup_count].io_port =3D ports[i];
-				setup[setup_count].tc1550  =3D 0;
-
-				conf.cf_port =3D
-				    (GETPORT(ports[i] + O_PORTA) << 8) + GETPORT(ports[i] + O_PORTB);
-
-				setup[setup_count].irq =3D IRQ_MIN + conf.cf_irq;
-				setup[setup_count].scsiid =3D conf.cf_id;
-				setup[setup_count].reconnect =3D conf.cf_tardisc;
-				setup[setup_count].parity =3D !conf.cf_parity;
-				setup[setup_count].synchronous =3D conf.cf_syncneg;
-				setup[setup_count].delay =3D DELAY_DEFAULT;
-				setup[setup_count].ext_trans =3D 0;
-#if defined(AHA152X_DEBUG)
-				setup[setup_count].debug =3D DEBUG_DEFAULT;
-#endif
-				setup_count++;
-			} else if (tc1550_porttest(ports[i])) {
-				ok++;
-				setup[setup_count].io_port =3D ports[i];
-				setup[setup_count].tc1550  =3D 1;
-
-				conf.cf_port =3D
-				    (GETPORT(ports[i] + O_PORTA) << 8) + GETPORT(ports[i] + O_PORTB);
-
-				setup[setup_count].irq =3D IRQ_MIN + conf.cf_irq;
-				setup[setup_count].scsiid =3D conf.cf_id;
-				setup[setup_count].reconnect =3D conf.cf_tardisc;
-				setup[setup_count].parity =3D !conf.cf_parity;
-				setup[setup_count].synchronous =3D conf.cf_syncneg;
-				setup[setup_count].delay =3D DELAY_DEFAULT;
-				setup[setup_count].ext_trans =3D 0;
-#if defined(AHA152X_DEBUG)
-				setup[setup_count].debug =3D DEBUG_DEFAULT;
-#endif
-				setup_count++;
-			}
-		}
+	scsi_scan_host(shpnt);
=20
-		if (ok)
-			printk("auto configuration: ok, ");
-	}
-#endif
+	registered_count++;
=20
-	printk("detected %d controller(s)\n", setup_count);
+	return shpnt;
=20
-	for (i=3D0; i<setup_count; i++) {
-		aha152x_probe_one(&setup[i]);
-		if (aha152x_host[registered_count]) {
-#ifdef __ISAPNP__
-			if(pnpdev[i])
-				HOSTDATA(aha152x_host[registered_count])->pnpdev=3Dpnpdev[i];
-#endif
-			registered_count++;
-		}
-	}
+out_host_put:
+	aha152x_host[registered_count]=3D0;
+	scsi_host_put(shpnt);
=20
-	return registered_count>0;
+	return 0;
 }
=20
-
-static int aha152x_release(struct Scsi_Host *shpnt)
+void aha152x_release(struct Scsi_Host *shpnt)
 {
+	if(!shpnt)
+		return;
+
 	if (shpnt->irq)
 		free_irq(shpnt->irq, shpnt);
=20
+#if !defined(PCMCIA)
 	if (shpnt->io_port)
 		release_region(shpnt->io_port, IO_RANGE);
+#endif
=20
 #ifdef __ISAPNP__
 	if (HOSTDATA(shpnt)->pnpdev)
 		pnp_device_detach(HOSTDATA(shpnt)->pnpdev);
 #endif
=20
-	scsi_unregister(shpnt);
-
-	return 0;
+	scsi_remove_host(shpnt);
+	scsi_host_put(shpnt);
 }
=20
+
 /*
  * setup controller to generate interrupts depending
  * on current state (lock has to be acquired)
@@ -1429,8 +974,8 @@
=20
 #if defined(AHA152X_DEBUG)
 	if (HOSTDATA(shpnt)->debug & debug_queue) {
-		printk(INFO_LEAD "queue: cmd_len=3D%d pieces=3D%d size=3D%u cmnd=3D",
-		       CMDINFO(SCpnt), SCpnt->cmd_len, SCpnt->use_sg, SCpnt->request_buf=
flen);
+		printk(INFO_LEAD "queue: %p; cmd_len=3D%d pieces=3D%d size=3D%u cmnd=3D",
+		       CMDINFO(SCpnt), SCpnt, SCpnt->cmd_len, SCpnt->use_sg, SCpnt->requ=
est_bufflen);
 		print_command(SCpnt->cmnd);
 	}
 #endif
@@ -1449,7 +994,7 @@
 			return FAILED;
 		}
 	} else {
-		SCpnt->host_scribble    =3D kmalloc(sizeof(struct aha152x_scdata), GFP_A=
TOMIC);
+		SCpnt->host_scribble =3D kmalloc(sizeof(struct aha152x_scdata), GFP_ATOM=
IC);
 		if(SCpnt->host_scribble=3D=3D0) {
 			printk(ERR_LEAD "allocation failed\n", CMDINFO(SCpnt));
 			return FAILED;
@@ -1544,11 +1089,6 @@
 	Scsi_Cmnd *ptr;
 	unsigned long flags;
=20
-	if(!shpnt) {
-		printk(ERR_LEAD "abort(%p): no host structure\n", CMDINFO(SCpnt), SCpnt);
-		return FAILED;
-	}
-
 #if defined(AHA152X_DEBUG)
 	if(HOSTDATA(shpnt)->debug & debug_eh) {
 		printk(DEBUG_LEAD "abort(%p)", CMDINFO(SCpnt), SCpnt);
@@ -1593,15 +1133,12 @@
 	Scsi_Cmnd	 *SCp   =3D (Scsi_Cmnd *)p;
 	struct semaphore *sem   =3D SCSEM(SCp);
 	struct Scsi_Host *shpnt =3D SCp->device->host;
+	unsigned long flags;
=20
 	/* remove command from issue queue */
-	if(remove_SC(&ISSUE_SC, SCp)) {
-		printk(KERN_INFO "aha152x: ABORT timed out - removed from issue queue\n"=
);
-		kfree(SCp->host_scribble);
-		SCp->host_scribble=3D0;
-	} else {
-		printk(KERN_INFO "aha152x: ABORT timed out - not on issue queue\n");
-	}
+	DO_LOCK(flags);
+	remove_SC(&ISSUE_SC, SCp);
+	DO_UNLOCK(flags);
=20
 	up(sem);
 }
@@ -1609,15 +1146,16 @@
 /*
  * Reset a device
  *
- * FIXME: never seen this live. might lockup...
- *
  */
 static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 {
 	struct Scsi_Host *shpnt =3D SCpnt->device->host;
 	DECLARE_MUTEX_LOCKED(sem);
 	struct timer_list timer;
+	unsigned long flags;
 	int ret;
+	int issued=3D0;
+	int disconnected=3D0;
=20
 #if defined(AHA152X_DEBUG)
 	if(HOSTDATA(shpnt)->debug & debug_eh) {
@@ -1631,6 +1169,11 @@
 		return FAILED;
 	}
=20
+	DO_LOCK(flags);
+	issued       =3D remove_SC(&ISSUE_SC, SCpnt)=3D=3D0;
+	disconnected =3D issued && remove_SC(&DISCONNECTED_SC, SCpnt);
+	DO_UNLOCK(flags);
+
 	SCpnt->cmd_len         =3D 0;
 	SCpnt->use_sg          =3D 0;
 	SCpnt->request_buffer  =3D 0;
@@ -1645,15 +1188,30 @@
 	add_timer(&timer);
 	down(&sem);
 	del_timer(&timer);
-
+=09
 	SCpnt->cmd_len         =3D SCpnt->old_cmd_len;
 	SCpnt->use_sg          =3D SCpnt->old_use_sg;
   	SCpnt->request_buffer  =3D SCpnt->buffer;
        	SCpnt->request_bufflen =3D SCpnt->bufflen;
=20
 	if(SCpnt->SCp.phase & resetted) {
+		HOSTDATA(shpnt)->commands--;
+		if (!HOSTDATA(shpnt)->commands)
+			SETPORT(PORTA, 0);
+		kfree(SCpnt->host_scribble);
+		SCpnt->host_scribble=3D0;
+
 		ret =3D SUCCESS;
 	} else {
+		/* requeue */
+		DO_LOCK(flags);
+		if(!issued) {
+			append_SC(&ISSUE_SC, SCpnt);
+		} else if(disconnected) {
+			append_SC(&DISCONNECTED_SC, SCpnt);
+		}
+		DO_UNLOCK(flags);
+=09
 		ret =3D FAILED;
 	}
=20
@@ -1664,13 +1222,17 @@
 static void free_hard_reset_SCs(struct Scsi_Host *shpnt, Scsi_Cmnd **SCs)
 {
 	Scsi_Cmnd *ptr;
-	unsigned long flags;
-
-	DO_LOCK(flags);
=20
 	ptr=3D*SCs;
 	while(ptr) {
-		Scsi_Cmnd *next =3D SCNEXT(ptr);
+		Scsi_Cmnd *next;
+
+		if(SCDATA(ptr)) {
+			next =3D SCNEXT(ptr);
+		} else {
+			printk(DEBUG_LEAD "queue corrupted at %p\n", CMDINFO(ptr), ptr);
+			next =3D 0;
+		}
=20
 		if (!ptr->device->soft_reset) {
 			DPRINTK(debug_eh, DEBUG_LEAD "disconnected command %p removed\n", CMDIN=
FO(ptr), ptr);
@@ -1682,8 +1244,6 @@
=20
 		ptr =3D next;
 	}
-
-	DO_UNLOCK(flags);
 }
=20
 /*
@@ -1695,6 +1255,8 @@
 	struct Scsi_Host *shpnt =3D SCpnt->device->host;
 	unsigned long flags;
=20
+	DO_LOCK(flags);
+
 #if defined(AHA152X_DEBUG)
 	if(HOSTDATA(shpnt)->debug & debug_eh) {
 		printk(DEBUG_LEAD "aha152x_bus_reset(%p)", CMDINFO(SCpnt), SCpnt);
@@ -1712,12 +1274,12 @@
 	SETPORT(SCSISEQ, 0);
 	mdelay(DELAY);
=20
-	DPRINTK(debug_eh, DEBUG_LEAD "bus reset returns\n", CMDINFO(SCpnt));
+	DPRINTK(debug_eh, DEBUG_LEAD "bus resetted\n", CMDINFO(SCpnt));
=20
-	DO_LOCK(flags);
 	setup_expected_interrupts(shpnt);
 	if(HOSTDATA(shpnt)->commands=3D=3D0)
 		SETPORT(PORTA, 0);
+
 	DO_UNLOCK(flags);
=20
 	return SUCCESS;
@@ -1983,6 +1545,7 @@
 #if defined(AHA152X_STAT)
 		action++;
 #endif
+
 		if(DONE_SC->SCp.phase & check_condition) {
 #if 0
 			if(HOSTDATA(shpnt)->debug & debug_eh) {
@@ -2012,47 +1575,57 @@
 #endif
=20
 			if(!(DONE_SC->SCp.Status & not_issued)) {
+				Scsi_Cmnd *ptr =3D DONE_SC;
+				DONE_SC=3D0;
 #if 0
-				DPRINTK(debug_eh, ERR_LEAD "requesting sense\n", CMDINFO(DONE_SC));
+				DPRINTK(debug_eh, ERR_LEAD "requesting sense\n", CMDINFO(ptr));
 #endif
=20
-				DONE_SC->cmnd[0]         =3D REQUEST_SENSE;
-				DONE_SC->cmnd[1]         =3D 0;
-				DONE_SC->cmnd[2]         =3D 0;
-				DONE_SC->cmnd[3]         =3D 0;
-				DONE_SC->cmnd[4]         =3D sizeof(DONE_SC->sense_buffer);
-				DONE_SC->cmnd[5]         =3D 0;
-				DONE_SC->cmd_len         =3D 6;
-				DONE_SC->use_sg          =3D 0;=20
-				DONE_SC->request_buffer  =3D DONE_SC->sense_buffer;
-				DONE_SC->request_bufflen =3D sizeof(DONE_SC->sense_buffer);
+				ptr->cmnd[0]         =3D REQUEST_SENSE;
+				ptr->cmnd[1]         =3D 0;
+				ptr->cmnd[2]         =3D 0;
+				ptr->cmnd[3]         =3D 0;
+				ptr->cmnd[4]         =3D sizeof(ptr->sense_buffer);
+				ptr->cmnd[5]         =3D 0;
+				ptr->cmd_len         =3D 6;
+				ptr->use_sg          =3D 0;=20
+				ptr->request_buffer  =3D ptr->sense_buffer;
+				ptr->request_bufflen =3D sizeof(ptr->sense_buffer);
 		=09
 				DO_UNLOCK(flags);
-				aha152x_internal_queue(DONE_SC, 0, check_condition, DONE_SC->scsi_done=
);
+				aha152x_internal_queue(ptr, 0, check_condition, ptr->scsi_done);
 				DO_LOCK(flags);
-
-				DONE_SC=3D0;
-			} else {
 #if 0
+			} else {
 				DPRINTK(debug_eh, ERR_LEAD "command not issued - CHECK CONDITION ignor=
ed\n", CMDINFO(DONE_SC));
 #endif
 			}
 		}
=20
 		if(DONE_SC && DONE_SC->scsi_done) {
-			/* turn led off, when no commands are in the driver */
-			HOSTDATA(shpnt)->commands--;
-			if (!HOSTDATA(shpnt)->commands)
-				SETPORT(PORTA, 0);	/* turn led off */
+#if defined(AHA152X_DEBUG)
+			int hostno=3DDONE_SC->device->host->host_no;
+			int id=3DDONE_SC->device->id & 0xf;
+			int lun=3DDONE_SC->device->lun & 0x7;
+#endif
+			Scsi_Cmnd *ptr =3D DONE_SC;
+			DONE_SC=3D0;
+
+			if(ptr->scsi_done !=3D reset_done) {
+				kfree(ptr->host_scribble);
+				ptr->host_scribble=3D0;
+			}
=20
 			DO_UNLOCK(flags);
-			DPRINTK(debug_done, DEBUG_LEAD "calling scsi_done(%p)\n", CMDINFO(DONE_=
SC), DONE_SC);
-                	DONE_SC->scsi_done(DONE_SC);
-			DPRINTK(debug_done, DEBUG_LEAD "scsi_done(%p) returned\n", CMDINFO(DONE=
_SC), DONE_SC);
+			DPRINTK(debug_done, DEBUG_LEAD "calling scsi_done(%p)\n", hostno, id, l=
un, ptr);
+                	ptr->scsi_done(ptr);
+			DPRINTK(debug_done, DEBUG_LEAD "scsi_done(%p) returned\n", hostno, id, =
lun, ptr);
 			DO_LOCK(flags);
=20
-			kfree(DONE_SC->host_scribble);
-			DONE_SC->host_scribble=3D0;
+			/* turn led off, when no commands are in the driver */
+			HOSTDATA(shpnt)->commands--;
+			if (!HOSTDATA(shpnt)->commands)
+				SETPORT(PORTA, 0);	/* turn led off */
 		}
=20
 		DONE_SC=3D0;
@@ -2920,10 +2493,10 @@
 			remove_SC(&DISCONNECTED_SC, ptr);
=20
 			ptr->result =3D  DID_RESET << 16;
-			ptr->scsi_done(ptr);
-
 			kfree(ptr->host_scribble);
 			ptr->host_scribble=3D0;
+			ptr->scsi_done(ptr);
+
 		}
=20
 		ptr =3D next;
@@ -3365,7 +2938,11 @@
 		printk("aborted|");
 	if (ptr->SCp.phase & resetted)
 		printk("resetted|");
-	printk("; next=3D0x%p\n", SCNEXT(ptr));
+	if( SCDATA(ptr) ) {
+		printk("; next=3D0x%p\n", SCNEXT(ptr));
+	} else {
+		printk("; next=3D(host scribble NULL)\n");
+	}
 }
=20
 /*
@@ -3389,7 +2966,7 @@
 		printk(KERN_DEBUG "none\n");
=20
 	printk(KERN_DEBUG "disconnected_SC:\n");
-	for (ptr =3D DISCONNECTED_SC; ptr; ptr =3D SCNEXT(ptr))
+	for (ptr =3D DISCONNECTED_SC; ptr; ptr =3D SCDATA(ptr) ? SCNEXT(ptr) : 0)
 		show_command(ptr);
=20
 	disp_ports(shpnt);
@@ -3880,26 +3457,489 @@
 }
=20
 static Scsi_Host_Template aha152x_driver_template =3D {
-	.module			=3D THIS_MODULE,
-	.name			=3D AHA152X_REVID,
-	.proc_name		=3D "aha152x",
-	.proc_info		=3D aha152x_proc_info,
-	.detect			=3D aha152x_detect,
-	.queuecommand		=3D aha152x_queue,
-	.eh_abort_handler	=3D aha152x_abort,
-	.eh_device_reset_handler =3D aha152x_device_reset,
-	.eh_bus_reset_handler	=3D aha152x_bus_reset,
-	.eh_host_reset_handler	=3D aha152x_host_reset,
-	.release		=3D aha152x_release,
-	.bios_param		=3D aha152x_biosparam,
-	.can_queue		=3D 1,
-	.this_id		=3D 7,
-	.sg_tablesize		=3D SG_ALL,
-	.cmd_per_lun		=3D 1,
-	.use_clustering		=3D DISABLE_CLUSTERING,
+	.module				=3D THIS_MODULE,
+	.name				=3D AHA152X_REVID,
+	.proc_name			=3D "aha152x",
+	.proc_info			=3D aha152x_proc_info,
+	.queuecommand			=3D aha152x_queue,
+	.eh_abort_handler		=3D aha152x_abort,
+	.eh_device_reset_handler	=3D aha152x_device_reset,
+	.eh_bus_reset_handler		=3D aha152x_bus_reset,
+	.eh_host_reset_handler		=3D aha152x_host_reset,
+	.bios_param			=3D aha152x_biosparam,
+	.can_queue			=3D 1,
+	.this_id			=3D 7,
+	.sg_tablesize			=3D SG_ALL,
+	.cmd_per_lun			=3D 1,
+	.use_clustering			=3D DISABLE_CLUSTERING,
 };
=20
-#ifndef PCMCIA
-#define driver_template aha152x_driver_template
-#include "scsi_module.c"
+#if !defined(PCMCIA)
+static int setup_count;
+static struct aha152x_setup setup[2];
+
+/* possible i/o addresses for the AIC-6260; default first */
+static unsigned short ports[] =3D { 0x340, 0x140 };
+
+#if !defined(SKIP_BIOSTEST)
+/* possible locations for the Adaptec BIOS; defaults first */
+static unsigned int addresses[] =3D
+{
+	0xdc000,		/* default first */
+	0xc8000,
+	0xcc000,
+	0xd0000,
+	0xd4000,
+	0xd8000,
+	0xe0000,
+	0xeb800,		/* VTech Platinum SMP */
+	0xf0000,
+};
+
+/* signatures for various AIC-6[23]60 based controllers.
+   The point in detecting signatures is to avoid useless and maybe
+   harmful probes on ports. I'm not sure that all listed boards pass
+   auto-configuration. For those which fail the BIOS signature is
+   obsolete, because user intervention to supply the configuration is
+   needed anyway.  May be an information whether or not the BIOS supports
+   extended translation could be also useful here. */
+static struct signature {
+	unsigned char *signature;
+	int sig_offset;
+	int sig_length;
+} signatures[] =3D
+{
+	{ "Adaptec AHA-1520 BIOS",	0x102e, 21 },
+		/* Adaptec 152x */
+	{ "Adaptec AHA-1520B",		0x000b, 17 },
+		/* Adaptec 152x rev B */
+	{ "Adaptec AHA-1520B",		0x0026, 17 },
+		/* Iomega Jaz Jet ISA (AIC6370Q) */
+	{ "Adaptec ASW-B626 BIOS",	0x1029, 21 },
+		/* on-board controller */
+	{ "Adaptec BIOS: ASW-B626",	0x000f, 22 },
+		/* on-board controller */
+	{ "Adaptec ASW-B626 S2",	0x2e6c, 19 },
+		/* on-board controller */
+	{ "Adaptec BIOS:AIC-6360",	0x000c, 21 },
+		/* on-board controller */
+	{ "ScsiPro SP-360 BIOS",	0x2873, 19 },
+		/* ScsiPro-Controller  */
+	{ "GA-400 LOCAL BUS SCSI BIOS", 0x102e, 26 },
+		/* Gigabyte Local-Bus-SCSI */
+	{ "Adaptec BIOS:AVA-282X",	0x000c, 21 },
+		/* Adaptec 282x */
+	{ "Adaptec IBM Dock II SCSI",   0x2edd, 24 },
+		/* IBM Thinkpad Dock II */
+	{ "Adaptec BIOS:AHA-1532P",     0x001c, 22 },
+		/* IBM Thinkpad Dock II SCSI */
+	{ "DTC3520A Host Adapter BIOS", 0x318a, 26 },
+		/* DTC 3520A ISA SCSI */
+};
+#endif /* !SKIP_BIOSTEST */
+
+/*
+ * Test, if port_base is valid.
+ *
+ */
+static int aha152x_porttest(int io_port)
+{
+	int i;
+
+	SETPORT(io_port + O_DMACNTRL1, 0);	/* reset stack pointer */
+	for (i =3D 0; i < 16; i++)
+		SETPORT(io_port + O_STACK, i);
+
+	SETPORT(io_port + O_DMACNTRL1, 0);	/* reset stack pointer */
+	for (i =3D 0; i < 16 && GETPORT(io_port + O_STACK) =3D=3D i; i++)
+		;
+
+	return (i =3D=3D 16);
+}
+
+static int tc1550_porttest(int io_port)
+{
+	int i;
+
+	SETPORT(io_port + O_TC_DMACNTRL1, 0);	/* reset stack pointer */
+	for (i =3D 0; i < 16; i++)
+		SETPORT(io_port + O_STACK, i);
+
+	SETPORT(io_port + O_TC_DMACNTRL1, 0);	/* reset stack pointer */
+	for (i =3D 0; i < 16 && GETPORT(io_port + O_TC_STACK) =3D=3D i; i++)
+		;
+
+	return (i =3D=3D 16);
+}
+
+
+static int checksetup(struct aha152x_setup *setup)
+{
+	int i;
+	for (i =3D 0; i < ARRAY_SIZE(ports) && (setup->io_port !=3D ports[i]); i+=
+)
+		;
+
+	if (i =3D=3D ARRAY_SIZE(ports))
+		return 0;
+
+	if( aha152x_porttest(setup->io_port) ) {
+		setup->tc1550=3D0;
+        } else if( tc1550_porttest(setup->io_port) ) {
+		setup->tc1550=3D1;
+	} else {
+		return 0;
+	}
+
+	if ((setup->irq < IRQ_MIN) || (setup->irq > IRQ_MAX))
+		return 0;
+
+	if ((setup->scsiid < 0) || (setup->scsiid > 7))
+		return 0;
+
+	if ((setup->reconnect < 0) || (setup->reconnect > 1))
+		return 0;
+
+	if ((setup->parity < 0) || (setup->parity > 1))
+		return 0;
+
+	if ((setup->synchronous < 0) || (setup->synchronous > 1))
+		return 0;
+
+	if ((setup->ext_trans < 0) || (setup->ext_trans > 1))
+		return 0;
+
+
+	return 1;
+}
+
+
+static int __init aha152x_init(void)
+{
+	int i, j, ok;
+#if defined(AUTOCONF)
+	aha152x_config conf;
 #endif
+#ifdef __ISAPNP__
+	struct pnp_dev *dev=3D0, *pnpdev[2] =3D {0, 0};
+#endif
+
+	if ( setup_count ) {
+		printk(KERN_INFO "aha152x: processing commandline: ");
+
+		for (i =3D 0; i<setup_count; i++) {
+			if (!checksetup(&setup[i])) {
+				printk(KERN_ERR "\naha152x: %s\n", setup[i].conf);
+				printk(KERN_ERR "aha152x: invalid line\n");
+			}
+		}
+		printk("ok\n");
+	}
+
+#if defined(SETUP0)
+	if (setup_count < ARRAY_SIZE(setup)) {
+		struct aha152x_setup override =3D SETUP0;
+
+		if (setup_count =3D=3D 0 || (override.io_port !=3D setup[0].io_port)) {
+			if (!checksetup(&override)) {
+				printk(KERN_ERR "\naha152x: invalid override SETUP0=3D{0x%x,%d,%d,%d,%=
d,%d,%d,%d}\n",
+				       override.io_port,
+				       override.irq,
+				       override.scsiid,
+				       override.reconnect,
+				       override.parity,
+				       override.synchronous,
+				       override.delay,
+				       override.ext_trans);
+			} else
+				setup[setup_count++] =3D override;
+		}
+	}
+#endif
+
+#if defined(SETUP1)
+	if (setup_count < ARRAY_SIZE(setup)) {
+		struct aha152x_setup override =3D SETUP1;
+
+		if (setup_count =3D=3D 0 || (override.io_port !=3D setup[0].io_port)) {
+			if (!checksetup(&override)) {
+				printk(KERN_ERR "\naha152x: invalid override SETUP1=3D{0x%x,%d,%d,%d,%=
d,%d,%d,%d}\n",
+				       override.io_port,
+				       override.irq,
+				       override.scsiid,
+				       override.reconnect,
+				       override.parity,
+				       override.synchronous,
+				       override.delay,
+				       override.ext_trans);
+			} else
+				setup[setup_count++] =3D override;
+		}
+	}
+#endif
+
+#if defined(MODULE)
+	if (setup_count<ARRAY_SIZE(setup) && (aha152x[0]!=3D0 || io[0]!=3D0 || ir=
q[0]!=3D0)) {
+		if(aha152x[0]!=3D0) {
+			setup[setup_count].conf        =3D "";
+			setup[setup_count].io_port     =3D aha152x[0];
+			setup[setup_count].irq         =3D aha152x[1];
+			setup[setup_count].scsiid      =3D aha152x[2];
+			setup[setup_count].reconnect   =3D aha152x[3];
+			setup[setup_count].parity      =3D aha152x[4];
+			setup[setup_count].synchronous =3D aha152x[5];
+			setup[setup_count].delay       =3D aha152x[6];
+			setup[setup_count].ext_trans   =3D aha152x[7];
+#if defined(AHA152X_DEBUG)
+			setup[setup_count].debug       =3D aha152x[8];
+#endif
+	  	} else if(io[0]!=3D0 || irq[0]!=3D0) {
+			if(io[0]!=3D0)  setup[setup_count].io_port =3D io[0];
+			if(irq[0]!=3D0) setup[setup_count].irq     =3D irq[0];
+
+	    		setup[setup_count].scsiid      =3D scsiid[0];
+	    		setup[setup_count].reconnect   =3D reconnect[0];
+	    		setup[setup_count].parity      =3D parity[0];
+	    		setup[setup_count].synchronous =3D sync[0];
+	    		setup[setup_count].delay       =3D delay[0];
+	    		setup[setup_count].ext_trans   =3D exttrans[0];
+#if defined(AHA152X_DEBUG)
+			setup[setup_count].debug       =3D debug[0];
+#endif
+		}
+
+          	if (checksetup(&setup[setup_count]))
+			setup_count++;
+		else
+			printk(KERN_ERR "aha152x: invalid module params io=3D0x%x, irq=3D%d,scs=
iid=3D%d,reconnect=3D%d,parity=3D%d,sync=3D%d,delay=3D%d,exttrans=3D%d\n",
+			       setup[setup_count].io_port,
+			       setup[setup_count].irq,
+			       setup[setup_count].scsiid,
+			       setup[setup_count].reconnect,
+			       setup[setup_count].parity,
+			       setup[setup_count].synchronous,
+			       setup[setup_count].delay,
+			       setup[setup_count].ext_trans);
+	}
+
+	if (setup_count<ARRAY_SIZE(setup) && (aha152x1[0]!=3D0 || io[1]!=3D0 || i=
rq[1]!=3D0)) {
+		if(aha152x1[0]!=3D0) {
+			setup[setup_count].conf        =3D "";
+			setup[setup_count].io_port     =3D aha152x1[0];
+			setup[setup_count].irq         =3D aha152x1[1];
+			setup[setup_count].scsiid      =3D aha152x1[2];
+			setup[setup_count].reconnect   =3D aha152x1[3];
+			setup[setup_count].parity      =3D aha152x1[4];
+			setup[setup_count].synchronous =3D aha152x1[5];
+			setup[setup_count].delay       =3D aha152x1[6];
+			setup[setup_count].ext_trans   =3D aha152x1[7];
+#if defined(AHA152X_DEBUG)
+			setup[setup_count].debug       =3D aha152x1[8];
+#endif
+	  	} else if(io[1]!=3D0 || irq[1]!=3D0) {
+			if(io[1]!=3D0)  setup[setup_count].io_port =3D io[1];
+			if(irq[1]!=3D0) setup[setup_count].irq     =3D irq[1];
+
+	    		setup[setup_count].scsiid      =3D scsiid[1];
+	    		setup[setup_count].reconnect   =3D reconnect[1];
+	    		setup[setup_count].parity      =3D parity[1];
+	    		setup[setup_count].synchronous =3D sync[1];
+	    		setup[setup_count].delay       =3D delay[1];
+	    		setup[setup_count].ext_trans   =3D exttrans[1];
+#if defined(AHA152X_DEBUG)
+			setup[setup_count].debug       =3D debug[1];
+#endif
+		}
+		if (checksetup(&setup[setup_count]))
+			setup_count++;
+		else
+			printk(KERN_ERR "aha152x: invalid module params io=3D0x%x, irq=3D%d,scs=
iid=3D%d,reconnect=3D%d,parity=3D%d,sync=3D%d,delay=3D%d,exttrans=3D%d\n",
+			       setup[setup_count].io_port,
+			       setup[setup_count].irq,
+			       setup[setup_count].scsiid,
+			       setup[setup_count].reconnect,
+			       setup[setup_count].parity,
+			       setup[setup_count].synchronous,
+			       setup[setup_count].delay,
+			       setup[setup_count].ext_trans);
+	}
+#endif
+
+#ifdef __ISAPNP__
+	while ( setup_count<ARRAY_SIZE(setup) && (dev=3Dpnp_find_dev(NULL, ISAPNP=
_VENDOR('A','D','P'), ISAPNP_FUNCTION(0x1505), dev)) ) {
+		if (pnp_device_attach(dev) < 0)
+			continue;
+		if (pnp_activate_dev(dev) < 0) {
+			pnp_device_detach(dev);
+			continue;
+		}
+		if (!pnp_port_valid(dev, 0)) {
+			pnp_device_detach(dev);
+			continue;
+		}
+		if (setup_count=3D=3D1 && pnp_port_start(dev, 0)=3D=3Dsetup[0].io_port) {
+			pnp_device_detach(dev);
+			continue;
+		}
+		setup[setup_count].io_port     =3D pnp_port_start(dev, 0);
+		setup[setup_count].irq         =3D pnp_irq(dev, 0);
+		setup[setup_count].scsiid      =3D 7;
+		setup[setup_count].reconnect   =3D 1;
+		setup[setup_count].parity      =3D 1;
+		setup[setup_count].synchronous =3D 1;
+		setup[setup_count].delay       =3D DELAY_DEFAULT;
+		setup[setup_count].ext_trans   =3D 0;
+#if defined(AHA152X_DEBUG)
+		setup[setup_count].debug       =3D DEBUG_DEFAULT;
+#endif
+		pnpdev[setup_count]            =3D dev;
+		printk (KERN_INFO
+			"aha152x: found ISAPnP AVA-1505A at io=3D0x%03x, irq=3D%d\n",
+			setup[setup_count].io_port, setup[setup_count].irq);
+		setup_count++;
+	}
+#endif
+
+#if defined(AUTOCONF)
+	if (setup_count<ARRAY_SIZE(setup)) {
+#if !defined(SKIP_BIOSTEST)
+		ok =3D 0;
+		for (i =3D 0; i < ARRAY_SIZE(addresses) && !ok; i++)
+			for (j =3D 0; j<ARRAY_SIZE(signatures) && !ok; j++)
+				ok =3D isa_check_signature(addresses[i] + signatures[j].sig_offset,
+								signatures[j].signature, signatures[j].sig_length);
+		if (!ok && setup_count =3D=3D 0)
+			return 0;
+
+		printk(KERN_INFO "aha152x: BIOS test: passed, ");
+#else
+		printk(KERN_INFO "aha152x: ");
+#endif				/* !SKIP_BIOSTEST */
+
+		ok =3D 0;
+		for (i =3D 0; i < ARRAY_SIZE(ports) && setup_count < 2; i++) {
+			if ((setup_count =3D=3D 1) && (setup[0].io_port =3D=3D ports[i]))
+				continue;
+
+			if (aha152x_porttest(ports[i])) {
+				ok++;
+				setup[setup_count].io_port =3D ports[i];
+				setup[setup_count].tc1550  =3D 0;
+
+				conf.cf_port =3D
+				    (GETPORT(ports[i] + O_PORTA) << 8) + GETPORT(ports[i] + O_PORTB);
+
+				setup[setup_count].irq =3D IRQ_MIN + conf.cf_irq;
+				setup[setup_count].scsiid =3D conf.cf_id;
+				setup[setup_count].reconnect =3D conf.cf_tardisc;
+				setup[setup_count].parity =3D !conf.cf_parity;
+				setup[setup_count].synchronous =3D conf.cf_syncneg;
+				setup[setup_count].delay =3D DELAY_DEFAULT;
+				setup[setup_count].ext_trans =3D 0;
+#if defined(AHA152X_DEBUG)
+				setup[setup_count].debug =3D DEBUG_DEFAULT;
+#endif
+				setup_count++;
+			} else if (tc1550_porttest(ports[i])) {
+				ok++;
+				setup[setup_count].io_port =3D ports[i];
+				setup[setup_count].tc1550  =3D 1;
+
+				conf.cf_port =3D
+				    (GETPORT(ports[i] + O_PORTA) << 8) + GETPORT(ports[i] + O_PORTB);
+
+				setup[setup_count].irq =3D IRQ_MIN + conf.cf_irq;
+				setup[setup_count].scsiid =3D conf.cf_id;
+				setup[setup_count].reconnect =3D conf.cf_tardisc;
+				setup[setup_count].parity =3D !conf.cf_parity;
+				setup[setup_count].synchronous =3D conf.cf_syncneg;
+				setup[setup_count].delay =3D DELAY_DEFAULT;
+				setup[setup_count].ext_trans =3D 0;
+#if defined(AHA152X_DEBUG)
+				setup[setup_count].debug =3D DEBUG_DEFAULT;
+#endif
+				setup_count++;
+			}
+		}
+
+		if (ok)
+			printk("auto configuration: ok, ");
+	}
+#endif
+
+	printk("%d controller(s) configured\n", setup_count);
+
+	for (i=3D0; i<setup_count; i++) {
+		if ( request_region(setup[i].io_port, IO_RANGE, "aha152x") ) {
+			struct Scsi_Host *shpnt =3D aha152x_probe_one(&setup[i]);
+
+			if( !shpnt ) {
+				release_region(setup[i].io_port, IO_RANGE);
+#if defined(__ISAPNP__)
+			} else if( pnpdev[i] ) {
+				HOSTDATA(shpnt)->pnpdev=3Dpnpdev[i];
+#endif
+			}
+		}
+	}
+
+	return registered_count>0;
+}
+
+static void __exit aha152x_exit(void)
+{
+	int i;
+
+	for(i=3D0; i<ARRAY_SIZE(setup); i++) {
+		aha152x_release(aha152x_host[i]);
+		aha152x_host[i]=3D0;
+	}
+}
+
+module_init(aha152x_init);
+module_exit(aha152x_exit);
+
+#if !defined(MODULE)
+static int __init aha152x_setup(char *str)
+{
+#if defined(AHA152X_DEBUG)
+	int ints[11];
+#else
+	int ints[10];
+#endif
+	get_options(str, ARRAY_SIZE(ints), ints);
+
+	if(setup_count>=3DARRAY_SIZE(setup)) {
+		printk(KERN_ERR "aha152x: you can only configure up to two controllers\n=
");
+		return 1;
+	}
+
+	setup[setup_count].conf        =3D str;
+	setup[setup_count].io_port     =3D ints[0] >=3D 1 ? ints[1] : 0x340;
+	setup[setup_count].irq         =3D ints[0] >=3D 2 ? ints[2] : 11;
+	setup[setup_count].scsiid      =3D ints[0] >=3D 3 ? ints[3] : 7;
+	setup[setup_count].reconnect   =3D ints[0] >=3D 4 ? ints[4] : 1;
+	setup[setup_count].parity      =3D ints[0] >=3D 5 ? ints[5] : 1;
+	setup[setup_count].synchronous =3D ints[0] >=3D 6 ? ints[6] : 1;
+	setup[setup_count].delay       =3D ints[0] >=3D 7 ? ints[7] : DELAY_DEFAU=
LT;
+	setup[setup_count].ext_trans   =3D ints[0] >=3D 8 ? ints[8] : 0;
+#if defined(AHA152X_DEBUG)
+	setup[setup_count].debug       =3D ints[0] >=3D 9 ? ints[9] : DEBUG_DEFAU=
LT;
+	if (ints[0] > 9) {
+		printk(KERN_NOTICE "aha152x: usage: aha152x=3D<IOBASE>[,<IRQ>[,<SCSI ID>"
+		       "[,<RECONNECT>[,<PARITY>[,<SYNCHRONOUS>[,<DELAY>[,<EXT_TRANS>[,<D=
EBUG>]]]]]]]]\n");
+#else
+	if (ints[0] > 8) {                                                /*}*/
+		printk(KERN_NOTICE "aha152x: usage: aha152x=3D<IOBASE>[,<IRQ>[,<SCSI ID>"
+		       "[,<RECONNECT>[,<PARITY>[,<SYNCHRONOUS>[,<DELAY>[,<EXT_TRANS>]]]]=
]]]\n");
+#endif
+	} else {
+		setup_count++;
+		return 0;
+	}
+
+	return 1;
+}
+__setup("aha152x=3D", aha152x_setup);
+#endif
+
+#endif /* !PCMCIA */
diff -udr orig/linux-2.6.0/drivers/scsi/aha152x.h linux-2.6.0/drivers/scsi/=
aha152x.h
--- orig/linux-2.6.0/drivers/scsi/aha152x.h	2003-12-18 03:59:05.000000000 +=
0100
+++ linux-2.6.0/drivers/scsi/aha152x.h	2004-01-13 21:26:46.000000000 +0100
@@ -331,6 +331,7 @@
 };
=20
 struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *);
-int aha152x_host_reset(struct scsi_cmnd *);
+void aha152x_release(struct Scsi_Host *);
+int aha152x_host_reset(Scsi_Cmnd *);
=20
 #endif /* _AHA152X_H */
diff -udr orig/linux-2.6.0/drivers/scsi/pcmcia/aha152x_stub.c linux-2.6.0/d=
rivers/scsi/pcmcia/aha152x_stub.c
--- orig/linux-2.6.0/drivers/scsi/pcmcia/aha152x_stub.c	2003-12-18 03:59:36=
=2E000000000 +0100
+++ linux-2.6.0/drivers/scsi/pcmcia/aha152x_stub.c	2004-01-15 18:42:29.0000=
00000 +0100
@@ -78,7 +78,7 @@
 static int host_id =3D 7;
 static int reconnect =3D 1;
 static int parity =3D 1;
-static int synchronous =3D 0;
+static int synchronous =3D 1;
 static int reset_delay =3D 100;
 static int ext_trans =3D 0;
=20
@@ -246,9 +246,6 @@
     CS_CHECK(RequestIRQ, handle, &link->irq);
     CS_CHECK(RequestConfiguration, handle, &link->conf);
    =20
-    /* A bad hack... */
-    release_region(link->io.BasePort1, link->io.NumPorts1);
-
     /* Set configuration options for the aha152x driver */
     memset(&s, 0, sizeof(s));
     s.conf        =3D "PCMCIA setup";
@@ -268,9 +265,6 @@
 	goto cs_failed;
     }
=20
-    scsi_add_host(host, NULL); /* XXX handle failure */
-    scsi_scan_host(host);
-
     sprintf(info->node.dev_name, "scsi%d", host->host_no);
     link->dev =3D &info->node;
     info->host =3D host;
@@ -288,7 +282,7 @@
 {
 	scsi_info_t *info =3D link->priv;
=20
-	scsi_remove_host(info->host);
+	aha152x_release(info->host);
 	link->dev =3D NULL;
    =20
 	CardServices(ReleaseConfiguration, link->handle);
@@ -296,7 +290,6 @@
 	CardServices(ReleaseIRQ, link->handle, &link->irq);
    =20
 	link->state &=3D ~DEV_CONFIG;
-	scsi_unregister(info->host);
 }
=20
 static int aha152x_event(event_t event, int priority,

--qDbXVdCdHGoSgWSk--

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFACxKLc/GhTF5ESHURApdrAJ9gaH7gS+D+rdQI80Ok+kus9MExSQCePAvE
CpWncvVqm8QQPEVbg+QUBCE=
=rsBg
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
