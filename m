From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 03/11] nvmet: Add support for configfs-ng multi-tenant logic
Date: Tue, 14 Jun 2016 04:35:38 +0000
Message-ID: <1465878946-26556-4-git-send-email-nab@linux-iscsi.org>
References: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38491 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbcFNEgx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2016 00:36:53 -0400
In-Reply-To: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

=46rom: Nicholas Bellinger <nab@linux-iscsi.org>

This patch introduces support for configfs-ng, that allows
for multi-tenant /sys/kernel/config/nvmet/subsystems/$SUBSYS_NQN/
operation, using existing /sys/kernel/config/target/core/
backends from target-core to be configfs symlinked as
per nvme-target subsystem NQN namespaces.

Here's how the layout looks:

/sys/kernel/config/nvmet/
=E2=94=94=E2=94=80=E2=94=80 subsystems
    =E2=94=94=E2=94=80=E2=94=80 nqn.2003-01.org.linux-iscsi.NVMf.skylak=
e-ep
        =E2=94=9C=E2=94=80=E2=94=80 namespaces
        =E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 1
        =E2=94=82=C2=A0=C2=A0     =E2=94=94=E2=94=80=E2=94=80 ramdisk0 =
-> ../../../../../target/core/rd_mcp_1/ramdisk0
        =E2=94=94=E2=94=80=E2=94=80 ports
            =E2=94=94=E2=94=80=E2=94=80 loop
                =E2=94=9C=E2=94=80=E2=94=80 addr_adrfam
                =E2=94=9C=E2=94=80=E2=94=80 addr_portid
                =E2=94=9C=E2=94=80=E2=94=80 addr_traddr
                =E2=94=9C=E2=94=80=E2=94=80 addr_treq
                =E2=94=9C=E2=94=80=E2=94=80 addr_trsvcid
                =E2=94=9C=E2=94=80=E2=94=80 addr_trtype
                =E2=94=94=E2=94=80=E2=94=80 enable

It convert nvmet_find_get_subsys to port_binding_list, and
do the same for nvmet_host_discovery_allowed.

Also convert nvmet_genctr to atomic_long_t, so it can be used
outside of nvmet_config_sem.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/nvme/target/Makefile      |   2 +-
 drivers/nvme/target/configfs-ng.c | 662 ++++++++++++++++++++++++++++++=
++++++++
 drivers/nvme/target/configfs.c    |  12 +-
 drivers/nvme/target/core.c        |  91 ++++--
 drivers/nvme/target/discovery.c   |  31 +-
 drivers/nvme/target/nvmet.h       |  50 ++-
 6 files changed, 812 insertions(+), 36 deletions(-)
 create mode 100644 drivers/nvme/target/configfs-ng.c

diff --git a/drivers/nvme/target/Makefile b/drivers/nvme/target/Makefil=
e
index b7a0623..2799e07 100644
--- a/drivers/nvme/target/Makefile
+++ b/drivers/nvme/target/Makefile
@@ -3,7 +3,7 @@ obj-$(CONFIG_NVME_TARGET)		+=3D nvmet.o
 obj-$(CONFIG_NVME_TARGET_LOOP)		+=3D nvme-loop.o
 obj-$(CONFIG_NVME_TARGET_RDMA)		+=3D nvmet-rdma.o
=20
-nvmet-y		+=3D core.o configfs.o admin-cmd.o io-cmd.o fabrics-cmd.o \
+nvmet-y		+=3D core.o configfs-ng.o admin-cmd.o io-cmd.o fabrics-cmd.o =
\
 			discovery.o
 nvme-loop-y	+=3D loop.o
 nvmet-rdma-y	+=3D rdma.o
