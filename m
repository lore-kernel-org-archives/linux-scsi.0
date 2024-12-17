Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5771D63CC
	for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2024 10:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734431497; cv=none; b=MBFgiHHjx9YJRsQR6/G9JK+a4Q9mfEJ4i/0FcHMC/XZHkt8fV7SiXooDWEKUI9MrEbj5/NTqscKfzal5l4uFBNfBpZPziT53VAqRsNhWUc0Ac37swdNtdamQ5Ro1wjultLew+tl8loqCbUDioYVKYN6yG94rzkGjtCX0QM0qWTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734431497; c=relaxed/simple;
	bh=fajVf/r3LPJsa9GAi29E1rTXH/qGwzuvrJ6v36PQzlw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ly9YOclxEFWzSDmTrEnpwGPYRrWYRdeQO2fJuB9mMqYXiu1SqZOI+biaxlBMXeNr4X9L4+30eHqAohaqhtLnnk4Mb3RnXBwKRni+aVNlJtl74pkzkfSkBDPoFH3366612HtSfXypJCjOUJV1PVuiHsd/naYEIaGtgs/UlYuL2uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gTXWm3Z5; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gTXWm3Z5"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734431492; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=oFWIM/KAvGFbJti/0TJxnLfdri5EIhGQDulcIINopRo=;
	b=gTXWm3Z5vHCbLdoxgHBTIlknL7cd4In3n7LdJQTKtbJaCB9E1UkTHXtqnOUs6oitWItFxxgmUSj00WUqTZVL6AXV7e06/QMYC0MEone9RTmnCYAtO50otJrqvxkzxRkBqEva57/5Bz2xo5mHSGXM6MflbCXimCVit6ObV0L1+mI=
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WLiRTWs_1734431486 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Dec 2024 18:31:31 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: fix possible crash when setup bsg fail
Date: Tue, 17 Dec 2024 18:31:26 +0800
Message-ID: <20241217103126.88206-1-kanie@linux.alibaba.com>
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
 drivers/scsi/mpi3mr/mpi3mr_app.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 10b8e4dc64f8..f4cacae1d3a4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2951,6 +2951,7 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 		.max_hw_sectors		= MPI3MR_MAX_APP_XFER_SECTORS,
 		.max_segments		= MPI3MR_MAX_APP_XFER_SEGMENTS,
 	};
+	struct request_queue *q;
 
 	device_initialize(bsg_dev);
 
@@ -2966,14 +2967,16 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
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
 	}
+
+	mrioc->bsg_queue = q;
 }
 
 /**
-- 
2.43.0

