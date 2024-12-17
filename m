Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30A81EB9E8
	for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2024 10:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734433138; cv=none; b=u0xeTzaLF0rdVrxOZTnYDKI/c5GNutKy8PR8QWdvVwyMNrJcDCmODkXTpVCLKgQ4k5mBJvqGij/AzEx6Xvx96xerTJ7nMzmBlUPUcvZO2+4v/3f6BCaAdBlrIdBRamnFHHxR+UyA79DiLY5JDeWScanGAp/atPsEaGEvMF+TuX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734433138; c=relaxed/simple;
	bh=gWrQlSTzr4nVUZNOUodnVFD6bjhpA4RtMJdrGKTKEu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgeTNSp8SAliqA3Pn29IxxTd17+WBKTw3z18NFjo8hzXa8sn4JsG6r7lgLY9AxwLbf37fEr3MxHAY0YBQldoWKnIcXHGNbcBl3uH+kjp77KzhsVI9TbdL7rwxuOG6o/wPJeQ/Awg6E1poTN9czMukC4PlyyvBwIrqp2qBNzk28w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=reCbolTk; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="reCbolTk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734433131; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=QW/xovfrvnu4XdsN/L25eDlZf5saxk45kn8XkVhNOLI=;
	b=reCbolTkELhEK0xxFRn861uNk25LHwi8M94v3uhHPcXnESLaLZXggpM++pJ3ouNZiKCrFv+Rw9oEE2HjKnQCvG77jyMkghgCIsHhH8FjoKxchuDeQstFDa6br1+g1SkMK5xr7WIqMpuk3DgP7BT0x6Cs8GT+T3pxZvGwAYCpc7o=
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WLiZ2-y_1734433126 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Dec 2024 18:58:50 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] scsi: ufs: delete bsg_dev when setup bsg fail
Date: Tue, 17 Dec 2024 18:58:39 +0800
Message-ID: <20241217105840.120081-2-kanie@linux.alibaba.com>
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

We should remove the bsg device when bsg_setup_queue() return fail
to release the resources.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
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

