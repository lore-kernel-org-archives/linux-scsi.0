Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B5D47B41C;
	Tue, 12 May 2026 07:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778570035; cv=none; b=L2wfl9vcgIHlrm3saVI5sQS0a/F2ipee0NUiBNOl3MTNQi+gWgn+zSN7TUlPrkr4qmOx4fjN6Dd3lPnesGxDOBbWP/Xznv0o+fQoKb5UESJBWTzoaZR+pLh7/W9aAm6TLHZJ5nY8O69KXP89lmO1YZF+S/CRaNvj9KmxTVG0RYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778570035; c=relaxed/simple;
	bh=u5cvvYmSTXwLfVAY8VRFTKz0xXwZlQoJozXx2VI9Xvw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t8T/1HW7fXyuY6ZChYq1/ewg9py+ObKYktbTxYaK6lGRewljcshr+Eot3MlcTfwrf4FKT2gRwuSeisMGLxzQeT1gZvZD6Q113jefpLCyd5uyvzltHytK5IKMIRCy5luU0VyEygtFMeZx2l+FpOPjdKt7+DVEFJp8DumVhmITGM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=gfUurRMs; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="gfUurRMs"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VdICtDzLasMnSUjGnZuUa/mDFx5fa6KCrls252g42Nw=;
	b=gfUurRMsPNCiZZCr8w5eo5ljoRfaM632a6L8Rq5xN24gAztsGKogPmXawV9GP/04e+rX4S00S
	B8J4yI18oWHAkU+rEnXltFr4uiMJw1HD+LGYp2VJNeMtR3xlrDW6aO9k4eo/yKxEzRzW8GmByUx
	erb/4NHww8i+fSnKyj5r1a8=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gF71S6k0VznTVK;
	Tue, 12 May 2026 15:06:36 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 56A544056E;
	Tue, 12 May 2026 15:13:40 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 12 May 2026 15:13:39 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH] scsi: libsas: handle linkrate change in sas_rediscover_dev
Date: Tue, 12 May 2026 15:12:26 +0800
Message-ID: <20260512071226.2299741-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj100018.china.huawei.com (7.202.194.12)

When a device attached to an expander phy experiences a linkrate change
(e.g., due to cable reconnection or negotiation), the current code in
sas_rediscover_dev() treats it as "broadcast flutter" and takes no action
if the SAS address and device type remain unchanged.

However, for drivers like hisi_sas, the ITCT entry needs to be updated to
reflect the new linkrate. Without this update, the hardware continues
using stale linkrate information, which can cause performance issues or
protocol errors.

This patch introduces a new LLDD callback lldd_dev_info_update() to notify
the low-level driver when a device's linkrate changes, allowing the driver
to update its hardware structures accordingly.

Additionally, refactor sas_ex_to_ata() to use a new helper function
sas_ex_to_dev() which returns any device type attached to an expander phy,
improving code reuse.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 16 ++++++++++++++++
 drivers/scsi/libsas/sas_discover.c    | 12 ++++++++++++
 drivers/scsi/libsas/sas_expander.c    | 25 +++++++++++++++++++------
 drivers/scsi/libsas/sas_internal.h    |  2 ++
 include/scsi/libsas.h                 |  1 +
 5 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 944ce19ae2fc..459a71c3f8b0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -900,6 +900,21 @@ static int hisi_sas_dev_found(struct domain_device *device)
 	return rc;
 }
 
+static void hisi_sas_dev_info_update(struct domain_device *device)
+{
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct device *dev = hisi_hba->dev;
+
+	if (!sas_dev)
+		return;
+
+	dev_info(dev, "%016llx update itct\n",
+		SAS_ADDR(device->sas_addr));
+	hisi_hba->hw->clear_itct(hisi_hba, sas_dev);
+	hisi_hba->hw->setup_itct(hisi_hba, sas_dev);
+}
+
 int hisi_sas_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
 {
 	struct domain_device *dev = sdev_to_domain_dev(sdev);
@@ -2168,6 +2183,7 @@ EXPORT_SYMBOL_GPL(hisi_sas_stt);
 static struct sas_domain_function_template hisi_sas_transport_ops = {
 	.lldd_dev_found		= hisi_sas_dev_found,
 	.lldd_dev_gone		= hisi_sas_dev_gone,
+	.lldd_dev_info_update	= hisi_sas_dev_info_update,
 	.lldd_execute_task	= hisi_sas_queue_command,
 	.lldd_control_phy	= hisi_sas_control_phy,
 	.lldd_abort_task	= hisi_sas_abort_task,
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index b07062db50b2..60be59c45508 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -204,6 +204,18 @@ void sas_notify_lldd_dev_gone(struct domain_device *dev)
 	}
 }
 
