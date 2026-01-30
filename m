Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAD3218821
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2026 08:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769760138; cv=none; b=WkW+PCsjvpFUhEUDkzU5bL7bxsDyfonaAYfiV9JdjdK88ghWoHQTjvVM1ne3rg4Ebp19zqaYo866CCpmXoOAfNP8kSWTcpOB5nRAHG2e1Uax8Ymwp4BREBfJdoruHIsR2DSueDvzlx0p8WzYjCsdTNA6ix+7nCp6Ok/l5yECI3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769760138; c=relaxed/simple;
	bh=sTy9gTXaVVls+tbdgjS1MW+/hfk2s14b97d4VT+JjMI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bD+9nR2QoFf0676V+VB0vrfhhRJo+4NnUZmWu/d2ANyXShCRbHdYsbZyzKpp6Fwv0Oj13VFdbKN84/NIGLUlSLLoKrYl7FPZMmoIG3EQ14X3OWE0xt4l3BKDi1S7ZBHyLdDj4aMzPESYgdMp78clCKlNV0bEu3ZM0/6MO5gQQQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=nCPrPp0q; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="nCPrPp0q"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769760132; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=PI78EppF0qajnP+iJpNVBjMc2/rU/DtGUnxDfFkUH3k=;
	b=nCPrPp0qMLGZQSf8fvSy9zvBzZP0MoHRVakAnKpfnDpSdZLPFXsm0X6nRhrO4GSqXK1JLdaBiusTc99dlosPsbijIcSlo8Zlk+qcsw77O3bKt51gbDKIsMeLpFFGBV2MwXVtrizaLiHoTKrBV2ju87rJ7QvGkdbjX2469n1zrck=
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WyA5QkZ_1769760127 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 30 Jan 2026 16:02:11 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: Make driver probing asynchronously
Date: Fri, 30 Jan 2026 16:02:07 +0800
Message-Id: <20260130080207.90053-1-kanie@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Speed up the boot process by using the asynchronous probing feature
supported by the kernel.

Set the PROBE_PREFER_ASYNCHRONOUS flag in the device_driver
structure so that the driver core probes in parallel.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index d4ca878d0886..99fb37fa4f6b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5983,7 +5983,10 @@ static struct pci_driver mpi3mr_pci_driver = {
 	.remove = mpi3mr_remove,
 	.shutdown = mpi3mr_shutdown,
 	.err_handler = &mpi3mr_err_handler,
-	.driver.pm = &mpi3mr_pm_ops,
+	.driver = {
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
+		.pm = &mpi3mr_pm_ops,
+	},
 };
 
 static ssize_t event_counter_show(struct device_driver *dd, char *buf)
-- 
2.32.0.3.g01195cf9f

