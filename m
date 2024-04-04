Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C3812AAEA
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 19:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712260698; cv=none; b=TftVopdWUNYZFeiSv1vQ5Sy0Dw1sVhoY4q7QCDOuLYd5ZXTomnMKtVWQ9JL6gT1SV1wuUoHflyaCknsAqWwr4zdFcDE2ccFXTGfrDlAR4vUCX8Fu5S+r9twPFPMvhP/L2b71o8Oq7Ke77YH4ctnEQRGtDeVQ29mGYL+T7OyUCqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712260698; c=relaxed/simple;
	bh=Vk7H3Xk8P3ZAFERWige+lmgJX81qy1E1DfiB/7/Slkk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pUbrzue/OmQ5skF1Xs34FgM0TxI+Ul2NHijJcQ8j6v+smUf8Nx1Z6VE6C5Q4VGWdbUqL547XfpFVhK/Oc3NOfiWplTEoghHE/O6GYP9aipucaBjLOapJpm9F6h6czoRNKvJdE5u8BLhh33+a6yKwBs4hzCw5f3zOl2eai3hGRJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NAC266IA; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NAC266IA"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-56829f41f81so2000660a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 12:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712260695; x=1712865495; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3rmu0hrKQn71jGQ20ZpBkHvHCtCxHR9LDj5EzuvfXt4=;
        b=NAC266IAot//VcUMKJ/XYzRKwJTSR334EBQ3we/MgjiecHtiC4KmIu1c5i5QUOdWdZ
         6/UGRPTofDQcfS2W3icvdvzqZpHEZtaJjT6n4BrvQtMST3EPK3VM9K1V5c863Pndd2sW
         4PyzF8v4mVN9zTegh1NMrAxIYEOtIFI8Q7P8prIVudz6TAEuFH3DjwUtPqhWRnhBROuI
         Yn9kmnAM7ptIVpyunt7neQPXGu4xNIyBuP1OIfds2JtdjziRuJl+eOqjQAM5aQCC2ki1
         OFvfQtHblQr/ggdiNiLneGF0W+ceO3VnjXwnreipc6l9Zl6XLZGy9k3M5hMV7cNrDieZ
         uKYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712260695; x=1712865495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3rmu0hrKQn71jGQ20ZpBkHvHCtCxHR9LDj5EzuvfXt4=;
        b=FAUxXn5YGkCw3Ya0VKaChsJIASl4EkqjcjT2tZPBz7w0wNdNxnlfJrrx18bk6MOhTF
         uBHlLj8+7i3TvwpOG5vmnH7SPD0YRM5cHCqOYLvkgTExP8KWtmsotelM4gZx1M8xyC5J
         VCbEdG9YoGLUe2Gan2NsWIxVgeEtCcdX17wkVGrEhEKObb+0xitQBx9Vz/6WN3jQ2WeW
         KhZTTSub7yo/tGZC/MdgrC/pX2eGOfwGAkdZqBQNJUmCMRBTVsR7boqWXcZgZbT+TSpa
         62laB5DIilHKqNIYdaTfrH+s2284t+2njB5anEoM28EuAZTxFwuU74SY5/P/o55Pe6PB
         VRBw==
X-Forwarded-Encrypted: i=1; AJvYcCWaHN/VISF70ZOHEzaSuI5F9EkGYJLMsU8ah9HPolZXKkSTWrWNXfVp3jDvKzalSyP7uNzD+Hc7RRZ6cQvwjhe2FLGXrw3ZW3rmCw==
X-Gm-Message-State: AOJu0Yxzar3KRXmWkzAfEsEqrWCMiDaGiZsc/rP0zl+xCShdERyxlKyW
	kmLLm6wRQHgFpUV7tquWrDoEgTemxNrwjmmXZcfIfBLP33dYY39Xv5jTsHdkCY9JRRZplgCFbpT
	ifjTN2KGhmUSYAL54O4x16GwxQn0tWFpMv3nR
X-Google-Smtp-Source: AGHT+IH+29d8o33j7PRVi4gbLNqwRM43CLCcwW5t4o0KNdp9u+AubsqnxawTXv6q+OcqdLtkLHN/Ki2ZZxYcwkGACdA=
X-Received: by 2002:a50:d519:0:b0:56b:d9e7:1233 with SMTP id
 u25-20020a50d519000000b0056bd9e71233mr2225543edi.32.1712260695481; Thu, 04
 Apr 2024 12:58:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net> <2a17e63b-6567-4d6c-abe2-309304bc9ea2@acm.org>
In-Reply-To: <2a17e63b-6567-4d6c-abe2-309304bc9ea2@acm.org>
From: Justin Stitt <justinstitt@google.com>
Date: Thu, 4 Apr 2024 12:58:03 -0700
Message-ID: <CAFhGd8oyD1LM5rR1eUBPcJrMZJgDW37KzMOhtjMVmkr1Z+RXMw@mail.gmail.com>
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
To: Bart Van Assche <bvanassche@acm.org>
Cc: Charles Bertsch <cbertsch@cox.net>, linux-scsi@vger.kernel.org, 
	MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 3, 2024 at 4:20=E2=80=AFPM Bart Van Assche <bvanassche@acm.org>=
 wrote:
>
> On 4/1/24 3:43 PM, Charles Bertsch wrote:
> > 45e833f0e5bb1985721d4a52380db47c5dad2d49 is the first bad commit
> > commit 45e833f0e5bb1985721d4a52380db47c5dad2d49
> > Author: Justin Stitt <justinstitt@google.com>
> > Date:   Tue Oct 3 22:15:45 2023 +0000
> >
> >      scsi: message: fusion: Replace deprecated strncpy() with strscpy()
> >
> >      strncpy() is deprecated for use on NUL-terminated destination
> > strings [1]
> >      and as such we should prefer more robust and less ambiguous string
> >      interfaces.
> Justin, can you please take a look at this email and its attachments?
>

Looking now. I must've broken something!

> Thanks,
>
> Bart.
