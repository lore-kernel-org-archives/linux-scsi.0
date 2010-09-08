From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 07/12] zfcp: Allow midlayer to scan for LUNs when running in NPIV mode
Date: Wed, 08 Sep 2010 14:39:56 +0200
Message-ID: <20100908124353.598418946@de.ibm.com>
References: <20100908123949.483410445@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.17.167]:33339 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729Ab0IHMn5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 08:43:57 -0400
Content-Disposition: inline; filename=706-zfcp-lun-scan.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Enable the LUN scanning mechanism in the SCSI midlayer:
- Do not set the disable_target_scan bit in the FC transport class.
- Set max_lun to 0xFFFFFFFF to allow the midlayer scan to include
  the two-level hierachical LUNs (like 0x40XX40XX00000000, but in SCSI
  midlayer LUN format).
- Set max_id to a high value to allow triggering the SCSI device
  rescan from sysfs.

When running in NPIV mode, zfcp accepts all LUNs in slave_attach. When
running in non-NPIV mode, the list of zfcp_unit structs determines
which SCSI devices are allowed on the current system.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_scsi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2010-09-08 08:49:29.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2010-09-08 08:49:29.000000000 +0200
@@ -143,7 +143,8 @@ static int zfcp_scsi_slave_alloc(struct
 	unit = zfcp_unit_find(port, zfcp_scsi_dev_lun(sdev));
 	if (unit)
 		put_device(&unit->dev);
-	else {
+
+	if (!unit && !(adapter->connection_features & FSF_FEATURE_NPIV_MODE)) {
 		put_device(&port->dev);
 		return -ENXIO;
 	}
@@ -309,8 +310,8 @@ int zfcp_adapter_scsi_register(struct zf
 	}
 
 	/* tell the SCSI stack some characteristics of this adapter */
-	adapter->scsi_host->max_id = 1;
-	adapter->scsi_host->max_lun = 1;
+	adapter->scsi_host->max_id = 511;
+	adapter->scsi_host->max_lun = 0xFFFFFFFF;
 	adapter->scsi_host->max_channel = 0;
 	adapter->scsi_host->unique_id = dev_id.devno;
 	adapter->scsi_host->max_cmd_len = 16; /* in struct fcp_cmnd */
@@ -687,7 +688,6 @@ struct fc_function_template zfcp_transpo
 	.show_host_port_type = 1,
 	.show_host_speed = 1,
 	.show_host_port_id = 1,
-	.disable_target_scan = 1,
 	.dd_bsg_size = sizeof(struct zfcp_fsf_ct_els),
 };
 

