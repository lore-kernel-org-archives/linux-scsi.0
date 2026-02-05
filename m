Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780FD3EDAC9
	for <linux-scsi@vger.kernel.org>; Thu,  5 Feb 2026 16:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770309652; cv=pass; b=RcDhPb/oo3Ex/6JTQVIHVfds9rZdi5YctGfjY/kqyUNc3ul2RI9269YHru5sUJcRpoIjCWrkGkHD3KO6035UGwblxcXzHngVI6FQTmwV0G4smZWvtiKpAGpQBEckSjwbJVoIll1TIHBBZq/qUThCU3seeb8zjAPAKa6Hr5vec/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770309652; c=relaxed/simple;
	bh=xwzG2Ogh4J2uFhZawtzchjseHiH8POO4drcnSGr4eYI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UFvMfmrp/umN3KsQXn98vjNHQzcSww0wp22sFQKNYuKwLHDMqzAvNdrt2TvDYc6b1tpE1Zrnj680KCIXbRhBun0ZQQNWMuqIK668IWa1ISJVMBl8ydrW6Mdxtb1M6WoJZpIviRJMeL6dN3ibkOmkCLKOvcOiia0qXSma9KcC68Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=I7gIGQDG; arc=pass smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="I7gIGQDG"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-382f9211cbfso11094121fa.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Feb 2026 08:40:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770309650; cv=none;
        d=google.com; s=arc-20240605;
        b=CD/E4+0H4m4bdLTaJNe7VQOa6bfDIerZ1lf9kSB77FzITJZ8P+9ePujwiTAYug6hXy
         YXmHZB6flAedI3KR0PZKsXL5/4NrrT2VzhL83IYGVHBMQHMcr+/f0j4LqzOP/eqW6sqr
         UucA1leQcxWiZM3blXACOvUjOytFc/N+KsC/0ELVW6KZSpFOjdAAs4MBc7R3TdIvcJU1
         seiNhkrzOo3B/VBS7UnDY9sFLNa7D+6BWVm9snILldgmYLOb5jByNJvUyOJC/aegmqsq
         8DoS+Gy8e71eZzH9m2lXLuukln65G84xif++ThHGn+doovklVBFHzBPGv+zzhMJ6Jof1
         Y8yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j8o2goC0ypz7sAm3yTvsQ1LLpo4GKpdQO8NpPSiwx6c=;
        fh=yyEtXWVdb0XsFdtK+SjvkzP21tCOAkqBoG+RXYIyV0w=;
        b=cZcjSviJI/STYyZqXgprhszJWA0u5UYAL3IlowsHJlPj9xa61KEE0rAdZuYBrnhvoJ
         rA9ZWbBgs3nHs+n9HpEx/GhmR6InTMDK70F9Qhc77oiKF/xiWLftsmTU4GnqeWXNxBuN
         Jb8jZ5xaLFsLJrZxLbBB8DcshISuuT7N//zJzYXfRqwasFkuZDDMsOw3IqSzdbhrvIEw
         cAoLB1ZIIvUJcDbGb8Kkn74Rs5EXgNakIwa7f66JrFC6PyQwaLFdFs71Aho3Hcssy/MU
         5qC53ZioQ090cAbA2/JfIAnnwlUYt3hTJCAvjeCH/cCYSiabFugJwHjOyHr0iuEw2k9c
         Geww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1770309650; x=1770914450; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j8o2goC0ypz7sAm3yTvsQ1LLpo4GKpdQO8NpPSiwx6c=;
        b=I7gIGQDGevnIjfO3BC9CI7Y6QpFDKEaHHK9ja4EqIoCuHGWfasDEKHuF37GeN0iKp9
         pWmTBaCcVdEbyucTBQbBH10GOqnxAm8N4igijj7XaD9pwuU0je8UX/SkGUSaq8SbJiM8
         DEpPfQk3zfL5/QLKb03UazTWf9Q84BzOEx7jEpTb6QXdlI0en3/u5frmYII4zHOB9uDf
         WfzpUfXCUp4xiHR3JwUB3A43JxhGqhtNaF8vOvrcAxM5VtGa8OiR+EbivKzfDKez6ePX
         r1QKCcK6md2WlOrdzxr0Rp+uImMlI3w6y7VX58HTlYDmB5b5Co9ylG+spuVDWjNsGGkl
         MsZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770309650; x=1770914450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j8o2goC0ypz7sAm3yTvsQ1LLpo4GKpdQO8NpPSiwx6c=;
        b=gE1TWkSTzq4/jC1UpRltpUFHbFMSmUqjQF4dQAiCYTy36qmJyJVB5pZj081iNEjwOc
         URpFqT00KZYHJuFQ2Mf72CIRNi6TUEeypbsyhq1T1PzOHRkPkW3P5iuQMqu5375obgjr
         fYnV6R5tqo9ax/VNQhlO4JobPJBXCr1XhfNvLGZrhek87NAf8Jdy6qIxrlQvJQBPeCTG
         dZWTfD8fjmex7VmjDZMp8MPykacDjAXQmsvLY8W/8nXhuDBtF6OqfOuy+wEj/5YxcwTm
         TJBgob+IHo9MW2ZG6fGXl2UZSeCP0QX6A8enyGOY57193g9N/TOHNllaWgoM3Wx7BVbQ
         vY1Q==
