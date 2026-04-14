Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281F9FC0A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 16:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776184693; cv=none; b=QL5et3T2tbJz76jLnIDShWBf7bqwRJnkDx2c5otPMocii1ziQ+xRBcMUzbw7WvAfIenIxJ+P1iln9/45Ce3aIS/h4Ip4RhxBxHB3h0B+odd7Pis/ZPsm0gJXMDPvc8/SSq1ygRtXabztKNLMO6yZtW8cJz2LoNNiOsGBGgnQRLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776184693; c=relaxed/simple;
	bh=hzFhGAptWJ4+cGmCkn3Eqela6TXPOJmyjZlc0q/YsGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ok3y/5sWSULhv+Wb8y1Xa6SxLrISRQWsdAtwmRPr+FrsqA1z7cwLemuOQumlQw+8yRbocLr7vMp3eE2B3lLAtX9ytBNFzOC6joS+yrsyDbbgukE32zc3n9ZunNf9M/vmoyqSymMC+F7pE5gRSwxXyOnM8wXoT9H9AQ7T4iw7bCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3uschHvt; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3uschHvt"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fw91v4GKyz1XM6Jf;
	Tue, 14 Apr 2026 16:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776184686; x=1778776687; bh=S4F1d6slOMtYDwvyv6A1JBON
	aq8o23yGe+2G7yj0ZGI=; b=3uschHvt3z4ZmXD60PXpUaKCmEXeTay3ViYLs4fv
	gQKni8fcxvRVnLg/PPJ6Sy+Qe6B80kZ+O0HNyRx38weVQRlcTIHyoQUiC/vWmV7+
	htBqtXL/Qm6UWQESCbuHdGTIdm3okNHjDih6u1JSR8rG8vb3XlvlsfxtCB4Dtx00
	zGlTQPoWu9PTPlkcsadPMmCc+8PwG2lTPq0kV/TxvFS11TrkWnZhHE5cS1DYDCfB
	gP4+QZk/F/umVCKcU9rOugFZouUE2koXsskhF4+5Nj76vK6khIWis/MR0fvQU4mm
	dSV1se+EAilGcpuMxMymxmsyy5ytzZHmcFgRYGt1sKYvaA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cPh1bYX8maQh; Tue, 14 Apr 2026 16:38:06 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fw91n3sJlz1XM5kt;
	Tue, 14 Apr 2026 16:38:05 +0000 (UTC)
Message-ID: <da1c23ea-5635-4872-b448-33f71219abc0@acm.org>
Date: Tue, 14 Apr 2026 09:38:04 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: smartpqi silence a recursive lock warning
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc: Don.Brace@microchip.com
References: <20260414124118.23661-1-thenzl@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260414124118.23661-1-thenzl@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/14/26 5:41 AM, Tomas Henzl wrote:
> On systems with multiple controllers debug kernel shows
> WARNING: possible recursive locking detected
> during shutdown.
> Each controller does have its own ctrl_info (and mutex)
> and that isn't correctly recognized by debug kernel.
> Supress the warning by releasing the mutex at the end of pqi_shutdown.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index b4ed991976d0..2026ac645d6a 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -9427,6 +9427,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
>   
>   	pqi_crash_if_pending_command(ctrl_info);
>   	pqi_reset(ctrl_info);
> +	pqi_ctrl_unblock_device_reset(ctrl_info);
>   }
>   
>   static void pqi_process_lockup_action_param(void)

This patch looks fine to me but the description not. I think this patch
fixes a real bug rather than only suppressing a lockdep complaint.

Additionally, all uses of mutexes in the entire driver probably should
be reviewed. Here are other questionable constructs in this driver I
know of:
- pqi_ofa_memory_alloc_worker() locks &ctrl_info->ofa_mutex but doesn't
   unlock it. This mutex probably gets unlocked from the context of
   another thread, something that is not allowed.
- There is code in this driver that calls
   mutex_is_locked(&ctrl_info->ofa_mutex) (pqi_ofa_in_progress()) and
   next calls mutex_unlock(&ctrl_info->ofa_mutex) without checking
   whether the mutex_lock() call happened by the same thread that calls
   mutex_unlock().

All the __acquire() and __release() statements in the patch below should
be reviewed.

Thanks,

Bart.


diff --git a/drivers/scsi/smartpqi/Makefile b/drivers/scsi/smartpqi/Makefile
index 28985e508b5c..71db5cd96284 100644
--- a/drivers/scsi/smartpqi/Makefile
+++ b/drivers/scsi/smartpqi/Makefile
@@ -1,3 +1,6 @@
  # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS := y
