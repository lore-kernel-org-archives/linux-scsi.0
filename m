Received: from mail-pj2-f28.google.com (mail-pj2-f28.google.com [74.125.227.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86B5519913
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 17:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789751451; cv=none; b=Al3pCK+KGFQPgE049XsNr5LcjIhvvIwQQPorEfmiPFOGrKycJpRt6JkWec7ZbwG+Wc3EXK7O33fKCdAdV9FdrcQfDaEJyPgK0WJmBZOCfLoGw5VVvYP3OoKDEZB1GxkNnOUmie2zSwwg4SN87BpaTCnFgbbvjiI4ZKqneNRyoJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789751451; c=relaxed/simple;
	bh=ucvUi70zYMSNKdpB5M9U4/0JPwWH9o5vYxQ/RxH4z38=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oDoaynh6GRK5HNJdaoldZ1wfvZ1cwnu0ycN+o9IIdwsk65BRZB/bv2Id/OLbjxcRbIHAFOWsKxzbrLH+n1iPqqhqVbiviHqivvuzlhDqRT+gecguEZRIwfviPVLbi6c7CdKczZrqDQsDNXYZjs/X4Gl364QzMq3oLcsXPFM46ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X/3Gfra/; arc=none smtp.client-ip=74.125.227.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X/3Gfra/"
Received: by mail-pj2-f28.google.com with SMTP id d9443c01a7336-2d91c22d27dso6560095ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 10:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789751449; x=1790356249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tVg6kTrkQkmUGuiks//D1y2XA3XKuOl8NQNCerU5SkU=;
        b=X/3Gfra/nivtqCsk6pHkyBPJoOHZb/Q9AOv7S6Hz/RqNjy5ZMpa5/+iO3h7rf4z+Ju
         ZIFrygxxDdPld07CBab3jooOq3WZxvbF+2jNXSn1ARddELHeUEKcQX8tN6VPKr6t2ALx
         PiChhSnA13tlFokZqEf3jAQQXf8/NbAwSyoYRYQ06cutbgmM+elE4ONIem79UpfmvrSs
         Ob+2t24gYN0gj7wpOKRKgtkHDRxBOYIK1Jr3ovEGuHoZzhMyvVMAzlqE+EP9bQ15b6o+
         krVk5SIJwS+TwilOmWhDACDpW0MeJEibgBVhdtksZLGuctSJVwWbymsMmq70yUJ4WZxX
         M6Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789751449; x=1790356249;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tVg6kTrkQkmUGuiks//D1y2XA3XKuOl8NQNCerU5SkU=;
        b=crXhWH1clKLWiWf+fnwEJ/oELDtz18CE4/hc69DttxQ4x84otCl3VvQDSkE0+emE8S
         ymOdgaaxTBqmNAmdfFv2xaYPFF6scVtCjAzOKnOClYOgU9njUMf7XJcTeA7h6zT9gAkl
         xoI0D7aK67v7qnv0Sx8TjT0fXzwrSz24aacrQvkyKS7qmejN1jH7JAFoib8XHV9GJP5G
         UMILylx0KmcHYK7tmHHdVctp6t0jTdfTo8akYx3+5+BlddfmVgNmmMYDJ6vHK8jU4vl9
         4eH8HlJ52yMN6ZMnOi79CEw/uXvR5PO9TMukVColE3X/eJkpQPIoh3EPuVtnA6gpXErC
         +XZg==
X-Forwarded-Encrypted: i=1; AKwUvByPWdXFbMQMbIfU82Ij86Wq7eFntguxncs0GV8/t2fOgRoKFgdKlrvKv68mmLLFX1YjC92h9xpf3NYh@vger.kernel.org
X-Gm-Message-State: AFuF++nN+JjEQzuPtcAN5CdR/lpjz0i6cH1dLt6cyV+ubQnL1JMblqMP
	kr5Svogd4F7WUUX7lOH8FPEvhisgqh9T1SPaOQwV+h1cwRwET1zl2/vI
X-Gm-Gg: AYBFou3/6vgpdtBcJNXeccgmeqHhDhiWWCIn6aVhIPVF9VjobNJjiV3uSUAAJ9rAeyC
	RqPW+DPgm45nXBNRIt6sdUSMfosyqMMXY1uH08aNjDTvUs0eWslZq7JV7BNlN/vCCKjfNatqO+m
	TpHRayUw7PfvfcAxW2D3/Hz7tSopkCKNW/VpaVqXtPEwcPq+NAtGxZ7rj5D5xwwYHQ250Sq1Huj
	ZfBQa5GgR2ahK8ewXfv92knzfI2TI+ecEOLRRXjRw96ShhX5bgy5CGVZW/SryzA8bYTQXqWedFT
	jEBydNCVTYnkhfeszQMXkAM34gpwC7O2FV6yHaGGtLiUCvWpYW/Svewnx2BPynlFZETt6bQZ16B
	aMJcbhDSbp7N0st0qk5Ezmi2Z9OeAhJSZ/Z/FrIqSOpv/qcfSDqu31n3xCmGjjoqxg3DJdS5MnP
	0gRaBydOwoELssPXWc+c09Qcut7PAnZqw1OqZqQ+1eHO8zRqvYoUriKQ==
X-Received: by 2002:a17:903:1446:b0:2dd:c100:4b7a with SMTP id d9443c01a7336-2ddc1005ecbmr3691105ad.49.1789751448786;
        Fri, 18 Sep 2026 10:10:48 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddb75b6552sm11775625ad.61.2026.09.18.10.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 10:10:48 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: lasi700: put SCSI host on remove
Date: Sat, 19 Sep 2026 01:10:38 +0800
Message-ID: <20260918171038.3588395-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

lasi700_probe() obtains a SCSI host through NCR_700_detect(). The
probe failure path drops the host reference with scsi_host_put(), but
the normal remove path does not perform the corresponding cleanup.

As a result, the SCSI host reference remains allocated after the
driver is removed.

Call scsi_host_put() after all users of the SCSI host have been torn
down to release the reference acquired during probe.

This issue was found by manual code inspection.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/lasi700.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
index 6d1fb55cc3ad..1b4982cde210 100644
--- a/drivers/scsi/lasi700.c
+++ b/drivers/scsi/lasi700.c
@@ -146,6 +146,7 @@ lasi700_driver_remove(struct parisc_device *dev)
 	free_irq(host->irq, host);
 	iounmap(hostdata->base);
 	kfree(hostdata);
+	scsi_host_put(host);
 }
 
 static struct parisc_driver lasi700_driver __refdata = {
-- 
2.43.0

