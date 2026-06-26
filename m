Received: from mail-ot1-f99.google.com (mail-ot1-f99.google.com [209.85.210.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5535A2EDD6C
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 11:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474528; cv=none; b=Pee5xs+hNya2wgVcvzmR8mjdbPd/CeltLPqsKCb3iebFkGaU6qssVsDkfKLx6pT21YrmCAmoJC5loZCkouY6SOE7FpiOOXZUl6reIC+quL5ZpFMgJ4EcCiUIWgzQZx7M91q3q/2ccVEIp6PdvLTyGPm68S+tLSpGfUQisM3umCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474528; c=relaxed/simple;
	bh=do5U8mAIwnXlGTUxkqcwhreLPYCPRr/JTd3q2VK4nI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9nbW59sRko+5o9tftQXqQJtI+R+Md43VUGFt7t+pcnX8K6cDUc91cBmAqoheQmlQZ49On+Mal2YhNDkgn3kBcnJhu5EqMMCSzpDWP78KCNdCZv8+d9nclHMjybQCT9tVnR1aE9/wEBQ+lgjaltLmoyDtF7u5S3VuhVtEKyrChc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=UXpLe/q8; arc=none smtp.client-ip=209.85.210.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UXpLe/q8"
Received: by mail-ot1-f99.google.com with SMTP id 46e09a7af769-7e93a984f79so598540a34.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782474526; x=1783079326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9M4DI90j4cx4EvN82voyU2o/Bt6rQeDhkbXST7l954=;
        b=mSZ3x0GNfW9fj3fy2MPkuGZqgT6Od8qIICmL+vhUwXOVvtDzexJfGPxeLq42Kw7JAr
         Mr5wN2fuPNkUOBvOyo8g2rN1nRsVfKGJ8iabf2UkP6AgslxVi6lcPWb6tqJF/r+oE64f
         IKIfGi/RGk4OYvlHqx3q4su9ATko7vZcyD8SexCwZczMBHiz66MHmppYH47LVGZjRA7m
         38nYUq5VO8rv1tgEQq8D1QD1jGZvTRURzVfh6hGXEgOOMtB3xef+awrh7tG/F27cYmEp
         x1cQCy+s27N5H/+X8OkJl+mAQJw4fzSyRzI8B1+G+P3QQzHAH79tItd7oy5IDOCs+MSi
         otJg==
X-Gm-Message-State: AOJu0YwvEtmfBdcTwCy6iZm0EakroYqQDZNNIublK/cmSjAbZxj3wRhM
	trKcyBaQD/BZzLIkZbmRKZ+kUCwao02pq9K0jc16lUvVDQ2kuP43TDQ+zuk2xJEG5WB5bsrUv9E
	Gsi01QAsw3p10t4ZvI5dQ//fWva4w1kCzZ3uyvCNJevYWGYW+OQGHz3CYQrlT+x6bQvuScWoKqb
	hOHbQ9Hh52BXqjk4TzAps2mbWYhxz6jZR2pPNF2qSM5Ldt3voTCevq9M6GzN9JprulrPOkao+9t
	H+LeWSLhLYSfuv+
X-Gm-Gg: AfdE7cne07yuNOpl35vsB3YnR83vvQZ7mxm5oOnypK4QIyer6sA0NY7GTC/pRIJOwtN
	v0r7do50zAm8FkhB+7hbT0aSmJQyTz6yS9VfslShLMkQKmDjhl9WmVOPiUKUhYBTKLO4yNfYz51
	TMiZlEI0wv6men8H6CXOd9ha4aEXlfm2ZAdOHzT/CNskHWU0qiCtunYrsCaSpdLQu5pBn105GDu
	XhG0YOaL73eG2+weWQsFPLwgZUa09KniCDaZFS1pVG/nSkZ7+o8Umm8/dAo3/ljLy0KBdZcawsT
	mRAkCQJyVf1o+oyGhKiXLKO7m9CzV/KWsBxpgefiyk8hh2vTVgu6gelW+tRSxhyDdpGV8XNRssw
	RuduZX5/2VmXeM9lIUAyCtkDaMvjn4MdE8InNayQtGxDhm4ZtsZs4tzsjCTWJt4lDbZVNxAxyUT
	1JsjYAdkWG/FnCd4PyLwNX5tuXByzcSxwpSlO0NiYUmp/bGw==
X-Received: by 2002:a05:6830:82ef:b0:7e6:fa1b:d99d with SMTP id 46e09a7af769-7e99c52fa7fmr6524415a34.17.1782474526238;
        Fri, 26 Jun 2026 04:48:46 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7e9aa4fa24asm161554a34.1.2026.06.26.04.48.45
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2026 04:48:46 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30c011c7cb9so2024804eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1782474524; x=1783079324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G9M4DI90j4cx4EvN82voyU2o/Bt6rQeDhkbXST7l954=;
        b=UXpLe/q8giFGHnKmpM5p4VDgFqWtIz2ChgkytNT9iWj1ZiDT+tKP6qRg4h81vIYWBZ
         gc3YGiqPYDT/CtUrkIGaGgV0YaLClpPNruZ/2hiAUWgaV6o/40O/xUrxIEJ8OgChiXNF
         k4IhVkb9BICjIGRMOKsXW6tCD8Ydix6AyKXn4=
X-Received: by 2002:a05:7300:e6c4:b0:30c:6d2c:2aa7 with SMTP id 5a478bee46e88-30c84fa683fmr6805841eec.20.1782474523951;
        Fri, 26 Jun 2026 04:48:43 -0700 (PDT)
X-Received: by 2002:a05:7300:e6c4:b0:30c:6d2c:2aa7 with SMTP id 5a478bee46e88-30c84fa683fmr6805802eec.20.1782474523193;
        Fri, 26 Jun 2026 04:48:43 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c58831asm18844838eec.13.2026.06.26.04.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 04:48:42 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 05/10] mpi3mr: Fix performance regression caused by extended IRQ poll sleep
Date: Fri, 26 Jun 2026 17:11:04 +0530
Message-ID: <20260626114109.43685-6-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
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

Fixes: 24d7071d9645 ("scsi: mpi3mr: A performance fix")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
index 496d7ca3ab37..32aeae20481e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -744,7 +744,7 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
 			    mpi3mr_process_op_reply_q(mrioc,
 				intr_info->op_reply_q);
 
-		usleep_range(MPI3MR_IRQ_POLL_SLEEP, MPI3MR_IRQ_POLL_SLEEP + 1);
+		usleep_range(MPI3MR_IRQ_POLL_SLEEP, 10 * MPI3MR_IRQ_POLL_SLEEP);
 
 	} while (atomic_read(&intr_info->op_reply_q->pend_ios) &&
 	    (num_op_reply < mrioc->max_host_ios));
-- 
2.47.3

