Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCBB3BED02
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 15:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776785227; cv=none; b=oxYIRE4N3d4gW9cXdVuMxwQgXecH7LdNHk/+itXR+oIPq/7kiVArm8ryaMpx1SReDgi6wnXb7CD1NhoU38VMgeLlGx86cOmy8C+9T+ZIjlYLeW5ffsvKKFgXCGfOClv/ikDgift9lu98vIe+MvDRrAqQDlseYuZFXoIqsvaWP3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776785227; c=relaxed/simple;
	bh=HMQenH1XkBU7W8b8BUsn8zSyD2GXaNftksjdRhjw2Ng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O3wubr5bAlvUjU+Shhxy1EGAH8ioKf3HLd8/zpukixHitKDz38Bi+wB9Y6f8PEfGFG9lEPSo7L4RidbaACWgbIKaHh3SWO3p/SQZENpZ6aFAz4rOMabiB8pbS5Qwn2CMqngR72hixZiO2qnmt6J2GcvHTFhA0K6tKrdB9ui1XuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H5+GtLNy; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H5+GtLNy"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-672645dbfeaso4803681a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 08:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1776785224; x=1777390024; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UweZUsDEXgdSj2j31HIN4OOcmnrK4eK14ZZCg44tHU8=;
        b=H5+GtLNyk3VekCRfXYA5Y/5XReuKFLSxbBwhm0jOn/zOlHH1YX5nsoBD1tCU1fO6TP
         YMihtcssgyf9Rr6Fil/PjBsQAxlO4NwDcgWScQOIwncdl3Rrz8rtOi8CM4UYwInuANBf
         s7PmMD5dS6WhdRvSNYP6DBSi21F8uqIpzXz7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776785224; x=1777390024;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UweZUsDEXgdSj2j31HIN4OOcmnrK4eK14ZZCg44tHU8=;
        b=DLdVvpgXl3a1IQPnUCokYerLLqdLbEWMA32lmII4pizGGctX6lIaxOZMPvtrwOcCvG
         dK9uJhZXbNTIhe1kYRMd/aR0fUTqv0csvweAXFBtEVnehOboc2kDB/vaXGo6pzirWd3j
         cO0V25YO+SBuEHSjJGTB136HHdZe/JBb6K52DCrGOm0ukCyMSCRtKZvDSiKdEkByBxak
         ibZzdHYPQZKtInUs32uwDzR+1sYGYW9LAQeOuNHwfo4wvb1HKU/ojnOaONZiwU0/DDa0
         kO1HgdnLVZBhISKTEFfkoGlQTiqg395rdKoHg5RkP66QvH0I4ROZZoNtmPh18JyZbC+0
         MiBg==
X-Forwarded-Encrypted: i=1; AFNElJ8UqXTTcNUWPoGyYeWCuFLLk4anGYVu2sOsgFMY76q/+rYvcuVRSD55KFe10DAi835gzVJ2zbK3ETc2@vger.kernel.org
X-Gm-Message-State: AOJu0YwUg6QjLAw2j86mYDIQSC/m3KsRHufB3X7oRrf93t/4NjNvRwa7
	M31Qk6b5i90/nIhGdRX0y3UDOgGRno8Jx0Q0z2XyduAgJWteIShqO+wWdWYQqNAjf83V0gUcFW9
	8hT+UTe8=
X-Gm-Gg: AeBDiesv3S/A1VvrRMPr6/eunP//1ddYSqO+3edljv+dO914ReQ5rAiij9ZM0kgkVr1
	t0VgrHR9XSNoOARdeiMdz6So8p3Tlxon1o1gggNR7Z7W4QD3FZjSDNl2fo2cBQzZLn9jcrkLI9H
	+y3S43MLU6rbm/AzecWpmLD+R/Vg10uVcLcUjQPGP1Z0N9uCYFW9QdyfgT+3XHKgK6qmRpnTdAM
	5Fc+UPLT0qdanXlzXURM3prx7fEVCTPgK3fPKnGEhDDAC3Pj209+6doxUB6yjI+4YBDp13KZIi8
	g0JST++9lUrmuuhGDDEtmS8A/l1WigqdSa85A5002TrE8GL87bnnceRkCqJlWmosG7VNzk7HxgA
	WNweIjSvKfdj2WIfg0WN5IWGRqzA4eGHDcoLvrzO/ATHPU71+VTRdjaPMIUJ5qiDxwTJq/3zoqs
	GM/eKbaw8exfwZ5NAB1gzff75SpGKbNCy0mkTiGLKOJ8vmhyQHj1iI7P2+wtG62/8GbuU99VDMQ
	7MS0HqoZnw=
X-Received: by 2002:a17:907:d0a:b0:b9e:345b:a900 with SMTP id a640c23a62f3a-ba41a72ffe3mr843708566b.31.1776785223789;
        Tue, 21 Apr 2026 08:27:03 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba454d1c38csm450423766b.41.2026.04.21.08.27.03
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 08:27:03 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-670f6ae9c7dso5981576a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 08:27:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+xN7chBWyZOZ57CoOCbOywwyyBbpv4KJ9E8NXj0PQ2IACwKOmtBkyiRx9RvZbqptowZV4nhnxKad4o@vger.kernel.org
X-Received: by 2002:aa7:c492:0:b0:676:989f:ec4b with SMTP id
 4fb4d7f45d1cf-676989fedb4mr1844972a12.5.1776785223151; Tue, 21 Apr 2026
 08:27:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421151345.9937-1-James.Bottomley@HansenPartnership.com>
In-Reply-To: <20260421151345.9937-1-James.Bottomley@HansenPartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Apr 2026 08:26:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh6ujpfmEufVOW928pW6xb00_tew5+9L88LL_xyZpBpJA@mail.gmail.com>
X-Gm-Features: AQROBzBIBA1h4RrA0bG31BSqWD8X-3WCa0UDU2Zei3rwul5LVKaUHZ38TfI-CTM
Message-ID: <CAHk-=wh6ujpfmEufVOW928pW6xb00_tew5+9L88LL_xyZpBpJA@mail.gmail.com>
Subject: Re: [GIT PULL v2] SCSI updates for the 7.0+ merge window
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 21 Apr 2026 at 08:13, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> The patch is available here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

Ok, it worked now, but I'd still prefer to see the full "real" git
pull-request that also talks about exactly which commit ID I'm
supposed to get, with verbiage like

   for you to fetch changes up to
   070ec6f691411f27e7a743841bdfb0bf604fbce2

   scsi: target: Don't validate ignored fields in PROUT PREEMPT

in the message.

I do note that you've used your own script forever, but it ends up
mattering exactly for the "oh, something went wrong" kinds of
situations, where I can use the commit ID to then look things up with
"git ls-remote" to try to figure out what happened.

              Linus
