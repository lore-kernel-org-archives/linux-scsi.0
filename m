From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic94xx: move entirely over to correct transport class
	formulation
Date: Mon, 27 Mar 2006 16:45:34 -0600
Message-ID: <1143499534.3334.33.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:61374 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751208AbWC0Wpg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 17:45:36 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k2RMjY220722
	for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2006 17:45:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This patch moves the sas class over to being a transport class (the sas
event functions now become transport functions) and the aic94xx now sets
everything up in the standard transport class way.

I've also fixed the multiple instance problem and verified that two
cards in the same box work.

James

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 53d5a0e..d0210dc 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -58,7 +58,9 @@ MODULE_PARM_DESC(collector, "\n"
 
 char sas_addr_str[2*SAS_ADDR_SIZE + 1] = "";
 
-static const struct scsi_host_template aic94xx_sht = {
+static struct scsi_transport_template *aic94xx_transport_template;
+
+static struct scsi_host_template aic94xx_sht = {
 	.module			= THIS_MODULE,
 	/* .name is initialized */
 	.name			= "aic94xx",
@@ -70,11 +72,11 @@ static const struct scsi_host_template a
 	.change_queue_depth	= sas_change_queue_depth,
 	.change_queue_type	= sas_change_queue_type,
 	.bios_param		= sas_bios_param,
-	/* .can_queue is initialized */
+	.can_queue		= 1,
+	.cmd_per_lun		= 1,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
-	/* .cmd_per_lun is initilized to .can_queue */
 	.use_clustering		= ENABLE_CLUSTERING,
 };
 
@@ -480,9 +482,16 @@ static void asd_destroy_global_caches(vo
 static int asd_register_sas_ha(struct asd_ha_struct *asd_ha)
 {
 	int i;
-	/* FIXME: this would screw up on >1 aic94xx card */
-	static struct asd_sas_phy   *sas_phys[ASD_MAX_PHYS];
-	static struct sas_port  *sas_ports[ASD_MAX_PHYS];
+	struct asd_sas_phy   **sas_phys =
+		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_phy), GFP_KERNEL);
+	struct sas_port  **sas_ports =
+		kmalloc(ASD_MAX_PHYS * sizeof(struct sas_port), GFP_KERNEL);
+
+	if (!sas_phys || !sas_ports) {
+		kfree(sas_phys);
+		kfree(sas_ports);
+		return -ENOMEM;
+	}
 
 	asd_ha->sas_ha.sas_ha_name = (char *) asd_ha->name;
 	asd_ha->sas_ha.lldd_module = THIS_MODULE;
@@ -497,34 +506,25 @@ static int asd_register_sas_ha(struct as
 	asd_ha->sas_ha.sas_port= sas_ports;
 	asd_ha->sas_ha.num_phys= ASD_MAX_PHYS;
 
-	asd_ha->sas_ha.lldd_port_formed = asd_update_port_links;
-
-	asd_ha->sas_ha.lldd_dev_found = asd_dev_found;
-	asd_ha->sas_ha.lldd_dev_gone = asd_dev_gone;
-
-	asd_ha->sas_ha.lldd_max_execute_num = lldd_max_execute_num;
 	asd_ha->sas_ha.lldd_queue_size = asd_ha->seq.can_queue;
-	asd_ha->sas_ha.lldd_execute_task = asd_execute_task;
-
-	asd_ha->sas_ha.lldd_abort_task     = asd_abort_task;
-	asd_ha->sas_ha.lldd_abort_task_set = asd_abort_task_set;
-	asd_ha->sas_ha.lldd_clear_aca      = asd_clear_aca;
-	asd_ha->sas_ha.lldd_clear_task_set = asd_clear_task_set;
-	asd_ha->sas_ha.lldd_I_T_nexus_reset= NULL;
-	asd_ha->sas_ha.lldd_lu_reset       = asd_lu_reset;
-	asd_ha->sas_ha.lldd_query_task     = asd_query_task;
 
-	asd_ha->sas_ha.lldd_clear_nexus_port = asd_clear_nexus_port;
-	asd_ha->sas_ha.lldd_clear_nexus_ha = asd_clear_nexus_ha;
-
-	asd_ha->sas_ha.lldd_control_phy = asd_control_phy;
-
-	return sas_register_ha(&asd_ha->sas_ha, &aic94xx_sht);
+	return sas_register_ha(&asd_ha->sas_ha);
 }
 
 static int asd_unregister_sas_ha(struct asd_ha_struct *asd_ha)
 {
-	return sas_unregister_ha(&asd_ha->sas_ha);
+	int err;
+
+	err = sas_unregister_ha(&asd_ha->sas_ha);
+
+	sas_remove_host(asd_ha->sas_ha.core.shost);
+	scsi_remove_host(asd_ha->sas_ha.core.shost);
+	scsi_host_put(asd_ha->sas_ha.core.shost);
+
+	kfree(asd_ha->sas_ha.sas_phy);
+	kfree(asd_ha->sas_ha.sas_port);
+
+	return err;
 }
 
 static int __devinit asd_pci_probe(struct pci_dev *dev,
@@ -533,6 +533,7 @@ static int __devinit asd_pci_probe(struc
 	struct asd_pcidev_struct *asd_dev;
 	unsigned asd_id = (unsigned) id->driver_data;
 	struct asd_ha_struct *asd_ha;
+	struct Scsi_Host *shost;
 	int err;
 
 	if (asd_id >= ARRAY_SIZE(asd_pcidev_data)) {
@@ -547,9 +548,14 @@ static int __devinit asd_pci_probe(struc
 
 	pci_set_master(dev);
 
+	err = -ENOMEM;
+
+	shost = scsi_host_alloc(&aic94xx_sht, sizeof(void *));
+	if (!shost)
+		goto Err;
+
 	asd_dev = &asd_pcidev_data[asd_id];
 
-	err = -ENOMEM;
 	asd_ha = kzalloc(sizeof(*asd_ha), GFP_KERNEL);
 	if (!asd_ha) {
 		asd_printk("out of memory\n");
@@ -561,6 +567,23 @@ static int __devinit asd_pci_probe(struc
 
 	asd_ha->name = asd_dev->name;
 	asd_printk("found %s, device %s\n", asd_ha->name, pci_name(dev));
+
+	SHOST_TO_SAS_HA(shost) = &asd_ha->sas_ha;
+	asd_ha->sas_ha.core.shost = shost;
+	shost->transportt = aic94xx_transport_template;
+	shost->max_channel = ASD_MAX_PHYS - 1;
+	shost->max_id = ~0;
+	shost->max_lun = ~0;
+	shost->max_cmd_len = 16;
+
+	err = scsi_add_host(shost, &dev->dev);
+	if (err) {
+		scsi_host_put(shost);
+		goto Err_free;
+	}
+
+
+
 	err = asd_dev->setup(asd_ha);
 	if (err)
 		goto Err_free;
@@ -656,6 +679,7 @@ Err_unmap:
 	asd_unmap_ha(asd_ha);
 Err_free:
 	kfree(asd_ha);
+	scsi_remove_host(shost);
 Err:
 	pci_disable_device(dev);
 	return err;
@@ -738,6 +762,28 @@ static void asd_remove_driver_attrs(stru
 	driver_remove_file(driver, &driver_attr_version);
 }
 
+static struct sas_domain_function_template aic94xx_transport_functions = {
+	.lldd_port_formed	= asd_update_port_links,
+
+	.lldd_dev_found		= asd_dev_found,
+	.lldd_dev_gone		= asd_dev_gone,
+
+	.lldd_execute_task	= asd_execute_task,
+
+	.lldd_abort_task	= asd_abort_task,
+	.lldd_abort_task_set	= asd_abort_task_set,
+	.lldd_clear_aca		= asd_clear_aca,
+	.lldd_clear_task_set	= asd_clear_task_set,
+	.lldd_I_T_nexus_reset	= NULL,
+	.lldd_lu_reset		= asd_lu_reset,
+	.lldd_query_task	= asd_query_task,
+
+	.lldd_clear_nexus_port	= asd_clear_nexus_port,
+	.lldd_clear_nexus_ha	= asd_clear_nexus_ha,
+
+	.lldd_control_phy	= asd_control_phy,
+};
+
 static const struct pci_device_id aic94xx_pci_table[] __devinitdata = {
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR10),
 	 0, 0, 1},
@@ -777,9 +823,23 @@ static int __init aic94xx_init(void)
 	if (err)
 		return err;
 
+	aic94xx_transport_template =
+		sas_domain_attach_transport(&aic94xx_transport_functions);
+	if (err)
+		goto out_destroy_caches;
+
 	err = pci_register_driver(&aic94xx_pci_driver);
-	if (!err)
-		asd_create_driver_attrs(&aic94xx_pci_driver.driver);
+	if (err)
+		goto out_release_transport;
+
+	asd_create_driver_attrs(&aic94xx_pci_driver.driver);
+
+	return err;
+
+ out_release_transport:
+	sas_release_transport(aic94xx_transport_template);
+ out_destroy_caches:
+	asd_destroy_global_caches();
 
 	return err;
 }
@@ -788,6 +848,7 @@ static void __exit aic94xx_exit(void)
 {
 	asd_remove_driver_attrs(&aic94xx_pci_driver.driver);
 	pci_unregister_driver(&aic94xx_pci_driver);
+	sas_release_transport(aic94xx_transport_template);
 	asd_destroy_global_caches();
 	asd_printk("%s version %s unloaded\n", ASD_DRIVER_DESCRIPTION,
 		   ASD_DRIVER_VERSION);
diff --git a/drivers/scsi/sas/sas_discover.c b/drivers/scsi/sas/sas_discover.c
index a3ce042..6f52df6 100644
--- a/drivers/scsi/sas/sas_discover.c
+++ b/drivers/scsi/sas/sas_discover.c
@@ -31,6 +31,10 @@
 #include <scsi/sas/sas_task.h>
 #include <scsi/sas/sas_discover.h>
 
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_sas.h>
+#include "../scsi_sas_internal.h"
+
 /* ---------- Basic task processing for discovery purposes ---------- */
 
 static void sas_task_timedout(unsigned long _task)
@@ -70,6 +74,8 @@ static int sas_execute_task(struct sas_t
 	struct task_status_struct *ts = &task->task_status;
 	int num_scatter = 0;
 	int retries = 0;
+	struct sas_internal *i =
+		to_sas_internal(task->dev->port->ha->core.shost->transportt);
 
 	if (pci_dma_dir != PCI_DMA_NONE) {
 		scatter = kzalloc(sizeof(*scatter), GFP_KERNEL);
@@ -96,8 +102,7 @@ static int sas_execute_task(struct sas_t
 		task->timer.expires = jiffies + SAS_DEV_TIMEOUT*HZ;
 		add_timer(&task->timer);
 
-		res = task->dev->port->ha->lldd_execute_task(task, 1,
-							     GFP_KERNEL);
+		res = i->dft->lldd_execute_task(task, 1, GFP_KERNEL);
 		if (res) {
 			del_timer(&task->timer);
 			SAS_DPRINTK("executing SAS discovery task failed:%d\n",
@@ -110,7 +115,7 @@ static int sas_execute_task(struct sas_t
 			int res2;
 			SAS_DPRINTK("task aborted, flags:0x%x\n",
 				    task->task_state_flags);
-			res2 = task->dev->port->ha->lldd_abort_task(task);
+			res2 = i->dft->lldd_abort_task(task);
 			SAS_DPRINTK("came back from abort task\n");
 			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 				if (res2 == TMF_RESP_FUNC_COMPLETE)
@@ -486,6 +491,36 @@ static int sas_discover_sata_pm(struct d
 	return -ENODEV;
 }
 
+int sas_notify_lldd_dev_found(struct domain_device *dev)
+{
+	int res = 0;
+	struct sas_ha_struct *sas_ha = dev->port->ha;
+	struct Scsi_Host *shost = sas_ha->core.shost;
+	struct sas_internal *i = to_sas_internal(shost->transportt);
+
+	if (i->dft->lldd_dev_found) {
+		res = i->dft->lldd_dev_found(dev);
+		if (res) {
+			printk("sas: driver on pcidev %s cannot handle "
+			       "device %llx, error:%d\n",
+			       pci_name(sas_ha->pcidev),
+			       SAS_ADDR(dev->sas_addr), res);
+		}
+	}
+	return res;
+}
+
+
+void sas_notify_lldd_dev_gone(struct domain_device *dev)
+{
+	struct sas_ha_struct *sas_ha = dev->port->ha;
+	struct Scsi_Host *shost = sas_ha->core.shost;
+	struct sas_internal *i = to_sas_internal(shost->transportt);
+
+	if (i->dft->lldd_dev_gone)
+		i->dft->lldd_dev_gone(dev);
+}
+
 /* ---------- Common/dispatchers ---------- */
 
 /**
diff --git a/drivers/scsi/sas/sas_expander.c b/drivers/scsi/sas/sas_expander.c
index c0e92e4..de8419e 100644
--- a/drivers/scsi/sas/sas_expander.c
+++ b/drivers/scsi/sas/sas_expander.c
@@ -30,6 +30,10 @@
 #include <scsi/sas/sas_task.h>
 #include <scsi/sas/sas_discover.h>
 
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_sas.h>
+#include "../scsi_sas_internal.h"
+
 static int sas_discover_expander(struct domain_device *dev);
 static int sas_configure_routing(struct domain_device *dev, u8 *sas_addr);
 static int sas_disable_routing(struct domain_device *dev,  u8 *sas_addr);
@@ -70,6 +74,8 @@ static int smp_execute_task(struct domai
 {
 	int res;
 	struct sas_task *task = sas_alloc_task(GFP_KERNEL);
+	struct sas_internal *i =
+		to_sas_internal(dev->port->ha->core.shost->transportt);
 
 	if (!task)
 		return -ENOMEM;
@@ -86,7 +92,7 @@ static int smp_execute_task(struct domai
 	task->timer.expires = jiffies + SMP_TIMEOUT*HZ;
 	add_timer(&task->timer);
 
-	res = task->dev->port->ha->lldd_execute_task(task, 1, GFP_KERNEL);
+	res = i->dft->lldd_execute_task(task, 1, GFP_KERNEL);
 
 	if (res) {
 		del_timer(&task->timer);
@@ -98,7 +104,7 @@ static int smp_execute_task(struct domai
 	res = -ETASK;
 	if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 		SAS_DPRINTK("smp task timed out or aborted\n");
-		task->dev->port->ha->lldd_abort_task(task);
+		i->dft->lldd_abort_task(task);
 		if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 			SAS_DPRINTK("SMP task aborted and not done\n");
 			goto ex_err;
diff --git a/drivers/scsi/sas/sas_init.c b/drivers/scsi/sas/sas_init.c
index 8a5894a..5fff210 100644
--- a/drivers/scsi/sas/sas_init.c
+++ b/drivers/scsi/sas/sas_init.c
@@ -29,12 +29,14 @@
 #include <linux/device.h>
 #include <linux/spinlock.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
 
 #include "sas_internal.h"
 #include <scsi/sas/sas_task.h>
 
-static struct scsi_transport_template *sas_transport_template;
+#include "../scsi_sas_internal.h"
 
 kmem_cache_t *sas_task_cache;
 
@@ -48,8 +50,7 @@ void sas_hae_reset(void *data)
 			&ha->pending);
 }
 
-int sas_register_ha(struct sas_ha_struct *sas_ha,
-		    const struct scsi_host_template *scsi_ht)
+int sas_register_ha(struct sas_ha_struct *sas_ha)
 {
 	int error = 0;
 
@@ -61,17 +62,10 @@ int sas_register_ha(struct sas_ha_struct
 	else if (sas_ha->lldd_queue_size == -1)
 		sas_ha->lldd_queue_size = 128; /* Sanity */
 
-	error = sas_register_scsi_host(sas_ha, scsi_ht,
-				       sas_transport_template);
-	if (error) {
-		printk(KERN_NOTICE "couldn't register scsi host\n");
-		return error;
-	}
-
 	error = sas_register_phys(sas_ha);
 	if (error) {
 		printk(KERN_NOTICE "couldn't register sas phys:%d\n", error);
-		goto Undo;
+		return error;
 	}
 
 	error = sas_register_ports(sas_ha);
@@ -100,8 +94,6 @@ int sas_register_ha(struct sas_ha_struct
 Undo_ports:
 	sas_unregister_ports(sas_ha);
 Undo_phys:
-Undo:
-	sas_unregister_scsi_host(sas_ha);
 
 	return error;
 }
@@ -114,14 +106,37 @@ int sas_unregister_ha(struct sas_ha_stru
 
 	sas_unregister_ports(sas_ha);
 
-	sas_unregister_scsi_host(sas_ha);
-
 	return 0;
 }
 
-static struct sas_function_template sas_transport_functions = {
+static struct sas_function_template sft = {
 };
 
+extern struct scsi_transport_template *
+sas_domain_attach_transport(struct sas_domain_function_template *dft)
+{
+	struct scsi_transport_template *stt = sas_attach_transport(&sft);
+	struct sas_internal *i;
+
+	if (!stt)
+		return stt;
+
+	i = to_sas_internal(stt);
+	i->dft = dft;
+	stt->create_work_queue = 1;
+	stt->eh_timed_out = sas_scsi_timed_out;
+
+	return stt;
+}
+EXPORT_SYMBOL_GPL(sas_domain_attach_transport);
+
+
+extern void sas_domain_release_transport(struct scsi_transport_template *stt)
+{
+	sas_release_transport(stt);
+}
+EXPORT_SYMBOL_GPL(sas_domain_release_transport);
+
 /* ---------- SAS Class register/unregister ---------- */
 
 static int __init sas_class_init(void)
@@ -131,21 +146,12 @@ static int __init sas_class_init(void)
 	if (!sas_task_cache)
 		return -ENOMEM;
 
-	sas_transport_template = sas_attach_transport(&sas_transport_functions);
-	if (!sas_transport_template) {
-		kmem_cache_destroy(sas_task_cache);
-		return -ENOMEM;
-	}
-
 	return 0;
 }
 
 static void __exit sas_class_exit(void)
 {
-	if (sas_transport_template)
-		sas_release_transport(sas_transport_template);
-	if (sas_task_cache)
-		kmem_cache_destroy(sas_task_cache);
+	kmem_cache_destroy(sas_task_cache);
 }
 
 MODULE_AUTHOR("Luben Tuikov <luben_tuikov@adaptec.com>");
diff --git a/drivers/scsi/sas/sas_internal.h b/drivers/scsi/sas/sas_internal.h
index 90d772e..596c417 100644
--- a/drivers/scsi/sas/sas_internal.h
+++ b/drivers/scsi/sas/sas_internal.h
@@ -49,10 +49,7 @@ void sas_unregister_phys(struct sas_ha_s
 int  sas_register_ports(struct sas_ha_struct *sas_ha);
 void sas_unregister_ports(struct sas_ha_struct *sas_ha);
 
-extern int  sas_register_scsi_host(struct sas_ha_struct *,
-				   const struct scsi_host_template *,
-				   struct scsi_transport_template *);
-void sas_unregister_scsi_host(struct sas_ha_struct *sas_ha);
+enum scsi_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *);
 
 int  sas_init_queue(struct sas_ha_struct *sas_ha);
 int  sas_init_events(struct sas_ha_struct *sas_ha);
@@ -66,6 +63,10 @@ void sas_porte_link_reset_err(void *);
 void sas_porte_timer_event(void *);
 void sas_porte_hard_reset(void *);
 
+int sas_notify_lldd_dev_found(struct domain_device *);
+void sas_notify_lldd_dev_gone(struct domain_device *);
+
+
 void sas_hae_reset(void *);
 
 static inline void sas_queue_event(int event, spinlock_t *lock, u32 *pending,
diff --git a/drivers/scsi/sas/sas_phy.c b/drivers/scsi/sas/sas_phy.c
index bc2834c..516abe8 100644
--- a/drivers/scsi/sas/sas_phy.c
+++ b/drivers/scsi/sas/sas_phy.c
@@ -25,7 +25,9 @@
 
 #include "sas_internal.h"
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
+#include "../scsi_sas_internal.h"
 
 /* ---------- Phy events ---------- */
 
@@ -53,24 +55,26 @@ static void sas_phye_oob_error(void *dat
 	struct asd_sas_phy *phy = data;
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct sas_port *port = phy->port;
+	struct sas_internal *i =
+		to_sas_internal(sas_ha->core.shost->transportt);
 
 	sas_begin_event(PHYE_OOB_ERROR, &phy->ha->event_lock,
 			&phy->phy_events_pending);
 
 	sas_deform_port(phy);
 
-	if (!port && phy->enabled && sas_ha->lldd_control_phy) {
+	if (!port && phy->enabled && i->dft->lldd_control_phy) {
 		phy->error++;
 		switch (phy->error) {
 		case 1:
 		case 2:
-			sas_ha->lldd_control_phy(phy, PHY_FUNC_HARD_RESET);
+			i->dft->lldd_control_phy(phy, PHY_FUNC_HARD_RESET);
 			break;
 		case 3:
 		default:
 			phy->error = 0;
 			phy->enabled = 0;
-			sas_ha->lldd_control_phy(phy, PHY_FUNC_DISABLE);
+			i->dft->lldd_control_phy(phy, PHY_FUNC_DISABLE);
 			break;
 		}
 	}
@@ -80,12 +84,14 @@ static void sas_phye_spinup_hold(void *d
 {
 	struct asd_sas_phy *phy = data;
 	struct sas_ha_struct *sas_ha = phy->ha;
+	struct sas_internal *i =
+		to_sas_internal(sas_ha->core.shost->transportt);
 
 	sas_begin_event(PHYE_SPINUP_HOLD, &phy->ha->event_lock,
 			&phy->phy_events_pending);
 
 	phy->error = 0;
-	sas_ha->lldd_control_phy(phy, PHY_FUNC_RELEASE_SPINUP_HOLD);
+	i->dft->lldd_control_phy(phy, PHY_FUNC_RELEASE_SPINUP_HOLD);
 }
 
 /* ---------- Phy class registration ---------- */
diff --git a/drivers/scsi/sas/sas_port.c b/drivers/scsi/sas/sas_port.c
index 6177423..00934cd 100644
--- a/drivers/scsi/sas/sas_port.c
+++ b/drivers/scsi/sas/sas_port.c
@@ -26,6 +26,10 @@
 #include "sas_internal.h"
 #include <scsi/sas/sas_discover.h>
 
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_sas.h>
+#include "../scsi_sas_internal.h"
+
 /**
  * sas_form_port -- add this phy to a port
  * @phy: the phy of interest
@@ -38,6 +42,8 @@ static void sas_form_port(struct asd_sas
 	int i;
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct sas_port *port = phy->port;
+	struct sas_internal *si =
+		to_sas_internal(sas_ha->core.shost->transportt);
 
 	if (port) {
 		if (memcmp(port->attached_sas_addr, phy->attached_sas_addr,
@@ -108,8 +114,8 @@ static void sas_form_port(struct asd_sas
 		port->port_dev->pathways = port->num_phys;
 
 	/* Tell the LLDD about this port formation. */
-	if (sas_ha->lldd_port_formed)
-		sas_ha->lldd_port_formed(phy);
+	if (si->dft->lldd_port_formed)
+		si->dft->lldd_port_formed(phy);
 
 	sas_discover_event(phy->port, DISCE_DISCOVER_DOMAIN);
 }
@@ -125,6 +131,8 @@ void sas_deform_port(struct asd_sas_phy 
 {
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct sas_port *port = phy->port;
+	struct sas_internal *si =
+		to_sas_internal(sas_ha->core.shost->transportt);
 
 	if (!port)
 		return;		  /* done by a phy event */
@@ -138,8 +146,8 @@ void sas_deform_port(struct asd_sas_phy 
 		wait_for_completion(&port->port_gone_completion);
 	}
 
-	if (sas_ha->lldd_port_deformed)
-		sas_ha->lldd_port_deformed(phy);
+	if (si->dft->lldd_port_deformed)
+		si->dft->lldd_port_deformed(phy);
 
 	spin_lock(&sas_ha->phy_port_lock);
 	spin_lock(&port->phy_list_lock);
diff --git a/drivers/scsi/sas/sas_scsi_host.c b/drivers/scsi/sas/sas_scsi_host.c
index 08ad980..0c46047 100644
--- a/drivers/scsi/sas/sas_scsi_host.c
+++ b/drivers/scsi/sas/sas_scsi_host.c
@@ -34,6 +34,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
+#include "../scsi_sas_internal.h"
 
 #include <linux/err.h>
 #include <linux/blkdev.h>
@@ -200,6 +201,7 @@ int sas_queuecommand(struct scsi_cmnd *c
 	int res = 0;
 	struct domain_device *dev = cmd_to_domain_dev(cmd);
 	struct Scsi_Host *host = cmd->device->host;
+	struct sas_internal *i = to_sas_internal(host->transportt);
 
 	spin_unlock_irq(host->host_lock);
 
@@ -215,7 +217,7 @@ int sas_queuecommand(struct scsi_cmnd *c
 		cmd->scsi_done = scsi_done;
 		/* Queue up, Direct Mode or Task Collector Mode. */
 		if (sas_ha->lldd_max_execute_num < 2)
-			res = sas_ha->lldd_execute_task(task, 1, GFP_ATOMIC);
+			res = i->dft->lldd_execute_task(task, 1, GFP_ATOMIC);
 		else
 			res = sas_queue_up(task);
 
@@ -286,6 +288,8 @@ static enum task_disposition sas_scsi_fi
 	struct sas_ha_struct *ha = task->dev->port->ha;
 	unsigned long flags;
 	int i, res;
+	struct sas_internal *si =
+		to_sas_internal(task->dev->port->ha->core.shost->transportt);
 
 	if (ha->lldd_max_execute_num > 1) {
 		struct scsi_core *core = &ha->core;
@@ -308,7 +312,7 @@ static enum task_disposition sas_scsi_fi
 
 	for (i = 0; i < 5; i++) {
 		SAS_DPRINTK("%s: aborting task 0x%p\n", __FUNCTION__, task);
-		res = task->dev->port->ha->lldd_abort_task(task);
+		res = si->dft->lldd_abort_task(task);
 
 		spin_lock_irqsave(&task->task_state_lock, flags);
 		if (task->task_state_flags & SAS_TASK_STATE_DONE) {
@@ -323,10 +327,10 @@ static enum task_disposition sas_scsi_fi
 			SAS_DPRINTK("%s: task 0x%p is aborted\n",
 				    __FUNCTION__, task);
 			return TASK_IS_ABORTED;
-		} else if (ha->lldd_query_task) {
+		} else if (si->dft->lldd_query_task) {
 			SAS_DPRINTK("%s: querying task 0x%p\n",
 				    __FUNCTION__, task);
-			res = ha->lldd_query_task(task);
+			res = si->dft->lldd_query_task(task);
 			if (res == TMF_RESP_FUNC_SUCC) {
 				SAS_DPRINTK("%s: task 0x%p at LU\n",
 					    __FUNCTION__, task);
@@ -343,9 +347,10 @@ static enum task_disposition sas_scsi_fi
 
 static int sas_recover_lu(struct domain_device *dev, struct scsi_cmnd *cmd)
 {
-	struct sas_ha_struct *ha = dev->port->ha;
 	int res = TMF_RESP_FUNC_FAILED;
 	struct scsi_lun lun;
+	struct sas_internal *i =
+		to_sas_internal(dev->port->ha->core.shost->transportt);
 
 	int_to_scsilun(cmd->device->lun, &lun);
 
@@ -353,17 +358,17 @@ static int sas_recover_lu(struct domain_
 		    SAS_ADDR(dev->sas_addr),
 		    cmd->device->lun);
 
-	if (ha->lldd_abort_task_set)
-		res = ha->lldd_abort_task_set(dev, lun.scsi_lun);
+	if (i->dft->lldd_abort_task_set)
+		res = i->dft->lldd_abort_task_set(dev, lun.scsi_lun);
 
 	if (res == TMF_RESP_FUNC_FAILED) {
-		if (ha->lldd_clear_task_set)
-			res = ha->lldd_clear_task_set(dev, lun.scsi_lun);
+		if (i->dft->lldd_clear_task_set)
+			res = i->dft->lldd_clear_task_set(dev, lun.scsi_lun);
 	}
 
 	if (res == TMF_RESP_FUNC_FAILED) {
-		if (ha->lldd_lu_reset)
-			res = ha->lldd_lu_reset(dev, lun.scsi_lun);
+		if (i->dft->lldd_lu_reset)
+			res = i->dft->lldd_lu_reset(dev, lun.scsi_lun);
 	}
 
 	return res;
@@ -371,14 +376,15 @@ static int sas_recover_lu(struct domain_
 
 static int sas_recover_I_T(struct domain_device *dev)
 {
-	struct sas_ha_struct *ha = dev->port->ha;
 	int res = TMF_RESP_FUNC_FAILED;
+	struct sas_internal *i =
+		to_sas_internal(dev->port->ha->core.shost->transportt);
 
 	SAS_DPRINTK("I_T nexus reset for dev %016llx\n",
 		    SAS_ADDR(dev->sas_addr));
 
-	if (ha->lldd_I_T_nexus_reset)
-		res = ha->lldd_I_T_nexus_reset(dev);
+	if (i->dft->lldd_I_T_nexus_reset)
+		res = i->dft->lldd_I_T_nexus_reset(dev);
 
 	return res;
 }
@@ -391,6 +397,7 @@ int sas_scsi_recover_host(struct Scsi_Ho
 	struct scsi_cmnd *cmd, *n;
 	enum task_disposition res = TASK_IS_DONE;
 	int tmf_resp;
+	struct sas_internal *i = to_sas_internal(shost->transportt);
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_splice_init(&shost->eh_cmd_q, &error_q);
@@ -449,11 +456,11 @@ Again:
 				goto Again;
 			}
 			/* Hammer time :-) */
-			if (ha->lldd_clear_nexus_port) {
+			if (i->dft->lldd_clear_nexus_port) {
 				struct sas_port *port = task->dev->port;
 				SAS_DPRINTK("clearing nexus for port:%d\n",
 					    port->id);
-				res = ha->lldd_clear_nexus_port(port);
+				res = i->dft->lldd_clear_nexus_port(port);
 				if (res == TMF_RESP_FUNC_COMPLETE) {
 					SAS_DPRINTK("clear nexus port:%d "
 						    "succeeded\n", port->id);
@@ -463,9 +470,9 @@ Again:
 					goto Again;
 				}
 			}
-			if (ha->lldd_clear_nexus_ha) {
+			if (i->dft->lldd_clear_nexus_ha) {
 				SAS_DPRINTK("clear nexus ha\n");
-				res = ha->lldd_clear_nexus_ha(ha);
+				res = i->dft->lldd_clear_nexus_ha(ha);
 				if (res == TMF_RESP_FUNC_COMPLETE) {
 					SAS_DPRINTK("clear nexus ha "
 						    "succeeded\n");
@@ -499,7 +506,7 @@ clear_q:
 	return 0;
 }
 
-static enum scsi_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
+enum scsi_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
 {
 	struct sas_task *task = TO_SAS_TASK(cmd);
 	unsigned long flags;
@@ -635,73 +642,6 @@ int sas_bios_param(struct scsi_device *s
 	return 0;
 }
 
-static inline void sas_init_host_template(struct sas_ha_struct *sas_ha,
-			      const struct scsi_host_template *scsi_ht)
-{
-	struct scsi_host_template *sht = sas_ha->core.sht;
-
-	memcpy(sht, scsi_ht, sizeof(struct scsi_host_template));
-
-	sht->name = sas_ha->sas_ha_name;
-	sht->can_queue = sas_ha->lldd_queue_size;
-	sht->cmd_per_lun = sht->can_queue;
-}
-
-int sas_register_scsi_host(struct sas_ha_struct *sas_ha,
-			   const struct scsi_host_template *scsi_ht,
-			   struct scsi_transport_template *tt)
-{
-	int err = -ENOMEM;
-
-	/* used for event processing */
-	tt->create_work_queue = 1;
-	tt->eh_timed_out = sas_scsi_timed_out;
-
-	sas_ha->core.sht = kzalloc(sizeof(*sas_ha->core.sht), GFP_KERNEL);
-	if (!sas_ha->core.sht)
-		return -ENOMEM;
-
-	sas_init_host_template(sas_ha, scsi_ht);
-
-	sas_ha->core.shost = scsi_host_alloc(sas_ha->core.sht, sizeof(void *));
-	if (!sas_ha->core.shost) {
-		printk(KERN_NOTICE "couldn't allocate scsi host\n");
-		goto out_err;
-	}
-	SHOST_TO_SAS_HA(sas_ha->core.shost) = sas_ha;
-
-	/* XXX: SCSI Core should really fix this (max vs. num of) */
-	sas_ha->core.shost->max_channel = sas_ha->num_phys - 1;
-	sas_ha->core.shost->max_id = ~0 - 1;
-	sas_ha->core.shost->max_lun = ~0 - 1;
-
-	sas_ha->core.shost->max_cmd_len = 16;
-	sas_ha->core.shost->transportt = tt;
-
-	err = scsi_add_host(sas_ha->core.shost, &sas_ha->pcidev->dev);
-	if (err) {
-		scsi_host_put(sas_ha->core.shost);
-		sas_ha->core.shost = NULL;
-		goto out_err;
-	}
-	return 0;
-
-out_err:
-	kfree(sas_ha->core.sht);
-	sas_ha->core.sht = NULL;
-	return err;
-}
-
-void sas_unregister_scsi_host(struct sas_ha_struct *sas_ha)
-{
-	sas_remove_host(sas_ha->core.shost);
-	scsi_remove_host(sas_ha->core.shost);
-	scsi_host_put(sas_ha->core.shost);
-	sas_ha->core.shost = NULL;
-	kfree(sas_ha->core.sht);
-	sas_ha->core.sht = NULL;
-}
-
 /* ---------- Task Collector Thread implementation ---------- */
 
 static void sas_queue(struct sas_ha_struct *sas_ha)
@@ -711,6 +651,7 @@ static void sas_queue(struct sas_ha_stru
 	LIST_HEAD(q);
 	int can_queue;
 	int res;
+	struct sas_internal *i = to_sas_internal(core->shost->transportt);
 
 	spin_lock_irqsave(&core->task_queue_lock, flags);
 	while (!core->queue_thread_kill &&
@@ -738,7 +679,7 @@ static void sas_queue(struct sas_ha_stru
 							   struct sas_task,
 							   list);
 			list_del_init(&q);
-			res = sas_ha->lldd_execute_task(task, can_queue,
+			res = i->dft->lldd_execute_task(task, can_queue,
 							GFP_KERNEL);
 			if (unlikely(res))
 				__list_add(&q, task->list.prev, &task->list);
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 134c44c..7b76b8d 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -35,40 +35,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
 
-
-#define SAS_HOST_ATTRS		0
-#define SAS_PORT_ATTRS		17
-#define SAS_RPORT_ATTRS		7
-#define SAS_END_DEV_ATTRS	3
-#define SAS_EXPANDER_ATTRS	7
-
-struct sas_internal {
-	struct scsi_transport_template t;
-	struct sas_function_template *f;
-
-	struct class_device_attribute private_host_attrs[SAS_HOST_ATTRS];
-	struct class_device_attribute private_phy_attrs[SAS_PORT_ATTRS];
-	struct class_device_attribute private_rphy_attrs[SAS_RPORT_ATTRS];
-	struct class_device_attribute private_end_dev_attrs[SAS_END_DEV_ATTRS];
-	struct class_device_attribute private_expander_attrs[SAS_EXPANDER_ATTRS];
-
-	struct transport_container phy_attr_cont;
-	struct transport_container rphy_attr_cont;
-	struct transport_container end_dev_attr_cont;
-	struct transport_container expander_attr_cont;
-
-	/*
-	 * The array of null terminated pointers to attributes
-	 * needed by scsi_sysfs.c
-	 */
-	struct class_device_attribute *host_attrs[SAS_HOST_ATTRS + 1];
-	struct class_device_attribute *phy_attrs[SAS_PORT_ATTRS + 1];
-	struct class_device_attribute *rphy_attrs[SAS_RPORT_ATTRS + 1];
-	struct class_device_attribute *end_dev_attrs[SAS_END_DEV_ATTRS + 1];
-	struct class_device_attribute *expander_attrs[SAS_EXPANDER_ATTRS + 1];
-};
-#define to_sas_internal(tmpl)	container_of(tmpl, struct sas_internal, t)
-
+#include "scsi_sas_internal.h"
 struct sas_host_attrs {
 	struct list_head rphy_list;
 	struct mutex lock;
diff --git a/include/scsi/sas/sas_class.h b/include/scsi/sas/sas_class.h
index 884a684..22128a2 100644
--- a/include/scsi/sas/sas_class.h
+++ b/include/scsi/sas/sas_class.h
@@ -186,7 +186,6 @@ struct sas_port {
 struct sas_task;
 
 struct scsi_core {
-	struct scsi_host_template *sht;
 	struct Scsi_Host *shost;
 
 	spinlock_t        task_queue_lock;
@@ -218,11 +217,19 @@ struct sas_ha_struct {
 	struct sas_port **sas_port; /* array of valid pointers, must be set */
 	int             num_phys; /* must be set, gt 0, static */
 
+	/* The class calls this to send a task for execution. */
+	int lldd_max_execute_num;
+	int lldd_queue_size;
+
 	/* LLDD calls these to notify the class of an event. */
 	void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
 	void (*notify_port_event)(struct asd_sas_phy *, enum port_event);
 	void (*notify_phy_event)(struct asd_sas_phy *, enum phy_event);
 
+	void *lldd_ha;		  /* not touched by sas class code */
+};
+
+struct sas_domain_function_template {
 	/* The class calls these to notify the LLDD of an event. */
 	void (*lldd_port_formed)(struct asd_sas_phy *);
 	void (*lldd_port_deformed)(struct asd_sas_phy *);
@@ -231,9 +238,6 @@ struct sas_ha_struct {
 	int  (*lldd_dev_found)(struct domain_device *);
 	void (*lldd_dev_gone)(struct domain_device *);
 
-	/* The class calls this to send a task for execution. */
-	int lldd_max_execute_num;
-	int lldd_queue_size;
 	int (*lldd_execute_task)(struct sas_task *, int num,
 				 unsigned long gfp_flags);
 
@@ -252,10 +256,9 @@ struct sas_ha_struct {
 
 	/* Phy management */
 	int (*lldd_control_phy)(struct asd_sas_phy *, enum phy_func);
-
-	void *lldd_ha;		  /* not touched by sas class code */
 };
 
+
 #define SHOST_TO_SAS_HA(_shost) (*(struct sas_ha_struct **)(_shost)->hostdata)
 
 static inline struct domain_device *
@@ -287,7 +290,7 @@ static inline void sas_phy_disconnected(
 	phy->linkrate = PHY_LINKRATE_NONE;
 }
 
-extern int sas_register_ha(struct sas_ha_struct *, const struct scsi_host_template *);
+extern int sas_register_ha(struct sas_ha_struct *);
 extern int sas_unregister_ha(struct sas_ha_struct *);
 
 extern int sas_queuecommand(struct scsi_cmnd *cmd,
@@ -302,5 +305,7 @@ extern int sas_change_queue_type(struct 
 extern int sas_bios_param(struct scsi_device *scsi_dev,
 			  struct block_device *bdev,
 			  sector_t capacity, int *hsc);
-
+extern struct scsi_transport_template *
+sas_domain_attach_transport(struct sas_domain_function_template *);
+extern void sas_domain_release_transport(struct scsi_transport_template *);
 #endif /* _SAS_CLASS_H_ */
diff --git a/include/scsi/sas/sas_discover.h b/include/scsi/sas/sas_discover.h
index 7fb0f8b..a870c2b 100644
--- a/include/scsi/sas/sas_discover.h
+++ b/include/scsi/sas/sas_discover.h
@@ -123,29 +123,6 @@ struct domain_device {
 	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
 
 
-static inline int sas_notify_lldd_dev_found(struct domain_device *dev)
-{
-	int res = 0;
-	struct sas_ha_struct *sas_ha = dev->port->ha;
-
-	if (sas_ha->lldd_dev_found) {
-		res = sas_ha->lldd_dev_found(dev);
-		if (res) {
-			printk("sas: driver on pcidev %s cannot handle "
-			       "device %llx, error:%d\n",
-			       pci_name(sas_ha->pcidev),
-			       SAS_ADDR(dev->sas_addr), res);
-		}
-	}
-	return res;
-}
-
-static inline void sas_notify_lldd_dev_gone(struct domain_device *dev)
-{
-	if (dev->port->ha->lldd_dev_gone)
-		dev->port->ha->lldd_dev_gone(dev);
-}
-
 static inline void sas_init_dev(struct domain_device *dev)
 {
 	INIT_LIST_HEAD(&dev->siblings);


