Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137D0156F54
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 11:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730287554; cv=none; b=jGZScxXwJNWFcQw6j3I2/FC0W63ah6Oe07dvNFFx/0FD9jhdk5RzZ6aNxj8pxwfi/Q4ilRaSvmEZ6qbJK3WHhF/GgtE/Z9hWFX78raFtBSl4QYazgHyQrKEGJLb+EAO1XBThfWsDjGtonj8dhuPjCTuClgKREHvXaQ/feyEbvpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730287554; c=relaxed/simple;
	bh=i/1lFAiCUmr8MozzsQANkNXi63EHwNpndZyFrvfM+q4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VFo+uI/3vVEi/gOk1zyZm2kQabLZo+J00XzjudWlr/wNINMh2m5ytfcmcsG3uNE24ItA7pgKXNAeRTets1yuEfbF2q1j4Xc2hQheGuxomgTD3jVhlFRdLE7PvSSnIQBM8COuJ1Rit5yVz4lsjeGxGcE7YSK7uy1/Kwia88J9djs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nSg/orIa; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nSg/orIa"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2fb59652cb9so64364191fa.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 04:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730287550; x=1730892350; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bMES1QAhfgu7bIQDYk1EUlu+RGSHNt1/K65I4mR80e4=;
        b=nSg/orIadb2AFsxHM/8a2bnuVpIJtpt1I/jLdUgXg0ikJ2Zb0/6vlOCt6wm3RwxvBd
         qp6Y8NKmPvGa3Ecd2LaIsO+9hiuVcCvgyreLqivSq0BASgz1nhVgR+DTxNyGp+fLDCGE
         oBWSaimrzi4dY04qOAjL91JsC6l79yiVc2g8sDy0VBDzcHCxp1H0krMx+++MW2zcT2Kw
         F7RNKOle20XqbBP8YeZHblRDncG6VgqgjSjTlN3kEPMAwFXHkySUjA0Aftj1nFiqJYp9
         NONH3uUgLzsXeJpm2Pf/hGsBwu770BsavmjDpF0L/9ecMmfwqZ8NiDRMXeTwYdwC6NUU
         2D/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730287550; x=1730892350;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bMES1QAhfgu7bIQDYk1EUlu+RGSHNt1/K65I4mR80e4=;
        b=oCRH4CCxDHWW+1pkyWxCIgwK2djg75/Hon8JF7om5CoB4IV/g08/+NkgT0hwFLDFum
         CK7odnquWptAlYD0+cB0vKD9wliWu6iD3uAKzAENoojohUBHTa3JzpdL9O0gDhNrDNWd
         UoOJLdnUNcRyfLfUUCOU3StqgT+2U0liCWPX+0XAZi2GBfWckkAXZo6A24oPLB3wntBw
         g/kFImJjqISYNukhd2hrTFekZ1hGXsGOUnBqrw0Spo4fPeEUMe1vKsqhcIp/CPtm5/WY
         O1NcQwsF5jvXqkWt2tquUvf9PM4nyuuSd0AF0DSXx0kw69D1qMduHGasMgxWzeiwePSB
         Cf1g==
X-Forwarded-Encrypted: i=1; AJvYcCU5BcynoDtGhN7+jiWQDCE9M06sBctKU1CM3sE3Q0D2J7wM3JPDvcsKgP6BozbOgkHICYLInPNLQIk9@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3AYyrqe1OEGECj2/z6CJ6t5BmQgFEJXwp9xagV+UXMp8CPTbA
	Z04Azwviy2oulsYc/s3BrieN47zalTkhmO/kJWC7lZ6a3UrviZrKpaWBCTzGXAo=
X-Google-Smtp-Source: AGHT+IGY4OdrV2g1gR/OZMrvjE/lAI6jJHYq/NY61VEtXYCuq6a/kfZIDfbwe86CLVK3+WjNbtSP5w==
X-Received: by 2002:a05:651c:1508:b0:2fb:6465:3198 with SMTP id 38308e7fff4ca-2fcbdf60348mr75079871fa.5.1730287550241;
        Wed, 30 Oct 2024 04:25:50 -0700 (PDT)
Received: from [192.168.0.157] ([79.115.63.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd9207d4sm18412585e9.20.2024.10.30.04.25.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 04:25:49 -0700 (PDT)
Message-ID: <436b02c6-a262-4015-92e3-454d444e877f@linaro.org>
Date: Wed, 30 Oct 2024 11:25:48 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/11] scsi: ufs: exynos: enable write line unique
 transactions on gs101
To: Peter Griffin <peter.griffin@linaro.org>, alim.akhtar@samsung.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 avri.altman@wdc.com, bvanassche@acm.org, krzk@kernel.org
Cc: andre.draszik@linaro.org, kernel-team@android.com,
 willmcvicker@google.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
 ebiggers@kernel.org
References: <20241025131442.112862-1-peter.griffin@linaro.org>
 <20241025131442.112862-9-peter.griffin@linaro.org>
Content-Language: en-US
From: Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20241025131442.112862-9-peter.griffin@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/25/24 2:14 PM, Peter Griffin wrote:
> Previously just AXIDMA_RWDATA_BURST_LEN[3:0] field was set to 8.

where was this set?

> 
> To enable WLU transaction additionally we need to set Write Line
> Unique enable [31], Write Line Unique Burst Length [30:27] and
> AXIDMA_RWDATA_BURST_LEN[3:0].
> 
> To support WLU transaction, both burth length fields need to be 0x3.
> 

typo, s/burth/burst
