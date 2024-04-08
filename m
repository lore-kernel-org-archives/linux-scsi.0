Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9F91272C4
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 20:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712606407; cv=none; b=dD7FwNggxHHmiMVXJetmqEqRVlU9HHg7Cb9xQHTG6Z2yeoEpkhMYstKA4aMEOp2zo8GX+yt7udDmMv2YTg/gvFo/dT+uS0CkHh/KFvIDTYER8ADe4HM0mExMZhYROm5IpEBblX10J2jZ3cpEXbDOJ6Z1saE4/h4Zthkaj6B0/4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712606407; c=relaxed/simple;
	bh=WM5cz2hAVGAXc1GzFnBOHrOHyynR+1egwsVJfgXfq2c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iFTm5pzCaBrpj7uNtLTwgFDtFZau+X2KOubo2jLX/jhF4Zm4nT65VIk8SScTUskCOgd+wXzX5hny2+LbM1PPG/QOhRPQ1MPOuX06ZowEL4+2LG9KuNlqwzF+xZHQ1frf5+7P2QLW5JPO8LaQFauKVraBBQ+ZcQot9C02oqLwDt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pqFhwgeU; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pqFhwgeU"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-56e69888a36so1441226a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 08 Apr 2024 13:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712606404; x=1713211204; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WM5cz2hAVGAXc1GzFnBOHrOHyynR+1egwsVJfgXfq2c=;
        b=pqFhwgeUIcIKpU3p5aGGaA6kcIMmzI4leRPhXMGNbeIH3lVVGDl4s8Hqwr6rL8EPpx
         gHbRmt0zP/u/SADXgyedzAWB8wLj4bNs4KNpwSAdOGirhW/IWCNL8EJIFclngJSDwaXh
         8QkKAwKkhpuvGsGB/PF4FFZe5c5qNeUc9SJW39pEcJ0TTynd1ABuuJ23DCQ7z/g5q+mP
         7qUy0PsaLJRMDW60FRSqNWHDeUa1HES82byBLAkHnnF1I9CeZsph4PJ4Q17TPSNlPFE2
         D5rhtdn5FvkxoAwXnNWpqN6L882vkh0Vs4phnZ45nu8Sjq38y6wVi4HIOWvzU0Qo8mv0
         f0oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712606404; x=1713211204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WM5cz2hAVGAXc1GzFnBOHrOHyynR+1egwsVJfgXfq2c=;
        b=awegMiipHV529ZvwfJxUmX0Ss9Sp1eWSZ8h9t4RSKAdmhiRjxwjEuATuQ8t9I3+DYQ
         a1a9bksWAOuMkOgaVj9W6w5aCasxYxA8d/p6zjsSCYX26AJQEQEnHo8+Cf4julQRtT37
         Kumfoe5qpVymUhG/0Ew6IGS4ycpiSYu6L4kXreX9x21vCTUsB4JEspNdOxI2sPRWzlHy
         BVOfJ5hniqST+Z5QGKlMCHcTx+5kLmZEn93umVlFQgeXjGeifuroEJutrZ3DccKo436z
         ThOAIK7oru0FhLCAtIo+7uYNB+PCDQpI44xT6VnWgfoD/GTncjUnKgERbbdnGt/KxHdE
         YjXQ==
X-Gm-Message-State: AOJu0Ywunc5HtXUjUh67C7rXul4JTsvLxKtywQSOqqHYY2lrC+UOyuY8
	4xv6d2ldh0zF8v8ts0pbMSPrfQgx39ZkkRJeJbZW4f4bWuPTwz0hLfdipkvAYLALVwhSKOoePwV
	VLzpaZUkuR3rDeO8BxdkRPfu6r+ikaDOrjDXh
X-Google-Smtp-Source: AGHT+IGOkK+CM+mAt4UL240nJ+aOSiNncqIusgXNQAbLCRO+D2Y5GsFtwEU/A4SJkLkhyhxCUljUFgObHckl5iQy3o8=
X-Received: by 2002:a50:d49a:0:b0:56e:246b:2896 with SMTP id
 s26-20020a50d49a000000b0056e246b2896mr5876974edi.3.1712606404346; Mon, 08 Apr
 2024 13:00:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net> <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
 <d45631ac-3ee6-45cc-8b5a-fab130ce39d7@cox.net>
In-Reply-To: <d45631ac-3ee6-45cc-8b5a-fab130ce39d7@cox.net>
From: Justin Stitt <justinstitt@google.com>
Date: Mon, 8 Apr 2024 12:59:52 -0700
Message-ID: <CAFhGd8p=R4P6J9KoMGcXij=fN=9sixVzjuz95TLKP1TexnvV8Q@mail.gmail.com>
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
To: Charles Bertsch <cbertsch@cox.net>, Kees Cook <keescook@chromium.org>
Cc: linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

https://lore.kernel.org/all/d45631ac-3ee6-45cc-8b5a-fab130ce39d7@cox.net/

On Sat, Apr 6, 2024 at 1:42=E2=80=AFPM Charles Bertsch <cbertsch@cox.net> w=
rote:
> Justin,
> Yes, undo of that patch does fix the problem, the scsi controller and
> all disks are visible.
>
> So did changing .config so that FORTIFY would not be used.
>
> Given other messages on this subject, there seems a basic conflict
> between using strscpy() to mean -- copy however much will fit, and leave
> a proper NUL-terminated string, versus FORTIFY trying to signal that
> something has been lost. Is there a strscpy variation (_pad maybe?) that
> FORTIFY will remain calm about truncation?

I think fortified strscpy() should allow for the truncation, this, at
least in my eyes, is the expected behavior of strscpy(). You copy as
much as you can from the source and slap a '\0' to the end without
overflowing the destination.

I think Kees has some plans to address this as we spoke offline.


>
> Charles Bertsch
>
