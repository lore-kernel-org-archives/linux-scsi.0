Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EFE8824
	for <linux-scsi@vger.kernel.org>; Sat, 20 Jan 2024 19:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705779340; cv=none; b=BN/zojkdyfhkB/3hq+kPRmgqCDSnpbLc66IpwALq0qjY9JPNG4lgCIU7w9kmrsqJrq391OMERkaXVt4lwWcIrG0Ho+hWh1AaaeNMRaCTIYw+1/a7DLvCznx4gTs1XcQOsZpjZBCClwnoFltEQLZuTk68r/zN+++EEhzItdw5vK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705779340; c=relaxed/simple;
	bh=NLWKB3iyr61ar4WQVIOUCJqflDtAeQTUkI8JnXa1jLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SQuHnoQWCZGkqDDUk/ZvOyDHYBjy9KhV5MtmIBGIbqGIxuk9iEmueYr/EO1oUYNg8frS33rPJutj/izGcp2FDtGPhpK9Mz1B/omiMyg4Ikuo162rdOBumWLAfVSKN9e6eACpWvBebkHATTmTagXf0lcsdfHgxD+cHxFPdHGMEmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NSEnFWvh; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NSEnFWvh"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-55a685e6299so1655880a12.2
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jan 2024 11:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1705779336; x=1706384136; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M/rp5vrGtS2RGHM4ILDxh2i+YzejulCBn4t1151pwRs=;
        b=NSEnFWvhkbvZRo0au5bHIfCEao9hsDsYxC6VuNXN7fXHaKY2opOC4WizU1oI6ujfsP
         JGgz2OPNPbJfD8VLokhheQ9Y0x+BGvHZaWQanHIyNTnLGjnTbEWFGRwJwApYAFGqUCns
         Dn/7JQTePCZxBuMQNggxqp6UG7pKiu1R+hNLY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705779336; x=1706384136;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M/rp5vrGtS2RGHM4ILDxh2i+YzejulCBn4t1151pwRs=;
        b=R/czOsjXHBn7UVp4m82cEKJUl4cb/Qc7MnFKPzSVDgqENo9U7D8EOHFhOufJcN8g4P
         r+2/ZEVfFsPnBb1VTHpGmMbyn13kUcMvjp7RN+9YHafjV1yzYS+yf6Z8YlJ7Js9izxKV
         g8qwvsR5yXf/ias+CR5/FbBzisgqy8n+02QPARyrNR9QCadYUrMO3xBoEv8TJ4mT2Zz9
         F/viaCDsPtGl4RqQjuR3kAtXk9cOTzlEfw3Gvf5F3Oyy6Wb+IVZhgOFx5ak4polW4rBG
         A8jLwJkXSC2x41sNdj+iwuG3kAluz1c3hYWrN/VXe5AbAKAxxMvwq/p9iG5VFp0jXrms
         zTlg==
X-Gm-Message-State: AOJu0Yx/sZWlN3Uq0VWZwUEmw6fgxLyiqZt8jW/Xh62v/Bcg6fXZCJSq
	ICdDVIi+6BXK9Dk6UwlknWeUM9LwU2In6tvNqK7Bc6MwsdO9XhEPRI+mxH6/QmKQhNe5Ud4yChE
	pH2JvDw==
X-Google-Smtp-Source: AGHT+IEdRgOpETxFsPXw4awSzl5weMAE1aPaP5pJqRVoyBlIXPUMjg1AL2crmL0v8kFc1F1KDOVsQA==
X-Received: by 2002:aa7:c403:0:b0:559:aefc:9cee with SMTP id j3-20020aa7c403000000b00559aefc9ceemr872335edq.59.1705779336456;
        Sat, 20 Jan 2024 11:35:36 -0800 (PST)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id ds9-20020a0564021cc900b0055982b14794sm6601070edb.9.2024.01.20.11.35.35
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jan 2024 11:35:36 -0800 (PST)
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-40e8fec0968so24646695e9.1
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jan 2024 11:35:35 -0800 (PST)
X-Received: by 2002:a05:600c:3581:b0:40e:a3aa:a458 with SMTP id
 p1-20020a05600c358100b0040ea3aaa458mr716415wmq.27.1705779335473; Sat, 20 Jan
 2024 11:35:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d2ce7bc75cadd3d39858c02f7f6f0b4286e6319b.camel@HansenPartnership.com>
 <CAHk-=wi8-9BCn+KxwtwrZ0g=Xpjin_D3p8ZYoT+4n2hvNeCh+w@mail.gmail.com> <7b104abd42691c3e3720ca6667f5e52d75ab6a92.camel@HansenPartnership.com>
In-Reply-To: <7b104abd42691c3e3720ca6667f5e52d75ab6a92.camel@HansenPartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 20 Jan 2024 11:35:18 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi03SZ4Yn9FRRsxnMv1ED5Qw25Bk9-+ofZVMYEDarHtHQ@mail.gmail.com>
Message-ID: <CAHk-=wi03SZ4Yn9FRRsxnMv1ED5Qw25Bk9-+ofZVMYEDarHtHQ@mail.gmail.com>
Subject: Re: [GIT PULL] final round of SCSI updates for the 6.7+ merge window
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 20 Jan 2024 at 11:09, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> It also seems that this magic option combination works better (just
> tried it on an old laptop that had my expired keys)
>
> gpg --auto-key-locate clear,dane --locate-external-key james.bottomley@hansenpartnership.com

So now I have a new subkey.

However, I note that you really do not seem to have gotten the message:

  sub   nistp256 2018-01-23 [S] [expires: 2026-01-16]
        E76040DB76CA3D176708F9AAE742C94CEE98AC85

WTF? What happened to "stop doing these idiotic short expirations"?

What's the advantage of all this stupid and pointless pain? Why didn't
you extend it by AT LEAST five years?

Has the expiration date *EVER* had a single good reason for it?

From a quick git lookup, in the last year I have pulled from 160
people. Imagine if they all set two-year expiration dates. Do the
math: I'd see pointlessly expired keys probably on average once or
twice a week.

Guess why I don't? BECAUSE NOBODY ELSE DOES THAT POINTLESS EXPIRY DANCE.

Why do you insist on being the problem?

Stop it. Really. I'm tired of the pointless extra work. PGP keys are a
disaster, and you keep on making things worse than they need to be.

               Linus
