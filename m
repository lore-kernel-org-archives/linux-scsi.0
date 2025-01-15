Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685E71991B4
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2025 19:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736968846; cv=none; b=VwWL6dIMZ5NkL816M+fgN8HRQZX02Gb96B5QtKarumLbGrepnuDVb1jlQK2NwINgCNDk/acgOrPgtV8RBySNXw+pmwrX4GOGway7yTQshPBXiGs6TmBy7ufOQ2M/VQcUWdzSM9WBxeBL94HUzIwHWneWfhYk0uST/Ki0GHwgntg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736968846; c=relaxed/simple;
	bh=GEt3aa5+baUPI2OZpNZc53nb/z4KgPrptPQacDscjtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Zh2kKu1zYY+5oY1uUuTlvWLW0SzgGAf8afXtzb6gJK1QwwP/3eUCfwZOIpgNFU6LuqJmaMaHx7GJf2xheIfMuvkK3zUi+jLhLI4cwi/Y0e9Ku2hwAzfj0lfUDsJOlBht1dMvKMF/C1sB1FANSYPzgm5evheprRZAyX3LFc4POUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oqbGxnyT; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oqbGxnyT"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d3cfa1da14so15389a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2025 11:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736968843; x=1737573643; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nYIRfzMIoEey6eiQZC1qlV3nAdw1Yt+nNSYPyfY46Hk=;
        b=oqbGxnyT5R4oTQ3S41XszMA+vwHf/K9ZnpSc0lIALleQPBmO4zTSz3Md9FmUIcOEyE
         Yg7fRpA8wm5BlJ7Kp3UdY62DM3LGKOwJR8ud9s2Ht82nYgVWQ4hQGMU5LSR0yP5C5osc
         MuXmDaPm92rmuylYoT/g8HFBD4RoisQFl1n5GWzJxtgxmPIfJoQgW54cbt9/nt8bopIN
         sox0X5wdHJkuTXisSx9D5slZ8LqYpcmIv6spGiHkyXsxTdB31Gsu2qv+rQR6XScEmpul
         UBi8yHI2GKdgjH9igPIjzDLWuPOguwt4NQ9mvC/wT8CmszT7R3NPMYehdAh2vNhLQny/
         aaDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736968843; x=1737573643;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nYIRfzMIoEey6eiQZC1qlV3nAdw1Yt+nNSYPyfY46Hk=;
        b=RitjcD62vGzvEwxiQco7jnOqYTHfWVxEReRMzwMdATY7g0/Y7MKx0JQ/0j2GsjxgKw
         4zf1/fEmWIe8enxQT46j6RCDmj3xgYwc7CqsdqSZKL96M0A9FZCHb6Fw25bvqtH8Brzf
         CJ3VR+xWSRa1NkxO0YKD1wlpBhScO8cmLjSOuRvwZ9SX3qjEiKmfjY4S8Ifsi1KZutaZ
         qqyceYZZX9Y1wnlDQ7hGmyqPT4pfI+pwo3tE05lc5nO66HS9eeu88mzqg97BhL5EeMlZ
         v2S7yz65sXWOVYPtbb75KBRZ6y2wkesLSZ6meD11PMcq8bipNyERmSiWezLnbJq7nQrS
         0BZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSSyrw8i+Hk6VORnSlnJzoU6gDN2M32NMPHWhvvObKODvDDjuJnj4UFMaQ7tzDxlMkaQfJVzXlCmq/@vger.kernel.org
X-Gm-Message-State: AOJu0YzQrsTz4sQpO8q59PtRUu77CEr7E1RvMuU6cfhl58LiL+kJnato
	lRL1UMdk2zVLaxNDNkk18DZlI7rDhscHJ0bGMfJAuRvdKc0tJ4hTOossp9ftjcg=
X-Gm-Gg: ASbGncu0oT0C0tWjPCaPsGQgCqdK7i5TrB5mG+Z2GyqBF5oqcDyKTQtRXNwnIe3cPB3
	738eArcZNhuEeRAtgAULwj8EOGsPcXCRU4YMKdhU6FQO9REMfjnxkfQMifjAbGCcSKxhcK/aGTt
	o2qNWcwi3OCEPVgEt+PUbKJhi0AknHEZN+YaCZI9ubHIEdrbAUB5wscOBpdmOZZOGSNme34h2xa
	kK5ffe012qeRciAqoCI5vpdlpZFekKiqYug4vaKhbPgeceRyu3PDTTPi6kC+hrQ16QI3gNHoCtt
X-Google-Smtp-Source: AGHT+IEobeKPSb66dhQJB8BVuTHa5PVEBMft92rOBD4aCHAR3KxGt12rfIWH0l1xEEGi6zqG+032uw==
X-Received: by 2002:a17:907:bb8d:b0:ab3:2719:ca30 with SMTP id a640c23a62f3a-ab32719d024mr384947066b.10.1736968842769;
        Wed, 15 Jan 2025 11:20:42 -0800 (PST)
Received: from [192.168.1.20] ([178.197.223.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c9565517sm800167966b.130.2025.01.15.11.20.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 11:20:42 -0800 (PST)
Message-ID: <37603c73-cab7-4973-8705-1deee6445a7d@linaro.org>
Date: Wed, 15 Jan 2025 20:20:40 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: Use str_enable_disable-like helpers
To: Bart Van Assche <bvanassche@acm.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org
References: <20250114200716.969457-1-krzysztof.kozlowski@linaro.org>
 <ca5482da-1612-4fab-bfeb-bdc72cd65662@acm.org>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Language: en-US
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <ca5482da-1612-4fab-bfeb-bdc72cd65662@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/01/2025 18:53, Bart Van Assche wrote:
> On 1/14/25 12:07 PM, Krzysztof Kozlowski wrote:
>> 2. Is slightly shorter thus also easier to read.
> 
> Does this change really make code easier to read? It forces readers
> of the code to look up a function definition. Isn't there a general

There is no general preference, up to you.

> preference in the Linux kernel to inline function definitions if the
> function body is shorter than or close to the length of the function
> name? I'm referring to functions like this one:
> 
> static inline const char *str_up_down(bool v)
> {
> 	return v ? "up" : "down";
> }
> 
> Bart.


It's subjective - in some places ternary is really complicating, from my
other patch:

	data & XCSI_DLXINFR_SOTERR ? "true" : "false",
	video->hq_mode ? "on" : "off", video->jpeg_hq_quality);

note that's ternary is split here:

	dstat & BT848_DSTATUS_HLOC
	? "yes" : "no");

I understand if you don't find the code here better.

Best regards,
Krzysztof
