Received: from mail-yw1-f226.google.com (mail-yw1-f226.google.com [209.85.128.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDEA30F959
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 08:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768205837; cv=none; b=QuNgZ63Qf/w3LnuPZHt1dbrEHI781TJDf75EKkJN5+xnTMC7hxZg2lW7oIagtrRdPN63K0DGiEOZ2J55Jd5KLoiTA9kdt/NVsiJEB6+TkaMHctCVvxkheAVIJ9F2LixFlSnzwptv/p4ebLnILmNP3AdwxoHszHvacPdsR4re5RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768205837; c=relaxed/simple;
	bh=cps32XEwz/c/5h1Z7oMxaJ/X93tVlCW6syN/Ek6XqGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8LQSdNl1j6VI8I0I3dnOWXB/vLrEniuYlef2FkEkME+ogVYWwVeNHEkC+vz4m4OuAYC2NhU+ZejE+Y29UzkQSwrE3BTAOsAN7vcvmtCnUQXgclPo6cWN7H1cZ3/gCmzfLzKe2A32ugcVQsgA3/pXYhU3hCxFoLQaWb0IF0EqlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=GRjbBVDB; arc=none smtp.client-ip=209.85.128.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GRjbBVDB"
Received: by mail-yw1-f226.google.com with SMTP id 00721157ae682-78fb5764382so64503937b3.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 00:17:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768205834; x=1768810634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zj7V5JNwo2Me01/PJAslBLgiyMXeAGqOW0IUxyM31Zg=;
        b=Z2uB6SSAVp9Hy2fjBZzfB/dXgGkUN2ioK0RBc7LFAAiU/aO7x/corT6E+3HphP6WmB
         kDFmHebrsN7wWg00N6tRGaZYrzrnVrEvSPQj2eIHGyyqi/wLM1+mtFWhRJ+uQ9vxa7gu
         uINGQbDeST6A/s0GfzbHOujvwU9Pzr8aLjORADM2ELZufvN/DYvxtN46o7qE/TlNVU+j
         GZNmPyTzBWIqDqFr5/fdhkLtPEkADNj5bc/tFifMu98RNYROJ8H1Hv/1qcNryn2pOIl4
         cmm0okSZkEBGqbQc4JnMnSI6CVjksMR7sqmUqGAxVUwj3fBlINSgP5bxd9HfzUyLzn20
         Hlyg==
X-Gm-Message-State: AOJu0YwxejiJ4D5VbgaV0LRWZyAAb5Xz3X8quRv5oB+RkzMIUTlSC81Z
	UfgBLJLDQWAuJIj1dkqHuY4PIGeCYmUM/ni2om4a2GiBXZY87wPnJCxuB7mMKjxw4jxdjDSvNOh
	mKH6msz7E6Fxs+n3s9Og9WKAZV2w+oN1GGy+X3yqf1b56XBNqn9uujvZFPohXvcGnKGygTKv0cX
	Colz9wOBcgLK0mjeiFiK1Uu6EJrXl5ltIVGR4ybrAiGPT20+qz+l6YZo7s6QK7wYMaNVr1SOKBW
	2kxOllP71+mCiNk
X-Gm-Gg: AY/fxX4hWLKAaVSv+/44YXy8ucvgUBLGSL3zbB84NpNZIRTZICdvx7m5LZY4DKDd58s
	z4IsmnNpaNefZ7j3aHwQb/MqoyEgRuKaoZtCKXDTij4hSAkgCu+a+j9LtYQ4uFe0Z/ImyZwbpTC
	RmFuuLIWynKx7As4+wYDE8MvgS5Kpat5PAladNf9ljOfSHeY+9B65OQlxitCPXLOH+squNwdrMP
	sYsZrE13BZ8P5SVFuLvvfTPpkGfHtsqLgzDGXVoEzx5x6Gp1GP3Ny4a723ptqYH63zV6Pj3LS3G
	tAOfIImkOYQe0UQHc2m2RofCm+0DKYrH/gLU1eTIg7mVVAVRbL1SRJKfi74ruQiPP0Vhxt+ESVZ
	tRJDR8HpuYgGypWq0l/Cgdw0EmRXs+w8/cLTAY5YQXRbOb36pP8VxUvd1t0hiiZU1WO5/jG2/FE
	zj2qiQOlX8OmtKThgfO5+NlUxF50/7fUucP/7PuuRSX6fSTCE=
X-Google-Smtp-Source: AGHT+IFyNoarf4vb2PE6kNn/Rk4cnkhxIMXQMSGCnqhK5QQa09cSuzJrR0djkeedNMIpfVxTHHPtcNG1YQxY
X-Received: by 2002:a05:690c:4913:b0:78f:a535:93d4 with SMTP id 00721157ae682-790b55e08d5mr134099007b3.25.1768205834602;
        Mon, 12 Jan 2026 00:17:14 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-790aa6e54b8sm13172757b3.27.2026.01.12.00.17.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jan 2026 00:17:14 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c5539b9adb8so1669158a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 00:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768205832; x=1768810632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zj7V5JNwo2Me01/PJAslBLgiyMXeAGqOW0IUxyM31Zg=;
        b=GRjbBVDBC6ivijoezKbl+tVYt7yZIte7Ts96xsrbJv9eldzS+hyhRQBnXMPphSVUg5
         +fhkIV1fXqclF6pRKbQ2ik3Xc0Gtu/Ig0GcLY/OPUL1Pz7I94xD0mjchZYv1SKNjT2C4
         V7Kcr8g9pJmoUKdny40Ak4fo6BNU+82dOro98=
X-Received: by 2002:a05:6a20:19a9:b0:389:93e3:ca96 with SMTP id adf61e73a8af0-38993e3cae9mr11856271637.21.1768205832353;
        Mon, 12 Jan 2026 00:17:12 -0800 (PST)
X-Received: by 2002:a05:6a20:19a9:b0:389:93e3:ca96 with SMTP id adf61e73a8af0-38993e3cae9mr11856258637.21.1768205831915;
        Mon, 12 Jan 2026 00:17:11 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5f8b1526sm16808659a91.14.2026.01.12.00.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 00:17:11 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 3/7] mpi3mr: Avoid redundant diag-fault resets
Date: Mon, 12 Jan 2026 13:40:33 +0530
Message-ID: <20260112081037.74376-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
References: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Update reset handling to invoke diag-save only for diag-fault resets.
Skip issuing a diagnostic reset if the IOC is already in FAULT state,
preventing repeated fault handling and improving reset stability.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 869e525f3e73..178738850541 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1707,6 +1707,8 @@ static int mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type,
 	    MPI3MR_RESET_REASON_OSTYPE_SHIFT) | (mrioc->facts.ioc_num <<
 	    MPI3MR_RESET_REASON_IOCNUM_SHIFT) | reset_reason);
 	writel(reset_reason, &mrioc->sysif_regs->scratchpad[0]);
