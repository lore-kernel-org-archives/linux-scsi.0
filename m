Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0400532B98B
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 15:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762527730; cv=none; b=aHXYDsZmFShisl1E4AWmV/k0Is20KQx48eFxJYy/b/fwKpyACMIReyM5aahyrkN8iWs3ceuVVCuN3rd0y9NfirDzKMBGOCAe7Ye3Osnn79iiYZEKCUXdBmUrKcnZwz53RlEF98wrFIfq+QKl2rDspw58MVDApkQMaV6+HrjlLdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762527730; c=relaxed/simple;
	bh=/MyQgTeg/kRKghyemlvvfpC1rLwcUH1vky5ONwwjHpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sra98PIp/sWviW1xxzViBHpRtqjD8VNP+/WBY9s2olkpmsuEhMAvIzlUk6gR4+pSEBdAhzgd/Q0oB/zppMG3LNWLfB7hnbfDCsZVDNSrZNABljW9NEW086IgUu1RepnkfpuMmyAR+/hF7eWeNg/6zYIXcYeeZuWjQxr9srynsA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SjTBB9p3; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SjTBB9p3"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4775ae5684fso4595845e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 07 Nov 2025 07:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762527726; x=1763132526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vyt/356haOFVo0WC/XQ0zOlNsdbCiUi9taT5WCt+m6s=;
        b=SjTBB9p3ApA94Ogdsmtjr6vhVgoTneODzXq7zF+3A6kts6/LoX8ICZOxq/puzgelO8
         REboWuZ6JzCeGUn/HwvYPcNcTvrXjSC5smKWE2cdw7HfqujJPmIMOz288c53uBOXSYKh
         CHGQNfk3JvdWRohJ029SIKihy57tnTreYg07bZ2M/Q0qlBW015wC/Abzv0l3VVzsx3iM
         RgWxChTkxqKCLg6nc8qii7eqLIKLTB7p2Xf60xpbeaU6Q1zAw0FDI5kMXj8hxNkprt0u
         daDO1qMyjElSMoFB9KbdfJA92LRwF/aqyGhMnzTXt0Z4F8wjgd3bMy/HnkjQDXgMgCvh
         RYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762527726; x=1763132526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vyt/356haOFVo0WC/XQ0zOlNsdbCiUi9taT5WCt+m6s=;
        b=Ax3djBs84lVSzgqYia5iJg4xRdrAZvnXNvecQwSCFd+rIAU4qvnSYCCvFTTxjCKa0A
         P2z4Dx8cK206S6eWc9svN3nDVzuzhGTD9aj5dU7BSqghoT3JWaBFNE99av9O9rfGC0t2
         LqpAbbg4hvdo8475JlWbNPLVIrx/XWvPafBubEATnbL6cQfehuj9i6V4I3j8BMBsIKfa
         XYvUxKHEs16VFNo9/4VZ2Ru/ROWeIXeLXzHBIHgJYolXLwhGnRxsPOvrQB08IWrJRF+n
         SfU+HG8FV+u3tdV7KR7dVWoDSbPLOnzXlrPyw6jaqb+xB2fYb5AUu5qDfxEiKQgw9rpt
         LO8A==
X-Forwarded-Encrypted: i=1; AJvYcCVh+usBnLr7bBxcwNP6fDcvN3pusxFMET5EjBLmuIJ2uYKVaomvgS/TJ4kc79BpAOSJQStIaLLDF0VI@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6BwOgTp+8nBC/ZvAgVxWL5iEhLr1sw3jiN3hZx8m/GknjJ8pf
	FzrcDFZRuUtJXVf/JG2b2vnxGlFXK75pqoK80+2nSMJ94/zGWFpg7FZimV8MKd3Rc8qTSl8E629
	QLFut
X-Gm-Gg: ASbGncsecLsi5LrwxuXWEgWtPIHpIKbKwxNXrQ/q5pGB08c+o9QEeO514qjQFpBJ61e
	VPnqIqSLBLkzmyYMPI72NbgeFwFTEqequ5UtpsJr7s4vXjbv0h/UKa2JSMFQTLTrY+Y9M2Y0iyX
	oZtmC9EtYw6aPdnVKUx2wrMoDA21UM87WjGyDGrqLXZV9gDYTD0f5YMBEukN/E5cqoNlKpUIUvF
	5e4ygiX8ICzFRdg3YPCxnPSYbmoVX+9O/uuwcJcUlIAQG0BPYwmW3i8BbiUTIrJ7ykbMn0RmRCm
	VH1XQKEkl6BXihSarr7FaqmWcZeoTZMei8m7TapNySkre96jVBVnPz407XadEdaMkr14buuS4f8
	7Gz09xDVbeQKMCyXGh5tslliFqdCIs3bFtM/hnOnvyaZi61QaIpfkaTj+8PHz9uqrMo4uoDP26X
	fOdOC4GnRro8NTy7ZT1rU3Ai/1
X-Google-Smtp-Source: AGHT+IH5Ey9B0iwSNCwyc1V8tclibBQXC7NnuyOaWnZdTUkdNZ9mMv2vosr2W3a789JDeZcYYQKCgw==
X-Received: by 2002:a05:600c:5813:b0:477:5c45:8117 with SMTP id 5b1f17b1804b1-4776bcc98bbmr17320205e9.41.1762527724463;
        Fri, 07 Nov 2025 07:02:04 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675ca52sm5777830f8f.25.2025.11.07.07.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 07:02:03 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/2] scsi: bnx2fc: add WQ_PERCPU to alloc_workqueue users
Date: Fri,  7 Nov 2025 16:01:54 +0100
Message-ID: <20251107150155.267651-2-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251107150155.267651-1-marco.crivellari@suse.com>
References: <20251107150155.267651-1-marco.crivellari@suse.com>
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
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 58da993251e9..0f68739d380a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2695,7 +2695,7 @@ static int __init bnx2fc_mod_init(void)
 	if (rc)
 		goto detach_ft;
 
-	bnx2fc_wq = alloc_workqueue("bnx2fc", 0, 0);
+	bnx2fc_wq = alloc_workqueue("bnx2fc", WQ_PERCPU, 0);
 	if (!bnx2fc_wq) {
 		rc = -ENOMEM;
 		goto release_bt;
-- 
2.51.1

