Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EE42AD0C
	for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2025 14:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763994052; cv=none; b=LNerU/YqJ3lysyCUsXBv2G6DrU2iJ9Di5C5wqPY+9W70oHgiqY406cQwtLl3qqSpsFsnygrKVUOcC6o1+4/vh40IWRW/sADiC+1TxHpRweJd8HbH+tOhbej2+5H7cVGzm2LaLP49sgQn7+5v+nJxiYNqDlkyCwryCuMeA8U9O9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763994052; c=relaxed/simple;
	bh=P+9FhADf8s7MH3SOEQ+F8e6dBQaXJaNU6K1PdzBNyuA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rbLLw0ic8asB0VwZleOyEiRXYr/P7mhUdk0sX7bPdEA+3NUxWEX12EAW/A4/z3MuGCRA64o8iqExDIQftsH9ZxnRpqJVB6yVSksufELq6LbsYlvRiokKgEAJjurfgZZOdtHIzH7Qj4i0DjQK3uo8j2vdGtbM0gQIRXZBXp2C+Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nZRIFOMT; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nZRIFOMT"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7aad4823079so3725306b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2025 06:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763994050; x=1764598850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JtEIxqFt5ongtgO9jgnonwhyV1MXPDFiUsBTRRrXqIk=;
        b=nZRIFOMTPQ/XlTjLo0u+jmnqdgCgsTeHss8wXAfrIKwprazwgKscnByKbzlruDzWVr
         bFBsLqsRvRCOzcG08iIeyFmxgtVaK/BFtJz3iv+9KEtzbFEMcMxXvVFysNbMfUwYfa3t
         aSASg+l65kkaAaVNswUhm9Up9X6HmCZ4epTQrT2ct7Ic0OmnZZexdh7Y/C5l3/UHOwqz
         B7a7HWmfmTTVqOiFE5FN7rzWmuGzlREXA5f48+farPCYYc4IqoDzjpY3v3CNJemW1BoN
         BeHecHeWl40rIkdjaW7e/1P3Qk4BLbBLV2esMa7NDQw5X3a3BrTWY8ay8tRxDkFENP8w
         VU2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763994050; x=1764598850;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JtEIxqFt5ongtgO9jgnonwhyV1MXPDFiUsBTRRrXqIk=;
        b=kDD2xcVx/ZpUV3FEJ+yhAukaQdLNOfc8ThxJRmyzbd+XMu+pTXno74ZjcHJpoIJO9s
         GUMtmPspg5KBixIE9i0Y3sglB5bDuyUwDdrgxNOUxUcyABsjD7qcg5TvqzWsBnsBEc7V
         yyRQ7l+UsQOuopKWL9sibPKwxm1K3L0U3FOyyLS1JdqPx5NEJ5PK2nfgi2IJ7yVfti4b
         gxZbnJAoXatJtjhEQYaiqof8QzM48iKhau4lI6DCDQsIIUugmNP3XfHCJNZPqkQexuLL
         tlPh7X4ETIjFK0bb4yy2c6u89YdYgaMMq/AoUOswnH/SfPZ8Fnoy6OO2Co50zNHPgUXU
         h/Lg==
X-Forwarded-Encrypted: i=1; AJvYcCX5Yp1ax49s3b5kcYUhDZH/c0ihxmd+m4TW7XoB9Y39eeIlOCYTNShwspPrgjqX8oFHVhMw67zg+lry@vger.kernel.org
X-Gm-Message-State: AOJu0YyyVtalnjQdNSwYunaRIitmZe3Lyb9W9oJYQC3Puj7sCAk2oTy+
	Kf6zBhMJ4kuxVIjtPedrC1ty/e+e29l+0k+vwm/J2QQ6vb5jMQ/N1Y5i