diff --git a/drivers/nvme/target/configfs-ng.c b/drivers/nvme/target/co=
nfigfs-ng.c
new file mode 100644
index 0000000..28dc24b
--- /dev/null
+++ b/drivers/nvme/target/configfs-ng.c
@@ -0,0 +1,662 @@
+/*
+ * Based on target_core_fabric_configfs.c code
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/stat.h>
+#include <linux/ctype.h>
+#include <target/target_core_base.h>
+#include <target/target_core_backend.h>
+
+#include "nvmet.h"
+
+/*
+ * NVMf host CIT
+ */
+static void nvmet_host_release(struct config_item *item)
+{
+	struct nvmet_host *host =3D to_host(item);
+	struct nvmet_subsys *subsys =3D host->subsys;
+
+	mutex_lock(&subsys->hosts_mutex);
+	list_del_init(&host->node);
+	mutex_unlock(&subsys->hosts_mutex);
+
+	kfree(host);
+}
+
+static struct configfs_item_operations nvmet_host_item_opts =3D {
+	.release		=3D nvmet_host_release,
+};
+
+static struct config_item_type nvmet_host_type =3D {
+	.ct_item_ops		=3D &nvmet_host_item_opts,
+	.ct_attrs		=3D NULL,
+	.ct_owner		=3D THIS_MODULE,
+
+};
+
+static struct config_group *nvmet_make_hosts(struct config_group *grou=
p,
+		const char *name)
+{
+	struct nvmet_subsys *subsys =3D ports_to_subsys(&group->cg_item);
+	struct nvmet_host *host;
+
+	host =3D kzalloc(sizeof(*host), GFP_KERNEL);
+	if (!host)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&host->node);
+	host->subsys =3D subsys;
+
+	mutex_lock(&subsys->hosts_mutex);
+	list_add_tail(&host->node, &subsys->hosts);
+	mutex_unlock(&subsys->hosts_mutex);
+
+	config_group_init_type_name(&host->group, name, &nvmet_host_type);
+
+	return &host->group;
+}
+
+static void nvmet_drop_hosts(struct config_group *group, struct config=
_item *item)
+{
+	config_item_put(item);
+}
+
+static struct configfs_group_operations nvmet_hosts_group_ops =3D {
+	.make_group		=3D nvmet_make_hosts,
+	.drop_item		=3D nvmet_drop_hosts,
+};
+
+static struct config_item_type nvmet_hosts_type =3D {
+	.ct_group_ops		=3D &nvmet_hosts_group_ops,
+	.ct_item_ops		=3D NULL,
+	.ct_attrs		=3D NULL,
+	.ct_owner		=3D THIS_MODULE,
+};
+
+/*
+ * nvmet_port Generic ConfigFS definitions.
+ */
+static ssize_t nvmet_port_addr_adrfam_show(struct config_item *item,
+		char *page)
+{
+	switch (to_nvmet_port_binding(item)->disc_addr.adrfam) {
+	case NVMF_ADDR_FAMILY_IP4:
+		return sprintf(page, "ipv4\n");
+	case NVMF_ADDR_FAMILY_IP6:
+		return sprintf(page, "ipv6\n");
+	case NVMF_ADDR_FAMILY_IB:
+		return sprintf(page, "ib\n");
+	default:
+		return sprintf(page, "\n");
+	}
+}
+
+static ssize_t nvmet_port_addr_adrfam_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_port_binding *pb =3D to_nvmet_port_binding(item);
+
+	if (pb->enabled) {
+		pr_err("Cannot modify address while enabled\n");
+		pr_err("Disable the address before modifying\n");
+		return -EACCES;
+	}
+
+	if (sysfs_streq(page, "ipv4")) {
+		pb->disc_addr.adrfam =3D NVMF_ADDR_FAMILY_IP4;
+	} else if (sysfs_streq(page, "ipv6")) {
+		pb->disc_addr.adrfam =3D NVMF_ADDR_FAMILY_IP6;
+	} else if (sysfs_streq(page, "ib")) {
+		pb->disc_addr.adrfam =3D NVMF_ADDR_FAMILY_IB;
+	} else {
+		pr_err("Invalid value '%s' for adrfam\n", page);
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+CONFIGFS_ATTR(nvmet_port_, addr_adrfam);
+
+static ssize_t nvmet_port_addr_portid_show(struct config_item *item,
+		char *page)
+{
+	struct nvmet_port_binding *pb =3D to_nvmet_port_binding(item);
+
+	return snprintf(page, PAGE_SIZE, "%d\n",
+			le16_to_cpu(pb->disc_addr.portid));
+}
+
+static ssize_t nvmet_port_addr_portid_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_port_binding *pb =3D to_nvmet_port_binding(item);
+	u16 portid =3D 0;
+
+	if (kstrtou16(page, 0, &portid)) {
+		pr_err("Invalid value '%s' for portid\n", page);
+		return -EINVAL;
+	}
+
+	if (pb->enabled) {
+		pr_err("Cannot modify address while enabled\n");
+		pr_err("Disable the address before modifying\n");
+		return -EACCES;
+	}
+	pb->disc_addr.portid =3D cpu_to_le16(portid);
+	return count;
+}
+
+CONFIGFS_ATTR(nvmet_port_, addr_portid);
+
+static ssize_t nvmet_port_addr_traddr_show(struct config_item *item,
+		char *page)
+{
+	struct nvmet_port_binding *pb =3D to_nvmet_port_binding(item);
+
+	return snprintf(page, PAGE_SIZE, "%s\n",
+			pb->disc_addr.traddr);
+}
+
+static ssize_t nvmet_port_addr_traddr_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_port_binding *pb =3D to_nvmet_port_binding(item);
+
+	if (count > NVMF_TRADDR_SIZE) {
+		pr_err("Invalid value '%s' for traddr\n", page);
+		return -EINVAL;
+	}
+
+	if (pb->enabled) {
+		pr_err("Cannot modify address while enabled\n");
+		pr_err("Disable the address before modifying\n");
+		return -EACCES;
+	}
+	return snprintf(pb->disc_addr.traddr,
+			sizeof(pb->disc_addr.traddr), "%s", page);
+}
+
+CONFIGFS_ATTR(nvmet_port_, addr_traddr);
+
+static ssize_t nvmet_port_addr_treq_show(struct config_item *item,
+		char *page)
+{
+	switch (to_nvmet_port_binding(item)->disc_addr.treq) {
+	case NVMF_TREQ_NOT_SPECIFIED:
+		return sprintf(page, "not specified\n");
+	case NVMF_TREQ_REQUIRED:
+		return sprintf(page, "required\n");
+	case NVMF_TREQ_NOT_REQUIRED:
+		return sprintf(page, "not required\n");
+	default:
+		return sprintf(page, "\n");
+	}
+}
+
+static ssize_t nvmet_port_addr_treq_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_port_binding *pb =3D to_nvmet_port_binding(item);
+
+	if (pb->enabled) {
+		pr_err("Cannot modify address while enabled\n");
+		pr_err("Disable the address before modifying\n");
+		return -EACCES;
+	}
+
+	if (sysfs_streq(page, "not specified")) {
+		pb->disc_addr.treq =3D NVMF_TREQ_NOT_SPECIFIED;
+	} else if (sysfs_streq(page, "required")) {
+		pb->disc_addr.treq =3D NVMF_TREQ_REQUIRED;
+	} else if (sysfs_streq(page, "not required")) {
+		pb->disc_addr.treq =3D NVMF_TREQ_NOT_REQUIRED;
+	} else {
+		pr_err("Invalid value '%s' for treq\n", page);
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+CONFIGFS_ATTR(nvmet_port_, addr_treq);
+
+static ssize_t nvmet_port_addr_trsvcid_show(struct config_item *item,
+		char *page)
+{
+	struct nvmet_port_binding *pb =3D to_nvmet_port_binding(item);
+
+	return snprintf(page, PAGE_SIZE, "%s\n",
+			pb->disc_addr.trsvcid);
+}
+
+static ssize_t nvmet_port_addr_trsvcid_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_port_binding *pb =3D to_nvmet_port_binding(item);
+
+	if (count > NVMF_TRSVCID_SIZE) {
+		pr_err("Invalid value '%s' for trsvcid\n", page);
+		return -EINVAL;
+	}
+	if (pb->enabled) {
+		pr_err("Cannot modify address while enabled\n");
+		pr_err("Disable the address before modifying\n");
+		return -EACCES;
+	}
+	return snprintf(pb->disc_addr.trsvcid,
+			sizeof(pb->disc_addr.trsvcid), "%s", page);
+}
+
+CONFIGFS_ATTR(nvmet_port_, addr_trsvcid);
+
+static ssize_t nvmet_port_addr_trtype_show(struct config_item *item,
+		char *page)
+{
+	switch (to_nvmet_port_binding(item)->disc_addr.trtype) {
+	case NVMF_TRTYPE_RDMA:
+		return sprintf(page, "rdma\n");
+	case NVMF_TRTYPE_LOOP:
+		return sprintf(page, "loop\n");
+	default:
+		return sprintf(page, "\n");
+	}
+}
+
+static void nvmet_port_init_tsas_rdma(struct nvmet_port_binding *pb)
+{
+	pb->disc_addr.trtype =3D NVMF_TRTYPE_RDMA;
+	memset(&pb->disc_addr.tsas.rdma, 0, NVMF_TSAS_SIZE);
+	pb->disc_addr.tsas.rdma.qptype =3D NVMF_RDMA_QPTYPE_CONNECTED;
+	pb->disc_addr.tsas.rdma.prtype =3D NVMF_RDMA_PRTYPE_NOT_SPECIFIED;
+	pb->disc_addr.tsas.rdma.cms =3D NVMF_RDMA_CMS_RDMA_CM;
+}
+
+static void nvmet_port_init_tsas_loop(struct nvmet_port_binding *pb)
+{
+	pb->disc_addr.trtype =3D NVMF_TRTYPE_LOOP;
+	memset(&pb->disc_addr.tsas, 0, NVMF_TSAS_SIZE);
+}
+
+static ssize_t nvmet_port_addr_trtype_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_port_binding *pb =3D to_nvmet_port_binding(item);
+
+	if (pb->enabled) {
+		pr_err("Cannot modify address while enabled\n");
+		pr_err("Disable the address before modifying\n");
+		return -EACCES;
+	}
+
+	if (sysfs_streq(page, "rdma")) {
+		nvmet_port_init_tsas_rdma(pb);
+	} else if (sysfs_streq(page, "loop")) {
+		nvmet_port_init_tsas_loop(pb);
+	} else {
+		pr_err("Invalid value '%s' for trtype\n", page);
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+CONFIGFS_ATTR(nvmet_port_, addr_trtype);
+
+static void nvmet_port_disable(struct nvmet_port_binding *pb)
+{
+	struct nvmet_fabrics_ops *ops =3D pb->nf_ops;
+	struct nvmet_port *port =3D pb->port;
+
+	if (!ops || !port)
+		return;
+
+	ops->remove_port(pb);
+	nvmet_put_transport(&pb->disc_addr);
+	pb->nf_ops =3D NULL;
+
+	atomic64_inc(&nvmet_genctr);
+}
+
+static ssize_t nvmet_port_enable_show(struct config_item *item, char *=
page)
+{
+	struct nvmet_port_binding *pb =3D to_nvmet_port_binding(item);
+
+	return sprintf(page, "%d\n", pb->enabled);
+}
+
+static ssize_t nvmet_port_enable_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_port *port;
+	struct nvmet_port_binding *pb =3D to_nvmet_port_binding(item);
+	struct nvmet_fabrics_ops *ops;
+	bool enable;
+	int rc;
+
+	if (strtobool(page, &enable))
+		return -EINVAL;
+
+	if (enable) {
+		if (pb->enabled) {
+			pr_warn("port already enabled: %d\n",
+				pb->disc_addr.trtype);
+			goto out;
+		}
+
+		ops =3D nvmet_get_transport(&pb->disc_addr);
+		if (IS_ERR(ops))
+			return PTR_ERR(ops);
+
+		pb->nf_ops =3D ops;
+
+		rc =3D ops->add_port(pb);
+		if (rc) {
+			nvmet_put_transport(&pb->disc_addr);
+			return rc;
+		}
+
+		atomic64_inc(&nvmet_genctr);
+	} else {
+		if (!pb->nf_ops)
+			return -EINVAL;
+
+		port =3D pb->port;
+		if (!port)
+			return -EINVAL;
+
+		nvmet_port_disable(pb);
+	}
+out:
+	return count;
+}
+
+CONFIGFS_ATTR(nvmet_port_, enable);
+
+static struct configfs_attribute *nvmet_port_attrs[] =3D {
+	&nvmet_port_attr_addr_adrfam,
+	&nvmet_port_attr_addr_portid,
+	&nvmet_port_attr_addr_traddr,
+	&nvmet_port_attr_addr_treq,
+	&nvmet_port_attr_addr_trsvcid,
+	&nvmet_port_attr_addr_trtype,
+	&nvmet_port_attr_enable,
+	NULL,
+};
+
+/*
+ * NVMf transport port CIT
+ */
+static void nvmet_port_release(struct config_item *item)
+{
+	struct nvmet_port_binding *pb =3D to_nvmet_port_binding(item);
+
+	nvmet_port_disable(pb);
+	kfree(pb);
+}
+
+static struct configfs_item_operations nvmet_port_item_ops =3D {
+	.release	=3D nvmet_port_release,
+};
+
+static struct config_item_type nvmet_port_type =3D {
+	.ct_item_ops		=3D &nvmet_port_item_ops,
+	.ct_attrs		=3D nvmet_port_attrs,
+	.ct_owner		=3D THIS_MODULE,
+};
+
+static struct config_group *nvmet_make_ports(struct config_group *grou=
p,
+		const char *name)
+{
+	struct nvmet_subsys *subsys =3D ports_to_subsys(&group->cg_item);
+	struct nvmet_port_binding *pb;
+
+	printk("Entering nvmet_make_port %s >>>>>>>>>>>>>>>>>>\n", name);
+
+	pb =3D kzalloc(sizeof(*pb), GFP_KERNEL);
+	if (!pb)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&pb->node);
+	pb->nf_subsys =3D subsys;
+
+	config_group_init_type_name(&pb->group, name, &nvmet_port_type);
+
+	return &pb->group;
+}
+
+static void nvmet_drop_ports(struct config_group *group, struct config=
_item *item)
+{
+	config_item_put(item);
+}
+
+static struct configfs_group_operations nvmet_ports_group_ops =3D {
+	.make_group		=3D nvmet_make_ports,
+	.drop_item		=3D nvmet_drop_ports,
+};
+
+static struct config_item_type nvmet_ports_type =3D {
+	.ct_group_ops		=3D &nvmet_ports_group_ops,
+	.ct_item_ops		=3D NULL,
+	.ct_attrs		=3D NULL,
+	.ct_owner		=3D THIS_MODULE,
+};
+
+/*
+ * NVMf namespace <-> /sys/kernel/config/target/core/ backend configfs=
 symlink
+ */
+static int nvmet_ns_link(struct config_item *ns_ci, struct config_item=
 *dev_ci)
