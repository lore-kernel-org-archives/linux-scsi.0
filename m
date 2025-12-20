Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3B2280033
	for <linux-scsi@vger.kernel.org>; Sat, 20 Dec 2025 07:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766215061; cv=none; b=g7huyfAT5tkOV9OFDGaPSugNnMZU0KQgp5d94nyCvvLQJaQ1HWS0YaxEXMgGuo2MA95RD0o8bFvgNzPmzALnFf2amiy2F/NEU73xfg6Vd2eKQ9D2DrKMkbwF4cojk8cqIZoPT1BacASrrmvxjf3qY01gBaM5czGI+Lk81H0R1rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766215061; c=relaxed/simple;
	bh=iABwZxh9fxx/El3byJGs9yluE8Abial/EkGNjCJe3YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jax5TA4PW4TsWNx4S0lngC5dnvOQ+CCi/GzeXZGnkYb7zxED04szCJdthqIYxAaMiBoGfUmBsAwDzIE1nQnMhiyad12xZzvZrPmm4enw+RxI0KEoBvChY8Rl4HGQjj6inRDGvlPLN1+M6NFPmeHFon+yGTCW4nCU63dMyOb9qQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OWq758fg; arc=none smtp.client-ip=74.125.82.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OWq758fg"
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-11beb0a7bd6so4994152c88.1
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 23:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766215058; x=1766819858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=50BOIvlH5SCR6RQlmb3P9L9nkf2GwjjwTZczrqAgn6I=;
        b=OWq758fgaA/qXn0/juR4eSHC6P6tqqfnCwlRhlhZqUublRl82h5WFyfPeVVkSJHRbn
         qw4nIwd4F6jr4iE/mBLwc0BQz6eXaIcYffzsPip5YUC2rfgdIn6N3dc60AuhjqTg1ihM
         /yEF57p4N1Nihi2/HDp8P1JbBvVbPTcGcn3RdAJtmVJV4ZgpkCbdpMMzm60+boWMcfYB
         SaOFbiaX8TYNuMxU0uet6szEPbyeBHSLz837xRlkVZYmFca3mFm79oxwmrHq2lXIyaSW
         WXen43aq67ZJqVMLbyH+QIp/fV7ychE028ALQiJzwXz/uisTisGOTVRrNdzIrtzFWXyN
         /nAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766215058; x=1766819858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=50BOIvlH5SCR6RQlmb3P9L9nkf2GwjjwTZczrqAgn6I=;
        b=KmeXbZbGowhg58aEkQRBi251SXvvKwtp4s/S+3YcQveQPDQS54+Ry2rYvbAt1T9Ssi
         AGjGMqJ2Z65syqp+2Zp64xpblw19v1F1WS+CkMP2gv2rhtCG8esANhJOf0+9dDvW74Uy
         ttuPv9OOueqiu3PoWkMt0jyPLCYr/l2syez3h2Dg1oJvijP+o1409C1jVrKg8FEOaQYs
         H5MYzwDbHvd+ehceL39ZYjsqqlwMelW+b5dat8Z8B5XNh0SdZDP6dOh59tXxAehIWseu
         NiN3HM4mvSXb9J2FFBwQA9sVT8warjL8Pb+KO6C0cdl3yYzvP78i33Qucp73QGfUzk0U
         zN/w==
X-Gm-Message-State: AOJu0YykoIH+m5J5yQsIQ5kcnQgGx1Jj9MjFpjpdmKHqBCI6S7uhnRTt
	/pkPpdqnst4G+QkHLLeOPEGsoyJU9tVFEcfWMdazwZgsnMrlGFJjMMmzeU6P39VIhP4=
X-Gm-Gg: AY/fxX5qf7pkIRxndRIrsztZ4XeY0VCbTeVwzWmvz47SjgWR/Yh++A3vO9Db0nOItuh
	im1sVqMb6CEVSl6iTjm0ma0Ac/eFXkJYEUv/uB1CnYOr+cDSxTZT7LevNrnHHmir3Mux1f8os9+
	u2zhJ/YoZI+y2Ri6j3m6Ae8cMr+46J+Nt3dopM1egy40wVVEu1YEQ2cuFzCV8lzKpBMdIjXkW9O
	a7IkNeRdRbzkNMkg8YBLwlqPsXHR9bRf45N9YWNpjdSDseeJfBmMFuDwR345v1xRU3iOyiE9r7q
	PANnKlrlliKk+ma8ZNOz5OXUZQ1V0xm2cdEskWq/pqPXyDexZVQddLb2Wx36+0rMLQjp19Y7/VE
	+2X2nW1nOktSNkfUPP0x85pnFbZ2+Tv3krAIT49ZweASlqm5OiNoobUYyFiCe60XGBs4QWjxxUY
	yAbVTLOT2+na2R6l1ZdjQj8Ed1IV23UUozegA/KgeWjtJotBtYRYmHEDkbZYGtKEG4l8LWo9cDc
	DRVXejksS28fSbuAEe+2+jvX8j4uYhftWAo95EZD31EpezX6aKcWS9DomCcfVQoVVD1TD0TjJ6l
	kcvftKfCEW2guYQ=
