From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][11/15] qlogicfas: support multiple cards
Date: Tue, 9 Mar 2004 10:41:27 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309134127.GM651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8D1TCnBmjJJF2KCx"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:64010 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261658AbUCINvw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 08:51:52 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id A2431327FB
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:47:12 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id 7EB142308A
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:33:11 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hU7-0000wo-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:41:27 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--8D1TCnBmjJJF2KCx
Content-Type: multipart/mixed; boundary="CpBQqYjq/d0HQTAP"
Content-Disposition: inline


--CpBQqYjq/d0HQTAP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



--=20
aris


--CpBQqYjq/d0HQTAP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="11-qlogicfas-support_to_multiple_cards.patch"
Content-Transfer-Encoding: quoted-printable

diff -urN linux-2.6.3-applied/drivers/scsi/qlogicfas.c linux-2.6.3-work/dri=
vers/scsi/qlogicfas.c
--- linux-2.6.3-applied/drivers/scsi/qlogicfas.c	2004-03-05 18:51:16.000000=
000 -0300
+++ linux-2.6.3-work/drivers/scsi/qlogicfas.c	2004-03-05 18:51:02.000000000=
 -0300
@@ -27,7 +27,6 @@
    SCSI driver cleanup and audit. This driver still needs work on the
    following
    	-	Non terminating hardware waits
-   	-	Support multiple cards at a time
    	-	Some layering violations with its pcmcia stub
=20
    Redistributable under terms of the GNU General Public License
@@ -139,16 +138,10 @@
=20
 #include "scsi.h"
 #include "hosts.h"
+#include "qlogicfas.h"
=20
 /*----------------------------------------------------------------*/
 /* driver state info, local to driver */
-static int qbase;		/* Port */
-static int qinitid;		/* initiator ID */
-static int qabort;		/* Flag to cause an abort */
-static int qlirq =3D -1;		/* IRQ being used */
-static char qinfo[80];		/* description */
-static Scsi_Cmnd *qlcmd;	/* current command being processed */
-
 static int qlcfg5 =3D (XTALFREQ << 5);	/* 15625/512 */
 static int qlcfg6 =3D SYNCXFRPD;
 static int qlcfg7 =3D SYNCOFFST;
@@ -184,9 +177,10 @@
=20
 /* error recovery - reset everything */
