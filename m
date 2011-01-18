From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: [PATCH] target_core_mib.h move
Date: Tue, 18 Jan 2011 17:58:32 +0100
Message-ID: <AANLkTinNiohS+9WDcCP4P=0beRRE53x4iFC9u7iXBOy2@mail.gmail.com>
References: <AANLkTim-KKyOt_U2cDvfW3cav9F29mSvzAcV9H2mJqbT@mail.gmail.com>
	<20110117205130.GA22532@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57846 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab1ARQ6d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jan 2011 11:58:33 -0500
Received: by iyj18 with SMTP id 18so5884190iyj.19
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2011 08:58:32 -0800 (PST)
In-Reply-To: <20110117205130.GA22532@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Mon, Jan 17, 2011 at 9:51 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jan 17, 2011 at 09:00:02PM +0100, Fubo Chen wrote:
>> target_core_mib.h move from drivers/target to include/target.
>> Otherwise my driver not build.
>>
>> Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
>
> Why does the driver need to poke into the target MIB code directly?

I should ask you why.

> Can you post the driver?

Compiler says:

$ make M=drivers/target modules
  CC [M]  drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.o
In file included from drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.c:15:0:
include/target/target_core_base.h:11:29: fatal error:
target_core_mib.h: No such file or directory
compilation terminated.
make[2]: *** [drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.o] Error 1
make[1]: *** [drivers/target/tcm_mvsas_tgt] Error 2
make: *** [_module_drivers/target] Error 2

for this driver:

---
 drivers/target/Kbuild                              |    1 +
 drivers/target/Kconfig                             |    2 +
 drivers/target/tcm_mvsas_tgt/Kbuild                |    3 +
 drivers/target/tcm_mvsas_tgt/Kconfig               |    6 +
 drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_base.h  |   31 ++
 .../target/tcm_mvsas_tgt/tcm_mvsas_tgt_configfs.c  |  298 ++++++++++++++++++++
 .../target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.c    |  272 ++++++++++++++++++
 .../target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.h    |   39 +++
 8 files changed, 652 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/Kbuild
 create mode 100644 drivers/target/tcm_mvsas_tgt/Kbuild
 create mode 100644 drivers/target/tcm_mvsas_tgt/Kconfig
 create mode 100644 drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_base.h
 create mode 100644 drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_configfs.c
 create mode 100644 drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.c
 create mode 100644 drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.h

diff --git a/drivers/target/Kbuild b/drivers/target/Kbuild
new file mode 100644
index 0000000..a997c81
--- /dev/null
+++ b/drivers/target/Kbuild
@@ -0,0 +1 @@
+obj-$(CONFIG_TCM_MVSAS_TGT)	+= tcm_mvsas_tgt/
diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 2fac3be..85dcc60 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -29,4 +29,6 @@ config TCM_PSCSI
 	Say Y here to enable the TCM/pSCSI subsystem plugin for non-buffered
 	passthrough access to Linux/SCSI device

+source drivers/target/mvsas_tgt/Kconfig
+
 endif
