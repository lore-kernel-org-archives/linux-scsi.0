Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793111749;
	b=QD20ryos/ItIeyXpNaTep7AQY9whY+A7XtpURciGjYrcr8YmyxudUrTq7AIPPB3Dfn7C
	 oND+wW4up/c8hksLnsKaVwJe1sw4Hok7SKWISrKmGBej7Xg3UHL9j1VdOBWEQCC412UzE
	 fHIoPonavVIw/nYey2iw4nioAJvgdT9CKj+6L4uzgamaAmnZwUonbmZl0/b3Cf3bbqWk1
	 sCEyedPfIXQiLlsn1/8GZvHS/lUib/Az+RTpcTA9DUDAkzSE1XLkBiwu+2ncCiy/ab1Uh
	 w8wE3z7Nii7eMn3gmfaMU5T0KTEZmvZTg48OA/xl38BG96n70OeWNrAwVTiEW1sqHdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793111749;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=YRBPfEuEjxiSl4lXEqZGK3PF4IiOziovuFu2epJkAlk=;
	b=S27caBQrzA6oSLiB8123Vr+Qhj7r76SRihgl6ZsUsf1xVy4LRUmfXScdL560FqJYQCH2
	 y08aqUCkytu7YuMyF/hEcf7Mo4OiVmcp1E4UeSY3wW5c5l1lAzQvdLe6qyIZrx9iXqjr+
	 UcCOFQjMcUwgcd0gXipG5Vg+i80gPSQ1lUdGIWiYleR3hbfcFfEP8WPhY6rKfhmjYF9O0
	 Cp3OerscFPuEIimaZp6gImYamGqvQGhBoVbgMoW9a9L/tM/ijeq/on+mc8qAZzY+/psLi
	 IdcJIdjMYTr8wSSb9RTgMBxqrdUD5alwpmwUa/3ZOH95Yn0UGEAIf0fj18xUOdDXHvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=E7cxlPoS;
	arc=none smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F22F606A32F
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 14:35:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F22F606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=E7cxlPoS
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b1b13e09ffso5877665a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 07:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793111736; x=1793716536; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YRBPfEuEjxiSl4lXEqZGK3PF4IiOziovuFu2epJkAlk=;
        b=E7cxlPoSfb508LpQLNZz2gFc1UG/3n7arWkKhOAHcXxM8rhXQ5zWKcrqBUoTTnvoSb
         J9k3jT/m5M5joqGA+aMRPRZn+ut02amEwgdFNH8+7I5ZRB/1TSvRuIWPMdR1AIGLDvo+
         lMfU8RDjbUb10GMcQJEEHqjm/TN21gj0kdJE2Gz9OkVyJsNSy+wSNNGWpXopIMjE7AQb
         qxGh4KDcFl0l6GkVyIp3fx7lA0p9cmfuL2RO1fwhSfyCoHMlKTDtJGJivaYwEsKv2JXm
         F6ICqBnRQstkzZnT4WLz5NKjhd3WOADutbu/1uD0niZrsX0EacwhXJSN3lLG+2qkr/Oh
         WXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793111736; x=1793716536;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YRBPfEuEjxiSl4lXEqZGK3PF4IiOziovuFu2epJkAlk=;
        b=kjHiuP510c7NJ9uoFWfdmhnpNCwbocIPp7OqdZoUyq2CY2NkkQgCLrKkweKjKR87XJ
         F391vIr0aT1WXZq2hbE1wbh6tK7b7K0MMEr1kDk4oDVeko74sCM7pYHgxSpXHP1bHNLJ
         Q3wBOqtyCNyIfF+/KXMQfkeqQTut8GqsKOakCOJieqMEDcZ+fMA05PXEaL2aXzQIGmSh
         0Y+oNBP+TEq97QLHP7pHvBP/WbMLIPfZFJqzyQyy9Fltfbq/zV6Bh80GXQrm8mrcQafi
         bllsiA2MVWqgJZovBpWSXpjPyYfbSZF/QpZlehEFzM8LrKoQKWqtuUSlmlNgJiBhcYjW
         yZ+g==
