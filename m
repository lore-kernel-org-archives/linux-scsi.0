Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792675800;
	b=GrBgYNbF0fURt0vcefhyh3Pkun8gj4SXuV4UAdTiJX+zz0f9QSgw5PdASlCyLgwRbub/
	 P0F2Mbe7xdpRPhspVbiP3NRcY9gmTlFrn0rC+//9H5LPohj3eQTiqj/xTCrBvZuDtTm2I
	 baEhPPE5jVV4BNIsOHxmNIsbEWTNLruUEzRLMOjyS50iFbEozgm+gW1zrOic4YqW9faKs
	 6BtJHHne4yOzYPEdDgWfVGuHoFEB9jxi8RKd0s/E1f/Vp8gb0yGn+BWi4xTirf2NSd3C9
	 ext/kjW0eLvk3WfIVxDWZ9uhzIdfnfcNKcM5wPnsq0vjeUNj6GvlIJkTfms26P4HPaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792675800;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=qTs7ITGH5Vm0O/b2VvByjBvC5hRyxCKXY/CuqHg+goE=;
	b=X4dVUXMbpwX8FIx11tKyKVp6Ypz/Vi/KlSZWCKlkBxzU29smBzXVhJWG0xsF2/4j6Azy
	 kvq46fAgHpRvrSXcD03QnvMxOJcXD8k/7L3jeWuIomWzuIdTTJuO7uf8d4larsyODTlOi
	 PCZfILkalPZbQnPSvmL/0G6zu19EAkq8p1oAIFGNtyDorPvAKYOgokAYRmMDjkwxYogcX
	 YXvZcJxno9X0QUJqeHAAXv+MfTntzN5AByDeZxyi7QDz0lbDl1yWMGjYDUjZtYWWRDw4U
	 g0C648qmk2LZE5d+78JXEI4qf6t7qvcF1Lg5Iq7ESMxGbbPnNWtv5boSnd9gIwrryXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=UnnznAku;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C70960A262B
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 13:29:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C70960A262B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=UnnznAku
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a2072b9832so3863995e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 06:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792675794; x=1793280594; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qTs7ITGH5Vm0O/b2VvByjBvC5hRyxCKXY/CuqHg+goE=;
        b=UnnznAkuDtGZE+MuoQei834/NZGnv+7Vu3YK0PkPpU0vwUPzY0P7vPsBfdCBwl1D7g
         cDMgvm6L11UCVY634uIvYXoT301cHNuxy6xCGZwomfA5BcqKkBKwgphDojJzmW42m7yF
         nZsOF3aj7f8myme7/ZAA5ACEV+B1OvvzCpRuMSqZGAZNuAiES68IdgYcIXt6kP5jlFRP
         lxaajb5lltKGetqki+6nThGI6mtu4BZ4gT4LPreda2Yr5ihTPSWO7PSOFLXvma0SlABy
         uOpEbcoLqT89POjef+36bd6+VJwTehl49AbT9dDCDWbVtSL3Kw3EDUgKzjdqTX4stHSI
         hTZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792675794; x=1793280594;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qTs7ITGH5Vm0O/b2VvByjBvC5hRyxCKXY/CuqHg+goE=;
        b=gArkeCVrd53/qTa9usjYQ1PzSqlfogVGttkSuDj6O6LkO40cBHy7zEY1/HV55ELOvm
         5gwyq3Zo6pQXsHdObyqoB7MBS6YWZYt1rYrJ0kRdyOtsAh2eTtt+hBQI2fcxSWaZ9r67
         9QiCTZVA5+HBqLwptV19HsIbfSjUwhiDgj9x+Gr9s5SyrP2dl2AuTN6GUuU9br+XsMRn
         jeyiHa7uvl+6LywnPwI/79qlpf8iTK5TxBz9lFgnaQgs64hcnYZzLY5Q8pASp6oePtLh
         ZEkMsj+KMU6JzPM1QMhhQjgrAv3vz2hhmCyFn0zsv1ta0K4ZVYl6KAGSm4QTjQNz22iv
         mbqw==
