Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF67E3112B7
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2025 13:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781001; cv=none; b=uE9S3rJRcyg6aEZ82UNxLFaYlIxpzfaDkkTICFdn0NHoLjYWuFBT0LnFwmSQwnu+qt54haakNCd38NJcGaMUoTmWrZTCMUwIBamVLRkyjdn04hT22TV2Vh+z9e/O3m3ZphgsRGydh0dU0PSujJyzFnS4GZCgGZgIg4o7CF0mAic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781001; c=relaxed/simple;
	bh=MYr02ZEBmHq0uhIy/4dPDK1/fPU1Kg9EJNPjNarkYCE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uqHHHue0GMQpriUXE+7qo2YOPvSp0paU/HwcFY2t1FGp2TATKXL3fJWVqCdYySVlK8Lm6Mflh+S65Fp3d64FESDD+kqCZ3E+MQ0gouKfDpK60pldwptJkPhMfDM7Zr0DK34hdRA/MTMa+amwr8eJNghsxQVj0dGMIk6xhBLwupk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RuLC3IaV; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RuLC3IaV"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so4894999a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2025 05:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762780997; x=1763385797; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eX8cXaP/IKh8VGGvFDRWHiVF+8A64KKj3ky2qGHDfis=;
        b=RuLC3IaVTFNTUQc2EwPiv6zaSgjdyIKtAqyZr+mveZ9a5YtOD6UJllbf9qNdarRQ9h
         KSeFnYpKNLHZiD6lTKO6xbz0EUgDX1OJ9cPLs9rvKpEJGo5ZxOOFeaBbqzsAnCcz4B+L
         c6XRWFjpHWfp3pesXF5HcV0nDktiVcPjnRCAC80koSKcYGVhfnIR2vBUAMrQc9oiuAMx
         YTtXngXxbom562wS7l5DpQz33il2tPLu8rlepvXjFlzKTTingF5FIyme/131B2mXQu26
         5Mck6HVs8lrAuJ0bamNgfOkv5IKugv/cu3Dav4EEqdqP/9I6YUP8bY43IdLsV0e/ZzJf
         O1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762780997; x=1763385797;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eX8cXaP/IKh8VGGvFDRWHiVF+8A64KKj3ky2qGHDfis=;
        b=Sgp5s3NBqVqThiR+z3ncNKq2W3Y7uUHGzGd/3wAQvC3pvSOBLcD4CkdmT6AdK8A9R7
         0hME4MCo9YKXEPnwMWaNPyN+Ib/xVZuyWT9gbBlqyg4RqN1avpnSCyxtFhLLf2TtAMY1
         PBmVeudOGbrOAelqe2Q98Zk+rSiZY6WWgbKMkpvbXtFLXEI4Jxxjp0Fez8Gg+ZNIBlnI
         ixatR0khB/LyUzZ1AvE3QD0RYZhmY7LdTzRQvvDhIE0gkUA4hmGcpMPd/8gMchEoidD6
         CLr63GWOUh2r9RajRFgwwS//vuGEXkw0nb/yN+Ypz9kvfHSChFELhS75QF3DPUjz0m2r
         521Q==
X-Forwarded-Encrypted: i=1; AJvYcCX+yjZtUcLiGvSQya48PY+5Y+Z0o9IH/EfyxZp8pwweMv8QFcw5LvlUlHjMBGA0r1/CVMEj47BlwHqT@vger.kernel.org
X-Gm-Message-State: AOJu0YxNVKADXiRIu3+kr5/oa8vVJ/Vd3heur7Ak4eCqOHUv5IRQ/4GK
	T82L3FeBriQonDqgbeZrr4Tg9jxELleRvy4GmfEHJR+tXzNdSNCkXKP9Y/AQVh1hhlo=
X-Gm-Gg: ASbGncuZVYrtLnkMg3iXGOkNX8YsB3Cq4HaCwvBoiXp6AwXTseynGMZpvDf8DZMYCOQ
	1XHhZhWbOPAOYyQfN6mXT6dORcHmiPcR5ep7gV2Uscnkv5s3516Hay/j5Hosmcg74ZVGD6iIAGZ
	/2DihnZT8eWaj2SFu6sKWwxGybHFI538MCmG7aTm68zdPEtBV6rEqwtIPyyJgrVLVGBSS3ZqrKD
	RjP6ha5rb83nPmO8PW3KYIMg0fR5GTL5HJCel+YZLM4oRgxyCXT0TYJkQsnML2timaAD5RGFYXh
	f+zLQvMY6eL8MNbYTlGOwzaITZ3Okvecx0enw4/mI1W1XmmWHKuCAZVT+3cOal5yA0UmaBXx7Fy
	sbMqbR3V6JiJL0Ke6JU7qvfnw8gFgjxP9xJwZTQ4LA4nGMYLWJm7gLWq5bmNZSEvdYsR+1Puncg
	bblJi+0LAReiSNfncz0IZ84iRFMF+aLaKjDGHMcDMdZ7Y=
