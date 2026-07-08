Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05D34D2EDC
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 18:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783536043; cv=none; b=ge5iSaTs5NTsxwvEmkpCk+m6BEcZNS4tZb4ysDDY+4Kilu9AFTVEEUmUqFfKyKHCHpd2abCJtdqJoKeYlTQ0HZYT8lsqb6Ybl52yZ7KR8Q/EDryJ2Cfar7dN5zj9LH42SPeEhaz63uujIWOpXWITFCdsPzowyOuIGabWOIN/7DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783536043; c=relaxed/simple;
	bh=FxnacupkGAFFNGuO564bT0u8EqaoKF1N8gEv5ghZeb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqz1qio2yXqTlt5fSjqZ8rnzwMBWtLYt8FUWcWH2hHOxMZ/vJrQkDLawEiz4DubrKSfIBSBvfCze7au0Qf9cngF8AuCHXjFbZEX0Cd1KySYash1GoKOJhfpBQJo0ysI6hqWMmhmUdI47GGnAa1Z6mk3W5IXe/AYsYY0caMDzwt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BObftHDS; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BObftHDS"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-381065a7a03so772697a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783536041; x=1784140841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f1MU7/DIjSiGyXV69qvYwhTaKanYmHbp7hogHsvddaM=;
        b=cAxUyQ7joVebeAzLRADzs1iPn0NA4j2hK6Gk0RPpPkzXczdH66yBR82vd/yQMk2Vhy
         ouUv0utkiaqiGDtfDMNsnUJYPcLYq0x3K4eW36cLgRqfOnPuX7x+hxSIZrCbE9PjPAVs
         5XEpt8zwkht+lRa2UBU4I/LalB/wSlxdfVYfoU1tncQ97WXWTgOiN3Au6CSkjI6nTmkl
         mgMfa1EaSsPwa8+BBJlkNhiYyi0E89IRZ+iQyBFz/MnX9eIQFbRM6k/Z0ZdVJrbrtyvG
         mbF3bxYwwJISDliK6Z81DYVUTK3Dqa2FOR9OffykYNQrocf4qNe83WeX0AKFbua1n6bx
         mEVA==
X-Gm-Message-State: AOJu0YwL09TFAMLfn8TSbH9dO3xztDaGVXKCQmIQZfJTcdtiTUga4rp5
	EdFIE2rwMsyucB3BcQjRNRC0B447uw087LjXlNyThFnKd6JzJRrgVfSDwDn1ygH9bmUktrDDug+
	+sdKCYWiJgxykPM/IBAtrOB856pX/eTH8OXc47HuKcYoN/HFJWGkPm8A/O+rCS4Hlm7EpLziBjn
	ZCjZFvBdgS5lK+HGxQ/kFxzj/uuMwOQfaW1x3QkjeNaTl3uqWygoCDpCQ6Hzn8bwI/vKuBczKnN
	2ck7tXrUJAjzaX8
X-Gm-Gg: AfdE7ck/GtT/JaGTmn0vHG+xWsXGIbWEaiYYSACeIuM0HsdPm7CMto5vFkpvAATkVgS
	Z1dfE+fI7w1R+CseL4JCMhGrHm+OzgL0JZelUy5RM4GARu42e+5KgZIjJcyEz50aKBtYIUFtesK
	h3GydmsQcSh9WJW4U6p0LG7QDbq+GaQMkMAKQyiWkg1tO879ncfHfPh3j/sWQt4rGtXxwK2fBZL
	PruqjWmX5bTM8je8SUG50ImlFJ9gP4XZcShN+8gAcMASZ+qBQ5wO1xDnuiPY9ZosBcW4d/yQUWB
	jb5beVovYUGlIZQQsJeV3dIhRXhhU1ZEUGJXO7+8iG0mw1zPe5HLmsaniSsQhHGTbkCciivs/TC
	9v0teG/62R2uG9jWNGN3IVs2fPD9qso9HGXubwdf7F6RvZIljgm+MczxsU+zWiRhq+Gdk/j2c/K
	tOIYv5BXG4hBqHn368TP94wCbC8SGkIOHd7OBUSUW5lp2swQ==
