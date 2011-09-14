From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.1-rc6
Date: Wed, 14 Sep 2011 17:31:30 -0500
Message-ID: <1316039490.3001.75.camel@dabdike.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a set of mostly isci and qla2xxx with minor bnx2i and hpsa ones.
They've been in linux-next since before master.kernel.org was taken
offline, so they should have had lots of testing (sorry for the delay,
was hoping not to have to set up my own git server).

The head sha1 is

commit 610602f369b4c810c9df05e431abd38f38cb8e0d

The fix is available here:

git://bedivere.hansenpartnership.com/git/scsi-rc-fixes-2.6.git

The short changelog is:

Andrew Vasquez (1):
      qla2xxx: Correct inadvertent loop state transitions during port-update handling.

Arun Easi (2):
      qla2xxx: T10 DIF - Fix incorrect error reporting.
      qla2xxx: T10 DIF - Handle uninitalized sectors.

Chad Dupuis (3):
      qla2xxx: Update version number to 8.03.07.07-k.
      qla2xxx: Double check for command completion if abort mailbox command fails.
      qla2xxx: Fix qla24xx revision check while enabling interrupts.

Dan Williams (5):
      isci: add version number
      isci: fix event-get pointer increment
      isci: dynamic interrupt coalescing
      isci: fix 32-bit operation when CONFIG_HIGHMEM64G=n
      isci: fix sata response handling

Dave Jiang (2):
      isci: Adding documentation to API change and fixup sysfs registration
      isci: Update MAINTAINERS entry for the isci driver

Eddie Wai (1):
      bnx2i: Fixed the endian on TTT for NOP out transmission

Jeff Skirvin (1):
      isci: Leave requests alone if already terminating.

Marcin Tomczak (1):
      isci: change sas phy timeouts from 54us to 59us

Robert Love (1):
      fcoe: Fix deadlock between fip's recv_work and rtnl

Saurav Kashyap (3):
      qla2xxx: Set the task attributes after memsetting fcp cmnd.
      qla2xxx: Save and restore irq in the response queue interrupt handler.
      qla2xxx: Acquire hardware lock while manipulating dsd list.

Stephen M. Cameron (2):
      hpsa: fix physical device lun and target numbering problem
      hpsa: fix problem that OBDR devices are not detected

Vasu Dev (2):
      libfc: block SCSI eh thread for blocked rports
      libfc: fix fc_eh_host_reset

Yi Zou (1):
      libfc: fix referencing to fc_fcp_pkt from the frame pointer via fr_fsp()


And the diffstat:

 Documentation/ABI/testing/sysfs-class-scsi_host |   13 +
 MAINTAINERS                                     |   11 +
 drivers/scsi/bnx2i/bnx2i_hwi.c                  |    2 +-
 drivers/scsi/fcoe/fcoe.c                        |   13 +-
 drivers/scsi/hpsa.c                             |   57 +++--
 drivers/scsi/isci/host.c                        |   13 +-
 drivers/scsi/isci/host.h                        |    3 +
 drivers/scsi/isci/init.c                        |   47 +++--
 drivers/scsi/isci/phy.c                         |   13 +
 drivers/scsi/isci/registers.h                   |   12 +
 drivers/scsi/isci/request.c                     |   30 ++--
 drivers/scsi/isci/unsolicited_frame_control.c   |    2 +-
 drivers/scsi/isci/unsolicited_frame_control.h   |    2 +-
 drivers/scsi/libfc/fc_exch.c                    |   59 ++++--
 drivers/scsi/libfc/fc_fcp.c                     |   11 +-
 drivers/scsi/libfc/fc_lport.c                   |   11 +-
 drivers/scsi/qla2xxx/qla_attr.c                 |    7 +-
 drivers/scsi/qla2xxx/qla_dbg.c                  |   36 ++--
 drivers/scsi/qla2xxx/qla_def.h                  |    2 +
 drivers/scsi/qla2xxx/qla_fw.h                   |    5 +
 drivers/scsi/qla2xxx/qla_init.c                 |    3 -
 drivers/scsi/qla2xxx/qla_inline.h               |   29 +++
 drivers/scsi/qla2xxx/qla_iocb.c                 |  282 +++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_isr.c                  |  109 +++++++--
 drivers/scsi/qla2xxx/qla_mid.c                  |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c                   |   25 +-
 drivers/scsi/qla2xxx/qla_os.c                   |   30 ++-
 drivers/scsi/qla2xxx/qla_version.h              |    2 +-
 28 files changed, 631 insertions(+), 200 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-scsi_host

Full diff below.

James

---

diff --git a/Documentation/ABI/testing/sysfs-class-scsi_host b/Documentation/ABI/testing/sysfs-class-scsi_host
new file mode 100644
index 0000000..29a4f89
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-scsi_host
@@ -0,0 +1,13 @@
+What:		/sys/class/scsi_host/hostX/isci_id
+Date:		June 2011
+Contact:	Dave Jiang <dave.jiang@intel.com>
+Description:
+		This file contains the enumerated host ID for the Intel
+		SCU controller. The Intel(R) C600 Series Chipset SATA/SAS
+		Storage Control Unit embeds up to two 4-port controllers in
+		a single PCI device.  The controllers are enumerated in order
+		which usually means the lowest number scsi_host corresponds
+		with the first controller, but this association is not
+		guaranteed.  The 'isci_id' attribute unambiguously identifies
+		the controller index: '0' for the first controller,
+		'1' for the second.
diff --git a/MAINTAINERS b/MAINTAINERS
index 069ee3b..4fe6854 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3262,6 +3262,17 @@ F:	Documentation/input/multi-touch-protocol.txt
 F:	drivers/input/input-mt.c
 K:	\b(ABS|SYN)_MT_
 
+INTEL C600 SERIES SAS CONTROLLER DRIVER
+M:	Intel SCU Linux support <intel-linux-scu@intel.com>
+M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dave Jiang <dave.jiang@intel.com>
+M:	Ed Nadolski <edmund.nadolski@intel.com>
+L:	linux-scsi@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git
+S:	Maintained
+F:	drivers/scsi/isci/
+F:	firmware/isci/
+
 INTEL IDLE DRIVER
 M:	Len Brown <lenb@kernel.org>
 L:	linux-pm@lists.linux-foundation.org
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 9ae80cd..dba72a4 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -563,7 +563,7 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
 	nopout_wqe->itt = ((u16)task->itt |
 			   (ISCSI_TASK_TYPE_MPATH <<
 			    ISCSI_TMF_REQUEST_TYPE_SHIFT));
-	nopout_wqe->ttt = nopout_hdr->ttt;
+	nopout_wqe->ttt = be32_to_cpu(nopout_hdr->ttt);
 	nopout_wqe->flags = 0;
 	if (!unsol)
 		nopout_wqe->flags = ISCSI_NOP_OUT_REQUEST_LOCAL_COMPLETION;
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ba710e3..5d0e9a2 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -432,6 +432,8 @@ void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 	u8 flogi_maddr[ETH_ALEN];
 	const struct net_device_ops *ops;
 
+	rtnl_lock();
+
 	/*
 	 * Don't listen for Ethernet packets anymore.
 	 * synchronize_net() ensures that the packet handlers are not running
@@ -461,6 +463,8 @@ void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 					" specific feature for LLD.\n");
 	}
 
+	rtnl_unlock();
+
 	/* Release the self-reference taken during fcoe_interface_create() */
 	fcoe_interface_put(fcoe);
 }
@@ -1951,11 +1955,8 @@ static void fcoe_destroy_work(struct work_struct *work)
 	fcoe_if_destroy(port->lport);
 
 	/* Do not tear down the fcoe interface for NPIV port */
-	if (!npiv) {
-		rtnl_lock();
+	if (!npiv)
 		fcoe_interface_cleanup(fcoe);
-		rtnl_unlock();
-	}
 
 	mutex_unlock(&fcoe_config_mutex);
 }
@@ -2009,8 +2010,9 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 		printk(KERN_ERR "fcoe: Failed to create interface (%s)\n",
 		       netdev->name);
 		rc = -EIO;
+		rtnl_unlock();
 		fcoe_interface_cleanup(fcoe);
-		goto out_nodev;
+		goto out_nortnl;
 	}
 
 	/* Make this the "master" N_Port */
@@ -2027,6 +2029,7 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 
 out_nodev:
 	rtnl_unlock();
