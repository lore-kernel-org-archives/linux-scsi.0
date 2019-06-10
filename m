From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2] scsi: libsas, lldds: Use dev_is_expander()
Date: Mon, 10 Jun 2019 20:41:41 +0800
Message-ID: <1560170501-220025-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: intel-linux-scu@intel.com, artur.paszkiewicz@intel.com, jinpu.wang@profitbricks.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Many times in libsas, and in LLDDs which use libsas, the check for an
expander device is re-implemented or open coded.

Use dev_is_expander() instead. We rename this from
sas_dev_type_is_expander() to not spill so many lines in referencing.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
Differences to v1:
- Fix isci build
- add review tags

diff --git a/drivers/scsi/aic94xx/aic94xx_dev.c b/drivers/scsi/aic94xx/aic94xx_dev.c
index 33072388ea16..e528a2ce9602 100644
--- a/drivers/scsi/aic94xx/aic94xx_dev.c
+++ b/drivers/scsi/aic94xx/aic94xx_dev.c
@@ -187,9 +187,7 @@ static int asd_init_target_ddb(struct domain_device *dev)
 			}
 		} else {
 			flags |= CONCURRENT_CONN_SUPP;
-			if (!dev->parent &&
-			    (dev->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
-			     dev->dev_type == SAS_FANOUT_EXPANDER_DEVICE))
+			if (!dev->parent && dev_is_expander(dev->dev_type))
 				asd_ddbsite_write_byte(asd_ha, ddb, MAX_CCONN,
 						       4);
 			else
diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 06f22fb372b1..8657977a2dd4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -66,10 +66,6 @@
 #define HISI_SAS_MAX_SMP_RESP_SZ 1028
 #define HISI_SAS_MAX_STP_RESP_SZ 28
 
-#define DEV_IS_EXPANDER(type) \
-	((type == SAS_EDGE_EXPANDER_DEVICE) || \
-	(type == SAS_FANOUT_EXPANDER_DEVICE))
-
 #define HISI_SAS_SATA_PROTOCOL_NONDATA		0x1
 #define HISI_SAS_SATA_PROTOCOL_PIO			0x2
 #define HISI_SAS_SATA_PROTOCOL_DMA			0x4
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 256f93e6f89f..90e5d947d8e4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -808,7 +808,7 @@ static int hisi_sas_dev_found(struct domain_device *device)
 	device->lldd_dev = sas_dev;
 	hisi_hba->hw->setup_itct(hisi_hba, sas_dev);
 
-	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type)) {
+	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
 		int phy_no;
 		u8 phy_num = parent_dev->ex_dev.num_phys;
 		struct ex_phy *phy;
@@ -1451,7 +1451,7 @@ static void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 old_state,
 
 				_sas_port = sas_port;
 
-				if (DEV_IS_EXPANDER(dev->dev_type))
+				if (dev_is_expander(dev->dev_type))
 					sas_ha->notify_port_event(sas_phy,
 							PORTE_BROADCAST_RCVD);
 			}
@@ -1538,7 +1538,7 @@ static void hisi_sas_terminate_stp_reject(struct hisi_hba *hisi_hba)
 		struct domain_device *port_dev = sas_port->port_dev;
 		struct domain_device *device;
 
-		if (!port_dev || !DEV_IS_EXPANDER(port_dev->dev_type))
+		if (!port_dev || !dev_is_expander(port_dev->dev_type))
 			continue;
 
 		/* Try to find a SATA device */
@@ -1908,7 +1908,7 @@ static int hisi_sas_clear_nexus_ha(struct sas_ha_struct *sas_ha)
 		struct domain_device *device = sas_dev->sas_device;
 
 		if ((sas_dev->dev_type == SAS_PHY_UNUSED) || !device ||
-		    DEV_IS_EXPANDER(device->dev_type))
+		    dev_is_expander(device->dev_type))
 			continue;
 
 		rc = hisi_sas_debug_I_T_nexus_reset(device);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index b8c0ba778293..7ebd62d2462e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -949,7 +949,7 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
 		break;
 	case SAS_SATA_DEV:
 	case SAS_SATA_PENDING:
