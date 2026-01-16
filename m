Received: from mail-yw1-f227.google.com (mail-yw1-f227.google.com [209.85.128.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F3734C981
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 06:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768544052; cv=none; b=EVJtg3tNR7Pfq4FB6F3krfzvjLCF8aQ1+EshcFb4DtXpEiMQad3jCIV6SIY4GS3bIWOWrzIPUwjLqB1wnWexh0aaOz0hYBrxVeoq+pee94Q4zDhweaW9QFrUxCtFsPDxgAv9V+qGKfS5Ay6AuCUux+byQjpJ7czQN5g1HI5FTBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768544052; c=relaxed/simple;
	bh=SjkIoLq355h0UBpBxszC7cjGTVDHcA70MhbLQAKAGfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJ3fLH4l4g83jQejazqRXj6JCYnuK1A9pmte+uSI0UPll8dh5APAVkw1EfRLBncLjjyH2DD0XUR5Ql2Il3VVzGfUcM+Qx+jsLjHd9T9BpldCeRKtS3RdPOddRAq7jZGFf8AlsM9NbjMPCcsPXs2uWF83tsOgTC+heCuwnvZVTLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=N+K7FR3A; arc=none smtp.client-ip=209.85.128.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="N+K7FR3A"
Received: by mail-yw1-f227.google.com with SMTP id 00721157ae682-78d6a3c3b77so31113737b3.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:14:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768544050; x=1769148850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m/NrlSycoKKxnF3uoLbYXuxzQfOQc/3BzjTP2uCX9Cg=;
        b=CxM15zcUZsCZM1B9S00y6Dp9G+pUeWf97/bf+3wlZmm0KTTFga08Vlz2DZExfIdxeH
         5aW4k2eoMUcxjsurvGDBxk/nILRJlw0mLoJJUvZ2MHWC9N51BR0Cpe10cTtrCJmrav/z
         9kUjC9k2aBRUFHwxypNH9Z7YFcT8QV0brigysuR0mFjWFajsetR5zRafvYFpm0OKePYp
         NRdYQjcuMNUCylqOsPxhYpG4+wzec2PXG05Px9ZyMdURaO8Yjj+9lCa0krKqRD2m2ZYj
         IXr3KwMeCT48A7nf1rMZfCvzW3rzr47EpUjbaU8i7RyJO/bNgaWZanYYkpE2HOusHkHa
         yoHA==
X-Gm-Message-State: AOJu0YzqiSjedXD6X9xTPHbCzW9HjrEpdmKyXX6JTrHZemYj6RfNgUEi
	3TZ0Uq1kmbNfKmsYkLw/q1tnfhR/AaftR/OXdThmYnombnIM3BhKYILtG7bK1E2RsmcC3brgF2p
	MlpnRMY+/xBVsa45z+WJ7RF9LY8O85lhf3ngss584Pivy0cLajoEerJ9bBoPho9dFfvatwbds6R
	3tA7zn+UfqupZ5wtzm7oAcg4yR8Qk363HPn/K3D/MFkttGG9MMYNhiLZMYPloEpknzcMOr+jCiB
	M1ii12s7/6FIwbF
X-Gm-Gg: AY/fxX7x9rEkNc1z6+hdxjXouIFKKfsHCsO/S36VAxk0EnEDXYK/+dsSBBSo+s504WH
	NAgyBOmn20EpPqyUNmKl0H05xr8Rvl+9P5cGrKNwfOAlW2DdTgccVOzNwSIa4nsY4AlPvxaqtEU
	Zmbx/h+W/3Jywi4A2tJRej9K2ngSSigr5SkMIVE99N4RivMEI/0IxohNNjebzhu+0HkTJbOkxiH
	u+q3CzPJg4dWvsQ5eDtmpfDXfKMuVKcveHB1AlrupT6yJA7TSnBTj1sOsbdavJSsU+4uaKPKts+
	ogsBu3LUdXQmM2LjVRD851VqHsMnrvSJZCaWQMLTYhbDf/QAYdgFScX4aHjo55EqEiBjkApVBZW
	MetuXhf8IJynedw5ZTKx3fZ04C7XCSKO+6pLv5qW17AHjCSFUk/mgwbabyayQQ8O/xQ+1GMgJfw
	W/7BtPHeH6/RUWYbIMAcSiHANRbI8fdlhlZsmVVfN9wWDRdPA=
X-Received: by 2002:a05:690c:fc5:b0:787:fff5:b10b with SMTP id 00721157ae682-793c57f0d21mr16983507b3.13.1768544050466;
        Thu, 15 Jan 2026 22:14:10 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-793c66c7301sm895257b3.7.2026.01.15.22.14.10
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jan 2026 22:14:10 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c5e56644646so1410039a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768544049; x=1769148849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m/NrlSycoKKxnF3uoLbYXuxzQfOQc/3BzjTP2uCX9Cg=;
        b=N+K7FR3AiQ/YV5dMWmigElWtoM8jjNrryBDRdxlzW5eE47bEwILdxSoAkTs2J4d9gV
         AuOZmRBXBfPI8jzIQl+QUYEWvXUHQY7GjMlmdK3JXNLI4RwjCWqroolGzi38lQTefdOQ
         Lphr90fU4QJ59UFdxZ4ZZXOnOCekRAYncu140=
X-Received: by 2002:a17:902:ef0a:b0:298:639b:a64f with SMTP id d9443c01a7336-2a71754671fmr21413305ad.6.1768544049004;
        Thu, 15 Jan 2026 22:14:09 -0800 (PST)
X-Received: by 2002:a17:902:ef0a:b0:298:639b:a64f with SMTP id d9443c01a7336-2a71754671fmr21413105ad.6.1768544048581;
        Thu, 15 Jan 2026 22:14:08 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a71941bd9bsm10231315ad.93.2026.01.15.22.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 22:14:08 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 7/8] mpi3mr: Fixed the W=1 compilation warning
Date: Fri, 16 Jan 2026 11:37:18 +0530
Message-ID: <20260116060719.32937-8-ranjan.kumar@broadcom.com>
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

Fixed W=1 compilation warnings

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 6 +++---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 6 ++++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 2abf87c4e76b..1cfbdb773353 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -776,8 +776,8 @@ static inline int mpi3mr_request_irq(struct mpi3mr_ioc *mrioc, u16 index)
 	intr_info->msix_index = index;
 	intr_info->op_reply_q = NULL;
 
-	snprintf(intr_info->name, MPI3MR_NAME_LENGTH, "%s%d-msix%d",
-	    mrioc->driver_name, mrioc->id, index);
+	scnprintf(intr_info->name, MPI3MR_NAME_LENGTH,
+	    "%.32s%d-msix%u", mrioc->driver_name, mrioc->id, index);
 
 #ifndef CONFIG_PREEMPT_RT
 	retval = request_threaded_irq(pci_irq_vector(pdev, index), mpi3mr_isr,
@@ -1789,7 +1789,7 @@ static int mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type,
 	scratch_pad0 = ((MPI3MR_RESET_REASON_OSTYPE_LINUX <<
 	    MPI3MR_RESET_REASON_OSTYPE_SHIFT) | (mrioc->facts.ioc_num <<
 	    MPI3MR_RESET_REASON_IOCNUM_SHIFT) | reset_reason);
-	writel(reset_reason, &mrioc->sysif_regs->scratchpad[0]);
+	writel(scratch_pad0, &mrioc->sysif_regs->scratchpad[0]);
 	if (reset_type == MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT)
 		mpi3mr_set_diagsave(mrioc);
 	writel(host_diagnostic | reset_type,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 2fce5bfb7204..3b46275788c6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5475,8 +5475,10 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (retval < 0)
 		goto id_alloc_failed;
 	mrioc->id = (u8)retval;
-	sprintf(mrioc->driver_name, "%s", MPI3MR_DRIVER_NAME);
-	sprintf(mrioc->name, "%s%d", mrioc->driver_name, mrioc->id);
+	strscpy(mrioc->driver_name, MPI3MR_DRIVER_NAME,
+	    sizeof(mrioc->driver_name));
+	scnprintf(mrioc->name, sizeof(mrioc->name),
+	    "%s%u", mrioc->driver_name, mrioc->id);
 	INIT_LIST_HEAD(&mrioc->list);
 	spin_lock(&mrioc_list_lock);
 	list_add_tail(&mrioc->list, &mrioc_list);
-- 
2.47.3

