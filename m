Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AAE1E8823
	for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2024 10:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734433146; cv=none; b=qorPWh97MpfxO5L5KMR+/Celf/xXqJvp7FYnoauDP9kCXmVPpbQUjlMPYoLzpgusgV6M2hs/j6FdZsf3NQyatS+lRb8RD7lUHI5EdCBatff3Z6RfROz04UhOMRfLree9fqJa3mu9AKHMcEM5AviPV2EfIQ0ARhwG65HDKWU9IHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734433146; c=relaxed/simple;
	bh=0q/vRBue26MgCPntAdFd60YFDQHhIcfoeTMFI7wi08w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTc63qaRZCetSyWhIgdCur7IK6F3jwjxdXU388W6J8O7caZ8lf0zMnCO21MVoI3tN3Z0bo8QH+/cMh6Rr/kFP9pJRJ9xyiJl1s+2VU3dOUeUSXMBueM9yNXZW2h8KQ3Wh2L6Dn1pPzaZl92cbXphYS04WzyaLZ2I1G8TCdpbco0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FS16hFz8; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FS16hFz8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734433136; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=s/7w0ibCS2KTb5dCH6Je4t8+tD3bgIfnHg/yaZWWvaw=;
	b=FS16hFz86P/OHDv3g5ixa7OQQre171uywfPdmas7SE8dgYuBOuXFirZ8SHbxSq7z4zPu1VJC/pHYodWvLZlAMI8dFF7blwUpQZGOMz/uzI70Z199flazAufVgezVbKd6X/UIhFwByVnrS0a6QMBDV3S+UpNDT+eSyBy71WqUXlI=
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WLiZ20N_1734433131 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Dec 2024 18:58:56 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] scsi: ufs: set bsg_queue to NULL after remove
Date: Tue, 17 Dec 2024 18:58:40 +0800
Message-ID: <20241217105840.120081-3-kanie@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241217105840.120081-1-kanie@linux.alibaba.com>
References: <20241217105840.120081-1-kanie@linux.alibaba.com>
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

