Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5C02E92A6;
	Mon, 24 Nov 2025 07:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763970916; cv=none; b=DgwlHpxDwt9vQFvPFsKvfieVGeiXRJj3xJD4ckwqWWwtzQwmJIkAdnvL+L/P9+XLGiL4SQf3q+NLnshR+C6YL0Z64Tb7FWTXqNsUQQ9d2eQSHBJJ8U0P3NKusYNmG8Uay99vn4ZaUyQU9joNGaScFMKK6a7HzaOdU3axZ0mT2T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763970916; c=relaxed/simple;
	bh=kj7M8ijDDNm7vZrumWE67rtZR1okf9MkRS6J5i1g8Ig=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nRmG8asnnGseYkVhUQcw/tNpSu5zFtNSXqE5hK96FRvw8K7Gdj8x1waDLsvlpSysYiUDvmYt64sQ8zi84Ll+E9aepTwJBIYJrLywP7PjeYdJrrXIOcgu6v9zqLl+skebKZoPVWb1M/sDuLJeCG3xLi0FfE373DxA5aif7nsoX6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=YGbLB0Nb; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="YGbLB0Nb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=KE
	p6OEeQjyBLRw96T6uVyiLsy8fYCs9k0A9JRhOf6OE=; b=YGbLB0NbruiC6d7Jam
	SVb/mpGKP0PQyQRvk3adYdyOWLedmIDZoWAUmEDiUcmWRyJMi8UvtOv/Uge/r+sf
	oQUW7ll3+kuFYsuqaD77WGoHxu3fB9AtXLDWlZ86KJ89iOK5IsLAGaW5FVqv9ljm
	bGtqKXNbSvilJvckvNMkcyeB8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wDnLTpJDyRpRLWeCQ--.2594S2;
	Mon, 24 Nov 2025 15:54:50 +0800 (CST)
From: Miao Li <limiao870622@163.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	limiao870622@163.com,
	Miao Li <limiao@kylinos.cn>
Subject: [PATCH] scsi: scsi_lib: Correct the description of the return value for scsi_device_quiesce()
Date: Mon, 24 Nov 2025 15:54:44 +0800
Message-Id: <20251124075444.32699-1-limiao870622@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnLTpJDyRpRLWeCQ--.2594S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr1DAF1rJFW7WrWkXFW8Zwb_yoWxKrX_ua
	92kw4xWF1UtrWIvw1fXrZ5AryF9F4DW34ruFsag3savw42qr1kXFWUZr15ZF45Xr47Aw17
	Aa9rZr4Yyw13GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRKxRhJUUUUU==
X-CM-SenderInfo: 5olpxtbryxiliss6il2tof0z/xtbCzgo5B2kkD0q+VwAA3b

From: Miao Li <limiao@kylinos.cn>

if scsi_device_quiesce() returns zero, the function executed successfully.

Signed-off-by: Miao Li <limiao@kylinos.cn>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d7e42293b864..072d477b8f4b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2735,7 +2735,7 @@ EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
  *
  *	Must be called with user context, may sleep.
  *
- *	Returns zero if unsuccessful or an error if not.
+ *	Returns zero if successful or an error if not.
  */
 int
 scsi_device_quiesce(struct scsi_device *sdev)
-- 
2.25.1

