Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D4D2D781B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Feb 2026 06:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770360600; cv=pass; b=c79PlhlJ7j6vgfy/4jxUn0UFpicOX/lMrms1A3gHaH2ojFpBOHdCm6wVbmpB86ySLVPtlbr6z3xVAQFDJPBQbBXnZQ25cW1l08T4yL5NPfdQ9hpQNGj20MMJQb4ggzF52NhZMQw957f1y7dcKaNKl2vc49g/A6skfNL6Tr1jY1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770360600; c=relaxed/simple;
	bh=zn56MDqZou2YUQ0C8t2gVrhqqWmPgwauHHH4EwxmVhA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fqSnTHtSG3yaGsCaNPkxnT1R2qnsMBGQZ97PqlI9NXHTAVp2AKR2+nrnA9NK4J+YbSaEKuWletYSFBmIeXZT6fkNuYfjIbJC0zKBDdme0eZljQEIlzrQYjGPRPaBB3oryG0loUA4s0ZtSgfD52tp7v2TR/+ERiftpBqb9agSm7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=izJYBqxr; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="izJYBqxr"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65814266b08so2725923a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Feb 2026 22:50:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770360599; cv=none;
        d=google.com; s=arc-20240605;
        b=L6ykwMv1xyA0SgPv/Xgyj96KxjLvRHEnFCLGBMSt64OTUrpJhLgwqJGGhDiGV8IvFx
         3sB1x+9LxGMMZ2MPtLbnG1sK9jP+NHhi8dKf2cZJqZZp//CMfJHG4DJPersFlwjcfWwh
         gfQEB2BtkgVKSNzUsUenU7W2k0i7SSR6gUJcJoqcZLc0hO4Reh4YrU1NcrTnXjB1b/6t
         Te+LkSwYaCYFZRWGm1L6NLFo44jq8qulBzefrgbs0/9jQGKp0OYhqkZhmot2sv9oQ3ia
         bmEGxLMTVM+yJWgZY4U9o1doKrmBieLCRdvpZv0ar6n1F2yZYhESLUfDfMwH3u7ER26B
         vzsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bM8AdAe3UKJD/AbD1OSOI8ewszluelbCga2Rkvp6g/M=;
        fh=JA5a1AsZr2y1eLaZIm79iJnVljpKo3LnLIZbTBbwdVo=;
        b=FdbzXeBrNbNDRTf61WVtIpbHntKojJUVJOsqA1OkMjyoOpRIB/yY+SK8YEVs7lhmmb
         /W1WaXmWeK3Z3NVEvNMUIQyiYZOyESzbfdmiiuA8Homz2BnOMPiCsVkLZrj/5P0Tv5Ij
         TGyLlsYAfJP53jdUzEPsRxX3MDRZ9Z+DyF2zKJA9ISK+rLphd7XTBZVpSDYfH/wJQuGS
         4RkjQJmBIzDdCHjWNleJBMybWyGMPWHRFZWfr0YqdZ/LjXPjnkh+PjNvz3u8AsFjeYGv
         Wv8Squ0bPwTnV0CPLkJPwVQkv8YNIV1zsCz+Ekomk4spNnDb7pQOkSpzkGrQ7PnNdgWL
         Rgsw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1770360599; x=1770965399; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bM8AdAe3UKJD/AbD1OSOI8ewszluelbCga2Rkvp6g/M=;
        b=izJYBqxrHLekGasycFJnHuxcF9cHoM2ogXggCF9Ng3BndqfE589aLc9d4QCqiYomuW
         n2hHcGojuPnXYJdgtjepX1z1pbSDeIwOaBrda+xmRPPaHjNuySmU7Q+07cezIvxEHbEN
         J9xcBHyFcJY74kJIsBHLaOVbNMJXBnXoSgDcCZdVTwKxHHMikt68NKUmg7+Vdbtz/akJ
         pknxIsECUji+jtxKqV+MFUrEvPFDyODPq/lRCFw/QhDa3oJjYZh0PJuXJ3PeLWJFbwMM
         XgZvVTKRyrLnGV94fPw4sfmzPUmNUKutcKmFS6NV3C69KMwDjdsw71RECLXIeaWBYwbo
         EPag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770360599; x=1770965399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bM8AdAe3UKJD/AbD1OSOI8ewszluelbCga2Rkvp6g/M=;
        b=YbDohb0VoKSAtSrMNcHVKM9YInsQlpqk6pjJWnJSwK7fqp3xdWBlcjgCXDfmebVDhT
         lXR/bYOgi/2APj09aJKLTsXUkUegdhwdXy2oTpCJWgj7tlU11Q0Q8nvHmic96RjLnQkI
         EVXHpwstdQ9NdqZKBXsGQ4Rl4j3MpmwEzRtRw1nQsil4rtFayGM+7Xp3wF7+zFHpV2wO
         /XY9ScRKz7/cA7nQlw+mcHRFecR4olBmR/v/7ZxTXZ771G5XA9mFD0BIpyQ3Otf/QY9x
         iOroCHOEE6Vzywuf+NeGCrd5YLQG0bgztp4WVP7zqIOFZb+lUwSTe/hnuwfEu6XTGi3R
         /Glw==
