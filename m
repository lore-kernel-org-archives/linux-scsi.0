Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B00248F4F
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 05:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753249293; cv=none; b=QzrB7jwL/70aNfJ0md7YzhYPbmIC0WHXGEwAe+RCm09iW0AvZ27roxOq08aN1Pzt0Uj/tn+oGU12qSvRVSJTyyMIuys6RELDzaB7IYwK9RHUogwRK+j5MBu8nr7s311cCkfTcl3DgrxqXjXc9lnv0VpHYW1OrQr+WkAZqZ54TTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753249293; c=relaxed/simple;
	bh=7x6D73ej8i2oC2V2/BCGnmGEdtJz8aQnsubABu8j3kM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCpIWlogSqV26DAdmxLL/B02rW5pV+4bOdYgmh7CK3pd3q1+5PWRKtM0E0oTTE2rykhS16kNTVOCcS5io4Ld56OnaKWtmS/NmS6K+vpWWpt/4MeESMi0oslx2MCobMaml51W032EvKAMgRpYEcYxa9mM+FPduc4KzqW8FXBtoOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G047n+X2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G047n+X2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A15C4CEF1;
	Wed, 23 Jul 2025 05:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753249292;
	bh=7x6D73ej8i2oC2V2/BCGnmGEdtJz8aQnsubABu8j3kM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=G047n+X2W+1PxqRdif8UFe6sRL6JDEjBs7pllEHlL62uAX0KwJOJ20L5mg69Fazub
	 eAoa/vobYBSfcgvdfEvxqrD/yDaEPE537pLXLSCeqW1fhjm4JTBf/OPvxCEoyJsJqp
	 lTgdovcADlCW04JCIhFgwqYwN8MwiIcbzZsMNXb6gOcd1XusqqJVUaKhsofMDpljW7
	 iZZ/3MDETcnM30Qw+HFUjLJ8o4yUp3pqpO7qa13Fy9W9RXVdGPF8AJvqnhivcCQvf+
	 CEYZEvu168L3nU08My+YPFNVB1aCmHbecXy7npWuS9KWFHooFaImWRmTIkzeBdZqkz
	 L07/q8K1Xfrig==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH 3/4] scsi: libsas: Move declarations of internal functions to sas_internal.h
Date: Wed, 23 Jul 2025 14:39:02 +0900
Message-ID: <20250723053903.49413-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723053903.49413-1-dlemoal@kernel.org>
References: <20250723053903.49413-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the declaration of all functions used only within libsas from
include/scsi/sas_ata.h to drivers/scsi/libsas/sas_internal.h.

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/libsas/sas_internal.h | 68 ++++++++++++++++++++++++++++++
 include/scsi/sas_ata.h             | 63 +--------------------------
 2 files changed, 69 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index b7d8c0da0ad2..90ec541a1f75 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -223,15 +223,83 @@ static inline void sas_put_device(struct domain_device *dev)
 }
 
 #ifdef CONFIG_SCSI_SAS_ATA
+
+int sas_ata_init(struct domain_device *dev);
+void sas_ata_task_abort(struct sas_task *task);
+int sas_discover_sata(struct domain_device *dev);
+int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *phy,
+		    struct domain_device *child, int phy_id);
+void sas_ata_strategy_handler(struct Scsi_Host *shost);
+void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q);
+void sas_ata_end_eh(struct ata_port *ap);
+
 static inline void sas_ata_wait_eh(struct domain_device *dev)
 {
 	if (dev_is_sata(dev))
 		ata_port_wait_eh(dev->sata_dev.ap);
 }
+
+void sas_probe_sata(struct asd_sas_port *port);
+void sas_suspend_sata(struct asd_sas_port *port);
+void sas_resume_sata(struct asd_sas_port *port);
+
 #else
+
+static inline int sas_ata_init(struct domain_device *dev)
+{
+	return 0;
+}
+
+static inline void sas_ata_task_abort(struct sas_task *task)
+{
+}
+
+static inline void sas_ata_strategy_handler(struct Scsi_Host *shost)
+{
+}
+
+static inline void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q)
+{
+}
+
+static inline void sas_ata_end_eh(struct ata_port *ap)
+{
+}
+
 static inline void sas_ata_wait_eh(struct domain_device *dev)
 {
 }
