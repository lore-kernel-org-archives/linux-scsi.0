Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BBB6EB7C;
	Fri, 14 Mar 2025 01:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914624; cv=none; b=id2WWsoznPf1Kqhfp6fO6pT1sMOrSAV1uaNAl7oU8jL7fY6mxsz4QPgnLGx3J7NzWRwuhVDehb60qXWNrvMIQxWpyQdvw/G74spa5oIWQ72XKUVV5AVGIpuQV8VHipPKKRH/eH9Mf2KU2v3gODWWqQlsBsorBUA8BH4iM1/uick=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914624; c=relaxed/simple;
	bh=WD1gJUModLnJXFrVTVWHo4vwDdbbVHXiJ3PH+9VD73g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b5gwSfApqrEj3hqSnWoib1ZjTQMI3H/jNz4h8n5+02TXY5L7VS3RwKyDQWnH9uArb41bF1ucZHNR7sJBswK4gj5iJiybs/wGNKoTRSScnZISflHZqmdjlRz9fAKbLQ930veGjJl5yt5J7Q1KpAnOPIgTyjBLQfFj1qogVTBOrJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4ZDR4z6sP3z1f0bZ;
	Fri, 14 Mar 2025 09:05:55 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id 2CFCD1A0188;
	Fri, 14 Mar 2025 09:10:20 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:19 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 16/19] scsi: smartpqi: Add param to control LUN based error handle
Date: Fri, 14 Mar 2025 09:29:24 +0800
Message-ID: <20250314012927.150860-17-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250314012927.150860-1-jiangjianjun3@huawei.com>
References: <20250314012927.150860-1-jiangjianjun3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500016.china.huawei.com (7.185.36.197)

From: Wenchao Hao <haowenchao2@huawei.com>

Add new param lun_eh to control if enable LUN based error handler, since
smartpqi did not define other further reset callbacks, it is not
necessary to fallback to further recover any more, so set the LUN
error handler with fallback set to 0.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 0da7be40c925..eb6e9be2efc2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -189,6 +189,10 @@ module_param_named(ctrl_ready_timeout,
 MODULE_PARM_DESC(ctrl_ready_timeout,
 	"Timeout in seconds for driver to wait for controller ready.");
 
+static bool pqi_lun_eh;
+module_param_named(lun_eh, pqi_lun_eh, bool, 0444);
+MODULE_PARM_DESC(lun_eh, "LUN based error handle (def=0)");
+
 static char *raid_levels[] = {
 	"RAID-0",
 	"RAID-4",
@@ -6496,6 +6500,13 @@ static int pqi_sdev_init(struct scsi_device *sdev)
 	struct pqi_ctrl_info *ctrl_info;
 	struct scsi_target *starget;
 	struct sas_rphy *rphy;
+	int ret = 0;
+
+	if (pqi_lun_eh) {
+		ret = scsi_device_setup_eh(sdev, 0);
+		if (ret)
+			return ret;
+	}
 
 	ctrl_info = shost_to_hba(sdev->host);
 
@@ -6583,6 +6594,9 @@ static void pqi_sdev_destroy(struct scsi_device *sdev)
 
 	ctrl_info = shost_to_hba(sdev->host);
 
+	if (pqi_lun_eh)
+		scsi_device_clear_eh(sdev);
+
 	mutex_acquired = mutex_trylock(&ctrl_info->scan_mutex);
 	if (!mutex_acquired)
 		return;
-- 
2.33.0

