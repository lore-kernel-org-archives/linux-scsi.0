From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] libsas: add host SMP processing
Date: Fri, 28 Dec 2007 17:36:38 -0600
Message-ID: <1198884998.3174.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48946 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510AbXL1Xgt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Dec 2007 18:36:49 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 27CAC863D
	for <linux-scsi@vger.kernel.org>; Fri, 28 Dec 2007 17:36:41 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.il.steeleye.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AMf5QYFIfuk5 for <linux-scsi@vger.kernel.org>;
	Fri, 28 Dec 2007 17:36:39 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 653508593
	for <linux-scsi@vger.kernel.org>; Fri, 28 Dec 2007 17:36:39 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This patch allows the sas host device to accept SMP commands.  This
brings the libsas attached hosts on to a par with the firmware based
ones like mptsas.

James

diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index c01a40d..18f33cd 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -38,6 +38,15 @@ config SCSI_SAS_ATA
 		Builds in ATA support into libsas.  Will necessitate
 		the loading of libata along with libsas.
 
+config SCSI_SAS_HOST_SMP
+	bool "Support for SMP interpretation for SAS hosts"
+	default y
+	depends on SCSI_SAS_LIBSAS
+	help
+		Allows sas hosts to receive SMP frames.  Selecting this
+		option builds an SMP interpreter into libsas.  Say
+		N here if you want to save the few kb this consumes.
+
 config SCSI_SAS_LIBSAS_DEBUG
 	bool "Compile the SAS Domain Transport Attributes in debug mode"
 	default y
diff --git a/drivers/scsi/libsas/Makefile b/drivers/scsi/libsas/Makefile
index fd387b9..60d6e93 100644
--- a/drivers/scsi/libsas/Makefile
+++ b/drivers/scsi/libsas/Makefile
@@ -35,3 +35,4 @@ libsas-y +=  sas_init.o     \
 		sas_expander.o \
 		sas_scsi_host.o
 libsas-$(CONFIG_SCSI_SAS_ATA) +=	sas_ata.o
+libsas-$(CONFIG_SCSI_SAS_HOST_SMP) +=	sas_host_smp.o
\ No newline at end of file
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 27674fe..76555b1 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1896,11 +1896,9 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	}
 
 	/* no rphy means no smp target support (ie aic94xx host) */
