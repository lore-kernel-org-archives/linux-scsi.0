From: Frank Lichtenheld <frank@lichtenheld.de>
Subject: [PATCH alternative] [SCSI] aic7xxx: Fix warnings with CONFIG_PM=n
Date: Fri,  9 Nov 2007 08:55:44 +0100
Message-ID: <1194594944-14277-1-git-send-email-frank@lichtenheld.de>
References: <4733A715.70008@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from v32413.1blu.de ([88.84.155.73]:37340 "EHLO mail.lenk.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbXKIHzr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2007 02:55:47 -0500
In-Reply-To: <4733A715.70008@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>, Frank Lichtenheld <frank@lichtenheld.de>

=46ixes the following warnings:
  CC [M]  drivers/scsi/aic7xxx/aic79xx_osm_pci.o
drivers/scsi/aic7xxx/aic79xx_osm_pci.c:101: warning: =E2=80=98ahd_linux=
_pci_dev_suspend=E2=80=99 defined but not used
drivers/scsi/aic7xxx/aic79xx_osm_pci.c:121: warning: =E2=80=98ahd_linux=
_pci_dev_resume=E2=80=99 defined but not used

  CC [M]  drivers/scsi/aic7xxx/aic7xxx_osm_pci.o
drivers/scsi/aic7xxx/aic7xxx_osm_pci.c:148: warning: =E2=80=98ahc_linux=
_pci_dev_suspend=E2=80=99 defined but not used
drivers/scsi/aic7xxx/aic7xxx_osm_pci.c:166: warning: =E2=80=98ahc_linux=
_pci_dev_resume=E2=80=99 defined but not used

Reorder code as suggested by Randy Dunlap to minimize
needed #ifdefs

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
---
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |   25 +++++++++++++-----------=
-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |   25 +++++++++++++-----------=
-
 2 files changed, 26 insertions(+), 24 deletions(-)

 > But "ideally" the functions would be defined before the             =
    =20
 > struct pci_driver data, so the prototypes for them could be removed.

 Hmm, I'm a bit sceptical about the reordering, but here you go.
 Choose whatever you like.

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7=
xxx/aic79xx_osm_pci.c
index 66f0259..f6dbd3e 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -50,8 +50,6 @@ static int	ahd_linux_pci_reserve_io_regions(struct ah=
d_softc *ahd,
 static int	ahd_linux_pci_reserve_mem_region(struct ahd_softc *ahd,
 						 u_long *bus_addr,
 						 uint8_t __iomem **maddr);
-static int	ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_=
t mesg);
-static int	ahd_linux_pci_dev_resume(struct pci_dev *pdev);
 static void	ahd_linux_pci_dev_remove(struct pci_dev *pdev);
=20
 /* Define the macro locally since it's different for different class o=
f chips.
@@ -85,17 +83,7 @@ static struct pci_device_id ahd_linux_pci_id_table[]=
 =3D {
=20
 MODULE_DEVICE_TABLE(pci, ahd_linux_pci_id_table);
=20
-static struct pci_driver aic79xx_pci_driver =3D {
-	.name		=3D "aic79xx",
-	.probe		=3D ahd_linux_pci_dev_probe,
 #ifdef CONFIG_PM
-	.suspend	=3D ahd_linux_pci_dev_suspend,
-	.resume		=3D ahd_linux_pci_dev_resume,
-#endif
-	.remove		=3D ahd_linux_pci_dev_remove,
-	.id_table	=3D ahd_linux_pci_id_table
-};
-
 static int
 ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
@@ -139,6 +127,19 @@ ahd_linux_pci_dev_resume(struct pci_dev *pdev)
=20
 	return rc;
 }
+#else
+#define ahd_linux_pci_dev_suspend     NULL                            =
                                                                       =
             =20
+#define ahd_linux_pci_dev_resume      NULL=20
+#endif
+
+static struct pci_driver aic79xx_pci_driver =3D {
+	.name		=3D "aic79xx",
+	.probe		=3D ahd_linux_pci_dev_probe,
+	.suspend	=3D ahd_linux_pci_dev_suspend,
+	.resume		=3D ahd_linux_pci_dev_resume,
+	.remove		=3D ahd_linux_pci_dev_remove,
+	.id_table	=3D ahd_linux_pci_id_table
+};
=20
 static void
 ahd_linux_pci_dev_remove(struct pci_dev *pdev)
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7=
xxx/aic7xxx_osm_pci.c
index 4488946..ab53189 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -49,8 +49,6 @@ static int	ahc_linux_pci_reserve_io_region(struct ahc=
_softc *ahc,
 static int	ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
 						 u_long *bus_addr,
 						 uint8_t __iomem **maddr);
-static int	ahc_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_=
t mesg);
-static int	ahc_linux_pci_dev_resume(struct pci_dev *pdev);
 static void	ahc_linux_pci_dev_remove(struct pci_dev *pdev);
=20
 /* Define the macro locally since it's different for different class o=
f chips.
@@ -132,17 +130,7 @@ static struct pci_device_id ahc_linux_pci_id_table=
[] =3D {
=20
 MODULE_DEVICE_TABLE(pci, ahc_linux_pci_id_table);
=20
-static struct pci_driver aic7xxx_pci_driver =3D {
-	.name		=3D "aic7xxx",
-	.probe		=3D ahc_linux_pci_dev_probe,
 #ifdef CONFIG_PM
-	.suspend	=3D ahc_linux_pci_dev_suspend,
-	.resume		=3D ahc_linux_pci_dev_resume,
-#endif
-	.remove		=3D ahc_linux_pci_dev_remove,
-	.id_table	=3D ahc_linux_pci_id_table
-};
-
 static int
 ahc_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
@@ -182,6 +170,19 @@ ahc_linux_pci_dev_resume(struct pci_dev *pdev)
=20
 	return (ahc_resume(ahc));
 }
+#else
+#define ahc_linux_pci_dev_suspend     NULL                            =
                                                                       =
            =20
+#define ahc_linux_pci_dev_resume      NULL
+#endif
+
+static struct pci_driver aic7xxx_pci_driver =3D {
+	.name		=3D "aic7xxx",
+	.probe		=3D ahc_linux_pci_dev_probe,
+	.suspend	=3D ahc_linux_pci_dev_suspend,
+	.resume		=3D ahc_linux_pci_dev_resume,
+	.remove		=3D ahc_linux_pci_dev_remove,
+	.id_table	=3D ahc_linux_pci_id_table
+};
=20
 static void
 ahc_linux_pci_dev_remove(struct pci_dev *pdev)
--=20
1.5.3.4

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
