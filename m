Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2FD13B7AB;
	Wed, 22 May 2024 11:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716378394; cv=none; b=haf5Cic9dvFP6HBMj0rpxUJ5NJvhO532JTUz+/tM42a555X0T3uPFZJPdJz7t0IqKj8F6s1uAboqxUo24CzY/TVaa/zTVA6cxjIcm6ijksyp3egVC/QEauqYTXjiZ6F+6e4MXJs77DYKUKT+QTJ6qoaG8zyYJb4p3oT1y7kDLnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716378394; c=relaxed/simple;
	bh=bRm9H4UquR51tvU1Bqm9NuZgpFhBOUcsrWpB5jVm+cQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dj9I6uTYGNvLiHz2u99oxHC0Z32CCaXDeIeIREfSe149kMJ0cNHBpNQBAWNM58W4qNwy4GesZaLrYO/CTyHwhyu/KR+clnkVauK0+UnbNPQL7aVmWv/7m9l4sASbPTM6vhsKa6vB5PFVL9qpip3rsq/twntp06XeURxiJoLxKxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VkqDQ4fHdzxNdL;
	Wed, 22 May 2024 19:42:46 +0800 (CST)
Received: from dggpemd100001.china.huawei.com (unknown [7.185.36.94])
	by mail.maildlp.com (Postfix) with ESMTPS id 2412B140133;
	Wed, 22 May 2024 19:46:28 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 dggpemd100001.china.huawei.com (7.185.36.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 22 May 2024 19:46:27 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <gregkh@linuxfoundation.org>, <rafael@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@hisilicon.com>, <liyihang9@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH] driver core: Add log when devtmpfs create node failed
Date: Wed, 22 May 2024 11:43:46 +0000
Message-ID: <20240522114346.42951-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemd100001.china.huawei.com (7.185.36.94)

Currently, no exception information is output when devtmpfs create node
failed, so add log info for it.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/base/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 5f4e03336e68..32a41e0472b2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3691,7 +3691,10 @@ int device_add(struct device *dev)
 		if (error)
 			goto SysEntryError;
 
-		devtmpfs_create_node(dev);
+		error = devtmpfs_create_node(dev);
+		if (error)
+			pr_info("devtmpfs create node for %s failed: %d\n",
+				dev_name(dev), error);
 	}
 
 	/* Notify clients of device addition.  This call must come
-- 
2.17.1

