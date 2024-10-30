Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAA21E3DEC
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 11:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730286198; cv=none; b=KpkpJ7Wl7sqh9bPyQpZ+aW5DpZg++9NbxYSmOHFEQqIvJWGmUnBmihn3/NP+dMUdcprr7e0eltePW+GEBNmalC1dVvLR5JixtaNl1+SlJ+p4KrR9N6CF7PubCpNXt7VoGjDQ493WOVkt0RqIIw7kOBn3MKMnONDbUwBE+FyRVFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730286198; c=relaxed/simple;
	bh=QXNmweAgC/jmsuKKLCRRIN/boDLh/CwGPO3yrJ+Qz8U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jqr9j8MnnjLJUDm3wXjjPi9YHR8YYLxUhOeLtnXMLLdzKWRe7nVYu6pZhNpEsAsR3/4bZUENAgr/A5bcfPfa8FthTLhdrKo6BJqbXjuId66XZJ+r+ORMVTJ+Q+HdUECYocXEv/LB2isZvV0WvijD3ivItkzW0q+Zg0D7pp77Xyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a99eb8b607aso819005866b.2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 04:03:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730286195; x=1730890995;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jdnv9b+E/RPfFcm/DuvJXftcWoJYt7LIqqXdQzKrd7Q=;
        b=rclKbfCcJoPVn2Ke2HwKufeuCPcWr/yowXhUBJ+lEbyiJ7wVHZtxxWqwvVWFwH5ESH
         oZK67p4MF1BswC81gZxW919DjR8+T0L7Z+E3tSRiBVVK6T4JfGSMIzvSx1Khilesu3Cr
         ch7G1WnICh+jH6w3Z5zi4IwN3LsvPoOcqbP01yxtrT9ljmqZseBTdGqBG6IMKQaV9Jbo
         wPL3TC5HG9rNteYHXEgDVUpwJ07elZQM4ZaINe6vLleb9fneMzrZReV31dkn+i0zhqb9
         yXcipFQuVJ6bp5sCtgRXGYrJIdbH7yzVzad44vTV9sXwiHsXT76bFWaNK2WOPWDekPne
         10kQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfS/ekl6mhPCU9Nizw5k1kS5ctvDCPJugIBO548Igiuveu9tG9rR1JDQTQd+6RrusIdrKjEAz28eu0@vger.kernel.org
X-Gm-Message-State: AOJu0Ywf1JIi3LxWnHWygXJixiaWaScOvHmMCEI0sMIhjKvfXIUrWTUt
	DUwJj3YZ5N0235jJSJoP8SayLqRaWubt1zbSSNBQrdxLAHUZlVRZ
X-Google-Smtp-Source: AGHT+IEWrrTb5y7uMwCGikUWzEHzP4RjuPlrLpecJfAUkYGMedeZf6P8y6wX2A2Add8fVHGyiDrk2Q==
X-Received: by 2002:a17:907:720b:b0:a9a:3459:6b63 with SMTP id a640c23a62f3a-a9de6331221mr1462126166b.56.1730286194617;
        Wed, 30 Oct 2024 04:03:14 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6f71fdb00fa633ffffe02074c.dip0.t-ipconnect.de. [2003:f6:f71f:db00:fa63:3fff:fe02:74c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9b1e75fe76sm577518966b.14.2024.10.30.04.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 04:03:14 -0700 (PDT)
From: Johannes Thumshirn <jth@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	linux-scsi@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenru <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH] scsi: sd_zbc: use kvzalloc to allocate report zones buffer
Date: Wed, 30 Oct 2024 12:02:53 +0100
Message-ID: <20241030110253.11718-1-jth@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

We have two reports of failed memory allocation in btrfs' code which is
calling into report zones.

Both of these reports have the following signature coming from
__vmalloc_area_node():

 kworker/u17:5: vmalloc error: size 0, failed to allocate pages, mode:0x10dc2(GFP_KERNEL|__GFP_HIGHMEM|__GFP_NORETRY|__GFP_ZERO), nodemask=(null),cpuset=/,mems_allowed=0

Further debugging showed these where allocations of one sector (512 bytes)
and at least one of the reporter's systems where low on memory, so going
through the overhead of allocating a vm area failed.

Switching the allocation from __vmalloc() to kvzalloc() avoids the
overhead of vmalloc() on small allocations and succeeds.

Note: the buffer is already freed using kvfree() so there's no need to
adjust the free path.

Cc: Qu Wenru <wqu@suse.com>
Cc: Naohiro Aota <naohiro.aota@wdc.com>
Link: https://github.com/kdave/btrfs-progs/issues/779
Link: https://github.com/kdave/btrfs-progs/issues/915
Fixes: Fixes: 23a50861adda ("scsi: sd_zbc: Cleanup sd_zbc_alloc_report_buffer()")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---

Note2: one of the reporters tested the patch with kvmalloc(... , ... |
__GFP_ZERO) instead of kvzalloc(). This is an "optimization" I did after
the successful testing.

Note3: calling report zones every time we create a block group in btrfs is
suboptimal as well and we're going to change this code path as well ASAP.

---
 drivers/scsi/sd_zbc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index ee2b74238758..6ab27f4f4878 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -188,8 +188,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 	bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
 
 	while (bufsize >= SECTOR_SIZE) {
-		buf = __vmalloc(bufsize,
-				GFP_KERNEL | __GFP_ZERO | __GFP_NORETRY);
+		buf = kvzalloc(bufsize, GFP_KERNEL | __GFP_NORETRY);
 		if (buf) {
 			*buflen = bufsize;
 			return buf;
-- 
2.43.0

