Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9262D2F6583
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 20:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758572362; cv=none; b=TSoOg8yrOnrsRkAEOKmWcaD8znFvwnm86M+J4tS39T3z2id1BJR8g0f0eLP83BPAcQNeguCpn4Awneh0NWPwdlJhFqlplB84q4VTG5zSWdr01DKgPFRcO4X14IsisoRGc/mkJ4gFGqqaLksIdtn87fPWhnqgvwMiFhiaZ+hNn0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758572362; c=relaxed/simple;
	bh=Wjj5orz1Ls2CmQfDaIzFeM+RMmWdHrc6IpmRS8oj2cE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qPVhxg0OB6b5EXsjoZuiQBoJAQ6JN4zUdGAJxjbn9ECoCMj7uNBxFeJxahrGL2cwX2NBr0HR4y7BHBn10VN8+9kaZKnCwoaJR8T+6mVdS5eKDYSvdTBKYIxzHgtGmyiIYd4P6TGIwblxcftnYT7/9I8abZ7khrTl7jzeR+X1IHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NMWwzLT8; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NMWwzLT8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758572358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IuZR+nPkiRhCz8T90e0V2L3HEyIm3Q690MeSbxQKeMU=;
	b=NMWwzLT8M4RGJ/zUJG7hO+v+bz5Cj+8AIAwzQgqQm4/rb07TTQQhFuLxcIw4s3e9dG6TqT
	HNeFU6ACb3QXUVeDJwiv/r0EdF4fowykbQ8+zYhHjneR9iG3UhpL0Hf1MNXZkU80uVpgy+
	x3WaNshFOMtbfvyQPdmpxZl4gA3/PlE=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: smartpqi: Replace kmalloc + copy_from_user with memdup_user
Date: Mon, 22 Sep 2025 22:18:33 +0200
Message-ID: <20250922201832.1697874-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace kmalloc() followed by copy_from_user() with memdup_user() to
simplify and improve pqi_passthru_ioctl().

Since memdup_user() already allocates memory, use kzalloc() in the else
branch instead of manually zeroing 'kernel_buffer' using memset(0).

Return early if an error occurs.  No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 125944941601..03c97e60d36f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -20,6 +20,7 @@
 #include <linux/reboot.h>
 #include <linux/cciss_ioctl.h>
 #include <linux/crash_dump.h>
+#include <linux/string.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -6774,17 +6775,15 @@ static int pqi_passthru_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
 	}
 
 	if (iocommand.buf_size > 0) {
-		kernel_buffer = kmalloc(iocommand.buf_size, GFP_KERNEL);
-		if (!kernel_buffer)
-			return -ENOMEM;
 		if (iocommand.Request.Type.Direction & XFER_WRITE) {
-			if (copy_from_user(kernel_buffer, iocommand.buf,
-				iocommand.buf_size)) {
-				rc = -EFAULT;
-				goto out;
-			}
+			kernel_buffer = memdup_user(iocommand.buf,
+						    iocommand.buf_size);
+			if (IS_ERR(kernel_buffer))
+				return PTR_ERR(kernel_buffer);
 		} else {
-			memset(kernel_buffer, 0, iocommand.buf_size);
+			kernel_buffer = kzalloc(iocommand.buf_size, GFP_KERNEL);
+			if (!kernel_buffer)
+				return -ENOMEM;
 		}
 	}
 
-- 
2.51.0

