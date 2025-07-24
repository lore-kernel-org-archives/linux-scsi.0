Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C47C147
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 00:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753315507; cv=none; b=mkIFxfgRHGxyoHffkz5z1l0UnLfEnQdWLSZ5Ka3QgXpS79hhQDcXMoxwLXFxUkMgmXAgt/2C74ub76Zj2k2qRW3d8NLoT1PWwKCVUmN8hl1pkx/x+cijNEaK2DR7m7/rIsiPCmv3kL5KJmu3kpHOqUQTUMoPVx5RAyMK1W3XRw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753315507; c=relaxed/simple;
	bh=oPq0am38a3k2Gitk/kUvysvrroy39y43lK8PEvLoK6M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dc8ovv4HIOsQ6ajP8rPd3qSNb3Z9tTu4geFDz0hw2+T5wsKOm/osB/vF+U7LlcmWITiYdeC62fvE8aodBPtYASbWmdNAuMaGNK/zLvLnpagUDLt7vVLHxdbC48qj9ZsG2DEZpfqSkusjJUhQcbJVXR6/ySL8WIjECyUsbqHrjoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rGbSK/D5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rGbSK/D5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B42C4CEEF;
	Thu, 24 Jul 2025 00:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753315505;
	bh=oPq0am38a3k2Gitk/kUvysvrroy39y43lK8PEvLoK6M=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=rGbSK/D5uTRLMS7p7avSToLF0pbp/0jkLynkixqBqs+9gDvbX3R787C1pIAfgqeBz
	 3U4DS2ViUF4FKHPwVcHoI7Pz9SZdTFPIrDGC43v5HTnYhnB7alpUu9c1R/J5HiS54d
	 wA2uddTxbXFxqAijY6hI0aNRskUQJNImGTjrEpgV/JvnDYnqydKpSjWM9XEcsc+F8W
	 YyJ1zhEL8cxkWSKDd0BtCYqUcWyyqBO8omruQhWZYVNoD+z6qvUwa6xwBpXVZEFU6l
	 l/unPMiOBRXLgCQUE8OnngxgRZerV8fx42ZDwsaedwkz+T7oH5rt9N77YwICE3VGJT
	 Phn5oWcB8P3dg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 4/5] scsi: libsas: Move declarations of internal functions to sas_internal.h
Date: Thu, 24 Jul 2025 09:02:34 +0900
Message-ID: <20250724000235.143460-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250724000235.143460-1-dlemoal@kernel.org>
References: <20250724000235.143460-1-dlemoal@kernel.org>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/libsas/sas_internal.h | 74 ++++++++++++++++++++++++++++++
 include/scsi/sas_ata.h             | 68 +--------------------------
 2 files changed, 75 insertions(+), 67 deletions(-)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 03d6ec1eb970..16f8d81d7531 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -222,4 +222,78 @@ static inline void sas_put_device(struct domain_device *dev)
 	kref_put(&dev->kref, sas_free_device);
 }
 
+#ifdef CONFIG_SCSI_SAS_ATA
+
+int sas_ata_init(struct domain_device *dev);
+void sas_ata_task_abort(struct sas_task *task);
+int sas_discover_sata(struct domain_device *dev);
+int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *phy,
+		    struct domain_device *child, int phy_id);
+void sas_ata_strategy_handler(struct Scsi_Host *shost);
+void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q);
+void sas_ata_end_eh(struct ata_port *ap);
+void sas_ata_wait_eh(struct domain_device *dev);
+void sas_probe_sata(struct asd_sas_port *port);
+void sas_suspend_sata(struct asd_sas_port *port);
+void sas_resume_sata(struct asd_sas_port *port);
+
+#else
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
+static inline void sas_ata_wait_eh(struct domain_device *dev)
+{
+}
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
+#endif
+
 #endif /* _SAS_INTERNAL_H_ */
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 5e3475975aee..a161c0222931 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -28,77 +28,24 @@ static inline bool dev_is_sata(struct domain_device *dev)
 	}
 }
 
-int sas_ata_init(struct domain_device *dev);
-void sas_ata_task_abort(struct sas_task *task);
-void sas_ata_strategy_handler(struct Scsi_Host *shost);
-void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q);
 void sas_ata_schedule_reset(struct domain_device *dev);
-void sas_ata_wait_eh(struct domain_device *dev);
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
 static inline bool dev_is_sata(struct domain_device *dev)
 {
 	return false;
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
 
-static inline void sas_ata_wait_eh(struct domain_device *dev)
-{
-}
-
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
@@ -115,19 +62,6 @@ static inline int smp_ata_check_ready_type(struct ata_link *link)
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

