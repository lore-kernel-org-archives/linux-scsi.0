From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic94xx: rename sas_port to asd_sas_port
Date: Tue, 30 May 2006 23:00:23 -0500
Message-ID: <1149048023.3545.56.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:63643 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751638AbWEaEAZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 00:00:25 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k4V40Oa04558
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 00:00:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a necessary namespace clash removal precursor prior to
introducing sas_port into the sas transport class.

James

diff --git a/drivers/scsi/aic94xx/aic94xx.h b/drivers/scsi/aic94xx/aic94xx.h
index 6a1f86c..24e662e 100644
--- a/drivers/scsi/aic94xx/aic94xx.h
+++ b/drivers/scsi/aic94xx/aic94xx.h
@@ -105,7 +105,7 @@ int  asd_lu_reset(struct domain_device *
 int  asd_query_task(struct sas_task *);
 
 /* ---------- Adapter and Port management ---------- */
-int  asd_clear_nexus_port(struct sas_port *port);
+int  asd_clear_nexus_port(struct asd_sas_port *port);
 int  asd_clear_nexus_ha(struct sas_ha_struct *sas_ha);
 
 /* ---------- Phy Management ---------- */
diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.h b/drivers/scsi/aic94xx/aic94xx_hwi.h
index 154feee..7b3b87b 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.h
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.h
@@ -211,7 +211,7 @@ struct asd_ha_struct {
 	struct hw_profile hw_prof;
 
 	struct asd_phy    phys[ASD_MAX_PHYS];
-	struct sas_port   ports[ASD_MAX_PHYS];
+	struct asd_sas_port   ports[ASD_MAX_PHYS];
 
 	struct dma_pool  *scb_pool;
 
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index e464c19..f337189 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -483,8 +483,8 @@ static int asd_register_sas_ha(struct as
 	int i;
 	struct asd_sas_phy   **sas_phys =
 		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_phy), GFP_KERNEL);
-	struct sas_port  **sas_ports =
-		kmalloc(ASD_MAX_PHYS * sizeof(struct sas_port), GFP_KERNEL);
+	struct asd_sas_port  **sas_ports =
+		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_port), GFP_KERNEL);
 
 	if (!sas_phys || !sas_ports) {
 		kfree(sas_phys);
diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index c1ee53b..f89e292 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -129,7 +129,7 @@ int asd_clear_nexus_ha(struct sas_ha_str
 	CLEAR_NEXUS_POST;
 }
 
-int asd_clear_nexus_port(struct sas_port *port)
+int asd_clear_nexus_port(struct asd_sas_port *port)
 {
 	struct asd_ha_struct *asd_ha = port->ha->lldd_ha;
 	struct asd_ascb *ascb;
diff --git a/drivers/scsi/sas/sas_discover.c b/drivers/scsi/sas/sas_discover.c
index 6f52df6..9dd72c5 100644
--- a/drivers/scsi/sas/sas_discover.c
+++ b/drivers/scsi/sas/sas_discover.c
@@ -191,7 +191,7 @@ out:
  * do, and should have their "parent" pointer set appropriately as
  * soon as a child device is discovered.
  */
-static int sas_get_port_device(struct sas_port *port)
+static int sas_get_port_device(struct asd_sas_port *port)
 {
 	unsigned long flags;
 	struct asd_sas_phy *phy;
@@ -384,7 +384,7 @@ out:
 static void sas_sata_propagate_sas_addr(struct domain_device *dev)
 {
 	unsigned long flags;
-	struct sas_port *port = dev->port;
+	struct asd_sas_port *port = dev->port;
 	struct asd_sas_phy  *phy;
 
 	BUG_ON(dev->parent);
@@ -620,7 +620,7 @@ void sas_unregister_dev(struct domain_de
 static void sas_unregister_domain_devices(void *data)
 {
 	struct domain_device *dev, *n;
-	struct sas_port *port = data;
+	struct asd_sas_port *port = data;
 
 	sas_begin_event(DISCE_PORT_GONE, &port->disc.disc_event_lock,
 			&port->disc.pending);
@@ -645,7 +645,7 @@ static void sas_unregister_domain_device
 static void sas_discover_domain(void *data)
 {
 	int error = 0;
-	struct sas_port *port = data;
+	struct asd_sas_port *port = data;
 
 	sas_begin_event(DISCE_DISCOVER_DOMAIN, &port->disc.disc_event_lock,
 			&port->disc.pending);
@@ -690,7 +690,7 @@ static void sas_discover_domain(void *da
 static void sas_revalidate_domain(void *data)
 {
 	int res = 0;
-	struct sas_port *port = data;
+	struct asd_sas_port *port = data;
 
 	sas_begin_event(DISCE_REVALIDATE_DOMAIN, &port->disc.disc_event_lock,
 			&port->disc.pending);
@@ -706,7 +706,7 @@ static void sas_revalidate_domain(void *
 
 /* ---------- Events ---------- */
 
-int sas_discover_event(struct sas_port *port, enum discover_event ev)
+int sas_discover_event(struct asd_sas_port *port, enum discover_event ev)
 {
 	struct sas_discovery *disc = &port->disc;
 
@@ -724,7 +724,7 @@ int sas_discover_event(struct sas_port *
  *
  * Called when the ports are being initialized.
  */
-void sas_init_disc(struct sas_discovery *disc, struct sas_port *port)
+void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *port)
 {
 	int i;
 
diff --git a/drivers/scsi/sas/sas_dump.c b/drivers/scsi/sas/sas_dump.c
index 15b0af6..d1f49cd 100644
--- a/drivers/scsi/sas/sas_dump.c
+++ b/drivers/scsi/sas/sas_dump.c
@@ -61,7 +61,7 @@ void sas_dprint_hae(struct sas_ha_struct
 		    sas_hae_str[he]);
 }
 
-void sas_dump_port(struct sas_port *port)
+void sas_dump_port(struct asd_sas_port *port)
 {
 	SAS_DPRINTK("port%d: class:0x%x\n", port->id, port->class);
 	SAS_DPRINTK("port%d: sas_addr:%llx\n", port->id,
diff --git a/drivers/scsi/sas/sas_dump.h b/drivers/scsi/sas/sas_dump.h
index fa00f6c..790521b 100644
--- a/drivers/scsi/sas/sas_dump.h
+++ b/drivers/scsi/sas/sas_dump.h
@@ -30,7 +30,7 @@ #ifdef SAS_DEBUG
 void sas_dprint_porte(int phyid, enum port_event pe);
 void sas_dprint_phye(int phyid, enum phy_event pe);
 void sas_dprint_hae(struct sas_ha_struct *sas_ha, enum ha_event he);
-void sas_dump_port(struct sas_port *port);
+void sas_dump_port(struct asd_sas_port *port);
 
 #else /* SAS_DEBUG */
 
@@ -38,6 +38,6 @@ static inline void sas_dprint_porte(int 
 static inline void sas_dprint_phye(int phyid, enum phy_event pe) { }
 static inline void sas_dprint_hae(struct sas_ha_struct *sas_ha,
 				  enum ha_event he) { }
-static inline void sas_dump_port(struct sas_port *port) { }
+static inline void sas_dump_port(struct asd_sas_port *port) { }
 
 #endif /* SAS_DEBUG */
diff --git a/drivers/scsi/sas/sas_expander.c b/drivers/scsi/sas/sas_expander.c
index de8419e..e716d50 100644
--- a/drivers/scsi/sas/sas_expander.c
+++ b/drivers/scsi/sas/sas_expander.c
@@ -471,7 +471,7 @@ static inline void sas_ex_disable_port(s
 	}
 }
 
-static inline int sas_dev_present_in_domain(struct sas_port *port,
+static inline int sas_dev_present_in_domain(struct asd_sas_port *port,
 					    u8 *sas_addr)
 {
 	struct domain_device *dev;
@@ -1314,7 +1314,7 @@ out_err:
 	return res;
 }
 
-static int sas_ex_level_discovery(struct sas_port *port, const int level)
+static int sas_ex_level_discovery(struct asd_sas_port *port, const int level)
 {
 	int res = 0;
 	struct domain_device *dev;
@@ -1333,7 +1333,7 @@ static int sas_ex_level_discovery(struct
 	return res;
 }
 
-static int sas_ex_bfs_disc(struct sas_port *port)
+static int sas_ex_bfs_disc(struct asd_sas_port *port)
 {
 	int res;
 	int level;
diff --git a/drivers/scsi/sas/sas_phy.c b/drivers/scsi/sas/sas_phy.c
index 516abe8..eacb891 100644
--- a/drivers/scsi/sas/sas_phy.c
+++ b/drivers/scsi/sas/sas_phy.c
@@ -54,7 +54,7 @@ static void sas_phye_oob_error(void *dat
 {
 	struct asd_sas_phy *phy = data;
 	struct sas_ha_struct *sas_ha = phy->ha;
-	struct sas_port *port = phy->port;
+	struct asd_sas_port *port = phy->port;
 	struct sas_internal *i =
 		to_sas_internal(sas_ha->core.shost->transportt);
 
diff --git a/drivers/scsi/sas/sas_port.c b/drivers/scsi/sas/sas_port.c
index 00934cd..1a042f9 100644
--- a/drivers/scsi/sas/sas_port.c
+++ b/drivers/scsi/sas/sas_port.c
@@ -41,7 +41,7 @@ static void sas_form_port(struct asd_sas
 {
 	int i;
 	struct sas_ha_struct *sas_ha = phy->ha;
-	struct sas_port *port = phy->port;
+	struct asd_sas_port *port = phy->port;
 	struct sas_internal *si =
 		to_sas_internal(sas_ha->core.shost->transportt);
 
@@ -130,7 +130,7 @@ static void sas_form_port(struct asd_sas
 void sas_deform_port(struct asd_sas_phy *phy)
 {
 	struct sas_ha_struct *sas_ha = phy->ha;
-	struct sas_port *port = phy->port;
+	struct asd_sas_port *port = phy->port;
 	struct sas_internal *si =
 		to_sas_internal(sas_ha->core.shost->transportt);
 
@@ -234,7 +234,7 @@ void sas_porte_hard_reset(void *data)
 
 /* ---------- SAS port registration ---------- */
 
-static void sas_init_port(struct sas_port *port,
+static void sas_init_port(struct asd_sas_port *port,
 			  struct sas_ha_struct *sas_ha, int i)
 {
 	port->id = i;
@@ -254,7 +254,7 @@ int sas_register_ports(struct sas_ha_str
 
 	/* initialize the ports and discovery */
 	for (i = 0; i < sas_ha->num_phys; i++) {
-		struct sas_port *port = sas_ha->sas_port[i];
+		struct asd_sas_port *port = sas_ha->sas_port[i];
 
 		sas_init_port(port, sas_ha, i);
 		sas_init_disc(&port->disc, port);
diff --git a/drivers/scsi/sas/sas_scsi_host.c b/drivers/scsi/sas/sas_scsi_host.c
index cd60d09..717f01e 100644
--- a/drivers/scsi/sas/sas_scsi_host.c
+++ b/drivers/scsi/sas/sas_scsi_host.c
@@ -263,13 +263,13 @@ static void sas_scsi_clear_queue_I_T(str
 }
 
 static void sas_scsi_clear_queue_port(struct list_head *error_q,
-				      struct sas_port *port)
+				      struct asd_sas_port *port)
 {
 	struct scsi_cmnd *cmd, *n;
 
 	list_for_each_entry_safe(cmd, n, error_q, eh_entry) {
 		struct domain_device *dev = cmd_to_domain_dev(cmd);
-		struct sas_port *x = dev->port;
+		struct asd_sas_port *x = dev->port;
 
 		if (x == port)
 			list_del_init(&cmd->eh_entry);
@@ -457,7 +457,7 @@ Again:
 			}
 			/* Hammer time :-) */
 			if (i->dft->lldd_clear_nexus_port) {
-				struct sas_port *port = task->dev->port;
+				struct asd_sas_port *port = task->dev->port;
 				SAS_DPRINTK("clearing nexus for port:%d\n",
 					    port->id);
 				res = i->dft->lldd_clear_nexus_port(port);
@@ -542,7 +542,7 @@ int sas_target_alloc(struct scsi_target 
 
 	spin_lock(&ha->phy_port_lock);
 	for (i = 0; i < ha->num_phys; i++) {
-		struct sas_port *port = ha->sas_port[i];
+		struct asd_sas_port *port = ha->sas_port[i];
 		struct domain_device *dev;
 
 		spin_lock(&port->dev_list_lock);
diff --git a/include/scsi/sas/sas_class.h b/include/scsi/sas/sas_class.h
index ba789b3..0c3aae5 100644
--- a/include/scsi/sas/sas_class.h
+++ b/include/scsi/sas/sas_class.h
@@ -86,6 +86,8 @@ enum discover_event {
 };
 #define DISC_NUM_EVENTS 3
 
+struct asd_sas_port;
+
 /* The phy pretty much is controlled by the LLDD.
  * The class only reads those fields.
  */
@@ -127,15 +129,13 @@ struct asd_sas_phy {
 	u32            sas_prim;
 
 	struct list_head port_phy_el; /* driver:RO */
-	struct sas_port      *port; /* Class:RW, driver: RO */
+	struct asd_sas_port      *port; /* Class:RW, driver: RO */
 
 	struct sas_ha_struct *ha; /* may be set; the class sets it anyway */
 
 	void *lldd_phy;		  /* not touched by the sas_class_code */
 };
 
-struct sas_port;
-
 struct sas_discovery {
 	spinlock_t disc_event_lock;
 	struct work_struct disc_work[DISC_NUM_EVENTS];
@@ -149,7 +149,7 @@ struct sas_discovery {
 struct domain_device;
 
 /* The port struct is Class:RW, driver:RO */
-struct sas_port {
+struct asd_sas_port {
 /* private: */
 	struct completion port_gone_completion;
 
@@ -214,7 +214,7 @@ struct sas_ha_struct {
 
 	spinlock_t      phy_port_lock;
 	struct asd_sas_phy  **sas_phy; /* array of valid pointers, must be set */
-	struct sas_port **sas_port; /* array of valid pointers, must be set */
+	struct asd_sas_port **sas_port; /* array of valid pointers, must be set */
 	int             num_phys; /* must be set, gt 0, static */
 
 	/* The class calls this to send a task for execution. */
@@ -251,7 +251,7 @@ struct sas_domain_function_template {
 	int (*lldd_query_task)(struct sas_task *);
 
 	/* Port and Adapter management */
-	int (*lldd_clear_nexus_port)(struct sas_port *);
+	int (*lldd_clear_nexus_port)(struct asd_sas_port *);
 	int (*lldd_clear_nexus_ha)(struct sas_ha_struct *);
 
 	/* Phy management */
diff --git a/include/scsi/sas/sas_discover.h b/include/scsi/sas/sas_discover.h
index a870c2b..cb2a673 100644
--- a/include/scsi/sas/sas_discover.h
+++ b/include/scsi/sas/sas_discover.h
@@ -94,7 +94,7 @@ struct domain_device {
 
 	struct domain_device *parent;
 	struct list_head siblings; /* devices on the same level */
-	struct sas_port *port;	  /* shortcut to root of the tree */
+	struct asd_sas_port *port;	  /* shortcut to root of the tree */
 
 	struct list_head dev_list_node;
 
@@ -144,8 +144,8 @@ static inline void sas_init_dev(struct d
 	}
 }
 
-void sas_init_disc(struct sas_discovery *disc, struct sas_port *port);
-int  sas_discover_event(struct sas_port *sas_port, enum discover_event ev);
+void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *port);
+int  sas_discover_event(struct asd_sas_port *sas_port, enum discover_event ev);
 
 int  sas_discover_sata(struct domain_device *dev);
 int  sas_discover_end_dev(struct domain_device *dev);


