From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] SCSI: Disable WRITE SAME for RAID and virtual host adapter drivers
Date: Wed, 23 Oct 2013 06:25:40 -0400
Message-ID: <yq1eh7cffmj.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43029 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3JWKZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2013 06:25:44 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r9NAPhtv006988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2013 10:25:43 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9NAPgCi029711
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2013 10:25:42 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9NAPgfD024322
	for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2013 10:25:42 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Some host adapters do not pass commands through to the target disk
directly. Instead they provide an emulated target which may or may not
accurately report its capabilities. In some cases the physical device
characteristics are reported even when the host adapter is processing
commands on the device's behalf. This can lead to adapter firmware hangs
or excessive I/O errors.

This patch disables WRITE SAME for devices connected to host adapters
that provide an emulated target. Driver writers can disable WRITE SAME
by setting the no_write_same flag in the host adapter template.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
I was torn between using the existing "emulated" flag or introducing a
new one. I ended up doing the latter but I'm also OK with setting
emulated for drivers that don't already and keying off of that. Comments
welcome...

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 97a0cef..5a6fe61 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3625,6 +3625,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		shost->max_lun = 1;
 		shost->max_channel = 1;
 		shost->max_cmd_len = 16;
+		shost->no_write_same = 1;
 
 		/* Schedule policy is determined by ->qc_defer()
 		 * callback and it needs to see every deferred qc.
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 281029d..b0bb056 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1623,6 +1623,7 @@ static struct scsi_host_template scsi_driver_template = {
 	.cmd_per_lun		= 1,
 	.can_queue		= 1,
 	.sdev_attrs		= sbp2_scsi_sysfs_attrs,
+	.no_write_same		= 1,
 };
 
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 5e1e12c..0a73253 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2025,7 +2025,8 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= twa_host_attrs,
-	.emulated		= 1
+	.emulated		= 1,
+	.no_write_same		= 1,
 };
 
 /* This function will probe and initialize a card */
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index c845bdb..4de3460 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1600,7 +1600,8 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= twl_host_attrs,
-	.emulated		= 1
+	.emulated		= 1,
+	.no_write_same		= 1,
 };
 
 /* This function will probe and initialize a card */
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index b9276d1..752624e 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2279,7 +2279,8 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,	
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= tw_host_attrs,
-	.emulated		= 1
+	.emulated		= 1,
+	.no_write_same		= 1,
 };
 
 /* This function will probe and initialize a card */
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 408a42e..15826a7 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1079,6 +1079,7 @@ static struct scsi_host_template aac_driver_template = {
 #endif
 	.use_clustering			= ENABLE_CLUSTERING,
 	.emulated			= 1,
+	.no_write_same			= 1,
 };
 
 static void __aac_shutdown(struct aac_dev * aac)
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 33c52bc..278c9fa 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -137,6 +137,7 @@ static struct scsi_host_template arcmsr_scsi_host_template = {
 	.cmd_per_lun		= ARCMSR_MAX_CMD_PERLUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= arcmsr_host_attrs,
+	.no_write_same		= 1,
 };
 static struct pci_device_id arcmsr_device_id_table[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1110)},
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 6d55b4e..aec3d4d 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4686,6 +4686,7 @@ static struct scsi_host_template gdth_template = {
         .cmd_per_lun            = GDTH_MAXC_P_L,
         .unchecked_isa_dma      = 1,
         .use_clustering         = ENABLE_CLUSTERING,
+	.no_write_same		= 1,
 };
 
 #ifdef CONFIG_ISA
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index df0c3c7..3cafe0d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -388,6 +388,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
+	shost->no_write_same = sht->no_write_same;
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index fb5a898..c11a1eae 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -561,6 +561,7 @@ static struct scsi_host_template hpsa_driver_template = {
 	.sdev_attrs = hpsa_sdev_attrs,
 	.shost_attrs = hpsa_shost_attrs,
 	.max_sectors = 8192,
+	.no_write_same = 1,
 };
 
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 36ac1c3..573f412 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6305,7 +6305,8 @@ static struct scsi_host_template driver_template = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = ipr_ioa_attrs,
 	.sdev_attrs = ipr_dev_attrs,
-	.proc_name = IPR_NAME
+	.proc_name = IPR_NAME,
+	.no_write_same = 1,
 };
 
 /**
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 8d5ea8a..52a216f 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -374,6 +374,7 @@ static struct scsi_host_template ips_driver_template = {
 	.sg_tablesize		= IPS_MAX_SG,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.no_write_same		= 1,
 };
 
 
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 90c95a3..816db12 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4244,6 +4244,7 @@ static struct scsi_host_template megaraid_template = {
 	.eh_device_reset_handler	= megaraid_reset,
 	.eh_bus_reset_handler		= megaraid_reset,
 	.eh_host_reset_handler		= megaraid_reset,
+	.no_write_same			= 1,
 };
 
 static int
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 515c962..8844d5c 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -367,6 +367,7 @@ static struct scsi_host_template megaraid_template_g = {
 	.eh_host_reset_handler		= megaraid_reset_handler,
 	.change_queue_depth		= megaraid_change_queue_depth,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.no_write_same			= 1,
 	.sdev_attrs			= megaraid_sdev_attrs,
 	.shost_attrs			= megaraid_shost_attrs,
 };
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e62ff02..731aa0f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2148,6 +2148,7 @@ static struct scsi_host_template megasas_template = {
 	.bios_param = megasas_bios_param,
 	.use_clustering = ENABLE_CLUSTERING,
 	.change_queue_depth = megasas_change_queue_depth,
+	.no_write_same = 1,
 };
 
 /**
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 1eb7b028..a38f71b 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4314,6 +4314,7 @@ static struct scsi_host_template pmcraid_host_template = {
 	.this_id = -1,
 	.sg_tablesize = PMCRAID_MAX_IOADLS,
 	.max_sectors = PMCRAID_IOA_MAX_SECTORS,
+	.no_write_same = 1,
 	.cmd_per_lun = PMCRAID_MAX_CMD_PER_LUN,
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = pmcraid_host_attrs,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fd874b8..27984e6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2659,6 +2659,12 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	struct scsi_device *sdev = sdkp->device;
 
+	if (sdev->host->no_write_same) {
+		sdev->no_write_same = 1;
+
+		return;
+	}
+
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
 		/* too large values might cause issues with arcmsr */
 		int vpd_buf_len = 64;
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 1a28f56..17d7404 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1697,6 +1697,7 @@ static struct scsi_host_template scsi_driver = {
 	.use_clustering =	DISABLE_CLUSTERING,
 	/* Make sure we dont get a sg segment crosses a page boundary */
 	.dma_boundary =		PAGE_SIZE-1,
+	.no_write_same =	1,
 };
 
 enum {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7552435..50769a7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -475,6 +475,9 @@ struct scsi_host_template {
 	 */
 	unsigned ordered_tag:1;
 
+	/* True if the controller does not support WRITE SAME */
+	unsigned no_write_same:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
@@ -674,6 +677,9 @@ struct Scsi_Host {
 	/* Don't resume host in EH */
 	unsigned eh_noresume:1;
 
+	/* The controller does not support WRITE SAME */
+	unsigned no_write_same:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
