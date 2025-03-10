Received: from fgw22-4.mail.saunalahti.fi (fgw22-4.mail.saunalahti.fi [62.142.5.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9D122FDFF
	for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2025 15:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741622277; cv=none; b=TEDoJRnUceevlsUjQNMksSvm4GmNTbsgFZLTd3gED7wB0TN1tz8qPd0JRMjVxsTWbBo0Fq3UVZVynI5pu8ihMfkvxS1L6FBo7hZ1G41lp4xOsMZETznAdApiFqQucOu8R8+8YSk0XKoJ6/6Xx07hLVihTAenFnA6g5z1EVRQUO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741622277; c=relaxed/simple;
	bh=pDMIF76U5R6sehUMMPztzkaKbQK+wxP4by7Kd+4CCXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=byzVoC5CNTp0OIBJZGVGFqvaRB5FxJyhpRiIqqE5+YI26/JyDtumBvgAjP/k9OvUOVzK9MujLrJBjkCygP2YaT9ecCCmYm0/Vv/8EMtxrTPAEOc68sM1AQRfC2oWVUm1UgnzvTD9KDNjI+vYBQDNJDrboRd7XvdKTSarI3awXBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=FpwnZE18; arc=none smtp.client-ip=62.142.5.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="FpwnZE18"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=urq9x6MXQiAerqD1D+2aNC5nKPqHNiYGyr+6MgMEgQw=;
	b=FpwnZE18FHsPKjD2xwu8GCsUoFPNUHey64hHWOmADmuoUdJUNuYrI9nfCoWgT832tRHt3beKX2oBN
	 F2eCQDjLobI1GUe6xpVy5HzCQnt4kX7B7vGqdVB4yWfvtBioC+XAnFyzriIPTw7QoFSMhbeVZ/butN
	 fCo7+kGwW4L/WQ1nmOZ036aHwD1DaWEwft9VjPCO1MzQMtPw2kDQFSfyLxC/r6WPVRf6yQ+fFFrolc
	 3Jkt8rG/wuoVWY34Lre9cwuKsm1LbxQ3nAJngqDS4AdhQOgrNpnErfpc/4qW1ZThuMl4lzGxJKlpa0
	 5rLR4/KraQjhOTWM/v3rLTdQblgXBcw==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id 43b91d29-fdc8-11ef-839f-005056bdd08f;
	Mon, 10 Mar 2025 17:56:44 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 1/5] scsi: scsi_debug: Fix two typos in command definitions
Date: Mon, 10 Mar 2025 17:55:53 +0200
Message-ID: <20250310155557.2872-2-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310155557.2872-1-Kai.Makisara@kolumbus.fi>
References: <20250310155557.2872-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix two command definitions:
- flags and service action reversed in SEND DIAGNOSTIC
- ATOMIC WRITE missing opcode

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/scsi_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 523f054912e1..c5e7264748a8 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -817,7 +817,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 	    {6,  0x1, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* ATA_PT */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
-	{0, 0x1d, F_D_OUT, 0, NULL, NULL,	/* SEND DIAGNOSTIC */
+	{0, 0x1d, 0, F_D_OUT, NULL, NULL,	/* SEND DIAGNOSTIC */
 	    {6,  0xf7, 0, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0x42, 0, F_D_OUT | FF_MEDIA_IO, resp_unmap, NULL, /* UNMAP */
 	    {10,  0x1, 0, 0, 0, 0, 0x3f, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0} },
@@ -852,7 +852,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 		{16,  0x0 /* SA */, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 		 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xbf, 0xc7} },
 /* 32 */
-	{0, 0x0, 0x0, F_D_OUT | FF_MEDIA_IO,
+	{0, 0x9c, 0x0, F_D_OUT | FF_MEDIA_IO,
 	    resp_atomic_write, NULL, /* ATOMIC WRITE 16 */
 		{16,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 		 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff} },
-- 
2.43.0

