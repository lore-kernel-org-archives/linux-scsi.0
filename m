Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78DF32ABE1
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 15:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762527729; cv=none; b=QbmzTseksGt5FRfvKyqYyqj94FZgjPp4I08GL2wCunaTzhj4sswWD1r61lc2+y5Ny4aG/D3VFTf4ujNRPtXDBqS+imgEh+BctRzA2TIqedPUdk/fqfHvO1w3QkJV20UJzYcGKQjRpMM5qsZlXZRUAXlSP0D2bKV+z3P1PkO9Sas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762527729; c=relaxed/simple;
	bh=neIM7QVQVzi+YLKvjx9mqdZ6zG6p4nF2fOHuVl49jL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lzoFV5X07R+PDuu3qdsK0zr0EiOWLaMc68hSDgvGKAMuU3GEcwJYfC7wZUhU6hzdtNr37511id7/XHLc5yAsDFzpQoFw8eklqvQsTj11VnRZG+NYEchrk5cO9y96SZlUq3jVWUaXb22bcIpd5GMsbKmDHu8Qhj3qyBWCG6YrrSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QAlQa3Z6; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QAlQa3Z6"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-471191ac79dso9508875e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 07 Nov 2025 07:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762527726; x=1763132526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O69j8p6POFkrpweTBOpwpVXxQ7WR8S2t/JBSoUi6DYU=;
        b=QAlQa3Z6xe/zc8yAFPJRLiNzwI4/aDxC4lqc4e+R+2EO/F7uawzAn+BmpXFFZ+wt5P
         YdEYHMEkeb/kZrsPrQbghJyTnyAq8DtIcw+muGs4DJkYz/tXOzdAXKSZjB1xN4D7DfLQ
         /J5PpM+1smoNAOueqh26io/+Im7Fjqkdtx4vRo4nkvrnui4jL7VeAjmpgRHQRZNU3x4b
         7lg1We606uAa00SWIFKRGO4SBTRCOiWBQnuoImRaJ4p2hbKuzpKWtfcMXQon4DAN8uov
         lFA7aZ6e6OYwfWmNqlt0POpLz0vkoCzn+jebOmvbrldiLscx2H8h/9K178ab2Psb0b7u
         cGtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762527726; x=1763132526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O69j8p6POFkrpweTBOpwpVXxQ7WR8S2t/JBSoUi6DYU=;
        b=NXFfUVDslVOFeZ6qqPb3SK3S9fNfdRfoT7iN98abwaIDN9vv83hg5D2Qg5WEulVAoG
         yjeF/g9VrEu00oXb/8oditBa8dNu8ZFexZ2rVT/u8ayAb8i0UE5DtI0j5dTJ6S6PEFvD
         wg1/nq+Nhkd7tPnSS9CEc4rpAaZl41XMbEhEe2+WM6M7/wo23fUQf3Fy8HjP7JwrHwPs
         CRqMrO4smbPlQtIafsnJ7Jd8R0iSVqcsMfM+WnxegZ509zEn+L8POCtRBANTclKJDKoz
         DkrAdVw+iLwRLNyJ+OAB/+aH8aqscBT+kjnbLTPb7H4OXTQAHV0DiCKtWfnd0Z3r7AZw
         nygQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKrO3VZGcUj4GvO5LKnn5E7HzAo3UhxP5X/E+ZHnTxF0GdhgGdIFbWjtKZm4XcCeav+cTc7zY9x7tc@vger.kernel.org
X-Gm-Message-State: AOJu0YxlyNGsMRfrwdC6UaYkWjzZfYoFxCfzfInFaY7nn+1jGlA3AHjD
	0V3FQK5YEWKNjX8CgCWbue7Bof02LAcFPOXv2nWpy7XyXEZd0ezQtCqwcuyhbaX1Esc=
