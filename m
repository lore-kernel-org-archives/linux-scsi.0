From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Add suspend/resume support for aic7xxx/aic79xx
Date: Wed, 17 Oct 2007 16:13:11 +0200
Message-ID: <47161877.1090000@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060905010908090708030104"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522AbXJQONO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 10:13:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060905010908090708030104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi James,

due to popular demand I've clobbered together a patch for
suspend/resume support in aic79xx/aic7xxx.

Looks reasonable enough, boots, but now I'd need someone
to actually test it :-)

As usual, comments, results, fixes, etc. welcome.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------060905010908090708030104
Content-Type: text/plain;
 name="aic7xxx-suspend"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic7xxx-suspend"

aic7xxx: Add suspend/resume support

The existing code already had some fragments for suspend/resume
support, so it's actually quite straigtforward to implement it.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index 27adbb2..f183c43 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -1003,8 +1003,16 @@ struct ahd_suspend_channel_state {
 	uint8_t	seqctl;
 };
 
+struct ahd_suspend_pci_state {
+	uint32_t  devconfig;
+	uint16_t  targcrccnt;
+	uint8_t   command;
+	uint8_t   csize_lattime;
+};
+
 struct ahd_suspend_state {
 	struct	ahd_suspend_channel_state channel[2];
+	struct  ahd_suspend_pci_state pci_state;
 	uint8_t	optionmode;
 	uint8_t	dscommand0;
 	uint8_t	dspcistatus;
@@ -1333,6 +1341,8 @@ struct	ahd_pci_identity *ahd_find_pci_device(ahd_dev_softc_t);
 int			  ahd_pci_config(struct ahd_softc *,
 					 struct ahd_pci_identity *);
 int	ahd_pci_test_register_access(struct ahd_softc *);
+void	ahd_pci_suspend(struct ahd_softc *);
+void	ahd_pci_resume(struct ahd_softc *);
 
 /************************** SCB and SCB queue management **********************/
 void		ahd_qinfifo_requeue_tail(struct ahd_softc *ahd,
@@ -1343,6 +1353,8 @@ struct ahd_softc	*ahd_alloc(void *platform_arg, char *name);
 int			 ahd_softc_init(struct ahd_softc *);
 void			 ahd_controller_info(struct ahd_softc *ahd, char *buf);
 int			 ahd_init(struct ahd_softc *ahd);
+int			 ahd_suspend(struct ahd_softc *ahd);
+void			 ahd_resume(struct ahd_softc *ahd);
 int			 ahd_default_config(struct ahd_softc *ahd);
 int			 ahd_parse_vpddata(struct ahd_softc *ahd,
 					   struct vpd_config *vpd);
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 05f692b..a7dd8cd 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -7175,7 +7175,6 @@ ahd_pause_and_flushwork(struct ahd_softc *ahd)
 	ahd->flags &= ~AHD_ALL_INTERRUPTS;
 }
 
-#if 0
 int
 ahd_suspend(struct ahd_softc *ahd)
 {
@@ -7189,19 +7188,15 @@ ahd_suspend(struct ahd_softc *ahd)
 	ahd_shutdown(ahd);
 	return (0);
 }
-#endif  /*  0  */
 
-#if 0
-int
+void
 ahd_resume(struct ahd_softc *ahd)
 {
 
 	ahd_reset(ahd, /*reinit*/TRUE);
 	ahd_intr_enable(ahd, TRUE); 
 	ahd_restart(ahd);
-	return (0);
 }
-#endif  /*  0  */
 
 /************************** Busy Target Table *********************************/
 /*
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
index c62ce41..66f0259 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -50,6 +50,8 @@ static int	ahd_linux_pci_reserve_io_regions(struct ahd_softc *ahd,
 static int	ahd_linux_pci_reserve_mem_region(struct ahd_softc *ahd,
 						 u_long *bus_addr,
 						 uint8_t __iomem **maddr);
+static int	ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg);
+static int	ahd_linux_pci_dev_resume(struct pci_dev *pdev);
 static void	ahd_linux_pci_dev_remove(struct pci_dev *pdev);
 
 /* Define the macro locally since it's different for different class of chips.
@@ -86,10 +88,58 @@ MODULE_DEVICE_TABLE(pci, ahd_linux_pci_id_table);
 static struct pci_driver aic79xx_pci_driver = {
 	.name		= "aic79xx",
 	.probe		= ahd_linux_pci_dev_probe,
+#ifdef CONFIG_PM
+	.suspend	= ahd_linux_pci_dev_suspend,
+	.resume		= ahd_linux_pci_dev_resume,
+#endif
 	.remove		= ahd_linux_pci_dev_remove,
 	.id_table	= ahd_linux_pci_id_table
 };
 
+static int
+ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
+{
+	struct ahd_softc *ahd = pci_get_drvdata(pdev);
+	int rc;
+
+	if ((rc = ahd_suspend(ahd)))
+		return rc;
+
+	ahd_pci_suspend(ahd);
+
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+
+	if (mesg.event == PM_EVENT_SUSPEND)
+		pci_set_power_state(pdev, PCI_D3hot);
+
+	return rc;
+}
+
+static int
+ahd_linux_pci_dev_resume(struct pci_dev *pdev)
+{
+	struct ahd_softc *ahd = pci_get_drvdata(pdev);
+	int rc;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+
+	if ((rc = pci_enable_device(pdev))) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "failed to enable device after resume (%d)\n", rc);
+		return rc;
+	}
+
+	pci_set_master(pdev);
+
+	ahd_pci_resume(ahd);
+
+	ahd_resume(ahd);
+
+	return rc;
+}
+
 static void
 ahd_linux_pci_dev_remove(struct pci_dev *pdev)
 {
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index 0bada00..7a203a9 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -389,6 +389,33 @@ ahd_pci_config(struct ahd_softc *ahd, struct ahd_pci_identity *entry)
 	return error;
 }
 
+void
+ahd_pci_suspend(struct ahd_softc *ahd)
+{
+	/*
+	 * Save chip register configuration data for chip resets
+	 * that occur during runtime and resume events.
+	 */
+	ahd->suspend_state.pci_state.devconfig =
+	    ahd_pci_read_config(ahd->dev_softc, DEVCONFIG, /*bytes*/4);
+	ahd->suspend_state.pci_state.command =
+	    ahd_pci_read_config(ahd->dev_softc, PCIR_COMMAND, /*bytes*/1);
+	ahd->suspend_state.pci_state.csize_lattime =
+	    ahd_pci_read_config(ahd->dev_softc, CSIZE_LATTIME, /*bytes*/1);
+
+}
+
+void
+ahd_pci_resume(struct ahd_softc *ahd)
+{
+	ahd_pci_write_config(ahd->dev_softc, DEVCONFIG,
+			     ahd->suspend_state.pci_state.devconfig, /*bytes*/4);
+	ahd_pci_write_config(ahd->dev_softc, PCIR_COMMAND,
+			     ahd->suspend_state.pci_state.command, /*bytes*/1);
+	ahd_pci_write_config(ahd->dev_softc, CSIZE_LATTIME,
+			     ahd->suspend_state.pci_state.csize_lattime, /*bytes*/1);
+}
+
 /*
  * Perform some simple tests that should catch situations where
  * our registers are invalidly mapped.
diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index e1bd57b..3d4e42d 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -962,16 +962,6 @@ struct ahc_softc {
 	ahc_bus_chip_init_t	  bus_chip_init;
 
 	/*
-	 * Bus specific suspend routine.
-	 */
-	ahc_bus_suspend_t	  bus_suspend;
-
-	/*
-	 * Bus specific resume routine.
-	 */
-	ahc_bus_resume_t	  bus_resume;
-
-	/*
 	 * Target mode related state kept on a per enabled lun basis.
 	 * Targets that are not enabled will have null entries.
 	 * As an initiator, we keep one target entry for our initiator
@@ -1153,6 +1143,7 @@ struct ahc_pci_identity	*ahc_find_pci_device(ahc_dev_softc_t);
 int			 ahc_pci_config(struct ahc_softc *,
 					struct ahc_pci_identity *);
 int			 ahc_pci_test_register_access(struct ahc_softc *);
+void			 ahc_pci_resume(struct ahc_softc *ahc);
 
 /*************************** EISA/VL Front End ********************************/
 struct aic7770_identity *aic7770_find_device(uint32_t);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
