From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: Re: [patch] qlogic: don't use qinfo as name
Date: Thu, 19 Feb 2004 14:26:19 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040219172619.GA667@cathedrallabs.org>
References: <20031020232200.GA473@cathedrallabs.org> <20040219150747.A23822@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eheScQNz3K90DVRs"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:33288 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S267437AbUBSR30 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2004 12:29:26 -0500
Content-Disposition: inline
In-Reply-To: <20040219150747.A23822@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org


--eheScQNz3K90DVRs
Content-Type: multipart/mixed; boundary="f+W+jCU1fRNres8c"
Content-Disposition: inline


--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hi Christoph,
> do you have those  qlogicfas patches from before the freeze still around?
> I just noticed they still aren't merged and without them the driver is
> pretty much useless..
yes, I'm sending it attached. I didn't changed them since, so I'm not sure if
they will apply cleanly.

--
aris

--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qlogic-dont_use_qinfo.patch"
Content-Transfer-Encoding: quoted-printable

--- linux/drivers/scsi/qlogicfas.c.orig	2003-10-17 16:47:54.000000000 -0200
+++ linux/drivers/scsi/qlogicfas.c	2003-10-17 16:48:30.000000000 -0200
@@ -665,7 +665,6 @@
 	sprintf(qinfo,
 		"Qlogicfas Driver version 0.46, chip %02X at %03X, IRQ %d, TPdma:%d",
 		qltyp, qbase, qlirq, QL_TURBO_PDMA);
-	host->name =3D qinfo;
=20
 	return hreg;
=20

--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qlogic-force_can_queue.patch"

--- linux/drivers/scsi/qlogicfas.c.orig	2003-10-20 21:12:09.000000000 -0200
+++ linux/drivers/scsi/qlogicfas.c	2003-10-20 21:12:17.000000000 -0200
@@ -793,7 +793,7 @@
 	.eh_device_reset_handler= qlogicfas_device_reset,
 	.eh_host_reset_handler	= qlogicfas_host_reset,
 	.bios_param		= qlogicfas_biosparam,
-	.can_queue		= 0,
+	.can_queue		= 1,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 1,

--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qlogic-kill_qluseirq.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-2.5/drivers/scsi/qlogicfas.c	2003-10-15 17:16:15.000000000 -0200
+++ build-2.5/drivers/scsi/qlogicfas.c	2003-10-17 16:44:41.000000000 -0200
@@ -48,11 +48,6 @@
=20
 #define QL_INT_ACTIVE_HIGH 2
=20
-/* Set the following to 1 to enable the use of interrupts.  Note that 0 te=
nds
-   to be more stable, but slower (or ties up the system more) */
-
-#define QL_USE_IRQ 1
-
 /* Set the following to max out the speed of the PIO PseudoDMA transfers,
    again, 0 tends to be slower, but more stable.  */
=20
@@ -500,8 +495,6 @@
 	return (result << 16) | (message << 8) | (status & STATUS_MASK);
 }
=20
-#if QL_USE_IRQ
-
 /*
  *	Interrupt handler=20
  */
@@ -541,10 +534,6 @@
 	return IRQ_HANDLED;
 }
=20
-#endif
-
-#if QL_USE_IRQ
-
 /*
  *	Queued command
  */
@@ -566,12 +555,6 @@
 	ql_icmd(cmd);
 	return 0;
 }
-#else
-int qlogicfas_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
-{
-	return 1;
-}
-#endif
=20
 #ifdef PCMCIA
=20
@@ -641,7 +624,6 @@
 	REG0;
 #endif
=20
-#if QL_USE_IRQ
 	/*
 	 *	IRQ probe - toggle pin and check request pending=20
 	 */
@@ -670,7 +652,7 @@
=20
 	if (qlirq >=3D 0 && !request_irq(qlirq, do_ql_ihandl, 0, "qlogicfas", NUL=
L))
 		host->can_queue =3D 1;
-#endif
+
 	hreg =3D scsi_register(host, 0);	/* no host data */
 	if (!hreg)
 		goto err_release_mem;