+out_nortnl:
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;
 }
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ec61bdb..b200b73 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -676,6 +676,16 @@ static void hpsa_scsi_replace_entry(struct ctlr_info *h, int hostno,
 	BUG_ON(entry < 0 || entry >= HPSA_MAX_SCSI_DEVS_PER_HBA);
 	removed[*nremoved] = h->dev[entry];
 	(*nremoved)++;
+
+	/*
+	 * New physical devices won't have target/lun assigned yet
+	 * so we need to preserve the values in the slot we are replacing.
+	 */
+	if (new_entry->target == -1) {
+		new_entry->target = h->dev[entry]->target;
+		new_entry->lun = h->dev[entry]->lun;
+	}
+
 	h->dev[entry] = new_entry;
 	added[*nadded] = new_entry;
 	(*nadded)++;
@@ -1548,10 +1558,17 @@ static inline void hpsa_set_bus_target_lun(struct hpsa_scsi_dev_t *device,
 }
 
 static int hpsa_update_device_info(struct ctlr_info *h,
-	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device)
+	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device,
+	unsigned char *is_OBDR_device)
 {
-#define OBDR_TAPE_INQ_SIZE 49
+
+#define OBDR_SIG_OFFSET 43
+#define OBDR_TAPE_SIG "$DR-10"
+#define OBDR_SIG_LEN (sizeof(OBDR_TAPE_SIG) - 1)
+#define OBDR_TAPE_INQ_SIZE (OBDR_SIG_OFFSET + OBDR_SIG_LEN)
+
 	unsigned char *inq_buff;
+	unsigned char *obdr_sig;
 
 	inq_buff = kzalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
 	if (!inq_buff)
@@ -1583,6 +1600,16 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 	else
 		this_device->raid_level = RAID_UNKNOWN;
 
+	if (is_OBDR_device) {
+		/* See if this is a One-Button-Disaster-Recovery device
+		 * by looking for "$DR-10" at offset 43 in inquiry data.
+		 */
+		obdr_sig = &inq_buff[OBDR_SIG_OFFSET];
+		*is_OBDR_device = (this_device->devtype == TYPE_ROM &&
+					strncmp(obdr_sig, OBDR_TAPE_SIG,
+						OBDR_SIG_LEN) == 0);
+	}
+
 	kfree(inq_buff);
 	return 0;
 
@@ -1716,7 +1743,7 @@ static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 		return 0;
 	}
 
-	if (hpsa_update_device_info(h, scsi3addr, this_device))
+	if (hpsa_update_device_info(h, scsi3addr, this_device, NULL))
 		return 0;
 	(*nmsa2xxx_enclosures)++;
 	hpsa_set_bus_target_lun(this_device, bus, target, 0);
@@ -1808,7 +1835,6 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	 */
 	struct ReportLUNdata *physdev_list = NULL;
 	struct ReportLUNdata *logdev_list = NULL;
-	unsigned char *inq_buff = NULL;
 	u32 nphysicals = 0;
 	u32 nlogicals = 0;
 	u32 ndev_allocated = 0;
@@ -1824,11 +1850,9 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		GFP_KERNEL);
 	physdev_list = kzalloc(reportlunsize, GFP_KERNEL);
 	logdev_list = kzalloc(reportlunsize, GFP_KERNEL);
-	inq_buff = kmalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
 	tmpdevice = kzalloc(sizeof(*tmpdevice), GFP_KERNEL);
 
-	if (!currentsd || !physdev_list || !logdev_list ||
-		!inq_buff || !tmpdevice) {
+	if (!currentsd || !physdev_list || !logdev_list || !tmpdevice) {
 		dev_err(&h->pdev->dev, "out of memory\n");
 		goto out;
 	}
@@ -1863,7 +1887,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	/* adjust our table of devices */
 	nmsa2xxx_enclosures = 0;
 	for (i = 0; i < nphysicals + nlogicals + 1; i++) {
-		u8 *lunaddrbytes;
+		u8 *lunaddrbytes, is_OBDR = 0;
 
 		/* Figure out where the LUN ID info is coming from */
 		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
@@ -1874,7 +1898,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 			continue;
 
 		/* Get device type, vendor, model, device id */
-		if (hpsa_update_device_info(h, lunaddrbytes, tmpdevice))
+		if (hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
+							&is_OBDR))
 			continue; /* skip it if we can't talk to it. */
 		figure_bus_target_lun(h, lunaddrbytes, &bus, &target, &lun,
 			tmpdevice);
@@ -1898,7 +1923,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		hpsa_set_bus_target_lun(this_device, bus, target, lun);
 
 		switch (this_device->devtype) {
-		case TYPE_ROM: {
+		case TYPE_ROM:
 			/* We don't *really* support actual CD-ROM devices,
 			 * just "One Button Disaster Recovery" tape drive
 			 * which temporarily pretends to be a CD-ROM drive.
@@ -1906,15 +1931,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 			 * device by checking for "$DR-10" in bytes 43-48 of
 			 * the inquiry data.
 			 */
-				char obdr_sig[7];
-#define OBDR_TAPE_SIG "$DR-10"
-				strncpy(obdr_sig, &inq_buff[43], 6);
-				obdr_sig[6] = '\0';
-				if (strncmp(obdr_sig, OBDR_TAPE_SIG, 6) != 0)
-					/* Not OBDR device, ignore it. */
-					break;
-			}
-			ncurrent++;
+			if (is_OBDR)
+				ncurrent++;
 			break;
 		case TYPE_DISK:
 			if (i < nphysicals)
@@ -1947,7 +1965,6 @@ out:
 	for (i = 0; i < ndev_allocated; i++)
 		kfree(currentsd[i]);
 	kfree(currentsd);
-	kfree(inq_buff);
 	kfree(physdev_list);
 	kfree(logdev_list);
 }
diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 26072f1..6981b77 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -531,6 +531,9 @@ static void sci_controller_process_completions(struct isci_host *ihost)
 			break;
 
 		case SCU_COMPLETION_TYPE_EVENT:
+			sci_controller_event_completion(ihost, ent);
+			break;
+
 		case SCU_COMPLETION_TYPE_NOTIFY: {
 			event_cycle ^= ((event_get+1) & SCU_MAX_EVENTS) <<
 				       (SMU_COMPLETION_QUEUE_GET_EVENT_CYCLE_BIT_SHIFT - SCU_MAX_EVENTS_SHIFT);
@@ -1091,6 +1094,7 @@ static void isci_host_completion_routine(unsigned long data)
 	struct isci_request *request;
 	struct isci_request *next_request;
 	struct sas_task     *task;
+	u16 active;
 
 	INIT_LIST_HEAD(&completed_request_list);
 	INIT_LIST_HEAD(&errored_request_list);
@@ -1181,6 +1185,13 @@ static void isci_host_completion_routine(unsigned long data)
 		}
 	}
 
+	/* the coalesence timeout doubles at each encoding step, so
+	 * update it based on the ilog2 value of the outstanding requests
+	 */
+	active = isci_tci_active(ihost);
+	writel(SMU_ICC_GEN_VAL(NUMBER, active) |
+	       SMU_ICC_GEN_VAL(TIMER, ISCI_COALESCE_BASE + ilog2(active)),
+	       &ihost->smu_registers->interrupt_coalesce_control);
 }
 
 /**
@@ -1471,7 +1482,7 @@ static void sci_controller_ready_state_enter(struct sci_base_state_machine *sm)
 	struct isci_host *ihost = container_of(sm, typeof(*ihost), sm);
 
 	/* set the default interrupt coalescence number and timeout value. */
-	sci_controller_set_interrupt_coalescence(ihost, 0x10, 250);
+	sci_controller_set_interrupt_coalescence(ihost, 0, 0);
 }
 
 static void sci_controller_ready_state_exit(struct sci_base_state_machine *sm)
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 062101a..9f33831 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -369,6 +369,9 @@ static inline struct isci_host *dev_to_ihost(struct domain_device *dev)
 #define ISCI_TAG_SEQ(tag) (((tag) >> 12) & (SCI_MAX_SEQ-1))
 #define ISCI_TAG_TCI(tag) ((tag) & (SCI_MAX_IO_REQUESTS-1))
 
