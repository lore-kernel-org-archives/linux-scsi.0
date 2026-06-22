Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DCF2E54AA;
	Mon, 22 Jun 2026 15:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782142663; cv=none; b=hs9P1HdbxZrZt6NcvFykRdMbJt0pDqTeX5uyoehtLL+kv2Mn1/4Jl07lNtK3ALya5ajW8iaOJy23oWnM65hrED4GcfyloGQ0OjDogc02uk3xMoFd19Ca2NZU3bSgTSAAVhrwfkQlg4LWwYo919uPTXQMB0HPrzh3FuGZPpiuBT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782142663; c=relaxed/simple;
	bh=kTeZoZlCzmEAynQLq6rXjNDMRpiS9VxJOvqTtGtfDnE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p7D09K9oBhk3awzK8w11NIARsfcE/9R8KLOXp75tP2mA73z5VzkJ7omatHXIh5dhgQjRHzlXQ6dKI0tXk5eNrtBPcYEdrVUDR5h3F+ld524mxHVZS62Fup1HwRuKXj/wceEwWgFkDjjGKOJokwxWw/BvT05rwTuZ3j8XqJ0a98o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LnTLKBJR; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LnTLKBJR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ay
	IrKN6ZzEsGpyQyzR2UIgDDJFyUdI13EqmRHCJyB8k=; b=LnTLKBJRIM8oukN8b3
	BoTABaKDacPe3dzErp2NdUdEumpl02Rf78tGBneGkUwmIv4gxQypUuZe/HyGSYRO
	dAnvvSomXTAMuzMz13TeuxdlK+YgTV6DS5XRIfl0QMNVoa/pKCLbJ4HgRqb5u286
	AWMloGQAPreOcYjzJv3VH0K/o=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3n2ixVjlqAeInFA--.45407S2;
	Mon, 22 Jun 2026 23:37:23 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH] scsi_sysfs: Fix runtime PM usage count leak on device add failure
Date: Mon, 22 Jun 2026 23:37:21 +0800
Message-Id: <20260622153721.1220711-1-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n2ixVjlqAeInFA--.45407S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrZFyktFy3WF17Ww4kWFWxWFg_yoW8Jr13pr
	W8XayjyrWxGw1Y9wn0gF4fWFy5JFZFgw1fGFW8G34I9aykAa48t34YyFyUWFyrGrZ7uanx
	JF17tF1rCF1Fgw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piOeOPUUUUU=
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbC7hOqGWo5VrP-1gAA3R

Balance the scsi_autopm_get_device() call on the error paths of
scsi_sysfs_add_sdev() by releasing the runtime PM reference before
returning.

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
---
 drivers/scsi/scsi_sysfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04..6b009e4f4b9e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1427,7 +1427,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
 				"failed to add device: %d\n", error);
-		return error;
+		goto out_autopm_put;
 	}
 
 	device_enable_async_suspend(&sdev->sdev_dev);
@@ -1436,7 +1436,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		sdev_printk(KERN_INFO, sdev,
 				"failed to add class device: %d\n", error);
 		device_del(&sdev->sdev_gendev);
-		return error;
+		goto out_autopm_put;
 	}
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
@@ -1452,6 +1452,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		}
 	}
 
+out_autopm_put:
 	scsi_autopm_put_device(sdev);
 	return error;
 }
-- 
2.25.1

