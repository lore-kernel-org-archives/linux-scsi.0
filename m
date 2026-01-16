Received: from mail-qv1-f99.google.com (mail-qv1-f99.google.com [209.85.219.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A5E34D3A1
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 06:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768544041; cv=none; b=P7/rq5Ptnce2efBqSSR/8V4yNdYBosmEGa/FUjonBtwrO7yGIPvteU7u8FY5T99yo+TuyAj0YIjINoF7HLBMpi8Rj51q8NUtbSZekBUHkWBjZZv4Orf0tdU0j6AEw5wXCcIdK0ifgkvxjm4gJZqWPNgi25l38rtvdE4CFwxtkiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768544041; c=relaxed/simple;
	bh=xwDbpWqTy4SGq/CuYIDmqvMXiNVHfrAkNIFP2XKxj90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvPigYp20P9wIQpGMIfwFKjhEI9gdDNY1zZMSXc8vrgCWRcez5Fv8uM3Sx+B64aCG/Eed+4J3uPozKzgroZPNakCpCGZrRCtSvXnvS5DCTszJmrG5QbNIn2P37IxmbW4C8aZmjrL7G8YUPMXWJfIYp5NkRR6h6vG2n0lHo8FZsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=KI7+zoQ8; arc=none smtp.client-ip=209.85.219.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KI7+zoQ8"
Received: by mail-qv1-f99.google.com with SMTP id 6a1803df08f44-888310b91c5so25177746d6.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:13:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768544039; x=1769148839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pjywzucN2ACn1QcAkHv4sQufumPgeUl6wFV/JHwQMWI=;
        b=Ur1m1Fhjk+XEAJ+Bk9DlmfdRHEYYLIyBtwo+FIcL9VWNLnREU8AmIStG0moHHQ5Auo
         9QtvZXA3LyxXP3+PfT1ozbtWRop8iy8o/Lbwgh9Wf2XxsUy4YcATIcEdSl0qXAW5KALl
         /VhFFv97UFaBHcUzVS0f0yweCPGTpSTLYgYdi7th6+iqm7FtTNFnPcDqKAI4DrZ9v2zY
         ufKjT9TQeQqMuVozu9pf4Lf9kqf2/swJKPsN7AaPW0eVkGCc8DDZNck6fknaLg1eMc/F
         lxJG1WMSEFinKjnmGPuRZ4SS1UF+hvr3cF/fskvAqMlbCAo9sumDy+BJcCT7T+vnHgx9
         grhg==
X-Gm-Message-State: AOJu0YxKXs8ZwxOvJ3KcBlypmsNEm+5mwW1dqNLkWsyQwVP+cFaPuxF/
	DWLRH77fGsqrKfn7vhS9pzQkBmNxmgJdYoRXY9/RFAPyGNISuNVoRVtlrxPF9CflNFv8MGM6snf
	ypIthw0pn62VCVIhTwoPLb7IcNAQ/wWPx+KDMzX/mQIbVG2rnbC+wb6Iqjza9Ncx/TXYB/MzL0E
	FJ1/KEfUgCNxfj1Gty5ngzRS93+FsGjIEt0VB/E6hbp1T2Tb4+z8X6Fa5tY9JpbpYmIvb48Zyvw
	Z/Tjubxuy2dp805
X-Gm-Gg: AY/fxX4pX4+XFQOyRD3uUy55bN+bFuPRctjuLdux0tKllmixY+ofkJgml+NNgCBfXG8
	TXOqgsQynHiqvoOZ6L7/qvoZXWMO1Se/v6QuI4KyPwfmFAsTxWrvkPwnJVCw2YU3/IEjaMBUmx2
	AkIr0yHfu6wOv9OvVvTpZfVMdP/l7ninf2n1cqjS49Yx0V1r+PR8Zqi3HvxcLOGv8Nij2Mc3OcP
	tv4PxRKutsSnvlOMz2I6JPO0u/0DmaBMZ973r9kPWqSehnL/Mt5+sMivMntPzaltBAkxaUDenfd
	VKcdCkjeogLA01iHmQzUaPdNpin2sNmZpHnMAcOuq1uOeQpVyLoWoKFJFCqR/VmtsqCtXJ8bmnL
	CP4EItyLlG1anYeLLEp/ed8BDYdYGI8lQkDLij/2vHKTnW+zCdd5A91CjAcZNcIpXhihWLXyfGW
	a3LUBueNH5I9hYM4d+nolfSVVauBbsLmHtKkPUqWKfMcNnYBM=
X-Received: by 2002:a05:6214:c8b:b0:888:4930:7989 with SMTP id 6a1803df08f44-8942d7e0fe2mr28771776d6.36.1768544038853;
        Thu, 15 Jan 2026 22:13:58 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-8942e6e6129sm922726d6.26.2026.01.15.22.13.58
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jan 2026 22:13:58 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a0e9e0fd49so25850445ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768544037; x=1769148837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pjywzucN2ACn1QcAkHv4sQufumPgeUl6wFV/JHwQMWI=;
        b=KI7+zoQ8Psp46YgKWg/0lfqBpacgr/LRGv3yOMOZtxkZjKkKAO+9Z1k1Q3Da6pA850
         1jLm1klenh8WZ6/BIVDHejNnXnVXn1jEpIEGAfokj8yUB9GteQAaqTHIBeSH9bQUhY4p
         tTuHb1RALAQzvBugDzBOxOL833BfGRdnxPpKQ=
X-Received: by 2002:a17:903:986:b0:2a0:97ea:b1bd with SMTP id d9443c01a7336-2a70087cbfamr53666075ad.0.1768544037330;
        Thu, 15 Jan 2026 22:13:57 -0800 (PST)
X-Received: by 2002:a17:903:986:b0:2a0:97ea:b1bd with SMTP id d9443c01a7336-2a70087cbfamr53665855ad.0.1768544036833;
        Thu, 15 Jan 2026 22:13:56 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a71941bd9bsm10231315ad.93.2026.01.15.22.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 22:13:56 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 3/8] mpi3mr: Avoid redundant diag-fault resets
Date: Fri, 16 Jan 2026 11:37:14 +0530
Message-ID: <20260116060719.32937-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
References: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
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
index 1300f9af4c74..6debe81a1e5b 100644
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
@@ -5401,6 +5403,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 {
 	int retval = 0, i;
 	unsigned long flags;
+	enum mpi3mr_iocstate ioc_state;
 	u32 host_diagnostic, timeout = MPI3_SYSIF_DIAG_SAVE_TIMEOUT * 10;
 	union mpi3mr_trigger_data trigger_data;
 
@@ -5459,7 +5462,6 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	mrioc->io_admin_reset_sync = 1;
 
 	if (snapdump) {
-		mpi3mr_set_diagsave(mrioc);
 		retval = mpi3mr_issue_reset(mrioc,
 		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
 		if (!retval) {
@@ -5561,8 +5563,13 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
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

