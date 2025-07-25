Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E9415E90
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 02:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753408850; cv=none; b=R1o14N66jGfVrbD8Y+e5Jw7aPTevRDTsg2VJpz+ZJk70vAijkK1CDtu1IqULlt09iNsKZt17qnlIUgZuAOdz2QManngd8OsIjdtTxLt2bQvayVigltup03awFo+jWotr9AVUaimqChmjpNL/Pk/BRXjEEYLIvx0P2t99u0C79ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753408850; c=relaxed/simple;
	bh=oPq0am38a3k2Gitk/kUvysvrroy39y43lK8PEvLoK6M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAEMtKiRNj0U+3NniXin33YrGxEYQxlZ9GdWbvq+uM9okBx2goh4br2aHUXWIZfcDLnDWlR5wwT7uf9kSagW+qEeFShL6/8B5QuMhDvczcvtw0fmJ/BGgNKYXLxEXQq0P5Ur8faMqncnLqe5aGDtW1pz1X3L9zNQsBBz3AeMHjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kxQ4mF3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kxQ4mF3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091A8C4CEEF;
	Fri, 25 Jul 2025 02:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753408849;
	bh=oPq0am38a3k2Gitk/kUvysvrroy39y43lK8PEvLoK6M=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kxQ4mF3HD5VefybgTAGbuv8sHbyNIUZxNl+s0hOFnXLRudmf+n5tCZxlxYn8pSqUJ
	 JZHGq1V+TzQlnscflFLCidbj3IdpousEENEMwXGzBHfCZlUor8x3NwXd5frdq6CJXe
	 BDlNYQc0vqBxy4q1nonnzC4GoRmCT6yODlGivj/8qhB2kKmQNJpmI3VYfoijWPsTmB
	 UdqG4bUwNZmNk9Bd6Rh8AZE1hRlcMkJVVxsZeXF3rBd5D5aqVWEPXEiGpmZ0RFXyJN
	 W9l4AxV1vnEj6M3P9xIDEux3YcTvQSSwZsB2SqvDQe1AuGRp5D5mnK2ID79UH420mH
	 5zXa7VfWvFC5w==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 4/5] scsi: libsas: Move declarations of internal functions to sas_internal.h
Date: Fri, 25 Jul 2025 10:58:17 +0900
Message-ID: <20250725015818.171252-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250725015818.171252-1-dlemoal@kernel.org>
References: <20250725015818.171252-1-dlemoal@kernel.org>
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

