Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C51146585;
	Fri, 14 Mar 2025 01:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914623; cv=none; b=nF63nfzhKyNAnZXoa10ugdVukq5Ylj/PD8bmZL38ZY60dmkfFWVgNnuIMpYtTp3fL5TpAtw3cmCAIcZrxllDmVz4RxbKMD6yedTczfwwsZ5PO7vtdMYlZ9qgs6f9c0ZXXQElc1gOqxKMTSeuTq3N7U+ZcNT4J+8VW64U+jCQt9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914623; c=relaxed/simple;
	bh=0Gje1SR8UgouUOWXw4TnLAlKrs8hTvO6GR3fvSwAeAc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZu5vqSqaA0uKyozHMtjryfy4SkwaT2hw+aGBcce6GGtOSWJpBMoRgeyDPwtK4+YM31lBXG4S7g8Avhvzpf8IYOr3tTl7JWyoK/HKSIW58guDmYPhYrRYcDm07XaLg7aF3RuSY9bXBxHiX8AmkqqOZi2uJnhJZyA31xOBzAS85Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZDR5c2RmNzvWrn;
	Fri, 14 Mar 2025 09:06:28 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id A5A19180102;
	Fri, 14 Mar 2025 09:10:19 +0800 (CST)
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
Subject: [RFC PATCH v3 15/19] scsi: mpt3sas: Add param to control target based error handle
Date: Fri, 14 Mar 2025 09:29:23 +0800
Message-ID: <20250314012927.150860-16-jiangjianjun3@huawei.com>
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

Add new module param target_eh to control if enable target based
error handle, since mpt3sas defined callback eh_host_reset, so make
it fallback to further recover when target based recovery can not
recover all error commands.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b3ceba3c1ea8..6f3eced511bf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -177,6 +177,10 @@ static bool lun_eh;
 module_param(lun_eh, bool, 0444);
 MODULE_PARM_DESC(lun_eh, "LUN based error handle (def=0)");
 
+static bool target_eh;
+module_param(target_eh, bool, 0444);
+MODULE_PARM_DESC(target_eh, "target based error handle (def=0)");
+
 /* raid transport support */
 static struct raid_template *mpt3sas_raid_template;
 static struct raid_template *mpt2sas_raid_template;
@@ -1878,6 +1882,13 @@ scsih_target_alloc(struct scsi_target *starget)
 	struct _pcie_device *pcie_device;
 	unsigned long flags;
 	struct sas_rphy *rphy;
+	int ret = 0;
+
+	if (target_eh) {
+		ret = scsi_target_setup_eh(starget, 1);
+		if (ret)
+			return ret;
+	}
 
 	sas_target_priv_data = kzalloc(sizeof(*sas_target_priv_data),
 				       GFP_KERNEL);
@@ -1968,6 +1979,9 @@ scsih_target_destroy(struct scsi_target *starget)
 	struct _pcie_device *pcie_device;
 	unsigned long flags;
 
+	if (target_eh)
+		scsi_target_clear_eh(starget);
+
 	sas_target_priv_data = starget->hostdata;
 	if (!sas_target_priv_data)
 		return;
-- 
2.33.0