X-Google-Smtp-Source: AGHT+IHIbQip3oRIxLs/vgfyQGsJ/97nX87DnESJQK/V93IsUuDpEFfmaz3LfBoy1n5lPmDOEoxn1g==
X-Received: by 2002:a05:7022:eac7:b0:11b:a738:65b2 with SMTP id a92af1059eb24-120619277d4mr8807929c88.5.1766215057522;
        Fri, 19 Dec 2025 23:17:37 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254d369sm17527115c88.16.2025.12.19.23.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 23:17:37 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: [PATCH v2 4/5] scsi: ipr: remove function tracing macros
Date: Fri, 19 Dec 2025 23:17:14 -0800
Message-ID: <20251220071715.44296-2-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251220071715.44296-1-enelsonmoore@gmail.com>
References: <20251220071715.44296-1-enelsonmoore@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These function tracing macros clutter the code and provide
no value over ftrace. Remove them.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/scsi/ipr.c | 130 ---------------------------------------------
 drivers/scsi/ipr.h |   3 --
 2 files changed, 133 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index dbd58a7e7bc1..10c751590aff 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -856,7 +856,6 @@ static void ipr_fail_all_ops(struct ipr_ioa_cfg *ioa_cfg)
 	struct ipr_cmnd *ipr_cmd, *temp;
 	struct ipr_hrr_queue *hrrq;
 
-	ENTER;
 	for_each_hrrq(hrrq, ioa_cfg) {
 		spin_lock(&hrrq->_lock);
 		list_for_each_entry_safe(ipr_cmd,
@@ -878,7 +877,6 @@ static void ipr_fail_all_ops(struct ipr_ioa_cfg *ioa_cfg)
 		}
 		spin_unlock(&hrrq->_lock);
 	}
