Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6E81E009D
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 12:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730291788; cv=none; b=i/Mu+AaJr4L6hz8/IDdbl/Yp1vZ2CNv64cgQuQHmiqYUydjTZ9DqOx49F46QITJD3hjUFa2DCrf5GQVBQA3YUeyK0siq/RRlSBJo29anx//UVDbvZzOSShIk+JPZtEbCFnIqNKeuiPmxNth3Fp+I63VAxiHTrDIeLSXejwW6LF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730291788; c=relaxed/simple;
	bh=1KULsa+6j+6JCRwXetM56Lo0Zn1gw65F9feRGJpZAlI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I13eS86acWI/Uj/E9XL3OiV9/VKvNu85IRmcQRZRiVxWlXDsTK7vDjkhLx6UAjpfoYAusj5edkPYFOqvwiuadk0Ooy56VY77lQSNH3J2Y29c3ZfkMc+2AuG5id3gEjwL9j8SXk4mb53ii3ftJzPaiNoGgRfXymuKygK6KTNKI3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GFRe41tY; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GFRe41tY"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-37d41894a32so553666f8f.1
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 05:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730291784; x=1730896584; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dz8ORMovlm8PCaRFyxkHztKoIVxbuXiuAHwjiXhbYNM=;
        b=GFRe41tYh0/0RJ4DTtspjGPX7JYeR2XtAqYQQURty/da+ccLsHqsTsEkFG4M6C8e06
         HBsoK0KL2Fl6s42bnC9iXFlUgezE2/S65fXHTmdJmaWzfFHNeqXZCnqYBX6nwmF8en0z
         9UkFYKz+rndqyUQEfhKpqVDo8PnWTUKmKxwwtjlOqtaO9TGIRd/xWpw90KXgfpnxceuZ
         rt1KuDE3nZB6Q4Ua7C94dJaNNHOuiB5oaO32roeUuwGrw+u5kQy0zVaBeZbUe6VP/MNs
         dAyzrkrQpPO5VBnKULe8r9qnab267CzmtIKXht0joYDIUNdXK0/+DKAK0aEHLmV1Vgb0
         32Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730291784; x=1730896584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dz8ORMovlm8PCaRFyxkHztKoIVxbuXiuAHwjiXhbYNM=;
        b=iMXxkCk5TkKANrrDkNArhvJhvPheImentU81YnlbJL8hcI6CFBmITZ2D/RqsYHOy2Q
         PNnz/6biXnC+4J147zTzMj+7dQK1rjue6dcXNEW6xtcjmZLmn62K7P/+PlYOX3Z+cl2E
         vuaaUraTte+9Jxxz7OlORqfbRMPwst1qB5H21hCc9E9wndKBG2SSb8UB7utSKW4VD4jj
         3CQRC716OZ00XJQEq6ug2ZpGjKjdXMYAK0IFtJiFfo9sO4PdtCImQ4vyZPxYR4QhuzbB
         CvEXZuqEqpvo5jeTQfq4Mgfz6hbmtkeV3Dm+WAaW5Os+q5TUUqlewLfaNxwAR1ro10CH
         hXpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXDtPkpcj8j1Xo71anLl5Rr99g9XWBKTvpN4AWF9fxlhZYJU7mjReT8PrUV1YhGVz1gExtx0RZ2B48@vger.kernel.org
X-Gm-Message-State: AOJu0YzVw3kqWqXsCtQmNwmPrCCUIGeVNLnj/f1Dl7GXSivQe05lPWP2
	e3agiBUqvwsYpcyBNyoV72YPdO78SCy9NDiBq5yKP8anLfrMbpiMfpGZVLqDtmE=
X-Google-Smtp-Source: AGHT+IH4FRnmdK9aLuDppBh7wG3Y7nEnBh681TyLIF03sNmMciY0XgRonlSoema7XbLW/dKKGVBRtA==
X-Received: by 2002:a05:6000:504:b0:37c:fbb7:5082 with SMTP id ffacd0b85a97d-3817d649f89mr4690368f8f.25.1730291784286;
        Wed, 30 Oct 2024 05:36:24 -0700 (PDT)
Received: from [192.168.0.157] ([79.115.63.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b47952sm15159285f8f.48.2024.10.30.05.36.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 05:36:23 -0700 (PDT)
Message-ID: <8dfeb9bf-3326-4d04-8dfb-fea9dad85864@linaro.org>
Date: Wed, 30 Oct 2024 12:36:21 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/11] scsi: ufs: exynos: enable write line unique
 transactions on gs101
To: Peter Griffin <peter.griffin@linaro.org>
Cc: alim.akhtar@samsung.com, James.Bottomley@hansenpartnership.com,
 martin.petersen@oracle.com, avri.altman@wdc.com, bvanassche@acm.org,
 krzk@kernel.org, andre.draszik@linaro.org, kernel-team@android.com,
 willmcvicker@google.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
 ebiggers@kernel.org
References: <20241025131442.112862-1-peter.griffin@linaro.org>
 <20241025131442.112862-9-peter.griffin@linaro.org>
 <436b02c6-a262-4015-92e3-454d444e877f@linaro.org>
 <CADrjBPoq2jbrMC7wBrjGxMwQ1ebTtBNRQzQ7NfE9=Gw9_4LQ6A@mail.gmail.com>
Content-Language: en-US
From: Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <CADrjBPoq2jbrMC7wBrjGxMwQ1ebTtBNRQzQ7NfE9=Gw9_4LQ6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/30/24 11:32 AM, Peter Griffin wrote:
>>> Previously just AXIDMA_RWDATA_BURST_LEN[3:0] field was set to 8.
>> where was this set?
> It is set to 0xf in exynos_ufs_post_link() function, see the following line
> hci_writel(ufs, 0xf, HCI_AXIDMA_RWDATA_BURST_LEN);
> 
> As all other SoCs expect the current value, I've left that assignment
> in the common function, and we update it in the  gs101_ufs_post_link()
> specific hook.
> 
oh yes, as a driver quirk.
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
