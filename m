Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5610374A1B
	for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2026 10:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788864237; cv=none; b=jqA6B4yn4PMR41A3e8qDa6hezPF6N3YDQ5KLlg8428BXGqjL9K5n+wlXzWdQT6D1Xt9CBt9TheczJBCD6kX5PU/U6bXg54Rpplu4tGHL2IqbAlsjew7Vh/1O09Tl/50fGbp+zYqGeUB7qmC6AhGLlN1fqRtI9oz6q838THy/ZlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788864237; c=relaxed/simple;
	bh=wJF87hAqw1DfV/G2Y8256aPe3GJWUQeIGK+xITMgWVU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sppkbQ80hA428OWex/1RDn8eXYDuvEh9qzQITloD+t3Te+XMu6z+vQ7ZS27ia53yK/2jEYT8N9uenFJBw9eQjoI6EaekcJaaqAFCSofrQJTpVgtSHBNFkIqFHCrjZuH4Z/Jz2fR/xkUjLSItLsX5owZWe78aa8MyH1OzS8GLcaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YIT9i5/k; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YIT9i5/k"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-39682983a0fso4762278a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 08 Sep 2026 03:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788864235; x=1789469035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qCqQB19M3/bVXTywLYLz0qY+EnHLX+YyNCe+Rh8rNHM=;
        b=YIT9i5/kw5N5auLfv5NH0nf/MDl5T/DQ1ZBzuCJpf2bB7yImQBzh2v6Omb5Pjw0W5X
         bKTahI3dT6FuLd7XYXWOsrtAlJoJqL5CdiR319B+V7CLatq2+tU2B6b7YgykCpl45ogT
         Fw4ZYtkQ6wqqn2p4pVpuVe38DW7d7YpE0DD1NOYyounronK+XoajP5I42IM0q44grwH6
         kpmeGiaRylvu5himvEl2VIxx5OPC/CVD2hcfvuRxcPJHrmnZIoxYkpNjsdhK67T5xhxN
         j8l0UCKHLZHljeugKM5KCLZeMfVjtb2JvLXZ+YPJ4UAZLwek1/IRFHahcxciuvbjWDyr
         4eQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788864235; x=1789469035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qCqQB19M3/bVXTywLYLz0qY+EnHLX+YyNCe+Rh8rNHM=;
        b=QS80WcEV4tN7gvf/xN6S1Rba5paNyPmaxTf8m1ofgKVc/CX4l0zHv8QXNyKKjS5PKe
         ZONL4dIUu3o5wRXkO7j5tSz5WAM5b5RBD9K1bBrQzEGT4rz3ImzgOXdBeA1+8beJ7sr/
         WY8ETFnwyB/RkNF113KYvEMSICif/E6tYgvOI4OZlhx/iFhO8TjAmocRGhgxt0NMCInO
         qtnfBfdUTl9gJoPhmiV8KZNGtJVzTVqbQWSzBr037m79uB/SC/8rCnIq5Tmp22icfbB3
         mDfYfwUR6okaTmv8rnW2UXlQATWOe73YJksw1yBLsIrpTGE2rSGa9Xt1XbGASde+NQBb
         k/tg==
X-Gm-Message-State: AFuF++mBzzqpxoldhCU4/syjF7QIbnlWtOOHnhy4YGJ/T/cV33AK4b2a
	g6trhIprFwI0LxmmQrxA8rfKAcDo0UTugn350KIyKnfyX463hyuj0A4e
X-Gm-Gg: AYBFou04A1i71jeuZ2QEUE31iu2cAlX8urQda5Zsfe2BYewuXVQT/vmK7qasnlyENKF
	XNPQHX69TP+ecJQW2jwxbLUz6Vg/oP0oCa0eRBIzV9QDNey97RN2X5SRekXYIxQadid2z+bBgPt
	cCI6x4OCdJYc1NcoWLhYOyzbmyeDjPRwNNxXTg6KJBVomWRm8qYTohrxGehUuP5llB96hOgUpGx
	97QGvjAdigSTrhx++J0Kft4pPvbXZ4ik2+4XYJlwxTTyRmW3eCTfNlcanIeYj3awSPRpcU4M6YS
	tDafiVJ9Nne/Wq/yZ+Mq+G2Kva7+3NB0GuqT1cJfNMohOYV9WNGkxdAeDKv63Kh6v1GMi5N/pku
	fWrkY8sliaY7R56//+AJjgLdNNitPCs3J4TtFx0TSzbT8QfSvu/3czLS6f8d+K+GNwcKMbm9ps4
	CssJTX6ohJ5mg/EUFGAK90XFHNwwAA/md1YdMe+MpHAaBgAz2pLvcKoQEhYopWs7IrWTOP6QFPv
	oVF9yBcOHec
X-Received: by 2002:a17:90a:d646:b0:398:9bd5:490d with SMTP id 98e67ed59e1d1-39b26214798mr46686051a91.20.1788864234965;
        Tue, 08 Sep 2026 03:43:54 -0700 (PDT)
Received: from adminex-ThinkPad-E14-Gen-7.. ([14.97.7.198])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3396e7e477csm3595604eec.29.2026.09.08.03.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 03:43:54 -0700 (PDT)
From: Mahantesh <mahantesh9789@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mahantesh <mahantesh9789@gmail.com>
Subject: [PATCH] scsi: isci: Fix duplicate word in comment
Date: Tue,  8 Sep 2026 16:13:42 +0530
Message-ID: <20260908104342.30297-1-mahantesh9789@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the duplicate word "the" in a comment in task.c.

Signed-off-by: Mahantesh <mahantesh9789@gmail.com>
---
 drivers/scsi/isci/task.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 3a25b1a2c52d..aeb2cda92465 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -67,7 +67,7 @@
 /**
 * isci_task_refuse() - complete the request to the upper layer driver in
 *     the case where an I/O needs to be completed back in the submit path.
-* @ihost: host on which the the request was queued
+* @ihost: host on which the request was queued
 * @task: request to complete
 * @response: response code for the completed task.
 * @status: status code for the completed task.
-- 
2.43.0

