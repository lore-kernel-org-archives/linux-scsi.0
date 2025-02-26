Received: from out30-85.freemail.mail.aliyun.com (out30-85.freemail.mail.aliyun.com [115.124.30.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708D825A33D;
	Wed, 26 Feb 2025 03:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740541091; cv=none; b=FRWpBO86coPseEjBJorpE/xG8n1PYYsyt9Q2LvL2VbxvOa35UZEzIlZEmk+2RM5VxU9kz7Vmz/mrDvuIiwgePJBHXyUDGiS26OoQWSHcm/ujAu4x0igQ7FckBwJKRFn7p+AsD7MtaZjq7O2AwOIke8JQY3WeJQEO7wVblxDNSRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740541091; c=relaxed/simple;
	bh=tl+hIViqGcJN9EAhpBn2DhDk/dQx1zV1lpZjUUKNoM4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AaP94zFmwhG4NC+wX2TRU9WnOTU5pgw1isnnorSzsQkSNdBXckpW+fX0xn7DRMpTUVnkG3IgtRHiyux8Aa9JyYNS3ZZjXhP57AVevlRp5o3QB1Vsrl0TGry7Q06jwjNbZ5hJaC8aHdUeUHfHybc052wRz/DMlYB3szcSV/1bjx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=xBRrq+7H; arc=none smtp.client-ip=115.124.30.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="xBRrq+7H"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1740541086; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=OsKNsNmNLVMbVkhyVLShvvRjQAaJ25qqPxT54PpSMw4=;
	b=xBRrq+7HrdUdUuLLHVgKmOBermnbpIubERCA0ySM25KUAV8ap7iHVz1A9rR/Hkif9rg+zQN6yylRIJ67HdO2Ix3Gjyb9S7sgFljdexSdbeFs7cKODh3/jO+Xd8/zjlggJfQx/hYZ4sNMgGkPC5dt0NZF6Tnw65PFQYiROMHSQK8=
Received: from wdhh6.sugon.cn(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0WQGbC7D_1740541085 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 26 Feb 2025 11:38:05 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chaohai Chen <wdhh6@aliyun.com>
Subject: [PATCH] scsi: fix schedule_work in spin_lock_irqsave in sdev_evt_send
Date: Wed, 26 Feb 2025 11:38:02 +0800
Message-Id: <20250226033802.233509-1-wdhh6@aliyun.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sdev->list_lock is designed to protect the sdev->event_list, the action
should be single(add, delete, traverse) in the lock.

Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index be0890e4e706..ca1bbd5e38c0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2661,8 +2661,8 @@ void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt)
 
 	spin_lock_irqsave(&sdev->list_lock, flags);
 	list_add_tail(&evt->node, &sdev->event_list);
-	schedule_work(&sdev->event_work);
 	spin_unlock_irqrestore(&sdev->list_lock, flags);
+	schedule_work(&sdev->event_work);
 }
 EXPORT_SYMBOL_GPL(sdev_evt_send);
 
-- 
2.34.1

