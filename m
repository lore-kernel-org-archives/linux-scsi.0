From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 05 of 10] scsi: Host protection capabilities
Date: Wed, 25 Jun 2008 11:22:44 -0400
Message-ID: <39e5bbd943566af7039e.1214407364@sermon.lab.mkp.net>
References: <patchbomb.1214407359@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:41044 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758947AbYFYPZ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 11:25:27 -0400
In-Reply-To: <patchbomb.1214407359@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Controllers that support protection information must indicate this to
the SCSI midlayer so that the ULD can prepare scsi_cmnds accordingly.

This patch implements a host mask and various types of protection:

 - DIF Type 1-3 (between HBA and disk)
 - Type H (identical to Type 1 for use with non-DIF disks)
 - DMA of protection information in a separate scatterlist

The patch also allows the HBA to set the guard type to something
different than the T10-mandated CRC.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
2 files changed, 76 insertions(+)
drivers/scsi/scsi_sysfs.c |    4 ++
include/scsi/scsi_host.h  |   72 +++++++++++++++++++++++++++++++++++++++++++++



diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -249,6 +249,8 @@ shost_rd_attr(can_queue, "%hd\n");
 shost_rd_attr(can_queue, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
+shost_rd_attr(prot_capabilities, "%u\n");
+shost_rd_attr(prot_guard_type, "%hd\n");
 shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
 
 static struct attribute *scsi_sysfs_shost_attrs[] = {
@@ -263,6 +265,8 @@ static struct attribute *scsi_sysfs_shos
 	&dev_attr_hstate.attr,
 	&dev_attr_supported_mode.attr,
 	&dev_attr_active_mode.attr,
+	&dev_attr_prot_capabilities.attr,
+	&dev_attr_prot_guard_type.attr,
 	NULL
 };
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -636,6 +636,10 @@ struct Scsi_Host {
 	 */
 	unsigned int max_host_blocked;
 
+	/* Protection Information */
+	unsigned int prot_capabilities;
+	unsigned char prot_guard_type;
+
 	/*
 	 * q used for scsi_tgt msgs, async events or any other requests that
 	 * need to be processed in userspace
@@ -756,6 +760,74 @@ extern void scsi_free_host_dev(struct sc
 extern void scsi_free_host_dev(struct scsi_device *);
 extern struct scsi_device *scsi_get_host_dev(struct Scsi_Host *);
 
+/*
+ * DIF defines the exchange of protection information between
+ * initiator and SBC block device.
+ *
+ * DIX defines the exchange of protection information between OS and
+ * initiator.
+ */
+enum scsi_host_prot_capabilities {
+	SHOST_DIF_TYPE1_PROTECTION = 1 << 0, /* T10 DIF Type 1 */
+	SHOST_DIF_TYPE2_PROTECTION = 1 << 1, /* T10 DIF Type 2 */
+	SHOST_DIF_TYPE3_PROTECTION = 1 << 2, /* T10 DIF Type 3 */
+
+	SHOST_DIX_TYPEH_PROTECTION = 1 << 6, /* DIX between OS and HBA */
+	SHOST_DIX_PROTECTION_DMA   = 1 << 7, /* DIX with DIF Type 1-3 */
+};
+
+/*
+ * SCSI hosts which support the Data Integrity Extensions must
+ * indicate their capabilities by setting the prot_capabilities using
+ * this call.
+ */
+static inline void scsi_host_set_prot(struct Scsi_Host *shost, unsigned int mask)
+{
+	shost->prot_capabilities = mask;
+}
+
+static inline unsigned int scsi_host_get_prot(struct Scsi_Host *shost)
+{
+	return shost->prot_capabilities;
+}
+
+static inline unsigned int scsi_host_dif_type(struct Scsi_Host *shost, unsigned int target_type)
+{
+	if (target_type == 0)
+		return shost->prot_capabilities & SHOST_DIX_TYPEH_PROTECTION;
+
+	return shost->prot_capabilities & (1 << (target_type - 1));
+}
+
+static inline unsigned int scsi_host_dif_dma(struct Scsi_Host *shost)
+{
+	return shost->prot_capabilities & SHOST_DIX_PROTECTION_DMA;
+}
+
+/*
+ * All DIX-capable initiators must support the T10-mandated CRC
+ * checksum.  Controllers can optionally implement the IP checksum
+ * scheme which has much lower impact on system performance.  Note
+ * that the main rationale for the checksum is to match integrity
+ * metadata with data.  Detecting bit errors are a job for ECC memory
+ * and buses.
+ */
+
+enum scsi_host_guard_type {
+	SHOST_DIX_GUARD_CRC = 1 << 0,
+	SHOST_DIX_GUARD_IP  = 1 << 1,
+};
+
+static inline void scsi_host_set_guard(struct Scsi_Host *shost, unsigned char type)
+{
+	shost->prot_guard_type = type;
+}
+
+static inline unsigned char scsi_host_get_guard(struct Scsi_Host *shost)
+{
+	return shost->prot_guard_type;
+}
+
 /* legacy interfaces */
 extern struct Scsi_Host *scsi_register(struct scsi_host_template *, int);
 extern void scsi_unregister(struct Scsi_Host *);


