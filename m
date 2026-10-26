Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793019417;
	b=GAsnds4fffpKAYtBZx2ckDN1aIa0M7880fDJTqC1Qtsbs+cE4UrmFRJsHkRVzCjdCfIr
	 NGjJtR0bxWRkw7ImaZBVrh4za0vLBBLRh7cU+INomwxqX1AmmofcMoWxGPo72MeMi5QN1
	 giRFGEm3hRSXOzjtJjnFerpkduMq4nhVTwNHblrAE8odxppe3yMt777C+JOyCilDtM95A
	 UF75hPjfa2M+R/FtTvGW5DlY/InrE/V+wziSCZC6jlIRM6wEQOYP5o8XA9Jr5sTTgi4tY
	 izr3siEQ1IhARMhdB99E+qvjUL+/SniN63mPXGHu2XwsIkPHuE4Ny528Gf9sT+mPrHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793019417;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=UCy5buCAAPRaMG/y5EzdlGNeV9SlawrqadrCQjrrMrA=;
	b=MPD3hA8fKMogJ7n3kkw+mosqCi7QblGrJYIkirakinm+dYWeDhvRDio3XtUbZTn9XnpL
	 aydV8WqNdq9aBdHOPR7O4vrSmoBtSh4695hQVs9Eq+lkhCKneic9TyWcN+EgkNFF5D7MS
	 Mk6dX6RHv7ChAlwR8yZ2jv5vkzmLBYytGvDJilvDMOy2ZsPgkB1ktJ0+LzATgbZ3HnH7s
	 s7t1hZq8n0Z5U/kCOoeGBmlmdJcUf48i+Tj3p9ZJAsQc9uKFQ2Xk9rdAAs8NtZlP2q9Au
	 Zg/KN0qJ72WhCJ+6CfAeAtVzmJjI7GDr97+9TrXvOqRE/OaZZ+/UaukQPuThCfSpm2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Ano9C4vd;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15F3606A321
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 12:56:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F15F3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Ano9C4vd
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49d05d51553so20422225e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 05:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793019415; x=1793624215; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UCy5buCAAPRaMG/y5EzdlGNeV9SlawrqadrCQjrrMrA=;
        b=Ano9C4vdkZuL2/qSA4Ya2bAb+80zZZnOYy82mM5+aY0M0+EE0WBERm9y/9zHGUYLFy
         A/J/afpuP84nvAjI7rcWqD6f0urPAT2qX3EWcO3VeEtngqOUYd3aDpRGLNUhvut54c9J
         Z1oAYUcsTgHRMSyRg/6cngtzc2vKPTxT0qQx543O0cXOcKyyzdbGswe0Pw5NjqBW+gdt
         EXQvMoI64JA/RKiM50EE+XpViU3oNBn1mlYqcO6RCyOleq+hN9EHTwgjQKFKLeoLXggd
         Wp3fgb+3J/jrJqkzmwYP507AQJxFQsK/0FYali9ZlKn3vzAijooDOJ+PaOUjZOT4sBXF
         SZbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793019415; x=1793624215;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UCy5buCAAPRaMG/y5EzdlGNeV9SlawrqadrCQjrrMrA=;
        b=Li0bwfT/5uLiRnQcrCm3OW78rbe990VOb/UnpI7KVX86ErLLPcfSdsUeMDzNec3pzu
         Ypbocx6cFEmKoG+ONfvW7Hmn6qW/Mu/CNPVBCGKFc0l3JhKVSHguouRIiYuADqSu361V
         S37PUXVRPJ68ouMQqTzb7SkjAYmUycptQoH5BVGduEFflUcDUjbJvS8Kzw8Z7onfIJIb
         nqg49SNvoyhbMc7QdXMroCwb3pHX/IrWCg4uraODe1I+MS6ngDN2U6GSNZZ/Ylr4yFOo
         Vbf3fJZAkq0tUhO4ufhXAosXVylIjYUeg4ewu6M5cKWsDI+WpwskS8zKoiJSVz8cZ742
         vj+Q==
X-Forwarded-Encrypted: i=1; AKwUvBxIFuE4cThGL4GqnicYYciPBy51s3nUYGZy3YxBSBRu7CAohgAriP5Ro/a0VJZiumD/P/bo3Jluhlju@vger.kernel.org
X-Gm-Message-State: AFq9FYLtShjhR74W7JYnSk0TR74CvQ0A1XzlT1y9OH6zWUiY4X4t3FkU
	hU4MOqOIKFUI8TMayI8J74QlPx+Z7XEI7NStjjbn3mycYkTuor9ZUPs53AWMw0icycQ=
