Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E181C6FD19
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Mar 2023 18:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjCMSLy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 14:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjCMSLl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 14:11:41 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADCD7B988;
        Mon, 13 Mar 2023 11:11:27 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 5BB64342154;
        Mon, 13 Mar 2023 21:11:24 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=FoBT5SUo0jk3Kx+/BS
        rgxJVCBRkbjo+HZGmpqyoyNHI=; b=ffYzyOEUDFWX9xeGwwZXEkx2L12u6pIVFP
        CTQyXvNjYV8PrLnOHm/t0YJvq+BJ8gzNUPhy4tgBmFYk2a+TJgg3qLjoiMVKgOw3
        I+ZVEoOJ5N3lGi5ylhQQf04I22QC3zuDyio9WPlXDVlsZgXH03//2DOhs+mcBzfV
        pEtLDc/VI=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 52461342145;
        Mon, 13 Mar 2023 21:11:24 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.20.11) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 13 Mar 2023 21:11:23 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Juergen Gross <jgross@suse.com>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [PATCH v3 12/12] target: add virtual remote target
Date:   Mon, 13 Mar 2023 21:11:10 +0300
Message-ID: <20230313181110.20566-13-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230313181110.20566-1-d.bogdanov@yadro.com>
References: <20230313181110.20566-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.20.11]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Create virtual remote target module.
It can be used to see a whole acl/lun/tpg configuration from all nodes
in storage cluster.
For example, it allows to setup remote ports in ALUA port groups. To
report all ports in a cluster in REPORT TARGET PORT GROUP command.

Suggested-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 v3:
    fix identation and spaces
    simplify init function
---
 drivers/target/Kconfig                 |   1 +
 drivers/target/Makefile                |   1 +
 drivers/target/tcm_remote/Kconfig      |   8 +
 drivers/target/tcm_remote/Makefile     |   2 +
 drivers/target/tcm_remote/tcm_remote.c | 268 +++++++++++++++++++++++++
 drivers/target/tcm_remote/tcm_remote.h |  20 ++
 6 files changed, 300 insertions(+)
 create mode 100644 drivers/target/tcm_remote/Kconfig
 create mode 100644 drivers/target/tcm_remote/Makefile
 create mode 100644 drivers/target/tcm_remote/tcm_remote.c
 create mode 100644 drivers/target/tcm_remote/tcm_remote.h

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 72171ea3dd53..92641d39126a 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -47,5 +47,6 @@ source "drivers/target/loopback/Kconfig"
 source "drivers/target/tcm_fc/Kconfig"
 source "drivers/target/iscsi/Kconfig"
 source "drivers/target/sbp/Kconfig"
+source "drivers/target/tcm_remote/Kconfig"
 
 endif
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 45634747377e..431b84abfb94 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_LOOPBACK_TARGET)	+= loopback/
 obj-$(CONFIG_TCM_FC)		+= tcm_fc/
 obj-$(CONFIG_ISCSI_TARGET)	+= iscsi/
 obj-$(CONFIG_SBP_TARGET)	+= sbp/
