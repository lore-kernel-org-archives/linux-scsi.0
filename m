Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C78C2E0
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 00:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753315507; cv=none; b=tRWTqJLxrOgI2W6fCJysPujE3dJ+hBYAd7YjihyAd5MkyD1hw4VIaGTYvfCz7FSxwtczKH4JmbdH4yjp7k/R+a0Tn3ovWGpeG15a3vDITCSGsqM1mifJxnUMKXUib0eltBnzYIHX4iWwcVNW5sx6qD1ePZZOih/YZqFwdiKYTpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753315507; c=relaxed/simple;
	bh=AteamDXKSGCcwdZNI1BL/1tAa1DYj1G7yUk2B5LqrcY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d965mbi+8g8ohMx3AoMPZpxaNCemUSx26THlztrqK9TeilXCbaJ5A3biZf5ywuBzivNS62HJxeP7ijrvZXkjRLXn9MgkBKOxK1zjSiso32JQjFECdCxrD1Ax5tLU6KTTChVS0LsKSRcFPgUF+TrVEFBAEH+Fl2wkVXhd9V8p5Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ofwjAvnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ofwjAvnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B22EC4CEF4;
	Thu, 24 Jul 2025 00:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753315506;
	bh=AteamDXKSGCcwdZNI1BL/1tAa1DYj1G7yUk2B5LqrcY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ofwjAvnGZ6Ukgme8++P5zhfZqMwInT6nPFZrNeMpOYBxQXQmdvBJNxhQ42ArJ6Kmr
	 kDV5mVkRFNxMKSva6rqTeZUrwYz8ay3IQ2dQUeEM2A6ZFWzaPnZe0WEyGPcvF9/Mq9
	 OdpaZmGjdCqJbPN4hFZ57gZWBJzxKu21L7hTL388RlC8F9DM8RJPFNN+YqBH5pNbj2
	 NzLo9DJDC4jfF1YWD1Bi0559fWdaTnpzJnaH7UJndUqhgsnVlQIi2F8VsskANtRMdf
	 y0+9+h9GAH1GZGQpofUWaz64ja5OJLMVoUl2yBr8H5V7yUXDGFDqawrN//EQIY2Ovt
	 P5RnZXdj0iyDA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 5/5] scsi: libsas: Use a bool for sas_deform_port() second argument
Date: Thu, 24 Jul 2025 09:02:35 +0900
Message-ID: <20250724000235.143460-6-dlemoal@kernel.org>
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

Change the type of the "gone" argument of sas_deform_port() from int to
bool. Simliarly, to be consistent, do the same change to the function
sas_unregister_domain_devices().

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/libsas/sas_discover.c |  2 +-
 drivers/scsi/libsas/sas_internal.h |  4 ++--
 drivers/scsi/libsas/sas_phy.c      |  6 +++---
 drivers/scsi/libsas/sas_port.c     | 13 ++++++-------
 4 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 951bdc554a10..b07062db50b2 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -406,7 +406,7 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 	}
 }
 
-void sas_unregister_domain_devices(struct asd_sas_port *port, int gone)
+void sas_unregister_domain_devices(struct asd_sas_port *port, bool gone)
 {
 	struct domain_device *dev, *n;
 
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 16f8d81d7531..6706f2be8d27 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -44,7 +44,7 @@ void sas_hash_addr(u8 *hashed, const u8 *sas_addr);
 int sas_discover_root_expander(struct domain_device *dev);
 
 int sas_ex_revalidate_domain(struct domain_device *dev);
-void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
+void sas_unregister_domain_devices(struct asd_sas_port *port, bool gone);
 void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *port);
 void sas_discover_event(struct asd_sas_port *port, enum discover_event ev);
 
@@ -70,7 +70,7 @@ void sas_enable_revalidation(struct sas_ha_struct *ha);
 void sas_queue_deferred_work(struct sas_ha_struct *ha);
 void __sas_drain_work(struct sas_ha_struct *ha);
 
-void sas_deform_port(struct asd_sas_phy *phy, int gone);
+void sas_deform_port(struct asd_sas_phy *phy, bool gone);
 
 void sas_porte_bytes_dmaed(struct work_struct *work);
 void sas_porte_broadcast_rcvd(struct work_struct *work);
diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index 57494ac97076..635835c28ecd 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -20,7 +20,7 @@ static void sas_phye_loss_of_signal(struct work_struct *work)
 	struct asd_sas_phy *phy = ev->phy;
 
 	phy->error = 0;
-	sas_deform_port(phy, 1);
+	sas_deform_port(phy, true);
 }
 
 static void sas_phye_oob_done(struct work_struct *work)
@@ -40,7 +40,7 @@ static void sas_phye_oob_error(struct work_struct *work)
 	struct sas_internal *i =
 		to_sas_internal(sas_ha->shost->transportt);
 
-	sas_deform_port(phy, 1);
+	sas_deform_port(phy, true);
 
 	if (!port && phy->enabled && i->dft->lldd_control_phy) {
 		phy->error++;
@@ -85,7 +85,7 @@ static void sas_phye_resume_timeout(struct work_struct *work)
 
 	phy->error = 0;
 	phy->suspended = 0;
-	sas_deform_port(phy, 1);
+	sas_deform_port(phy, true);
 }
 
 
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index e3f2ed913419..de7556070048 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -113,7 +113,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 
 	if (port) {
 		if (!phy_is_wideport_member(port, phy))
-			sas_deform_port(phy, 0);
+			sas_deform_port(phy, false);
 		else if (phy->suspended) {
 			phy->suspended = 0;
 			sas_resume_port(phy);
@@ -206,7 +206,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
  * This is called when the physical link to the other phy has been
  * lost (on this phy), in Event thread context. We cannot delay here.
  */
-void sas_deform_port(struct asd_sas_phy *phy, int gone)
+void sas_deform_port(struct asd_sas_phy *phy, bool gone)
 {
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct asd_sas_port *port = phy->port;
@@ -301,7 +301,7 @@ void sas_porte_link_reset_err(struct work_struct *work)
 	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
-	sas_deform_port(phy, 1);
+	sas_deform_port(phy, true);
 }
 
 void sas_porte_timer_event(struct work_struct *work)
@@ -309,7 +309,7 @@ void sas_porte_timer_event(struct work_struct *work)
 	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
-	sas_deform_port(phy, 1);
+	sas_deform_port(phy, true);
 }
 
 void sas_porte_hard_reset(struct work_struct *work)
@@ -317,7 +317,7 @@ void sas_porte_hard_reset(struct work_struct *work)
 	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
-	sas_deform_port(phy, 1);
+	sas_deform_port(phy, true);
 }
 
 /* ---------- SAS port registration ---------- */
@@ -358,8 +358,7 @@ void sas_unregister_ports(struct sas_ha_struct *sas_ha)
 
 	for (i = 0; i < sas_ha->num_phys; i++)
 		if (sas_ha->sas_phy[i]->port)
-			sas_deform_port(sas_ha->sas_phy[i], 0);
-
+			sas_deform_port(sas_ha->sas_phy[i], false);
 }
 
 const work_func_t sas_port_event_fns[PORT_NUM_EVENTS] = {
-- 
2.50.1