+
+static inline void sas_probe_sata(struct asd_sas_port *port)
+{
+}
+
+static inline void sas_suspend_sata(struct asd_sas_port *port)
+{
+}
+
+static inline void sas_resume_sata(struct asd_sas_port *port)
+{
+}
+
+static inline void sas_ata_disabled_notice(void)
+{
+	pr_notice_once("ATA device seen but CONFIG_SCSI_SAS_ATA=N\n");
+}
+
+static inline int sas_discover_sata(struct domain_device *dev)
+{
+	sas_ata_disabled_notice();
+	return -ENXIO;
+}
+
+static inline int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *phy,
+				  struct domain_device *child, int phy_id)
+{
+	sas_ata_disabled_notice();
+	return -ENODEV;
+}
+
 #endif
 
 #endif /* _SAS_INTERNAL_H_ */
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index f8806de007ab..9df5607e1e6b 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -21,72 +21,24 @@ static inline int dev_is_sata(struct domain_device *dev)
 	       dev->dev_type == SAS_SATA_PM_PORT || dev->dev_type == SAS_SATA_PENDING;
 }
 
-int sas_ata_init(struct domain_device *dev);
-void sas_ata_task_abort(struct sas_task *task);
-void sas_ata_strategy_handler(struct Scsi_Host *shost);
-void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q);
 void sas_ata_schedule_reset(struct domain_device *dev);
-void sas_probe_sata(struct asd_sas_port *port);
-void sas_suspend_sata(struct asd_sas_port *port);
-void sas_resume_sata(struct asd_sas_port *port);
-void sas_ata_end_eh(struct ata_port *ap);
 void sas_ata_device_link_abort(struct domain_device *dev, bool force_reset);
-int sas_execute_ata_cmd(struct domain_device *device, u8 *fis,
-			int force_phy_id);
+int sas_execute_ata_cmd(struct domain_device *device, u8 *fis, int force_phy_id);
 int smp_ata_check_ready_type(struct ata_link *link);
-int sas_discover_sata(struct domain_device *dev);
-int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *phy,
-		    struct domain_device *child, int phy_id);
 
 extern const struct attribute_group sas_ata_sdev_attr_group;
 
 #else
 
-static inline void sas_ata_disabled_notice(void)
-{
-	pr_notice_once("ATA device seen but CONFIG_SCSI_SAS_ATA=N\n");
-}
-
 static inline int dev_is_sata(struct domain_device *dev)
 {
 	return 0;
 }
-static inline int sas_ata_init(struct domain_device *dev)
-{
-	return 0;
-}
-static inline void sas_ata_task_abort(struct sas_task *task)
-{
-}
-
-static inline void sas_ata_strategy_handler(struct Scsi_Host *shost)
-{
-}
-
-static inline void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q)
-{
-}
 
 static inline void sas_ata_schedule_reset(struct domain_device *dev)
 {
 }
 
-static inline void sas_probe_sata(struct asd_sas_port *port)
-{
-}
-
-static inline void sas_suspend_sata(struct asd_sas_port *port)
-{
-}
-
-static inline void sas_resume_sata(struct asd_sas_port *port)
-{
-}
-
-static inline void sas_ata_end_eh(struct ata_port *ap)
-{
-}
-
 static inline void sas_ata_device_link_abort(struct domain_device *dev,
 					     bool force_reset)
 {
@@ -103,19 +55,6 @@ static inline int smp_ata_check_ready_type(struct ata_link *link)
 	return 0;
 }
 
-static inline int sas_discover_sata(struct domain_device *dev)
-{
-	sas_ata_disabled_notice();
-	return -ENXIO;
-}
-
-static inline int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *phy,
-				  struct domain_device *child, int phy_id)
-{
-	sas_ata_disabled_notice();
-	return -ENODEV;
-}
-
 #define sas_ata_sdev_attr_group ((struct attribute_group) {})
 
 #endif
-- 
2.50.1

