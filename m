Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E4B323A6;
	Fri, 21 Feb 2025 03:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740107318; cv=none; b=c/qhaXf9zpUyGAh5PtgRXz/8LpEJPTeAOrE1A6+z6EUF/614NYsw8JHr5PVZtQcfRhPY7EgIz3HoJyM310DwPC7i2xu6WudAOjdmxNh2Dl0EkwojgXWPRJPtR8ggRKkDOHQ5LWCBMYqYAtLm6/Z2XAxVLHvw6BtGcCPT6Qd53RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740107318; c=relaxed/simple;
	bh=aMh7PWd/nPU+F6S05farHl3FMDorY9sLkJX/uYIxCLk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sUE/JmqD3qKRAIjdj4a8sZ0kGE6F0yWtCDwSJe8QiLL2ZfRP/SUJ5J/HkyPI3gEsdla5vB7hHTNdR2dC4HGXjMQR22CDU/VWr1MxqTKNQKnOCK1mKtfLZollkYxHs8IfS+uhHJoWdCsTdP7CRSvkYk5JMZu9lfmnN8T2FE7edNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=iIcoiqYb; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="iIcoiqYb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=QhmKk
	EpK7TAbWhCmZSDRLTRjZc6e3DY7VfFo5NaGp1M=; b=iIcoiqYbaB+zlDQS5vhmP
	unpU/YilBpFvzxqxRfQjiEDbifoSjxqudbji0tGsW1BkY1ALzK9q7ifjFLNq9eW7
	tnkGxjbEOh55nLgkAyX2J9ajQGA+9OWnpQLI8h/+rAOzhzN9bkNv9VC9Q8Q7x5Zt
	moR44Zf2R3DGmeUtvh5idw=
Received: from wdhh6.sugon.cn (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgD3P_8O7rdn5BLdAQ--.10993S2;
	Fri, 21 Feb 2025 11:07:59 +0800 (CST)
From: Chaohai Chen <wdhh66@163.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org,
	Chaohai Chen <wdhh66@163.com>
Subject: [PATCH v2] scsi: fix missing lock protection
Date: Fri, 21 Feb 2025 11:07:55 +0800
Message-Id: <20250221030755.219277-1-wdhh66@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgD3P_8O7rdn5BLdAQ--.10993S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw4xZF13uw45Ary7Xr15XFb_yoW3trg_ur
	ZYqrn7GF4jkr47tws5tFW3uryj9r48XrnY9F1fta43ZayrXF1ktas3tr43Z3yxJrWkCr15
	Aw1DZryFyr1DGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRNNtxUUUUUU==
X-CM-SenderInfo: hzgkxlqw6rljoofrz/1tbiEBX61me36jtclgAAsi

async_scan_lock is designed to protect the scanning_hosts list,
but there is no protection here.

Signed-off-by: Chaohai Chen <wdhh66@163.com>
---
 drivers/scsi/scsi_scan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 96d7e1a9a7c7..4833b8fe251b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -151,8 +151,9 @@ int scsi_complete_async_scans(void)
 	struct async_scan_data *data;
 
 	do {
-		if (list_empty(&scanning_hosts))
-			return 0;
+		scoped_guard(spinlock, &async_scan_lock)
+			if (list_empty(&scanning_hosts))
+				return 0;
 		/* If we can't get memory immediately, that's OK.  Just
 		 * sleep a little.  Even if we never get memory, the async
 		 * scans will finish eventually.
-- 
2.34.1

