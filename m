Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67861946AA;
	Fri, 14 Mar 2025 01:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914629; cv=none; b=px4VF6U0iWII1+PNdh905jmKTc11DiKay0J2jPVmxM5C3k6tf+AhLRjkfpQLaueN7yWA/lSKrB/qhyruk3JAqpi75VLdU9jpTTveUGTfvSN7GVeIM5eh+zHZf13W+1fOpL0G3hv6bJwTAB/1W85Nxd5/n1ds0UnKxeIrF2dJHMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914629; c=relaxed/simple;
	bh=avghMgFjPeUTvjk6WUJz3BpzKN2b/Dc6sK35L2Ty46s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cao59PtKNaPfW0CXu6lxn1+wjT98JhMn5EZm8w+o3NYQzsw9HG+GRkZNna9HY3cn/rAoVEIFc6XFHTQfPq+GYzqh1L6zs3OYrCMyymVp8rkPS0Nc4y5xvkHJGQIcBSa73cWU76Qk9R9r7xJnODTLfDAvTPzENU+Fb8E3dADWEhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4ZDRBk3LTrz27gXH;
	Fri, 14 Mar 2025 09:10:54 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id 2E35414011D;
	Fri, 14 Mar 2025 09:10:19 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:18 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 14/19] scsi: mpt3sas: Add param to control LUN based error handle
Date: Fri, 14 Mar 2025 09:29:22 +0800
Message-ID: <20250314012927.150860-15-jiangjianjun3@huawei.com>
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

Add new module param lun_eh to control if enable LUN based
error handler, since mpt3sas defined callback eh_host_reset
and eh_target_reset, so make it fallback to further recover
when LUN based recovery can not recover all error commands.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a456e5ec74d8..b3ceba3c1ea8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -173,6 +173,10 @@ module_param(host_tagset_enable, int, 0444);
 MODULE_PARM_DESC(host_tagset_enable,
 	"Shared host tagset enable/disable Default: enable(1)");
 
+static bool lun_eh;
+module_param(lun_eh, bool, 0444);
+MODULE_PARM_DESC(lun_eh, "LUN based error handle (def=0)");
+
 /* raid transport support */
 static struct raid_template *mpt3sas_raid_template;
 static struct raid_template *mpt2sas_raid_template;
@@ -2043,6 +2047,13 @@ scsih_sdev_init(struct scsi_device *sdev)
 	struct _sas_device *sas_device;
 	struct _pcie_device *pcie_device;
 	unsigned long flags;
+	int ret = 0;
+
+	if (lun_eh) {
+		ret = scsi_device_setup_eh(sdev, 1);
+		if (ret)
+			return ret;
+	}
 
 	sas_device_priv_data = kzalloc(sizeof(*sas_device_priv_data),
 				       GFP_KERNEL);
@@ -2121,6 +2132,9 @@ scsih_sdev_destroy(struct scsi_device *sdev)
 	struct _pcie_device *pcie_device;
 	unsigned long flags;
 
+	if (lun_eh)
+		scsi_device_clear_eh(sdev);
+
 	if (!sdev->hostdata)
 		return;
 
-- 
2.33.0