X-Gm-Gg: ASbGncsr6gb3WqfeZQZE30XWyHwy2PdNaGkFYnYDFzRdXX15JMumuhe1gpILcPxqkpr
	6WLw1Nhedxvo/W4m7s/6kpvXRYJH3vRo0USLeb1p0ezbmuICgYRL5yemuYTXVZUML6Tu3hVpFVd
	B+RoGM3kziMpBrWzX2xE4V5K5rJthA/CzaM4ueSm+wHRboniu3W/Ha6kDSxSLnj6IHhhQ3xOoaW
	GTIFh0BMKu18m6Ei5cTG/MflprHFsJuiTqxtHNWhYTgcpI1JB7zqFvGCU1qitr7KVi3CvW0KHkU
	UeXFd25EOM/TRoxfn9cdb7G+9tKQDR+0r9O8aseSDFOtIT7b+vW36V3OuBsDgb5LuJO0Oelc0sa
	QQQLlVo121KTJ45Newe2J+V7kkejQU3cdZND8ufHL0+0nEUrrMTv6UXrM02Y/IavDqFTvFydZ+X
	x/oDx/OAeivdIJAYpj/2peINUS
X-Google-Smtp-Source: AGHT+IHjMq1QJ7HYQ/kS/Qhb3uXFesgKIN2s46CxCh7W140FLJQZ4eDZpV2W+DDmBxiZua0HLfkCFg==
X-Received: by 2002:a05:600c:4694:b0:471:13fa:1b84 with SMTP id 5b1f17b1804b1-4776bc959f6mr29006635e9.12.1762527725719;
        Fri, 07 Nov 2025 07:02:05 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675ca52sm5777830f8f.25.2025.11.07.07.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 07:02:05 -0800 (PST)
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
Subject: [PATCH 2/2] scsi: qedf: add WQ_PERCPU to alloc_workqueue users
Date: Fri,  7 Nov 2025 16:01:55 +0100
Message-ID: <20251107150155.267651-3-marco.crivellari@suse.com>
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
 drivers/scsi/qedf/qedf_main.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 6b1ebab36fa3..7792e00800ae 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3374,7 +3374,8 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_INFO, "qedf->io_mempool=%p.\n",
 	    qedf->io_mempool);
 
-	qedf->link_update_wq = alloc_workqueue("qedf_%u_link", WQ_MEM_RECLAIM,
+	qedf->link_update_wq = alloc_workqueue("qedf_%u_link",
+					       WQ_MEM_RECLAIM | WQ_PERCPU,
 					       1, qedf->lport->host->host_no);
 	INIT_DELAYED_WORK(&qedf->link_update, qedf_handle_link_update);
 	INIT_DELAYED_WORK(&qedf->link_recovery, qedf_link_recovery);
@@ -3585,7 +3586,8 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	ether_addr_copy(params.ll2_mac_address, qedf->mac);
 
 	/* Start LL2 processing thread */
-	qedf->ll2_recv_wq = alloc_workqueue("qedf_%d_ll2", WQ_MEM_RECLAIM, 1,
+	qedf->ll2_recv_wq = alloc_workqueue("qedf_%d_ll2",
+					    WQ_MEM_RECLAIM | WQ_PERCPU, 1,
 					    host->host_no);
 	if (!qedf->ll2_recv_wq) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to LL2 workqueue.\n");
@@ -3628,7 +3630,8 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	qedf->timer_work_queue = alloc_workqueue("qedf_%u_timer",
-				WQ_MEM_RECLAIM, 1, qedf->lport->host->host_no);
+				WQ_MEM_RECLAIM | WQ_PERCPU, 1,
+				qedf->lport->host->host_no);
 	if (!qedf->timer_work_queue) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to start timer "
 			  "workqueue.\n");
@@ -3641,7 +3644,8 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		sprintf(host_buf, "qedf_%u_dpc",
 		    qedf->lport->host->host_no);
 		qedf->dpc_wq =
-			alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, host_buf);
+			alloc_workqueue("%s", WQ_MEM_RECLAIM | WQ_PERCPU, 1,
+					host_buf);
 	}
 	INIT_DELAYED_WORK(&qedf->recovery_work, qedf_recovery_handler);
 
@@ -4177,7 +4181,8 @@ static int __init qedf_init(void)
 		goto err3;
 	}
 
-	qedf_io_wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, "qedf_io_wq");
+	qedf_io_wq = alloc_workqueue("%s", WQ_MEM_RECLAIM | WQ_PERCPU, 1,
+				     "qedf_io_wq");
 	if (!qedf_io_wq) {
 		QEDF_ERR(NULL, "Could not create qedf_io_wq.\n");
 		goto err4;
-- 
2.51.1

