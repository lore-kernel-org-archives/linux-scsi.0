From: aris@cathedrallabs.org (Aristeu Sergio Rozanski Filho)
Subject: [patch][1/3] qlogicfas: kill horrible irq probing
Date: Wed, 31 Mar 2004 10:03:28 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040331130328.GA28021@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oLBj+sq0vYjzfsbl"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:4624 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261942AbUCaNFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 08:05:15 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id 9E800328AA
	for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2004 10:05:38 -0300 (EST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,
	this patch kills irq probe and also I/O because isn't useful to
	probe I/O if we can't probe irq later.

--=20
aris


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="01-qlogicfas-remove_io_and_irq_probe.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux-2.6.4-applied/drivers/scsi/qlogicfas.c linux-2.6.4-work/driv=
ers/scsi/qlogicfas.c
--- linux-2.6.4-applied/drivers/scsi/qlogicfas.c	2004-03-13 15:10:48.000000=
000 -0300
+++ linux-2.6.4-work/drivers/scsi/qlogicfas.c	2004-03-18 08:31:52.000000000=
 -0300
@@ -475,7 +475,6 @@
 struct Scsi_Host *__qlogicfas_detect(Scsi_Host_Template *host, int qbase,
 								int qlirq)
 {
-	int i, j;		/* these are only used by IRQ detect */
 	int qltyp;		/* type of chip */
 	int qinitid;
 	struct Scsi_Host *hreg;	/* registered host structure */
@@ -490,20 +489,26 @@
 	 *	the second card, but I haven't tested this.
 	 */
=20
-	if (!qbase) {
-		for (qbase =3D 0x230; qbase < 0x430; qbase +=3D 0x100) {
-			if (!request_region(qbase, 0x10, qlogicfas_name))
-				continue;
-			REG1;
-			if (((inb(qbase + 0xe) ^ inb(qbase + 0xe)) =3D=3D 7)
-			    && ((inb(qbase + 0xe) ^ inb(qbase + 0xe)) =3D=3D 7))
-				break;
-			release_region(qbase, 0x10);
-		}
-		if (qbase =3D=3D 0x430)
-			return NULL;;
-	} else
-		printk(KERN_INFO "Ql: Using preset base address of %03x\n", qbase);
+	if (!qbase || qlirq =3D=3D -1)
+		goto err;
+
+	if (!request_region(qbase, 0x10, qlogicfas_name)) {
+		printk(KERN_INFO "%s: address %#x is busy\n", qlogicfas_name,
+							      qbase);
+		goto err;
+	}
+
+	REG1;
+	if (((inb(qbase + 0xe) ^ inb(qbase + 0xe)) !=3D 7)
+	    || ((inb(qbase + 0xe) ^ inb(qbase + 0xe)) !=3D 7)) {
+		printk(KERN_WARNING "%s: probe failed for %#x\n",
+								qlogicfas_name,
+								qbase);
+		goto err_release_mem;
+	}
+
+	printk(KERN_INFO "%s: Using preset base address of %03x,"
+			 " IRQ %d\n", qlogicfas_name, qbase, qlirq);
=20
 	qltyp =3D inb(qbase + 0xe) & 0xf8;
 	qinitid =3D host->this_id;
@@ -524,32 +529,6 @@
 	REG0;
 #endif
=20
-	/*
-	 *	IRQ probe - toggle pin and check request pending=20
-	 */
-
-	if (qlirq =3D=3D -1) {
-		i =3D 0xffff;
-		j =3D 3;
-		outb(0x90, qbase + 3);	/* illegal command - cause interrupt */
-		REG1;
-		outb(10, 0x20);	/* access pending interrupt map */
-		outb(10, 0xa0);
-		while (j--) {
-			outb(0xb0 | QL_INT_ACTIVE_HIGH, qbase + 0xd);	/* int pin off */
-			i &=3D ~(inb(0x20) | (inb(0xa0) << 8));		/* find IRQ off */
-			outb(0xb4 | QL_INT_ACTIVE_HIGH, qbase + 0xd);	/* int pin on */
-			i &=3D inb(0x20) | (inb(0xa0) << 8);		/* find IRQ on */
-		}
-		REG0;
-		while (inb(qbase + 5));	/* purge int */
-		j =3D -1;
-		while (i)	/* find on bit */
-			i >>=3D 1, j++;	/* should check for exactly 1 on */
-		qlirq =3D j;
-	} else
-		printk(KERN_INFO "Ql: Using preset IRQ %d\n", qlirq);
-
 	hreg =3D scsi_host_alloc(host, sizeof(struct qlogicfas_priv));
 	if (!hreg)
 		goto err_release_mem;
@@ -587,6 +566,7 @@
=20
 err_release_mem:
 	release_region(qbase, 0x10);
+err:
 	return NULL;
 }
=20
@@ -603,10 +583,9 @@
 {
 	struct Scsi_Host	*shost;
 	qlogicfas_priv_t	priv;
-	int	i,
-		num =3D 0;
+	int	num;
=20
-	for (i =3D 0; i < MAX_QLOGICFAS; i++) {
+	for (num =3D 0; num < MAX_QLOGICFAS; num++) {
 		shost =3D __qlogicfas_detect(sht, iobase[num], irq[num]);
 		if (shost =3D=3D NULL) {
 			/* no more devices */
@@ -615,7 +594,6 @@
 		priv =3D (qlogicfas_priv_t)&(shost->hostdata[0]);
 		priv->next =3D cards;
 		cards =3D priv;
-		num++;
 	}
=20
 	return num;
@@ -747,6 +725,9 @@
 {
 	if (!qlogicfas_detect(&qlogicfas_driver_template)) {
 		/* no cards found */
+		printk(KERN_INFO "%s: no cards were found, please specify "
+				 "I/O address and IRQ using iobase=3D and irq=3D "
+				 "options", qlogicfas_name);
 		return -ENODEV;
 	}
=20

--oLBj+sq0vYjzfsbl--
