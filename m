From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 20/28] libsas: sas_phy_enable via transport_sas_phy_reset
Date: Thu, 22 Dec 2011 19:00:13 -0800
Message-ID: <20111223030012.21827.61992.stgit@localhost6.localdomain6>
References: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Execute the link-reset triggered by sas_phy_enable via
transport_sas_phy_reset so that it can be managed by libata.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_init.c      |   56 ++++++++++++++++++++++++++++++-----
 drivers/scsi/libsas/sas_internal.h  |    3 ++
 drivers/scsi/libsas/sas_scsi_host.c |    1 -
 include/scsi/libsas.h               |    1 -
 4 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index f261e97..ca080a8 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -249,15 +249,15 @@ static int transport_sas_phy_reset(struct sas_phy *phy, int hard_reset)
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
@@ -266,15 +266,21 @@ int sas_phy_enable(struct sas_phy *phy, int enable)
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
@@ -357,6 +363,13 @@ static void phy_reset_work(struct work_struct *work)
 	d->reset_result = transport_sas_phy_reset(d->phy, d->hard_reset);
 }
 
+static void phy_enable_work(struct work_struct *work)
+{
+	struct sas_phy_data *d = container_of(work, typeof(*d), enable_work);
+
+	d->enable_result = sas_phy_enable(d->phy, d->enable);
+}
+
 static int sas_phy_setup(struct sas_phy *phy)
 {
 	struct sas_phy_data *d = kzalloc(sizeof(*d), GFP_KERNEL);
@@ -366,6 +379,7 @@ static int sas_phy_setup(struct sas_phy *phy)
 
 	mutex_init(&d->event_lock);
 	INIT_WORK(&d->reset_work, phy_reset_work);
+	INIT_WORK(&d->enable_work, phy_enable_work);
 	d->phy = phy;
 	phy->hostdata = d;
 
@@ -398,8 +412,34 @@ static int queue_phy_reset(struct sas_phy *phy, int hard_reset)
 	return rc;
 }
 
+static int queue_phy_enable(struct sas_phy *phy, int enable)
+{
+	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
+	struct sas_phy_data *d = phy->hostdata;
+	int rc;
+
+	if (!d)
+		return -ENOMEM;
+
+	/* libsas workqueue coordinates ata-eh reset with discovery */
+	mutex_lock(&d->event_lock);
+	d->enable_result = 0;
+	d->enable = enable;
+
+	spin_lock_irq(&ha->state_lock);
+	sas_queue_work(ha, &d->enable_work);
+	spin_unlock_irq(&ha->state_lock);
+
+	sas_drain_work(ha);
+	rc = d->enable_result;
+	mutex_unlock(&d->event_lock);
+
+	return rc;
+}
+
 static struct sas_function_template sft = {
-	.phy_enable = sas_phy_enable,
+	.phy_enable = queue_phy_enable,
 	.phy_reset = queue_phy_reset,
 	.phy_setup = sas_phy_setup,
 	.phy_release = sas_phy_release,
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 984de1c..cde1a84 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -45,6 +45,9 @@ struct sas_phy_data {
 	int hard_reset;
 	int reset_result;
 	struct work_struct reset_work;
+	int enable;
+	int enable_result;
+	struct work_struct enable_work;
 };
 
 void sas_scsi_recover_host(struct Scsi_Host *shost);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 57a3484..b849dcd 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1077,7 +1077,6 @@ EXPORT_SYMBOL_GPL(sas_change_queue_type);
 EXPORT_SYMBOL_GPL(sas_bios_param);
 EXPORT_SYMBOL_GPL(sas_task_abort);
 EXPORT_SYMBOL_GPL(sas_phy_reset);
-EXPORT_SYMBOL_GPL(sas_phy_enable);
 EXPORT_SYMBOL_GPL(sas_eh_device_reset_handler);
 EXPORT_SYMBOL_GPL(sas_eh_bus_reset_handler);
 EXPORT_SYMBOL_GPL(sas_slave_alloc);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3ac12eb..7ba7095 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -629,7 +629,6 @@ extern int sas_unregister_ha(struct sas_ha_struct *);
 
 int sas_set_phy_speed(struct sas_phy *phy,
 		      struct sas_phy_linkrates *rates);
-int sas_phy_enable(struct sas_phy *phy, int enabled);
 int sas_phy_reset(struct sas_phy *phy, int hard_reset);
 int sas_queue_up(struct sas_task *task);
 extern int sas_queuecommand(struct Scsi_Host * ,struct scsi_cmnd *);

