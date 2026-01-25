Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D14A1DF75A
	for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 20:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769371836; cv=none; b=cU0gd3fXShoo9pYs5nxG7c3m07bKi8JAnZO6FaXgFB6g3PUBuL4tGO9Kn6JXT0/ajwYLdNy0BeNnVvII/B3be9m5ch56vQlPdRsbdbSEHy0RQcGcgyO374S6ZGvVAROLFeDvhiEC1jI/WWeKdLh2eIaHNgssfYVs+b2CWZkwUO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769371836; c=relaxed/simple;
	bh=kysk0nfdcqyHJ/gd+2IwepjGENtxNaa7WoLx1fwaYV8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HoizvJRFDoeS9K4g2WSUCt1p6n9tLRPfGjKgbya9eZ6R+VzMMUr/ZS036Bj/d2Ul7HTG0trbiv20ty4zwGvp3UgY2+1YcIP49pKQp8a1Q4CC2/+OtmGY6GPfjRI1iMnxvjRzZ/qbWZLj7Ce2554pQchm6EDL/+HiColCrNVmbCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e1I42AxV; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e1I42AxV"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64b92abe63aso8003168a12.0
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 12:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1769371833; x=1769976633; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cEi6LT5Qs6UFl+h6flgx1HJJEPBecPDFGWHnEpjXqxs=;
        b=e1I42AxVsQEGjrcukvi4DkYp3buc5E/jisunbl49wAVERFVBIyt7Et9IMsDU6rotIh
         WxC6igWBgShLPla7ptaXZvs+YEkyUvKYvOPq4Shdw9ASpRpgpM3fiRplaVmv7gcgACj6
         QRol5F07K4QmP6eQAnMBvZvCX6zhlEtg4Tb/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769371833; x=1769976633;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cEi6LT5Qs6UFl+h6flgx1HJJEPBecPDFGWHnEpjXqxs=;
        b=YRsjZ4GrkO98Up77WESHXd+TRbP6mwj70++tZGamXiVWbYlId8A0agLFe7yeEL807A
         +VZaXG2aha1icaKpNciN2Xj8mLMniZLjdMTAjSeXD/rhkZs6vylJXP7WUEisADVDuoTC
         obpNP0IL/u2rm0Vst9hQbl4sOAXmZ1A9pJuWlOtl7xN7quBUb23Os/3CWoh0BCzFKtC3
         67RAYOOS4L23Yizx51L6akps+m4KjgRCDj9GuXXzOgrQlMjD3HaxojQCCzv9rH2RubaH
         NhHh2jr3egnxFihVneGoMbrpQ9F7nTf8ppYVijzzT7SjEISW/Ssu2Xh40UqW9Sl5Ci3k
         I0/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWwLSKkTW/+KYfDZSVF4xrYuV+lYjw8USx/1ODdKbNqJ7Gk8GUbKB/n35FyBIR0T07TBxXH4vbDmWMD@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz1YwnW3ujbYQtt00lk7C92ItNuLDj0jiEIl6/ae1E5A9UV+U7
	hyuyoVvBZ7dU6C7OFVuMsub6n7haiZO2KqNdbB2rtCqrJgZVVDG5ZfQv/ZdhCnNpKdk91RBIqLj
	nC8GKtaY+fg==
X-Gm-Gg: AZuq6aJM0XMSOaboYPeDogkr10kKghLx3o/Xz72b5uwwcvFvuwDrLQJlw9numGxbU9C
	4GajHQIGL3tNaUAzhgyLzG6MVIc75slDFRfFW4hWOgdmNBKTWDVnzqxR697+F/gNNKbwg7OKMWl
	TgCdHokK7r1Iwamii/rSeHMBDb/negpeq0goIG7tYEh2OkOXQF1FH3tDF9iMW6nrKsOZ7bsMnLD
	MDQhh40LMtG3Zr19nmK+AE7J85wQ8tXSWZBB6QhEfbjAupj4jxh2uL/uf0g/UES9rnbQcKIFcjJ
	YiWzM3KuIJHaRlGiX67MdFsTOjjlapcrfMQdBCD689cCbscdJaSmHv4mf1OhJuHoLoxGdVBTWQL
	NxPLIqAsBWe2r7C/fITHqNMBHG/5tZD4S9DIH+ekMkp4LGRjUs8zyXPZDQBuZR7hsbetkR1sRyv
	1u218jSZEz9jBM53/I0MG56C7z4A3ioZQb6uyQDkIT/8zkFan93dvWoW8OTuhz
X-Received: by 2002:a17:907:7207:b0:b77:f4a:ca1b with SMTP id a640c23a62f3a-b8d20b4f208mr152811266b.16.1769371832685;
        Sun, 25 Jan 2026 12:10:32 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b885b419642sm508565766b.28.2026.01.25.12.10.32
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jan 2026 12:10:32 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-655af782859so7775135a12.2
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 12:10:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWphZsUhcuT//CD0kerof8u1QeZfvxReeVYCRv6dhm3vVfGfOgOR7GqFEmcv2W3GTDnSMUlvYLo2DF4@vger.kernel.org
X-Received: by 2002:a05:6402:50cc:b0:658:1025:32be with SMTP id
 4fb4d7f45d1cf-658706e00c3mr1631216a12.33.1769371832014; Sun, 25 Jan 2026
 12:10:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1a20127d291b660d4f85bb85c1dacc67c228c368.camel@HansenPartnership.com>
 <CAHk-=wg+4HjC5+qo_dKoyCt=TmVuUQqpWGAHMcRv6KKnv64v=Q@mail.gmail.com> <3a280502b3cb98c60ee3b514e7e27f0749c86a26.camel@HansenPartnership.com>
In-Reply-To: <3a280502b3cb98c60ee3b514e7e27f0749c86a26.camel@HansenPartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 25 Jan 2026 12:10:15 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjxH4L=On-ix4X8WNzKOSbUEbycDogfxFFJd1MD=uJtJw@mail.gmail.com>
X-Gm-Features: AZwV_Qh0GP6OP7bxojaPGh5GzNEtTjovX6pGPso1Hggcq4voofmGCQaaIPHw8C4
Message-ID: <CAHk-=wjxH4L=On-ix4X8WNzKOSbUEbycDogfxFFJd1MD=uJtJw@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 6.19-rc6
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 25 Jan 2026 at 11:14, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> You can either ignore the expired key warning on your end

Done, and pulled.

> or get the updated key here
>
> gpg --auto-key-locate dane --locate-keys james.bottomley@hansenpartnership.com

Well, that does nothing. Possibly due to DNS propagation delays. I
guess I'll try again later.

              Linus
