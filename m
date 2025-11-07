Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E702E3365
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762526999; cv=none; b=N16no1P2APHJdYFyMuEc+by9CNkffewk6Hv9VRNc34CvfUrd3+VZEXFNogaYgmefrQWbBh5DZdN8BswOW3I8xMPHLTJi5q7kWMh8aF/hUWLAXHatU5CwOWMYMy3w2sr5x+kpK89CvWDqm6PplkOxljhMQFGU2AvevxqKt6eDjmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762526999; c=relaxed/simple;
	bh=R60yq7Ux8MdCyprKEUeQRHdxJELJGDKQUJfcKlvoUpE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dh31kZoaO3+HVpoYVvS67LwIFjpzdxKx2y+IyFPZNYncrq49J0u1Mk5CZUPp+w00IYDSRXwBeNYjd9R1itvd+WoRlaglMFxPJFVdGL45gXYqs7qs6sKNxRBcAmGMIkP0CxpfuvyrvyzeetMkU8eOgyxosfmdkuo4g9al6Eb2z4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EKRmAVI3; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EKRmAVI3"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-426f1574a14so520631f8f.3
        for <linux-scsi@vger.kernel.org>; Fri, 07 Nov 2025 06:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762526996; x=1763131796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=STau6u9jhqCOInN1U4SWuQ4ezXT3yovDegIpSsm7oMk=;
        b=EKRmAVI300UCslyaTfmrYpg4l9yx7ZFm0hPw9x+gnHL5Loumw42JHJ8Ff4dJnBBq/V
         dWM9u0rw24F5j2srVuSIOrzIaXF7OoUYnO6WfJ67zD6deHgb2cpSw0cnrhqWbsidT72A
         OyP9Wuv/Feens8vbLqmbt/r6LgJNpZj35uFyotHSJ0yY8wg8iS9o3bJL7txSRVGx2ymq
         LzIKRBq+1wV/c3mQknyNkf0BHXAxZMe4hEp0CDuPQHE/fRfnATxQiMZHg2AAbegobg/o
         JqZVvpooum7QCk29sgiZMcqPBqPm289ZY+7RAobB1PNPM3Jak6IP97GecTBPRjWGIEZi
         kZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762526996; x=1763131796;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=STau6u9jhqCOInN1U4SWuQ4ezXT3yovDegIpSsm7oMk=;
        b=hPia8TZCj8pjUa0NGFo76rHmg+Y9aT6K5cloOcXfExZ0aLIfIzunSb7TSQgGfDwBo+
         KnmbbycrAwvFrm8jUQZy0YZyRuoQrIW3WN8Q3rM33Fq2lxe2SNxwVJYHKEokG/kOCNWt
         PZquvLnrQs8ry2QPXLZj0AUkxACmUlwpBiIjwkB7+0SasDouJHwpv9up9UiXJE0D4SnO
         JSe7vIcwIBLJGx8OFz5BJhB/Rx7P9qRt3PFByJ3Hfrt7qIXeaFl/PB0b4Supx72smyQi
         1L/76WhdMvaZQdKYAmze8PCKpmAUXunWVQ55LjjI0xXATrPN+My4DP72Br/Tp48LbYRj
         WvDA==
X-Forwarded-Encrypted: i=1; AJvYcCWPv8ym8k6yDODQTeLe7GecSbgYw/ob9p8VR5H+3lHWEq7Qg3SPWUJUOwKjjpnvOz2Xf+7AJ1WBvbgW@vger.kernel.org
X-Gm-Message-State: AOJu0YwX/3Wu/oz5BnWZn+P3vz5loSa+DtQyHmV9wC8l1hZfBgQqPj2i
	Im8MZ5mtbFexcr4BZR/UbjzswXhj0BszXOq0x4dbp+N829skFWRW8ryjXFhIga2kk7I=
X-Gm-Gg: ASbGnculJQbYZ7p4zMQ9o8pjPr7Sa+GtS9admeuu0oziqPJH+yIJdSvFh/w8NFn9LQl
	J1wEmgpdyKg32B6eikoOGphO2MswlEOEgWSy4xnSOv36OaYDuwQrNHTJboTcLSWDu7/e044n9KX
	2gq9fkeZffELxILQGDD3t/wj2yvhY/Wo1OPkWVGDB2pFwSllgd7i/E9N7O3lGLAtaVNpBwHAxDy
	hjToYsX7plzWss68B9VesrPgt6u/ghkQX+67LBRYNcFyp6XG9OBNNclTe6nFCNh4Rn5rDqTZrVY
	7J7UYKNQRxGtGraz8nvtiQlkoCeaPPu25QjW0eoVSkwTYnslphxRnbs3do+vtGH1QIm/nDoOxGU
	Y+Ve9FuGJWFcCJRqgO5Gd5/iH5xUS0Zeh+UdGFI64kqslidNM34PASKZQFxp3hoATGTCJxDXJgO
	uxWfgEJiQsl0YeDKPe+yyws1Qb7cL8oyL059Y=
X-Google-Smtp-Source: AGHT+IEudGEjMGz1QHC0rwY4GHFl1js5BdpSiSYknPZ2gBXKgm3ef5ITc3fXWAnE21HztbZ0TqzA+Q==
X-Received: by 2002:a05:6000:430d:b0:429:ca7f:8d73 with SMTP id ffacd0b85a97d-42adce35cbamr3105947f8f.26.1762526995617;
        Fri, 07 Nov 2025 06:49:55 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42abe63e131sm5901584f8f.20.2025.11.07.06.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 06:49:55 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: be2iscsi: add WQ_PERCPU to alloc_workqueue users
Date: Fri,  7 Nov 2025 15:49:49 +0100
Message-ID: <20251107144949.256894-1-marco.crivellari@suse.com>
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
 drivers/scsi/be2iscsi/be_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index dc88bc46dcc0..a0e794ffc980 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5633,7 +5633,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 
 	phba->ctrl.mcc_alloc_index = phba->ctrl.mcc_free_index = 0;
 
-	phba->wq = alloc_workqueue("beiscsi_%02x_wq", WQ_MEM_RECLAIM, 1,
+	phba->wq = alloc_workqueue("beiscsi_%02x_wq",
+				   WQ_MEM_RECLAIM | WQ_PERCPU, 1,
 				   phba->shost->host_no);
 	if (!phba->wq) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-- 
2.51.1

