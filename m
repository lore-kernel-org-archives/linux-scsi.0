Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C943454BF1
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jan 2024 09:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706518970; cv=none; b=kHE9hizZ/gGEwVz9wlJmIH7Nuhs/rzYy9Jt8VLhjoqBddWbD3zMajzm0NPv58QXEipOiIs3ah8bTxk0QVhR0oWXeJg+fdnOxhOHIfF8h77GySa08/u2dOLrOmtEW3Gul6sqLM/2fRdxkoHkYplP6/pjlt0bV2lXigtycO9yP5X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706518970; c=relaxed/simple;
	bh=mgo4baukzR5DOt5UGk6o5gHtUCt52fC8NSqKrMf4Wv4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kfI4TYwXG4dP2NNLjs185BcuUPqCreTGGxHrW0uAgN5b/uugcsgfgEIdsrnLDEVdGyt92AYUhPbToHI/5/P/su0i1+2jtcf2yKYgo1MPmgwAWqrfn8Hm/+qJsL6hsah9Bf7VmYAWrWfvFHiV9joY3csX97MTn42jvme85NzRZYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jqYuEARs; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jqYuEARs"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706518960; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=n0D7lFQAP3jzqQbAE3d9i81KEmuS8CdRynZBQVx7j58=;
	b=jqYuEARsisqmJwdatMp4ANLfKahhxFMejpdLukkdNE4AN+DNmi1DjICBgJMLCUMy6CS5P2AG4gwj63cAE9Wk6c5ljJwCbiTc5CLqlplGr7bLEDrtZiUcLGqGlFvOiRN0t5mCQu/2VAilu7QlZttu6QMqU5FoYrhhC6KydvZGIwQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=kanie@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W.YwcLD_1706518955;
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0W.YwcLD_1706518955)
          by smtp.aliyun-inc.com;
          Mon, 29 Jan 2024 17:02:39 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: jejb@linux.ibm.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: sd: fix sd ida memory leak
Date: Mon, 29 Jan 2024 17:02:34 +0800
Message-ID: <20240129090234.7762-1-kanie@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sd_index_ida should be destroy when the sd module exit.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
---
 drivers/scsi/sd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0833b3e6aa6e..8b88cba88da2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4079,6 +4079,8 @@ static void __exit exit_sd(void)
 
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(sd_major(i), "sd");
+
+	ida_destroy(&sd_index_ida);
 }
 
 module_init(init_sd);
-- 
2.43.0

