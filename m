Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27EB45DF4A
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 15:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784734178; cv=pass; b=JEjZrPDtLqGxRUZAixg8RKE14imm5hicXMIa5C+f8xVVjUROKx2uSMqCknWqTmosqVWYcOk/qOVrwb5ZZRye/ZlptVnjSf3PUvS2Qiqhm6BhJ5CsP5i/jOrplp5X5hMagiUfChTd2oWSBduHouhQjZvsaKYV9V+I2x7xrBOTWQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784734178; c=relaxed/simple;
	bh=om92Vg1MT06YPtu4FZa6UsTxYYkEP2jooVYJUsl6Wn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U0mOQLM/ZZVc75bGjqZFlRCSxCjYhxk/9AzdE5Ws/atRiiOYsujhx/GXIyRGuG3gan9wvpVcp+G4CUKCQLgmlnEu0z/mK7smWIYwPo0EZ1clflnXOmUNpPF6aM0THK6Um/uyRkggN6mCWKDkiGqN5GC7IweZTfyHccFcMT7k8N4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kHZj65fR; arc=pass smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kHZj65fR"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38096590070so1998831a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 08:29:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784734157; cv=none;
        d=google.com; s=arc-20260327;
        b=Z+jPOsiq1nq0ldxIQ3ypFdCR8MpEQfmwITNrWDKYdlPED00APe0YG5qB/JI+pWIaIH
         U2KMd0QuJqVROAOhtVWmGlENL5Zx1wudKR6pIo4GWl0jKz5HvJ5DoshrBU/fMmLOyN0P
         19AsHyty+TNYyZcAngRlPnkoX54h0OBBi1r0cRqGkz9x3RB8iTEK9GeDBZcopWayQ51a
         lay4s0xNtpmBM072wL+Fn+H88zjw85eCPPe19cZMofkaGEz6cmS8eXRCLXmyMSLWX2Xe
         dihm6V5vsxPmp2LjnPRKiZ+jiRcFfJNdwMzKR5AV3vw5wudXJkHn0J754i0AuHsqkpJn
         Ak0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2Aoj5jAfbWafkO/PX+megQ9fW1pG8YJPAHZMTkiGVzA=;
        fh=OBixaPLH8uVZaNLB20NMWIV6F1EiPzb45SRZbaUSSUE=;
        b=DsXm13n18K3sshTDfFfueA0rmYUQma+GtBjcrXIzbtuzVqlGWpOOVRkEVm8ENPkZy0
         I2RimK2+kNSbcjhWygVDxpfBs3I7cKeghMk1fMSemVXXmyXvUMK5BV8MXCh42zBTlxgQ
         VG/BCF66xF1SHnKlmclgXLqFj2ONYPPJkwC91+6GevqXx8QMc8OkgkLVvAh8p6NQWBKj
         C9nLTqrlQ48owyE3lBkulJuqkwI3dfQr5TdRyJGoKRJcJPn6GGhu9o8Dj/3HAQdfdvaj
         2jIRIMAq3bC7S3K7EOGR/q8uni0bUvfQt8kGcqbhBDpqLUoGayjNntoEJIWUI9hId6k+
         UmDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784734157; x=1785338957; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2Aoj5jAfbWafkO/PX+megQ9fW1pG8YJPAHZMTkiGVzA=;
        b=kHZj65fRZN/8gzH2BHG9ICX+G8tJRTI9ZdjSmLk2pkEr647JrqjkOY5zllmGSiO4qA
         PYFKh9cwp7Bhf0xtKDJPlpabNwePgleXGYTopGs821En48E50PuHCFLD/hc7jyvs1JSZ
         Ye/TH0IbmTLw5E/Iq+cEpM35heD2GaDez6ugI6K2Oj7RdBW9kozximllUMZp/1UH2ZMI
         voK/ZzBg5gANTOcV+hg3dRD+tPPtXPGmK/0fZf1RGIapx3QgytaDWYbKX0u23WqVtIAw
         N3IQSC8LxmtebEwHt2xDSR8UHhbwse2kw9K3Q8p4kacqqC/MSRA4diHGI5Dn0bflO0Ah
         +Mjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784734157; x=1785338957;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Aoj5jAfbWafkO/PX+megQ9fW1pG8YJPAHZMTkiGVzA=;
        b=XiyML0VhHn6q1pyNyOZg9YpKCqwDDOqsBfL5fdFI/TiQ+FEGVa5/+Fd4rIPOuXWgvG
         x7pRWilFI5NCDSLxYLrrA4AtxZnXdhYGJQ99n/5ws0bVfxamLoA3TLrLa5zNqHxhsJlJ
         yJgniW0lPulhdmM5e+0ugX8JjzggT4DDJhyH1ZEIzpinQIK2OEDzyW63f5Q/uXo3yTkP
         kIR+u89yNqVU45f5tBUhyZ+KFsrS171gwqpKt83Wd/BQ9hb5jDDk7CJ+NPVpi8hFGlfk
         4BC5FR+gZi50VssOjKZ7NaHsdlxk/kpi4CnjsDd0MQUikbBBoIxx9lAsQRfw7IE6k4mA
         piOg==
