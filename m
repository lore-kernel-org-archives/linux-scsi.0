Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422C7145B11;
	Mon,  3 Aug 2026 02:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785722744; cv=none; b=p9WUmFxHsqvxYNtIcEtWPNSdKL7MIPMMuMBsuKAQbL9p7UhzZK2ubgCgaCxp6mY/PSCiGuxBMNWNsxA/FMD7EMU4gXkzgTtuPZuj+dS+zn79BsvU0AiHhNBvE2BrVkk1wHaPcXYJ7ShVEb2BBxxGHvT8wSHA6IDBELbcs8xoqEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785722744; c=relaxed/simple;
	bh=DGLSz1drwadQXoLuiQ0F9H4rs3hoiP4wsOwcBKLpicY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lMTT+d+6J99FkYA+8YYbsenfsB0LQkvjlQqaPvsvKbMAsdeYvQ3/O5yNcjGtgSM8QfXa1xU2GhV+PoPRzvYoCs7LKmcbN7LDNh2SsMDM4y8ica6UQHyhd4tf8JZZTpFbUy8O1eu9SDGqLImivlzZ13Tf1dELkNtKnBdmQXq6ia8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=TOr+1fCJ; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="TOr+1fCJ"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6P7OZxF3uG9jtAtVnF/GXy+v04G0BPEm8duwmRRZDpA=;
	b=TOr+1fCJFM31YzSOKa36n/ieDe9rVvDX0X7qA4KQsUQQYVJt/aAG29Fg6mguDjoVTgCokeCTd
	mtQW3SX+3zATTE6HljOhIeMKCdux3uHwis+rL0W5ScYDb2goNPUd8+wCwUsCNfZSc8N8aWKk/Xf
	2BYiwJ2BjafdAMi7t7BvEdE=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hD0C02dCZzpSvD;
	Mon,  3 Aug 2026 09:56:12 +0800 (CST)
Received: from kwepemp100002.china.huawei.com (unknown [7.202.195.234])
	by mail.maildlp.com (Postfix) with ESMTPS id F27C24056E;
	Mon,  3 Aug 2026 10:05:37 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp100002.china.huawei.com (7.202.195.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 10:05:37 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 10:05:37 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH v3 1/2] scsi: libsas: Add PHYE_NOTIFY_ENABLE_SPINUP phy event for ASC/ASCQ=0x04/0x11
Date: Mon, 3 Aug 2026 10:05:35 +0800
Message-ID: <20260803020536.546544-2-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803020536.546544-1-yangxingui@huawei.com>
References: <20260803020536.546544-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemp500015.china.huawei.com (7.202.195.9)

When a SAS device is in the Active_Wait or Idle_Wait power state, it
returns NOT_READY with ASC/ASCQ = 0x04/0x11 (notify (enable spinup)
required), indicating that a NOTIFY(ENABLE SPINUP) primitive is needed to
trigger media spinup.

Add a PHYE_NOTIFY_ENABLE_SPINUP phy event and an optional
lldd_notify_enable_spinup callback to sas_domain_function_template. Sense
detection is done in sas_ssp_task_spinup_notify(), called from
sas_ssp_task_response() which is the common entry point for all SAS LLDDs.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/libsas/sas_internal.h  |  2 ++
 drivers/scsi/libsas/sas_phy.c       | 12 ++++++++
 drivers/scsi/libsas/sas_scsi_host.c | 45 +++++++++++++++++++++++++++++
 drivers/scsi/libsas/sas_task.c      |  2 ++
 include/scsi/libsas.h               |  9 ++++++
 5 files changed, 70 insertions(+)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 7dce0f587149..fa06f50b0bf0 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -107,6 +107,8 @@ extern const work_func_t sas_port_event_fns[PORT_NUM_EVENTS];
 
 void sas_task_internal_done(struct sas_task *task);
 void sas_task_internal_timedout(struct timer_list *t);
+void sas_ssp_task_spinup_notify(struct sas_task *task,
+				struct ssp_response_iu *iu);
 int sas_execute_tmf(struct domain_device *device, void *parameter,
 		    int para_len, int force_phy_id,
 		    struct sas_tmf_task *tmf);
diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index 58f08dc2c187..897a5b46db78 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -111,6 +111,17 @@ static void sas_phye_shutdown(struct work_struct *work)
 	phy->in_shutdown = 0;
 }
 
+static void sas_phye_notify_enable_spinup(struct work_struct *work)
+{
+	struct asd_sas_event *ev = to_asd_sas_event(work);
+	struct asd_sas_phy *phy = ev->phy;
+	struct sas_ha_struct *sas_ha = phy->ha;
+	struct sas_internal *i =
+		to_sas_internal(sas_ha->shost->transportt);
+
+	i->dft->lldd_notify_enable_spinup(phy);
+}
+
 /* ---------- Phy class registration ---------- */
 
 int sas_register_phys(struct sas_ha_struct *sas_ha)