+{
+	struct nvmet_ns *ns =3D to_nvmet_ns(ns_ci);
+	struct se_device *dev =3D
+		container_of(to_config_group(dev_ci), struct se_device, dev_group);
+
+	if (dev->dev_link_magic !=3D SE_DEV_LINK_MAGIC) {
+		pr_err("Bad dev->dev_link_magic, not a valid se_dev_ci pointer:"
+		       " %p to struct se_device: %p\n", dev_ci, dev);
+		return -EFAULT;
+	}
+
+	if (!(dev->dev_flags & DF_CONFIGURED)) {
+		pr_err("se_device not configured yet, cannot namespace link\n");
+		return -ENODEV;
+	}
+
+	if (!dev->transport->sbc_ops) {
+		pr_err("se_device does not have sbc_ops, cannot namespace link\n");
+		return -ENOSYS;
+	}
+
+	// XXX: Pass in struct se_device into nvmet_ns_enable
+	return nvmet_ns_enable(ns);
+}
+
+static int nvmet_ns_unlink(struct config_item *ns_ci, struct config_it=
em *dev_ci)
+{
+	struct nvmet_ns *ns =3D to_nvmet_ns(ns_ci);
+
+	nvmet_ns_disable(ns);
+	return 0;
+}
+
+static void nvmet_ns_release(struct config_item *item)
+{
+	struct nvmet_ns *ns =3D to_nvmet_ns(item);
+
+	nvmet_ns_free(ns);
+}
+
+static struct configfs_item_operations nvmet_ns_item_ops =3D {
+	.release		=3D nvmet_ns_release,
+	.allow_link		=3D nvmet_ns_link,
+	.drop_link		=3D nvmet_ns_unlink,
+};
+
+static struct config_item_type nvmet_ns_type =3D {
+	.ct_item_ops		=3D &nvmet_ns_item_ops,
+	.ct_attrs		=3D NULL,
+	.ct_owner		=3D THIS_MODULE,
+};
+
+static struct config_group *nvmet_make_namespace(struct config_group *=
group,
+		const char *name)
+{
+	struct nvmet_subsys *subsys =3D namespaces_to_subsys(&group->cg_item)=
;
+	struct nvmet_ns *ns;
+	int ret;
+	u32 nsid;
+
+	ret =3D kstrtou32(name, 0, &nsid);
+	if (ret)
+		goto out;
+
+	ret =3D -EINVAL;
+	if (nsid =3D=3D 0 || nsid =3D=3D 0xffffffff)
+		goto out;
+
+	ret =3D -ENOMEM;
+	ns =3D nvmet_ns_alloc(subsys, nsid);
+	if (!ns)
+		goto out;
+	config_group_init_type_name(&ns->group, name, &nvmet_ns_type);
+
+	pr_info("adding nsid %d to subsystem %s\n", nsid, subsys->subsysnqn);
+
+	return &ns->group;
+out:
+	return ERR_PTR(ret);
+}
+
+static void nvmet_drop_namespace(struct config_group *group, struct co=
nfig_item *item)
+{
+	/*
+	 * struct nvmet_ns is released via nvmet_ns_release()
+	 */
+	config_item_put(item);
+}
+
+static struct configfs_group_operations nvmet_namespaces_group_ops =3D=
 {
+	.make_group		=3D nvmet_make_namespace,
+	.drop_item		=3D nvmet_drop_namespace,
+};
+
+static struct config_item_type nvmet_namespaces_type =3D {
+	.ct_group_ops		=3D &nvmet_namespaces_group_ops,
+	.ct_owner		=3D THIS_MODULE,
+};
+
+/*
+ * Subsystem structures & folder operation functions below
+ */
+static void nvmet_subsys_release(struct config_item *item)
+{
+	struct nvmet_subsys *subsys =3D to_subsys(item);
+
+	nvmet_subsys_put(subsys);
+}
+
+static struct configfs_item_operations nvmet_subsys_item_ops =3D {
+	.release		=3D nvmet_subsys_release,
+};
+
+static struct config_item_type nvmet_subsys_type =3D {
+	.ct_item_ops		=3D &nvmet_subsys_item_ops,
+//	.ct_attrs		=3D nvmet_subsys_attrs,
+	.ct_owner		=3D THIS_MODULE,
+};
+
+static struct config_group *nvmet_make_subsys(struct config_group *gro=
up,
+		const char *name)
+{
+	struct nvmet_subsys *subsys;
+
+	if (sysfs_streq(name, NVME_DISC_SUBSYS_NAME)) {
+		pr_err("can't create discovery subsystem through configfs\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	subsys =3D nvmet_subsys_alloc(name, NVME_NQN_NVME);
+	if (!subsys)
+		return ERR_PTR(-ENOMEM);
+
+	config_group_init_type_name(&subsys->group, name, &nvmet_subsys_type)=
;
+
+	config_group_init_type_name(&subsys->namespaces_group,
+			"namespaces", &nvmet_namespaces_type);
+	configfs_add_default_group(&subsys->namespaces_group, &subsys->group)=
;
+
+	config_group_init_type_name(&subsys->ports_group,
+			"ports", &nvmet_ports_type);
+	configfs_add_default_group(&subsys->ports_group, &subsys->group);
+
+	config_group_init_type_name(&subsys->hosts_group,
+			"hosts", &nvmet_hosts_type);
+	configfs_add_default_group(&subsys->hosts_group, &subsys->group);
+
+//	XXX: subsys->allow_any_host hardcoded to true
+	subsys->allow_any_host =3D true;
+
+	return &subsys->group;
+}
+
+static void nvmet_drop_subsys(struct config_group *group, struct confi=
g_item *item)
+{
+	/*
+	 * struct nvmet_port is releated via nvmet_subsys_release()
+	 */
+	config_item_put(item);
+}
+
+static struct configfs_group_operations nvmet_subsystems_group_ops =3D=
 {
+	.make_group		=3D nvmet_make_subsys,
+	.drop_item		=3D nvmet_drop_subsys,
+};
+
+static struct config_item_type nvmet_subsystems_type =3D {
+	.ct_group_ops		=3D &nvmet_subsystems_group_ops,
+	.ct_owner		=3D THIS_MODULE,
+};
+
+static struct config_group nvmet_subsystems_group;
+
+static struct config_item_type nvmet_root_type =3D {
+	.ct_owner		=3D THIS_MODULE,
+};
+
+static struct configfs_subsystem nvmet_configfs_subsystem =3D {
+	.su_group =3D {
+		.cg_item =3D {
+			.ci_namebuf	=3D "nvmet",
+			.ci_type	=3D &nvmet_root_type,
+		},
+	},
+};
+
+int __init nvmet_init_configfs(void)
+{
+	int ret;
+
+	config_group_init(&nvmet_configfs_subsystem.su_group);
+	mutex_init(&nvmet_configfs_subsystem.su_mutex);
+
+	config_group_init_type_name(&nvmet_subsystems_group,
+			"subsystems", &nvmet_subsystems_type);
+	configfs_add_default_group(&nvmet_subsystems_group,
+			&nvmet_configfs_subsystem.su_group);
+
+	ret =3D configfs_register_subsystem(&nvmet_configfs_subsystem);
+	if (ret) {
+		pr_err("configfs_register_subsystem: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+void __exit nvmet_exit_configfs(void)
+{
+	configfs_unregister_subsystem(&nvmet_configfs_subsystem);
+}
diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/confi=
gfs.c
index aebe646..b30896a 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -441,7 +441,9 @@ static int nvmet_port_subsys_allow_link(struct conf=
ig_item *parent,
 	if (!link)
 		return -ENOMEM;
 	link->subsys =3D subsys;
-
+#if 1
+	BUG_ON(1);
+#else
 	down_write(&nvmet_config_sem);
 	ret =3D -EEXIST;
 	list_for_each_entry(p, &port->subsystems, entry) {
@@ -458,6 +460,7 @@ static int nvmet_port_subsys_allow_link(struct conf=
ig_item *parent,
 	list_add_tail(&link->entry, &port->subsystems);
 	nvmet_genctr++;
 	up_write(&nvmet_config_sem);
+#endif
 	return 0;
=20
 out_free_link:
@@ -469,6 +472,7 @@ out_free_link:
 static int nvmet_port_subsys_drop_link(struct config_item *parent,
 		struct config_item *target)
 {
+#if 0
 	struct nvmet_port *port =3D to_nvmet_port(parent->ci_parent);
 	struct nvmet_subsys *subsys =3D to_subsys(target);
 	struct nvmet_subsys_link *p;
@@ -487,7 +491,9 @@ found:
 	if (list_empty(&port->subsystems))
 		nvmet_disable_port(port);
 	up_write(&nvmet_config_sem);
+
 	kfree(p);
+#endif
 	return 0;
 }
=20
@@ -504,6 +510,7 @@ static struct config_item_type nvmet_port_subsys_ty=
pe =3D {
 static int nvmet_allowed_hosts_allow_link(struct config_item *parent,
 		struct config_item *target)
 {
+#if 0
 	struct nvmet_subsys *subsys =3D to_subsys(parent->ci_parent);
 	struct nvmet_host *host;
 	struct nvmet_host_link *link, *p;
@@ -540,11 +547,13 @@ out_free_link:
 	up_write(&nvmet_config_sem);
 	kfree(link);
 	return ret;
+#endif
 }
=20
 static int nvmet_allowed_hosts_drop_link(struct config_item *parent,
 		struct config_item *target)
 {
+#if 0
 	struct nvmet_subsys *subsys =3D to_subsys(parent->ci_parent);
 	struct nvmet_host *host =3D to_host(target);
 	struct nvmet_host_link *p;
@@ -563,6 +572,7 @@ found:
 	up_write(&nvmet_config_sem);
 	kfree(p);
 	return 0;
+#endif
 }
=20
 static struct configfs_item_operations nvmet_allowed_hosts_item_ops =3D=
 {
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 689ad4c..3357696 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -147,6 +147,7 @@ EXPORT_SYMBOL_GPL(nvmet_unregister_transport);
=20
 int nvmet_enable_port(struct nvmet_port *port)
 {
+#if 0
 	struct nvmet_fabrics_ops *ops;
 	int ret;
=20
@@ -175,11 +176,13 @@ int nvmet_enable_port(struct nvmet_port *port)
 	}
=20
 	port->enabled =3D true;
+#endif
 	return 0;
 }
=20
 void nvmet_disable_port(struct nvmet_port *port)
 {
+#if 0
 	struct nvmet_fabrics_ops *ops;
=20
 	lockdep_assert_held(&nvmet_config_sem);
@@ -189,6 +192,7 @@ void nvmet_disable_port(struct nvmet_port *port)
 	ops =3D nvmet_transports[port->disc_addr.trtype];
 	ops->remove_port(port);
 	module_put(ops->owner);
+#endif
 }
=20
 struct nvmet_fabrics_ops *
@@ -681,15 +685,19 @@ out:
 static bool __nvmet_host_allowed(struct nvmet_subsys *subsys,
 		const char *hostnqn)
 {
-	struct nvmet_host_link *p;
+	struct nvmet_host *h;
=20
 	if (subsys->allow_any_host)
 		return true;
=20
-	list_for_each_entry(p, &subsys->hosts, entry) {
-		if (!strcmp(nvmet_host_name(p->host), hostnqn))
+	mutex_lock(&subsys->hosts_mutex);
+	list_for_each_entry(h, &subsys->hosts, node) {
+		if (!strcmp(nvmet_host_name(h), hostnqn)) {
+			mutex_unlock(&subsys->hosts_mutex);
 			return true;
+		}
 	}
+	mutex_unlock(&subsys->hosts_mutex);
=20
 	return false;
 }
@@ -697,10 +705,21 @@ static bool __nvmet_host_allowed(struct nvmet_sub=
sys *subsys,
 static bool nvmet_host_discovery_allowed(struct nvmet_req *req,
 		const char *hostnqn)
 {
-	struct nvmet_subsys_link *s;
+	struct nvmet_port_binding *pb;
+	struct nvmet_port *port =3D req->port;
+	struct nvmet_subsys *subsys;
+
+	if (!port)
+		return false;
+
+	lockdep_assert_held(&port->port_binding_mutex);
+
+	list_for_each_entry(pb, &port->port_binding_list, node) {
+		subsys =3D pb->nf_subsys;
+		if (!subsys)
+			continue;
=20
-	list_for_each_entry(s, &req->port->subsystems, entry) {
-		if (__nvmet_host_allowed(s->subsys, hostnqn))
+		if (__nvmet_host_allowed(subsys, hostnqn))
 			return true;
 	}
=20
@@ -710,8 +729,6 @@ static bool nvmet_host_discovery_allowed(struct nvm=
et_req *req,
 bool nvmet_host_allowed(struct nvmet_req *req, struct nvmet_subsys *su=
bsys,
 		const char *hostnqn)
 {
-	lockdep_assert_held(&nvmet_config_sem);
-
 	if (subsys->type =3D=3D NVME_NQN_DISC)
 		return nvmet_host_discovery_allowed(req, hostnqn);
 	else
@@ -721,13 +738,14 @@ bool nvmet_host_allowed(struct nvmet_req *req, st=
ruct nvmet_subsys *subsys,
 u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 		struct nvmet_req *req, u32 kato, struct nvmet_ctrl **ctrlp)
 {
+	struct nvmet_port *port =3D req->port;
 	struct nvmet_subsys *subsys;
 	struct nvmet_ctrl *ctrl;
 	int ret;
 	u16 status;
=20
 	status =3D NVME_SC_CONNECT_INVALID_PARAM | NVME_SC_DNR;
-	subsys =3D nvmet_find_get_subsys(req->port, subsysnqn);
+	subsys =3D nvmet_find_get_subsys(port, subsysnqn);
 	if (!subsys) {
 		pr_warn("connect request for invalid subsystem %s!\n",
 			subsysnqn);
@@ -736,15 +754,16 @@ u16 nvmet_alloc_ctrl(const char *subsysnqn, const=
 char *hostnqn,
 	}
=20
 	status =3D NVME_SC_CONNECT_INVALID_PARAM | NVME_SC_DNR;
-	down_read(&nvmet_config_sem);
+
+	mutex_lock(&port->port_binding_mutex);
 	if (!nvmet_host_allowed(req, subsys, hostnqn)) {
 		pr_info("connect by host %s for subsystem %s not allowed\n",
 			hostnqn, subsysnqn);
 		req->rsp->result =3D IPO_IATTR_CONNECT_DATA(hostnqn);
-		up_read(&nvmet_config_sem);
+		mutex_unlock(&port->port_binding_mutex);
 		goto out_put_subsystem;
 	}
-	up_read(&nvmet_config_sem);
+	mutex_unlock(&port->port_binding_mutex);
=20
 	status =3D NVME_SC_INTERNAL;
 	ctrl =3D kzalloc(sizeof(*ctrl), GFP_KERNEL);
@@ -872,10 +891,29 @@ void nvmet_ctrl_fatal_error(struct nvmet_ctrl *ct=
rl)
 }
 EXPORT_SYMBOL_GPL(nvmet_ctrl_fatal_error);
=20
+void nvmet_port_binding_enable(struct nvmet_port_binding *pb, struct n=
vmet_port *port)
+{
+	mutex_lock(&port->port_binding_mutex);
+	pb->enabled =3D true;
+	list_add_tail(&pb->node, &port->port_binding_list);
+	mutex_unlock(&port->port_binding_mutex);
+}
+EXPORT_SYMBOL_GPL(nvmet_port_binding_enable);
+
+void nvmet_port_binding_disable(struct nvmet_port_binding *pb, struct =
nvmet_port *port)
+{
+	mutex_lock(&port->port_binding_mutex);
+	pb->enabled =3D false;
+	list_del_init(&pb->node);
+	mutex_unlock(&port->port_binding_mutex);
+}
+EXPORT_SYMBOL_GPL(nvmet_port_binding_disable);
+
 static struct nvmet_subsys *nvmet_find_get_subsys(struct nvmet_port *p=
ort,
 		const char *subsysnqn)
 {
-	struct nvmet_subsys_link *p;
+	struct nvmet_port_binding *pb;
+	struct nvmet_subsys *subsys;
=20
 	if (!port)
 		return NULL;
@@ -887,17 +925,22 @@ static struct nvmet_subsys *nvmet_find_get_subsys=
(struct nvmet_port *port,
 		return nvmet_disc_subsys;
 	}
=20
-	down_read(&nvmet_config_sem);
-	list_for_each_entry(p, &port->subsystems, entry) {
-		if (!strncmp(p->subsys->subsysnqn, subsysnqn,
-				NVMF_NQN_SIZE)) {
-			if (!kref_get_unless_zero(&p->subsys->ref))
-				break;
-			up_read(&nvmet_config_sem);
-			return p->subsys;
+	mutex_lock(&port->port_binding_mutex);
+	list_for_each_entry(pb, &port->port_binding_list, node) {
+		subsys =3D pb->nf_subsys;
+		if (!subsys)
+			continue;
+
+		if (strcmp(subsys->subsysnqn, subsysnqn))
+			continue;
+
+		if (kref_get_unless_zero(&subsys->ref)) {=09
+			mutex_unlock(&port->port_binding_mutex);
+			return subsys;
 		}
 	}
-	up_read(&nvmet_config_sem);
+	mutex_unlock(&port->port_binding_mutex);
+
 	return NULL;
 }
=20
@@ -935,13 +978,13 @@ struct nvmet_subsys *nvmet_subsys_alloc(const cha=
r *subsysnqn,
 	kref_init(&subsys->ref);
=20
 	mutex_init(&subsys->lock);
+	mutex_init(&subsys->hosts_mutex);
 	INIT_LIST_HEAD(&subsys->namespaces);
 	INIT_LIST_HEAD(&subsys->ctrls);
+	INIT_LIST_HEAD(&subsys->hosts);
=20
 	ida_init(&subsys->cntlid_ida);
=20
-	INIT_LIST_HEAD(&subsys->hosts);
-
 	return subsys;
 }
=20
diff --git a/drivers/nvme/target/discovery.c b/drivers/nvme/target/disc=
overy.c
index 6f65646..32dc05c 100644
--- a/drivers/nvme/target/discovery.c
+++ b/drivers/nvme/target/discovery.c
@@ -18,7 +18,7 @@
=20
 struct nvmet_subsys *nvmet_disc_subsys;
=20
-u64 nvmet_genctr;
+atomic_long_t nvmet_genctr;
=20
 void nvmet_referral_enable(struct nvmet_port *parent, struct nvmet_por=
t *port)
 {
@@ -26,7 +26,7 @@ void nvmet_referral_enable(struct nvmet_port *parent,=
 struct nvmet_port *port)
 	if (list_empty(&port->entry)) {
 		list_add_tail(&port->entry, &parent->referrals);
 		port->enabled =3D true;
-		nvmet_genctr++;
+		atomic64_inc(&nvmet_genctr);
 	}
 	up_write(&nvmet_config_sem);
 }
@@ -37,7 +37,7 @@ void nvmet_referral_disable(struct nvmet_port *port)
 	if (!list_empty(&port->entry)) {
 		port->enabled =3D false;
 		list_del_init(&port->entry);
-		nvmet_genctr++;
+		atomic64_inc(&nvmet_genctr);
 	}
 	up_write(&nvmet_config_sem);
 }
@@ -69,8 +69,8 @@ static void nvmet_execute_get_disc_log_page(struct nv=
met_req *req)
 	size_t data_len =3D nvmet_get_log_page_len(req->cmd);
 	size_t alloc_len =3D max(data_len, sizeof(*hdr));
 	int residual_len =3D data_len - sizeof(*hdr);
-	struct nvmet_subsys_link *p;
-	struct nvmet_port *r;
+	struct nvmet_port *port =3D req->port;
+	struct nvmet_port_binding *pb;
 	u32 numrec =3D 0;
 	u16 status =3D 0;
=20
@@ -84,7 +84,7 @@ static void nvmet_execute_get_disc_log_page(struct nv=
met_req *req)
 		status =3D NVME_SC_INTERNAL;
 		goto out;
 	}
-
+#if 0
 	down_read(&nvmet_config_sem);
 	list_for_each_entry(p, &req->port->subsystems, entry) {
 		if (!nvmet_host_allowed(req, p->subsys, ctrl->hostnqn))
@@ -113,7 +113,26 @@ static void nvmet_execute_get_disc_log_page(struct=
 nvmet_req *req)
 	hdr->recfmt =3D cpu_to_le16(0);
=20
 	up_read(&nvmet_config_sem);
+#else
+	mutex_lock(&port->port_binding_mutex);
+	list_for_each_entry(pb, &port->port_binding_list, node) {
+		if (!nvmet_host_allowed(req, pb->nf_subsys, ctrl->hostnqn))
+			continue;
+
+		if (residual_len >=3D entry_size) {
+			nvmet_format_discovery_entry(hdr, port,
+					pb->nf_subsys->subsysnqn,
+					NVME_NQN_NVME, numrec);
+			residual_len -=3D entry_size;
+		}
+		numrec++;
+	}
+	hdr->genctr =3D cpu_to_le64(atomic64_read(&nvmet_genctr));
+	hdr->numrec =3D cpu_to_le64(numrec);
+	hdr->recfmt =3D cpu_to_le16(0);
=20
+	mutex_unlock(&port->port_binding_mutex);
+#endif
 	status =3D nvmet_copy_to_sgl(req, 0, hdr, data_len);
 	kfree(hdr);
 out:
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 17fd217..265f56f 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -79,6 +79,8 @@ struct nvmet_sq {
 	struct completion	free_done;
 };
=20
+struct nvmet_port_binding;
+
 /**
  * struct nvmet_port -	Common structure to keep port
  *				information for the target.
@@ -98,6 +100,25 @@ struct nvmet_port {
 	struct list_head		referrals;
 	void				*priv;
 	bool				enabled;
+
+	struct nvmet_subsys		*nf_subsys;
+	struct nvmet_fabrics_ops	*nf_ops;
+
+	struct mutex			port_binding_mutex;
+	struct list_head		port_binding_list;
+};
+
+struct nvmet_port_binding {
+	bool				enabled;
+	struct nvmf_disc_rsp_page_entry	disc_addr;
+
+	struct nvmet_port		*port;
+	struct nvmet_subsys		*nf_subsys;
+	struct nvmet_fabrics_ops	*nf_ops;
+
+	struct list_head		node;
+	struct list_head		subsys_node;
+	struct config_group		group;
 };
=20
 static inline struct nvmet_port *to_nvmet_port(struct config_item *ite=
m)
@@ -106,6 +127,13 @@ static inline struct nvmet_port *to_nvmet_port(str=
uct config_item *item)
 			group);
 }
=20
+static inline struct nvmet_port_binding *
+to_nvmet_port_binding(struct config_item *item)
+{
+	return container_of(to_config_group(item), struct nvmet_port_binding,
+			group);
+}
+
 struct nvmet_ctrl {
 	struct nvmet_subsys	*subsys;
 	struct nvmet_cq		**cqs;
@@ -147,6 +175,7 @@ struct nvmet_subsys {
 	struct list_head	ctrls;
 	struct ida		cntlid_ida;
=20
+	struct mutex		hosts_mutex;
 	struct list_head	hosts;
 	bool			allow_any_host;
=20
@@ -158,7 +187,8 @@ struct nvmet_subsys {
 	struct config_group	group;
=20
 	struct config_group	namespaces_group;
-	struct config_group	allowed_hosts_group;
+	struct config_group	ports_group;
+	struct config_group	hosts_group;
 };
=20
 static inline struct nvmet_subsys *to_subsys(struct config_item *item)
@@ -173,7 +203,17 @@ static inline struct nvmet_subsys *namespaces_to_s=
ubsys(
 			namespaces_group);
 }
=20
+static inline struct nvmet_subsys *ports_to_subsys(
+		struct config_item *item)
+{
+	return container_of(to_config_group(item), struct nvmet_subsys,
+			ports_group);
+}
+
 struct nvmet_host {
+	struct nvmet_subsys	*subsys;
+
+	struct list_head	node;
 	struct config_group	group;
 };
=20
@@ -205,8 +245,8 @@ struct nvmet_fabrics_ops {
 	unsigned int msdbd;
 	bool has_keyed_sgls : 1;
 	void (*queue_response)(struct nvmet_req *req);
-	int (*add_port)(struct nvmet_port *port);
-	void (*remove_port)(struct nvmet_port *port);
+	int (*add_port)(struct nvmet_port_binding *pb);
+	void (*remove_port)(struct nvmet_port_binding *pb);
 	void (*delete_ctrl)(struct nvmet_ctrl *ctrl);
 };
=20
@@ -274,6 +314,8 @@ void nvmet_sq_destroy(struct nvmet_sq *sq);
 int nvmet_sq_init(struct nvmet_sq *sq);
=20
 void nvmet_ctrl_fatal_error(struct nvmet_ctrl *ctrl);
+void nvmet_port_binding_enable(struct nvmet_port_binding *pb, struct n=
vmet_port *port);
+void nvmet_port_binding_disable(struct nvmet_port_binding *pb, struct =
nvmet_port *port);
=20
 void nvmet_update_cc(struct nvmet_ctrl *ctrl, u32 new);
 u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
@@ -326,7 +368,7 @@ int __init nvmet_init_discovery(void);
 void nvmet_exit_discovery(void);
=20
 extern struct nvmet_subsys *nvmet_disc_subsys;
-extern u64 nvmet_genctr;
+extern atomic_long_t nvmet_genctr;
 extern struct rw_semaphore nvmet_config_sem;
=20
 bool nvmet_host_allowed(struct nvmet_req *req, struct nvmet_subsys *su=
bsys,
--=20
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
