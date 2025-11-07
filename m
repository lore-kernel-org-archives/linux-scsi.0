Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBF61A3164
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 15:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762528589; cv=none; b=HHLOTWQ5o+zTFSYLUEKwFosHgCxsSqeOLgcDTni/3Uh9c+mWdfes/M46faGm1nf2C7r31+j7ZP00OBbEBD1SeQ5hNMvbO6HCm4NiM8W8DDz6hH42wssN14FQp9u9GfxTdNAd+kL9hLo3lPj0MrCbnHCFhWhprv+u+n7V5OuNpts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762528589; c=relaxed/simple;
	bh=Q/6vxRricWDrRCUSl44BgJKITMGcBpXQaAm9tnUqR/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AIdbsIpOgDvh3ZWmC44eSjxMv/UaivgNi73TelezshO+LYgjjTnCvKFWPevD4tcRiSy9FpI2iI4memt5F8tO0ThJWglceLqlET8T5eOPyu2rNDwIMIfauW+HNc3Nl4R3tLk8+IznpS7MUkmz+kMo/bKzD5njLMNyJr9qME9Vo5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L4wF4tBe; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L4wF4tBe"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3ed20bdfdffso819506f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 07 Nov 2025 07:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762528586; x=1763133386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fcwFTq1/DogLswamjpDbcdEqXnwm4REhdjASNxEdBs8=;
        b=L4wF4tBesny1Tg31eUJYUEIjM2pDo6xT1Z9kmDx89CIRaHLFozx4wm3k4+UVLRjgcs
         SBNMwIhj1753vcP8COqkkE169oVf/CeilpfhOLYHbuwD7AMI0BQdEWaML77jU9EfplbT
         zcy9IAUBcma+VILQ1yZOv01xA/lNJxPevB7DyatiZQtnY5x70BFE7MGtEJspkW2JfY2s
         DCevp2JDSvIgpKLAsPByhjMN+InLYPujWt0eDHzREnX8C9wUKhvmUGoMw0PRj9qHt97V
         xg/zChqqriNqIp5B1QcyJpxICwUBAF0JqBxA6S53adcRr/+jBkmNBVssJiyAErZ8QbZ5
         Gu9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762528586; x=1763133386;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fcwFTq1/DogLswamjpDbcdEqXnwm4REhdjASNxEdBs8=;
        b=GPnYjw+DbAwOXIsLjvPvKOW9gaUAioyySXOsoYWgNQdRhl7e8T4XEjZbClqKSCcQlH
         4APv4eOBmmN2/SOTOtaqoWXoJyOiPtf5tSBb73LHayqmJdD2Rts3VpR64+hEU9X0llOP
         pHfiSy6czjXQu0F4llUkM/5GYepp7EsRvW4cgnNyAYG+ejMs5DqJXERT0H9PqAcIqKef
         kWb+NmofnAwCyxVGZqp+cLycbVRrauoktixeMaIW69OfDaf2vWhw0Rp1vd0purRjzm02
         7OltbxEBytlj5mVSkVLtsmHhDDzF2m2ta8c01MQz3+cMi2PYD9qngb2IeLkAYSkog2mV
         4WuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXLP/TcbWDstgrnyGWyZu42ocOB1NrArLjdxh6HeOu7qtxy+NJjjUyJIuUWIRK4kgmFvvjQXx4fIM+@vger.kernel.org
X-Gm-Message-State: AOJu0YyoRSZXIEdnYTVec4PEJ+oBdzshAPznfwscd9QI+jAM7eS9WLyr
	nvkjw3zHhm3f12CACHw44wB9K67OPG6t9AkNx4KfzOAkvWJXG5ejcWNmRdwBsw7YAUs=
X-Gm-Gg: ASbGncv9+DoNTuaaj+p9RusNMvHk5JmcxzMvhgbvbZdqTzRjF/8alzDQj6gdCr8uyo7
	w4EtZNozNBlktv3fCDaS9AlAJRyRVGLCzTS6lX0jD1x/+q5ZXvoBPn/oia24R2VOnKBhYf2lu3X
	+OoQncH06B4id4sMN5Qwe5Dw5GMwaG4T+KuNPwOr7ArDg6nN9LtvLw2g+CadxfJAM0+m+alS7dx
	XXECF4/WuL+7QrtvNseHnsUbcS2t/Ien58BTRyuQhnE6ZuEFaAeHTYqs5jHfPCJtYN9/t2qpzqn
	w9Shxc+GiSmtK5UZwu0boHzXKL5Yr4VEtBV3isXpV/rOpM2OSV1w8hADeDGzdVLSAzVUcoAM/aa
	/VNzliB7B6dcXXUxn/SSpa/BoHyLAWAWa31jNE41oiSsImLDIc8xWWMBAOJpdwes2OpgsQlQwmk
	R/eHtEWIptYAExUITy7YSNteZH
X-Google-Smtp-Source: AGHT+IEb71e1N6JfIEUJiI9T+djX0T6M9NFuyXbFtIKtj2yXnBFzlQmVzBKFWvRjsc8GOuNvVFya4w==
X-Received: by 2002:a5d:5847:0:b0:429:bc56:cd37 with SMTP id ffacd0b85a97d-42adc68956bmr2219409f8f.6.1762528585653;
        Fri, 07 Nov 2025 07:16:25 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac6794f6esm6688333f8f.41.2025.11.07.07.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 07:16:25 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: qedi: add WQ_PERCPU to alloc_workqueue users
Date: Fri,  7 Nov 2025 16:16:18 +0100
Message-ID: <20251107151618.281250-1-marco.crivellari@suse.com>
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
 drivers/scsi/qedi/qedi_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index b168bb2178e9..56685ee22fdf 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2768,7 +2768,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 		}
 
 		qedi->offload_thread = alloc_workqueue("qedi_ofld%d",
-						       WQ_MEM_RECLAIM,
+						       WQ_MEM_RECLAIM | WQ_PERCPU,
 						       1, qedi->shost->host_no);
 		if (!qedi->offload_thread) {
 			QEDI_ERR(&qedi->dbg_ctx,
-- 
2.51.1