+void sas_notify_lldd_dev_info_update(struct domain_device *dev)
+{
+	struct sas_ha_struct *sas_ha = dev->port->ha;
+	struct Scsi_Host *shost = sas_ha->shost;
+	struct sas_internal *i = to_sas_internal(shost->transportt);
+
+	if (!i->dft->lldd_dev_info_update)
+		return;
+
+	i->dft->lldd_dev_info_update(dev);
+}
+
 static void sas_probe_devices(struct asd_sas_port *port)
 {
 	struct domain_device *dev, *n;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index f471ab464a78..f1c6fdbcbe05 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -345,11 +345,9 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 		 SAS_ADDR(phy->attached_sas_addr), type);
 }
 
-/* check if we have an existing attached ata device on this expander phy */
-struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
+struct domain_device *sas_ex_to_dev(struct domain_device *ex_dev, int phy_id)
 {
 	struct ex_phy *ex_phy = &ex_dev->ex_dev.ex_phy[phy_id];
-	struct domain_device *dev;
 	struct sas_rphy *rphy;
 
 	if (!ex_phy->port)
@@ -359,7 +357,13 @@ struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
 	if (!rphy)
 		return NULL;
 
-	dev = sas_find_dev_by_rphy(rphy);
+	return sas_find_dev_by_rphy(rphy);
+}
+
+/* check if we have an existing attached ata device on this expander phy */
+struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
+{
+	struct domain_device *dev = sas_ex_to_dev(ex_dev, phy_id);
 
 	if (dev && dev_is_sata(dev))
 		return dev;
@@ -2013,13 +2017,22 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
 		goto out_free_resp;
 	} else if (SAS_ADDR(sas_addr) == SAS_ADDR(phy->attached_sas_addr) &&
 		   dev_type_flutter(type, phy->attached_dev_type)) {
-		struct domain_device *ata_dev = sas_ex_to_ata(dev, phy_id);
+		struct domain_device *child_dev = sas_ex_to_dev(dev, phy_id);
 		char *action = "";
 
 		sas_ex_phy_discover(dev, phy_id);
 
-		if (ata_dev && phy->attached_dev_type == SAS_SATA_PENDING)
+		if (child_dev && dev_is_sata(child_dev) &&
+		    phy->attached_dev_type == SAS_SATA_PENDING)
 			action = ", needs recovery";
+		else if (child_dev && child_dev->linkrate != phy->linkrate) {
+			pr_debug("ex %016llx phy%02d linkrate changed from %d to %d\n",
+				 SAS_ADDR(dev->sas_addr), phy_id,
+				 child_dev->linkrate, phy->linkrate);
+			child_dev->linkrate = phy->linkrate;
+			sas_notify_lldd_dev_info_update(child_dev);
+		}
+
 		pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
 			 SAS_ADDR(dev->sas_addr), phy_id, action);
 		goto out_free_resp;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 7dce0f587149..9ee37b8abd78 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -82,6 +82,7 @@ bool sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw);
 
 int sas_notify_lldd_dev_found(struct domain_device *);
 void sas_notify_lldd_dev_gone(struct domain_device *);
+void sas_notify_lldd_dev_info_update(struct domain_device *dev);
 
 void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		struct sas_rphy *rphy);
@@ -91,6 +92,7 @@ int sas_smp_get_phy_events(struct sas_phy *phy);
 
 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
+struct domain_device *sas_ex_to_dev(struct domain_device *ex_dev, int phy_id);
 struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
 int sas_ex_phy_discover(struct domain_device *dev, int single);
 int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 163f23c92b41..973b4445b7e0 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -674,6 +674,7 @@ struct sas_domain_function_template {
 	/* GPIO support */
 	int (*lldd_write_gpio)(struct sas_ha_struct *, u8 reg_type,
 			       u8 reg_index, u8 reg_count, u8 *write_data);
+	void (*lldd_dev_info_update)(struct domain_device *dev);
 };
 
 extern int sas_register_ha(struct sas_ha_struct *);
-- 
2.43.0