-	LEAVE;
 }
 
 /**
@@ -2593,7 +2591,6 @@ static void ipr_timeout(struct timer_list *t)
 	unsigned long lock_flags = 0;
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
-	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
 	ioa_cfg->errors_logged++;
@@ -2607,7 +2604,6 @@ static void ipr_timeout(struct timer_list *t)
 		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	LEAVE;
 }
 
 /**
@@ -2626,7 +2622,6 @@ static void ipr_oper_timeout(struct timer_list *t)
 	unsigned long lock_flags = 0;
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
-	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
 	ioa_cfg->errors_logged++;
@@ -2643,7 +2638,6 @@ static void ipr_oper_timeout(struct timer_list *t)
 	}
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	LEAVE;
 }
 
 /**
@@ -3058,8 +3052,6 @@ static void ipr_get_ioa_dump(struct ipr_ioa_cfg *ioa_cfg, struct ipr_dump *dump)
 	int valid = 1;
 	int i;
 
-	ENTER;
-
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
 	if (ioa_cfg->sdt_state != READ_DUMP) {
@@ -3198,7 +3190,6 @@ static void ipr_get_ioa_dump(struct ipr_ioa_cfg *ioa_cfg, struct ipr_dump *dump)
 	driver_dump->hdr.len += ioa_dump->hdr.len;
 	wmb();
 	ioa_cfg->sdt_state = DUMP_OBTAINED;
-	LEAVE;
 }
 
 #else
@@ -3219,7 +3210,6 @@ static void ipr_release_dump(struct kref *kref)
 	unsigned long lock_flags = 0;
 	int i;
 
-	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	ioa_cfg->dump = NULL;
 	ioa_cfg->sdt_state = INACTIVE;
@@ -3230,7 +3220,6 @@ static void ipr_release_dump(struct kref *kref)
 
 	vfree(dump->ioa_dump.ioa_data);
 	kfree(dump);
-	LEAVE;
 }
 
 static void ipr_add_remove_thread(struct work_struct *work)
@@ -3243,7 +3232,6 @@ static void ipr_add_remove_thread(struct work_struct *work)
 	u8 bus, target, lun;
 	int did_work;
 
-	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
 restart:
@@ -3289,7 +3277,6 @@ static void ipr_add_remove_thread(struct work_struct *work)
 	ioa_cfg->scan_done = 1;
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	kobject_uevent(&ioa_cfg->host->shost_dev.kobj, KOBJ_CHANGE);
-	LEAVE;
 }
 
 /**
@@ -3310,7 +3297,6 @@ static void ipr_worker_thread(struct work_struct *work)
 	struct ipr_ioa_cfg *ioa_cfg =
 		container_of(work, struct ipr_ioa_cfg, work_q);
 
-	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
 	if (ioa_cfg->sdt_state == READ_DUMP) {
@@ -3349,7 +3335,6 @@ static void ipr_worker_thread(struct work_struct *work)
 	schedule_work(&ioa_cfg->scsi_add_work_q);
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	LEAVE;
 }
 
 #ifdef CONFIG_SCSI_IPR_TRACE
@@ -4330,8 +4315,6 @@ static int ipr_free_dump(struct ipr_ioa_cfg *ioa_cfg)
 	struct ipr_dump *dump;
 	unsigned long lock_flags = 0;
 
-	ENTER;
-
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	dump = ioa_cfg->dump;
 	if (!dump) {
@@ -4344,7 +4327,6 @@ static int ipr_free_dump(struct ipr_ioa_cfg *ioa_cfg)
 
 	kref_put(&dump->kref, ipr_release_dump);
 
-	LEAVE;
 	return 0;
 }
 
@@ -4912,7 +4894,6 @@ static int ipr_wait_for_ops(struct ipr_ioa_cfg *ioa_cfg, void *device,
 	signed long timeout = IPR_ABORT_TASK_TIMEOUT;
 	DECLARE_COMPLETION_ONSTACK(comp);
 
-	ENTER;
 	do {
 		wait = 0;
 
@@ -4952,13 +4933,11 @@ static int ipr_wait_for_ops(struct ipr_ioa_cfg *ioa_cfg, void *device,
 
 				if (wait)
 					dev_err(&ioa_cfg->pdev->dev, "Timed out waiting for aborted commands\n");
-				LEAVE;
 				return wait ? FAILED : SUCCESS;
 			}
 		}
 	} while (wait);
 
-	LEAVE;
 	return SUCCESS;
 }
 
@@ -4968,7 +4947,6 @@ static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
 	unsigned long lock_flags = 0;
 	int rc = SUCCESS;
 
-	ENTER;
 	ioa_cfg = (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
@@ -4993,7 +4971,6 @@ static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
 	}
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	LEAVE;
 	return rc;
 }
 
@@ -5018,7 +4995,6 @@ static int ipr_device_reset(struct ipr_ioa_cfg *ioa_cfg,
 	struct ipr_cmd_pkt *cmd_pkt;
 	u32 ioasc;
 
-	ENTER;
 	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ioarcb = &ipr_cmd->ioarcb;
 	cmd_pkt = &ioarcb->cmd_pkt;
@@ -5034,7 +5010,6 @@ static int ipr_device_reset(struct ipr_ioa_cfg *ioa_cfg,
 	ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 
-	LEAVE;
 	return IPR_IOASC_SENSE_KEY(ioasc) ? -EIO : 0;
 }
 
@@ -5055,7 +5030,6 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 	struct ipr_resource_entry *res;
 	int rc = 0;
 
-	ENTER;
 	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
 	res = scsi_cmd->device->hostdata;
 
@@ -5076,7 +5050,6 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 	res->resetting_device = 0;
 	res->reset_occurred = 1;
 
-	LEAVE;
 	return rc ? FAILED : SUCCESS;
 }
 
@@ -5116,7 +5089,6 @@ static void ipr_bus_reset_done(struct ipr_cmnd *ipr_cmd)
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	struct ipr_resource_entry *res;
 
-	ENTER;
 	if (!ioa_cfg->sis64)
 		list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
 			if (res->res_handle == ipr_cmd->ioarcb.res_handle) {
@@ -5135,7 +5107,6 @@ static void ipr_bus_reset_done(struct ipr_cmnd *ipr_cmd)
 		ipr_cmd->sibling->done(ipr_cmd->sibling);
 
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
-	LEAVE;
 }
 
 /**
@@ -5157,7 +5128,6 @@ static void ipr_abort_timeout(struct timer_list *t)
 	struct ipr_cmd_pkt *cmd_pkt;
 	unsigned long lock_flags = 0;
 
-	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	if (ipr_cmd->completion.done || ioa_cfg->in_reset_reload) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
@@ -5176,7 +5146,6 @@ static void ipr_abort_timeout(struct timer_list *t)
 
 	ipr_do_req(reset_cmd, ipr_bus_reset_done, ipr_timeout, IPR_DEVICE_RESET_TIMEOUT);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	LEAVE;
 }
 
 /**
@@ -5198,7 +5167,6 @@ static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd)
 	int i, op_found = 0;
 	struct ipr_hrr_queue *hrrq;
 
-	ENTER;
 	ioa_cfg = (struct ipr_ioa_cfg *)scsi_cmd->device->host->hostdata;
 	res = scsi_cmd->device->hostdata;
 
@@ -5263,7 +5231,6 @@ static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd)
 	if (!ipr_is_naca_model(res))
 		res->needs_sync_complete = 1;
 
-	LEAVE;
 	return IPR_IOASC_SENSE_KEY(ioasc) ? FAILED : SUCCESS;
 }
 
@@ -5303,8 +5270,6 @@ static int ipr_eh_abort(struct scsi_cmnd *scsi_cmd)
 	int rc;
 	struct ipr_ioa_cfg *ioa_cfg;
 
-	ENTER;
-
 	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
 
 	spin_lock_irqsave(scsi_cmd->device->host->host_lock, flags);
@@ -5313,7 +5278,6 @@ static int ipr_eh_abort(struct scsi_cmnd *scsi_cmd)
 
 	if (rc == SUCCESS)
 		rc = ipr_wait_for_ops(ioa_cfg, scsi_cmd->device, ipr_match_lun);
-	LEAVE;
 	return rc;
 }
 
@@ -6430,7 +6394,6 @@ static int ipr_ioa_bringdown_done(struct ipr_cmnd *ipr_cmd)
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	int i;
 
-	ENTER;
 	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa) {
 		ipr_trace;
 		ioa_cfg->scsi_unblock = 1;
@@ -6448,7 +6411,6 @@ static int ipr_ioa_bringdown_done(struct ipr_cmnd *ipr_cmd)
 
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 	wake_up_all(&ioa_cfg->reset_wait_q);
-	LEAVE;
 
 	return IPR_RC_JOB_RETURN;
 }
@@ -6470,7 +6432,6 @@ static int ipr_ioa_reset_done(struct ipr_cmnd *ipr_cmd)
 	struct ipr_resource_entry *res;
 	int j;
 
-	ENTER;
 	ioa_cfg->in_reset_reload = 0;
 	for (j = 0; j < ioa_cfg->hrrq_num; j++) {
 		spin_lock(&ioa_cfg->hrrq[j]._lock);
@@ -6510,7 +6471,6 @@ static int ipr_ioa_reset_done(struct ipr_cmnd *ipr_cmd)
 
 	ioa_cfg->scsi_unblock = 1;
 	schedule_work(&ioa_cfg->work_q);
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -6578,11 +6538,9 @@ static int ipr_set_supported_devs(struct ipr_cmnd *ipr_cmd)
 
 		if (!ioa_cfg->sis64)
 			ipr_cmd->job_step = ipr_set_supported_devs;
-		LEAVE;
 		return IPR_RC_JOB_RETURN;
 	}
 
-	LEAVE;
 	return IPR_RC_JOB_CONTINUE;
 }
 
@@ -6775,7 +6733,6 @@ static int ipr_ioafp_mode_select_page28(struct ipr_cmnd *ipr_cmd)
 	struct ipr_mode_pages *mode_pages = &ioa_cfg->vpd_cbs->mode_pages;
 	int length;
 
-	ENTER;
 	ipr_scsi_bus_speed_limit(ioa_cfg);
 	ipr_check_term_power(ioa_cfg, mode_pages);
 	ipr_modify_ioafp_mode_page_28(ioa_cfg, mode_pages);
@@ -6791,7 +6748,6 @@ static int ipr_ioafp_mode_select_page28(struct ipr_cmnd *ipr_cmd)
 				    struct ipr_resource_entry, queue);
 	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout, IPR_INTERNAL_TIMEOUT);
 
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -6883,7 +6839,6 @@ static int ipr_ioafp_mode_sense_page28(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
-	ENTER;
 	ipr_build_mode_sense(ipr_cmd, cpu_to_be32(IPR_IOA_RES_HANDLE),
 			     0x28, ioa_cfg->vpd_cbs_dma +
 			     offsetof(struct ipr_misc_cbs, mode_pages),
@@ -6894,7 +6849,6 @@ static int ipr_ioafp_mode_sense_page28(struct ipr_cmnd *ipr_cmd)
 
 	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout, IPR_INTERNAL_TIMEOUT);
 
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -6914,7 +6868,6 @@ static int ipr_ioafp_mode_select_page24(struct ipr_cmnd *ipr_cmd)
 	struct ipr_mode_page24 *mode_page;
 	int length;
 
-	ENTER;
 	mode_page = ipr_get_mode_page(mode_pages, 0x24,
 				      sizeof(struct ipr_mode_page24));
 
@@ -6931,7 +6884,6 @@ static int ipr_ioafp_mode_select_page24(struct ipr_cmnd *ipr_cmd)
 	ipr_cmd->job_step = ipr_ioafp_mode_sense_page28;
 	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout, IPR_INTERNAL_TIMEOUT);
 
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -6971,7 +6923,6 @@ static int ipr_ioafp_mode_sense_page24(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
-	ENTER;
 	ipr_build_mode_sense(ipr_cmd, cpu_to_be32(IPR_IOA_RES_HANDLE),
 			     0x24, ioa_cfg->vpd_cbs_dma +
 			     offsetof(struct ipr_misc_cbs, mode_pages),
@@ -6982,7 +6933,6 @@ static int ipr_ioafp_mode_sense_page24(struct ipr_cmnd *ipr_cmd)
 
 	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout, IPR_INTERNAL_TIMEOUT);
 
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -7006,7 +6956,6 @@ static int ipr_init_res_table(struct ipr_cmnd *ipr_cmd)
 	int entries, found, flag, i;
 	LIST_HEAD(old_res);
 
-	ENTER;
 	if (ioa_cfg->sis64)
 		flag = ioa_cfg->u.cfg_table64->hdr64.flags;
 	else
@@ -7075,7 +7024,6 @@ static int ipr_init_res_table(struct ipr_cmnd *ipr_cmd)
 	else
 		ipr_cmd->job_step = ipr_ioafp_mode_sense_page28;
 
-	LEAVE;
 	return IPR_RC_JOB_CONTINUE;
 }
 
@@ -7096,7 +7044,6 @@ static int ipr_ioafp_query_ioa_cfg(struct ipr_cmnd *ipr_cmd)
 	struct ipr_inquiry_page3 *ucode_vpd = &ioa_cfg->vpd_cbs->page3_data;
 	struct ipr_inquiry_cap *cap = &ioa_cfg->vpd_cbs->cap;
 
-	ENTER;
 	if (cap->cap & IPR_CAP_DUAL_IOA_RAID)
 		ioa_cfg->dual_raid = 1;
 	dev_info(&ioa_cfg->pdev->dev, "Adapter firmware version: %02X%02X%02X%02X\n",
@@ -7117,7 +7064,6 @@ static int ipr_ioafp_query_ioa_cfg(struct ipr_cmnd *ipr_cmd)
 
 	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout, IPR_INTERNAL_TIMEOUT);
 
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -7156,8 +7102,6 @@ static int ipr_ioafp_set_caching_parameters(struct ipr_cmnd *ipr_cmd)
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	struct ipr_inquiry_pageC4 *pageC4 = &ioa_cfg->vpd_cbs->pageC4_data;
 
-	ENTER;
-
 	ipr_cmd->job_step = ipr_ioafp_query_ioa_cfg;
 
 	if (pageC4->cache_cap[0] & IPR_CAP_SYNC_CACHE) {
@@ -7171,11 +7115,9 @@ static int ipr_ioafp_set_caching_parameters(struct ipr_cmnd *ipr_cmd)
 		ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout,
 			   IPR_SET_SUP_DEVICE_TIMEOUT);
 
-		LEAVE;
 		return IPR_RC_JOB_RETURN;
 	}
 
-	LEAVE;
 	return IPR_RC_JOB_CONTINUE;
 }
 
@@ -7197,7 +7139,6 @@ static void ipr_ioafp_inquiry(struct ipr_cmnd *ipr_cmd, u8 flags, u8 page,
 {
 	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
 
-	ENTER;
 	ioarcb->cmd_pkt.request_type = IPR_RQTYPE_SCSICDB;
 	ioarcb->res_handle = cpu_to_be32(IPR_IOA_RES_HANDLE);
 
@@ -7209,7 +7150,6 @@ static void ipr_ioafp_inquiry(struct ipr_cmnd *ipr_cmd, u8 flags, u8 page,
 	ipr_init_ioadl(ipr_cmd, dma_addr, xfer_len, IPR_IOADL_FLAGS_READ_LAST);
 
 	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout, IPR_INTERNAL_TIMEOUT);
-	LEAVE;
 }
 
 /**
@@ -7249,7 +7189,6 @@ static int ipr_ioafp_pageC4_inquiry(struct ipr_cmnd *ipr_cmd)
 	struct ipr_inquiry_page0 *page0 = &ioa_cfg->vpd_cbs->page0_data;
 	struct ipr_inquiry_pageC4 *pageC4 = &ioa_cfg->vpd_cbs->pageC4_data;
 
-	ENTER;
 	ipr_cmd->job_step = ipr_ioafp_set_caching_parameters;
 	memset(pageC4, 0, sizeof(*pageC4));
 
@@ -7262,7 +7201,6 @@ static int ipr_ioafp_pageC4_inquiry(struct ipr_cmnd *ipr_cmd)
 		return IPR_RC_JOB_RETURN;
 	}
 
-	LEAVE;
 	return IPR_RC_JOB_CONTINUE;
 }
 
@@ -7282,7 +7220,6 @@ static int ipr_ioafp_cap_inquiry(struct ipr_cmnd *ipr_cmd)
 	struct ipr_inquiry_page0 *page0 = &ioa_cfg->vpd_cbs->page0_data;
 	struct ipr_inquiry_cap *cap = &ioa_cfg->vpd_cbs->cap;
 
-	ENTER;
 	ipr_cmd->job_step = ipr_ioafp_pageC4_inquiry;
 	memset(cap, 0, sizeof(*cap));
 
@@ -7293,7 +7230,6 @@ static int ipr_ioafp_cap_inquiry(struct ipr_cmnd *ipr_cmd)
 		return IPR_RC_JOB_RETURN;
 	}
 
-	LEAVE;
 	return IPR_RC_JOB_CONTINUE;
 }
 
@@ -7311,15 +7247,12 @@ static int ipr_ioafp_page3_inquiry(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
-	ENTER;
-
 	ipr_cmd->job_step = ipr_ioafp_cap_inquiry;
 
 	ipr_ioafp_inquiry(ipr_cmd, 1, 3,
 			  ioa_cfg->vpd_cbs_dma + offsetof(struct ipr_misc_cbs, page3_data),
 			  sizeof(struct ipr_inquiry_page3));
 
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -7338,8 +7271,6 @@ static int ipr_ioafp_page0_inquiry(struct ipr_cmnd *ipr_cmd)
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	char type[5];
 
-	ENTER;
-
 	/* Grab the type out of the VPD and store it away */
 	memcpy(type, ioa_cfg->vpd_cbs->ioa_vpd.std_inq_data.vpids.product_id, 4);
 	type[4] = '\0';
