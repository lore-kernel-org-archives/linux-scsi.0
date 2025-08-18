Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7F32765EE
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 10:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755514261; cv=none; b=BeohKVuE6jpHpcxuLMLHj/kgN5HRwA8cBbZ8nOUehKjd9zFI1fSC8jObvWJvnfjH9+q8hErdoTsUVh85h+BNEXIv7iHwyAJIisL76EHJtmTaEq8BJs9c7YwMjKoGvq8qr+TSw0ZGFlAQg7dLq6u2AsE7Oqi0WIIwl80DyC0OaJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755514261; c=relaxed/simple;
	bh=pZ28X6C6V+lht1om+EThDAP4EVsl4TPoXoYx+3BdCx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GduQvO72rRfAM6XynGWT5ZEx1Lv9f/cHmi7deKQ2UCC/KpX5a+x33WocFLQZPNyMCZ+vLaHAvSbnjRSp299hrJtZheBgOn6iCIdhN+5o0i2jmWvsD17LzJtAPKEoyI/HfpeIqO2aBxO1J6T2/GuruDaIV23s3B14KLxT3Vt+eHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EwIW1kBT; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EwIW1kBT"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45a1b00f187so16895975e9.0
        for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 03:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1755514257; x=1756119057; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OZHyg61EBWZaARHc87dfxpWntWm0nMzTS3sgcvk3T3M=;
        b=EwIW1kBTgag/lEv67UZSyFSE4hfrKqNCrDD5WDwgejKDJwbDaezHDvk7oo1PWAxsiz
         UUGQb3rVYbEsYNIXxOdoasaBjzLKNVZAOlG4CsiYX2jeBaHhnrAgMr4F9KXmJ6cSzSMd
         NTc0eC9azuQ78FE/3/hl8zc34YjJ3QI9BY8uGFIhenMZ78fbuf4O4bkG0UVT/RAqHaSL
         FTMLFdoObpmwAqhV7DTJzI1xIOFmFwKtEqRGy70SsAPutmQvljcBN8IXYreqAMWarj07
         QA4JICXqLYKt1ar64zaJ1APpaeI/39kh1C64dcG0Z9zZZ96hg57XjIhdNryYPWMzV/3H
         opZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755514257; x=1756119057;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OZHyg61EBWZaARHc87dfxpWntWm0nMzTS3sgcvk3T3M=;
        b=n1A93btz2VLLUCrpTkBmXamULQiJEBvHYoyxSkOu3eeur/f3JOClfbJlWZNq8FY0QM
         GD0qkQt0SqbBJRQKc/Yx5uepe3Z57654OPP9guSnYw7VfJ457ATLqVj6h9ZbE4GJOfti
         6uAWGPw2pwTjzPUOMwJA8ah6cyIHJzLGzqp4sAxz45Vsoum6ClYo44flw4LOAqlp/hFA
         vRsdgASaM2rUGTlC93OIwOnVwX/Pc/A8ljaztILTkPMGanccYB/9r6DdmoQ+4sznbi+j
         27sOEZ8F8U+tZmbYAm5GU+c0gO/kzfeHRSszs0Tj8kSQB8gIxsc8dlVnXHtFHkuZZBVH
         KhoQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2FFdN1i/jURZdHPv4yMhqPUmnKP6QhJRL7L9rbBj2VyP79OaP7M9RScUshGkZTm99++IIP4GftTTC@vger.kernel.org
X-Gm-Message-State: AOJu0YxUujgCub2Ukvf6r20BCD1poUShqpSTibwvS9Yzxf1LOBCNERWb
	qqhIIOYCdlEkeyaY7tFthVxsFwBeNrckTQxON9op/jv9ijlz59rZwedBQcrdEcZSTko=
X-Gm-Gg: ASbGnct+CIqKghzioqNTEhnz/URa+wcvHFyfvsizJtyx7e6+SfqivJpvzy3o/2GbAZP
	bcadj+6BnzNoXT1DgEV32HtD5Nd9WCfDJSvfjmbpV+ULVANsGEtUzOGC1YQKBzrVlw1Z1nFpzQX
	UxFcDoUJ6FH8OWoZmDLec2Wulvzu/lFMgzlja+niGsGozeX/kOf4oLcvQ6EuoYCTrhYGUsSOVJd
	J04/a8bWBpBBZxQ2E379dMJ4xon+o+JE6xzULLDekdVQbx1c58sYEmQDn0uTzXXlm2yc6MFQRWO
	Atpgb0lColDXGRaHR7vldj4ktIgX/SO6VO3AxJhrgudlvctTMYoRXdElld+GqdIvzqVdRaE8pMv
	9BTZW7ZBo5+j7nQOpuL9AloLbwVtnrjqgF/XN4+37vIHjyLKM0iYyFn94k07s4iA=
X-Google-Smtp-Source: AGHT+IFtjih4o8NS4VHkcYD2Txcwmf+pFe1QNvS0DpqHsE8KLRkcgWRFJ+48VhP74+JNXQyo/iL/1w==
X-Received: by 2002:a5d:5f49:0:b0:3a4:ee40:715c with SMTP id ffacd0b85a97d-3bb66a3baa4mr9592468f8f.14.1755514257365;
        Mon, 18 Aug 2025 03:50:57 -0700 (PDT)
Received: from ?IPV6:2001:a61:134f:2b01:faa4:fc57:140d:45b? ([2001:a61:134f:2b01:faa4:fc57:140d:45b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb6816ef48sm12090391f8f.58.2025.08.18.03.50.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 03:50:56 -0700 (PDT)
Message-ID: <a1cf393a-9901-469b-90f4-81211f2e1b9b@suse.com>
Date: Mon, 18 Aug 2025 12:50:55 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/11] USB: Pass PMSG_POWEROFF event to
 suspend_common() for poweroff with S4 flow
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Danilo Krummrich <dakr@kernel.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 "open list:HIBERNATION (aka Software Suspend, aka swsusp)"
 <linux-pm@vger.kernel.org>,
 "open list:RADEON and AMDGPU DRM DRIVERS" <amd-gfx@lists.freedesktop.org>,
 "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
 "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
 "open list:TRACING" <linux-trace-kernel@vger.kernel.org>,
 AceLan Kao <acelan.kao@canonical.com>, Kai-Heng Feng <kaihengf@nvidia.com>,
 Mark Pearson <mpearson-lenovo@squebb.ca>,
 =?UTF-8?Q?Merthan_Karaka=C5=9F?= <m3rthn.k@gmail.com>,
 Eric Naim <dnaim@cachyos.org>
References: <20250818020101.3619237-1-superm1@kernel.org>
 <20250818020101.3619237-5-superm1@kernel.org>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20250818020101.3619237-5-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/25 04:00, Mario Limonciello (AMD) wrote:
> If powering off the system with the S4 flow USB wakeup sources should
> be ignored. Add a new callback hcd_pci_poweroff() which will differentiate
> whether target state is S5 and pass PMSG_POWEROFF as the message so that
> suspend_common() will avoid doing wakeups.

Hi,

how will Wake-On-LAN work with this change?

	Regards
		Oliver

