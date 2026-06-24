Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719B3346AF1;
	Wed, 24 Jun 2026 07:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782287626; cv=none; b=AwwvubsysCAfO311Gp+9knGaUmE2V2wZhM9oJbg9NZFqMavBSxVsS6MAMvDmLUDA1bJtLFZ4IDi9YPQ2VAs1deTCyX/xv2rAv+c/b40p/7o70OXViq3F0krIe1ufSIgjo8fMQaY782WcMvr/CfE5j3WhxZov1euFZ7kwSj1lxh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782287626; c=relaxed/simple;
	bh=3oRmFCSkxr3e9HlHiLfHB2B2Ud6wlxG36cRhd9K+y44=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ev0yD/7cFfP2q8bFGbWbd/PDfEu61OBcw6NduhHCDFCjayyOofHdg0+S0fW354OCxs0IZrH4D+zWe9oQPpGGjPacosupKvp7DkFDp68eWbrPOANb28vUpXUtzQjrxhVsfz8Mzdn6UbgHhlOF8TYuLjFJ+TqrUWJSPQwgpwjAyrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Kb8zL0Mm; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Kb8zL0Mm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=xW
	vTyXVWPTS+RNlrE97bcDl0yy1amozop+tHW7to0a0=; b=Kb8zL0MmHnzpgs9ZYF
	1y5x3lnBpRtyUc+j71o6EQAml8vpXxsh1OCe+7Fxtkg+4aR7S23uzOcZ53L7E5dC
	nc+pOTKw9ONNSA0VLGytGJCW7a3gewlSF+wlUIJtfPpPpcBxb8b3NimzJrbFj/pc
	n7v+DjRUXqO5WuwE+YsK+1ab0=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDXHxDnjDtqP1UsDg--.41004S2;
	Wed, 24 Jun 2026 15:53:16 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH v2] scsi_sysfs: Fix runtime PM usage count leak on device add failure
Date: Wed, 24 Jun 2026 15:53:05 +0800
Message-Id: <20260624075305.2853512-1-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDXHxDnjDtqP1UsDg--.41004S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zr48Kr1Uur4DCry7uw1kuFg_yoW8XFy7pr
	WrXa42yrWxWw1Y9wn0vF13uFy5JFWUt34fGFy8G3429a4kAa48t34rCFyjqFyrGrZ7uanx
	JF1DtF18Cr1rKw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pE_Ow_UUUUU=
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbC7QzHNmo7jOzBdQAA3V

Balance the scsi_autopm_get_device() call on the error paths of
scsi_sysfs_add_sdev(). Disable runtime PM before dropping the
reference when device_add() fails for sdev_gendev, since device_del()
is not run on that path.

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
---
 drivers/scsi/scsi_sysfs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04..14dcf45b524a 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1427,7 +1427,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
 				"failed to add device: %d\n", error);
-		return error;
+		goto out_pm_runtime_disable;
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
@@ -1452,8 +1452,14 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		}
 	}
 
+out_autopm_put:
 	scsi_autopm_put_device(sdev);
 	return error;
+
+out_pm_runtime_disable:
+	if (pm_runtime_enabled(&sdev->sdev_gendev))
+		pm_runtime_disable(&sdev->sdev_gendev);
+	goto out_autopm_put;
 }
 
 void __scsi_remove_device(struct scsi_device *sdev)
-- 
2.25.1

