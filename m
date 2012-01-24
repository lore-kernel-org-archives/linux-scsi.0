From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v7 0/6] libsas error handling + discovery v7
Date: Mon, 23 Jan 2012 23:50:14 -0800
Message-ID: <20120124074825.22384.17157.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Changes since v6: http://marc.info/?l=linux-scsi&m=132711081125550&w=2

1/ "isci: kill iphy->isci_port lookups": refreshed to fix a build error on
    32-bit.  I think it is time for these changes to get some soak time in
    -next.

2/ "libsas: improve debug statements": changed 'routing char' for
    table-to-table capable expanders to 'U' per Doug.

3/ "libsas: let libata recover links that fail to transmit initial
    sig-fis": no functional changes, content rebased due to note 2.

4/ "libsas: async ata scanning": fixed to close potential crash if eh is
    already active when libsas tries to probe a new device.

5/ new "libsas: fix lifetime of SAS_HA_FROZEN": slub debug caught a
    regression due to SAS_HA_FROZEN preventing eh_scmds from being completed
    normally.

6/ new "libsas: revert ata srst": originally added to take advantage of
    the srst generation capabilities of isci, but since isci has opted not
    to use it we no longer need to carry it upstream.

[PATCH 0/1] isci: kill iphy->isci_port lookups
[PATCH 0/2] libsas: improve debug statements
[PATCH 0/3] libsas: let libata recover links that fail to transmit initial sig-fis
[PATCH 0/4] libsas: async ata scanning
[PATCH 0/5] libsas: fix lifetime of SAS_HA_FROZEN
[PATCH 0/6] libsas: revert ata srst

Incremental diff (libsas-eh-reworks-v6..libsas-eh-reworks-v7):

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index eca9ba0..d8d2068 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -1710,7 +1710,7 @@ void isci_port_deformed(struct asd_sas_phy *phy)
 
 	if (i >= SCI_MAX_PHYS)
 		dev_dbg(&ihost->pdev->dev, "%s: port: %ld\n",
-			__func__, iport - &ihost->ports[0]);
+			__func__, (long) (iport - &ihost->ports[0]));
 }
 
 void isci_port_formed(struct asd_sas_phy *phy)
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index fe60736..653aa97 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -376,7 +376,7 @@ static int local_ata_check_ready(struct ata_link *link)
 }
 
 static int sas_ata_printk(const char *level, const struct domain_device *ddev,
-		          const char *fmt, ...)
+			  const char *fmt, ...)
 {
 	struct ata_port *ap = ddev->sata_dev.ap;
 	struct device *dev = &ddev->rphy->dev;
@@ -443,43 +443,6 @@ static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,
 	return ret;
 }
 
-static int sas_ata_soft_reset(struct ata_link *link, unsigned int *class,
-			       unsigned long deadline)
-{
-	struct ata_port *ap = link->ap;
-	struct domain_device *dev = ap->private_data;
-	struct sas_internal *i = dev_to_sas_internal(dev);
-	int res = TMF_RESP_FUNC_FAILED;
-	int ret = 0;
-
-	if (i->dft->lldd_ata_soft_reset)
-		res = i->dft->lldd_ata_soft_reset(dev);
-
-	if (res != TMF_RESP_FUNC_COMPLETE) {
-		SAS_DPRINTK("%s: Unable to soft reset\n", __func__);
-		ret = -EAGAIN;
-	}
-
-	switch (dev->sata_dev.command_set) {
-	case ATA_COMMAND_SET:
-		SAS_DPRINTK("%s: Found ATA device.\n", __func__);
-		*class = ATA_DEV_ATA;
-		break;
-	case ATAPI_COMMAND_SET:
-		SAS_DPRINTK("%s: Found ATAPI device.\n", __func__);
-		*class = ATA_DEV_ATAPI;
-		break;
-	default:
-		SAS_DPRINTK("%s: Unknown SATA command set: %d.\n",
-			    __func__, dev->sata_dev.command_set);
-		*class = ATA_DEV_UNKNOWN;
-		break;
-	}
-
-	ap->cbl = ATA_CBL_SATA;
-	return ret;
-}
-
 /*
  * notify the lldd to forget the sas_task for this internal ata command
  * that bypasses scsi-eh
@@ -563,7 +526,6 @@ static void sas_ata_set_dmamode(struct ata_port *ap, struct ata_device *ata_dev)
 
 static struct ata_port_operations sas_sata_ops = {
 	.prereset		= ata_std_prereset,
-	.softreset		= sas_ata_soft_reset,
 	.hardreset		= sas_ata_hard_reset,
 	.postreset		= ata_std_postreset,
 	.error_handler		= ata_std_error_handler,
@@ -606,6 +568,8 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev)
 	ap->private_data = found_dev;
 	ap->cbl = ATA_CBL_SATA;
 	ap->scsi_host = shost;
+	/* publish initialized ata port */
+	smp_wmb();
 	found_dev->sata_dev.ap = ap;
 
 	return 0;
