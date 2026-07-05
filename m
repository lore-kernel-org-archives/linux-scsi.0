Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AF884039
	for <linux-scsi@vger.kernel.org>; Sun,  5 Jul 2026 01:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783214127; cv=pass; b=jiW6651nmX6ovkzITyVSFOdUhPAIybdmZ1bggrKp6BOVYdCv0MvsUEj3CQP0/kRFvOQ97LmDks9SngJWX14EmMlzcvwZfNnoNVh9WXIHMMauybqgeiG7+qgMVDPrxGJ5ep5A/vRJJ9NuruGhoRgQcSsBNbRMFBwx9QN/RpGhQAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783214127; c=relaxed/simple;
	bh=fu52nWRAfvbJOjjjHZtpe+DWPq9bPj46rcQujrydYqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pZ9ba9ur8zBAkLCoe3yU078Ne8GNNkd9yjw3n9JiBVdEtqTSQJn3DsTV/GnhD1BBqo7yLyX5bYxgpbz5bmnhEBnx4H8W48Eko8TFiwcWhtQsnYHK34njG/qrfO7Ag1NCV7IRtjqzRkYzQQdxe0MXnHw/mrEQRcxEkgnDkS15V+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZxFksGi8; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxFksGi8"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-697564cb69eso3549593a12.0
        for <linux-scsi@vger.kernel.org>; Sat, 04 Jul 2026 18:15:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783214124; cv=none;
        d=google.com; s=arc-20260327;
        b=KNywrtDZIyrDJCJxpnCikRnJsyRowOeQWgvbAmBOVSqQW6Uphm8qVsI0EF/BAYjNbp
         EI+RmVLJnU/5s3+oK8fjOMjzaAKUUu2Q/cQowqwbFTwXfI490x/eoCpMwS5w+cSC3YmF
         l4M50XRzkAC1h6CCR0M/QMEkAe0l87BYzGxTJfLVPkPlNl/cxXhW/gKfIIQpuxtJKsmI
         dKYt9oj6+Ngr7D0rQ56NosY94TaY5LccbW5FU52yY9JXYQMDi7G4UxGUZY8aY0UemNst
         a0p7XtCPG1skx/4tjiHCbfxRNdDearAk60t1wO0vscp+3WGueQYKDNMjy+oHD10+QA89
         +dAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LaK13aLkN8e0SdSWT+I2LcMwsTBnQrpte2CYPZfNQKg=;
        fh=LoZMaYcLtMSZfIvykC4/BeuHV9I1+xgtoiCPfakDtYI=;
        b=E3tqkLxidmAWEFqMTIFN+Vr4zld+jUQE5/VNKJw4sOpVL40CSTVYYEp5XQ317sLhQm
         W8puiTiRdBowHXbzisjvzFgcQMLkpkYEQVnMcLHJpHp4qMl+0c3ozFPfDPsY+mNZyNP+
         UMn8Jm5tSok98ggNXPBO0x2fqu84iNY8kdSnuuKqYZ/AYhXnWoBk7TW0zqleFbHvVojl
         IBR7PRUx/F0hy9xDVOJ4+U7yl9WJUgzmH5aLQWeHLHakyjn0ElG+C2xqQCBwVgKgf0z6
         Ki74sUrWQ5H5cY5hOGSxA14rPS7zwKFjy1d6BReDt8j0w5gKKcTA5m0Ovc3NVjepsqOy
         NESQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783214124; x=1783818924; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LaK13aLkN8e0SdSWT+I2LcMwsTBnQrpte2CYPZfNQKg=;
        b=ZxFksGi85wIhN/SHPXP90OaWPxgKpEpX5aKL/A2EDwUUkJD6UKH0kvMe+HvaL2K4ED
         RSvMzxJ4sv20YhLLin74CHoJPCPu1LTMZD49diEBfF+QC3oRpQ3zS9vf1Amvtgg2Zgor
         duRGNlwiRM/g/mUDMrbTKXBF650GWmqlFvA0f5neOGbidfpRRarMBQ8HGm8A7/irSvDg
         Fr/0JKovQrr25z+bFqMgEqlDMkTy/YRoDDWi/4shebhuybblsXO/zJ0vnsg8k8eMvtsz
         EI+hZbYwqXYHPVsJvpjR4jte+RLhKW6ZjvyBmBmE6kPPbF01OuNYctqYRRMxleHY5g82
         ISuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783214124; x=1783818924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LaK13aLkN8e0SdSWT+I2LcMwsTBnQrpte2CYPZfNQKg=;
        b=qQvX0IgqzhiOEtAiIDS9nzH1mqTTD8UyrlHW4crC/iyg5VoTfNP12vnmT9BW4PZ/+y
         ndtkgXEs/jC2kVErM15YyESRw84pclD5qbnUjgQRFd0prsuUNbKENQjUBxafXnvKKffy
         upkqss8+BaAXCVFJPaVvbZnVnE61ArRrC72Y+eYntmmcPI8JD0y9kuW6tPhOYXo98lMq
         bodykj4x8a107GndNdZSF6a9hQMdVc5NQFY0IDLBjMBcnaj6BuT6SE/Ieuk8wIOevnkU
         d/poJQSESsM4D5rpwqD5U/ttC05Gs4+e549ylEnTEjQRggnonZMl6DauzSfcp7v3Orbx
         L8Og==
