Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36642ECE8A;
	Tue, 17 Jun 2025 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176753; cv=none; b=Tj2GKGgd3JDDNVRXuBB5m+N9VFr3Z9FfFVgvIgf7wk8x+odHWjWs2SQmvcEkYXV0FOM6eBokeawLZc0Xy4Esljeu8gVosaWzoaXJtjtDlexkZQBvej9pBp0Bb8pSrSjyU1tcCkMh9yOEC1wBY/ONlawBRDkKYiYmf0AZpzMvxw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176753; c=relaxed/simple;
	bh=TJvZblJpIa9D0x7fZX2D6OvOlnJtJsWT6fGloKub2DA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ML4K7I+Ltm7C6CcoW9LmsxOVM2wxkmngT05xX2IRnZMLfAarLHsNgV2paK5ksII3EJd6tGv7I/7ME/IPqO84OfM5rZBFRpiAJlDZ9pDUnkw/ixkC5Db4qv6RrBd+gsGWG4vzgGHjOz+Zizwn3xwoLGXtoh76pQ1nQAOuZ0YCKnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V4iz+ev2; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V4iz+ev2"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a577ab8c34so274105f8f.3;
        Tue, 17 Jun 2025 09:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750176750; x=1750781550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FKODIo+PGL4FfaP6Gv7XmJHhwu908ENQS1onyL5vDbs=;
        b=V4iz+ev2HKWXUB1ehpemF63iXEVQ7Qzkqeyqw1swJYgld4bdbnRcfox15lGKIZ5s+k
         f/mSWBwSQYjgoCBKBjrknSlqBZWte2VwOpZenuAJ24e76WYBkZUwS5VMrlsmKvkDtht7
         8cJc7sDwVtr6aC9RSMGSIUU/60KNy8i2HndO6q5BwB7zQZdTJ2q+5teoi8Xle1tJpQr/
         HKbplm4X6SmcGaYUNn87eaSEKmNeGvdeoIU26xo/QD8V9P01JPhYfFR87WaFlFDkN0zo
         ZVYnw11xO3ezD3Z9gQ/9cB3M1Lcz0vYgRB3rBpURgNZgBt3q3vCG5TwiNEaCpVSMj2cN
         5JlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750176750; x=1750781550;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FKODIo+PGL4FfaP6Gv7XmJHhwu908ENQS1onyL5vDbs=;
        b=VCnKl4rD7ze6Sz2BL3gcQ8se8bZEUzu601KpinyaHtbQwG2/m51IGvyQ9K2sam2GhX
         WhOCDUORK26TBI1M64pYB3CGjo6STjl5aITbYKoDqtmSTlDTftEbJx4gsxhCR2Yt3ayI
         yaYAW4CwAXXEHAmmUhcMbdSbmVgtQTTJA0b9vnZYZ1gMsCNzlSoBf3eiztKs9Ht23TyA
         nnFrHZTc7U6D7NoQUqmjA1jDJU21bCO4VPXWxbAD8PphhVtYkP/nximrdQHaXALNo3hn
         BCUxIXZwmZG70MzVdXvx+/iDYDonHUblRcyuQx4pHb6B6M9HhMXxqJdAKN5u+ZtEPOoi
         wAXw==
X-Forwarded-Encrypted: i=1; AJvYcCV5QjiHQhcL6YXVQaIUMGtC7C6DPXWtYenvj2ZNOKV6yEeKIfOU+AsAjChRUUqRtQQzFAED89Atu95YOgc=@vger.kernel.org, AJvYcCWB0FYGQp5GVyWS7w4Ha32Y16csQDD+PLS7JHZdUToqeyXOfHRy1z0azrWuJ9UG0cW9mjoAkpvfN6/EkQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvTt5YtuENBuoaN+mESyNkzpJeFRwdDsBDQnKGbyWAXPtKuwrZ
	Uk2kze8shK+xqKFS10FnxD5kx3h8qfwkn1yZ5V7+5xQ6Ay72LWeASfuz
X-Gm-Gg: ASbGncsHraCWSfOtO+mu9jP2SY2dyeOlzxQWAps00vViqPc/4PlPEW0avDbG2lS75pJ
	ClQWsdXIyo7y4qqLOZogT1Xb/tgkAiGj4F1rj4MmGf6hHmLtnbbVmqeJMIxftV1RuVK3SIRm+k8
	CjKmVRCpF1fzreS+SP0ndCDkcJdJKeDxwsIErOV6OZMvoXIMeV9lM1iJoQPlbjQB3cB0YSanuGS
	kUAI6JUaMPaaAt35tkl//40n4XD+Atsrcr4nP0s/OLW1j78CDJ8Do3H6MgpnIqs+XtFD7ztFBdQ
	Us0n7aInCCzYUbBlm3+9o0/zRkA4z3Dl+u3qElscZ81T1YBwYjF1D8htPX2KWdOXSC6Er+jdfCN
	q85VZUCuzYBkFf5iJRxYR14Im7w4fF29vWpz7Nd9ohnz9taWdWrkCWrQbne4SwLQ3pqiN4sxDXh
	0=
X-Google-Smtp-Source: AGHT+IGnvRMOWFkNNdD8ewDwN5gHHgHwhRjmoB0NywW6zfw9yWQjU3U9ktOL5CXPfd0twGaki/XvoQ==
X-Received: by 2002:a05:6000:40cf:b0:3a4:dd00:9ac3 with SMTP id ffacd0b85a97d-3a585f7d579mr1235736f8f.12.1750176750098;
        Tue, 17 Jun 2025 09:12:30 -0700 (PDT)
Received: from thomas-precision3591.home (2a01cb00014ec300dae5d691da698f4c.ipv6.abo.wanadoo.fr. [2a01:cb00:14e:c300:dae5:d691:da69:8f4c])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4532e151c3csm185089575e9.30.2025.06.17.09.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:12:29 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Joe Carnuccio <joe.carnuccio@qlogic.com>,
	Himanshu Madhani <hmadhani@marvell.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: Fix dma mapping test in `qla24xx_get_port_database()`
Date: Tue, 17 Jun 2025 18:11:11 +0200
Message-ID: <20250617161115.39888-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`dma_map_XXX()` functions return as error values DMA_MAPPING_ERROR which
is often ~0.  The error value should be tested with
`dma_mapping_error()` like it was done in `qla26xx_dport_diagnostics()`.

Fixes: 818c7f87a177 ("scsi: qla2xxx: Add changes in preparation for vendor extended FDMI/RDP")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0cd6f3e14882..13b6cb1b93ac 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2147,7 +2147,7 @@ qla24xx_get_port_database(scsi_qla_host_t *vha, u16 nport_handle,
 
 	pdb_dma = dma_map_single(&vha->hw->pdev->dev, pdb,
 	    sizeof(*pdb), DMA_FROM_DEVICE);
-	if (!pdb_dma) {
+	if (dma_mapping_error(&vha->hw->pdev->dev, pdb_dma)) {
 		ql_log(ql_log_warn, vha, 0x1116, "Failed to map dma buffer.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
-- 
2.43.0

