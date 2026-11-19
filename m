Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795108144;
	b=piFpTZWHLjJwCUQ56vEIMVJWPkKbdwZ2fycdoLdphLPJBi2EDARXfnftDpTEqyVnH61d
	 dz4a6k/BX1N8pGxgNnnA/LxzdH4rAE9UTKnDU8nFiSYfkwm3M6lpY3muYB9F10G7KMOBi
	 Rlz66V6tur8EffVJd2vEY5J0mzpR/68zSHwthDAcKWGyjFXtJXm9rzTsjBNFy+Te2VosO
	 pA3iEIHIHiYuB1LYJ5yjf9MeJlpuV1CiO53tW3Q7iRQGwzLolR6WdQ2lKIeVhJpVzf/EE
	 QvoQWAZ3mPb/mPa95BgGK2avbCySXasmokCGOWQtLEx0io0xZ2jc96JHI/Ocwo+Q/vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795108144;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=qewKek18Cekp1MLnhZnBB0dbzkIZGz1GDnRfqgtaoNs=;
	b=R4GKMnFERccsg44h4vFMVSVbmicm/mcCf15va5Y9JV4mfvMkZ1x4m1tqRStEq0byjmcI
	 tW3AoD4SEdrJEz+gL6bdcM5mcm9b1CtM99RtdNPRKuWGAWzfXC0z2ylCXFyH7foQ2IwU+
	 w8OUyWfKbl/VMHCntl8IW2CVG4N0ti1UYEZnxyEaHYpg9TxFAgKCxsWY/2yvvCTe7B3Dm
	 eBQwseXe5PC8hVVFL9Zgx0Jz+I9yWMszKdiZNHGw4BK/wbFYz6qYgl0ptpscj4WESUcCk
	 fS+Nk6czWRQ9Ip3bidGsBNqYT9DgL+d903so/+SmiPM96uyCAymyUsFNrTOCTEVgPgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=N74sIDFY;
	arc=none smtp.remote-ip=74.125.82.70
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8273C606A32F
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 17:09:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8273C606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=N74sIDFY
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1a5005fd0f8so4496780c88.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 09:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795108144; x=1795712944; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qewKek18Cekp1MLnhZnBB0dbzkIZGz1GDnRfqgtaoNs=;
        b=N74sIDFY0/fHHVeLR7dz4ES+V7XEejLnR66eM6sSdiLUEv2UqFBSbh1NMPWj9h7HZw
         Q+8Y+ESw0Vc9tTad5B/t9KclZmTPS80HQ+ZAM3FUnjER4OygzRqwqlKh1av3OqmVaxqx
         1mT4ZdjZO4sE+O9yWqy5eiVvFwngVvYcHCcaJKgjRMHO5De4rpJjc/Bw/gyZO7HIxz96
         aXxOcRw48POpZiBoVacBnGS0v8O7BugQI6yjpyYh2Llo566sk/yv9XMYvsLEH1imxmxu
         wQSR1JYMfJGePVANSFkzDz5rSniNlXXuRM34cI7IonLVTjM6SA+8etbyZwi5E5X91BKd
         +/oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795108144; x=1795712944;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qewKek18Cekp1MLnhZnBB0dbzkIZGz1GDnRfqgtaoNs=;
        b=pPuXRMJYbwHoMoDkLT51kxXCJafm2+I+JSRSWHdsASQil42XDqGoNuo0VrAHd4akKN
         M63DMMr1RDfjeZewLS2BSTdHGGUu6E4Meq18Jcw2BOOJuYvHbYWhPQSRKqt4ICStVINq
         +dreS2nzJRCHE1ES51cXqyhf73Ok2xRNCwMb9ZilsESDmasl5/9vz2adMcyJW99TvFaA
         hZPPXbW7zeKkJxA6WBiJSiiPQE3DD5BKEtt7RwTlrwJ5JQbq1AGiAy9JF5k3qwFHvRSP
         R1degH+xTNWie0mBI2A6lZDjSg6bW3iv8nLl0/xV4K/fkBuoLQX90QYrmUomyaZuGVAi
         8yuw==
X-Forwarded-Encrypted: i=1; AL+hErHqOA5MWkSHqX6EhwqhtjEM8bXGO+KsThx2Mb6Yzhh2ZAmUb+KtyuOSfFb5fquYS9U4D7wcMiB2zyV7@vger.kernel.org
X-Gm-Message-State: APuU4Z8i5Cv3aEslMIDUriIzz02QHpViBjlnSeVnINMEUAGNoyQyTN4k
	g6uOdPHU8MAh0T7bYEhWdIOY5P75mpb0MI+A6rWABb3cZcMlwY+fNc25j1/gblPKzLqv44B8R8R
	4zS7SKKBNEg==
X-Received: from dlep8-n1.prod.google.com ([2002:a05:701b:4588:10b0:161:df69:3983])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:5f08:b0:144:c112:5f24
 with SMTP id a92af1059eb24-1b5568f9e24mr242758c88.25.1795108143195; Thu, 19
 Nov 2026 09:09:03 -0800 (PST)
