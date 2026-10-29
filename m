Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793270621;
	b=dpFgKeNZGkvfnTDVUaxeSazCY4rIQ/2b01cT0l/OXjr3BR+hICfuUSawOseKUEHBF0V0
	 g29d2esTv26xCIYLoLEPm6T43vBlFmSADpyhu9d6EKJzPxai0YGvQCLdOpfNiGRV+Vf49
	 e72QpM+rp52dGyFKGWxCkZ2XBHcFIwjYxX/eJwNovd0DaQcGvPytqHRGETyk6fP14OjM+
	 7PQvoUKu75Aky5BVBmEOUzSK+6ORVSA3oMzO7MfHbtb3yWYMm8J5YmhJldI0OQTJVLQRt
	 g6wCDarouoK3KUmCfNP3H90S7OINGlyFiHmncI2MxaupMn4apBDjONk61Db6TBUQ9ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793270621;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=6XOKkfJsefWjpOEYol68Fomb3WNK9nIfoprYMh5LhYo=;
	b=qK0tCW3DrOSOrAIwbWsnrXw5CAQPdmqpJ1op6DPPseT3fe83gil5eorifKvBLtAbBA3P
	 PQiqh9OFhlLpig0F0h0iYLDqtXhH+/ZWI3vyxLryVFfxCf0Gj7YtywinwQ+HG8G4AlUuJ
	 BRNfrkE27xR42BVJjf+m0V7sxAPbPcMiPVktio52HH3iUu1PSs7rQwEE5kNxHHo/51DFV
	 MBxMHeyu6Nk1SL31UHMNZTsDDrRi6iMk7FNvVkTcVOwt09fgLQplEFbWgc7kp4yTIRHvi
	 xy7oMRZy40lJql9ABQZkJzWOBcyZXbWMr6a0C5gvz80rKoG3OG4gBjplAv61a3uWK1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L10ktrJK;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987E9606A31F
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 10:43:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 987E9606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L10ktrJK
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a2084d62cdso16955995e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 03:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793270619; x=1793875419; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6XOKkfJsefWjpOEYol68Fomb3WNK9nIfoprYMh5LhYo=;
        b=L10ktrJKN6okWgDge9N56XwZKPL8WktAO6uHm2Zk/4dFNgy1RlGz0BVhY52Xst5U9V
         EdqBZiljHAwu2Dh/bcfZmpppX9dE2UIE/2/Ul73rHShJ3uM7B/g6jgCByyv1SNBs7cHE
         Oz31XCk3LctSXwGXUIf+k2I04vJmTDdR4Qf8YRVS4wlnw0UnRiP2IaA4llb41qNy/YTq
         kDHpWKwB29pV8DFndNNN3V/UrutXwUwgbFM2r1cNSgwwpAW5nUReonMXawoNs0fO+EVw
         580HcoCstQbN/XHS3Fun17diEkCODOdjRJKn2VhsNUl2Ad5IBgBKGPJZLASyIDhnfAbq
         QnJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793270619; x=1793875419;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6XOKkfJsefWjpOEYol68Fomb3WNK9nIfoprYMh5LhYo=;
        b=NFKLkbZK+XJwUUeO6GywkROAOzP8pbKkXH8d0y9NCOfOAg8z784ADyCQKJoIXBn50g
         kburyBD0rdcql3aLzZoM5doSF5yX+o5QeQt4Vj922O5veAEopZJGK7S9Y3a5KSjHxyby
         0bfeoOu8hRXw72Iq63Tdi5/VrQm3PImXctbZddnxi50dhAA1+ZDWI6uCR+KvbDfqt0HN
         qHoxCfmDAfLZsyDyft5et0e71N8rpXTPMOKDf5sknO3y6s1UoqdJwHVfmh5RM91HfJDq
         KfzTWMEuC5igTJ6i/N08Ic0YuKoluwIryCBlmiFtOyncctfNDeSRqw2fffCs2Q+lQx3Y
         pvIA==
