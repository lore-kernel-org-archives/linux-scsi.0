Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C70D3AEF27
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 10:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783421787; cv=none; b=eMVIucB9XJr00UI4tS813UZ8osWFSIH4Nd9N1Ff87GBd5VobnAksXg7O1yc/YAUvyf3N+O0bBVOkFY5ISSRtiVt5JHaMaTLdpguZ0lW+u1zyLgzEraGh6PaqZngCCNBbRuivMvWWkFX4Se3e92XTmWVoc9ojB9Gv1bB55kRrnBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783421787; c=relaxed/simple;
	bh=awhhvCgICifL1tQgcoJS/mW48fOurHuo99YkdBdLzk4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JGBp4MXI3s45QTGKUpnnUCeM+NE8tb9Soba11fEJSLSO4tzBQcXhF8PB8EMCy0Y5EHV1MxgDGQ1JHx8dmqfEq9Riv7S5E3M8vJVEIjVWPsUELOLJBNBqsu453mO3M3/ZcGW0PuPGJhKJDWGjo5hBYpEf/x1ONIr03Vhz8eFISk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U2yOpvqx; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U2yOpvqx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783421780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gWWEywfitziTG44pKsxejOLDxZopVxNIPtMFzDkT2Yo=;
	b=U2yOpvqxia6C/WW/Y37RzEXFYUFX07TIsRO6AmfYf17zAXu/PzbE51cdOFLvEIy1IoR8El
	CmG5advzta7pXPAAxFz0ZYnNqopJlpxdc+fx+br1Dm+Ir4hageAhSLtekkzVP6JDma2K7I
	LNDHnzHTX6XaUSBjXn4LLp+9hIWZJl0=
From: John Garry <john.garry@linux.dev>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: p.raghav@samsung.com,
	sw.prabhu6@gmail.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH] scsi: sd: fix error handling for sd_large_pool_create() call failure
Date: Tue,  7 Jul 2026 11:55:55 +0100
Message-ID: <20260707105555.1382237-1-john.garry@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If the sd_probe() -> sd_large_pool_create() call fails, then we incorrectly
unwind the probe actions.

Currently for the sd_large_pool_create() failure we do no undo the
device_add() call.

Fix this by mimicking the handling of device_add_disk() failure, in calling
device_unregister() and put_disk(). The device_unregister() call will
result in scsi_disk_release() being called, which unwinds many actions in
sd_probe().

Fixes: 7179e626b76e ("scsi: sd: Enable sector size > PAGE_SIZE in SCSI sd driver")
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
I do wonder if it is simpler to always create this pool when we can
support LBS. We only create a min of two elements in the pool, so
hardly large.

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 599e75f33334..d18693d390b2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4089,7 +4089,9 @@ static int sd_probe(struct scsi_device *sdp)
 	if (sdp->sector_size > PAGE_SIZE) {
 		if (sd_large_pool_create()) {
 			error = -ENOMEM;
-			goto out_free_index;
+			device_unregister(&sdkp->disk_dev);
+			put_disk(gd);
+			goto out;
 		}
 	}
 
-- 
2.43.0

