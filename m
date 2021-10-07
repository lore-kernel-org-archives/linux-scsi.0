Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33125C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1747F60F51
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242546AbhJGVtI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:49:08 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:37821 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbhJGVtI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:49:08 -0400
Received: by mail-pf1-f173.google.com with SMTP id q19so5981760pfl.4;
        Thu, 07 Oct 2021 14:47:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XmCI1FNC/AApgJUnJ9aARbqTG/luu8fBLN0UmqhN8Ks=;
        b=5PqFNKfVKB9gfu3dlYPKpBrCidmq4M8IfQCFPxCArA9PhYUvjNzNGd5bCbvRkxJNx/
         dHzx2n6WHw2rytgVYmRKWOVHc/SUQ1ftPyRVoW9DYbDdVUni3sJxj3JDuP7Bhvfp90xy
         U0bw8ITDFUvSdIIyaSEh1rmT/qN1zjl4H5WSph8zBg9dvkQb4ZpgAnlvIp6r3fYNTPrU
         RQvDe8dGgp+74ZTyd4hj0aZG8jMYpcbcVryPrXBVFyvlF/6DQk/xeT7H4NnjBj4SyRlP
         gwx3eNlEujpx2NqUix7LcYTX2v49YIzWAXeO7gSEpO9NMNW4O1cybq51JhXmT3NDktPG
         aUMg==
X-Gm-Message-State: AOAM530gTZ1KZmCZvvMueYVQrUEoqZBYnU+kO+/V4HW6GiAiaTax7EhF
        67GFDp3OIPa+RG6HXAa+Te0=
X-Google-Smtp-Source: ABdhPJzy7rsLDmHhzgspbXp+wTsIOC5azay4EgiZS+NVfpLf9SSgQwT1xVaQLysaCUPAwVAKV8GogA==
X-Received: by 2002:aa7:8d86:0:b0:44c:9006:1b44 with SMTP id i6-20020aa78d86000000b0044c90061b44mr6737282pfr.36.1633643233614;
        Thu, 07 Oct 2021 14:47:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id nn14sm215393pjb.27.2021.10.07.14.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 14:47:12 -0700 (PDT)
Subject: Re: [PATCH v1] scsi: ufs: clear doorbell for hibern8 errors when
 using ah8
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com, vkumar.1997@samsung.com
References: <CGME20211007075635epcas2p16af95ce29750417f34f8490b0d8000d4@epcas2p1.samsung.com>
 <1633592411-129911-1-git-send-email-kwmad.kim@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b548158d-a155-bde9-caff-0f3fefbda403@acm.org>
Date:   Thu, 7 Oct 2021 14:47:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1633592411-129911-1-git-send-email-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/7/21 12:40 AM, Kiwoong Kim wrote:
> When an scsi command is dispatched right after host complete
> all the pending requests goes to idle and ufs driver tries
> to ring a doorbell, host might be still during entering into
> hibern8. If an error occurrs during that period, the doorbell
> might not be zero. In this case, clearing it should be needed
> to requeue its command.
> Currently, ufshcd_err_handler goes directly to reset when the
> driver's link state is broken. This patch is to make it clear
> doorbells in the case. In the situation, communication would
> be disabled, so TM isn't necessary or we can say it's not
> available.

The above text is too hard to comprehend. Please make it more clear. As 
an example, in the first sentence, what does "goes to idle" apply to? 
Does it apply to "SCSI command", "pending requests" or something else?

What mechanism does "If an error occurs" refer to? A SCSI command 
processing error, a link error or another type of error?

> Here's an actual symptom that I've faced. At the time, tag #17
> is still pended even after host reset. And then the block timer
> is expired.

pended -> pending.

> exynos-ufs 11100000.ufs: ufshcd_check_errors: Auto Hibern8
> Enter failed - status: 0x00000040, upmcrs: 0x00000001
> ..
> host_regs: 00000050: b8671000 00000008 00020000 00000000
> ..
> exynos-ufs 11100000.ufs: ufshcd_abort: Device abort task at tag 17

The relationship between the example and the description above the 
example is not clear. If a command is pending before the error handler 
starts, aborting that command fails and the host is not reset then the 
command will still be pending after the error handler has finished.

> @@ -6138,7 +6139,12 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
>   	     (hba->saved_uic_err & (UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
>   				    UFSHCD_UIC_DL_TCx_REPLAY_ERROR)))) {
>   		needs_reset = true;
> -		goto do_reset;
> +		spin_lock_irqsave(hba->host->host_lock, flags);
> +		if (!hba->ahit && ufshcd_is_link_broken(hba))
> +			link_broken_in_ah8 = true;
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +		if (!link_broken_in_ah8)
> +			goto do_reset;
>   	}
>   

My understanding is that hba->ahit == 0 means that auto-hibernation is 
disabled. Hence, the above code sets 'link_broken_in_ah8' only if 
auto-hibernation is disabled. So what does the name of the variable 
'link_broken_in_ah8' mean?

> @@ -6168,6 +6174,9 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
>   		}
>   	}
>   
> +	if (link_broken_in_ah8)
> +		goto lock_skip_pending_xfer_clear;
> +
>   	/* Clear pending task management requests */
>   	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
>   		if (ufshcd_clear_tm_cmd(hba, tag)) {

Why is skipping the ufshcd_clear_tm_cmd() calls useful in this case?

Thanks,

Bart.


