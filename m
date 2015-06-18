From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/8] tcm_loop: Hook into SAS transport class
Date: Thu, 18 Jun 2015 11:43:35 +0200
Message-ID: <1434620622-65391-2-git-send-email-hare@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbbFRJnp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2015 05:43:45 -0400
In-Reply-To: <1434620622-65391-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

If tcm_loop emulates a SAS HBA it should hook into the SAS
transport class, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/loopback/tcm_loop.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index a556bde..45ae3e4 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -31,6 +31,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_transport_sas.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
@@ -42,7 +43,7 @@
 
 static struct workqueue_struct *tcm_loop_workqueue;
 static struct kmem_cache *tcm_loop_cmd_cache;
-
+static struct scsi_transport_template *tcm_loop_sas_transport_template;
 static int tcm_loop_hba_no_cnt;
 
 static int tcm_loop_queue_status(struct se_cmd *se_cmd);
@@ -360,6 +361,9 @@ static int tcm_loop_slave_alloc(struct scsi_device *sd)
 	return 0;
 }
 
+struct sas_function_template tcm_loop_sas_transport_functions = {
+};
+
 static struct scsi_host_template tcm_loop_driver_template = {
 	.show_info		= tcm_loop_show_info,
 	.proc_name		= "tcm_loopback",
@@ -408,6 +412,8 @@ static int tcm_loop_driver_probe(struct device *dev)
 	sh->max_lun = 0;
 	sh->max_channel = 0;
 	sh->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
+	if (tl_hba->tl_proto_id == SCSI_PROTOCOL_SAS)
+		sh->transportt = tcm_loop_sas_transport_template;
 
 	host_prot = SHOST_DIF_TYPE1_PROTECTION | SHOST_DIF_TYPE2_PROTECTION |
 		    SHOST_DIF_TYPE3_PROTECTION | SHOST_DIX_TYPE1_PROTECTION |
@@ -1290,8 +1296,15 @@ static int __init tcm_loop_fabric_init(void)
 	if (ret)
 		goto out_release_core_bus;
 
+	tcm_loop_sas_transport_template =
+		sas_attach_transport(&tcm_loop_sas_transport_functions);
+	if (!tcm_loop_sas_transport_template)
+		goto out_unregister_template;
+
 	return 0;
 
+out_unregister_template:
+	target_unregister_template(&loop_ops);
 out_release_core_bus:
 	tcm_loop_release_core_bus();
 out_destroy_cache:
@@ -1304,6 +1317,7 @@ out:
 
 static void __exit tcm_loop_fabric_exit(void)
 {
+	sas_release_transport(tcm_loop_sas_transport_template);
 	target_unregister_template(&loop_ops);
 	tcm_loop_release_core_bus();
 	kmem_cache_destroy(tcm_loop_cmd_cache);
-- 
1.8.5.2