X-Forwarded-Encrypted: i=1; AHgh+RqUHqLwUMoivepzSnIlr4SW8ZwTZpmBQ+MpTHPn5tM7n9n4e+cVXa8DIHvPDFHXrECzBn30eEHyhBir@vger.kernel.org
X-Gm-Message-State: AOJu0YwaxyvbVFTq3KlKENQUcNfgtKsL5+hh6mveGUzc1V9Gxd9tsM2N
	/VUqnVsprQhdd2DXwJcTzPL7WAyeSRGG0luXrq66281rPAJ8KKIS9EykftGidodLmVVYAl/UBQ6
	q3k1gILnDAlXFDU755HMQ2WU3Vj6oNHg=
X-Gm-Gg: AR+sD10ksgwvz0CxDpQqBDcri8tV5Ov8nvlqguJiqPOU6RPlsrBRllwipayp+5KZSv5
	soYsce5gmHaM5cFaLuHxxRIPHATwquxcg4/eha8KY/gtECwENvbFwDY37XFxeQltB/S/9o6HOXl
	tHeAWwuz+GcPlpFFQn18VjNyui/LIzZxK7Z6dpHN/Ri253XCYjwsxwFLjJ3TNcFLPwJU49e+BjK
	1DRjIuetH05mauTMXXxWfVxeA64c6r6l0KB/K4m2hd6rbp9ksZ8IG0olBVPxRKhUmiKapz26NKN
	yNEyjz1G9KEBWDcmlK1Sexu8eOIWnwiGjnoNiNKjL9EDvrRw6tVQJ29qggqctMBCwpfMBKZenrj
	WnA==
X-Received: by 2002:a17:90a:bf92:b0:38e:ab3f:2c99 with SMTP id
 98e67ed59e1d1-38eab3f38a0mr1422489a91.2.1784734156982; Wed, 22 Jul 2026
 08:29:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn> <20260722042744.5C1B01F000E9@smtp.kernel.org>
 <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
 <2026072224-moisture-gonad-409f@gregkh> <2026072205-unsealed-emcee-b243@gregkh>
 <ed0f74db3342ead9a36a0367b8a5cf694b0decf3.camel@HansenPartnership.com>
In-Reply-To: <ed0f74db3342ead9a36a0367b8a5cf694b0decf3.camel@HansenPartnership.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 22 Jul 2026 17:29:03 +0200
X-Gm-Features: AUfX_mwHR2f5q7FTmXaAPXY0LSHFQ4XQZ-onxLdgL2t_w3ErYqbkA-y1dJ2vX8w
Message-ID: <CANiq72m4XJcj+y-VnWYBwoMvJd+P8Xqs2dK3vaGEycFpqwAt_g@mail.gmail.com>
Subject: Re: How to fix problems with the sashiko review model
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, sashiko-reviews@lists.linux.dev, 
	Chris Mason <clm@fb.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-scsi@vger.kernel.org, 
	ksummit@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 4:15=E2=80=AFPM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> So you're thinking of this file:
>
> Documentation/process/threat-model.rst
>
> ?  It's already mostly in there, it's just that sashiko doesn't seem to
> be picking it up (otherwise it wouldn't have suggested the problem I
> noted), which is why I was thinking it needed to be a direct prompt ...
> unless the prompt should be to read that file?

Yeah, I had the same question for the Rust subsystem -- I have some
guidelines I want to add, which should be useful for both humans and
LLMs (e.g. not too many tokens), but I am not sure what is the best
practice here.

I think mentioning it in the prompt is needed, but perhaps it is best
to force it into the prompt `#includ`ing it somehow (ideally without
actually copy-pasting it every once in a while).

Either way, it would be nice to be consistent about this across
subsystems both on the kernel and on the prompts repository.

Cheers,
Miguel
