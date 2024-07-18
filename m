Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE2578C7A
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jul 2024 08:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721290118; cv=none; b=q9lALYPf3916GNHs7Y9sqrc5HxtQWMrR7tD4UJD5T3jCs176a+ZHCs0/uFhuU6fiIKmZg5BZGqF0hlGw/81v2yD2d9FhgHHAoqoveoVmjJgJjO8bO7DAgcXUr+B+IKVb6NnkTYo2mFshK3KKde1AajqzXIb0pbQDv54DXwR/EC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721290118; c=relaxed/simple;
	bh=H4w4bWRvrB8E66jmulgnfGAybN14N6YfNxdxG+lAPUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7Z1ryL57iE2kBdC+5JC/8VgSftJKzGg3EtbY7Ir0aoaOD5hj8xjLR2J6LgC6HZiB1yF4Qa2L4tQVhCdgWDdgIURHWrmkEHi2BVR2ZOoOyS7F8So28D1h2Vc1bnEUN6NnxeuxAmt/wg/w1HC4kA4nMT4vDZFxh16+ZF3COIA8Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=mOwTuxfH; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="mOwTuxfH"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-810f75a632dso17383139f.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jul 2024 01:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1721290116; x=1721894916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0zvKcJeZW/5nlFPVZg7CuEvKzbd3IdJrobgY1LSpsC0=;
        b=mOwTuxfHHIKADmb10i1U0f3ttUyT2kANWxCx4emcJIEKCuUQdjiMjs2s2uRZ1zOQZc
         1YdgqrNEU+jMT1xu5vt4JWtSTzM2MUxqbvkoCwM+s3c5FTRRJnsxNfuzLGr8Egtou2Fx
         m1o9eAoqiuVDx/yxiS/DRHSpxHG3IvP+jnad4lq3Z3SOQDMxAD20bSM/yNnvf+CGX9Es
         Bi2DIEuxriAZx7X6E9ei+Yucz3/GJgQeL9uuuM5S79eBcXpd2kDGrAKv2ppLE/yoVkbt
         c189/3baiPCN63d5+zVnfiDgVM/h4bCPSQJHr9k2jaifCtaQUzzfff0CG7B/fYsPlTkK
         1F6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721290116; x=1721894916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0zvKcJeZW/5nlFPVZg7CuEvKzbd3IdJrobgY1LSpsC0=;
        b=dl7FC9gGS4zTrYdZ9kreXZzI0Oo7ALDpEstOgtKZnjCm8bE1Ws0L6nR3+s0pT4+Gia
         G72nXspb7i3Ap8URUR1xSYarY1NDlitxpa4y/sMaxFQu2xN2ncVeznX8s7WmNpFqXqJh
         lbZDbVrF+a2DDKn5cjnvWsFsqNhchAL0Czl5d3dhnC+gLszwNrx5ldkl8Td6AoAAVnoI
         wzPQRhInRLoQEXNfwSGcejBuYMIx1qPU2dT1TpoAO3lDOtWy/WYgUjuRcZIx37gR8Icf
         AioBNbk4VepU9f5kyyBpo189qkp7n1CAWeDmmsSU0qFXZQUpQ1TDnytD6ZkUTpnrervk
         W2Bg==
X-Forwarded-Encrypted: i=1; AJvYcCWzljXIcUobl6xFkblgt+b8T8suT7/KG/BebYcQTPtenSi2J55HhrG5Nz0EGA1apIHWyE4z3KAK78DRSIv9SkuRwdYc4eNukkqEWg==
X-Gm-Message-State: AOJu0YyKI0DhVPSPJlcraIoG3JLhWltsbR13dWuOznLO9Xm3mj+p4H3C
	HeVFaoDPusncARA8DJOUDAOEQzvwQHy392h4B1zkRKrooQ0Tt6pG+0r1xuvw4bI=
X-Google-Smtp-Source: AGHT+IG+282LO3MdKEtecYTgxT/0LeZXejY4bHurHDfBCc4XmaLwlg8D0qa19SjkP31nyxE0heR9UA==
X-Received: by 2002:a05:6e02:168d:b0:376:1264:d82d with SMTP id e9e14a558f8ab-3955760e43fmr49523385ab.30.1721290115841;
        Thu, 18 Jul 2024 01:08:35 -0700 (PDT)
Received: from localhost.localdomain.gitgo.cc (vps-bd302c4a.vps.ovh.ca. [15.235.142.94])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-78e34d2c4d3sm7385958a12.48.2024.07.18.01.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 01:08:35 -0700 (PDT)
From: Li Feng <fengli@smartx.com>
To: Jens Axboe <axboe@kernel.dk>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-kernel@vger.kernel.org (open list),
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Haoqian He <haoqian.he@smartx.com>
Subject: [PATCH v3 2/2] scsi: sd: remove some redundant initialization code
Date: Thu, 18 Jul 2024 16:07:23 +0800
Message-ID: <20240718080751.313102-3-fengli@smartx.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240718080751.313102-1-fengli@smartx.com>
References: <20240718080751.313102-1-fengli@smartx.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Haoqian He <haoqian.he@smartx.com>

Since the memory allocated by kzalloc for sdkp has been
initialized to 0, the code that initializes some sdkp
fields to 0 is no longer needed.

Signed-off-by: Haoqian He <haoqian.he@smartx.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Li Feng <fengli@smartx.com>
---
 drivers/scsi/sd.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c180427e2c98..3921b8fd71d1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3953,7 +3953,6 @@ static int sd_probe(struct device *dev)
 	sdkp->disk = gd;
 	sdkp->index = index;
 	sdkp->max_retries = SD_MAX_RETRIES;
-	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
 
 	if (!sdp->request_queue->rq_timeout) {
@@ -3986,13 +3985,7 @@ static int sd_probe(struct device *dev)
 
 	/* defaults, until the device tells us otherwise */
 	sdp->sector_size = 512;
-	sdkp->capacity = 0;
 	sdkp->media_present = 1;
-	sdkp->write_prot = 0;
-	sdkp->cache_override = 0;
-	sdkp->WCE = 0;
-	sdkp->RCD = 0;
-	sdkp->ATO = 0;
 	sdkp->first_scan = 1;
 	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
 
-- 
2.45.2

