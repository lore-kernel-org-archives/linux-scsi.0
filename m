Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FE219CC02
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2024 22:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732661389; cv=none; b=tLKJWDslqdSQHeyZ+8EfvnpGsA0YJO1frqwMTiGX49zsl9A6/nlaaEI7muzQSmNHgxyFG8/r/Ed99dGIJAdXb5ZX2RrjyfdVl01g4TC7xaJfRXODvS+GArUXuy9RrSrePErw9Q67Y12mLtGQqNWlVK9DjBHV3DbxHn2REpWVzNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732661389; c=relaxed/simple;
	bh=HO4kGLHdZ46KJzFqmtjTFi+nQsgV3QcEAv4sUsSt5xo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HUBOn3OTRO2dHIGhvEWxbl54/e+yTT0WHxBP4Nxj7/oTAZ9GPgeDXBWODXwH43KoJR9Ax0NNNnS891WBjkOXx/dFmQJeN4rre4GHwkPNcT7I4W8idOzhcnwTFlZGDxuwL5XLL223sjLm1bNWR8mEH5e5jBLLOHiQt15vgllvs40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ln7f3+Ma; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ln7f3+Ma"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-72530f542a8so132482b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2024 14:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732661387; x=1733266187; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9P7Y6hO1KRaALzgNc/8yHI8FvE407ycTLKy/FIi5bOI=;
        b=ln7f3+ManIYlw+pGafejt5GaRFRJhYVVVni6KW1VnVAtDfbMr7zVNRrDNvMf/td2Hj
         ceChdLN5T9mQsGlkZ32Al+cL7RJAk2kJ2E9H5sTeQ9H9/nsFFr49Hj/uRtMIim2GeCxW
         /p8YvlQOqOQggLnt+BVVlGUXYfcHQKf7xAPBD2Ln6OOB5TZah/Z7HIpVRscEcOmYUrjL
         GRNQAdn/7WmGpKG+lvDgi8D6yqBopFOKWy8qovACqH+h70c6px8EcsLhzCfSFFnBAaoR
         BMjnlrQ5x+qGzFvOQiQESt/b3c6ZYkxUVWMapxjKsad4AWcGZDnAeOoPMoWq7qsoTQm2
         AbuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732661387; x=1733266187;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9P7Y6hO1KRaALzgNc/8yHI8FvE407ycTLKy/FIi5bOI=;
        b=eW/o0DJjvE7/uVuelOyAobE7lBt6iT/TZ7Jh0Hs6330T0K5L7eckwmF8p1nYy2r2lR
         cXTTs2c+hwOSTe4ZPgwb3uxYpxSqeaONmbOjw5ebouEzrUpeaTs3BTZQtBb6KwIJT7fY
         el3/jVm08v1h+SDKeD3YheTIeNLseBPUQsNcalI9Bew2HBlGixfxMHaW+t4JIHUcza5i
         qcJFI3J7o8TRPf7VYnrKj9enHn8KDspJtEPY9cxtYM2WpOe9z3g7OirI4mfbZFcVFu8g
         fPRWasNZhChSaiF2rYtTR5ievB7Upa+ZWhCau1Kq28eh8yHv8l4+6i0MnjDsGICo8wLI
         f1Ig==
X-Gm-Message-State: AOJu0YwbgYB2SkHYxixr9XrsmP/s3meQT512sW7OpRdvHLsKDZgY7141
	NIxj2s0No8V8+iE5dpD9LaEv2kQbjcDI0q4plMWToBt0fpJM8iO83xhgEEqK7zO3ekkTaQmhCyh
	TJBcumBBun37WttTlx58eqw==
X-Google-Smtp-Source: AGHT+IGBAWYeOEhaz87TjdeEOr5B5hoQsFgmzgO/CGWAO8M7kpMSblZXDhBBLm/oE/W0R77+i9RRo26nBAsOi90Pdw==
X-Received: from pfau6.prod.google.com ([2002:a05:6a00:aa86:b0:725:31af:9cfb])
 (user=salomondush job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:230b:b0:71e:2a0:b0b8 with SMTP id d2e1a72fcca58-7252ffd2b20mr996637b3a.1.1732661387475;
 Tue, 26 Nov 2024 14:49:47 -0800 (PST)
Date: Tue, 26 Nov 2024 22:49:23 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241126224923.973528-1-salomondush@google.com>
Subject: [PATCH] scsi: pm80xx: Increase reserved tags from 8 to 128
From: Salomon Dushimirimana <salomondush@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>, Salomon Dushimirimana <salomondush@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Igor Pylypiv <ipylypiv@google.com>

Increase the number of reserved tags to prevent command processing
failures when the driver is under stress. 8 reserved tags are quickly
getting all used up leading to errors when command completions are
delayed.

The driver needs ~512 ccbs/tags for maximum I/O utilization:
16 (max disks) * 32 (max SATA queue depth) = ~512 ccbs/tags.

By reserving 128 tags the driver will still have plenty of tags/ccbs
left: 1024 (max ccbs) - 128 (reserved slot) = 896 tags/ccbs left.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
---
 drivers/scsi/pm8001/pm8001_defs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index 501b574239e8..abe6560a5817 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -90,7 +90,7 @@ enum port_type {
 #define	PM8001_MAX_PORTS	 16	/* max. possible ports */
 #define	PM8001_MAX_DEVICES	 2048	/* max supported device */
 #define	PM8001_MAX_MSIX_VEC	 64	/* max msi-x int for spcv/ve */
-#define	PM8001_RESERVE_SLOT	 8
+#define	PM8001_RESERVE_SLOT	 128
 
 #define	CONFIG_SCSI_PM8001_MAX_DMA_SG	528
 #define PM8001_MAX_DMA_SG	CONFIG_SCSI_PM8001_MAX_DMA_SG
-- 
2.47.0.338.g60cca15819-goog

