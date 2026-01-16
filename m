Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61973043D5
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 22:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768602927; cv=none; b=k0RQGnifpBTOtPd2vWnGMwscNBYBjdi2gKwCveWzxgJq8eaVNA9MyEuByRNk+ubMGxLyOl3vk46oy1p8UzZ+seJqYMcn6UP8hceoU7Je/4RTbYVTHgpLtb7eBfy1inGwQI//qLdkNMYK0Mz3SUHahdR8gCvLMl9qzdtzc+hr3c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768602927; c=relaxed/simple;
	bh=Bs6N8TmR+SuPmXchESQ+loryAIkp6V/PwqIeVMH774A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RRA02eezhgIzCagpMHo/l5DGDx0XkRDQbYKIIPR1qICzNc7EesLFXmJkFnIWd/LlYVl6oja8KsvVHccUAuRo82Qbe89jG6DLDpHKwqKyInpXtJE+vKltSQkhFpR4AnqV8Z6Sqe2SomHE3HJf0ZeDgrlQcDIOcWsDrV2xw8JWD+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OM4heqP8; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OM4heqP8"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-88a2b99d8c5so20235786d6.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 14:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768602925; x=1769207725; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2JCaf0F7r9kXojyB7zdNX5DnzW5uy3vZg1lHRv5VVZ4=;
        b=OM4heqP8hVoWdTN3fvdQyNmRroHJu9o8ckG83QMrYJ4AVY0P+RuUQhRqI/XbwbjoNK
         xOQSpNYSLXjqxyb/E/mbKALWbyvlCzQpewY0IOWb7JTW6KSlDWxXVXkQP/LRmAZwjOKt
         OXg4cmhQxvdgcqMssTl7CtMbpfv/fOvpZzf0To9bGAC4VsmnVYI2u52agslZogjcIkrm
         J5kJhgMThncDPHTJ0viTgvQDGDOYzEhHDfAkcEF1YlOYyDkYUxyJ/ZooBN3OrrZ3ZOei
         8XB4Lpqx/lQBQL73y4Rjh/SFARlcQwhI/dl1YcIroX7gHaFaeaXjsrbGtqFtKAYj0KnM
         UfWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768602925; x=1769207725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2JCaf0F7r9kXojyB7zdNX5DnzW5uy3vZg1lHRv5VVZ4=;
        b=smJyW+TgjxWP3bkTSNOzVYJpO1jzirFg/6RC6vqMypsDlqynroYzKiwTbuiSlCLMJN
         YwcCpvRvUvFnuy2x7WAmvNDPHkbIu1LNUOvAcySyoUV9ZOcUtBhmRtDt5caVC4kzfgiE
         qt5qViFu+CV9or3qXb3PohfL/N/MX7LgYWP2zy+y/U54KkCtnT/Jxzrnn8Q4QnOii4Bi
         JQQA5RK66arC3trVaLhqNcnXcjn0BmJ/lK17k7cyj8hLsWsejbMhexxIm2Y+HxAZGtt0
         YL14W6W6c9TKfoG1Of1PrgYilTKhdoiJZqf297zX1hPXei/MJ7ymOmdnmTi5xyZEsytr
         tmNw==
X-Forwarded-Encrypted: i=1; AJvYcCURFOQ9cb2lMMiZjaluUuerD9S/WSiFyxoj1Uzv557OTUf5fo2LlABi45mmV78mp9DUOVNPa1IrySQI@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3hrEgsd5zqqFDtchCptr+lmLnLq1hKYqxrbx93mmGZn+yuGDw
	V3QtZi+oezHsQKLjSAnhgVrYewY3adhiaoTmofQp9x/ZT2bgID/EtrkhCMgJV2R7JBgWztR+rfi
	nSYZJNFLkmvSCZ/oMtjVyH1PAQ3qnMrwV3esVSRI=
X-Gm-Gg: AY/fxX55oqhyPanXijobCbXCgvcmIWxVlE6p0ue0ZBUhk+NNPDqr67AtDaGwBip/Jac
	komfKEmTIEOwf9yEDN8pZBHS4ggPW5sEfbGywAKtn5DH+i4Xy9GLzyFQI1+dVZiQ4lykcGJIqBC
	Ziuv6il2aS46kBoQYvd97mKHdZBlQ6J/R7s2Vl6ineo0nEEd9+826g0NhrqKrweutPTeFK3CwHN
	Xd6tJIzAMDSXuOPdi3HcXBsQNOyFa2VqQuS37gq2C2SVZx5zFJ05hiBVvMEYZInA/A8abSI
X-Received: by 2002:a05:6214:130b:b0:892:755c:93b1 with SMTP id
 6a1803df08f44-8942dd2941emr61537136d6.15.1768602924819; Fri, 16 Jan 2026
 14:35:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113222716.2454544-1-minipli@grsecurity.net> <CABPRKS89zwXdUT1Bhj37cQDyOHNupOJ-Ez6kS7Dp_pu06X9Myw@mail.gmail.com>
In-Reply-To: <CABPRKS89zwXdUT1Bhj37cQDyOHNupOJ-Ez6kS7Dp_pu06X9Myw@mail.gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Fri, 16 Jan 2026 14:33:45 -0800
X-Gm-Features: AZwV_QjX1QoCe_7qK3zXgAJotqN8ndHVb9kmgSBRcXI7X-sU_ydlL7oP83G1Y54
Message-ID: <CABPRKS-ongXPqWVpNYiKvy_afVKn999bxtSEfsBVQ7z5JVCgeQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Properly set WC for DPP mapping
To: Mathias Krause <minipli@grsecurity.net>
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>, 
	linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mathias,

> > I don't have any hardware to test this on. I just got the report from a
> > customer of ours regarding the CONFIG_DEBUG_VIRTUAL BUG_ON(). As I don'=
t
> > have any spec for the hardware either, I assumed a few things, like:
> > 1/ DPP regions are only supported on SIL4 devices.
> > 2/ DPP may be shared with other registers (doorbells?) in the same BAR.
>
> Sure, we=E2=80=99ll have close look at this patch and test on real hardwa=
re.
> Will report back on our findings.

This patch has been tested on real hardware and I/O is stalled when
using DPP.  We can look for an alternative solution.

Do we happen to have a dmesg log with the call trace observed?

I plan on attempting to reproduce what the customer is observing by
enabling CONFIG_DEBUG_VIRTUAL, and would be helpful to see context
from a dmesg log.

Regards,
Justin

On Fri, Jan 16, 2026 at 9:46=E2=80=AFAM Justin Tee <justintee8345@gmail.com=
> wrote:
>
> Hi Mathias,
>
> > I don't have any hardware to test this on. I just got the report from a
> > customer of ours regarding the CONFIG_DEBUG_VIRTUAL BUG_ON(). As I don'=
t
> > have any spec for the hardware either, I assumed a few things, like:
> > 1/ DPP regions are only supported on SIL4 devices.
> > 2/ DPP may be shared with other registers (doorbells?) in the same BAR.
>
> Sure, we=E2=80=99ll have close look at this patch and test on real hardwa=
re.
> Will report back on our findings.
>
> Thanks,
> Justin
