Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D084B2DCBF4
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2025 15:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761320579; cv=none; b=PiwiPU0dDwKUVn7KWqP1bA6UiJAOl0UfKwCT2IyK5M1NFz19dLxUQ23KZgJloXjquIxXmPCF8TKhO3h7TwY8ltboH91K9DSHe+Rgqa0XWQMjGVddSLX86YYBC38Nd/VTBFmBG+Ak3TBFGCk21YeeE80w94LTuJidQ/23wDafrro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761320579; c=relaxed/simple;
	bh=Hsy5wkoKS0CFGE12T/+2vOH4BbAMMRrYk5XeYbvm0aw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fmh92l78IXBZQI4kmIILaxI4iiIXvGHyApMJ8U/A7tk0jW7IantBx2lQNLg58eHIA5sZ0dEysjfGvVRfIOtb4xb1pcstTzI/05vzRkkVChVwu0t4PKYBqniDemvqTdXTazV+EgYyZ516SF8Scw95RUgBszOJym+fg9EWr/8Hdik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PVRoEDMz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PVRoEDMz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761320577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hsy5wkoKS0CFGE12T/+2vOH4BbAMMRrYk5XeYbvm0aw=;
	b=PVRoEDMz+azVExa6usEDTKQk0LnGyGTQgbt2kAlF+eKtsm1YhhbJS2K9T+/+Uj9I/ZprW6
	Gl9FRwU/vimfccoNd1NcwgmTCO/wQubtzevVvYiOKp5U7KuxZ75tddHtnYpqKm2sqgwitL
	L1g7hvTSvGUn78rZya0GDl8Cp973gic=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-l51RgPDqPauOYjY3qzLCoA-1; Fri, 24 Oct 2025 11:42:55 -0400
X-MC-Unique: l51RgPDqPauOYjY3qzLCoA-1
X-Mimecast-MFC-AGG-ID: l51RgPDqPauOYjY3qzLCoA_1761320574
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-372932bf858so15372531fa.3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2025 08:42:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761320573; x=1761925373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hsy5wkoKS0CFGE12T/+2vOH4BbAMMRrYk5XeYbvm0aw=;
        b=jExB1WTLr8Fl2y2PVOXHB8EaFBH1o1Hjfi6CVLo8zi1s088HyjcTVpIMvf3lcRR/zT
         ls5xiovo+AiVlCRMoEqSo8p+fYACCunaLmBq4hwnS2+MwdAONXXqZBQIRP4p0i01AOqo
         4zT4QhQ5kzkJ3vWUkoyz3BAvZoJWxcsvN9d0NuAyg/7QDybWKg/NU/DzSJ1NeQpJJ5RS
         wn4PgKlO2fBuxKNtr7bxVS53yg/PciUDHYi3cMWE1Qm93TQyJVNWYkrwy2zTCink3Im0
         MKGd3ULMSV2VPDzPr8A8AFS/eTm0UAEnYIZHJtf3jOXszbDRCYnx7dz2d5Tv6xIjCa4b
         RG1w==
X-Gm-Message-State: AOJu0YzuYKTBC/LRQ4YUzeJGwP62opsSgDDeL6HdIxw6Nn/G5lLQD6sw
	KeWQr2FSKNU5/+X6NIGNlcWabmWESXX/6j2lq6LTiTzoWfUYWD8dm9knjjXNPiBp0hum8vVe/8g
	szHwegRxw+/npW2Watob86tv2PzJ3Rpiw9AWbRfkLerInAA/UfslU9fVvvNQqaWlgAB/36AX0cJ
	LqRzukl+mshb4ZMXuFlhSQDUL5L4qtu7fcnLqkvaOrzp71sg==
X-Gm-Gg: ASbGncvJKN9kRa5eglOohpElZqUy0WJJvLnV+NAQ3DCF4EyFXM3q67S+2DGLpn4+KIm
	O9M07bn3foNPaDE9M5di6x97o1o8c5SzzEHxBHok4c9SuEtZ05SUE2tVngpo0km5S5TLOm0zOAC
	IcAfYsxUToRe4026nBSEEDBGFmT/1R+iSVgVSJBmivH3WmpPKV/iXhlA==
X-Received: by 2002:a2e:be27:0:b0:36d:54b3:9f71 with SMTP id 38308e7fff4ca-3779783f84cmr94583931fa.1.1761320572982;
        Fri, 24 Oct 2025 08:42:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJuD9NJopLVWzUxnCINbd/At0jfbqhknd0a805IqAZHKlGMtJ5lVX2INT/8ZuwHh7j6s3Mw8NR2a2NS4Y8qeo=
