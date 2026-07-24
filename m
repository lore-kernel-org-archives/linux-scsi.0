Received: from mail-vk1-f225.google.com (mail-vk1-f225.google.com [209.85.221.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB3441F5EA
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889174; cv=none; b=uwQoodfEc6WkIyTdOUpHmGdUKnKi56wVtGyd4U5hjK9lbfzZ5q3z39QMCvY1PeoITK9fWzGh5A///yNHqRNxOhXLH4IksPVbZpXe8Jwz8u+jQc31QhXumFR8I5NZfRWKNunE5sucmBSdHnY1rWfGCvAPemUDKtcQnFciOiP9Sfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889174; c=relaxed/simple;
	bh=ZIOyzWHGEUL26LcHP59WuDHWqLhjBuFjcSKJ8ukZu8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2qDg+f0FHmDAJHF6GBb0NixdPOiT/BxFQ39ISBRQ4KXKTEAlXPi2Wf7oDOreLCeZUfYdTQ/ghc/TPABPOTJN4QzuFd78qnKKgtW5GOzdHfOyv+pFKsvi8YF6eVA4Zm1c7zmTUFyvbDp41FGqCW1LPoEcrjP6P5mgyE5z27K4IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ewqhWAsx; arc=none smtp.client-ip=209.85.221.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ewqhWAsx"
Received: by mail-vk1-f225.google.com with SMTP id 71dfb90a1353d-5c276bfce7eso167404e0c.2
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784889172; x=1785493972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SxE4bB9WIZg+8s3gW5hXNjusGWrc8XT9kF+T1TIlAak=;
        b=dBFJpIXUoGJ2ZvNGzPh0tT2j7nOf0EcY3akwq/U7QorUcDZifb7adlaEAgp8DZYQST
         k1FhZ2WsRgJhtreKFGIxN4bnR5EnQOMhA2nQeXFPnBQ3np7KKcf9V547MSC9rwoY5WvG
         xp8PJa60CznRhNryrLKMRzVNmMX6xkglMNeNC4/AhzGKGjz2ymGUgGYxYMRjKUTt4CMh
         cb62hRuAmlfb8Vem7GdcMiroN2hafSmRhKrWcElqfuz3XLIFN/MFFngjHtYqwC1kbH1r
         9G+gTZDfawjaipdzWE6arhmQFh+z5BdX8kE0N0cx11ooxpvZIdvbFA7E/Dv1cIAWSHEL
         +9XA==
X-Gm-Message-State: AOJu0YzcHdHrtVNR3AIZKkO1ZgXoibtrx2Wl7KqMRWVwrEXwGVShyAT9
	ijAYhdwkmjH5vzjex5i3CrcgGmde/khvsHGqMp2IaR6zitO0amZO96xufJkgLidJGUEOSBa6o7o
	2AN8L8DNJr9FQgjO9Bt+yhpI7qxp1ISJayT3qMJi6LF7vZg1hcISVXTqA8kyk2LHPk8/T0qEhHR
	ovw8hpyMSh/K17682jDFiepFq2RYZcBkfQPTWiHONfgAeXwsbejzrU5qUjNowxLbeB8fNB3hKNd
	3EIfFGn5nBLtjNZ
X-Gm-Gg: AR+sD1333mAATpJHrQjzGHLgTr6IW0ff7eDjEQoS/9CXD7rqbM3zkXecJVcwgxjHZFA
	sVjxEC0J6cV35lOPQbU6FFkF1Ylr78Bh/yYxYaT7fa3Wl83Fluo27221m7mvEBAG4+wCpC18VSP
	hxQWLAaQ/5doQ3OKWtEx5WX9DEjbPwB+duUmkL8ty9zMalUElWuTp+6ZMHzhPnDGpikTryIIU1a
	oCg0bbRMApKNrlXqnZH7IrhxaxU3cp9r2CCCp/7U12/ztpz8kmepvb9JlsguAxNlmiuVsddjxRX
	mJrf8mxO42e7/E/n+CAdJatEqt7+m5F/AimZPUVRSR3uszEI9unu7BtYQ0hlNhbuyBOJDGDFUgx
	P8hT8MUZw4+2P9UTTC/KA2wxTNJp9FOAQtazU6l7ABIyuI78MHHT1EiOqoG19S7H+WaUsQ5bki9
	+cph11162UXQ6EKI36hANRUolWNzJBATjOMao=
X-Received: by 2002:a05:6123:2eb:b0:5c1:47db:cfcb with SMTP id 71dfb90a1353d-5c2da022353mr3731784e0c.4.1784889171646;
        Fri, 24 Jul 2026 03:32:51 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c2c65ad85asm952920e0c.7.2026.07.24.03.32.51
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2026 03:32:51 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb711c88f2eso213887a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784889170; x=1785493970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SxE4bB9WIZg+8s3gW5hXNjusGWrc8XT9kF+T1TIlAak=;
        b=ewqhWAsxlboIuWQYUQf/JZK39XEYUJi4XmeNSYHsLrfH2ga0PYqvXnqXI/KkzJcUlX
         MUxBZIqg2M8pyUQp6/jxjyM7iE3D0iE/f+PPojnwYFCM7t2bh785SJshgG6Oia+YfEA8
         9TCfyk8xjmgsI4QxlCPKbtd05q4DlmihLCl9Q=
X-Received: by 2002:a05:6a21:a04:b0:3c3:97fc:93e1 with SMTP id adf61e73a8af0-3c44afccc17mr7709645637.15.1784889170499;
        Fri, 24 Jul 2026 03:32:50 -0700 (PDT)
X-Received: by 2002:a05:6a21:a04:b0:3c3:97fc:93e1 with SMTP id adf61e73a8af0-3c44afccc17mr7709609637.15.1784889169947;
        Fri, 24 Jul 2026 03:32:49 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1cf8fasm30233211eec.31.2026.07.24.03.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 03:32:49 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 06/10] mpi3mr: Fix memory leak on operational queue creation failure
Date: Fri, 24 Jul 2026 15:55:01 +0530
Message-ID: <20260724102505.115136-7-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
References: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

When operational queue creation fails after one or more queues have
been created, the error path frees the queue information arrays but
does not release the DMA memory segments associated with the created
queues, resulting in a memory leak. Fix this by ensuring that partially
allocated segments are freed immediately if a queue fails to create.

Furthermore, the error handling path leaves dangling pointers in
mrioc->intr_info[*].op_reply_q. If a spurious interrupt fires on an IRQ
vector associated with a downgraded or freed queue, it leads to a
Use-After-Free or NULL pointer dereference. Resolve this by ensuring
the corresponding intr_info pointer is cleared whenever a reply queue's
memory segments are freed.

Finally, harden the error handling path by checking for NULL pointers
before freeing segments, and reset the operational queue counts to zero
on failure. This prevents a deferred kernel panic during driver cleanup
if queue creation fails during a controller reset.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=6
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=6
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 9f7cee26ebcd..370ad8568117 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2020,6 +2020,10 @@ static void mpi3mr_free_op_reply_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
 	u16 j;
 	int size;
 	struct segments *segments;
+	u16 midx = REPLY_QUEUE_IDX_TO_MSIX_IDX(q_idx, mrioc->op_reply_q_offset);
+
+	if (midx < mrioc->intr_info_count)
+		mrioc->intr_info[midx].op_reply_q = NULL;
 
 	segments = mrioc->op_reply_qinfo[q_idx].q_segments;
 	if (!segments)
@@ -2504,7 +2508,7 @@ static int mpi3mr_create_op_req_q(struct mpi3mr_ioc *mrioc, u16 idx,
 static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 {
 	int retval = 0;
-	u16 num_queues = 0, i = 0, msix_count_op_q = 1;
+	u16 num_queues = 0, i = 0, j  = 0, msix_count_op_q = 1;
 	u32 ioc_status;
 	enum mpi3mr_iocstate ioc_state;
 
@@ -2556,6 +2560,13 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 		}
 	}
 
+	if (i < num_queues) {
+		for (j = i; j < num_queues; j++) {
+			mpi3mr_free_op_req_q_segments(mrioc, j);
+			mpi3mr_free_op_reply_q_segments(mrioc, j);
+		}
+	}
+
 	if (i == 0) {
 		/* Not even one queue is created successfully*/
 		retval = -1;
@@ -2577,11 +2588,18 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 
 	return retval;
 out_failed:
-	kfree(mrioc->req_qinfo);
-	mrioc->req_qinfo = NULL;
-
+	if (mrioc->req_qinfo) {
+		for (j = 0; j < i; j++) {
+			mpi3mr_free_op_req_q_segments(mrioc, j);
+			mpi3mr_free_op_reply_q_segments(mrioc, j);
+		}
+		kfree(mrioc->req_qinfo);
+		mrioc->req_qinfo = NULL;
+	}
+	mrioc->num_op_req_q = 0;
 	kfree(mrioc->op_reply_qinfo);
 	mrioc->op_reply_qinfo = NULL;
+	mrioc->num_op_reply_q = 0;
 
 	return retval;
 }
-- 
2.47.3

