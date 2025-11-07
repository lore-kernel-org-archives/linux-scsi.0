Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C572D373F
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 15:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762530019; cv=none; b=bZ7prVFBoo574I4GrE6TXcDa/fjMm4fPQm7OK/bBAs6U2hRciPKerQsie1TvgDhyzv4CvY+c0R9n4x2/sZPmX5wx2GrUThGQNpYbRfUeFCX8UKd7bQ3LYB1G8M5cZJCBPq44KOvXLf59Y7IJdjOrHu/Yfv57vhBlGnpOFMd+Tzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762530019; c=relaxed/simple;
	bh=NBspa1M9xzcXUUTgbXNjvpUvNYxLGuDwsK4d7c3UuqY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=W/Y6tbrCskmJ5I724eM/JzBSQTTK7NQ43FB6xEWW/t9Wl7+yQWvNIqoNy/DJzsehqL4YN0hK/DhLath7lFj8gyWHdyXrwb0M+DHpiN9Jx/bK3gMs1Ub9OC+fFOXzh6bICeYiYoh7ZuVjYsj+R+dB2Kr9Kt88xXSvwZT9yRbNNE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YUBRM8SN; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YUBRM8SN"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4710665e7deso4253495e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 07 Nov 2025 07:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762530015; x=1763134815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rhXOhqg1sIDmdMzsCZzzAsthVHfSqnWAIntsnfsu5cM=;
        b=YUBRM8SNAYaK0gpnieK627FbHv3r/onK26Opg9seAnOpgGiLHEIx+GwdnrPO9OxdtF
         n9bQfKMaL9+4M4AZlIEvzNR11O2ZSaEu6+sYyE0sDYojm3ycUwSWUHhHuQ3o8HtdOFtE
         C5faBceOqg+I+ko7HINWXkoULwb1zv2+g9RotYtJ9VUNzeUWuB5Ayvh7/1VhIUmHj2ZJ
         DAWX2GrPhdTccANiPM2HCCDCow6y+pzxasmpSBNlFVPjJNwqQJDWPXsLi6T//LUGbJ6i
         IJKvkzwVI2GzXb9P26Nc/XlhHsgVakc0MB7RI/8zhlD2yYJrVlqM34Af1JZbyRH2NktZ
         xB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762530015; x=1763134815;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rhXOhqg1sIDmdMzsCZzzAsthVHfSqnWAIntsnfsu5cM=;
        b=nbO9j2tjEQpNakxGssNHpf+ccMroG0Y786mdpXnlQrmB+flrLfGI4DEGYfqKe0xVnY
         doUeDgpZmBN+yqwawHnOJNsFGgrorDtlRDPPKSBr4uN4Xk/iy7zB2foxUwSELj/JNnPj
         JvTPumjzR+s3Xl/FpAz5gpP1EYYUtNa0/ZILyDAISwaFMpGboSKeaB7OLci6CsY31OWJ
         lziwvUTwWuGWEj98sQJ7jW4RXqg5YAQnp74TRYy6dvMI599PrQ9qwbqG15+QxnDfZSdo
         +mJTkdgiiB+yBdVqtFH4+rWSUG9Czt+DAfVqT3dhUBlDRerC0mU8E1UCuEXPQREA5Qho
         GoMg==
X-Forwarded-Encrypted: i=1; AJvYcCVs3mBxyeRpdv5m//1eQToXusviLs/gjwW3mOl87J7+wqPQSg11OgQa26oTgPPbGSXoQGnSqAOd4jIk@vger.kernel.org
X-Gm-Message-State: AOJu0YyJSsWQvVo7ecmxtQlt/Vb5a7whqTuB9x/N2IG2htyJddTAF0V/
	VWgg0yEsdXiMqLVee9rbo65bYOFvafZgDsK5H0lTo+Pxxtyar+HjqbVryKU52gs3rXE=
X-Gm-Gg: ASbGncv3LbCgo+mQ7I6bY3rjwgvrrp8B2FCCA2H6dGj/NXO1Y19XykCehglEDcYYkuz
	bY+SgVBydXDYpk1886yEorUTlmfrxZ3fWaDrJAlIPn4eDGnlB4PJbqZRYC6vMnXmnhpikIzxS1h
	n6oAkPwQzPZmAIRvfrpdu9NPQL5w7FuFL/4wWfn77WmJsCY7wDYAnsS3FbCcdVTTfrdT7porqPW
	Ixx9AT6Y4GOFQQeCOSKV1uvHSlui+FSovqsUpX/q+Qr5hJjXBSUTzASbxtV5t0x7GpJkCS5VPld
	ysLeePLaKwfKK68vvr5l2+pJQ2nxJGgOEQNUwQhC1GoC/JFgfW2rVLh2hu78dGJRlcfSFZa3KvA
	2V8LzceURaiLq6mKS3ZcdV+IAzJ/8IfpsjNx5xSjlYQOYVUvwaCTJ+9BiPq4ZeJyBKEcaGUWC+X
	QW3ae/pFupFqUfH70EJ1+kCHSi
X-Google-Smtp-Source: AGHT+IFSx5eQ+BnvpINM9/8VhGI19WFqR+6DwHzA3h5TSyLVbX0IHAbZJD/pcebt4hPjLvWH8Ij7+w==
X-Received: by 2002:a05:600c:46ce:b0:46f:b43a:aee1 with SMTP id 5b1f17b1804b1-4776bcff76emr28112475e9.38.1762530015224;
        Fri, 07 Nov 2025 07:40:15 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47763dc2b8asm49447385e9.2.2025.11.07.07.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 07:40:14 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: target: add WQ_PERCPU to alloc_workqueue users
Date: Fri,  7 Nov 2025 16:40:08 +0100
Message-ID: <20251107154008.304127-1-marco.crivellari@suse.com>
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
 drivers/target/target_core_transport.c | 4 ++--
 drivers/target/target_core_xcopy.c     | 2 +-
 drivers/target/tcm_fc/tfc_conf.c       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0a76bdfe5528..ca571076c15b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -126,12 +126,12 @@ int init_se_kmem_caches(void)
 	}
 
 	target_completion_wq = alloc_workqueue("target_completion",
-					       WQ_MEM_RECLAIM, 0);
+					       WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!target_completion_wq)
 		goto out_free_lba_map_mem_cache;
 
 	target_submission_wq = alloc_workqueue("target_submission",
-					       WQ_MEM_RECLAIM, 0);
+					       WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!target_submission_wq)
 		goto out_free_completion_wq;
 
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 877ce58c0a70..93534a6e14b7 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -462,7 +462,7 @@ static const struct target_core_fabric_ops xcopy_pt_tfo = {
 
 int target_xcopy_setup_pt(void)
 {
-	xcopy_wq = alloc_workqueue("xcopy_wq", WQ_MEM_RECLAIM, 0);
+	xcopy_wq = alloc_workqueue("xcopy_wq", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!xcopy_wq) {
 		pr_err("Unable to allocate xcopy_wq\n");
 		return -ENOMEM;
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 639fc358ed0f..f686d95d3273 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -250,7 +250,7 @@ static struct se_portal_group *ft_add_tpg(struct se_wwn *wwn, const char *name)
 	tpg->lport_wwn = ft_wwn;
 	INIT_LIST_HEAD(&tpg->lun_list);
 
-	wq = alloc_workqueue("tcm_fc", 0, 1);
+	wq = alloc_workqueue("tcm_fc", WQ_PERCPU, 1);
 	if (!wq) {
 		kfree(tpg);
 		return NULL;
-- 
2.51.1