+	if (reset_type == MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT)
+		mpi3mr_set_diagsave(mrioc);
 	writel(host_diagnostic | reset_type,
 	    &mrioc->sysif_regs->host_diagnostic);
 	switch (reset_type) {
@@ -5404,6 +5406,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 {
 	int retval = 0, i;
 	unsigned long flags;
+	enum mpi3mr_iocstate ioc_state;
 	u32 host_diagnostic, timeout = MPI3_SYSIF_DIAG_SAVE_TIMEOUT * 10;
 	union mpi3mr_trigger_data trigger_data;
 
@@ -5462,7 +5465,6 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	mrioc->io_admin_reset_sync = 1;
 
 	if (snapdump) {
-		mpi3mr_set_diagsave(mrioc);
 		retval = mpi3mr_issue_reset(mrioc,
 		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
 		if (!retval) {
@@ -5564,8 +5566,13 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		if (mrioc->pel_enabled)
 			atomic64_inc(&event_counter);
 	} else {
-		mpi3mr_issue_reset(mrioc,
-		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
+		dprint_reset(mrioc,
+			"soft_reset_handler failed, marking controller as unrecoverable\n");
+		ioc_state = mpi3mr_get_iocstate(mrioc);
+
+		if (ioc_state != MRIOC_STATE_FAULT)
+			mpi3mr_issue_reset(mrioc,
+				MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
 		mrioc->device_refresh_on = 0;
 		mrioc->unrecoverable = 1;
 		mrioc->reset_in_progress = 0;
-- 
2.47.3

