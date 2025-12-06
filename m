Received: from out30-87.freemail.mail.aliyun.com (out30-87.freemail.mail.aliyun.com [115.124.30.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B9021D59C;
	Sat,  6 Dec 2025 06:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765001189; cv=none; b=QChsK0iv+kioNQevCyvgXHbIb/LLATOCL5LCgErr+sS7E7WoARpjBRzs4ZmBpy5WXjwiJziuATnkaNwIzb/PDzGbmPsq+NVUSw0qgb7slWwgWSLcNa7ZkRAXgUGycrar88Y73CLtIsqXxQm6T5/K+YlD4dE1ZVrXwq/RgCUGJI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765001189; c=relaxed/simple;
	bh=enUE8DBAcw1FTEUqLnvz3ybgxghL53DX3S27mXskn3M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=h+hInFxckVsQ8U5beI35RsP2Hxtkq0EyBgd1+JTPTT//FP4uHT8oyrUGreT1NuVFvl20ub+3tsVwjzacRMbHSLuKQnlkKV5VDWY4HvZe4v2pn/5TByMdqffUsEuYE3tgw97JCZ8eyZK5uYrAgLXHOA0au/2QSt+AsClg1v/4L3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=bMWPACw1; arc=none smtp.client-ip=115.124.30.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="bMWPACw1"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1765001183; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=uqhJStpDbxY9Ts7cUN/tAC36capxmQxHCWH+vP0Em+c=;
	b=bMWPACw1nvqvNtqoYI6PAtEhcvopzRtGFmPygjMKpRv5OVw9YxZSHQXOm0CuZ6UmRMW+sFueY/LtKTc38AAN81n/oimnY4bqxTVgbgap3iuJEex42DdtapPo5Bk33Nb/cCI/jpLlaEFQEoDG8RQH0uN1rgPGWokna7SDRW37POw=
Received: from LAPTOP-RK2E6KJ3.localdomain(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0WuA6aEn_1765001179 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 06 Dec 2025 14:06:23 +0800
From: wdhh6 <wdhh6@aliyun.com>
To: john.g.garry@oracle.com,
	yanaijie@huawei.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	wdhh6@aliyun.com,
	dlemoal@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: libsas: Add rollback handling in the sas_register_phys() and sas_register_ha() when an error occurs.
Date: Sat,  6 Dec 2025 14:06:16 +0800
Message-Id: <20251206060616.69216-1-wdhh6@aliyun.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chaohai Chen <wdhh6@aliyun.com>

In sas_register_phys(), if an error is triggered in the loop process,
we need to rollback the resources that have already been requested.

Add the sas_unregister_phys() when an error occurs in
sas_register_ha().

Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
---
v1: https://lore.kernel.org/r/20251205080252.1020028-1-wdhh6@aliyun.com
v2->v1: 
- Call the label using a descriptive name in sas_register_phys() (Damien Le Moal);
- Complete Undo_phys label in sas_register_ha (Jason Yan);
- Fix compile probelm.
---
 drivers/scsi/libsas/sas_init.c     |  1 +
 drivers/scsi/libsas/sas_internal.h |  1 +
 drivers/scsi/libsas/sas_phy.c      | 33 +++++++++++++++++++++++++++---
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 8566bb120..6b15ad1bc 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -141,6 +141,7 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
 Undo_ports:
 	sas_unregister_ports(sas_ha);
 Undo_phys:
+	sas_unregister_phys(sas_ha);
 
 	return error;
 }
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 6706f2be8..2211fbdfc 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -54,6 +54,7 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev);
 void sas_scsi_recover_host(struct Scsi_Host *shost);
 
 int  sas_register_phys(struct sas_ha_struct *sas_ha);
+void sas_unregister_phys(struct sas_ha_struct *sas_ha);
 
 struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy, gfp_t gfp_flags);
 void sas_free_event(struct asd_sas_event *event);
diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index 635835c28..4e26b0f23 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -116,6 +116,7 @@ static void sas_phye_shutdown(struct work_struct *work)
 int sas_register_phys(struct sas_ha_struct *sas_ha)
 {
 	int i;
+	int err;
 
 	/* Now register the phys. */
 	for (i = 0; i < sas_ha->num_phys; i++) {
@@ -132,8 +133,10 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
 		phy->frame_rcvd_size = 0;
 
 		phy->phy = sas_phy_alloc(&sas_ha->shost->shost_gendev, i);
-		if (!phy->phy)
-			return -ENOMEM;
+		if (!phy->phy) {
+			err = -ENOMEM;
+			goto rollback;
+		}
 
 		phy->phy->identify.initiator_port_protocols =
 			phy->iproto;
@@ -146,10 +149,34 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
 		phy->phy->maximum_linkrate = SAS_LINK_RATE_UNKNOWN;
 		phy->phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
 
-		sas_phy_add(phy->phy);
+		err = sas_phy_add(phy->phy);
+		if (err) {
+			sas_phy_free(phy->phy);
+			goto rollback;
+		}
 	}
 
 	return 0;
+rollback:
+	for (i--; i >= 0; i--) {
+		struct asd_sas_phy *phy = sas_ha->sas_phy[i];
+
+		sas_phy_delete(phy->phy);
+		sas_phy_free(phy->phy);
+	}
+	return err;
+}
+
+void sas_unregister_phys(struct sas_ha_struct *sas_ha)
+{
+	int i;
+	struct asd_sas_phy *phy;
+
+	for (i = 0; i < sas_ha->num_phys; i++) {
+		phy = sas_ha->sas_phy[i];
+		sas_phy_delete(phy->phy);
+		sas_phy_free(phy->phy);
+	}
 }
 
 const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS] = {
-- 
2.34.1

