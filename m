Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C55B333733
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 09:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761904616; cv=none; b=aFdaRCpfW9AxAKy/nU4PWlnJRkvdXNlFOhe+EGuHOXlbfPIdCE9TbRIH/S9sOWotwBFyG54EwANYKQvpZQHvB/tUE+6hk6RGHlOCr5Va3rHh5GNsAqRIu/RfNiH0ARcOXgb0FdMyT/Vqh6PIL71IA5SJqA4Tw16AMX/40zU0OU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761904616; c=relaxed/simple;
	bh=iLz+raYpmV/FRkHcddplK9Xz7NwdeSLevio/ryv7bAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ibdvDa7lMy4SuFKW3iunxAmBZAYSXtfp7lSvT2MaTNWqWrrAK8j/ZSpVmdLBuqqho2T+0gee902uoTNtZeLla9q60cwpVphplKcHdkjNFm+o/8MfxU+W7Ziiw181eZutJjEnX3j9V3gnMF3gMS4MfLJ/is8I+a9VNbEjlyBs4f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V3mRccOv; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V3mRccOv"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-471b80b994bso25497735e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 02:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761904613; x=1762509413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j12YdcbQpfT8Ri5Sjm8HpC33Bil9gxYaV08r43TG4D0=;
        b=V3mRccOv6aym7YTtt9V/2lNEh9Ff0n/0sZ46AecSX451etzHFGgbJDbBVBy2bPUw63
         ZpvLKIiRH11FnBwZxnfTkfzbKcxAROTqV3g+gRv8aC76P4FzoxcRAaOdLyjlh/akbwbq
         8TESX0sh8uN06bg3AY4gq2/qIfIZjki7twl4N3ik+S4SwBft8r4ywBFKvqn0jf9sQovc
         aIWGylbufp/pxoCjrmvtUwYbduZIsEdnRFcPDwm9Ebk1r0GXMtIRXTuSXc6mxm4UflSW
         j6tX0dwkQkl5t27NkaqdYBfO7CYTLuD3DRuxLQKx/PiASaFQBbNxyCJqTO7aE6Xr+Vqk
         Nwcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761904613; x=1762509413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j12YdcbQpfT8Ri5Sjm8HpC33Bil9gxYaV08r43TG4D0=;
        b=gCditfSvIlkiXQgC0iaVsxQ7s5ERbo34lkizXX0jN3UUmrUacHPxV1eOB2CPHY7DUM
         XLc5LbjmFAO45QhORRCdaeSxhrGUkDnHU66f3dQwEfiTPETfkxmvW9tkgOCcgOWxOMPC
         4kVHMq5MuN2F2Bi60BqOHRJosdH225j6KahDR+F7AoDAvXebbR8zmojU2vJ2mCMU4UbC
         mrq7ARuuxHqRX9A8LmQTfT9tPmwLTeKrld16sPY0jFD/GpuuNRwbgADmO4AmffJ5IK3d
         T3vNesLVEBHmQ7P66VX++y7NcicCKoSSuvAsjQrQhW31QdXQm3iNnJWNEnBAiW/8w/1Y
         2UwA==
X-Forwarded-Encrypted: i=1; AJvYcCXO2DsIMJK2yIImT+S0/7Kqo7r5h86T4CInO6Wbi3zxVvXEWhuJVBgYRQoI1Mqtfbwc8ROAz0VcA7M7@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz83HFI4esbGPLxXMSLCg+yBhE/V8Q6T4p/hR7eK1bKxPEAySD
	cV3cXMqdwNU66DRD5IiDWzRI/FFk55wjMaHLg39JsF4sQ7blje778EaPcNcKxTPNCxE=
X-Gm-Gg: ASbGncuA14+EXMWKJ67mELNXH5ij2vetnPVjZktwcqHQfsmjB7BW6pj7ApAx28SNT0n
	waC6eeaDpZphscUE25qQl5xDYmddSdAZx+2fT5VjzGyKLw6xA6xAHVx3N7I0wHWmhixt1ZwKi+6
	TaX6yOa9PA//hClVzTBfW6A3dbL+v7t8/+o9oveYfCHNcfzgt8B9+D3HjAxJEj4mcUPU0xgcMUe
	1PVSpEshQpxFzjbwXEVKdkUDnOw1kTdnXgO+Wv4dnn57Qtw65BidhTNXjAyqbCrVhR5vevZC4oP
	jUDVsNaaAow9ygETUxxgI8Q+jSbZtFlnWQ6W536CJE40cMrM81e/jFUdSvZ/zaygqpQSf8caBQc
	xCboiSv43NP21BaJvkFcz15BAViff5NlJAO4wU2biyK9xiUqw3eq6o+7OAFIiNJujSuy1Gt+9lM
	2+B7vr4goLhLk9FwKBqYLkGS8Y1iIlD7L3WCD/ogdjm/7h0w==
X-Google-Smtp-Source: AGHT+IHIxYUB7ucqmBG4m5QaDjIg9L1VP2kIebkbFH+exLigBCCQXvz5AOOKdVL9nqzemP99+DYyqA==
X-Received: by 2002:a05:600c:a010:b0:477:28c1:26ce with SMTP id 5b1f17b1804b1-47730794423mr28108185e9.7.1761904612811;
        Fri, 31 Oct 2025 02:56:52 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772899fdfbsm81572335e9.4.2025.10.31.02.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 02:56:52 -0700 (PDT)
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
Subject: [PATCH 3/4] scsi: scsi_dh_alua: WQ_PERCPU added to alloc_workqueue users
Date: Fri, 31 Oct 2025 10:56:42 +0100
Message-ID: <20251031095643.74246-4-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251031095643.74246-1-marco.crivellari@suse.com>
References: <20251031095643.74246-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistentcy cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

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
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 1bf5948d1188..6fd89ae33059 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1300,7 +1300,7 @@ static int __init alua_init(void)
 {
 	int r;
 
-	kaluad_wq = alloc_workqueue("kaluad", WQ_MEM_RECLAIM, 0);
+	kaluad_wq = alloc_workqueue("kaluad", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!kaluad_wq)
 		return -ENOMEM;
 
-- 
2.51.0