X-Forwarded-Encrypted: i=1; AKwUvBzEei51XTZL0Zcr3/2261NrCgZELGEqr+YYYmdyogmy4amiehPv/LviCXMqF3BLRp+a+SYOp5u0G1Nz@vger.kernel.org
X-Gm-Message-State: AFq9FYLeRPOO9X0pPbdqadPU2Tv5Kjs1BpzkNjpoDcnmmd3pRBmx5QaZ
	ehGRX8FoHWWXV/KOgCNQLxAhHzmkDqtOdPQE98k2SUfpo5l6Dg7LUH5S
X-Gm-Gg: AYBFou1QB8SET2iuWmOLRzcVPXJ6LB0i6lB3tnRcoNl9qiDZm7FQBslPj+PbQAvyjGf
	e6vwMUemcRan9jIDEaFB+4iVhTRezcZ8q7dM1ytUp5ZorhqewOt4crp+ELm9yaBjRIY7VCH38+D
	cWTumUA91kxX07Z9sn69IkDPpGjXGQ8wMv4PmR12Jf6PrPY5uVCZ/EdMBv696J2q5cD6heDOt6l
	Se421Ut6n/w5lIkHBtNf8QzwgMg/0K8sEOM0zrheB3GiGBxYSmtxQyK1vPbKC/ITfrJPyjPsAZz
	OC5LrkY2QxSmP54v9BeZC17C6ZL9m6Rp75ipTcPkcWFEgJG3QeZCtnB9IMxpYHYNAG1TuTkpctn
	s8oRkIyvVDBePF4/4ZifMa/QD0CJpp6MgygO8T5jFOcfVMhRBOE+tyvdyQ0RtsbHnlZGN0q0leu
	0L5lRUNqFmf7jCSzffCe1TaczHUCpZxghbzFgEE6aYSJbg6YZcoTCwXgaaCKDlP/nAZBVtczb9B
	8cUXSemw1DQQSiwLXZFcxfkzRhXw2J2l/4anyOqlIsR1Q/0C0XNCtbHDcQkloikjIEXXEbKnEQC
	jC8cflWoKPilFSv9Kr2GyGX9sLuYwxa7Uih9e8AkhxeZMQOSyLI8W8MoY5MHa9lnYiLPX+/b106
	tlT+OiinH/JyobNHDOGLg07k8p3KGOdPw2aCEhlScIU0jrk9rbGNnRn2UkkSGqLqwdpq+uwpR2J
	Q6kg==
X-Received: by 2002:a05:600c:34cc:b0:4a1:fa33:441a with SMTP id 5b1f17b1804b1-4a963ffc267mr124682955e9.2.1793270618838;
        Thu, 29 Oct 2026 03:43:38 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a94f629d5fsm47165475e9.3.2026.10.29.03.43.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 03:43:38 -0700 (PDT)
Message-ID: <e6b98a2e-a9da-406e-8969-3eb73b6d71b5@gmail.com>
Date: Thu, 29 Oct 2026 10:43:39 +0000
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
Subject: Re: [PATCH v2 2/5] io_uring/uring_cmd: add import flags to
 io_uring_cmd_import_fixed()
To: Anuj Gupta <anuj1072538@gmail.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
 mkp@kernel.org, bernd@bsbernd.com, joannelkoong@gmail.com, miklos@szeredi.hu
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 fuse-devel@lists.linux.dev, joshi.k@samsung.com, anuj20.g@samsung.com
References: <20261022144501.2478417-1-anuj1072538@gmail.com>
 <20261022144501.2478417-3-anuj1072538@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20261022144501.2478417-3-anuj1072538@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/26 15:44, Anuj Gupta wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> Add an import flags argument to io_uring_cmd_import_fixed(), so callers
> can opt in to buffer types they support. No flags are defined yet, and
> all callers pass 0.
> 
> No functional change.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov

