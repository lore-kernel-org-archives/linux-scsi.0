Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79FC3624C6
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 13:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776258060; cv=none; b=q1sOSb8f3+/QlQYQsZ07A0BRNtP7c7Bu2aa/PbNfGHupcGbB5qAgmM8bDrPdLwEC++xwKicNQfGo6EkUmdRqOiSh1FYlWOQz7YCsovsISo4VLOtj14nRgocfJa6K1m1FRplona7E7qM2dD/j6IfrxrV648gX2A9m6oVArINrOuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776258060; c=relaxed/simple;
	bh=Dw63usdIYDOJUgLtDGQbN0vRnfj1p110y6pgTk4UsA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p5o8G8469mBmY/sYVzjv6OwspSfPjq1wrn4fBebas94s0WxtxJqQ30ZtYogl86EiFhNm4kLxBIJS1E8mbQTGmbRXx8QDjvEVPm4AXMDSGkEewqa8rChJy1suXCM5HB4jSbT7isnp0sxZcqYbfg1hy45T+huv1RfJXwDQrfNSB4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SLH5/h4V; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cDMUd13X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SLH5/h4V";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cDMUd13X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776258057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fyVgteRHuuY2XCBfLJMks6rBuxhNtn6IXJbU3IFaaMU=;
	b=SLH5/h4VADnvmpFPGZJdIdd5w2xpYJdV31WV/twbjfzf9woSj1jhMY+ZnBt7R/2s0D6Dvz
	ykqBNcXYeR514b7mJcVJA5nxZNgb957QLl7oLx5UajqdfL5z0bTVnpWhWTBsHdKfE/Pv7/
	egv+eKP0rcrreorWs9sbT87IWE+6HfI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-K5BB5psWPNiNh1kBnl7YYw-1; Wed, 15 Apr 2026 09:00:56 -0400
X-MC-Unique: K5BB5psWPNiNh1kBnl7YYw-1
X-Mimecast-MFC-AGG-ID: K5BB5psWPNiNh1kBnl7YYw_1776258055
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43d744128b9so2929426f8f.0
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 06:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776258055; x=1776862855; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fyVgteRHuuY2XCBfLJMks6rBuxhNtn6IXJbU3IFaaMU=;
        b=cDMUd13XeBUMbe5FICF7ear1iwqtqhuVqEBPWpbTUVSmYGRS6sPgOM1zkzT+cnOzxc
         H4keELPNNeyHh2CP8eYozP+B7kQH32QMOm2CofhdNatIn4Gv1jY4Wf86EkfTxpjzf92L
         rlOXW3Jwg8UjjDNcrkjnAWygetVVyZPQjCblDnfMljBz0nnSyz8ond0oEOznKVn2Bc0M
         D+w8lIae8nyrVUUhXbu2/cEysqTd3pimpc+4P/p8SthpNckwLka3/cREJcatqzxALUVN
         wmJP546JJv0bcG+A1Rb073yUIyVI0wHe0woiluiIwFCqu8qWYRt03u7ROWpD4j/Nrzg1
         VSig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776258055; x=1776862855;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fyVgteRHuuY2XCBfLJMks6rBuxhNtn6IXJbU3IFaaMU=;
        b=FsIkh4jhbM/tC8eic3tJqtf9mGhaiWRASsR1+FetVQpehUDsllGHo7Ze1GLiYTcZti
         CngYeH/v8qs+b2xmrTOf7tIP1M/FJIXDSmm3iQNkGaTdN5T4GfqJUiDHRZflPKYtFUs+
         bUfsI+SJRKxYs5zEC93qDbP+XQhJi27jwwbBAUaep8VIg68RRKjjBtIr6NZKlgJN8VnR
         CgCHWexwlTNRCxkm5nsmfSjIo4kw7JbobcPWGqG2HtLYPwcaKGWNGTtx3vpFfNfoIDPj
         +TUlKXoN6DxzKa2dDFhHxAfGpX64X9BDIr/LKqeSDZqNQr/4AcfzK+InksInI7H7vwnk
         W+2Q==
