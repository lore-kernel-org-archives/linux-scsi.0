From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: Export transport identifier
Date: Mon, 09 Mar 2009 11:45:04 -0400
Message-ID: <yq1tz62ya2n.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:61819 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbZCIPpP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2009 11:45:15 -0400
Received: from rgminet15.oracle.com (rcsinet15.oracle.com [148.87.113.117])
	by rgminet13.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n29FkLvw023614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 9 Mar 2009 15:46:23 GMT
Received: from acsmt700.oracle.com (acsmt700.oracle.com [141.146.40.70])
	by rgminet15.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n29FjBmZ009406
	for <linux-scsi@vger.kernel.org>; Mon, 9 Mar 2009 15:45:13 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch exports a transport identifier for each host.  This removes
the need for heuristics in management utilities that need to know the
transport type.

The identifier is set by the SCSI transport class except for ATA, USB
and FireWire.  The default identifier is SPI as not all legacy HBA
drivers are using transport classes.

This patch is based on work by FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp>.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 9e92107..f412c96 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3191,6 +3191,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		shost->max_lun = 1;
 		shost->max_channel = 1;
 		shost->max_cmd_len = 16;
+		shost->transport_id = SCSI_TRANSPORT_ATA;
 
 		/* Schedule policy is determined by ->qc_defer()
 		 * callback and it needs to see every deferred qc.
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index e88d506..0be1127 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1139,6 +1139,7 @@ static int sbp2_probe(struct device *dev)
 	if (scsi_add_host(shost, &unit->device) < 0)
 		goto fail_shost_put;
 
+	shost->transport_id = SCSI_TRANSPORT_SBP;
 	fw_device_get(device);
 	fw_unit_get(unit);
 
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index ab1034c..2354182 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -870,6 +870,7 @@ static struct sbp2_lu *sbp2_alloc_device(struct unit_directory *ud)
 	}
 
 	shost->hostdata[0] = (unsigned long)lu;
+	shost->transport_id = SCSI_TRANSPORT_SBP;
 
 	if (!scsi_add_host(shost, &ud->device)) {
 		lu->shost = shost;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fa4711d..ad62243 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -140,6 +140,34 @@ static DEVICE_ATTR(name, S_IRUGO, show_##name, NULL);
 #define shost_rd_attr(field, format_string) \
 shost_rd_attr2(field, field, format_string)
 
+static const struct {
+	enum scsi_transport_id value;
+	char *name;
+} scsi_transport_names[] = {
+	{ SCSI_TRANSPORT_SPI,		"spi"		},
+	{ SCSI_TRANSPORT_FC,		"fc"		},
+	{ SCSI_TRANSPORT_SAS,		"sas"		},
+	{ SCSI_TRANSPORT_ISCSI,		"iscsi"		},
+	{ SCSI_TRANSPORT_SBP,		"sbp"		},
+	{ SCSI_TRANSPORT_USB,		"usb"		},
+	{ SCSI_TRANSPORT_ATA,		"ata"		},
+};
+
+static const char *scsi_transport_name(enum scsi_transport_id id)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(scsi_transport_names); i++) {
+		if (scsi_transport_names[i].value == id) {
+			name = scsi_transport_names[i].name;
+			break;
+		}
+	}
+
+	return name;
+}
+
 /*
  * Create the actual show/store functions and data structures.
  */
@@ -244,6 +272,20 @@ show_shost_active_mode(struct device *dev,
 
 static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL);
 
+static ssize_t
+show_shost_transport_name(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	const char *name = scsi_transport_name(shost->transport_id);
+
+	if (!name)
+		return -EINVAL;
+
+	return snprintf(buf, 20, "%s\n", name);
+}
+static DEVICE_ATTR(transport_name, S_IRUGO, show_shost_transport_name, NULL);
+
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
@@ -268,6 +310,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_active_mode.attr,
 	&dev_attr_prot_capabilities.attr,
 	&dev_attr_prot_guard_type.attr,
+	&dev_attr_transport_name.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 2df7529..44eaeb5 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -410,6 +410,7 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
 		fc_host->work_q = NULL;
 		return -ENOMEM;
 	}
+	shost->transport_id = SCSI_TRANSPORT_FC;
 
 	return 0;
 }
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 75c9297..9bfbbb8 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -253,6 +253,7 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 						ihost->scan_workq_name);
 	if (!ihost->scan_workq)
 		return -ENOMEM;
+	shost->transport_id = SCSI_TRANSPORT_ISCSI;
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 50988cb..8335de8 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -287,6 +287,7 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
 		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
 			   shost->host_no);
 
+	shost->transport_id = SCSI_TRANSPORT_SAS;
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 21a045e..0533977 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -63,6 +63,7 @@ static int srp_host_setup(struct transport_container *tc, struct device *dev,
 	struct srp_host_attrs *srp_host = to_srp_host_attrs(shost);
 
 	atomic_set(&srp_host->next_port_id, 0);
+	shost->transport_id = SCSI_TRANSPORT_SRP;
 	return 0;
 }
 
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 4becf49..a2ad18d 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -1041,6 +1041,7 @@ static int storage_probe(struct usb_interface *intf,
 	 * Allow 16-byte CDBs and thus > 2TB
 	 */
 	host->max_cmd_len = 16;
+	host->transport_id = SCSI_TRANSPORT_USB;
 	us = host_to_us(host);
 	memset(us, 0, sizeof(struct us_data));
 	mutex_init(&(us->dev_mutex));
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 80d7f60..109aa25 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -523,4 +523,15 @@ static inline __u32 scsi_to_u32(__u8 *ptr)
 	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
 }
 
+enum scsi_transport_id {
+	SCSI_TRANSPORT_UNKNOWN = 0,
+	SCSI_TRANSPORT_SPI,
+	SCSI_TRANSPORT_FC,
+	SCSI_TRANSPORT_SAS,
+	SCSI_TRANSPORT_ISCSI,
+	SCSI_TRANSPORT_SBP,
+	SCSI_TRANSPORT_USB,
+	SCSI_TRANSPORT_ATA,
+};
+
 #endif /* _SCSI_SCSI_H */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index d123ca8..54fc90f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -648,6 +648,7 @@ struct Scsi_Host {
 	
 
 	enum scsi_host_state shost_state;
+	enum scsi_transport_id transport_id;
 
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;

