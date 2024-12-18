Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1747638F83
	for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2024 01:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734486154; cv=none; b=ITqKg/SGYn3HHojvXCSNIMkMAX7vM7HNIwGfjohdwjYDipylEsNC3g4jqtstuXYI94xDsHTgt5PbXnw2kI2SKC1awpVwScps2m+Z+/smUaEyf+zPz6uIRljqTWBQEWDy6IlKOmlA5FKxbPJBKEjF0bBATdRwS5XRgRJMZIzYnwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734486154; c=relaxed/simple;
	bh=9DDhqZ5GL3bWLF2JQ/8wk/kYkmV0oNMb4pEvDyyutGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuSc1HgrnYqlIR5IA7gFBy0DCllUUiqvEWNLnT5xKoDG13YIC+KTR8xrj81gzd43ajIDFNfIyA4Y4Ia9R0g0txDGswvKbV20GjkAswi/+6i8EmsdRjfLRIu7kqzkgUsoy2Nk9wtMEjzDJcQVn0vryZyg2HCLxrEjBdaDIgfUg1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NzDwlEa3; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NzDwlEa3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734486149; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=st9j5bVLlDLGnivy9glLf5EF/HW2mUncSqB5KfxcHAo=;
	b=NzDwlEa3uiM1KYQ4cw4wmxSZ+whAx9swIAMpg8tEJBFS6o4Q8XRPNBZlKZ3yQ1qkD2t+8d34SEjlXO8ZahNIiMX6kmClxWnzR0WebuWQoo+lr1qH1RrjPeORok5jH3BZDANu98J2ArlFwSeRs0toM76MGIhM9QSfGyHNSXEFwro=
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WLkjHmh_1734486144 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Dec 2024 09:42:29 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH v2 2/2] scsi: ufs: set bsg_queue to NULL after remove
Date: Wed, 18 Dec 2024 09:42:14 +0800
Message-ID: <20241218014214.64533-3-kanie@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241218014214.64533-1-kanie@linux.alibaba.com>
References: <20241218014214.64533-1-kanie@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, this does not cause any issues, but I believe it is
necessary to set bsg_queue to NULL after removing it to prevent
potential use-after-free (UAF) access.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufs_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 58023f735c19..8d4ad0a3f2cf 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -216,6 +216,7 @@ void ufs_bsg_remove(struct ufs_hba *hba)
 		return;
 
 	bsg_remove_queue(hba->bsg_queue);
+	hba->bsg_queue = NULL;
 
 	device_del(bsg_dev);
 	put_device(bsg_dev);
-- 
2.43.0

