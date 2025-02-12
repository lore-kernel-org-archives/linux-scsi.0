Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62678202F7E;
	Wed, 12 Feb 2025 22:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739400294; cv=none; b=BE/21OY4zSzbEUKjL/mm/46XJW0cSqxQVMupb+Sf98Mlw1VUvsDSCkDafCA70Ydgk5S5QgvQN7rMc2Kso4Y2CvbUDCjt07jRwDCn99EZYfOdF1h7NrnmYG9GdR630svR9zB2DR29512xXqKhMkN77vjyhdMNBTWihUllD0J9n4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739400294; c=relaxed/simple;
	bh=z9K2SNQtTIdcySZ/ULm/lkM2yh+FA5LHsXlyB61Kgnk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ty3IGJy/d7GTA5QNbz3qGesZeCCgCYUeg3IHWCqcbhYbmxrMi/UImSLm7RMAO2Vm5qMn36hksdmKNyNOt1heL1SjsyNWG0kVgkfHw5ABIoZAaA9xeX7JGOkgxwA54yvARK/E0UjyHOYnZjnreo8oaxqLnx9UoWe0pjjpk9ZaWF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=exhtteN2; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="exhtteN2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739400289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=E/cxKPCvN17tUSvXSTT4NfZgXnCFHT0D3OhifJh6Y5M=;
	b=exhtteN2rEMT63dC1GLSP/ATefmHrQFZ3zqoLIXAASHfg9XSlwjgpP6gY+xMpGK1s3jX1b
	CEz1NViWMzjWTIJbke8phdr1clZ0ZISnSVuEdXdPb+TX6v2EZayYOj2A0Iz2wTmG5jzHGc
	1cs4HxZ5jC0PwNIKI1xXEFRIrqBFToQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-hardening@vger.kernel.org,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: hpsa: Replace deprecated strncpy() with strscpy_pad()
Date: Wed, 12 Feb 2025 23:43:53 +0100
Message-ID: <20250212224352.86583-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

strncpy() is deprecated for NUL-terminated destination buffers [1].

Replace memset() and strncpy() with strscpy_pad() to copy the version
string and fill the remaining bytes in the destination buffer with NUL
bytes. This avoids zeroing the memory before copying the string.

Compile-tested only.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/hpsa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 84d8de07b7ae..1334886b68d0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7238,8 +7238,7 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
 
 static void init_driver_version(char *driver_version, int len)
 {
-	memset(driver_version, 0, len);
-	strncpy(driver_version, HPSA " " HPSA_DRIVER_VERSION, len - 1);
+	strscpy_pad(driver_version, HPSA " " HPSA_DRIVER_VERSION, len - 1);
 }
 
 static int write_driver_ver_to_cfgtable(struct CfgTable __iomem *cfgtable)
-- 
2.48.1

