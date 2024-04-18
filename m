Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4E563D5
	for <linux-scsi@vger.kernel.org>; Thu, 18 Apr 2024 02:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713408961; cv=none; b=obaPVEg1B07QKolZnaW4DFd+ee+PPSU5HQZUgN2j2BLnea2qn28D0UGReeusfxVDME/B8hftP6JYPGCWAKdR7NDGwFP/1kXtVhC+NvyyAnvoJsH1Fn20Fc35PqL5/9oMelEzG6Fqp/ZH9pkTsl5HMYegMSnmzZdYfyF51/mJjGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713408961; c=relaxed/simple;
	bh=ZbMTj2LcTG25khgbXRykONXFN3HlOFtzAntYKZIsrP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N4knV3KaIl4IBKXMIlL4GXAD8J5JPaod/VksyQmsbA1XxtPbCCoBDCI7d3xljN65UFL7IASPNlB9pIjB+10WIZqxXr7WqM6djtvyGzBNNIEHvdwVOy2sYLfga9lNH/CRD5CSu4WO0BjXlOne3cBMc2P25jEOr8+jcYszBB4/wB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QHlO4G+K; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QHlO4G+K"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1e40042c13eso3199115ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2024 19:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713408959; x=1714013759; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=90b5Pk3JLEXPuwNPofcOB7rj3EMCJuvhStc2PAZZ7YA=;
        b=QHlO4G+Kz+/F744j1SI0XHlbDPLB75qz5GAaR9/HjiWFCyaMmM5b8ZdPK5ProJ6y+Y
         HWYl9agodW1u/J2jCak7H6uzpKX3bt5H2b4f94wrgqfB/qhPIWjI4NqhZuHwUKp3vOEx
         fpzaqy/vDU7tlFN1bns832xGq7ckZL8zb8pdICdcS93XQSfVAlR9HofFAHwBAnuLS1s6
         gG9ul5hFafSAm56NaHhchlIgRW4M+IVdGdCM+VX+C3n3vwTAHSIdPp1Kzpg3nD8euoFF
         m88g3WArx9togtAPYZrt65DXxL7evt/3Tm/e6pyHZ8an8X5GUE4h/j+/oinIO9KGAOo4
         +D6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713408959; x=1714013759;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=90b5Pk3JLEXPuwNPofcOB7rj3EMCJuvhStc2PAZZ7YA=;
        b=rPzek0Ai6zP3iOigfA8Lml+xvwpaz1IsqXC+KREe2VtazN0+tZ746aQVB0sIEiLEo6
         jxfeRhT199AS8TO3iXSjBublA/kY7xI4gpM2oEL+3ll7CRy6KFRp0dyulTjUNBdH8ESd
         zTxGv8wK7E0cHvcf/ww5xvH+wDEK4ZVAMrBqhmpACstxhruHNnpoLXfFyk66vQ22i+8Q
         pTm+vZewSoONlKrePQFNKc3z9AchxjwiK4LKU9PNakaToWOe3I7903Cra+dqP4C97xTC
         dCYD15QAUbuTnxOxkFP06ipZk6+nQI6pyQG/+zkGXcgrznSAIALOYlQ3IBtl4yG99+xV
         5FgA==
X-Gm-Message-State: AOJu0YyChESHcaTLZ/Hbs9p2SkIqaoN45X6h1bsvTdP0bOi74Kz+mQSU
	GM4/a2DnUa5vFwHXiFaRPYEoQCrkuIdhoy5f1/AwKUoDrUAL4XXf
X-Google-Smtp-Source: AGHT+IGDGFXb5xipnkLazhaMuLzTpZAYCtcRiZLXhbUaJB7ILiGQ5Qy5XBryxE2Tp8gQGz542xTO4A==
X-Received: by 2002:a17:902:bcc7:b0:1e8:1dc0:601f with SMTP id o7-20020a170902bcc700b001e81dc0601fmr1445036pls.55.1713408959503;
        Wed, 17 Apr 2024 19:55:59 -0700 (PDT)
Received: from [0.0.0.0] (74.211.104.32.16clouds.com. [74.211.104.32])
        by smtp.gmail.com with ESMTPSA id x6-20020a170902820600b001e43df03096sm371921pln.30.2024.04.17.19.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 19:55:59 -0700 (PDT)
Message-ID: <6f9b424a-040d-4c82-ad2a-cea4684548b0@gmail.com>
Date: Thu, 18 Apr 2024 10:55:53 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] scsi: ufs: Check for completion from the timeout
 handler
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Avri Altman <avri.altman@wdc.com>, Stanley Jhu <chu.stanley@gmail.com>,
 Can Guo <quic_cang@quicinc.com>, Peter Wang <peter.wang@mediatek.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Andrew Halaney <ahalaney@redhat.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Bean Huo <beanhuo@micron.com>
References: <20240416171357.1062583-1-bvanassche@acm.org>
 <20240416171357.1062583-5-bvanassche@acm.org>
Content-Language: en-US
From: Wenchao Hao <haowenchao22@gmail.com>
In-Reply-To: <20240416171357.1062583-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024/4/17 1:13, Bart Van Assche wrote:
> If ufshcd_abort() returns SUCCESS for an already completed command then
> that command is completed twice. This results in a crash. Prevent this by
> checking whether a command has completed without completion interrupt from
> the timeout handler. This CL fixes the following kernel crash:
> 
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
>  drivers/ufs/core/ufshcd.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c552bf391f79..c44515605031 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8880,6 +8880,25 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>  static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
>  {
>  	struct ufs_hba *hba = shost_priv(scmd->device->host);
> +	struct scsi_cmnd *cmd2 = scmd;
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
> +		sdev_printk(KERN_INFO, scmd->device,
> +			    "%s: cmd with tag %#x has already been completed\n",
> +			    __func__, blk_mq_unique_tag(scsi_cmd_to_rq(scmd)));

Would here cause a UAF because the scsi_cmnd has already been completed?
If UAF would not happen, I think maybe scmd_printk() would be better than sdev_printk()

> +		return SCSI_EH_DONE;
> +	}
>  
>  	if (!hba->system_suspending) {
>  		/* Activate the error handler in the SCSI core. */
> 

