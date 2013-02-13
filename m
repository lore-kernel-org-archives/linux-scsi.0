From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
Date: Wed, 13 Feb 2013 16:06:11 +0100
Message-ID: <1360767971-947-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab3BMPGP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2013 10:06:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Steffen Maier <maier@linux.vnet.ibm.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Krishna Gudipati <kgudipat@brocade.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Abhijeet Joglekar <abjoglek@cisco.com>

shost->max_lun is only ever useful when doing a sequential
scan as we need to limit the number of devices to scan there.
For report lun scan we should allow _any_ reported LUN number
as long as the LLDD supports 64 bit LUNs.

So add a new flag 'support_64bit_luns' to the scsi host and
modify report lun scan to not check for max_luns during
scanning if that flag is set. This will get rid of the
annoying 'lunXXXX has a LUN larger than allowed ...'
message and allow scanning to continue.

Cc: James Bottomley <jbottomley@parallels.com>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: James Smart <james.smart@emulex.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Krishna Gudipati <kgudipat@brocade.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Cc: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 7b31e3f..375d69f 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -316,6 +316,7 @@ static struct scsi_host_template zfcp_scsi_host_template = {
 	.dma_boundary		 = ZFCP_QDIO_SBALE_LEN - 1,
 	.cmd_per_lun		 = 1,
 	.use_clustering		 = 1,
+	.support_64bit_luns	 = 1,
 	.shost_attrs		 = zfcp_sysfs_shost_attrs,
 	.sdev_attrs		 = zfcp_sysfs_sdev_attrs,
 };
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 4e2733d..8ad5e50 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -543,6 +543,7 @@ static struct scsi_host_template beiscsi_sht = {
 	.max_sectors = BEISCSI_MAX_SECTORS,
 	.cmd_per_lun = BEISCSI_CMD_PER_LUN,
 	.use_clustering = ENABLE_CLUSTERING,
+	.support_64bit_luns = 1,
 	.vendor_id = SCSI_NL_VID_TYPE_PCI | BE_VENDOR_ID,
 
 };
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 8f92732..410af66 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -803,6 +803,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 	.sg_tablesize = BFAD_IO_MAX_SGE,
 	.cmd_per_lun = 3,
 	.use_clustering = ENABLE_CLUSTERING,
+	.support_64bit_luns = 1,
 	.shost_attrs = bfad_im_host_attrs,
 	.max_sectors = BFAD_MAX_SECTORS,
 	.vendor_id = BFA_PCI_VENDOR_ID_BROCADE,
@@ -825,6 +826,7 @@ struct scsi_host_template bfad_im_vport_template = {
 	.sg_tablesize = BFAD_IO_MAX_SGE,
 	.cmd_per_lun = 3,
 	.use_clustering = ENABLE_CLUSTERING,
+	.support_64bit_luns = 1,
 	.shost_attrs = bfad_im_vport_attrs,
 	.max_sectors = BFAD_MAX_SECTORS,
 };
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index fbf3ac6..c636cf2 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -102,6 +102,7 @@ static struct scsi_host_template fnic_host_template = {
 	.change_queue_type = fc_change_queue_type,
 	.this_id = -1,
 	.cmd_per_lun = 3,
+	.support_64bit_luns = 1,
 	.can_queue = FNIC_MAX_IO_REQ,
 	.use_clustering = ENABLE_CLUSTERING,
 	.sg_tablesize = FNIC_MAX_SG_DESC_CNT,
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 1d7da3f..39c714c 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6014,6 +6014,7 @@ static struct scsi_host_template driver_template = {
 	.max_sectors = IPR_IOA_MAX_SECTORS,
 	.cmd_per_lun = IPR_MAX_CMD_PER_LUN,
 	.use_clustering = ENABLE_CLUSTERING,
+	.support_64bit_luns = 1,
 	.shost_attrs = ipr_ioa_attrs,
 	.sdev_attrs = ipr_dev_attrs,
 	.proc_name = IPR_NAME
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 60e5a17..d7de766 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5146,6 +5146,7 @@ struct scsi_host_template lpfc_template = {
 	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.support_64bit_luns	= 1,
 	.shost_attrs		= lpfc_hba_attrs,
 	.max_sectors		= 0xFFFF,
 	.vendor_id		= LPFC_NL_VENDOR_ID,
@@ -5169,6 +5170,7 @@ struct scsi_host_template lpfc_vport_template = {
 	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.support_64bit_luns	= 1,
 	.shost_attrs		= lpfc_vport_attrs,
 	.max_sectors		= 0xFFFF,
 	.change_queue_depth	= lpfc_change_queue_depth,
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index ce90d05..09229c4 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -67,6 +67,7 @@ static struct scsi_host_template mvs_sht = {
 	.bios_param		= sas_bios_param,
 	.can_queue		= 1,
 	.cmd_per_lun		= 1,
+	.support_64bit_luns	= 1,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 4c9fe73..39ca498 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -73,6 +73,7 @@ static struct scsi_host_template pm8001_sht = {
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.support_64bit_luns	= 1,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
 	.target_destroy		= sas_target_destroy,
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index b46f5e9..037adbf 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4330,6 +4330,7 @@ static struct scsi_host_template pmcraid_host_template = {
 	.max_sectors = PMCRAID_IOA_MAX_SECTORS,
 	.cmd_per_lun = PMCRAID_MAX_CMD_PER_LUN,
 	.use_clustering = ENABLE_CLUSTERING,
+	.support_64bit_luns = 1,
 	.shost_attrs = pmcraid_host_attrs,
 	.proc_name = PMCRAID_DRIVER_NAME
 };
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 10d23f8..35bab2f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -261,6 +261,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.sg_tablesize		= SG_ALL,
+	.support_64bit_luns	= 1,
 
 	.max_sectors		= 0xFFFF,
 	.shost_attrs		= qla2x00_host_attrs,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 4cec123..c6d9f38 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -190,6 +190,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.sg_tablesize		= SG_ALL,
+	.support_64bit_luns	= 1,
 
 	.max_sectors		= 0xFFFF,
 	.shost_attrs		= qla4xxx_host_attrs,
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..bebaddf 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1468,7 +1468,8 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 			for (i = 0; i < sizeof(struct scsi_lun); i++)
 				printk("%02x", data[i]);
 			printk(" has a LUN larger than currently supported.\n");
-		} else if (lun > sdev->host->max_lun) {
+		} else if (!sdev->host->hostt->support_64bit_luns &&
+			   lun > sdev->host->max_lun) {
 			printk(KERN_WARNING "scsi: %s lun%d has a LUN larger"
 			       " than allowed by the host adapter\n",
 			       devname, lun);
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 3bfaa66..c85d7a0 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -911,6 +911,7 @@ static struct scsi_host_template pvscsi_template = {
 	.dma_boundary			= UINT_MAX,
 	.max_sectors			= 0xffff,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.support_64bit_luns		= 1,
 	.eh_abort_handler		= pvscsi_abort,
 	.eh_device_reset_handler	= pvscsi_device_reset,
 	.eh_bus_reset_handler		= pvscsi_bus_reset,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 4908480..afcf8a7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -474,6 +474,11 @@ struct scsi_host_template {
 	unsigned ordered_tag:1;
 
 	/*
+	 * True if the low-level driver supports 64-bit LUNs
+	 */
+	unsigned support_64bit_luns:1;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
 	unsigned int max_host_blocked;
