Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.236.52.234
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793240271;
	b=PUi0iZGc5D00vZBxOfeqst2h2CCAT4HC91YG8aTuH9AQe7UEYYs07h258tmPq5vlsxVy
	 KfFNQV0RDfvJV1mn2WPZOoyl4nTIBveo7zirWLHblZjKfq4ihZEofZNAJ7Jp/inJ020ZW
	 TBu0tlWKI/IcwGIZlbMOVStKO5utDR7tE+3X9GIv8MZd23jt6OURUF2wq4xXItlj9VAsz
	 GFe0YTaBcuOM9sS0yl8+30/XiUM5MhuzX4c/LjQ0LsHk+3Fjbat73Az6g1XPIJRH6WuMo
	 P4VKnA3Uvj88WXgDgo68dwmjeBLomvUX7PGt7QOkH0+BKsmxT81e2y4lbW11gFkbW2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240271;
	h=DMARC-Filter:Received:Message-ID:Date:MIME-Version:User-Agent:Cc:
	 Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:X-HM-Spam-Status:
	 DKIM-Signature;
	bh=94GbrZJV0CaGo6wck2S4ifIyUMVOHNG7UOLGW8Hmwbw=;
	b=Ba1NBHXIkot+9ae1/5Ii+mWc+XmVegOr8DnPdFNUCDU9XA1NfxB+lxRh5uTrtR9Juz1S
	 1rn3Mk1zlYfz7hajNX65+VDSNoW0MP0DLaevnsJRbR29nBcIPOO+GOWkdph4wPu8M4LDD
	 Sc3uy5MEtmHs0uD0+y/ghzQ0KP8MBfFjW8surM1kNOh27UeTTf83s9FYSMt7QZ7jjVemW
	 j5iLRiyOaoKi0dNMSrjbweaegxl3Jkkbu/IRyNJ4tNGaTBNHoZnM8MLYqA0kCuRqQKFs7
	 nOUhadY6xCqwRJNDSFGh3rZEWcF972C+UavQ+NnlcyD+Ev4p0LRypiJXye7hv4MJwfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rock-chips.com;
	spf=pass smtp.mailfrom=rock-chips.com;
	dkim=pass header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=BPwxg1SI;
	arc=none smtp.remote-ip=160.236.52.234
Received: from mail-m16023652234.xmail.ntesmail.com (mail-m16023652234.xmail.ntesmail.com [160.236.52.234])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3895A606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 02:17:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3895A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=BPwxg1SI
Received: from [172.16.12.48] (unknown [61.154.14.86])
	by smtp.qiye.163.com (Hmail) with ESMTP id 52ba403f9;
	Thu, 29 Oct 2026 10:17:38 +0800 (GMT+08:00)
Message-ID: <3c4f9345-255b-4719-9d52-121b6ba301cb@rock-chips.com>
Date: Thu, 29 Oct 2026 10:17:35 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: shawn.lin@rock-chips.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Retry the full device init on
 fatal link loss
To: sashiko-reviews@lists.linux.dev
References: <20261029014839.3390579-1-shawn.lin@rock-chips.com>
 <20261029014839.3390579-3-shawn.lin@rock-chips.com>
 <sashiko-outbox-188630@kernel.org>
From: Shawn Lin <shawn.lin@rock-chips.com>
In-Reply-To: <sashiko-outbox-188630@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa18572d92603a4kunmc83cfa7310e75f
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSU5NVkxIGBhDGkpNTxgaGlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlNSlVKTk9VSk9VQ01ZV1kWGg8SFR0UWUFZT0tIVUpLSU
	9PT0hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=BPwxg1SIn7wW+woRw0RE3DRsvifSO+ijbL55OXYpNgW/Dzrqq8Q+3HKWvslJPptQHN5Cei0yDwYzDY/uISJ2kMvoHU+udKORmAaIjf/vC2KNRUHSxc3GBbALQXAGmKuQbmGTOoD3Yn7VVJea6cTPlCOcHDsCB4DROAv/+tNj4WY=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=94GbrZJV0CaGo6wck2S4ifIyUMVOHNG7UOLGW8Hmwbw=;
	h=date:mime-version:subject:message-id:from;

在 2026/10/29 星期四 10:06, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] scsi: ufs: core: broken MCQ reconfiguration order in ufshcd_init() retry
> - [High] scsi: ufs: error state cleared before ufshcd_hba_stop() in ufshcd_init()
> - [High] scsi: ufs: core: missing ufs_hwmon_remove() and EE mask reset on init retry
> - [Low] scsi: ufs: core: pass host_lock pointer to spin_lock_irqsave()
> --

...