+
  obj-$(CONFIG_SCSI_SMARTPQI) += smartpqi.o
  smartpqi-objs := smartpqi_init.o smartpqi_sis.o smartpqi_sas_transport.o
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c 
b/drivers/scsi/smartpqi/smartpqi_init.c
index b4ed991976d0..f99eef39ede4 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -306,12 +306,14 @@ static inline void 
pqi_save_fw_triage_setting(struct pqi_ctrl_info *ctrl_info, b
  }

  static inline void pqi_ctrl_block_scan(struct pqi_ctrl_info *ctrl_info)
+	__acquires(ctrl_info->scan_mutex)
  {
  	ctrl_info->scan_blocked = true;
  	mutex_lock(&ctrl_info->scan_mutex);
  }

  static inline void pqi_ctrl_unblock_scan(struct pqi_ctrl_info *ctrl_info)
+	__releases(ctrl_info->scan_mutex)
  {
  	ctrl_info->scan_blocked = false;
  	mutex_unlock(&ctrl_info->scan_mutex);
@@ -323,11 +325,13 @@ static inline bool pqi_ctrl_scan_blocked(struct 
pqi_ctrl_info *ctrl_info)
  }

  static inline void pqi_ctrl_block_device_reset(struct pqi_ctrl_info 
*ctrl_info)
+	__acquires(ctrl_info->lun_reset_mutex)
  {
  	mutex_lock(&ctrl_info->lun_reset_mutex);
  }

  static inline void pqi_ctrl_unblock_device_reset(struct pqi_ctrl_info 
*ctrl_info)
+	__releases(ctrl_info->lun_reset_mutex)
  {
  	mutex_unlock(&ctrl_info->lun_reset_mutex);
  }
@@ -430,11 +434,13 @@ static inline bool pqi_device_offline(struct 
pqi_scsi_dev *device)
  }

  static inline void pqi_ctrl_ofa_start(struct pqi_ctrl_info *ctrl_info)
+	__acquires(ctrl_info->ofa_mutex)
  {
  	mutex_lock(&ctrl_info->ofa_mutex);
  }

  static inline void pqi_ctrl_ofa_done(struct pqi_ctrl_info *ctrl_info)
+	__releases(ctrl_info->ofa_mutex)
  {
  	mutex_unlock(&ctrl_info->ofa_mutex);
  }
@@ -2299,6 +2305,7 @@ static void pqi_update_device_list(struct 
pqi_ctrl_info *ctrl_info,
  	 * requests before removal.
  	 */
  	if (pqi_ofa_in_progress(ctrl_info)) {
+		__acquire(&ctrl_info->lun_reset_mutex);
  		list_for_each_entry_safe(device, next, &delete_list, delete_list_entry)
  			if (pqi_is_device_added(device))
  				pqi_device_remove_start(device);
@@ -3661,6 +3668,8 @@ static void pqi_process_soft_reset(struct 
pqi_ctrl_info *ctrl_info)
  		pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
  		rc = pqi_ofa_ctrl_restart(ctrl_info, delay_secs);
  		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
+		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
+		__acquire(&ctrl_info->ofa_mutex);
  		pqi_ctrl_ofa_done(ctrl_info);
  		dev_info(&ctrl_info->pci_dev->dev,
  				"Online Firmware Activation: %s\n",
@@ -3672,6 +3681,8 @@ static void pqi_process_soft_reset(struct 
pqi_ctrl_info *ctrl_info)
  		if (ctrl_info->soft_reset_handshake_supported)
  			pqi_clear_soft_reset_status(ctrl_info);
  		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
+		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
+		__acquire(&ctrl_info->ofa_mutex);
  		pqi_ctrl_ofa_done(ctrl_info);
  		pqi_ofa_ctrl_unquiesce(ctrl_info);
  		break;
@@ -3682,6 +3693,8 @@ static void pqi_process_soft_reset(struct 
pqi_ctrl_info *ctrl_info)
  			"unexpected Online Firmware Activation reset status: 0x%x\n",
  			reset_status);
  		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
+		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
+		__acquire(&ctrl_info->ofa_mutex);
  		pqi_ctrl_ofa_done(ctrl_info);
  		pqi_ofa_ctrl_unquiesce(ctrl_info);
  		pqi_take_ctrl_offline(ctrl_info, PQI_OFA_RESPONSE_TIMEOUT);
@@ -3698,6 +3711,8 @@ static void pqi_ofa_memory_alloc_worker(struct 
work_struct *work)
  	pqi_ctrl_ofa_start(ctrl_info);
  	pqi_host_setup_buffer(ctrl_info, &ctrl_info->ofa_memory, 
ctrl_info->ofa_bytes_requested, ctrl_info->ofa_bytes_requested);
  	pqi_host_memory_update(ctrl_info, &ctrl_info->ofa_memory, 
PQI_VENDOR_GENERAL_OFA_MEMORY_UPDATE);
+	/* This function acquires &ctrl_info->ofa_mutex and doesn't release it. */
+	__release(&ctrl_info->ofa_mutex);
  }

  static void pqi_ofa_quiesce_worker(struct work_struct *work)
@@ -3738,6 +3753,8 @@ static bool pqi_ofa_process_event(struct 
pqi_ctrl_info *ctrl_info,
  			"received Online Firmware Activation cancel request: reason: %u\n",
  			ctrl_info->ofa_cancel_reason);
  		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
+		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
+		__acquire(&ctrl_info->ofa_mutex);
  		pqi_ctrl_ofa_done(ctrl_info);
  		break;
  	default:
@@ -8726,6 +8743,7 @@ static int pqi_ctrl_init_resume(struct 
pqi_ctrl_info *ctrl_info)
  	}

  	if (pqi_ofa_in_progress(ctrl_info)) {
+		__acquire(&ctrl_info->scan_mutex);
  		pqi_ctrl_unblock_scan(ctrl_info);
  		if (ctrl_info->ctrl_logging_supported) {
  			if (!ctrl_info->ctrl_log_memory.host_memory)
@@ -8938,6 +8956,8 @@ static void pqi_remove_ctrl(struct pqi_ctrl_info 
*ctrl_info)
  }

  static void pqi_ofa_ctrl_quiesce(struct pqi_ctrl_info *ctrl_info)
+	__acquires(&ctrl_info->scan_mutex)
+	__acquires(&ctrl_info->lun_reset_mutex)
  {
  	pqi_ctrl_block_scan(ctrl_info);
  	pqi_scsi_block_requests(ctrl_info);
@@ -8948,6 +8968,8 @@ static void pqi_ofa_ctrl_quiesce(struct 
pqi_ctrl_info *ctrl_info)
  }

  static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info)
