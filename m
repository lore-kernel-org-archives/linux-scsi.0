Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06F828505E
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 19:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783105608; cv=pass; b=A9KnC5XWqMVdum5FOTE/+tB8vcGOhmRxKBeInR5exjypvNwQqjutMV/XBVwYLtmWUenQyu6Oc3YfJvFvRXEnSIkD+0XZJryqrfk7Afnd71Zt/1Sh18B0sBTbhZba8tmi/Q3vgrnVq10SbRz6XpcXL3KVAKmEXH9qx23sVdrtVdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783105608; c=relaxed/simple;
	bh=k3RPGAp9TTWRVSnJ9yi69FuEbvcNRj9QK7W0Z0AxRT4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YgvXBwjaWWAlyOB81A/OCATIPtXX3Yn7C342FPxEboHt7ZOCc65uDmIdRFCoDymauoJqr4/IfD2tTmeOpJ0Oz/rmzlj65O/eRyLxRBwCLmOdKOPreMVQJSeeGVE1L9q9o/OhiUzMRfrl/vFHs0FUZQ0qE8czn1Ps4zDGals8TnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C1+29AoG; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C1+29AoG"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-691c5776f95so1629260a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jul 2026 12:06:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783105605; cv=none;
        d=google.com; s=arc-20260327;
        b=s+gGRm43McIaWrmMXw/R9QNwsmptpILP5LoWf8zlNiSR7UdNudkNL0xwUDM5qYBYIn
         rOxyc/WeE9lq2Qghae92ruW1me57WWm5YcC9mv+X3G8suHfxVzKTiQO/dWd2+pae2itu
         HGMx5w2tfQqUGwU6qDpMku3bmb8uB5wSCa+HnY4GTf4x1biYe+P95wS65NZC/3PI4/LB
         dLwg76JjIvhcmx8d3FbULaKiKQOPC+KfU8+tVgew6Nw+ibQAwolyS7jjWk6KNXLzYuk3
         TiKSOUreWh8AygGT7MHXyRYDQp5Q3P1MI4tUvRtBHYDCNqrGIwr1Y31o6zsJXWsfyc6Q
         eNIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ptCq+Q5Te24m3SA3JXj8jjJzYrmXyLCdMsPnUku3kEQ=;
        fh=LoZMaYcLtMSZfIvykC4/BeuHV9I1+xgtoiCPfakDtYI=;
        b=cyA2DwvHuazOE/8IdR/ixuK+Tteu2gEC+8EpXtmXbcENSAfpG7QK6cxkv120PtOxod
         OQALFGem484c+S5HEQhP6qZln7Meqe5Bxd8rl9pd3r0xfqljhC8f1siqyWYPPQMuTUJa
         bxj43YeBb0WdwsjrZqYmLxhY/iJZMwaXXNTj2I9DUk1Ix3TXlNRonpxVpDr/b+8V/ArW
         Q/8qR3zvqkflqJfjMGa82EVjTGBkpn173oYpDaLhk8T6QAVm400Gx/O7cwrCyx8nIJnc
         BQjvnxFp1m0FGAUtqiiwV6f2gKl/8kScZl/6W718olazq1XLL+YdUZ4j7VUpKdBJiG4f
         0MAQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783105605; x=1783710405; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ptCq+Q5Te24m3SA3JXj8jjJzYrmXyLCdMsPnUku3kEQ=;
        b=C1+29AoGbNWZUZsXzo5zbHIWpQ83y5fHbsz+wfq6fkRCwbvtAUqLyKty40QNx9ioVB
         YeT2mxWQ/lMuoFP+AzL2EjDpcJnbwrJXjR6cMBXhx2mAjjfOysZYlZrXYNRd4lPODGsu
         YVmmmycmqcqWNGRI2JKW05Qfw7oQoDytRi9GMrUw8mXYwcNmXwT9Dbo/sJRg2xLO8Z3Q
         1FbrMqMJgQ8t2AmO2xnUuu2A77RGphpIrV3/a2Ij5e7dIG0GMuRAu7dzcHAas/4SGPTf
         Dq5ofa4oaq2XjL4fHgD1EwM2jFQ17TDhCwvut+Vj0TGKzdfZWbTPCw7ZsPGjQVEbfwMu
         QfQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783105605; x=1783710405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ptCq+Q5Te24m3SA3JXj8jjJzYrmXyLCdMsPnUku3kEQ=;
        b=RGbZhWr5R+izzHE1iftWN5YJefFN9mq6+aZ9fY+cwmGiLZmLvinyuSE/RRoLxNmjG9
         0bpjnjDYxrccG6xSM3ZkJaex84CtJzeISMQAYkcAMLkTR7JtpCqck++298MfTO7JkCrg
         RMC34QeZ5S0DQF6u6VAvQsMfuntoCwnlGGS1Bi/e/furMyyaMer9TZEWFelCVZKizINo
         Df2PT02MT4RQhZIe4s3onFUt/oxvrRzLTCvgzcmDZ+3O3amgsMbQpik2FSYY/4TMZnTy
         gEWRyT2XWh6rArRwU4xGq1/RySde+JlH4hw4wFXCl9VjzM7Nu9rIPelm5DuJ23rlbXSm
         Yilg==
