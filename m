From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: RFC: Transport identifier
Date: Wed, 25 Feb 2009 23:31:55 -0500
Message-ID: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:43458 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZBZEcF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2009 23:32:05 -0500
Received: from acsinet13.oracle.com (acsinet13.oracle.com [141.146.126.235])
	by acsinet12.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n1Q4VndU015553
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2009 04:31:50 GMT
Received: from acsmt704.oracle.com (acsmt704.oracle.com [141.146.40.82])
	by acsinet13.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n1Q4W8qN009326
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2009 04:32:09 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


There are a few cases where it would be useful to know which transport
is associated with a scsi_device.  For instance when determining whether
to send a READ CAPACITY(16) to a device or not:

    static int sd_try_rc16_first(struct scsi_device *sdp)
    {
	if (scsi_device_transport(sdp) == SCSI_TRANSPORT_USB)
	   return 0; /* Run screaming for the hills */
    [...]

This patch implements support for a transport identifier in the
scsi_host.  The id defaults to SPI and it is explicitly overridden in
the host templates for FC, SAS, USB, etc. drivers.

It also looks like the availability of this transport id could improve
the sysfs parsing in lsscsi.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1622,6 +1622,7 @@ static struct scsi_host_template scsi_dr
 	.cmd_per_lun		= 1,
 	.can_queue		= 1,
 	.sdev_attrs		= sbp2_scsi_sysfs_attrs,
+	.transport_id		= SCSI_TRANSPORT_SBP,
 };
 
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -345,6 +345,7 @@ static struct scsi_host_template sbp2_sh
 	.cmd_per_lun		 = SBP2_MAX_CMDS,
 	.can_queue		 = SBP2_MAX_CMDS,
 	.sdev_attrs		 = sbp2_sysfs_sdev_attrs,
+	.transport_id		 = SCSI_TRANSPORT_SBP,
 };
 
 #define SBP2_ROM_VALUE_WILDCARD ~0         /* match all */
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -603,6 +603,7 @@ static struct scsi_host_template iscsi_i
 	.use_clustering         = DISABLE_CLUSTERING,
 	.proc_name              = "iscsi_iser",
 	.this_id                = -1,
+	.transport_id		= SCSI_TRANSPORT_ISCSI,
 };
 
 static struct iscsi_transport iscsi_iser_transport = {
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1594,6 +1594,7 @@ static struct scsi_host_template srp_tem
 	.cmd_per_lun			= SRP_SQ_SIZE,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= srp_host_attrs
+	.transport_id			= SCSI_TRANSPORT_ISCSI,
 };
 
 static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -131,6 +131,7 @@ static struct scsi_host_template mptfc_d
 	.cmd_per_lun			= 7,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= mptscsih_host_attrs,
+	.transport_id			= SCSI_TRANSPORT_FC,
 };
 
 /****************************************************************************
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1047,6 +1047,7 @@ static struct scsi_host_template mptsas_
 	.cmd_per_lun			= 7,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= mptscsih_host_attrs,
+	.transport_id			= SCSI_TRANSPORT_SAS,
 };
 
 static int mptsas_get_linkerrors(struct sas_phy *phy)
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -504,6 +504,7 @@ struct fc_function_template zfcp_transpo
 	.show_host_speed = 1,
 	.show_host_port_id = 1,
 	.disable_target_scan = 1,
+	.transport_id = SCSI_TRANSPORT_FC,
 };
 
 struct zfcp_data zfcp_data = {
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -149,6 +149,15 @@ int scsi_host_set_state(struct Scsi_Host
 EXPORT_SYMBOL(scsi_host_set_state);
 
 /**
+ * scsi_host_transport_id - Get the transport for a SCSI host
+ * @shost:	pointer to SCSI host
+ */
+enum scsi_transport_id scsi_host_transport_id(struct Scsi_Host *host)
+{
+	return host->transport_id;
+}
+
+/**
  * scsi_remove_host - remove a scsi host
  * @shost:	a pointer to a scsi host to remove
  **/
@@ -358,6 +367,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
+	shost->transport_id = sht->transport_id;
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -836,6 +836,7 @@ static struct scsi_host_template iscsi_s
 	.slave_configure        = iscsi_sw_tcp_slave_configure,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
+	.transport_id		= SCSI_TRANSPORT_ISCSI,
 };
 
 static struct iscsi_transport iscsi_sw_tcp_transport = {
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2956,6 +2956,7 @@ struct scsi_host_template lpfc_template 
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= lpfc_hba_attrs,
 	.max_sectors		= 0xFFFF,
+	.transport_id		= SCSI_TRANSPORT_FC,
 };
 
 struct scsi_host_template lpfc_vport_template = {
@@ -2976,4 +2977,5 @@ struct scsi_host_template lpfc_vport_tem
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= lpfc_vport_attrs,
 	.max_sectors		= 0xFFFF,
+	.transport_id		= SCSI_TRANSPORT_FC,
 };
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1309,6 +1309,7 @@ static struct scsi_host_template megasas
 	.eh_timed_out = megasas_reset_timer,
 	.bios_param = megasas_bios_param,
 	.use_clustering = ENABLE_CLUSTERING,
