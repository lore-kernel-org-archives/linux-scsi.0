From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi_add_host/scsi_Remove_host for aic7xxx/aic79xx
Date: Wed, 26 Feb 2003 20:05:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030226200541.A8346@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: gibbs@scsiguy.com
Cc: linux-scsi@vger.kernel.org

I remember having this submitted a while ago, but here's the code
again, this time with the untested aic79xx bits.


--- 1.22/drivers/scsi/aic7xxx/aic79xx_osm.c	Tue Feb 18 19:12:35 2003
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm.c	Wed Feb 26 19:53:22 2003
@@ -801,7 +801,6 @@
 
 /************************  Host template entry points *************************/
 static int	   ahd_linux_detect(Scsi_Host_Template *);
-static int	   ahd_linux_release(struct Scsi_Host *);
 static const char *ahd_linux_info(struct Scsi_Host *);
 static int	   ahd_linux_queue(Scsi_Cmnd *, void (*)(Scsi_Cmnd *));
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
@@ -811,6 +810,7 @@
 static int	   ahd_linux_biosparam(struct scsi_device*,
 				       struct block_device*, sector_t, int[]);
 #else
+static int	   ahd_linux_release(struct Scsi_Host *);
 static void	   ahd_linux_select_queue_depth(struct Scsi_Host *host,
 						Scsi_Device *scsi_devs);
 static int	   ahd_linux_biosparam(Disk *, kdev_t, int[]);
@@ -874,7 +874,7 @@
 	ahd_list_lockinit();
 
 #ifdef CONFIG_PCI
-	ahd_linux_pci_probe(template);
+	ahd_linux_pci_init();
 #endif
 
 	/*
@@ -894,6 +894,7 @@
 	return (found);
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 /*
  * Free the passed in Scsi_Host memory structures prior to unloading the
  * module.
@@ -925,6 +926,7 @@
 	ahd_list_unlock(&l);
 	return (0);
 }
+#endif
 
 /*
  * Return a string describing the driver.
@@ -1664,9 +1666,9 @@
 }
 
 Scsi_Host_Template aic79xx_driver_template = {
+	.module			= THIS_MODULE,
+	.name			= "aic79xx",
 	.proc_info		= ahd_linux_proc_info,
-	.detect			= ahd_linux_detect,
-	.release		= ahd_linux_release,
 	.info			= ahd_linux_info,
 	.queuecommand		= ahd_linux_queue,
 	.eh_abort_handler	= ahd_linux_abort,
@@ -1698,18 +1700,17 @@
 #endif
 #endif
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	.name			= "aic79xx",
 	.slave_alloc		= ahd_linux_slave_alloc,
 	.slave_configure	= ahd_linux_slave_configure,
 	.slave_destroy		= ahd_linux_slave_destroy,
 #else
+	.detect			= ahd_linux_detect,
+	.release		= ahd_linux_release,
 	.select_queue_depths	= ahd_linux_select_queue_depth,
 	.use_new_eh_code	= 1,
 #endif
 };
 
-#define driver_template aic79xx_driver_template
-#include "scsi_module.c"
 /**************************** Tasklet Handler *********************************/
 
 static void
@@ -2381,9 +2382,8 @@
 		ahd_set_name(ahd, new_name);
 	}
 	host->unique_id = ahd->unit;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	scsi_set_device(host, &ahd->dev_softc->dev);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,4)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,4) && \
+    LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,0)
 	scsi_set_pci_device(host, ahd->dev_softc);
 #endif
 	ahd_linux_initialize_scsi_bus(ahd);
@@ -2410,6 +2410,10 @@
 	ahd_intr_enable(ahd, TRUE);
 	ahd_linux_start_dv(ahd);
 	ahd_unlock(ahd, &s);
+
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+	scsi_add_host(host, &ahd->dev_softc->dev);
+#endif
 	return (0);
 }
 
@@ -2556,8 +2560,12 @@
 					 __WCLONE) == -ERESTARTSYS);
 		}
 		ahd_teardown_runq_tasklet(ahd);
-		if (ahd->platform_data->host != NULL)
+		if (ahd->platform_data->host != NULL) {
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+			scsi_remove_host(ahd->platform_data->host);
+#endif
 			scsi_unregister(ahd->platform_data->host);
+		}
 
 		/* destroy all of the device and target objects */
 		for (i = 0; i < AHD_NUM_TARGETS; i++) {
@@ -2595,21 +2603,17 @@
 					   0x1000);
 #endif
 		}
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-		/* XXX Need an instance detach in the PCI code */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0) && \
+    LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,0)
+    		/*
+		 * In 2.4 we detach from the scsi midlayer before the PCI
+		 * layer invokes our remove callback.
+		 */
 		if (ahd->dev_softc != NULL)
 			ahd->dev_softc->driver = NULL;
 #endif
 		free(ahd->platform_data, M_DEVBUF);
 	}
