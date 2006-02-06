From: brking@us.ibm.com
Subject: [patch 15/15] ipr: Support attaching SATA devices
Date: Mon, 06 Feb 2006 09:42:33 -0600
Message-ID: <200602061542.k16FgdNU025771@d03av04.boulder.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Adds support to attach SATA devices to ipr SAS adapters.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/Kconfig  |    1 
 drivers/scsi/Makefile |    2 
 drivers/scsi/ipr.c    |  610 +++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ipr.h    |   88 ++++++-
 4 files changed, 665 insertions(+), 36 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_sata_with_libata_changes drivers/scsi/ipr.h
--- libata-dev/drivers/scsi/ipr.h~ipr_sata_with_libata_changes	2006-02-06 09:15:44.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/ipr.h	2006-02-06 09:16:38.000000000 -0600
@@ -36,8 +36,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.1.1"
-#define IPR_DRIVER_DATE "(November 15, 2005)"
+#define IPR_DRIVER_VERSION "2.2.0"
+#define IPR_DRIVER_DATE "(February 6, 2005)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
@@ -45,6 +45,7 @@
  *	This can be adjusted at runtime through sysfs device attributes.
  */
 #define IPR_MAX_CMD_PER_LUN				6
+#define IPR_MAX_CMD_PER_ATA_LUN			1
 
 /*
  * IPR_NUM_BASE_CMD_BLKS: This defines the maximum number of
@@ -145,6 +146,7 @@
 #define	IPR_LUN_RESET					0x40
 #define	IPR_TARGET_RESET					0x20
 #define	IPR_BUS_RESET					0x10
+#define	IPR_ATA_PHY_RESET					0x80
 #define IPR_ID_HOST_RR_Q				0xC4
 #define IPR_QUERY_IOA_CONFIG				0xC5
 #define IPR_CANCEL_ALL_REQUESTS			0xCE
@@ -295,7 +297,11 @@ struct ipr_std_inq_data {
 }__attribute__ ((packed));
 
 struct ipr_config_table_entry {
-	u8 service_level;
+	u8 proto;
+#define IPR_PROTO_SATA			0x02
+#define IPR_PROTO_SATA_ATAPI		0x03
+#define IPR_PROTO_SAS_STP		0x06
+#define IPR_PROTO_SAS_STP_ATAPI	0x07
 	u8 array_id;
 	u8 flags;
 #define IPR_IS_IOA_RESOURCE	0x80
@@ -307,6 +313,7 @@ struct ipr_config_table_entry {
 #define IPR_SUBTYPE_AF_DASD			0
 #define IPR_SUBTYPE_GENERIC_SCSI	1
 #define IPR_SUBTYPE_VOLUME_SET		2
+#define IPR_SUBTYPE_GENERIC_ATA	4
 
 #define IPR_QUEUEING_MODEL(res)	((((res)->cfgte.flags) & 0x70) >> 4)
 #define IPR_QUEUE_FROZEN_MODEL	0
@@ -350,6 +357,7 @@ struct ipr_cmd_pkt {
 #define IPR_RQTYPE_SCSICDB		0x00
 #define IPR_RQTYPE_IOACMD		0x01
 #define IPR_RQTYPE_HCAM			0x02
+#define IPR_RQTYPE_ATA_PASSTHRU	0x04
 
 	u8 luntar_luntrn;
 
@@ -373,6 +381,37 @@ struct ipr_cmd_pkt {
 	__be16 timeout;
 }__attribute__ ((packed, aligned(4)));
 
+struct ipr_ioarcb_ata_regs {
+	u8 flags;
+#define IPR_ATA_FLAG_PACKET_CMD			0x80
+#define IPR_ATA_FLAG_XFER_TYPE_DMA			0x40
+#define IPR_ATA_FLAG_STATUS_ON_GOOD_COMPLETION	0x20
+	u8 reserved[3];
+
+	__be16 data;
+	u8 feature;
+	u8 nsect;
+	u8 lbal;
+	u8 lbam;
+	u8 lbah;
+	u8 device;
+	u8 command;
+	u8 reserved2[3];
+	u8 hob_feature;
+	u8 hob_nsect;
+	u8 hob_lbal;
+	u8 hob_lbam;
+	u8 hob_lbah;
+	u8 ctl;
+}__attribute__ ((packed, aligned(4)));
+
+struct ipr_ioarcb_add_data {
+	union {
+		struct ipr_ioarcb_ata_regs regs;
+		__be32 add_cmd_parms[10];
+	}u;
+}__attribute__ ((packed, aligned(4)));
+
 /* IOA Request Control Block    128 bytes  */
 struct ipr_ioarcb {
 	__be32 ioarcb_host_pci_addr;
@@ -397,7 +436,7 @@ struct ipr_ioarcb {
 	struct ipr_cmd_pkt cmd_pkt;
 
 	__be32 add_cmd_parms_len;
-	__be32 add_cmd_parms[10];
+	struct ipr_ioarcb_add_data add_data;
 }__attribute__((packed, aligned (4)));
 
 struct ipr_ioadl_desc {
@@ -433,6 +472,21 @@ struct ipr_ioasa_gpdd {
 	__be32 ioa_data[2];
 }__attribute__((packed, aligned (4)));
 
+struct ipr_ioasa_gata {
+	u8 error;
+	u8 nsect;		/* Interrupt reason */
+	u8 lbal;
+	u8 lbam;
+	u8 lbah;
+	u8 device;
+	u8 status;
+	u8 alt_status;	/* ATA CTL */
+	u8 hob_nsect;
+	u8 hob_lbal;
+	u8 hob_lbam;
+	u8 hob_lbah;
+}__attribute__((packed, aligned (4)));
+
 struct ipr_auto_sense {
 	__be16 auto_sense_len;
 	__be16 ioa_data_len;
@@ -474,6 +528,7 @@ struct ipr_ioasa {
 		struct ipr_ioasa_vset vset;
 		struct ipr_ioasa_af_dasd dasd;
 		struct ipr_ioasa_gpdd gpdd;
+		struct ipr_ioasa_gata gata;
 	} u;
 
 	struct ipr_auto_sense auto_sense;
@@ -793,6 +848,13 @@ struct ipr_bus_attributes {
 	u32 max_xfer_rate;
 };
 
+struct ipr_sata_port {
+	struct ipr_ioa_cfg *ioa_cfg;
+	struct ata_port *ap;
+	struct ipr_resource_entry *res;
+	struct ipr_ioasa_gata ioasa;
+};
+
 struct ipr_resource_entry {
 	struct ipr_config_table_entry cfgte;
 	u8 needs_sync_complete:1;
@@ -802,6 +864,7 @@ struct ipr_resource_entry {
 	u8 resetting_device:1;
 
 	struct scsi_device *sdev;
+	struct ipr_sata_port *sata_port;
 	struct list_head queue;
 };
 
@@ -1030,6 +1093,7 @@ struct ipr_cmnd {
 	struct ipr_ioadl_desc ioadl[IPR_NUM_IOADL_ENTRIES];
 	struct list_head queue;
 	struct scsi_cmnd *scsi_cmd;
+	struct ata_queued_cmd *qc;
 	struct completion completion;
 	struct timer_list timer;
 	void (*done) (struct ipr_cmnd *);
@@ -1309,6 +1373,22 @@ static inline int ipr_is_scsi_disk(struc
 }
 
 /**
+ * ipr_is_gata - Determine if a resource is a generic ATA resource
+ * @res:	resource entry struct
+ *
+ * Return value:
+ * 	1 if GATA / 0 if not GATA
+ **/
+static inline int ipr_is_gata(struct ipr_resource_entry *res)
+{
+	if (!ipr_is_ioa_resource(res) &&
+	    IPR_RES_SUBTYPE(res) == IPR_SUBTYPE_GENERIC_ATA)
+		return 1;
+	else
+		return 0;
+}
+
+/**
  * ipr_is_naca_model - Determine if a resource is using NACA queueing model
  * @res:	resource entry struct
  *
diff -puN drivers/scsi/ipr.c~ipr_sata_with_libata_changes drivers/scsi/ipr.c
--- libata-dev/drivers/scsi/ipr.c~ipr_sata_with_libata_changes	2006-02-06 09:15:44.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/ipr.c	2006-02-06 09:15:44.000000000 -0600
@@ -71,6 +71,7 @@
 #include <linux/firmware.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/libata.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/processor.h>
@@ -454,8 +455,10 @@ static void ipr_reinit_ipr_cmnd(struct i
 	ioarcb->read_ioadl_len = 0;
 	ioasa->ioasc = 0;
 	ioasa->residual_data_len = 0;
+	ioasa->u.gata.status = 0;
 
 	ipr_cmd->scsi_cmd = NULL;
+	ipr_cmd->qc = NULL;
 	ipr_cmd->sense_buffer[0] = 0;
 	ipr_cmd->dma_use_sg = 0;
 }
@@ -799,6 +802,7 @@ static void ipr_init_res_entry(struct ip
 	res->del_from_ml = 0;
 	res->resetting_device = 0;
 	res->sdev = NULL;
+	res->sata_port = NULL;
 }
 
 /**
@@ -3025,6 +3029,17 @@ static int ipr_free_dump(struct ipr_ioa_
  **/
 static int ipr_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
+	struct ipr_resource_entry *res;
+	unsigned long lock_flags = 0;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	res = (struct ipr_resource_entry *)sdev->hostdata;
+
+	if (res && ipr_is_gata(res) && qdepth > IPR_MAX_CMD_PER_ATA_LUN)
+		qdepth = IPR_MAX_CMD_PER_ATA_LUN;
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+
 	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
 	return sdev->queue_depth;
 }
@@ -3140,6 +3155,128 @@ static int ipr_biosparam(struct scsi_dev
 }
 
 /**
+ * ipr_find_starget - Find target based on bus/target.
+ * @starget:	scsi target struct
+ *
+ * Return value:
+ * 	resource entry pointer if found / NULL if not found
+ **/
+static struct ipr_resource_entry *ipr_find_starget(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
+	struct ipr_resource_entry *res;
+
+	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
+		if ((res->cfgte.res_addr.bus == starget->channel) &&
+		    (res->cfgte.res_addr.target == starget->id) &&
+		    (res->cfgte.res_addr.lun == 0)) {
+			return res;
+		}
+	}
+
+	return NULL;
+}
+
+static struct ata_port_info sata_port_info;
+
+/**
+ * ipr_target_alloc - Prepare for commands to a SCSI target
+ * @starget:	scsi target struct
+ *
+ * If the device is a SATA device, this function allocates an
+ * ATA port with libata, else it does nothing.
+ *
+ * Return value:
+ * 	0 on success / non-0 on failure
+ **/
+static int ipr_target_alloc(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
+	struct ipr_sata_port *sata_port;
+	struct ata_port *ap;
+	struct ipr_resource_entry *res;
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	res = ipr_find_starget(starget);
+	starget->hostdata = NULL;
+
+	if (res && ipr_is_gata(res)) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		sata_port = kzalloc(sizeof(*sata_port), GFP_KERNEL);
+		if (!sata_port)
+			return -ENOMEM;
+
+		ap = ata_sas_port_alloc(ioa_cfg->pdev, &sata_port_info, shost);
+		if (ap) {
+			spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+			sata_port->ioa_cfg = ioa_cfg;
+			sata_port->ap = ap;
+			sata_port->res = res;
+
+			res->sata_port = sata_port;
+			ap->private_data = sata_port;
+			starget->hostdata = sata_port;
+		} else {
+			kfree(sata_port);
+			return -ENOMEM;
+		}
+	}
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+
+	return 0;
+}
+
+/**
+ * ipr_target_destroy - Destroy a SCSI target
+ * @starget:	scsi target struct
+ *
+ * If the device was a SATA device, this function frees the libata
+ * ATA port, else it does nothing.
+ *
+ **/
+static void ipr_target_destroy(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
+	struct ipr_sata_port *sata_port;
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	if (starget->hostdata) {
+		sata_port = starget->hostdata;
+		starget->hostdata = NULL;
+		ata_sas_port_destroy(sata_port->ap);
+		kfree(sata_port);
+	}
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+}
+
+/**
+ * ipr_find_sdev - Find device based on bus/target/lun.
+ * @sdev:	scsi device struct
+ *
+ * Return value:
+ * 	resource entry pointer if found / NULL if not found
+ **/
+static struct ipr_resource_entry *ipr_find_sdev(struct scsi_device *sdev)
+{
+	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) sdev->host->hostdata;
+	struct ipr_resource_entry *res;
+
+	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
+		if ((res->cfgte.res_addr.bus == sdev->channel) &&
+		    (res->cfgte.res_addr.target == sdev->id) &&
+		    (res->cfgte.res_addr.lun == sdev->lun))
+			return res;
+	}
+
+	return NULL;
+}
+
+/**
  * ipr_slave_destroy - Unconfigure a SCSI device
  * @sdev:	scsi device struct
  *
@@ -3157,8 +3294,11 @@ static void ipr_slave_destroy(struct scs
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *) sdev->hostdata;
 	if (res) {
+		if (res->sata_port)
+			ata_port_disable(res->sata_port->ap);
 		sdev->hostdata = NULL;
 		res->sdev = NULL;
+		res->sata_port = NULL;
 	}
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 }
@@ -3193,13 +3333,45 @@ static int ipr_slave_configure(struct sc
 		}
 		if (ipr_is_scsi_disk(res))
 			sdev->allow_restart = 1;
-		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
+		if (ipr_is_gata(res)) {
+			scsi_adjust_queue_depth(sdev, 0, IPR_MAX_CMD_PER_ATA_LUN);
+			ata_sas_slave_configure(sdev, res->sata_port->ap);
+		} else {
+			scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
+		}
 	}
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	return 0;
 }
 
 /**
+ * ipr_ata_slave_alloc - Prepare for commands to a SATA device
+ * @sdev:	scsi device struct
+ *
+ * This function initializes an ATA port so that future commands
+ * sent through queuecommand will work.
+ *
+ * Return value:
+ * 	0 on success
+ **/
+static int ipr_ata_slave_alloc(struct scsi_device *sdev)
+{
+	struct ipr_sata_port *sata_port = NULL;
+	int rc = -ENXIO;
+
+	ENTER;
+	if (sdev->sdev_target)
+		sata_port = sdev->sdev_target->hostdata;
+	if (sata_port)
+		rc = ata_sas_port_init(sata_port->ap);
+	if (rc)
+		ipr_slave_destroy(sdev);
+
+	LEAVE;
+	return rc;
+}
+
+/**
  * ipr_slave_alloc - Prepare for commands to a device.
  * @sdev:	scsi device struct
  *
@@ -3222,18 +3394,18 @@ static int ipr_slave_alloc(struct scsi_d
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
-	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
-		if ((res->cfgte.res_addr.bus == sdev->channel) &&
-		    (res->cfgte.res_addr.target == sdev->id) &&
-		    (res->cfgte.res_addr.lun == sdev->lun)) {
-			res->sdev = sdev;
-			res->add_to_ml = 0;
-			res->in_erp = 0;
-			sdev->hostdata = res;
-			if (!ipr_is_naca_model(res))
-				res->needs_sync_complete = 1;
-			rc = 0;
-			break;
+	res = ipr_find_sdev(sdev);
+	if (res) {
+		res->sdev = sdev;
+		res->add_to_ml = 0;
+		res->in_erp = 0;
+		sdev->hostdata = res;
+		if (!ipr_is_naca_model(res))
+			res->needs_sync_complete = 1;
+		rc = 0;
+		if (ipr_is_gata(res)) {
+			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+			return ipr_ata_slave_alloc(sdev);
 		}
 	}
 
@@ -3281,6 +3453,49 @@ static int ipr_eh_host_reset(struct scsi
 }
 
 /**
+ * ipr_device_reset - Reset the device
+ * @ioa_cfg:	ioa config struct
+ * @res:		resource entry struct
+ *
+ * This function issues a device reset to the affected device.
+ * If the device is a SCSI device, a LUN reset will be sent
+ * to the device first. If that does not work, a target reset
+ * will be sent. If the device is a SATA device, a PHY reset will
+ * be sent.
+ *
+ * Return value:
+ *	SUCCESS / FAILED
+ **/
+static int ipr_device_reset(struct ipr_ioa_cfg *ioa_cfg,
+			    struct ipr_resource_entry *res)
+{
+	struct ipr_cmnd *ipr_cmd;
+	struct ipr_cmd_pkt *cmd_pkt;
+	u32 ioasc;
+
+	ENTER;
+	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
+
+	ipr_cmd->ioarcb.res_handle = res->cfgte.res_handle;
+	cmd_pkt = &ipr_cmd->ioarcb.cmd_pkt;
+	cmd_pkt->request_type = IPR_RQTYPE_IOACMD;
+	cmd_pkt->cdb[0] = IPR_RESET_DEVICE;
+	if (ipr_is_gata(res))
+		cmd_pkt->cdb[2] = IPR_ATA_PHY_RESET;
+
+	ipr_res_err(ioa_cfg, res, "Resetting device\n");
+	ipr_send_blocking_cmd(ipr_cmd, ipr_timeout, IPR_DEVICE_RESET_TIMEOUT);
+	ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
+	if (ipr_is_gata(res) && res->sata_port)
+		memcpy(&res->sata_port->ioasa, &ipr_cmd->ioasa.u.gata,
+		       sizeof(struct ipr_ioasa_gata));
+	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
+
+	LEAVE;
+	return (IPR_IOASC_SENSE_KEY(ioasc) ? FAILED : SUCCESS);
+}
+
+/**
  * ipr_eh_dev_reset - Reset the device
  * @scsi_cmd:	scsi command struct
  *
@@ -3296,8 +3511,7 @@ static int __ipr_eh_dev_reset(struct scs
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
-	struct ipr_cmd_pkt *cmd_pkt;
-	u32 ioasc;
+	int rc;
 
 	ENTER;
 	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
@@ -3324,25 +3538,11 @@ static int __ipr_eh_dev_reset(struct scs
 	}
 
 	res->resetting_device = 1;
-
-	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
-
-	ipr_cmd->ioarcb.res_handle = res->cfgte.res_handle;
-	cmd_pkt = &ipr_cmd->ioarcb.cmd_pkt;
-	cmd_pkt->request_type = IPR_RQTYPE_IOACMD;
-	cmd_pkt->cdb[0] = IPR_RESET_DEVICE;
-
-	sdev_printk(KERN_ERR, scsi_cmd->device, "Resetting device\n");
-	ipr_send_blocking_cmd(ipr_cmd, ipr_timeout, IPR_DEVICE_RESET_TIMEOUT);
-
-	ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
-
+	rc = ipr_device_reset(ioa_cfg, res);
 	res->resetting_device = 0;
 
-	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
-
 	LEAVE;
-	return (IPR_IOASC_SENSE_KEY(ioasc) ? FAILED : SUCCESS);
+	return rc;
 }
 
 static int ipr_eh_dev_reset(struct scsi_cmnd * cmd)
@@ -4206,6 +4406,37 @@ static void ipr_scsi_done(struct ipr_cmn
 }
 
 /**
+ * ipr_sata_done - done function for SATA commands
+ * @ipr_cmd:	ipr command struct
+ *
+ * This function is invoked by the interrupt handler for
+ * ops generated by the SCSI mid-layer to SATA devices
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_sata_done(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	struct ata_queued_cmd *qc = ipr_cmd->qc;
+	struct ipr_sata_port *sata_port = qc->ap->private_data;
+	u32 ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
+
+	if (ioasc != IPR_IOASC_IOA_WAS_RESET) {
+		memcpy(&sata_port->ioasa, &ipr_cmd->ioasa.u.gata,
+		       sizeof(struct ipr_ioasa_gata));
+		ipr_dump_ioasa(ioa_cfg, ipr_cmd, sata_port->res);
+	}
+
+	if (ioasc)
+		qc->err_mask |= __ac_err_mask(ipr_cmd->ioasa.u.gata.status);
+	else
+		qc->err_mask |= ac_err_mask(ipr_cmd->ioasa.u.gata.status);
+	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
+	ata_qc_complete(qc);
+}
+
+/**
  * ipr_save_ioafp_mode_select - Save adapters mode select data
  * @ioa_cfg:	ioa config struct
  * @scsi_cmd:	scsi command struct
@@ -4279,6 +4510,9 @@ static int ipr_queuecommand(struct scsi_
 		return 0;
 	}
 
+	if (ipr_is_gata(res))
+		return ata_sas_queuecmd(scsi_cmd, done, res->sata_port->ap);
+
 	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ioarcb = &ipr_cmd->ioarcb;
 	list_add_tail(&ipr_cmd->queue, &ioa_cfg->pending_q);
@@ -4327,6 +4561,26 @@ static int ipr_queuecommand(struct scsi_
 }
 
 /**
+ * ipr_ioctl - IOCTL handler
+ * @sdev:	scsi device struct
+ * @cmd:	IOCTL cmd
+ * @arg:	IOCTL arg
+ *
+ * Return value:
+ * 	0 on success / other on failure
+ **/
+int ipr_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
+{
+	struct ipr_resource_entry *res;
+
+	res = (struct ipr_resource_entry *)sdev->hostdata;
+	if (res && ipr_is_gata(res))
+		return __ata_scsi_ioctl(sdev, cmd, arg);
+
+	return -EINVAL;
+}
+
+/**
  * ipr_info - Get information about the card/driver
  * @scsi_host:	scsi host struct
  *
@@ -4352,6 +4606,7 @@ static struct scsi_host_template driver_
 	.module = THIS_MODULE,
 	.name = "IPR",
 	.info = ipr_ioa_info,
+	.ioctl = ipr_ioctl,
 	.queuecommand = ipr_queuecommand,
 	.eh_abort_handler = ipr_eh_abort,
 	.eh_device_reset_handler = ipr_eh_dev_reset,
@@ -4359,6 +4614,8 @@ static struct scsi_host_template driver_
 	.slave_alloc = ipr_slave_alloc,
 	.slave_configure = ipr_slave_configure,
 	.slave_destroy = ipr_slave_destroy,
+	.target_alloc = ipr_target_alloc,
+	.target_destroy = ipr_target_destroy,
 	.change_queue_depth = ipr_change_queue_depth,
 	.change_queue_type = ipr_change_queue_type,
 	.bios_param = ipr_biosparam,
@@ -4373,6 +4630,297 @@ static struct scsi_host_template driver_
 	.proc_name = IPR_NAME
 };
 
+/**
+ * ipr_ata_phy_reset - libata phy_reset handler
+ * @ap:	ata port to reset
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_ata_phy_reset(struct ata_port *ap)
+{
+	unsigned long flags;
+	struct ipr_sata_port *sata_port = ap->private_data;
+	struct ipr_resource_entry *res = sata_port->res;
+	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
+
+	ENTER;
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	while(ioa_cfg->in_reset_reload) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	}
+
+	if (!ioa_cfg->allow_cmds) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+		return;
+	}
+
+	ipr_device_reset(ioa_cfg, res);
+
+	switch(res->cfgte.proto) {
+	case IPR_PROTO_SATA:
+	case IPR_PROTO_SAS_STP:
+		ap->device[0].class = ATA_DEV_ATA;
+		break;
+	case IPR_PROTO_SATA_ATAPI:
+	case IPR_PROTO_SAS_STP_ATAPI:
+		ap->device[0].class = ATA_DEV_ATAPI;
+		break;
+	default:
+		ap->ops->port_disable(ap);
+		break;
+	};
+
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	LEAVE;
+}
+
+/**
+ * ipr_sata_timeout - Perform SATA timeout processing
+ * @ap:	ATA port
+ *
+ * Perform any cleanup necessary to flush the timed out ops
+ * back.
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_sata_timeout(struct ata_port *ap)
+{
+	struct ipr_sata_port *sata_port = ap->private_data;
+	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
+	unsigned long flags;
+	int rc = SUCCESS;
+
+	ENTER;
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	rc = ipr_device_reset(ioa_cfg, sata_port->res);
+	if (rc != SUCCESS) {
+		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+	} else
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	LEAVE;
+}
+
+/**
+ * ipr_tf_read - Read the current ATA taskfile for the ATA port
+ * @ap:	ATA port
+ * @tf:	destination ATA taskfile
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
+{
+	struct ipr_sata_port *sata_port = ap->private_data;
+	struct ipr_ioasa_gata *g = &sata_port->ioasa;
+
+	tf->feature = g->error;
+	tf->nsect = g->nsect;
+	tf->lbal = g->lbal;
+	tf->lbam = g->lbam;
+	tf->lbah = g->lbah;
+	tf->device = g->device;
+	tf->command = g->status;
+	tf->hob_nsect = g->hob_nsect;
+	tf->hob_lbal = g->hob_lbal;
+	tf->hob_lbam = g->hob_lbam;
+	tf->hob_lbah = g->hob_lbah;
+	tf->ctl = g->alt_status;
+}
+
+/**
+ * ipr_copy_sata_tf - Copy a SATA taskfile to an IOA data structure
+ * @regs:	destination
+ * @tf:	source ATA taskfile
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_copy_sata_tf(struct ipr_ioarcb_ata_regs *regs,
+			     struct ata_taskfile *tf)
+{
+	regs->feature = tf->feature;
+	regs->nsect = tf->nsect;
+	regs->lbal = tf->lbal;
+	regs->lbam = tf->lbam;
+	regs->lbah = tf->lbah;
+	regs->device = tf->device;
+	regs->command = tf->command;
+	regs->hob_feature = tf->hob_feature;
+	regs->hob_nsect = tf->hob_nsect;
+	regs->hob_lbal = tf->hob_lbal;
+	regs->hob_lbam = tf->hob_lbam;
+	regs->hob_lbah = tf->hob_lbah;
+	regs->ctl = tf->ctl;
+}
+
+/**
+ * ipr_build_ata_ioadl - Build an ATA scatter/gather list
+ * @ipr_cmd:	ipr command struct
+ * @qc:		ATA queued command
+ *
+ **/
+static void ipr_build_ata_ioadl(struct ipr_cmnd *ipr_cmd,
+				struct ata_queued_cmd *qc)
+{
+	u32 ioadl_flags = 0;
+	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
+	struct ipr_ioadl_desc *ioadl = ipr_cmd->ioadl;
+	int len = qc->nbytes;
+	struct scatterlist *sg;
+
+	if (len == 0)
+		return;
+
+	if (qc->dma_dir == DMA_TO_DEVICE) {
+		ioadl_flags = IPR_IOADL_FLAGS_WRITE;
+		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_WRITE_NOT_READ;
+		ioarcb->write_data_transfer_length = cpu_to_be32(len);
+		ioarcb->write_ioadl_len =
+			cpu_to_be32(sizeof(struct ipr_ioadl_desc) * ipr_cmd->dma_use_sg);
+	} else if (qc->dma_dir == DMA_FROM_DEVICE) {
+		ioadl_flags = IPR_IOADL_FLAGS_READ;
+		ioarcb->read_data_transfer_length = cpu_to_be32(len);
+		ioarcb->read_ioadl_len =
+			cpu_to_be32(sizeof(struct ipr_ioadl_desc) * ipr_cmd->dma_use_sg);
+	}
+
+	ata_for_each_sg(sg, qc) {
+		ioadl->flags_and_data_len = cpu_to_be32(ioadl_flags | sg_dma_len(sg));
+		ioadl->address = cpu_to_be32(sg_dma_address(sg));
+		if (ata_sg_is_last(sg, qc))
+			ioadl->flags_and_data_len |= cpu_to_be32(IPR_IOADL_FLAGS_LAST);
+		else
+			ioadl++;
+	}
+}
+
+/**
+ * ipr_qc_issue - Issue a SATA qc to a device
+ * @qc:	queued command
+ *
+ * Return value:
+ * 	0 if success
+ **/
+static int ipr_qc_issue(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ipr_sata_port *sata_port = ap->private_data;
+	struct ipr_resource_entry *res = sata_port->res;
+	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
+	struct ipr_cmnd *ipr_cmd;
+	struct ipr_ioarcb *ioarcb;
+	struct ipr_ioarcb_ata_regs *regs;
+
+	if (unlikely(!ioa_cfg->allow_cmds || ioa_cfg->ioa_is_dead))
+		return -EIO;
+
+	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
+	ioarcb = &ipr_cmd->ioarcb;
+	regs = &ioarcb->add_data.u.regs;
+
+	memset(&ioarcb->add_data, 0, sizeof(ioarcb->add_data));
+	ioarcb->add_cmd_parms_len = cpu_to_be32(sizeof(ioarcb->add_data.u.regs));
+
+	list_add_tail(&ipr_cmd->queue, &ioa_cfg->pending_q);
+	ipr_cmd->qc = qc;
+	ipr_cmd->done = ipr_sata_done;
+	ipr_cmd->ioarcb.res_handle = res->cfgte.res_handle;
+	ioarcb->cmd_pkt.request_type = IPR_RQTYPE_ATA_PASSTHRU;
+	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
+	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
+	ipr_cmd->dma_use_sg = qc->n_elem;
+
+	ipr_build_ata_ioadl(ipr_cmd, qc);
+	regs->flags |= IPR_ATA_FLAG_STATUS_ON_GOOD_COMPLETION;
+	ipr_copy_sata_tf(regs, &qc->tf);
+	memcpy(ioarcb->cmd_pkt.cdb, qc->cdb, IPR_MAX_CDB_LEN);
+	ipr_trc_hook(ipr_cmd, IPR_TRACE_START, IPR_GET_PHYS_LOC(res->cfgte.res_addr));
+
+	switch (qc->tf.protocol) {
+	case ATA_PROT_NODATA:
+	case ATA_PROT_PIO:
+		break;
+
+	case ATA_PROT_DMA:
+		regs->flags |= IPR_ATA_FLAG_XFER_TYPE_DMA;
+		break;
+
+	case ATA_PROT_ATAPI:
+	case ATA_PROT_ATAPI_NODATA:
+		regs->flags |= IPR_ATA_FLAG_PACKET_CMD;
+		break;
+
+	case ATA_PROT_ATAPI_DMA:
+		regs->flags |= IPR_ATA_FLAG_PACKET_CMD;
+		regs->flags |= IPR_ATA_FLAG_XFER_TYPE_DMA;
+		break;
+
+	default:
+		WARN_ON(1);
+		return -1;
+	}
+
+	mb();
+	writel(be32_to_cpu(ioarcb->ioarcb_host_pci_addr),
+	       ioa_cfg->regs.ioarrin_reg);
+	return 0;
+}
+
+/**
+ * ipr_ata_check_status - Return last ATA status
+ * @ap:	ATA port
+ *
+ * Return value:
+ * 	ATA status
+ **/
+static u8 ipr_ata_check_status(struct ata_port *ap)
+{
+	struct ipr_sata_port *sata_port = ap->private_data;
+	return sata_port->ioasa.status;
+}
+
+/**
+ * ipr_ata_check_altstatus - Return last ATA altstatus
+ * @ap:	ATA port
+ *
+ * Return value:
+ * 	Alt ATA status
+ **/
+static u8 ipr_ata_check_altstatus(struct ata_port *ap)
+{
+	struct ipr_sata_port *sata_port = ap->private_data;
+	return sata_port->ioasa.alt_status;
+}
+
+static struct ata_port_operations ipr_sata_ops = {
+	.port_disable = ata_port_disable,
+	.check_status = ipr_ata_check_status,
+	.check_altstatus = ipr_ata_check_altstatus,
+	.dev_select = ata_noop_dev_select,
+	.phy_reset = ipr_ata_phy_reset,
+	.tf_read = ipr_tf_read,
+	.qc_prep = ata_noop_qc_prep,
+	.qc_issue = ipr_qc_issue,
+	.eng_timeout = ipr_sata_timeout,
+	.port_start = ata_port_start,
+	.port_stop = ata_port_stop
+};
+
+static struct ata_port_info sata_port_info = {
+	.host_flags	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_SATA_RESET |
+	ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA | ATA_FLAG_NO_PRD,
+	.pio_mask	= 0x10, /* pio4 */
+	.mwdma_mask = 0x07,
+	.udma_mask	= 0x7f, /* udma0-6 */
+	.port_ops	= &ipr_sata_ops
+};
+
 #ifdef CONFIG_PPC_PSERIES
 static const u16 ipr_blocked_processors[] = {
 	PV_NORTHSTAR,
diff -puN drivers/scsi/Kconfig~ipr_sata_with_libata_changes drivers/scsi/Kconfig
--- libata-dev/drivers/scsi/Kconfig~ipr_sata_with_libata_changes	2006-02-06 09:15:44.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/Kconfig	2006-02-06 09:15:44.000000000 -0600
@@ -1103,6 +1103,7 @@ config SCSI_IPR
 	tristate "IBM Power Linux RAID adapter support"
 	depends on PCI && SCSI
 	select FW_LOADER
+	select SCSI_SATA
 	---help---
 	  This driver supports the IBM Power Linux family RAID adapters.
 	  This includes IBM pSeries 5712, 5703, 5709, and 570A, as well
diff -puN drivers/scsi/Makefile~ipr_sata_with_libata_changes drivers/scsi/Makefile
--- libata-dev/drivers/scsi/Makefile~ipr_sata_with_libata_changes	2006-02-06 09:15:44.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/Makefile	2006-02-06 09:15:44.000000000 -0600
@@ -121,7 +121,7 @@ obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 obj-$(CONFIG_SCSI_FCAL)		+= fcal.o
 obj-$(CONFIG_SCSI_LASI700)	+= 53c700.o lasi700.o
 obj-$(CONFIG_SCSI_NSP32)	+= nsp32.o
-obj-$(CONFIG_SCSI_IPR)		+= ipr.o
+obj-$(CONFIG_SCSI_IPR)		+= libata.o ipr.o
 obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_SATA_AHCI)	+= libata.o ahci.o
 obj-$(CONFIG_SCSI_SATA_SVW)	+= libata.o sata_svw.o
_