@@ -7351,7 +7282,6 @@ static int ipr_ioafp_page0_inquiry(struct ipr_cmnd *ipr_cmd)
 			  ioa_cfg->vpd_cbs_dma + offsetof(struct ipr_misc_cbs, page0_data),
 			  sizeof(struct ipr_inquiry_page0));
 
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -7368,14 +7298,12 @@ static int ipr_ioafp_std_inquiry(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
-	ENTER;
 	ipr_cmd->job_step = ipr_ioafp_page0_inquiry;
 
 	ipr_ioafp_inquiry(ipr_cmd, 0, 0,
 			  ioa_cfg->vpd_cbs_dma + offsetof(struct ipr_misc_cbs, ioa_vpd),
 			  sizeof(struct ipr_ioa_vpd));
 
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -7395,7 +7323,6 @@ static int ipr_ioafp_identify_hrrq(struct ipr_cmnd *ipr_cmd)
 	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
 	struct ipr_hrr_queue *hrrq;
 
-	ENTER;
 	ipr_cmd->job_step = ipr_ioafp_std_inquiry;
 	if (ioa_cfg->identify_hrrq_index == 0)
 		dev_info(&ioa_cfg->pdev->dev, "Starting IOA initialization sequence.\n");
@@ -7453,11 +7380,9 @@ static int ipr_ioafp_identify_hrrq(struct ipr_cmnd *ipr_cmd)
 		if (++ioa_cfg->identify_hrrq_index < ioa_cfg->hrrq_num)
 			ipr_cmd->job_step = ipr_ioafp_identify_hrrq;
 
-		LEAVE;
 		return IPR_RC_JOB_RETURN;
 	}
 
