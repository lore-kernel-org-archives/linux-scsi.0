From: "Thomson, Patrick S" <patrick.s.thomson@intel.com>
Subject: [RFC] libsas: modifying libsas port creation
Date: Mon, 27 Sep 2010 16:14:12 -0700
Message-ID: <86810401A1B22346A09CBA649BE561E90133F6445B@azsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55955 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab0I0XOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2010 19:14:15 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Marushak, Nathan" <nathan.marushak@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Jeppsen, Roger C" <roger.c.jeppsen@intel.com>

Hello,

I'm working on a SAS driver for Intel's Patsburg chipset and ran across a problem (for me) when libsas creates a port. Specifically, it appears that libsas will use only use the attached sas address when creating a port, instead of the sas address on each side of the link. What I'd like to propose is to modify port creation such that, based on a flag stored in struct sas_ha_struct, that the SAS address on the initiator side can be taken into account. If the flag is not set, then the original behavior is in force.

The main point is that the original behavior is the default, and if anyone wants to use the modified port creation, they call sas_ha_struct.notify_libsas_config() right after sas_ha_register during module init.

Thanks!
Pat Thomson

diff -Nau old/include/scsi/libsas.h new/include/scsi/libsas.h
--- old/include/scsi/libsas.h	2010-09-27 14:23:14.142380393 -0700
+++ new/include/scsi/libsas.h	2010-09-27 15:26:38.040818779 -0700
@@ -89,6 +89,11 @@
 	DISC_NUM_EVENTS 	= 3,
 };
 
+enum cfg_state {
+	CFGE_USE_HOST_TARGET_SAS = 0U, /* struct sas_ha_struct.use_host_phy_addr */
+	CFGE_USE_ONLY_TARGET_SAS = 1,  /* struct sas_ha_struct.use_host_phy_addr */
+};
+
 /* ---------- Expander Devices ---------- */
 
 #define to_dom_device(_obj) container_of(_obj, struct domain_device, dev_obj)
@@ -344,6 +349,9 @@
 
 	struct scsi_core core;
 
+	spinlock_t        libsas_config_lock;
+	unsigned int      use_host_phy_addr; /* defaults to 0 */
+
 /* public: */
 	char *sas_ha_name;
 	struct device *dev;	  /* should be set */
@@ -366,6 +374,9 @@
 	void (*notify_port_event)(struct asd_sas_phy *, enum port_event);
 	void (*notify_phy_event)(struct asd_sas_phy *, enum phy_event);
 
+	/* LLDD calls to this notifies libsas of a characteristic change */
+	void (*notify_libsas_config)(struct sas_ha_struct *, enum cfg_state);
+
 	void *lldd_ha;		  /* not touched by sas class code */
 
 	struct list_head eh_done_q;
diff -Nau old/drivers/scsi/libsas/sas_port.c new/drivers/scsi/libsas/sas_port.c
--- old/drivers/scsi/libsas/sas_port.c	2010-09-27 15:28:37.465380355 -0700
+++ new/drivers/scsi/libsas/sas_port.c	2010-09-27 15:30:44.235625831 -0700
@@ -43,10 +43,17 @@
 	struct sas_internal *si =
 		to_sas_internal(sas_ha->core.shost->transportt);
 	unsigned long flags;
+	unsigned int use_phy_addr;
+
+	spin_lock_irqsave(&sas_ha->libsas_config_lock, flags);
+	use_phy_addr = sas_ha->use_host_phy_addr;
+	spin_unlock_irqrestore(&sas_ha->libsas_config_lock, flags);
 
 	if (port) {
-		if (memcmp(port->attached_sas_addr, phy->attached_sas_addr,
-			   SAS_ADDR_SIZE) != 0)
+		if ((memcmp(port->attached_sas_addr, phy->attached_sas_addr,
+			   SAS_ADDR_SIZE) != 0) ||
+		    ((use_phy_addr) && (memcmp(port->sas_addr, phy->sas_addr, 
+						  SAS_ADDR_SIZE) != 0)))
 			sas_deform_port(phy);
 		else {
 			SAS_DPRINTK("%s: phy%d belongs to port%d already(%d)!\n",
@@ -64,6 +71,8 @@
 		if (*(u64 *) port->sas_addr &&
 		    memcmp(port->attached_sas_addr,
 			   phy->attached_sas_addr, SAS_ADDR_SIZE) == 0 &&
+                    (!(use_phy_addr) || (memcmp(port->sas_addr, phy->sas_addr, 
+						SAS_ADDR_SIZE) == 0)) &&
 		    port->num_phys > 0) {
 			/* wide port */
 			SAS_DPRINTK("phy%d matched wide port%d\n", phy->id,
diff -Nau old/drivers/scsi/libsas/sas_init.c new/drivers/scsi/libsas/sas_init.c
--- old/drivers/scsi/libsas/sas_init.c	2010-09-27 15:31:43.158567989 -0700
+++ new/drivers/scsi/libsas/sas_init.c	2010-09-27 15:35:21.458813146 -0700
@@ -39,6 +39,8 @@
 
 struct kmem_cache *sas_task_cache;
 
+void notify_libsas_config(struct sas_ha_struct *ha_struct, enum cfg_state cfg);
+
 /*------------ SAS addr hash -----------*/
 void sas_hash_addr(u8 *hashed, const u8 *sas_addr)
 {
@@ -120,6 +122,13 @@
 
 	INIT_LIST_HEAD(&sas_ha->eh_done_q);
 
+	/* setup behavior mod interface */
+	spin_lock_init(&sas_ha->libsas_config_lock);
+	sas_ha->notify_libsas_config = notify_libsas_config;
+
+	/* when creating ports, don't take host phy addr into account */
+	sas_ha->use_host_phy_addr = 0;
+
 	return 0;
 
 Undo_ports:
@@ -255,6 +264,22 @@
 	return ret;
 }
 
+void notify_libsas_config(struct sas_ha_struct *sas_ha, enum cfg_state cfg)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sas_ha->libsas_config_lock, flags);
+	switch (cfg) {
+	case CFGE_USE_HOST_TARGET_SAS:
+		sas_ha->use_host_phy_addr = 1;
+		break;
+	case CFGE_USE_ONLY_TARGET_SAS:
+		sas_ha->use_host_phy_addr = 0;
+		break;
+	}
+	spin_unlock_irqrestore(&sas_ha->libsas_config_lock, flags);
+}
+
 static struct sas_function_template sft = {
 	.phy_enable = sas_phy_enable,
 	.phy_reset = sas_phy_reset,
