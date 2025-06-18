Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3298020B215;
	Wed, 18 Jun 2025 06:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750229885; cv=none; b=Br7n9oIs1IAz638XNm10/Ca7cxlrKmh5jRhZGXm6wSDCkJTBa2RZQSkxNoaByquiMI4779ocukK7pin0CygpxGCx9WfYnaCPqvv1QAMely/iV0XQ/swI7sJpWuPhIjHI4XkZ+6GopgDVDop6nzOJu0WLuHUjoN7SB0OOnZ/sG1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750229885; c=relaxed/simple;
	bh=tjM7nXQDvrm4aXok7ekeYIc7+Z5Pf4zrD5WRV31r+Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dFMxO9mo4e8BxM5IKUd2hDbnjPSpAwIyK+DfyB0gHDFI8hZ7SE58bnCH5oef6lhREyPbFItYjd9xaAk0vta74xUBVOfrBWWGI3cxHOyp8WBw6A5SOV4mAyU5Hvc9reyUuko6icypyzvb2FEh4owaHSyeY+hebjw1LVZaohC8xmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dOg+TW8l; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dOg+TW8l"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a52878d37aso1208787f8f.2;
        Tue, 17 Jun 2025 23:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750229882; x=1750834682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hcrmkRjUYqJwnpl1Ch5OIGjoKPGqpaU2Vsr38iZ8Beo=;
        b=dOg+TW8lrG9hFYmxkIBI5WhImFhRgETy5gn2jgxrfKDt9PTg5Y0R13B6JoY8F+hGEa
         7Sgxs4+c//Ik+ri7NLWFDGPz2Vckp16s/g66yGIxCSH4ky1Kr8qmuxKe16QYibxk9aXa
         XMAezNLPLKr1lOXtgjOdzKfIs/IlOo0SLeAgZAWY4JVSQXPWMHdJI8sX4ws4wx1wt5da
         07Bcno2Yg+70+BP+ye7iHwhLcs7BMpn65h4cYTeuMz/yzrZtp9WxgO3ewhwhpMnwIuG4
         PymxY3cKsHHjagp7OqJywJ1aDntAD9mHsiKA9Y88x4NsyHtzAPueoKo1cZAuKB4qwQMr
         siSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750229882; x=1750834682;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hcrmkRjUYqJwnpl1Ch5OIGjoKPGqpaU2Vsr38iZ8Beo=;
        b=YF3C8kDUXDpGjU4Xe8Gxm/wIpBArV7/nGSge7C1fkNyIm8NNSdY2B33puwQRS2qUcH
         ScJlpPpz+4w1+UibuV4deKhLNOvaQz81iR7SCG5CaCNpTOEO7zMvZ2meDYKT8gANZzgt
         2TlVksomPPrDrIQrwIlUvrX9EiAUIv82UGGZNMOLBeQ+4UN6qXwP3HGlxv6qwKOGWSvJ
         9XCjhPlhanx57oUOgqfJHQjFdB9zpwWm4MIRjh+PnjFJ9AjwBXhVonMBj9uAUXeMZLNY
         XETGmB/u2c1i/IITiU9lWtqh/N7i1t71jwI9KVbk2JIszxWWJm5nDm0PZzxRPAZerlIl
         r9AQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3jK9yafVRwtYE3ybsngAnbCxFQWg66kORexcSui8eN5p5ryhnymnsV0ulsDkwH+d5Ss1DFrP41KARAg==@vger.kernel.org, AJvYcCXYC8jMS5LukbYhWlxWdhM8YESJnwU5r2aJ6Ltv0uRmG63mX9Ijd0sZFZRrhOxpqLogFWX04UcFvTE/+pQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJKeue+Ujx+2DKF+TduJasF8ixzHqKeTvwuq4bQ6MERKc15DpX
	+kH6EAsvbbD6T//YzKubw5sCKNub8rA31GCutfIuJt08NWA6HTu7Hdeo
X-Gm-Gg: ASbGncuaMmZazt9wZu+AisgEc7aUQsnofVEbemVpQ2/Rmk623W+5cY/FxsyWya7giJP
	2qyyHChoGIBi0Er9iQ6ha9I8i/iUkmE9b4DIzjeG/7HKg7zD49g6T43tH358PrCmh04KGLe4Ouv
	7BRPGqKeS00HzJfLwG3nYeGt6KS0XER981W7WAAovtkzsu0MbbpvUMdp3lHG60DD8aSFKd0EDMn
	H0C1ALX2S7l6Q1TOWoLy6h0Ed+DeUaxKboTmaPJm/NzyIzgfU+IhGfbpOyf+ixjwNK1l/NVleTg
	yYuUZAPFyz7Nd8qLWWoqMY96OKxtZEDrGdDqJ0MCgTT+JI2iPYvZjXssAgdCWavCj8V2AmAORFm
	cupn/swUNl+rwWA31JAERzkBeDHG8yTOkCKOv1G0Vnxz6AEOh1NI/jTT1a+j+jGKJKR5kKp8lyj
	g=
X-Google-Smtp-Source: AGHT+IGF2cms3CFUDxUkkiMp5ViaH0bho25Dd3n2Re8I3Q+gwxx6REqBoIvxMFMoUP4vLRF2fx1ntg==
X-Received: by 2002:a05:6000:2507:b0:3a4:f744:e019 with SMTP id ffacd0b85a97d-3a572e55403mr4623040f8f.16.1750229882266;
        Tue, 17 Jun 2025 23:58:02 -0700 (PDT)
Received: from thomas-precision3591.home (2a01cb00014ec300f1c5391b39542642.ipv6.abo.wanadoo.fr. [2a01:cb00:14e:c300:f1c5:391b:3954:2642])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a589092d1asm3794488f8f.24.2025.06.17.23.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 23:58:01 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Arulprabhu Ponnusamy <arulponn@cisco.com>,
	Arun Easi <aeasi@cisco.com>,
	Gian Carlo Boffa <gcboffa@cisco.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: fnic: fix missing dma mapping error in `fnic_send_frame()`
Date: Wed, 18 Jun 2025 08:57:04 +0200
Message-ID: <20250618065715.14740-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`dma_map_XXX()` can fail and should be tested for errors with
`dma_mapping_error().`

Fixes: a63e78eb2b0f ("scsi: fnic: Add support for fabric based solicited requests and responses")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/scsi/fnic/fnic_fcs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 1e8cd64f9a5c..103ab6f1f7cd 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -636,6 +636,8 @@ static int fnic_send_frame(struct fnic *fnic, void *frame, int frame_len)
 	unsigned long flags;
 
 	pa = dma_map_single(&fnic->pdev->dev, frame, frame_len, DMA_TO_DEVICE);
+	if (dma_mapping_error(&fnic->pdev->dev, pa))
+		return -ENOMEM;
 
 	if ((fnic_fc_trace_set_data(fnic->fnic_num,
 				FNIC_FC_SEND | 0x80, (char *) frame,
-- 
2.43.0