X-Received: by 2002:a2e:be27:0:b0:36d:54b3:9f71 with SMTP id
 38308e7fff4ca-3779783f84cmr94583831fa.1.1761320572501; Fri, 24 Oct 2025
 08:42:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251023140531.5197-1-djeffery@redhat.com> <1D000F1D-7FE1-434C-AAB7-DEFF0FDD4106@kolumbus.fi>
In-Reply-To: <1D000F1D-7FE1-434C-AAB7-DEFF0FDD4106@kolumbus.fi>
From: David Jeffery <djeffery@redhat.com>
Date: Fri, 24 Oct 2025 11:42:40 -0400
X-Gm-Features: AWmQ_bkg9FSFx_UEChtPYWK0lvZToODvpxCVPxwaIF63Gq4lWHAbCie4KfbGD2g
Message-ID: <CA+-xHTEibYoSbmBN-Qx9OoXo9nb75AQbivOT6Y-FKVUEAEWKRg@mail.gmail.com>
Subject: Re: [PATCH] scsi: st: skip buffer flush for information ioctls when
 there is no buffering
To: =?UTF-8?B?S2FpIE3DpGtpc2FyYSAoS29sdW1idXMp?= <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, Laurence Oberman <loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2025 at 7:58=E2=80=AFAM "Kai M=C3=A4kisara (Kolumbus)"
<kai.makisara@kolumbus.fi> wrote:
>
>
> > On 23. Oct 2025, at 17.04, David Jeffery <djeffery@redhat.com> wrote:
> >
> > With commit 9604eea5bd3a ("scsi: st: Add third party poweron reset hand=
ling")
> > some customer tape applications fail from being unable to complete ioct=
ls
> > to verify ID information for the device when there has been any sort of=
 reset
> > event to their tape devices.
> >
> > The st driver currently will fail all standard scsi ioctls if a call to
> > flush_buffer fails in st_ioctl. This effectively allows ioctls which
> > otherwise have no affect on tape state to function as an indirect metho=
d
> > of flushing buffers when the tape is being used in a buffering mode.
> >
> > But this also makes scsi information ioctls unreliable after a reset ev=
en
> > if no buffering is in use. With a reset setting the pos_unknown field,
> > flush_buffer will report failure and fail all ioctls. So any applicatio=
n
> > expecting to use ioctls to check the identify the device will be unable=
 to
> > do so in such a state.
> >
> > Instead of always failing the ioctls, allow the ioctls which will not
> > otherwise interact with the tape to bypass the call to flush_buffer if
> > there is no buffering occurring in the st driver.
>
> In principle, the driver should allow after reset commands that are not
> affected by rewind at reset. In practice, there are cases that have not
> been handled, like this one. This is, however, somewhat nasty case
> because st has to know about the internals of the scsi stack. But,
> something has to be done because this is a practical problem.
>
> Your patch should solve this problem, but there are some things that
> I would like to address.
>
> The patch includes a huge jump over most of the code. This makes it
> a little difficult to understand. I think it would be better to handle th=
is
> condition locally around the call to flush_buffer(). This would make it
> clear to see what this does, without having to check the code being
> jumped over.

If that is your preference, I have no problem with changing it. I wasn't
thrilled with either location.

> Another thing is handling the non-empty buffer. Could the patch just
> skip flush_buffer() unconditionally? I don't like to have code that
> mysteriously fails in some cases without a clear reason: why can't one
> ask the IDs even if the buffer is not empty?

I originally wrote a version which worked this way, but discarded it out
of concern that there may be tape software which expects the current
behavior and uses some of the ioctls as an overly clever method to
flush the buffer. The flush behavior has been there a long time so I was
concerned about completely removing it and risking breaking some
other application.

Perhaps my paranoia about changing the behavior is unwarranted. Do
you think it best to completely ignore any flushing or buffering for these
IDing ioctls?

> This problem also provides an opportunity to slight cleaning the
> code by moving handling of pass-through to a new function. The the
> rest of st_ioctl() would then just concentrate on the MTIOC_* ioctls.

st_ioctl is quite the mess with how things are laid out. I can see
about making a version which moves the handling of generic scsi
ioctls into its own function instead of adding to st_ioctl's complexity.

Thanks,
David Jeffery

