From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: RFC: Transport identifier
Date: Fri, 27 Feb 2009 16:33:24 +0900
Message-ID: <20090227163326V.fujita.tomonori@lab.ntt.co.jp>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
	<1235663301.19035.44.camel@localhost.localdomain>
	<yq1prh5ey7b.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42728 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbZB0Hdj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 02:33:39 -0500
In-Reply-To: <yq1prh5ey7b.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Thu, 26 Feb 2009 15:32:24 -0500
"Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> James> I'd really rather not put transport specific knowledge back into
> James> the mid-layer ... the whole idea of the transport classes was to
> James> take it out as much as possible.
> 
> I felt that implementing transport classes for everything else was a
> huge overkill for a simple identifier.

But touching every lld is not nice. How about setting
shost->transport_id in each transport class (like the attached patch)?
I guess that it would be better to move this to transport class
completely though.


> James> The other thought is that a lot of devices nowadays are bridged
> James> (all SCSI DVDs have SPI to ATA bridges; a lot of high end USB
> James> storage or enclosures has USB to ATA bridges), so a single
> James> transport identifier doesn't quite cover it.
> 
> Nope.  And it was not means to be concise.  It was meant to be a hint as
> to what kind of technology was at play.
> 
> To a large extent a dubious_transport bit would suffice.  But I also
> wanted to remedy the lsscsi problem while I was at it.  As Doug
> mentioned the current heuristics are icky.

Doug's idea (or something like that) sounds reasonable to me.


> James> The final thought is that a lot of what you're looking for is
> James> actually in the PROTOCOL field of a VPD inquiry, so it might be
> James> possible to use that to obviate a lot of this.
> 
> You mean the protocol mode page?  Or the version descriptors in INQUIRY?
> 
> I don't have a single device that provides the version descriptors.
> Sadly.

I don't too. I checked the PROTOCOL field of a VPD inquiry for other
reasons and none of my disk set it.


diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index da63802..010cc33 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -140,6 +140,33 @@ static DEVICE_ATTR(name, S_IRUGO, show_##name, NULL);
 #define shost_rd_attr(field, format_string) \
 shost_rd_attr2(field, field, format_string)
 
+static const struct {
+	enum scsi_transport_id value;
+	char *name;
+} scsi_transport_names[] = {
+	{SCSI_TRANSPORT_SPI, "spi"},
+	{SCSI_TRANSPORT_FC, "fc"},
+	{SCSI_TRANSPORT_SAS, "sas"},
+	{SCSI_TRANSPORT_ISCSI, "iscsi"},
+	{SCSI_TRANSPORT_SBP, "sbp"},
+	{SCSI_TRANSPORT_USB, "usb"},
+	{SCSI_TRANSPORT_ATA, "ata"},
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
+	return name;
+}
+
 /*
  * Create the actual show/store functions and data structures.
  */
@@ -244,6 +271,19 @@ show_shost_active_mode(struct device *dev,
 
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
+	return snprintf(buf, 20, "%s\n", name);
+}
+static DEVICE_ATTR(transport_name, S_IRUGO, show_shost_transport_name, NULL);
+
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
@@ -268,6 +308,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_active_mode.attr,
 	&dev_attr_prot_capabilities.attr,
 	&dev_attr_prot_guard_type.attr,
+	&dev_attr_transport_name.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 5f77417..093bdb5 100644
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
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index a109165..4d1d75e 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -533,4 +533,14 @@ static inline __u32 scsi_to_u32(__u8 *ptr)
 	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
 }
 
+enum scsi_transport_id {
+	SCSI_TRANSPORT_SPI = 0,
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