index ea5687d..4488946 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -49,6 +49,8 @@ static int	ahc_linux_pci_reserve_io_region(struct ahc_softc *ahc,
 static int	ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
 						 u_long *bus_addr,
 						 uint8_t __iomem **maddr);
+static int	ahc_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg);
+static int	ahc_linux_pci_dev_resume(struct pci_dev *pdev);
 static void	ahc_linux_pci_dev_remove(struct pci_dev *pdev);
 
 /* Define the macro locally since it's different for different class of chips.
@@ -133,10 +135,54 @@ MODULE_DEVICE_TABLE(pci, ahc_linux_pci_id_table);
 static struct pci_driver aic7xxx_pci_driver = {
 	.name		= "aic7xxx",
 	.probe		= ahc_linux_pci_dev_probe,
+#ifdef CONFIG_PM
+	.suspend	= ahc_linux_pci_dev_suspend,
+	.resume		= ahc_linux_pci_dev_resume,
+#endif
 	.remove		= ahc_linux_pci_dev_remove,
 	.id_table	= ahc_linux_pci_id_table
 };
 
+static int
+ahc_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
+{
+	struct ahc_softc *ahc = pci_get_drvdata(pdev);
+	int rc;
+
+	if ((rc = ahc_suspend(ahc)))
+		return rc;
+
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+
+	if (mesg.event == PM_EVENT_SUSPEND)
+		pci_set_power_state(pdev, PCI_D3hot);
+
+	return rc;
+}
+
+static int
+ahc_linux_pci_dev_resume(struct pci_dev *pdev)
+{
+	struct ahc_softc *ahc = pci_get_drvdata(pdev);
+	int rc;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+
+	if ((rc = pci_enable_device(pdev))) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "failed to enable device after resume (%d)\n", rc);
+		return rc;
+	}
+
+	pci_set_master(pdev);
+
+	ahc_pci_resume(ahc);
+
+	return (ahc_resume(ahc));
+}
+
 static void
 ahc_linux_pci_dev_remove(struct pci_dev *pdev)
 {
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
index 09c8172..ae35937 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -633,8 +633,6 @@ static void    write_brdctl(struct ahc_softc *ahc, uint8_t value);
 static uint8_t read_brdctl(struct ahc_softc *ahc);
 static void ahc_pci_intr(struct ahc_softc *ahc);
 static int  ahc_pci_chip_init(struct ahc_softc *ahc);
-static int  ahc_pci_suspend(struct ahc_softc *ahc);
-static int  ahc_pci_resume(struct ahc_softc *ahc);
 
 static int
 ahc_9005_subdevinfo_valid(uint16_t device, uint16_t vendor,
@@ -791,8 +789,6 @@ ahc_pci_config(struct ahc_softc *ahc, struct ahc_pci_identity *entry)
 
 	ahc->bus_intr = ahc_pci_intr;
 	ahc->bus_chip_init = ahc_pci_chip_init;
-	ahc->bus_suspend = ahc_pci_suspend;
-	ahc->bus_resume = ahc_pci_resume;
 
 	/* Remeber how the card was setup in case there is no SEEPROM */
 	if ((ahc_inb(ahc, HCNTRL) & POWRDN) == 0) {
@@ -2024,18 +2020,9 @@ ahc_pci_chip_init(struct ahc_softc *ahc)
 	return (ahc_chip_init(ahc));
 }
 
-static int
-ahc_pci_suspend(struct ahc_softc *ahc)
-{
-	return (ahc_suspend(ahc));
-}
-
-static int
+void
 ahc_pci_resume(struct ahc_softc *ahc)
 {
-
-	pci_set_power_state(ahc->dev_softc, AHC_POWER_STATE_D0);
-
 	/*
 	 * We assume that the OS has restored our register
 	 * mappings, etc.  Just update the config space registers
@@ -2063,7 +2050,6 @@ ahc_pci_resume(struct ahc_softc *ahc)
 				      &sxfrctl1);
 		ahc_release_seeprom(&sd);
 	}
-	return (ahc_resume(ahc));
 }
 
 static int

--------------060905010908090708030104--