+obj-$(CONFIG_REMOTE_TARGET)	+= tcm_remote/
diff --git a/drivers/target/tcm_remote/Kconfig b/drivers/target/tcm_remote/Kconfig
new file mode 100644
index 000000000000..e6bebb5fe6f1
--- /dev/null
+++ b/drivers/target/tcm_remote/Kconfig
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config REMOTE_TARGET
+	tristate "TCM Virtual Remote target"
+	depends on SCSI
+	help
+	  Say Y here to enable the TCM Virtual Remote fabric
+	  That fabric is a dummy fabric to tell TCM about configuration
+	  of TPG/ACL/LUN on peer nodes in a cluster.
diff --git a/drivers/target/tcm_remote/Makefile b/drivers/target/tcm_remote/Makefile
new file mode 100644
index 000000000000..5818ffd0b0fa
--- /dev/null
+++ b/drivers/target/tcm_remote/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_REMOTE_TARGET)	+= tcm_remote.o
diff --git a/drivers/target/tcm_remote/tcm_remote.c b/drivers/target/tcm_remote/tcm_remote.c
new file mode 100644
index 000000000000..cb8db2558056
--- /dev/null
+++ b/drivers/target/tcm_remote/tcm_remote.c
@@ -0,0 +1,268 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/configfs.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_fabric.h>
+
+#include "tcm_remote.h"
+
+static inline struct tcm_remote_tpg *remote_tpg(struct se_portal_group *se_tpg)
+{
+	return container_of(se_tpg, struct tcm_remote_tpg, remote_se_tpg);
+}
+
+static char *tcm_remote_get_endpoint_wwn(struct se_portal_group *se_tpg)
+{
+	/*
+	 * Return the passed NAA identifier for the Target Port
+	 */
+	return &remote_tpg(se_tpg)->remote_hba->remote_wwn_address[0];
+}
+
+static u16 tcm_remote_get_tag(struct se_portal_group *se_tpg)
+{
+	/*
+	 * This Tag is used when forming SCSI Name identifier in EVPD=1 0x83
+	 * to represent the SCSI Target Port.
+	 */
+	return remote_tpg(se_tpg)->remote_tpgt;
+}
+
+static int tcm_remote_dummy_cmd_fn(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+static void tcm_remote_dummy_cmd_void_fn(struct se_cmd *se_cmd)
+{
+
+}
+
+static char *tcm_remote_dump_proto_id(struct tcm_remote_hba *remote_hba)
+{
+	switch (remote_hba->remote_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		return "SAS";
+	case SCSI_PROTOCOL_SRP:
+		return "SRP";
+	case SCSI_PROTOCOL_FCP:
+		return "FCP";
+	case SCSI_PROTOCOL_ISCSI:
+		return "iSCSI";
+	default:
+		break;
+	}
+
+	return "Unknown";
+}
+
+static int tcm_remote_port_link(
+	struct se_portal_group *se_tpg,
+	struct se_lun *lun)
+{
+	pr_debug("TCM_Remote_ConfigFS: Port Link LUN %lld Successful\n",
+		 lun->unpacked_lun);
+	return 0;
+}
+
+static void tcm_remote_port_unlink(
+	struct se_portal_group *se_tpg,
+	struct se_lun *lun)
+{
+	pr_debug("TCM_Remote_ConfigFS: Port Unlink LUN %lld Successful\n",
+		 lun->unpacked_lun);
+}
+
+static struct se_portal_group *tcm_remote_make_tpg(
+	struct se_wwn *wwn,
+	const char *name)
+{
+	struct tcm_remote_hba *remote_hba = container_of(wwn,
+			struct tcm_remote_hba, remote_hba_wwn);
+	struct tcm_remote_tpg *remote_tpg;
+	unsigned long tpgt;
+	int ret;
+
+	if (strstr(name, "tpgt_") != name) {
+		pr_err("Unable to locate \"tpgt_#\" directory group\n");
+		return ERR_PTR(-EINVAL);
+	}
+	if (kstrtoul(name + 5, 10, &tpgt))
+		return ERR_PTR(-EINVAL);
+
+	if (tpgt >= TL_TPGS_PER_HBA) {
+		pr_err("Passed tpgt: %lu exceeds TL_TPGS_PER_HBA: %u\n",
+		       tpgt, TL_TPGS_PER_HBA);
+		return ERR_PTR(-EINVAL);
+	}
+	remote_tpg = &remote_hba->remote_hba_tpgs[tpgt];
+	remote_tpg->remote_hba = remote_hba;
+	remote_tpg->remote_tpgt = tpgt;
+	/*
+	 * Register the remote_tpg as a emulated TCM Target Endpoint
+	 */
+	ret = core_tpg_register(wwn, &remote_tpg->remote_se_tpg,
+				remote_hba->remote_proto_id);
+	if (ret < 0)
+		return ERR_PTR(-ENOMEM);
+
+	pr_debug("TCM_Remote_ConfigFS: Allocated Emulated %s Target Port %s,t,0x%04lx\n",
+		 tcm_remote_dump_proto_id(remote_hba),
+		 config_item_name(&wwn->wwn_group.cg_item), tpgt);
+	return &remote_tpg->remote_se_tpg;
+}
+
+static void tcm_remote_drop_tpg(struct se_portal_group *se_tpg)
+{
+	struct se_wwn *wwn = se_tpg->se_tpg_wwn;
+	struct tcm_remote_tpg *remote_tpg = container_of(se_tpg,
+				struct tcm_remote_tpg, remote_se_tpg);
+	struct tcm_remote_hba *remote_hba;
+	unsigned short tpgt;
+
+	remote_hba = remote_tpg->remote_hba;
+	tpgt = remote_tpg->remote_tpgt;
+
+	/*
+	 * Deregister the remote_tpg as a emulated TCM Target Endpoint
+	 */
+	core_tpg_deregister(se_tpg);
+
+	remote_tpg->remote_hba = NULL;
+	remote_tpg->remote_tpgt = 0;
+
+	pr_debug("TCM_Remote_ConfigFS: Deallocated Emulated %s Target Port %s,t,0x%04x\n",
+		 tcm_remote_dump_proto_id(remote_hba),
+		 config_item_name(&wwn->wwn_group.cg_item), tpgt);
+}
+
+static struct se_wwn *tcm_remote_make_wwn(
+	struct target_fabric_configfs *tf,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_remote_hba *remote_hba;
+	char *ptr;
+	int ret, off = 0;
+
+	remote_hba = kzalloc(sizeof(*remote_hba), GFP_KERNEL);
+	if (!remote_hba)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * Determine the emulated Protocol Identifier and Target Port Name
+	 * based on the incoming configfs directory name.
+	 */
+	ptr = strstr(name, "naa.");
+	if (ptr) {
+		remote_hba->remote_proto_id = SCSI_PROTOCOL_SAS;
+		goto check_len;
+	}
+	ptr = strstr(name, "fc.");
+	if (ptr) {
+		remote_hba->remote_proto_id = SCSI_PROTOCOL_FCP;
+		off = 3; /* Skip over "fc." */
+		goto check_len;
+	}
+	ptr = strstr(name, "0x");
+	if (ptr) {
+		remote_hba->remote_proto_id = SCSI_PROTOCOL_SRP;
+		off = 2; /* Skip over "0x" */
+		goto check_len;
+	}
+	ptr = strstr(name, "iqn.");
+	if (!ptr) {
+		pr_err("Unable to locate prefix for emulated Target Port: %s\n",
+		       name);
+		ret = -EINVAL;
+		goto out;
+	}
+	remote_hba->remote_proto_id = SCSI_PROTOCOL_ISCSI;
+
+check_len:
+	if (strlen(name) >= TL_WWN_ADDR_LEN) {
+		pr_err("Emulated NAA %s Address: %s, exceeds max: %d\n",
+		       name, tcm_remote_dump_proto_id(remote_hba), TL_WWN_ADDR_LEN);
+		ret = -EINVAL;
+		goto out;
+	}
+	snprintf(&remote_hba->remote_wwn_address[0], TL_WWN_ADDR_LEN, "%s", &name[off]);
+
+	pr_debug("TCM_Remote_ConfigFS: Allocated emulated Target %s Address: %s\n",
+		 tcm_remote_dump_proto_id(remote_hba), name);
+	return &remote_hba->remote_hba_wwn;
+out:
+	kfree(remote_hba);
+	return ERR_PTR(ret);
+}
+
+static void tcm_remote_drop_wwn(struct se_wwn *wwn)
+{
+	struct tcm_remote_hba *remote_hba = container_of(wwn,
+				struct tcm_remote_hba, remote_hba_wwn);
+
+	pr_debug("TCM_Remote_ConfigFS: Deallocating emulated Target %s Address: %s\n",
+		 tcm_remote_dump_proto_id(remote_hba),
+		 remote_hba->remote_wwn_address);
+	kfree(remote_hba);
+}
+
+static ssize_t tcm_remote_wwn_version_show(struct config_item *item, char *page)
+{
+	return sprintf(page, "TCM Remote Fabric module %s\n", TCM_REMOTE_VERSION);
+}
+
+CONFIGFS_ATTR_RO(tcm_remote_wwn_, version);
+
+static struct configfs_attribute *tcm_remote_wwn_attrs[] = {
+	&tcm_remote_wwn_attr_version,
+	NULL,
+};
+
+static const struct target_core_fabric_ops remote_ops = {
+	.module				= THIS_MODULE,
+	.fabric_name			= "remote",
+	.tpg_get_wwn			= tcm_remote_get_endpoint_wwn,
+	.tpg_get_tag			= tcm_remote_get_tag,
+	.check_stop_free		= tcm_remote_dummy_cmd_fn,
+	.release_cmd			= tcm_remote_dummy_cmd_void_fn,
+	.write_pending			= tcm_remote_dummy_cmd_fn,
+	.queue_data_in			= tcm_remote_dummy_cmd_fn,
+	.queue_status			= tcm_remote_dummy_cmd_fn,
+	.queue_tm_rsp			= tcm_remote_dummy_cmd_void_fn,
+	.aborted_task			= tcm_remote_dummy_cmd_void_fn,
+	.fabric_make_wwn		= tcm_remote_make_wwn,
+	.fabric_drop_wwn		= tcm_remote_drop_wwn,
+	.fabric_make_tpg		= tcm_remote_make_tpg,
+	.fabric_drop_tpg		= tcm_remote_drop_tpg,
+	.fabric_post_link		= tcm_remote_port_link,
+	.fabric_pre_unlink		= tcm_remote_port_unlink,
+	.tfc_wwn_attrs			= tcm_remote_wwn_attrs,
+};
+
+static int __init tcm_remote_fabric_init(void)
+{
+	return target_register_template(&remote_ops);
+}
+
+static void __exit tcm_remote_fabric_exit(void)
+{
+	target_unregister_template(&remote_ops);
+}
+
+MODULE_DESCRIPTION("TCM virtual remote target");
+MODULE_AUTHOR("Dmitry Bogdanov <d.bogdanov@yadro.com>");
+MODULE_LICENSE("GPL");
+module_init(tcm_remote_fabric_init);
+module_exit(tcm_remote_fabric_exit);
diff --git a/drivers/target/tcm_remote/tcm_remote.h b/drivers/target/tcm_remote/tcm_remote.h
new file mode 100644
index 000000000000..913d1a6eb3a2
--- /dev/null
+++ b/drivers/target/tcm_remote/tcm_remote.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/types.h>
+#include <linux/device.h>
+
+#define TCM_REMOTE_VERSION		"v0.1"
+#define TL_WWN_ADDR_LEN			256
+#define TL_TPGS_PER_HBA			32
+
+struct tcm_remote_tpg {
+	unsigned short remote_tpgt;
+	struct se_portal_group remote_se_tpg;
+	struct tcm_remote_hba *remote_hba;
+};
+
+struct tcm_remote_hba {
+	u8 remote_proto_id;
+	unsigned char remote_wwn_address[TL_WWN_ADDR_LEN];
+	struct tcm_remote_tpg remote_hba_tpgs[TL_TPGS_PER_HBA];
+	struct se_wwn remote_hba_wwn;
+};
-- 
2.25.1


