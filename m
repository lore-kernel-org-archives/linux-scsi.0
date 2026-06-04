Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0D5355F5F
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 23:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780616853; cv=pass; b=SzJvC7tVaPiKqkgZX3ULEwajvEk8fcEvaNQSre7XehVig9xMoG+fwTVNY5vKuj7Gwxux2LKRBrpXXUZE/RdSxJ67p+uSckng9xDBA8+HYKtuK9wddzMS56e11zXexyhTeusNaoLghpNLQh69GcsfC1nKNy5MNEcuwqqgohoo8pc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780616853; c=relaxed/simple;
	bh=biIxAk+6odobKkfmCAx2K1/eRar8yr8TI4Z/4RRvvwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iALkeBiar8AA0eP39AOcY7hrrOgk6PjFhbt7bZXZNPe1ZuLgsaAQ8EJkmKs3ffHb6QnF+q86KvBnoYtNEXb8CDiOOkuGtlsdq3gyESgXu4wA2ahfsM1AAVt3o2wW8F1I7J521LmDMxfaTkWWKsQpcVe9Ox7lfI7IDgxyhEl4yHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=U9JB4WSH; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="U9JB4WSH"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5aa7a7ad4d3so1055697e87.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 16:47:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780616850; cv=none;
        d=google.com; s=arc-20240605;
        b=g9N0VN+KJbdy8c2l6vWwNa5UI12edm7DlIGmDTZP0qokZoSrqDdjOTV8O2Xw9VpwXf
         cjY5YoF2WMG1BB+6Kc5BzjtVw8QTOddV8iynX5xZXCJksHSEcW8f7PROf7ySpqynyiHn
         Gr1oZwIbnFciTADvXmgXPLDadMoL6XMZtx9vWy2UFBt7Q+vPmtBI4dfN+AwbnuIzKe6c
         pytA3xpAe5EwVSgUI1vcoK3xowUOKPyGFBJaNm631aoBf1/Gt7vfb6eP4Y7ai0TojeIu
         m63p1G5J1TEMXszXYnYpdWAv++Ufe+BJjImtmcpuWszaIIgHo7bRcbx3qU4c76Jr0y4y
         pI+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4etXzWJuSqceR5kMD0xuPCm3358nSlE7U+Eq4Mdardw=;
        fh=rnb7MjWsTwSriPQPZqVE1YGi3BIu2FnREoAEv9526AA=;
        b=XveYkBcEldUDbIItmNroavj2JHhweMl+KZ1ysK5pkqbl/CQCfUEPmKiKgoMA4NTj9t
         Tb+Wsok7fGCDCtKxWXPFA57kdBr/PACgFq3wygdLF3UzRH9UKrjNaW9uox+0Xe2cNxWQ
         hMjc0Se0lEOGgnNx2qEa9AleocuC0v5tmZGGJa0cm2LPUSC9zzfK1zEjkEwCc8MxYYUW
         a/PLiKp+++G93I98JPej0m5uA83LBGo2pFmZksvK2m/UDQEI/trrWYfsZ3bsl8biCPBs
         XqNQ8F7clQnfdGhcn1JUS37KH2XqZCoIr2rRixan99i0IGFjvGW8cLJI69A0yNshkID+
         /hLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780616850; x=1781221650; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4etXzWJuSqceR5kMD0xuPCm3358nSlE7U+Eq4Mdardw=;
        b=U9JB4WSHlbVrY68gVWctM7HkFcuCgsyYvzK03Ce/nf7kvNgjg8jBCQkLviWf6pW6Ei
         RCSMCdbl4UvxG/1hF8NUuLFWMlcNDa81Uo3OnzmvFZkYOBJE2Zy5TQabgJE+EGAYl9ak
         jViiS1Wm6CgPiyUQWehH1kpfd01daRSa5ihXTiGGW+WzjZPhlzRvzFAD92pMNVrD44oU
         0mVmI6R2wAYfwfs1elv5fVoB/hSLDjGAD5VuixbhdYuwxBckuSSUTNtI/bw1qRJGbPkD
         RyhY61nJota/8MNcDf/g8YryOC+lp5Q9x9uXTbhVseaONHwdxZm4JKt8IcJ3l8GdhSo6
         49eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780616850; x=1781221650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4etXzWJuSqceR5kMD0xuPCm3358nSlE7U+Eq4Mdardw=;
        b=rusJYzKholcwj3luYOiLsjEuwVCVxUcZO2calnwXO/B/pOyOUXYyAi3ylJUunDRjsi
         Ph2oFLSeRwtcmBHZqQ+8comODWKq5ezzACQCTQbt6gCXyOqsGJf+D3ykKTtDQhJzQC/G
         wF+B5TWFr+XAsVRnHbEZE4AtzKer7EGzvkSQs5wvCF3+ammR9waZ4EnlKYKrWSFkqRTd
         Zg99NXlECU07h/s3+EORO98UO4+4hgh1mZEkN5tYe2MxIAyWB5PF3KyApq3rpRyGYGmq
         snLMMxb+XHriwq3HMS/m034u/IwnDKJKri5gKbU5kzj4U0glDQmQE90r7EzI3XK0LoXZ
         ELwA==
