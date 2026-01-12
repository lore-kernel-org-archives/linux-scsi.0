Received: from mail-qt1-f226.google.com (mail-qt1-f226.google.com [209.85.160.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F59719992C
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 08:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768205845; cv=none; b=ee5ynsba0eNjjPqvJo27S1YzywSPL18ratexSWMicmNO0j3d4zvky4pCPWXaeQFC1Lmn9n0nAyBlZlcuujMtbFziBHi4FJ4Bu6y6iunCx46Q3CDuNxeBAGAAbEFuDkKx0eGZlj8/mVhQi8lORXe0biA6easy+1cumkNj6evE3/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768205845; c=relaxed/simple;
	bh=z+xEDtbn9FvJPHFO1czd568v7YLup81vjxBvdizWNtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9zkHFKznIPdzpVOFA0zFzOMyQVegln2uTy6ec6ZC+nvOhMWx6bR9ZVJIacYoD5RIb07BqSEn0ZCgP/Osfc/6QIKVGykIRrfwP3BWoOUGqqBo//EJiN4L3uuDF8Eb2drMLAHtNY4yA22OzxDu81IT2qB3AQeFKv/cH1CI0J1dxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Ib1crcC1; arc=none smtp.client-ip=209.85.160.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ib1crcC1"
Received: by mail-qt1-f226.google.com with SMTP id d75a77b69052e-4ee1939e70bso69417231cf.3
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 00:17:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768205843; x=1768810643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rITt6EkJ8vRBozq9wQKtCdxoluuvVRihjeN5uaAx+to=;
        b=Sfpwcx7K7jaTi1SE9zX2sSN/xeszJlqLFRM+f/jHNoh/Rjit3tIaUDvvggbwl7su38
         xBpD8DCtF6/6JXZg5iqHup0dnKOO7tfiaesr4iJeNgUF0dKuCqndpAXqOqLdxyu0T2gK
         XA3fKUmw7YhKEbNvKLPEtpWNHfunnjnlEveP9CGpPPdVhb4N5hpPn2hEk2DM2Q2wgZsv
         AHkh9CWnMZMH7bck3KBWWvBfqhzhixBtuhMjjEix1Nr8im7atNLJkAogAPYtB+nZR7+m
         oyp0rjWe/XIlIYZstPYeaVbk5wEK1PJvOleprONoHfB16kFYGPalniNDnHE50mshYHxT
         b5Aw==
X-Gm-Message-State: AOJu0YzfOpMSRE58qgXmvYBFw/yYU3MVLrULdIb8AeY4oA5znAXSGNAR
	5a4bZg4ntzN9gTTS2H72hIWezuunzV57M/dievAMICilT9Eg/EhpJzreCnQBizpp7+pbuTE3/Wb
	3Mme4o02KeP5dyzDQABvLrCk5ylcn9ZPv1JAJg2Rmz4wU3tfylpXVLwNzBTi7ZdGWEMmOkBM80q
	g58uo3GQWotnveVFKEShH8yKqMxoEgedPibbMj4sUEIGRzFHSHGeDDrsLHPflC4FxrglaeJX14M
	RC0X2OPJUtSF20c
X-Gm-Gg: AY/fxX6ntpkRxnl0uf4KMSqupDYnr2vWW535BwnyQucAzD2zuvS2kr6Fwc+ISG1qFgS
	I+hnzlse50JErjYeQ/mpdrLbGamzd6FuRDyFwSYXeDkZHaFa/8gQQ6poCL47daoc65plN7wZCMF
	+bCtsJkK6YRAReVDKb0dup8XhRLzEPviNR5WWqHURX8VVb89SU/6kZq2akzHaFNnUWIuDCSX/fY
	KU3xmkzPvTp7iHRHyDfauzY5qsPww4ikcQJAAo6HbCNk7R0rzZwcPZVm12FgCr++BkAQJDwxL+i
	6FSskCjw1u9Ura3SUd6mlzodAJC7qUSnvkTgZX7ApTBzxs0vy1ySzvwz9uDc7rOAGFH7zfCN0kw
	CDjMB3fpVu9pt2fKhCNgBKYzkHlOYaACNTidZf+iD4h/Tet76XBli0k2Uqugm1p94uVtE3pMuot
	Z8cwOvmBmFgCfyOKpjydcG5WaI80uNqS0yuBuvh+G+YmvWDZo=
X-Google-Smtp-Source: AGHT+IG6McmzymRa2eB/YZDxMOGPHcORrUR4DUxP6XZMFBcLhKlpHILIMftxh5UrZuhvDWT1iy852+Xnk3/5
X-Received: by 2002:a05:622a:209:b0:4f1:c698:6e9e with SMTP id d75a77b69052e-4ffb482ffa8mr232261771cf.27.1768205842892;
        Mon, 12 Jan 2026 00:17:22 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-890770946f9sm22184386d6.5.2026.01.12.00.17.22
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jan 2026 00:17:22 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34c48a76e75so6540410a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 00:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768205841; x=1768810641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rITt6EkJ8vRBozq9wQKtCdxoluuvVRihjeN5uaAx+to=;
        b=Ib1crcC1HCe24oiYixXKeHANpAv4a302MyjmueeiU1eTnR8RYAe8IktC34VPPyoE6j
         jPF3sqkrjiDq94A6NrNuGU0cXFoQF4OvpoLK4STXtKKwXqBPRhC146DJf0sgxdz1gnjA
         TanSrKYMh2VT7/wYQi2TJn6WtvBuZ7gquNqZs=
X-Received: by 2002:a17:90b:560f:b0:341:d265:1e82 with SMTP id 98e67ed59e1d1-34f68cb94ffmr15294825a91.29.1768205841282;
        Mon, 12 Jan 2026 00:17:21 -0800 (PST)
X-Received: by 2002:a17:90b:560f:b0:341:d265:1e82 with SMTP id 98e67ed59e1d1-34f68cb94ffmr15294801a91.29.1768205840720;
        Mon, 12 Jan 2026 00:17:20 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5f8b1526sm16808659a91.14.2026.01.12.00.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 00:17:20 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 6/7] mpi3mr: Record and report controller firmware faults
Date: Mon, 12 Jan 2026 13:40:36 +0530
Message-ID: <20260112081037.74376-7-ranjan.kumar@broadcom.com>
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

Capture and retain firmware fault codes and extended fault information
whenever the controller enters a fault state.

Maintain a persistent firmware fault counter, expose it via sysfs,
and generate uevents to aid userspace diagnostics and failure analysis.

Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  8 +++
 drivers/scsi/mpi3mr/mpi3mr_app.c | 24 +++++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 87 ++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 590c017acf25..58db60e13c13 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1137,6 +1137,10 @@ struct scmd_priv {
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
@@ -1340,6 +1344,10 @@ struct mpi3mr_ioc {
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
index 178738850541..ea951ef4b2d9 100644
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
@@ -1249,6 +1274,44 @@ static void mpi3mr_alloc_ioctl_dma_memory(struct mpi3mr_ioc *mrioc)
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
+
+	env = kzalloc(sizeof(*env), GFP_KERNEL);
+	if (!env)
+		return;
+
+	if (add_uevent_var(env, "DRIVER=%s", mrioc->driver_name))
+		return;
+	if (add_uevent_var(env, "IOC_ID=%u", mrioc->id))
+		return;
+	if (add_uevent_var(env, "FAULT_CODE=0x%08x", mrioc->saved_fault_code))
+		return;
+	if (add_uevent_var(env, "FAULT_INFO0=0x%08x",
+	     mrioc->saved_fault_info[0]))
+		return;
+	if (add_uevent_var(env, "FAULT_INFO1=0x%08x",
+	     mrioc->saved_fault_info[1]))
+		return;
+	if (add_uevent_var(env, "FAULT_INFO2=0x%08x",
+	    mrioc->saved_fault_info[2]))
+		return;
+
+	kobject_uevent_env(&mrioc->shost->shost_gendev.kobj,
+	    KOBJ_CHANGE, env->envp);
+	kfree(env);
+}
+
 /**
  * mpi3mr_clear_reset_history - clear reset history
  * @mrioc: Adapter instance reference
@@ -1480,6 +1543,10 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
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
@@ -2577,6 +2644,9 @@ void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code)
 		mpi3mr_set_trigger_data_in_all_hdb(mrioc,
 		    MPI3MR_HDB_TRIGGER_TYPE_FAULT, &trigger_data, 0);
 		mpi3mr_print_fault_info(mrioc);
+		mpi3mr_save_fault_info(mrioc);
+		mrioc->fault_during_init = 1;
+		mrioc->fwfault_counter++;
 		return;
 	}
 
@@ -2594,6 +2664,10 @@ void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code)
 			break;
 		msleep(100);
 	} while (--timeout);
+
+	mpi3mr_save_fault_info(mrioc);
+	mrioc->fault_during_init = 1;
+	mrioc->fwfault_counter++;
 }
 
 /**
@@ -2770,6 +2844,11 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	union mpi3mr_trigger_data trigger_data;
 	u16 reset_reason = MPI3MR_RESET_FROM_FAULT_WATCH;
 
+	if (mrioc->fault_during_init) {
+		mpi3mr_fault_uevent_emit(mrioc);
+		mrioc->fault_during_init = 0;
+	}
+
 	if (mrioc->reset_in_progress || mrioc->pci_err_recovery)
 		return;
 
@@ -2842,6 +2921,10 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 		goto schedule_work;
 	}
 
+	mpi3mr_save_fault_info(mrioc);
+	mpi3mr_fault_uevent_emit(mrioc);
+	mrioc->fwfault_counter++;
+
 	switch (trigger_data.fault) {
 	case MPI3_SYSIF_FAULT_CODE_COMPLETE_RESET_NEEDED:
 	case MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED:
@@ -5478,6 +5561,10 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
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

