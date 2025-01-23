Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E752D20DD50
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2025 11:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737632218; cv=none; b=JUZo7DT1XRDyHj8td6x3FpZl/ku9fglh14T+9udWzW/PQyoZqOz6vKktnWilHpkpCvRilviv1ilsKKV1NuoMDYG08P5eFoUWeDMOoLQGH743UVSYjBUXCiUEXqGZC9Q+D5HEh7upcur2dthgwNeoGrn30gBVPlXq/HxPozDtYwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737632218; c=relaxed/simple;
	bh=RdI6IJceYHWNDjwXbPHhGrnfntTwaSLvqJY46KDpWw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VGxxpLF/cSFQ9PjHgEObSD2r6aaEFeE8QfLRnqmVpXMdWNm39utTVpn2oIZcEsPe3teQwlW8BIBouMzek9EUDdgFzB1dwyoEDJ+C+vBJaNqzV37C4qlLsKxRUX1h8amh30j6FqcnYUbABr3A2z7/9YZTc38SNPibYNpn+D2MvIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ruBZpmjx; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ruBZpmjx"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43624b2d453so8021265e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2025 03:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737632215; x=1738237015; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RdI6IJceYHWNDjwXbPHhGrnfntTwaSLvqJY46KDpWw0=;
        b=ruBZpmjxkoV7rFM04585/V49ThTQUAvaUoPIQlGJWzO0nun0ewjdroUriFWzt1Lc+J
         0oz5R6UpXdGTTutIbdN1FSY2bAa9HbGnDMgosAj3hVzXMICzRUQRoNYHHZjSurEiAGN5
         j6CfxreKvhybXuVx2oY++gxygIOc+qpDt+SOkQ1AodfLMzPwPhdr99/gcfFwQ1T1C4u9
         YiiPlUCVr6H5RRgI66JSxopX2dXm/TGa/AcE1Dt4BNVDzp3NgdAUzAGUW2hF6Ko+7v2s
         TXZ/PDYoPuenvzpPcuyHFClX+0Fq1hvVzWb0cwno0Nuz0djvsaazkigH4fSA9uh8fw/F
         RRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737632215; x=1738237015;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RdI6IJceYHWNDjwXbPHhGrnfntTwaSLvqJY46KDpWw0=;
        b=tZ2MmI1o8tROopWBazxLBMDGsq8y9bI0aypSA34pMlkdin7y0IkH7QPtNd2BB7hcAh
         5czfd8qpEHbywSz/jZkJ+it46ua9NpOYUC8xu2fmXGk0mr2DflE4m5LYqmpRhGl0hDFf
         1hUjNBWpk+4odTbGERRVma0ZBZEGZO2oA5zbPjmtsi9veIMioAi5N1PP3cpYfuKBQbvC
         7+Yytiu8tPmox2Y/3XX3E0QUBwLl1Fv9K29lhkNt60T88ZZWRhYsi4SpDJTkOMID/+68
         DKZ0xXEIJQJRmZDO4nqmcC7DJg5wZD6hjRq6HVs4mGu5jWQCPQHfPjvN62ayzYa0D4H1
         VnXg==
X-Forwarded-Encrypted: i=1; AJvYcCUU9zzwZJeEUqg3gpUI1fYAGAahRAdrzp9aPc9bLV4iIFmoxlnHzGdfTOLlKk8VLRkNXSto+VdsTjHo@vger.kernel.org
X-Gm-Message-State: AOJu0YyVWHt7az+g2OFbmCRMUh0MflhcR1quJeCrhNfD5nuDsh0ZAsOH
	fa9uNXGccwKPuT5X9kPGh3uL6npwMkpxmaXkuyjmnHTXYnT6HzElu/LNczkm6pg=
X-Gm-Gg: ASbGnctTaxDPP7IXCYBvLeN+J1W0KXqCtI85sUeCr7m1MdGMPNAA9jkt7HBi2I05DM/
	ew1uSDltI9BJbO/1d46aenOPmt10oelsElYM8SqO77WbmPcXcmrJ6kCuLtZLMu9TRHZTaB9xIMo
	D91dWZhIpe4NzYSDUlyvmJRV3cbBTrc/JBsSs1pewYStE4LPwrDgpwpTZ172BQCUmxYIHkY9T4X
	eEfcRpnevYKTuCLiYUJ2YDO4tvJoaoBcOPWHP11AaHLceLVXcwNp1Yb5tqzxv5eG/7eNmwaOOQC
	GYcIQBMN5BevxnjiJw==
X-Google-Smtp-Source: AGHT+IELUBxDoirlNG9SA4nq62ZMYmDw/0cKfHcaM4E/mFo7d2pn8cQOe4FUQ9oLCcMRfxLaJHQO3g==
X-Received: by 2002:a05:600c:3548:b0:434:a1d3:a321 with SMTP id 5b1f17b1804b1-438913c6150mr239518495e9.3.1737632215254;
        Thu, 23 Jan 2025 03:36:55 -0800 (PST)
Received: from [192.168.0.35] ([176.61.106.227])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b31c6fbasm58088275e9.33.2025.01.23.03.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 03:36:54 -0800 (PST)
Message-ID: <7f8bb83f-aa15-4a58-baf4-6241b479b412@linaro.org>
Date: Thu, 23 Jan 2025 11:36:53 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] ABI: sysfs-driver-ufs: Add missing UFS sysfs
 addributes
To: Ziqi Chen <quic_ziqichen@quicinc.com>, quic_cang@quicinc.com,
 bvanassche@acm.org, mani@kernel.org, beanhuo@micron.com,
 avri.altman@wdc.com, junwoo80.lee@samsung.com, martin.petersen@oracle.com,
 quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
 quic_rampraka@quicinc.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 Keoseong Park <keosung.park@samsung.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20250122100214.489749-1-quic_ziqichen@quicinc.com>
 <20250122100214.489749-9-quic_ziqichen@quicinc.com>
Content-Language: en-US
From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
In-Reply-To: <20250122100214.489749-9-quic_ziqichen@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/01/2025 10:02, Ziqi Chen wrote:
> Add UFS driver sysfs addributes clkscale_enable, clkgate_enable and
> clkgate_delay_ms to this doucment.

I'm 99% sure you mean "attributes" not "addributes"

---
bod