Date: Thu, 19 Nov 2026 09:09:00 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261119170900.1530138-1-irogers@google.com>
Subject: [PATCH] scsi: mpi3mr: Fix start_time and error return in mpi3mr_bring_ioc_ready()
From: Ian Rogers <irogers@google.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Elkin Cruz <elkin@google.com>, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

mpi3mr_bring_ioc_ready() has three bugs in its failure and retry
handling:

1. start_time is only assigned after MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC
   when retry == 0, after three earlier 'goto out_failed' paths. If
   soft reset, reset-state polling, or admin queue setup fails on the
   first attempt, out_failed computes elapsed_time_sec from an
   uninitialized start_time, and if a retry occurs (retry == 1),
   start_time remains uninitialized for the ready-polling loop as well.

2. In 'elapsed_time_sec < (mrioc->ready_timeout - 60)', ready_timeout
   is u32, so values below 60 wrap around in 32-bit unsigned arithmetic
   before zero-extending to u64, spuriously retrying past the timeout.

3. After mpi3mr_setup_admin_qpair() sets retval = 0 (or on entry where
   retval is initialized to 0), controller fault/reset-history checks,
   ready-state timeouts, and early unrecoverable or device-not-present
   exits return retval == 0 (success) to mpi3mr_init_ioc() and
   mpi3mr_reinit_ioc() even though controller bringup failed.

Initialize start_time = jiffies at function entry for pre-enable failure
exits, reset start_time = jiffies the first time
MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC is written so pre-enable waits do not
drain ready_timeout, rewrite the retry window check as
'elapsed_time_sec + 60 < mrioc->ready_timeout', and ensure retval = -1
on all failure exits.

Found via Clang -Wconditional-uninitialized on an x86_64 allyesconfig
build. Verified by building drivers/scsi/mpi3mr/mpi3mr_fw.o with
LLVM=1 W=1 (-Werror) and -Wconditional-uninitialized, and with a
standalone C logic reproducer under ASan/UBSan; not runtime-tested on
physical MPI3 hardware.

Fixes: 59bd9cfe3fa0 ("scsi: mpi3mr: Code refactor of IOC init - part2")
Fixes: 0a319f162949 ("scsi: mpi3mr: Wait for diagnostic save during controller init")
Fixes: 9634bb07083c ("scsi: mpi3mr: Enhance the Enable Controller retry logic")
Fixes: 4616a4b3cb8a ("scsi: mpi3mr: Improve wait logic while controller transitions to READY state")
Fixes: fb6eb98f3965 ("scsi: mpi3mr: Handling of fault code for insufficient power")
Signed-off-by: Ian Rogers <irogers@google.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f0d3cd398dd0..b92b2467e995 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1582,8 +1582,9 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 	int retval = 0;
 	enum mpi3mr_iocstate ioc_state;
 	u64 base_info;
+	bool enable_started = false;
 	u8 retry = 0;
-	u64 start_time, elapsed_time_sec;
+	u64 start_time = jiffies, elapsed_time_sec;
 
 retry_bring_ioc_ready:
 
@@ -1595,6 +1596,7 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 
 	if (!mpi3mr_is_fault_recoverable(mrioc)) {
 		mrioc->unrecoverable = 1;
+		retval = -1;
 		goto out_device_not_present;
 	}
 
@@ -1621,6 +1623,7 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 		if (!pci_device_is_present(mrioc->pdev)) {
 			mrioc->unrecoverable = 1;
 			ioc_err(mrioc, "controller is not present while waiting to reset\n");
+			retval = -1;
 			goto out_device_not_present;
 		}
 
@@ -1654,6 +1657,7 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 				if (!pci_device_is_present(mrioc->pdev)) {
 					mrioc->unrecoverable = 1;
 					ioc_err(mrioc, "controller is not present at the bringup\n");
+					retval = -1;
 					goto out_device_not_present;
 				}
 				msleep(100);
@@ -1690,8 +1694,10 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 	ioc_config |= MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC;
 	writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
 
-	if (retry == 0)
+	if (!enable_started) {
 		start_time = jiffies;
+		enable_started = true;
+	}
 
 	timeout = mrioc->ready_timeout * 10;
 	do {
@@ -1731,7 +1737,7 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 
 out_failed:
 	elapsed_time_sec = jiffies_to_msecs(jiffies - start_time)/1000;
-	if ((retry < 2) && (elapsed_time_sec < (mrioc->ready_timeout - 60))) {
+	if (retry < 2 && elapsed_time_sec + 60 < mrioc->ready_timeout) {
 		retry++;
 
 		ioc_warn(mrioc, "retrying to bring IOC ready, retry_count:%d\n"
@@ -1739,6 +1745,8 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 
 		goto retry_bring_ioc_ready;
 	}
+	if (!retval)
+		retval = -1;
 	ioc_state = mpi3mr_get_iocstate(mrioc);
 	ioc_err(mrioc,
 	    "failed to bring to ready state,  current state: %s\n",
-- 
2.56.1.708.g77570a6a1d-goog