X-Gm-Message-State: AOJu0Yza2QXckgQheV06FFkS24MDZ/wyuCoaZosT4W86j5UPiIm/7S+j
	lQUz1YF4WrN3inQ4tH2uPEXAAQr+6iSexDpC0xnVAumUKWr/b7IS26hn++pWOfodwhFZ0POPC06
	DW62dDE6caFgtt4oNnFoJKipLLKVXBt+P0P0hen6ElA==
X-Gm-Gg: AZuq6aLqP6J3LOGOLEvd0rh5TKvKesHTR0LP07+0lBFezqNigQqVX1J1KYFeXZ60fkS
	p3W9yv6871WFxzVA2sXlPb21eWTCQwCIH/YwDEtC048bvvY+uSHg1goIEmInTuKINjRY0QWRxfH
	XGvLpAAJLOP+spwP3kpwOvb14+SwARyseFPYHS5DcpiZcacfERgSs/yqiqlbgjE6d7JZRv8a+xJ
	7pi5xS1FT7yMKBY6X/KFQoceAvz7X2cZ2PD1jdCzvDzCJDHRc0J7S0nqpxTls96YejezpxTVa2A
	6hihoGzAP7YFF5Fz8vio+pRZCWTWj6vj9+jlPsDEBEViD7wA5XJiU1fO
X-Received: by 2002:a05:651c:31ce:b0:385:da28:1e4d with SMTP id
 38308e7fff4ca-38691e38f7cmr23240501fa.24.1770309649567; Thu, 05 Feb 2026
 08:40:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <32e620691c0ecf76f469a21bffaba396f207ccb9.camel@HansenPartnership.com>
In-Reply-To: <32e620691c0ecf76f469a21bffaba396f207ccb9.camel@HansenPartnership.com>
From: Haris Iqbal <haris.iqbal@ionos.com>
Date: Thu, 5 Feb 2026 17:40:37 +0100
X-Gm-Features: AZwV_QjmZRCeTXVDFflMu1LZl_ZSuoZx08sEIUmia56TUKmCgVvLJHiLQYSMHpw
Message-ID: <CAJpMwyg4Etv3qOw2Ur+L9YmWbt7Rw19uTs0=RsRtuORaEOoHnQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Documenting the correct pushback on AI
 inspired (and other) fixes in older drivers
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2026 at 10:52=E2=80=AFAM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> To set the stage, we in SCSI have seen an uptick in patches to older
> drivers mostly fixing missing free (data leak) and data race problems.
> I'm not even sure they're all AI found, but we don't really need to
> know that. The problem, that the submitters often don't appreciate, is
> that every "fix" has some chance of being wrong, so it requires code
> inspection (which is also not free, and which may get it wrong too) and
> testing, for which, often, no-one has any immediate hardware. The
> problems we see is that missed frees (often in error legs) represent
> tiny amounts of memory over the lifetime of the driver (they're often
> in the remove legs) and so we have to ask set against the risk of a
> wrong patch, is the problem even worth fixing? The same goes for data
> races ... and here the suggested fixes are often somewhat complex and,
> on analysis, problematic in some way. I've cc'd fsdevel, because I
> think you're seeing a similar thing for less well maintained
> filesystems.
>
> I'd like to see us formulate a document we can put into the kernel and
> point to when they come along. Probably formulated along the lines of
> "first do no harm" and pointing out that every "fix" carries risk and
> we have to set that risk against what we actually get in terms of
> benefits. So require the submitter to specify:
>
>  * What are the user visible effects (memory leak =3D none), transient
>    bad stats data, or actual data corruption or kernel crash (latter
>    being most serious)
>  * how likely (or often) will this be seen?  If about once a kernel boot(
>    or less), at this point if you have anything less than corruption or
>    a crash, don't bother fixing it because the effect is too minor
>  * For bad stats data, is there an existing tool that uses the data, if
>    not don't bother and even if so show it leads to issues
>  * How was the fix tested (to reduce risk) i.e. do you have the
>    hardware or an acceptable emulation?  If not, report the issue, but
>    don't bother sending the fix.
>
> I think this is just a starting point, and, obviously, it's a bit
> driver centric, but we can probably add generalizations for filesystems
> (and even mm and bpf).

It is an interesting proposal, but I feel the problem statement
overlaps with some other, already being discussed, or covered topics.
For example, the topic of fixes requiring effort and time of the
maintainer/reviewer, and the fact that AI now potentially leads to too
many such fixes is being discussed in the following link,

https://lore.kernel.org/ksummit/20251114183528.1239900-1-dave.hansen@linux.=
intel.com/#t

TL;DR
The submitter has to mention the tools used to generate the fix.
And the maintainer can choose how to handle fixes from certain tools,

+As with all contributions, individual maintainers have discretion to
+choose how they handle the contribution. For example, they might:
+
+ - Treat it just like any other contribution.
+ - Reject it outright.
+ - Treat the contribution specially like reviewing with extra scrutiny,
+   or at a lower priority than human-generated content
+ - Suggest a better prompt instead of suggesting specific code changes.
+ - Ask for some other special steps, like asking the contributor to
+   elaborate on how the tool or model was trained.
+ - Ask the submitter to explain in more detail about the contribution
+   so that the maintainer can feel comfortable that the submitter fully
+   understands how the code works.

The topic of how big are the effects, or how likely (or often) the
effects happens may just be linked to the main and IMHO an important
topic; availability of the hardware for testing.
For this too, the previous discussion explicitly asks the submitter
for the following,

+ - How is the submission tested and tools used to test the fix?

I am not sure if this discussion can be linked to the above mentioned
one, but there are definitely parallels here.

>
> Regards,
>
> James
>
>
