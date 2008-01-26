From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] aic79xx: fix warnings with CONFIG_PM disabled
Date: Sun, 27 Jan 2008 00:08:18 +0900
Message-ID: <20080127000740N.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:37772 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbYAZPIe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jan 2008 10:08:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

  CC [M]  drivers/scsi/aic7xxx/aic79xx_osm_pci.o
drivers/scsi/aic7xxx/aic79xx_osm_pci.c:101: warning: 'ahd_linux_pci_dev_suspend' defined but not used
drivers/scsi/aic7xxx/aic79xx_osm_pci.c:121: warning: 'ahd_linux_pci_dev_resume' defined but not used

This moves aic79xx_pci_driver struct, removes some forward
declarations, and adds some ifdef CONFIG_PM.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/aic7xxx/aic79xx.h         |    5 +++-
 drivers/scsi/aic7xxx/aic79xx_core.c    |    2 +
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |   33 +++++++++++--------------------
 drivers/scsi/aic7xxx/aic79xx_pci.c     |    2 +
 4 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index ce638aa..2f00467 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -1340,8 +1340,10 @@ struct	ahd_pci_identity *ahd_find_pci_device(ahd_dev_softc_t);
 int			  ahd_pci_config(struct ahd_softc *,
 					 struct ahd_pci_identity *);
 int	ahd_pci_test_register_access(struct ahd_softc *);
+#ifdef CONFIG_PM
 void	ahd_pci_suspend(struct ahd_softc *);
 void	ahd_pci_resume(struct ahd_softc *);
+#endif
 
 /************************** SCB and SCB queue management **********************/
 void		ahd_qinfifo_requeue_tail(struct ahd_softc *ahd,
@@ -1352,8 +1354,10 @@ struct ahd_softc	*ahd_alloc(void *platform_arg, char *name);
 int			 ahd_softc_init(struct ahd_softc *);
 void			 ahd_controller_info(struct ahd_softc *ahd, char *buf);
 int			 ahd_init(struct ahd_softc *ahd);
+#ifdef CONFIG_PM
 int			 ahd_suspend(struct ahd_softc *ahd);
 void			 ahd_resume(struct ahd_softc *ahd);
+#endif
 int			 ahd_default_config(struct ahd_softc *ahd);
 int			 ahd_parse_vpddata(struct ahd_softc *ahd,
 					   struct vpd_config *vpd);
@@ -1361,7 +1365,6 @@ int			 ahd_parse_cfgdata(struct ahd_softc *ahd,
 					   struct seeprom_config *sc);
 void			 ahd_intr_enable(struct ahd_softc *ahd, int enable);
 void			 ahd_pause_and_flushwork(struct ahd_softc *ahd);
-int			 ahd_suspend(struct ahd_softc *ahd); 
 void			 ahd_set_unit(struct ahd_softc *, int);
 void			 ahd_set_name(struct ahd_softc *, char *);
 struct scb		*ahd_get_scb(struct ahd_softc *ahd, u_int col_idx);
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index a7dd8cd..ade0fb8 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -7175,6 +7175,7 @@ ahd_pause_and_flushwork(struct ahd_softc *ahd)
 	ahd->flags &= ~AHD_ALL_INTERRUPTS;
 }
 
+#ifdef CONFIG_PM
 int
 ahd_suspend(struct ahd_softc *ahd)
 {
@@ -7197,6 +7198,7 @@ ahd_resume(struct ahd_softc *ahd)
 	ahd_intr_enable(ahd, TRUE); 
 	ahd_restart(ahd);
 }
+#endif
 
 /************************** Busy Target Table *********************************/
 /*
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
index 66f0259..4150c8a 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -43,17 +43,6 @@
 #include "aic79xx_inline.h"
 #include "aic79xx_pci.h"
 
-static int	ahd_linux_pci_dev_probe(struct pci_dev *pdev,
-					const struct pci_device_id *ent);
-static int	ahd_linux_pci_reserve_io_regions(struct ahd_softc *ahd,
-						 u_long *base, u_long *base2);
-static int	ahd_linux_pci_reserve_mem_region(struct ahd_softc *ahd,
-						 u_long *bus_addr,
-						 uint8_t __iomem **maddr);
-static int	ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg);
-static int	ahd_linux_pci_dev_resume(struct pci_dev *pdev);
-static void	ahd_linux_pci_dev_remove(struct pci_dev *pdev);
-
 /* Define the macro locally since it's different for different class of chips.
  */
 #define ID(x)            \
@@ -85,17 +74,7 @@ static struct pci_device_id ahd_linux_pci_id_table[] = {
 
 MODULE_DEVICE_TABLE(pci, ahd_linux_pci_id_table);
 
-static struct pci_driver aic79xx_pci_driver = {
-	.name		= "aic79xx",
-	.probe		= ahd_linux_pci_dev_probe,
 #ifdef CONFIG_PM
-	.suspend	= ahd_linux_pci_dev_suspend,
-	.resume		= ahd_linux_pci_dev_resume,
-#endif
-	.remove		= ahd_linux_pci_dev_remove,
-	.id_table	= ahd_linux_pci_id_table
-};
-
 static int
 ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
@@ -139,6 +118,7 @@ ahd_linux_pci_dev_resume(struct pci_dev *pdev)
 
 	return rc;
 }
+#endif
 
 static void
 ahd_linux_pci_dev_remove(struct pci_dev *pdev)
@@ -245,6 +225,17 @@ ahd_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return (0);
 }
 
+static struct pci_driver aic79xx_pci_driver = {
+	.name		= "aic79xx",
+	.probe		= ahd_linux_pci_dev_probe,
+#ifdef CONFIG_PM
+	.suspend	= ahd_linux_pci_dev_suspend,
+	.resume		= ahd_linux_pci_dev_resume,
+#endif
+	.remove		= ahd_linux_pci_dev_remove,
+	.id_table	= ahd_linux_pci_id_table
+};
+
 int
 ahd_linux_pci_init(void)
 {
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index 7a203a9..df85367 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -389,6 +389,7 @@ ahd_pci_config(struct ahd_softc *ahd, struct ahd_pci_identity *entry)
 	return error;
 }
 
+#ifdef CONFIG_PM
 void
 ahd_pci_suspend(struct ahd_softc *ahd)
 {
@@ -415,6 +416,7 @@ ahd_pci_resume(struct ahd_softc *ahd)
 	ahd_pci_write_config(ahd->dev_softc, CSIZE_LATTIME,
 			     ahd->suspend_state.pci_state.csize_lattime, /*bytes*/1);
 }
+#endif
 
 /*
  * Perform some simple tests that should catch situations where
-- 
1.5.3.4

