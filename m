Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A01C392C51
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 06:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776235921; cv=none; b=N2dWzr0xrzl2oonjKMEkwFmWg0zw55GU5RLkbfZRaOYCik5xUYuiN+TEtq9jyfwDDGap0nswZDD7x2NqMkXH1T1DMNvpK2k2Sz2wXiD2Azvx7T8sLFkaLgqelC3Yk4RGfp/aU1xUUNF8FtFUkEIt1Ud87ZAxn0tGTLYacc0FuB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776235921; c=relaxed/simple;
	bh=BHixSKvgJTX5vUY2RX01w7yNjSynfqpFLPtxzEITDpo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JwyPZJbeOrK+WPrHR1glnDY5yULaG+jiVMfy4U2YGJ2W4h/uSBWgYoKF475qfxGCXCZg5Q7g7VdN+reqrQV8pQSco0WsNlUCz1PO3//7ILFmZDfiMdVQDnWPXLNzgPrRkzs2YXlzLjLLh8fZ0R8RKa7JMICHFyBV2sJ2FXIcef8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lAq9x/c4; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lAq9x/c4"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43d73422431so2492806f8f.2
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 23:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776235917; x=1776840717; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nRavgm//LE5hnp4ZuvoUZb2fmYkepzUx9f2OGsUTCno=;
        b=lAq9x/c4BvkzRi/UgjaVs9bxp6xnFuaiUyF2LjgNiC92Aa3hwksFLwGVpa27Ovz8IV
         /7QIRE6Wtj12/OI+puOZYs576GQNR1uvz49zI6b67vIu15p43m+sCRKIKDYLaRliVAY6
         nIFKCjRzzladlr8nrcQEAwwvgxl++5556pQ+eS3wQKWCJsh4tHa+iuPIIs2fFpYabnFy
         N/3Dk0Nk9p87GULlkPfJDW9xm5mWD1UZBMN1r+zFk9l70+lYHGcxWKYUMAQfkD+uL+mU
         nyZAWSqZTB3ZZ2Xwq+evUAZiPpT5uTr0DYGPgV4z9EWVKcjWk+Cr2v/2vqI/PP4JEEWc
         jtjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776235917; x=1776840717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nRavgm//LE5hnp4ZuvoUZb2fmYkepzUx9f2OGsUTCno=;
        b=G8wOvcyaBaRz+/HF4ujFWp7tIf2eOGG5rk4lNQdGC60cP7NMi/hNjpq6XUkA/5Qznn
         j0wExGoM3LEjjTptmo5WmqySTpwiATK2zrifhJfsfpKlaQs4I2C2leBzAvyowOlc4idi
         5qjVxOFACPi0B8OMmYQ1q1rEl7BJ/jlv0p5fDN8t24ehxpkH/DRMr0ErSBlzB63EkauP
         +3z1f9ZvTYnFoVdUgoi5xerk9BRqPiDmctAEAbkdcdr5A56ndeNJxQvtSNEd9zbpzYQz
         3yAm2bDh6YsxFu2kPG8gvt3ocQLywqLiybYpXK+duu3avGANZ9QfS+cnbe9M8qTwJfuz
         QWGQ==
X-Gm-Message-State: AOJu0Yw4QRsp6vOfXwvMjofcLM/rY5dn/2pnVS+HSxXPYcJjBiMxvYz8
	CQRLGVVtfSFSbxa/+hp3zuZd86Hdy69akdVKT+NBYjsbFCoSPt4pSDMqH80C5Vkg
