From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] megaraid_sas: Enable shared tag map
Date: Mon, 29 Sep 2014 13:47:52 +0200
Message-ID: <1411991272-129962-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaI2Lr4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:47:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@avagotech.com>, Hannes Reinecke <hare@suse.de>

Megaraid_sas uses a shared pool of commands per HBA, so we
should be enabling a shared tag map.
This will allow the I/O scheduler to make better scheduling
decisions and will avoid BUSY states in the driver.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 34 ++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f6a69a3..996fa9a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1659,7 +1659,7 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 	*/
 	blk_queue_rq_timeout(sdev->request_queue,
 		MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
-
+	sdev->tagged_supported = 1;
 	return 0;
 }
 
@@ -1667,6 +1667,10 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 {
 	u16             pd_index = 0;
 	struct megasas_instance *instance ;
+
+	/* We have a shared tag map, so TCQ is always supported */
+	sdev->tagged_supported = 1;
+
 	instance = megasas_lookup_instance(sdev->host->host_no);
 	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
 		/*
@@ -1677,13 +1681,20 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 			sdev->id;
 		if (instance->pd_list[pd_index].driveState ==
 					MR_PD_STATE_SYSTEM) {
+			scsi_activate_tcq(sdev, MEGASAS_DEFAULT_CMD_PER_LUN);
 			return 0;
 		}
 		return -ENXIO;
 	}
+	scsi_activate_tcq(sdev, MEGASAS_DEFAULT_CMD_PER_LUN);
 	return 0;
 }
 
+static void megasas_slave_destroy(struct scsi_device *sdev)
+{
+	scsi_deactivate_tcq(sdev, 1);
+}
+
 void megaraid_sas_kill_hba(struct megasas_instance *instance)
 {
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
@@ -2746,6 +2757,21 @@ struct device_attribute *megaraid_host_attrs[] = {
 	NULL,
 };
 
+static int megasas_change_queue_type(struct scsi_device *sdev, int tag_type)
+{
+	if (sdev->host->bqt && sdev->tagged_supported) {
+		scsi_set_tag_type(sdev, tag_type);
+
+		if (tag_type)
+			scsi_activate_tcq(sdev, sdev->queue_depth);
+		else
+			scsi_deactivate_tcq(sdev, sdev->queue_depth);
+	} else
+		tag_type = 0;
+
+	return tag_type;
+}
+
 /*
  * Scsi host template for megaraid_sas driver
  */
@@ -2756,6 +2782,7 @@ static struct scsi_host_template megasas_template = {
 	.proc_name = "megaraid_sas",
 	.slave_configure = megasas_slave_configure,
 	.slave_alloc = megasas_slave_alloc,
+	.slave_destroy = megasas_slave_destroy,
 	.queuecommand = megasas_queue_command,
 	.eh_device_reset_handler = megasas_reset_device,
 	.eh_bus_reset_handler = megasas_reset_bus_host,
@@ -2765,6 +2792,7 @@ static struct scsi_host_template megasas_template = {
 	.bios_param = megasas_bios_param,
 	.use_clustering = ENABLE_CLUSTERING,
 	.change_queue_depth = megasas_change_queue_depth,
+	.change_queue_type = megasas_change_queue_type,
 	.no_write_same = 1,
 };
 
@@ -4909,6 +4937,10 @@ static int megasas_io_attach(struct megasas_instance *instance)
 	host->this_id = instance->init_id;
 	host->sg_tablesize = instance->max_num_sge;
 
+	if (!scsi_init_shared_tag_map(host, host->can_queue))
+		printk(KERN_WARNING "megasas: enable TCQ support, depth %d",
+			host->can_queue);
+
 	if (instance->fw_support_ieee)
 		instance->max_sectors_per_req = MEGASAS_MAX_SECTORS_IEEE;
 
-- 
1.8.5.2