X-Forwarded-Encrypted: i=1; AFNElJ/UEj89v26NNdSMgBAbwnze1s8POmLJJZlUZCSOjfNtAXDSFFRNeosbJqyqsY3qiEzK1xtamXqXpaL6@vger.kernel.org
X-Gm-Message-State: AOJu0YynsIo6PTE8yELuB2dBQA3dIWcTkbuqethLKjGY5LLMgjLkKX6D
	wgOy/vHW4RHa2l/8wlhw6D1YLZ5m3FjkiDLCNN3ilCGzC9rcC258xbc+IMng+cATdk9Eat5oLM/
	C+WRGu+uvYmRGl5L5tEfdSntRzVYttT7DJAAp2WJFeqW4wJvVZ5OhoWD9kDOibYk=
X-Gm-Gg: AeBDieuyZeIhxow7v55cs2XspbbGIfDREsKANx3Ud+SI5is4n/uoW3SXWrhxGmDpFMi
	VNdCMbMmAZpB3AcoGFXAj52G5HwoBa5w0lh8rCuFUGMWlSvEfoRjXq8B1V1q2UYkSgDAizT6l09
	q8qdDoJOZcF8hEKdhpK2rOSjGr89mIQzIIqmRHNw+qe8nLevPNuQrvFkRegSLvI6NaQJpY/QLrc
	rBP++FXVUV2cvRyj7LS5Qs1RODaij0rjx+HZFgq2x1NyxH3nNmEm7I/lhHL/HZis57ezjmnuC/t
	A/pcDXBboiHicIOLURo6YE3ZmKzfVD3BsdPKxk4PC6JcQcfvL8yAKoOnwbi+0Or1bj2IMncJdYL
	Kr1gCIH/dfc5tUQZ5/3V0hgGZRe5poWnY0xlc/HUQdrup7abUrKvfV2Ax34TowHYR
X-Received: by 2002:a5d:64e3:0:b0:43d:7b90:fa23 with SMTP id ffacd0b85a97d-43d7b90fe37mr17730231f8f.29.1776258055051;
        Wed, 15 Apr 2026 06:00:55 -0700 (PDT)
X-Received: by 2002:a5d:64e3:0:b0:43d:7b90:fa23 with SMTP id ffacd0b85a97d-43d7b90fe37mr17730128f8f.29.1776258054314;
        Wed, 15 Apr 2026 06:00:54 -0700 (PDT)
Received: from [192.168.0.150] (78-80-81-193.customers.tmcz.cz. [78.80.81.193])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead33d670sm5344057f8f.2.2026.04.15.06.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2026 06:00:53 -0700 (PDT)
Message-ID: <9503cc3e-2764-4e30-a5eb-fc996ff0555d@redhat.com>
Date: Wed, 15 Apr 2026 15:00:52 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: smartpqi silence a recursive lock warning
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc: Don.Brace@microchip.com
References: <20260414124118.23661-1-thenzl@redhat.com>
 <da1c23ea-5635-4872-b448-33f71219abc0@acm.org>
Content-Language: en-US
From: Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <da1c23ea-5635-4872-b448-33f71219abc0@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/14/26 6:38 PM, Bart Van Assche wrote:
> On 4/14/26 5:41 AM, Tomas Henzl wrote:
>> On systems with multiple controllers debug kernel shows
>> WARNING: possible recursive locking detected
>> during shutdown.
>> Each controller does have its own ctrl_info (and mutex)
>> and that isn't correctly recognized by debug kernel.
>> Supress the warning by releasing the mutex at the end of pqi_shutdown.
>>
>> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>> ---
>>   drivers/scsi/smartpqi/smartpqi_init.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
>> index b4ed991976d0..2026ac645d6a 100644
>> --- a/drivers/scsi/smartpqi/smartpqi_init.c
>> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
>> @@ -9427,6 +9427,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
>>   
>>   	pqi_crash_if_pending_command(ctrl_info);
>>   	pqi_reset(ctrl_info);
>> +	pqi_ctrl_unblock_device_reset(ctrl_info);
>>   }
>>   
>>   static void pqi_process_lockup_action_param(void)
> 
> This patch looks fine to me but the description not. I think this patch
> fixes a real bug rather than only suppressing a lockdep complaint.

