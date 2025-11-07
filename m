Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD0730C61C
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 15:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762527979; cv=none; b=VK7k5QjIqpjNgrgbdTvK0tnRjmy2TrGRU8SFfxHmAWRHsSxkg+NMuCL5+WBsU/JAAPd0mE9xeof+w/6QuDOwpeS3Lbzi/paqAE0QZacc4ZdQlA1GYCxeWyiqKMkoblPa3qvNWWRrK6mPlhfBp0w5npD8Rof7nfLUtDG0O+P/pfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762527979; c=relaxed/simple;
	bh=I1uyF94YPCgRaFvl8OfqcySKhRO4bX53+vRKo3KnpXs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FJVGCEOe6AYgQPJyeE2WGAVtWeBzQkux3iJdljX+PSR7FLLFQGzqiH4NBEgnQCN8eITMhzOymgML5Oo3C9janTcbe9jUybHx1e7BAbV+V5B5FjqAOd75GZ/HtCmuOYhO+D/ct+Lk0byM7f5HIkqE/phn1J/sW1Z4e2O/KG8s9AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gt2nUuvM; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gt2nUuvM"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-471191ac79dso9559735e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 07 Nov 2025 07:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762527976; x=1763132776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=py75GPFijQsPUx0jpTbres5/IKDk4ZsE3rbUHQbz/Yc=;
        b=gt2nUuvM5rjYgTZZJBN5l2FbDqDK3nccnSq7jgvNxILnZU1egU2dqqhBon1hVv53sn
         SVY5SC9brsdMEG2ESLfsVyh9ak1dYlJhsQORGe5446FIHOsmBqQKUdXSAXkLyqLmHi6/
         MfeDgN3f660kyJ2fPtpXn4M4kBG5s8N/FXX0xBZdbwOFNOmD/YR4eAYj5VxCyDVkb3Ez
         kCCexMNXuyfTtg8kEo/AXBFQoRQTL08pjR+6iT+QmCTeL27/uSPAG1Gcwh3foS2AlQSh
         23Wx2+H24P/lN/lfW+i2332bD4FsEAQ3inBXdVZJuH4jpbHnjIXhQaXRYca8xKCKSLvz
         90Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762527976; x=1763132776;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=py75GPFijQsPUx0jpTbres5/IKDk4ZsE3rbUHQbz/Yc=;
        b=NzMn5QDVr1nOJCRI6dscphcEOcP1N6oDx4tjDATyczHLNADBrCZ4Nn0Zt5jxZXkKW/
         YCCWWDDkGccmRe+WrH1srhkAQrSPVfNdTKEYDdtmkLoS19PW13FfgSmkeyQsRbF/nnXD
         XAxtO1Wyrk2wKd3h/0Rl3cDGbZrNAi26CoE/TqtQlVj8BTkPC7nqdtjH2zVbFWyEEv/m
         abTO67hfKCEzb1p7I8IRccxwf7qRNfYS4OaN+j9s4m1+qoDSrjNWCgcysbTF0FhEm8nH
         7ZSCUCC8MugW96cnK9DRxsgcXkV6Z0BQweqMVGi51MFn2P0OCW2x11YwwnKslHP0mVYO
         t88g==
X-Forwarded-Encrypted: i=1; AJvYcCVEsx/Xv42oZH4L07eDu5uTVOwdtMrfXXmSEzcgTbP7I8+TfkG0Q0xG9Bvdmy/LBBE8k6XFERPxF1fM@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrc/7maRlp+y7ffuSOkT8QEE9gT/KUQ0El1zLHv0PvTUpxsejI
	a6ViAQjRe5C52rtTBxANXZT0srOT76AQ2B43cSqgRAG4cD6Y0G4GuetYiTJOUGQWg5w=
X-Gm-Gg: ASbGnctz4BHH5asD7ATaLTchlc7woZV7Rgck0e/gOHIFE6WjBRveBjXH47VP/ZXzbjt
	/Ks/30KH4JPFT/Ph3tD4HmRsk8FZoqUhv6Exd9jCzUBunIcb4MVX17BOx2nOIHGOGHladGbPhRt
	K0EeA3ug2gM2ZyNydR/epk+Dff99WoXueX4RstdxXYW9tYNTl4pJo2B7YD1/4szVgNRQ+MYOcIr
	tZa4hiRbRhdFb38y0MrFNXxUMEzPywQHjKcdfq0U0xe98p8qaCWjak6n95MJtTTCeJNSH6mm0ST
	vmw/ggLStHflZYDgcbJsHpxU/Lmv6XNLZDItULLUymp4O+FiVPCE3doqBGR8wFQjuMat3CYz514
	TXLsjUy8+7sxYw/vTtS9h8X5024QVLH8p2DKbEoyq4AXpU5bogjnaclhNLGVfYSxOH/3DQJvZ8m
	1FYnJVmOlcvE99csWjTPfgYwoO
X-Google-Smtp-Source: AGHT+IGz8YM6333JLm588AFc5cKs16RWmjvD1JWcT1yqGgw96JtcAIFnCIm4vEabRZZUth0PEEmaSg==
X-Received: by 2002:a05:600c:4f53:b0:475:df91:ddf0 with SMTP id 5b1f17b1804b1-4776bcc5494mr28930715e9.33.1762527976212;
        Fri, 07 Nov 2025 07:06:16 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac677b41csm5666982f8f.34.2025.11.07.07.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 07:06:15 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: ibmvscsi_tgt: add WQ_PERCPU to alloc_workqueue users
Date: Fri,  7 Nov 2025 16:05:42 +0100
Message-ID: <20251107150542.271229-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently if a user enqueues a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistency cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This continues the effort to refactor workqueue APIs, which began with
the introduction of new workqueues and a new alloc_workqueue flag in:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

This change adds a new WQ_PERCPU flag to explicitly request
alloc_workqueue() to be per-cpu when WQ_UNBOUND has not been specified.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 5a3787f27369..f259746bc804 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3533,7 +3533,8 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	init_completion(&vscsi->wait_idle);
 	init_completion(&vscsi->unconfig);
 
-	vscsi->work_q = alloc_workqueue("ibmvscsis%s", WQ_MEM_RECLAIM, 1,
+	vscsi->work_q = alloc_workqueue("ibmvscsis%s",
+					WQ_MEM_RECLAIM | WQ_PERCPU, 1,
 					dev_name(&vdev->dev));
 	if (!vscsi->work_q) {
 		rc = -ENOMEM;
-- 
2.51.1