-	LEAVE;
 	return IPR_RC_JOB_CONTINUE;
 }
 
@@ -7508,7 +7433,6 @@ static void ipr_reset_start_timer(struct ipr_cmnd *ipr_cmd,
 				  unsigned long timeout)
 {
 
-	ENTER;
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_pending_q);
 	ipr_cmd->done = ipr_reset_ioa_job;
 
@@ -7624,7 +7548,6 @@ static int ipr_reset_enable_ioa(struct ipr_cmnd *ipr_cmd)
 	volatile u64 maskval;
 	int i;
 
-	ENTER;
 	ipr_cmd->job_step = ipr_ioafp_identify_hrrq;
 	ipr_init_ioa_mem(ioa_cfg);
 
@@ -7673,7 +7596,6 @@ static int ipr_reset_enable_ioa(struct ipr_cmnd *ipr_cmd)
 	add_timer(&ipr_cmd->timer);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_pending_q);
 
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -7797,13 +7719,11 @@ static int ipr_reset_get_unit_check_job(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
-	ENTER;
 	ioa_cfg->ioa_unit_checked = 0;
 	ipr_get_unit_check_buffer(ioa_cfg);
 	ipr_cmd->job_step = ipr_reset_alert;
 	ipr_reset_start_timer(ipr_cmd, 0);
 
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -7811,8 +7731,6 @@ static int ipr_dump_mailbox_wait(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
-	ENTER;
-
 	if (ioa_cfg->sdt_state != GET_DUMP)
 		return IPR_RC_JOB_RETURN;
 
@@ -7839,7 +7757,6 @@ static int ipr_dump_mailbox_wait(struct ipr_cmnd *ipr_cmd)
 				      IPR_CHECK_FOR_RESET_TIMEOUT);
 	}
 
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -7882,7 +7799,6 @@ static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
-	ENTER;
 	pci_restore_state(ioa_cfg->pdev);
 
 	if (ipr_set_pcix_cmd_reg(ioa_cfg)) {
@@ -7922,7 +7838,6 @@ static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
 		ipr_cmd->job_step = ipr_reset_enable_ioa;
 	}
 