=20
-static void ql_zap(void)
+static void ql_zap(qlogicfas_priv_t priv)
 {
 	int x;
+	int qbase =3D priv->qbase;
=20
 	x =3D inb(qbase + 0xd);
 	REG0;
@@ -200,9 +194,10 @@
  *	Do a pseudo-dma tranfer
  */
 =20
-static int ql_pdma(int phase, char *request, int reqlen)
+static int ql_pdma(qlogicfas_priv_t priv, int phase, char *request, int re=
qlen)
 {
 	int j;
+	int qbase =3D priv->qbase;
 	j =3D 0;
 	if (phase & 1) {	/* in */
 #if QL_TURBO_PDMA
@@ -284,23 +279,25 @@
  *	Wait for interrupt flag (polled - not real hardware interrupt)=20
  */
=20
-static int ql_wai(void)
+static int ql_wai(qlogicfas_priv_t priv)
 {
 	int k;
+	int qbase =3D priv->qbase;
 	unsigned long i;
=20
 	k =3D 0;
 	i =3D jiffies + WATCHDOG;
-	while (time_before(jiffies, i) && !qabort && !((k =3D inb(qbase + 4)) & 0=
xe0)) {
+	while (time_before(jiffies, i) && !priv->qabort &&
+					!((k =3D inb(qbase + 4)) & 0xe0)) {
 		barrier();
 		cpu_relax();
 	}
 	if (time_after_eq(jiffies, i))
 		return (DID_TIME_OUT);
-	if (qabort)
-		return (qabort =3D=3D 1 ? DID_ABORT : DID_RESET);
+	if (priv->qabort)
+		return (priv->qabort =3D=3D 1 ? DID_ABORT : DID_RESET);
 	if (k & 0x60)
-		ql_zap();
+		ql_zap(priv);
 	if (k & 0x20)
 		return (DID_PARITY);
 	if (k & 0x40)
@@ -315,9 +312,11 @@
=20
 static void ql_icmd(Scsi_Cmnd * cmd)
 {
+	qlogicfas_priv_t priv =3D (qlogicfas_priv_t)&(cmd->device->host->hostdata=
[0]);
+	int 	qbase =3D priv->qbase;
 	unsigned int i;
=20
-	qabort =3D 0;
+	priv->qabort =3D 0;
=20
 	REG0;
 	/* clearing of interrupts and the fifo is needed */
@@ -338,7 +337,7 @@
 	/* configurables */
 	outb(qlcfgc, qbase + 0xc);
 	/* config: no reset interrupt, (initiator) bus id */
-	outb(0x40 | qlcfg8 | qinitid, qbase + 8);
+	outb(0x40 | qlcfg8 | priv->qinitid, qbase + 8);
 	outb(qlcfg7, qbase + 7);
 	outb(qlcfg6, qbase + 6);
 	 /**/ outb(qlcfg5, qbase + 5);	/* select timer */
@@ -349,7 +348,7 @@
 	for (i =3D 0; i < cmd->cmd_len; i++)
 		outb(cmd->cmnd[i], qbase + 2);
=20
-	qlcmd =3D cmd;
+	priv->qlcmd =3D cmd;
 	outb(0x41, qbase + 3);	/* select and send command */
 }
=20
@@ -369,6 +368,8 @@
 	struct scatterlist *sglist;	/* scatter-gather list pointer */
 	unsigned int sgcount;	/* sg counter */
 	char *buf;
+	qlogicfas_priv_t priv =3D (qlogicfas_priv_t)&(cmd->device->host->hostdata=
[0]);
+	int qbase =3D priv->qbase;
=20
 	rtrc(1)
 	j =3D inb(qbase + 6);
@@ -379,7 +380,7 @@
 	i |=3D inb(qbase + 5);	/* the 0x10 bit can be set after the 0x08 */
 	if (i !=3D 0x18) {
 		printk(KERN_ERR "Ql:Bad Interrupt status:%02x\n", i);
-		ql_zap();
+		ql_zap(priv);
 		return (DID_BAD_INTR << 16);
 	}
 	j &=3D 7;			/* j =3D inb( qbase + 7 ) >> 5; */
@@ -392,7 +393,7 @@
 	if (j !=3D 3 && j !=3D 4) {
 		printk(KERN_ERR "Ql:Bad sequence for command %d, int %02X, cmdleft =3D %=
d\n",
 		     j, i, inb(qbase + 7) & 0x1f);
-		ql_zap();
+		ql_zap(priv);
 		return (DID_ERROR << 16);
 	}
 	result =3D DID_OK;
@@ -410,18 +411,19 @@
 		/* PIO pseudo DMA to buffer or sglist */
 		REG1;
 		if (!cmd->use_sg)
-			ql_pdma(phase, cmd->request_buffer,
+			ql_pdma(priv, phase, cmd->request_buffer,
 				cmd->request_bufflen);
 		else {
 			sgcount =3D cmd->use_sg;
 			sglist =3D cmd->request_buffer;
 			while (sgcount--) {
-				if (qabort) {
+				if (priv->qabort) {
 					REG0;
-					return ((qabort =3D=3D 1 ? DID_ABORT : DID_RESET) << 16);
+					return ((priv->qabort =3D=3D 1 ?
+						DID_ABORT : DID_RESET) << 16);
 				}
 				buf =3D page_address(sglist->page) + sglist->offset;
-				if (ql_pdma(phase, buf, sglist->length))
+				if (ql_pdma(priv, phase, buf, sglist->length))
 					break;
 				sglist++;
 			}
@@ -432,7 +434,7 @@
 		 *	Wait for irq (split into second state of irq handler
 		 *	if this can take time)=20
 		 */
-		if ((k =3D ql_wai()))
+		if ((k =3D ql_wai(priv)))
 			return (k << 16);
 		k =3D inb(qbase + 5);	/* should be 0x10, bus service */
 	}
@@ -443,11 +445,12 @@
 	=20
 	k =3D jiffies + WATCHDOG;
=20
-	while (time_before(jiffies, k) && !qabort && !(inb(qbase + 4) & 6))
+	while (time_before(jiffies, k) && !priv->qabort &&
+						!(inb(qbase + 4) & 6))
 		cpu_relax();	/* wait for status phase */
=20
 	if (time_after_eq(jiffies, k)) {
-		ql_zap();
+		ql_zap(priv);
 		return (DID_TIME_OUT << 16);
 	}
=20
@@ -455,11 +458,11 @@
 	while (inb(qbase + 5))
 		cpu_relax();	/* clear pending ints */
=20
-	if (qabort)
-		return ((qabort =3D=3D 1 ? DID_ABORT : DID_RESET) << 16);
+	if (priv->qabort)
+		return ((priv->qabort =3D=3D 1 ? DID_ABORT : DID_RESET) << 16);
=20
 	outb(0x11, qbase + 3);	/* get status and message */
-	if ((k =3D ql_wai()))
+	if ((k =3D ql_wai(priv)))
 		return (k << 16);
 	i =3D inb(qbase + 5);	/* get chip irq stat */
 	j =3D inb(qbase + 7) & 0x1f;	/* and bytes rec'd */
@@ -476,7 +479,7 @@
 	}
 	outb(0x12, qbase + 3);	/* done, disconnect */
 	rtrc(1)
-	if ((k =3D ql_wai()))
+	if ((k =3D ql_wai(priv)))
 		return (k << 16);
=20
 	/*
@@ -484,15 +487,15 @@
 	 */
 	=20
 	i =3D inb(qbase + 5);	/* should be bus service */
-	while (!qabort && ((i & 0x20) !=3D 0x20)) {
+	while (!priv->qabort && ((i & 0x20) !=3D 0x20)) {
 		barrier();
 		cpu_relax();
 		i |=3D inb(qbase + 5);
 	}
 	rtrc(0)
=20
-	if (qabort)
-		return ((qabort =3D=3D 1 ? DID_ABORT : DID_RESET) << 16);
+	if (priv->qabort)
+		return ((priv->qabort =3D=3D 1 ? DID_ABORT : DID_RESET) << 16);
 	=09
 	return (result << 16) | (message << 8) | (status & STATUS_MASK);
 }
@@ -504,20 +507,23 @@
 static void ql_ihandl(int irq, void *dev_id, struct pt_regs *regs)
 {
 	Scsi_Cmnd *icmd;
+	struct Scsi_Host *host =3D (struct Scsi_Host *)dev_id;
+	qlogicfas_priv_t priv =3D (qlogicfas_priv_t)&(host->hostdata[0]);
+	int qbase =3D priv->qbase;
 	REG0;
=20
 	if (!(inb(qbase + 4) & 0x80))	/* false alarm? */
 		return;
=20
-	if (qlcmd =3D=3D NULL) {	/* no command to process? */
+	if (priv->qlcmd =3D=3D NULL) {	/* no command to process? */
 		int i;
 		i =3D 16;
 		while (i-- && inb(qbase + 5));	/* maybe also ql_zap() */
 		return;
 	}
-	icmd =3D qlcmd;
+	icmd =3D priv->qlcmd;
 	icmd->result =3D ql_pcmd(icmd);
-	qlcmd =3D NULL;
+	priv->qlcmd =3D NULL;
 	/*
 	 *	If result is CHECK CONDITION done calls qcommand to request=20
 	 *	sense=20
@@ -542,7 +548,8 @@
=20
 int qlogicfas_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 {
-	if (cmd->device->id =3D=3D qinitid) {
+	qlogicfas_priv_t priv =3D (qlogicfas_priv_t)&(cmd->device->host->hostdata=
[0]);
+	if (cmd->device->id =3D=3D priv->qinitid) {
 		cmd->result =3D DID_BAD_TARGET << 16;
 		done(cmd);
 		return 0;
@@ -550,7 +557,7 @@
=20
 	cmd->scsi_done =3D done;
 	/* wait for the last command's interrupt to finish */
-	while (qlcmd !=3D NULL) {
+	while (priv->qlcmd !=3D NULL) {
 		barrier();
 		cpu_relax();
 	}
@@ -558,30 +565,18 @@
 	return 0;
 }
=20
-#ifdef PCMCIA
-
-/*
- *	Allow PCMCIA code to preset the port
- *	port should be 0 and irq to -1 respectively for autoprobing=20
- */
-
-void qlogicfas_preset(int port, int irq)
-{
-	qbase =3D port;
-	qlirq =3D irq;
-}
-
-#endif
-
 /*
  *	Look for qlogic card and init if found=20
  */
 =20
-struct Scsi_Host *__qlogicfas_detect(Scsi_Host_Template *host)
+struct Scsi_Host *__qlogicfas_detect(Scsi_Host_Template *host, int qbase,
+								int qlirq)
 {
 	int i, j;		/* these are only used by IRQ detect */
 	int qltyp;		/* type of chip */
+	int qinitid;
 	struct Scsi_Host *hreg;	/* registered host structure */
+	qlogicfas_priv_t priv;
=20
 	/*	Qlogic Cards only exist at 0x230 or 0x330 (the chip itself
 	 *	decodes the address - I check 230 first since MIDI cards are
@@ -652,16 +647,20 @@
 	} else
 		printk(KERN_INFO "Ql: Using preset IRQ %d\n", qlirq);
=20
-	hreg =3D scsi_host_alloc(host, 0);	/* no host data */
+	hreg =3D scsi_host_alloc(host, sizeof(struct qlogicfas_priv));
 	if (!hreg)
 		goto err_release_mem;
+	priv =3D (qlogicfas_priv_t)&(hreg->hostdata[0]);
 	hreg->io_port =3D qbase;
 	hreg->n_io_port =3D 16;
 	hreg->dma_channel =3D -1;
 	if (qlirq !=3D -1)
 		hreg->irq =3D qlirq;
+	priv->qbase =3D qbase;
+	priv->qlirq =3D qlirq;
+	priv->qinitid =3D qinitid;
=20
-	sprintf(qinfo,
+	sprintf(priv->qinfo,
 		"Qlogicfas Driver version 0.46, chip %02X at %03X, IRQ %d, TPdma:%d",
 		qltyp, qbase, qlirq, QL_TURBO_PDMA);
 	host->name =3D qlogicfas_name;
@@ -687,13 +686,35 @@
 	return NULL;
 }
=20
+#define MAX_QLOGICFAS	8
+static int iobase[MAX_QLOGICFAS];
+static int irq[MAX_QLOGICFAS] =3D { [0 ... MAX_QLOGICFAS-1] =3D -1 };
+MODULE_PARM(iobase, "1-" __MODULE_STRING(MAX_QLOGICFAS) "i");
+MODULE_PARM(irq, "1-" __MODULE_STRING(MAX_QLOGICFAS) "i");
+MODULE_PARM_DESC(iobase, "I/O address");
+MODULE_PARM_DESC(irq, "IRQ");
+
 int __devinit qlogicfas_detect(Scsi_Host_Template *sht)
 {
-	return (__qlogicfas_detect(sht) !=3D NULL);
+	int	i,
+		num =3D 0;
+
+	for (i =3D 0; i < MAX_QLOGICFAS; i++) {
+		if (__qlogicfas_detect(sht, iobase[num], irq[num]) =3D=3D NULL) {
+			/* no more devices */
+			break;
+		}
+		num++;
+	}
+
+	return num;
 }
=20
 static int qlogicfas_release(struct Scsi_Host *shost)
 {
+	qlogicfas_priv_t priv =3D (qlogicfas_priv_t)&(shost->hostdata[0]);
+	int qbase =3D priv->qbase;
+
 	if (shost->irq) {
 		REG1;
 		outb(0, qbase + 0xb);	/* disable ints */
@@ -740,8 +761,9 @@
 =20
 static int qlogicfas_abort(Scsi_Cmnd * cmd)
 {
-	qabort =3D 1;
-	ql_zap();
+	qlogicfas_priv_t priv =3D (qlogicfas_priv_t)&(cmd->device->host->hostdata=
[0]);
+	priv->qabort =3D 1;
+	ql_zap(priv);
 	return SUCCESS;
 }
=20
@@ -753,8 +775,9 @@
=20
 int qlogicfas_bus_reset(Scsi_Cmnd * cmd)
 {
-	qabort =3D 2;
-	ql_zap();
+	qlogicfas_priv_t priv =3D (qlogicfas_priv_t)&(cmd->device->host->hostdata=
[0]);
+	priv->qabort =3D 2;
+	ql_zap(priv);
 	return SUCCESS;
 }
=20
@@ -782,7 +805,8 @@
=20
 static const char *qlogicfas_info(struct Scsi_Host *host)
 {
-	return qinfo;
+	qlogicfas_priv_t priv =3D (qlogicfas_priv_t)&(host->hostdata[0]);
+	return priv->qinfo;
 }
=20
 MODULE_AUTHOR("Tom Zerucha, Michael Griffith");
diff -urN linux-2.6.3-applied/drivers/scsi/qlogicfas.h linux-2.6.3-work/dri=
vers/scsi/qlogicfas.h
--- linux-2.6.3-applied/drivers/scsi/qlogicfas.h	1969-12-31 21:00:00.000000=
000 -0300
+++ linux-2.6.3-work/drivers/scsi/qlogicfas.h	2004-03-05 18:51:02.000000000=
 -0300
@@ -0,0 +1,14 @@
+/* to be used by qlogicfas and qlogic_cs */
+#ifndef __QLOGICFAS_H
+#define __QLOGICFAS_H
+struct qlogicfas_priv {
+	 int		qbase;		/* Port */
+	 int		qinitid;	/* initiator ID */
+	 int		qabort;		/* Flag to cause an abort */
+	 int		qlirq;		/* IRQ being used */
+	 char		qinfo[80];	/* description */
+	 Scsi_Cmnd 	*qlcmd;		/* current command being processed */
+};
+typedef struct qlogicfas_priv *qlogicfas_priv_t;
+#endif	/* __QLOGICFAS_H */
+

--CpBQqYjq/d0HQTAP--

--8D1TCnBmjJJF2KCx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATcmGRRJOudsVYbMRAtBdAJ4lN0JT4nkLnxRBpijq8PEvFA8VQwCgvyUP
4XIehNuoffDjz6tTIerlbPg=
=IVTu
-----END PGP SIGNATURE-----

--8D1TCnBmjJJF2KCx--
