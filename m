From: Nathan Bryant <nbryant@optonline.net>
Subject: [patch] ACPI work on aic7xxx
Date: Tue, 20 Jul 2004 11:22:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40FD38A0.3000603@optonline.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030604040201040300000207"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thunderdog.allegientsystems.com ([208.251.178.238]:49557 "EHLO
	lasn-001.allegientsystems.com") by vger.kernel.org with ESMTP
	id S265074AbUGTPV6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2004 11:21:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: random1@o-o.yi.org, Luben Tuikov <luben_tuikov@adaptec.com>, pavel@ucw.cz

This is a multi-part message in MIME format.
--------------030604040201040300000207
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Attached is a patch against 2.6.8-rc that supplies some more of the 
missing pieces of ACPI support for the aic7xxx driver.

--- Background and current driver status:
The 6.2.36 driver in current mainline 2.6 kernels contains the OS- and 
bus- neutral portions of the suspend/resume callbacks (ahc_resume() in 
aic7xxx_core.c and ahc_pci_resume() in aic7xxx_pci.c.) These stubs are 
mostly concerned with the card's own registers, and don't perform the 
requisite linux-specific calls to save and restore PCI config space and 
re-enable the card slot. It also appears that these callbacks were being 
developed by eyeball and were never tested. (Of course, not many people 
could test it since ACPI core wasn't in a usable state until recent 2.6)

As a consequence, after a resume the card I/O space is not visible under 
the current driver, and the driver would panic the kernel with the "Loop 
1" message. (See 
http://marc.theaimsgroup.com/?l=linux-scsi&m=102710764330862&w=2) This 
patch fixes that part. We now renable the slot and interrupts properly, 
and then call the previously-implemented resume routines (with just some 
obvious fixes) to attempt to reinitialize the card.

--- Where we are now:
It still doesn't work. The driver complains, "scsi0: Someone reset 
channel A" repeatedly. This message is coming from the driver's 
interrupt handler, so either the card registers are improperly 
reinitialized in some way, or the driver's state engine is not clearing 
the interrupt status, or we're somehow causing the reset to occur again 
and again. I'm not sure how much further I can take this without a data 
book or some help figuring out the card and driver state machines. I 
guess either the card's state machine or the driver's state machine has 
been driven insane, but I'm not sure what direction to look in.

This patch also includes a small fix for a bad merge, as suggested by 
Pavel Machec. See 
http://marc.theaimsgroup.com/?l=linux-scsi&m=108306129820558&w=2


Nathan Bryant

--------------030604040201040300000207
Content-Type: text/plain;
 name="aic7xxx_acpi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic7xxx_acpi.patch"

diff -urN linux-2.6.7-1.492.backup/drivers/scsi/aic7xxx/aic7xxx.h linux-2.6.7-1.492/drivers/scsi/aic7xxx/aic7xxx.h
--- linux-2.6.7-1.492.backup/drivers/scsi/aic7xxx/aic7xxx.h	2004-06-16 01:19:29.000000000 -0400
+++ linux-2.6.7-1.492/drivers/scsi/aic7xxx/aic7xxx.h	2004-07-19 23:27:51.000000000 -0400
@@ -1109,6 +1109,8 @@
 
 	uint16_t	 	  user_discenable;/* Disconnection allowed  */
 	uint16_t		  user_tagenable;/* Tagged Queuing allowed */
+
+	u32                      PciState[64]; /* save PCI state to this area */
 };
 
 TAILQ_HEAD(ahc_softc_tailq, ahc_softc);
diff -urN linux-2.6.7-1.492.backup/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c linux-2.6.7-1.492/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- linux-2.6.7-1.492.backup/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2004-07-15 14:23:17.000000000 -0400
+++ linux-2.6.7-1.492/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2004-07-20 00:34:30.000000000 -0400
@@ -54,6 +54,10 @@
 static int	ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
 						 u_long *bus_addr,
 						 uint8_t **maddr);
+#ifdef CONFIG_PM
+static int	ahc_linux_pci_suspend(struct pci_dev *dev, u32 state);
+static int	ahc_linux_pci_resume(struct pci_dev *dev);
+#endif
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 static void	ahc_linux_pci_dev_remove(struct pci_dev *pdev);
 
@@ -76,6 +80,10 @@
 	.name		= "aic7xxx",
 	.probe		= ahc_linux_pci_dev_probe,
 	.remove		= ahc_linux_pci_dev_remove,
+#ifdef CONFIG_PM
+	.suspend	= ahc_linux_pci_suspend,
+	.resume		= ahc_linux_pci_resume,
+#endif
 	.id_table	= ahc_linux_pci_id_table
 };
 
@@ -225,6 +233,72 @@
 #endif
 }
 