+	.transport_id = SCSI_TRANSPORT_SAS,
 };
 
 /**
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -147,6 +147,7 @@ static struct scsi_host_template qla2x00
 	 */
 	.max_sectors		= 0xFFFF,
 	.shost_attrs		= qla2x00_host_attrs,
+	.transport_id		= SCSI_TRANSPORT_FC,
 };
 
 struct scsi_host_template qla24xx_driver_template = {
@@ -175,6 +176,7 @@ struct scsi_host_template qla24xx_driver
 
 	.max_sectors		= 0xFFFF,
 	.shost_attrs		= qla2x00_host_attrs,
+	.transport_id		= SCSI_TRANSPORT_FC,
 };
 
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -103,6 +103,7 @@ static struct scsi_host_template qla4xxx
 	.sg_tablesize		= SG_ALL,
 
 	.max_sectors		= 0xFFFF,
+	.transport_id		= SCSI_TRANSPORT_ISCSI,
 };
 
 static struct iscsi_transport qla4xxx_iscsi_transport = {
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -244,6 +244,20 @@ show_shost_active_mode(struct device *de
 
 static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL);
 
+/* These strings must match the scsi_transport_id enum in scsi.h */
+static const char * const transport_names[] = {
+	"spi", "fc", "sas", "iscsi", "sbp", "usb", "ata",
+};
+
+static ssize_t
+show_shost_transport_id(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+
+	return snprintf(buf, 20, "%s\n", transport_names[shost->transport_id]);
+}
+static DEVICE_ATTR(transport_id, S_IRUGO, show_shost_transport_id, NULL);
+
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
@@ -268,6 +282,7 @@ static struct attribute *scsi_sysfs_shos
 	&dev_attr_active_mode.attr,
 	&dev_attr_prot_capabilities.attr,
 	&dev_attr_prot_guard_type.attr,
+	&dev_attr_transport_id.attr,
 	NULL
 };
 
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -553,7 +553,9 @@ struct scsi_host_template usb_stor_host_
 	.sdev_attrs =			sysfs_device_attr_list,
 
 	/* module management */
-	.module =			THIS_MODULE
+	.module =			THIS_MODULE,
+
+	.transport_id = 		SCSI_TRANSPORT_USB,
 };
 
 /* To Report "Illegal Request: Invalid Field in CDB */
diff --git a/include/linux/libata.h b/include/linux/libata.h
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1144,6 +1144,7 @@ extern struct device_attribute *ata_comm
 	.slave_configure	= ata_scsi_slave_config,	\
 	.slave_destroy		= ata_scsi_slave_destroy,	\
 	.bios_param		= ata_std_bios_param,		\
+	.transport_id		= SCSI_TRANSPORT_ATA,		\
 	.sdev_attrs		= ata_common_sdev_attrs
 
 #define ATA_NCQ_SHT(drv_name)					\
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -533,4 +533,16 @@ static inline __u32 scsi_to_u32(__u8 *pt
 	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
 }
 
+enum scsi_transport_id {
+	SCSI_TRANSPORT_SPI,
+	SCSI_TRANSPORT_FC,
+	SCSI_TRANSPORT_SAS,
+	SCSI_TRANSPORT_ISCSI,
+	SCSI_TRANSPORT_SBP,
+	SCSI_TRANSPORT_USB,
+	SCSI_TRANSPORT_ATA,
+};
+
+extern enum scsi_transport_id scsi_host_transport_id(struct Scsi_Host *);
+
 #endif /* _SCSI_SCSI_H */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -455,6 +455,11 @@ static inline int scsi_device_protection
 	return sdev->scsi_level > SCSI_2 && sdev->inquiry[5] & (1<<0);
 }
 
+static inline int scsi_device_transport(struct scsi_device *sdev)
+{
+	return scsi_host_transport_id(sdev->host);
+}
+
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
 #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -471,6 +471,11 @@ struct scsi_host_template {
 	struct device_attribute **sdev_attrs;
 
 	/*
+	 * Type of transport
+	 */
+	enum scsi_transport_id transport_id;
+
+	/*
 	 * List of hosts per template.
 	 *
 	 * This is only for use by scsi_module.c for legacy templates.
@@ -648,6 +653,7 @@ struct Scsi_Host {
 	
 
 	enum scsi_host_state shost_state;
+	enum scsi_transport_id transport_id;
 
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;