+/* interrupt coalescing baseline: 9 == 3 to 5us interrupt delay per command */
+#define ISCI_COALESCE_BASE 9
+
 /* expander attached sata devices require 3 rnc slots */
 static inline int sci_remote_device_node_count(struct isci_remote_device *idev)
 {
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 61e0d09..29aa34e 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -59,10 +59,19 @@
 #include <linux/firmware.h>
 #include <linux/efi.h>
 #include <asm/string.h>
+#include <scsi/scsi_host.h>
 #include "isci.h"
 #include "task.h"
 #include "probe_roms.h"
 
+#define MAJ 1
+#define MIN 0
+#define BUILD 0
+#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN) "." \
+	__stringify(BUILD)
+
+MODULE_VERSION(DRV_VERSION);
+
 static struct scsi_transport_template *isci_transport_template;
 
 static DEFINE_PCI_DEVICE_TABLE(isci_id_table) = {
@@ -113,6 +122,22 @@ unsigned char max_concurr_spinup = 1;
 module_param(max_concurr_spinup, byte, 0);
 MODULE_PARM_DESC(max_concurr_spinup, "Max concurrent device spinup");
 
+static ssize_t isci_show_id(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = container_of(dev, typeof(*shost), shost_dev);
+	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
+	struct isci_host *ihost = container_of(sas_ha, typeof(*ihost), sas_ha);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", ihost->id);
+}
+
+static DEVICE_ATTR(isci_id, S_IRUGO, isci_show_id, NULL);
+
+struct device_attribute *isci_host_attrs[] = {
+	&dev_attr_isci_id,
+	NULL
+};
+
 static struct scsi_host_template isci_sht = {
 
 	.module				= THIS_MODULE,
@@ -138,6 +163,7 @@ static struct scsi_host_template isci_sht = {
 	.slave_alloc			= sas_slave_alloc,
 	.target_destroy			= sas_target_destroy,
 	.ioctl				= sas_ioctl,
+	.shost_attrs			= isci_host_attrs,
 };
 
 static struct sas_domain_function_template isci_transport_ops  = {
@@ -232,17 +258,6 @@ static int isci_register_sas_ha(struct isci_host *isci_host)
 	return 0;
 }
 
-static ssize_t isci_show_id(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct Scsi_Host *shost = container_of(dev, typeof(*shost), shost_dev);
-	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
-	struct isci_host *ihost = container_of(sas_ha, typeof(*ihost), sas_ha);
-
-	return snprintf(buf, PAGE_SIZE, "%d\n", ihost->id);
-}
-
-static DEVICE_ATTR(isci_id, S_IRUGO, isci_show_id, NULL);
-
 static void isci_unregister(struct isci_host *isci_host)
 {
 	struct Scsi_Host *shost;
@@ -251,7 +266,6 @@ static void isci_unregister(struct isci_host *isci_host)
 		return;
 
 	shost = isci_host->shost;
-	device_remove_file(&shost->shost_dev, &dev_attr_isci_id);
 
 	sas_unregister_ha(&isci_host->sas_ha);
 
@@ -415,14 +429,8 @@ static struct isci_host *isci_host_alloc(struct pci_dev *pdev, int id)
 	if (err)
 		goto err_shost_remove;
 
-	err = device_create_file(&shost->shost_dev, &dev_attr_isci_id);
-	if (err)
-		goto err_unregister_ha;
-
 	return isci_host;
 
- err_unregister_ha:
-	sas_unregister_ha(&(isci_host->sas_ha));
  err_shost_remove:
 	scsi_remove_host(shost);
  err_shost:
@@ -540,7 +548,8 @@ static __init int isci_init(void)
 {
 	int err;
 
-	pr_info("%s: Intel(R) C600 SAS Controller Driver\n", DRV_NAME);
+	pr_info("%s: Intel(R) C600 SAS Controller Driver - version %s\n",
+		DRV_NAME, DRV_VERSION);
 
 	isci_transport_template = sas_domain_attach_transport(&isci_transport_ops);
 	if (!isci_transport_template)
diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index 79313a7..430fc8f 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -104,6 +104,7 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
 	u32 parity_count = 0;
 	u32 llctl, link_rate;
 	u32 clksm_value = 0;
+	u32 sp_timeouts = 0;
 
 	iphy->link_layer_registers = reg;
 
@@ -211,6 +212,18 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
 	llctl |= SCU_SAS_LLCTL_GEN_VAL(MAX_LINK_RATE, link_rate);
 	writel(llctl, &iphy->link_layer_registers->link_layer_control);
 
+	sp_timeouts = readl(&iphy->link_layer_registers->sas_phy_timeouts);
+
+	/* Clear the default 0x36 (54us) RATE_CHANGE timeout value. */
+	sp_timeouts &= ~SCU_SAS_PHYTOV_GEN_VAL(RATE_CHANGE, 0xFF);
+
+	/* Set RATE_CHANGE timeout value to 0x3B (59us).  This ensures SCU can
+	 * lock with 3Gb drive when SCU max rate is set to 1.5Gb.
+	 */
+	sp_timeouts |= SCU_SAS_PHYTOV_GEN_VAL(RATE_CHANGE, 0x3B);
+
+	writel(sp_timeouts, &iphy->link_layer_registers->sas_phy_timeouts);
+
 	if (is_a2(ihost->pdev)) {
 		/* Program the max ARB time for the PHY to 700us so we inter-operate with
 		 * the PMC expander which shuts down PHYs if the expander PHY generates too
diff --git a/drivers/scsi/isci/registers.h b/drivers/scsi/isci/registers.h
index 9b266c7..00afc73 100644
--- a/drivers/scsi/isci/registers.h
+++ b/drivers/scsi/isci/registers.h
@@ -1299,6 +1299,18 @@ struct scu_transport_layer_registers {
 #define SCU_AFE_XCVRCR_OFFSET       0x00DC
 #define SCU_AFE_LUTCR_OFFSET        0x00E0
 
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_ALIGN_DETECTION_SHIFT          (0UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_ALIGN_DETECTION_MASK           (0x000000FFUL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_HOT_PLUG_SHIFT                 (8UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_HOT_PLUG_MASK                  (0x0000FF00UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_COMSAS_DETECTION_SHIFT         (16UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_COMSAS_DETECTION_MASK          (0x00FF0000UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_RATE_CHANGE_SHIFT              (24UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_RATE_CHANGE_MASK               (0xFF000000UL)
+
+#define SCU_SAS_PHYTOV_GEN_VAL(name, value) \
+	SCU_GEN_VALUE(SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_##name, value)
+
 #define SCU_SAS_LINK_LAYER_CONTROL_MAX_LINK_RATE_SHIFT                  (0)
 #define SCU_SAS_LINK_LAYER_CONTROL_MAX_LINK_RATE_MASK                   (0x00000003)
 #define SCU_SAS_LINK_LAYER_CONTROL_MAX_LINK_RATE_GEN1                   (0)
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index a46e07a..b5d3a8c 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -732,12 +732,20 @@ sci_io_request_terminate(struct isci_request *ireq)
 		sci_change_state(&ireq->sm, SCI_REQ_ABORTING);
 		return SCI_SUCCESS;
 	case SCI_REQ_TASK_WAIT_TC_RESP:
+		/* The task frame was already confirmed to have been
+		 * sent by the SCU HW.  Since the state machine is
+		 * now only waiting for the task response itself,
+		 * abort the request and complete it immediately
+		 * and don't wait for the task response.
+		 */
 		sci_change_state(&ireq->sm, SCI_REQ_ABORTING);
 		sci_change_state(&ireq->sm, SCI_REQ_COMPLETED);
 		return SCI_SUCCESS;
 	case SCI_REQ_ABORTING:
-		sci_change_state(&ireq->sm, SCI_REQ_COMPLETED);
-		return SCI_SUCCESS;
+		/* If a request has a termination requested twice, return
+		 * a failure indication, since HW confirmation of the first
+		 * abort is still outstanding.
+		 */
 	case SCI_REQ_COMPLETED:
 	default:
 		dev_warn(&ireq->owning_controller->pdev->dev,
@@ -2399,22 +2407,19 @@ static void isci_task_save_for_upper_layer_completion(
 	}
 }
 
-static void isci_request_process_stp_response(struct sas_task *task,
-					      void *response_buffer)
+static void isci_process_stp_response(struct sas_task *task, struct dev_to_host_fis *fis)
 {
-	struct dev_to_host_fis *d2h_reg_fis = response_buffer;
 	struct task_status_struct *ts = &task->task_status;
 	struct ata_task_resp *resp = (void *)&ts->buf[0];
 
-	resp->frame_len = le16_to_cpu(*(__le16 *)(response_buffer + 6));
-	memcpy(&resp->ending_fis[0], response_buffer + 16, 24);
+	resp->frame_len = sizeof(*fis);
+	memcpy(resp->ending_fis, fis, sizeof(*fis));
 	ts->buf_valid_size = sizeof(*resp);
 
-	/**
-	 * If the device fault bit is set in the status register, then
+	/* If the device fault bit is set in the status register, then
 	 * set the sense data and return.
 	 */
-	if (d2h_reg_fis->status & ATA_DF)
+	if (fis->status & ATA_DF)
 		ts->stat = SAS_PROTO_RESPONSE;
 	else
 		ts->stat = SAM_STAT_GOOD;
@@ -2428,7 +2433,6 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 {
 	struct sas_task *task = isci_request_access_task(request);
 	struct ssp_response_iu *resp_iu;
-	void *resp_buf;
 	unsigned long task_flags;
 	struct isci_remote_device *idev = isci_lookup_device(task->dev);
 	enum service_response response       = SAS_TASK_UNDELIVERED;
@@ -2565,9 +2569,7 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 				task);
 
 			if (sas_protocol_ata(task->task_proto)) {
-				resp_buf = &request->stp.rsp;
-				isci_request_process_stp_response(task,
-								  resp_buf);
+				isci_process_stp_response(task, &request->stp.rsp);
 			} else if (SAS_PROTOCOL_SSP == task->task_proto) {
 
 				/* crack the iu response buffer. */
diff --git a/drivers/scsi/isci/unsolicited_frame_control.c b/drivers/scsi/isci/unsolicited_frame_control.c
index e9e1e2a..16f88ab 100644
--- a/drivers/scsi/isci/unsolicited_frame_control.c
+++ b/drivers/scsi/isci/unsolicited_frame_control.c
@@ -72,7 +72,7 @@ int sci_unsolicited_frame_control_construct(struct isci_host *ihost)
 	 */
 	buf_len = SCU_MAX_UNSOLICITED_FRAMES * SCU_UNSOLICITED_FRAME_BUFFER_SIZE;
 	header_len = SCU_MAX_UNSOLICITED_FRAMES * sizeof(struct scu_unsolicited_frame_header);
-	size = buf_len + header_len + SCU_MAX_UNSOLICITED_FRAMES * sizeof(dma_addr_t);
+	size = buf_len + header_len + SCU_MAX_UNSOLICITED_FRAMES * sizeof(uf_control->address_table.array[0]);
 
 	/*
 	 * The Unsolicited Frame buffers are set at the start of the UF
diff --git a/drivers/scsi/isci/unsolicited_frame_control.h b/drivers/scsi/isci/unsolicited_frame_control.h
index 31cb950..75d8966 100644
--- a/drivers/scsi/isci/unsolicited_frame_control.h
+++ b/drivers/scsi/isci/unsolicited_frame_control.h
@@ -214,7 +214,7 @@ struct sci_uf_address_table_array {
 	 * starting address of the UF address table.
 	 * 64-bit pointers are required by the hardware.
 	 */
-	dma_addr_t *array;
+	u64 *array;
 
 	/**
 	 * This field specifies the physical address location for the UF
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 01ff082..d261e98 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -494,6 +494,9 @@ static int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp,
 	 */
 	error = lport->tt.frame_send(lport, fp);
 
+	if (fh->fh_type == FC_TYPE_BLS)
+		return error;
+
 	/*
 	 * Update the exchange and sequence flags,
 	 * assuming all frames for the sequence have been sent.
@@ -575,42 +578,35 @@ static void fc_seq_set_resp(struct fc_seq *sp,
 }
 
 /**
- * fc_seq_exch_abort() - Abort an exchange and sequence
- * @req_sp:	The sequence to be aborted
+ * fc_exch_abort_locked() - Abort an exchange
+ * @ep:	The exchange to be aborted
  * @timer_msec: The period of time to wait before aborting
  *
- * Generally called because of a timeout or an abort from the upper layer.
+ * Locking notes:  Called with exch lock held
+ *
+ * Return value: 0 on success else error code
  */
-static int fc_seq_exch_abort(const struct fc_seq *req_sp,
-			     unsigned int timer_msec)
+static int fc_exch_abort_locked(struct fc_exch *ep,
+				unsigned int timer_msec)
 {
 	struct fc_seq *sp;
-	struct fc_exch *ep;
 	struct fc_frame *fp;
 	int error;
 
-	ep = fc_seq_exch(req_sp);
-
-	spin_lock_bh(&ep->ex_lock);
 	if (ep->esb_stat & (ESB_ST_COMPLETE | ESB_ST_ABNORMAL) ||
-	    ep->state & (FC_EX_DONE | FC_EX_RST_CLEANUP)) {
-		spin_unlock_bh(&ep->ex_lock);
+	    ep->state & (FC_EX_DONE | FC_EX_RST_CLEANUP))
 		return -ENXIO;
-	}
 
 	/*
 	 * Send the abort on a new sequence if possible.
 	 */
 	sp = fc_seq_start_next_locked(&ep->seq);
-	if (!sp) {
-		spin_unlock_bh(&ep->ex_lock);
+	if (!sp)
 		return -ENOMEM;
-	}
 
 	ep->esb_stat |= ESB_ST_SEQ_INIT | ESB_ST_ABNORMAL;
 	if (timer_msec)
 		fc_exch_timer_set_locked(ep, timer_msec);
-	spin_unlock_bh(&ep->ex_lock);
 
 	/*
 	 * If not logged into the fabric, don't send ABTS but leave
@@ -633,6 +629,28 @@ static int fc_seq_exch_abort(const struct fc_seq *req_sp,
 }
 
 /**
+ * fc_seq_exch_abort() - Abort an exchange and sequence
+ * @req_sp:	The sequence to be aborted
+ * @timer_msec: The period of time to wait before aborting
+ *
+ * Generally called because of a timeout or an abort from the upper layer.
+ *
+ * Return value: 0 on success else error code
+ */
+static int fc_seq_exch_abort(const struct fc_seq *req_sp,
+			     unsigned int timer_msec)
+{
+	struct fc_exch *ep;
+	int error;
+
+	ep = fc_seq_exch(req_sp);
+	spin_lock_bh(&ep->ex_lock);
+	error = fc_exch_abort_locked(ep, timer_msec);
+	spin_unlock_bh(&ep->ex_lock);
+	return error;
+}
+
+/**
  * fc_exch_timeout() - Handle exchange timer expiration
  * @work: The work_struct identifying the exchange that timed out
  */
@@ -1715,6 +1733,7 @@ static void fc_exch_reset(struct fc_exch *ep)
 	int rc = 1;
 
 	spin_lock_bh(&ep->ex_lock);
+	fc_exch_abort_locked(ep, 0);
 	ep->state |= FC_EX_RST_CLEANUP;
 	if (cancel_delayed_work(&ep->timeout_work))
 		atomic_dec(&ep->ex_refcnt);	/* drop hold for timer */
@@ -1962,6 +1981,7 @@ static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 	struct fc_exch *ep;
 	struct fc_seq *sp = NULL;
 	struct fc_frame_header *fh;
+	struct fc_fcp_pkt *fsp = NULL;
 	int rc = 1;
 
 	ep = fc_exch_alloc(lport, fp);
@@ -1984,8 +2004,10 @@ static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 	fc_exch_setup_hdr(ep, fp, ep->f_ctl);
 	sp->cnt++;
 
-	if (ep->xid <= lport->lro_xid && fh->fh_r_ctl == FC_RCTL_DD_UNSOL_CMD)
+	if (ep->xid <= lport->lro_xid && fh->fh_r_ctl == FC_RCTL_DD_UNSOL_CMD) {
+		fsp = fr_fsp(fp);
 		fc_fcp_ddp_setup(fr_fsp(fp), ep->xid);
+	}
 
 	if (unlikely(lport->tt.frame_send(lport, fp)))
 		goto err;
@@ -1999,7 +2021,8 @@ static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 	spin_unlock_bh(&ep->ex_lock);
 	return sp;
 err:
-	fc_fcp_ddp_done(fr_fsp(fp));
+	if (fsp)
+		fc_fcp_ddp_done(fsp);
 	rc = fc_exch_done_locked(ep);
 	spin_unlock_bh(&ep->ex_lock);
 	if (!rc)
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index afb63c8..4c41ee8 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2019,6 +2019,11 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	struct fc_fcp_internal *si;
 	int rc = FAILED;
 	unsigned long flags;
+	int rval;
+
+	rval = fc_block_scsi_eh(sc_cmd);
+	if (rval)
+		return rval;
 
 	lport = shost_priv(sc_cmd->device->host);
 	if (lport->state != LPORT_ST_READY)
@@ -2068,9 +2073,9 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	int rc = FAILED;
 	int rval;
 
-	rval = fc_remote_port_chkready(rport);
+	rval = fc_block_scsi_eh(sc_cmd);
 	if (rval)
-		goto out;
+		return rval;
 
 	lport = shost_priv(sc_cmd->device->host);
 
@@ -2116,6 +2121,8 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 
 	FC_SCSI_DBG(lport, "Resetting host\n");
 
+	fc_block_scsi_eh(sc_cmd);
+
 	lport->tt.lport_reset(lport);
 	wait_tmo = jiffies + FC_HOST_RESET_TIMEOUT;
 	while (!fc_fcp_lport_queue_ready(lport) && time_before(jiffies,
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e55ed9c..628f347 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -88,6 +88,7 @@
  */
 
 #include <linux/timer.h>
+#include <linux/delay.h>
 #include <linux/slab.h>
 #include <asm/unaligned.h>
 
@@ -1029,8 +1030,16 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 			   FCH_EVT_LIPRESET, 0);
 	fc_vports_linkchange(lport);
 	fc_lport_reset_locked(lport);
-	if (lport->link_up)
+	if (lport->link_up) {
+		/*
+		 * Wait upto resource allocation time out before
+		 * doing re-login since incomplete FIP exchanged
+		 * from last session may collide with exchanges
+		 * in new session.
+		 */
+		msleep(lport->r_a_tov);
 		fc_lport_enter_flogi(lport);
+	}
 }
 
 /**
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 7836eb0..a31e05f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1786,13 +1786,16 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 			fc_vport_set_state(fc_vport, FC_VPORT_LINKDOWN);
 	}
 
-	if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && ql2xenabledif) {
+	if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
 		if (ha->fw_attributes & BIT_4) {
+			int prot = 0;
 			vha->flags.difdix_supported = 1;
 			ql_dbg(ql_dbg_user, vha, 0x7082,
 			    "Registered for DIF/DIX type 1 and 3 protection.\n");
+			if (ql2xenabledif == 1)
+				prot = SHOST_DIX_TYPE0_PROTECTION;
 			scsi_host_set_prot(vha->host,
-			    SHOST_DIF_TYPE1_PROTECTION
+			    prot | SHOST_DIF_TYPE1_PROTECTION
 			    | SHOST_DIF_TYPE2_PROTECTION
 			    | SHOST_DIF_TYPE3_PROTECTION
 			    | SHOST_DIX_TYPE1_PROTECTION
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 2155071..d79cd8a 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -8,24 +8,24 @@
 /*
  * Table for showing the current message id in use for particular level
  * Change this table for addition of log/debug messages.
- * -----------------------------------------------------
- * |             Level            |   Last Value Used  |
- * -----------------------------------------------------
- * | Module Init and Probe        |       0x0116       |
- * | Mailbox commands             |       0x111e       |
- * | Device Discovery             |       0x2083       |
- * | Queue Command and IO tracing |       0x302e       |
- * | DPC Thread                   |       0x401c       |
- * | Async Events                 |       0x5059       |
- * | Timer Routines               |       0x600d       |
- * | User Space Interactions      |       0x709c       |
- * | Task Management              |       0x8043       |
- * | AER/EEH                      |       0x900f       |
- * | Virtual Port                 |       0xa007       |
- * | ISP82XX Specific             |       0xb027       |
- * | MultiQ                       |       0xc00b       |
- * | Misc                         |       0xd00b       |
- * -----------------------------------------------------
+ * ----------------------------------------------------------------------
+ * |             Level            |   Last Value Used  |     Holes	|
+ * ----------------------------------------------------------------------
+ * | Module Init and Probe        |       0x0116       |  		|
+ * | Mailbox commands             |       0x1126       |		|
+ * | Device Discovery             |       0x2083       |		|
+ * | Queue Command and IO tracing |       0x302e       |     0x3008     |
+ * | DPC Thread                   |       0x401c       |		|
+ * | Async Events                 |       0x5059       |		|
+ * | Timer Routines               |       0x600d       |		|
+ * | User Space Interactions      |       0x709d       |		|
+ * | Task Management              |       0x8041       |    		|
+ * | AER/EEH                      |       0x900f       |		|
+ * | Virtual Port                 |       0xa007       |		|
+ * | ISP82XX Specific             |       0xb04f       |    		|
+ * | MultiQ                       |       0xc00b       |		|
+ * | Misc                         |       0xd00b       |		|
+ * ----------------------------------------------------------------------
  */
 
 #include "qla_def.h"
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index cc5a792..a03eaf4 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2529,6 +2529,7 @@ struct qla_hw_data {
 #define DT_ISP8021			BIT_14
 #define DT_ISP_LAST			(DT_ISP8021 << 1)
 
+#define DT_T10_PI                       BIT_25
 #define DT_IIDMA                        BIT_26
 #define DT_FWI2                         BIT_27
 #define DT_ZIO_SUPPORTED                BIT_28
@@ -2572,6 +2573,7 @@ struct qla_hw_data {
 #define IS_NOCACHE_VPD_TYPE(ha)	(IS_QLA81XX(ha))
 #define IS_ALOGIO_CAPABLE(ha)	(IS_QLA23XX(ha) || IS_FWI2_CAPABLE(ha))
 
+#define IS_T10_PI_CAPABLE(ha)   ((ha)->device_type & DT_T10_PI)
 #define IS_IIDMA_CAPABLE(ha)    ((ha)->device_type & DT_IIDMA)
 #define IS_FWI2_CAPABLE(ha)     ((ha)->device_type & DT_FWI2)
 #define IS_ZIO_SUPPORTED(ha)    ((ha)->device_type & DT_ZIO_SUPPORTED)
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 691783a..aa69486 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -537,6 +537,11 @@ struct sts_entry_24xx {
 	/*
 	 * If DIF Error is set in comp_status, these additional fields are
 	 * defined:
+	 *
+	 * !!! NOTE: Firmware sends expected/actual DIF data in big endian
+	 * format; but all of the "data" field gets swab32-d in the beginning
+	 * of qla2x00_status_entry().
+	 *
 	 * &data[10] : uint8_t report_runt_bg[2];	- computed guard
 	 * &data[12] : uint8_t actual_dif[8];		- DIF Data received
 	 * &data[20] : uint8_t expected_dif[8];		- DIF Data computed
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index def6942..37da04d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3838,15 +3838,12 @@ qla2x00_loop_resync(scsi_qla_host_t *vha)
 		req = vha->req;
 	rsp = req->rsp;
 
-	atomic_set(&vha->loop_state, LOOP_UPDATE);
 	clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
 	if (vha->flags.online) {
 		if (!(rval = qla2x00_fw_ready(vha))) {
 			/* Wait at most MAX_TARGET RSCNs for a stable link. */
 			wait_time = 256;
 			do {
-				atomic_set(&vha->loop_state, LOOP_UPDATE);
-
 				/* Issue a marker after FW becomes ready. */
 				qla2x00_marker(vha, req, rsp, 0, 0,
 					MK_SYNC_ALL);
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index d2e904b..9902834 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -102,3 +102,32 @@ qla2x00_set_fcport_state(fc_port_t *fcport, int state)
 		    fcport->d_id.b.al_pa);
 	}
 }
+
+static inline int
+qla2x00_hba_err_chk_enabled(srb_t *sp)
+{
+	/*
+	 * Uncomment when corresponding SCSI changes are done.
+	 *
+	if (!sp->cmd->prot_chk)
+		return 0;
+	 *
+	 */
+
+	switch (scsi_get_prot_op(sp->cmd)) {
+	case SCSI_PROT_READ_STRIP:
+	case SCSI_PROT_WRITE_INSERT:
+		if (ql2xenablehba_err_chk >= 1)
+			return 1;
+		break;
+	case SCSI_PROT_READ_PASS:
+	case SCSI_PROT_WRITE_PASS:
+		if (ql2xenablehba_err_chk >= 2)
+			return 1;
+		break;
+	case SCSI_PROT_READ_INSERT:
+	case SCSI_PROT_WRITE_STRIP:
+		return 1;
+	}
+	return 0;
+}
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 49d6906..dbec896 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -709,20 +709,28 @@ struct fw_dif_context {
  *
  */
 static inline void
-qla24xx_set_t10dif_tags(struct scsi_cmnd *cmd, struct fw_dif_context *pkt,
+qla24xx_set_t10dif_tags(srb_t *sp, struct fw_dif_context *pkt,
     unsigned int protcnt)
 {
-	struct sd_dif_tuple *spt;
+	struct scsi_cmnd *cmd = sp->cmd;
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
-	unsigned char op = scsi_get_prot_op(cmd);
 
 	switch (scsi_get_prot_type(cmd)) {
-	/* For TYPE 0 protection: no checking */
 	case SCSI_PROT_DIF_TYPE0:
-		pkt->ref_tag_mask[0] = 0x00;
-		pkt->ref_tag_mask[1] = 0x00;
-		pkt->ref_tag_mask[2] = 0x00;
-		pkt->ref_tag_mask[3] = 0x00;
+		/*
+		 * No check for ql2xenablehba_err_chk, as it would be an
+		 * I/O error if hba tag generation is not done.
+		 */
+		pkt->ref_tag = cpu_to_le32((uint32_t)
+		    (0xffffffff & scsi_get_lba(cmd)));
+
+		if (!qla2x00_hba_err_chk_enabled(sp))
+			break;
+
+		pkt->ref_tag_mask[0] = 0xff;
+		pkt->ref_tag_mask[1] = 0xff;
+		pkt->ref_tag_mask[2] = 0xff;
+		pkt->ref_tag_mask[3] = 0xff;
 		break;
 
 	/*
@@ -730,20 +738,16 @@ qla24xx_set_t10dif_tags(struct scsi_cmnd *cmd, struct fw_dif_context *pkt,
 	 * match LBA in CDB + N
 	 */
 	case SCSI_PROT_DIF_TYPE2:
-		if (!ql2xenablehba_err_chk)
-			break;
-
-		if (scsi_prot_sg_count(cmd)) {
-			spt = page_address(sg_page(scsi_prot_sglist(cmd))) +
-			    scsi_prot_sglist(cmd)[0].offset;
-			pkt->app_tag = swab32(spt->app_tag);
-			pkt->app_tag_mask[0] =  0xff;
-			pkt->app_tag_mask[1] =  0xff;
-		}
+		pkt->app_tag = __constant_cpu_to_le16(0);
+		pkt->app_tag_mask[0] = 0x0;
+		pkt->app_tag_mask[1] = 0x0;
 
 		pkt->ref_tag = cpu_to_le32((uint32_t)
 		    (0xffffffff & scsi_get_lba(cmd)));
 
+		if (!qla2x00_hba_err_chk_enabled(sp))
+			break;
+
 		/* enable ALL bytes of the ref tag */
 		pkt->ref_tag_mask[0] = 0xff;
 		pkt->ref_tag_mask[1] = 0xff;
@@ -763,26 +767,15 @@ qla24xx_set_t10dif_tags(struct scsi_cmnd *cmd, struct fw_dif_context *pkt,
 	 * 16 bit app tag.
 	 */
 	case SCSI_PROT_DIF_TYPE1:
-		if (!ql2xenablehba_err_chk)
+		pkt->ref_tag = cpu_to_le32((uint32_t)
+		    (0xffffffff & scsi_get_lba(cmd)));
+		pkt->app_tag = __constant_cpu_to_le16(0);
+		pkt->app_tag_mask[0] = 0x0;
+		pkt->app_tag_mask[1] = 0x0;
+
+		if (!qla2x00_hba_err_chk_enabled(sp))
 			break;
 
-		if (protcnt && (op == SCSI_PROT_WRITE_STRIP ||
-		    op == SCSI_PROT_WRITE_PASS)) {
-			spt = page_address(sg_page(scsi_prot_sglist(cmd))) +
-			    scsi_prot_sglist(cmd)[0].offset;
-			ql_dbg(ql_dbg_io, vha, 0x3008,
-			    "LBA from user %p, lba = 0x%x for cmd=%p.\n",
-			    spt, (int)spt->ref_tag, cmd);
-			pkt->ref_tag = swab32(spt->ref_tag);
-			pkt->app_tag_mask[0] = 0x0;
-			pkt->app_tag_mask[1] = 0x0;
-		} else {
-			pkt->ref_tag = cpu_to_le32((uint32_t)
-			    (0xffffffff & scsi_get_lba(cmd)));
-			pkt->app_tag = __constant_cpu_to_le16(0);
-			pkt->app_tag_mask[0] = 0x0;
-			pkt->app_tag_mask[1] = 0x0;
-		}
 		/* enable ALL bytes of the ref tag */
 		pkt->ref_tag_mask[0] = 0xff;
 		pkt->ref_tag_mask[1] = 0xff;
@@ -798,8 +791,162 @@ qla24xx_set_t10dif_tags(struct scsi_cmnd *cmd, struct fw_dif_context *pkt,
 	    scsi_get_prot_type(cmd), cmd);
 }
 
+struct qla2_sgx {
+	dma_addr_t		dma_addr;	/* OUT */
+	uint32_t		dma_len;	/* OUT */
+
+	uint32_t		tot_bytes;	/* IN */
+	struct scatterlist	*cur_sg;	/* IN */
+
+	/* for book keeping, bzero on initial invocation */
+	uint32_t		bytes_consumed;
+	uint32_t		num_bytes;
+	uint32_t		tot_partial;
+
+	/* for debugging */
+	uint32_t		num_sg;
+	srb_t			*sp;
+};
 
 static int
+qla24xx_get_one_block_sg(uint32_t blk_sz, struct qla2_sgx *sgx,
+	uint32_t *partial)
+{
+	struct scatterlist *sg;
+	uint32_t cumulative_partial, sg_len;
+	dma_addr_t sg_dma_addr;
+
+	if (sgx->num_bytes == sgx->tot_bytes)
+		return 0;
+
+	sg = sgx->cur_sg;
+	cumulative_partial = sgx->tot_partial;
+
+	sg_dma_addr = sg_dma_address(sg);
+	sg_len = sg_dma_len(sg);
+
+	sgx->dma_addr = sg_dma_addr + sgx->bytes_consumed;
+
+	if ((cumulative_partial + (sg_len - sgx->bytes_consumed)) >= blk_sz) {
+		sgx->dma_len = (blk_sz - cumulative_partial);
+		sgx->tot_partial = 0;
+		sgx->num_bytes += blk_sz;
+		*partial = 0;
+	} else {
+		sgx->dma_len = sg_len - sgx->bytes_consumed;
+		sgx->tot_partial += sgx->dma_len;
+		*partial = 1;
+	}
+
+	sgx->bytes_consumed += sgx->dma_len;
+
+	if (sg_len == sgx->bytes_consumed) {
+		sg = sg_next(sg);
+		sgx->num_sg++;
+		sgx->cur_sg = sg;
+		sgx->bytes_consumed = 0;
+	}
+
+	return 1;
+}
+
+static int
+qla24xx_walk_and_build_sglist_no_difb(struct qla_hw_data *ha, srb_t *sp,
+	uint32_t *dsd, uint16_t tot_dsds)
+{
+	void *next_dsd;
+	uint8_t avail_dsds = 0;
+	uint32_t dsd_list_len;
+	struct dsd_dma *dsd_ptr;
+	struct scatterlist *sg_prot;
+	uint32_t *cur_dsd = dsd;
+	uint16_t	used_dsds = tot_dsds;
+
+	uint32_t	prot_int;
+	uint32_t	partial;
+	struct qla2_sgx sgx;
+	dma_addr_t	sle_dma;
+	uint32_t	sle_dma_len, tot_prot_dma_len = 0;
+	struct scsi_cmnd *cmd = sp->cmd;
+
+	prot_int = cmd->device->sector_size;
+
+	memset(&sgx, 0, sizeof(struct qla2_sgx));
+	sgx.tot_bytes = scsi_bufflen(sp->cmd);
+	sgx.cur_sg = scsi_sglist(sp->cmd);
+	sgx.sp = sp;
+
+	sg_prot = scsi_prot_sglist(sp->cmd);
+
+	while (qla24xx_get_one_block_sg(prot_int, &sgx, &partial)) {
+
+		sle_dma = sgx.dma_addr;
+		sle_dma_len = sgx.dma_len;
+alloc_and_fill:
+		/* Allocate additional continuation packets? */
+		if (avail_dsds == 0) {
+			avail_dsds = (used_dsds > QLA_DSDS_PER_IOCB) ?
+					QLA_DSDS_PER_IOCB : used_dsds;
+			dsd_list_len = (avail_dsds + 1) * 12;
+			used_dsds -= avail_dsds;
+
+			/* allocate tracking DS */
+			dsd_ptr = kzalloc(sizeof(struct dsd_dma), GFP_ATOMIC);
+			if (!dsd_ptr)
+				return 1;
+
+			/* allocate new list */
+			dsd_ptr->dsd_addr = next_dsd =
+			    dma_pool_alloc(ha->dl_dma_pool, GFP_ATOMIC,
+				&dsd_ptr->dsd_list_dma);
+
+			if (!next_dsd) {
+				/*
+				 * Need to cleanup only this dsd_ptr, rest
+				 * will be done by sp_free_dma()
+				 */
+				kfree(dsd_ptr);
+				return 1;
+			}
+
+			list_add_tail(&dsd_ptr->list,
+			    &((struct crc_context *)sp->ctx)->dsd_list);
+
+			sp->flags |= SRB_CRC_CTX_DSD_VALID;
+
+			/* add new list to cmd iocb or last list */
+			*cur_dsd++ = cpu_to_le32(LSD(dsd_ptr->dsd_list_dma));
+			*cur_dsd++ = cpu_to_le32(MSD(dsd_ptr->dsd_list_dma));
+			*cur_dsd++ = dsd_list_len;
+			cur_dsd = (uint32_t *)next_dsd;
+		}
+		*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
+		*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
+		*cur_dsd++ = cpu_to_le32(sle_dma_len);
+		avail_dsds--;
+
+		if (partial == 0) {
+			/* Got a full protection interval */
+			sle_dma = sg_dma_address(sg_prot) + tot_prot_dma_len;
+			sle_dma_len = 8;
+
+			tot_prot_dma_len += sle_dma_len;
+			if (tot_prot_dma_len == sg_dma_len(sg_prot)) {
+				tot_prot_dma_len = 0;
+				sg_prot = sg_next(sg_prot);
+			}
+
+			partial = 1; /* So as to not re-enter this block */
+			goto alloc_and_fill;
+		}
+	}
+	/* Null termination */
+	*cur_dsd++ = 0;
+	*cur_dsd++ = 0;
+	*cur_dsd++ = 0;
+	return 0;
+}
+static int
 qla24xx_walk_and_build_sglist(struct qla_hw_data *ha, srb_t *sp, uint32_t *dsd,
 	uint16_t tot_dsds)
 {
@@ -981,7 +1128,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	struct scsi_cmnd	*cmd;
 	struct scatterlist	*cur_seg;
 	int			sgc;
-	uint32_t		total_bytes;
+	uint32_t		total_bytes = 0;
 	uint32_t		data_bytes;
 	uint32_t		dif_bytes;
 	uint8_t			bundling = 1;
@@ -1023,8 +1170,10 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 		    __constant_cpu_to_le16(CF_READ_DATA);
 	}
 
-	tot_prot_dsds = scsi_prot_sg_count(cmd);
-	if (!tot_prot_dsds)
+	if ((scsi_get_prot_op(sp->cmd) == SCSI_PROT_READ_INSERT) ||
+	    (scsi_get_prot_op(sp->cmd) == SCSI_PROT_WRITE_STRIP) ||
+	    (scsi_get_prot_op(sp->cmd) == SCSI_PROT_READ_STRIP) ||
+	    (scsi_get_prot_op(sp->cmd) == SCSI_PROT_WRITE_INSERT))
 		bundling = 0;
 
 	/* Allocate CRC context from global pool */
@@ -1047,7 +1196,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 
 	INIT_LIST_HEAD(&crc_ctx_pkt->dsd_list);
 
-	qla24xx_set_t10dif_tags(cmd, (struct fw_dif_context *)
+	qla24xx_set_t10dif_tags(sp, (struct fw_dif_context *)
 	    &crc_ctx_pkt->ref_tag, tot_prot_dsds);
 
 	cmd_pkt->crc_context_address[0] = cpu_to_le32(LSD(crc_ctx_dma));
@@ -1076,7 +1225,6 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 		fcp_cmnd->additional_cdb_len |= 2;
 
 	int_to_scsilun(sp->cmd->device->lun, &fcp_cmnd->lun);
-	host_to_fcp_swap((uint8_t *)&fcp_cmnd->lun, sizeof(fcp_cmnd->lun));
 	memcpy(fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
 	cmd_pkt->fcp_cmnd_dseg_len = cpu_to_le16(fcp_cmnd_len);
 	cmd_pkt->fcp_cmnd_dseg_address[0] = cpu_to_le32(
@@ -1107,15 +1255,28 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	cmd_pkt->fcp_rsp_dseg_len = 0; /* Let response come in status iocb */
 
 	/* Compute dif len and adjust data len to incude protection */
-	total_bytes = data_bytes;
 	dif_bytes = 0;
 	blk_size = cmd->device->sector_size;
-	if (scsi_get_prot_op(cmd) != SCSI_PROT_NORMAL) {
-		dif_bytes = (data_bytes / blk_size) * 8;
-		total_bytes += dif_bytes;
+	dif_bytes = (data_bytes / blk_size) * 8;
+
+	switch (scsi_get_prot_op(sp->cmd)) {
+	case SCSI_PROT_READ_INSERT:
+	case SCSI_PROT_WRITE_STRIP:
+	    total_bytes = data_bytes;
+	    data_bytes += dif_bytes;
+	    break;
+
+	case SCSI_PROT_READ_STRIP:
+	case SCSI_PROT_WRITE_INSERT:
+	case SCSI_PROT_READ_PASS:
+	case SCSI_PROT_WRITE_PASS:
+	    total_bytes = data_bytes + dif_bytes;
+	    break;
+	default:
+	    BUG();
 	}
 
-	if (!ql2xenablehba_err_chk)
+	if (!qla2x00_hba_err_chk_enabled(sp))
 		fw_prot_opts |= 0x10; /* Disable Guard tag checking */
 
 	if (!bundling) {
@@ -1151,7 +1312,12 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 
 	cmd_pkt->control_flags |=
 	    __constant_cpu_to_le16(CF_DATA_SEG_DESCR_ENABLE);
-	if (qla24xx_walk_and_build_sglist(ha, sp, cur_dsd,
+
+	if (!bundling && tot_prot_dsds) {
+		if (qla24xx_walk_and_build_sglist_no_difb(ha, sp,
+		    cur_dsd, tot_dsds))
+			goto crc_queuing_error;
+	} else if (qla24xx_walk_and_build_sglist(ha, sp, cur_dsd,
 	    (tot_dsds - tot_prot_dsds)))
 		goto crc_queuing_error;
 
@@ -1414,6 +1580,22 @@ qla24xx_dif_start_scsi(srb_t *sp)
 			goto queuing_error;
 		else
 			sp->flags |= SRB_DMA_VALID;
+
+		if ((scsi_get_prot_op(cmd) == SCSI_PROT_READ_INSERT) ||
+		    (scsi_get_prot_op(cmd) == SCSI_PROT_WRITE_STRIP)) {
+			struct qla2_sgx sgx;
+			uint32_t	partial;
+
+			memset(&sgx, 0, sizeof(struct qla2_sgx));
+			sgx.tot_bytes = scsi_bufflen(cmd);
+			sgx.cur_sg = scsi_sglist(cmd);
+			sgx.sp = sp;
+
+			nseg = 0;
+			while (qla24xx_get_one_block_sg(
+			    cmd->device->sector_size, &sgx, &partial))
+				nseg++;
+		}
 	} else
 		nseg = 0;
 
@@ -1428,6 +1610,11 @@ qla24xx_dif_start_scsi(srb_t *sp)
 			goto queuing_error;
 		else
 			sp->flags |= SRB_CRC_PROT_DMA_VALID;
+
+		if ((scsi_get_prot_op(cmd) == SCSI_PROT_READ_INSERT) ||
+		    (scsi_get_prot_op(cmd) == SCSI_PROT_WRITE_STRIP)) {
+			nseg = scsi_bufflen(cmd) / cmd->device->sector_size;
+		}
 	} else {
 		nseg = 0;
 	}
@@ -1454,6 +1641,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	/* Build header part of command packet (excluding the OPCODE). */
 	req->current_outstanding_cmd = handle;
 	req->outstanding_cmds[handle] = sp;
+	sp->handle = handle;
 	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b16b772..646fc52 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -719,7 +719,6 @@ skip_rio:
 			vha->flags.rscn_queue_overflow = 1;
 		}
 
-		atomic_set(&vha->loop_state, LOOP_UPDATE);
 		atomic_set(&vha->loop_down_timer, 0);
 		vha->flags.management_server_logged_in = 0;
 
@@ -1435,25 +1434,27 @@ struct scsi_dif_tuple {
  * ASC/ASCQ fields in the sense buffer with ILLEGAL_REQUEST
  * to indicate to the kernel that the HBA detected error.
  */
-static inline void
+static inline int
 qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 {
 	struct scsi_qla_host *vha = sp->fcport->vha;
 	struct scsi_cmnd *cmd = sp->cmd;
-	struct scsi_dif_tuple	*ep =
-			(struct scsi_dif_tuple *)&sts24->data[20];
-	struct scsi_dif_tuple	*ap =
-			(struct scsi_dif_tuple *)&sts24->data[12];
+	uint8_t		*ap = &sts24->data[12];
+	uint8_t		*ep = &sts24->data[20];
 	uint32_t	e_ref_tag, a_ref_tag;
 	uint16_t	e_app_tag, a_app_tag;
 	uint16_t	e_guard, a_guard;
 
-	e_ref_tag = be32_to_cpu(ep->ref_tag);
-	a_ref_tag = be32_to_cpu(ap->ref_tag);
-	e_app_tag = be16_to_cpu(ep->app_tag);
-	a_app_tag = be16_to_cpu(ap->app_tag);
-	e_guard = be16_to_cpu(ep->guard);
-	a_guard = be16_to_cpu(ap->guard);
+	/*
+	 * swab32 of the "data" field in the beginning of qla2x00_status_entry()
+	 * would make guard field appear at offset 2
+	 */
+	a_guard   = le16_to_cpu(*(uint16_t *)(ap + 2));
+	a_app_tag = le16_to_cpu(*(uint16_t *)(ap + 0));
+	a_ref_tag = le32_to_cpu(*(uint32_t *)(ap + 4));
+	e_guard   = le16_to_cpu(*(uint16_t *)(ep + 2));
+	e_app_tag = le16_to_cpu(*(uint16_t *)(ep + 0));
+	e_ref_tag = le32_to_cpu(*(uint32_t *)(ep + 4));
 
 	ql_dbg(ql_dbg_io, vha, 0x3023,
 	    "iocb(s) %p Returned STATUS.\n", sts24);
@@ -1465,6 +1466,63 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 	    cmd->cmnd[0], (u64)scsi_get_lba(cmd), a_ref_tag, e_ref_tag,
 	    a_app_tag, e_app_tag, a_guard, e_guard);
 
+	/*
+	 * Ignore sector if:
+	 * For type     3: ref & app tag is all 'f's
+	 * For type 0,1,2: app tag is all 'f's
+	 */
+	if ((a_app_tag == 0xffff) &&
+	    ((scsi_get_prot_type(cmd) != SCSI_PROT_DIF_TYPE3) ||
+	     (a_ref_tag == 0xffffffff))) {
+		uint32_t blocks_done, resid;
+		sector_t lba_s = scsi_get_lba(cmd);
+
+		/* 2TB boundary case covered automatically with this */
+		blocks_done = e_ref_tag - (uint32_t)lba_s + 1;
+
+		resid = scsi_bufflen(cmd) - (blocks_done *
+		    cmd->device->sector_size);
+
+		scsi_set_resid(cmd, resid);
+		cmd->result = DID_OK << 16;
+
+		/* Update protection tag */
+		if (scsi_prot_sg_count(cmd)) {
+			uint32_t i, j = 0, k = 0, num_ent;
+			struct scatterlist *sg;
+			struct sd_dif_tuple *spt;
+
+			/* Patch the corresponding protection tags */
+			scsi_for_each_prot_sg(cmd, sg,
+			    scsi_prot_sg_count(cmd), i) {
+				num_ent = sg_dma_len(sg) / 8;
+				if (k + num_ent < blocks_done) {
+					k += num_ent;
+					continue;
+				}
+				j = blocks_done - k - 1;
+				k = blocks_done;
+				break;
+			}
+
+			if (k != blocks_done) {
+				qla_printk(KERN_WARNING, sp->fcport->vha->hw,
+				    "unexpected tag values tag:lba=%x:%lx)\n",
+				    e_ref_tag, lba_s);
+				return 1;
+			}
+
+			spt = page_address(sg_page(sg)) + sg->offset;
+			spt += j;
+
+			spt->app_tag = 0xffff;
+			if (scsi_get_prot_type(cmd) == SCSI_PROT_DIF_TYPE3)
+				spt->ref_tag = 0xffffffff;
+		}
+
+		return 0;
+	}
+
 	/* check guard */
 	if (e_guard != a_guard) {
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
@@ -1472,28 +1530,30 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 		set_driver_byte(cmd, DRIVER_SENSE);
 		set_host_byte(cmd, DID_ABORT);
 		cmd->result |= SAM_STAT_CHECK_CONDITION << 1;
-		return;
+		return 1;
 	}
 
-	/* check appl tag */
-	if (e_app_tag != a_app_tag) {
+	/* check ref tag */
+	if (e_ref_tag != a_ref_tag) {
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
-		    0x10, 0x2);
+		    0x10, 0x3);
 		set_driver_byte(cmd, DRIVER_SENSE);
 		set_host_byte(cmd, DID_ABORT);
 		cmd->result |= SAM_STAT_CHECK_CONDITION << 1;
-		return;
+		return 1;
 	}
 
-	/* check ref tag */
-	if (e_ref_tag != a_ref_tag) {
+	/* check appl tag */
+	if (e_app_tag != a_app_tag) {
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
-		    0x10, 0x3);
+		    0x10, 0x2);
 		set_driver_byte(cmd, DRIVER_SENSE);
 		set_host_byte(cmd, DID_ABORT);
 		cmd->result |= SAM_STAT_CHECK_CONDITION << 1;
-		return;
+		return 1;
 	}
+
+	return 1;
 }
 
 /**
@@ -1767,7 +1827,7 @@ check_scsi_status:
 		break;
 
 	case CS_DIF_ERROR:
-		qla2x00_handle_dif_error(sp, sts24);
+		logit = qla2x00_handle_dif_error(sp, sts24);
 		break;
 	default:
 		cp->result = DID_ERROR << 16;
@@ -2468,11 +2528,10 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 		goto skip_msi;
 	}
 
-	if (IS_QLA2432(ha) && (ha->pdev->revision < QLA_MSIX_CHIP_REV_24XX ||
-		!QLA_MSIX_FW_MODE_1(ha->fw_attributes))) {
+	if (IS_QLA2432(ha) && (ha->pdev->revision < QLA_MSIX_CHIP_REV_24XX)) {
 		ql_log(ql_log_warn, vha, 0x0035,
 		    "MSI-X; Unsupported ISP2432 (0x%X, 0x%X).\n",
-		    ha->pdev->revision, ha->fw_attributes);
+		    ha->pdev->revision, QLA_MSIX_CHIP_REV_24XX);
 		goto skip_msix;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index c706ed3..f488cc6 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -472,7 +472,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	host->can_queue = base_vha->req->length + 128;
 	host->this_id = 255;
 	host->cmd_per_lun = 3;
-	if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && ql2xenabledif)
+	if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif)
 		host->max_cmd_len = 32;
 	else
 		host->max_cmd_len = MAX_CMDSZ;
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 5cbf33a..049807c 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2208,6 +2208,7 @@ qla82xx_msix_rsp_q(int irq, void *dev_id)
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_82xx __iomem *reg;
+	unsigned long flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -2218,11 +2219,11 @@ qla82xx_msix_rsp_q(int irq, void *dev_id)
 
 	ha = rsp->hw;
 	reg = &ha->iobase->isp82;
-	spin_lock_irq(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	qla24xx_process_response_queue(vha, rsp);
 	WRT_REG_DWORD(&reg->host_int, 0);
-	spin_unlock_irq(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -2838,6 +2839,16 @@ sufficient_dsds:
 		int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
 		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
 
+		/* build FCP_CMND IU */
+		memset(ctx->fcp_cmnd, 0, sizeof(struct fcp_cmnd));
+		int_to_scsilun(sp->cmd->device->lun, &ctx->fcp_cmnd->lun);
+		ctx->fcp_cmnd->additional_cdb_len = additional_cdb_len;
+
+		if (cmd->sc_data_direction == DMA_TO_DEVICE)
+			ctx->fcp_cmnd->additional_cdb_len |= 1;
+		else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
+			ctx->fcp_cmnd->additional_cdb_len |= 2;
+
 		/*
 		 * Update tagged queuing modifier -- default is TSK_SIMPLE (0).
 		 */
@@ -2854,16 +2865,6 @@ sufficient_dsds:
 			}
 		}
 
-		/* build FCP_CMND IU */
-		memset(ctx->fcp_cmnd, 0, sizeof(struct fcp_cmnd));
-		int_to_scsilun(sp->cmd->device->lun, &ctx->fcp_cmnd->lun);
-		ctx->fcp_cmnd->additional_cdb_len = additional_cdb_len;
-
-		if (cmd->sc_data_direction == DMA_TO_DEVICE)
-			ctx->fcp_cmnd->additional_cdb_len |= 1;
-		else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
-			ctx->fcp_cmnd->additional_cdb_len |= 2;
-
 		memcpy(ctx->fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
 
 		fcp_dl = (uint32_t *)(ctx->fcp_cmnd->cdb + 16 +
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e02df27..4cace3f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -106,17 +106,21 @@ MODULE_PARM_DESC(ql2xmaxqdepth,
 		"Maximum queue depth to report for target devices.");
 
 /* Do not change the value of this after module load */
-int ql2xenabledif = 1;
+int ql2xenabledif = 0;
 module_param(ql2xenabledif, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xenabledif,
 		" Enable T10-CRC-DIF "
-		" Default is 0 - No DIF Support. 1 - Enable it");
+		" Default is 0 - No DIF Support. 1 - Enable it"
+		", 2 - Enable DIF for all types, except Type 0.");
 
-int ql2xenablehba_err_chk;
+int ql2xenablehba_err_chk = 2;
 module_param(ql2xenablehba_err_chk, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xenablehba_err_chk,
-		" Enable T10-CRC-DIF Error isolation by HBA"
-		" Default is 0 - Error isolation disabled, 1 - Enable it");
+		" Enable T10-CRC-DIF Error isolation by HBA:\n"
+		" Default is 1.\n"
+		"  0 -- Error isolation disabled\n"
+		"  1 -- Error isolation enabled only for DIX Type 0\n"
+		"  2 -- Error isolation enabled for all Types\n");
 
 int ql2xiidmaenable=1;
 module_param(ql2xiidmaenable, int, S_IRUGO);
@@ -909,7 +913,14 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		    "Abort command mbx success.\n");
 		wait = 1;
 	}
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qla2x00_sp_compl(ha, sp);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	/* Did the command return during mailbox execution? */
+	if (ret == FAILED && !CMD_SP(cmd))
+		ret = SUCCESS;
 
 	/* Wait for the command to be returned. */
 	if (wait) {
@@ -2251,7 +2262,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	host->this_id = 255;
 	host->cmd_per_lun = 3;
 	host->unique_id = host->host_no;
-	if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && ql2xenabledif)
+	if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif)
 		host->max_cmd_len = 32;
 	else
 		host->max_cmd_len = MAX_CMDSZ;
@@ -2378,13 +2389,16 @@ skip_dpc:
 	    "Detected hba at address=%p.\n",
 	    ha);
 
-	if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && ql2xenabledif) {
+	if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
 		if (ha->fw_attributes & BIT_4) {
+			int prot = 0;
 			base_vha->flags.difdix_supported = 1;
 			ql_dbg(ql_dbg_init, base_vha, 0x00f1,
 			    "Registering for DIF/DIX type 1 and 3 protection.\n");
+			if (ql2xenabledif == 1)
+				prot = SHOST_DIX_TYPE0_PROTECTION;
 			scsi_host_set_prot(host,
-			    SHOST_DIF_TYPE1_PROTECTION
+			    prot | SHOST_DIF_TYPE1_PROTECTION
 			    | SHOST_DIF_TYPE2_PROTECTION
 			    | SHOST_DIF_TYPE3_PROTECTION
 			    | SHOST_DIX_TYPE1_PROTECTION
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 062c97b..13b6357 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.07.03-k"
+#define QLA2XXX_VERSION      "8.03.07.07-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
