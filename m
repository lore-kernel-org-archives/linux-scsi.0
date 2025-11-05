Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49DE30EF6D
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 15:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762355027; cv=none; b=ic5yXh0u7Jyk+qH83dpS6AUGEziGeZZKvO0rUqvcKPqeWQs3PKglc45q/ufHtxB3UY3V7vWRAjiFIpNUP2yNBxj0q0joEg9xRnyrNQuwFQuVjy4DFrAkZg9Ewe3l3oU7LUMhuOTfmtXQnWcLtj5RNES5VdFiAW8nG+x6FLjonp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762355027; c=relaxed/simple;
	bh=HFGpbq6AGnpQDHs3RJgDweKupuWTaBcUzSm+7AIU1rM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZAtwsTw8SRYZRju14yDEysEzHyntTv5MO8feX6unVjkR8kR5X3yMG56+VVjATlxf10ppPAbZsSr9IIvn6AOu7xo2ymYMTm2BF8qurfaTpxMPzwypmANhM230B+aFy0fFxZJry5Sn7Q/GqajJlUHWKyxGbUaAgywEzB5qoJkriKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aQOEbkCZ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aQOEbkCZ"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477605dc769so3377915e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Nov 2025 07:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762355024; x=1762959824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/fCx1hZSgC1hl4Am8i+o/TTbFE77gj5sFZ6mozJ1t3M=;
        b=aQOEbkCZcY2skNtBeSKjWcsTsjGSBYFLmAfVJsJP1ExeIriAyNaUiCLt9gV/1zqiA7
         gXcs+LN5SCE8zocM0Q8nlGMAuqLejZLKpOIlO5wUYxFL653/nlrBzNjkyd5etUSJsCcx
         7NKDWHFyR9b+DO/V3nF8V+XfyseNQZGfUPh3yVrPXnOS1GtN6Q9TYph6sizCOLEaKgt1
         VDpml2ytZlvclRi4E1LUuj0Z/JanfnxPMUd7tvHsA4PfEqXAttj7ak3nleBHsEEmSr7L
         /Eoj/LPwH3xm6s462gBN9NFxKI3AMAwUZqfU047FODj6oTTsHefzxYh5+PAntnvt2t/a
         b+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762355024; x=1762959824;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/fCx1hZSgC1hl4Am8i+o/TTbFE77gj5sFZ6mozJ1t3M=;
        b=FjmHLlzL5Zx/r2WNbUcYv0gTmHXNQ4A2NAp2O4/E4CFr4QrjbcXKSLzhqyjuuDQDMO
         UKuXp4nScCSedkYPKYALDHnll2y+CbiAfRoNjepBycQnhea9gUhrnav5AcnXTGJnxh6b
         MfpIMAxpFyrEwGFGLPGWOT7SgabUpEwG9z6WXS9khZSjFSOa4PCoRVnF4C+jc6mdm+nZ
         KcqZEspOB5dQ8n4q7RRD83wHXM53Kyz2emGqQ3iGj2f7xn+rRYC3yoaBS2o5xghCwywY
         +47EU8/JAfQtoehUPAYaZPbax5kxy+Lh+im2oq3rPXcfSCQKb1t9U7VFBYt6hSov71nL
         dHvg==
X-Forwarded-Encrypted: i=1; AJvYcCUz+g3H54VqUWpFavtPosj5uSSTcyeSYukHx7ruay/EzkO6KaNaO0ZSgWeb6oqMPpJs2tGatW9q3PLc@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/qYlYnWd+oh/Z9yN5azdpQ9nfL+kBPyWbpp6JpWU0NZuNJG8s
	dmBuWGr4CyK+G2cSun4FgIqI0HvL+K1c9EV79V7skwzDkB1oS1uQbzVF5yBI5CW0lys=
X-Gm-Gg: ASbGncvv9GpSaQ8IqDiptJSSPPb4V3x+NlTYMSep9UbmOi9zoMHT14CExI3w4gejVp1
	kXrjqk20DIgSYMKdeS5BO7nBAsFoDOdQlzGT/9LTqvRraFSkukx4IHNgX9xJ+6j/xobW4BKbMD9
	EJpKDG8gnWhk8FrwaSsmS6HMGgQEQHT5K7p1b8o//FhMTU2WwBkHcSvnmBq0qh5AFAILIs0Qn/O
	zefmsMoMaWeZfgqc4nsz3n/Xrk+zPHC1Bk4h5Jq64wFwyMxJJaKy52PaIN/VDVLuD4ennEp+Hkr
	4mhsCG2NUZcQ4Ay4zYREJPWvA4WAUHk1BDfP3Urx39K84V+RHcWphO/wlXJFriGQYVRTK8eZpBy
	kaPGz44SQZF+1NyQplSksQDm1jbgfc+m1uPtpEMf5qZoIXol3AEvsSCHaSVoF82cYgIkk35RepO
	+MEUtDIuO/E1IZANQuNOOR5ts=
X-Google-Smtp-Source: AGHT+IFmA0c4Wtd407mbM3RJEVqW2wIems/Y5GIiyaQOas2YI7MfDjPyLQJRRLt+sr4PuRJzXADpNg==
X-Received: by 2002:a05:600c:3e85:b0:477:bb0:7528 with SMTP id 5b1f17b1804b1-4775cdf7506mr28946685e9.22.1762355022966;
        Wed, 05 Nov 2025 07:03:42 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1f9cdbsm11483290f8f.34.2025.11.05.07.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 07:03:42 -0800 (PST)
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
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: fcoe: add WQ_PERCPU to alloc_workqueue users
Date: Wed,  5 Nov 2025 16:03:36 +0100
Message-ID: <20251105150336.244079-1-marco.crivellari@suse.com>
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

This patch continues the effort to refactor worqueue APIs, which has begun
with the change introducing new workqueues and a new alloc_workqueue flag:

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
 drivers/scsi/fcoe/fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 4912087de10d..c8c5dfb3ba9a 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2438,7 +2438,7 @@ static int __init fcoe_init(void)
 	unsigned int cpu;
 	int rc = 0;
 
-	fcoe_wq = alloc_workqueue("fcoe", 0, 0);
+	fcoe_wq = alloc_workqueue("fcoe", WQ_PERCPU, 0);
 	if (!fcoe_wq)
 		return -ENOMEM;
 
-- 
2.51.1

