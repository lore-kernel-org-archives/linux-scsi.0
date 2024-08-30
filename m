Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6AD15C143
	for <linux-scsi@vger.kernel.org>; Fri, 30 Aug 2024 07:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725004618; cv=none; b=e2SPFnQoVAYW11aouIKue3OnZWX/lFyyEto9NI7U3s1d8llOmmTW+YP9if1DRoaaIBNW74nxX3MYAwZc6Jtbn75LtQfx/mAq7M1a4luFzt/3CCr8UEkCiFZ7svmQz77DoOOF972aLHw1t0T3bwOnOJ6R+dK6Vs8prg8n0SaXSKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725004618; c=relaxed/simple;
	bh=Ql4UixNQdZ+q9bKpp3RycufxOesQjplvzHA3rEz0gNo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oPZCyv1iAmvVW/lAOgvQ++VLEgxMHFhX5ClcQQ+AE8Hwui9ap7HQFOvTYcC+KeIAwf6AIzMZ7mnVKNLpTHklptQFraCp9cm/hVThPoXNNAK4/wOT6MqFlL8aIHyHcSduRWMgCJGQkOni4FtmpWf8/V6s1uLa0y8LTDEZHbIkvBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ww9Rc5KLQzpV6R;
	Fri, 30 Aug 2024 15:55:08 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 9D2D818007C;
	Fri, 30 Aug 2024 15:56:53 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 30 Aug
 2024 15:56:53 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH -next] scsi: qla2xxx: replace simple_strtoul to kstrtoul
Date: Fri, 30 Aug 2024 16:05:05 +0800
Message-ID: <20240830080505.3545641-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)

The function simple_strtoul performs no error checking
in scenarios where the input value overflows the intended
output variable.

We can replace the use of the simple_strtoul with the safer
alternatives kstrtoul. For fail case, we also print the extra
message.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index a1545dad0c0c..e92d4e43bdf5 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -598,7 +598,12 @@ qla_dfs_naqp_write(struct file *file, const char __user *buffer,
 		return PTR_ERR(buf);
 	}
 
-	num_act_qp = simple_strtoul(buf, NULL, 0);
+	if (kstrtoul(buf, 0, &num_act_qp)) {
+		pr_err("host:%ld: fail to parse user buffer into number.",
+		    vha->host_no);
+		rc = -EINVAL;
+		goto out_free;
+	}
 
 	if (num_act_qp >= vha->hw->max_qpairs) {
 		pr_err("User set invalid number of qpairs %lu. Max = %d",
-- 
2.34.1