-	if (TAILQ_EMPTY(&ahd_tailq)) {
-		unregister_reboot_notifier(&ahd_linux_notifier);
-#ifdef CONFIG_PCI
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-		pci_unregister_driver(&aic79xx_pci_driver);
-#endif
-#endif
-	}
 }
 
 void
@@ -5315,3 +5319,30 @@
 		}
 	}
 }
+
+static int __init ahd_linux_init(void)
+{
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+       return (ahd_linux_detect(&aic79xx_driver_template) ? 0 : -ENODEV);
+#else
+	scsi_register_module(MODULE_SCSI_HA, &aic79xx_driver_template);
+	if (!driver_template.present) {
+		scsi_unregister_module(MODULE_SCSI_HA,
+				       &aic79xx_driver_template);
+		return (-ENODEV);
+	}
+
+	return (0);
+#endif
+}
+
+static void __exit ahd_linux_exit(void)
+{
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+	scsi_unregister_module(MODULE_SCSI_HA, &aic79xx_driver_template);
+#endif
+	ahd_linux_pci_exit();
+}
+
+module_init(ahd_linux_init);
+module_exit(ahd_linux_exit);
--- 1.16/drivers/scsi/aic7xxx/aic79xx_osm.h	Fri Feb  7 09:20:36 2003
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm.h	Wed Feb 26 19:46:01 2003
@@ -952,7 +952,8 @@
 #include <linux/bios32.h>
 #endif
 
-int			 ahd_linux_pci_probe(Scsi_Host_Template *);
+int			 ahd_linux_pci_init(void);
+void			 ahd_linux_pci_exit(void);
 int			 ahd_pci_map_registers(struct ahd_softc *ahd);
 int			 ahd_pci_map_int(struct ahd_softc *ahd);
 
--- 1.5/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	Wed Jan  8 03:58:34 2003
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	Wed Feb 26 19:48:22 2003
@@ -183,14 +183,21 @@
 	}
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	pci_set_drvdata(pdev, ahd);
-	if (aic79xx_detect_complete)
+	if (aic79xx_detect_complete) {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 		ahd_linux_register_host(ahd, &aic79xx_driver_template);
+#else
+		printf("aic79xx: ignoring PCI device found after "
+		       "initialization\n");
+		return (-ENODEV);
+#endif
+	}
 #endif
 	return (0);
 }
 
 int
-ahd_linux_pci_probe(Scsi_Host_Template *template)
+ahd_linux_pci_init(void)
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	return (pci_module_init(&aic79xx_pci_driver));
@@ -217,6 +224,12 @@
 	}
 	return (found);
 #endif
+}
+
+void
+ahd_linux_pci_exit(void)
+{
+	pci_unregister_driver(&aic79xx_pci_driver);
 }
 
 static int
--- 1.20/drivers/scsi/aic7xxx/aic7xxx_osm.c	Tue Feb 25 18:45:05 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.c	Wed Feb 26 19:50:29 2003
@@ -875,7 +875,7 @@
 	ahc_list_lockinit();
 
 #ifdef CONFIG_PCI
-	ahc_linux_pci_probe(template);
+	ahc_linux_pci_init();
 #endif
 
 	if (aic7xxx_no_probe == 0)
@@ -1266,9 +1266,9 @@
 }
 
 Scsi_Host_Template aic7xxx_driver_template = {
+	.module			= THIS_MODULE,
+	.name			= "aic7xxx",
 	.proc_info		= ahc_linux_proc_info,
-	.detect			= ahc_linux_detect,
-	.release		= ahc_linux_release,
 	.info			= ahc_linux_info,
 	.queuecommand		= ahc_linux_queue,
 	.eh_abort_handler	= ahc_linux_abort,
@@ -1300,19 +1300,17 @@
 #endif
 #endif
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	.name			= "aic7xxx",
 	.slave_alloc		= ahc_linux_slave_alloc,
 	.slave_configure	= ahc_linux_slave_configure,
 	.slave_destroy		= ahc_linux_slave_destroy,
 #else
+	.detect			= ahc_linux_detect,
+	.release		= ahc_linux_release,
 	.select_queue_depths	= ahc_linux_select_queue_depth,
 	.use_new_eh_code	= 1,
 #endif
 };
 
-#define driver_template aic7xxx_driver_template
-#include "scsi_module.c"
-
 /**************************** Tasklet Handler *********************************/
 
 static void
@@ -1861,9 +1859,8 @@
 		ahc_set_name(ahc, new_name);
 	}
 	host->unique_id = ahc->unit;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-	scsi_set_device(host, &ahc->dev_softc->dev);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,4)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,4) && \
+    LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,0)
 	scsi_set_pci_device(host, ahc->dev_softc);
 #endif
 	ahc_linux_initialize_scsi_bus(ahc);
