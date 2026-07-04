Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D3B1DED40
	for <linux-scsi@vger.kernel.org>; Sat,  4 Jul 2026 17:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783187315; cv=none; b=RA1qPqXuClMOCq6X6tVJ6uEqM7QR1AShiAcQZZfndv33+FFrjOElbBXL7+SbeUNQyDWqcO2s6TVkDOmBFD0QVRO9otauti+O5PWueGuHr2iB52k4QfM1SUQ8YJJPRP4afTbeQTyMGjWcOKPvtJpKDAy+YiHfRNpD4l3IXscf+aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783187315; c=relaxed/simple;
	bh=UtUu5BioZuJKfFmTZv0SLYsE6ePCGt9kpNlHvIfI8tg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TOrxhN8HrbocD4a9ZRKooSNxN2cYzNWQQcNR46n8uLiXJQshyVHvpAVPAEET8fSJkY8V/ePCS3RbLJbR0T4+ORRoHXMm3Z0IAnEfUCTw7DbZgWUKa7nAP8sPGBnPdjMXQM31lIhIcnma3razDtZta0555fkANCJRgsBvfkVucw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EwNsYfS2; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EwNsYfS2"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8453427d3f4so1390574b3a.3
        for <linux-scsi@vger.kernel.org>; Sat, 04 Jul 2026 10:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783187313; x=1783792113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sn9RvgI/yVMwEfWJXk2ielNPfuat7hoo2D7L75ktDis=;
        b=EwNsYfS27efKosx997XVsKwnYDa8kFfgk9ia0aMpj7+A99uGa+RVC2OcwRxKbh3MdF
         GlwkIBS2eTup5ZrGgOMqHuE64Ceyw7bkU8kZ0mRV+28Im1IieUUQkuL9hZqM8XOzdmZl
         1wEmhRkpj1KfTDnWqiV9pEcSo7cgcb43qQTLvqeArqAaSsGLaJqDuH8nXnEp9w3cNvIK
         UfAxhHZj3LJS9034rNjmrzTRJ5KcN2JvwbUjrQW/Oo2S+9Hh8cpS4oahSQQbxa6iZ/Cm
         Nt97Xd3sKErHu2G+P0JOCyhrZnXmsIEeoPVneJN7gI2vqEIek2IPtd3x+rzhGR8rhYeB
         8tDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783187313; x=1783792113;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sn9RvgI/yVMwEfWJXk2ielNPfuat7hoo2D7L75ktDis=;
        b=CJkr5Nz0AkAjbb/9hsOwr8OiFVSbhNONZVftTMKrv0Jymd1bnND6hxVh5pJqmLspvK
         bo30Y6l4n1aNlCvbDfcTqkZ38qkpNYaX+7b1mLP9PA9xuvkmZ2rXrUQ4x8PbD67sN2kG
         x4DrwqbNFTU6GpAJaUul/z/n4Dj1HoMNq6mY652/Pcuk6okFS4irEOBZ5rZ8BKqvc31I
         w8Ev7F0mwVxp330Onl7q+i8wIFInaR2wFu5zVOgCbkW2ZhgaWnAI2jmrfxtH5BUGqbql
         OYMtBLq1vpCt9WW/8snGI+6ybZEzmo2PsGM2j0piwtwz0aFZd0pwFCJn3CmbQKlLC6qo
         l5zw==
X-Forwarded-Encrypted: i=1; AFNElJ8IWypXkyhGInrx3F3vE7YsS1a2SEL50M/aUnvKt/4LYZ83tdqI5ptIiLp21SVvGjp+tOASOr6lQlLU@vger.kernel.org
X-Gm-Message-State: AOJu0YyBOnbTNrEFyxeEywce6wI9Ot0WTFeDZsmy5Qf7JpFqaALEGgLg
	W68dOPxjJBGY7Brrn4SVnzHcXIDgurxBze142P7U6LEP0fgUU6vJ/MHK
X-Gm-Gg: AfdE7cmvcbRLGxm9YHcdYtj/GyHBtFYYez7tv5Wl463EbhZQNgKd5UKjF+mv9SvQuOc
	0ixAM1C6tfYiDqW8ggq+/KuHyhz9LVc4O45eHpy/jczF0NG3xknDu0+SHEEYbGRQRH/iOxo0EH1
	6QQBYqP69mrA7+fv1ytRSHW5RQTVq4rsbtwnQevyq3Gi7PeAQgBve0lP2MOGRTLTAcgRHSqFvED
	J9pR33y1BVBlx4VlmVmoDLegkRRvByxnFRIp12Dx+qDw0R01oIUDiq6EF8+BSJFjtGDe03INjL1
	7qujaAljEM/cE4Y+B9NpkaP2wYsACyOky/jmfZesvzUAQvRNQniHmGoNn6+guLkQpgw5IzmpbDM
	hUb0aSB6hiFflbyHCD2uw932sOWY3gLUu27aphSpX7S56ka0trwHUe8A1y/h4/hHxYPT3QEg=
X-Received: by 2002:a05:6a20:c79b:b0:3b2:a809:1000 with SMTP id adf61e73a8af0-3c03e1a28b6mr4198185637.3.1783187313259;
        Sat, 04 Jul 2026 10:48:33 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1000::f280])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e91b07639sm3857271a12.21.2026.07.04.10.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 10:48:32 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anil Gurumurthy <agurumurthy@marvell.com>,
	Himanshu Madhani <hmadhani2024@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] scsi: qla2xxx: Fix BSG request hang on flash image validation failure
Date: Sun,  5 Jul 2026 01:46:03 +0800
Message-ID: <20260704174603.255881-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

qla28xx_validate_flash_image() validates a flash image and reports the
result through the BSG reply. It only calls bsg_job_done() when the
validation succeeds.

However, the function always returns QLA_SUCCESS. If validation fails,
bsg_job_done() is skipped but the zero return value tells the BSG core
that the request was accepted and will be completed asynchronously. No
one completes the request afterwards, so the BSG request remains
in-flight until it times out.

Return the validation error when bsg_job_done() is not called. This lets
the BSG core complete the request with an error instead of waiting for a
completion that will never happen.

Fixes: c2c68225b145 ("scsi: qla2xxx: Fix bsg_done() causing double free")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 5e910b5ca670..5b2201859f73 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -3369,5 +3369,5 @@ static int qla28xx_validate_flash_image(struct bsg_job *bsg_job)
 		bsg_job_done(bsg_job, bsg_reply->result,
 			     bsg_reply->reply_payload_rcv_len);
 
-	return QLA_SUCCESS;
+	return rval;
 }
-- 
2.43.0

