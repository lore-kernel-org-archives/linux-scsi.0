Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AF91E9092
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 13:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730294959; cv=none; b=K7MkUV3tfRi1pCOFNnf5VsYa0eyYnAnGKWI8J4XT8EteSlRrKxhzpd9XNoY5FXYeDC6T83hj7j9q6LwbnK2LLqxKFa/Ndd8tT58KGEYh8laL2iyUozXu8rjzZOdL18i7DFMOwgm3pskwT6KNMlKx1qW3u+1FjXN68oYOIEJDJlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730294959; c=relaxed/simple;
	bh=rcLE83f8I5rl8ZtZIrZgOnTLuwTtp/g9tS9d1ZU8SuI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=dwXnT9S4KDc9+0+7VZvuWPhdBAyFWfIAJJrjT2Ku6qQ2BArr4Dv0Uk1Gx0/u8VKIWEcjTAWepxCy57AcJC2WKvkfAbenvVaSeJdQ8R+J1Uqh3uxOvTEWU7s885XJQQniEYhWvFjLrN57CWLhp8nmdpA2xH85Ye6MYJ6vxyxrvHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=w8f6Nwe2; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w8f6Nwe2"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43168d9c6c9so64603735e9.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 06:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730294956; x=1730899756; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rcLE83f8I5rl8ZtZIrZgOnTLuwTtp/g9tS9d1ZU8SuI=;
        b=w8f6Nwe2Lvw6fY90d7sWFp6pWD0lWV9p0z6lJ5/eVjsaJiivlR9ajTQbRbZsF5dRr+
         r5RBvcTJHlsmOazfq7+OyUOLsQUYQ1y7MxWAadXX4ZcTco1Mvf5QUvlV/IYTBFwc2WRf
         vIhytAaZhAfNqemQytcQD/2CqpgSx99caBYvZRoIusFd9zfF5g4OuoPV7qGKNyqYKmU6
         JfC9HpL4aeUF1qHs6eAm6CQqu9nHGEjuHij77tZ+DIq9BwA8bsAJfWTJpWgdeQVMOnk/
         b44qw/RSR0rTNJcrf0atYEZzyg4Jbk7qTAOxtwqhv5F1/VXTLp/kxhmybcF6ifkfK9kp
         97CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730294956; x=1730899756;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rcLE83f8I5rl8ZtZIrZgOnTLuwTtp/g9tS9d1ZU8SuI=;
        b=rgFqF12fQ8U3bY0HdeHFm3MJiUXjI6shXkHGc7RBpXV8k88B72P0lHbP5eqhDpPIPu
         zm2VMyLgy5Sw58Vp1VyYBpQFtdYG76vwJ7+rDpt3SZx8iY93bwa1ivEyuNYDjY+4bl/4
         KE0EB5OL+Rkxc78zrXeEIE8W1tG0UAD4bZ82k7VlpzmEhr6hlzbonTWtp5uoOi/pIlXn
         ImRUB9ZX8jBYXzfnRUKebQ8lnQ13jL3FJRQAbbAw8uBWRzxzQixSN/ruAo4monYSPI37
         xZ6WVLk4Bs98fskCcGaeCfvQtCJNxX2eU/ui9Pfpov1SCYIy5QyUAqZvQc07tZYJVTMl
         7wuw==
X-Forwarded-Encrypted: i=1; AJvYcCXRIDitEZldTJTVHgfaVJAzVs+yfcPcyh3H2AL1iHYwSe/TFOjgEVtugs7G1mrCBzgHvRAXveww1zFG@vger.kernel.org
X-Gm-Message-State: AOJu0YylGvyIMb3I4K+3ySdHBY6wefIXY60CJxCpWJTwCnm+taeTsc7v
	dh9vDZU30wDdPK+ano/LKM+Ap/rf+bsNYtlSlk4QAzDrVEHe5dYw8GuTCD2ieSA=
X-Google-Smtp-Source: AGHT+IHp5AbAqgjQIgwYYwcTFJhtpBHYbLWugEe1xzPeyU3dGtA9O/+opSkEXa/XOrO9WuCxMOGUqw==
X-Received: by 2002:adf:ea43:0:b0:37d:633a:b361 with SMTP id ffacd0b85a97d-38061206c0cmr11906179f8f.51.1730294956053;
        Wed, 30 Oct 2024 06:29:16 -0700 (PDT)
Received: from [192.168.0.157] ([79.115.63.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd9a9a53sm21657955e9.30.2024.10.30.06.29.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 06:29:14 -0700 (PDT)
Message-ID: <8e2a327a-5efc-4ba3-afa2-387099967468@linaro.org>
Date: Wed, 30 Oct 2024 13:29:13 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/11] scsi: ufs: exynos: Add
 EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR check
From: Tudor Ambarus <tudor.ambarus@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>, alim.akhtar@samsung.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 avri.altman@wdc.com, bvanassche@acm.org, krzk@kernel.org
Cc: andre.draszik@linaro.org, kernel-team@android.com,
 willmcvicker@google.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
 ebiggers@kernel.org
References: <20241025131442.112862-1-peter.griffin@linaro.org>
 <20241025131442.112862-5-peter.griffin@linaro.org>
 <f5ac07e3-3fde-4ac8-8cfc-fb7918ffb2a7@linaro.org>
Content-Language: en-US
In-Reply-To: <f5ac07e3-3fde-4ac8-8cfc-fb7918ffb2a7@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/30/24 8:56 AM, Tudor Ambarus wrote:
> tx_linereset_n, rx_hibern8_wait is set but not used anywhere. Can we
> remove it? Not related to this patch though.

Sent patches to remove these fields at:

https://lore.kernel.org/linux-scsi/20241030132649.3575865-1-tudor.ambarus@linaro.org/