X-Forwarded-Encrypted: i=1; AKwUvBzo0Z90GRZQoGXYHUTf+RA8AmhxOTjL4FMcy+AE+nfTWKJ1NNmVeMOKLABwmYh3imqmBh9fScT6tEaT@vger.kernel.org
X-Gm-Message-State: AFq9FYLrKg1xH0NJaJY1t79nwYF9wQqVvZx5L7jwsnTG5R+tI8qIHmNT
	FtFtxGVmXCdJzxbaYVCdEdMpkLURp0Hn1Pb084z0wBn7M/MH9lnTwb3wdRuv3eYtbeA=
X-Gm-Gg: AYBFou01XEuVXy1imnRehoUkSpHF1pMTt1zgKev7bFKyozGl0n9Us7/msBONxgfWyXs
	+rWG+HTKF7umm72RhiNoKWZBiilH/tRDXlRG+46zUL6sYAQwzEajIUEB44860aB5sa8AzMop4k3
	uGw79akagGfgeMIUOInqZhD7roSLww61ViBsQHtwQ2/4J6TDu/pvl9n5vWJoQi1619de7426BEO
	qPBhc6sCN+xbs5eCf4/4W5LTKXPMOHYCqkbMhIcfIjXTBTpxpBqlz9TVA66576/o9iXBsIj0VFL
	ozvDM49UotyaSY9keHSw/SaOCt4v03oIibDTHEsBmqyvwq0uIa8Y3f6lwpME8gd/SfMBLRJ2cAW
	lOQcrxBUXuLaUf/8S9CnZHYOF+//NOWOY3OZyhVbbvi+i0uQrd3TMuEOB+bih+9iuZWIoJ1ZR47
	m3YLSdSZlFZtX/2aa/W2yd/VXykuOnTnrzKp1dvRJgHnWWegOCoRmuLJAJ8A4DliviphvGVNlUW
	zVRE47TlFn3vj/VbM9mt8HmYBVyuiC91dYN1zpeEHfYSvLt4WH/T8j3lNP9dZp48aq2i/kyuX7a
	Vr9X+a6O8jGLrcWI4Z7IRHljNE48n12BpMd+pUmrRID9
X-Received: by 2002:a17:906:d54a:b0:c40:aa04:18d0 with SMTP id a640c23a62f3a-c46bdd971cemr1053838166b.17.1793111736587;
        Tue, 27 Oct 2026 07:35:36 -0700 (PDT)
Received: from ?IPV6:2001:a61:13a7:df01:6e79:f35a:ab88:b157? ([2001:a61:13a7:df01:6e79:f35a:ab88:b157])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebd4ba7sm23338023f8f.33.2026.10.27.07.35.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 07:35:36 -0700 (PDT)
Message-ID: <8469d5fa-2f4e-4565-8d84-43d6b71b4a9c@suse.com>
Date: Tue, 27 Oct 2026 15:35:34 +0100
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
Subject: Re: [PATCH v3] usb: uas: wait for pending commands before unbinding
To: Jiayi Li <lijiayi@kylinos.cn>, Oliver Neukum <oneukum@suse.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
 Michal Pecio <michal.pecio@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <20261027131458.983241-1-lijiayi@kylinos.cn>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20261027131458.983241-1-lijiayi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 27.10.26 14:14, Jiayi Li wrote:
> USB core normally disables interface endpoints before calling
> uas_disconnect(), cancelling URBs while the device may still be
> processing the associated commands. Some storage bridges may then
> fail to recover after a driver rebind and require a disconnect and
> reconnect.

[..]

I regret torturing you again, but there is a simple issue left.

>   static void uas_disconnect(struct usb_interface *intf)
>   {
>   	struct Scsi_Host *shost = usb_get_intfdata(intf);
>   	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
>   	unsigned long flags;
>   
> +	cancel_work(&devinfo->scan_work);

No _sync
> +	spin_lock_irqsave(&shost->host_lock, flags);
> +	scsi_block_requests(shost);
> +	spin_unlock_irqrestore(&shost->host_lock, flags);
> +
> +	uas_pre_disconnect(intf);
> +
>   	spin_lock_irqsave(&devinfo->lock, flags);
>   	devinfo->resetting = 1;
>   	spin_unlock_irqrestore(&devinfo->lock, flags);
>   
> +	scsi_unblock_requests(shost);
> +
>   	cancel_work_sync(&devinfo->work);

With _sync

I'd say both ought to use cancel_work_sync()

	Regards
		Oliver