X-Gm-Message-State: AOJu0YwMpUcfVxC2uByilGQwgbaT+BMU4GkJlzaLYS5dWLpm5sjwv/HQ
	MGwtQJlFehGERmcUh7HNudJsm4VTnPItfWD4C6dVi+tGUY0E3UtyuXM/ENu2QPih97XvZ2Ar/1J
	+mBhSbQwUXiiBsj7AAcWgsnl1ETD81oM=
X-Gm-Gg: AfdE7cleYO+G2r+8Jd3sq4a2Zt4rwdhkWuSyluP1HwXDag65MQ/p0K7Wqfwt47nZC8u
	ZoCce5bR/vliEvAOGYM7pkRnQk6drFqswEXJluAb7bTDEhTmDfgQrGLbD8EB4cznZJSqKuL5pNP
	/KTFPoJMZOBmee/h1vHdO61XxcARDk43sFW8k1WmPMLtIimIr4I692DUR2dHeRHHKUABvX+IXMJ
	TvoDYnkRZl8opwm62P9y8Bfm61hdTtglHfn/uoBKJdBLqgEFD/M4DdH6GjnFz/cZzIn39GNLQcp
	WLneZfahpN6VrKoiiaK5zDpOKx9E3pBa6492sgnhUWMV8RaJq+TBZH90JoLFSPkHarkIESOdxdO
	6Y0JByPjNVi6vCzbKEBV90NTDRr4=
X-Received: by 2002:a05:6402:274a:b0:699:2448:be63 with SMTP id
 4fb4d7f45d1cf-69a1a273625mr189718a12.16.1783105605235; Fri, 03 Jul 2026
 12:06:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260630012101.1461335-1-rosenp@gmail.com> <17d381fb-1f91-461c-8315-1508ad0c1efe@kernel.org>
In-Reply-To: <17d381fb-1f91-461c-8315-1508ad0c1efe@kernel.org>
From: Rosen Penev <rosenp@gmail.com>
Date: Fri, 3 Jul 2026 12:06:34 -0700
X-Gm-Features: AVVi8CdaQFcBWDWlMOsDL-RbGTiwVSxCIdUvl5QYiWhT7_pjzoXOmEeBUlTudQ8
Message-ID: <CAKxU2N8Be1XxVznSrV1KGWOyivNEFJjojd2KRXLguLYZEB=gYw@mail.gmail.com>
Subject: Re: [PATCH] scsi: st: use kzalloc_array
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL HARDENING (not covered by other areas):Keyword:b__counted_by(_le|_be|_ptr)?b" <linux-hardening@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 30, 2026 at 12:28=E2=80=AFAM Damien Le Moal <dlemoal@kernel.org=
> wrote:
>
> On 6/30/26 10:21, Rosen Penev wrote:
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
>
> No commit message ? Please explain your reasonning, because I find this p=
atch
> incorrect. See below.
>
> > ---
> >  drivers/scsi/st.c | 12 +++---------
> >  drivers/scsi/st.h |  3 ++-
> >  2 files changed, 5 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> > index f1c3c4946637..31ae189b18e7 100644
> > --- a/drivers/scsi/st.c
> > +++ b/drivers/scsi/st.c
> > @@ -149,7 +149,7 @@ static struct st_dev_parm {
> >     mode counts */
> >  static const char *st_formats[] =3D {
> >       "",  "r", "k", "s", "l", "t", "o", "u",
> > -     "m", "v", "p", "x", "a", "y", "q", "z"};
> > +     "m", "v", "p", "x", "a", "y", "q", "z"};
> >
> >  /* The default definitions have been moved to st_options.h */
> >
> > @@ -3973,21 +3973,15 @@ static struct st_buffer *new_tape_buffer(int ma=
x_sg)
> >  {
> >       struct st_buffer *tb;
> >
> > -     tb =3D kzalloc_obj(struct st_buffer);
> > +     tb =3D kzalloc_flex(*tb, reserved_pages, max_sg);
> >       if (!tb) {
> >               printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n=
");
> >               return NULL;
> >       }
> > -     tb->frp_segs =3D 0;
> >       tb->use_sg =3D max_sg;
> > +     tb->frp_segs =3D 0;
> >       tb->buffer_size =3D 0;
> >
> > -     tb->reserved_pages =3D kzalloc_objs(struct page *, max_sg);
>
> reserve_pages is in the middle of struct st_buffer so you cannot use a fl=
ex array.
This patch moves it, no?
>
> > -     if (!tb->reserved_pages) {
> > -             kfree(tb);
> > -             return NULL;
> > -     }
> > -
> >       return tb;
> >  }
> >
> > diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
> > index 0d7c4b8c2c8a..759f4c43d563 100644
> > --- a/drivers/scsi/st.h
> > +++ b/drivers/scsi/st.h
> > @@ -45,7 +45,6 @@ struct st_buffer {
> >       int syscall_result;
> >       struct st_request *last_SRpnt;
> >       struct st_cmdstatus cmdstat;
> > -     struct page **reserved_pages;
> >       int reserved_page_order;
> >       struct page **mapped_pages;
> >       struct rq_map_data map_data;
> > @@ -53,6 +52,8 @@ struct st_buffer {
> >       unsigned short use_sg;  /* zero or max number of s/g segments for=
 this adapter */
> >       unsigned short sg_segs;         /* number of segments in s/g list=
 */
> >       unsigned short frp_segs;        /* number of buffer segments */
> > +
> > +     struct page *reserved_pages[] __counted_by(use_sg);
> >  };
> >
> >  /* The tape mode definition */
>
>
> --
> Damien Le Moal
> Western Digital Research
