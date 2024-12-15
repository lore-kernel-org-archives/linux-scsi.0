Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044C281E
	for <linux-scsi@vger.kernel.org>; Sun, 15 Dec 2024 00:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734220990; cv=none; b=mTN+BzfEud7o9XhiM7dwvG5I5+keJnqTRSP6FWMmnwb5aT90la5JebSJ3nSi+9PRe6kf4qiKVnuMzSgG6TVXzVTMq2pFy5zuj167+jR7lsBflQJhTdnr7WCxvNsM7DG8tkiCnxqK3oDTSpwr+wv2zk4EP16TzBkEQ9AzP6GTRtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734220990; c=relaxed/simple;
	bh=xQFkpgBPg4Q78xCiadfJSR1zWL7V/gBsQiInFrVHHm0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OyJBlVDEk8CD6KTWtWfrAXCcSCBHDqEKUYF6NmQa/1Vq9LMawTJG4Au7PnXkso2c7toyNMVuR4d1fjxIzi2m4607UujTsw9FvPTPN55ByMmvzOljYx0i2h90SNS2YK02nkSbyXKIVLm1OBBFMdZRzrebaIzNVOfekdBgCfI+4KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GJYR2PW/; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GJYR2PW/"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d3bdccba49so5227678a12.1
        for <linux-scsi@vger.kernel.org>; Sat, 14 Dec 2024 16:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1734220986; x=1734825786; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T3usN9VYGUEh24gR+LciJgIyFJjC0v6UAg/jDOmx3oE=;
        b=GJYR2PW/J2E9gcF7loKLRmwX8qNvIdQ9IBY0mcQ+w5gpcFCu5jwPoKVIycf4IkmIzO
         m/7112sqXk8cYeEO2HY/RIMSGIM5MHPJjrBPVdgNjhg2iZwzJRUT3TeHvprnS+ve6Qkd
         k77LCdH9OCnm0pL4fSGbKAvdelvogQs+MtntQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734220986; x=1734825786;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T3usN9VYGUEh24gR+LciJgIyFJjC0v6UAg/jDOmx3oE=;
        b=Md0tDep+nRY4nt5anGsMx+4IsT1npsC8eKjMX3jMzPaEP6f/1yU37hpB3Vv5bp1iAE
         d8PB34WAHNyG7RnXnjo3/CNYcY1SXAGgGB9HV5EJpcT/VDHBhYOz1hpn9qCyC+4ESHBY
         UMOOuU2rnZpjIwzXoVMfCjXHgqDsAX2omdaeccOrwFwW2ORxx3FXdQP+M4ELlzUTwe1t
         1gluCdidURYF5nnEjE7uTaSqSErGh8xlzpVxX7CA1Jo5qppUHGq2SjCKrvt6+y5oydUC
         pLQAjioadnGrbXG6iH9+pgvmnK42JSm6UWPB5F+KKnNM/GOe5KYcOeu9YPzxooWR+k2x
         dbEQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5r7i+22jEeuNdftAavtQoDJTqHDW45DlrIu5Ff+rY3ejmvjtB4vPQeceLlU6/RbsZIpsV/WETBtGm@vger.kernel.org
X-Gm-Message-State: AOJu0YyzNA7VzUwrl7FfcVJev0RGG83HqX3iu1FieUrs4sQ1S7ta74r5
	4RoXdEsfBHIM39/UrCYy9hw4zfvyjwAiv3HbbHMf3IKRy0MvAKpdYfBzgsDXp4GLFh1IFA3k+AQ
	VcQ4=
X-Gm-Gg: ASbGncsN5y0uNvmDs6PRMXqIGXXPSJslvam7ZepPzUohauo/A+IxnXa3p8lqlj+EOtv
	F8EpUUX6dPy4MBedo8B20oAmqVlvoocoaJ383s3gzhtLUV066F5pr0w5Cml0a8vgq/aPBe2zkLN
	UGXKBP3b/tlbGGdFAaVuSKQcuggyml5buL0xj1JbIYy7ulMOdAtIfy3plkjlaIt/alwC1rnPTlF
	Ojc/i8twF0FrMAyWv7yP8CLMkEt3DxT13IkbOaZUjkmiah9QCNsebkIOSw3pQik7jT4FVKyKKLj
	mSrA5l1lA/V27v7gfnl11XTjONkXRrg=
X-Google-Smtp-Source: AGHT+IGA0MgR+xwVcQhrby9aKoQ8xNlYUZ3BzRKQHqAiBrnfkqCSyshcL1X1iDNUaxmPwD+gnnVO5A==
X-Received: by 2002:a05:6402:254e:b0:5d1:2290:c623 with SMTP id 4fb4d7f45d1cf-5d63c2e8742mr7379890a12.7.1734220986116;
        Sat, 14 Dec 2024 16:03:06 -0800 (PST)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d652f270bfsm1502661a12.61.2024.12.14.16.03.03
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2024 16:03:04 -0800 (PST)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aab925654d9so249183066b.2
        for <linux-scsi@vger.kernel.org>; Sat, 14 Dec 2024 16:03:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUL8NZiMGBzjXlQkqtORuEHSjarVhjbRd6D6qYOtleOyskr9cjzjdaukJCa1kHTUf4LaS5Zsru0ckgG@vger.kernel.org
X-Received: by 2002:a17:906:c146:b0:aa6:82e3:2103 with SMTP id
 a640c23a62f3a-aab779b7e12mr856494866b.32.1734220983343; Sat, 14 Dec 2024
 16:03:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <395d805645f141b15ef818dadf39c8689986e8b4.camel@HansenPartnership.com>
In-Reply-To: <395d805645f141b15ef818dadf39c8689986e8b4.camel@HansenPartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Dec 2024 16:02:47 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjUTLUdiyc=+Mw3qTiQRu5xhtkBYd9r+o_hJTKgoW9XKQ@mail.gmail.com>
Message-ID: <CAHk-=wjUTLUdiyc=+Mw3qTiQRu5xhtkBYd9r+o_hJTKgoW9XKQ@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 6.13-rc2
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 14 Dec 2024 at 15:08, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
>       scsi: ufs: core: Update compl_time_stamp_local_clock after completing a cqe

Why does that ufs driver have that pointless "local_clock" version,
when it also does a real ktime?

It's documented to be just for debugging.

Then the "ktime" version is documented to be for statistics.

What makes this all make sense? Two different clocks, for two
different non-essential uses? And that duplication literally causes
bugs because clearly people get confused.

This particular bug has been around for almost two years, so equally
clearly these timestamps really *really* aren't that important.

Can we just agree that it's silly *and* confusing to maintain two
different completely unimportant timestamps in parallel, and just get
rid of at least one of them?

            Linus
