From: Marc Zyngier <mzyngier@freesurf.fr>
Subject: [PATCH][2.5] Aic7xxx and EISA API
Date: 19 May 2003 17:30:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <wrpel2v54y9.fsf@hina.wild-wind.fr.eu.org>
Reply-To: mzyngier@freesurf.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:4107 "EHLO
	young-lust.wild-wind.fr.eu.org") by vger.kernel.org with ESMTP
	id S262489AbTESPZA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 11:25:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

Justin,

This patch updates the aic7xxx driver to use the EISA probing API. It
also includes the fix you provided for TWIN boards.

I'd appreciate any comment.

        M.

===== drivers/scsi/aic7xxx/Kconfig.aic7xxx 1.10 vs edited =====
--- 1.10/drivers/scsi/aic7xxx/Kconfig.aic7xxx	Thu Feb 20 23:50:08 2003
+++ edited/drivers/scsi/aic7xxx/Kconfig.aic7xxx	Fri May 16 14:03:11 2003
@@ -52,7 +52,7 @@
 
 config AIC7XXX_PROBE_EISA_VL
 	bool "Probe for EISA and VL AIC7XXX Adapters"
-	depends on SCSI_AIC7XXX
+	depends on SCSI_AIC7XXX && EISA
 	help
 	Probe for EISA and VLB Aic7xxx controllers.  In many newer systems,
 	the invasive probes necessary to detect these controllers can cause
===== drivers/scsi/aic7xxx/aic7770_osm.c 1.3 vs edited =====
--- 1.3/drivers/scsi/aic7xxx/aic7770_osm.c	Mon Mar 10 21:18:24 2003
+++ edited/drivers/scsi/aic7xxx/aic7770_osm.c	Fri May 16 16:55:33 2003
@@ -45,6 +45,54 @@
 #define NUMSLOTS		16
 #define IDOFFSET		0x80
 
+static int aic7770_eisa_config (Scsi_Host_Template *template,
+				struct aic7770_identity *entry,
+				int slot,
+				unsigned int eisaBase,
+				struct ahc_softc **eisa_ahc)
+{
+	struct ahc_softc *ahc;
+	char	 buf[80];
+	char	*name;
+	int	 error;
+
+	if (eisa_ahc)
+		*eisa_ahc = NULL;
+	/*
+	 * Allocate a softc for this card and
+	 * set it up for attachment by our
+	 * common detect routine.
+	 */
+	sprintf(buf, "ahc_eisa:%d", slot);
+	name = malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
+	if (name == NULL)
+		return -ENOMEM;
+	strcpy(name, buf);
+	ahc = ahc_alloc(template, name);
+	if (ahc == NULL) {
+		/*
+		 * If we can't allocate this one,
+		 * chances are we won't be able to
+		 * allocate future card structures.
+		 */
+		free (name, M_DEVBUF);
+		return -ENOMEM;
+	}
+	error = aic7770_config(ahc, entry, eisaBase);
+	if (error != 0) {
+		ahc->bsh.ioport = 0;
+		ahc_free(ahc);
+		free (name, M_DEVBUF);
+		return error;
+	}
+
+	if (eisa_ahc)
+		*eisa_ahc = ahc;
+	
+	return 0;
+}
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 int
 aic7770_linux_probe(Scsi_Host_Template *template)
 {
@@ -84,35 +132,11 @@
 
 		entry = aic7770_find_device(eisa_id);
 		if (entry != NULL) {
-			char	 buf[80];
-			char	*name;
 			int	 error;
 
-			/*
-			 * Allocate a softc for this card and
-			 * set it up for attachment by our
-			 * common detect routine.
-			 */
-			sprintf(buf, "ahc_eisa:%d", slot);
-			name = malloc(strlen(buf) + 1, M_DEVBUF, M_NOWAIT);
-			if (name == NULL)
-				break;
-			strcpy(name, buf);
-			ahc = ahc_alloc(template, name);
-			if (ahc == NULL) {
-				/*
-				 * If we can't allocate this one,
-				 * chances are we won't be able to
-				 * allocate future card structures.
-				 */
-				break;
-			}
-			error = aic7770_config(ahc, entry, eisaBase);
-			if (error != 0) {
-				ahc->bsh.ioport = 0;
-				ahc_free(ahc);
+			error = aic7770_eisa_config(template, entry, slot, eisaBase, NULL);
+			if (error != 0)
 				continue;
-			}
 			found++;
 		}
 	}
@@ -121,6 +145,132 @@
 	return (0);
 #endif
 }
