Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7AC3E173B
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 08:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782979710; cv=none; b=ZWM5nfoE3u9XngUHIcnBi8AdOyXcqoI8BqQf+d0BDRSNtzMT8ctigZImKV8Ic6RI+6cf0/8CvnitTSZ4tzM9c1dhJ1ltTAgq7her+/hYFtDnLY9CnAIy2oi75E2SEc+LpMQ4IeFntn9KmBsGSgy1ZPcXOVvCZclJfbnKXqE52Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782979710; c=relaxed/simple;
	bh=pwiVFkeQnCttoDbb09pbQ4jq5kWqQHsBcVoqyTATkis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IhdrEPzw+kgdbuCqi+b/PPe9g6oixNSXMqJZr31FevQnKEP6MszXeYNWd5q6cJWcbMZqqTYF2LSIG43Ut9NYGuXMAFtoCg6bQUcEO72zTB/6QqT46FO7RGRdV6KKTogd+whrkQ73+xTsWV38bXR7xZjPrRSD3IwJbqbQKAeWBz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Z8WQ+9eH; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Z8WQ+9eH"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4758bd3731bso216256f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jul 2026 01:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782979708; x=1783584508; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uS/X0/8CmnUDQ6B8grMHPvwwaVFQGYkdZZB6z5qqXrM=;
        b=Z8WQ+9eHsEjGqg7ZuJUrrBdhJ3MUFucdAa5iPH49ir7LBULtNgMdcozF8mwwGQE/jy
         yU3vERqjlmrsql6GyUGGD38dBzgHnbcTaMRFvumui+EU+SnuJAID/Oeezqtce+umtuLn
         DzrS5z+vjqmTVkizKtVoWE47qDYYV06AZ5xH9Z/h7j/qkkReFFHFeIyNMG7+H6JY4iXP
         szzBoeCTSej7sKXmIZ9dNVpHu+vp6pcp25vZ2lJ8CY20H3COCdYdnfwW2nruMQSvURT0
         OqBFQlnNMvpRzyJwbpPZoQ8w87vtg1VjUWJ3S1vh3UFHAtepmDuIZzirVyzWBcUp45nt
         T5lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782979708; x=1783584508;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uS/X0/8CmnUDQ6B8grMHPvwwaVFQGYkdZZB6z5qqXrM=;
        b=ZeXQDMLfyoD/vVQqadUPWORxoO3S9IL86HDgX7KcCFFq9Qi9rGJgCpbpXzPjxzQaXM
         IGweKXqyElNJKrIBh1zRvj6YidvmF5jLnsxHapbBBUu64toVjeEeMViaX7Pk0EjrYgW4
         +8kfrD0pGegh0ush96/o50hRW0iegRlH1nkiLBUCon+2idpOA+ci5fRdlvU3nZ0knIC6
         L8SDnwOTtbfzfJn63AwCY4bUkKUEeIqjWCy+euSKSxLgp8BXruvIayhtW2Vfdi4I2/g/
         zIG8ry0vLTO16CQSOmaBZYEj3IfhYKtHVwveTnGx95He5wsWTN0jjFZwrDaDxDi5sk7C
         AUXA==
X-Forwarded-Encrypted: i=1; AHgh+Rqt5o8oWqhd8viCm6jzsXH+WyPVr/CPNC3jlzuEaJ5ea6h+GLaT6Ob7M/qr6g0nWq/QktrGSqa/M7v5@vger.kernel.org
X-Gm-Message-State: AOJu0YwxYM+RhV/lor6TeP6XGmwqh1bhslzIsvKJMUI2ptmcMOsnbjIZ
	eJGpx6f1XH+lInWCXgRG8AoIT44H4JaZTz6ohSvABJavsDpTGmS9v4SYN7F8Ju58jEY=
X-Gm-Gg: AfdE7cmUjRKVI196vokkEZqIptTmdukR8bjCXelMLyGXcxZ3zldZ3Tumq4TU/aG7Oeg
	Hi571S6arHGYq0CeNN4AWPrpGQ4pNA1A43dvolV2aMa+pWVpOxkOrM+N2VV4gzB5XvrYmBq3xca
	RbA0/7kb180HQV6mlmi7ckgqWMcoi/yuS78SnyowBaUgvR83DsD4nS7wR0qe40QPVJeGBHUKv+W
	oaLu5hhTcOhGzaUdjsvvHF5CV/stJxAw47o1GlY+AYB0F4xPphdecBVFpMAWs0XgMQXwvgMfgMk
	IqaTtk7SOITuSpBWmjNnFwZgPSl0jNYE5Vr3sI5BzXGt5+SZWPp46AMUBUZnNFehV3dh9kjO42M
	dueNAOw5YzM/ADkV2iwANWVAIULH/JT3UpjQdf0kBGLbgKk6TCM3y1UyveLx6BuZSlNP/jbvvLS
	yhXjvwTHl7d68+mUJ9n1RnItllTfBjq0OXnD5N0+/oQ2pP5lKPoLJUUCfC
X-Received: by 2002:a05:6000:2203:b0:473:536b:5d1a with SMTP id ffacd0b85a97d-47743d71b1bmr6959077f8f.7.1782979707557;
        Thu, 02 Jul 2026 01:08:27 -0700 (PDT)
Received: from ?IPV6:2001:a61:1344:a301:8020:436f:b412:795e? ([2001:a61:1344:a301:8020:436f:b412:795e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-477db8a4b73sm6769213f8f.15.2026.07.02.01.08.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 01:08:27 -0700 (PDT)
Message-ID: <ea2e824c-dded-423e-a242-56b9860d3430@suse.com>
Date: Thu, 2 Jul 2026 10:08:26 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [usb-storage] [RFC PATCH] usb: storage: uas: limit consecutive
 device resets in error handling
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>
References: <20260701040335.810297-1-senozhatsky@chromium.org>
 <e2599d9b-5dd9-47db-8339-f1aa825a11d6@suse.com> <akXJuqvHLUpcjXIv@google.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <akXJuqvHLUpcjXIv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 02.07.26 04:25, Sergey Senozhatsky wrote:

> <4>[ 750.651133] rq: tag=0 hctx=0 op=WRITE sector=13860872 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
> <4>[ 750.651205] rq: tag=1 hctx=0 op=WRITE sector=13865992 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
> <4>[ 750.651263] rq: tag=2 hctx=0 op=WRITE sector=13863944 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
> <4>[ 750.651320] rq: tag=3 hctx=0 op=WRITE sector=13862920 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
> <4>[ 750.651379] rq: tag=4 hctx=0 op=WRITE sector=13861896 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
> <4>[ 750.651437] rq: tag=5 hctx=0 op=WRITE sector=13864968 len=524288 age=76536 ms pid=11900 comm=image_burner state=D

[..]
> <4>[ 812.091136] rq: tag=0 hctx=0 op=WRITE sector=13863944 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
> <4>[ 812.091194] rq: tag=1 hctx=0 op=WRITE sector=13862920 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
> <4>[ 812.091242] rq: tag=2 hctx=0 op=WRITE sector=13861896 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
> <4>[ 812.091289] rq: tag=3 hctx=0 op=WRITE sector=13860872 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
> <4>[ 812.091335] rq: tag=4 hctx=0 op=WRITE sector=13865992 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
> <4>[ 812.091381] rq: tag=5 hctx=0 op=WRITE sector=13864968 len=524288 age=137976 ms pid=11900 comm=image_burner state=D

This looks to me like the block layer keeps writing to the same sectors.
In other words the issue I see is with the block layer. Do you know what
triggers the error handler at the very first timeß

	Regards
		Oliver

