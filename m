Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4EF1E7C07
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 12:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730289629; cv=none; b=c8Ki4PfEghPZkkQDAeqAv9AKQriuKUOUkb7j6kD2ONbbmb/8WM/lM2zTUnj4DWw20W/gAc/7TX8g/ro6W64PqPhVjbcFDNqu7WQ74WW/Wrt1kFEtl8Wuy4SctMiwf1qcQnl3Pi+USAg/0bDE/ic3pdVS88qxXORvHGK0PEu/NbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730289629; c=relaxed/simple;
	bh=nM38MNJvKA1mecfRM7u5vCbSbJQllP2Ezo9yQDCPKDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eZmfPCDA/H/XF2p2URNjtNHDQlVOvcprHutHIeoDr8OAmQlXmxieUXuQDParyLU/h6KYL7lBAjPjmjphKr+DkyWJbg/3nmGXRyYK9pMClGIjUhB//opSi6Hn2tXpt3DIae2n4uKpucgAobrS6JaGeFCfI/ko+JXzRWZ1gZFbUEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wwu1UdnX; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wwu1UdnX"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43161e7bb25so60726455e9.2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 05:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730289624; x=1730894424; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=heM+XH6baATko105nYV8E2040lmy0LhxFZdot+CyuRw=;
        b=wwu1UdnXlNqqfLKebzkbOvo+TJ1bD0rSwmONnuKARwoq3V2ZViDauVnWlFv8lDx9EZ
         wddmg0pR5LwJjoCuUaoz6qwoW5cSRm3+6S4zoqTjFWtFPgJex8dA7yvPjD5l4vCPLHIO
         ljfmXFaYgSvNkqFIyj4qMDDxPL1rylBzjP3JdLIXXG9LzxSUcDF2jsGo9j1S/GvHcXLZ
         y1vYILv1yZnWq6eKS8MougYlWZ+n2deKA9HMa62+ugHRYKNxgPTuJhkvBXj/fh5fbsxo
         AU2ShtFYSBskyrUT1ndAvldyckmFh+MVmWC4CrVGW/3WSJbZRYExJiyB2yyMRx5kms4m
         bYsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730289624; x=1730894424;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=heM+XH6baATko105nYV8E2040lmy0LhxFZdot+CyuRw=;
        b=hXdlx5mYybq3EPMdMvmykRjlJ22UqaZojuKqc6xKhMbjGAT3lNOu18HRh+2ATV/Hvq
         60TEoKN19K6pvj7zcBv7l7jXpIVjMPp4pWteRhGPc8ofavLXqAdI3pcnGcy3MhtR/ya0
         gQPcxMg2id25p2zc3p96lqX1U+8gwBgXLkauOhsYIy6x/RSuTqj2QcG5WGi7Kwk1ajVf
         2yI9BM3dm0sdpBbXwi20bB2GRvOuIMiOlt8YCc6/L+VMI22ioRcWiFHWsNzKtVfP8Bwe
         YYnebpy8CNCWu3EEb+v2IDy2CI4QT9Mbq+g1HewRr3dvEM6eqicSz0C6YZcGfbOAt8m9
         jdsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJk3EQ0Zm9I3+fc2fi1xf1ewbJ1vx/JvhwJ9BDvRYOmfjpbxzXtdhHfjipFDpmmxZ6KPnHmFeSEW3W@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn1nbiTlj9fvnxXr4pFwFcTLb+XVz4uVkG0Jt6iAqOkaBC0L/9
	AScA9Z7ghIyaELIw/dHFg+n3Cl8mHHJb9DCa0rd7c9o7lf0dou79Hw519RB9ydA=
X-Google-Smtp-Source: AGHT+IHdqyep7BVt0uyn5JbTz0KBCY80ohOEAxNDfe2YT8nR9HTsXFBe91fCaeMmIZfL9ezJQQxpbg==
X-Received: by 2002:adf:ec8f:0:b0:374:b35e:ea6c with SMTP id ffacd0b85a97d-381b70ed1c3mr2049217f8f.40.1730289624347;
        Wed, 30 Oct 2024 05:00:24 -0700 (PDT)
Received: from [192.168.0.157] ([79.115.63.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd9480e5sm19330995e9.16.2024.10.30.05.00.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 05:00:23 -0700 (PDT)
Message-ID: <b5dcd5df-7215-4679-a6be-c45d525e8051@linaro.org>
Date: Wed, 30 Oct 2024 12:00:22 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/11] scsi: ufs: exynos: fix hibern8 notify callbacks
To: Peter Griffin <peter.griffin@linaro.org>, alim.akhtar@samsung.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 avri.altman@wdc.com, bvanassche@acm.org, krzk@kernel.org
Cc: andre.draszik@linaro.org, kernel-team@android.com,
 willmcvicker@google.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
 ebiggers@kernel.org
References: <20241025131442.112862-1-peter.griffin@linaro.org>
 <20241025131442.112862-11-peter.griffin@linaro.org>
Content-Language: en-US
From: Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20241025131442.112862-11-peter.griffin@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/25/24 2:14 PM, Peter Griffin wrote:
> v1 of the patch which introduced the ufshcd_vops_hibern8_notify() callback
> used a bool instead of an enum. In v2 this was updated to an enum based on
> the review feedback in [1].
> 
> ufs-exynos hibernate calls have always been broken upstream as it follows
> the v1 bool implementation.
> 
> [1] https://patchwork.kernel.org/project/linux-scsi/patch/001f01d23994$719997c0$54ccc740$@samsung.com/

you can use the Link tag, Link: blabla [1]

A Fixes tag and maybe Cc to stable? Or maybe you chose to not backport
it intentionally, in which case you have to add:
Cc: <stable+noautosel@kernel.org> # reason goes here, and must be present

In order to avoid scripts queuing your patch. It contains "fix" in the
subject, there's a high probability to be queued to stable.

With these addressed:
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
