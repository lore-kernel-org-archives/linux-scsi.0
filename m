Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519FF51812E
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 17:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789753396; cv=none; b=n0fxq3ClOlUg1TMbVPfTtLpBa6BKdDKHFj5K24+1zb/CeJDkb4CS8T7NMbq+CsSGYMK87xD4IorniPOQgQb4fYXT50EY2olifFdGWS8qMaAp66CwdeFSEfkIBWs/29NhncvAsEyOtyTwuCwmbwAqRaHG81MAT/iMC8r8JjT7UZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789753396; c=relaxed/simple;
	bh=Uq8QRraJyLtZrRNTXaeWCRTnd/mRf52zyf3y/Vh9vqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J3upUrIV8iUozdglfa2lcWf3rbujNB5o2JHsctzkogekmNbWQAge/7XS+cD54mGnmk0vBBaJuqYXev0cbckmsc/j9vmIkkYTnaeEm7VtY1Di1c3r5XEIlauQKEpptGnmSmXHKMSaobr9P3V0LVOMIET7Tzn3Mxj32T3/PtB/UVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UU+h8xfH; arc=none smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UU+h8xfH"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469f204f6so732105b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 10:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789753392; x=1790358192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FIRlGwxrCdrjvee4osJgbOjkfM6UpiYBM8dMdM5ttdg=;
        b=UU+h8xfHVniiUKDQWJ5AVEV7NEpFnJm1eZuxjtwdZv7Pv0juY1U33W1eqVQyn6mO1s
         dGRouxQltAochZ3tSJa4v2BYefiwJcHIl1cgWEFAMG0hvWF9Kfr+CtxL6gpkQ2Fo1395
         fQxhU2ZCjOUTd2RP7Ee+Qq06TPkKNfYDRBDrlGLoSvfmzNqZA8duXa5swNYL7hlWKKKG
         sAzekTWNFWxs6w+OaVRweuWQFWLjMCjpmpRBN9bph9xAPsT8CzfQNqOQjidS29ZdOvtJ
         ppe/1UG8RUlTCT2g5in+XEoLZGnQoDXwNP3teIeEmPd3ZPB9/mopYq7wuPWj4dP49Ii6
         9URw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789753392; x=1790358192;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FIRlGwxrCdrjvee4osJgbOjkfM6UpiYBM8dMdM5ttdg=;
        b=0yRo9hyeMd0d32EHHazXFuUu0mzrOiB8Tl9Xwy+1XmvT8KSbrUBznzV+QNkqiEmo31
         6ljPr+tyk50QUgysmkDlLfPf5HznOluz8q/sxlhgfJaz6Mw86fwjJF7HvZRWUfxi561U
         PpCFGfJERYUzju3ncf8RJuXUXW7gW0OHuRZOAmCSzJ2HRHycEu8zF9KtRCA8yAP3OKnT
         QqEIaMDxcot77BvfbmSEhQpPIxjCZXcGTUmd8VKzf5ZOEv9G7PqIaqP5yNJu4g+jQXuC
         9MHGDSPSapagDXgK7gTIdRDHiGHHzu2H9npK+8ShecrEGzROQoM1GNniM3SgboiaLQrv
         JBOQ==
X-Forwarded-Encrypted: i=1; AKwUvBwjI3xcnm2M7eska0rECT13XFBDcYk8HBEzKjadI2zm0xv505tk6DjBRUGqnM8NLvVnMOPs7p99Qfq4@vger.kernel.org
X-Gm-Message-State: AFuF++nQfZyIToqaM9i2eZymmxUbRe+6VEWrx88p2Zsmv8ohoc6rr+68
	2hpvRYRM9Y0g8q/kLnaKM4ZbWJqbvZU4AqAv7SCpp4/myon7W12Okyvb
X-Gm-Gg: AYBFou1KVwUUC/FguiWvP75FhYW8ES5V4zGa1+HXaa6qu3L5KaR8LXNqdTes7gszjhB
	7s6dwHgdLRX2a08hNYHxao2yHYwhbmiM+QL7by8u3yhVvBHBXltcyxE6WLby3jyne4cRjMzpXvB
	m6zBKy091x8O0ermXiy2KHRWnRJJGW2720RWFlW4EjFi4A2EywYjHO0WZtHIBgi/eO8aG55oTu/
	TDSG5ElPQy4kfYCbnYuqZ25wRrXug6ThHCJ6frRcw0voR2/qlzoPmaYRTr8hcv4I2YD+Pb6oUsN
	ShzN7/m31PQhSblsv213uvF92tGhaaBPA/Z8by32hPf6TaghwE6fSmeqeUFRegHJe9rXWU6S/cr
	D9QhMnp/CHWF35UCOjBQgf0JLwdVWRTv/0wKvpua/iWCb+PrKQ4nor0s0P+UexoZXLbrsLxM0ie
	hAIrO1RHIC4WWr3F3kTeyEprOW/aTYt5KSqJh2G5QHOCkiT4fBJkT2qg==
X-Received: by 2002:a05:6a00:ab89:b0:84a:29a7:f3b1 with SMTP id d2e1a72fcca58-874decf5c32mr5978246b3a.16.1789753392137;
        Fri, 18 Sep 2026 10:43:12 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877a94f4fefsm130384b3a.25.2026.09.18.10.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 10:43:11 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: sim710: put SCSI host on remove
Date: Sat, 19 Sep 2026 01:43:04 +0800
Message-ID: <20260918174304.3611005-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sim710_probe_common() obtains a SCSI host through NCR_700_detect().
The probe failure path drops the host reference with scsi_host_put(),
but the normal remove path does not perform the corresponding cleanup.

As a result, the SCSI host reference remains allocated after the
device is removed.

Call scsi_host_put() after all users of the SCSI host have been torn
down to release the reference acquired during probe.

This issue was found by manual code inspection.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/sim710.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index 408f37003748..c3454e04c1e7 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -153,6 +153,7 @@ static int sim710_device_remove(struct device *dev)
 	kfree(hostdata);
 	free_irq(host->irq, host);
 	release_region(host->base, 64);
+	scsi_host_put(host);
 	return 0;
 }
 
-- 
2.43.0

