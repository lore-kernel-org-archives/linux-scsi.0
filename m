From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RFC: Transport identifier
Date: Fri, 27 Feb 2009 23:13:03 -0500
Message-ID: <yq1eixjdws0.fsf@sermon.lab.mkp.net>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
	<1235663301.19035.44.camel@localhost.localdomain>
	<yq1prh5ey7b.fsf@sermon.lab.mkp.net>
	<20090227163326V.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:24952 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbZB1EN0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Feb 2009 23:13:26 -0500
In-Reply-To: <20090227163326V.fujita.tomonori@lab.ntt.co.jp> (FUJITA Tomonori's message of "Fri\, 27 Feb 2009 16\:33\:24 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

>>>>> "Tomo" == FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:

Tomo> How about setting shost->transport_id in each transport class
Tomo> (like the attached patch)?  I guess that it would be better to
Tomo> move this to transport class completely though.

The following patch below sits somewhere between my original take and
your patch.  Those transports that have classes implemented fill out the
id like you did.  The ones that don't (ATA, FireWire and USB) set it
manually.  Best of both worlds, IMHO.

The patch provides a solution for lsscsi scanning.  I'll save the
scsi_device portion for another time.


>> I don't have a single device that provides the version descriptors.
>> Sadly.

Tomo> I don't too. I checked the PROTOCOL field of a VPD inquiry for
Tomo> other reasons and none of my disk set it.

I tested in my lab today and out of about 30 drive models I only had one
that had the protocol mode pages filled out.  Not a single drive had the
version descriptors.  I also tried a few USB and FireWire drives.
Zilch.

I was planning on rolling an orthogonal patch that exposed device/port
protocol.  But given the test results I'm not so sure it's worth the
effort.


diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3215,6 +3215,7 @@ int ata_scsi_add_hosts(struct ata_host *
 		shost->max_lun = 1;
 		shost->max_channel = 1;
 		shost->max_cmd_len = 16;
+		shost->transport_id = SCSI_TRANSPORT_ATA;
 
 		/* Schedule policy is determined by ->qc_defer()
 		 * callback and it needs to see every deferred qc.
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1144,6 +1144,7 @@ static int sbp2_probe(struct device *dev
 	if (scsi_add_host(shost, &unit->device) < 0)
 		goto fail_shost_put;
 
+	shost->transport_id = SCSI_TRANSPORT_SBP;
 	fw_device_get(device);
 	fw_unit_get(unit);
 
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -880,6 +880,7 @@ static struct sbp2_lu *sbp2_alloc_device
 	}
 
 	shost->hostdata[0] = (unsigned long)lu;
+	shost->transport_id = SCSI_TRANSPORT_SBP;
 
 	if (!scsi_add_host(shost, &ud->device)) {
 		lu->shost = shost;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -140,6 +140,35 @@ static DEVICE_ATTR(name, S_IRUGO, show_#
 #define shost_rd_attr(field, format_string) \
 shost_rd_attr2(field, field, format_string)
 
+static const struct {
+	enum scsi_transport_id value;
+	char *name;
+} scsi_transport_names[] = {
+	{ SCSI_TRANSPORT_UNKNOWN,	"unknown"	},
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
@@ -244,6 +273,20 @@ show_shost_active_mode(struct device *de
 
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
@@ -268,6 +311,7 @@ static struct attribute *scsi_sysfs_shos
 	&dev_attr_active_mode.attr,
 	&dev_attr_prot_capabilities.attr,
 	&dev_attr_prot_guard_type.attr,
+	&dev_attr_transport_name.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -410,6 +410,7 @@ static int fc_host_setup(struct transpor
 		fc_host->work_q = NULL;
 		return -ENOMEM;
 	}
+	shost->transport_id = SCSI_TRANSPORT_FC;
 
 	return 0;
 }
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -253,6 +253,7 @@ static int iscsi_setup_host(struct trans
 						ihost->scan_workq_name);
 	if (!ihost->scan_workq)
 		return -ENOMEM;
+	shost->transport_id = SCSI_TRANSPORT_ISCSI;
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -287,6 +287,7 @@ static int sas_host_setup(struct transpo
 		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
 			   shost->host_no);
 
+	shost->transport_id = SCSI_TRANSPORT_SAS;
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -63,6 +63,7 @@ static int srp_host_setup(struct transpo
 	struct srp_host_attrs *srp_host = to_srp_host_attrs(shost);
 
 	atomic_set(&srp_host->next_port_id, 0);
+	shost->transport_id = SCSI_TRANSPORT_SRP;
 	return 0;
 }
 
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -1041,6 +1041,7 @@ static int storage_probe(struct usb_inte
 	 * Allow 16-byte CDBs and thus > 2TB
 	 */
 	host->max_cmd_len = 16;
+	host->transport_id = SCSI_TRANSPORT_USB;
 	us = host_to_us(host);
 	memset(us, 0, sizeof(struct us_data));
 	mutex_init(&(us->dev_mutex));
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -533,4 +533,15 @@ static inline __u32 scsi_to_u32(__u8 *pt
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
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -648,6 +648,7 @@ struct Scsi_Host {
 	
 
 	enum scsi_host_state shost_state;
+	enum scsi_transport_id transport_id;
 
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;
