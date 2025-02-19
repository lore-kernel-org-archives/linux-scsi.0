Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 838921C54BE;
	Wed, 19 Feb 2025 08:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739952708; cv=none; b=hEFcJUoaXQXgGNAz6S4CWOTq+3vPnJbQ2Qq4JGgGQsNEqhy8qK52vQlWYt/LJRN7PF0nD9j5KO5V23dXIdxRAIVjqcnuoFzUJkp03tCgRedxmqgxEoO3EKiHt3Ao9My80Y/Ho+d8sqoUBOvvL5yY6uJJHeP7hJEWZrrthHojXj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739952708; c=relaxed/simple;
	bh=elTfSUpJus9Dh01GMc0HZ/JUEutfoMK622ZRG8wXE/I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nC0s8D82ognkC+1xOdFo25Z82giKA4W2DwTAv6q/MB9ZQQL5s37hlQR7pSfq8B0877Ck4vydAhmqmws7fVht2kZRiygewh+Zm8dcoMRCuZQSfk4LkyYi8vu+80dRmpKTc6hPVwNdeqwVj+18N//CS3H22Puz6osja1h2Uq6mUWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=eA12FOcn; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="eA12FOcn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=pIf9b
	39a574X2F7JDmFa9sO7taNTVX9ScalIAYOkPeA=; b=eA12FOcnM6eKw6cUarc1H
	PJwxMDweb5TS0nk0TMPsWFhF/sIRtPrlHNL8fFL5+JfiKgzi6Hv8ekaZ2VawjwT/
	ZZfbHGP+KlkExh69yB26OMNL9w1lmIAPpCOjNrBQ/U3SUrxDooRZnQ47Ly9/2+rG
	XLQgQR06cZ5YpQk9UgZxMc=
Received: from wdhh6.sugon.cn (unknown [60.29.3.194])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgB3I7Q1krVnIyHBOQ--.44615S2;
	Wed, 19 Feb 2025 16:11:34 +0800 (CST)
From: Chaohai Chen <wdhh66@163.com>
To: martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chaohai Chen <wdhh66@163.com>
Subject: [PATCH] scsi: fix missing lock protection
Date: Wed, 19 Feb 2025 16:11:19 +0800
Message-Id: <20250219081119.203295-1-wdhh66@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgB3I7Q1krVnIyHBOQ--.44615S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jry7Gr48tr4fGw48Xr1rtFb_yoWfXFX_ur
	Zaqr97Jr4jkr43tws5tay3Gr9F9r4rXr1v9F1fta43Z3yrX3Wktas3tr43Z3y3CrWkCw15
	Aw1DZryFyr1DGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_L0ePUUUUU==
X-CM-SenderInfo: hzgkxlqw6rljoofrz/1tbiKAz41me1j+ZBLQAAsd

async_scan_lock is designed to protect the scanning_hosts list,
but there is no protection here.

Signed-off-by: Chaohai Chen <wdhh66@163.com>
---
 drivers/scsi/scsi_scan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 087fcbfc9aaa..9a90e6ba5603 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -151,8 +151,12 @@ int scsi_complete_async_scans(void)
 	struct async_scan_data *data;
 
 	do {
-		if (list_empty(&scanning_hosts))
+		spin_lock(&async_scan_lock);
+		if (list_empty(&scanning_hosts)) {
+			spin_unlock(&async_scan_lock);
 			return 0;
+		}
+		spin_unlock(&async_scan_lock);
 		/* If we can't get memory immediately, that's OK.  Just
 		 * sleep a little.  Even if we never get memory, the async
 		 * scans will finish eventually.
-- 
2.34.1