X-Gm-Gg: ASbGncsQx98CX2TwiTwSuTNjVp0X3vZ83OTEtpgnGB1HzibGV0JtjZxyUKzAD+Xl+Gn
	gyanZPFT890+HIphaWJZ3wTU4yy9Sf05ht83MMBkk2E3k9mGdhPXybWh5KqmBiSr5lY7/ON4hzu
	nfk0BZFhJ+9jdfINrozEyJot3Ildx2YKe2+NnKacCZic+/RXIuTU2CpXeBv0MM8NxKasJLxH0JI
	Zs+ivTO7dEVb0F1b3Mux9vbheC6m2yYK2fxcHO2YkXtJusjno880UQvVbRoDB1BCive72nskgpj
	2EApvD78gAN80z0yhbH2jZlPHb74OmgeW87oOrv4GTn4dQJASujgU3YE84oUgTqehNUN5Dqc/kT
	GyHU9Jekp3bKjxgLSCsbpMhU6RSxV5Yk6XV1kVRtF2BmwiAFfG5aaB/1lMDbucsgAsKr95XNqXh
	DU2w==
X-Google-Smtp-Source: AGHT+IEd80b9KHBlizAkoV7O6dqpDGYe9T7PBqWTaUJkMAkhRKB/WBdPJczUkKhbO4okXnPj9GexWQ==
X-Received: by 2002:a05:6a20:3d07:b0:35d:a9b2:63f2 with SMTP id adf61e73a8af0-36150bb0435mr11876497637.0.1763994049808;
        Mon, 24 Nov 2025 06:20:49 -0800 (PST)
Received: from lgs.. ([36.255.193.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd7604de68bsm13640640a12.21.2025.11.24.06.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 06:20:49 -0800 (PST)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: HighPoint Linux Team <linux@highpoint-tech.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] [SCSI] hptiop: Add inbound queue offset bounds check in iop_get_config_itl
Date: Mon, 24 Nov 2025 22:20:36 +0800
Message-ID: <20251124142036.41231-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The function iop_get_config_itl() reads a 32‑bit offset (req32) from the
inbound queue register (hba->u.itl.iop->inbound_queue) and then uses it
without validation to compute:
    req = (base + req32)
followed by memcpy_fromio(config, req, sizeof(*config)).

Without verifying that req32 is within the valid I/O region and that
req32 + sizeof(*config) does not overflow the mapped I/O region, a
malicious or faulty device/firmware could cause the driver to read memory
outside the intended request structure — leading to an out‑of‑bounds I/O read.

According to kernel documentation:
  "The value returned from the inbound queue port is an offset relative
  to the IOP BAR0." ([docs.kernel.org](https://docs.kernel.org/scsi/hptiop.html))
However, the documentation does *not* specify a maximum offset, nor a bound
such as “offset + size ≤ IOP memory region size”.

In the driver code, hptiop_map_pci_bar_itl() does:
    hba->u.itl.iop = hptiop_map_pci_bar(hba, 0);
and uses pci_resource_len(hba->pcidev, 0) to obtain the mapped region size
for BAR0. Therefore we can use that size at runtime to bound req32 safely.

To implement the fix in iop_get_config_itl():
  - Retrieve the BAR0 region size via:
        struct pci_dev *pcidev = hba->pcidev;
        u32 length = pci_resource_len(pcidev, 0);
  - Then check:
        if (req32 == IOPMU_QUEUE_EMPTY || req32 + sizeof(*config) > length)
            return -EINVAL;
  - This ensures we do not rely on a hard‑coded maximum, but use the actual
    mapped region size for the bound.

Fixes: ede1e6f8b4324 ("[SCSI] hptiop: HighPoint RocketRAID 3xxx controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/hptiop.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index f18b770626e6..c01370893a81 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -404,7 +404,10 @@ static int iop_get_config_itl(struct hptiop_hba *hba,
 	struct hpt_iop_request_get_config __iomem *req;
 
 	req32 = readl(&hba->u.itl.iop->inbound_queue);
-	if (req32 == IOPMU_QUEUE_EMPTY)
+
+	struct pci_dev *pcidev = hba->pcidev;
+	u32 length = pci_resource_len(pcidev, 0);
+	if (req32 == IOPMU_QUEUE_EMPTY || req32 + sizeof(*config) > length)
 		return -1;
 
 	req = (struct hpt_iop_request_get_config __iomem *)
-- 
2.43.0