+	__releases(&ctrl_info->lun_reset_mutex)
+	__releases(&ctrl_info->scan_mutex)
  {
  	pqi_start_heartbeat_timer(ctrl_info);
  	pqi_ctrl_unblock_requests(ctrl_info);
@@ -9410,6 +9432,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
  	pqi_ctrl_block_device_reset(ctrl_info);
  	pqi_ctrl_block_requests(ctrl_info);
  	pqi_ctrl_wait_until_quiesced(ctrl_info);
+	__release(&ctrl_info->lun_reset_mutex);

  	if (system_state == SYSTEM_RESTART)
  		shutdown_event = RESTART;
@@ -9486,6 +9509,8 @@ static inline enum bmic_flush_cache_shutdown_event 
pqi_get_flush_cache_shutdown_
  }

  static int pqi_suspend_or_freeze(struct device *dev, bool suspend)
+	__acquires(&((struct pqi_ctrl_info 
*)pci_get_drvdata(to_pci_dev(dev)))->scan_mutex)
+	__acquires(&((struct pqi_ctrl_info 
*)pci_get_drvdata(to_pci_dev(dev)))->lun_reset_mutex)
  {
  	struct pci_dev *pci_dev;
  	struct pqi_ctrl_info *ctrl_info;
@@ -9519,11 +9544,15 @@ static int pqi_suspend_or_freeze(struct device 
*dev, bool suspend)
  }

  static __maybe_unused int pqi_suspend(struct device *dev)
+	__acquires(&((struct pqi_ctrl_info 
*)pci_get_drvdata(to_pci_dev(dev)))->scan_mutex)
+	__acquires(&((struct pqi_ctrl_info 
*)pci_get_drvdata(to_pci_dev(dev)))->lun_reset_mutex)
  {
  	return pqi_suspend_or_freeze(dev, true);
  }

  static int pqi_resume_or_restore(struct device *dev)
+	__cond_releases(0, &((struct pqi_ctrl_info 
*)pci_get_drvdata(to_pci_dev(dev)))->lun_reset_mutex)
+	__cond_releases(0, &((struct pqi_ctrl_info 
*)pci_get_drvdata(to_pci_dev(dev)))->scan_mutex)
  {
  	int rc;
  	struct pci_dev *pci_dev;
@@ -9547,11 +9576,15 @@ static int pqi_resume_or_restore(struct device *dev)
  }

  static int pqi_freeze(struct device *dev)
+	__acquires(&((struct pqi_ctrl_info 
*)pci_get_drvdata(to_pci_dev(dev)))->scan_mutex)
+	__acquires(&((struct pqi_ctrl_info 
*)pci_get_drvdata(to_pci_dev(dev)))->lun_reset_mutex)
  {
  	return pqi_suspend_or_freeze(dev, false);
  }

  static int pqi_thaw(struct device *dev)
+	__cond_releases(0, &((struct pqi_ctrl_info 
*)pci_get_drvdata(to_pci_dev(dev)))->lun_reset_mutex)
+	__cond_releases(0, &((struct pqi_ctrl_info 
*)pci_get_drvdata(to_pci_dev(dev)))->scan_mutex)
  {
  	int rc;
  	struct pci_dev *pci_dev;

