Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696B9278E71
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2025 11:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744370363; cv=none; b=btqVlK30DUiiVlGcBPS6Un/9cS11sk5TM1TcvsR1/NyO5VvhcaP1xFzjc1VCvI/87USjqidQ7ZC2CNlvI33JfuWEoJXxwv+r5RW9RrOI6xQiSkz2rq+CmN1mz9ol49F3dQqpKEvy3NseUbINCAdv1CvuHCzoEXzVdfdqCUM353M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744370363; c=relaxed/simple;
	bh=ZN6/Z5nSCfpz8ee+8Vf/JI1w39/NLe6Ltjd7nMki7tE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=genmA2wKZIIEpf+oIaPqTOLrUZ9N+G7mNXMo/0lpyerAGahIJWc6amuxcKvvWa+FBWAJIL3KVlOOOObof4hEmknKy6HRUCP9wEgPixu63HM5EPflQRMEPLKaGfRYqX7onMCaJsVZmR4v35plo1wxaYPRnHO0ku1R4UlE/7qPpzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=S0ZcFy77; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="S0ZcFy77"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso1801912b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2025 04:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1744370361; x=1744975161; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2grBUE+ByEyrq24CTT/4/1EgXXaYZslkW9YGFS6AGM=;
        b=S0ZcFy77f13AHXg6BsqkdnYiNGBxiQsEReXdokNnBSdDrwssSPwR3fUX9a6M1Sees7
         hv9QBYCklI9+lSUvByMWojB4QlLF5JWztZH2f0RtTbqEg1ESyIHxIFhcvwq8y1roOllO
         gfE5mdqbU3QWDUCQEe7zaaqp5C4rNMnodfUDg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744370361; x=1744975161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X2grBUE+ByEyrq24CTT/4/1EgXXaYZslkW9YGFS6AGM=;
        b=VCr0Om1+B9XoC/J6aASIkDoSGVAK5kZGBq/qQcR90GLOZNDDbwL5zP/FK+5wLDXbMH
         7qXcZgZOFuhHgCmk3IIVfRXFBz6i0ktxamvJ8si+Tla5tgQat6ZqB1vM5XTNXoWHp0cm
         4gF5WC4za0HzIWpX2WqLti4D7SKqZvfeOMwEUX5elKoAUcUE4z9wHF6hE9mFOqDf6kkN
         nSZvyLZBQHc9fdNZptollCPwuRv61QBSew7+rPSdCclM3EOxZRhVi35GZHnrM9P6gROw
         Db047+hqqESnWmD77ETFP1IZ+a/6FFbo82VqaWNNNrAiGy7Jh5macS5xBmF7v79alfzp
         lUyw==
X-Gm-Message-State: AOJu0YwtmaXjThckIRl4lugj35bghe7ltED7cSpxk1oZnnmHqZBKozcG
	QgFND9iKooXbY+1gA8h0eVQp8E1SI5vUWyF+TompPp/kADZSvdNZRTcJYlC8r5Oy03Vb4dUj5Rm
	gHhDo2eDtHZ22kTaxzv1BFhgd3PSV7gxSr9ES/Y1MpVizyVf1EINRrB9HwuFpk3VCRLQ1Ihsxf2
	ORflKktPkmK4hoaZHZVWP5e+qxyMFLrn61NbjYjEaWiPK6BQ==
X-Gm-Gg: ASbGncthKisRjMKeG1XtkC98LPTa64zuQP2LjbkhODY1VpxdZ5wQk0La+Z4LE4O1Jvs
	/R0R4BW7/RkkqNVTvcgWImlmYvpM8rgfXo16jK1BjD8BrZ7jIg5cAWqwJLAtkSW4/ZvXiGE+smJ
	AzURFIVJB8uEbk8BHxfCjBsMu7XCXtpH5D2/I97vtPgWHejrEVVZtapdcGWyfTzNFgB8ezkVwO/
	z3m7T9UvMMCChdI7mGhAK/3XsnE1bH+DXEMM6V9GZnrVqfeCUCgnnbxGJNpKGzmLfBeJOoHod1a
	TXMF+dHiCmJ1FFBWVPAppTobG+lZO8nuUNx72PH9xdCddlLgRSpWlIMeotaHMDNREU6jlYwM2xP
	lo0z6bMgQ
X-Google-Smtp-Source: AGHT+IGprhVvqVGaozZMc8xBNscavP2bL0ESOlMdW8m8pbBaONLhNIwuFHxK+ZsceFIKpApgsfp20Q==
X-Received: by 2002:a05:6a00:21c4:b0:736:ba49:97bb with SMTP id d2e1a72fcca58-73bd11a8470mr3102242b3a.5.1744370360568;
        Fri, 11 Apr 2025 04:19:20 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd21c65c9sm1266920b3a.61.2025.04.11.04.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Apr 2025 04:19:20 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	tadamsjr@google.com,
	vishakhavc@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	stable@vger.kernel.org
Subject: [PATCH v1 2/2] mpi3mr: resets the pending interrupt flag
Date: Fri, 11 Apr 2025 16:44:19 +0530
Message-Id: <20250411111419.135485-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250411111419.135485-1-ranjan.kumar@broadcom.com>
References: <20250411111419.135485-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If an admin interrupt is missed, admin_pend_isr may stay set and
trigger admin reply processing even when no admin IOs are pending.
Clearing/Resetting it in the admin completion path prevents this.

Fixes: ca41929b2ed5 ("scsi: mpi3mr: Check admin reply queue from Watchdog")
Cc: stable@vger.kernel.org
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index d6e402aacb2a..003e1f7005c4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -451,6 +451,7 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 		return 0;
 	}
 
+	atomic_set(&mrioc->admin_pend_isr, 0);
 	reply_desc = (struct mpi3_default_reply_descriptor *)mrioc->admin_reply_base +
 	    admin_reply_ci;
 
@@ -2925,6 +2926,7 @@ static int mpi3mr_setup_admin_qpair(struct mpi3mr_ioc *mrioc)
 	mrioc->admin_reply_ci = 0;
 	mrioc->admin_reply_ephase = 1;
 	atomic_set(&mrioc->admin_reply_q_in_use, 0);
+	atomic_set(&mrioc->admin_pend_isr, 0);
 
 	if (!mrioc->admin_req_base) {
 		mrioc->admin_req_base = dma_alloc_coherent(&mrioc->pdev->dev,
@@ -4653,6 +4655,7 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 	if (mrioc->admin_reply_base)
 		memset(mrioc->admin_reply_base, 0, mrioc->admin_reply_q_sz);
 	atomic_set(&mrioc->admin_reply_q_in_use, 0);
+	atomic_set(&mrioc->admin_pend_isr, 0);
 
 	if (mrioc->init_cmds.reply) {
 		memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));
-- 
2.31.1