X-Google-Smtp-Source: AGHT+IEUjJOmZes5x9oG6eap4HMLLuDUBze6Ph1eKOXxCDMcrtDYaszjSgs/iHIicGpw340vcMk2FA==
X-Received: by 2002:a05:6402:2755:b0:641:8137:e1c8 with SMTP id 4fb4d7f45d1cf-6418137ed28mr4140452a12.34.1762780996736;
        Mon, 10 Nov 2025 05:23:16 -0800 (PST)
Received: from ?IPV6:2001:a61:131d:c701:d281:81d3:7d40:d3c6? ([2001:a61:131d:c701:d281:81d3:7d40:d3c6])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f862697sm11360513a12.25.2025.11.10.05.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 05:23:16 -0800 (PST)
Message-ID: <eb0e0fda-2292-4759-89e7-66e590c4ca83@suse.com>
Date: Mon, 10 Nov 2025 14:23:15 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] usb: uas: fix urb unmapping issue when the uas device
 is remove during ongoing data transfer
To: guhuinan <guhuinan@xiaomi.com>, Oliver Neukum <oneukum@suse.com>,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org,
 Yu Chen <chenyu45@xiaomi.com>, Michal Pecio <michal.pecio@gmail.com>
References: <20251104061608.1336-1-guhuinan@xiaomi.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20251104061608.1336-1-guhuinan@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.11.25 07:16, guhuinan wrote:
> From: Owen Gu <guhuinan@xiaomi.com>
> 
> When a UAS device is unplugged during data transfer, there is
> a probability of a system panic occurring. The root cause is
> an access to an invalid memory address during URB callback handling.
> Specifically, this happens when the dma_direct_unmap_sg() function
> is called within the usb_hcd_unmap_urb_for_dma() interface, but the
> sg->dma_address field is 0 and the sg data structure has already been
> freed.
> 
> The SCSI driver sends transfer commands by invoking uas_queuecommand_lck()
> in uas.c, using the uas_submit_urbs() function to submit requests to USB.
> Within the uas_submit_urbs() implementation, three URBs (sense_urb,
> data_urb, and cmd_urb) are sequentially submitted. Device removal may
> occur at any point during uas_submit_urbs execution, which may result
> in URB submission failure. However, some URBs might have been successfully
> submitted before the failure, and uas_submit_urbs will return the -ENODEV
> error code in this case. The current error handling directly calls
> scsi_done(). In the SCSI driver, this eventually triggers scsi_complete()
> to invoke scsi_end_request() for releasing the sgtable. The successfully
> submitted URBs, when being unlinked to giveback, call
> usb_hcd_unmap_urb_for_dma() in hcd.c, leading to exceptions during sg
> unmapping operations since the sg data structure has already been freed.
> 
> This patch modifies the error condition check in the uas_submit_urbs()
> function. When a UAS device is removed but one or more URBs have already
> been successfully submitted to USB, it avoids immediately invoking
> scsi_done() and save the cmnd to devinfo->cmnd array. If the successfully
> submitted URBs is completed before devinfo->resetting being set, then
> the scsi_done() function will be called within uas_try_complete() after
> all pending URB operations are finalized. Otherwise, the scsi_done()
> function will be called within uas_zap_pending(), which is executed after
> usb_kill_anchored_urbs().
> 
> The error handling only takes effect when uas_queuecommand_lck() calls
> uas_submit_urbs() and returns the error value -ENODEV . In this case,
> the device is disconnected, and the flow proceeds to uas_disconnect(),
> where uas_zap_pending() is invoked to call uas_try_complete().
> 
> Signed-off-by: Yu Chen <chenyu45@xiaomi.com>
> Signed-off-by: Owen Gu <guhuinan@xiaomi.com>
Acked-by: Oliver Neukum <oneukum@suse.com>> ---
> v3: Add some commit message.
> v2: Upon uas_submit_urbs() returning -ENODEV despite successful URB
> submission, the cmnd is added to the devinfo->cmnd array before
> exiting uas_queuecommand_lck().
> https://lore.kernel.org/linux-usb/20251015153157.11870-1-guhuinan@xiaomi.com/
> v1: https://lore.kernel.org/linux-usb/20250930045309.21588-1-guhuinan@xiaomi.com/
> ---
> ---
>   drivers/usb/storage/uas.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 4ed0dc19afe0..45b01df364f7 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -698,6 +698,10 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd)
>   	 * of queueing, no matter how fatal the error
>   	 */
>   	if (err == -ENODEV) {
> +		if (cmdinfo->state & (COMMAND_INFLIGHT | DATA_IN_URB_INFLIGHT |
> +				DATA_OUT_URB_INFLIGHT))
> +			goto out;
> +
>   		set_host_byte(cmnd, DID_NO_CONNECT);
>   		scsi_done(cmnd);
>   		goto zombie;
> @@ -711,6 +715,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd)
>   		uas_add_work(cmnd);
>   	}
>   
> +out:
>   	devinfo->cmnd[idx] = cmnd;
>   zombie:
>   	spin_unlock_irqrestore(&devinfo->lock, flags);