X-Received: by 2002:a17:90b:4cce:b0:37f:9ce0:af32 with SMTP id 98e67ed59e1d1-389421ac479mr4097760a91.29.1783536041111;
        Wed, 08 Jul 2026 11:40:41 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-11.dlp.protect.broadcom.com. [144.49.247.11])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-311747f0a28sm339705eec.1.2026.07.08.11.40.40
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2026 11:40:41 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c8952346bb9so852721a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1783536039; x=1784140839; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f1MU7/DIjSiGyXV69qvYwhTaKanYmHbp7hogHsvddaM=;
        b=BObftHDSpep9ZK/b6dlc3zmEuEjtJQqE0qxJWKo+1mukIoLV4svzhSttWx6H6Gkey+
         w4Qq4Ea+I/3zLLwC1pDhBkK50+W7dEc7JnkrV27FVWpD2C1gWdtzhW6TN5OKnPlz9OM3
         umxt00cZXhmtwhSa5QzPCzaUM1byxNDb9IHxQ=
X-Received: by 2002:a05:6a21:62c8:b0:3c0:9c19:6596 with SMTP id adf61e73a8af0-3c0bd1a19e7mr4540025637.62.1783536039073;
        Wed, 08 Jul 2026 11:40:39 -0700 (PDT)
X-Received: by 2002:a05:6a21:62c8:b0:3c0:9c19:6596 with SMTP id adf61e73a8af0-3c0bd1a19e7mr4539993637.62.1783536038513;
        Wed, 08 Jul 2026 11:40:38 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm19820599eec.18.2026.07.08.11.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 11:40:38 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 05/10] mpi3mr: Fix performance regression caused by extended IRQ poll sleep
Date: Thu,  9 Jul 2026 00:03:00 +0530
Message-ID: <20260708183305.244485-6-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
References: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Commit 24d7071d9645 ("scsi: mpi3mr: A performance fix") increased the
threaded IRQ poll sleep range from 2-20 us to 20-21 us to work around a
timer slack issue.

On kernels unaffected by the timer slack issue, the longer sleep interval
reduces reply queue processing efficiency and causes an approximately 7%
throughput regression on NVMe direct-attached RAID10 configurations.

Restore the IRQ poll sleep range to 2-20 us to recover the lost
throughput.

Additionally, add missing dma_rmb() memory barriers in the admin and
operational reply queue processing loops. This ensures that the descriptor
payload is only read after the phase bit check is complete, preventing
weakly ordered architectures from speculatively processing stale data.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=5
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 27 ++++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 1f2f0951b560..1d11d7c69536 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -178,7 +178,7 @@ extern atomic64_t event_counter;
 #define MPI3MR_DEFAULT_SDEV_QD	32
 
 /* Definitions for Threaded IRQ poll*/
-#define MPI3MR_IRQ_POLL_SLEEP			20
+#define MPI3MR_IRQ_POLL_SLEEP			2
 #define MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT		8
 
 /* Definitions for the controller security status*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 434b66f7b502..2f787fa36ffd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -473,6 +473,12 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 		return 0;
 	}
 
+	/*
+	 * Ensure that the descriptor payload is read only after
+	 * the phase bit check is complete.
+	 */
+	dma_rmb();
+
 	do {
 		if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
 			break;
@@ -493,6 +499,13 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 		if ((le16_to_cpu(reply_desc->reply_flags) &
 		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase)
 			break;
+
+		/*
+		 * Ensure that the descriptor payload is read only after
+		 * the phase bit check is complete.
+		 */
+		dma_rmb();
+
 		if (threshold_comps == MPI3MR_THRESHOLD_REPLY_COUNT) {
 			writel(admin_reply_ci,
 			    &mrioc->sysif_regs->admin_reply_queue_ci);
@@ -568,6 +581,12 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		return 0;
 	}
 
+	/*
+	 * Ensure that the descriptor payload is read only after
+	 * the phase bit check is complete.
+	 */
+	dma_rmb();
+
 	do {
 		if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
 			break;
@@ -594,6 +613,12 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		if ((le16_to_cpu(reply_desc->reply_flags) &
 		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase)
 			break;
+
+		/*
+		 * Ensure that the descriptor payload is read only after
+		 * the phase bit check is complete.
+		 */
+		dma_rmb();
 #ifndef CONFIG_PREEMPT_RT
 		/*
 		 * Exit completion loop to avoid CPU lockup
@@ -744,7 +769,7 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
 			    mpi3mr_process_op_reply_q(mrioc,
 				intr_info->op_reply_q);
 
-		usleep_range(MPI3MR_IRQ_POLL_SLEEP, MPI3MR_IRQ_POLL_SLEEP + 1);
+		usleep_range(MPI3MR_IRQ_POLL_SLEEP, 10 * MPI3MR_IRQ_POLL_SLEEP);
 
 	} while (atomic_read(&intr_info->op_reply_q->pend_ios) &&
 	    (num_op_reply < mrioc->max_host_ios));
-- 
2.47.3

