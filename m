Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2963813CFB6
	for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2024 11:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734433464; cv=none; b=uoPIx1LPmT4kEPS9bYp2LNAipFVQlduwZrVdPWmFDXsNkKc6INuxYrm9pNmvZs7Yc4JV/CbQ9o8wdEF0RNvdXkfHCVPC0cL4mAZ85lntSJd1MEI7r0FtW3jwJmHMQOGkCx6do37gQ5p99yeo8ugwG0nPYo0mU7Bu84XVh3gm0cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734433464; c=relaxed/simple;
	bh=vQlwdr6AATRfPwOsOMKmKHv5WVxy7vHjHmyBkGRHVug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pkRMGm9OSafd+69owQ6jzNzsYtWLzsrVNsnVLbsjJbILJ0p3kCoLsI3Z0DK7VlmYyxHGUckSdyyalcWQCR1AO7pqgy+LExdclO3XIIhXTEpEsix3QwRbSECE/S/KDV97zV1FEtgiT0gV6N0djddTpjbdS4c8tkXYtQVaujqkNfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wQWHsnb6; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wQWHsnb6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734433454; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=+3abJLPLXpvW745cWekItCsjPfh1jhDhErTz4GOQWM8=;
	b=wQWHsnb6fWaXhh7UNIU8fcLDZhKwZy52Xamc6aN/J+KmlSa5ZpaKa0UqPfsUnaPhhGOlA228SsGkdQRSua4zIBDCabxIVcq7A+cRoBXaIZRjsHXdSxiddZtQnX89/wcpifwZxvumL5JDRDKguHeUe2FF3j5jq6imr7Bbca4ztjc=
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WLifgAu_1734433448 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Dec 2024 19:04:13 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2] scsi: mpi3mr: fix possible crash when setup bsg fail
Date: Tue, 17 Dec 2024 19:04:08 +0800
Message-ID: <20241217110408.126413-1-kanie@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If bsg_setup_queue() fails, the bsg_queue is assigned a non-NULL value.
Consequently, in mpi3mr_bsg_exit(), the condition
"if(!mrioc->bsg_queue)" will not be satisfied, preventing execution
from entering bsg_remove_queue(), which could lead to a crash.

Fixes: 4268fa751365 ("scsi: mpi3mr: Add bsg device support")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
---
Changes from v1 to v2:
- Add return statement when setup bsg queue fail, sorry for the v1
trouble.
 drivers/scsi/mpi3mr/mpi3mr_app.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 10b8e4dc64f8..7589f48aebc8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2951,6 +2951,7 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 		.max_hw_sectors		= MPI3MR_MAX_APP_XFER_SECTORS,
 		.max_segments		= MPI3MR_MAX_APP_XFER_SEGMENTS,
 	};
+	struct request_queue *q;
 
 	device_initialize(bsg_dev);
 
@@ -2966,14 +2967,17 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 		return;
 	}
 
-	mrioc->bsg_queue = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), &lim,
+	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), &lim,
 			mpi3mr_bsg_request, NULL, 0);
-	if (IS_ERR(mrioc->bsg_queue)) {
+	if (IS_ERR(q)) {
 		ioc_err(mrioc, "%s: bsg registration failed\n",
 		    dev_name(bsg_dev));
 		device_del(bsg_dev);
 		put_device(bsg_dev);
+		return;
 	}
+
+	mrioc->bsg_queue = q;
 }
 
 /**
-- 
2.43.0

