Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264EE442F
	for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2024 01:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734486151; cv=none; b=FVYYCZfeiOPzlPYwwIRiGqmGFJrIacONB/QGVyRZOu0d8+RY81vVvtEsIocmT1gkAAY0eMAUkStkY4lHLfeWAZDeH0d3xHZqzf3//HrEv2vYfWgiqf7NaIujvFbYZW+bxgqQRMLCxeopgeX/LqOz/6w+tc/TAAsXar1zvn81h9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734486151; c=relaxed/simple;
	bh=AqBTh1fC8EvQj6s5iZTRjE+R/6ZpNfBSzGiB5v2q0+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0Zb2fZCrgb3fwoZhAdu82lawV48R2Qtv5iY8VXZoAKrDWLNuuUOCHVzlI7YX3KWxZEUu57hbhxF10t7K8QlhUwPiY14FQ6EJgDZuuWFsNZy+RzIWJijp/3Hdys8SbRTuPTH1NJFoS2ai8pIOdQ/kRTdwTc8IC5/OZ7JZHd4qhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BX3J5G2B; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BX3J5G2B"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734486144; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=PODfGPGC4nyt3k892CCFR/jqSesuqcwxiHx4cZgk/WI=;
	b=BX3J5G2BPHXbnjC4J7+ZdSIWfVc3yECAnzMqLYPqEGtVcFjXXLh1uiVv/mOzuUi13Z3+EDc12zDiIV5zFFa3IRPsgo7idXAlSl0W0/ol3Jkuvapfhne6cxb6RqOtYDwS5vQ5Anf6C5B8Qd97bxxmlH7n+nnBUJJiC8PjloNUwCs=
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WLkhQP8_1734486139 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Dec 2024 09:42:24 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH v2 1/2] scsi: ufs: delete bsg_dev when setup bsg fail
Date: Wed, 18 Dec 2024 09:42:13 +0800
Message-ID: <20241218014214.64533-2-kanie@linux.alibaba.com>
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

We should remove the bsg device when bsg_setup_queue() return fail
to release the resources.

Fixes: df032bf27a41 ("scsi: ufs: Add a bsg endpoint that supports UPIUs")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufs_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 6c09d97ae006..58023f735c19 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -257,6 +257,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 			NULL, 0);
 	if (IS_ERR(q)) {
 		ret = PTR_ERR(q);
+		device_del(bsg_dev);
 		goto out;
 	}
 
-- 
2.43.0

