Received: from jupiter.guys.cyano.uk (jupiter.guys.cyano.uk [45.63.120.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6299327F011;
	Tue, 23 Sep 2025 12:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.63.120.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758631976; cv=none; b=SPcLwu3YgfXLf0FQgp9+/5q0eW+BC+OBrLTJTh31By9E6jh+hMbS6/tDR9cBI6iOydZahhGYIKnFH16oFy9h31U+qcYWxF9X2Jv2Pc4GNsn91cIno+WQId/LuBckpECbnTmQjKXYPM+Mny4HNbmeS37ivbKnr9wIPpdok4W+5VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758631976; c=relaxed/simple;
	bh=pszMH4vAes2x2NzIO/YcXPKwce2xSUi8oH2/WP2RUlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tXe3LcVAggUa6O6g9Owpv9TQpbEMRwyWvgMjXf3KtQuh7O1L4F/vX1B2y+qzFG5bgxOQwVbI6xmSIm1SiiTzgRTHi/eCnewV0D2JLtR7YZv1DiTOlGOFRnKrbnc3Gnky8E3oEtk3y5L3HssKXC89RDMwakWLUBbcUtHkYbuXRD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyano.uk; spf=pass smtp.mailfrom=cyano.uk; dkim=pass (2048-bit key) header.d=cyano.uk header.i=@cyano.uk header.b=oAtr9DzC; arc=none smtp.client-ip=45.63.120.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyano.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyano.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyano.uk header.i=@cyano.uk header.b="oAtr9DzC"
From: Xinhui Yang <cyan@cyano.uk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyano.uk; s=dkim;
	t=1758631971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/CddcSgxbg3jlRM+H18V72Q8aXUxrOpaUSJrwxeCfds=;
	b=oAtr9DzCy8Bjll9LT4ixz/Gnd1xSCoc1xB7fwDfxQK/ojsyQOQshJRG7jlvraDw0QaKwB4
	KaqbeaJ0dqAH4g71Z+UcHrXUzGuIVfAIE2ia/Q5n5Yh9fzXdBiPAzGg6i/yi+x9VRfxnE+
	6wlzQhQndoefUx2bjPNTcGIHnS9bsSN8SX/kqba52M6d1q8y2ysJEasQ2nUwxU/4SxnRAw
	wJcUFiJDPaXihz7bCRjFmcx88EXLuc+VGOtHlH5OZjPi9SQaVAGnVEHW0sN0wwZeIL8ja9
	zm7uJdpPNmRte1Ihj4+SGedbj6rUOvfml4pXDAIbnHLgM3eqt1rPGwjyZYT7EQ==
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
Subject: [PATCH v3 1/2] scsi: dc395x: correctly discard the return value in certain reads
Date: Tue, 23 Sep 2025 20:52:24 +0800
Message-ID: <20250923125226.1883391-2-cyan@cyano.uk>
In-Reply-To: <20250923125226.1883391-1-cyan@cyano.uk>
References: <20250923125226.1883391-1-cyan@cyano.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ---

There are certain read operations performed in this code which doesn't
really don't need its return value. Those read operations either clears
the FIFO buffer, or clears the interruption status. However, unused read
triggers compiler warnings. With CONFIG_WERROR on, these warnings get
converted into errors:

drivers/scsi/dc395x.c: In function ‘__dc395x_eh_bus_reset’:
drivers/scsi/dc395x.c:97:49: error: value computed is not used [-Werror=unused-value]
   97 | #define DC395x_read8(acb,address)               (u8)(inb(acb->io_port_base + (address)))
      |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/dc395x.c:1003:9: note: in expansion of macro ‘DC395x_read8’
 1003 |         DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS);
      |         ^~~~~~~~~~~~
drivers/scsi/dc395x.c: In function ‘data_io_transfer’:
drivers/scsi/dc395x.c:97:49: error: value computed is not used [-Werror=unused-value]
   97 | #define DC395x_read8(acb,address)               (u8)(inb(acb->io_port_base + (address)))
      |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/dc395x.c:2032:33: note: in expansion of macro ‘DC395x_read8’
 2032 |                                 DC395x_read8(acb, TRM_S1040_SCSI_FIFO);

Create a new macro DC395x_peek8() to deliberately cast the return value
to void, which tells the compiler we really don't need the return value
of such read operations.

Cc: stable@vger.kernel.org
Signed-off-by: Xinhui Yang <cyan@cyano.uk>
---
 drivers/scsi/dc395x.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 386c8359e1cc..aed4f21e8143 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -94,6 +94,12 @@
 #define DC395x_LOCK_IO(dev,flags)		spin_lock_irqsave(((struct Scsi_Host *)dev)->host_lock, flags)
 #define DC395x_UNLOCK_IO(dev,flags)		spin_unlock_irqrestore(((struct Scsi_Host *)dev)->host_lock, flags)
 
+/*
+ * read operations that may trigger side effects in the hardware,
+ * but the value can or should be discarded.
+ */
+#define DC395x_peek8(acb, address)		((void)(inb(acb->io_port_base + (address))))
+/* normal read write operations goes here. */
 #define DC395x_read8(acb,address)		(u8)(inb(acb->io_port_base + (address)))
 #define DC395x_read16(acb,address)		(u16)(inw(acb->io_port_base + (address)))
 #define DC395x_read32(acb,address)		(u32)(inl(acb->io_port_base + (address)))
@@ -1000,7 +1006,7 @@ static int __dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
 	DC395x_write8(acb, TRM_S1040_DMA_CONTROL, CLRXFIFO);
 	clear_fifo(acb, "eh_bus_reset");
 	/* Delete pending IRQ */
-	DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS);
+	DC395x_peek8(acb, TRM_S1040_SCSI_INTSTATUS);
 	set_basic_config(acb);
 
 	reset_dev_param(acb);
