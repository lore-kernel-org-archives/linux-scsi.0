From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [14/27]
Date: Thu, 17 Feb 2005 12:36:47 -0500
Message-ID: <4214D62F.30809@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:1426 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262329AbVBQRgw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:36:52 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHapr31149
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:36:51 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHapb21229
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:36:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

OSM code.  Part 1/3.

diff -Nru a/drivers/scsi/adp94xx/adp94xx_osm.c b/drivers/scsi/adp94xx/adp94xx_osm.c
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/drivers/scsi/adp94xx/adp94xx_osm.c	2005-02-16 16:08:12 -05:00
@@ -0,0 +1,1923 @@
+/*
+ * Adaptec ADP94xx SAS HBA device driver for Linux.
+ *
+ * Written by: David Chaw <david_chaw@adaptec.com>
+ * Modified by: Naveen Chandrasekaran <naveen_chandrasekaran@adaptec.com>
+ *
+ * Copyright (c) 2004 Adaptec Inc.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ * $Id: //depot/razor/linux/src/adp94xx_osm.c#192 $
+ * 
+ */	
+#define KDB_ENABLE	0
+
+#if KDB_ENABLE
+#include "linux/kdb.h"
+#endif
+#include "adp94xx_osm.h"
+#include "adp94xx_inline.h"
+#include "adp94xx_sata.h"
+#include "adp94xx_hwi.h"
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+#include <linux/moduleparam.h>
+#endif
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Maintainer: David Chaw <david_chaw@adaptec.com>");
+MODULE_DESCRIPTION("Adaptec Linux SAS/SATA Family Driver");
+
+/* Global variables */
+LIST_HEAD(asd_hbas);
+static Scsi_Host_Template 	asd_sht;
+static asd_init_status_t	asd_init_stat;
+static int			asd_init_result;
+spinlock_t 			asd_list_spinlock;
+
+#ifdef ASD_EH_SIMULATION
+static u_long			cmd_cnt = 0;
+#endif
+
+u_int				debug_mask = 0x0;
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+/* For dynamic sglist size calculation. */
+u_int asd_nseg;
+#endif
+
+/* Device Queue Depth Handling. */
+#define ASD_DEF_TCQ_PER_DEVICE	32
+#define ASD_MAX_TCQ_PER_DEVICE	64
+#define ASD_MIN_TCQ_PER_DEVICE	1
+
+static u_int cmd_per_lun = ASD_DEF_TCQ_PER_DEVICE;
+
+/* By default we do not attach to HostRAID enabled controllers.
+ */
+#define ASD_DEF_ATTACH_HOSTRAID 0
+static int attach_HostRAID = ASD_DEF_ATTACH_HOSTRAID;
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+module_param_named(attach_HostRAID, attach_HostRAID, int, S_IRUGO|S_IWUSR);
+module_param_named(cmd_per_lun, cmd_per_lun, uint, S_IRUGO|S_IWUSR);
+module_param_named(debug_mask, debug_mask, uint, S_IRUGO|S_IWUSR);
+#else /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0) */
+MODULE_PARM(attach_HostRAID, "i");
+MODULE_PARM(cmd_per_lun, "i");
+MODULE_PARM(debug_mask, "i");
+#ifndef MODULE
+static int adp94xx_setup(char *s);
+__setup("adp94xx=", adp94xx_setup);
+#endif /* MODULE */
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0) */
+
+MODULE_PARM_DESC(attach_HostRAID,
+		 "integer, disable(0) or enable(1) attaching to\n"
+		 "\tHostRAID enabled controllers."
+		 " Default:" __stringify(ASD_DEF_ATTACH_HOSTRAID));
+MODULE_PARM_DESC(cmd_per_lun,
+		 "integer, queue depth for all attached targets that\n"
+		 "\tsupport tag queueing."
+		 " Default:" __stringify(ASD_DEF_TCQ_PER_DEVICE)
+	         " Min:" __stringify(ASD_MIN_TCQ_PER_DEVICE)
+		 " Max:" __stringify(ASD_MAX_TCQ_PER_DEVICE));
+MODULE_PARM_DESC(debug_mask,
+		 "integer, the debug mask, must have ASD_DEBUG macro\n"
+		 "\tdefined at compilation time.");
+
+/* The driver version */
+static const char __driver_version[] \
+	__attribute__ ((section ("driver_version"))) \
+	= "driver_version=" ASD_DRIVER_VERSION "-" \
+	__stringify(ASD_RELEASE_VERSION);
+static const char *asd_driver_version \
+	= __driver_version + sizeof("driver_version=") - 1;
+
+/* Module entry points */
+static int __init	asd_init(void);
+static void 		asd_exit(void);
+
+/* Initialization */
+static void 		asd_size_nseg(void);
+
+/* Midlayer entry points */
+static int		asd_detect(Scsi_Host_Template *);
+static const char      *asd_info(struct Scsi_Host *);
+static int 		asd_queue(Scsi_Cmnd *, void (*)(Scsi_Cmnd *));
+irqreturn_t		asd_isr(int, void *, struct pt_regs *);
+static int		asd_abort(Scsi_Cmnd *);
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+static int	asd_proc_info(struct Scsi_Host *, char *, char **, off_t,
+			      int, int);
+static int	asd_bios_param(struct scsi_device *sdev,
+			       struct block_device *bdev, sector_t capacity,
+			       int geom[]);
+static int	asd_slave_alloc(Scsi_Device *);
+static int	asd_slave_configure(Scsi_Device *);
+static void	asd_slave_destroy(Scsi_Device *);
+static int	asd_initiate_bus_scan(struct asd_softc *asd);
+#else
+static int	asd_release(struct Scsi_Host *);
+static int	asd_proc_info(char *, char **, off_t, int, int, int);
+static void	asd_select_queue_depth(struct Scsi_Host *, Scsi_Device *);
+static int	asd_bios_param(Disk *disk, kdev_t dev, int geom[]);
+#endif
+
+typedef enum {
+	ASD_QUEUE_NONE,
+	ASD_QUEUE_BASIC,
+	ASD_QUEUE_TAGGED
+} asd_queue_alg;
+
+static void	asd_set_device_queue_depth(struct asd_softc *asd,
+					   struct asd_device *dev);
+static u_int	asd_get_user_tagdepth(struct asd_softc *asd,
+				      struct asd_device *dev);
+static void	asd_set_tags(struct asd_softc *asd, struct asd_device *dev,
+			     asd_queue_alg alg);
+static void 	asd_print_path(struct asd_softc *asd, struct asd_device *dev);
+
+/* Device Queue Handling. */
+static struct asd_domain *
+		asd_alloc_domain(struct asd_softc *asd, u_int channel_mapping);
+static void	asd_free_domain(struct asd_softc *asd, struct asd_domain *dm);
+static void	asd_dev_timed_unfreeze(u_long arg);
+static void	asd_init_dev_itnl_exp(struct asd_softc *asd,
+				      struct asd_target *targ, u_int lun);
+void		asd_dev_intl_times_out(u_long arg);
+
+static asd_scb_post_t	asd_scb_done;
+static void	asd_handle_sas_status(struct asd_softc *asd,
+				      struct asd_device *dev, struct scb *scb,
+				      struct ssp_resp_edb *edb, u_int edb_len);
+static ASD_COMMAND_BUILD_STATUS	
+		asd_build_sas_scb(struct asd_softc *asd, struct scb *scb,
+				  union asd_cmd *acmd);
+static void	asd_runq_tasklet(unsigned long data);
+static void	asd_unblock_tasklet(unsigned long data);
+static void	asd_flush_device_queue(struct asd_softc *asd,
+				       struct asd_device *dev);
+static inline void
+		asd_check_device_queue(struct asd_softc *asd,
+				       struct asd_device *dev);
+inline void 	asd_run_device_queues(struct asd_softc *asd);
+
+/* Discovery and Device async. event thread. */
+static int	asd_discovery_thread(void *data);
+static void	asd_kill_discovery_thread(struct asd_softc *asd);
+static int	asd_check_phy_events(struct asd_softc *asd, u_int phy_id);
+static int	asd_check_port_events(struct asd_softc *asd, u_int port_id);
+static void	asd_process_id_addr_evt(struct asd_softc *asd, 
+					struct asd_phy *phy);
+static int	asd_initiate_port_discovery(struct asd_softc *asd, 
+				            struct asd_port *port);
+static void	asd_handle_loss_of_signal(struct asd_softc *asd, 
+					  struct asd_port *port);
+static void 	asd_setup_port_data(struct asd_softc *asd,
+				    struct asd_port *port, struct asd_phy *phy);
+static int	asd_setup_target_data(struct asd_softc *asd,
+				      struct asd_phy *phy,
+				      struct asd_target *targ);
+static void	asd_configure_port_targets(struct asd_softc *asd, 
+					   struct asd_port *port);
+static void	asd_configure_target(struct asd_softc *asd,
+				     struct asd_target *targ);
+static void	asd_destroy_target(struct asd_softc *asd,
+				   struct asd_target *targ);
+static void	asd_clear_device_io(struct asd_softc *asd,
+				    struct asd_device *dev);
+static asd_scb_post_t	asd_clear_device_io_done;
+
+/* Error Recovery thread. */
+static int	asd_ehandler_thread(void *data);
+static void	asd_kill_ehandler_thread(struct asd_softc *asd);
+static asd_scb_eh_post_t asd_ehandler_done;
+
+#ifdef ASD_EH_SIMULATION
+static void	asd_eh_simul_done(struct asd_softc *asd, struct scb *scb);
+static int	asd_eh_simul_thread(void *data);
+static void	asd_kill_eh_simul_thread(struct asd_softc *asd);
+#endif
+
+/* PCI entry points */
+static int	asd_pci_dev_probe(struct pci_dev *pdev,
+			 	  const struct pci_device_id *id);
+static void	asd_pci_dev_remove(struct pci_dev *pdev);
+
+/*
+ * PCI Device specific initialization routine.
+ */
+typedef int (asd_pdev_setup_t)	(struct asd_softc *);
+
+struct asd_pci_driver_data {
+	/* Controller Description. */
+	char		  *description;
+
+	/* Controller Specific Setup Routine. */
+	asd_pdev_setup_t  *setup;
+};
+
+static asd_pdev_setup_t asd_aic9410_setup;
+
+/* Supported PCI Vendor & Device ID */
+#ifndef PCI_VENDOR_ID_ADAPTEC2
+#define PCI_VENDOR_ID_ADAPTEC2	0x9005
+#endif
+#define PCI_CLASS_DEFAULT	0
+#define PCI_CLASS_MASK_DEFAULT	0
+
+static struct asd_pci_driver_data  asd_aic9410_drv_data =	\
+{								\
+	"Adaptec AIC-9410 SAS/SATA Controller",			\
+	asd_aic9410_setup					\
+};
+
+static struct pci_device_id  asd_pci_ids_table[] = {
+	{
+		PCI_VENDOR_ID_ADAPTEC2, 0x0412, PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_DEFAULT, PCI_CLASS_MASK_DEFAULT,
+		(unsigned long) &asd_aic9410_drv_data
+	},
+	{
+		PCI_VENDOR_ID_ADAPTEC2, 0x041E, PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_DEFAULT, PCI_CLASS_MASK_DEFAULT,
+		(unsigned long) &asd_aic9410_drv_data
+	},
+	{ 0 }
+};
+
+MODULE_DEVICE_TABLE(pci, asd_pci_ids_table);
+
+struct pci_driver  adp94xx_pci_driver = {
+	.name		= ASD_DRIVER_NAME,
+	.probe		= asd_pci_dev_probe,
+	.remove 	= asd_pci_dev_remove,
+	.id_table	= asd_pci_ids_table
+};
+
+/* Local functions */
+static struct asd_softc	*asd_get_softc(struct asd_softc *asd);
+static int		asd_get_unit(void);
+static int		asd_register_host(struct asd_softc *asd);
+static void             __asd_unregister_host(struct asd_softc *asd);
+static int		asd_init_hw(struct asd_softc *asd);
+static int		asd_map_io_handle(struct asd_softc *asd);
+static int		asd_mem_mapped_io_handle(struct asd_softc *asd);
+static int		asd_io_mapped_io_handle(struct asd_softc *asd);
+
+/********************************* Inlines ************************************/
+
+static inline void	asd_init_tasklets(struct asd_softc *asd);
+static inline void	asd_kill_tasklets(struct asd_softc *asd);
+
+static inline void
+asd_init_tasklets(struct asd_softc *asd)
+{
+	tasklet_init(&asd->platform_data->runq_tasklet, asd_runq_tasklet,
+		     (unsigned long) asd);
+	tasklet_init(&asd->platform_data->unblock_tasklet, asd_unblock_tasklet,
+		     (unsigned long) asd);
+}
+
+static inline void
+asd_kill_tasklets(struct asd_softc *asd)
+{
+	tasklet_kill(&asd->platform_data->runq_tasklet);
+	tasklet_kill(&asd->platform_data->unblock_tasklet);
+}	
+
+struct asd_device *
+asd_get_device(struct asd_softc *asd, u_int ch, u_int id, u_int lun, int alloc)
+{
+	struct asd_domain	*dm;
+	struct asd_target	*targ;
+	struct asd_device	*dev;
+
+	ASD_LOCK_ASSERT(asd);
+
+	/*
+	 * Domain and target structures are allocated by our
+	 * discovery process.  Fail if our mapping attempt
+	 * finds either of these path components missing.
+	 */
+	if ((ch >= asd->platform_data->num_domains) || 
+	    ((dm = asd->platform_data->domains[ch]) == NULL)) {
+		return (NULL);
+	}
+
+	if ((id >= ASD_MAX_TARGETS) || 
+	    ((targ = dm->targets[id]) == NULL)) {
+		return (NULL);
+	}
+
+	if (lun >= ASD_MAX_LUNS) {
+		return (NULL);
+	}
+
+	dev = targ->devices[lun];
+
+	return (dev);
+}
+
+void
+asd_unmap_scb(struct asd_softc *asd, struct scb *scb)
+{
+	Scsi_Cmnd *cmd;
+	int direction;
+
+	cmd = &acmd_scsi_cmd(scb->io_ctx);
+	direction = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+
+	if (cmd->use_sg != 0) {
+		struct scatterlist *sg;
+
+		sg = (struct scatterlist *)cmd->request_buffer;
+		asd_unmap_sg(asd, sg, cmd->use_sg, direction);
+	} else if (cmd->request_bufflen != 0) {
+		asd_unmap_single(asd,
+				 scb->platform_data->buf_busaddr,
+				 cmd->request_bufflen, direction);
+	}
+}
+
+static inline void
+asd_check_device_queue(struct asd_softc *asd, struct asd_device *dev)
+{
+	ASD_LOCK_ASSERT(asd);
+
+	if ((dev->flags & ASD_DEV_FREEZE_TIL_EMPTY) != 0 && dev->active == 0) {
+		dev->flags &= ~ASD_DEV_FREEZE_TIL_EMPTY;
+		dev->qfrozen--;
+	}
+
+	if (list_empty(&dev->busyq) || dev->openings == 0 || 
+	    dev->qfrozen != 0 || dev->target->qfrozen != 0)
+		return;
+
+	asd_flush_device_queue(asd, dev);
+}
+
+inline void
+asd_run_device_queues(struct asd_softc *asd)
+{
+	struct asd_device *dev;
+
+	while ((dev = asd_next_device_to_run(asd)) != NULL) {
+		list_del(&dev->links);
+		dev->flags &= ~ASD_DEV_ON_RUN_LIST;
+		asd_check_device_queue(asd, dev);
+	}
+}
+
+static inline void asd_target_addref(struct asd_target *targ);
+static inline void asd_target_release(struct asd_softc *asd,
+				      struct asd_target *targ);
+static inline void asd_domain_addref(struct asd_domain *dm);
+static inline void asd_domain_release(struct asd_softc *asd,
+				      struct asd_target *targ);
+
+static inline void
+asd_target_addref(struct asd_target *targ)
+{
+	targ->refcount++;
+}
+
+static inline void
+asd_target_release(struct asd_softc *asd, struct asd_target *targ)
+{
+	targ->refcount--;
+	if (targ->refcount == 0) {
+		asd_free_target(asd, targ);
+	}
+}
+
+static inline void
+asd_domain_addref(struct asd_domain *dm)
+{
+	dm->refcount++;
+}
+
+static inline void
+asd_domain_release(struct asd_softc *asd, struct asd_target *targ)
+{
+	targ->domain->refcount--;
+
+	targ->domain->targets[targ->target] = NULL;
+
+	if (targ->domain->refcount == 0) {
+		asd_free_domain(asd, targ->domain);
+	}
+}
+
+/******************************************************************************/
+
+/* 
+ * Function:
+ *	asd_get_softc()
+ *
+ * Description:
+ *	Search if the requested host is in our HBA list. 
+ */
+static struct asd_softc	*
+asd_get_softc(struct asd_softc *asd) 
+{
+	struct asd_softc	*entry;
+	unsigned long		 flags;
+	
+	asd_list_lock(&flags);
+	list_for_each_entry(entry, &asd_hbas, link) {
+		if (entry == asd) {
+			asd_list_unlock(&flags);
+			return (asd);
+		}
+	}
+	asd_list_unlock(&flags);
+		
+	return (NULL);
+}
+
+/* 
+ * Function:
+ *	asd_get_softc_by_hba_index()
+ *
+ * Description:
+ *	Search and return the host corresponding to the user requested 
+ *	hba_index from our HBA list. 
+ */
+struct asd_softc *
+asd_get_softc_by_hba_index(uint32_t hba_index)
+{
+	struct asd_softc	*entry;
+	unsigned long		 flags;
+	
+	asd_list_lock(&flags);
+	list_for_each_entry(entry, &asd_hbas, link) {
+		if (entry->asd_hba_index == hba_index) {
+			asd_list_unlock(&flags);
+			return (entry);
+		}
+	}
+	asd_list_unlock(&flags);
+		
+	return (NULL);
+}
+
+/* 
+ * Function:
+ *	asd_get_number_of_hbas_present()
+ *
+ * Description:
+ *	Return the total number of SAS HBAs present
+ */
+int 
+asd_get_number_of_hbas_present(void)
+{
+	struct asd_softc	*entry;
+	unsigned long		 flags;
+	int hba_count;
+	
+	hba_count = 0;
+	asd_list_lock(&flags);
+	list_for_each_entry(entry, &asd_hbas, link) {
+		hba_count++;
+	}
+	asd_list_unlock(&flags);
+		
+	return hba_count;
+}
+
+/*
+ * Function:
+ * 	asd_get_unit()
+ *
+ * Description:
+ *	Find the smallest available unit number to use for a new device.
+ * 	Avoid using a static count to handle the "repeated hot-(un)plug"
+ * 	scenario.
+ */
+static int
+asd_get_unit(void)
+{
+	struct asd_softc	*asd;
+	unsigned long		 flags;
+	int			 unit;
+
+	unit = 0;
+	asd_list_lock(&flags);
+retry:
+	list_for_each_entry(asd, &asd_hbas, link) {
+		if (asd->profile.unit == unit) {
+			unit++;
+			goto retry;
+		}
+	}
+	asd_list_unlock(&flags);
+	return (unit);
+}
+
+static void
+asd_print_path(struct asd_softc *asd, struct asd_device *dev)
+{
+	if (dev != NULL)
+		asd_print("(scsi%d: Ch %d Id %d Lun %d): ",
+			  asd->platform_data->scsi_host->host_no,
+			  dev->ch, dev->id, dev->lun);
+}
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0) && !defined(MODULE)
+/*
+ * asd_setup_qtag_info
+ * This function interprets the cmd_per_lun setup parameter and sets
+ * its value internally.
+ */
+static void asd_setup_qtag_info(char *c)
+{
+	u_int	tags;
+
+	tags = simple_strtoul(c, NULL, 0) & (~0);
+
+	if (tags < ASD_MIN_TCQ_PER_DEVICE || tags > ASD_MAX_TCQ_PER_DEVICE) {
+		asd_print(ASD_DRIVER_NAME": cmd_per_lun:%d out of range,"
+			  " setting default:%d\n",tags,ASD_DEF_TCQ_PER_DEVICE);
+		tags = ASD_DEF_TCQ_PER_DEVICE;
+	} else {
+		asd_print(ASD_DRIVER_NAME": setting cmd_per_lun:%d\n", tags);
+	}
+
+	cmd_per_lun = tags;
+}
+
+static void
+asd_setup_debug_info(char *c)
+{
+	u_int 	dbg_mask;
+
+	dbg_mask = simple_strtoul(c, NULL, 0) & 0xFF;
+	asd_print("Setting the Debug Mask : 0x%x\n\n", dbg_mask);
+}
+
+/*
+ * Function:
+ *	adp94xx_setup()
+ *
+ * Description:
+ * 	Handle Linux boot parameters. This routine allows for assigning a value
+ * 	to a parameter with a ':' between the parameter and the value.
+ * 	ie. adp94xx=cmd_per_lun:32
+ */
+static int
+adp94xx_setup(char *s)
+{
+	char   *p;
+	char   *end;
+	int	i, n;
+
+	static struct {
+		const char 	*name;
+		uint32_t 	*flag;
+	} options[] = {
+		{ "attach_HostRAID", &attach_HostRAID },
+		{ "debug_mask", NULL },
+		{ "cmd_per_lun", NULL },
+	};
+
+	end = strchr(s, '\0');
+	n = 0;  
+
+	while ((p = strsep(&s, ",.")) != NULL) {
+		if (*p == '\0')
+			continue;
+		for (i = 0; i < NUM_ELEMENTS(options); i++) {
+
+			n = strlen(options[i].name);
+			if (strncmp(options[i].name, p, n) == 0)
+				break;
+		}
+		if (i == NUM_ELEMENTS(options))
+			continue;
+
+		if (strncmp(p, "cmd_per_lun", n) == 0) {
+			asd_setup_qtag_info(p + n + 1);
+		} else if (strncmp(p, "debug_mask", n) == 0) {
+			asd_setup_debug_info(p + n + 1);
+		} else if (p[n] == ':') {
+			*(options[i].flag) = simple_strtoul(p + n + 1, NULL,0);
+		} else {
+			*(options[i].flag) ^= 0xFFFFFFFF;
+		}
+	}
+	return (1);
+}
+#endif
+
+/* 
+ * Function:
+ *	asd_init()
+ *
+ * Description:
+ *	This is the entry point which will be called during module loading. 
+ */
+static int __init
+asd_init(void)
+{
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	asd_detect(&asd_sht);
+#else
+	scsi_register_module(MODULE_SCSI_HA, &asd_sht);
+#endif
+	if (asd_init_result != 0) {
+		asd_log(ASD_DBG_INIT, "Module init failed !\n");
+		asd_exit();
+		return (asd_init_result);
+	}
+
+	/* Register the IOCTL char device. */
+	if (asd_register_ioctl_dev() != 0) {
+		asd_log(ASD_DBG_INIT, "Failed to register IOCTL "
+			"dev.\n");
+		asd_exit();
+		asd_init_result = -1;
+	} else {
+		asd_init_stat.asd_ioctl_registered = 1;
+	}
+
+	return (asd_init_result);
+}
+
+/* 
+ * Function:
+ *	asd_exit()
+ *
+ * Description:
+ *	This is the entry point which will be called during module unloading. 
+ */
+static void
+asd_exit(void)
+{
+	struct asd_softc  *asd;
+
+	asd_log(ASD_DBG_INIT, "Unloading module ...\n");
+
+	list_for_each_entry(asd, &asd_hbas, link) {
+		asd_kill_discovery_thread(asd);
+
+		asd_kill_ehandler_thread(asd);
+#ifdef ASD_EH_SIMULATION		
+		asd_kill_eh_simul_thread(asd);
+#endif
+	}
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)	
+	scsi_unregister_module(MODULE_SCSI_HA, &asd_sht);
+#endif
+	if (asd_init_stat.asd_pci_registered == 1)
+		pci_unregister_driver(&adp94xx_pci_driver); 
+
+	if (asd_init_stat.asd_ioctl_registered == 1)
+		asd_unregister_ioctl_dev();
+	
+}
+
+/* 
+ * Function:
+ *	asd_aic9410_setup()
+ *
+ * Description:
+ *	Setup host profile initialization for the AIC9410 controller. 
+ */
+static int
+asd_aic9410_setup(struct asd_softc *asd)
+{
+	/*
+	 * max_cmds_per_lun will be throttled once we know the attached 
+	 * device is DASD.
+	 */
+	asd->profile.max_cmds_per_lun = 2;
+	asd->profile.can_queue = ASD_MAX_QUEUE;
+	asd->profile.initiator_id = 255;
+	asd->profile.max_luns = ASD_MAX_LUNS;
+	asd->profile.max_scsi_ids = ASD_MAX_TARGETS;
+	asd->profile.max_channels = ASD_MAX_PORTS;
+	/*
+	 * For now, we assumed that the controller can support 64-bit
+	 * addressing. 
+	 */
+	asd->profile.dma64_addr = 1;
+	asd->profile.name = ASD_DRIVER_NAME;
+		
+	/* Controller specific profile. */
+	asd->hw_profile.max_devices = ASD_MAX_DEVICES;
+	asd->hw_profile.max_targets = ASD_MAX_TARGETS;
+	asd->hw_profile.max_ports = ASD_MAX_PORTS;
+	asd->hw_profile.max_phys = ASD_MAX_PHYS;
+	/*
+	 * enabled_phys could be used as a bitmap for the user to specified 
+	 * which phys to be enabled.
+	 */ 
+	asd->hw_profile.enabled_phys = (1 << asd->hw_profile.max_phys) - 1; 
+	asd->hw_profile.max_scbs = ASD_MAX_USABLE_SCBS;
+	asd->hw_profile.max_ddbs = ASD_MAX_DDBS;	 
+	asd->hw_profile.rev_id = asd_pcic_read_byte(asd, PCIC_DEVREV_ID);
+
+	/* 
+	 * Default World Wide Name set for the Controller.
+	 */
+	asd->hw_profile.wwn[0] = 0x50;
+	asd->hw_profile.wwn[1] = 0x00;
+	asd->hw_profile.wwn[2] = 0x0d;
+	asd->hw_profile.wwn[3] = 0x1f;
+	asd->hw_profile.wwn[4] = 0xed;
+	asd->hw_profile.wwn[5] = 0xcb;
+	asd->hw_profile.wwn[6] = 0xa9;
+	asd->hw_profile.wwn[7] = 0x89;
+	return (0);
+}
+
+/*
+ * Function:
+ *	asd_size_nseg()
+ *
+ * Description:
+ *
+ * In pre-2.5.X...
+ * The midlayer allocates an S/G array dynamically when a command is issued
+ * using SCSI malloc.  This array, which is in an OS dependent format that
+ * must later be copied to our private S/G list, is sized to house just the
+ * number of segments needed for the current transfer.  Since the code that
+ * sizes the SCSI malloc pool does not take into consideration fragmentation
+ * of the pool, executing transactions numbering just a fraction of our
+ * concurrent transaction limit with list lengths aproaching AHC_NSEG will
+ * quickly depleat the SCSI malloc pool of usable space.  Unfortunately, the
+ * mid-layer does not properly handle this scsi malloc failures for the S/G
+ * array and the result can be a lockup of the I/O subsystem.  We try to size
+ * our S/G list so that it satisfies our drivers allocation requirements in
+ * addition to avoiding fragmentation of the SCSI malloc pool.
+ */
+static void
+asd_size_nseg(void)
+{
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+	u_int cur_size;
+	u_int best_size;
+
+	/*
+	 * The SCSI allocator rounds to the nearest 512 bytes
+	 * and cannot allocate across a page boundary.  Our algorithm
+	 * is to start at 1K of scsi malloc space per-command and
+	 * loop through all factors of the PAGE_SIZE and pick the best.
+	 */
+	best_size = 0;
+	for (cur_size = 1024; cur_size <= PAGE_SIZE; cur_size *= 2) {
+		u_int nseg;
+
+		nseg = cur_size / sizeof(struct scatterlist);
+		if (nseg < ASD_LINUX_MIN_NSEG)
+			continue;
+
+		if (best_size == 0) {
+			best_size = cur_size;
+			asd_nseg = nseg;
+		} else {
+			u_int best_rem;
+			u_int cur_rem;
+
+			/*
+			 * Compare the traits of the current "best_size"
+			 * with the current size to determine if the
+			 * current size is a better size.
+			 */
+			best_rem = best_size % sizeof(struct scatterlist);
+			cur_rem = cur_size % sizeof(struct scatterlist);
+			if (cur_rem < best_rem) {
+				best_size = cur_size;
+				asd_nseg = nseg;
+			}
+		}
+	}
+#endif
+}
+
+/* 
+ * Function:
+ *	asd_detect()
+ *
+ * Description:
+ *	This routine shall detect any supported controller. 
+ */
+static int
+asd_detect(Scsi_Host_Template *sht)
+{
+	struct asd_softc	*asd;
+	int			 error;
+	uint8_t 		 hba_cnt;
+
+	asd_print("Loading AIC-94xx Linux SAS/SATA Family Driver, Rev: %s\n\n",
+		  asd_driver_version);
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+	/*
+	 * Release the lock that was held by the midlayer prior to calling us.
+	 */
+	spin_unlock_irq(&io_request_lock);
+#endif
+	hba_cnt = 0;
+	asd_init_stat.asd_init_state = 1;
+
+	asd_list_lockinit();
+	/*
+	 * Determine an appropriate size for our SG lists.
+	 */
+	asd_size_nseg();
+
+	/* Register our PCI entry points and id table. */
+	error = pci_module_init(&adp94xx_pci_driver);
+	if (error != 0) {	
+		asd_init_result = error;
+		goto exit;
+	} else {
+		asd_init_stat.asd_pci_registered = 1;
+		asd_init_result = error;
+	}
+
+	/* For every controller found, register it with the midlayer. */
+	list_for_each_entry(asd, &asd_hbas, link) {
+		error = asd_register_host(asd);
+		if (error != 0) {
+			asd_init_result = error;
+			goto exit;
+		}
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+		error = asd_initiate_bus_scan(asd);
+		if (error != 0) {
+			struct pci_dev *pci_dev = asd_pci_dev(asd);
+			asd_print("%s: couldn't initiate bus scan for "
+				  "PCI device %x:%x.%x (%x:%x)\n",
+				  asd_name(asd),
+				  pci_dev->bus->number,
+				  PCI_SLOT(pci_dev->devfn),
+				  PCI_FUNC(pci_dev->devfn),
+				  pci_dev->vendor,
+				  pci_dev->device);
+			__asd_unregister_host(asd);
+			continue;
+		}
+#endif
+		asd->asd_hba_index = hba_cnt++;
+
+		asd_ctl_init_internal_data(asd);
+	}
+
+	asd_init_stat.asd_init_state = 0;
+
+exit:
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+	/* Acquire the lock before returning to midlayer. */
+	spin_lock_irq(&io_request_lock);
+#endif
+	asd_print("AIC-94xx controller(s) attached = %d.\n\n", hba_cnt);
+
+	return (hba_cnt);
+}
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+/* 
+ * Function:
+ *	asd_release()
+ *
+ * Description:
+ *	Free the Scsi_Host structure during unloading module. 
+ */
+static int
+asd_release(struct Scsi_Host *scsi_host)
+{
+	struct asd_softc	*asd;
+	unsigned long		 flags;
+
+	if (scsi_host != NULL) {
+		asd = *((struct asd_softc **) scsi_host->hostdata);
+		
+		if (asd_get_softc(asd) != NULL) {
+			asd_list_lock(&flags);
+			list_del(&asd->link);
+			asd_list_unlock(&flags);
+			asd_free_softc(asd);
+		}
+	}
+
+	return (0);
+}
+#endif
+
+/* 
+ * Function:
+ *	asd_register_host()
+ *
+ * Description:
+ *	Register our controller with the scsi midlayer. 
+ */
+static int		
+asd_register_host(struct asd_softc *asd)
+{
+	struct Scsi_Host	*scsi_host;
+	u_long			 flags;
+	
+	asd_sht.name = ((struct asd_pci_driver_data *) 
+			(asd->pci_entry->driver_data))->description;	
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	scsi_host = scsi_host_alloc(&asd_sht, sizeof(struct asd_softc *));
+#else
+	scsi_host = scsi_register(&asd_sht, sizeof(struct asd_softc *));
+#endif 
+	if (scsi_host == NULL)
+		return (-ENOMEM);
+	
+	*((struct asd_softc **) scsi_host->hostdata) = asd;
+	
+	asd_lock(asd, &flags);
+
+	/* Fill in host related fields. */
+	asd->platform_data->scsi_host = scsi_host;
+	scsi_host->can_queue = asd->profile.can_queue;
+	scsi_host->cmd_per_lun = asd->profile.max_cmds_per_lun;
+	scsi_host->sg_tablesize	= ASD_NSEG;
+	scsi_host->max_channel = asd->profile.max_channels;
+	scsi_host->max_id = asd->profile.max_scsi_ids;
+	scsi_host->max_lun = asd->profile.max_luns;
+	scsi_host->this_id = asd->profile.initiator_id;
+	scsi_host->unique_id = asd->profile.unit = asd_get_unit();
+	scsi_host->irq = asd->profile.irq;	
+	asd_assign_host_lock(asd);
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,4) && \
+    LINUX_VERSION_CODE  < KERNEL_VERSION(2,5,0)	
+	scsi_set_pci_device(scsi_host, asd->dev);
+#endif	
+	asd_unlock(asd, &flags);
+
+	/*
+	 * Create a discovery thread and block the OS
+	 * discovery of targets until our first discovery
+	 * pass has completed.
+	 */
+	asd_freeze_hostq(asd);
+	asd->platform_data->flags |= ASD_DISCOVERY_INIT;
+
+	asd->platform_data->discovery_pid = kernel_thread(
+						asd_discovery_thread, 
+						asd, 0);
+	if (asd->platform_data->discovery_pid < 0) {
+		asd_print("%s: Failed to create discovery thread, error=%d\n",
+			  asd_name(asd), asd->platform_data->discovery_pid);
+		return (-asd->platform_data->discovery_pid);
+	}
+
+	asd->platform_data->ehandler_pid = kernel_thread(
+						asd_ehandler_thread, 
+						asd, 0);
+	if (asd->platform_data->ehandler_pid < 0) {
+		asd_print("%s: Failed to create error handler thread, "
+			  "error=%d\n",
+			  asd_name(asd), asd->platform_data->ehandler_pid);
+		return (-asd->platform_data->ehandler_pid);
+	}
+
+#ifdef ASD_EH_SIMULATION		
+	asd->platform_data->eh_simul_pid = kernel_thread(
+						asd_eh_simul_thread, 
+						asd, 0);
+	if (asd->platform_data->eh_simul_pid < 0) {
+		asd_print("%s: Failed to create eh_simul thread, error=%d\n",
+			  asd_name(asd), asd->platform_data->eh_simul_pid);
+		return (-asd->platform_data->eh_simul_pid);
+	}
+#endif
+
+	return (0);
+}
+
+/*
+ * Function:
+ * __asd_unregister_host()
+ *
+ * Description:
+ * Revert what asd_register_host() did.  This function is to be used
+ * from asd_detect().
+ */
+static void __asd_unregister_host(struct asd_softc *asd)
+{
+#ifdef ASD_EH_SIMULATION
+	/* shutdown the simulation thread */
+	asd->platform_data->flags |= ASD_EH_SIMUL_SHUTDOWN;
+	up(&asd->platform_data->eh_simul_sem);
+#endif /* ASD_EH_SIMULATION */
+
+	/* shutdown the eh and discovery thread */
+	asd->platform_data->flags |=
+		(ASD_RECOVERY_SHUTDOWN | ASD_DISCOVERY_SHUTDOWN);
+	up(&asd->platform_data->ehandler_sem);
+	up(&asd->platform_data->discovery_sem);
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	scsi_remove_host(asd->platform_data->scsi_host);
+	scsi_host_put(asd->platform_data->scsi_host);
+#else
+	scsi_unregister(asd->platform_data->scsi_host);
+#endif 
+}
+
+/***************************** Queue Handling ********************************/
+
+struct asd_device *
+asd_alloc_device(struct asd_softc *asd, struct asd_target *targ,
+		 u_int ch, u_int id, u_int lun)
+{
+	struct asd_device *dev;
+
+	dev = asd_alloc_mem(sizeof(*dev), GFP_ATOMIC);
+	if (dev == NULL)
+		return (NULL);
+
+	memset(dev, 0, sizeof(*dev));
+	init_timer(&dev->timer);
+	INIT_LIST_HEAD(&dev->busyq);
+	dev->flags = ASD_DEV_UNCONFIGURED;
+	dev->ch = ch;
+	dev->id = id;
+	dev->lun = lun;
+	memcpy(dev->saslun, &lun, sizeof(u_int)/*8*/);//TBD
+	dev->target = targ;
+#ifdef MULTIPATH_IO
+	dev->current_target = targ;
+#endif
+
+	/*
+	 * We start out life using untagged
+	 * transactions of which we allow one.
+	 */
+	dev->openings = 1;
+
+	/*
+	 * Set maxtags to 0.  This will be changed if we
+	 * later determine that we are dealing with
+	 * a tagged queuing capable device.
+	 */
+	dev->maxtags = 0;
+	
+	targ->devices[lun] = dev;
+	asd_target_addref(targ);
+
+	return (dev);
+}
+
+void
+asd_free_device(struct asd_softc *asd, struct asd_device *dev)
+{
+	struct asd_target *targ;
+
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,41)
+	/*
+	 * Ensure no scheduled workqueue entry is running for
+	 * this device prior freeing the device.
+	 */
+	if ((dev->flags & ASD_DEV_DPC_ACTIVE) != 0)
+		flush_scheduled_work();
+#endif	
+	targ = dev->target;
+	targ->devices[dev->lun] = NULL;
+	asd_free_mem(dev);
+	asd_target_release(asd, targ);
+	targ->flags &= ~ASD_TARG_MAPPED;
+}
+
+struct asd_target *
+asd_alloc_target(struct asd_softc *asd, struct asd_port *src_port)
+{
+	struct asd_target *targ;
+
+	targ = asd_alloc_mem(sizeof(*targ), GFP_ATOMIC);
+	if (targ == NULL)
+		return (NULL);
+	memset(targ, 0, sizeof(*targ));
+
+	/*
+	 * By default, we are not mapped into
+	 * the OS topology view.
+	 */
+	targ->domain = NULL;
+	targ->target = ASD_MAX_TARGETS;
+
+	/*
+	 * Targets stay around until some event drops
+	 * the sentinel reference count on the object.
+	 */
+	targ->refcount = 0;
+
+	targ->softc = asd;
+	targ->flags |= ASD_TARG_FLAGS_NONE;
+	targ->src_port = src_port;
+	INIT_LIST_HEAD(&targ->children);
+	INIT_LIST_HEAD(&targ->siblings);
+	INIT_LIST_HEAD(&targ->all_domain_targets);
+	INIT_LIST_HEAD(&targ->validate_links);
+	INIT_LIST_HEAD(&targ->multipath);
+	init_timer(&targ->timer);
+	return (targ);
+}
+
+void
+asd_free_target(struct asd_softc *asd, struct asd_target *targ)
+{
+	list_del(&targ->children);
+	list_del(&targ->siblings);
+	list_del(&targ->multipath);
+	list_del(&targ->all_domain_targets);
+
+	if (targ->domain != NULL) {
+		asd_domain_release(asd, targ);
+		targ->domain = NULL;
+	}
+
+	if (targ->Phy != NULL) {
+		asd_free_mem(targ->Phy);
+	}
+
+	if (targ->RouteTable != NULL) {
+		asd_free_mem(targ->RouteTable);
+	}
+
+	asd_free_mem(targ);
+}
+
+static struct asd_domain *
+asd_alloc_domain(struct asd_softc *asd, u_int channel_mapping)
+{
+	struct asd_domain *dm;
+
+	dm = asd_alloc_mem(sizeof(*dm), GFP_ATOMIC);
+	if (dm == NULL)
+		return (NULL);
+
+	memset(dm, 0, sizeof(*dm));
+	asd->platform_data->domains[channel_mapping] = dm;
+	dm->channel_mapping = channel_mapping;
+
+	dm->refcount = 0;
+
+	return (dm);
+}
+
+static void
+asd_free_domain(struct asd_softc *asd, struct asd_domain *dm)
+{
+	u_int i;
+
+	for (i = 0; i < ASD_MAX_TARGETS; i++) {
+		if (dm->targets[i] != NULL) {
+			asd_print("%s: Freeing non-empty domain %p!\n",
+				  asd_name(asd), dm);
+			break;
+		}
+	}
+	asd->platform_data->domains[dm->channel_mapping] = NULL;
+	asd_free_mem(dm);
+}
+
+static void
+asd_flush_device_queue(struct asd_softc *asd, struct asd_device *dev)
+{
+	union asd_cmd 		*acmd;
+	struct scsi_cmnd 	*cmd;
+	struct scb 		*scb;
+	struct asd_port		*port;
+	ASD_COMMAND_BUILD_STATUS build_status;
+
+	ASD_LOCK_ASSERT(asd);
+
+	if ((dev->flags & ASD_DEV_ON_RUN_LIST) != 0)
+		panic("asd_flush_device_queue: running device on run list");
+
+	while (!list_empty(&dev->busyq) && (dev->openings > 0) && 
+	       (dev->qfrozen == 0) && (dev->target->qfrozen == 0)) {
+
+		if (asd->platform_data->qfrozen != 0) {
+			/*
+			 * Schedule us to run later.  The only reason we are not
+			 * running is because the whole controller Q is frozen.
+			 */
+			list_add_tail(&dev->links,
+				      &asd->platform_data->device_runq);
+			dev->flags |= ASD_DEV_ON_RUN_LIST;
+			return;
+		}
+
+		port = dev->target->src_port;
+		if (((port->events & ASD_DISCOVERY_PROCESS) != 0) && 
+		    ((port->events & ASD_DISCOVERY_REQ) != 0) &&
+		    ((port->events & ASD_VALIDATION_REQ) != 0)) {
+			/*
+			 * Discovery is requested / on-going for the port
+			 * that the device is currently attached to.
+			 * Prevent any new IOs going to the device until
+			 * the discovery is done and configuration is
+			 * validated.
+			 */
+			list_add_tail(&dev->links,
+				      &asd->platform_data->device_runq);
+			dev->flags |= ASD_DEV_ON_RUN_LIST;
+			return;
+		}
+
+		acmd = list_entry(dev->busyq.next, union asd_cmd, acmd_links);
+		list_del(&acmd->acmd_links);
+		cmd = &acmd_scsi_cmd(acmd);
+
+		/*
+		 * The target is in the process of being destroyed as
+		 * it had been hot-removed. Return the IO back to the
+		 * scsi layer.
+		 */
+		if (dev->target->flags & ASD_TARG_HOT_REMOVED) {
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+			asd_cmd_set_host_status(cmd, DID_NO_CONNECT);
+#else
+			asd_cmd_set_offline_status(cmd);
+#endif
+			cmd->scsi_done(cmd);
+			continue;
+		}
+
+		if (cmd->sc_magic != ASD_CSMI_COMMAND) {
+			/*
+			 * Get an scb to use.
+			 */
+			if ((scb = asd_hwi_get_scb(asd, 0)) == NULL) {
+				list_add_tail(&acmd->acmd_links, &dev->busyq);
+				list_add_tail(&dev->links,
+					      &asd->platform_data->device_runq);
+				dev->flags |= ASD_DEV_ON_RUN_LIST;
+				asd->flags |= ASD_SCB_RESOURCE_SHORTAGE;
+				asd->platform_data->qfrozen++;
+				return;
+			}
+
+			scb->platform_data->dev = dev;
+			scb->platform_data->targ = dev->target;
+			cmd->host_scribble = (char *)scb;
+			/*
+			 * SCB build handlers return zero status to indicate
+			 * that the SCB should be queued to the controller.
+			 * Any other status indicates that the OS's cmd
+			 * structure should be completed and that the build
+			 * handler has updated its status accordingly.
+			 */
+			switch (dev->target->command_set_type) {
+			case ASD_COMMAND_SET_SCSI:
+				build_status = asd_build_sas_scb(
+					asd, scb, acmd);
+				break;
+
+			case ASD_COMMAND_SET_ATA:
+				build_status = asd_build_ata_scb(
+					asd, scb, acmd);
+				break;
+
+			case ASD_COMMAND_SET_ATAPI:
+				build_status = asd_build_atapi_scb(
+					asd, scb, acmd);
+				break;
+
+			default:
+				build_status = ASD_COMMAND_BUILD_FAILED;
+				asd_cmd_set_host_status(cmd, DID_NO_CONNECT);
+
+				/*
+				 * Fall through to complete and free the scb.
+				 */
+				break;
+			}
+
+			if (build_status != ASD_COMMAND_BUILD_OK) {
+				/*
+				 * Two cases here:
+				 * 1) The command has been emulated, and it
+				 *    is ASD_COMMAND_BUILD_FINISHED
+				 * 2) The command was malformed and it is
+				 *    ASD_COMMAND_BUILD_FAILED.
+				 */
+				asd_hwi_free_scb(asd, scb);
+				cmd->scsi_done(cmd);
+				continue;
+			}
+		} else {
+			/* command generated by CSMI */
+			scb = (struct scb *)cmd->host_scribble;
+		}
+
+		dev->openings--;
+		dev->active++;
+		dev->commands_issued++;
+		list_add_tail(&scb->owner_links,
+			      &asd->platform_data->pending_os_scbs);
+		scb->flags |= SCB_ACTIVE;
+		asd_hwi_post_scb(asd, scb);
+
+#ifdef ASD_EH_SIMULATION
+		if (asd_cmd_get_host_status(cmd) == 0x88) {
+			scb->flags |= SCB_TIMEDOUT;
+			scb->eh_state = SCB_EH_DEV_RESET_REQ;
+			scb->eh_post = asd_eh_simul_done;
+			list_add_tail(&scb->timedout_links, 
+				      &asd->timedout_scbs);
+			asd_print("Adding scb(%d) to timedout queue for "
+				  "error recv. simulation.\n",
+				  SCB_GET_INDEX(scb));
+			asd_wakeup_sem(&asd->platform_data->ehandler_sem);
+		}
+#endif /* ASD_EH_SIMULATION */
+		if (cmd->sc_magic == ASD_CSMI_COMMAND)
+			asd_free_mem(cmd);
+	}
+
+}
+
+#ifdef ASD_EH_SIMULATION
+static void
+asd_eh_simul_done(struct asd_softc *asd, struct scb *scb)
+{
+	asd_print("EH SIMULATION DONE.\n");
+}
+
+static int
+asd_eh_simul_thread(void *data)
+{
+	struct asd_softc	*asd;
+	struct scb		*scb;
+	u_long			 flags;	
+
+	asd = (struct asd_softc *) data;
+
+	lock_kernel();
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,60)
+	/*
+	 * Don't care about any signals.
+	 */
+	siginitsetinv(&current->blocked, 0);
+	daemonize();
+	sprintf(current->comm, "asd_eh_simul_%d", asd->profile.unit);
+#else
+	daemonize("asd_eh_simul_%d", asd->profile.unit);
+	current->flags |= PF_FREEZE;	
+#endif
+	unlock_kernel();
+
+	while (1) {
+sleep:
+		down_interruptible(&asd->platform_data->eh_simul_sem);
+
+		/* Check to see if we've been signaled to exit. */
+		asd_lock(asd, &flags);
+		if ((asd->platform_data->flags & ASD_EH_SIMUL_SHUTDOWN) != 0) {
+			asd_unlock(asd, &flags);
+			break;
+		}
+
+		asd_unlock(asd, &flags);
+		
+		if (!list_empty(&asd->timedout_scbs)) {
+			scb = list_entry(asd->timedout_scbs.next, struct scb, 
+				 timedout_links);
+			if (scb == NULL) {
+				asd_print("Timedout queue is empty.\n");
+				goto sleep;
+			}
+
+			asd_lock(asd, &flags);
+
+			list_del(&scb->timedout_links);
+			scb->flags &= ~SCB_TIMEDOUT;
+		
+			asd_unlock(asd, &flags);
+		}
+	}
+
+	return (0);
+}
+#endif /* ASD_EH_SIMULATION */
+
+static void
+asd_dev_timed_unfreeze(u_long arg)
+{
+	struct asd_softc	*asd;
+	struct asd_device	*dev;
+	u_long			 flags;
+
+	dev = (struct asd_device *) arg;
+	asd = dev->target->softc;
+	
+	asd_lock(asd, &flags);
+	/*
+	 * Release our hold on the device.
+	 */
+	dev->flags &= ~ASD_DEV_TIMER_ACTIVE;
+	dev->active--;
+
+	if (dev->qfrozen > 0)
+		dev->qfrozen--;
+
+	if ((dev->qfrozen == 0) && (dev->target->qfrozen == 0) &&
+	    ((dev->flags & ASD_DEV_ON_RUN_LIST) == 0))
+		asd_flush_device_queue(asd, dev);
+	
+	if ((dev->flags & ASD_DEV_UNCONFIGURED) != 0 &&
+	     list_empty(&dev->busyq) && dev->active == 0) {
+		asd_free_device(asd, dev);
+	}
+	asd_unlock(asd, &flags);
+}
+
+void
+asd_timed_run_dev_queue(u_long arg)
+{
+	struct asd_softc	*asd;
+	struct asd_device	*dev;
+	u_long			 flags;
+
+	dev = (struct asd_device *) arg;
+	asd = dev->target->softc;
+	
+	asd_lock(asd, &flags);
+
+	dev->flags &= ~ASD_DEV_TIMER_ACTIVE;
+
+	if ((dev->qfrozen == 0) && (dev->target->qfrozen == 0) &&
+	    ((dev->target->flags & ASD_TARG_HOT_REMOVED) == 0) &&
+	    ((dev->flags & ASD_DEV_ON_RUN_LIST) == 0)) {
+
+		asd_flush_device_queue(asd, dev);
+	} else {
+		asd_log(ASD_DBG_ERROR, "DEV QF: %d TARG QF: %d "
+			"DEV FL: 0x%x TARG FL: 0x%x.\n",
+			dev->qfrozen, dev->target->qfrozen,
+			dev->flags, dev->target->flags);
+	}
+
+	asd_unlock(asd, &flags);
+}
+	
+static void
+asd_scb_done(struct asd_softc *asd, struct scb *scb, struct asd_done_list *dl)
+{
+	Scsi_Cmnd 		*cmd;
+	struct asd_device *dev;
+
+	if ((scb->flags & SCB_ACTIVE) == 0) {
+		asd_print("SCB %d done'd twice\n", SCB_GET_INDEX(scb));
+		panic("Stopping for safety");
+	}
+
+	list_del(&scb->owner_links);
+
+	cmd = &acmd_scsi_cmd(scb->io_ctx);
+	dev = scb->platform_data->dev;
+	dev->active--;
+	dev->openings++;
+	if ((scb->flags & SCB_DEV_QFRZN) != 0) {
+		scb->flags &= ~SCB_DEV_QFRZN;
+		dev->qfrozen--;
+	}
+
+	asd_unmap_scb(asd, scb);
+
+	/*
+	 * Guard against stale sense data.
+	 * The Linux mid-layer assumes that sense
+	 * was retrieved anytime the first byte of
+	 * the sense buffer looks "sane".
+	 */
+	cmd->sense_buffer[0] = 0;
+	cmd->resid = 0;
+
+	switch (dl->opcode) {
+	case TASK_COMP_W_UNDERRUN:
+		cmd->resid = asd_le32toh(dl->stat_blk.data.res_len);
+		/* FALLTHROUGH */
+	case TASK_COMP_WO_ERR:
+		asd_cmd_set_host_status(cmd, DID_OK);
+		break;
+	
+	case SSP_TASK_COMP_W_RESP:
+	{
+		union edb 		*edb;
+		struct response_sb   	*rsp;
+		struct ssp_resp_edb  	*redb;
+		struct scb 		*escb;
+		u_int  			 escb_index;
+		u_int			 edb_index;
+
+		rsp = &dl->stat_blk.response;
+		escb_index = asd_le16toh(rsp->empty_scb_tc);
+		edb_index = RSP_EDB_ELEM(rsp) - 1;
+		edb = asd_hwi_indexes_to_edb(asd, &escb, escb_index, edb_index);
+		if (edb == NULL) {
+			asd_print("Invalid EDB recv for SSP comp w/response.\n"
+				  "Returning generic error to OS.\n");
+			asd_cmd_set_host_status(cmd, DID_ERROR);
+			break;
+		}
+		redb = &edb->ssp_resp;
+		cmd->resid = asd_le32toh(redb->res_len);
+		asd_handle_sas_status(asd, dev, scb, redb, RSP_EDB_BUFLEN(rsp));
+		asd_hwi_free_edb(asd, escb, edb_index);
+		break;
+	}
+	
+	case TASK_ABORTED_ON_REQUEST:
+		asd_cmd_set_host_status(cmd, DID_ABORT);
+		break;
+	
+	case TASK_CLEARED:
+	{
+		struct task_cleared_sb	*task_clr;
+
+		task_clr = &dl->stat_blk.task_cleared;
+
+		asd_log(ASD_DBG_ERROR," Task Cleared for Tag: 0x%x, "
+			"TC: 0x%x.\n",
+			task_clr->tag_of_cleared_task, SCB_GET_INDEX(scb));
+
+		/*
+		 * Pending command at the firmware's queues aborted upon
+		 * request. If the device is offline then failed the IO.
+		 * Otherwise, have the command retried again.
+	         */
+		if (task_clr->clr_nxs_ctx == ASD_TARG_HOT_REMOVED) {
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+			asd_cmd_set_host_status(cmd, DID_NO_CONNECT);
+#else
+			asd_cmd_set_offline_status(cmd);
+#endif
+		} else
+			asd_cmd_set_host_status(cmd, DID_SOFT_ERROR);
+
+		break;
+	}
+
+	case TASK_INT_W_BRK_RCVD:
+		asd_log(ASD_DBG_ERROR, "TASK INT. WITH BREAK RECEIVED.\n");
+		asd_cmd_set_host_status(cmd, DID_SOFT_ERROR);
+		break;
+
+	case TASK_ABORTED_BY_ITNL_EXP:
+	{
+		struct itnl_exp_sb	*itnl_exp;
+
+		itnl_exp = &dl->stat_blk.itnl_exp;
+
+		asd_log(ASD_DBG_ERROR, "ITNL EXP for SCB 0x%x Reason = 0x%x.\n",
+			SCB_GET_INDEX(scb), itnl_exp->reason);
+		
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+		asd_cmd_set_host_status(cmd, DID_NO_CONNECT);
+#else
+		asd_cmd_set_offline_status(cmd);
+#endif
+		break;
+	}
+
+	case TASK_F_W_NAK_RCVD:
+		asd_log(ASD_DBG_ERROR, "TASK FAILED WITH NAK RECEIVED.\n");
+		asd_cmd_set_host_status(cmd, DID_SOFT_ERROR);
+		break;
+
+	default:
+		asd_log(ASD_DBG_ERROR, "UNHANDLED TASK.\n");
+		asd_cmd_set_host_status(cmd, DID_SOFT_ERROR);
+		break;
+	}
+
+	if ((dev->target->flags & ASD_TARG_HOT_REMOVED) != 0) {
+		/*
+	 	 * If the target had been removed and all active IOs on 
+		 * the device have been completed, schedule the device to
+		 * be destroyed.
+	 	 */
+		if (list_empty(&dev->busyq) && (dev->active == 0) &&
+		   ((dev->flags & ASD_DEV_DESTROY_WAS_ACTIVE) != 0)) {
+			/*
+			 * Schedule a deferred process task to destroy
+		         * the device.
+			 */	 
+			asd_setup_dev_dpc_task(dev, asd_destroy_device);
+		}
+	} else {
+		if ((dev->flags & ASD_DEV_ON_RUN_LIST) == 0) {
+			list_add_tail(&dev->links,
+				      &asd->platform_data->device_runq);
+			dev->flags |= ASD_DEV_ON_RUN_LIST;
+		}
+	}
+
+	/*
+	 * Only free the scb if it hasn't timedout.
+	 * For SCB that has timedout, error recovery has invoked and
+	 * the timedout SCB will be freed in the error recovery path.
+	 */
+	if ((scb->flags & SCB_TIMEDOUT) == 0)
+		asd_hwi_free_scb(asd, scb);
+	
+	cmd->scsi_done(cmd);
+}
+
+void
+asd_scb_internal_done(struct asd_softc *asd, struct scb *scb,
+		      struct asd_done_list *dl)
+{
+	if ((scb->flags & SCB_ACTIVE) == 0) {
+		asd_print("SCB %d done'd twice\n", SCB_GET_INDEX(scb));
+		panic("Stopping for safety");
+	}
+
+	list_del(&scb->owner_links);
+
+	/*
+	 * In this case, "internal" means that the scb does not have
+	 * a Scsi_Cmnd associated with it.
+	 */
+	if ((scb->flags & SCB_INTERNAL) == 0) {
+		asd_unmap_scb(asd, scb);
+	}
+
+	switch (dl->opcode) {
+	case TASK_COMP_W_UNDERRUN:
+		/* FALLTHROUGH */
+	case TASK_COMP_WO_ERR:
+		break;
+	case SSP_TASK_COMP_W_RESP:
+	{
+		union	edb *edb;
+		struct	response_sb   *rsp;
+		struct	ssp_resp_edb  *redb;
+		struct	scb *escb;
+		u_int	escb_index;
+		u_int	edb_index;
+
+		rsp = &dl->stat_blk.response;
+		escb_index = asd_le16toh(rsp->empty_scb_tc);
+		edb_index = RSP_EDB_ELEM(rsp) - 1;
+		edb = asd_hwi_indexes_to_edb(asd, &escb, escb_index, edb_index);
+		if (edb == NULL) {
+			asd_print("Invalid EDB recv for SSP comp w/response.\n"
+				  "Returning generic error to OS.\n");
+			break;
+		}
+		redb = &edb->ssp_resp;
+		asd_hwi_free_edb(asd, escb, edb_index);
+	}
+	default:
+		break;
+	}
+
+	/*
+	 * Only free the scb if it hasn't timedout.
+	 * For SCB that has timedout, error recovery has invoked and
+	 * the timedout SCB will be freed in the error recovery path.
+	 */
+	if ((scb->flags & SCB_TIMEDOUT) == 0)
+		asd_hwi_free_scb(asd, scb);
+}
+
+static void
+asd_handle_sas_status(struct asd_softc *asd, struct asd_device *dev,
+		      struct scb *scb, struct ssp_resp_edb *edb, u_int edb_len)
+{
+	struct ssp_resp_iu 	*riu;
+	Scsi_Cmnd 		*cmd;
+
+	cmd = &acmd_scsi_cmd(scb->io_ctx);
+	riu = &edb->resp_frame.riu;
+	if (edb_len < offsetof(struct ssp_resp_edb, resp_frame.riu.res_2)) {
+		asd_print("Insufficient data recv for SSP comp w/response.\n"
+			  "Returning generic error to OS.\n");
+		asd_cmd_set_host_status(cmd, DID_ERROR);
+		return;
+	}
+
+	switch (SSP_RIU_DATAPRES(riu)) {
+	case SSP_RIU_DATAPRES_RESP:
+	{
+		uint8_t	resp_code;
+
+		resp_code = ((struct resp_data_iu *) &riu->data[0])->resp_code;
+
+		asd_print("Unhandled RESPONSE data (resp code: 0x%x).\n"
+			  "Returning generic error to OS.\n",
+			  resp_code);
+		asd_cmd_set_host_status(cmd, DID_SOFT_ERROR);
+		return;
+	}
+
+	case SSP_RIU_DATAPRES_SENSE:
+	{
+		uint32_t sense_len;
+
+		/* Copy sense data. */
+		if (edb_len < offsetof(struct ssp_resp_edb,
+				       resp_frame.riu.sense_len)) {
+			asd_print("Insufficient data recv for sense len.\n"
+				  "Returning generic error to OS.\n");
+			asd_cmd_set_host_status(cmd, DID_SOFT_ERROR);
+			return;
+		}
+		sense_len = edb_len - offsetof(struct ssp_resp_edb,
+					       resp_frame.riu.data);
+		sense_len = MIN(sense_len, scsi_4btoul(riu->sense_len));
+		if (sense_len <= 0) {
+			asd_print("Insufficient data recv for sense data.\n"
+				  "Returning generic error to OS.\n");
+			asd_cmd_set_host_status(cmd, DID_SOFT_ERROR);
+			return;
+		}
+		sense_len = MIN(sizeof(cmd->sense_buffer), sense_len);
+		memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
+		memcpy(cmd->sense_buffer, riu->data, sense_len);
+		asd_cmd_set_driver_status(cmd, DRIVER_SENSE);
+
+		/*
+		 * Power on reset or bus reset occurred, let's have the 
+		 * command retried again.
+		 */ 
+		if ((cmd->sense_buffer[2] == UNIT_ATTENTION) && 
+		    (cmd->sense_buffer[12] == 0x29)) {
+			asd_cmd_set_host_status(cmd, DID_ERROR);
+			break;
+		}
+	}
+		/* FALLTHROUGH*/
+	case SSP_RIU_DATAPRES_NONE:
+		asd_cmd_set_host_status(cmd, DID_OK);
+		asd_cmd_set_scsi_status(cmd, riu->status);
+		break;
+
+	default:
+		asd_log(ASD_DBG_ERROR, "Unknown response frame format.\n"
+			"Returning generic error to OS.\n");
+		asd_cmd_set_host_status(cmd, DID_SOFT_ERROR);
+		return;
+	}
+
+	/*
+	 * We don't currently trust the mid-layer to
+	 * properly deal with queue full or busy.  So,
+	 * when one occurs, we tell the mid-layer to
+	 * unconditionally requeue the command to us
+	 * so that we can retry it ourselves.  We also
+	 * implement our own throttling mechanism so
+	 * we don't clobber the device with too many
+	 * commands.
+	 */
+	switch (riu->status) {
+	case SCSI_STATUS_OK:
+	case SCSI_STATUS_CHECK_COND:
+	case SCSI_STATUS_COND_MET:
+	case SCSI_STATUS_INTERMED:
+	case SCSI_STATUS_INTERMED_COND_MET:
+	case SCSI_STATUS_RESERV_CONFLICT:
+	case SCSI_STATUS_CMD_TERMINATED:
+	case SCSI_STATUS_ACA_ACTIVE:
+	case SCSI_STATUS_TASK_ABORTED:
+		break;
+
+	case SCSI_STATUS_QUEUE_FULL:
+	{
+		/*
+		 * Note that dev->active may not be 100% accurate
+		 * since it counts commands in the outgoing SCB queue
+		 * that have yet to be seen by the end device.  In
+		 * practice, this doesn't matter since we will not queue
+		 * additional commands until we receive a successful
+		 * completion.  If we have not dropped the count to
+		 * the device's queue depth yet, we will see additional
+		 * queue fulls as the outgoing SCB queue drains, resulting
+		 * in further drops of the queue depth.
+		 */
+		asd_print_path(asd, dev);
+		asd_print("Queue Full!\n");
+		
+		dev->tag_success_count = 0;
+		if (dev->active != 0) {
+			/*
+			 * Drop our opening count to the number
+			 * of commands currently outstanding.
+			 */
+			dev->openings = 0;
+			asd_print_path(asd, dev);
+			asd_print("Dropping tag count to %d\n", dev->active);
+			if (dev->active == dev->tags_on_last_queuefull) {
+				dev->last_queuefull_same_count++;
+				/*
+				 * If we repeatedly see a queue full
+				 * at the same queue depth, this
+				 * device has a fixed number of tag
+				 * slots.  Lock in this tag depth
+				 * so we stop seeing queue fulls from
+				 * this device.
+				 */
+				if (dev->last_queuefull_same_count == 
+				    ASD_LOCK_TAGS_COUNT) {
+					dev->maxtags = dev->active;
+					asd_print_path(asd, dev);
+					asd_print("Locking tag count at %d\n",
+						  dev->active);
+				}
+			} else {
+				dev->tags_on_last_queuefull = dev->active;
+				dev->last_queuefull_same_count = 0;
+			}
+			
+			asd_set_tags(asd, dev,
+				    (dev->flags & ASD_DEV_Q_BASIC) ?
+				    ASD_QUEUE_BASIC : ASD_QUEUE_TAGGED);
+
+			asd_cmd_set_retry_status(cmd);
+			break;
+		}
+		/*
+		 * Drop down to a single opening, and treat this
+		 * as if the target returned BUSY SCSI status.
+		 */
+		dev->openings = 1;
+		asd_cmd_set_scsi_status(cmd, SCSI_STATUS_BUSY);
+		/* FALLTHROUGH */
+	}
+	case SCSI_STATUS_BUSY:
+		asd_log(ASD_DBG_ERROR, "REVISITED: SCSI_STATUS_BUSY");
+
+		/*
+		 * Set a short timer to defer sending commands for
+		 * a bit since Linux will not delay in this case.
+		 */
+		if ((dev->flags & ASD_DEV_TIMER_ACTIVE) != 0) {
+			asd_print("%s:%c:%d: Device Timer still active during "
+				  "busy processing\n", asd_name(asd),
+				  dev->target->domain->channel_mapping,
+				  dev->target->target);
+			break;
+		}
+		dev->qfrozen++;
+		/*
+		 * Keep the active count non-zero during
+		 * the lifetime of the timer.  This
+		 * guarantees that the device will not
+		 * be freed before our timer executes.
+		 */
+		dev->active++;
+		dev->flags |= ASD_DEV_TIMER_ACTIVE;
+		init_timer(&dev->timer);
+		dev->timer.data = (u_long) dev;
+		dev->timer.expires = jiffies + (HZ/2);
+		dev->timer.function = asd_dev_timed_unfreeze;
+		add_timer(&dev->timer);
+		break;
+	default:
+		/*
+		 * Unknown scsi status returned by the target.
+		 *  Have the command retried.
+		 */ 
+		asd_cmd_set_host_status(cmd, DID_SOFT_ERROR);
+		break;
+	}
+}