--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qlogic-pcmcia_dont_release_region.patch"
Content-Transfer-Encoding: quoted-printable

--- linux/drivers/scsi/pcmcia/qlogic_stub.c.orig	2003-10-22 22:31:05.000000=
000 -0200
+++ linux/drivers/scsi/pcmcia/qlogic_stub.c	2003-10-22 22:31:36.000000000 -=
0200
@@ -240,9 +240,6 @@
 		outb(0x04, link->io.BasePort1 + 0xd);
 	}
=20
-	/* A bad hack... */
-	release_region(link->io.BasePort1, link->io.NumPorts1);
-
 	/* The KXL-810AN has a bigger IO port window */
 	if (link->io.NumPorts1 =3D=3D 32)
 		qlogicfas_preset(link->io.BasePort1 + 16, link->irq.AssignedIRQ);

--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qlogic-pcmcia_uses_scsi_host_alloc.patch"
Content-Transfer-Encoding: quoted-printable

--- linux/drivers/scsi/qlogicfas.c.orig	2003-10-22 22:25:19.000000000 -0200
+++ linux/drivers/scsi/qlogicfas.c	2003-10-22 21:26:59.000000000 -0200
@@ -650,7 +650,11 @@
 	} else
 		printk(KERN_INFO "Ql: Using preset IRQ %d\n", qlirq);
=20
+#ifdef PCMCIA
+	hreg =3D scsi_host_alloc(host, 0);
+#else
 	hreg =3D scsi_register(host, 0);	/* no host data */
+#endif
 	if (!hreg)
 		goto err_release_mem;
 	hreg->io_port =3D qbase;
--- linux/drivers/scsi/pcmcia/qlogic_stub.c.orig	2003-10-20 21:04:02.000000=
000 -0200
+++ linux/drivers/scsi/pcmcia/qlogic_stub.c	2003-10-22 22:24:34.000000000 -=
0200
@@ -288,7 +288,7 @@
 	CardServices(ReleaseIO, link->handle, &link->io);
 	CardServices(ReleaseIRQ, link->handle, &link->irq);
=20
-	scsi_unregister(info->host);
+	scsi_host_put(info->host);
=20
 	link->state &=3D ~DEV_CONFIG;
 }

--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qlogic-request_irq_with_priv_data.patch"
Content-Transfer-Encoding: quoted-printable

--- linux/drivers/scsi/qlogicfas.c.orig	2003-10-17 16:49:30.000000000 -0200
+++ linux/drivers/scsi/qlogicfas.c	2003-10-17 16:54:06.000000000 -0200
@@ -650,9 +650,6 @@
 	} else
 		printk(KERN_INFO "Ql: Using preset IRQ %d\n", qlirq);
=20
-	if (qlirq >=3D 0 && !request_irq(qlirq, do_ql_ihandl, 0, "qlogicfas", NUL=
L))
-		host->can_queue =3D 1;
-
 	hreg =3D scsi_register(host, 0);	/* no host data */
 	if (!hreg)
 		goto err_release_mem;
@@ -666,12 +663,20 @@
 		"Qlogicfas Driver version 0.46, chip %02X at %03X, IRQ %d, TPdma:%d",
 		qltyp, qbase, qlirq, QL_TURBO_PDMA);
=20
+	if (request_irq(qlirq, do_ql_ihandl, 0, "qlogicfas", hreg))
+		goto free_scsi_host;
+
 	return hreg;
=20
+free_scsi_host:
+#ifdef PCMCIA
+	scsi_host_put(hreg);
+#else
+	scsi_unregister(hreg);
+#endif
+
 err_release_mem:
 	release_region(qbase, 0x10);
-	if (host->can_queue)
-		free_irq(qlirq, do_ql_ihandl);
 	return NULL;;
=20
 }

--f+W+jCU1fRNres8c--

--eheScQNz3K90DVRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFANPG7RRJOudsVYbMRAsBXAJsFSEfQ2tPBei5CCFNzISaVuX/yIQCfc1KA
z2SvOb75yRY4SGx9af07wNo=
=VTd/
-----END PGP SIGNATURE-----

--eheScQNz3K90DVRs--