-		if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type))
+		if (parent_dev && dev_is_expander(parent_dev->dev_type))
 			qw0 = HISI_SAS_DEV_TYPE_STP << ITCT_HDR_DEV_TYPE_OFF;
 		else
 			qw0 = HISI_SAS_DEV_TYPE_SATA << ITCT_HDR_DEV_TYPE_OFF;
@@ -2531,7 +2531,7 @@ static void prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 	/* create header */
 	/* dw0 */
 	dw0 = port->id << CMD_HDR_PORT_OFF;
-	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type))
+	if (parent_dev && dev_is_expander(parent_dev->dev_type))
 		dw0 |= 3 << CMD_HDR_CMD_OFF;
 	else
 		dw0 |= 4 << CMD_HDR_CMD_OFF;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index b92aa6b37e1d..b75bf92066a9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -759,7 +759,7 @@ static void setup_itct_v3_hw(struct hisi_hba *hisi_hba,
 		break;
 	case SAS_SATA_DEV:
 	case SAS_SATA_PENDING:
-		if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type))
+		if (parent_dev && dev_is_expander(parent_dev->dev_type))
 			qw0 = HISI_SAS_DEV_TYPE_STP << ITCT_HDR_DEV_TYPE_OFF;
 		else
 			qw0 = HISI_SAS_DEV_TYPE_SATA << ITCT_HDR_DEV_TYPE_OFF;
@@ -1358,7 +1358,7 @@ static void prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 	u32 dw1 = 0, dw2 = 0;
 
 	hdr->dw0 = cpu_to_le32(port->id << CMD_HDR_PORT_OFF);
