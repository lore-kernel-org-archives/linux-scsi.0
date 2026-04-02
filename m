Received: from mail-qv1-f99.google.com (mail-qv1-f99.google.com [209.85.219.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2823F362143
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2026 07:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775114260; cv=none; b=u+f2NsRKffOnckYpNoBblkeMeIkJ9GJEs3qeDg6Ry3MqkOY0rPRyCYEdBCbv0NpBPXHxOE71v6N3jJkXxc0YcKTmad1/3/7dnqG4HwKIQ/C/N35PUQWSTWylGH6Wm19Gf1h0MYUVCkAcvi755aWpNbqJXmPZ7dcaxgwhWiSKjEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775114260; c=relaxed/simple;
	bh=1gdV0SawydOTOqfq2ZqweOb9opxXVWy34LHBBXGq3jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bnyr5g9dXU/UarNY3TdDZVwovCBTpkgP5hAnnfcyemp1+UecPrhFbJ1oUzytwE7fP3/vqw/YXENjOb6dgSgeKgYCFvP4Ro9itDNsprDAB5EMsq9l3RAx6/RRX76MhwoNVJB6Ha8ly8mIJHAoSk5oxM/AxQGHYtPJR+mxSZ+4niM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=f9qvXdtz; arc=none smtp.client-ip=209.85.219.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="f9qvXdtz"
Received: by mail-qv1-f99.google.com with SMTP id 6a1803df08f44-8a4b8c3a30bso7858156d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 02 Apr 2026 00:17:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775114258; x=1775719058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iANOw+j+FFixYv8CP4Q0aUKUIdpvufgAkkTBaFaBfMM=;
        b=LQ5ZNGh8JwD6Ym2NzcqP3jqDWjpZ7x+NeHL5n3mqQoaEldsgUDXQagQTlblwe4dLdh
         PFFCB79KrOgaVZkdfg1NDzTKF3kS6KLQ2H1/flJki6zCQBNVcrpq2TRtmgC+vjycwme7
         +sFw4FyRiAuUsWqPrTDffmhqGsWjjxz3+UcZjHn6tbmupfCnFMyc256xzc60rj+91Ekq
         vYojPOs4Gpu3N8HZpOlrRljZX1DjxF2MyXwrGoZeUxMqqOjWYMZutrZbncikmcH5fdSp
         aB2OKGjAIX/v0hUuCcPXew9IRIGtnJwyA2VBPonRkSL4C39OzXRhdRQz+FzCju4Y9rw/
         E84A==
X-Gm-Message-State: AOJu0YxfFzWdAlFO3SMZrKuwED/y0AF5kUhtlQth/rnUJgYyZnmWiJ57
	N+0FS4lriFxjWEDn5AkfBANZBV9RefUejJPjOKvkoSCF1AU4j1PvftQes6dKxQhcOJuGdYq6oae
	bv5NFXXaJAEmYurCn3Bi5PrMfxDdCHI0iE3jgXTPt9e12BuOjoKBx8bQxFoUz66V22UmXwxl9+R
	FcopuIEcgzMwvdPRmZrvvQqp0Pi3zlIruyDkUAZfQ42RJudO11RuIIkcr2dzWxoNSbb4AeG+5+/
	jyzRRCBEIP2iJag
X-Gm-Gg: ATEYQzwoedwADUpRCg3JWM5fvAKQekl+xqpkwx4Nvcyi2g8iAXw21mBwN+GrieSsqZH
	1O1LBZwMB3tf2kVnSiFQX7YUDhR+XSHtOXrBTjwUYyQDkAOvJQNGekv/QSxoFj+GCm2eAErgzJU
	DV+mZsmI22PYKghVue8Qlhgmgikwx1k6yNF1743xmULWo5x+YvkXz9Q6inkqqDvwv9SsPFYXSTJ
	/j1wmd53a5dXZUXZHMrjdgDl6AO9luLuhfKL8e9NmumVp2N+GMQGI84cXAIdmdh/hoao81jFZ1u
	HbXossDhMg7kJT+drzYYcSDqbeOtwQF2qIhmaUdLmCZD3JACTIbwUvA6r4Tl3vY8sYG8OKTnQ6O
	rrztbfUHPJSBwEbMmkHv3XGUm24BYLYZuRR+yKsBL+ou1TevWC0Exnl3IrO2o/RaubG62Hqt248
	BrhCqWoUG3TUpHAw57d9YytGQ4QfhcIpM1uJn9cNWD5tapeHgHlr6ZZGLc/is=
X-Received: by 2002:a05:6214:43c4:b0:89c:e44c:1b9e with SMTP id 6a1803df08f44-8a5a16b5fb5mr35803696d6.41.1775114258029;
        Thu, 02 Apr 2026 00:17:38 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-8a593ceedd4sm2137136d6.10.2026.04.02.00.17.37
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Apr 2026 00:17:38 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b23af7d7e8so17179415ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 02 Apr 2026 00:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1775114256; x=1775719056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iANOw+j+FFixYv8CP4Q0aUKUIdpvufgAkkTBaFaBfMM=;
        b=f9qvXdtzvQVlY0SP5FBqiswyZ7ffWHFiAJNw0lKwK1NBVfmfgTR/LB+5jlwsZ5/oqP
         kaicCgBGDKcEjAiOQLsHz7nrHe+cFAjXhZaoKcpe8syaS4m3Y2VfD5fC2kTjX7u9ulB9
         jNsPKk7mqkhB5WVRRZW9ZpFE2WK2nxiUUvde0=
X-Received: by 2002:a17:903:1a2f:b0:2b2:4e5a:9471 with SMTP id d9443c01a7336-2b2758c365cmr20897065ad.22.1775114256617;
        Thu, 02 Apr 2026 00:17:36 -0700 (PDT)
X-Received: by 2002:a17:903:1a2f:b0:2b2:4e5a:9471 with SMTP id d9443c01a7336-2b2758c365cmr20896855ad.22.1775114256232;
        Thu, 02 Apr 2026 00:17:36 -0700 (PDT)
Received: from sumit_ws.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27477c54bsm24612825ad.27.2026.04.02.00.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 00:17:35 -0700 (PDT)
From: Sumit Saxena <sumit.saxena@broadcom.com>
To: martin.petersen@oracle.com,
	axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	James Rizzo <james.rizzo@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 3/3] scsi: align scsi_device iodone_cnt to avoid cache line contention
Date: Thu,  2 Apr 2026 13:16:37 +0530
Message-ID: <20260402074637.92417-4-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260402074637.92417-1-sumit.saxena@broadcom.com>
References: <20260402074637.92417-1-sumit.saxena@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: James Rizzo <james.rizzo@broadcom.com>

Place iodone_cnt on its own cache line so it does not share a cache line
with iorequest_cnt, avoiding significant performance hits from false
sharing when request and completion paths update these counters on some
CPU architectures.

Signed-off-by: James Rizzo <james.rizzo@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 include/scsi/scsi_device.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9c2a7bbe5891..86c2a3a6b206 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -272,7 +272,9 @@ struct scsi_device {
 #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
 	atomic_t iorequest_cnt;
-	atomic_t iodone_cnt;
+	/* ensure iorequest_cnt and iodone_cnt are on different cache lines to avoid significant
+	   performance hits on cache line contention on some CPU architectures */
+	atomic_t iodone_cnt ____cacheline_aligned_in_smp;
 	atomic_t ioerr_cnt;
 	atomic_t iotmo_cnt;
 
-- 
2.43.7

