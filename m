Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98086FE04
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 22:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712270840; cv=none; b=S7dh8wPZoLGpk1ptnIHcAc0z9cXbC0NWv4ri07pbXr+T69eDzBYV1YK3Uuj9rvHa2eeQlaaPwgN0sXPjEIFY3ShBcYGrmQsXmYfYivNONlQA+cehnC4rMFiscrZPjfEX16tSFwRMDBIZZu+dCdXrTP3tvZVet4Bm7HTPhBkyqOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712270840; c=relaxed/simple;
	bh=GK5pzepmmVWYbFilAnNrZGPMclLybNJcKRLNfoanMhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OcEadwiphbFAGRUXLejbIgBkRTGiQBNLcK4TTnZagmlhcwlIp7h4iWzw7cswOisMdyoAhP42NKnDc6yrHkl6eUGhsbTyiaV6R8P+rUSbf0ftNlbDAgwgRcQFs59hno+1LO/M3MBAm7rb5CkK68XWkFV0i7o+dDk0CvNT+lK6i4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CsyJ2LyR; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CsyJ2LyR"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5684db9147dso1885767a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 15:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712270837; x=1712875637; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/LRQveA4Bd5KOhVN4LdN0SZIxg6xig22B4uSHmKqtVc=;
        b=CsyJ2LyRvS8oihuylvfNysGQ1V2xxZVNKyjMpdEt+MyVGmcs3N9ztGytRmPZEuKk1t
         t53cS6ruhGKwSZYmWExltNW/QaEYOH5ujc+fxwVWLz+91WplaR4G22N6rue5OEeqSPp6
         HLZSAnHruo1GWvwlE2OqYbeyZgztyQYbJioakH8aYPteYZ2a1v6WoKhrrjS8lYaV5v6k
         Y6zn9oZ3PAnYmINB4E4U5Mm7rVNGMo3Brr4JydWiL6pO4hN/kE3QvrvWugLRujxCbu8m
         oszJiEpqDypwCBFk1IBvJ/ChPWQpJgNwPhW1wq8dA+xeOCidlPQFSoloVtWonnLyfnsS
         Qvig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712270837; x=1712875637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/LRQveA4Bd5KOhVN4LdN0SZIxg6xig22B4uSHmKqtVc=;
        b=MSNcXM1MCF3iMAhI0s+64hNXK6ZFIabGpZ92ygQr9gUBOBVjsFy+8ydy1g9EzhMUec
         J1+UTcW8cZo0pisRXzd5J6e1JbSFX8WcYj92X0zVMD8JE+kMflMgV0Zqslv5kqZGC/wz
         yaUaUNN7NSjqBI48SzANQil8czmfj8zt5xx2MaQc2hwL2q+X73xf9FVOI/Ha7IIWLmP5
         wnimd7j0w6kXALPkdHrmPyJ9qlVqKPxS4DFZ9qtllwzMsrKVhIVEbzmIWvx64Hg6WLh2
         grgGGPg93jwmKNCagim7Clkk7T7SjZlJF+hwwdhuiwLnruSNkjybjmTU3D0KLPkFixAp
         ovQA==
X-Forwarded-Encrypted: i=1; AJvYcCV5PQTjx4rpSPSx4PcZTjN1PPQtR/xSJMrzwhAwbXQXGxJBc1rIVgL1ebam98nzXZ/9ruWkXHpaa1jtyTwBu8ZuaFalTNt7lV1hMw==
X-Gm-Message-State: AOJu0YxC4KAricaFzcF4mjuYTwMyQ+XUN3bNkqTuKKIVyehki2/+EOIv
	PdvUskbd8xrxsvdiMx8HFgTbZJpVDHhHb/62cm/y/3XQQmadVb8LbGFzn+LhTwU81aU/9UpH/Ss
	sJvrCnpuH8S0rJYD8LaSqj2QU4OWfdtJ6+wRz
X-Google-Smtp-Source: AGHT+IEnCDKX45B3lu6sWf7htDSEIXJOE3CMEpgNyU8zZ5TzJ1ZTV6KrZtaHDn65ZZ6HiF90Ulsta1n4Fp9LqDkg6Lk=
X-Received: by 2002:a50:8d58:0:b0:56c:3b74:ea4 with SMTP id
 t24-20020a508d58000000b0056c3b740ea4mr2641806edt.21.1712270837030; Thu, 04
 Apr 2024 15:47:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net> <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
 <5ac64c472d739a15d513ad21ca1ae7f8543ad91c.camel@HansenPartnership.com>
 <CAFhGd8pg78F1vkd6su6FeF3s0wgF8BdJH+cOUsUdqLmuK6O+Pg@mail.gmail.com>
 <f8b8380bf69a93c94974daaa4e2d119d8fcc6d0f.camel@HansenPartnership.com> <784db8a20a3ddeb6c0498f2b31719e5198da6581.camel@HansenPartnership.com>
In-Reply-To: <784db8a20a3ddeb6c0498f2b31719e5198da6581.camel@HansenPartnership.com>
From: Justin Stitt <justinstitt@google.com>
Date: Thu, 4 Apr 2024 15:47:05 -0700
Message-ID: <CAFhGd8r1gGCAbsebK-4fD+cPeUCMgUG_XTx5fKa3cqJwNEEM8Q@mail.gmail.com>
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Charles Bertsch <cbertsch@cox.net>, linux-scsi@vger.kernel.org, 
	MPT-FusionLinux.pdl@broadcom.com, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Cc'ing Kees.

On Thu, Apr 4, 2024 at 3:33=E2=80=AFPM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> But additionally this is a common pattern in SCSI: using strncpy to
> zero terminate fields that may be unterminated in the exchange protocol
> so we can send them to sysfs or otherwise treat them as strings.  That
> means we might have this problem in other drivers you've converted ...

Correct. Although certain conditions must be met:

1) length argument is larger than source but less than or equal to destinat=
ion
2) source is not NUL-terminated
3) sizes known at compile-time

I think fortified strscpy needs to be a bit more lenient towards
source buffer overreads when we know strscpy should just truncate and
NUL-terminate.

Kees, what do you think?

>
> James
>
>
