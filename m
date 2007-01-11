From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 04/21] libsas: Add a sysfs knob to enable/disable a phy
Date: Thu, 11 Jan 2007 14:14:57 -0800
Message-ID: <20070111221457.3543.17060.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57291 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbXAKWOj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:14:39 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMEcWi027210
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:38 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMEc6I286514
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:38 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMEbdZ001707
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:37 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


This patch lets a user arbitrarily enable or disable a phy via sysfs.
Potential applications include shutting down a phy to replace one
lane of wide port, and (more importantly) providing a method for the
libata SATL to control the phy.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_init.c      |   35 +++++++++++++++++++++++-
 drivers/scsi/libsas/sas_scsi_host.c |    1 +
 drivers/scsi/scsi_transport_sas.c   |   51 +++++++++++++++++++++++++++++++++++
 include/scsi/libsas.h               |    3 ++
 include/scsi/scsi_transport_sas.h   |    2 +
 5 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 2f0c07f..90cce34 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -146,6 +146,36 @@ static int sas_get_linkerrors(struct sas
 	return sas_smp_get_phy_events(phy);
 }
 
+int sas_phy_enable(struct sas_phy *phy, int enable)
+{
+	int ret;
+	enum phy_func command;
+
+	if (enable)
+		command = PHY_FUNC_LINK_RESET;
+	else
+		command = PHY_FUNC_DISABLE;
+
+	if (scsi_is_sas_phy_local(phy)) {
+		struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+		struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
+		struct asd_sas_phy *asd_phy = sas_ha->sas_phy[phy->number];
+		struct sas_internal *i =
+			to_sas_internal(sas_ha->core.shost->transportt);
+
+		if (!enable) {
+			sas_phy_disconnected(asd_phy);
+			sas_ha->notify_phy_event(asd_phy, PHYE_LOSS_OF_SIGNAL);
+		}
+		ret = i->dft->lldd_control_phy(asd_phy, command, NULL);
+	} else {
+		struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
+		struct domain_device *ddev = sas_find_dev_by_rphy(rphy);
+		ret = sas_smp_phy_control(ddev, phy->number, command, NULL);
+	}
+	return ret;
+}
+
 int sas_phy_reset(struct sas_phy *phy, int hard_reset)
 {
 	int ret;
@@ -172,8 +202,8 @@ int sas_phy_reset(struct sas_phy *phy, i
 	return ret;
 }
 
-static int sas_set_phy_speed(struct sas_phy *phy,
-			     struct sas_phy_linkrates *rates)
+int sas_set_phy_speed(struct sas_phy *phy,
+		      struct sas_phy_linkrates *rates)
 {
 	int ret;
 
@@ -212,6 +242,7 @@ static int sas_set_phy_speed(struct sas_
 }
 
 static struct sas_function_template sft = {
+	.phy_enable = sas_phy_enable,
 	.phy_reset = sas_phy_reset,
 	.set_phy_speed = sas_set_phy_speed,
 	.get_linkerrors = sas_get_linkerrors,
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 21bd247..7774eb3 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -875,3 +875,4 @@ EXPORT_SYMBOL_GPL(sas_change_queue_type)
 EXPORT_SYMBOL_GPL(sas_bios_param);
 EXPORT_SYMBOL_GPL(sas_task_abort);
 EXPORT_SYMBOL_GPL(sas_phy_reset);
+EXPORT_SYMBOL_GPL(sas_phy_enable);
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 5c0b75b..9e38c18 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -336,6 +336,51 @@ show_sas_device_type(struct class_device
 }
 static CLASS_DEVICE_ATTR(device_type, S_IRUGO, show_sas_device_type, NULL);
 
+static ssize_t do_sas_phy_enable(struct class_device *cdev,
+		size_t count, int enable)
+{
+	struct sas_phy *phy = transport_class_to_phy(cdev);
+	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+	struct sas_internal *i = to_sas_internal(shost->transportt);
+	int error;
+
+	error = i->f->phy_enable(phy, enable);
+	if (error)
+		return error;
+	phy->enabled = enable;
+	return count;
+};
+
+static ssize_t store_sas_phy_enable(struct class_device *cdev,
+		const char *buf, size_t count)
+{
+	if (count < 1)
+		return -EINVAL;
+
+	switch (buf[0]) {
+	case '0':
+		do_sas_phy_enable(cdev, count, 0);
+		break;
+	case '1':
+		do_sas_phy_enable(cdev, count, 1);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static ssize_t show_sas_phy_enable(struct class_device *cdev, char *buf)
+{
+	struct sas_phy *phy = transport_class_to_phy(cdev);
+
+	return snprintf(buf, 20, "%d", phy->enabled);
+}
+
+static CLASS_DEVICE_ATTR(enable, S_IRUGO | S_IWUSR, show_sas_phy_enable,
+			 store_sas_phy_enable);
+
 static ssize_t do_sas_phy_reset(struct class_device *cdev,
 		size_t count, int hard_reset)
 {
@@ -435,6 +480,7 @@ struct sas_phy *sas_phy_alloc(struct dev
 		return NULL;
 
 	phy->number = number;
+	phy->enabled = 1;
 
 	device_initialize(&phy->dev);
 	phy->dev.parent = get_device(parent);
@@ -1389,6 +1435,10 @@ #define SETUP_PHY_ATTRIBUTE_RW(field)			
 	SETUP_TEMPLATE_RW(phy_attrs, field, S_IRUGO | S_IWUSR, 1,	\
 			!i->f->set_phy_speed, S_IRUGO)
 
+#define SETUP_OPTIONAL_PHY_ATTRIBUTE_RW(field, func)			\
+	SETUP_TEMPLATE_RW(phy_attrs, field, S_IRUGO | S_IWUSR, 1,	\
+			  !i->f->func, S_IRUGO)
+
 #define SETUP_PORT_ATTRIBUTE(field)					\
 	SETUP_TEMPLATE(port_attrs, field, S_IRUGO, 1)
 
@@ -1479,6 +1529,7 @@ sas_attach_transport(struct sas_function
 	SETUP_PHY_ATTRIBUTE(phy_reset_problem_count);
 	SETUP_OPTIONAL_PHY_ATTRIBUTE_WRONLY(link_reset, phy_reset);
 	SETUP_OPTIONAL_PHY_ATTRIBUTE_WRONLY(hard_reset, phy_reset);
+	SETUP_OPTIONAL_PHY_ATTRIBUTE_RW(enable, phy_enable);
 	i->phy_attrs[count] = NULL;
 
 	count = 0;
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index da96bcf..0689d66 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -614,6 +614,9 @@ struct sas_domain_function_template {
 extern int sas_register_ha(struct sas_ha_struct *);
 extern int sas_unregister_ha(struct sas_ha_struct *);
 
+int sas_set_phy_speed(struct sas_phy *phy,
+		      struct sas_phy_linkrates *rates);
+int sas_phy_enable(struct sas_phy *phy, int enabled);
 int sas_phy_reset(struct sas_phy *phy, int hard_reset);
 extern int sas_queuecommand(struct scsi_cmnd *,
 		     void (*scsi_done)(struct scsi_cmnd *));
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 59633a8..45d5859 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -54,6 +54,7 @@ struct sas_identify {
 struct sas_phy {
 	struct device		dev;
 	int			number;
+	int			enabled;
 
 	/* phy identification */
 	struct sas_identify	identify;
@@ -163,6 +164,7 @@ struct sas_function_template {
 	int (*get_enclosure_identifier)(struct sas_rphy *, u64 *);
 	int (*get_bay_identifier)(struct sas_rphy *);
 	int (*phy_reset)(struct sas_phy *, int);
+	int (*phy_enable)(struct sas_phy *, int);
 	int (*set_phy_speed)(struct sas_phy *, struct sas_phy_linkrates *);
 };
 
