Received: from mail-ot1-f98.google.com (mail-ot1-f98.google.com [209.85.210.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208663A6F04
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075902; cv=none; b=j4vBg5sCaAqhZM1pZjrls5YlIAtwAfB5KgINVEuHPynllpgCtRxiKnpzyZ7GcM1/VJw22mQBdiQATZpgqj5eST5U48kQQdBFDokgWPo1NJCxG5slTvLPzQujw1fzIqtMXFh0y7q//xrLDEkRPHhgsRm7i8DuH246zmXdq3I+VnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075902; c=relaxed/simple;
	bh=CvRHcK+hJw9dMj8Jr1gfiTJjWH6VQQYr8cXlTmChO9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4DscW9dadhpL2Za8lAKwE0KsVvxpD8Pzy02aOzcH7+2TMI8TSGrU37iT5w/UB57XAWWvAjxNeHXEAiAiNIoIACKPfHgOuMko+zDhif3jRCwUCAARcN7JRXkFGHV83R4uR0Tol9+o6m0SX7479Btx17smzlvZ0NKlS9l3v9OCZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=QYidMvQ/; arc=none smtp.client-ip=209.85.210.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QYidMvQ/"
Received: by mail-ot1-f98.google.com with SMTP id 46e09a7af769-7ee37dc91f5so63867a34.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075900; x=1787680700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hnBA8zkLLjycxSdxZuqPkfawdSxIHV5hz/K4Er5f1YU=;
        b=VGssU/h97Oj7tBD7DIdMZ/ZRblhsVI7V0RoVcSMH3vfokm18ZWjv6+QQhzzfHf0bZg
         iQ/VReUaHYPpOdOaX1piZsaaAZdu8YCuIqrjHTwAEtic/9Z6EtYT9Tg2pht9rFjWqcd+
         QAyDVvowiLU0S0oWaHEwXtqOLwSuHCUbZvHyo7zytuV7nshTtQkmhtjPws76C8S4fraP
         W6BJzgoldkUkBv5FJDDQsDWTPud1O/OwJhFLZcSQZTAxhDuB9esmUFv4XEZHkK69lFwW
         ziD/lRoGyzUMYs2CN/xvx/kyCKxkcVCmYlAeCsuJ8MVwQYSTbiU+8vHWgFWJDdzgh1eq
         AGIQ==
X-Gm-Message-State: AOJu0YxMTjvJPd5NdKPaJOwD55kE3DtsEhQPAyk/CAbI3hzqdQCqVGDF
	XKp3BHnjj2nBnUE79EH4vmYge/ZHIIU89A31aBL9ZXi3Z0eHQJhvMsfTpZKfU0vFdcr/Y/EkgDO
	rWdu3bqsYpH7zQmAaqxFo7Juyhv0BvJmpQUboxrcCCjjJOZqI/43qtFXyD+hbZPqnGuuqatOW1+
	jubGKpgJp3mdCqNJ5US5OxPNN2lO4dpTkEWGwzEHKkeVLkAU0zAJtfCgyTvNSDZ2kQtWmBF3MhS
	7ZNZezposSInuwYvw4rl6Fy
X-Gm-Gg: AR+sD12tlpW0ETslma0mIAaYc2CXPi7XxAPpboUjxu/SJ/vcNf6zSNis3kQyZu+WpvL
	bcDPLw5vRnXQespS0Gn8WfdlqujxU0IOZZMxjB0CJB+uzujU9bRuc5AWrK1hQVuWID8/heRK76c
	dcExwlqR5rq1LWU2zxwk8uXSx3N+zd1OqBZvvZ3KrPICAIbsqBUPXOea8i86TUP8HX9fNtMyu2y
	hhZdwXL1XxAByHyiJO3kf15XVRetl2p8JJRHFRUp9aT5BRtpQj3uQ3rwOrf+YUucu0S4qDMA4jX
	lRT7rd4qmsGPKWIrp8xeZYASrzAzo9TxAFji0dhF9a/J2N8smF/jNKTGfY+qnd2bUiCcnimU0/J
	xxFPrJxuNUHeSaTBAvXF590Xdlka+wyWwbws0sou7DYtubEIg2Njhs4LXCpr2QYShegj+mEV8FZ
	1idB/iYTfTVFiFozlMwFUZeLuaSIErVnbWrNNb5/kYeHA=
X-Received: by 2002:a05:6830:6d4d:b0:7e6:ee1f:96f1 with SMTP id 46e09a7af769-7f3de5ce42dmr36162005a34.5.1787075899954;
        Tue, 18 Aug 2026 10:58:19 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7f41c0ade16sm701283a34.6.2026.08.18.10.58.19
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:58:19 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c9fe4c5eb39so36127a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075898; x=1787680698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hnBA8zkLLjycxSdxZuqPkfawdSxIHV5hz/K4Er5f1YU=;
        b=QYidMvQ/PgYfXiVSXselucaQE5ABj0QWtcWSeE078esMqZre5Ui1tpbV0MY5CW/viW
         ecFkWxLsSd7WaJSfs9VygDnwhHf9digG7ZZJ4nOz4rPOg6qbxq85C8UkLBPIrQPtA53H
         g/r8doPAPooDvzQ5Voz83xNtlFyXso0R4xjjg=
X-Received: by 2002:a17:90b:2541:b0:38d:eaec:4396 with SMTP id 98e67ed59e1d1-3933e5d2332mr40276186a91.11.1787075898469;
        Tue, 18 Aug 2026 10:58:18 -0700 (PDT)
X-Received: by 2002:a17:90b:2541:b0:38d:eaec:4396 with SMTP id 98e67ed59e1d1-3933e5d2332mr40276108a91.11.1787075897859;
        Tue, 18 Aug 2026 10:58:17 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:58:17 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	ranjan.kumar@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 17/17] mpi3mr: Fix NULL pointer dereference on PCI error recovery
Date: Wed, 19 Aug 2026 04:44:26 +0530
Message-ID: <20260818231426.58105-18-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On a frozen PCI channel the driver unmaps the register window and frees
the interrupts, but leaves the firmware event workqueue running. An
event handler that is already in flight can still reach the register
window after it has been unmapped.

Stop event processing and drain the queue first, and start it again
when the channel resumes.

Fixes: 30bafe1774f0 ("scsi: mpi3mr: Support PCI Error Recovery callback handlers")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index c740a64164e5..6f1a9472675d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5972,6 +5972,8 @@ mpi3mr_pcierr_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 			return PCI_ERS_RESULT_DISCONNECT;
 		}
 
+		mrioc->stop_drv_processing = 1;
+		mpi3mr_cleanup_fwevt_list(mrioc);
 		scsi_block_requests(mrioc->shost);
 		mpi3mr_stop_watchdog(mrioc);
 		mpi3mr_cleanup_resources(mrioc);
@@ -6069,6 +6071,7 @@ static void mpi3mr_pcierr_resume(struct pci_dev *pdev)
 
 	if (mrioc->block_on_pci_err) {
 		mrioc->block_on_pci_err = false;
+		mrioc->stop_drv_processing = 0;
 		scsi_unblock_requests(shost);
 		mpi3mr_start_watchdog(mrioc);
 	}
