From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][13/15] qlogic_cs: use own detect and release functions
Date: Tue, 9 Mar 2004 10:42:54 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309134254.GO651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wNT7VBaN1rUIB9jO"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:33225 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S261727AbUCINtL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 08:49:11 -0500
Received: from panda.sul.com.br (panda.sul.com.br [200.219.150.4])
	by zeus.kernel.org (8.11.6/8.11.6) with ESMTP id i29Dn5m23770
	for <linux-scsi@vger.kernel.org>; Tue, 9 Mar 2004 05:49:06 -0800
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id C54CB32822
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:48:45 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id AC50D236C6
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:34:38 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hVW-0000x2-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:42:54 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--wNT7VBaN1rUIB9jO
Content-Type: multipart/mixed; boundary="LQFJYnjHKDAbJRTQ"
Content-Disposition: inline


--LQFJYnjHKDAbJRTQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



--=20
aris


--LQFJYnjHKDAbJRTQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="13-qlogic_cs-use_own_detect_and_release_functions.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux-2.6.3-applied/drivers/scsi/pcmcia/qlogic_stub.c linux-2.6.3-=
work/drivers/scsi/pcmcia/qlogic_stub.c
--- linux-2.6.3-applied/drivers/scsi/pcmcia/qlogic_stub.c	2004-03-05 18:48:=
17.000000000 -0300
+++ linux-2.6.3-work/drivers/scsi/pcmcia/qlogic_stub.c	2004-03-08 13:33:51.=
000000000 -0300
@@ -43,9 +43,11 @@
 #include <linux/major.h>
 #include <linux/blkdev.h>
 #include <scsi/scsi_ioctl.h>
+#include <linux/interrupt.h>
=20
 #include "scsi.h"
 #include "hosts.h"
+#include "../qlogicfas.h"
=20
 #include <pcmcia/version.h>
 #include <pcmcia/cs_types.h>
@@ -57,8 +59,8 @@
=20
 extern Scsi_Host_Template qlogicfas_driver_template;
 extern void qlogicfas_preset(int port, int irq);
-extern struct Scsi_Host *__qlogicfas_detect(Scsi_Host_Template *);
 extern int qlogicfas_bus_reset(Scsi_Cmnd *);
+extern irqreturn_t do_ql_ihandl(int irq, void *dev_id, struct pt_regs *reg=
s);
=20
 static char *qlogic_name =3D "qlogic_cs";
=20
@@ -102,6 +104,71 @@
=20
 static dev_info_t dev_info =3D "qlogic_cs";
=20
+static struct Scsi_Host *qlogic_detect(Scsi_Host_Template *host,
+				dev_link_t *link, int qbase, int qlirq)
+{
+	int qltyp;		/* type of chip */
+	int qinitid;
+	struct Scsi_Host *shost;	/* registered host structure */
+	qlogicfas_priv_t priv;
+
+	qltyp =3D inb(qbase + 0xe) & 0xf8;
+	qinitid =3D host->this_id;
+	if (qinitid < 0)
+		qinitid =3D 7;	/* if no ID, use 7 */
+	outb(1, qbase + 8);	/* set for PIO pseudo DMA */
+	REG0;
+	outb(0x40 | qlcfg8 | qinitid, qbase + 8);	/* (ini) bus id, disable scsi r=
st */
+	outb(qlcfg5, qbase + 5);	/* select timer */
+	outb(qlcfg9, qbase + 9);	/* prescaler */
+
+#if QL_RESET_AT_START
+	outb(3, qbase + 3);
+	REG1;
+	/* FIXME: timeout */
+	while (inb(qbase + 0xf) & 4)
+		cpu_relax();
+	REG0;
+#endif
+
+	host->name =3D qlogic_name;
+	shost =3D scsi_host_alloc(host, sizeof(struct qlogicfas_priv));
+	if (!shost)
+		goto err;
+	shost->io_port =3D qbase;
+	shost->n_io_port =3D 16;
+	shost->dma_channel =3D -1;
+	if (qlirq !=3D -1)
+		shost->irq =3D qlirq;
+
+	priv =3D (qlogicfas_priv_t)&(shost->hostdata[0]);
+	priv->qlirq =3D qlirq;
+	priv->qbase =3D qbase;
+	priv->qinitid =3D qinitid;
+
+	if (request_irq(qlirq, do_ql_ihandl, 0, qlogic_name, shost))
+		goto free_scsi_host;
+
+	sprintf(priv->qinfo,
+		"Qlogicfas Driver version 0.46, chip %02X at %03X, IRQ %d, TPdma:%d",
+		qltyp, qbase, qlirq, QL_TURBO_PDMA);
+
+	if (scsi_add_host(shost, NULL))
+		goto free_interrupt;
+
+	scsi_scan_host(shost);
+
+	return shost;
+
+free_interrupt:
+	free_irq(qlirq, shost);
+
+free_scsi_host:
+	scsi_host_put(shost);
+=09
+err:
+	return NULL;
+}
 static dev_link_t *qlogic_attach(void)
 {
 	scsi_info_t *info;
@@ -240,15 +307,17 @@
 		outb(0x04, link->io.BasePort1 + 0xd);
 	}
=20
+	qlogicfas_driver_template.name =3D qlogic_name;
+	qlogicfas_driver_template.proc_name =3D qlogic_name;
+
 	/* The KXL-810AN has a bigger IO port window */
 	if (link->io.NumPorts1 =3D=3D 32)
-		qlogicfas_preset(link->io.BasePort1 + 16, link->irq.AssignedIRQ);
+		host =3D qlogic_detect(&qlogicfas_driver_template, link,
+			link->io.BasePort1 + 16, link->irq.AssignedIRQ);
 	else
-		qlogicfas_preset(link->io.BasePort1, link->irq.AssignedIRQ);
-
-	qlogicfas_driver_template.name =3D qlogic_name;
-	qlogicfas_driver_template.proc_name =3D qlogic_name;
-	host =3D __qlogicfas_detect(&qlogicfas_driver_template);
+		host =3D qlogic_detect(&qlogicfas_driver_template, link,
+			link->io.BasePort1, link->irq.AssignedIRQ);
+=09
 	if (!host) {
 		printk(KERN_INFO "%s: no SCSI devices found\n", qlogic_name);
 		goto out;
@@ -258,9 +327,6 @@
 	link->dev =3D &info->node;
 	info->host =3D host;
=20
-	scsi_add_host(host, NULL); /* XXX handle failure */
-	scsi_scan_host(host);
-
 out:
 	link->state &=3D ~DEV_CONFIG_PENDING;
 	return;
@@ -287,6 +353,8 @@
 	scsi_remove_host(info->host);
 	link->dev =3D NULL;
=20
+	free_irq(link->irq.AssignedIRQ, info->host);
+
 	pcmcia_release_configuration(link->handle);
 	pcmcia_release_io(link->handle, &link->io);
 	pcmcia_release_irq(link->handle, &link->irq);

--LQFJYnjHKDAbJRTQ--

--wNT7VBaN1rUIB9jO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATcneRRJOudsVYbMRAjClAKCUnQRVpTwIVrk1ZS/5G6pVz+O2aQCgpgJB
E/7g0D8tqA2LyQxStazQEXI=
=Lati
-----END PGP SIGNATURE-----

--wNT7VBaN1rUIB9jO--
