Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0373612F59C
	for <linux-scsi@vger.kernel.org>; Fri, 30 Aug 2024 07:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725004251; cv=none; b=FrndSDg+VHy/ZpvGORuWYbeSREI4FwO/lMOAXxnlt4wLcRfiG5Atz5SPknO+buNfl6yyD9maMtl4Nzik6V1GIgv4+D2S/loJH0fUqh9cXtfq4aoL8Mn3K/NjZFd7f4o2amJLmHpYhmMUsgVVRDbidXS32jRqy5uAE+bGbYJV7ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725004251; c=relaxed/simple;
	bh=BwTXN0bkNA4j+m1hXNgJFnkJDYt+INhKByC83R7D6Pk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XfICLgRPKydGCWWyNKNiSnlXarVbqeS28PvHN0hR3eYX6+0uwfLbJ93/J3KkVM7S+5NOt/QHwn3YibwePG4tDJJz7AzHCoax6HNcu7F9NW27LDLvpwFr+whraMBzMksQw9ndHQha0Uog7aL5n9l4kJU5V52rdOec7K6yWMHQCIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Ww9LJ3wv9z2Cp86;
	Fri, 30 Aug 2024 15:50:32 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 4DC091A016C;
	Fri, 30 Aug 2024 15:50:46 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 30 Aug
 2024 15:50:46 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH -next] scsi: sd: Remove duplicate included header file linux/bio-integrity.h
Date: Fri, 30 Aug 2024 15:58:58 +0800
Message-ID: <20240830075858.3541907-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

The header file linux/bio-integrity.h is included twice.
Remove the last one. The compilation test has passed.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 drivers/scsi/sd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 76f488ef6a7e..022ef94ee8de 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -38,7 +38,6 @@
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <linux/bio-integrity.h>
 #include <linux/hdreg.h>
 #include <linux/errno.h>
 #include <linux/idr.h>
-- 
2.34.1