X-Forwarded-Encrypted: i=1; AFNElJ+eDwWpVx51cIg/ddOCGjNBajVuGxT3KW4Vs0Y7/PPOLzod6KsF6EgzFZC4mpO03Ubea3hVGGaF6gUt@vger.kernel.org
X-Gm-Message-State: AOJu0YysGPHHR1EZVQInpk/HsGRl/8deJ0DDDJIYxUO8KB2d3XeugpCR
	1T0pawhqeqwPR66X8nr58v3RXa1WQib/WqUnl8BIDcVY8VRGM0gG7taKHC8U0U+sYD2dpSKrqdT
	37IUajr0q1hwNMPER9wj0Gvupwm6Ty0S6QC5sY6NGgg==
X-Gm-Gg: Acq92OGviuWSubVt3wJQug3tPK3cLXhHHCC3YXGS2hURW/2gEKHJOe+LwUfDmRQSilg
	y1SBBV0TXP1H6fboWJTNEUMu2Tdku4ZAw/QT+KwPkl7H10VggIKi6+LdO3+f9uk7a+qw6Zt3nCH
	JTFQi3iz1AsMWlaxIBzb7sm8vTOiG7BqqlnWbnCbuRr+52jGqtQok49XYkUDtlRxWDqsudmp3qh
	lNfR1uNqhyLqCMnw1YXMt+pPTv9B26x4U3JqMNkMza+BuXjdHIAhsmIFq2pQ3oO+NKPijQnbDlw
	SRdgkU65vMbdm7Sm
X-Received: by 2002:a05:6512:3990:b0:5aa:6ede:62 with SMTP id
 2adb3069b0e04-5aa87b521dbmr269910e87.17.1780616850140; Thu, 04 Jun 2026
 16:47:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260603235616.124535-1-sam.moelius@trailofbits.com>
 <6d2e78e6a5840f5892e7eb081657b23aa62bc50d.camel@HansenPartnership.com>
 <CAE+C+DbpB6UP29WTNGgrnYqhazEC5=5ErNJiChrDz8sygC_-0w@mail.gmail.com>
 <4A3BD9E5-21E2-40F7-9242-71589477F2EF@kolumbus.fi> <c56802d9d3f05635c5b126687d0351a647801a77.camel@HansenPartnership.com>
In-Reply-To: <c56802d9d3f05635c5b126687d0351a647801a77.camel@HansenPartnership.com>
From: Samuel Moelius <sam.moelius@trailofbits.com>
Date: Thu, 4 Jun 2026 19:47:18 -0400
X-Gm-Features: AVVi8CeqTYFDPYKHxRDZW89x5Vz_VZEpg3kCVJq9TSc2oktx-wK8ucq3uxn4cKA
Message-ID: <CAE+C+DYFZ8qRn1c2RL6g85rYvfX4n999GR7oL1+LD6aFgDP5Ow@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: scsi_debug: fix one-partition tape setup bounds
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: =?UTF-8?B?S2FpIE3DpGtpc2FyYSAoS29sdW1idXMp?= <kai.makisara@kolumbus.fi>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	"open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 4, 2026 at 3:29=E2=80=AFPM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Thu, 2026-06-04 at 22:14 +0300, Kai M=C3=A4kisara (Kolumbus) wrote:
> >
> > > On 4. Jun 2026, at 21.33, Samuel Moelius
> > > <sam.moelius@trailofbits.com> wrote:
> > >
> > > On Thu, Jun 4, 2026 at 9:38=E2=80=AFAM James Bottomley
> > > <James.Bottomley@hansenpartnership.com> wrote:
> > > >
> > > > On Wed, 2026-06-03 at 23:55 +0000, Samuel Moelius wrote:
> > > > > The tape setup path writes partition metadata one element past
> > > > > the
> > > > > allocated tape_blocks array when a one-partition configuration
> > > > > is
> > > > > selected.
> > > > >
> > > > > That corrupts adjacent state during device initialization
> > > > > before any
> > > > > command is issued.
> > > >
> > > > I still don't get what the actual problem is.  For a single
> > > > partition
> > > > tape I can't see where scsi_debug would actually do anything with
> > > > tape_blocks[1].  What is it that you're seeing when using
> > > > scsi_debug
> > > > that motivates this?
> > >
> > > The bug is a kernel OOB write. I can share a PoC if desired. The
> > > PoC
> > > sends this SCSI command through /dev/sgN:
> > >
> > > ...
> >
> > > Then the bug: it initializes partition 1 even though there is only
> > > one
> > > partition:
> > >
> > >    devip->tape_eop[1] =3D part_1_size;
> > >    devip->tape_blocks[1] =3D devip->tape_blocks[0] +
> > >                            devip->tape_eop[0];
> > >    devip->tape_blocks[1]->fl_size =3D TAPE_BLOCK_EOD_FLAG;
> > >
> > > Because devip->tape_eop[0] =3D=3D 10000, this computes:
> > >
> > >    devip->tape_blocks[1] =3D devip->tape_blocks[0] + 10000
> > >
> > > But the allocation has only 10000 elements. So this write is one
> > > element past the allocation.
> >
> > OK. The bug is not initialization of the pointer but writing the
> > fl_size using the pointer. Good catch!
>
> Isn't the fix actually to allocate an extra block for the EOF:
>
> @@ -6648,7 +6648,7 @@ static int scsi_debug_sdev_configure(struct scsi_de=
vice *sdp,
>         if (sdebug_ptype =3D=3D TYPE_TAPE) {
>                 if (!devip->tape_blocks[0]) {
>                         devip->tape_blocks[0] =3D
> -                               kzalloc_objs(struct tape_block, TAPE_UNIT=
S);
> +                               kzalloc_objs(struct tape_block, TAPE_UNIT=
S + 1);
>                         if (!devip->tape_blocks[0])
>                                 return 1;

I'll send a v3 that uses that approach.
