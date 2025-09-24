Received: from jupiter.guys.cyano.uk (jupiter.guys.cyano.uk [45.63.120.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3EA246BC7;
	Wed, 24 Sep 2025 05:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.63.120.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758693465; cv=none; b=dvJ37+K+Aegzdb+dLPGgOP+KeAkvL6BtYVM0B+qoNfcYIHnRNjvTPYLRlwa03ak0TAMp3xAX6otHVpbi9kDXgY+f2u1Hvky0YIT074Ap8UBQ/MkUeoqvp1mgDZFl33FfqRMqNmMcXrFy4CtdyiqU8YQLMxS5rPCFHjZmFQ9q/hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758693465; c=relaxed/simple;
	bh=RY98zhyMeHdIe7oz1vmNIMN1hoojLCcBjgCdD486iY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdwsSGuNPo/5+D594nla3qOzc6b0Nl5yJJLvNZQlLewbDyd8jTyQGVtSSncB7bEzvPA7iRIcjuM24VadAKhJsA4w5tsF0pBmEcNcS45J72RpDWU0WEYYgrlEyjF0Uq0DwvL/nJPoOe7A2sgjTj7taONXc54mMH0YkIo5vYa3F68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyano.uk; spf=pass smtp.mailfrom=cyano.uk; dkim=pass (2048-bit key) header.d=cyano.uk header.i=@cyano.uk header.b=Y5LyuWRv; arc=none smtp.client-ip=45.63.120.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyano.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyano.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyano.uk header.i=@cyano.uk header.b="Y5LyuWRv"
From: Xinhui Yang <cyan@cyano.uk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyano.uk; s=dkim;
	t=1758693461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E1OyOTy+j30pzlwfHanTxfG7kMQ+teePd67XVj8f1Ng=;
	b=Y5LyuWRvqFkACBDrq6BR6Ah9OCwmfOXHo0N9S6qInXJL2htKcJX5RSReUe2a2NaDTJiZIR
	07QQ/wJ7AuaZXtIhytqspgtiZfBJ2p1/8oKPDax7VXX8Czl2yY9Rc5ElLrEwXkTTl/+kOR
	WDYl+kWACclRTYJbgTHSI+5zCobuTVgH/iIDsMzZUVNIc5KJBgpUF2ICwIdTG4Rkxedvrb
	En7glIPyY09qvdvGoPUXcfaEYtseAJ9oplecUdCNTXkvMfFMe0ltAfjgEFmzw14j+6FQUr
	PQj0kt0JnAj/X1oXsiEQq2Q8wgVRkqYaliS//rjZIssbmxd9hAgOPLJvd3eVVg==
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
Subject: [PATCH v4 2/2] scsi: dc395x: improve code formatting for the macros
Date: Wed, 24 Sep 2025 13:56:27 +0800
Message-ID: <20250924055628.1929177-3-cyan@cyano.uk>
In-Reply-To: <20250924055628.1929177-1-cyan@cyano.uk>
References: <20250924055628.1929177-1-cyan@cyano.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: --

The DC395x_* macros does not have white spaces between their arguments,
and checkpatch.pl throws an error for each change in the macros. Adding
white spaces between the arguments to fix the formatting.

Also, there are no surrounding parentheses in the expressions for the
read macros, since these casts makes the expression a compound, which
checkpatch.pl also complained about.
Removing the type casts of the inb(), inw() and inl() calls. They now
returns the expected type without explicit casting.

This patch does only formatting improvements to make the macro
definitions align with the previous patch.

[1]: https://lore.kernel.org/linux-scsi/1ae97d061da14b0d85c0938c3000ed57ccd39382.camel@HansenPartnership.com/

Signed-off-by: Xinhui Yang <cyan@cyano.uk>
---
 drivers/scsi/dc395x.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index aed4f21e8143..1fb954180269 100644
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
+#define DC395x_read8(acb, address)		inb(acb->io_port_base + (address))
+#define DC395x_read16(acb, address)		inw(acb->io_port_base + (address))
+#define DC395x_read32(acb, address)		inl(acb->io_port_base + (address))
+#define DC395x_write8(acb, address, value)	outb((value), acb->io_port_base + (address))
+#define DC395x_write16(acb, address, value)	outw((value), acb->io_port_base + (address))
+#define DC395x_write32(acb, address, value)	outl((value), acb->io_port_base + (address))
 
 #define TAG_NONE 255
 
-- 
2.51.0

