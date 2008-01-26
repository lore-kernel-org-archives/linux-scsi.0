From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] aic7xxx: fix warnings with CONFIG_PM disabled
Date: Sun, 27 Jan 2008 00:08:19 +0900
Message-ID: <20080127000742C.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:42599 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbYAZPIf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jan 2008 10:08:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

  CC [M]  drivers/scsi/aic7xxx/aic7xxx_osm_pci.o
drivers/scsi/aic7xxx/aic7xxx_osm_pci.c:148: warning: 'ahc_linux_pci_dev_suspend' defined but not used
drivers/scsi/aic7xxx/aic7xxx_osm_pci.c:166: warning: 'ahc_linux_pci_dev_resume' defined but not used

This moves aic7xxx_pci_driver struct, removes some forward declarations,
and adds some ifdef CONFIG_PM.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/aic7xxx/aic7xxx.h         |    4 +++
 drivers/scsi/aic7xxx/aic7xxx_core.c    |    3 +-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |   33 +++++++++++--------------------
 drivers/scsi/aic7xxx/aic7xxx_pci.c     |    2 +
 4 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index 3d4e42d..c0344e6 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -1143,7 +1143,9 @@ struct ahc_pci_identity	*ahc_find_pci_device(ahc_dev_softc_t);
 int			 ahc_pci_config(struct ahc_softc *,
 					struct ahc_pci_identity *);
 int			 ahc_pci_test_register_access(struct ahc_softc *);
+#ifdef CONFIG_PM
 void			 ahc_pci_resume(struct ahc_softc *ahc);
+#endif
 
 /*************************** EISA/VL Front End ********************************/
 struct aic7770_identity *aic7770_find_device(uint32_t);
@@ -1170,8 +1172,10 @@ int			 ahc_chip_init(struct ahc_softc *ahc);
 int			 ahc_init(struct ahc_softc *ahc);
 void			 ahc_intr_enable(struct ahc_softc *ahc, int enable);
 void			 ahc_pause_and_flushwork(struct ahc_softc *ahc);
+#ifdef CONFIG_PM
 int			 ahc_suspend(struct ahc_softc *ahc); 
 int			 ahc_resume(struct ahc_softc *ahc);
+#endif
 void			 ahc_set_unit(struct ahc_softc *, int);
 void			 ahc_set_name(struct ahc_softc *, char *);
 void			 ahc_alloc_scbs(struct ahc_softc *ahc);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index f350b5e..6d2ae64 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -5078,6 +5078,7 @@ ahc_pause_and_flushwork(struct ahc_softc *ahc)
 	ahc->flags &= ~AHC_ALL_INTERRUPTS;
 }
 
+#ifdef CONFIG_PM
 int
 ahc_suspend(struct ahc_softc *ahc)
 {
@@ -5113,7 +5114,7 @@ ahc_resume(struct ahc_softc *ahc)
 	ahc_restart(ahc);
 	return (0);
 }
-
+#endif
 /************************** Busy Target Table *********************************/
 /*
  * Return the untagged transaction id for a given target/channel lun.
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
index 4488946..dd6e21d 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -42,17 +42,6 @@
 #include "aic7xxx_osm.h"
 #include "aic7xxx_pci.h"
 
-static int	ahc_linux_pci_dev_probe(struct pci_dev *pdev,
-					const struct pci_device_id *ent);
-static int	ahc_linux_pci_reserve_io_region(struct ahc_softc *ahc,
-						u_long *base);
-static int	ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
-						 u_long *bus_addr,
-						 uint8_t __iomem **maddr);
-static int	ahc_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg);
-static int	ahc_linux_pci_dev_resume(struct pci_dev *pdev);
-static void	ahc_linux_pci_dev_remove(struct pci_dev *pdev);
-
 /* Define the macro locally since it's different for different class of chips.
 */
 #define ID(x)	ID_C(x, PCI_CLASS_STORAGE_SCSI)
@@ -132,17 +121,7 @@ static struct pci_device_id ahc_linux_pci_id_table[] = {
 
 MODULE_DEVICE_TABLE(pci, ahc_linux_pci_id_table);
 
-static struct pci_driver aic7xxx_pci_driver = {
-	.name		= "aic7xxx",
-	.probe		= ahc_linux_pci_dev_probe,
 #ifdef CONFIG_PM
-	.suspend	= ahc_linux_pci_dev_suspend,
-	.resume		= ahc_linux_pci_dev_resume,
-#endif
-	.remove		= ahc_linux_pci_dev_remove,
-	.id_table	= ahc_linux_pci_id_table
-};
-
 static int
 ahc_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
@@ -182,6 +161,7 @@ ahc_linux_pci_dev_resume(struct pci_dev *pdev)
 
 	return (ahc_resume(ahc));
 }
+#endif
 
 static void
 ahc_linux_pci_dev_remove(struct pci_dev *pdev)
@@ -289,6 +269,17 @@ ahc_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return (0);
 }
 
+static struct pci_driver aic7xxx_pci_driver = {
+	.name		= "aic7xxx",
+	.probe		= ahc_linux_pci_dev_probe,
+#ifdef CONFIG_PM
+	.suspend	= ahc_linux_pci_dev_suspend,
+	.resume		= ahc_linux_pci_dev_resume,
+#endif
+	.remove		= ahc_linux_pci_dev_remove,
+	.id_table	= ahc_linux_pci_id_table
+};
+
 int
 ahc_linux_pci_init(void)
 {
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
index ae35937..56848f4 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -2020,6 +2020,7 @@ ahc_pci_chip_init(struct ahc_softc *ahc)
 	return (ahc_chip_init(ahc));
 }
 
+#ifdef CONFIG_PM
 void
 ahc_pci_resume(struct ahc_softc *ahc)
 {
@@ -2051,6 +2052,7 @@ ahc_pci_resume(struct ahc_softc *ahc)
 		ahc_release_seeprom(&sd);
 	}
 }
+#endif
 
 static int
 ahc_aic785X_setup(struct ahc_softc *ahc)
-- 
1.5.3.4

