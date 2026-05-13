Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED4F37DAA3;
	Wed, 13 May 2026 02:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778638637; cv=none; b=IOj/Lnt8qrBCVuyDnlrUhSIN6PpsAYUcU3EO5ThJb853sIrRv+80fApTjF54DP0ZMTTTR/T2bW+0ZlL0W7cInnqdNSckq3BBtShhohkX0W75Uea4Qa80zfCOnzZvW1yuy3I+LMb0hgY8S6yNKu1XFBlMCs9DXD2TfWoSILZYIYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778638637; c=relaxed/simple;
	bh=y7AN/kjfIaDUjAs68wyzm8U1nSM+wxtEywdyuxi9noo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kvNs0uQTWzajF6krSBiC4PJ311o8Nef2IeSI+VbMSqhcwOUw8felhY+Nd1P6b7H5fOqXdqUYlLFeob3bQT9eGG5WPVzrWg9MSzIUl3ssTMTxPvhTYpLLNftGBwEcP72C4UdMne3HBVCge4dY7XtAOUzI9RPofCUuFTj32MF6PpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=O+zTUc5G; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="O+zTUc5G"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0aZ6fiaSRIdI1DR6jHyD3+VcENmT7D4KK2+OhAb5Hwg=;
	b=O+zTUc5GADoz6ZI6e2Zclokk0JOMcVwpLJzJSAxHmj30pU76p2x9c+vYqScWMYD8uhrgKU72X
	r5EgfcDNYrJNgeRs/baJnBkxRlWHQD8NGPjwLPc4hk8OGob1dz7WfM/kc9Ewf6khX94o3aRT2gI
	rHo/y3+K7F+1mmQaqi61T1g=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gFcNF6Lnfz1prm1;
	Wed, 13 May 2026 10:09:33 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 53B464056D;
	Wed, 13 May 2026 10:17:13 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 13 May 2026 10:17:12 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH v2 3/3] scsi: hisi_sas: add support for dev info update notification
Date: Wed, 13 May 2026 10:16:03 +0800
Message-ID: <20260513021603.3023329-4-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513021603.3023329-1-yangxingui@huawei.com>
References: <20260513021603.3023329-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100018.china.huawei.com (7.202.194.12)

Implement the lldd_dev_info_update callback for hisi_sas driver. When
a device's information changes (such as linkrate), clear the old ITCT
entry and setup a new one to reflect the new settings. This ensures the
hardware uses the correct information after events like cable reconnection
or renegotiation.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 944ce19ae2fc..095960aef6d8 100644
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
+	dev_info(dev, "update itct for device %016llx\n",
+		 SAS_ADDR(device->sas_addr));
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
-- 
2.43.0