@@ -2029,8 +2035,8 @@ static void data_io_transfer(struct AdapterCtlBlk *acb,
 			DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
 				      CFG2_WIDEFIFO);
 			if (io_dir & DMACMD_DIR) {
-				DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
-				DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
+				DC395x_peek8(acb, TRM_S1040_SCSI_FIFO);
+				DC395x_peek8(acb, TRM_S1040_SCSI_FIFO);
 			} else {
 				/* Danger, Robinson: If you find KGs
 				 * scattered over the wide disk, the driver
@@ -2044,7 +2050,7 @@ static void data_io_transfer(struct AdapterCtlBlk *acb,
 			/* Danger, Robinson: If you find a collection of Ks on your disk
 			 * something broke :-( */
 			if (io_dir & DMACMD_DIR)
-				DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
+				DC395x_peek8(acb, TRM_S1040_SCSI_FIFO);
 			else
 				DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 'K');
 		}
@@ -2892,7 +2898,7 @@ static void set_basic_config(struct AdapterCtlBlk *acb)
 	    DMA_FIFO_HALF_HALF | DMA_ENHANCE /*| DMA_MEM_MULTI_READ */ ;
 	DC395x_write16(acb, TRM_S1040_DMA_CONFIG, wval);
 	/* Clear pending interrupt status */
-	DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS);
+	DC395x_peek8(acb, TRM_S1040_SCSI_INTSTATUS);
 	/* Enable SCSI interrupt    */
 	DC395x_write8(acb, TRM_S1040_SCSI_INTEN, 0x7F);
 	DC395x_write8(acb, TRM_S1040_DMA_INTEN, EN_SCSIINTR | EN_DMAXFERERROR
@@ -3799,7 +3805,7 @@ static void adapter_uninit_chip(struct AdapterCtlBlk *acb)
 		reset_scsi_bus(acb);
 
 	/* clear any pending interrupt state */
-	DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS);
+	DC395x_peek8(acb, TRM_S1040_SCSI_INTSTATUS);
 }
 
 
-- 
2.51.0

