Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD3E219A9B
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 05:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753249291; cv=none; b=ZxpYFQa38cC0X3wDOnk1JCLvGrL8mNcETJT7aa+e17oGA28jDYJYwynKU1v89XQ9T+eXGxdnTzg665WkZBcLWFcJFBMNWWaJ+NeIq0Vofwz/m174MUUzfGMx9NJ5lO+4pvnvV7bNz7mlumOIILa6eSKG49sX9w54WoPgu+15Z/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753249291; c=relaxed/simple;
	bh=awO+AEnIqTYFgJXDhp5OJR9H2v/QWzobO5dzT67x1vQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fplSsfGaDBm672T0D5pW7EjanNxjfSxOpjGK3KfoSLt0tZFc+yc8ZZERuugVLg6o3/ToMZCO8T7En9dweYTa9EET9qSMmaHLrSkEn3isM/iUAtQT0CFQRLhr/v/DWYrSWLlNGWSSwW026aMFjp4pDUoYzFPSc3atwWZhUGfu3lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sb0+ljx4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sb0+ljx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328A6C4CEF1;
	Wed, 23 Jul 2025 05:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753249291;
	bh=awO+AEnIqTYFgJXDhp5OJR9H2v/QWzobO5dzT67x1vQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sb0+ljx4N8nBRR921Mbpps8PsLug3cYZ6SrlsfOxAWrp+pK3SPsd1D2OEOMciWz9T
	 r5ke2Vzd0tXdco1IBuDf68aL7D/XbTFbJhC4D5gYBwtEZz1mDt11w3ZlrFrOGGXvTK
	 vUKE3pTgyeQ0Ln3E5kPl2r512drx3HbDUP4xe//qSirXhMbeXRxxwMAYb02/ce5tfC
	 P008CRxSxrNXpUylboazDI2WWch9A/vXrgYGIEqYWIppXZtI9JDpn0Q8ftPltwTwcF
	 dN5l69YGV3AKjpN5pfuv1XBOufst4itDJzEV3JnoohB/lHSLa47K4DYfCk7NKXb6IY
	 9/ffuqopQ6R+Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/4] scsi: libsas: Make sas_ata_wait_eh() inline
Date: Wed, 23 Jul 2025 14:39:00 +0900
Message-ID: <20250723053903.49413-2-dlemoal@kernel.org>
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

Simplify the code of sas_ata_wait_eh() and make this function inline,
moving its definition and stub definition to
drivers/scsi/libsas/sas_internal.h.

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/libsas/sas_ata.c      | 11 -----------
 drivers/scsi/libsas/sas_internal.h | 12 ++++++++++++
 include/scsi/sas_ata.h             |  5 -----
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 7b4e7a61965a..0afc9944d985 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -925,17 +925,6 @@ void sas_ata_schedule_reset(struct domain_device *dev)
 }
 EXPORT_SYMBOL_GPL(sas_ata_schedule_reset);
 
-void sas_ata_wait_eh(struct domain_device *dev)
-{
-	struct ata_port *ap;
-
-	if (!dev_is_sata(dev))
-		return;
-
-	ap = dev->sata_dev.ap;
-	ata_port_wait_eh(ap);
-}
-
 void sas_ata_device_link_abort(struct domain_device *device, bool force_reset)
 {
 	struct ata_port *ap = device->sata_dev.ap;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 03d6ec1eb970..b7d8c0da0ad2 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -222,4 +222,16 @@ static inline void sas_put_device(struct domain_device *dev)
 	kref_put(&dev->kref, sas_free_device);
 }
 
+#ifdef CONFIG_SCSI_SAS_ATA
+static inline void sas_ata_wait_eh(struct domain_device *dev)
+{
+	if (dev_is_sata(dev))
+		ata_port_wait_eh(dev->sata_dev.ap);
+}
+#else
+static inline void sas_ata_wait_eh(struct domain_device *dev)
+{
+}
+#endif
+
 #endif /* _SAS_INTERNAL_H_ */
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 92e27e7bf088..4317c39f77bb 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -27,7 +27,6 @@ void sas_ata_task_abort(struct sas_task *task);
 void sas_ata_strategy_handler(struct Scsi_Host *shost);
 void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q);
 void sas_ata_schedule_reset(struct domain_device *dev);
-void sas_ata_wait_eh(struct domain_device *dev);
 void sas_probe_sata(struct asd_sas_port *port);
 void sas_suspend_sata(struct asd_sas_port *port);
 void sas_resume_sata(struct asd_sas_port *port);
@@ -73,10 +72,6 @@ static inline void sas_ata_schedule_reset(struct domain_device *dev)
 {
 }
 
-static inline void sas_ata_wait_eh(struct domain_device *dev)
-{
-}
-
 static inline void sas_probe_sata(struct asd_sas_port *port)
 {
 }
-- 
2.50.1

