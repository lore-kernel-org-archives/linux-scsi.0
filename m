Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E646FC6
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 03:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719460248; cv=none; b=DtItjw1sIRrSHLdkmgUcJTou4DLROD17EtDxasBGcUkPMJ9m11paakCONRurE8BzWoaXOP5mvL8JCJFsTXIQk73A/S3jNqUsYV4L/6F2vONR6q4KuCGZ6rtFhXSxuZLOXKaFu9d+/qgoIbxYi/mcNV/7xPpPrY1gfTXqg0QavMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719460248; c=relaxed/simple;
	bh=W990NWdmtidMM9+QbPMlQSV+XxmKPYqqM/tLNLUkqgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZLyQXE0RXg9m2mw0HQEvr06Q06O/9uDKEMFY7aiYnSn9Ynmn21DqQskyY2zYSIDpoacP3QDbKWtbpQuQl9GPG/m7ZoNV1MJbSW1AZnYDSDIhUKX8bbPIrEbsri0Fcl5gHIz2kwpzed+2oUAWX2qBTT7R2DVKRRAub49YZThju7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HQh6TwUX; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HQh6TwUX"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3d56285aa18so588959b6e.2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 20:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719460246; x=1720065046; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EDlXTb3kX/YDPJ4ful/KCceKwRm4ZQ9e5m6kFqDnix4=;
        b=HQh6TwUXQXj69FnNQLgMUQ47kKSTyi01s7NOIPSc8Nv2dAxStSB8u6qtImjNQYzCSN
         3LFmAdOldk/DSA9n4jrXQae+PN8lxpKvf4LJ4PbDU0cpWc2BLvdbzwRG7/+JcA8aBa5Q
         HtsDJ4Jf4ECMsTnUPp/y27fCxErtNnHtfmM6ibvpV08Grvxt8bzV8VkzKLfOwSclgwSD
         8ZrG68AzaArS6bdR5n3HqjlMFeT6wQm2M+C+e0ltoxgWbB0h6cBjUjAoXlKieaq7oWqD
         QfBWl9x6n4YOOVh0ScftZ+7lHmn1FexeBqdBoXwCe2Rp1xfgZAPWtsylwGK4pNbTc4GF
         dS3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719460246; x=1720065046;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EDlXTb3kX/YDPJ4ful/KCceKwRm4ZQ9e5m6kFqDnix4=;
        b=BDpwseIDC6Yf+KIWZZyB1ogVoaNZskHJkYd/kWTVriy5qUkLgEOWb7POT6l6tt9gUb
         ARCRZMAPMajf3QbzI68bmGDN5M1ehu75DyYElLRfaY8/WBIf50d0mPAeMOHbExNCJ3zy
         L46GTRECBMPinTkImM1wSRoqBBL9ZNXmIeIr6RRHlQTbyJwx57RxzCquPvayNjgjNLQc
         j1/LPkJyvMZOu279okZ8esH5QqXYTPvb8zuLlYwL+3sNHIH0054htIVvBjXDLtoDa0y8
         230DpuWqqPkXkoCpAxju2WKsxAjFqTiia7bnJp8t+8CmZREUf8FO/vYXNs3qNwbBmMcl
         Qi0w==
X-Gm-Message-State: AOJu0YwMNHhhKgpVlk13VdgfXLj6Tt9Bzq6Kj4l2dc8QLxBp5VusAyFF
	Pj7YOzpQuG+B23ldmRTAHGvbpLqS48mPCxiAXoHf7RJRwqzUwLPO
X-Google-Smtp-Source: AGHT+IG2evUI+O/RPw0eZ+e9xJthAR6dXzj6RkYeb1t9g1WiZ9J/NzTqITlPo1VjvHQR0yW9CuMDpg==
X-Received: by 2002:a05:6808:21a6:b0:3d2:27ef:264f with SMTP id 5614622812f47-3d54595d9e5mr14885704b6e.10.1719460244599;
        Wed, 26 Jun 2024 20:50:44 -0700 (PDT)