+
+#else /* kernel > 2.5.0 */
+
+#include <linux/device.h>
+#include <linux/eisa.h>
+
+static Scsi_Host_Template *aic7770_template;
+
+static void aic7770_convert_eisa_sig (char *sig_str, int num)
+{
+        u8 sig[4];
+        u16 rev;
+	u32 id;
+        int i;
+
+        id = aic7770_ident_table[num].full_id;
+
+	for (i = 0; i < 4; i++) {
+		sig[i] = id >> 24;
+		id <<= 8;
+	}
+
+	/* From driver/eisa/eisa-bus.c */
+        sig_str[0] = ((sig[0] >> 2) & 0x1f) + ('A' - 1);
+        sig_str[1] = (((sig[0] & 3) << 3) | (sig[1] >> 5)) + ('A' - 1);
+        sig_str[2] = (sig[1] & 0x1f) + ('A' - 1);
+        rev = (sig[2] << 8) | sig[3];
+        sprintf(sig_str + 3, "%04X", rev);
+}
+
+static void aic7770_ahc_remove (struct ahc_softc *ahc)
+{
+	if (ahc != NULL) {
+		u_long s;
+
+		ahc_lock(ahc, &s);
+		ahc_intr_enable(ahc, FALSE);
+		ahc_unlock(ahc, &s);
+		ahc_free(ahc);
+	}
+}
+
+static int aic7770_eisa_probe (struct device *dev)
+{
+	struct eisa_device *edev = to_eisa_device (dev);
+
+	if (aic7770_eisa_config (aic7770_template,
+				 aic7770_ident_table + edev->id.driver_data,
+				 edev->slot,
+				 edev->base_addr + AHC_EISA_SLOT_OFFSET,
+				 (struct ahc_softc **) &dev->driver_data))
+		return -1;
+
+	if (ahc_linux_register_host ((struct ahc_softc *) dev->driver_data,
+				     aic7770_template)) {
+		u_long l;
+
+		ahc_list_lock(&l);
+		aic7770_ahc_remove ((struct ahc_softc *) dev->driver_data);
+		ahc_list_unlock(&l);
+
+		return -1;
+	}
+	
+	return 0;
+}
+
+static int aic7770_eisa_remove (struct device *dev)
+{
+	struct ahc_softc *ahc;
+	u_long l;
+
+	/*
+	 * We should be able to just perform
+	 * the free directly, but check our
+	 * list for extra sanity.
+	 */
+	ahc_list_lock(&l);
+	ahc = ahc_find_softc((struct ahc_softc *) dev->driver_data);
+	aic7770_ahc_remove (ahc);
+	ahc_list_unlock(&l);
+	
+	return 0;
+}
+
+static struct eisa_driver aic7770_driver = {
+	.driver = {
+		.name   = "aic7xxx",
+		.probe  = aic7770_eisa_probe,
+		.remove = aic7770_eisa_remove,
+	},
+};
+
+int aic7770_linux_probe (Scsi_Host_Template *template)
+{
+	struct eisa_device_id *eids;
+	int i;
+	
+	aic7770_template = template;
+
+	if (!(eids = kmalloc (sizeof (*eids) * (ahc_num_aic7770_devs + 1),
+			      GFP_KERNEL)))
+		return -1;
+
+	memset (eids, 0, sizeof (*eids));
+	
+	/* Populate the EISA id table with driver-provided entries...
+	   The last entry (terminator) is set by virtue of
+	   memset... */
+	for (i = 0; i < ahc_num_aic7770_devs; i++) {
+		aic7770_convert_eisa_sig (eids[i].sig, i);
+		eids[i].driver_data = i;
+	}
+
+	aic7770_driver.id_table = eids;
+
+	eisa_driver_register (&aic7770_driver);
+	
+	return 0;
+}
+
+void aic7770_linux_exit (void)
+{
+	eisa_driver_unregister (&aic7770_driver);
+}
+#endif
 
 int
 aic7770_map_registers(struct ahc_softc *ahc, u_int port)
===== drivers/scsi/aic7xxx/aic7xxx_osm.c 1.36 vs edited =====
--- 1.36/drivers/scsi/aic7xxx/aic7xxx_osm.c	Tue May 13 23:11:12 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.c	Fri May 16 16:50:36 2003
@@ -777,7 +777,6 @@
 
 /************************  Host template entry points *************************/
 static int	   ahc_linux_detect(Scsi_Host_Template *);
-static int	   ahc_linux_release(struct Scsi_Host *);
 static int	   ahc_linux_queue(Scsi_Cmnd *, void (*)(Scsi_Cmnd *));
 static const char *ahc_linux_info(struct Scsi_Host *);
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
@@ -790,6 +789,7 @@
 				       sector_t, int[]);
 #endif
 #else
+static int	   ahc_linux_release(struct Scsi_Host *);
 static void	   ahc_linux_select_queue_depth(struct Scsi_Host *host,
 						Scsi_Device *scsi_devs);
 #if defined(__i386__)
@@ -920,8 +920,10 @@
 	ahc_linux_pci_init();
 #endif
 
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)) || defined (CONFIG_EISA)
 	if (aic7xxx_probe_eisa_vl != 0)
 		aic7770_linux_probe(template);