X-Gm-Gg: AeBDies6tFP/DevBe7R21MtQq1IL3Wv+dHvd9FlQ7Yb/27XDcHEILi1/AFZbq+3O8HU
	MwIciitMrvNgaXomVVmJkifSKsHq+AOe1CvTyP06BfO3BCgGkRV+hvmNYPDZ3WRxU6NIqI5d441
	dNkA/IxS2iTUy2/TSaNbzYTdLx3+RRNnA84gBWbjjJgD0LG8sN0s0FNdwVUEh3+07vaMnpxOokZ
	zxAXz0JwwxTddurAWqXq9cTWwIEbjJDIQo3DOj1mDVqeFQKkMb0XrKdXxGvPKnEQo7DgnGLeWOk
	KE0iP8xGJvmJfnKlHTH0CDPHHLn1cWr4ODkleU89yIo1cpGSaD+Lo6BtJk0rsA/+uXM8e2v5rTA
	Wj7vyTc81J7mo3mP+pvoY5BudI/v4ey1JpY72jcgPabUAf/+9yxkS7juuxCoAmSiuvof1gZp71p
	zie2Hj/SnZ1W4MUq2W4A3lQInrz2XNJHDZoyCpTr1vHO5SQpAFYN86TGc4sfjaXrMgTwVQgIylj
	ZkYahHVjPP9TnAdBh16q+Q6PuTwQBUPYKNM6h/Ny57uv8YRJus53rBd1dyEsaGgxuGW9OPPy3r2
	cSUh2OUIVw2fiSRALR1f0+EQrO6XatdbgrKVIZ/i9IBvzFFxRG3vGilataOGEfABm3+NM5GZww=
	=
X-Received: by 2002:a05:6000:40e1:b0:43d:7d6f:f529 with SMTP id ffacd0b85a97d-43d7d6ff5demr11404567f8f.31.1776235916950;
        Tue, 14 Apr 2026 23:51:56 -0700 (PDT)
Received: from particle-0df3-d360 (2a02-1810-950a-eb00-f9cf-2393-cb7f-6fd9.ip6.access.telenet.be. [2a02:1810:950a:eb00:f9cf:2393:cb7f:6fd9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead35662csm2440948f8f.14.2026.04.14.23.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 23:51:56 -0700 (PDT)
From: Daan De Meyer <daan.j.demeyer@gmail.com>
X-Google-Original-From: Daan De Meyer <daan@amutable.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	Daan De Meyer <daan@amutable.com>
Subject: [PATCH RESEND] scsi: sr: exclude CDC_MRW_W and CDC_RAM from writeable check
Date: Wed, 15 Apr 2026 06:51:11 +0000
Message-ID: <20260415065110.3496246-2-daan@amutable.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The writeable check in get_capabilities() includes CDC_MRW_W and
CDC_RAM in its bitmask, but these capabilities are not determined from
the MODE SENSE capabilities page. They require the SCSI GET
CONFIGURATION command, which is only issued later by cdrom_open_write()
at device open time.

Since cdi.mask is initialized to zero (all capabilities assumed
present), CDC_MRW_W and CDC_RAM are left unmasked by default. This
makes the writeable check always true when MODE SENSE succeeds,
regardless of the drive's actual write capabilities as reported in the
capabilities page.

Fix this by only checking CDC_DVD_RAM and CDC_CD_RW in the writeable
condition, as these are the write capabilities actually determined from
the MODE SENSE capabilities page. CDC_MRW_W and CDC_RAM will continue
to be evaluated by cdrom_open_write() at open time via GET
CONFIGURATION.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Daan De Meyer <daan@amutable.com>
---
 drivers/scsi/sr.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 8ed002f82e36..0a6413b77dd3 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -901,10 +901,14 @@ static int get_capabilities(struct scsi_cd *cd)
 		cd->cdi.mask |= CDC_CLOSE_TRAY; */
 
 	/*
-	 * if DVD-RAM, MRW-W or CD-RW, we are randomly writable
+	 * Check if the drive has write capabilities. Only consider
+	 * capabilities that are determined from the MODE SENSE capabilities
+	 * page here. CDC_MRW_W (MRW writing) and CDC_RAM (random writable)
+	 * require the SCSI GET CONFIGURATION command to determine, which
+	 * is issued later by cdrom_open_write() at device open time.
 	 */
-	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) !=
-			(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) {
+	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_CD_RW)) !=
+			(CDC_DVD_RAM | CDC_CD_RW)) {
 		cd->writeable = 1;
 	}
 
-- 
2.53.0