X-Forwarded-Encrypted: i=1; AJvYcCX18k69ewKHt55YeBsdMl9Qe/E2DwZETBsajZQnhlH+rpXB+v2gHdGkS18SwBlStzrvlWpZFyFD8/b/@vger.kernel.org
X-Gm-Message-State: AOJu0YzccF+qREIfaS7E/Y7GsJJTlsr0ONjmolDzE/Gx8TJ7Nkp4pqDt
	39Pv10ZS8HxGIcZ3EnJRGpp1IL3IuKq7R/JymxgmEBNimWalRUtQDNpQkjSmZE5H9eDVI5dQSJO
	F03jKLBJ6tKk7XoqI4ZqfkjJu4l7QN6/yEHDDYuKEJg==
X-Gm-Gg: AZuq6aKj0kl0QyfBfUPJlaL25JEjrE2kEfIowpa2g10d+Varo3eEoUlnpXCYQsswUp5
	gFv1v3cXQ7udLXetVx72ZzE5V6Iy/OrAKfBcV+vkfog4gw/mtA/CsqBk2mNrvjq49mOCgFvmgtz
	XIt1jtazf6MFD3bQHXyc73JKmK++2vXt0GwRg2PpteqgIIP3ZFPScHAzztgR+QH24UD1MJw4dyh
	kj8rP1w5B+QgttQQurCPQho1n5xEGZIKfeva+2nIHyiOqs5qZa0r6g1D7e+OsRIM3pprz4Bv7tr
	22gD5YxB3thuDIDDB5tD+uVokplw
X-Received: by 2002:a17:907:782:b0:b8e:64e:1fe with SMTP id
 a640c23a62f3a-b8edf38468dmr94509666b.55.1770360598768; Thu, 05 Feb 2026
 22:49:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260205-ufs-rpmb-v2-1-5e1572ee52bf@flipper.net> <acc28d2d-3a85-4fba-8c15-fb956c34edf0@acm.org>
In-Reply-To: <acc28d2d-3a85-4fba-8c15-fb956c34edf0@acm.org>
From: Alexey Charkov <alchark@flipper.net>
Date: Fri, 6 Feb 2026 10:49:50 +0400
X-Gm-Features: AZwV_Qh60k4ZH69X3yTEHM2-LuMmU8iNtZP6b3zNYT4SfIokl9ZJKac7I8JvAIA
Message-ID: <CAKTNdwEd5-V6REf4BDTtm37tBzWZ2baf92X3A6HvHULsUj6=Kg@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Fix RPMB region size detection for
 UFS 2.2
To: Bart Van Assche <bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Bean Huo <beanhuo@micron.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Bart,

On Thu, Feb 5, 2026 at 8:08=E2=80=AFPM Bart Van Assche <bvanassche@acm.org>=
 wrote:
>
> On 2/5/26 12:30 AM, Alexey Charkov wrote:
> > @@ -5249,6 +5250,20 @@ static void ufshcd_lu_init(struct ufs_hba *hba, =
struct scsi_device *sdev)
> >               hba->dev_info.rpmb_region_size[1] =3D desc_buf[RPMB_UNIT_=
DESC_PARAM_REGION1_SIZE];
> >               hba->dev_info.rpmb_region_size[2] =3D desc_buf[RPMB_UNIT_=
DESC_PARAM_REGION2_SIZE];
> >               hba->dev_info.rpmb_region_size[3] =3D desc_buf[RPMB_UNIT_=
DESC_PARAM_REGION3_SIZE];
>
> Executing the above code if (hba->dev_info.wspecversion <=3D 0x0220) is
> risky, isn't it?

I don't think so. On <=3D0x0220 this part of the descriptor (four bytes
at offset 0x13) should always return zeros, so a compliant device
shouldn't get confused, nor make the driver confused.

The spec there is worded a bit weirdly, but it does say clearly that
these are set to zero, and I can confirm it on the devices I have at
hand (a couple of Biwin and a Samsung one, all 2.2 spec).

The spec says (Section 14.1.4.6 RPMB Unit Descriptor, table entry for
offset 13h):
4 bytes. dEraseBlockSize. Value 00h. User-configurable: no. Erase
Block Size In number of Logical Blocks. For RPMB, Erase Block Size is
ignored; set to =E2=80=980=E2=80=99

Not sure what was the rationale for giving this region a name at all,
as it is effectively reserved and zeroed out (and then change the name
and purpose of it in the next spec version anyway). But in this
context "Value 00h" is all that matters AFAICT :)

Shall I also add a comment to that effect?

> > +             if (hba->dev_info.wspecversion <=3D 0x0220) {
> > +                     /* These older spec chips have only one RPMB regi=
on,
> > +                      * sized between 128 kB minimum and 16 MB maximum=
.
> > +                      * No per region size fields are provided, so get=
 it
> > +                      * from the logical block count and size fields f=
or
> > +                      * compatibility
> > +                      */
>
> Please follow the Linux kernel coding style for source code comments.
>  From Documentation/process/coding-style.rst:
>
> The preferred style for long (multi-line) comments is:
>
> .. code-block:: c
>
>         /*
>          * This is the preferred style for multi-line

Right, the top empty line. Thanks for the pointer!

Best regards,
Alexey
