Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5FD25B098
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 18:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780598003; cv=pass; b=TLmwuqaz+/DwWHwMrKglNWVTxvO0ma7L5kQRjJwN8IZSEu6OFwp4s094uoZR+NA3uPu+r9B0kPzC2Awd4Y3uEaq3gQEt050lvgwVOcXVey4jmwqnrgI/vUVt132gNXTd5644CXLLHPURtHIVYyMvHDnbwoJeFNGnJHo34VBdsLU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780598003; c=relaxed/simple;
	bh=oMDSYTH3vXxx750YzjzDtvEQHOAZ3c0ZtF9U+ZOlB28=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nx6AnzM1vHH6yQlK5dtv9qq1s3CKjGSUOwiTVI4dfOUUgneRFc82354MMjeGeATT+JXIf7gG13v1e7mGSEnooHjsryEyLIhA5H3FcL78Il1z2EJFKcfSD7QXzo9XbIuYcVC9PFjcqEe1AxPHhm10v9UIKXoZfJzwv3vMKIXF11E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=czoly+SI; arc=pass smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="czoly+SI"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5aa5edf347eso711359e87.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 11:33:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780598000; cv=none;
        d=google.com; s=arc-20240605;
        b=TuLRwss1L+PN1OXjqRiurE+jedSp4i/j00jU8ZOe5ufGrlAVVxhMr+Ny4ysC0/Jugn
         ltjatPwr23xFvTCSfV9pHKzyugBVUDh8bH7dg2RF0yWE/qxh6wSuOyOIFIDEj5leP9Hw
         kyciPD4oP6nhOvyYPdcwAhT1/8YOEmeWdtxx/aFea5FzYtzEzI6OD1jD10H0tZY764CI
         aKwXUMvRbRqsnDqBHbYfDw5lFAqFjS3T57SSPmWlbyS1hWAdWGuOzF/VpHwNRA4ZaETi
         /aHoWUNf7bsqe8Ejdwn8oTCyvH+bM86idtX6ukZpuVH+aV6im1phENbQHoyU6S+5LKA9
         Pwdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FMBBNVyyWUX8SOTnPk3dJHwEcA4PwzlXJ8JPotT6/PE=;
        fh=EBeU+Ep+lvgSEfh51eKQY7YytSptfcv+8xhSodSRFfw=;
        b=XXir7PeqEihfCsHpOu174cuk3zg6sLpq+yETlvxa5sEPLOka4m3Hwdur6ixZfRBuAP
         ApF9LkeBH1aiHvE5F1ODqCjAlB68zdwWOYHjlg011GvdHHeV9Hrz3OSE4ciXOuukbd+Y
         sUHmGnKMJsq8HKf8oInqwcliwzU85jOCYaPuMzdUizYBJjYBw6kE+UqmDWZ7iuN6CTGs
         NPu0CcIbKuZh4w2PGZVfRf4ISM60PR7+GqTQOv1jEG0ru36pBpB9/FM0XPxpt5HunjTM
         3nJcLXdAwDJNZmgj56Z6nhcX2bGSZbMF6gGwOt7lHCfYzFmB4ImqXanxRHc2Tuumaj3H
         dB2Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780598000; x=1781202800; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FMBBNVyyWUX8SOTnPk3dJHwEcA4PwzlXJ8JPotT6/PE=;
        b=czoly+SIU3QgFdfAv28Cusd8eGmAHdDXEEdswwaAINn0GeJldVshO58QZGM7S2zyLC
         lnMlUW/IdlE0JR+BKUJqAsI7gv8N8qYhK38X8l6I9eTfEd9K0conmOfrqunyjKcwcClT
         q8SToEKtpyQdfyXgvCiHMg0+LY+Wc61qdZ3rm26qkdZ69HyOP06LVCw9VqhmMuSc8JDa
         n35GoBc5ZYztAZAjWYDlIzCxOb4c4tlTDpUPyCjXGjUQIDDPdASpr2QiIn0ziAHA30Yz
         DefWc71dj0/+R2CRn/ky+4logy90CAuGR5smcUUNdAvBXZnwNI5ZOlqcUeOIZCy3FG7e
         INqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780598000; x=1781202800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FMBBNVyyWUX8SOTnPk3dJHwEcA4PwzlXJ8JPotT6/PE=;
        b=PJ2Charw8JauDoUJTaSAVYMj4ryhypTIvEnQiTpFnB+JCVYeHXAbb2tc/b0jGgbK9n
         ZT7pkWM1+9I4olBBV/dOfuBuDgPAwcWOaxvQH5zVKiYKNI2D4LiXvLFbNSS5c42n44Rk
         HEnd5YOkGTtHO0SVmEQeEtM51Sly0z8QDbNRJvKGtbVoIL9QwfQHNlpi0LjnKFMlAPwL
         31VG9IYK6TcJ03E2m0W8pO0vCOJBrSTMeiEyg/3LW0GhTgX/MK8w9XXLykzkVytcSbrY
         D0gyuDYMY+oU/YqUy057XkHJ0QsAwAFwJrBfE7HV4GqdA3IaOJ2gA9f9LT/drQG1rjdq
         N4qQ==
