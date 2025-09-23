Received: from jupiter.guys.cyano.uk (jupiter.guys.cyano.uk [45.63.120.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01A7323F55;
	Tue, 23 Sep 2025 12:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.63.120.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758631979; cv=none; b=ffCvDr4Ex84T1AlnIoE3gZZU7MBTLLucdMYqhyssGmdq7QKEh/0r3PGSm49254lsIugB976ELWf4q0ZeDfavVZy2oD/PlBa0D79bWFjyc7loPWLY9IFZsKwM48tCm0xfw3pxct+LVNErlYjS7O06ZY+PSYILnL0111dcJd7yz+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758631979; c=relaxed/simple;
	bh=N7ofGPH6tnE0yPkXEvdQZt6jPJL4C59ks1kQl2gCV4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ok9y822T0X7SbuhSJEuSoGc/pLS+wvRdVo+/emNlX6DQC9bR0VoiDXCLcyiYtZ58Yf54pXcbm7jXE0wKWWB/Z3IuIAfcHDqB735xefJjzIvSP/mtjDCiI/k8XYNzlhrahdunQBSIh88kFz+UXsxJENtgiocQVHJq63uk6fPRFxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyano.uk; spf=pass smtp.mailfrom=cyano.uk; dkim=pass (2048-bit key) header.d=cyano.uk header.i=@cyano.uk header.b=ELet/SXA; arc=none smtp.client-ip=45.63.120.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyano.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyano.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyano.uk header.i=@cyano.uk header.b="ELet/SXA"
From: Xinhui Yang <cyan@cyano.uk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyano.uk; s=dkim;
	t=1758631976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=31zsNWXd2C/aDik62qqsyHsxzZajvYQtmtXWDAIFjvc=;
	b=ELet/SXA/CbqZCSYLDXXU0gAQJ3xnjSUwS7o0ug87PE5RbGPk/lDPvTpM5Ng6ouqFzPB+x
	KuqnlL2CpF6A7Hdx6BX941cSILffw6IiJ5/3IL0Rog97DvMOS8SEJ3c+mmgllcDj9q8CYV
	DehYsIMMh4S5GR11LsyZRxM39QW5QZJLieFo7cI8tSQo2GKfMPx/AMTpwWyQnOQaV30vIo
	HvTusJFS3hHWcesP8RHZUDivnLD/R8vR7csp3ZPVaOSkGue1fVqvu9KBmG8F6vZ/rsCil5
	w1WSwMEmC1salVWU/nUjTVC10voUUJfnwZkf1C0oYDfNVzTeBFQ3YBMPo+rdsw==
Authentication-Results: jupiter.guys.cyano.uk;
	auth=pass smtp.mailfrom=cyan@cyano.uk
To: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org,
	Mingcong Bai <jeffbai@aosc.io>,
	Kexy Biscuit <kexybiscuit@aosc.io>,
	Xinhui Yang <cyan@cyano.uk>,
	Oliver Neukum <oliver@neukum.org>,
	Ali Akcaagac <aliakc@web.de>,
	Jamie Lenehan <lenehan@twibble.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 2/2] scsi: dc395x: improve code formatting for the macros
Date: Tue, 23 Sep 2025 20:52:25 +0800
Message-ID: <20250923125226.1883391-3-cyan@cyano.uk>
In-Reply-To: <20250923125226.1883391-1-cyan@cyano.uk>
References: <20250923125226.1883391-1-cyan@cyano.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: --

These DC395x_* macros does not have white spaces around their arguments,
thus checkpatch.pl throws an error for each change in the macros.

Also, there are no surrounding parentheses in the expressions for the
read and write macros, which checkpatch.pl also complained about.

This patch does only formatting improvements to make the macro
definitions align with the previous patch.

Signed-off-by: Xinhui Yang <cyan@cyano.uk>
---
 drivers/scsi/dc395x.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index aed4f21e8143..cff6fa20e53c 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -91,8 +91,8 @@
 #endif
 
 
-#define DC395x_LOCK_IO(dev,flags)		spin_lock_irqsave(((struct Scsi_Host *)dev)->host_lock, flags)
-#define DC395x_UNLOCK_IO(dev,flags)		spin_unlock_irqrestore(((struct Scsi_Host *)dev)->host_lock, flags)
+#define DC395x_LOCK_IO(dev, flags)		spin_lock_irqsave(((struct Scsi_Host *)dev)->host_lock, flags)
+#define DC395x_UNLOCK_IO(dev, flags)		spin_unlock_irqrestore(((struct Scsi_Host *)dev)->host_lock, flags)
 
 /*
  * read operations that may trigger side effects in the hardware,
@@ -100,12 +100,12 @@
  */
 #define DC395x_peek8(acb, address)		((void)(inb(acb->io_port_base + (address))))
 /* normal read write operations goes here. */
-#define DC395x_read8(acb,address)		(u8)(inb(acb->io_port_base + (address)))
-#define DC395x_read16(acb,address)		(u16)(inw(acb->io_port_base + (address)))
-#define DC395x_read32(acb,address)		(u32)(inl(acb->io_port_base + (address)))
-#define DC395x_write8(acb,address,value)	outb((value), acb->io_port_base + (address))
-#define DC395x_write16(acb,address,value)	outw((value), acb->io_port_base + (address))
-#define DC395x_write32(acb,address,value)	outl((value), acb->io_port_base + (address))
+#define DC395x_read8(acb, address)		((u8)    (inb(acb->io_port_base + (address))))
+#define DC395x_read16(acb, address)		((u16)   (inw(acb->io_port_base + (address))))
+#define DC395x_read32(acb, address)		((u32)   (inl(acb->io_port_base + (address))))
+#define DC395x_write8(acb, address, value)	(outb((value), acb->io_port_base + (address)))
+#define DC395x_write16(acb, address, value)	(outw((value), acb->io_port_base + (address)))
+#define DC395x_write32(acb, address, value)	(outl((value), acb->io_port_base + (address)))
 
 #define TAG_NONE 255
 
-- 
2.51.0

