Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795434070;
	b=oLe8NMg9Y09+BsuMgvH7v+dN+UbnnYxlT2WrmF7NpasfdGoEQq3Mg0W7d8+mp1nJNodY
	 JAxCvszADClTpZ9IfV5GkXDbyNLOXik7VUHWzr/gxfD0r0jsCvlN4HPLuN2ILQL3tKnlL
	 gddzi8zUDQIGiW/EIEFJUeou4uAvRpLp2W1aCdXju4U4FSwCtVBaXgcV/lmLbJUqQLZYs
	 XJT4tttrjVAYQSFiMdsDUYOFwn3TcG3BYyEdgjXGEbBSkbsL1qh0YqK50kzEm4ucbhaHM
	 50x1Im108SrxPmXcdHDOSrIWvo5KoR/WAfArEI7CqJx1bDGZ2AzOAfRZGp+QAdJxxUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795434070;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=F8UfxySGOv1BnhxOIHb7TZOrVtDzm4+SYsgNqgsm3UU=;
	b=15mZ+TgyTn7gWh1XhO2fLWFteRanY1uEolVi6FWP6BBZ2EHay2oPGeWeZCl/7c7sxDdO
	 oGlbOGn0LkOWFpMIk+8O748pRz1J+45yIAcZyuwIQ0VCsEmfYLoeg1fIn0TFJpMD7C+X6
	 Ds8VwIX1vKa11zI+qL/JJuh46OKr/icxh3yd6H9rEgp3idi4bd2i1ZHz9FwqwOdB/G8of
	 0SfIzXOKAIMbeXhrDd4LdjNRgX8HIaTeegVbnQTeCP/zIm11jue/VY2qj6ZazYuNfvR2T
	 pTtPrd8uPV0iSM1PmL6eWlp+uXEBBMGF5jrLoaxWc+G04xqEuxeRXeIjbre69aDJRXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=J08bLTro;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFFF606A321
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 11:41:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AFFF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=J08bLTro
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4a5024b3c28so2480031f8f.0
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 03:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795434068; x=1796038868; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F8UfxySGOv1BnhxOIHb7TZOrVtDzm4+SYsgNqgsm3UU=;
        b=J08bLTrowdgJPgjhkkBH+cXrotJoMXPemIQ4IlNLhjvUsvEXaRek0D+f3nVkoBcNkh
         4tYINQfWwWQYjZJIlLQN7nHRU5q0XXX7krCcQyjlax7TWO7IePBcmfPUf+Mr6jhXfDCk
         H3bhw/sV2MAVi+2jL0qxEeFIoxAWTK29mrR0a67pf0Ds86fuCZPFR+XxshrI8rgaivJB
         x/xrLo5p9ErhpMb6qjIVcyaFLdwNrebz2W33vCrRZSQqllNBEcP7PTqtwNRxdu4XzMWy
         b5ahG1Oh+3zy2Vlxntkrt2K0Xb9n5G26GmZlA7sg3+MVUM6Ss/I7lxY1+LPE8HHVQ6sv
         k6NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434068; x=1796038868;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F8UfxySGOv1BnhxOIHb7TZOrVtDzm4+SYsgNqgsm3UU=;
        b=xirCUOEWYjzcanMBEPU5q+RCAyr/XbO1vC+I7xWIIPaxFIPkmqYNHCHLnN1CFQhoHn
         T7eYds1dc5s3CLRyJSCHOOdSURuoGcHAuyPqjoqlzYDT1TPgGOj9cA+mG3rLxpwnpzgg
         NyBBZEqsSsdRr/wb7Zqyqq/N2j6llSKf67v/T8NeueAvM647Bw4yBo78wRmA0i6BDydw
         kzzEaOUKn17xP602PzzVLQglWbOWybt/Ccamu9UHPXQ5VY/CXiBszn/RiSvxF0nY0JSr
         9GoXTFQbualBdcUKdEA/2tWbGvrO3fPO85HqdEs2OTcnvn+C4tIoztlmcPQ6EhJQnwOP
         qWBg==