> 
> [Severity: High]
> What happens if an error or link-loss interrupt fires while the host
> controller is still active during ufshcd_device_reset(), before
> ufshcd_hba_stop() disables the controller?
> 
> Because cancel_work_sync(&hba->eh_work) and the clearing of hba->saved_err,
> hba->saved_uic_err, and hba->ufshcd_state happen before ufshcd_hba_stop(),
> resetting the attached device while controller interrupts are enabled can
> trigger ufshcd_intr() -> ufshcd_check_errors():
> 
> 	hba->saved_err |= hba->errors;
> 	hba->saved_uic_err |= hba->uic_error;
> 	...
> 	ufshcd_schedule_eh_work(hba);
> 
> Since hba->ufs_device_wlun is not set yet and hba->host_sem is not held
> during ufshcd_init(), ufshcd_err_handler() can then run concurrently on
> hba->eh_wq:
> 
> 	down(&hba->host_sem);
> 	spin_lock_irqsave(&hba->host->host_lock, flags);
> 	if (ufshcd_err_handling_should_stop(hba)) {
> 		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
> 			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
> 		spin_unlock_irqrestore(&hba->host->host_lock, flags);
> 		up(&hba->host_sem);
> 		return;
> 	}
> 
> Could this overwrite hba->ufshcd_state and leave hba->saved_err and
> hba->saved_uic_err latched during the retry? Should ufshcd_hba_stop(hba) be
> called before cancelling hba->eh_work, clearing the error state, and
> resetting the device?

It's a valid concern, will fix it in v3.

> 
> [Severity: High]
> Can this retry path also leak the hwmon device and struct ufs_hwmon_data if
> ufshcd_full_device_init() fails in ufshcd_post_device_init() after
> ufshcd_device_params_init() has already succeeded?
> 
> During ufshcd_full_device_init(), the call chain is:
> 
> 	ufshcd_device_params_init()
> 	  ufs_get_device_desc()
> 	    ufshcd_temp_notif_probe()
> 	      ufshcd_enable_ee(hba, mask);
> 	      ufs_hwmon_probe(hba, mask);
> 	ufshcd_post_device_init()
> 	  ufshcd_config_pwr_mode()
> 
> If ufshcd_post_device_init() fails, ufs_put_device_desc() only frees
> dev_info->model and dev_info->device_id. On the next iteration,
> ufs_hwmon_probe() in drivers/ufs/core/ufs-hwmon.c allocates a new
> struct ufs_hwmon_data, registers a second hwmon device, and overwrites
> hba->hwmon_device:
> 
> 	data = kzalloc_obj(*data);
> 	if (!data)
> 		return;
> 	...
> 	hwmon = hwmon_device_register_with_info(dev, "ufs", data, &ufs_hwmon_hba_info, NULL);
> 	...
> 	hba->hwmon_device = hwmon;
> 
> In addition, hba->ee_ctrl_mask and hba->ee_drv_mask retain the bits set by
> ufshcd_enable_ee() before ufshcd_device_reset() reset the device, which
> causes ufshcd_update_ee_control() on the next attempt to see an unchanged
> mask and skip writing the exception event control attribute to the device.
> Should the retry cleanup call ufs_hwmon_remove(hba) and clear the exception
> event masks?

Ack.

> 
>> +		if (ufshcd_hba_enable(hba)) {
>> +			dev_err(hba->dev, "Host controller enable failed\n");
>> +			ufshcd_print_evt_hist(hba);
>> +			ufshcd_print_host_state(hba);
>> +			goto out_release;
>> +		}
>> +
>> +		/* Reconfigure MCQ upon controller re-enable */
>> +		if (hba->mcq_enabled) {
>> +			ufshcd_config_mcq(hba);
>> +			ufshcd_mcq_enable(hba);
>> +		}
> 
> [Severity: High]
> Is the ordering of ufshcd_config_mcq(hba) and ufshcd_mcq_enable(hba) here
> intended?
> 
> On the initial probe path, ufshcd_add_scsi_host() calls ufshcd_mcq_enable()
> first, and ufshcd_full_device_init() calls ufshcd_config_mcq() only after
> ufshcd_link_startup() completes:
> 
> 	err = ufshcd_link_startup(hba);
> 	if (err)
> 		return err;
> 
> 	if (hba->mcq_enabled)
> 		ufshcd_config_mcq(hba);
> 
> In the retry path of ufshcd_init(), calling ufshcd_config_mcq(hba) before
> ufshcd_mcq_enable(hba) configures the queues and enables them in
> ufshcd_mcq_make_queues_operational() before ufshcd_mcq_enable() selects
> multi-circular queue mode in REG_UFS_MEM_CFG and before the next attempt's
> ufshcd_link_startup(hba). Then, when ufshcd_full_device_init() runs on the
> next iteration, it calls ufshcd_config_mcq(hba) a second time while the
> hardware queues are already enabled.
> 
> Furthermore, if ufshcd_link_startup() encounters an error on its own retry
> and calls ufshcd_hba_enable(hba), the controller reset will clear
> REG_UFS_MEM_CFG again without ufshcd_mcq_enable(hba) being re-applied before
> ufshcd_config_mcq(hba). Should the retry path only call
> ufshcd_mcq_enable(hba) (or should ufshcd_mcq_enable(hba) be called right
> before ufshcd_config_mcq(hba) inside ufshcd_full_device_init())?

My platform doesn't support MCQ, so actually I cannot test
this path. Will look into it.

> 

