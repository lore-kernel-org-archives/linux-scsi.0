Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D222472B8
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 08:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789029229; cv=none; b=jGBi+2+BKrdWYeSVEcSV/JE9cQxb9zEmmvUWJ4E9aPImq7TIZ6Artqv6k9BowOC4J2i6NpJ4f+XcAg5Xtv/+MgyrAftj83CLoX9FqXbKEDhTCjV1u2oNMbr7n1ic1j8BRzXe2YoUG55EIer1tjaZfBNJY/28ZbWpGjhn8M4daGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789029229; c=relaxed/simple;
	bh=HhQAnu7am8lcan+rEXFRV1oJg16AJp0jaoM8Z9/hRGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c54kl9OWmx9W9BvP4VS6I0/5a9IXfYTLO3oN1DPqhCGIuucXFdEmjjsDYhT7zTA0wOo/Paa5GmZNDfF7cw7lM0zgR+C+ck5i2CrS6HOZYmcWLA+FoA/3/di3GDGO0hDrAuRTooNqkWOzwjBK7U+jBNm0EycwgKSTZHv41O9Iwis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JiunYuQ4; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JiunYuQ4"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49b965570d7so75786365e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 01:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789029226; x=1789634026; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hzZhRaUvpfNvfJeOcUe7YmDm/dB9ckW/oQNsKe9IOfA=;
        b=JiunYuQ4liDD937BhXd5a09tfOrYolYtaB5Rnh5uTGXZu5/PT+SAVvYx/1XNdn/jtc
         a8GbrlxlAOkdbzi9Z08tuVMQN5JpLxm8GGLGIpc/1Dtwo4nwUFl915ERAqiRpqfX1Gp0
         YylBGHNnamqT5GgSxrBkOdvJI7G5yDx1oCPEAOWA9dOM0ZpTqK4X8pavphCNLN3Iw/DU
         i1MesVB4IO0xPi796QAlx9ig5vPc/H+YZmO3aL5qGnSoL0/3Kno5rdTWboLMPb2zJ/1I
         vgs4mveLRQxdiK4XU5QrG3/gz/7njVYCm2aSprTaWE/xB/fTptGfayxBllfWy6iYuWP5
         5jrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789029226; x=1789634026;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hzZhRaUvpfNvfJeOcUe7YmDm/dB9ckW/oQNsKe9IOfA=;
        b=oQK7+3c2h8X5NeD/diGLR3Sl6H06gE5+KYD6Z/s50DzZkE6H7G/U0FeIyQmu+4SlDt
         hwU9na6j3pYIoXYV8jwd3IOpvpe8KP2GyJWy0P3TLCT9ZAtx8o2njlH2uHhpPW6CQdUZ
         B0QiWyU2zIEkADwOarBcGVQ1e9MbUFhPwjIX8IitNXBkuITxOq6aR0sryydBzlsBG7I7
         6sbL4IHU7it1KQ+cTEynzp5uiclNW7WFXX0V0dfPifCAOyul23F4QRWqJr5fGtqKyAUk
         cfyJ33VUdP5ItPzOtbNvu8whGgRxJkZiQA5C8oAKkbbO3TriqbFpktj4jXz7OBD+D5Hj
         ex5Q==
X-Forwarded-Encrypted: i=1; AKwUvBzReE0GY6lC6oPzrLX/sAdW5/vqXCnYWAR5e9fkTdjgsgQcSaSGCz5fXsBI1d5GrzwUs5xsigWFzEE0@vger.kernel.org
X-Gm-Message-State: AFuF++l+g0w81E3bwOl4me3KncGHrhOboBkYEXjDYQoK/ybPDo3Ky7zq
	FOYWG+Uy2Hn/PPP5MHu99TMZsGJ7hnoagXrE3awc57nvqRk2greGLyFXS+ASgtribYo=
X-Gm-Gg: AYBFou1vjZ8h2HdQq0pzVf+pfQUTaHVEJstSYVQabJTwd7pLrhnmxBjXXdd9+DUWuuS
	VS/4s5fhNX2MiyoT+7AeeZPfnHOxABwUuxIjPd4fmQdly/EL1AoWV+MTSvmA9mlaD/JNmr/wkId
	ZF/8zE4gsKPTx07jv3631/VEwYddC75nKobfUtPNM2o3JUjcTgzcQ1sSP6yCU/vZB3nid/Q1wIU
	wKOkMesFFRx+BKIgrhnjIrlKxPn7B5pz3ex2G54X5TDauKELnVDgGiu/fJ//ugTDJXKn4Tbgw6C
	Q7APVXOy5LVIsOyELthFmhAXR7lW/oJ2mDhfUW0y1Zn6YWcJSq2+Scn6KPtOPzC/bdUbB3Mphea
	E6sldeNmrv9e+HVHqSDCCvgRRGxnngXZSD3C8Vd8aWtIZ5QebTSYdXvEcwc8tOwftdVCgN1Lxc7
	2D+hu+7eMYc1aj4IF+WJIAxtfbaJbqY1bSAvVbUD/8XO4FrtwsvZZw3N8k615WteOfaGumX9M4e
	bLYxeLVXtZAF53brUyW3iMZIqsS92ZCOx1RgdMg
X-Received: by 2002:a05:600c:354a:b0:49c:fc6e:8cb6 with SMTP id 5b1f17b1804b1-49cfc6e8f48mr375853355e9.26.1789029226295;
        Thu, 10 Sep 2026 01:33:46 -0700 (PDT)
Received: from ?IPV6:2001:a61:135f:1c01:4928:2da:9a39:bb64? ([2001:a61:135f:1c01:4928:2da:9a39:bb64])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858bcefd59sm43282065f8f.19.2026.09.10.01.33.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 01:33:45 -0700 (PDT)
Message-ID: <c0006a9c-7cc1-49a4-8226-2f4e5333a4e4@suse.com>
Date: Thu, 10 Sep 2026 10:33:45 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: dc395x: sync the waiting_timer before freeing the
 host
To: Fan Wu <fanwu01@zju.edu.cn>, Ali Akcaagac <aliakc@web.de>,
 Jamie Lenehan <lenehan@twibble.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260810055028.119525-1-fanwu01@zju.edu.cn>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20260810055028.119525-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.08.26 07:50, Fan Wu wrote:
> The waiting_timer callback re-arms itself and takes the host lock.
> adapter_uninit() currently stops it with timer_delete(), which does not
> wait for a callback already running on another CPU. The final
> scsi_host_put() that frees the host (and the host lock the callback
> dereferences) runs right after adapter_uninit(), so a concurrent or just
> re-armed callback can fire after the free, leaving a potential
> use-after-free window.
> 
> Replace timer_delete() with timer_shutdown_sync() and move it after
> free_irq(), outside the host-lock section. This waits for a running
> callback and prevents it from re-arming, while avoiding the self-deadlock
> that would result from syncing a callback blocked on the lock we still
> hold.

Thank you for the patch. It raises a question, though. Do you want
the timers to fire after the adapter has already ceased to function?

	Regards
		Oliver

