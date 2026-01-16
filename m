Received: from mail-yw1-f227.google.com (mail-yw1-f227.google.com [209.85.128.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C858F34D3A1
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 06:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768544050; cv=none; b=HT7WC11g/dXZL+gmwxrCv3781gUQ2mwHffLi2ZIwyXXfNcvZzJVgNzsTX4uPLtznXjbuOPo3frwGHV21bjFB0Ys/+X7MgSCShZ0mO0nLBciWrJqMg/O4V8eCTjHnWYUPoUzl0JlsbfHsnK+pL154moV4gkQVsz/G09IZB9RF4Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768544050; c=relaxed/simple;
	bh=rs323bmbyJgxl+Z5j3UEUauCa43tFvegft/V7RKmeFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxhU2clGNakzNZXPlE6xgr4c53DkP3NaN4YLnJel4tF00cu+QKGM942Q47+YDWZydeCdA3YSFuX/fk0l/xMWoWTaP+H9u2cLxlqWkt/YYo+Rya3034jhvR9J3aEfIfszNkTQwfh07nbbUQq1BguxeFOwaKvmal+syoKOgbJZWTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=d4vXn/Yw; arc=none smtp.client-ip=209.85.128.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="d4vXn/Yw"
Received: by mail-yw1-f227.google.com with SMTP id 00721157ae682-78fb9a67b06so16626907b3.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:14:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768544048; x=1769148848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7irBZtLTHwAAWMcKesBJnbUxg401HXQva+4z2jxDs80=;
        b=tNwAs5SJsPVQuD/eR13rljEK9xeD+zFxbx/1fRewUqdaX1+MZKJwRs1q4UUyNjIK/p
         KrIV37cs+B+MMTnazwQLRnPKd+qNSqPxQrw+lrWajS54Evw0M5YCdi29ImTa/zPpL89u
         mK2Uy9t/tnYGFEtiike2ogDVTArvBED9qIuZ1FU2ej8INuDZZllZhy6vvaMhcrzEl7dB
         XxTp3fffe2tZ/Z3pN0Qb2+xikmizd8fJwHjqLyxuSpSu+inr6oYOk8T26kAM+wpnuN1u
         uhN+XfebNmjmu5GEZeumHR2R+LdHEvi3dhI0v39Deb1hk3HU9GzscOKNKg4CYgXcC7JO
         WzEw==
X-Gm-Message-State: AOJu0YwPBbVtEpynzbkstnuFsi8BIsZSPYdAOcpEm6G+BuBmByZTfoE5
	Nw+Z0MnBXErBy5u6HuD1qaxYFIqo6IQRpN0LkdmPUWxuZxxbmdeY3Fm+DuWeATDCMaBhwbUfDP+
	ds3VGrm0Sb15EoyZJ2bWzkIIC0ZFAPJPB5g6zOTRA13PYmeSO9f0fDivDC0aXWJ27fOr451tQNu
	7AmOLAL3ATxOJeT5VOZiy5U1XM0mNM0LR1uRc4ahFAYgws92drpxJZHx9A5ORYAb9ABMspZVpJO
	uRIR0U9BGwgu8sC
X-Gm-Gg: AY/fxX4mw9qTOV/D9QFNjc4bpkHTjYM4IC7SoHbNnkhrO0IKJjGHvR5E0SoW0s5sDGK
	HWG95+yh6bHWLR82RSU5N+0kUNaEVzKrtV/BPc2UZxXwotPCJNpk7PdHPja7BWzQ48BOjDJOyzT
	X6f3DbVIWUbwiaceO4O4AFmrw20kzmuBmleFXso1FadXURV28+AlK1xc9hwopfmTzpAllC66pKl
	o86SUKHIVZMlYzHqjlpuNPaYe6FpWdSX1IW0xPSk8q8fSBh5wT/XdXio7GH3TB2JDRItLv152zM
	a1qWt64s9mWXJe7ckBakdnBv0ZC8nla2wOq/WUD8z2nn2xUvhwkTQ4GgOFua9q6eAK29pXPCSs9
	D2jjHgHZcooO/SED3shS7XviW6dsi5uYZCJVgopXpb+6ITnnDv0SH33eetsgk3lJramVHvJFkZZ
	G8FXC0cJCCelLemXdSSpPPWApINphdoxed+3zjjspr6Q==
X-Received: by 2002:a05:690c:fc5:b0:78f:f375:a1ff with SMTP id 00721157ae682-793c66b8f37mr13173407b3.4.1768544047820;
        Thu, 15 Jan 2026 22:14:07 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-793c6816ebcsm881417b3.16.2026.01.15.22.14.07
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jan 2026 22:14:07 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34ea5074935so1500633a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768544046; x=1769148846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7irBZtLTHwAAWMcKesBJnbUxg401HXQva+4z2jxDs80=;
        b=d4vXn/YwVMxsxCRVdTV8+J7JbiMVZO39X7zex5kdXzV9mxYatgCNmVQ43DXKzGHcxP
         VZ8JP5kxeDc0PG2JxkxqIOkzkEMv+TzHwH3meGI7t7oGqv+L6WVEL5atldajbEm9wYiT
         e+/xhfzwlNqNSX48sS0AF28UiqtF6aVqpqWmM=
X-Received: by 2002:a17:902:fc86:b0:295:9db1:ff3a with SMTP id d9443c01a7336-2a7188fc362mr17932795ad.28.1768544046213;
        Thu, 15 Jan 2026 22:14:06 -0800 (PST)
X-Received: by 2002:a17:902:fc86:b0:295:9db1:ff3a with SMTP id d9443c01a7336-2a7188fc362mr17932505ad.28.1768544045641;
        Thu, 15 Jan 2026 22:14:05 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a71941bd9bsm10231315ad.93.2026.01.15.22.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 22:14:05 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 6/8] mpi3mr: Record and report controller firmware faults
Date: Fri, 16 Jan 2026 11:37:17 +0530
Message-ID: <20260116060719.32937-7-ranjan.kumar@broadcom.com>
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

Capture and retain firmware fault codes and extended fault information
whenever the controller enters a fault state.

Maintain a persistent firmware fault counter, expose it via sysfs,
and generate uevents to aid userspace diagnostics and failure analysis.

Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |   8 +++
 drivers/scsi/mpi3mr/mpi3mr_app.c |  24 +++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 103 +++++++++++++++++++++++++++++++
 3 files changed, 135 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index eee6cb40a960..6a0291708113 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1136,6 +1136,10 @@ struct scmd_priv {
  * @default_qcount: Total Default queues
  * @active_poll_qcount: Currently active poll queue count
  * @requested_poll_qcount: User requested poll queue count
+ * @fault_during_init: Indicates a firmware fault occurred during initialization
+ * @saved_fault_code: Firmware fault code captured at the time of failure
+ * @saved_fault_info: Additional firmware-provided fault information
+ * @fwfault_counter: Count of firmware faults detected by the driver
  * @bsg_dev: BSG device structure
  * @bsg_queue: Request queue for BSG device
  * @stop_bsgs: Stop BSG request flag
@@ -1338,6 +1342,10 @@ struct mpi3mr_ioc {
 	u16 default_qcount;
 	u16 active_poll_qcount;
 	u16 requested_poll_qcount;
+	u8 fault_during_init;
+	u32 saved_fault_code;
+	u32 saved_fault_info[3];
+	u64 fwfault_counter;
 
 	struct device bsg_dev;
 	struct request_queue *bsg_queue;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 37cca0573ddc..1353a8ff9c85 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -3255,6 +3255,29 @@ adp_state_show(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR_RO(adp_state);
 
+/**
+ * fwfault_count_show() - SysFS callback to show firmware fault count
+ * @dev: class device
+ * @attr: Device attribute
+ * @buf: Buffer to copy data into
+ *
+ * Displays the total number of firmware faults detected by the driver
+ * since the controller was initialized.
+ *
+ * Return: Number of bytes written to @buf
+ */
+
+static ssize_t
+fwfault_count_show(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", mrioc->fwfault_counter);
+}
+static DEVICE_ATTR_RO(fwfault_count);
+
 static struct attribute *mpi3mr_host_attrs[] = {
 	&dev_attr_version_fw.attr,
 	&dev_attr_fw_queue_depth.attr,
@@ -3263,6 +3286,7 @@ static struct attribute *mpi3mr_host_attrs[] = {
 	&dev_attr_reply_qfull_count.attr,
 	&dev_attr_logging_level.attr,
 	&dev_attr_adp_state.attr,
+	&dev_attr_fwfault_count.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 6debe81a1e5b..2abf87c4e76b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1108,6 +1108,31 @@ void mpi3mr_print_fault_info(struct mpi3mr_ioc *mrioc)
 	}
 }
 
+/**
+ * mpi3mr_save_fault_info - Save fault information
+ * @mrioc: Adapter instance reference
+ *
+ * Save the controller fault information if there is a
+ * controller fault.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_save_fault_info(struct mpi3mr_ioc *mrioc)
+{
+	u32 ioc_status, i;
+
+	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
+
+	if (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT) {
+		mrioc->saved_fault_code = readl(&mrioc->sysif_regs->fault) &
+		    MPI3_SYSIF_FAULT_CODE_MASK;
+		for (i = 0; i < 3; i++) {
+			mrioc->saved_fault_info[i] =
+			readl(&mrioc->sysif_regs->fault_info[i]);
+		}
+	}
+}
+
 /**
  * mpi3mr_get_iocstate - Get IOC State
  * @mrioc: Adapter instance reference
@@ -1249,6 +1274,60 @@ static void mpi3mr_alloc_ioctl_dma_memory(struct mpi3mr_ioc *mrioc)
 	mpi3mr_free_ioctl_dma_memory(mrioc);
 }
 
+/**
+ * mpi3mr_fault_uevent_emit - Emit uevent for any controller
+ * fault
+ * @mrioc: Pointer to the mpi3mr_ioc structure for the controller instance
+ *
+ * This function is invoked when the controller undergoes any
+ * type of fault.
+ */
+
+static void mpi3mr_fault_uevent_emit(struct mpi3mr_ioc *mrioc)
+{
+	struct kobj_uevent_env *env;
+	int ret;
+
+	env = kzalloc(sizeof(*env), GFP_KERNEL);
+	if (!env)
+		return;
+
+	ret = add_uevent_var(env, "DRIVER=%s", mrioc->driver_name);
+	if (ret)
+		goto out_free;
+
+	ret = add_uevent_var(env, "IOC_ID=%u", mrioc->id);
+	if (ret)
+		goto out_free;
+
+	ret = add_uevent_var(env, "FAULT_CODE=0x%08x",
+			    mrioc->saved_fault_code);
+	if (ret)
+		goto out_free;
+
+	ret = add_uevent_var(env, "FAULT_INFO0=0x%08x",
+			     mrioc->saved_fault_info[0]);
+	if (ret)
+		goto out_free;
+
+	ret = add_uevent_var(env, "FAULT_INFO1=0x%08x",
+			    mrioc->saved_fault_info[1]);
+	if (ret)
+		goto out_free;
+
+	ret = add_uevent_var(env, "FAULT_INFO2=0x%08x",
+			    mrioc->saved_fault_info[2]);
+	if (ret)
+		goto out_free;
+
+	kobject_uevent_env(&mrioc->shost->shost_gendev.kobj,
+			KOBJ_CHANGE, env->envp);
+
+out_free:
+	kfree(env);
+
+}
+
 /**
  * mpi3mr_clear_reset_history - clear reset history
  * @mrioc: Adapter instance reference
@@ -1480,6 +1559,10 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 		if (ioc_state == MRIOC_STATE_FAULT) {
 			timeout = MPI3_SYSIF_DIAG_SAVE_TIMEOUT * 10;
 			mpi3mr_print_fault_info(mrioc);
+			mpi3mr_save_fault_info(mrioc);
+			mrioc->fault_during_init = 1;
+			mrioc->fwfault_counter++;
+
 			do {
 				host_diagnostic =
 					readl(&mrioc->sysif_regs->host_diagnostic);
@@ -2577,6 +2660,9 @@ void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code)
 		mpi3mr_set_trigger_data_in_all_hdb(mrioc,
 		    MPI3MR_HDB_TRIGGER_TYPE_FAULT, &trigger_data, 0);
 		mpi3mr_print_fault_info(mrioc);
+		mpi3mr_save_fault_info(mrioc);
+		mrioc->fault_during_init = 1;
+		mrioc->fwfault_counter++;
 		return;
 	}
 
@@ -2594,6 +2680,10 @@ void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code)
 			break;
 		msleep(100);
 	} while (--timeout);
+
+	mpi3mr_save_fault_info(mrioc);
+	mrioc->fault_during_init = 1;
+	mrioc->fwfault_counter++;
 }
 
 /**
@@ -2770,6 +2860,11 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	union mpi3mr_trigger_data trigger_data;
 	u16 reset_reason = MPI3MR_RESET_FROM_FAULT_WATCH;
 
+	if (mrioc->fault_during_init) {
+		mpi3mr_fault_uevent_emit(mrioc);
+		mrioc->fault_during_init = 0;
+	}
+
 	if (mrioc->reset_in_progress || mrioc->pci_err_recovery)
 		return;
 
@@ -2842,6 +2937,10 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 		goto schedule_work;
 	}
 
+	mpi3mr_save_fault_info(mrioc);
+	mpi3mr_fault_uevent_emit(mrioc);
+	mrioc->fwfault_counter++;
+
 	switch (trigger_data.fault) {
 	case MPI3_SYSIF_FAULT_CODE_COMPLETE_RESET_NEEDED:
 	case MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED:
@@ -5475,6 +5574,10 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 					break;
 				msleep(100);
 			} while (--timeout);
+
+			mpi3mr_save_fault_info(mrioc);
+			mpi3mr_fault_uevent_emit(mrioc);
+			mrioc->fwfault_counter++;
 			mpi3mr_set_trigger_data_in_all_hdb(mrioc,
 			    MPI3MR_HDB_TRIGGER_TYPE_FAULT, &trigger_data, 0);
 		}
-- 
2.47.3

