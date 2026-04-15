Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CD2349B02
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 04:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776226118; cv=none; b=hQuH4kGvSJCF4VFePYw0gHo/blpgVeknKAR76JsjyagWDyECQ68TmAQzMrYjdhEP2/ns0lpI9bXx01/7YnTZv4QJ7XUiK0G8/LAibIQ0YOsiaaXu6PUYduRRJ3p4XXfyVsAks+IVST1j+hV+UwvFP1J+ygFm8WnBqt3R8p3ts/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776226118; c=relaxed/simple;
	bh=1JFYliA1eIfO38BDolH5vZE2GQiymOSm1FE48m3IXyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UqyH0EHwIzsllZ5ByU7JwJfqY8bE1IMMiOW+lO4AlaaKqv2qUUqVYhPAo9NTsCWLql90uDjZTJYxgNTiOEZpAfrRBZbAS5TSfVVbDOxZSrusl8OYa69Dd/03WAaUGVbKMIN5dWnXX+RIsNkppfBz8UTw5K5Jr178I8B0o1ETcY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vt.edu; spf=pass smtp.mailfrom=vt.edu; dkim=pass (2048-bit key) header.d=vt-edu.20251104.gappssmtp.com header.i=@vt-edu.20251104.gappssmtp.com header.b=LBrnccc6; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vt.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vt.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vt-edu.20251104.gappssmtp.com header.i=@vt-edu.20251104.gappssmtp.com header.b="LBrnccc6"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-12c565dd3a7so2843707c88.1
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 21:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20251104.gappssmtp.com; s=20251104; t=1776226115; x=1776830915; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ScBve9F1pkkVpbC3fWLbe3v5cogqHa2vYvsAA5m89zY=;
        b=LBrnccc695EiH/c8KELWCNqj/5ozgnsXEXDBs1DFPknl/SdL14fxcj+K58fGDnQupa
         suMNOKr6H96qnKo8d8FhyZH7XzhwnNsNeNqk+CUhGNjZ7+6paUXucCbFm52YXZNES/f7
         +ikvzIi3cjdwDDYUv3DYsvX6SJQE5Ye+41c/Fovm5Bz/6RyE7re96rpWovlhqJnMGZvR
         ggZx8bo5bTuifVYD+5a5h1BOFpIXecD+O2SuqdUEiYXgNIvHZUxZFzi0C7orhaCmEyoW
         FnEjifcd26sc+2CxYqh/OQriHDiRxW6Kz0/CJYJyncDcCIodVgzY+Q1TxNUCdqzEIpRs
         gEEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776226115; x=1776830915;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ScBve9F1pkkVpbC3fWLbe3v5cogqHa2vYvsAA5m89zY=;
        b=k19fl9Hazy9gvWaDYU8h9rjlMbPKTI01ywJtIqnyW/nkTOeAlZnEkBu6PINUa8GZzm
         O7tetZAT/z6UNtpFxb0+E51PGYOaVibAUKGysgtaI98s6QBzYvEGPsw475Z4S4JXUxrJ
         9l+441ziPWG8stb06kiR+4rYla1iV+6oNylG/gIl6MqWgwx8k/BAnEHh/AnxiB8zAiyz
         uW7/o+vJrn+J4ffpIPxyfjULzVcRreeQ+Bl/zbHHMOqN57TbinDcpJkaNzYWHr2pH5YL
         IQIzHQ9u/8e1HFm6BPkmgSLnkzSKhvGVL+3+mugisZ2oV2erDOy7iaOaM863NEtRTwtR
         zLIw==
X-Forwarded-Encrypted: i=1; AFNElJ+wp1RUpBvygkBDTHCbeuscwg1eKhANlbtAgvIp2j//6pL2zsHYUrzqi5yGT1G7QvwDySabjPW6ikgz@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1FdnlcYyaaAOuFE64H5hsUUj2SwZh2XockSgz4BenwoHzS6r+
	gzUqMIe7meKdEgcUqTGAIwTxY5wR0jabhUeHOQIWBTqo8YvRe2XXz5+7vnbbx55cGcg=
X-Gm-Gg: AeBDiesqkv+ioIkyNqZ5YDOEIguKZxCf+DZrpqmhSwgrB99Y3qL4UATYdz6zZbLlP1J
	FSKnGV+IT9I89q/m3HL+BtCek3xVqU7wFT1eJR8deXvRaBGVYPfEkIHbIhNVKp0Z+K+zxvozLOI
	negJvZxEXt7zSz2iWyfXtm2rpZYTcoOuHx4B0dGYAUgHUPAfQ7m1LHeQRFDoYQeqQlAbEG0gak7
	nOOCyzuxi5c8LQ9EUpH82qXGWsZnXKmPASUTjQWZSbe8BlWMCv/R7e79H+A4WTCvlU8snhDEbKK
	0cOaerUieR6PFDmqBOdUBkm+PrV+aAXXyxRylPJ8s/KBwfeqc5vBHio4ey7aCA8hJoFM/8a0XCV
	6v483yknY40KW2a76OMyiO4mzlUca3HFnXmaF5y6p4ccYum9wRoVyGbdZQ3Yre0MAiVa+HfvDpz
	5AlLxW5Rt4EiOcd2ZYRhr03IgDwZL3XMGD6ePV2Zm5WVLZHD+b1k9u+FdSgPGvh3BjZqp5YShIy
	n30GIlfi2yIdcaNnVHB7WnbOLVhMzICWt7KXIn1
X-Received: by 2002:a05:7022:48f:b0:127:5cda:fb7d with SMTP id a92af1059eb24-12c34e4524fmr10782658c88.6.1776226114823;
        Tue, 14 Apr 2026 21:08:34 -0700 (PDT)
Received: from [192.168.86.23] ([136.25.189.61])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c5e5827aasm637402c88.0.2026.04.14.21.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 21:08:34 -0700 (PDT)
Message-ID: <258ab32c-4704-48a8-aec4-739c497a80d3@vt.edu>
Date: Tue, 14 Apr 2026 21:08:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: target: iscsi: reject invalid size Extended CDB
 AHS
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
Cc: Dmitry Bogdanov <d.bogdanov@yadro.com>, carlos.bilbao@kernel.org,
 kees@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260404014429.115807-1-carlos.bilbao@kernel.org>
 <20260409024253.34926-1-carlos.bilbao@kernel.org>
 <20260409093159.GA902@yadro.com>
 <0657bd66-43df-43b0-97d0-16288595e229@gmail.com>
 <yq1cy02tgum.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Carlos Bilbao <bilbao@vt.edu>
In-Reply-To: <yq1cy02tgum.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 19:36, Martin K. Petersen wrote:

> Carlos,
>
>>>> +               u16 cdb_length = ahslength - 1 + ISCSI_CDB_SIZE;
>>> AFAIK, a variable declarationis allowed to be in the beginning of code block only.
>> You're absolutely right, happy to send v3 if the maintainer prefers.
> Yes, please. Best to stay consistent with the existing coding style in a
> given file.


Sure, v3 sent!

>

Thanks,

Carlos

