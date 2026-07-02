Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE7E31355D;
	Thu,  2 Jul 2026 03:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782964779; cv=none; b=ghLLzk7aIbB1WXOGIPX3CcFI+40BGC7jzEO1yNPsGkx9wSg9VBNj9L27NnAT13l+dYZVD8Bgb9YVbk/ueUjv968eL6Uk01VUeD0+A4nRjlgT6qhV9/7hUbgeU3qYmTJNaCYMpsv558jbOO7OVgD0DNM/NjIV1F+ZVap0IkmOFFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782964779; c=relaxed/simple;
	bh=hJdM8j4SwxiBpX/d2w2s622cgYe98SvUgCY5x0tyj24=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bbL+LhVnvREnxLWLLRXqSC33LUGMowIwzo6wMWAvjKFWOOUo/4obuKXPcq3zufNn/Q5ZwLXGa7OLn46Ftss2Vnqf7kGoqvViQyCv93ydpcDvVMn3X1Ir2t/4oOfxWOJZjbR+dTI9FCU5w8wEbLER8pWhUbjFRi5CBJIQRMpDfHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=OketN4m5; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="OketN4m5"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CDz5Ra6EoYQMHGOMW8nSOgbE5CgRrUtlw7+7uOAvRUA=;
	b=OketN4m53tyntaTnZnTbKbU+6ngC6tyXFJebZ2EbC3DFzG7b2X4h5hCp0n4ys2ytUY8NCTWlk
	irFuqRLB3UJylK+wwQKI/V4jFm0//yIhSVepvgMQOb5T5NKlqPcE1iX/BYZG5ilFqbUBVWUU869
	YaQX9qONFIhMvRCTwTK0rVc=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4grNFM45sHzKm4R;
	Thu,  2 Jul 2026 11:50:15 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 3D8A240586;
	Thu,  2 Jul 2026 11:59:28 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 2 Jul 2026 11:59:27 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<john.g.garry@oracle.com>, <dlemoal@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH 2/2] scsi: hisi_sas: add spinup_notify callback to handle Active_Wait/Idle_Wait SSP devices
Date: Thu, 2 Jul 2026 11:57:24 +0800
Message-ID: <20260702035724.2059166-3-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702035724.2059166-1-yangxingui@huawei.com>
References: <20260702035724.2059166-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100018.china.huawei.com (7.202.194.12)

When a SAS HDD disk connected via SSP (Serial Attached SCSI Protocol) is in
Active_Wait or Idle_Wait state (typical after power-up with RNOT=1), it
does not respond to standard SCSI START_STOP spinup commands. Instead it
returns NOT_READY with ASC/ASCQ = 0x04/0x11 ("notify (enable spinup)
required").

The hisi_sas controller pulses the SL_CONTROL.NOTIFY_EN bit to send a
NOTIFY(ENABLE SPINUP) primitive to the SSP device, allowing it to exit the
waiting state.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 25 +++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  1 +
 5 files changed, 29 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 1323ed8aa717..e198fa7f84e0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -689,4 +689,5 @@ extern void hisi_sas_sync_cqs(struct hisi_hba *hisi_hba);
 extern void hisi_sas_sync_poll_cqs(struct hisi_hba *hisi_hba);
 extern void hisi_sas_controller_reset_prepare(struct hisi_hba *hisi_hba);
 extern void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba);
+extern void hisi_sas_spinup_notify(struct scsi_device *sdev);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 944ce19ae2fc..1a16d18db297 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2474,6 +2474,31 @@ int hisi_sas_get_fw_info(struct hisi_hba *hisi_hba)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_get_fw_info);
 
+void hisi_sas_spinup_notify(struct scsi_device *sdev)
+{
+	struct domain_device *dev = sdev_to_domain_dev(sdev);
+	struct sas_ha_struct *sha;
+	struct hisi_hba *hisi_hba;
+	struct sas_phy *local_phy;
+	struct hisi_sas_phy *phy;
+
+	if (dev->parent && dev_is_expander(dev->parent->dev_type))
+		return;
+
+	sha = SHOST_TO_SAS_HA(sdev->host);
+	hisi_hba = sha->lldd_ha;
+
+	local_phy = sas_get_local_phy(dev);
+	phy = &hisi_hba->phy[local_phy->number];
+	if (phy->identify.target_port_protocols & SAS_PROTOCOL_SSP) {
+		hisi_hba->hw->sl_notify_ssp(hisi_hba, local_phy->number);
+		dev_info(hisi_hba->dev, "spinup notify on phy%d for sdev %s\n",
+			 local_phy->number, dev_name(&sdev->sdev_dev));
+	}
+	sas_put_local_phy(local_phy);
+}
+EXPORT_SYMBOL_GPL(hisi_sas_spinup_notify);
+
 static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 					      const struct hisi_sas_hw *hw)
 {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index fa94d7110714..0179c33f08d4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1760,6 +1760,7 @@ static const struct scsi_host_template sht_v1_hw = {
 	.sdev_init		= hisi_sas_sdev_init,
 	.shost_groups		= host_v1_hw_groups,
 	.host_reset		= hisi_sas_host_reset,
+	.spinup_notify		= hisi_sas_spinup_notify,
 };
 
 static const struct hisi_sas_hw hisi_sas_v1_hw = {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index f3516a0611dd..82708a3e71c2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3597,6 +3597,7 @@ static const struct scsi_host_template sht_v2_hw = {
 	.host_reset		= hisi_sas_host_reset,
 	.map_queues		= map_queues_v2_hw,
 	.host_tagset		= 1,
+	.spinup_notify		= hisi_sas_spinup_notify,
 };
 
 static const struct hisi_sas_hw hisi_sas_v2_hw = {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 901f508e8be7..330da2503b75 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3417,6 +3417,7 @@ static const struct scsi_host_template sht_v3_hw = {
 	.host_reset		= hisi_sas_host_reset,
 	.host_tagset		= 1,
 	.mq_poll		= queue_complete_v3_hw,
+	.spinup_notify		= hisi_sas_spinup_notify,
 };
 
 static const struct hisi_sas_hw hisi_sas_v3_hw = {
-- 
2.43.0