X-Forwarded-Encrypted: i=1; AFNElJ/pCzjYLE6cKC939zyd4Si5DgMG4TLZOZTZ+xkHy8tkexhoRYcdsgl9vCBE/lkmpH843R6nNnWdIjE0@vger.kernel.org
X-Gm-Message-State: AOJu0YzqsXti97vJNNCElw61Maj42D5DgdvFJYkEPpla6t4QzyiULOKh
	7HBYYv+bTGLIPBI5Jm4xtR9igaIY/PtTbTVkTtTZKxRJVbHbLDmNoxSBepVGrIEqIyi8VS0fxYj
	q7GIY6CIqadMB/WRIbTzKjkk81tyBQiqaE0FjuCh3JQ==
X-Gm-Gg: Acq92OFaP9VQLRRq4fCnPGzC461O8E4i8OzYk+mq99BzTi8xOACHacoTPUzXM4AD4kC
	Ywy9wwKbLAVjPlCoPsrbqGR98SJ3hu0dkZ4eQkryiqg2/JXVyYrsUzdJcV1STUYK5e74Ln0tm7f
	nbIPhofUhDsGYG9HmgyeDx6YiIdXoUNcEmiZHZ596Up+F88KqrOhvxUf6Syzh9dpU7+IygJ+mMM
	XOoa12UsLi5QbS6J4GmxBj1587nC/toYOTHfk8TMDz93dn83OYMxqJHpI/9q9E0/G2mfEGbBSVz
	9OlP7upU2mVKdIJO
X-Received: by 2002:a05:6512:15a4:b0:5aa:6eca:f382 with SMTP id
 2adb3069b0e04-5aa87b76dc4mr11807e87.11.1780598000460; Thu, 04 Jun 2026
 11:33:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260603235616.124535-1-sam.moelius@trailofbits.com> <6d2e78e6a5840f5892e7eb081657b23aa62bc50d.camel@HansenPartnership.com>
In-Reply-To: <6d2e78e6a5840f5892e7eb081657b23aa62bc50d.camel@HansenPartnership.com>
From: Samuel Moelius <sam.moelius@trailofbits.com>
Date: Thu, 4 Jun 2026 14:33:09 -0400
X-Gm-Features: AVHnY4LD3pkiYKZ7fNmSUUSjU2S3PT1PsKvK4xcHx49ubGuvEYgRrydimR-dFo0
Message-ID: <CAE+C+DbpB6UP29WTNGgrnYqhazEC5=5ErNJiChrDz8sygC_-0w@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: scsi_debug: fix one-partition tape setup bounds
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
	"open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 4, 2026 at 9:38=E2=80=AFAM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Wed, 2026-06-03 at 23:55 +0000, Samuel Moelius wrote:
> > The tape setup path writes partition metadata one element past the
> > allocated tape_blocks array when a one-partition configuration is
> > selected.
> >
> > That corrupts adjacent state during device initialization before any
> > command is issued.
>
> I still don't get what the actual problem is.  For a single partition
> tape I can't see where scsi_debug would actually do anything with
> tape_blocks[1].  What is it that you're seeing when using scsi_debug
> that motivates this?

The bug is a kernel OOB write. I can share a PoC if desired. The PoC
sends this SCSI command through /dev/sgN:

    unsigned char format_medium[6] =3D { 0x04, 0, 0, 0, 0, 0 };

    rc =3D sg_cmd(fd, "format_medium_one_partition",
                format_medium, sizeof(format_medium));

Inside sg_cmd(), that becomes an SG_IO ioctl:

    hdr.interface_id =3D 'S';
    hdr.dxfer_direction =3D SG_DXFER_NONE;
    hdr.cmd_len =3D cdb_len;
    hdr.cmdp =3D cdb;
    hdr.timeout =3D 10000;

    ioctl(fd, SG_IO, &hdr);

For scsi_debug tape devices, opcode 0x04 dispatches here:

    { 0, 0x4, 0, DS_SSC, 0, resp_format_medium, NULL,
      /* FORMAT MEDIUM (6) */ }

resp_format_medium() sees cmd[2] =3D=3D 0, meaning the default
one-partition format path:

    if (cmd[2] !=3D 0) {
            ...
    } else {
            res =3D partition_tape(devip, 1, TAPE_UNITS, 0);
    }

So partition_tape() is called with:

    nbr_partitions =3D 1
    part_0_size    =3D TAPE_UNITS =3D 10000
    part_1_size    =3D 0

The unpatched code only checked total size:

    if (part_0_size + part_1_size > TAPE_UNITS)
            return -1;

That passes:

    10000 + 0 =3D=3D 10000

Then it initializes partition 0:

    devip->tape_eop[0] =3D part_0_size;
    devip->tape_blocks[0]->fl_size =3D TAPE_BLOCK_EOD_FLAG;

Then the bug: it initializes partition 1 even though there is only one
partition:

    devip->tape_eop[1] =3D part_1_size;
    devip->tape_blocks[1] =3D devip->tape_blocks[0] +
                            devip->tape_eop[0];
    devip->tape_blocks[1]->fl_size =3D TAPE_BLOCK_EOD_FLAG;

Because devip->tape_eop[0] =3D=3D 10000, this computes:

    devip->tape_blocks[1] =3D devip->tape_blocks[0] + 10000

But the allocation has only 10000 elements. So this write is one
element past the allocation.
