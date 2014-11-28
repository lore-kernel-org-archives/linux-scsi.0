From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 14/16] target/pscsi: Convert to external pscsi_backend_dev_attrs
Date: Fri, 28 Nov 2014 09:06:40 +0000
Message-ID: <1417165602-32359-15-git-send-email-nab@daterainc.com>
References: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:59970 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaK1Jhy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Nov 2014 04:37:54 -0500
Received: by mail-ob0-f176.google.com with SMTP id vb8so4779817obc.21
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2014 01:37:53 -0800 (PST)
In-Reply-To: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Jerome Martin <tramjoe.merin@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts PSCSI to use an external set of device attributes,
and utilizes target_core_backend_configfs.h macros to generate a default
set of configfs extended-attr handlers.

It calls target_core_setup_sub_cits() to setup the initial config_item_type
based on existing target_core_configfs.c defaults, and using configfs_attribute
for hw_pi_prot_type, hw_block_size, hw_max_sectors, hw_queue_depth populates
pscsi_backend_dev_attrs[]

Only these four hw_* read-only device attributes are exports for PSCSI.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 7c8291f..74873e4 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -44,6 +44,7 @@
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
+#include <target/target_core_backend_configfs.h>
 
 #include "target_core_alua.h"
 #include "target_core_pscsi.h"
@@ -1165,6 +1166,26 @@ static void pscsi_req_done(struct request *req, int uptodate)
 	kfree(pt);
 }
 
+DEF_TB_DEV_ATTRIB_RO(pscsi, hw_pi_prot_type);
+TB_DEV_ATTR_RO(pscsi, hw_pi_prot_type);
+
+DEF_TB_DEV_ATTRIB_RO(pscsi, hw_block_size);
+TB_DEV_ATTR_RO(pscsi, hw_block_size);
+
+DEF_TB_DEV_ATTRIB_RO(pscsi, hw_max_sectors);
+TB_DEV_ATTR_RO(pscsi, hw_max_sectors);
+
+DEF_TB_DEV_ATTRIB_RO(pscsi, hw_queue_depth);
+TB_DEV_ATTR_RO(pscsi, hw_queue_depth);
+
+static struct configfs_attribute *pscsi_backend_dev_attrs[] = {
+	&pscsi_dev_attrib_hw_pi_prot_type.attr,
+	&pscsi_dev_attrib_hw_block_size.attr,
+	&pscsi_dev_attrib_hw_max_sectors.attr,
+	&pscsi_dev_attrib_hw_queue_depth.attr,
+	NULL,
+};
+
 static struct se_subsystem_api pscsi_template = {
 	.name			= "pscsi",
 	.owner			= THIS_MODULE,
@@ -1185,6 +1206,11 @@ static struct se_subsystem_api pscsi_template = {
 
 static int __init pscsi_module_init(void)
 {
+	struct target_backend_cits *tbc = &pscsi_template.tb_cits;
+
+	target_core_setup_sub_cits(&pscsi_template);
+	tbc->tb_dev_attrib_cit.ct_attrs = pscsi_backend_dev_attrs;
+
 	return transport_subsystem_register(&pscsi_template);
 }
 
-- 
1.9.1

