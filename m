Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B79940627E
	for <linux-scsi@vger.kernel.org>; Thu,  7 May 2026 14:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778164461; cv=none; b=Y8mb/GWQhph/yhOdhH5OO/7wjnDBIGkT1frCkqMSFqhdNkAcmaQlTdnRidwCQ78/f/wlm2Hoy2IpFPxopah/SQXSv1yNYLqBIVzJW6kPT5O05XCnSPh/EuIBDo8NrGpM3iipAwY9/4JGMsI/J5/gMaF5Z+tKnTcPZnTHwmGitf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778164461; c=relaxed/simple;
	bh=VQ/Saokh+qNsqoGUrQeMP/hADrgCvykOhkDbj/dG1B8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RSPfqsY8Am/G8eEiiu7pFvuqHJJU4xRSzxoarbXYzs7GZhUcO/MXFHUPVh6lIvuzqg6CPLJABdQF86E7uI9B2XtSOyBAhZjlw6WvqBXVDW/0gjvdTxhHG5x8xBe4yll+bWWBGEIZ7JmnIJoyMy+8XoTEVAYP3pYzcSHVkjn841c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JW9o4x60; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JW9o4x60"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4526a8170ceso548641f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 May 2026 07:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778164458; x=1778769258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s3j1nccFhQvm0JUf5yUCCDfxuxwWOSInGRVCG3JqpcM=;
        b=JW9o4x60gxYnyI0GgqKIjGklyqJ0i4RoDo21G8tn6iCvv5/krD92bLSg9EvdDnVnTL
         UwVCaBNzaN3ochPW6ySwvrqsTCOsfYS1RwWHGsCANkGmXHs1c4bBX8B+y33f/PqyJoKm
         1IocjAUxJnw1QE+TZQf/BCJMHuduuhXeIbHWdErU0TZrLbd4z747omtGaksRPAKyvz1H
         OvavtAfu55S81wmekIwvb9xsFi78CYjLwkKSqp2eoZcRNNhgEHcPPmK8/8TUZZlTjBsY
         LGfzgGglsYs/Y3KhahsfT+ZgOfvsxsoCA4pLX2Uwdnd/cty2DnTZdCytnSfcsmQ1iVUy
         DoLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778164458; x=1778769258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s3j1nccFhQvm0JUf5yUCCDfxuxwWOSInGRVCG3JqpcM=;
        b=lNJ5xgTHNN98PyoMAYsRDrm1Pp/k//+Xip3IbRKcynNicdI1kcq7/ds7HPvL46Fm9x
         RuX2yl9xkFm3O5+qwlFoo6uVJF1/3qDNZlRlGFqpTZGJr3QdO1UCPLuBeMTRysZcE48d
         64VkNoNoqleEmPCl0RWoIVKS3fAHSalXvOAPuqSU3HRUchfYTcU+9o9zoseGnsMX7eT9
         uKjeplXX/9YwiUsF/bvfkZTFvgBYl9aeBdXavQU8Q4/w3VhsAFSENI0ahPJj33+NKCii
         6W0UakvV+lWb2zmo1B+pHPT0fXEjzmp4zVPUFqKk4USSKCEl5a694o3azyUACjrlL7WV
         RmYA==
X-Forwarded-Encrypted: i=1; AFNElJ8dMBfkt+QCKQDauf7+fT/8egFpNAqwaRO9PNUnibaz0ulmxzZrcGpIC0hbcEHsDhKKuj0CgD+Amc0M@vger.kernel.org
X-Gm-Message-State: AOJu0Ywvhmcu37CO+JOjag26plDoHNl9qEFkjKX5r9foz16+c7OBlP6l
	Hq5tjZB+85UwsH8C1n0XwRaRar/Iqnd2wHgO3Bh57hqtl3WHtgY0nPz8qIGmap7kgLs=
