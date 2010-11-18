From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm_qla2xxx: Add initial HW and NPIV configfs handlers
Date: Thu, 18 Nov 2010 04:49:45 -0800
Message-ID: <1290084586-7207-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm21.bullet.mail.ne1.yahoo.com ([98.138.90.84]:25492 "HELO
	nm21.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756214Ab0KRMtw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 07:49:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Giridhar, Andrew and Co,

Attached is a functional control plane prototype that I have come up thus far
for lio-core-2.6.git/tcm_qla2xxx using ISP2532-based 8Gb adapters in a PTP
setup, with the tcm_qla2xxx side using host PCIe device passthrough for
individual ports into .37-rc1 KVM/QEMU guest.   I am interested to get some
feedback on the configfs enabled NPIV pieces especially (currently compile
tested only in PTP mode), but I think the non NPIV case is straight-forward
enough for the moment.

So, please have a look at the following and add your comments accordingly.

Thanks!

--nab

------------------------------------------------------------------------------

This patch adds the base tcm_qla2xxx HW configfs handler (non NPIV) in
tcm_qla2xxx_make_lport() that will walk the PCI device list looking for a
driver with MODE_TARGET supported and not already enabled, looking for a
matching struct scsi_qla_host->port_name for the passed configfs FC WWPN.

This patch also adds initial (compile tested) support for NPIV capable driver
by registering a second tcm_qla2xxx_npiv_ops during tcm_qla2xxx_register_configfs()
at module_init() time, and saves a global pointer to tcm_qla2xxx_npiv_fabric_configfs.
This means the seperate NPIV enabled code can be run from the same tcm_qla2xxx
LKM at /sys/kernel/config/target/qla2xxx_npiv/$WWPN+$WWNN using the same format as
the existing NPIV sysfs triggers at /sys/class/fc_host/$HOST/[create,delete]_vport.

This patch also adds special NPIV configfs handlers in tcm_qla2xxx_npiv_make_lport()
and tcm_qla2xxx_npiv_drop_lport() to call fc_vport_create() and fc_vport_terminate()
respectively to setup/release the NPIV port with libfc code.  Also included is a NPIV
version of tcm_qla2xxx_npiv_make_tpg() that references the NPIV global pointer directly.

For the non NPIV case the current control plane code looks like the following in action
for a matching vha->port_name containing a FC WWPN of 21:00:00:24:ff:31:4c:48

lenny64guest0:/usr/src/lio-core-2.6.git# insmod drivers/target/tcm_qla2xxx/tcm_qla2xxx.ko
lenny64guest0:/usr/src/lio-core-2.6.git# mkdir -p /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:31:4c:48/tpgt_1/lun/lun_0
lenny64guest0:/usr/src/lio-core-2.6.git# cd /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:31:4c:48/tpgt_1/lun/lun_0
lenny64guest0:/sys/kernel/config/target/qla2xxx/21:00:00:24:ff:31:4c:48/tpgt_1/lun/lun_0# ln -s /sys/kernel/config/target/core/fileio_0/sync_fileio qla2xxx_port

lenny64guest0:/sys/kernel/config/target/qla2xxx/21:00:00:24:ff:31:4c:48/tpgt_1/lun/lun_0# tree /sys/kernel/config/target/qla2xxx/
/sys/kernel/config/target/qla2xxx/
|-- 21:00:00:24:ff:31:4c:48
|   `-- tpgt_1
|       |-- acls
|       |-- attrib
|       |-- lun
|       |   `-- lun_0
|       |       |-- alua_tg_pt_gp
|       |       |-- alua_tg_pt_offline
|       |       |-- alua_tg_pt_status
|       |       |-- alua_tg_pt_write_md
|       |       `-- qla2xxx_port -> ../../../../../../target/core/fileio_0/sync_fileio
|       |-- np
|       `-- param
|-- discovery_auth
`-- version

and from the kernel log:

[15078.953293] TCM QLOGIC QLA2XXX fabric module v0.1 on Linux/x86_64 on 2.6.37-rc1+
[15078.953361] Setup generic discovery
[15078.953361] Setup generic wwn
[15078.953361] Setup generic tpg
[15078.953361] Setup generic tpg_base
[15078.953361] Setup generic tpg_port
[15078.957499] Setup generic tpg_lun
[15078.958080] Setup generic tpg_np
[15078.958640] Setup generic tpg_np_base
[15078.959273] Setup generic tpg_attrib
[15078.959891] Setup generic tpg_param
[15078.960494] Setup generic tpg_nacl
[15078.961085] Setup generic tpg_nacl_base
[15078.961481] Setup generic tpg_nacl_attrib
[15078.961481] Setup generic tpg_nacl_auth
[15078.961481] Setup generic tpg_nacl_param
[15078.961481] Setup generic tpg_mappedlun
[15078.961481] <<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
[15078.965721] Initialized struct target_fabric_configfs: ffff88007494c890 for qla2xxx
[15078.967043] <<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
[15078.968185] TCM_QLA2XXX[0] - Set fabric -> tcm_qla2xxx_fabric_configfs
[15078.969311] Setup generic discovery
[15078.969696] Setup generic wwn
[15078.969696] Setup generic tpg
[15078.969696] Setup generic tpg_base
[15078.969696] Setup generic tpg_port
[15078.969696] Setup generic tpg_lun
[15078.969696] Setup generic tpg_np
[15078.969696] Setup generic tpg_np_base
[15078.973959] Setup generic tpg_attrib
[15078.974579] Setup generic tpg_param
[15078.975155] Setup generic tpg_nacl
[15078.975718] Setup generic tpg_nacl_base
[15078.976352] Setup generic tpg_nacl_attrib
[15078.977010] Setup generic tpg_nacl_auth
[15078.977793] Setup generic tpg_nacl_param
[15078.977939] Setup generic tpg_mappedlun
[15078.977939] <<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
[15078.977939] Initialized struct target_fabric_configfs: ffff88007494a850 for qla2xxx_npiv
[15078.981638] <<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
[15078.982750] TCM_QLA2XXX[0] - Set fabric -> tcm_qla2xxx_npiv_fabric_configfs
[15085.683873] Target_Core_ConfigFS: REGISTER -> group: ffffffffa05b2b00 name: qla2xxx
[15085.685184] Target_Core_ConfigFS: REGISTER -> Located fabric: qla2xxx
[15085.686270] Target_Core_ConfigFS: REGISTER tfc_wwn_cit -> ffff88007494cb98
[15085.686343] Target_Core_ConfigFS: REGISTER -> Allocated Fabric: qla2xxx
[15085.686343] Target_Core_ConfigFS: REGISTER -> Set tf->tf_fabric for qla2xxx
[15085.686343] qla2xxx HW vha->node_name: 20 00 00 24 ff 31 4c 48
[15085.690922] qla2xxx HW vha->port_name: 21 00 00 24 ff 31 4c 48
[15085.692079] qla2xxx passed configfs WWPN: 21 00 00 24 ff 31 4c 48
[15085.693276] qla2xxx: Found matching HW WWPN: 21:00:00:24:ff:31:4c:48 for lport
[15085.694349] TARGET_CORE[qla2xxx]: Allocated Normal struct se_portal_group for endpoint: 21:00:00:24:ff:31:4c:48, Portal Tag: 1
[15203.490029] fileio/qla2xxx: Adding to default ALUA Target Port Group: alua/default_tg_pt_gp
[15203.491497] qla2xxx_TPG[1]_LUN[0] - Activated qla2xxx Logical Unit from CORE HBA: 2

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_qla2xxx/Kbuild                 |    2 +-
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h     |   18 +
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c |  397 ++++++++++++++++++++-
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c   |   94 +++++-
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h   |   22 +-
 5 files changed, 517 insertions(+), 16 deletions(-)

diff --git a/drivers/target/tcm_qla2xxx/Kbuild b/drivers/target/tcm_qla2xxx/Kbuild
index a527461..067cca1 100644
--- a/drivers/target/tcm_qla2xxx/Kbuild
+++ b/drivers/target/tcm_qla2xxx/Kbuild
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/tcm_qla2xxx
+EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/ -I$(srctree)/drivers/scsi/qla2xxx/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/tcm_qla2xxx/
 
 tcm_qla2xxx-objs		:= tcm_qla2xxx_fabric.o \
 				   tcm_qla2xxx_configfs.o \
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
index 7c5f7ac..404f579 100644
--- a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
@@ -3,6 +3,12 @@
 #define TCM_QLA2XXX_VERSION	"v0.1"
 /* length of ASCII WWPNs including pad */
 #define TCM_QLA2XXX_NAMELEN	32
+/* lenth of ASCII NPIV 'WWPN+WWNN' including pad */
+#define TCM_QLA2XXX_NPIV_NAMELEN 66
+
+struct tcm_qla2xxx_cmd {
+	struct se_cmd se_cmd;
+};
 
 struct tcm_qla2xxx_nacl {
 	/* Binary World Wide unique Port Name for FC Initiator Nport */
@@ -27,8 +33,20 @@ struct tcm_qla2xxx_lport {
 	u8 lport_proto_id;
 	/* Binary World Wide unique Port Name for FC Target Lport */
 	u64 lport_wwpn;
+	/* Binary World Wide unique Port Name for FC NPIV Target Lport */
+	u64 lport_npiv_wwpn;
+	/* Binary World Wide unique Node Name for FC NPIV Target Lport */
+	u64 lport_npiv_wwnn;
 	/* ASCII formatted WWPN for FC Target Lport */
 	char lport_name[TCM_QLA2XXX_NAMELEN];
+	/* ASCII formatted WWPN+WWNN for NPIV FC Target Lport */
+	char lport_npiv_name[TCM_QLA2XXX_NPIV_NAMELEN];
+	/* Pointer to struct scsi_qla_host from qla2xxx LLD */
+	struct scsi_qla_host *qla_vha;
+	/* Pointer to struct scsi_qla_host for NPIV VP from qla2xxx LLD */
+	struct scsi_qla_host *qla_npiv_vp;
+	/* Pointer to struct fc_vport for NPIV vport from libfc */
+	struct fc_vport *npiv_vport;
 	/* Returned by tcm_qla2xxx_make_lport() */
 	struct se_wwn lport_wwn;
 };
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
index 51091fd..c6308cf 100644
--- a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
@@ -56,6 +56,7 @@
 
 /* Local pointer to allocated TCM configfs fabric module */
 struct target_fabric_configfs *tcm_qla2xxx_fabric_configfs;
+struct target_fabric_configfs *tcm_qla2xxx_npiv_fabric_configfs;
 
 static struct se_node_acl *tcm_qla2xxx_make_nodeacl(
 	struct se_portal_group *se_tpg,
@@ -145,6 +146,56 @@ static void tcm_qla2xxx_drop_tpg(struct se_portal_group *se_tpg)
 	kfree(tpg);
 }
 
+static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
+	struct se_wwn *wwn,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_qla2xxx_lport *lport = container_of(wwn,
+			struct tcm_qla2xxx_lport, lport_wwn);
+	struct tcm_qla2xxx_tpg *tpg;
+	unsigned long tpgt;
+	int ret;
+
+	if (strstr(name, "tpgt_") != name)
+		return ERR_PTR(-EINVAL);
+	if (strict_strtoul(name + 5, 10, &tpgt) || tpgt > USHRT_MAX)
+		return ERR_PTR(-EINVAL);
+
+	tpg = kzalloc(sizeof(struct tcm_qla2xxx_tpg), GFP_KERNEL);
+	if (!(tpg)) {
+		printk(KERN_ERR "Unable to allocate struct tcm_qla2xxx_tpg\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	tpg->lport = lport;
+	tpg->lport_tpgt = tpgt;
+
+	ret = core_tpg_register(&tcm_qla2xxx_npiv_fabric_configfs->tf_ops, wwn,
+				&tpg->se_tpg, (void *)tpg,
+				TRANSPORT_TPG_TYPE_NORMAL);
+	if (ret < 0) {
+		kfree(tpg);
+		return NULL;
+	}
+	return &tpg->se_tpg;
+}
+
+
+static void tcm_qla2xxx_init_lport(
+	struct tcm_qla2xxx_lport *lport,
+	struct scsi_qla_host *vha,
+	struct scsi_qla_host *npiv_vp)
+{
+	struct qla_hw_data *ha = vha->hw;
+
+	/*
+	 * Setup local pointer to vha, NPIV VP pointer (if present) and
+	 * vha->tcm_lport pointer
+	 */
+	lport->qla_vha = vha;
+	lport->qla_npiv_vp = npiv_vp;
+	ha->tcm_lport = lport;
+}
 
 static struct se_wwn *tcm_qla2xxx_make_lport(
 	struct target_fabric_configfs *tf,
@@ -152,7 +203,14 @@ static struct se_wwn *tcm_qla2xxx_make_lport(
 	const char *name)
 {
 	struct tcm_qla2xxx_lport *lport;
+	struct Scsi_Host *host = NULL;
+	struct pci_dev *dev = NULL;
+	struct scsi_qla_host *vha;
+	struct qla_hw_data *ha;
+	unsigned long flags;
 	u64 wwpn;
+	int i, ret = -ENODEV;
+	u8 b[8];
 
 	if (tcm_qla2xxx_parse_wwn(name, &wwpn, 1) < 0)
 		return ERR_PTR(-EINVAL);
@@ -165,21 +223,249 @@ static struct se_wwn *tcm_qla2xxx_make_lport(
 	lport->lport_wwpn = wwpn;
 	tcm_qla2xxx_format_wwn(&lport->lport_name[0], TCM_QLA2XXX_NAMELEN, wwpn);
 
+	while ((dev = pci_get_device(PCI_VENDOR_ID_QLOGIC, PCI_ANY_ID,
+					dev)) != NULL) {
+
+		vha = pci_get_drvdata(dev);
+		if (!vha)
+			continue;
+		ha = vha->hw;
+		if (!ha)
+			continue;
+		host = vha->host;
+		if (!host)
+			continue;
+
+		if (!(host->hostt->supported_mode & MODE_TARGET))
+			continue;
+
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		if (host->active_mode & MODE_TARGET) {
+			printk(KERN_INFO "MODE_TARGET already active on qla2xxx"
+					"(%d)\n",  host->host_no);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			continue;
+		}
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		if (!scsi_host_get(host)) {
+			printk(KERN_ERR "Unable to scsi_host_get() for"
+				" qla2xxx scsi_host\n");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		printk("qla2xxx HW vha->node_name: ");
+		for (i = 0; i < 8; i++)
+			printk("%02x ", vha->node_name[i]);
+		printk("\n");
+
+		printk("qla2xxx HW vha->port_name: ");
+		for (i = 0; i < 8; i++)
+			printk("%02x ", vha->port_name[i]);
+		printk("\n");
+
+		printk("qla2xxx passed configfs WWPN: ");
+		put_unaligned_be64(wwpn, b);
+		for (i = 0; i < 8; i++)
+			printk("%02x ", b[i]);
+		printk("\n");
+
+		if (memcmp(vha->port_name, b, 8)) {
+			scsi_host_put(host);
+			continue;
+		}
+		printk("qla2xxx: Found matching HW WWPN: %s for lport\n", name);
+		tcm_qla2xxx_init_lport(lport, vha, NULL);
+		ret = 0;
+		break;
+	}
+
+	if (ret != 0)
+		goto out;
+
+	return &lport->lport_wwn;
+out:
+	kfree(lport);
+	return ERR_PTR(ret);
+}
+
+static void tcm_qla2xxx_drop_lport(struct se_wwn *wwn)
+{
+	struct tcm_qla2xxx_lport *lport = container_of(wwn,
+			struct tcm_qla2xxx_lport, lport_wwn);
+	struct scsi_qla_host *vha = lport->qla_vha;
+	struct Scsi_Host *sh = vha->host;
+
+	scsi_host_put(sh);
+	kfree(lport);
+}
+
+static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
+	struct target_fabric_configfs *tf,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_qla2xxx_lport *lport;
+	struct Scsi_Host *host = NULL;
+	struct pci_dev *dev = NULL;
+	struct scsi_qla_host *vha, *npiv_vp;
+	struct qla_hw_data *ha;
+	struct fc_vport_identifiers vid;
+	struct fc_vport *vport;
+	unsigned long flags;
+	u64 npiv_wwpn, npiv_wwnn;
+	int i, ret = -ENODEV;
+	u8 b[8], b2[8];
+
+	if (tcm_qla2xxx_npiv_parse_wwn(name, strlen(name)+1,
+				&npiv_wwpn, &npiv_wwnn) < 0)
+		return ERR_PTR(-EINVAL);
+
+	lport = kzalloc(sizeof(struct tcm_qla2xxx_lport), GFP_KERNEL);
+	if (!(lport)) {
+		printk(KERN_ERR "Unable to allocate struct tcm_qla2xxx_lport"
+				" for NPIV\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	lport->lport_npiv_wwpn = npiv_wwpn;
+	lport->lport_npiv_wwnn = npiv_wwnn;
+	tcm_qla2xxx_npiv_format_wwn(&lport->lport_npiv_name[0],
+			TCM_QLA2XXX_NAMELEN, npiv_wwpn, npiv_wwnn);
+
+	while ((dev = pci_get_device(PCI_VENDOR_ID_QLOGIC, PCI_ANY_ID,
+					dev)) != NULL) {
+
+		vha = pci_get_drvdata(dev);
+		if (!vha)
+			continue;
+		ha = vha->hw;
+		if (!ha)
+			continue;
+		host = vha->host;
+		if (!host)
+			continue;
+
+		if (!(host->hostt->supported_mode & MODE_TARGET))
+			continue;
+
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		if (host->active_mode & MODE_TARGET) {
+			printk(KERN_INFO "MODE_TARGET already active on qla2xxx"
+					"(%d)\n",  host->host_no);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			continue;
+		}
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		if (!scsi_host_get(host)) {
+			printk(KERN_ERR "Unable to scsi_host_get() for"
+				" qla2xxx scsi_host\n");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		printk("qla2xxx HW vha->node_name: ");
+		for (i = 0; i < 8; i++)
+			printk("%02x ", vha->node_name[i]);
+		printk("\n");
+
+		printk("qla2xxx HW vha->port_name: ");
+		for (i = 0; i < 8; i++)
+			printk("%02x ", vha->port_name[i]);
+		printk("\n");
+
+		printk("qla2xxx passed configfs NPIV WWPN: ");
+		put_unaligned_be64(npiv_wwpn, b);
+		for (i = 0; i < 8; i++)
+			printk("%02x ", b[i]);
+		printk("\n");
+
+		printk("qla2xxx passed configfs NPIV WWNN: ");
+		put_unaligned_be64(npiv_wwnn, b2);
+		for (i = 0; i < 8; i++)
+			printk("%02x ", b2[i]);
+		printk("\n");
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		list_for_each_entry(npiv_vp, &ha->vp_list, list) {
+			if (!npiv_vp->vp_idx)
+				continue;
+
+			if (memcmp(npiv_vp->port_name, b, 8) ||
+			    memcmp(npiv_vp->node_name, b2, 8))
+				continue;
+
+#warning FIXME: Need to add atomic_inc(&npiv_vp->vref_count) before dropping ha->vport_slock..?
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+
+			printk("qla2xxx_npiv: Found matching NPIV WWPN+WWNN: %s "
+					" for lport\n", name);
+			tcm_qla2xxx_init_lport(lport, vha, npiv_vp);
+			/*
+			 * Setup fc_vport_identifiers for NPIV containing
+			 * the passed WWPN and WWNN for the new libfc vport.
+			 */
+			memset(&vid, 0, sizeof(vid));
+			vid.roles = FC_PORT_ROLE_FCP_INITIATOR;
+			vid.vport_type = FC_PORTTYPE_NPIV;
+			vid.port_name = npiv_wwpn;
+			vid.node_name = npiv_wwnn;
+			/* vid.symbolic_name is already zero/NULL's */
+			vid.disable = false;	/* always enabled */
+
+			/* we only allow support on Channel 0 !!! */
+			vport = fc_vport_create(host, 0, &vid);
+			if (!vport) {
+				printk(KERN_ERR "fc_vport_create() failed for"
+						" NPIV tcm_qla2xxx\n");
+				scsi_host_put(host);
+				ret = -EINVAL;
+				goto out;
+			}
+			lport->npiv_vport = vport;
+			ret = 0;
+			spin_lock_irqsave(&ha->vport_slock, flags);
+			break;
+		}
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+
+		if (!ret)
+			break;
+
+		scsi_host_put(host);
+	}
+
+	if (ret != 0)
+		goto out;
+
 	return &lport->lport_wwn;
+out:
+	kfree(lport);
+	return ERR_PTR(ret);
 }
 
-static void tcm_qla2xxx_drop_lport(struct se_wwn_s *wwn)
+static void tcm_qla2xxx_npiv_drop_lport(struct se_wwn *wwn)
 {
 	struct tcm_qla2xxx_lport *lport = container_of(wwn,
 			struct tcm_qla2xxx_lport, lport_wwn);
+	struct scsi_qla_host *vha = lport->qla_vha;
+	struct Scsi_Host *sh = vha->host;
+	/*
+	 * Notify libfc that we want to release the lport->npiv_vport
+	 */
+	fc_vport_terminate(lport->npiv_vport);
+
+	scsi_host_put(sh);
 	kfree(lport);
 }
 
+
 static ssize_t tcm_qla2xxx_wwn_show_attr_version(
 	struct target_fabric_configfs *tf,
 	char *page)
 {
-	return sprintf(page, "TCM QLOGIC QLA2XXX fabric module %s on %s/%s"
+	return sprintf(page, "TCM QLOGIC QLA2XXX NPIV capable fabric module %s on %s/%s"
 		" on "UTS_RELEASE"\n", TCM_QLA2XXX_VERSION, utsname()->sysname,
 		utsname()->machine);
 }
@@ -244,9 +530,62 @@ static struct target_core_fabric_ops tcm_qla2xxx_ops = {
 	.fabric_drop_nodeacl		= tcm_qla2xxx_drop_nodeacl,
 };
 
+static struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
+	.get_fabric_name		= tcm_qla2xxx_npiv_get_fabric_name,
+	.get_fabric_proto_ident		= tcm_qla2xxx_get_fabric_proto_ident,
+	.tpg_get_wwn			= tcm_qla2xxx_npiv_get_fabric_wwn,
+	.tpg_get_tag			= tcm_qla2xxx_get_tag,
+	.tpg_get_default_depth		= tcm_qla2xxx_get_default_depth,
+	.tpg_get_pr_transport_id	= tcm_qla2xxx_get_pr_transport_id,
+	.tpg_get_pr_transport_id_len	= tcm_qla2xxx_get_pr_transport_id_len,
+	.tpg_parse_pr_out_transport_id	= tcm_qla2xxx_parse_pr_out_transport_id,
+	.tpg_check_demo_mode		= tcm_qla2xxx_check_false,
+	.tpg_check_demo_mode_cache	= tcm_qla2xxx_check_true,
+	.tpg_check_demo_mode_write_protect = tcm_qla2xxx_check_true,
+	.tpg_check_prod_mode_write_protect = tcm_qla2xxx_check_false,
+	.tpg_alloc_fabric_acl		= tcm_qla2xxx_alloc_fabric_acl,
+	.tpg_release_fabric_acl		= tcm_qla2xxx_release_fabric_acl,
+	.tpg_get_inst_index		= tcm_qla2xxx_tpg_get_inst_index,
+	.release_cmd_to_pool		= tcm_qla2xxx_release_cmd,
+	.release_cmd_direct		= tcm_qla2xxx_release_cmd,
+	.shutdown_session		= tcm_qla2xxx_shutdown_session,
+	.close_session			= tcm_qla2xxx_close_session,
+	.stop_session			= tcm_qla2xxx_stop_session,
+	.fall_back_to_erl0		= tcm_qla2xxx_reset_nexus,
+	.sess_logged_in			= tcm_qla2xxx_sess_logged_in,
+	.sess_get_index			= tcm_qla2xxx_sess_get_index,
+	.sess_get_initiator_sid		= NULL,
+	.write_pending			= tcm_qla2xxx_write_pending,
+	.write_pending_status		= tcm_qla2xxx_write_pending_status,
+	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
+	.get_task_tag			= tcm_qla2xxx_get_task_tag,
+	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
+	.new_cmd_failure		= tcm_qla2xxx_new_cmd_failure,
+	.queue_data_in			= tcm_qla2xxx_queue_data_in,
+	.queue_status			= tcm_qla2xxx_queue_status,
+	.queue_tm_rsp			= tcm_qla2xxx_queue_tm_rsp,
+	.get_fabric_sense_len		= tcm_qla2xxx_get_fabric_sense_len,
+	.set_fabric_sense_len		= tcm_qla2xxx_set_fabric_sense_len,
+	.is_state_remove		= tcm_qla2xxx_is_state_remove,
+	.pack_lun			= tcm_qla2xxx_pack_lun,
+	/*
+	 * Setup function pointers for generic logic in target_core_fabric_configfs.c
+	 */
+	.fabric_make_wwn		= tcm_qla2xxx_npiv_make_lport,
+	.fabric_drop_wwn		= tcm_qla2xxx_npiv_drop_lport,
+	.fabric_make_tpg		= tcm_qla2xxx_npiv_make_tpg,
+	.fabric_drop_tpg		= tcm_qla2xxx_drop_tpg,
+	.fabric_post_link		= NULL,
+	.fabric_pre_unlink		= NULL,
+	.fabric_make_np			= NULL,
+	.fabric_drop_np			= NULL,
+	.fabric_make_nodeacl		= tcm_qla2xxx_make_nodeacl,
+	.fabric_drop_nodeacl		= tcm_qla2xxx_drop_nodeacl,
+};
+
 static int tcm_qla2xxx_register_configfs(void)
 {
-	struct target_fabric_configfs *fabric;
+	struct target_fabric_configfs *fabric, *npiv_fabric;
 	int ret;
 
 	printk(KERN_INFO "TCM QLOGIC QLA2XXX fabric module %s on %s/%s"
@@ -290,7 +629,53 @@ static int tcm_qla2xxx_register_configfs(void)
 	 */
 	tcm_qla2xxx_fabric_configfs = fabric;	
 	printk(KERN_INFO "TCM_QLA2XXX[0] - Set fabric -> tcm_qla2xxx_fabric_configfs\n");
+
+	/*
+	 * Register the top level struct config_item_type for NPIV with TCM core
+	 */
+	npiv_fabric = target_fabric_configfs_init(THIS_MODULE, "qla2xxx_npiv");
+	if (!(npiv_fabric)) {
+		printk(KERN_ERR "target_fabric_configfs_init() failed\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+	/*
+	 * Setup fabric->tf_ops from our local tcm_qla2xxx_npiv_ops
+	 */
+	npiv_fabric->tf_ops = tcm_qla2xxx_npiv_ops;
+	/*
+	 * Setup default attribute lists for various npiv_fabric->tf_cit_tmpl
+	 */
+	TF_CIT_TMPL(npiv_fabric)->tfc_wwn_cit.ct_attrs = tcm_qla2xxx_wwn_attrs;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
+	/*
+	 * Register the npiv_fabric for use within TCM
+	 */
+	ret = target_fabric_configfs_register(npiv_fabric);
+	if (ret < 0) {
+		printk(KERN_ERR "target_fabric_configfs_register() failed"
+				" for TCM_QLA2XXX\n");
+		goto out;;
+	}
+	/*
+	 * Setup our local pointer to *npiv_fabric
+	 */
+	tcm_qla2xxx_npiv_fabric_configfs = npiv_fabric;
+	printk(KERN_INFO "TCM_QLA2XXX[0] - Set fabric -> tcm_qla2xxx_npiv_fabric_configfs\n");
+
 	return 0;
+out:
+	if (tcm_qla2xxx_fabric_configfs != NULL)
+		target_fabric_configfs_deregister(tcm_qla2xxx_fabric_configfs);
+
+	return ret;
 }
 
 static void tcm_qla2xxx_deregister_configfs(void)
@@ -301,6 +686,10 @@ static void tcm_qla2xxx_deregister_configfs(void)
 	target_fabric_configfs_deregister(tcm_qla2xxx_fabric_configfs);
 	tcm_qla2xxx_fabric_configfs = NULL;
 	printk(KERN_INFO "TCM_QLA2XXX[0] - Cleared tcm_qla2xxx_fabric_configfs\n");
+
+	target_fabric_configfs_deregister(tcm_qla2xxx_npiv_fabric_configfs);
+	tcm_qla2xxx_npiv_fabric_configfs = NULL;
+	printk(KERN_INFO "TCM_QLA2XXX[0] - Cleared tcm_qla2xxx_npiv_fabric_configfs\n");
 }
 
 static int __init tcm_qla2xxx_init(void)
@@ -320,7 +709,7 @@ static void __exit tcm_qla2xxx_exit(void)
 }
 
 #ifdef MODULE
-MODULE_DESCRIPTION("TCM QLA2XXX series fabric driver");
+MODULE_DESCRIPTION("TCM QLA2XXX series NPIV enabled fabric driver");
 MODULE_LICENSE("GPL");
 module_init(tcm_qla2xxx_init);
 module_exit(tcm_qla2xxx_exit);
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
index 347ad1e..f1cfd8c 100644
--- a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
@@ -40,6 +40,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/libfc.h>
+#include <scsi/scsi_transport_fc.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
@@ -128,7 +129,87 @@ char *tcm_qla2xxx_get_fabric_name(void)
 	return "qla2xxx";
 }
 
-u8 tcm_qla2xxx_get_fabric_proto_ident(se_portal_group_t *se_tpg)
+/*
+ * From drivers/scsi/scsi_transport_fc.c:fc_parse_wwn
+ */
+static int tcm_qla2xxx_npiv_extract_wwn(const char *ns, u64 *nm)
+{
+	unsigned int i, j, value;
+	u8 wwn[8];
+
+	memset(wwn, 0, sizeof(wwn));
+
+	/* Validate and store the new name */
+	for (i = 0, j = 0; i < 16; i++) {
+		value = hex_to_bin(*ns++);
+		if (value >= 0)
+			j = (j << 4) | value;
+		else
+			return -EINVAL;
+
+		if (i % 2) {
+			wwn[i/2] = j & 0xff;
+			j = 0;
+		}
+	}
+
+	*nm = wwn_to_u64(wwn);
+	return 0;
+}
+
+/*
+ * This parsing logic follows drivers/scsi/scsi_transport_fc.c:store_fc_host_vport_create()
+ */
+int tcm_qla2xxx_npiv_parse_wwn(
+	const char *name,
+	size_t count,
+	u64 *wwpn,
+	u64 *wwnn)
+{
+	unsigned int cnt = count;
+	int rc;
+
+	*wwpn = 0;
+	*wwnn = 0;
+
+	/* count may include a LF at end of string */
+	if (name[cnt-1] == '\n')
+		cnt--;
+
+	/* validate we have enough characters for WWPN */
+	if ((cnt != (16+1+16)) || (name[16] != ':'))
+		return -EINVAL;
+
+	rc = tcm_qla2xxx_npiv_extract_wwn(&name[0], wwpn);
+	if (rc != 0)
+		return rc;
+
+	rc = tcm_qla2xxx_npiv_extract_wwn(&name[17], wwnn);
+	if (rc != 0)
+		return rc;
+
+	return 0;
+}
+
+ssize_t tcm_qla2xxx_npiv_format_wwn(char *buf, size_t len, u64 wwpn, u64 wwnn)
+{
+	u8 b[8], b2[8];
+
+	put_unaligned_be64(wwpn, b);
+	put_unaligned_be64(wwnn, b2);
+        return snprintf(buf, len,
+                "%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x,"
+		"%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x",
+                b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7],
+		b2[0], b2[1], b2[2], b2[3], b2[4], b2[5], b2[6], b2[7]);
+}
+
+char *tcm_qla2xxx_npiv_get_fabric_name(void)
+{
+	return "qla2xxx_npiv";
+}
+
+u8 tcm_qla2xxx_get_fabric_proto_ident(struct se_portal_group *se_tpg)
 {
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 				struct tcm_qla2xxx_tpg, se_tpg);
@@ -154,7 +235,16 @@ char *tcm_qla2xxx_get_fabric_wwn(struct se_portal_group *se_tpg)
 	return &lport->lport_name[0];
 }
 
-u16 tcm_qla2xxx_get_tag(se_portal_group_t *se_tpg)
+char *tcm_qla2xxx_npiv_get_fabric_wwn(struct se_portal_group *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport = tpg->lport;
+
+	return &lport->lport_npiv_name[0];
+}
+
+u16 tcm_qla2xxx_get_tag(struct se_portal_group *se_tpg)
 {
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 				struct tcm_qla2xxx_tpg, se_tpg);
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h
index 151d352..d0a5d01 100644
--- a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h
@@ -3,15 +3,19 @@ extern int tcm_qla2xxx_check_false(struct se_portal_group *);
 extern ssize_t tcm_qla2xxx_parse_wwn(const char *, u64 *, int);
 extern ssize_t tcm_qla2xxx_format_wwn(char *, size_t, u64);
 extern char *tcm_qla2xxx_get_fabric_name(void);
-extern u8 tcm_qla2xxx_get_fabric_proto_ident(se_portal_group_t *);
-extern char *tcm_qla2xxx_get_fabric_wwn(se_portal_group_t *);
-extern u16 tcm_qla2xxx_get_tag(se_portal_group_t *);
-extern u32 tcm_qla2xxx_get_default_depth(se_portal_group_t *);
-extern u32 tcm_qla2xxx_get_pr_transport_id(se_portal_group_t *, se_node_acl_t *,
-				t10_pr_registration_t *, int *, unsigned char *);
-extern u32 tcm_qla2xxx_get_pr_transport_id_len(se_portal_group_t *, se_node_acl_t *,
-				t10_pr_registration_t *, int *);
-extern char *tcm_qla2xxx_parse_pr_out_transport_id(se_portal_group_t *, const char *,
+extern int tcm_qla2xxx_npiv_parse_wwn(const char *name, size_t, u64 *, u64 *);
+extern ssize_t tcm_qla2xxx_npiv_format_wwn(char *, size_t, u64, u64);
+extern char *tcm_qla2xxx_npiv_get_fabric_name(void);
+extern u8 tcm_qla2xxx_get_fabric_proto_ident(struct se_portal_group *);
+extern char *tcm_qla2xxx_get_fabric_wwn(struct se_portal_group *);
+extern char *tcm_qla2xxx_npiv_get_fabric_wwn(struct se_portal_group *);
+extern u16 tcm_qla2xxx_get_tag(struct se_portal_group *);
+extern u32 tcm_qla2xxx_get_default_depth(struct se_portal_group *);
+extern u32 tcm_qla2xxx_get_pr_transport_id(struct se_portal_group *, struct se_node_acl *,
+			struct t10_pr_registration *, int *, unsigned char *);
+extern u32 tcm_qla2xxx_get_pr_transport_id_len(struct se_portal_group *, struct se_node_acl *,
+			struct t10_pr_registration *, int *);
+extern char *tcm_qla2xxx_parse_pr_out_transport_id(struct se_portal_group *, const char *,
 				u32 *, char **);
 extern struct se_node_acl *tcm_qla2xxx_alloc_fabric_acl(struct se_portal_group *);
 extern void tcm_qla2xxx_release_fabric_acl(struct se_portal_group *, struct se_node_acl *);
-- 
1.5.6.5

