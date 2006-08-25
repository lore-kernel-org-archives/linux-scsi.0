From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic94xx: add link error counts to the expander phys
Date: Fri, 25 Aug 2006 17:51:24 -0500
Message-ID: <1156546284.3462.23.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:17096 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751575AbWHYWv2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Aug 2006 18:51:28 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k7PMpP510573
	for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2006 18:51:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Unfortunately, the aic94xx seems to keep none of these mandatory error
counts for the HBA phys, but the transport class can still get them from
all the expanders using the REPORT_ERROR_LOG SMP function.

James

Index: BUILD-2.6/drivers/scsi/libsas/sas_init.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_init.c	2006-08-25 16:18:41.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_init.c	2006-08-25 17:42:38.000000000 -0500
@@ -132,6 +132,16 @@
 	return 0;
 }
 
+static int sas_get_linkerrors(struct sas_phy *phy)
+{
+	if (scsi_is_sas_phy_local(phy))
+		/* FIXME: we have no local phy stats
+		 * gathering at this time */
+		return -EINVAL;
+
+	return sas_smp_get_phy_events(phy);
+}
+
 static int sas_phy_reset(struct sas_phy *phy, int hard_reset)
 {
 	int ret;
@@ -160,6 +170,7 @@
 
 static struct sas_function_template sft = {
 	.phy_reset = sas_phy_reset,
+	.get_linkerrors = sas_get_linkerrors,
 };
 
 extern struct scsi_transport_template *
Index: BUILD-2.6/drivers/scsi/libsas/sas_expander.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_expander.c	2006-08-25 16:23:05.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_expander.c	2006-08-25 17:48:45.000000000 -0500
@@ -502,6 +502,39 @@
 	return 0;
 }
 
+#define RPEL_REQ_SIZE	16
+#define RPEL_RESP_SIZE	32
+int sas_smp_get_phy_events(struct sas_phy *phy)
+{
+	int res;
+	struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
+	struct domain_device *dev = sas_find_dev_by_rphy(rphy);
+	u8 *req = alloc_smp_req(RPEL_REQ_SIZE);
+	u8 *resp = kzalloc(RPEL_RESP_SIZE, GFP_KERNEL);
+
+	if (!resp)
+		return -ENOMEM;
+
+	req[1] = SMP_REPORT_PHY_ERR_LOG;
+	req[9] = phy->number;
+
+	res = smp_execute_task(dev, req, RPEL_REQ_SIZE,
+			            resp, RPEL_RESP_SIZE);
+
+	if (!res)
+		goto out;
+
+	phy->invalid_dword_count = scsi_to_u32(&resp[12]);
+	phy->running_disparity_error_count = scsi_to_u32(&resp[16]);
+	phy->loss_of_dword_sync_count = scsi_to_u32(&resp[20]);
+	phy->phy_reset_problem_count = scsi_to_u32(&resp[24]);
+
+ out:
+	kfree(resp);
+	return res;
+
+}
+
 #define RPS_REQ_SIZE  16
 #define RPS_RESP_SIZE 60
 
Index: BUILD-2.6/include/scsi/scsi.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi.h	2006-08-25 16:57:26.000000000 -0500
+++ BUILD-2.6/include/scsi/scsi.h	2006-08-25 16:59:32.000000000 -0500
@@ -429,4 +429,10 @@
 /* Used to obtain the PCI location of a device */
 #define SCSI_IOCTL_GET_PCI		0x5387
 
+/* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
+static inline u32 scsi_to_u32(u8 *ptr)
+{
+	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
+}
+
 #endif /* _SCSI_SCSI_H */
Index: BUILD-2.6/drivers/scsi/libsas/sas_internal.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_internal.h	2006-08-25 17:02:42.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_internal.h	2006-08-25 17:43:25.000000000 -0500
@@ -26,6 +26,7 @@
 #ifndef _SAS_INTERNAL_H_
 #define _SAS_INTERNAL_H_
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_sas.h>
 #include <scsi/libsas.h>
@@ -70,6 +71,7 @@
 
 int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 			enum phy_func phy_func);
+int sas_smp_get_phy_events(struct sas_phy *phy);
 
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
 


