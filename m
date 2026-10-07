Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A6D4AA40D
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 14:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791383549; cv=pass; b=A6rFN2DEW7yHrcW6BrI2WIWN9hsL6hntEtJsjfGRcx6l8trE7WhEIDT8ku8/SpUgjuYe5PiF2Zuf9rxwg+NaSbyFeWYDXaWUK1F+46Maj1VZ6zAhrpkoMTvdYKggDp6c3aT7KZ4ei3b7TrPqTctFs7MPuWvNXhxa2z0dPIWDESk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791383549; c=relaxed/simple;
	bh=kAAKOOjaAvYZaAHOUTCAOnLdyRNj6P0W/vYfaghxTeQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hwoLAcXu2V/ffMjixq641QYE7hA2hKNVsc0lX6DXedXayMBjsUdJSEsMENiLl4sZ0kgu25pOegp0XZ8XNm74Xukz1t21rv61DT4su/Yd1kJo1bamEcTvvxjHB7yD1BSFej9E3xjos4ydg5KncD5QLhfZFVN0sbe55jt9XaYYNtc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AuBMqsLR; arc=pass smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AuBMqsLR"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3516c82e96cso543008eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 07:32:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791383544; cv=none;
        d=google.com; s=arc-20260327;
        b=cQHVFYa+0ICaoF5Bj3pJS40mOXc331qdYdxyHHHZCSlAMwLDK0JJprTHeKZOjEmG9h
         vlQMGA1tF0DrokUNo8lIid+YLS5XPCJaEclWfIiQiWeEvzuTXhQvoDYQuwTnjJ4YK6Ja
         g0KZOOghopT6BPxcCJEgiF5w/0Hu42fiUtYi+ncHBzalFnR2dQPtY5ZFanLFUuMmttjs
         jDD2cSHaJ4a4tKrfzj9VjPqnpuL0boR6zO5aYQuH+EOLNu6OLv36wstC9d0JR8zLWx05
         7U0o4yVKKKgxsmBh6tgtOfwksEj7HmLPRBJOXMz7Li8J8r7DWKBFqy1Gsooo3doBqfhZ
         DqVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wNM9t3jtIo/GYt2tLLZSJbMvnD5utEjM7/ofYn8Iatc=;
        fh=ScG9p6HQAiJaabLyduXUk8iPzQEDojNFd7Lce9XYoA8=;
        b=gk6w1MRCupJQE/kGNT9dNvjsVTxz2xBB24PAMNsJ3dvXl2nSasI3XfgkAc3zwJ4M3a
         nSg+4iAxnUxICJg5EDZ77W905wzAk0zPvkF47bQHnuAvdIkdnIBuUBMrpPezZC46NKcW
         17X0cVYwExi490tz34GQjBMfMe4dtEC7+UhgT06ocbPSUryTo+ANqagrLLl+BGto32mQ
         dODML7qp+ctekYPqyPPpW0yd71ceEblYcNriKaXxaukRp6skaJfA0ttsQsRddQRQ2LkZ
         j4X4HwEHdaggwwENKFQlSEs2bxhnb7KEcm+fpU/zuOcXUfb8/oZ0ffssHdno7s5iXBnF
         4OPQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791383544; x=1791988344; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wNM9t3jtIo/GYt2tLLZSJbMvnD5utEjM7/ofYn8Iatc=;
        b=AuBMqsLRnAFKZ541w3KEN7pS7LQhd2VcpxgV2smpdAlvKF9Q7ulkIr/m3C3GBvp8J7
         ptJd8pR9R2Jfaffd6ZklXm2KnDiw8VqgWYsNCzI7LlL5RehTCWp45g9B/tG9hX3hkZ3w
         9KaKswHraPQC6ZHwOa2UJjvKee8pTyiI2mO8o+Q38nEQNx17Og/gGIunrzBDuNMuXdch
         sAC9Lel6GcirZx0AjqJUUdgwxJG1Rb1xP2FpDtivi7OsKLPsmdS0X5Dv5v3r9Ng5Uj9A
         XwDj2IgLRKKEuGEz318IFKiC8hI9HKiQSxihQ9g5Gg24sqzGuc1R2ZczHGnZq9/fm/8U
         +9Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791383544; x=1791988344;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wNM9t3jtIo/GYt2tLLZSJbMvnD5utEjM7/ofYn8Iatc=;
        b=GJZ76amjKoUqBHT7whscnDEGTXEgEFYS95br6G+tojJMwkgfHoDEZFnTXI2SjvbdQo
         uLROJaJBJ4nhocsVDL/qpkdI9kIyiqr6MAnLvN8As1UlHbsKJVTGK72r+ECWzZn55WwN
         oSXriHVRDuoLR7t+szxO3/C0OFgpkHygxpTnJ8WWb9zLdIPc82ZWdvYTIz2mmIPLlYjD
         7QkB4TbbAVfEo2wZ/TSeu2J5gvo8ev4OTTMpuyf2K8JjyUY2sPRRaFZhOnLFRItyDCSj
         vL5PnAFR5uVB0jQOhTGq23bDKcOIFKj0hg7Mw0vS1nkFbeXwzjmzjgyKFI7Vda6EhWEA
         MSxA==
