Received: from mail-vs1-f99.google.com (mail-vs1-f99.google.com [209.85.217.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16E13A4F3B
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 12:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784896274; cv=none; b=k4Gnhc7JzCtgShyV2PXT7jHCPRt5vwpWt1J8ejcdgOx7ZXbGPCT/XWrA+GK/BGb90MRMSPH0Tuu6KInwrYDTpvgVrmwmQ8opJVil7Btl5xmXYCJuBEETxsqnfq72liipeXjRZ/fmuE0HN2ktici0jfGOFXqNF9mWSEcN6s4PBAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784896274; c=relaxed/simple;
	bh=UsnQdurGkhTD0FFI1IxkF0/BX+N5D2F3UCTWwreu8xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULR75a5NNZR2YUmXA8kzefGesGI2PnxOGwY4q8M6BtPN6ALNNlT6b6CgKxK7T2OFC7jr3L8xYW6vQ8QNITpTjizmN88S9iBEMliR9nOity2tVZ1GGGpUrHGvrugcHicVAFwIon+0LFkwZcNMiTpBrwnECM25hMUN7E9JImSWVwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cyka/svB; arc=none smtp.client-ip=209.85.217.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cyka/svB"
Received: by mail-vs1-f99.google.com with SMTP id ada2fe7eead31-74ac0efb654so174103137.2
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 05:31:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784896271; x=1785501071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gyURRY8gMRQ+MzQb7QRMvKchSqs0HgkH7NPN3SVMIL4=;
        b=FyVR2ovInBsUoIf7HI/NVgX7pFMosw0X7p/QBA3I9YTtkaxTvLyT9ByH/dkHpcjn29
         B4RvSi0SwWoss4bIlQqaBni5u0roZfN+oT3TzRSZTHff2X2ly+tIQPXF6Zg90oIPL687
         UHmdataac+PmTh/KrsnuHslvOQpMTKLE6voG72h6BnY9zrCrMcb5Q8mFelVG18kA3EMd
         GANZM64DV+ZHmGPinE9512r2iuNNadrGJMH7p/iJ7opXHYvr13+V2RecBWR06tJTor/Z
         PbR6waV864/K6dNjU69SHZwenTfULiHOGGGQ7cPa3S33yhVkOMRcON2ssYQ6dKXZzC70
         1qww==
X-Gm-Message-State: AOJu0Yyr0EZg+cocRHEc/0a56NnJV125fCWua7bR3ChktAvReGpGksIR
	jNZ8pkRiMoCZfmtZYyx1SGOe5/GWcw3hAksvYq3rABHGaQFznNWBjFg1KajOdWTmTlGAgQISMwB
	pMX7f6YP2sbkdif4ISFjjsTFczjZKBXd+j3sUcV5TwrepEkY3d1ofQk/hQLYYmxpzXxRuUsHb9B
	0qPc/7sVq9NXN2EeV/ILHavPyx3Fd7K4QQWLy4n/ZKYt13XFU2k9qQkl17BBJJ5rLoMNt13/za/
	4ZDGN7Roc/LRWYe6szy68RW
X-Gm-Gg: AR+sD12+LFLfinTeHQM4nrx8qk9UHQAnXBU5vSugfbz0ttsoPj4AyXg4F6HsGvG8W07
	MeDjYCf3k0vY+4jkCXBh0ifX36xksnP8qghCzUcuQcY/raABjSmvG12e9tllN8VvHxxLBhjz8I5
	BLJ/1CgFOXMS7PtPpOjOV3P3e2CI4QWBB4GCVbr1BRmUJgA1jDk83KCFiwP4BveewBj7QjLKGRi
	PURJ1R10R2IgqwJSiO47OhiqfVxnBZygJ5yAtp6FbClcFPkggPEbsXJHgbttevKV+e2Ds66WWHc
	3SG3S4NcvgA0K1ybY+5ABt3prHHrmSgAWODZjin41QwenUj8XmFnmulYk+kyEjZMzSNCjYJANFK
	9/kIXchWP8dHh+oW9++gKr0SDAChYtte5C6eZKa0pDnv2XizvsDL04+fIrjqFHDd8IwdZXjG4iP
	qATnLv0yz4Ue5IYiDRkQWc7ejjsB/zH+x2tCiqiW1EGMc=
X-Received: by 2002:a05:6102:3e12:b0:737:783d:1912 with SMTP id ada2fe7eead31-74d5e6d6e01mr4050341137.12.1784896271375;
        Fri, 24 Jul 2026 05:31:11 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-74ad3598919sm784236137.29.2026.07.24.05.31.11
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2026 05:31:11 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so422918a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 05:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784896270; x=1785501070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gyURRY8gMRQ+MzQb7QRMvKchSqs0HgkH7NPN3SVMIL4=;
        b=cyka/svBzaGe/Jsb7zZ6ZodXWqPXzNSKHCKL5mrHLFD5k8uin0e9JkrCySpsjjJx5P
         OHpjL7Iq3oX6tM60RZ6PdU6DP2fYMTcnty6MCam1A6S0/EVQK4NRf+6RzpAVDnWZI379
         mcluxCxapfkhxOcGkNyW/91gYV4M6Wn5pWfxM=
X-Received: by 2002:a17:90b:4f45:b0:38e:6a30:2990 with SMTP id 98e67ed59e1d1-38ec660e0bdmr6888839a91.27.1784896270143;
        Fri, 24 Jul 2026 05:31:10 -0700 (PDT)
X-Received: by 2002:a17:90b:4f45:b0:38e:6a30:2990 with SMTP id 98e67ed59e1d1-38ec660e0bdmr6888761a91.27.1784896269217;
        Fri, 24 Jul 2026 05:31:09 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f041bec23sm1376175a91.15.2026.07.24.05.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 05:31:08 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	ranjan.kumar@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH v2] mpi3mr: Fix potential deadlock in mpi3mr_fault_uevent_emit
Date: Fri, 24 Jul 2026 23:22:31 +0530
Message-ID: <20260724175231.935192-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260724164630.924288-1-chandrakanth.patil@broadcom.com>
References: <20260724164630.924288-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

mpi3mr_fault_uevent_emit() runs from the fault watchdog and reset
paths, where host I/O may already be blocked. GFP_KERNEL allocations
here, both the local kzalloc_obj() and the ones inside
kobject_uevent_env() itself, can trigger reclaim that waits on that
blocked I/O and deadlock.

Use memalloc_noio_save()/restore() to cover the whole call instead of
just the local allocation.

Fixes: ec54b348f274 ("scsi: mpi3mr: Record and report controller firmware faults")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260724164630.924288-1-chandrakanth.patil%40broadcom.com
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
V1 -> V2: Wrap kobject_uevent_env() in memalloc_noio_save()/restore()
    instead of only changing the local kzalloc_obj() allocation to
    GFP_NOIO, since kobject_uevent_env() performs unconditional
    GFP_KERNEL allocations internally too. (Sashiko)

 drivers/scsi/mpi3mr/mpi3mr_fw.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 31b19ed1528e..681868716ebd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -9,6 +9,7 @@
 
 #include "mpi3mr.h"
 #include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/sched/mm.h>
 
 static int
 mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type, u16 reset_reason);
@@ -1287,11 +1288,14 @@ static void mpi3mr_alloc_ioctl_dma_memory(struct mpi3mr_ioc *mrioc)
 static void mpi3mr_fault_uevent_emit(struct mpi3mr_ioc *mrioc)
 {
 	struct kobj_uevent_env *env;
+	unsigned int noio_flag;
 	int ret;
 
+	noio_flag = memalloc_noio_save();
+
 	env = kzalloc_obj(*env);
 	if (!env)
-		return;
+		goto out_restore;
 
 	ret = add_uevent_var(env, "DRIVER=%s", mrioc->driver_name);
 	if (ret)
@@ -1326,7 +1330,8 @@ static void mpi3mr_fault_uevent_emit(struct mpi3mr_ioc *mrioc)
 
 out_free:
 	kfree(env);
-
+out_restore:
+	memalloc_noio_restore(noio_flag);
 }
 
 /**
-- 
2.52.0