+#ifdef CONFIG_PM
+int ahc_linux_pci_suspend(struct pci_dev *dev, u32 state)
+{
+	int rval;
+	u32 device_state;
+	struct ahc_softc *ahc =
+		ahc_find_softc((struct ahc_softc *)pci_get_drvdata(dev));
+
+#if 0
+        switch(state)
+        {
+                case 1: /* S1 */
+                        device_state=1; /* D1 */;
+                        break;
+                case 3: /* S3 */
+                case 4: /* S4 */
+                        device_state=3; /* D3 */;
+                        break;
+                default:
+                        return -EAGAIN /*FIXME*/;
+                        break;
+        }
+#else
+	device_state = state;
+#endif
+
+        printk(KERN_INFO
+        "aic7xxx: pci-suspend: pdev=0x%p, slot=%s, Entering operating state [D%d]\n",
+                dev, pci_name(dev), device_state);
+
+	rval = ahc->bus_suspend(ahc);
+	if (rval != 0)
+		return rval;
+
+	pci_save_state(dev, ahc->PciState);
+	pci_disable_device(dev);
+	pci_set_power_state(dev, device_state);
+	return 0;
+}
+
+int ahc_linux_pci_resume(struct pci_dev *dev)
+{
+	int rval;
+	int device_state = dev->current_state;
+	struct ahc_softc *ahc =
+		ahc_find_softc((struct ahc_softc *)pci_get_drvdata(dev));
+
+        printk(KERN_INFO
+        "aic7xxx: pci-resume: pdev=0x%p, slot=%s, Previous operating state [D%d]\n",
+                dev, pci_name(dev), device_state);
+
+        pci_set_power_state(dev, AHC_POWER_STATE_D0);
+        pci_restore_state(dev, ahc->PciState);
+        pci_enable_device(dev);
+        pci_set_master(dev);
+
+	rval = ahc->bus_resume(ahc);
+#ifdef AHC_DEBUG
+	if (ahc_debug & AHC_SHOW_MISC) {
+		ahc_dump_card_state(ahc);
+	}
+#endif
+	return rval;
+}
+#endif /* CONFIG_PM */
+
 void
 ahc_linux_pci_exit(void)
 {
diff -urN linux-2.6.7-1.492.backup/drivers/scsi/aic7xxx/aic7xxx_pci.c linux-2.6.7-1.492/drivers/scsi/aic7xxx/aic7xxx_pci.c
--- linux-2.6.7-1.492.backup/drivers/scsi/aic7xxx/aic7xxx_pci.c	2004-06-16 01:18:57.000000000 -0400
+++ linux-2.6.7-1.492/drivers/scsi/aic7xxx/aic7xxx_pci.c	2004-07-19 23:32:21.000000000 -0400
@@ -834,8 +834,8 @@
 	ahc_pci_write_config(ahc->dev_softc, DEVCONFIG, devconfig, /*bytes*/4);
 
 	/* Ensure busmastering is enabled */
-	command = ahc_pci_read_config(ahc->dev_softc, PCIR_COMMAND, /*bytes*/2);
-	command |= PCIM_CMD_BUSMASTEREN;
+        command = ahc_pci_read_config(ahc->dev_softc, PCIR_COMMAND, /*bytes*/2);
+        command |= PCIM_CMD_BUSMASTEREN;
 
 	ahc_pci_write_config(ahc->dev_softc, PCIR_COMMAND, command, /*bytes*/2);
 
@@ -2090,21 +2090,18 @@
 static int
 ahc_pci_resume(struct ahc_softc *ahc)
 {
-
-	ahc_power_state_change(ahc, AHC_POWER_STATE_D0);
-
 	/*
 	 * We assume that the OS has restored our register
 	 * mappings, etc.  Just update the config space registers
 	 * that the OS doesn't know about and rely on our chip
 	 * reset handler to handle the rest.
 	 */
-	ahc_pci_write_config(ahc->dev_softc, DEVCONFIG, /*bytes*/4,
-			     ahc->bus_softc.pci_softc.devconfig);
-	ahc_pci_write_config(ahc->dev_softc, PCIR_COMMAND, /*bytes*/1,
-			     ahc->bus_softc.pci_softc.command);
-	ahc_pci_write_config(ahc->dev_softc, CSIZE_LATTIME, /*bytes*/1,
-			     ahc->bus_softc.pci_softc.csize_lattime);
+	ahc_pci_write_config(ahc->dev_softc, DEVCONFIG,
+			     ahc->bus_softc.pci_softc.devconfig, /*bytes*/4);
+	ahc_pci_write_config(ahc->dev_softc, PCIR_COMMAND,
+			     ahc->bus_softc.pci_softc.command, /*bytes*/1);
+	ahc_pci_write_config(ahc->dev_softc, CSIZE_LATTIME,
+			     ahc->bus_softc.pci_softc.csize_lattime, /*bytes*/1);
 	if ((ahc->flags & AHC_HAS_TERM_LOGIC) != 0) {
 		struct	seeprom_descriptor sd;
 		u_int	sxfrctl1;
--- linux-2.6.7-1.486/drivers/scsi/aic7xxx/aic7xxx_osm.c.orig	2004-07-14 18:45:39.695469069 -0400
+++ linux-2.6.7-1.486/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-07-14 18:46:55.160968771 -0400
@@ -2295,7 +2295,7 @@
 	sprintf(current->comm, "ahc_dv_%d", ahc->unit);
 #else
 	daemonize("ahc_dv_%d", ahc->unit);
-	current->flags |= PF_FREEZE;
+	current->flags |= PF_NOFREEZE;
 #endif
 	unlock_kernel();
 
--- linux-2.6.7-1.486/drivers/scsi/aic7xxx/aic79xx_osm.c.orig	2004-07-14 18:46:09.524239111 -0400
+++ linux-2.6.7-1.486/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-07-14 18:47:09.707290430 -0400
@@ -2591,7 +2591,7 @@
 	sprintf(current->comm, "ahd_dv_%d", ahd->unit);
 #else
 	daemonize("ahd_dv_%d", ahd->unit);
-	current->flags |= PF_FREEZE;
+	current->flags |= PF_NOFREEZE;
 #endif
 	unlock_kernel();
 

--------------030604040201040300000207--

