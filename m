Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D81F224AF0
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 13:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759238570; cv=none; b=l2zRtiOijApyVWHgF4H69dHHyfC8aZjyuTJCD9y8mvu8EsDzzR83txn+ogNNzyIUK/iNQrvwPEMP1JbMTBLJMNnDrdSnIiLbYCcPKolb4ElI93h3g8ta1pO6UJ8hdGNBuQQLin4vn8x4eGLHK3nTO6qxnCmH2ClQFKDVZWrw/oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759238570; c=relaxed/simple;
	bh=59NoSC7ocZ7c3HpMjXdvCeJv9n5mEh9jzMeOC/NIuGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VHb77ua9t+S/O2LjMVy0ju+RUnEyiuiLOeqHn4hsIbM+o8MSOgVtItev/vojD2qHUeAJLgr2aqcnw4Wt/BNxZQA9taJhvqk958JrhwzF1NszjSi16pNOxHle0cxM50LIs0nWWWfSM+nBySHEwk4nJQPudngIN21EjEIUw1kPfsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GLto13CZ; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GLto13CZ"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6228de280a4so11617092a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 06:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759238566; x=1759843366; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uwAebk43If0gjy3ve3r9IFpSG2OftYAndV3V+n10Lek=;
        b=GLto13CZ6JMPlbvF/OCZ1TS1hOu/R8r+b+/yz6gY66gKmBqG5gWKjN+dU/LD/dUd2k
         iD3D4dM7F/qWwyae1v5YMx02CWMds4vqkX2NPQMLL3baHcFwVs3kQ306pfFkgWehdEUY
         Yu+8IE6nDs/DDBI8jgwI2UY9aIVSQp7+Slh/sXtLFuU+G5g/ZMU1PiV220vNnXR2IGSH
         OHBYi0XP6TbxPyLCtGoPvAgfIhBjYaSMGu+2b1n+YeFePcbP/FhtWnBiUo8FiVhZJTuT
         drkHDHAn9/e8XXNhTEkEbel0vnAdiKOtnk3Ic/Kim9zKjQV2WwUAg1dHPJrO2AKugJ96
         Rf5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759238566; x=1759843366;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uwAebk43If0gjy3ve3r9IFpSG2OftYAndV3V+n10Lek=;
        b=O80ZXQbUd5Qgg7/+tMXSHRdJ6czViYMclVmUsFvUNVmRJBjhu+vWTdkf07qVP5moRV
         HO73HSRZxehVDxiz+Hwxj/gZTQjPuciTjisYl6SGp1ctLqQfCdX7EAWJ/YvR6RtaAy11
         ifJSK4TZfrdWfjMJxyPK2e9SeGktZG1jm+Nq382ico+7hKLVXESjqxqW/grRkhT/G5eg
         Xk6mV050sabcIhuWnfDodtdM42uG913JI7xDfsltJoavveLj+LjErchWFg6ePIkXAybT
         PRx/y3AeeBuDKh6z1/NzYpSzFXt8kwQomvU9OXjonrpGKaNStzUe8X1mg1E3GE8/egS9
         9tGg==
X-Forwarded-Encrypted: i=1; AJvYcCXpxcTM5SIxSnmh7RFrDCdapXO/sSQhIHNWJ58w7wdyNmt4KVA4vuqDampOXAEDlvTFY/+A5Dz7+dQO@vger.kernel.org
X-Gm-Message-State: AOJu0YxXfD2BgJDJh9pVFeBxUGr3AOJ1kzYUmou47SNeJ1urwJfrdCz3
	Yz1EinfmKLFuY8d/ljOH6pnT57lNmq1J9VcV5VSlP38esnkUpwhxt7UfZjIHpomc+E4=
X-Gm-Gg: ASbGncvEZmPNCf/cN8VlQrfR9MKZQ8fBAMTxaVQBoTnlpQAeNj8bl1mnE1E/HminqSQ
	L9kNQPfbTITxI4Lt7X3FAGFqbI+02tkabJ5zhW2h5y5zCgRd1M5R8+gd1vFJqNVCvotbMrlDr4b
	FTdj0DXCrxjxBhk7N86NUEXkmHG6zS9ZGcqqzUrprLJlaSaJm/p4b/3W+kgzMi+uFEaIxFhFLF5
	AbAZHQ/tCP81SSMr8jF5aEEJP7iYPZd9SEqDhmLl7X/o5HDWnEc7PqRaEcVyemH+uD0MYVWplOe
	YSjXx1FPi668GkyqyO6A6aRM7iaSD97BUsxVEdv7VMVZBq/8+z2O+r0tnnNqUevLYrCPLGvcOu7
	N25tZPqNidT83X6Gv4Nr86ajIK241HZjy3h4c58K782cn8oICOTzFy5Y4GWpXG38ogmvgC3ndoj
	ZSlLC5OG+4T8kW4pex1/4uwTE=
X-Google-Smtp-Source: AGHT+IGMmebQvklxeUJZNswwjRqyuzOfwdDvXkiArUTNHu/zyJ1G1AIYldRx7ek+Ug5wpdnFDX7cug==
X-Received: by 2002:a17:906:c150:b0:b04:6fc9:f108 with SMTP id a640c23a62f3a-b34b86a19b0mr2094007966b.24.1759238566474;
        Tue, 30 Sep 2025 06:22:46 -0700 (PDT)
Received: from ?IPV6:2001:a61:13a9:ac01:423a:d8a6:b2d:25a7? ([2001:a61:13a9:ac01:423a:d8a6:b2d:25a7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3b0c9c9e8esm686349166b.59.2025.09.30.06.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 06:22:46 -0700 (PDT)
Message-ID: <6c65094e-81e5-4ce8-8592-9458c51116f7@suse.com>
Date: Tue, 30 Sep 2025 15:22:45 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fix urb unmapping issue when the uas device is remove
 during ongoing data transfer
To: guhuinan <guhuinan@xiaomi.com>, Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org,
 Yu Chen <chenyu45@xiaomi.com>
References: <20250930045309.21588-1-guhuinan@xiaomi.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20250930045309.21588-1-guhuinan@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 30.09.25 06:53, guhuinan wrote:
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
> submitted URBs, when being completed (giveback), call
> usb_hcd_unmap_urb_for_dma() in hcd.c, leading to exceptions during sg
> unmapping operations since the sg data structure has already been freed.
> 
> This patch modifies the error condition check in the uas_submit_urbs()
> function. When a UAS device is removed but one or more URBs have already
> been successfully submitted to USB, it avoids immediately invoking
> scsi_done(). Instead, it waits for the successfully submitted URBs to
> complete , and then triggers the scsi_done() function call within
> uas_try_complete() after all pending URB operations are finalized.
> 
> Signed-off-by: Yu Chen <chenyu45@xiaomi.com>
> Signed-off-by: Owen Gu <guhuinan@xiaomi.com>
> ---
>   drivers/usb/storage/uas.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 4ed0dc19afe0..6bfc7281f7ad 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -699,7 +699,9 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd)
>   	 */
>   	if (err == -ENODEV) {
>   		set_host_byte(cmnd, DID_NO_CONNECT);

Why then set the host byte unconditionally?

> -		scsi_done(cmnd);
> +		if (!(cmdinfo->state & (COMMAND_INFLIGHT | DATA_IN_URB_INFLIGHT |
> +				DATA_OUT_URB_INFLIGHT)))
> +			scsi_done(cmnd);

It would seem to me that in this case you need to make sure
in the completion handlers that scsi_done() is always called,
even if the resetting flag is set.

	Regards
		Oliver

