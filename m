From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Fix for EISA only aic7xxx compile
Date: 28 Aug 2003 12:40:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1062088833.1999.31.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-/TyN6+CjuaOXtwhpkofN"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:22278 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264080AbTH1Qkl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2003 12:40:41 -0400
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-/TyN6+CjuaOXtwhpkofN
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

If I build an EISA (no PCI) kernel for my intel express, I get undefined
references to ahc_linux_pci_exit().

The attached patch fixes this (seemed simpler than trying to work out
how to move the function calls).

Other than that, EISA only seems to work fine for me.

James


--=-/TyN6+CjuaOXtwhpkofN
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D drivers/scsi/aic7xxx/aic7xxx_osm.h 1.50 vs edited =3D=3D=3D=
=3D=3D
--- 1.50/drivers/scsi/aic7xxx/aic7xxx_osm.h	Fri May  2 15:26:21 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.h	Thu Aug 28 12:05:26 2003
@@ -852,10 +852,16 @@
 int			 aic7770_map_int(struct ahc_softc *ahc, u_int irq);
=20
 /******************************* PCI Routines ****************************=
*****/
+#ifdef CONFIG_PCI
 int			 ahc_linux_pci_init(void);
 void			 ahc_linux_pci_exit(void);
 int			 ahc_pci_map_registers(struct ahc_softc *ahc);
 int			 ahc_pci_map_int(struct ahc_softc *ahc);
+#else
+static inline void ahc_linux_pci_exit(void)
+{
+}
+#endif
=20
 static __inline uint32_t ahc_pci_read_config(ahc_dev_softc_t pci,
 					     int reg, int width);

--=-/TyN6+CjuaOXtwhpkofN--