-	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type))
+	if (parent_dev && dev_is_expander(parent_dev->dev_type))
 		hdr->dw0 |= cpu_to_le32(3 << CMD_HDR_CMD_OFF);
 	else
 		hdr->dw0 |= cpu_to_le32(4U << CMD_HDR_CMD_OFF);
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 9d29edb9f590..49aa4e657c44 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1087,7 +1087,7 @@ static void sci_remote_device_ready_state_enter(struct sci_base_state_machine *s
 
 	if (dev->dev_type == SAS_SATA_DEV || (dev->tproto & SAS_PROTOCOL_SATA)) {
 		sci_change_state(&idev->sm, SCI_STP_DEV_IDLE);
-	} else if (dev_is_expander(dev)) {
+	} else if (dev_is_expander(dev->dev_type)) {
 		sci_change_state(&idev->sm, SCI_SMP_DEV_IDLE);
 	} else
 		isci_remote_device_ready(ihost, idev);
@@ -1478,7 +1478,7 @@ static enum sci_status isci_remote_device_construct(struct isci_port *iport,
 	struct domain_device *dev = idev->domain_dev;
 	enum sci_status status;
 
-	if (dev->parent && dev_is_expander(dev->parent))
+	if (dev->parent && dev_is_expander(dev->parent->dev_type))
 		status = sci_remote_device_ea_construct(iport, idev);
 	else
 		status = sci_remote_device_da_construct(iport, idev);
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index 47a013fffae7..3ad681c4c20a 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -295,11 +295,6 @@ static inline struct isci_remote_device *rnc_to_dev(struct sci_remote_node_conte
 	return idev;
 }
 
-static inline bool dev_is_expander(struct domain_device *dev)
-{
-	return dev->dev_type == SAS_EDGE_EXPANDER_DEVICE || dev->dev_type == SAS_FANOUT_EXPANDER_DEVICE;
-}
-
 static inline void sci_remote_device_decrement_request_count(struct isci_remote_device *idev)
 {
 	/* XXX delete this voodoo when converting to the top-level device
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index c552b4b59717..343d24c7e788 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -3101,7 +3101,7 @@ sci_io_request_construct(struct isci_host *ihost,
 		/* pass */;
 	else if (dev_is_sata(dev))
 		memset(&ireq->stp.cmd, 0, sizeof(ireq->stp.cmd));
-	else if (dev_is_expander(dev))
+	else if (dev_is_expander(dev->dev_type))
 		/* pass */;
 	else
 		return SCI_FAILURE_UNSUPPORTED_PROTOCOL;
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index fb6eba331ac6..26fa1a4d1e6b 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -511,7 +511,7 @@ int isci_task_abort_task(struct sas_task *task)
 		 "%s: dev = %p (%s%s), task = %p, old_request == %p\n",
 		 __func__, idev,
 		 (dev_is_sata(task->dev) ? "STP/SATA"
-					 : ((dev_is_expander(task->dev))
+					 : ((dev_is_expander(task->dev->dev_type))
 						? "SMP"
 						: "SSP")),
 		 ((idev) ? ((test_bit(IDEV_GONE, &idev->flags))
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 2518cecb7edf..abcad097ff2f 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -293,7 +293,7 @@ void sas_free_device(struct kref *kref)
 	dev->phy = NULL;
 
 	/* remove the phys and ports, everything else should be gone */
-	if (dev->dev_type == SAS_EDGE_EXPANDER_DEVICE || dev->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
+	if (dev_is_expander(dev->dev_type))
 		kfree(dev->ex_dev.ex_phy);
 
 	if (dev_is_sata(dev) && dev->sata_dev.ap) {
@@ -503,8 +503,7 @@ static void sas_revalidate_domain(struct work_struct *work)
 	pr_debug("REVALIDATING DOMAIN on port %d, pid:%d\n", port->id,
 		 task_pid_nr(current));
 
-	if (ddev && (ddev->dev_type == SAS_FANOUT_EXPANDER_DEVICE ||
-		     ddev->dev_type == SAS_EDGE_EXPANDER_DEVICE))
+	if (ddev && dev_is_expander(ddev->dev_type))
 		res = sas_ex_revalidate_domain(ddev);
 
 	pr_debug("done REVALIDATING DOMAIN on port %d, pid:%d, res 0x%x\n",
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index fd16a3debef4..ecae55f117a3 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1120,8 +1120,7 @@ static int sas_find_sub_addr(struct domain_device *dev, u8 *sub_addr)
 		    phy->phy_state == PHY_NOT_PRESENT)
 			continue;
 
-		if ((phy->attached_dev_type == SAS_EDGE_EXPANDER_DEVICE ||
-		     phy->attached_dev_type == SAS_FANOUT_EXPANDER_DEVICE) &&
+		if (dev_is_expander(phy->attached_dev_type) &&
 		    phy->routing_attr == SUBTRACTIVE_ROUTING) {
 
 			memcpy(sub_addr, phy->attached_sas_addr, SAS_ADDR_SIZE);
@@ -1139,8 +1138,7 @@ static int sas_check_level_subtractive_boundary(struct domain_device *dev)
 	u8 sub_addr[SAS_ADDR_SIZE] = {0, };
 
 	list_for_each_entry(child, &ex->children, siblings) {
-		if (child->dev_type != SAS_EDGE_EXPANDER_DEVICE &&
-		    child->dev_type != SAS_FANOUT_EXPANDER_DEVICE)
+		if (!dev_is_expander(child->dev_type))
 			continue;
 		if (sub_addr[0] == 0) {
 			sas_find_sub_addr(child, sub_addr);
@@ -1225,8 +1223,7 @@ static int sas_check_ex_subtractive_boundary(struct domain_device *dev)
 		    phy->phy_state == PHY_NOT_PRESENT)
 			continue;
 
-		if ((phy->attached_dev_type == SAS_FANOUT_EXPANDER_DEVICE ||
-		     phy->attached_dev_type == SAS_EDGE_EXPANDER_DEVICE) &&
+		if (dev_is_expander(phy->attached_dev_type) &&
 		    phy->routing_attr == SUBTRACTIVE_ROUTING) {
 
 			if (!sub_sas_addr)
@@ -1322,8 +1319,7 @@ static int sas_check_parent_topology(struct domain_device *child)
 	if (!child->parent)
 		return 0;
 
-	if (child->parent->dev_type != SAS_EDGE_EXPANDER_DEVICE &&
-	    child->parent->dev_type != SAS_FANOUT_EXPANDER_DEVICE)
+	if (!dev_is_expander(child->parent->dev_type))
 		return 0;
 
 	parent_ex = &child->parent->ex_dev;
@@ -1619,8 +1615,7 @@ static int sas_ex_level_discovery(struct asd_sas_port *port, const int level)
 	struct domain_device *dev;
 
 	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
-		if (dev->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
-		    dev->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
+		if (dev_is_expander(dev->dev_type)) {
 			struct sas_expander_device *ex =
 				rphy_to_expander_device(dev->rphy);
 
@@ -1852,7 +1847,7 @@ static int sas_find_bcast_dev(struct domain_device *dev,
 				SAS_ADDR(dev->sas_addr));
 	}
 	list_for_each_entry(ch, &ex->children, siblings) {
-		if (ch->dev_type == SAS_EDGE_EXPANDER_DEVICE || ch->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
+		if (dev_is_expander(ch->dev_type)) {
 			res = sas_find_bcast_dev(ch, src_dev);
 			if (*src_dev)
 				return res;
@@ -1869,8 +1864,7 @@ static void sas_unregister_ex_tree(struct asd_sas_port *port, struct domain_devi
 
 	list_for_each_entry_safe(child, n, &ex->children, siblings) {
 		set_bit(SAS_DEV_GONE, &child->state);
-		if (child->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
-		    child->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
+		if (dev_is_expander(child->dev_type))
 			sas_unregister_ex_tree(port, child);
 		else
 			sas_unregister_dev(port, child);
@@ -1890,8 +1884,7 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 			if (SAS_ADDR(child->sas_addr) ==
 			    SAS_ADDR(phy->attached_sas_addr)) {
 				set_bit(SAS_DEV_GONE, &child->state);
-				if (child->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
-				    child->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
+				if (dev_is_expander(child->dev_type))
 					sas_unregister_ex_tree(parent->port, child);
 				else
 					sas_unregister_dev(parent->port, child);
@@ -1920,8 +1913,7 @@ static int sas_discover_bfs_by_root_level(struct domain_device *root,
 	int res = 0;
 
 	list_for_each_entry(child, &ex_root->children, siblings) {
-		if (child->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
-		    child->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
+		if (dev_is_expander(child->dev_type)) {
 			struct sas_expander_device *ex =
 				rphy_to_expander_device(child->rphy);
 
@@ -1974,8 +1966,7 @@ static int sas_discover_new(struct domain_device *dev, int phy_id)
 	list_for_each_entry(child, &dev->ex_dev.children, siblings) {
 		if (SAS_ADDR(child->sas_addr) ==
 		    SAS_ADDR(ex_phy->attached_sas_addr)) {
-			if (child->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
-			    child->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
+			if (dev_is_expander(child->dev_type))
 				res = sas_discover_bfs_by_root(child);
 			break;
 		}
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 11f028a441dd..7c86fd248129 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -54,7 +54,7 @@ static void sas_resume_port(struct asd_sas_phy *phy)
 			continue;
 		}
 
-		if (dev->dev_type == SAS_EDGE_EXPANDER_DEVICE || dev->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
+		if (dev_is_expander(dev->dev_type)) {
 			dev->ex_dev.ex_change_count = -1;
 			for (i = 0; i < dev->ex_dev.num_phys; i++) {
 				struct ex_phy *phy = &dev->ex_dev.ex_phy[i];
@@ -179,7 +179,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 
 	sas_discover_event(phy->port, DISCE_DISCOVER_DOMAIN);
 	/* Only insert a revalidate event after initial discovery */
-	if (port_dev && sas_dev_type_is_expander(port_dev->dev_type)) {
+	if (port_dev && dev_is_expander(port_dev->dev_type)) {
 		struct expander_device *ex_dev = &port_dev->ex_dev;
 
 		ex_dev->ex_change_count = -1;
@@ -248,7 +248,7 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)
 	spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
 
 	/* Only insert revalidate event if the port still has members */
-	if (port->port && dev && sas_dev_type_is_expander(dev->dev_type)) {
+	if (port->port && dev && dev_is_expander(dev->dev_type)) {
 		struct expander_device *ex_dev = &dev->ex_dev;
 
 		ex_dev->ex_change_count = -1;
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index e933c65d8e0b..0ee688f52990 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1209,7 +1209,7 @@ static int mvs_dev_found_notify(struct domain_device *dev, int lock)
 	mvi_device->dev_type = dev->dev_type;
 	mvi_device->mvi_info = mvi;
 	mvi_device->sas_device = dev;
-	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type)) {
+	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
 		int phy_id;
 		u8 phy_num = parent_dev->ex_dev.num_phys;
 		struct ex_phy *phy;
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 080676c1c9e5..b391c03fe5f5 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -66,9 +66,6 @@ extern struct mvs_info *tgt_mvi;
 extern const struct mvs_dispatch mvs_64xx_dispatch;
 extern const struct mvs_dispatch mvs_94xx_dispatch;
 
-#define DEV_IS_EXPANDER(type)	\
-	((type == SAS_EDGE_EXPANDER_DEVICE) || (type == SAS_FANOUT_EXPANDER_DEVICE))
-
 #define bit(n) ((u64)1 << n)
 
 #define for_each_phy(__lseq_mask, __mc, __lseq)			\
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 109effd3557d..68a8217032d0 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2356,7 +2356,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
 		(status != IO_UNDERFLOW)) {
 		if (!((t->dev->parent) &&
-			(DEV_IS_EXPANDER(t->dev->parent->dev_type)))) {
+			(dev_is_expander(t->dev->parent->dev_type)))) {
 			for (i = 0 , j = 4; j <= 7 && i <= 3; i++ , j++)
 				sata_addr_low[i] = pm8001_ha->sas_addr[j];
 			for (i = 0 , j = 0; j <= 3 && i <= 3; i++ , j++)
@@ -4560,7 +4560,7 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 			pm8001_dev->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
 			stp_sspsmp_sata = 0x01; /*ssp or smp*/
 	}
-	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type))
+	if (parent_dev && dev_is_expander(parent_dev->dev_type))
 		phy_id = parent_dev->ex_dev.ex_phy->phy_id;
 	else
 		phy_id = pm8001_dev->attached_phy;
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 3de57c5a3299..dd38c356a1a4 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -634,7 +634,7 @@ static int pm8001_dev_found_notify(struct domain_device *dev)
 	dev->lldd_dev = pm8001_device;
 	pm8001_device->dev_type = dev->dev_type;
 	pm8001_device->dcompletion = &completion;
-	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type)) {
+	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
 		int phy_id;
 		struct ex_phy *phy;
 		for (phy_id = 0; phy_id < parent_dev->ex_dev.num_phys;
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index ac6d8e3f22de..ff17c6aff63d 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -103,7 +103,6 @@ do {						\
 #define PM8001_READ_VPD
 
 
-#define DEV_IS_EXPANDER(type)	((type == SAS_EDGE_EXPANDER_DEVICE) || (type == SAS_FANOUT_EXPANDER_DEVICE))
 #define IS_SPCV_12G(dev)	((dev->device == 0X8074)		\
 				|| (dev->device == 0X8076)		\
 				|| (dev->device == 0X8077)		\
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 301de40eb708..1128d86d241a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2066,7 +2066,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
 		(status != IO_UNDERFLOW)) {
 		if (!((t->dev->parent) &&
-			(DEV_IS_EXPANDER(t->dev->parent->dev_type)))) {
+			(dev_is_expander(t->dev->parent->dev_type)))) {
 			for (i = 0 , j = 4; i <= 3 && j <= 7; i++ , j++)
 				sata_addr_low[i] = pm8001_ha->sas_addr[j];
 			for (i = 0 , j = 0; i <= 3 && j <= 3; i++ , j++)
@@ -4561,7 +4561,7 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 			pm8001_dev->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
 			stp_sspsmp_sata = 0x01; /*ssp or smp*/
 	}
-	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type))
+	if (parent_dev && dev_is_expander(parent_dev->dev_type))
 		phy_id = parent_dev->ex_dev.ex_phy->phy_id;
 	else
 		phy_id = pm8001_dev->attached_phy;
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 901355a1bc53..a8565a87291d 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -207,8 +207,7 @@ struct sas_work {
 	struct work_struct work;
 };
 
-/* Lots of code duplicates this in the SCSI tree, which can be factored out */
-static inline bool sas_dev_type_is_expander(enum sas_device_type type)
+static inline bool dev_is_expander(enum sas_device_type type)
 {
 	return type == SAS_EDGE_EXPANDER_DEVICE ||
 	       type == SAS_FANOUT_EXPANDER_DEVICE;
-- 
2.17.1