@@ -760,6 +724,18 @@ static void async_sas_ata_eh(void *data, async_cookie_t cookie)
 	wake_up(&ha->core.shost->host_wait);
 }
 
+static bool sas_ata_dev_eh_valid(struct domain_device *dev)
+{
+	struct ata_port *ap;
+
+	if (!dev_is_sata(dev))
+		return false;
+	ap = dev->sata_dev.ap;
+	/* consume fully initialized ata ports */
+	smp_rmb();
+	return !!ap;
+}
+
 void sas_ata_strategy_handler(struct Scsi_Host *shost)
 {
 	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
@@ -783,7 +759,7 @@ void sas_ata_strategy_handler(struct Scsi_Host *shost)
 
 		spin_lock(&port->dev_list_lock);
 		list_for_each_entry(dev, &port->dev_list, dev_list_node) {
-			if (!dev_is_sata(dev))
+			if (!sas_ata_dev_eh_valid(dev))
 				continue;
 			async_schedule_domain(async_sas_ata_eh, dev, &async);
 		}
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 0aa90d7..14e3244 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -166,6 +166,23 @@ static inline void *alloc_smp_resp(int size)
 	return kzalloc(size, GFP_KERNEL);
 }
 
+static char sas_route_char(struct domain_device *dev, struct ex_phy *phy)
+{
+	switch (phy->routing_attr) {
+	case TABLE_ROUTING:
+		if (dev->ex_dev.t2t_supp)
+			return 'U';
+		else
+			return 'T';
+	case DIRECT_ROUTING:
+		return 'D';
+	case SUBTRACTIVE_ROUTING:
+		return 'S';
+	default:
+		return '?';
+	}
+}
+
 static enum sas_dev_type to_dev_type(struct discover_resp *dr)
 {
 	/* This is detecting a failure to transmit initial dev to host
@@ -287,10 +304,8 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 
 	SAS_DPRINTK("ex %016llx phy%02d:%c:%X attached: %016llx (%s)\n",
 		    SAS_ADDR(dev->sas_addr), phy->phy_id,
-		    phy->routing_attr == TABLE_ROUTING ? 'T' :
-		    phy->routing_attr == DIRECT_ROUTING ? 'D' :
-		    phy->routing_attr == SUBTRACTIVE_ROUTING ? 'S' : '?',
-		    phy->linkrate, SAS_ADDR(phy->attached_sas_addr), type);
+		    sas_route_char(dev, phy), phy->linkrate,
+		    SAS_ADDR(phy->attached_sas_addr), type);
 }
 
 /* check if we have an existing attached ata device on this expander phy */
@@ -1192,32 +1207,25 @@ static void sas_print_parent_topology_bug(struct domain_device *child,
 						 struct ex_phy *parent_phy,
 						 struct ex_phy *child_phy)
 {
-	static const char ra_char[] = {
-		[DIRECT_ROUTING] = 'D',
-		[SUBTRACTIVE_ROUTING] = 'S',
-		[TABLE_ROUTING] = 'T',
-	};
 	static const char *ex_type[] = {
 		[EDGE_DEV] = "edge",
 		[FANOUT_DEV] = "fanout",
 	};
 	struct domain_device *parent = child->parent;
 
-	sas_printk("%s ex %016llx (T2T supp:%d) phy 0x%x <--> %s ex %016llx "
-		   "(T2T supp:%d) phy 0x%x has %c:%c routing link!\n",
+	sas_printk("%s ex %016llx phy 0x%x <--> %s ex %016llx "
+		   "phy 0x%x has %c:%c routing link!\n",
 
 		   ex_type[parent->dev_type],
 		   SAS_ADDR(parent->sas_addr),
-		   parent->ex_dev.t2t_supp,
 		   parent_phy->phy_id,
 
 		   ex_type[child->dev_type],
 		   SAS_ADDR(child->sas_addr),
-		   child->ex_dev.t2t_supp,
 		   child_phy->phy_id,
 
-		   ra_char[parent_phy->routing_attr],
-		   ra_char[child_phy->routing_attr]);
+		   sas_route_char(parent, parent_phy),
+		   sas_route_char(child, child_phy));
 }
 
 static int sas_check_eeds(struct domain_device *child,
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 3701ff7..fd32913 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -521,8 +521,7 @@ try_bus_reset:
 	return FAILED;
 }
 
-static int sas_eh_handle_sas_errors(struct Scsi_Host *shost,
-				    struct list_head *work_q)
+static void sas_eh_handle_sas_errors(struct Scsi_Host *shost, struct list_head *work_q)
 {
 	struct scsi_cmnd *cmd, *n;
 	enum task_disposition res = TASK_IS_DONE;
@@ -658,7 +657,7 @@ static int sas_eh_handle_sas_errors(struct Scsi_Host *shost,
  out:
 	list_splice_tail(&done, work_q);
 	list_splice_tail_init(&ha->eh_ata_q, work_q);
-	return list_empty(work_q);
+	return;
 
  clear_q:
 	SAS_DPRINTK("--- Exit %s -- clear_q\n", __func__);
@@ -682,10 +681,13 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 		    __func__, shost->host_busy, shost->host_failed);
 	/*
 	 * Deal with commands that still have SAS tasks (i.e. they didn't
-	 * complete via the normal sas_task completion mechanism)
+	 * complete via the normal sas_task completion mechanism),
+	 * SAS_HA_FROZEN gives eh dominion over all sas_task completion.
 	 */
 	set_bit(SAS_HA_FROZEN, &ha->state);
-	if (sas_eh_handle_sas_errors(shost, &eh_work_q))
+	sas_eh_handle_sas_errors(shost, &eh_work_q);
+	clear_bit(SAS_HA_FROZEN, &ha->state);
+	if (list_empty(&eh_work_q))
 		goto out;
 
 	/*
@@ -699,7 +701,6 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 		scsi_eh_ready_devs(shost, &eh_work_q, &ha->eh_done_q);
 
 out:
-	clear_bit(SAS_HA_FROZEN, &ha->state);
 	if (ha->lldd_max_execute_num > 1)
 		wake_up_process(ha->core.queue_thread);
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 20153d5..5f5ed1b 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -619,7 +619,6 @@ struct sas_domain_function_template {
 	int (*lldd_clear_aca)(struct domain_device *, u8 *lun);
 	int (*lldd_clear_task_set)(struct domain_device *, u8 *lun);
 	int (*lldd_I_T_nexus_reset)(struct domain_device *);
-	int (*lldd_ata_soft_reset)(struct domain_device *);
 	int (*lldd_ata_check_ready)(struct domain_device *);
 	void (*lldd_ata_set_dmamode)(struct domain_device *);
 	int (*lldd_lu_reset)(struct domain_device *, u8 *lun);
