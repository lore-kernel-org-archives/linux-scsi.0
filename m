Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42329244667;
	Mon,  3 Aug 2026 02:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785722743; cv=none; b=XWSpnWupaWrK0uMI6sR4SHA1SQlfpEHNkMA6/PQQKo05np1J1520BRMwAK0gG1hZna695Z7w9Z78MMqR/83cNIOPT8+eXmWv1L5z4PloQkACbZqzUh9+T9p3POwr9MwjOWA9nKBJ9oRvTIRrc6uOOf3mJ2eGV8dNJTQHmgjAg/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785722743; c=relaxed/simple;
	bh=xlhAxrm4hWoFSUVCBPkRNPEtuRwBlo4dXpDZdfM9BUA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tol8rwx+Is+QZuGeD1LoV54VizzGLVEqXDrI6JPAJKKhosIhFvCbhvoBKRzta2lcBTYqBcQSvkCw2Hv8jTHfIpmu4LUeSKul+Ob1rgZvFf7ZHxwZjcaZmG/0+k9yGlhVQQ2GG6BkI0R3M8Hu9/4eHwHsbyJ5Fgys+QV5U6VKfD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=krMx8+f5; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="krMx8+f5"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bgxqG+epbVaXtjY7d1bTjADbYNCTt/oo5fDIbqJDCzM=;
	b=krMx8+f5J2sp9CpsiuBAUCrhE2hs/PKURSnndeFhTYBDbDlrkCUAup+HccgYcJnqzDnXDrEag
	XbYIgFmow5v/+yrWP7ivJ7OKT+LS3qX5ExL5mg8gSAq6TiXvQc0o+Oqu7PYvIf280CHyab2XxKs
	3WAychC15LpwIiXCikxzdaY=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hD0C05vs9zpT1Y;
	Mon,  3 Aug 2026 09:56:12 +0800 (CST)
Received: from kwepemp100006.china.huawei.com (unknown [7.202.195.87])
	by mail.maildlp.com (Postfix) with ESMTPS id 6CCA720333;
	Mon,  3 Aug 2026 10:05:38 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp100006.china.huawei.com (7.202.195.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 10:05:38 +0800
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
Subject: [PATCH v3 2/2] scsi: hisi_sas: Add lldd_notify_enable_spinup callback for SAS devices
Date: Mon, 3 Aug 2026 10:05:36 +0800
Message-ID: <20260803020536.546544-3-yangxingui@huawei.com>
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

Register the lldd_notify_enable_spinup callback. The callback sends a
NOTIFY(ENABLE SPINUP) primitive via sl_notify_ssp() to trigger media spinup
on SAS devices in Active_Wait or Idle_Wait state.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 944ce19ae2fc..a726d6680386 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2081,6 +2081,16 @@ static int hisi_sas_write_gpio(struct sas_ha_struct *sha, u8 reg_type,
 				reg_index, reg_count, write_data);
 }
 
+static void hisi_sas_notify_enable_spinup(struct asd_sas_phy *phy)
+{
+	struct hisi_sas_phy *hisi_phy =
+		container_of(phy, struct hisi_sas_phy, sas_phy);
+	struct hisi_hba *hisi_hba = hisi_phy->hisi_hba;
+
+	hisi_hba->hw->sl_notify_ssp(hisi_hba, phy->id);
+	dev_info(hisi_hba->dev, "phy%d notify enable spinup\n", phy->id);
+}
+
 static void hisi_sas_phy_disconnected(struct hisi_sas_phy *phy)
 {
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
@@ -2180,6 +2190,7 @@ static struct sas_domain_function_template hisi_sas_transport_ops = {
 	.lldd_write_gpio	= hisi_sas_write_gpio,
 	.lldd_tmf_aborted	= hisi_sas_tmf_aborted,
 	.lldd_abort_timeout	= hisi_sas_internal_abort_timeout,
+	.lldd_notify_enable_spinup = hisi_sas_notify_enable_spinup,
 };
 
 void hisi_sas_init_mem(struct hisi_hba *hisi_hba)
-- 
2.43.0

