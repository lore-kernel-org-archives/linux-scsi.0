Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D641FCFFB
	for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2025 14:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740061804; cv=none; b=NiOcbWLw8ezuyot0bX/UN+Rl7XsrzthGqs0j84mbhNqjVvwPgjEBK+tysgU8YTHvM1nr3oX5yPVyP8XXI4JPICh15Hye3YZhw1AKHsgn9hDuqFYutgbHzLkJb+zrsdxtakr4lxRjceYqnCqVNmw/BFTurrft5OHurt6Eply9rt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740061804; c=relaxed/simple;
	bh=jehMlgOKK/zn8+rmeNaKOBWwweqaNIMzFNYVLZCoblU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BUoOVRmHQBQLEBEVr0WxnXxtosmfLGJIRmG/nSzdvu1crvHUo2CZUNcN2ZlOzzHTNsJGX3ZhylwSRx3SFOT4LfgETOgbiKTgPmPcsxubBbfmZttt9Ydd/aSSjNYSqRKeaPzeG/bCIgf+LJ5ByZrP17CtHYX6t8EjOr3akavyDUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hPJ/f+fm; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hPJ/f+fm"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22128b7d587so18770995ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2025 06:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1740061801; x=1740666601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=89cusljOZsNEHMX/VEIEyLqmvuwdbN0yx/sWF6eMKeI=;
        b=hPJ/f+fmLOU0AK5bYzwhEB2VH7JA/rpVOEANYZAyrxOrstxaNdspkzHpXo5NFAYCaU
         I8kv8/OiHGdeD2bVi7cfk7kKFivC6iC2RzVG8ocWlHLTjIteWHSo6M9bWG5QLu9uoxKZ
         rnN7u5dHK0T2AQ6y72ZIeSJr4GF7ZI+mOkI+0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740061801; x=1740666601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=89cusljOZsNEHMX/VEIEyLqmvuwdbN0yx/sWF6eMKeI=;
        b=BVZ1Sx5LCucnJ7qmaFLC14HPIiGOeu1jzFIMdSzc9a50zJj6Z71F5uEgBIA7+K21wX
         gCHI8uSK3Kg1q50k3DJBlE5Qay/jJxKzMVO5psSMun8/2d74hgaNJ8v9sacVvlVikHl6
         Tv5jjPo/JJHK02vj4hp5BkNnzUSNldIghcDEdMjceHjbJJ1ZCvEu4EpZBVM6swM8a4N8
         Vwfw8j/qi3m0P28khHrqOOT5On4NnJaXNqIP7ijtRbFSY2E/jfh1ZQRyqpEy47WBn3E9
         wKkf2hGJYdilkaAm5aAiaSU4WcR1caSLGvb1HTSc1xdiXDeMZ6wImU92ATLmkvq6fxWd
         0jBg==
X-Gm-Message-State: AOJu0Yyvue/fHNGEKVA6GWn+TKfAA6vq1ELa1wESkyeOJg6VF0ztBSfW
	qO+cJihro6EHxwrBNEVhxTuKwaEfL5PyBicP9LBavz2I/OntMDt01uUR4YDAsWKARTZ9OvQ6cko
	xBTqgCReopeyeDAyOUgCmabNGPySBc6OWiOsWf7HgNH5QWtBN3bjrW58siVBl1jcJNU6X75f2TP
	Dklu76ULMvMZM4f6qJk+HNG/iS9g01mhn8utHMcef6YcY1VA==
X-Gm-Gg: ASbGncuSJVjDItidJITGPgq2rvqDV+e7+L6UA8lbZekP8T6ntLjm7SECykdT870Q7/7
	jvNNWBhH/sswCJAuE2Y8/AFXKZNUyaUmJylcRrCzGAzb5Q3aUjqT2FYzBZiP0fyt81q56jsgTNh
	NUbGhwe/UuYoU2JETY3epzSOPFEGYIZiMz9zIkhz7hCeZFBtJfbmSVf1RXdtJ8dtGbAeBR8zvEz
	2Z1RjUJXQ+oc3Cf4+ZSB8xnS/ok1XG1H2IEtH1XdfHMlq/1J3g74LChIu0Xew2tTzBxhLfJnYiX
	Jk35bQm0sRLNdtzGeazO2XCjABbaYt8UkWorejLDSxyPrGCyUnp+2xe9sdU=
