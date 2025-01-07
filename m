Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51586154BF5
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 02:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736216450; cv=none; b=exrdPFZ+sThGSs8JEiw1zbDeAQnaGVqTUKUUkk2iEfRlqsXM9fcmfURzM9tvtScwfCfr1gq77clL9scEfSG0a/R0VjhlaehMddFuP+dT5AxEYZTfzOcUEPUqYEtjwLsSp+Nk3S18njINY4dkXKTyYvK+74ElZLioUDSi7gFmneU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736216450; c=relaxed/simple;
	bh=nBBQzWcqQnxqzZ84DdmHGJc3K1e8OrEkyec8pneqUlw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gC1vs2/ChnPyutghNYSdVSQ20SpM4A2eKHBFkWMkHS6sWt4T2LGdNb/kWoRYGCVInkoNsceAvn3UnFbaEE9nhshPGRWtrx29s1q4Y+00PwWgGg1/pg5gBxh+FnfhLMbIQiGUornguBbXDKFpgex/nBmIXRv8BG5yy6Tv4M05VZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=k4LNwDbO; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="k4LNwDbO"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1736216437; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=qTZdaUe9FmBJxhyFYnvIk1mFlYvfchK3KzwBRbRWIx8=;
	b=k4LNwDbO9hAaoGOul2JiKBWs4sR/tscFo7dq5Bew9S7oSBzSiiwuv8zVVKBEw0U8g9daTloOQq8JGIJekdS3ghh6jrXa0+MIh5LvFJ5BnScrd+lEMqLFtBQb7wKfAsaiWpQVl+Ybsqti/NUE6LWlKqftL9E1uGPVoGYJDo4ktzg=
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WN8tlzR_1736216432 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Jan 2025 10:20:37 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH v4] scsi: mpi3mr: fix possible crash when setup bsg fail
Date: Tue,  7 Jan 2025 10:20:32 +0800
Message-ID: <20250107022032.24006-1-kanie@linux.alibaba.com>
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
from entering bsg_remove_queue(), which could lead to the following
crash:

BUG: kernel NULL pointer dereference, address: 000000000000041c
Call Trace:
  <TASK>
  mpi3mr_bsg_exit+0x1f/0x50 [mpi3mr]
  mpi3mr_remove+0x6f/0x340 [mpi3mr]
  pci_device_remove+0x3f/0xb0
  device_release_driver_internal+0x19d/0x220
  unbind_store+0xa4/0xb0
  kernfs_fop_write_iter+0x11f/0x200
  vfs_write+0x1fc/0x3e0
  ksys_write+0x67/0xe0
  do_syscall_64+0x38/0x80
  entry_SYSCALL_64_after_hwframe+0x78/0xe2

Fixes: 4268fa751365 ("scsi: mpi3mr: Add bsg device support")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
Changes from v3 to v4:
- Clean up the call trace (Bart).
- Add the rb tag from Bart, thanks.

Changes from v2 to v3:
- Add the crash stack to commit body.

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

