From: Frank Lichtenheld <frank@lichtenheld.de>
Subject: [PATCH] [SCSI] aic7xxx: Fix warnings with CONFIG_PM=n
Date: Fri,  9 Nov 2007 00:03:48 +0100
Message-ID: <1194563028-19364-1-git-send-email-frank@lichtenheld.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from v32413.1blu.de ([88.84.155.73]:33081 "EHLO mail.lenk.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762630AbXKHXd7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Nov 2007 18:33:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, trivial@kernel.org, Frank Lichtenheld <frank@lichtenheld.de>

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

Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
---
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |    4 ++++
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7=
xxx/aic79xx_osm_pci.c
index 66f0259..36d7618 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -50,8 +50,10 @@ static int	ahd_linux_pci_reserve_io_regions(struct a=
hd_softc *ahd,
 static int	ahd_linux_pci_reserve_mem_region(struct ahd_softc *ahd,
 						 u_long *bus_addr,
 						 uint8_t __iomem **maddr);
+#ifdef CONFIG_PM
 static int	ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_=
t mesg);
 static int	ahd_linux_pci_dev_resume(struct pci_dev *pdev);
+#endif
 static void	ahd_linux_pci_dev_remove(struct pci_dev *pdev);
=20
 /* Define the macro locally since it's different for different class o=
f chips.
@@ -96,6 +98,7 @@ static struct pci_driver aic79xx_pci_driver =3D {
 	.id_table	=3D ahd_linux_pci_id_table
 };
=20
+#ifdef CONFIG_PM
 static int
 ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
@@ -139,6 +142,7 @@ ahd_linux_pci_dev_resume(struct pci_dev *pdev)
=20
 	return rc;
 }
+#endif
=20
 static void
 ahd_linux_pci_dev_remove(struct pci_dev *pdev)
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7=
xxx/aic7xxx_osm_pci.c
index 4488946..212c2c8 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -49,8 +49,10 @@ static int	ahc_linux_pci_reserve_io_region(struct ah=
c_softc *ahc,
 static int	ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
 						 u_long *bus_addr,
 						 uint8_t __iomem **maddr);
+#ifdef CONFIG_PM
 static int	ahc_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_=
t mesg);
 static int	ahc_linux_pci_dev_resume(struct pci_dev *pdev);
+#endif
 static void	ahc_linux_pci_dev_remove(struct pci_dev *pdev);
=20
 /* Define the macro locally since it's different for different class o=
f chips.
@@ -143,6 +145,7 @@ static struct pci_driver aic7xxx_pci_driver =3D {
 	.id_table	=3D ahc_linux_pci_id_table
 };
=20
+#ifdef CONFIG_PM
 static int
 ahc_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
@@ -182,6 +185,7 @@ ahc_linux_pci_dev_resume(struct pci_dev *pdev)
=20
 	return (ahc_resume(ahc));
 }
+#endif
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