Each mutex lock ought to have a corresponding unlock.
However, in cases where a driver exits a shutdown function while holding
a mutex, this is not strictly necessary. The shutdown process will
continue, and once the power is off, everything is effectively reset.

I chose to add the unlock rather than use lockdep classes,
mainly because that is what most developers expect.

A potential problem is that, after introducing the unlock, a hypothetical
situation could arise where another thread, which would previously
have remained blocked, is now able to proceed, and something bad could
happen as a result. I looked into this possibility and believe that it
is safe.

I think that the missing unlock was an oversight rather than an intention.


> 
> Additionally, all uses of mutexes in the entire driver probably should
> be reviewed. Here are other questionable constructs in this driver I
> know of:
> - pqi_ofa_memory_alloc_worker() locks &ctrl_info->ofa_mutex but doesn't
>    unlock it. This mutex probably gets unlocked from the context of
>    another thread, something that is not allowed.
> - There is code in this driver that calls
>    mutex_is_locked(&ctrl_info->ofa_mutex) (pqi_ofa_in_progress()) and
>    next calls mutex_unlock(&ctrl_info->ofa_mutex) without checking
>    whether the mutex_lock() call happened by the same thread that calls
>    mutex_unlock().
> 
> All the __acquire() and __release() statements in the patch below should
> be reviewed.

You are likely right, but I posted this fix to address the warning and
for now I'd like to stick with that.

Thanks,
tomash

