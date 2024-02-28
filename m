Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFBD25601
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 08:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709107237; cv=none; b=D1a6r1+G+pRBOw8ZPOPJALHG1UjuEwFatE6mfQs2E/mv44YtemdRCHf8ZAubyH8mOeuQSqCTa04aL/AdGbk1pmLa1jDpWCuPGWHQYpYkYFNqhqKEE+EyvGJTlgvQm0GO2wpViAhVlKujD5VDKpraNvkDOn1UyhSp7JdOrk740Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709107237; c=relaxed/simple;
	bh=yPfz2sin32rZiQP+8BH+34YmroVrlOsfX9BevnQRkz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A7KjoCnmSMtZYHRIY2jQBjk86hEm90yLDYmvbdy2hjy6XWLYnfi8MAQIbqfc6AmYWPHaUUEjO6vAxV4IwSd+ddg2+MBF36QFcvxEPqR4quF/t0Mv/sNYN+cMSwwHRbfN+Ln4T4wCsPw/nIzjI0rzHLwMYaTeNOHfaLdbXyxxWDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KfwIIbFT; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KfwIIbFT"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d269b2ff48so63776161fa.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 00:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709107231; x=1709712031; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RMPPuq20bTo2IvgrEDXMIqv+e5KFkAdYGzZyeqGK2xU=;
        b=KfwIIbFTXDjTieixXQiuqEvlvfAlswNXHP2DnYTXUy1Q1feQt8VFetkHepBbbwShC1
         JRrMlfkkm90G7gtP9Dfu9H5YQcKS4Nky1CYscVy7upWbULilflySfU0/a2+xSCnVAqN1
         PEDfDsXK2/6L6psfNx/jomWY8aIs+LRF6I0SfV0WhLy9ASFXptQ3LhGSuT3anIqKRCC5
         LHYwb7URpAvqgglNnG+MDywnbGTvLq/TD0YImBJVoCtumr/vF+TzNLmlTU1/mJ8FPRa9
         8DqRHCfeqrVL4iPWy75F++TNgF3XX+qE7ZcC6UlusVKG/ioZjkFuAYXAS7Yn1TOP7CjJ
         fGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709107231; x=1709712031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RMPPuq20bTo2IvgrEDXMIqv+e5KFkAdYGzZyeqGK2xU=;
        b=mm9WitRBMyusxgen1u8AOapshfIjmOkyGDqAyyw9ZMfS9hCewETeFUvqijERD8Bw1n
         0tC+XdSJdjij5sho8jNxHiOPYiybE9KysZVN0C2C5/bbjPhsedwgm1QtvhWAPPa61+v+
         H2O8OBwcbH9ghXmITNSNs3X2D+HiEYU1PBiM2+jsFjjiMQSyTibdc16/0N9CZHlStgBo
         6ZV73bjOVhmaM3V+IDurub9jSQUI3TeaFaFc2Qx2Os2NO9us4ddsoqYqGEL7ws12KcEH
         v8LrrNYf+VB6qVK1B4j3Td7pyGHozwQtaidLOJpgZUoDJ3CPcna7Dls0aqWaPJaApZHz
         zcxg==
X-Forwarded-Encrypted: i=1; AJvYcCUFPXnr4Dan1nE3pkDVvGy+NPE49KWFKp7qq3GHB4+SQu56CSGGXi+YiVRvLq9QRlkxgKDnSK+pGN4+DPBm0xCWRXlvU42kwDncnw==
X-Gm-Message-State: AOJu0Yw96X2aN/7M/MRuKcjwpQCEVLIN6jLRflgxe7Osf7GiynOszNQF
	bEBwdQy9LY9ZdzYQJuiQFfRtnhiy7POl9GaEP6sYeC7QQzhzuS+yRzv3YbYi5zU=
X-Google-Smtp-Source: AGHT+IHG9JuMT1frUWRx1Ja5QCluLAjVs4eLsTOezZ62w6SZ6+YmOaVvsQnaqY8lTACXTFTdwBRzYQ==
X-Received: by 2002:a2e:a54a:0:b0:2d2:3915:cfc4 with SMTP id e10-20020a2ea54a000000b002d23915cfc4mr9991963ljn.4.1709107231035;
        Wed, 28 Feb 2024 00:00:31 -0800 (PST)
Received: from ?IPV6:2001:a61:1366:6801:d8:8490:cf1a:3274? ([2001:a61:1366:6801:d8:8490:cf1a:3274])
        by smtp.gmail.com with ESMTPSA id bn21-20020a056000061500b0033e033898c5sm387989wrb.20.2024.02.28.00.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 00:00:30 -0800 (PST)
Message-ID: <e8c4e8a3-bfc3-463f-afce-b9f600b588b2@suse.com>
Date: Wed, 28 Feb 2024 09:00:29 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] USB:UAS:return ENODEV when submit urbs fail with
 device not attached.
To: Weitao Wang <WeitaoWang-oc@zhaoxin.com>, oneukum@suse.com,
 stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
 linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Cc: WeitaoWang@zhaoxin.com, stable@vger.kernel.org
References: <20240228111521.3864-1-WeitaoWang-oc@zhaoxin.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20240228111521.3864-1-WeitaoWang-oc@zhaoxin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.02.24 12:15, Weitao Wang wrote:

Hi,

sorry for going at this again, but there are a few technical issues left.

	Regards
		Oliver

> ---
> v1->v2
>   - Modify the description of this patch.
> 
>   drivers/usb/storage/uas.c | 21 ++++++++++-----------
>   1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 9707f53cfda9..967f18db525a 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
   
> @@ -562,9 +561,9 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
>   
>   	lockdep_assert_held(&devinfo->lock);
>   	if (cmdinfo->state & SUBMIT_STATUS_URB) {
> -		urb = uas_submit_sense_urb(cmnd, GFP_ATOMIC);
> -		if (!urb)
> -			return SCSI_MLQUEUE_DEVICE_BUSY;
> +		err = uas_submit_sense_urb(cmnd, GFP_ATOMIC);
> +		if (err)
> +			return (err == -ENODEV) ? -ENODEV : SCSI_MLQUEUE_DEVICE_BUSY;

Either we ought to use SCSI error codes or generic error codes.
There is no need to translate all but one error condition here.

>   		cmdinfo->state &= ~SUBMIT_STATUS_URB;
>   	}
>   
> @@ -582,7 +581,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
>   		if (err) {
>   			usb_unanchor_urb(cmdinfo->data_in_urb);
>   			uas_log_cmd_state(cmnd, "data in submit err", err);
> -			return SCSI_MLQUEUE_DEVICE_BUSY;
> +			return (err == -ENODEV) ? -ENODEV : SCSI_MLQUEUE_DEVICE_BUSY;

Same as above and below.