diff --git a/drivers/target/tcm_mvsas_tgt/Kbuild
b/drivers/target/tcm_mvsas_tgt/Kbuild
new file mode 100644
index 0000000..1c179d7
--- /dev/null
+++ b/drivers/target/tcm_mvsas_tgt/Kbuild
@@ -0,0 +1,3 @@
+tcm_mvsas_tgt-objs			:= tcm_mvsas_tgt_fabric.o \
+					   tcm_mvsas_tgt_configfs.o
+obj-$(CONFIG_TCM_MVSAS_TGT)		+= tcm_mvsas_tgt.o
diff --git a/drivers/target/tcm_mvsas_tgt/Kconfig
b/drivers/target/tcm_mvsas_tgt/Kconfig
new file mode 100644
index 0000000..4e505fb
--- /dev/null
+++ b/drivers/target/tcm_mvsas_tgt/Kconfig
@@ -0,0 +1,6 @@
+config TCM_MVSAS_TGT
+	tristate "TCM_MVSAS_TGT fabric module"
+	depends on TARGET_CORE && CONFIGFS_FS
+	default n
+	---help---
+	Say Y here to enable the TCM_MVSAS_TGT fabric module
diff --git a/drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_base.h
b/drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_base.h
new file mode 100644
index 0000000..44d1a03
--- /dev/null
+++ b/drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_base.h
@@ -0,0 +1,31 @@
+#define TCM_MVSAS_TGT_VERSION  "v0.1"
+#define TCM_MVSAS_TGT_NAMELEN 32
+
+struct tcm_mvsas_tgt_nacl {
+	/* Binary World Wide unique Port Name for SAS Initiator port */
+	u64 iport_wwpn;
+	/* ASCII formatted WWPN for Sas Initiator port */
+	char iport_name[TCM_MVSAS_TGT_NAMELEN];
+	/* Returned by tcm_mvsas_tgt_make_nodeacl() */
+	struct se_node_acl se_node_acl;
+};
+
+struct tcm_mvsas_tgt_tpg {
+	/* SAS port target portal group tag for TCM */
+	u16 tport_tpgt;
+	/* Pointer back to tcm_mvsas_tgt_tport */
+	struct tcm_mvsas_tgt_tport *tport;
+	/* Returned by tcm_mvsas_tgt_make_tpg() */
+	struct se_portal_group se_tpg;
+};
+
+struct tcm_mvsas_tgt_tport {
+	/* SCSI protocol the tport is providing */
+	u8 tport_proto_id;
+	/* Binary World Wide unique Port Name for SAS Target port */
+	u64 tport_wwpn;
+	/* ASCII formatted WWPN for SAS Target port */
+	char tport_name[TCM_MVSAS_TGT_NAMELEN];
+	/* Returned by tcm_mvsas_tgt_make_tport() */
+	struct se_wwn tport_wwn;
+};
diff --git a/drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_configfs.c
b/drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_configfs.c
new file mode 100644
index 0000000..7a4e938
--- /dev/null
+++ b/drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_configfs.c
@@ -0,0 +1,298 @@
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/version.h>
+#include <generated/utsrelease.h>
+#include <linux/utsname.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/configfs.h>
+#include <linux/ctype.h>
+#include <asm/unaligned.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_fabric_ops.h>
+#include <target/target_core_fabric_configfs.h>
+#include <target/target_core_fabric_lib.h>
+#include <target/target_core_device.h>
+#include <target/target_core_tpg.h>
+#include <target/target_core_configfs.h>
+#include <target/target_core_base.h>
+#include <target/configfs_macros.h>
+
+#include <tcm_mvsas_tgt_base.h>
+#include <tcm_mvsas_tgt_fabric.h>
+
+/* Local pointer to allocated TCM configfs fabric module */
+struct target_fabric_configfs *tcm_mvsas_tgt_fabric_configfs;
+
+static struct se_node_acl *tcm_mvsas_tgt_make_nodeacl(
+	struct se_portal_group *se_tpg,
+	struct config_group *group,
+	const char *name)
+{
+	struct se_node_acl *se_nacl, *se_nacl_new;
+	struct tcm_mvsas_tgt_nacl *nacl;
+	u64 wwpn = 0;
+	u32 nexus_depth;
+
+	/* tcm_mvsas_tgt_parse_wwn(name, &wwpn, 1) < 0)
+		return ERR_PTR(-EINVAL); */
+	se_nacl_new = tcm_mvsas_tgt_alloc_fabric_acl(se_tpg);
+	if (!(se_nacl_new))
+		return ERR_PTR(-ENOMEM);
+//#warning FIXME: Hardcoded nexus depth in tcm_mvsas_tgt_make_nodeacl()
+	nexus_depth = 1;
+	/*
+	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
+	 * when converting a NodeACL from demo mode -> explict
+	 */
+	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
+				name, nexus_depth);
+	if (IS_ERR(se_nacl)) {
+		tcm_mvsas_tgt_release_fabric_acl(se_tpg, se_nacl_new);
+		return se_nacl;
+	}
+	/*
+	 * Locate our struct tcm_mvsas_tgt_nacl and set the FC Nport WWPN
+	 */
+	nacl = container_of(se_nacl, struct tcm_mvsas_tgt_nacl, se_node_acl);
+	nacl->iport_wwpn = wwpn;
+	/* tcm_mvsas_tgt_format_wwn(&nacl->iport_name[0],
TCM_MVSAS_TGT_NAMELEN, wwpn); */
+
+	return se_nacl;
+}
+
+static void tcm_mvsas_tgt_drop_nodeacl(struct se_node_acl *se_acl)
+{
+	struct tcm_mvsas_tgt_nacl *nacl = container_of(se_acl,
+				struct tcm_mvsas_tgt_nacl, se_node_acl);
+	kfree(nacl);
+}
+
+static struct se_portal_group *tcm_mvsas_tgt_make_tpg(
+	struct se_wwn *wwn,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_mvsas_tgt_tport*tport = container_of(wwn,
+			struct tcm_mvsas_tgt_tport, tport_wwn);
+
+	struct tcm_mvsas_tgt_tpg *tpg;
+	unsigned long tpgt;
+	int ret;
+
+	if (strstr(name, "tpgt_") != name)
+		return ERR_PTR(-EINVAL);
+	if (strict_strtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)
+		return ERR_PTR(-EINVAL);
+
+	tpg = kzalloc(sizeof(struct tcm_mvsas_tgt_tpg), GFP_KERNEL);
+	if (!(tpg)) {
+		printk(KERN_ERR "Unable to allocate struct tcm_mvsas_tgt_tpg");
+		return ERR_PTR(-ENOMEM);
+	}
+	tpg->tport = tport;
+	tpg->tport_tpgt = tpgt;
+
+	ret = core_tpg_register(&tcm_mvsas_tgt_fabric_configfs->tf_ops, wwn,
+				&tpg->se_tpg, (void *)tpg,
+				TRANSPORT_TPG_TYPE_NORMAL);
+	if (ret < 0) {
+		kfree(tpg);
+		return NULL;
+	}
+	return &tpg->se_tpg;
+}
+
+static void tcm_mvsas_tgt_drop_tpg(struct se_portal_group *se_tpg)
+{
+	struct tcm_mvsas_tgt_tpg *tpg = container_of(se_tpg,
+				struct tcm_mvsas_tgt_tpg, se_tpg);
+
+	core_tpg_deregister(se_tpg);
+	kfree(tpg);
+}
+
+static struct se_wwn *tcm_mvsas_tgt_make_tport(
+	struct target_fabric_configfs *tf,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_mvsas_tgt_tport *tport;
+	u64 wwpn = 0;
+
+	/* if (tcm_mvsas_tgt_parse_wwn(name, &wwpn, 1) < 0)
+		return ERR_PTR(-EINVAL); */
+
+	tport = kzalloc(sizeof(struct tcm_mvsas_tgt_tport), GFP_KERNEL);
+	if (!(tport)) {
+		printk(KERN_ERR "Unable to allocate struct tcm_mvsas_tgt_tport");
+		return ERR_PTR(-ENOMEM);
+	}
+	tport->tport_wwpn = wwpn;
+	/* tcm_mvsas_tgt_format_wwn(&tport->tport_name[0],
TCM_MVSAS_TGT__NAMELEN, wwpn); */
+
+	return &tport->tport_wwn;
+}
+
+static void tcm_mvsas_tgt_drop_tport(struct se_wwn *wwn)
+{
+	struct tcm_mvsas_tgt_tport *tport = container_of(wwn,
+				struct tcm_mvsas_tgt_tport, tport_wwn);
+	kfree(tport);
+}
+
+static ssize_t tcm_mvsas_tgt_wwn_show_attr_version(
+	struct target_fabric_configfs *tf,
+	char *page)
+{
+	return sprintf(page, "TCM_MVSAS_TGT fabric module %s on %s/%s"
+		"on "UTS_RELEASE"\n", TCM_MVSAS_TGT_VERSION, utsname()->sysname,
+		utsname()->machine);
+}
+
+TF_WWN_ATTR_RO(tcm_mvsas_tgt, version);
+
+static struct configfs_attribute *tcm_mvsas_tgt_wwn_attrs[] = {
+	&tcm_mvsas_tgt_wwn_version.attr,
+	NULL,
+};
+
+static struct target_core_fabric_ops tcm_mvsas_tgt_ops = {
+	.get_fabric_name		= tcm_mvsas_tgt_get_fabric_name,
+	.get_fabric_proto_ident		= tcm_mvsas_tgt_get_fabric_proto_ident,
+	.tpg_get_wwn			= tcm_mvsas_tgt_get_fabric_wwn,
+	.tpg_get_tag			= tcm_mvsas_tgt_get_tag,
+	.tpg_get_default_depth		= tcm_mvsas_tgt_get_default_depth,
+	.tpg_get_pr_transport_id	= tcm_mvsas_tgt_get_pr_transport_id,
+	.tpg_get_pr_transport_id_len	= tcm_mvsas_tgt_get_pr_transport_id_len,
+	.tpg_parse_pr_out_transport_id	= tcm_mvsas_tgt_parse_pr_out_transport_id,
+	.tpg_check_demo_mode		= tcm_mvsas_tgt_check_false,
+	.tpg_check_demo_mode_cache	= tcm_mvsas_tgt_check_true,
+	.tpg_check_demo_mode_write_protect = tcm_mvsas_tgt_check_true,
+	.tpg_check_prod_mode_write_protect = tcm_mvsas_tgt_check_false,
+	.tpg_alloc_fabric_acl		= tcm_mvsas_tgt_alloc_fabric_acl,
+	.tpg_release_fabric_acl		= tcm_mvsas_tgt_release_fabric_acl,
+	.tpg_get_inst_index		= tcm_mvsas_tgt_tpg_get_inst_index,
+	.release_cmd_to_pool		= tcm_mvsas_tgt_release_cmd,
+	.release_cmd_direct		= tcm_mvsas_tgt_release_cmd,
+	.shutdown_session		= tcm_mvsas_tgt_shutdown_session,
+	.close_session			= tcm_mvsas_tgt_close_session,
+	.stop_session			= tcm_mvsas_tgt_stop_session,
+	.fall_back_to_erl0		= tcm_mvsas_tgt_reset_nexus,
+	.sess_logged_in			= tcm_mvsas_tgt_sess_logged_in,
+	.sess_get_index			= tcm_mvsas_tgt_sess_get_index,
+	.sess_get_initiator_sid		= NULL,
+	.write_pending			= tcm_mvsas_tgt_write_pending,
+	.write_pending_status		= tcm_mvsas_tgt_write_pending_status,
+	.set_default_node_attributes	= tcm_mvsas_tgt_set_default_node_attrs,
+	.get_task_tag			= tcm_mvsas_tgt_get_task_tag,
+	.get_cmd_state			= tcm_mvsas_tgt_get_cmd_state,
+	.new_cmd_failure		= tcm_mvsas_tgt_new_cmd_failure,
+	.queue_data_in			= tcm_mvsas_tgt_queue_data_in,
+	.queue_status			= tcm_mvsas_tgt_queue_status,
+	.queue_tm_rsp			= tcm_mvsas_tgt_queue_tm_rsp,
+	.get_fabric_sense_len		= tcm_mvsas_tgt_get_fabric_sense_len,
+	.set_fabric_sense_len		= tcm_mvsas_tgt_set_fabric_sense_len,
+	.is_state_remove		= tcm_mvsas_tgt_is_state_remove,
+	.pack_lun			= tcm_mvsas_tgt_pack_lun,
+	/*
+	 * Setup function pointers for generic logic in target_core_fabric_configfs.c
+	 */
+	.fabric_make_wwn		= tcm_mvsas_tgt_make_tport,
+	.fabric_drop_wwn		= tcm_mvsas_tgt_drop_tport,
+	.fabric_make_tpg		= tcm_mvsas_tgt_make_tpg,
+	.fabric_drop_tpg		= tcm_mvsas_tgt_drop_tpg,
+	.fabric_post_link		= NULL,
+	.fabric_pre_unlink		= NULL,
+	.fabric_make_np			= NULL,
+	.fabric_drop_np			= NULL,
+	.fabric_make_nodeacl		= tcm_mvsas_tgt_make_nodeacl,
+	.fabric_drop_nodeacl		= tcm_mvsas_tgt_drop_nodeacl,
+};
+
+static int tcm_mvsas_tgt_register_configfs(void)
+{
+	struct target_fabric_configfs *fabric;
+	int ret;
+
+	printk(KERN_INFO "TCM_MVSAS_TGT fabric module %s on %s/%s"
+		" on "UTS_RELEASE"\n",TCM_MVSAS_TGT_VERSION, utsname()->sysname,
+		utsname()->machine);
+	/*
+	 * Register the top level struct config_item_type with TCM core
+	 */
+	fabric = target_fabric_configfs_init(THIS_MODULE, "mvsas_tgt");
+	if (!(fabric)) {
+		printk(KERN_ERR "target_fabric_configfs_init() failed\n");
+		return -ENOMEM;
+	}
+	/*
+	 * Setup fabric->tf_ops from our local tcm_mvsas_tgt_ops
+	 */
+	fabric->tf_ops = tcm_mvsas_tgt_ops;
+	/*
+	 * Setup default attribute lists for various fabric->tf_cit_tmpl
+	 */
+	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = tcm_mvsas_tgt_wwn_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
+	/*
+	 * Register the fabric for use within TCM
+	 */
+	ret = target_fabric_configfs_register(fabric);
+	if (ret < 0) {
+		printk(KERN_ERR "target_fabric_configfs_register() failed"
+				" for TCM_MVSAS_TGT\n");
+		return ret;
+	}
+	/*
+	 * Setup our local pointer to *fabric
+	 */
+	tcm_mvsas_tgt_fabric_configfs = fabric;
+	printk(KERN_INFO "TCM_MVSAS_TGT[0] - Set fabric ->
tcm_mvsas_tgt_fabric_configfs\n");
+	return 0;
+};
+
+static void tcm_mvsas_tgt_deregister_configfs(void)
+{
+	if (!(tcm_mvsas_tgt_fabric_configfs))
+		return;
+
+	target_fabric_configfs_deregister(tcm_mvsas_tgt_fabric_configfs);
+	tcm_mvsas_tgt_fabric_configfs = NULL;
+	printk(KERN_INFO "TCM_MVSAS_TGT[0] - Cleared
tcm_mvsas_tgt_fabric_configfs\n");
+};
+
+static int __init tcm_mvsas_tgt_init(void)
+{
+	int ret;
+
+	ret = tcm_mvsas_tgt_register_configfs();
+	if (ret < 0)
+		return ret;
+
+	return 0;
+};
+
+static void tcm_mvsas_tgt_exit(void)
+{
+	tcm_mvsas_tgt_deregister_configfs();
+};
+
+#ifdef MODULE
+MODULE_DESCRIPTION("TCM_MVSAS_TGT series fabric driver");
+MODULE_LICENSE("GPL");
+module_init(tcm_mvsas_tgt_init);
+module_exit(tcm_mvsas_tgt_exit);
+#endif
diff --git a/drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.c
b/drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.c
new file mode 100644
index 0000000..36c92cc
--- /dev/null
+++ b/drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.c
@@ -0,0 +1,272 @@
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <asm/unaligned.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/libfc.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_fabric_ops.h>
+#include <target/target_core_fabric_lib.h>
+#include <target/target_core_device.h>
+#include <target/target_core_tpg.h>
+#include <target/target_core_configfs.h>
+#include <tcm_mvsas_tgt_base.h>
+#include <tcm_mvsas_tgt_fabric.h>
+
+int tcm_mvsas_tgt_check_true(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+int tcm_mvsas_tgt_check_false(struct se_portal_group *se_tpg)
+{
+	return 0;
+}
+
+char *tcm_mvsas_tgt_get_fabric_name(void)
+{
+	return "mvsas_tgt";
+}
+
+u8 tcm_mvsas_tgt_get_fabric_proto_ident(struct se_portal_group *se_tpg)
+{
+	struct tcm_mvsas_tgt_tpg *tpg = container_of(se_tpg,
+				struct tcm_mvsas_tgt_tpg, se_tpg);
+	struct tcm_mvsas_tgt_tport *tport = tpg->tport;
+	u8 proto_id;
+
+	switch (tport->tport_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+	default:
+		proto_id = sas_get_fabric_proto_ident(se_tpg);
+		break;
+	}
+
+	return proto_id;
+}
+
+char *tcm_mvsas_tgt_get_fabric_wwn(struct se_portal_group *se_tpg)
+{
+	struct tcm_mvsas_tgt_tpg *tpg = container_of(se_tpg,
+				struct tcm_mvsas_tgt_tpg, se_tpg);
+	struct tcm_mvsas_tgt_tport *tport = tpg->tport;
+
+	return &tport->tport_name[0];
+}
+
+u16 tcm_mvsas_tgt_get_tag(struct se_portal_group *se_tpg)
+{
+	struct tcm_mvsas_tgt_tpg *tpg = container_of(se_tpg,
+				struct tcm_mvsas_tgt_tpg, se_tpg);
+	return tpg->tport_tpgt;
+}
+
+u32 tcm_mvsas_tgt_get_default_depth(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+u32 tcm_mvsas_tgt_get_pr_transport_id(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl,
+	struct t10_pr_registration *pr_reg,
+	int *format_code,
+	unsigned char *buf)
+{
+	struct tcm_mvsas_tgt_tpg *tpg = container_of(se_tpg,
+				struct tcm_mvsas_tgt_tpg, se_tpg);
+	struct tcm_mvsas_tgt_tport *tport = tpg->tport;
+	int ret = 0;
+
+	switch (tport->tport_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+	default:
+		ret = sas_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
+					format_code, buf);
+		break;
+	}
+
+	return ret;
+}
+
+u32 tcm_mvsas_tgt_get_pr_transport_id_len(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl,
+	struct t10_pr_registration *pr_reg,
+	int *format_code)
+{
+	struct tcm_mvsas_tgt_tpg *tpg = container_of(se_tpg,
+				struct tcm_mvsas_tgt_tpg, se_tpg);
+	struct tcm_mvsas_tgt_tport *tport = tpg->tport;
+	int ret = 0;
+
+	switch (tport->tport_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+	default:
+		ret = sas_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
+					format_code);
+		break;
+	}
+
+	return ret;
+}
+
+char *tcm_mvsas_tgt_parse_pr_out_transport_id(
+	struct se_portal_group *se_tpg,
+	const char *buf,
+	u32 *out_tid_len,
+	char **port_nexus_ptr)
+{
+	struct tcm_mvsas_tgt_tpg *tpg = container_of(se_tpg,
+				struct tcm_mvsas_tgt_tpg, se_tpg);
+	struct tcm_mvsas_tgt_tport *tport = tpg->tport;
+	char *tid = NULL;
+
+	switch (tport->tport_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+	default:
+		tid = sas_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
+					port_nexus_ptr);
+	}
+
+	return tid;
+}
+
+struct se_node_acl *tcm_mvsas_tgt_alloc_fabric_acl(struct
se_portal_group *se_tpg)
+{
+	struct tcm_mvsas_tgt_nacl *nacl;
+
+	nacl = kzalloc(sizeof(struct tcm_mvsas_tgt_nacl), GFP_KERNEL);
+	if (!(nacl)) {
+		printk(KERN_ERR "Unable to alocate struct tcm_mvsas_tgt_nacl\n");
+		return NULL;
+	}
+
+	return &nacl->se_node_acl;
+}
+
+void tcm_mvsas_tgt_release_fabric_acl(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl)
+{
+	struct tcm_mvsas_tgt_nacl *nacl = container_of(se_nacl,
+			struct tcm_mvsas_tgt_nacl, se_node_acl);
+	kfree(nacl);
+}
+
+u32 tcm_mvsas_tgt_tpg_get_inst_index(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+void tcm_mvsas_tgt_release_cmd(struct se_cmd *se_cmd)
+{
+	return;
+}
+
+int tcm_mvsas_tgt_shutdown_session(struct se_session *se_sess)
+{
+	return 0;
+}
+
+void tcm_mvsas_tgt_close_session(struct se_session *se_sess)
+{
+	return;
+}
+
+void tcm_mvsas_tgt_stop_session(struct se_session *se_sess, int
sess_sleep , int conn_sleep)
+{
+	return;
+}
+
+void tcm_mvsas_tgt_reset_nexus(struct se_session *se_sess)
+{
+	return;
+}
+
+int tcm_mvsas_tgt_sess_logged_in(struct se_session *se_sess)
+{
+	return 0;
+}
+
+u32 tcm_mvsas_tgt_sess_get_index(struct se_session *se_sess)
+{
+	return 0;
+}
+
+int tcm_mvsas_tgt_write_pending(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+int tcm_mvsas_tgt_write_pending_status(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+void tcm_mvsas_tgt_set_default_node_attrs(struct se_node_acl *nacl)
+{
+	return;
+}
+
+u32 tcm_mvsas_tgt_get_task_tag(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+int tcm_mvsas_tgt_get_cmd_state(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+void tcm_mvsas_tgt_new_cmd_failure(struct se_cmd *se_cmd)
+{
+	return;
+}
+
+int tcm_mvsas_tgt_queue_data_in(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+int tcm_mvsas_tgt_queue_status(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+int tcm_mvsas_tgt_queue_tm_rsp(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+u16 tcm_mvsas_tgt_set_fabric_sense_len(struct se_cmd *se_cmd, u32 sense_length)
+{
+	return 0;
+}
+
+u16 tcm_mvsas_tgt_get_fabric_sense_len(void)
+{
+	return 0;
+}
+
+int tcm_mvsas_tgt_is_state_remove(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+u64 tcm_mvsas_tgt_pack_lun(unsigned int lun)
+{
+	WARN_ON(lun >= 256);
+	/* Caller wants this byte-swapped */
+	return cpu_to_le64((lun & 0xff) << 8);
+}
+
diff --git a/drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.h
b/drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.h
new file mode 100644
index 0000000..fb1a021
--- /dev/null
+++ b/drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.h
@@ -0,0 +1,39 @@
+int tcm_mvsas_tgt_check_true(struct se_portal_group *);
+int tcm_mvsas_tgt_check_false(struct se_portal_group *);
+char *tcm_mvsas_tgt_get_fabric_name(void);
+u8 tcm_mvsas_tgt_get_fabric_proto_ident(struct se_portal_group *);
+char *tcm_mvsas_tgt_get_fabric_wwn(struct se_portal_group *);
+u16 tcm_mvsas_tgt_get_tag(struct se_portal_group *);
+u32 tcm_mvsas_tgt_get_default_depth(struct se_portal_group *);
+u32 tcm_mvsas_tgt_get_pr_transport_id(struct se_portal_group *,
+			struct se_node_acl *, struct t10_pr_registration *,
+			int *, unsigned char *);
+u32 tcm_mvsas_tgt_get_pr_transport_id_len(struct se_portal_group *,
+			struct se_node_acl *, struct t10_pr_registration *,
+			int *);
+char *tcm_mvsas_tgt_parse_pr_out_transport_id(struct se_portal_group *,
+			const char *, u32 *, char **);
+struct se_node_acl *tcm_mvsas_tgt_alloc_fabric_acl(struct se_portal_group *);
+void tcm_mvsas_tgt_release_fabric_acl(struct se_portal_group *,
+			struct se_node_acl *);
+u32 tcm_mvsas_tgt_tpg_get_inst_index(struct se_portal_group *);
+void tcm_mvsas_tgt_release_cmd(struct se_cmd *);
+int tcm_mvsas_tgt_shutdown_session(struct se_session *);
+void tcm_mvsas_tgt_close_session(struct se_session *);
+void tcm_mvsas_tgt_stop_session(struct se_session *, int, int);
+void tcm_mvsas_tgt_reset_nexus(struct se_session *);
+int tcm_mvsas_tgt_sess_logged_in(struct se_session *);
+u32 tcm_mvsas_tgt_sess_get_index(struct se_session *);
+int tcm_mvsas_tgt_write_pending(struct se_cmd *);
+int tcm_mvsas_tgt_write_pending_status(struct se_cmd *);
+void tcm_mvsas_tgt_set_default_node_attrs(struct se_node_acl *);
+u32 tcm_mvsas_tgt_get_task_tag(struct se_cmd *);
+int tcm_mvsas_tgt_get_cmd_state(struct se_cmd *);
+void tcm_mvsas_tgt_new_cmd_failure(struct se_cmd *);
+int tcm_mvsas_tgt_queue_data_in(struct se_cmd *);
+int tcm_mvsas_tgt_queue_status(struct se_cmd *);
+int tcm_mvsas_tgt_queue_tm_rsp(struct se_cmd *);
+u16 tcm_mvsas_tgt_set_fabric_sense_len(struct se_cmd *, u32);
+u16 tcm_mvsas_tgt_get_fabric_sense_len(void);
+int tcm_mvsas_tgt_is_state_remove(struct se_cmd *);
+u64 tcm_mvsas_tgt_pack_lun(unsigned int);
-- 
1.7.1