> 
> Thanks,
> 
> Bart.
> 
> 
> diff --git a/drivers/scsi/smartpqi/Makefile b/drivers/scsi/smartpqi/Makefile
> index 28985e508b5c..71db5cd96284 100644
> --- a/drivers/scsi/smartpqi/Makefile
> +++ b/drivers/scsi/smartpqi/Makefile
> @@ -1,3 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0
> +
> +CONTEXT_ANALYSIS := y
> +
>   obj-$(CONFIG_SCSI_SMARTPQI) += smartpqi.o
>   smartpqi-objs := smartpqi_init.o smartpqi_sis.o smartpqi_sas_transport.o
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c 
> b/drivers/scsi/smartpqi/smartpqi_init.c
> index b4ed991976d0..f99eef39ede4 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -306,12 +306,14 @@ static inline void 
> pqi_save_fw_triage_setting(struct pqi_ctrl_info *ctrl_info, b
>   }
> 
>   static inline void pqi_ctrl_block_scan(struct pqi_ctrl_info *ctrl_info)
> +	__acquires(ctrl_info->scan_mutex)
>   {
>   	ctrl_info->scan_blocked = true;
>   	mutex_lock(&ctrl_info->scan_mutex);
>   }
> 
>   static inline void pqi_ctrl_unblock_scan(struct pqi_ctrl_info *ctrl_info)
> +	__releases(ctrl_info->scan_mutex)
>   {
>   	ctrl_info->scan_blocked = false;
>   	mutex_unlock(&ctrl_info->scan_mutex);
> @@ -323,11 +325,13 @@ static inline bool pqi_ctrl_scan_blocked(struct 
> pqi_ctrl_info *ctrl_info)
>   }
> 
>   static inline void pqi_ctrl_block_device_reset(struct pqi_ctrl_info 
> *ctrl_info)
> +	__acquires(ctrl_info->lun_reset_mutex)
>   {
>   	mutex_lock(&ctrl_info->lun_reset_mutex);
>   }
> 
>   static inline void pqi_ctrl_unblock_device_reset(struct pqi_ctrl_info 
> *ctrl_info)
> +	__releases(ctrl_info->lun_reset_mutex)
>   {
>   	mutex_unlock(&ctrl_info->lun_reset_mutex);
>   }
> @@ -430,11 +434,13 @@ static inline bool pqi_device_offline(struct 
> pqi_scsi_dev *device)
>   }
> 
>   static inline void pqi_ctrl_ofa_start(struct pqi_ctrl_info *ctrl_info)
> +	__acquires(ctrl_info->ofa_mutex)
>   {
>   	mutex_lock(&ctrl_info->ofa_mutex);
>   }
> 
>   static inline void pqi_ctrl_ofa_done(struct pqi_ctrl_info *ctrl_info)
> +	__releases(ctrl_info->ofa_mutex)
>   {
>   	mutex_unlock(&ctrl_info->ofa_mutex);
>   }
> @@ -2299,6 +2305,7 @@ static void pqi_update_device_list(struct 
> pqi_ctrl_info *ctrl_info,
>   	 * requests before removal.
>   	 */
>   	if (pqi_ofa_in_progress(ctrl_info)) {
> +		__acquire(&ctrl_info->lun_reset_mutex);
>   		list_for_each_entry_safe(device, next, &delete_list, delete_list_entry)
>   			if (pqi_is_device_added(device))
>   				pqi_device_remove_start(device);
> @@ -3661,6 +3668,8 @@ static void pqi_process_soft_reset(struct 
> pqi_ctrl_info *ctrl_info)
>   		pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
>   		rc = pqi_ofa_ctrl_restart(ctrl_info, delay_secs);
>   		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
> +		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
> +		__acquire(&ctrl_info->ofa_mutex);
>   		pqi_ctrl_ofa_done(ctrl_info);
>   		dev_info(&ctrl_info->pci_dev->dev,
>   				"Online Firmware Activation: %s\n",
> @@ -3672,6 +3681,8 @@ static void pqi_process_soft_reset(struct 
> pqi_ctrl_info *ctrl_info)
>   		if (ctrl_info->soft_reset_handshake_supported)
>   			pqi_clear_soft_reset_status(ctrl_info);
>   		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
> +		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
> +		__acquire(&ctrl_info->ofa_mutex);
>   		pqi_ctrl_ofa_done(ctrl_info);
>   		pqi_ofa_ctrl_unquiesce(ctrl_info);
>   		break;
> @@ -3682,6 +3693,8 @@ static void pqi_process_soft_reset(struct 
> pqi_ctrl_info *ctrl_info)
>   			"unexpected Online Firmware Activation reset status: 0x%x\n",
>   			reset_status);
>   		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
> +		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
> +		__acquire(&ctrl_info->ofa_mutex);
>   		pqi_ctrl_ofa_done(ctrl_info);
>   		pqi_ofa_ctrl_unquiesce(ctrl_info);
>   		pqi_take_ctrl_offline(ctrl_info, PQI_OFA_RESPONSE_TIMEOUT);
> @@ -3698,6 +3711,8 @@ static void pqi_ofa_memory_alloc_worker(struct 
> work_struct *work)
>   	pqi_ctrl_ofa_start(ctrl_info);
>   	pqi_host_setup_buffer(ctrl_info, &ctrl_info->ofa_memory, 
> ctrl_info->ofa_bytes_requested, ctrl_info->ofa_bytes_requested);
>   	pqi_host_memory_update(ctrl_info, &ctrl_info->ofa_memory, 
> PQI_VENDOR_GENERAL_OFA_MEMORY_UPDATE);
> +	/* This function acquires &ctrl_info->ofa_mutex and doesn't release it. */
> +	__release(&ctrl_info->ofa_mutex);
>   }
> 
>   static void pqi_ofa_quiesce_worker(struct work_struct *work)
> @@ -3738,6 +3753,8 @@ static bool pqi_ofa_process_event(struct 
> pqi_ctrl_info *ctrl_info,
>   			"received Online Firmware Activation cancel request: reason: %u\n",
>   			ctrl_info->ofa_cancel_reason);
>   		pqi_host_free_buffer(ctrl_info, &ctrl_info->ofa_memory);
> +		/* What guarantees that &ctrl_info->ofa_mutex is held here? */
> +		__acquire(&ctrl_info->ofa_mutex);
>   		pqi_ctrl_ofa_done(ctrl_info);
>   		break;
>   	default:
> @@ -8726,6 +8743,7 @@ static int pqi_ctrl_init_resume(struct 
> pqi_ctrl_info *ctrl_info)
>   	}
> 
>   	if (pqi_ofa_in_progress(ctrl_info)) {
> +		__acquire(&ctrl_info->scan_mutex);
>   		pqi_ctrl_unblock_scan(ctrl_info);
>   		if (ctrl_info->ctrl_logging_supported) {
>   			if (!ctrl_info->ctrl_log_memory.host_memory)
> @@ -8938,6 +8956,8 @@ static void pqi_remove_ctrl(struct pqi_ctrl_info 
> *ctrl_info)
>   }
> 
>   static void pqi_ofa_ctrl_quiesce(struct pqi_ctrl_info *ctrl_info)
> +	__acquires(&ctrl_info->scan_mutex)
> +	__acquires(&ctrl_info->lun_reset_mutex)
>   {
>   	pqi_ctrl_block_scan(ctrl_info);
>   	pqi_scsi_block_requests(ctrl_info);
> @@ -8948,6 +8968,8 @@ static void pqi_ofa_ctrl_quiesce(struct 
> pqi_ctrl_info *ctrl_info)
>   }
> 
>   static void pqi_ofa_ctrl_unquiesce(struct pqi_ctrl_info *ctrl_info)
> +	__releases(&ctrl_info->lun_reset_mutex)
> +	__releases(&ctrl_info->scan_mutex)
>   {
>   	pqi_start_heartbeat_timer(ctrl_info);
>   	pqi_ctrl_unblock_requests(ctrl_info);
> @@ -9410,6 +9432,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
>   	pqi_ctrl_block_device_reset(ctrl_info);
>   	pqi_ctrl_block_requests(ctrl_info);
>   	pqi_ctrl_wait_until_quiesced(ctrl_info);
> +	__release(&ctrl_info->lun_reset_mutex);
> 
>   	if (system_state == SYSTEM_RESTART)
>   		shutdown_event = RESTART;
> @@ -9486,6 +9509,8 @@ static inline enum bmic_flush_cache_shutdown_event 
> pqi_get_flush_cache_shutdown_
>   }
> 
>   static int pqi_suspend_or_freeze(struct device *dev, bool suspend)
> +	__acquires(&((struct pqi_ctrl_info 
> *)pci_get_drvdata(to_pci_dev(dev)))->scan_mutex)
> +	__acquires(&((struct pqi_ctrl_info 
> *)pci_get_drvdata(to_pci_dev(dev)))->lun_reset_mutex)
>   {
>   	struct pci_dev *pci_dev;
>   	struct pqi_ctrl_info *ctrl_info;
> @@ -9519,11 +9544,15 @@ static int pqi_suspend_or_freeze(struct device 
> *dev, bool suspend)
>   }
> 
>   static __maybe_unused int pqi_suspend(struct device *dev)
> +	__acquires(&((struct pqi_ctrl_info 
> *)pci_get_drvdata(to_pci_dev(dev)))->scan_mutex)
> +	__acquires(&((struct pqi_ctrl_info 
> *)pci_get_drvdata(to_pci_dev(dev)))->lun_reset_mutex)
>   {
>   	return pqi_suspend_or_freeze(dev, true);
>   }
> 
>   static int pqi_resume_or_restore(struct device *dev)
> +	__cond_releases(0, &((struct pqi_ctrl_info 
> *)pci_get_drvdata(to_pci_dev(dev)))->lun_reset_mutex)
> +	__cond_releases(0, &((struct pqi_ctrl_info 
> *)pci_get_drvdata(to_pci_dev(dev)))->scan_mutex)
>   {
>   	int rc;
>   	struct pci_dev *pci_dev;
> @@ -9547,11 +9576,15 @@ static int pqi_resume_or_restore(struct device *dev)
>   }
> 
>   static int pqi_freeze(struct device *dev)
> +	__acquires(&((struct pqi_ctrl_info 
> *)pci_get_drvdata(to_pci_dev(dev)))->scan_mutex)
> +	__acquires(&((struct pqi_ctrl_info 
> *)pci_get_drvdata(to_pci_dev(dev)))->lun_reset_mutex)
>   {
>   	return pqi_suspend_or_freeze(dev, false);
>   }
> 
>   static int pqi_thaw(struct device *dev)
> +	__cond_releases(0, &((struct pqi_ctrl_info 
> *)pci_get_drvdata(to_pci_dev(dev)))->lun_reset_mutex)
> +	__cond_releases(0, &((struct pqi_ctrl_info 
> *)pci_get_drvdata(to_pci_dev(dev)))->scan_mutex)
>   {
>   	int rc;
>   	struct pci_dev *pci_dev;
> 