Received: from [0.0.0.0] (97.64.23.41.16clouds.com. [97.64.23.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-706b4a6071bsm265108b3a.212.2024.06.26.20.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jun 2024 20:50:44 -0700 (PDT)
Message-ID: <a4ad73c7-0a8e-4f87-b9fc-f3a2d58d5206@gmail.com>
Date: Thu, 27 Jun 2024 11:50:36 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@wdc.com>, Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Bean Huo <beanhuo@micron.com>, Andrew Halaney <ahalaney@redhat.com>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-9-bvanassche@acm.org>
From: Wenchao Hao <haowenchao22@gmail.com>
In-Reply-To: <20240617210844.337476-9-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024/6/18 5:07, Bart Van Assche wrote:
> If ufshcd_abort() returns SUCCESS for an already completed command then
> that command is completed twice. This results in a crash. Prevent this by
> checking whether a command has completed without completion interrupt from
> the timeout handler. This CL fixes the following kernel crash:
> 

Hi Bart,

Could you describe in more detail about how command completed twice happened?
I think this would not happen, below is my analysis, if it is wrong, please
correct me.

In your description, ufshcd_abort() returns SUCCESS is condition which trigger
the issue.

There are 2 paths would call ufshcd_abort(). The first one is triggered by
block layer's timeout, which is:

scsi_timeout()
        hostt->eh_timed_out() [ufshcd_eh_timed_out]
                                // return SCSI_EH_NOT_HANDLED
        test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state)
                                // return true
        scsi_abort_command()
                queue_delayed_work(shost->tmf_work_q, &scmd->abort_work, ...)

The above flow would trigger ufshcd_abort() be called in workqueue:

scmd_eh_abort_handler()
        scsi_try_to_abort_cmd()
                hostt->eh_abort_handler() [ufshcd_abort]

While when ufshcd_abort() is called by above flow, the command has been marked
as SCMD_STATE_COMPLETE, and it means scsi_timeout() win the scsi_done(), so 
normal context(usually  triggered by driver's irq handler which call scsi_done())
would not handle this command any more.
The only path which would handle this command is scmd_eh_abort_handler() if
ufshcd_abort() return SUCCESS.

Is any other context which would finish this command?

Another path is:

scsi_send_eh_cmnd()
        shost->hostt->queuecommand() // queued command did not finish in time
        scsi_abort_eh_cmnd()

This is error handler path when host is set to RECOVERY state, no new normal
command would be send any more. What's more, if ufshcd_abort() is called now,
the aborted command is also command send in scsi_send_eh_cmnd().

> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> Call trace:
>  dma_direct_map_sg+0x70/0x274
>  scsi_dma_map+0x84/0x124
>  ufshcd_queuecommand+0x3fc/0x880
>  scsi_queue_rq+0x7d0/0x111c
>  blk_mq_dispatch_rq_list+0x440/0xebc
>  blk_mq_do_dispatch_sched+0x5a4/0x6b8
>  __blk_mq_sched_dispatch_requests+0x150/0x220
>  __blk_mq_run_hw_queue+0xf0/0x218
>  __blk_mq_delay_run_hw_queue+0x8c/0x18c
>  blk_mq_run_hw_queue+0x1a4/0x360
>  blk_mq_sched_insert_requests+0x130/0x334
>  blk_mq_flush_plug_list+0x138/0x234
>  blk_flush_plug_list+0x118/0x164
>  blk_finish_plug()
>  read_pages+0x38c/0x408
>  page_cache_ra_unbounded+0x230/0x2f8
>  do_sync_mmap_readahead+0x1a4/0x208
>  filemap_fault+0x27c/0x8f4
>  f2fs_filemap_fault+0x28/0xfc
>  __do_fault+0xc4/0x208
>  handle_pte_fault+0x290/0xe04
>  do_handle_mm_fault+0x52c/0x858
>  do_page_fault+0x5dc/0x798
>  do_translation_fault+0x40/0x54
>  do_mem_abort+0x60/0x134
>  el0_da+0x40/0xb8
>  el0t_64_sync_handler+0xc4/0xe4
>  el0t_64_sync+0x1b4/0x1b8
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index e3835e61e4b1..47cc0802c4f4 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8922,7 +8922,28 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>  
>  static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
>  {
> -	struct ufs_hba *hba = shost_priv(scmd->device->host);
> +	struct scsi_device *sdev = scmd->device;
> +	struct ufs_hba *hba = shost_priv(sdev->host);
> +	struct scsi_cmnd *cmd2 = scmd;
> +	const u32 unique_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
> +
> +	WARN_ON_ONCE(!scmd);
> +
> +	if (is_mcq_enabled(hba)) {
> +		struct request *rq = scsi_cmd_to_rq(scmd);
> +		struct ufs_hw_queue *hwq = ufshcd_mcq_req_to_hwq(hba, rq);
> +
> +		ufshcd_mcq_poll_cqe_lock(hba, hwq, &cmd2);
> +	} else {
> +		__ufshcd_poll(hba->host, UFSHCD_POLL_FROM_INTERRUPT_CONTEXT,
> +			      &cmd2);
> +	}
> +	if (cmd2 == NULL) {
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: cmd with tag %#x has already been completed\n",
> +			    __func__, unique_tag);
> +		return SCSI_EH_DONE;
> +	}
>  
>  	if (!hba->system_suspending) {
>  		/* Activate the error handler in the SCSI core. */
> 

