Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CBB14F112
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 11:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762254504; cv=none; b=Q2018ZsSSlNPJNaR9JPqQPzadWiOkqsHjhaiMgMPiFfKmHfMfTU4lo1APRViskzPlSHKnMeLWjYKyx7A7t/EPpwapI2Wtf9XVdvWCQ3W0rY9+7MhwHs1SSSPF2RdeZmLvGCOfrAECeNMo3YEOzFAPnFyHEmj+wuuYIHzOy7utTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762254504; c=relaxed/simple;
	bh=WQ/ohDia7uzWf+QTovyDFaXkQtp6pvGqaaFaRGl927Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iu5pgMKvtEOsmd4EFhkPVVZkHOXr53nGbd2IGnHR02djpHbLrPxYd0eax14RKWHH5iUtvuBEznHC0ZKWAGvu36jF14CkIyxp1zROnpvo7IO6dYM0h3GwBZ3HsViy3i5zTnyvJCwc+leRBYjnzONNvRehQfraFEfylyOhYqlAD0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AO9Lghqq; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AO9Lghqq"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b7042e50899so941295466b.0
        for <linux-scsi@vger.kernel.org>; Tue, 04 Nov 2025 03:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762254501; x=1762859301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ffwBII/8UKbjUAsU6g4VA0sKiKJx/b1RbgapN8DJwps=;
        b=AO9Lghqqqr7EHG3Zj8HrzMVidUzoXNWzw+visfpyluiaIvLNPdzej6EG4OJN1n9gxY
         hNo+3lzDiv5SHBjkEyAJ+wEZRHEk2zte5mzsgrilYvVseXdTMMw+bt+6yuCFFiGzyhvh
         7aD+oIPCoOaLTtYwJ3hiJ6ZNGN879ckhoKNBJFX4Z8TUjpMBXMg3Fp7mrwJHjAoI6QBS
         9itqI6ZyiSN0sl5Aq54CQyiMIqQsUt9uPV2jaLw2sJiEed+4dDi27kH875gtDkbb2b9X
         820KzOznCJtVbb5ctXQhcpsJmwd9qEHNJKIsFsnu41zZ4xEIHqF9If0NXlt8G+e50QoH
         OkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762254501; x=1762859301;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ffwBII/8UKbjUAsU6g4VA0sKiKJx/b1RbgapN8DJwps=;
        b=lRi1F5wYWBW+UowVsPs/8/jElufn9f5kjybP2PIgEkU+yEJP1rrGblQv185DzWKlsl
         y9BZsVW8601s4DhanIc+pbq3S/UTfQpyUIP7vp7KcXqwCm4vhvWdFQUFyFaw5CHjIder
         hCmERtCeGFgILR5Xl9qKNt/tKJZ8cadG+gvzMKDtBh4R5l3E66oieNRoupjClDjRsXWe
         NJimNvN8l+i7e6GauMRo14iDoX9/WazUVMG7r25PvwMFxLvD++2JbUHpukW1JJ3/BaXx
         GuU6+TYpCY06KU62X7/EwPZ2NcewvZz2iy+/Xm5sOuCx6v2pExHAFKeYrQg4JvUmdtLK
         VcaA==
X-Forwarded-Encrypted: i=1; AJvYcCW9qYWL48eUmBdXs7Mgbgp6+Tmuub14Ryzqn25UZWTAdUmmp0TNJ9LJcbnDV64iu6CQM2be7/3C5wGC@vger.kernel.org
X-Gm-Message-State: AOJu0YzEyEDAagdFDiGiOiiYunF0Z+Bmd+KfgVwVmQe2ybRQolphzS36
	QDeM2UgRtkfF/x12EbQGQJPF6efaSlQK9uPkV2NTFBFG0m4sknwg82KttQbYe6IsdzA=
X-Gm-Gg: ASbGncuIEn3f67+4vA1vy0e8jMbDwlEDxZnmn3/G2bCJqL9O76QJDuP+2BI30Z54c57
	sEYUBiR4RltuBx41xAFnpWo8I7+MR8dkl9gc7ORKS4YKSKskOvD9Er4mzs72QbXx2eOXk/GjI1M
	SBZdB4ez/4wEp2McNQmbWHxbg6PRZuOoct6CrI1GAxVXmGMxObNiYB9cHzt6uWTnIgdojvbiNWt
	LNyaI2ilcuzwfyXbCDtzciXjHu2TlsZC6bsFmnBlxmFsneheRkRTmihQRIe8AsDXPgBP3JGpPAr
	2fVAiyT/HgDc6YpgoM+i8DJ/V1KjzJPabgNutPXU/k/cKhjZZLBCOncoCEugRT2eLC1kFlpp1Wc
	7FBvKLZ9wSYLdYVMMwHmjKCc2w63OZCmjVJwLLkEfLC/S7DWiviFJesMvor5zvbxwcCTjNapZZc
	MKVa4=
X-Google-Smtp-Source: AGHT+IF5qrlPWCkuEzv3QTctjZLDhOiaF5uRDaxLj/l/ay6tSejPh79HWrKLIT/9StR2Q5AWaBBgAA==
X-Received: by 2002:a17:907:7f94:b0:b70:e15b:286a with SMTP id a640c23a62f3a-b70e15b2d72mr680407066b.57.1762254500568;
        Tue, 04 Nov 2025 03:08:20 -0800 (PST)
Received: from linux ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723fe38a4esm178899366b.62.2025.11.04.03.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 03:08:20 -0800 (PST)
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
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>
Subject: [PATCH] scsi: lpfc: WQ_PERCPU added to alloc_workqueue users
Date: Tue,  4 Nov 2025 12:08:08 +0100
Message-ID: <20251104110808.123424-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.1
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

This patch continues the effort to refactor worqueue APIs, which has begun
with the change introducing new workqueues and a new alloc_workqueue flag:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f206267d9ecd..45d43e9c5827 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7950,7 +7950,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	/* Allocate all driver workqueues here */
 
 	/* The lpfc_wq workqueue for deferred irq use */
-	phba->wq = alloc_workqueue("lpfc_wq", WQ_MEM_RECLAIM, 0);
+	phba->wq = alloc_workqueue("lpfc_wq", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!phba->wq)
 		return -ENOMEM;
 
-- 
2.51.1

