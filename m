Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710131C1F22
	for <linux-scsi@vger.kernel.org>; Mon,  9 Jun 2025 07:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749452987; cv=none; b=YwE1SW1lTAs2jZTwX7tQZK+0IJwZy5SrSc8R4HToct2UTBXwlNkilGND6EZAckh4w27i3dXQPm1hgIEOWC6BBWsap6I6iAOP+eSakHAAq7y6B5h9Eg89byXjm7+a4LxrQze30UY2erh3KNCJmZvlyXaRMXv+4+IeXr7xM+ivXzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749452987; c=relaxed/simple;
	bh=FSDpt+soB+kJAc3aAHvBnNWXf23kg39FCCz/ToPg2RU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t89AhoYDsPnwM1N4aUtWWNypMA43T6gokWP0Bn6mNTkPXFIR753TzxlHFcJio0viCJMkCiBCa31N0xHk7GFCRqTVk+ry/QNZG8X8PynXAs8x4H8V+l/FKlhXIw902J+3TlXr4TIa826IG56VJcaMuxUOoxrOn1CM3mJAqlSuj74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lZuTXxHk; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lZuTXxHk"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6fabb948e5aso42871836d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jun 2025 00:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749452985; x=1750057785; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FSDpt+soB+kJAc3aAHvBnNWXf23kg39FCCz/ToPg2RU=;
        b=lZuTXxHkyfMIOLwC9MswwrLYDWo0d5S4KKTK7B0p/NuQEfy9sfbKFYwYdM630GoGNM
         TFnVRDwBX2mqSrYe5S1Oej6Fn8ZfszxGF4X/PY/ETblg6Kv6NlY/43xbXRIfrikqxg/f
         vxtJ0Z43ldTtbDZ+mSAzJCgAhyA+Kl5H+0nfPiSPftZB4CXTlR+SlSL1MLwIdHnIOS1t
         HTbGMuHAhLIkLDxphpntTVJVCHg7vx8Rj+swbWeNRrG+EyshcYsOfzyCmVD0+V2zkuoa
         piHXtS6opnqYeZsgu2G0KJ8gpE8dnZ3CWs10FFtJJbATolXy9sEJ+B1Zc9r6c930g++u
         rtpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749452985; x=1750057785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FSDpt+soB+kJAc3aAHvBnNWXf23kg39FCCz/ToPg2RU=;
        b=GPfXdsWK9Tw2V/PoxB5WjDWmrOfPmrY/Ias5hDhLUYfYIe4M/qi4Pvj6/BuFoJmv7Y
         FSGIMzrrTJlajOZ9ErmuMKVYy30auY6iJtRdFKC6ZZ15Yeyp2eTH+R5W9JfxSWrSWz2C
         8KwaHfU+Nw9DSTYfJJjD8O01GSeirDxwjzJvPVVMmrpWBEwtK6MF1yaZkmrCMdmn0qUH
         FpMWdKwA95/2ZZNUKXFrpKrS6l6c3Sh5CBdHJTKeKTYKsJLv3JvjCW9S/wjCykIodYkq
         B79+A1SY5nj7fq//xlMaV3oTsqsDkKvNZwP4GY60wQrgZsHXH37rKMTW296dD9ndTLxm
         lntg==
X-Forwarded-Encrypted: i=1; AJvYcCW4GZeFhcoYtuRDfyzRQMeRG1bB+Q6Pzk3vM7dh6WADAux72GmT8Tl7J1amPjdJHNewhjk5V7tPeqlI@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl+bMLJcTr7wOTMde8VhGGlXDF1E30qU60fevGfU9FyN00oSl+
	BTjb9fAQHVlxI7gMW1+bCnb/RcuRpK5F2ftoTLshrZhUPkqfZiMydkU2TKdos8aF3NFmtXpNw3L
	jFXr2dcl8/aztbqhLmR7lpoY1y3ieUWs=
X-Gm-Gg: ASbGncs1ABvq8MH0/x8m8EXDMHh16i7/55QwY9e5rSiWfd+KK1Rze0tnygnCiAvwwsu
	lIDiPQrqqnnAn1OyfweOcuSiAEGYHTuTw1nL6esVcqMUUpXle4tAfJ86ywrCHyI1h3VfaJk885H
	jxqbVeSpdnLF4w5omCqowcCpKhbfCGm9TnczTqEQ7lEcDG
X-Google-Smtp-Source: AGHT+IEv9O5YgK3CppAzORYW9KFh0DLzC+syzKnM/PtyGYw3mtH7vr5CfNkkmq+OCVmoIdxjC9ptRQIN0c0PHd5d8pM=
X-Received: by 2002:ad4:5ce4:0:b0:6fa:fe02:8219 with SMTP id
 6a1803df08f44-6fb08fc6fa8mr214450996d6.7.1749452985349; Mon, 09 Jun 2025
 00:09:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606052747.742998-1-dlemoal@kernel.org> <aEZ2C93sEiFRzGEE@infradead.org>
In-Reply-To: <aEZ2C93sEiFRzGEE@infradead.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 9 Jun 2025 15:09:09 +0800
X-Gm-Features: AX0GCFuK49o41AbcT2ztweuzhQCz-bSY0VjklxaSb3cYyaqjjPCbEhY4BZkL94Q
Message-ID: <CALOAHbDmSjaBjG7-yTm4FOxwY-mhR0ea610ZyTb-TPzLZOu2Lw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve ATA NCQ command error in mpt3sas and mpi3mr
To: Christoph Hellwig <hch@infradead.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 9, 2025 at 1:50=E2=80=AFPM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> Adding Yafang Shao <laoar.shao@gmail.com>, who has a test case, which
> I think promted this.

Thank you for the information and for addressing this so quickly!

>
> Yafang, can you check if this makes the writeback errors you're seeing
> go away?

I=E2=80=99m happy to test the fix and will share the results as soon as I h=
ave them.

--=20
Regards
Yafang
