Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B852431329D
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 09:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761904615; cv=none; b=FqHl76Y0GIlKECvGBAUsXre+dSlbnxkjZoTKsww7BF+1zI195RykA/zRran2fdZA1I2BHajgP/8GPaT0SP8jJ+/cZJFbRLfxOS1y7yzjou3cP4kK46l+Z3/5rUTiTiWMH69/Bh+Xko9QiPwRYBjrEGDYs/WJ/Ynk0PsV/cwKu+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761904615; c=relaxed/simple;
	bh=zSU4HFRWc5yjlOePtP3l5a54RXFYN+qEWiVewuQaZ1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aYZ/JCpC8AelcYiGrB/Rb9edh0qPzWSZxyUw6II+SJ0NUo3IQaLJMRl3DqMrbwAk0fQAegndJUajx5b7XgVCIGxkLv7uT1W/Xuu4o4dSCtbvFoE4HwIVmBMU+vx4JWh/gSDP/6BfGWegXB2KH9fV7e2LaOVCtnwiFPI7LlAbiuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JY+Vr18g; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JY+Vr18g"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-475db4ad7e4so7824335e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 02:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761904612; x=1762509412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MmAkRDH072pmMAt8C09hH0SSMKdgHgvAXQzj/nVWYGI=;
        b=JY+Vr18gVLBvYvDUnb8cOAGRJpv4kqAUtVSoRfrUS7PfSC+8wLZu1BxQCpzLiyjzxg
         kCMaWdJmFNSa7xDeBLTgRw4HyAxLoU46MTYpvXP3cBIWpYaoi9QP1IjCTg2tDOXs9sSK
         zOld/rzmRdutPIxjMyofZpzBbUYSnPlsKJiitgqOQlpaQ8S9HjQh4akEi+oOHQvHwtAS
         1YgSKOYfjtn9EvXDX3eQ3DiOnMx6yMc3Qg2Nv/QPBtWYAuhPJ74vCd3E1D1E3DT1BsBi
         a2JabnGoKIwHkqfMHAbD0iNOaDlgpIdsU6YIcVjHmv8SfcsmoqYRsfOh9iaIfL2Eozfk
         Xtbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761904612; x=1762509412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MmAkRDH072pmMAt8C09hH0SSMKdgHgvAXQzj/nVWYGI=;
        b=v7T8l2l2RWZVL7v1v+vlYL5b9K/9L9YsRL8kJJB8wC9e18GGUH5fsr5UJXE4yOwoCB
         wHU8dYC5pCIJ8WyWkO2SQadLIFDJYEjZkwMnADct0ptTcSX5jFe+OmRxjVBSH0N5T/Zh
         bQH1d8V9wjg3kr7HFT7B3tKf7jFGS1Tt7Pq3FXwfDCtHAspPvs/ObBUqFsGJv6lNNmAH
         MKoR9+VJ84PMOzouIhauxXXhcSI6/5mn6BHFO9AJRgdYpfqDLskobRiEa79+nCHms1bo
         8GCYRKyqOMi0JQKi6Zl7Jkfp/hYs8GhcG+n0GumV6nXX4W+0aO30zSYtNmS+8omZIqBu
         lsKw==
X-Forwarded-Encrypted: i=1; AJvYcCWHirCz17Gm9ahgCnc7qTs/oN5fdTixAErpdV2vseOGIpH1p/tKK8YEHA+rAryh1OPTrOsxq8iBoQaX@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5j7bdbxeV4KLPGBXUjUI+GK4oTy4zdV407xbY6IhmOB/eIw3i
	o+HsBLBPkU6fxGMlZJTHdXV1sci9dZmtIK38+tof1mxCETg+1kw2qNPx3XdyyDrTsOI=
X-Gm-Gg: ASbGncsM7dN8eWelZtxX/zR3HqMJ8TAQaGnk7Li1PR8oaossGZaz99oZAqR0xmpA4ZI
	J1NXvgm0TNynBH7ncYiSDlRMjebXGnEnPc1X03jf3Tn2W2M/KnB/oyYOdAGDCOu1RNiBgnNTeMi
	DffS3iNZ9FwnqJNopOz5EP7pzOP5c7vmtdx57EW8EdqLiE4i7bxFM4wzoCY1hcyKHCIkAkdLUyC
	bPicssIh42nwfZVMprUb8QRJ9Fei6aGy6vVEpkAStepkSPfBhGWx5iCRhJJRxArO3uioUVwT7la
	TS+SsCu7F9g+uOO/PDbd8pO721AWy91/aGkQBFfiEByKsG5Y2NayH2bi2qlRbJSCt/pIQMWJlcK
	fO0llK/lV+0FkfZMMlg6cJFLKENsai+aie9j5MKFgdEzqB3dh8IVpsM8gu4tc+We6f9InLMgELX
	bKTbHaGY7s+Z3raawRAB5vqDcw
X-Google-Smtp-Source: AGHT+IEWdBLW+xRIf/F2cVKkNcU7C9/5C1kAno6QiP2mfQjJ5dJJs+H0nq1O8xvzmqMM+7ltKU/mvg==
X-Received: by 2002:a05:600d:8312:b0:477:326c:b32f with SMTP id 5b1f17b1804b1-477326cb6ebmr10175535e9.11.1761904612013;
        Fri, 31 Oct 2025 02:56:52 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772899fdfbsm81572335e9.4.2025.10.31.02.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 02:56:51 -0700 (PDT)
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
Subject: [PATCH 2/4] scsi: qla2xxx: WQ_PERCPU added to alloc_workqueue users
Date: Fri, 31 Oct 2025 10:56:41 +0100
Message-ID: <20251031095643.74246-3-marco.crivellari@suse.com>
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
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d48d8671c18a..af51f1cf5daa 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3397,7 +3397,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    "req->req_q_in=%p req->req_q_out=%p rsp->rsp_q_in=%p rsp->rsp_q_out=%p.\n",
 	    req->req_q_in, req->req_q_out, rsp->rsp_q_in, rsp->rsp_q_out);
 
-	ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 0);
+	ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (unlikely(!ha->wq)) {
 		ret = -ENOMEM;
 		goto probe_failed;
-- 
2.51.0