@@ -186,4 +197,5 @@ const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS] = {
 	[PHYE_SPINUP_HOLD] = sas_phye_spinup_hold,
 	[PHYE_RESUME_TIMEOUT] = sas_phye_resume_timeout,
 	[PHYE_SHUTDOWN] = sas_phye_shutdown,
+	[PHYE_NOTIFY_ENABLE_SPINUP] = sas_phye_notify_enable_spinup,
 };
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index c83282733ec4..bb1dfc16d8d1 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -34,6 +34,51 @@
 #include <linux/scatterlist.h>
 #include <linux/libata.h>
 
+/*
+ * If the SSP response carries NOT_READY sense with ASC/ASCQ = 0x04/0x11
+ * ("notify (enable spinup) required"), queue a PHYE_NOTIFY_ENABLE_SPINUP
+ * phy event so the LLDD can send a NOTIFY(ENABLE SPINUP) primitive.
+ */
+void sas_ssp_task_spinup_notify(struct sas_task *task,
+				struct ssp_response_iu *iu)
+{
+	struct domain_device *dev = task->dev;
+	struct sas_ha_struct *ha = dev->port->ha;
+	struct sas_internal *i = to_sas_internal(ha->shost->transportt);
+	struct scsi_sense_hdr sshdr;
+	struct sas_phy *local_phy;
+	struct asd_sas_phy *phy;
+	u32 sense_len;
+
+	/*
+	 * NOTIFY(ENABLE SPINUP) must be sent on the local phy directly
+	 * attached to the target. Skip expander-attached devices.
+	 */
+	if (dev->parent && dev_is_expander(dev->parent->dev_type))
+		return;
+
+	if (!i->dft->lldd_notify_enable_spinup)
+		return;
+
+	if (iu->status != SAM_STAT_CHECK_CONDITION)
+		return;
+
+	sense_len = min_t(u32, be32_to_cpu(iu->sense_data_len),
+			  SAS_STATUS_BUF_SIZE);
+	if (!scsi_normalize_sense(iu->sense_data, sense_len, &sshdr))
+		return;
+
+	if (sshdr.sense_key != NOT_READY ||
+	    sshdr.asc != 0x04 || sshdr.ascq != 0x11)
+		return;
+
+	local_phy = sas_get_local_phy(dev);
+	phy = ha->sas_phy[local_phy->number];
+	sas_put_local_phy(local_phy);
+
+	sas_notify_phy_event(phy, PHYE_NOTIFY_ENABLE_SPINUP, GFP_ATOMIC);
+}
+
 /* record final status and free the task */
 static void sas_end_task(struct scsi_cmnd *sc, struct sas_task *task)
 {
diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
index e9d291007817..d1eb6ce90626 100644
--- a/drivers/scsi/libsas/sas_task.c
+++ b/drivers/scsi/libsas/sas_task.c
@@ -29,6 +29,8 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
 			      be32_to_cpu(iu->sense_data_len));
 		memcpy(tstat->buf, iu->sense_data, tstat->buf_valid_size);
 
+		sas_ssp_task_spinup_notify(task, iu);
+
 		if (iu->status != SAM_STAT_CHECK_CONDITION)
 			dev_warn(dev, "dev %016llx sent sense data, but stat(0x%x) is not CHECK CONDITION\n",
 				 SAS_ADDR(task->dev->sas_addr), iu->status);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 163f23c92b41..945b7cfe0224 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -49,6 +49,7 @@ enum phy_event {
 	PHYE_SPINUP_HOLD,             /* hot plug SATA, no COMWAKE sent */
 	PHYE_RESUME_TIMEOUT,
 	PHYE_SHUTDOWN,
+	PHYE_NOTIFY_ENABLE_SPINUP,    /* NOTIFY(ENABLE SPINUP) primitive */
 	PHY_NUM_EVENTS,
 };
 
@@ -674,6 +675,14 @@ struct sas_domain_function_template {
 	/* GPIO support */
 	int (*lldd_write_gpio)(struct sas_ha_struct *, u8 reg_type,
 			       u8 reg_index, u8 reg_count, u8 *write_data);
+
+	/*
+	 * Optional callback invoked when an SSP target returns NOT_READY
+	 * with ASC/ASCQ = 0x04/0x11 ("notify (enable spinup) required"),
+	 * indicating the device is in Active_Wait/Idle_Wait state and
+	 * needs a NOTIFY(ENABLE SPINUP) primitive to proceed.
+	 */
+	void (*lldd_notify_enable_spinup)(struct asd_sas_phy *phy);
 };
 
 extern int sas_register_ha(struct sas_ha_struct *);
-- 
2.43.0