X-Forwarded-Encrypted: i=1; AKwUvByBoNp7J+t1mjALsi3//xnOGwjoj8UXZQjGAd/YB17LvtqHNwWjPzUONhHeEEZtrLzzDLq+LY5ZPl6/@vger.kernel.org
X-Gm-Message-State: AFuF++nwx1rbCk2V4EvoKhoOY81GuaBTrxmY2Z1NleSZjTYU5KqwA9pQ
	DXdavHOTUVKJXF+xbiMDR+9zYizXzofHsDCNghDTIVjqy3psRMREMqQxbauRwN0uzEbz133BcJE
	pAvXY6oedJwLV1ovKRNOkucAJR9YzQ1j0W7fhhvFs
X-Gm-Gg: AYBFou3s8bDaZqXt2Zx9XQgkgDES/fP4g1PUB3SsEXN5pt9hwBm/ieSymcMxPhsHiOw
	4nmIyy5NmRlJTtwcGvIU0H1yGdD/IAHEUSyHO5lYtfXpv+p3OxG1R60crtyfmmg5uO4OpZCazXx
	Husfl/UXK0/bGPf9HPYU4GzFi1k/tv53mvMxL2lRTNLjCwjaAmQSbd3s+f89SamtBjl7p0HSjQX
	CRuFAZZV2A1Dowq5s+haHYkBlEha1wNdMK8xda2RofMGBTHzJhtP43nAexeczrdnOfr8svY69LT
	4AYL7A0mx1z2tjOzz9roBuN9RZKBi7teyMDt3FQ1ZQ2AKug2F8/l3TsaeaLPB/jeFU/ESC8GBYQ
	wkIA046uT9Nt8DkuXh3lZOg==
X-Received: by 2002:a05:701b:458d:b0:14c:d84c:7182 with SMTP id
 a92af1059eb24-16205ead94bmr2126585c88.22.1791383543226; Wed, 07 Oct 2026
 07:32:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791349129.git.bvanassche@acm.org> <765bf3683555f3d7fbe8510cde1eb50d5f6d0c6f.1791349129.git.bvanassche@acm.org>
 <20261007131411.GE30647@lst.de>
In-Reply-To: <20261007131411.GE30647@lst.de>
From: Marco Elver <elver@google.com>
Date: Wed, 7 Oct 2026 16:31:45 +0200
X-Gm-Features: AclHuK9avBQrZLO05u7yyi3tvHf6fXRKzgFjjrsP78FV-9q7VTnQzI8J5lXgpbw
Message-ID: <CANpmjNOUKf49YsujdfA-c553mx7G7+NWEPJjwNxCyTWafDZBOg@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] scsi: scsi_debug: Improve lock context annotations
To: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Oct 2026 at 15:14, Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Oct 06, 2026 at 10:07:29PM -0700, Bart Van Assche wrote:
> >  static inline void
> >  sdeb_read_lock(rwlock_t *lock)
> > +     __acquires_shared(lock)
> > +     __context_unsafe(/*conditional locking*/)
> >  {
> > -     if (sdebug_no_rwlock)
> > -             __acquire(lock);
> > -     else
> > +     if (!sdebug_no_rwlock)
> >               read_lock(lock);
> >  }
>
> Is there no way we can make the spare-style __acquire/__release work for
> clang?  That would be this and similar patterns so much better and
> safer than the blanket __context_unsafe.

__acquire/__release/etc. fake acquire/release functions do already
work with Clang Context Analysis. I spent quite a while making them
work because of patterns like above, and lots of macros which rely on
them. See definition of context_lock_struct() in
include/linux/compiler-context-analysis.h where they are implemented
(tldr; they are "overloaded" empty inline functions which exist per
context lock type).

Thanks,
-- Marco
