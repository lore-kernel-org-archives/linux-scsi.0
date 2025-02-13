Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B83221D3CE
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 11:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739446895; cv=none; b=lJZqgfMwu94MFl4zwuSR88brpMuPYWTAP5/sGeLDO5l6LEsiulQw/fSJGlyMjTrfKrS8Ov64YsgQehRfIej9/9/putml2T/Z2VYhAIgrlL264rhiOnTSdJ10QaOcuhfGnsmLvZLwoWMO6bjkAw0BPsdptdnAg5d60OweOMGz5Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739446895; c=relaxed/simple;
	bh=+qKUAWjFc48ziEJIkUk+8ESw3UmXJzNOpYUOg1HgaSs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MPZfrOjDXkXLy88xFJLYi+wT/vjT3AEIbMqDa09xQYzEFyqSlSqZ9lhQgxAp7wHFSGk+oetsy2K62E8mafApPu3HIBmhUGGXHvbRSFyPIb6f0IxT67fDUdpCYAuii0S+HT3rx9BU069MUJrUOD6cWlZDivBaKuiubIrHNaJsuX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=naKAqAbs; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="naKAqAbs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739446880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ML720xXgLDVS1KuIyxe6zn7F10AobIzF856LOQXCS0o=;
	b=naKAqAbsp+YtigXKI1sWgYo5jQhp7EUIniFG0D5o7qPUY9f+wlVu6JZVYie6SAddb5woy2
	3cpyd5IKgTpUiBonCbEIwS7X4o4CoMZUvj6pNOwQdV+dU10C/lIPYFXqv/3ervuT9zNySV
	iVGnZjzJvyPevBl1yjpwc84DSM3gsd4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-hardening@vger.kernel.org,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: hpsa: Replace deprecated strncpy() with strscpy_pad()
Date: Thu, 13 Feb 2025 12:40:48 +0100
Message-ID: <20250213114047.2366-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

strncpy() is deprecated for NUL-terminated destination buffers. Replace
memset() and strncpy() with strscpy_pad() to copy the version string and
fill the remaining bytes in the destination buffer with NUL bytes. This
avoids zeroing the memory before copying the string.

Compile-tested only.

Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Use len instead of len - 1
- Link to v1: https://lore.kernel.org/r/20250212224352.86583-3-thorsten.blum@linux.dev/
---
 drivers/scsi/hpsa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c7ebae24b09f..968cefb497eb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7236,8 +7236,7 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
 
 static void init_driver_version(char *driver_version, int len)
 {
-	memset(driver_version, 0, len);
-	strncpy(driver_version, HPSA " " HPSA_DRIVER_VERSION, len - 1);
+	strscpy_pad(driver_version, HPSA " " HPSA_DRIVER_VERSION, len);
 }
 
 static int write_driver_ver_to_cfgtable(struct CfgTable __iomem *cfgtable)
-- 
2.48.1

