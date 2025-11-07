Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214BE184540
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 15:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762530808; cv=none; b=XgwVuv1aB7p+HLGeBc7fvrjtgrT/o5dCtyn+du9gNx2PzTkG5FGSIVAMl2IBRKjOZbHoSIBMhdETb8wgfevzLhi/flSNPoqL3A2cQ9v0fiFFf1oclARhMwlAa7nLckH7F9qUp/XatoGfJJYqL3LzxxsH/igQ3pFOxTMA/T7nazU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762530808; c=relaxed/simple;
	bh=Z/HW6Gd2eaFdwzc3o2Q/3/qDsl9IgmaCSmXGYi3MYJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qHGrFj3GkIXqvhEIDylExnOYpdkVxReiT5/IEgOFneAJKll2uIze88//DmkysDj6qoWUF3NeEGLkHmERTBLcW/cCJY6RgftIaNX+Mm81+emawGH8k7uEV+NCFc+pgNAe21Mv7j5AAtYDXLuepadiTcWVfC0oo9pNWMDCt27PtuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NBXE5J5h; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NBXE5J5h"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-429cf861327so635868f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 07 Nov 2025 07:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762530804; x=1763135604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=17YEM9k7IvljCCDwPTNBWkpc9TMBSZ/b/zjRccaW+FU=;
        b=NBXE5J5hfHWccO7T+0GV9FjwJoQ/vVSzP9NWz2LeGOerYqpB61Zz04YZGniwOgo7Ci
         EGxi87SNGyny7zGNUUlJriEcj2235NZXFilgUOSJqb1vPcjslqR++aLeHWj1OFaPQIRP
         nXBBFWOmrnv/XxMbkprqeFQTGuj/3qRxT6ljlG2cTPwCzIfJXeC9zh8HeHEAtNIboDKg
         +jDMmm0wUmGNmmIyIUTrF+Ok4V9b3t3giOs2ziNx+3U00jldlcsExydVG8kQLueUW0ME
         bjLl+NKe8iWjGO82AFsVFoX0Mw9RElO3wqUkIgLvIvyY/oZyDuPjv1c5RurxKqtQpXCA
         lnkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762530804; x=1763135604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17YEM9k7IvljCCDwPTNBWkpc9TMBSZ/b/zjRccaW+FU=;
        b=YDLW9IqzfZ16GAP3gmyrXUoYQT7lNaY6kUeK6407qzMfTApqxmbMZU3wTzuZWe6SL1
         Pqfi6HquxGagljB4rfoEgp0zIKLTiAHxW3rBQasb7Y/jev8XY6ZPCbur01Jla67hIGyX
         fFUzWN2sQ2aNfxsUkJ1AATk4cBMo6Xfp3ppYw3d2pLwT2sZVRzz2TksouiotulwtGn7J
         EiwM1wdWxxOr7UNl4uX43IoS1Lmb96EsXQ0v1bNnUy8Sd1vIR58nDzRtAs3fpXdp7WjJ
         vj6JS+4OyWsHEvnNxzKBZ/up7YrZ8yWptLPgKJZPsp8wUDOojfC0KmhtDmqx5O/2luZB
         hN9A==
X-Forwarded-Encrypted: i=1; AJvYcCXu73zP0sSa1KaGcHL6svZ6qykq2BJBA3+gD02yD0LIebzkLskqdxiK6IpcsOcFnibwEMAuDeO+ZILY@vger.kernel.org
X-Gm-Message-State: AOJu0YynBvPPjhsDhb4fKXbWlwJajnur58Drjjh5vHtgNvAV679Ra5B5
	fkgjg4aYVXqjORNJ4uD34az0dHObHzBkGXwuZVan58FMS8eHaCy+Gu5L7vq3OEdYJ1Q=
X-Gm-Gg: ASbGnctBv1wHQTozcs1qT/1JqaQV4TXNGvXqQQ3OnmeZ1X/Ole2R5tnIGU4VBCw/Qm1
	zKbSfd+W5KhZ6cIR+NXGEazaMP/fo/AixQmfSRUlTheBPL2Z30kI4OabgXJxTudegkHmBx/0xaL
	NSpApOGoBqCCubZo/YtajetUHzxnGDnHf6deVs066ugYzsdOFDhYa+ycJ9QR+90ACzQfCa+Cwz4
	w10VXzVRkxZDsFiWbFpWIaIvOh0AGy15fqOeGXQgLraO9jblp960yufY8JlZUIlBSLeacPMWgzu
	WxErtXa/EH0XTVGZkAY+WJ1tzCNTSQvvP7gwN6ToXNQY1I8BcaXnnjhLHD1oOGaQowcYdhHVb3J
	nX01FNuwbCtJuJkH0tspR3qUtnW2RibFGOvnJnwhiKZm+yCk7AzEGl6I/wBvI0HC/exhfXQNRM7
	IQA00p3TGWA3VnUrwknhoizUhY
X-Google-Smtp-Source: AGHT+IEokRi0h80eOyFa6VsIO+fcg0fMne03igfDqDKxQ9pp+KJhIGPFNTKOsC+yFoOa5eXicCpnrQ==
X-Received: by 2002:a05:6000:4026:b0:429:ee71:2ff0 with SMTP id ffacd0b85a97d-42ae5aeff0dmr3333462f8f.53.1762530804428;
        Fri, 07 Nov 2025 07:53:24 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675cbefsm6256121f8f.27.2025.11.07.07.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 07:53:24 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH] scsi: pm80xx: add WQ_PERCPU to alloc_workqueue users
Date: Fri,  7 Nov 2025 16:52:57 +0100
Message-ID: <20251107155257.316728-1-marco.crivellari@suse.com>
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

This  adds a new WQ_PERCPU flag to explicitly request to alloc_workqueue()
to be per-cpu when WQ_UNBOUND has not been specified.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 8ff4b89ff81e..9acca83d6958 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1534,7 +1534,7 @@ static int __init pm8001_init(void)
 	if (pm8001_use_tasklet && !pm8001_use_msix)
 		pm8001_use_tasklet = false;
 
-	pm8001_wq = alloc_workqueue("pm80xx", 0, 0);
+	pm8001_wq = alloc_workqueue("pm80xx", WQ_PERCPU, 0);
 	if (!pm8001_wq)
 		goto err;
 
-- 
2.51.1