+#endif
 
 	/*
 	 * Register with the SCSI layer all
@@ -929,9 +931,14 @@
 	 */
 	found = 0;
 	TAILQ_FOREACH(ahc, &ahc_tailq, links) {
-
-		if (ahc_linux_register_host(ahc, template) == 0)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+		/* On 2.5.x, EISA is taken care of in the probing code */
+		if (ahc->chip & (AHC_EISA|AHC_VL))
 			found++;
+		else
+#endif
+			if (ahc_linux_register_host(ahc, template) == 0)
+				found++;
 	}
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	spin_lock_irq(&io_request_lock);
@@ -940,6 +947,7 @@
 	return (found);
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 /*
  * Free the passed in Scsi_Host memory structures prior to unloading the
  * module.
@@ -971,6 +979,7 @@
 	ahc_list_unlock(&l);
 	return (0);
 }
+#endif
 
 /*
  * Return a string describing the driver.
@@ -1747,7 +1756,7 @@
 	struct	 Scsi_Host *host;
 	char	*new_name;
 	u_long	 s;
-	u_int	 target;
+	u_int	 targ_offset;
 
 	template->name = ahc->description;
 	host = scsi_register(template, sizeof(struct ahc_softc *));
@@ -1802,14 +1811,19 @@
 	 * negotiation will occur for the first command, and DV
 	 * will comence should that first command be successful.
 	 */
-	for (target = 0;
-	     target < host->max_id * (host->max_channel + 1); target++) {
+	for (targ_offset = 0;
+	     targ_offset < host->max_id * (host->max_channel + 1);
+	     targ_offset++) {
 		u_int channel;
+		u_int target;
 
 		channel = 0;
+		target = targ_offset;
 		if (target > 7
-		 && (ahc->features & AHC_TWIN) != 0)
+		 && (ahc->features & AHC_TWIN) != 0) {
 			channel = 1;
+			target &= 0x7;
+		}
 		/*
 		 * Skip our own ID.  Some Compaq/HP storage devices
 		 * have enclosure management devices that respond to
@@ -2443,8 +2457,10 @@
 		ahc_unlock(ahc, &s);
 		return;
 	}
-	ahc_compile_devinfo(&devinfo, ahc->our_id, targ->target, /*lun*/0,
-			    targ->channel + 'A', ROLE_INITIATOR);
+	ahc_compile_devinfo(&devinfo,
+			    targ->channel == 0 ? ahc->our_id : ahc->our_id_b,
+			    targ->target, /*lun*/0, targ->channel + 'A',
+			    ROLE_INITIATOR);
 #ifdef AHC_DEBUG
 	if (ahc_debug & AHC_SHOW_DV) {
 		ahc_print_devinfo(ahc, &devinfo);
@@ -5095,7 +5111,25 @@
 ahc_linux_init(void)
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	return (ahc_linux_detect(&aic7xxx_driver_template) ? 0 : -ENODEV);
+#ifdef MODULE
+	if (!ahc_linux_detect(&aic7xxx_driver_template)) {
+#ifdef CONFIG_PCI
+		ahc_linux_pci_exit();
+#endif
+
+#ifdef CONFIG_EISA
+	/*
+	 * Get rid of the non-pci devices.  
+	 */
+		if (aic7xxx_probe_eisa_vl != 0)
+			aic7770_linux_exit();
+#endif
+		return (-ENODEV);
+	}
+#else
+	ahc_linux_detect(&aic7xxx_driver_template);
+#endif
+	return 0;
 #else
 	scsi_register_module(MODULE_SCSI_HA, &aic7xxx_driver_template);
 	if (aic7xxx_driver_template.present == 0) {
@@ -5127,16 +5161,17 @@
 	}
 	ahc_list_unlock(&l);
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-
+#ifdef CONFIG_PCI
 	ahc_linux_pci_exit();
+#endif
 
+#ifdef CONFIG_EISA
 	/*
 	 * Get rid of the non-pci devices.  
-	 *
-	 * XXX(hch): switch over eisa support to new LDM-based API
 	 */
-	TAILQ_FOREACH(ahc, &ahc_tailq, links)
-		ahc_linux_release(ahc->platform_data->host);
+	if (aic7xxx_probe_eisa_vl != 0)
+		aic7770_linux_exit();
+#endif
 #else
 	scsi_unregister_module(MODULE_SCSI_HA, &aic7xxx_driver_template);
 
===== drivers/scsi/aic7xxx/aic7xxx_osm.h 1.44 vs edited =====
--- 1.44/drivers/scsi/aic7xxx/aic7xxx_osm.h	Tue May 13 05:52:59 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.h	Fri May 16 12:16:09 2003
@@ -848,6 +848,7 @@
 			    ahc_power_state new_state);
 /**************************** VL/EISA Routines ********************************/
 int			 aic7770_linux_probe(Scsi_Host_Template *);
+void			 aic7770_linux_exit (void);
 int			 aic7770_map_registers(struct ahc_softc *ahc,
 					       u_int port);
 int			 aic7770_map_int(struct ahc_softc *ahc, u_int irq);

-- 
Places change, faces change. Life is so very strange.