-	if (!rphy) {
-		printk("%s: can we send a smp request to a host?\n",
-		       __FUNCTION__);
-		return -EINVAL;
-	}
+	if (!rphy)
+		return sas_smp_host_handler(shost, req, rsp);
+
 	type = rphy->identify.device_type;
 
 	if (type != SAS_EDGE_EXPANDER_DEVICE &&
diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
new file mode 100644
index 0000000..5b9370a
--- /dev/null
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -0,0 +1,247 @@
+/*
+ * Serial Attached SCSI (SAS) Expander discovery and configuration
+ *
+ * Copyright (C) 2007 James E.J. Bottomley
+ *		<James.Bottomley@HansenPartnership.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 only.
+ */
+#include <linux/scatterlist.h>
+#include <linux/blkdev.h>
+
+#include "sas_internal.h"
+
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_sas.h>
+#include "../scsi_sas_internal.h"
+
+static void sas_host_smp_discover(struct sas_ha_struct *sas_ha, u8 *resp_data,
+				  u8 phy_id)
+{
+	struct sas_phy *phy;
+	struct sas_rphy *rphy;
+
+	if (phy_id >= sas_ha->num_phys) {
+		resp_data[2] = SMP_RESP_NO_PHY;
+		return;
+	}
+	resp_data[2] = SMP_RESP_FUNC_ACC;
+
+	phy = sas_ha->sas_phy[phy_id]->phy;
+	resp_data[9] = phy_id;
+	resp_data[13] = phy->negotiated_linkrate;
+	memcpy(resp_data + 16, sas_ha->sas_addr, SAS_ADDR_SIZE);
+	memcpy(resp_data + 24, sas_ha->sas_phy[phy_id]->attached_sas_addr,
+	       SAS_ADDR_SIZE);
+	resp_data[40] = (phy->minimum_linkrate << 4) |
+		phy->minimum_linkrate_hw;
+	resp_data[41] = (phy->maximum_linkrate << 4) |
+		phy->maximum_linkrate_hw;
+
+	if (!sas_ha->sas_phy[phy_id]->port)
+		return;
+
+	rphy = sas_ha->sas_phy[phy_id]->port->port_dev->rphy;
+	resp_data[12] = rphy->identify.device_type << 4;
+	resp_data[14] = rphy->identify.initiator_port_protocols;
+	resp_data[15] = rphy->identify.target_port_protocols;
+}
+
+static void sas_report_phy_sata(struct sas_ha_struct *sas_ha, u8 *resp_data,
+				u8 phy_id)
+{
+	struct sas_rphy *rphy;
+	struct dev_to_host_fis *fis;
+	int i;
+
+	if (phy_id >= sas_ha->num_phys) {
+		resp_data[2] = SMP_RESP_NO_PHY;
+		return;
+	}
+
+	resp_data[2] = SMP_RESP_PHY_NO_SATA;
+
+	if (!sas_ha->sas_phy[phy_id]->port)
+		return;
+
+	rphy = sas_ha->sas_phy[phy_id]->port->port_dev->rphy;
+	fis = (struct dev_to_host_fis *)
+		sas_ha->sas_phy[phy_id]->port->port_dev->frame_rcvd;
+	if (rphy->identify.target_port_protocols != SAS_PROTOCOL_SATA)
+		return;
+
+	resp_data[2] = SMP_RESP_FUNC_ACC;
+	resp_data[9] = phy_id;
+	memcpy(resp_data + 16, sas_ha->sas_phy[phy_id]->attached_sas_addr,
+	       SAS_ADDR_SIZE);
+
+	/* check to see if we have a valid d2h fis */
+	if (fis->fis_type != 0x34)
+		return;
+
+	/* the d2h fis is required by the standard to be in LE format */
+	for (i = 0; i < 20; i += 4) {
+		u8 *dst = resp_data + 24 + i, *src =
+			&sas_ha->sas_phy[phy_id]->port->port_dev->frame_rcvd[i];
+		dst[0] = src[3];
+		dst[1] = src[2];
+		dst[2] = src[1];
+		dst[3] = src[0];
+	}
+}
+
+static void sas_phy_control(struct sas_ha_struct *sas_ha, u8 phy_id,
+			    u8 phy_op, enum sas_linkrate min,
+			    enum sas_linkrate max, u8 *resp_data)
+{
+	struct sas_internal *i =
+		to_sas_internal(sas_ha->core.shost->transportt);
+	struct sas_phy_linkrates rates;
+
+	if (phy_id >= sas_ha->num_phys) {
+		resp_data[2] = SMP_RESP_NO_PHY;
+		return;
+	}
+	switch (phy_op) {
+	case PHY_FUNC_NOP:
+	case PHY_FUNC_LINK_RESET:
+	case PHY_FUNC_HARD_RESET:
+	case PHY_FUNC_DISABLE:
+	case PHY_FUNC_CLEAR_ERROR_LOG:
+	case PHY_FUNC_CLEAR_AFFIL:
+	case PHY_FUNC_TX_SATA_PS_SIGNAL:
+		break;
+
+	default:
+		resp_data[2] = SMP_RESP_PHY_UNK_OP;
+		return;
+	}
+
+	rates.minimum_linkrate = min;
+	rates.maximum_linkrate = max;
+
+	if (i->dft->lldd_control_phy(sas_ha->sas_phy[phy_id], phy_op, &rates))
+		resp_data[2] = SMP_RESP_FUNC_FAILED;
+	else
+		resp_data[2] = SMP_RESP_FUNC_ACC;
+}
+
+int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
+			 struct request *rsp)
+{
+	u8 *req_data = NULL, *resp_data = NULL, *buf;
+	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
+	int error = -EINVAL;
+
+	/* eight is the minimum size for request and response frames */
+	if (req->data_len < 8 || rsp->data_len < 8)
+		goto out;
+
+	if (bio_offset(req->bio) + req->data_len > PAGE_SIZE ||
+	    bio_offset(rsp->bio) + rsp->data_len > PAGE_SIZE) {
+		shost_printk(KERN_ERR, shost,
+			"SMP request/response frame crosses page boundary");
+		goto out;
+	}
+
+	req_data = kzalloc(req->data_len, GFP_KERNEL);
+
+	/* make sure frame can always be built ... we copy
+	 * back only the requested length */
+	resp_data = kzalloc(max(rsp->data_len, 128U), GFP_KERNEL);
+
+	if (!req_data || !resp_data) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	local_irq_disable();
+	buf = kmap_atomic(bio_page(req->bio), KM_USER0) + bio_offset(req->bio);
+	memcpy(req_data, buf, req->data_len);
+	kunmap_atomic(buf - bio_offset(req->bio), KM_USER0);
+	local_irq_enable();
+
+	if (req_data[0] != SMP_REQUEST)
+		goto out;
+
+	/* always succeeds ... even if we can't process the request
+	 * the result is in the response frame */
+	error = 0;
+
+	/* set up default don't know response */
+	resp_data[0] = SMP_RESPONSE;
+	resp_data[1] = req_data[1];
+	resp_data[2] = SMP_RESP_FUNC_UNK;
+
+	switch (req_data[1]) {
+	case SMP_REPORT_GENERAL:
+		resp_data[2] = SMP_RESP_FUNC_ACC;
+		resp_data[9] = sas_ha->num_phys;
+		break;
+
+	case SMP_REPORT_MANUF_INFO:
+		resp_data[2] = SMP_RESP_FUNC_ACC;
+		memcpy(resp_data + 12, shost->hostt->name,
+		       SAS_EXPANDER_VENDOR_ID_LEN);
+		memcpy(resp_data + 20, "libsas virt phy",
+		       SAS_EXPANDER_PRODUCT_ID_LEN);
+		break;
+
+	case SMP_READ_GPIO_REG:
+		/* FIXME: need GPIO support in the transport class */
+		break;
+
+	case SMP_DISCOVER:
+		sas_host_smp_discover(sas_ha, resp_data, req_data[9]);
+		break;
+
+	case SMP_REPORT_PHY_ERR_LOG:
+		/* FIXME: could implement this with additional
+		 * libsas callbacks providing the HW supports it */
+		break;
+
+	case SMP_REPORT_PHY_SATA:
+		sas_report_phy_sata(sas_ha, resp_data, req_data[9]);
+		break;
+
+	case SMP_REPORT_ROUTE_INFO:
+		/* Can't implement; hosts have no routes */
+		break;
+
+	case SMP_WRITE_GPIO_REG:
+		/* FIXME: need GPIO support in the transport class */
+		break;
+
+	case SMP_CONF_ROUTE_INFO:
+		/* Can't implement; hosts have no routes */
+		break;
+
+	case SMP_PHY_CONTROL:
+		sas_phy_control(sas_ha, req_data[9], req_data[10],
+				req_data[32] >> 4, req_data[33] >> 4,
+				resp_data);
+		break;
+
+	case SMP_PHY_TEST_FUNCTION:
+		/* FIXME: should this be implemented? */
+		break;
+
+	default:
+		/* probably a 2.0 function */
+		break;
+	}
+
+	local_irq_disable();
+	buf = kmap_atomic(bio_page(rsp->bio), KM_USER0) + bio_offset(rsp->bio);
+	memcpy(buf, resp_data, rsp->data_len);
+	flush_kernel_dcache_page(bio_page(rsp->bio));
+	kunmap_atomic(buf - bio_offset(rsp->bio), KM_USER0);
+	local_irq_enable();
+
+ out:
+	kfree(req_data);
+	kfree(resp_data);
+	return error;
+}
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index baa0666..b4f9368 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -80,6 +80,20 @@ struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
 
 void sas_hae_reset(struct work_struct *work);
 
+#ifdef CONFIG_SCSI_SAS_HOST_SMP
+extern int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
+				struct request *rsp);
+#else
+static inline int sas_smp_host_handler(struct Scsi_Host *shost,
+				       struct request *req,
+				       struct request *rsp)
+{
+	shost_printk(KERN_ERR, shost,
+		"Cannot send SMP to a sas host (not enabled in CONFIG)\n");
+	return -EINVAL;
+}
+#endif
+
 static inline void sas_queue_event(int event, spinlock_t *lock,
 				   unsigned long *pending,
 				   struct work_struct *work,
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 007d929..09125fa 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -11,10 +11,10 @@ struct sas_rphy;
 struct request;
 
 enum sas_device_type {
-	SAS_PHY_UNUSED,
-	SAS_END_DEVICE,
-	SAS_EDGE_EXPANDER_DEVICE,
-	SAS_FANOUT_EXPANDER_DEVICE,
+	SAS_PHY_UNUSED = 0,
+	SAS_END_DEVICE = 1,
+	SAS_EDGE_EXPANDER_DEVICE = 2,
+	SAS_FANOUT_EXPANDER_DEVICE = 3,
 };
 
 static inline int sas_protocol_ata(enum sas_protocol proto)


