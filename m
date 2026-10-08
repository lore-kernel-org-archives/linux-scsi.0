Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6753C1D64
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 11:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791457257; cv=none; b=rQZNA0NVLwE/d8v5b9zvlchFfj3g4yjU/Atgk9iUXrgnZS67bM0X8W2jDPPoReKkT7llec7xghME3z4TXzlaMUcyGEjaLPcwHCOh3gevivaZVugbmj82+b6KOKPQW7tpxOOwNLn/XqOLxRp7FykgBWrDYcjVo7HfE596oBl0Zkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791457257; c=relaxed/simple;
	bh=Hv2/f9SdQ7Xo1WLsf5CXwfkJ7Dywol0sBld6LjtCz08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y7dPW1afQFq2uexVm+rjb29ajKl+7KMaf3IrBLJU6aPXheDfZkYKntRKp6Oh8N6bypaUdYFYg2cfg4Vw3mTCGiOjQo2ZjvaawT9pGygpHhorfFw4F54L8TfssP6XFPF4MUMar4CoQiQGPHn4/brprZHiS+DjAAn+niFlQmSQmbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SqyRFPiM; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SqyRFPiM"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a021c809e3so28960885e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 04:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791457254; x=1792062054; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=np5hFTibkx5z0+8RGGFNmawfN6ZXgeIigzCb4JmakuQ=;
        b=SqyRFPiMQFyoM7QgyoLSJ3PnzUj5kTwtig8YJeWiqwErn1EhO0d3kNXxdAB/xtRb4d
         hDPZqVHvXwjxTVuiIUO6K6riWZwBBp1XDdwSxnYx81dYOqtivCr8g6DJxeTvWfhZdh27
         zf3E22/n0YqIFkzAngXVG4g5AFh4QETHvh4NBEKRgK8Jo7C3gNOUeRRz+6fEoScB/KLu
         H/WlvHC7LWRZhNlVskvaOJ07huYHtUV9tVekb9MMMllT/KLRnX8qDV4d30debBxp0u/d
         9bXmEFjAm7BXumKJSswApqZwUz1HrFHtv565LDa1cGTH6AXXViZ40t1Q0xd2JH0RQH7Q
         mgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791457254; x=1792062054;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=np5hFTibkx5z0+8RGGFNmawfN6ZXgeIigzCb4JmakuQ=;
        b=JnnMfvp4BX1OYSmQ4YtXyQNnwQmZWvJgvL8hAigbF6WsfeWMcmWGJMjrBAmVKGJa53
         hs98pyYZdm16uKhv0B9gYAwLowBWZcYxA9qTiaHIDhWvZcZtf8cCLkGo2xCH+eOPPSCO
         8ro2CUQ+rY+g4J39GgqDlIwCAFCQwgQ+qQSbi1hxYXelYd4mJdJhhzWWwrMf+Z9EwqSc
         S4kqphFyovDVgbRquARmEcb6+dNc8LGXiMYTixld3izKu3GERQ6dIp6bJOHDgXifnzkk
         635xiD6Tia1fKJl7yBiPUhhuaBXOiPHu4TqXo/JnHXDxtMmDjxnqkC8/vWTA/DmXGEO7
         s31g==
X-Gm-Message-State: AFuF++kfRG3g1tfsfaYZZB8ocWOPhbYC2jtMPpWu7er+iF4D4Ftp8c11
	RVKgDhRHeSWplkANX3vSOujzOokdxNAlPrXkk0beK1/lO0PMYrclM+Rdpoat25RnA8w=
X-Gm-Gg: AYBFou2nEDBat/C0RRQQXxRlsZwhwVrKkirWkXENuEu5U4t+DNsGa5WVnqVhvY4ihr/
	41E88pZ/FXKjI0zi0ZOpHLvEycrEW8xygxKgw2DkFNbI8+hHdfTN2dUPFblt4f9FfyOsaX+B9Qk
	KJoq+xxSUzKY8o4ZG5jutd3HfVSN//OoB0NSq9fhGTXGZpRynshlILND8a/GN81CbEbv1j+7N0Q
	jLcFk5jbkIHvpuOKPFb2g9U0Qe090JFP990f8D0TUBP+Ncv5MiBmTymcX26sjoGEzZ9fHAEGaGw
	/bGjx683H8XpbrU6KgvBWGuZsdBR2vlIOje1wTiGQTZq6CW2rIW14Mzs33czixqSnjvycaOjF4s
	atn2oPO4M3EAmJV1G18fXBMWCvzg4P/NS1+CPYBZizwqf6rp5jOIaCosc3DAS0KhZIIa1gxDlEl
	PAtY3+Pn5XnYGCnfhNZncbmvaHlTqOFWAND+O8p+K5dgj1Fa9GgE/Q/2kgqoHU5LEx/4gkWRryS
	ucAZEXXfRQ4AZ3ufD8CsCk/7+B8A9U3NEXjpsSCzg==
X-Received: by 2002:a05:600c:4e87:b0:49f:bd3c:bc18 with SMTP id 5b1f17b1804b1-4a18045565cmr89191725e9.19.1791457254152;
        Thu, 08 Oct 2026 04:00:54 -0700 (PDT)
Received: from ?IPV6:2001:a61:13be:f901:8903:c5f1:e7c8:72f0? ([2001:a61:13be:f901:8903:c5f1:e7c8:72f0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843cb256sm56466535e9.5.2026.10.08.04.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 04:00:53 -0700 (PDT)
Message-ID: <f82a72b7-6122-4bbc-adf4-2d08706344a2@suse.com>
Date: Thu, 8 Oct 2026 13:00:53 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] usb: uas: implement .change_queue_depth to allow per-device
 queue depth override
To: Luca Cecchi <luca.cecchi.info@gmail.com>, linux-usb@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, oneukum@suse.com
References: <CAKVTVpi5WaOcmg0Tx8+wG01ReD0kmZJv-ZEQF_XusqF-PH3F9Q@mail.gmail.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <CAKVTVpi5WaOcmg0Tx8+wG01ReD0kmZJv-ZEQF_XusqF-PH3F9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Luca,

On 04.10.26 13:41, Luca Cecchi wrote:

> QUESTION
> 
> Does this seem like a reasonable way to expose this, or would you rather

Your patch is very good. Can you please resend it?
It is a bit corrupted by the mailer.

> see it handled differently (e.g. through the quirks table with a numeric
> value instead of a boolean, if that fits the existing infrastructure
> better)? Happy to adjust the implementation, rerun tests, or send more

I would prefer both approaches. The reason I think that a udev
rule is insufficient is that it inevitably leaves the window
for a lockup to happen before udev can act.

Could you also implement a quirk that limits queue depth to, let's say
three quarters of the maximum?

	Regards
		Oliver


