Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C68715AF6
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 19:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731268102; cv=none; b=GULkTNY5EEjhZCeKFOlMNN3NdMKFrwlFFd5zwFWAfOyWzbAI6IHf63l6OAh++mvUaVlQBfUP9mVeC4j21DPi4khE9bz/m2WOmkEak76HXgkX8MZMWWA6uNKrkkvJwGwVxh23LJ6z1QjDZBYuNg3WOTXJSLqqfdVB+ikwLbBBnt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731268102; c=relaxed/simple;
	bh=v1vop3wLystWxWfNX0dShT1GXWHJiATJWUH4po0Qv4o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WIYpNGJJuFxH8neZBmtNcwoWDB2xGvZGemHXa9zAVyilRBsA7xsfFTNDJewaNozOoHPc1ddprDc6F1Ya5RymN6E2X5z0up/1Qnk5+J1sObSIug1OFE1916o/GkH3vaSdD1OoIyiBE+/tU/NQVQH/VV+b+gC2FtUqT+7Im5Uws0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=CAm90DOU; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CAm90DOU"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2e3010478e6so3108138a91.1
        for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 11:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1731268099; x=1731872899; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ztCbQ341QzkrBAmVAh3XDeFXbULNdiUdZkV0xQ3oTSE=;
        b=CAm90DOUQHucsriGZYD4Xz5PksPstF9/c0sVUSnf0mtyR6YRl0hOpzABvoxljukn1y
         01TD4GyNBhjMd8q/xC0UaoO5v3pKp+MPXBY1NifVa9K3W0QWwpg2oDD8H43A2us9jYcS
         dEyEG8eo5q3MZb+7tdNrm2KXtVYvUdzIxOFnA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731268099; x=1731872899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ztCbQ341QzkrBAmVAh3XDeFXbULNdiUdZkV0xQ3oTSE=;
        b=apBWJeyQXUndTdBPDN4oNDGW9p7hyhY08V3YI6NEZtu4rIkceoGibIsZndY/PcerKz
         qBuw0q5rwojzAuCq2aoJBHdP/+karIXagh2II+Kq1DsjEbaVa9fm39kCEZrM39Vl8N/k
         WwWSuXWZHet1vPzMAxslQR4zKIhE2jTrG8v01nHEV1MqPDslD4ByDXbxx5CjBa7Ny0no
         QCgFCF1T9xC8phldePewp0IAHV8bRWCONuQawdklGCSK1ySKClYDpDn5Ec4OYZ6FbT+t
         Q+byVsqMZwhA+n+QDZfX9O6OEOOo4qacEgQX1j1itMYqeumtFnxnv6JQhPn3VWl2cW2H
         7uuQ==
X-Gm-Message-State: AOJu0YzjwZ3rIny8Mqlu5wBa77eM1BxGlzkrMLYZpeemNvabkgPJq479
	g3Z/eMsvviVRl3Iy1FMew34Q2L1fKQt3IClSh7PSVRFGF7acoG9u5vBuvw5UupiWQF7EUFcgX5T
	JEfV2yIxa9aIbEQK1hrCxi4kd2YxcUT/F7yjPx5Fywdcp0GNvL88/tpCUcVU2nHlJsWfJiAqmRr
	vXbx+whFNYEZLZiMaJZtAP/338FH8xoVQ1ql1iAtHJGthAhw==
X-Google-Smtp-Source: AGHT+IEDRJm9tl05MLSGxKivPVfmfrKYiDTKxrtAX5d07tFBnZqufLuZFgfUPUZhs9vNa0epoa5mXQ==
X-Received: by 2002:a17:90b:3911:b0:2e2:f04d:9f0d with SMTP id 98e67ed59e1d1-2e9b170c3camr14815670a91.16.1731268099359;
        Sun, 10 Nov 2024 11:48:19 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e9b50dcd9bsm4867586a91.21.2024.11.10.11.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 11:48:18 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 4/5] mpi3mr: Handling of fault code for insufficient power
Date: Mon, 11 Nov 2024 01:14:04 +0530
Message-Id: <20241110194405.10108-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241110194405.10108-1-ranjan.kumar@broadcom.com>
References: <20241110194405.10108-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During load, modified the driver to check and fail
before retrying the initialization for faults if
the fault code for the in-sufficient power. And also
modified the driver to check and mark the controller
as unrecoverable instead of issuing reset in the
watch dog timer if the fault code for the in-sufficient power.

Signed-off-by: Prayas Patel <prayas.patel@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 2e6245bd4282..5ed31fe57474 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1035,6 +1035,36 @@ static const char *mpi3mr_reset_type_name(u16 reset_type)
 	return name;
 }
 
+/**
+ * mpi3mr_is_fault_recoverable - Read fault code and decide
+ * whether the controller can be recoverable
+ * @mrioc: Adapter instance reference
+ * Return: true if fault is recoverable, false otherwise.
+ */
+static inline bool mpi3mr_is_fault_recoverable(struct mpi3mr_ioc *mrioc)
+{
+	u32 fault;
+
+	fault = (readl(&mrioc->sysif_regs->fault) &
+		      MPI3_SYSIF_FAULT_CODE_MASK);
+
+	switch (fault) {
+	case MPI3_SYSIF_FAULT_CODE_COMPLETE_RESET_NEEDED:
+	case MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED:
+		ioc_warn(mrioc,
+		    "controller requires system power cycle, marking controller as unrecoverable\n");
+		return false;
+	case MPI3_SYSIF_FAULT_CODE_INSUFFICIENT_PCI_SLOT_POWER:
+		ioc_warn(mrioc,
+		    "controller faulted due to insufficient power,\n"
+		    " try by connecting it to a different slot\n");
+		return false;
+	default:
+		break;
+	}
+	return true;
+}
+
 /**
  * mpi3mr_print_fault_info - Display fault information
  * @mrioc: Adapter instance reference
@@ -1373,6 +1403,11 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 	ioc_info(mrioc, "ioc_status(0x%08x), ioc_config(0x%08x), ioc_info(0x%016llx) at the bringup\n",
 	    ioc_status, ioc_config, base_info);
 
+	if (!mpi3mr_is_fault_recoverable(mrioc)) {
+		mrioc->unrecoverable = 1;
+		goto out_device_not_present;
+	}
+
 	/*The timeout value is in 2sec unit, changing it to seconds*/
 	mrioc->ready_timeout =
 	    ((base_info & MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_MASK) >>
@@ -2734,6 +2769,11 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	mpi3mr_print_fault_info(mrioc);
 	mrioc->diagsave_timeout = 0;
 
+	if (!mpi3mr_is_fault_recoverable(mrioc)) {
+		mrioc->unrecoverable = 1;
+		goto schedule_work;
+	}
+
 	switch (trigger_data.fault) {
 	case MPI3_SYSIF_FAULT_CODE_COMPLETE_RESET_NEEDED:
 	case MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED:
-- 
2.31.1

