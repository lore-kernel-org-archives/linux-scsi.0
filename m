Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC7C413797
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 17:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789752054; cv=none; b=HBoOAmCnfXP+G03nhdEscFIPACgr8ns9au09Qfoo9oaHO7r4OIUFeSOYXn/oSb+zxPGnhL7a6eXm7L7ZTrfIsZvHAmetC4h5/wf+PgOAV1fXEgMRCuF7liwT0WK/5lkfXefasBxnM/4jhwUFGcpbbNw7zwbzFzIeVjvZjunR2ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789752054; c=relaxed/simple;
	bh=ycTNuNghg1L9HOhDg4vLC91GWhxqeUus56xpeIdOnok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CwW114LeSGJC63OLW3AU/TUx814iFHErR6RcX48FWfV622q0M6oMPZE728Y+FMu8h759dR7zU2eAGIvL5J6SL5pwHQ3V2hw3n2XoViUUhViR8bIGaNJ/TdCLyKaIdkyIPwZalkH0KehBay7aKrL0R5FfTJ8LnZUy7J/jvYJnito=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=in8+y42w; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="in8+y42w"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d93ff61046so9910205ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 10:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789752050; x=1790356850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LGeB3qqSMA8aQqCowwE6YHw3Cnq2V7NyQcOr+BMSCUA=;
        b=in8+y42wn7r01a2hjC2vylH+FqkMzv1fhdNaTj7Y/GZGeKJ4aLa8+BkvBqopazpBP1
         uMhLAdMAwuBkKqTHXTWqcSkP3ueT/8z23RSoFO/o6PvDbFJwpEm9LAh1cXcbJpVc3hfR
         U1zQRuZ0dpjWW3swvO+q46XDPLvq5r8i5uLs5EqQJi3ei7dxVpQHe0N5k0hv27qr3yRM
         Jq2uxIBp/zNvzhI9icRXjpdzfQnQ09iMKMB3tgIyrMA5GQAPqJuNa8IGySxx7qfgeg0K
         tHQWe/OA7Xbo6EkKHD4v6uWNA97uyj4vChps1qKMms109yZSOc5uhWDN21/Y10Y04qVR
         bJyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789752050; x=1790356850;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LGeB3qqSMA8aQqCowwE6YHw3Cnq2V7NyQcOr+BMSCUA=;
        b=251ZtDT2pt6Z+BjfAeFv/TooTf+q0BcCqQvVfK7/zbdr/a7qZU1AjRmMsfAF46FqDE
         P0TrCsZiF+cqu6/k8mmBqp37nvbZdL5eVtTkBtLm5iJJiakiKjfXM3S7Tvfh3DGIEOE5
         104h7NrJJ3uJczZRXCGGjlLmxOpAE2U4Inc1u2f7lbeCjfUyG1z+7udP8UuE47ROHHya
         X6Z44C5zxrwRGnucq9zR+xBbaAl78/27GN0B9rg4fBzfDQQdqHStAqCX6qS+GrOt15UL
         yZqXJYFOhfYAwHpNtEgcachi6KZ6BZMTJ7ZyPeXnUeBFmCprc7uV5jIuXwuW+SE1pKrs
         FS7A==
X-Forwarded-Encrypted: i=1; AKwUvByyuH5nl12DLMX4+5ImH1QanXeeJp1lVZK8/VQn3bj2Blr2W6J1j0KXUNTX5zGah07oqMS2BEexf+Yi@vger.kernel.org
X-Gm-Message-State: AFuF++mhiNihuNdLw9HRh87bLd6P0KE7VwSXsnWLvdu7d2kA4mzvW+jp
	FCdHRoS0QXWSS8urzRQZ5hJahr1KFMCPEF7JqyQXNBpI7ekmapJM/qzJ
X-Gm-Gg: AYBFou0LaqaJNVLaIWc70YMi5QdgJ6Hn0oo3LIjGMsInStF+MavEoHpkjJL8BEk1Upe
	XTXxqP4moRb86ONSynfbwM2FVMwPLLSi2sW1xJX+0qba8yRnXu+ediTCvmUWyFvwOgACwoU95Jb
	AlB0U1BQ69sLNAGk2ik1p4gAbVQau0UdEkhHigiINr7+V2UOgtvqpN++yiVI8XQbwm90gFFhL5N
	VEXNbYEuZTyOSrGsb9nsqjHahirzCL7OO8cnPEX4ebN+aHCsE+4wlL5BmAL3HVcOPhrXPGuvyMr
	ZZbJGmLdFoeRDYdXSIxidHLNSlR4sxjidDf4aWPbUc5pSMwdeKVwhJFJ2j6pAlTY1ZBwzxI7qkz
	lpKVJgaMSjEtC3rAd3G69InriU5SDNOzV6MCgMio1gQlu510ZbK+Y0ysDzLjWqNo96F6iJSbO2X
	LPlTEU96GpXlL4BD2aKORG+w3Ur2fhthyZlACm8fq2JRH5pf4eQ1ZVlQ==
X-Received: by 2002:a17:902:f78d:b0:2dd:c054:1980 with SMTP id d9443c01a7336-2ddc0541d21mr9604945ad.37.1789752049765;
        Fri, 18 Sep 2026 10:20:49 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc18031c5sm26255ad.77.2026.09.18.10.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 10:20:49 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: mvme16x: put SCSI host on remove
Date: Sat, 19 Sep 2026 01:20:38 +0800
Message-ID: <20260918172038.3594309-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvme16x_probe() obtains a SCSI host through NCR_700_detect(). The
probe failure path drops the host reference with scsi_host_put(), but
the normal remove path does not perform the corresponding cleanup.

As a result, the SCSI host reference remains allocated after the
driver is removed.

Call scsi_host_put() after all users of the SCSI host have been torn
down to release the reference acquired during probe.

This issue was found by manual code inspection.

Fixes: 506c7bbcd9bc ("[SCSI] 53c700: m68k MVME16x NCR53C710 SCSI")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/mvme16x_scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.c
index f4db93c13986..8191b1e273eb 100644
--- a/drivers/scsi/mvme16x_scsi.c
+++ b/drivers/scsi/mvme16x_scsi.c
@@ -120,6 +120,7 @@ static void mvme16x_device_remove(struct platform_device *dev)
 	NCR_700_release(host);
 	kfree(hostdata);
 	free_irq(host->irq, host);
+	scsi_host_put(host);
 }
 
 static struct platform_driver mvme16x_scsi_driver = {
-- 
2.43.0