X-Forwarded-Encrypted: i=1; AKwUvBzfzEqfxCsrylJgt/Rt+iB6/aCXIjrj4FcVCOdWWFLSfEpKacrNeAk+uNoeAQ2WaEc+v5NFeBUX30ww@vger.kernel.org
X-Gm-Message-State: AFq9FYI5+sDVm74jO4qjim95Ck6EhFIiFh9Kcu2nUuv4NlTJ/fEHzdHa
	wD2E81pNajJI5IydiiU33L++o4aM4wXZv8yXFeh8ChETIqnqqCIVludrB3dqdQukVg0=
X-Gm-Gg: AYBFou1Ggm9fHySFmIVuuT7a9pY+0ACuekqDc20nlV0PIk89STqQJ7D2LFiyiCH0g0E
	uRJMc1MFp/kYldLM+JxlLEZCpLS6PeToXPGGrKuxhkjZb/s9HZr9hEzmwYyP/ReWtPYk/1NgvAo
	PhoRS8LgzhUnGgirzyqjYpQOY1C+wcOTAEfHqoGSa5GCM/i7EnVkaOqoftvTEPnxNeQME7kF5x4
	OF2tcY1annwE/lva95zYDmZjV5eCFxciZEdoUoA1Cie/2EaGx+i98v3XmRt52Ok8ZBaWdedxr3y
	33w2KEyOOKXVnGIm7O5PZFynGcanhUwxSOB1qb5Q+00jcGuhEgi/HVkpWD6yh4UXrt8evSBoQqb
	SXVIDXSG9vOe4cdZgJnNr0OMkSemMibSNXPAd/rhd7GVhNmn5c+4UHHEreCQJShp4z+hK3jkUM6
	ZimyiPGgA9mKaGGXIwhgI1MTLk2z4u94pOdnG32ZACHKxF7gsQPHeUhgcIuI8jnIOTFFRl6jMIJ
	KMiTeGhwV6CdTIuPaI2N9HaADvatfsSYSQHLoR+rtqA6dwFMm1S9fuvX9GFnZGR72QvGQOxfmlG
	2tPiIMklJ7Y5lYrvB10=
X-Received: by 2002:a05:600c:6085:b0:4a1:a7f8:c124 with SMTP id 5b1f17b1804b1-4a204b04321mr42997325e9.7.1792675793804;
        Thu, 22 Oct 2026 06:29:53 -0700 (PDT)
Received: from ?IPV6:2001:a61:1362:6c01:90a6:c895:55cc:41c? ([2001:a61:1362:6c01:90a6:c895:55cc:41c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a203a265afsm82566045e9.7.2026.10.22.06.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 06:29:53 -0700 (PDT)
Message-ID: <6015c40b-04ae-443e-8271-63e064f08ab0@suse.com>
Date: Thu, 22 Oct 2026 15:29:52 +0200
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
Subject: Re: [PATCH] usb: uas: wait for pending commands before unbinding
To: Jiayi Li <lijiayi@kylinos.cn>
Cc: Alan Stern <stern@rowland.harvard.edu>,
 Michal Pecio <michal.pecio@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <20261022123401.319479-1-lijiayi@kylinos.cn>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20261022123401.319479-1-lijiayi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

thank you for doing this.

On 22.10.26 14:34, Jiayi Li wrote:

> +static void uas_pre_disconnect(struct usb_interface *intf)
> +{
> +	struct Scsi_Host *shost = usb_get_intfdata(intf);
> +	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
> +	unsigned long flags, start_time;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	scsi_block_requests(shost);

No, on pure grounds of maintainability, please put the
blocking of the host in the direct handler for disconnect.
Unblocking in the caller something that was never blocked
would forever trip up anybody reading the code.

	Regards
		Oliver


