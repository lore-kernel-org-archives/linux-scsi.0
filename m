From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 20/24] libsas: sas_phy_enable via transport_sas_phy_reset
Date: Fri, 16 Dec 2011 18:34:51 -0800
Message-ID: <20111217023451.15036.48402.stgit@localhost6.localdomain6>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50405 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab1LQCew (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 21:34:52 -0500
In-Reply-To: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

Execute the link-reset triggered by sas_phy_enable via
transport_sas_phy_reset so that it can be managed by libata.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_init.c      |   20 +++++++++++++-------
 drivers/scsi/libsas/sas_scsi_host.c |    1 -
 drivers/scsi/scsi_transport_sas.c   |   26 ++++++++++++++++++--------
 include/scsi/libsas.h               |    1 -
 include/scsi/scsi_transport_sas.h   |    3 +++
 5 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 2b8c09e..e461b98 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -245,15 +245,15 @@ static int transport_sas_phy_reset(struct sas_phy *phy, int hard_reset)
 	return ret;
 }
 
-int sas_phy_enable(struct sas_phy *phy, int enable)
+static int sas_phy_enable(struct sas_phy *phy, int enable)
 {
 	int ret;
-	enum phy_func command;
+	enum phy_func cmd;
 
 	if (enable)
-		command = PHY_FUNC_LINK_RESET;
+		cmd = PHY_FUNC_LINK_RESET;
 	else
-		command = PHY_FUNC_DISABLE;
+		cmd = PHY_FUNC_DISABLE;
 
 	if (scsi_is_sas_phy_local(phy)) {
 		struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
@@ -262,15 +262,21 @@ int sas_phy_enable(struct sas_phy *phy, int enable)
 		struct sas_internal *i =
 			to_sas_internal(sas_ha->core.shost->transportt);
 
-		if (!enable) {
+		if (enable)
+			ret = transport_sas_phy_reset(phy, 0);
+		else {
 			sas_phy_disconnected(asd_phy);
 			sas_ha->notify_phy_event(asd_phy, PHYE_LOSS_OF_SIGNAL);
+			ret = i->dft->lldd_control_phy(asd_phy, cmd, NULL);
 		}
-		ret = i->dft->lldd_control_phy(asd_phy, command, NULL);
 	} else {
 		struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
 		struct domain_device *ddev = sas_find_dev_by_rphy(rphy);
-		ret = sas_smp_phy_control(ddev, phy->number, command, NULL);
+
+		if (enable)
+			ret = transport_sas_phy_reset(phy, 0);
+		else
+			ret = sas_smp_phy_control(ddev, phy->number, cmd, NULL);
 	}
 	return ret;
 }
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index e51a909..2061e53 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1083,7 +1083,6 @@ EXPORT_SYMBOL_GPL(sas_change_queue_type);
 EXPORT_SYMBOL_GPL(sas_bios_param);
 EXPORT_SYMBOL_GPL(sas_task_abort);
 EXPORT_SYMBOL_GPL(sas_phy_reset);
-EXPORT_SYMBOL_GPL(sas_phy_enable);
 EXPORT_SYMBOL_GPL(sas_eh_device_reset_handler);
 EXPORT_SYMBOL_GPL(sas_eh_bus_reset_handler);
 EXPORT_SYMBOL_GPL(sas_slave_alloc);
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 760b80b..45ab52b 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -556,20 +556,20 @@ show_sas_device_type(struct device *dev,
 }
 static DEVICE_ATTR(device_type, S_IRUGO, show_sas_device_type, NULL);
 
-static ssize_t do_sas_phy_enable(struct device *dev,
-		size_t count, int enable)
+static ssize_t do_sas_phy_enable(struct device *dev, size_t count, int enable)
 {
 	struct sas_phy *phy = transport_class_to_phy(dev);
 	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
-	struct sas_internal *i = to_sas_internal(shost->transportt);
-	int error;
 
-	error = i->f->phy_enable(phy, enable);
-	if (error)
-		return error;
+	phy->enable = enable;
+	phy->enable_result = 0;
+	scsi_queue_work(shost, &phy->enable_work);
+	scsi_flush_work(shost);
+	if (phy->enable_result)
+		return phy->enable_result;
 	phy->enabled = enable;
 	return count;
-};
+}
 
 static ssize_t
 store_sas_phy_enable(struct device *dev, struct device_attribute *attr,
@@ -695,6 +695,15 @@ static void sas_phy_reset_work(struct work_struct *work)
 	phy->reset_result = i->f->phy_reset(phy, phy->hard_reset);
 }
 
+static void sas_phy_enable_work(struct work_struct *work)
+{
+	struct sas_phy *phy = container_of(work, typeof(*phy), enable_work);
+	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+	struct sas_internal *i = to_sas_internal(shost->transportt);
+
+	phy->enable_result = i->f->phy_enable(phy, phy->enable);
+}
+
 /**
  * sas_phy_alloc  -  allocates and initialize a SAS PHY structure
  * @parent:	Parent device
@@ -724,6 +733,7 @@ struct sas_phy *sas_phy_alloc(struct device *parent, int number)
 	phy->dev.release = sas_phy_release;
 	INIT_LIST_HEAD(&phy->port_siblings);
 	INIT_WORK(&phy->reset_work, sas_phy_reset_work);
+	INIT_WORK(&phy->enable_work, sas_phy_enable_work);
 	if (scsi_is_sas_expander_device(parent)) {
 		struct sas_rphy *rphy = dev_to_rphy(parent);
 		dev_set_name(&phy->dev, "phy-%d:%d:%d", shost->host_no,
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3ffc605..6e8f25d 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -624,7 +624,6 @@ extern int sas_unregister_ha(struct sas_ha_struct *);
 
 int sas_set_phy_speed(struct sas_phy *phy,
 		      struct sas_phy_linkrates *rates);
-int sas_phy_enable(struct sas_phy *phy, int enabled);
 int sas_phy_reset(struct sas_phy *phy, int hard_reset);
 int sas_queue_up(struct sas_task *task);
 extern int sas_queuecommand(struct Scsi_Host * ,struct scsi_cmnd *);
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index c7eea0d..698e383 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -78,6 +78,9 @@ struct sas_phy {
 	int			hard_reset;
 	int			reset_result;
 	struct work_struct      reset_work;
+	int			enable;
+	int			enable_result;
+	struct work_struct	enable_work;
 };
 
 #define dev_to_phy(d) \

