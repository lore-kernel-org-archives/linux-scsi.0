Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EBC32571D
	for <linux-scsi@vger.kernel.org>; Sun,  2 Aug 2026 16:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785688415; cv=none; b=h+3SQcEimI4ncamLBPLQOlAxKa5j/vkr30x/uRw+mMJt1Zwt0gt3OLEEIyaDt/QrAsdCEP06XxZ0taM9r54sDDGXEHZjvAzEePS566vN1tJxAwAcjUc7XqlEe00buz5HYKqD9zZWbzfevesDHNC/OtC2yWUatJfkxvGyx6ocMV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785688415; c=relaxed/simple;
	bh=sOQCVuogkfYMMhor3J8kpwx9F+0s6hCxTg6Uyirwx3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rcb3v62MjGjVS2XnLjhibZ9s2Nz+NUuMINk9IJ5cwqIfiqDztqSKijMja54g9mpoAGSIdObvXsYQf00llskAg5W0HgVcOpq+fcgr7af4PRn6Z6aDU3kXqwzOBXhSkG7GkuQkDx0BNM8tYn9Ek2MyoT1qxs3xivdGWi420X8YXYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GBumDN5U; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GBumDN5U"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c16794450aeso375132466b.2
        for <linux-scsi@vger.kernel.org>; Sun, 02 Aug 2026 09:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1785688411; x=1786293211; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cN2ORGcAcfJ/XP7y51QQH/B5hBo2NkObxPWrSzc3qy8=;
        b=GBumDN5UANg1KQJjRWGfjHNWiAobyuKbJj2NN1e69qJ27XMQoAl3BZIE/R5UOU7m7M
         l1wRPXTXytZcCGQ38EmDq1pEGAYKO3Ppm+fIcuL9EzUMh2DkZC+pZM5aTSgO0JEaqFAE
         KE1Sv+X3k4B4EIn1VifMpYDUIvXVM9z4PX9o0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785688411; x=1786293211;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cN2ORGcAcfJ/XP7y51QQH/B5hBo2NkObxPWrSzc3qy8=;
        b=OB6CtTlSM9JDla7IWQjnjNQyadf/YEiB/FQKYs82Y1LMT/WidiEysL3EsDGUqRcXgc
         L7fUNXqpD0p3JH0MKW7xGbNOHbiUV71OuAB5kMmWDHNgNWDHp+1tPEosUOUN0J2rOKRh
         BcEAHRyLnpoCmx1F4zMrRETFSSkr8wz5UknbGkm8MuN1U3gZ/yVCaXQ0Lm9NnLX7zOFW
         UjmQQpKTXx4ZsQlsC993S4YyK+RZGT097ZgWmhGAKF4k2/RrcLjy1NiKgxr/RZF2mRUE
         C9cH3iyTHdWDe7A1GHBtlWCZRi1XJSU3w6prf7sp0v0QQUfufqJjak0wbnnpT3FHbTq5
         4iYg==
X-Forwarded-Encrypted: i=1; AHgh+Rresg/aCjcx8VeiUGnQdpKzEGY/Jxmm3GVWlxGd36Sne5tfokMtOqR1UDM9PO4hr+0fWSdrtXLsmGli@vger.kernel.org
X-Gm-Message-State: AOJu0YzynmzSmqAiDONfkzVZSfCK2PicFPLf1rIXsPSY0gAUNEBT4url
	FC7UaIrb41VHkoQgXZvWpm4OO+LH8HFc/LDPaMzhIdYuNRPLWLUJ/gFyo57BbidbfJhrucS2m76
	lFykRQxE=
X-Gm-Gg: AR+sD12ln22JQCTua/dab0dd4vR1VuSsvnd+O2d5pWp+cWzNZXLkHOJyvSafC3sM8Yw
	Px52UdzbitRXoqL/5LMX/i1HIZw+BnC0SLP9o2Iwxjt3LTb1JtQyJFf8Ig6WdpeQ/B0fao/G4t+
	+F3MhxmrSDMvvhY+d1MZKeIgBDnzmHJl8pUqmtdqiAZo9Lx2nlagTAQZBjsjpZkAIZAeyrSSgHy
	i/w99Rbrtv4lEcfEXgCLFbDWHZdpsDg+WNx8vOiNDHzVijuAPgLOHw8CaTHRShJlVdSmwLXmAek
	aIfCEIQlvHUTON2JaC2Zp5CAmn1mjugX3qJlf/dnyH4n0jD5ozUMaDis1WTncrpYY5FadNeiF/E
	AV//dSRF0RlNJNQF4J53UIRSAQuobheoOS0P9zcvxUQldnQjCmpH/UYx3aFf5RpBximcK0TDSfF
	4PqQeQSBXWtVwt+wZNpZxq+ZPdAK/vRm8tVhW9PxjDEynlA5EiXkkqcr0Pjz2lx1770fJN/3LpU
	2XtYECI/KHu3aCKLu5pwgb1u4CY206oQa1Iyg==
X-Received: by 2002:a17:907:d13:b0:c1b:66a5:e8f0 with SMTP id a640c23a62f3a-c1fe7ecada2mr601241966b.4.1785688411228;
        Sun, 02 Aug 2026 09:33:31 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd3cc3ea1sm437615266b.26.2026.08.02.09.33.30
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2026 09:33:30 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso313516866b.1
        for <linux-scsi@vger.kernel.org>; Sun, 02 Aug 2026 09:33:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpEETyn/C2RGRSLftwvtMroT6y7F8W4QGsnnPgI7BD90O0XIqdduv357H1V2IYoBFkSi3W21/Fcz2eV@vger.kernel.org
X-Received: by 2002:a17:906:7947:b0:c15:fc5b:6884 with SMTP id
 a640c23a62f3a-c1fe7ecb323mr578797166b.13.1785688410245; Sun, 02 Aug 2026
 09:33:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <62fc8f5dd0e1e9ac6d512e84173d33e4676adc35.camel@HansenPartnership.com>
In-Reply-To: <62fc8f5dd0e1e9ac6d512e84173d33e4676adc35.camel@HansenPartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 2 Aug 2026 09:33:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj-HxDeuQ0LLf8qmzZ9zJTq2o6Q3LOtcNhqR_pS=LUFAg@mail.gmail.com>
X-Gm-Features: AUfX_mzEEa69w6aniqmTKrBfETlhTzDvVvJGrGx6kxLbHIj_btAY5VKP9dQAQKg
Message-ID: <CAHk-=wj-HxDeuQ0LLf8qmzZ9zJTq2o6Q3LOtcNhqR_pS=LUFAg@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 7.2-rc5+
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 2 Aug 2026 at 05:51, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Sorry for the last minute pull request.  This time I managed to spill
> soup in my laptop on a business trip and fried the motherboard, so I've
> only just got back home to a desktop.

That's the oddest version of "my dog ate my homework" I've ever heard.

             Linus