X-Forwarded-Encrypted: i=1; AL+hErFzLpNcTdeg+PoJJ5h9280hBE1clr97QfPppYAGchs0SRf6HDoHsNrvI1GotJct6l3V/LgBSoDqAwWh@vger.kernel.org
X-Gm-Message-State: APuU4Z9GfaAEVMxX/wYTqcKIZrWG5bjnKSIS1XJKhCRuqkVdY7BDdXU1
	r92QsF45yViqRyvrqb9zMpUROiETkKUFIzXcv4/FCwNDPPgkHU7qCWVO/0dJZpyGFRo=
X-Gm-Gg: AZFdTZc6OYE3hHQ5E5kKRtkbDmKFwJFejLxbR4TnT0O/f51McoYsIs9kwjGu4MxAJvq
	7k1MTix7p2a4ylrfPM9OU23pFj+buHV62MJUg7IuT+d1VzleHg4XnONx29tAq0+edXLsxf+Kmbs
	ipPYgop3pzYgGOOl0xgTI8qeMuFY2E4lYs3zCx/J+sQ2Bxc35bJV7QzFMbsUNJ10OcCNq+S6NSf
	HcyMrCtv6qH5XAsVdpv+wwXIIpltBTZi/KxqyuJE7tFS+DPzrdhj3piZ6FqNyW2DHFSmOw7V2AC
	LmL4q8iY3/+ZR9f++mV4spMb/YfZnlboFoZZXOTyY1YnFK3E/N71iPLutKa+bjUbSE7CFAElGAC
	HstfaIA6mkHUC37yW47L9pRGKbGIhuWD7sOGPXt+I1ruu9EkPkLLOftp49j+HS2I8To0G2biP1Q
	LCDJLCif2WtS8ktmKTOMNl5ge32umpfXLrRWwGHHMiyAVJFqN2bPIWbadmQOPIrVhlpXXurH5Kj
	Gvy18935xZ6h7l1WXZwvw94y9a0+W+D3rjjr3/LirfOr9G7kBkXiOe9zcCN7DSUOmgAv/aD1v4H
	kR6dvQDXXFRLtkaVtJHI10Q2tccTCjfblKmsTEk7FdDimOCbN2UUMfZP4C5NkFmKFIpgMPGSWxw
	nsUlo7MZM9rFXxFzP
X-Received: by 2002:a05:600c:3547:b0:4a1:c27d:e1a8 with SMTP id 5b1f17b1804b1-4bb8880b88fmr223796715e9.10.1795434068387;
        Mon, 23 Nov 2026 03:41:08 -0800 (PST)
Received: from ?IPV6:2001:a61:131e:b901:6da9:459e:7c6c:e85e? ([2001:a61:131e:b901:6da9:459e:7c6c:e85e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b39b6sm305870855e9.12.2026.11.23.03.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 03:41:08 -0800 (PST)
Message-ID: <cef781a8-45db-4540-981d-b38667dcfbb7@suse.com>
Date: Mon, 23 Nov 2026 12:41:07 +0100
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
Subject: Re: [PATCH 1/2] usb: uas: expose US_FL_NO_ATA_1X in sysfs as
 ata_passthrough_disabled
To: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
 Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <20261121155253.4980-1-mat.jonczyk@o2.pl>
 <68f6376d-a0cf-4f87-9cbb-0afb7b8536d4@suse.com>
 <52a233cb-1671-431c-8c14-7757ca947aa5@o2.pl>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <52a233cb-1671-431c-8c14-7757ca947aa5@o2.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 23.11.26 11:48, Mateusz Jończyk wrote:
> W dniu 23.11.2026 o 09:27, Oliver Neukum pisze:

>  > thank you for handling this. One thing though. This requires putting
>  > the emit code into every driver. Can we centralize that somehow?
> 
> Not really, short of moving the handling of the ata_passthrough_disabled
> attribute into the middle SCSI layer (which would also likely involve
> moving the whole of US_FL_NO_ATA_1X logic from uas_queuecommand_lck()
> there). Is this what you mean?

Now that you mention it, shouldn't that be where it ought to be anyway?
Usually the SCSI layer generates or filters commands, while the LLDD
determine what command sets a device will accept and reports that.

	Regards
		Oliver