X-Gm-Gg: AeBDievAUufMnkOH5E5op2z2BW/wmGiMwV/SOzur7zjAp8eYKGyc1DFda3rq3usqHrx
	fHe95ePfZ1nlR58zqjZkd9Lrb7EhZxY652VpemYX884oskue3DV75WYnkIh8EdLruA6yErCIH1f
	wagsK1pZMxi0UeRXoxCTRvcejlTBfOCWHrIatw3yPEusmKtr/61dh4wixHIPQe7fbW6ScumVtgo
	6gGxTe1O2ELV90Lt7y66bmphoOQBp+bZmBrNwsrm1ztiB/6M1pZm7jNcfZC8EeMlStp1FCrAi88
	j4JOTKWTdk9pLfjDP8k038AhdPEdA9tcfrp4bb4RBukjT1wMteGmbGAmFlJ1zSoh4oc7jmNMN9d
	DxonIjfPDfNK1kOHjvgGThcdy6aEUh2IJhghlb45/z6ny1L9QM7bgNG26z6KBUpAPXSOqDlP/oj
	109O3BhqcMTZPd1QnOchGO/RIa6k6ximKeNPcZU4yNWUpSlEn2yi/2OwUOqw==
X-Received: by 2002:a05:6000:200e:b0:43d:7946:bae5 with SMTP id ffacd0b85a97d-4515da96794mr13554195f8f.42.1778164457527;
        Thu, 07 May 2026 07:34:17 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45054b03df9sm20352362f8f.24.2026.05.07.07.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 07:34:17 -0700 (PDT)
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
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [RFC PATCH] scsi: scsi_transport_srp: Move long delayed work on system_dfl_long_wq
Date: Thu,  7 May 2026 16:34:10 +0200
Message-ID: <20260507143410.337267-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently the code enqueue work items using {queue|mod}_delayed_work(),
using system_long_wq. This workqueue should be used when long works are
expected and it is a per-cpu workqueue.

The function(s) end up calling __queue_delayed_work(), which set a global
timer that could fire anywhere, enqueuing the work where the timer fired.

Unbound works could benefit from scheduler task placement, to optimize
performance and power consumption. Long work shouldn't stick to a single
CPU.

Recently, a new unbound workqueue specific for long running work has
been added:

    c116737e972e ("workqueue: Add system_dfl_long_wq for long unbound works")

Since the workqueue work doesn't rely on per-cpu variables, there is no
obvious reason that justify the use of a per-cpu workqueue. So change
system_long_wq with system_dfl_long_wq so that the work may benefit from
scheduler task placement.

Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/scsi/scsi_transport_srp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index d71ab5fdb758..a61cbb079ab4 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -234,7 +234,7 @@ static ssize_t store_reconnect_delay(struct device *dev,
 
 	if (rport->reconnect_delay <= 0 && delay > 0 &&
 	    rport->state != SRP_RPORT_RUNNING) {
-		queue_delayed_work(system_long_wq, &rport->reconnect_work,
+		queue_delayed_work(system_dfl_long_wq, &rport->reconnect_work,
 				   delay * HZ);
 	} else if (delay <= 0) {
 		cancel_delayed_work(&rport->reconnect_work);
@@ -390,7 +390,7 @@ static void srp_reconnect_work(struct work_struct *work)
 		delay = rport->reconnect_delay *
 			clamp(rport->failed_reconnects - 10, 1, 100);
 		if (delay > 0)
-			queue_delayed_work(system_long_wq,
+			queue_delayed_work(system_dfl_long_wq,
 					   &rport->reconnect_work, delay * HZ);
 	}
 }
@@ -474,7 +474,7 @@ static void __srp_start_tl_fail_timers(struct srp_rport *rport)
 	if (rport->state == SRP_RPORT_LOST)
 		return;
 	if (delay > 0)
-		queue_delayed_work(system_long_wq, &rport->reconnect_work,
+		queue_delayed_work(system_dfl_long_wq, &rport->reconnect_work,
 				   1UL * delay * HZ);
 	if ((fast_io_fail_tmo >= 0 || dev_loss_tmo >= 0) &&
 	    srp_rport_set_state(rport, SRP_RPORT_BLOCKED) == 0) {
@@ -482,11 +482,11 @@ static void __srp_start_tl_fail_timers(struct srp_rport *rport)
 			 rport->state);
 		scsi_block_targets(shost, &shost->shost_gendev);
 		if (fast_io_fail_tmo >= 0)
-			queue_delayed_work(system_long_wq,
+			queue_delayed_work(system_dfl_long_wq,
 					   &rport->fast_io_fail_work,
 					   1UL * fast_io_fail_tmo * HZ);
 		if (dev_loss_tmo >= 0)
-			queue_delayed_work(system_long_wq,
+			queue_delayed_work(system_dfl_long_wq,
 					   &rport->dev_loss_work,
 					   1UL * dev_loss_tmo * HZ);
 	}
-- 
2.53.0