X-Gm-Message-State: AOJu0YzMtPxZSYIy2c1lGbmDdR5525dtA5ADsyUWYiPBos+WOd6h6+o2
	DTBbCMXT3gG9mTbqU9LtnqXiG2wygNmCm38gWuIa0GmH6kJkehocYCQykLZh1E2P3yZs/oINMEs
	gwyQIRLNYXgbVJisk6QmPiVV+M+zN7KY=
X-Gm-Gg: AfdE7cm/wwj9zs+aiMKCeAmdYOQoN8N8JnnUT+RrC7eISRkD607Nz8mqm/oDC6JoNnQ
	+FA/QaCldyRESoD73+gaSD2iGTRrlSyFLyFqWTtg/aKkip3ULaVpMkQfVJIYvU+4+dExMO4qOmh
	aEvfNqxAiWWFpSY3jOxWxnaTdgO/CORSl+/y669wEPKNgbEKvADEwWTcmW0hRXocwxkn1vpbgmE
	VwEKC5C7hZkVXIvMQHFyz4Pnv49TgXgpvbsPeqkbyW9GzYe+bSDX9AMFjNxhAqhoM1aSurR+zNZ
	g19383Q0uRxXDME1BWk7Pr8iec+Pmw0EGyl7g6s7tkH1I2yIE2Qqj8Po1oz7o0Ji8mCHNdkegOd
	jGgNtDQNXD6fg/OIkrKz7n7CN9/Y=
X-Received: by 2002:a05:6402:3509:b0:699:728e:48c3 with SMTP id
 4fb4d7f45d1cf-69a1a268a37mr1383169a12.9.1783214123945; Sat, 04 Jul 2026
 18:15:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260630012101.1461335-1-rosenp@gmail.com> <17d381fb-1f91-461c-8315-1508ad0c1efe@kernel.org>
 <CAKxU2N8Be1XxVznSrV1KGWOyivNEFJjojd2KRXLguLYZEB=gYw@mail.gmail.com> <bcd2926f-66df-4ffb-b0f8-97323cee5d94@kernel.org>
In-Reply-To: <bcd2926f-66df-4ffb-b0f8-97323cee5d94@kernel.org>
From: Rosen Penev <rosenp@gmail.com>
Date: Sat, 4 Jul 2026 18:15:12 -0700
X-Gm-Features: AVVi8CfqgxoDtZMU5hXXboA5liZptgivCrsoo-QDoE7T9b9FbUG6zUBlnlxJwf0
Message-ID: <CAKxU2N9yrL+nz1MOrnin49s-ew7jFBW2VZ3TN0O+SR63FGpT0w@mail.gmail.com>
Subject: Re: [PATCH] scsi: st: use kzalloc_array
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL HARDENING (not covered by other areas):Keyword:b__counted_by(_le|_be|_ptr)?b" <linux-hardening@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 4, 2026 at 6:08=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org> =
wrote:
>
> On 7/4/26 04:06, Rosen Penev wrote:
> > On Tue, Jun 30, 2026 at 12:28=E2=80=AFAM Damien Le Moal <dlemoal@kernel=
.org> wrote:
> >>
> >> On 6/30/26 10:21, Rosen Penev wrote:
> >>> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> >>
> >> No commit message ? Please explain your reasonning, because I find thi=
s patch
> >> incorrect. See below.
> >>
> >>> ---
> >>>  drivers/scsi/st.c | 12 +++---------
> >>>  drivers/scsi/st.h |  3 ++-
> >>>  2 files changed, 5 insertions(+), 10 deletions(-)
> >>>
> >>> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> >>> index f1c3c4946637..31ae189b18e7 100644
> >>> --- a/drivers/scsi/st.c
> >>> +++ b/drivers/scsi/st.c
> >>> @@ -149,7 +149,7 @@ static struct st_dev_parm {
> >>>     mode counts */
> >>>  static const char *st_formats[] =3D {
> >>>       "",  "r", "k", "s", "l", "t", "o", "u",
> >>> -     "m", "v", "p", "x", "a", "y", "q", "z"};
> >>> +     "m", "v", "p", "x", "a", "y", "q", "z"};
> >>>
> >>>  /* The default definitions have been moved to st_options.h */
> >>>
> >>> @@ -3973,21 +3973,15 @@ static struct st_buffer *new_tape_buffer(int =
max_sg)
> >>>  {
> >>>       struct st_buffer *tb;
> >>>
> >>> -     tb =3D kzalloc_obj(struct st_buffer);
> >>> +     tb =3D kzalloc_flex(*tb, reserved_pages, max_sg);
> >>>       if (!tb) {
> >>>               printk(KERN_NOTICE "st: Can't allocate new tape buffer.=
\n");
> >>>               return NULL;
> >>>       }
> >>> -     tb->frp_segs =3D 0;
> >>>       tb->use_sg =3D max_sg;
> >>> +     tb->frp_segs =3D 0;
> >>>       tb->buffer_size =3D 0;
> >>>
> >>> -     tb->reserved_pages =3D kzalloc_objs(struct page *, max_sg);
> >>
> >> reserve_pages is in the middle of struct st_buffer so you cannot use a=
 flex array.
> > This patch moves it, no?
>
> Do! Completely missed that. Looks good then, but please write a commit me=
ssage.
I sent a v2. One bug with this was I forgot to remove the kfree call.
>
> --
> Damien Le Moal
> Western Digital Research