@@ -1897,6 +1894,10 @@
 	ahc_intr_enable(ahc, TRUE);
 	ahc_linux_start_dv(ahc);
 	ahc_unlock(ahc, &s);
+
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+	scsi_add_host(host, (ahc->dev_softc ? &ahc->dev_softc->dev : NULL));
+#endif
 	return (0);
 }
 
@@ -2075,8 +2076,12 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 		tasklet_kill(&ahc->platform_data->runq_tasklet);
 #endif
-		if (ahc->platform_data->host != NULL)
+		if (ahc->platform_data->host != NULL) {
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+			scsi_remove_host(ahc->platform_data->host);
+#endif
 			scsi_unregister(ahc->platform_data->host);
+		}
 
 		/* destroy all of the device and target objects */
 		for (i = 0; i < AHC_NUM_TARGETS; i++) {
@@ -2112,19 +2117,16 @@
 #endif
 		}
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-		/* XXX Need an instance detach in the PCI code */
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+		/*
+		 * In 2.4 we detach from the scsi midlayer before the PCI
+		 * layer invokes our remove callback.
+		 */
 		if (ahc->dev_softc != NULL)
 			ahc->dev_softc->driver = NULL;
 #endif
-		free(ahc->platform_data, M_DEVBUF);
-	}
-	if (TAILQ_EMPTY(&ahc_tailq)) {
-		unregister_reboot_notifier(&ahc_linux_notifier);
-#ifdef CONFIG_PCI
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-		pci_unregister_driver(&aic7xxx_pci_driver);
-#endif
 #endif
+		free(ahc->platform_data, M_DEVBUF);
 	}
 }
 
@@ -5182,3 +5184,51 @@
 		}
 	}
 }
+
+static int __init ahc_linux_init(void)
+{
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+	return (ahc_linux_detect(&aic7xxx_driver_template) ? 0 : -ENODEV);
+#else
+	scsi_register_module(MODULE_SCSI_HA, &aic7xxx_driver_template);
+	if (!driver_template.present) {
+		scsi_unregister_module(MODULE_SCSI_HA,
+				       &aic7xxx_driver_template);
+		return (-ENODEV);
+	}
+
+	return (0);
+#endif
+}
+
+static void __exit ahc_linux_exit(void)
+{
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+	struct	ahc_softc *ahc;
+
+	ahc_linux_pci_exit();
+
+	/*
+	 * Get rid of the non-pci devices.  
+	 *
+	 * XXX(hch): switch over eisa support to new LDM-based API
+	 */
+	TAILQ_FOREACH(ahc, &ahc_tailq, links)
+		ahc_linux_release(ahc->platform_data->host);
+#else
+	scsi_unregister_module(MODULE_SCSI_HA, &aic7xxx_driver_template);
+
+	/*
+	 * In 2.4 we have to unregister from the PCI core _after_
+	 * unregistering from the scsi midlayer to avoid danling references.
+	 *
+	 * The 2.4 scsi midlayer is so f***ed..
+	 */
+	ahc_linux_pci_exit();
+#endif
+
+	unregister_reboot_notifier(&ahc_linux_notifier);
+}
+
+module_init(ahc_linux_init);
+module_exit(ahc_linux_exit);
--- 1.28/drivers/scsi/aic7xxx/aic7xxx_osm.h	Fri Feb  7 09:20:36 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.h	Wed Feb 26 17:14:16 2003
@@ -912,7 +912,8 @@
 #include <linux/bios32.h>
 #endif
 
-int			 ahc_linux_pci_probe(Scsi_Host_Template *);
+int			 ahc_linux_pci_init(void);
+void			 ahc_linux_pci_exit(void);
 int			 ahc_pci_map_registers(struct ahc_softc *ahc);
 int			 ahc_pci_map_int(struct ahc_softc *ahc);
 
--- 1.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	Wed Jan  8 03:58:35 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	Wed Feb 26 17:14:16 2003
@@ -179,14 +179,21 @@
 	}
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	pci_set_drvdata(pdev, ahc);
-	if (aic7xxx_detect_complete)
+	if (aic7xxx_detect_complete) {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 		ahc_linux_register_host(ahc, &aic7xxx_driver_template);
+#else
+		printf("aic7xxx: ignoring PCI device found after "
+		       "initialization\n");
+		return (-ENODEV);
+#endif
+	}
 #endif
 	return (0);
 }
 
 int
-ahc_linux_pci_probe(Scsi_Host_Template *template)
+ahc_linux_pci_init(void)
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	return (pci_module_init(&aic7xxx_pci_driver));
@@ -213,6 +220,12 @@
 	}
 	return (found);
 #endif
+}
+
+void
+ahc_linux_pci_exit(void)
+{
+	pci_unregister_driver(&aic7xxx_pci_driver);
 }
 
 static int
