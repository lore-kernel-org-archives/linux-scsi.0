Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9397192D77;
	Fri, 11 Oct 2024 11:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728646507; cv=none; b=kVazVAl29pzD0XQ7t7os3sfgGZY4O9g2kXSJH3rcQVQ8Ntd8PJMs2PRxo7JbPCf0K3XGlwdM/pPR3UHx/cPW5qwdcgdq8EQ16MYasIBGcOGwJww4HTteq6yp2FBZYjSNWVcYpaqxOCWkmUkFH8MeU84As7VGE1J3PlqLg+ktp8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728646507; c=relaxed/simple;
	bh=NzuwYRVLbZuWfu7bBXQpk7mh0Hc0R3PvllwT9mM0Pd8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OAa+9C2zMLAFEp3Z6QcOkocnkSUZ2joptkJZ8wuApNAB8FJb/4hHp+FiOccWEuaDJW8wk8a9EJ6Gv4mM6Ax0D1C7MI0eSX2bb/tyWw8KDJgHWHRg5meZlnReIn+JSAtw32Is+CoqfmnpaT+bGsBnDprg1AA3imsKlnIojzJJC5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XQ4Hf4wxczpVvj;
	Fri, 11 Oct 2024 19:33:02 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (unknown [7.193.23.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 0E49C180AE9;
	Fri, 11 Oct 2024 19:35:02 +0800 (CST)
Received: from huawei.com (10.175.113.133) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 11 Oct
 2024 19:35:01 +0800
From: Wang Hai <wanghai38@huawei.com>
To: <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
	<himanshu.madhani@oracle.com>, <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: target: core: Fix null-ptr-deref in target_alloc_device()
Date: Fri, 11 Oct 2024 19:34:44 +0800
Message-ID: <20241011113444.40749-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600001.china.huawei.com (7.193.23.3)

There is a null-ptr-deref issue reported by kasan:

BUG: KASAN: null-ptr-deref in target_alloc_device+0xbc4/0xbe0 [target_core_mod]
...
 kasan_report+0xb9/0xf0
 target_alloc_device+0xbc4/0xbe0 [target_core_mod]
 core_dev_setup_virtual_lun0+0xef/0x1f0 [target_core_mod]
 target_core_init_configfs+0x205/0x420 [target_core_mod]
 do_one_initcall+0xdd/0x4e0
...
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

In target_alloc_device(), if allocing memory for dev queues fails,
then dev will be freed by dev->transport->free_device(), but
dev->transport is not initialized at that time, which will lead to a
null pointer reference problem.

Fixing this bug by freeing dev with hba->backend->ops->free_device().

Fixes: 1526d9f10c61 ("scsi: target: Make state_list per CPU")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/target/target_core_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index bf4892544cfd..bb84d304b07e 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -691,7 +691,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 	dev->queues = kcalloc(nr_cpu_ids, sizeof(*dev->queues), GFP_KERNEL);
 	if (!dev->queues) {
-		dev->transport->free_device(dev);
+		hba->backend->ops->free_device(dev);
 		return NULL;
 	}
 
-- 
2.17.1