X-Gm-Gg: AYBFou0YTSD9SMoi86iLgaP/6bNIt4ecC5L2N5Yyo24JuJQbq8EJAiB/wM0w7G4PHLX
	T73Y/ws0IftIahqoI2jwihHNNFnBairQGgKodv8ZMX9syzYt2HOYogPOOJOChLLwlCBuDNZyToI
	SEAyMT+YAmTii6toY9lnepMtbKxoJa8uCwBcjJNUovCMAwMMLz4dLMPeO/e6/uHO06fQVCGah78
	QkN9Pe+jfXDPOdKmdeYwBI1CpZUefxR0aukJ6f5gLW4HK5S/fBtDA0b5L5Ae3+N9fi/38fHVngV
	hVkEgyMWufbpbzu+qWtj5HMwZqongV58runWvsp9Fuwq2yskua9Jhp3f/6PeX/vn0Bz8ksuBlgm
	sXNUpptOJnqnHA2vN7rNiNJ1r39qeo3vHkPDFeYqUY+VojGWFCLIqEE8Ge6C6K9KD73eqUqQze6
	A8uusn1ZM40uqJhyw7lruS2ADi4IrkLfrj4SjX/aC1rk4rGbJCFRXc1ev8/82xALMuNjOj8fNAK
	6VBfoZQ+6+tsZAx4LepxyK2Ubf48n5/6NFgkSTJFLehAoC5va+gsHH/zC09emwfQO9xXxboiM/D
	FBOrNpbLGnC//E/0TYU1aA==
X-Received: by 2002:a05:600c:c0c8:b0:4a4:de70:2ad4 with SMTP id 5b1f17b1804b1-4a4de702b8bmr75813525e9.22.1793019415369;
        Mon, 26 Oct 2026 05:56:55 -0700 (PDT)
Received: from ?IPV6:2001:a61:1396:ca01:48fa:543c:8ef8:4075? ([2001:a61:1396:ca01:48fa:543c:8ef8:4075])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc3932sm17562810f8f.18.2026.10.26.05.56.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 05:56:55 -0700 (PDT)
Message-ID: <e6009e1b-2d95-4350-8374-d5930200ed24@suse.com>
Date: Mon, 26 Oct 2026 13:56:54 +0100
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
Subject: Re: [PATCH v2] usb: uas: wait for pending commands before unbinding
To: Jiayi Li <lijiayi@kylinos.cn>
Cc: Alan Stern <stern@rowland.harvard.edu>,
 Michal Pecio <michal.pecio@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <20261023013931.388916-1-lijiayi@kylinos.cn>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20261023013931.388916-1-lijiayi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 23.10.26 03:39, Jiayi Li wrote:
> USB core normally disables interface endpoints before calling
> uas_disconnect(). This cancels pending URBs while the device may still
> be processing the associated commands. Some storage bridges then stop
> responding after a driver rebind and need a disconnect and reconnect
> to recover.

I am afraid there are some issues left. Let me address them inline
to the code.

  
> +static void uas_pre_disconnect(struct usb_interface *intf)
> +{
> +	struct Scsi_Host *shost = usb_get_intfdata(intf);
> +	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
> +	unsigned long start_time;
> +
> +	start_time = jiffies;
> +	for (;;) {
> +		if (READ_ONCE(devinfo->udev->state) == USB_STATE_NOTATTACHED)
> +			return;
> +
> +		flush_work(&devinfo->work);

This raises two questions:

1. If an error happens while disconnect is running, why do we want to schedule
work?
2. Why only this and not also scan_work?
> +		if (!usb_wait_anchor_empty_timeout(&devinfo->sense_urbs, 5000))
> +			break;

Some commands run longer
> +		if (!usb_wait_anchor_empty_timeout(&devinfo->data_urbs, 500))
> +			break;
> +
> +		if (time_after(jiffies, start_time + 5 * HZ))
> +			break;
> +		if (uas_cmnd_list_empty(devinfo))
> +			return;
> +
> +		msleep(20);
> +	}
> +
> +	shost_printk(KERN_ERR, shost, "%s: timed out\n", __func__);
> +}
> +
>   static void uas_disconnect(struct usb_interface *intf)
>   {
>   	struct Scsi_Host *shost = usb_get_intfdata(intf);
>   	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
>   	unsigned long flags;
>   
> +	spin_lock_irqsave(&shost->host_lock, flags);
> +	scsi_block_requests(shost);
> +	spin_unlock_irqrestore(&shost->host_lock, flags);
> +
> +	uas_pre_disconnect(intf);
> +
>   	spin_lock_irqsave(&devinfo->lock, flags);
>   	devinfo->resetting = 1;
>   	spin_unlock_irqrestore(&devinfo->lock, flags);

Is the resetting flag even needed anymore?
If it is needed, why set it so late?

	Regards
		Oliver