-	LEAVE;
 	return IPR_RC_JOB_CONTINUE;
 }
 
@@ -7939,12 +7854,10 @@ static int ipr_reset_bist_done(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
-	ENTER;
 	if (ioa_cfg->cfg_locked)
 		pci_cfg_access_unlock(ioa_cfg->pdev);
 	ioa_cfg->cfg_locked = 0;
 	ipr_cmd->job_step = ipr_reset_restore_cfg_space;
-	LEAVE;
 	return IPR_RC_JOB_CONTINUE;
 }
 
@@ -7962,7 +7875,6 @@ static int ipr_reset_start_bist(struct ipr_cmnd *ipr_cmd)
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	int rc = PCIBIOS_SUCCESSFUL;
 
-	ENTER;
 	if (ioa_cfg->ipr_chip->bist_method == IPR_MMIO)
 		writel(IPR_UPROCI_SIS64_START_BIST,
 		       ioa_cfg->regs.set_uproc_interrupt_reg32);
@@ -7982,7 +7894,6 @@ static int ipr_reset_start_bist(struct ipr_cmnd *ipr_cmd)
 		rc = IPR_RC_JOB_CONTINUE;
 	}
 
-	LEAVE;
 	return rc;
 }
 
@@ -7997,10 +7908,8 @@ static int ipr_reset_start_bist(struct ipr_cmnd *ipr_cmd)
  **/
 static int ipr_reset_slot_reset_done(struct ipr_cmnd *ipr_cmd)
 {
-	ENTER;
 	ipr_cmd->job_step = ipr_reset_bist_done;
 	ipr_reset_start_timer(ipr_cmd, IPR_WAIT_FOR_BIST_TIMEOUT);
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -8018,7 +7927,6 @@ static void ipr_reset_reset_work(struct work_struct *work)
 	struct pci_dev *pdev = ioa_cfg->pdev;
 	unsigned long lock_flags = 0;
 
-	ENTER;
 	pci_set_pcie_reset_state(pdev, pcie_warm_reset);
 	msleep(jiffies_to_msecs(IPR_PCI_RESET_TIMEOUT));
 	pci_set_pcie_reset_state(pdev, pcie_deassert_reset);
@@ -8027,7 +7935,6 @@ static void ipr_reset_reset_work(struct work_struct *work)
 	if (ioa_cfg->reset_cmd == ipr_cmd)
 		ipr_reset_ioa_job(ipr_cmd);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	LEAVE;
 }
 
 /**
@@ -8043,11 +7950,9 @@ static int ipr_reset_slot_reset(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
-	ENTER;
 	INIT_WORK(&ipr_cmd->work, ipr_reset_reset_work);
 	queue_work(ioa_cfg->reset_work_q, &ipr_cmd->work);
 	ipr_cmd->job_step = ipr_reset_slot_reset_done;
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -8165,7 +8070,6 @@ static int ipr_reset_alert(struct ipr_cmnd *ipr_cmd)
 	u16 cmd_reg;
 	int rc;
 
-	ENTER;
 	rc = pci_read_config_word(ioa_cfg->pdev, PCI_COMMAND, &cmd_reg);
 
 	if ((rc == PCIBIOS_SUCCESSFUL) && (cmd_reg & PCI_COMMAND_MEMORY)) {
@@ -8179,7 +8083,6 @@ static int ipr_reset_alert(struct ipr_cmnd *ipr_cmd)
 	ipr_cmd->u.time_left = IPR_WAIT_FOR_RESET_TIMEOUT;
 	ipr_reset_start_timer(ipr_cmd, IPR_CHECK_FOR_RESET_TIMEOUT);
 
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -8196,10 +8099,8 @@ static int ipr_reset_quiesce_done(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
-	ENTER;
 	ipr_cmd->job_step = ipr_ioa_bringdown_done;
 	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
-	LEAVE;
 	return IPR_RC_JOB_CONTINUE;
 }
 
@@ -8221,7 +8122,6 @@ static int ipr_reset_cancel_hcam_done(struct ipr_cmnd *ipr_cmd)
 	int rc = IPR_RC_JOB_CONTINUE;
 	int count = 0;
 
-	ENTER;
 	ipr_cmd->job_step = ipr_reset_quiesce_done;
 
 	for_each_hrrq(hrrq, ioa_cfg) {
@@ -8239,7 +8139,6 @@ static int ipr_reset_cancel_hcam_done(struct ipr_cmnd *ipr_cmd)
 			break;
 	}
 
-	LEAVE;
 	return rc;
 }
 
@@ -8260,7 +8159,6 @@ static int ipr_reset_cancel_hcam(struct ipr_cmnd *ipr_cmd)
 	struct ipr_cmnd *hcam_cmd;
 	struct ipr_hrr_queue *hrrq = &ioa_cfg->hrrq[IPR_INIT_HRRQ];
 
-	ENTER;
 	ipr_cmd->job_step = ipr_reset_cancel_hcam_done;
 
 	if (!hrrq->ioa_is_dead) {
@@ -8295,7 +8193,6 @@ static int ipr_reset_cancel_hcam(struct ipr_cmnd *ipr_cmd)
 	} else
 		ipr_cmd->job_step = ipr_reset_alert;
 
-	LEAVE;
 	return rc;
 }
 
@@ -8335,7 +8232,6 @@ static int ipr_reset_ucode_download(struct ipr_cmnd *ipr_cmd)
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	struct ipr_sglist *sglist = ioa_cfg->ucode_sglist;
 
-	ENTER;
 	ipr_cmd->job_step = ipr_reset_alert;
 
 	if (!sglist)
@@ -8358,7 +8254,6 @@ static int ipr_reset_ucode_download(struct ipr_cmnd *ipr_cmd)
 	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout,
 		   IPR_WRITE_BUFFER_TIMEOUT);
 
-	LEAVE;
 	return IPR_RC_JOB_RETURN;
 }
 
@@ -8380,7 +8275,6 @@ static int ipr_reset_shutdown_ioa(struct ipr_cmnd *ipr_cmd)
 	unsigned long timeout;
 	int rc = IPR_RC_JOB_CONTINUE;
 
-	ENTER;
 	if (shutdown_type == IPR_SHUTDOWN_QUIESCE)
 		ipr_cmd->job_step = ipr_reset_cancel_hcam;
 	else if (shutdown_type != IPR_SHUTDOWN_NONE &&
@@ -8406,7 +8300,6 @@ static int ipr_reset_shutdown_ioa(struct ipr_cmnd *ipr_cmd)
 	} else
 		ipr_cmd->job_step = ipr_reset_alert;
 
-	LEAVE;
 	return rc;
 }
 
@@ -8711,7 +8604,6 @@ static void ipr_probe_ioa_part2(struct ipr_ioa_cfg *ioa_cfg)
 {
 	unsigned long host_lock_flags = 0;
 
-	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 	dev_dbg(&ioa_cfg->pdev->dev, "ioa_cfg adx: 0x%p\n", ioa_cfg);
 	ioa_cfg->probe_done = 1;
@@ -8722,8 +8614,6 @@ static void ipr_probe_ioa_part2(struct ipr_ioa_cfg *ioa_cfg)
 		_ipr_initiate_ioa_reset(ioa_cfg, ipr_reset_enable_ioa,
 					IPR_SHUTDOWN_NONE);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
-
-	LEAVE;
 }
 
 /**
@@ -8827,7 +8717,6 @@ static void ipr_free_all_resources(struct ipr_ioa_cfg *ioa_cfg)
 {
 	struct pci_dev *pdev = ioa_cfg->pdev;
 
-	ENTER;
 	ipr_free_irqs(ioa_cfg);
 	if (ioa_cfg->reset_work_q)
 		destroy_workqueue(ioa_cfg->reset_work_q);
@@ -8836,7 +8725,6 @@ static void ipr_free_all_resources(struct ipr_ioa_cfg *ioa_cfg)
 	ipr_free_mem(ioa_cfg);
 	scsi_host_put(ioa_cfg->host);
 	pci_disable_device(pdev);
-	LEAVE;
 }
 
 /**
@@ -8962,7 +8850,6 @@ static int ipr_alloc_mem(struct ipr_ioa_cfg *ioa_cfg)
 	struct pci_dev *pdev = ioa_cfg->pdev;
 	int i, rc = -ENOMEM;
 
-	ENTER;
 	ioa_cfg->res_entries = kcalloc(ioa_cfg->max_devs_supported,
 				       sizeof(struct ipr_resource_entry),
 				       GFP_KERNEL);
@@ -9035,7 +8922,6 @@ static int ipr_alloc_mem(struct ipr_ioa_cfg *ioa_cfg)
 
 	rc = 0;
 out:
-	LEAVE;
 	return rc;
 
 out_free_hostrcb_dma:
@@ -9319,8 +9205,6 @@ static int ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg, struct pci_dev *pdev)
 	unsigned long lock_flags = 0;
 	int irq = pci_irq_vector(pdev, 0);
 
-	ENTER;
-
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	init_waitqueue_head(&ioa_cfg->msi_wait_q);
 	ioa_cfg->msi_received = 0;
@@ -9353,8 +9237,6 @@ static int ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg, struct pci_dev *pdev)
 
 	free_irq(irq, ioa_cfg);
 
-	LEAVE;
-
 	return rc;
 }
 
@@ -9377,8 +9259,6 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 	unsigned long lock_flags, driver_lock_flags;
 	unsigned int irq_flag;
 
-	ENTER;
-
 	dev_info(&pdev->dev, "Found IOA with IRQ: %d\n", pdev->irq);
 	host = scsi_host_alloc(&driver_template, sizeof(*ioa_cfg));
 
@@ -9616,7 +9496,6 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 	list_add_tail(&ioa_cfg->queue, &ipr_ioa_head);
 	spin_unlock_irqrestore(&ipr_driver_lock, driver_lock_flags);
 
-	LEAVE;
 out:
 	return rc;
 
@@ -9655,13 +9534,11 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 static void ipr_initiate_ioa_bringdown(struct ipr_ioa_cfg *ioa_cfg,
 				       enum ipr_shutdown_type shutdown_type)
 {
-	ENTER;
 	if (ioa_cfg->sdt_state == WAIT_FOR_DUMP)
 		ioa_cfg->sdt_state = ABORT_DUMP;
 	ioa_cfg->reset_retries = 0;
 	ioa_cfg->in_ioa_bringdown = 1;
 	ipr_initiate_ioa_reset(ioa_cfg, shutdown_type);
-	LEAVE;
 }
 
 /**
@@ -9679,7 +9556,6 @@ static void __ipr_remove(struct pci_dev *pdev)
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
 	int i;
 	unsigned long driver_lock_flags;
-	ENTER;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 	while (ioa_cfg->in_reset_reload) {
@@ -9713,8 +9589,6 @@ static void __ipr_remove(struct pci_dev *pdev)
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
 
 	ipr_free_all_resources(ioa_cfg);
-
-	LEAVE;
 }
 
 /**
@@ -9730,8 +9604,6 @@ static void ipr_remove(struct pci_dev *pdev)
 {
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
 
-	ENTER;
-
 	ipr_remove_trace_file(&ioa_cfg->host->shost_dev.kobj,
 			      &ipr_trace_attr);
 	ipr_remove_dump_file(&ioa_cfg->host->shost_dev.kobj,
@@ -9741,8 +9613,6 @@ static void ipr_remove(struct pci_dev *pdev)
 	scsi_remove_host(ioa_cfg->host);
 
 	__ipr_remove(pdev);
-
-	LEAVE;
 }
 
 /**
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index fde7145835de..55bf2e36298c 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1764,9 +1764,6 @@ struct ipr_ucode_image_header {
 #define ipr_trace ipr_dbg("%s: %s: Line: %d\n",\
 	__FILE__, __func__, __LINE__)
 
-#define ENTER IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Entering %s\n", __func__))
-#define LEAVE IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Leaving %s\n", __func__))
-
 #define ipr_err_separator \
 ipr_err("----------------------------------------------------------\n")
 
-- 
2.43.0

