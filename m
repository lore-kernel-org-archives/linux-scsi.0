Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAAE14F112;
	Thu, 18 Dec 2025 02:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766025113; cv=none; b=dM+bLZlkBP+GT1vPf3avdgL/E869DFU5FZkZqDg/mznOPidyN2tig0Sw/EQjJGKcb07A2wbmLCqLd9A9PwX3Q7t91lY6esGACHumWmjdbzJEJjOzWQKIyow97AALZ0h2Qd8bai6YQBQirdSL3lyvFmEByNeLtZ/AL/P3JaAysPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766025113; c=relaxed/simple;
	bh=4fCswRjpfDl82tSXSPEGfo0daBAz734DQLcIlJ/OWqU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=f9HVVfkUIGbEIeeSiNlAKakFzWKZDUey+fbzZRG+KkdWnL/xN1u9ZYidVnkI/JdkdMC7QLNiSI/XixJ2eNpFPalU/CMoHv1XgGuDrVZj0XKq+NWTaUZ2Ogt+YS6H62wuEoXxdhPx6H4USLYRdufm8Nah9wqfXyQgCKJPJiCRpAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=UHQ7Anc8; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="UHQ7Anc8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Uq
	6zn7zxUHiaggC/hHMds9nPR1hVUetAtpiZrhbBN4w=; b=UHQ7Anc8GDMXLg8G4r
	rELx+Zh7wQuMK+bFtcwCZ7iAqy/xpfVqgy8/xwVtJFR8n+uxc1CUt/A3UHo4iFFd
	UfcPjp9z/OgM9ZYvGmK3DacpqasggKjOCcpvgbhqRfPTs+bE9/z4zWd/PfxdMgNl
	V5k6s4jj/ReDlacCWHX3neHJc=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgB31eODZ0NpYbVfIA--.96S2;
	Thu, 18 Dec 2025 10:31:34 +0800 (CST)
From: Miao Li <limiao870622@163.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	limiao870622@163.com,
	Miao Li <limiao@kylinos.cn>
Subject: [PATCH] scsi: core: Correct documentation for scsi_test_unit_ready()
Date: Thu, 18 Dec 2025 10:31:29 +0800
Message-Id: <20251218023129.284307-1-limiao870622@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgB31eODZ0NpYbVfIA--.96S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xw4Duw4DAr1rGw1kZF1kKrg_yoW3Cwc_Ga
	92kws7uF1Y9rZrKw18Zr1FvrZIvFsrW3sY9FnYqas0vw4jvr1DZFyDAr18ZF4rGr1Ykw15
	Ca9rZr1Yvr17GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRRTa05UUUUU==
X-CM-SenderInfo: 5olpxtbryxiliss6il2tof0z/xtbC7wcm82lDZ4dPWAAA3g

From: Miao Li <limiao@kylinos.cn>

If scsi_test_unit_ready() returns zero,
command TUR was executed successfully.

Signed-off-by: Miao Li <limiao@kylinos.cn>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 93031326ac3e..c7d6b76c86d2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2459,7 +2459,7 @@ EXPORT_SYMBOL(scsi_mode_sense);
  *	@retries: number of retries before failing
  *	@sshdr: outpout pointer for decoded sense information.
  *
- *	Returns zero if unsuccessful or an error if TUR failed.  For
+ *	Returns zero if successful or an error if TUR failed.  For
  *	removable media, UNIT_ATTENTION sets ->changed flag.
  **/
 int
-- 
2.25.1