X-Google-Smtp-Source: AGHT+IE/014GNPulRgILSw6lsVBBXPUu4PeOeTrJrpYrUNBqWDhlGUXeMN/Z62ll/3Hy29q7SgWvFw==
X-Received: by 2002:a17:903:19c4:b0:215:b058:289c with SMTP id d9443c01a7336-2217055dbf2mr119452125ad.8.1740061800989;
        Thu, 20 Feb 2025 06:30:00 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d47ba84fsm122551805ad.0.2025.02.20.06.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 06:30:00 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 3/4] mpi3mr: Check admin reply queue from Watchdog
Date: Thu, 20 Feb 2025 19:55:27 +0530
Message-Id: <20250220142528.20837-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250220142528.20837-1-ranjan.kumar@broadcom.com>
References: <20250220142528.20837-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Admin reply processing can be called from multiple
contexts(interrupt raised by the controller, driver drains
admin reply queue upon Task Management returned with success
status by firmware).Driver uses a atomic flag for synchronization
among multiple threads/context for draining the admin replies.
Upon entering the admin processing routine,the thread will set the
atomic flag and starts replies processing and while exiting
the routine, the driver resets the flag. But there is a race condition
when one thread(Thread 1) has processed replies and about to reset the
flag but in meantime few more replies posted on queue and
another thread(Thread 2) is called to process replies but
since the synchronization flag is still set, Thread 2 will return
without processing replies and those new replies will not be flushed.

Watchdog thread will monitor the instances when admin ISR/poll call is
returned due to another thread is processing admin replies. If such an
instance is found, driver will call admin ISR to drain replies(if any).

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  3 +++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 10 +++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index ab36aa2dfdc4..3348797bc73f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1032,6 +1032,8 @@ struct scmd_priv {
  * @admin_reply_base: Admin reply queue base virtual address
  * @admin_reply_dma: Admin reply queue base dma address
  * @admin_reply_q_in_use: Queue is handled by poll/ISR
+ * @admin_pend_isr: Count of unprocessed admin ISR/poll calls
+ * due to another thread processing replies
  * @ready_timeout: Controller ready timeout
  * @intr_info: Interrupt cookie pointer
  * @intr_info_count: Number of interrupt cookies
@@ -1206,6 +1208,7 @@ struct mpi3mr_ioc {
 	void *admin_reply_base;
 	dma_addr_t admin_reply_dma;
 	atomic_t admin_reply_q_in_use;
+	atomic_t admin_pend_isr;
 
 	u32 ready_timeout;
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f83d5c9f29a2..3fcb1ad3b070 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -446,8 +446,10 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 	u16 threshold_comps = 0;
 	struct mpi3_default_reply_descriptor *reply_desc;
 
-	if (!atomic_add_unless(&mrioc->admin_reply_q_in_use, 1, 1))
+	if (!atomic_add_unless(&mrioc->admin_reply_q_in_use, 1, 1)) {
+		atomic_inc(&mrioc->admin_pend_isr);
 		return 0;
+	}
 
 	reply_desc = (struct mpi3_default_reply_descriptor *)mrioc->admin_reply_base +
 	    admin_reply_ci;
@@ -2757,6 +2759,12 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 		return;
 	}
 
+	if (atomic_read(&mrioc->admin_pend_isr)) {
+		ioc_err(mrioc, "Unprocessed admin ISR instance found\n"
+				"flush admin replies\n");
+		mpi3mr_process_admin_reply_q(mrioc);
+	}
+
 	if (!(mrioc->facts.ioc_capabilities &
 		MPI3_IOCFACTS_CAPABILITY_NON_SUPERVISOR_IOC) &&
 		(mrioc->ts_update_counter++ >= mrioc->ts_update_interval)) {
-- 
2.31.1

