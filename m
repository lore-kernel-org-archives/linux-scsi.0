Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A376019ABAB
	for <linux-scsi@vger.kernel.org>; Mon,  9 Dec 2024 20:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733777684; cv=none; b=szcTDr2k20Q8i7kAFXzmhdhsSMqwhiiSnrkhyAhozutQm6+YXTIpY6S18mjYJc2wJ6THQtjd5eJ+lXxrqWWuAkt0QBLYivyEdhGv8ELDAkv9RlPq27fCbAfYrgoa2orr7SmqGLlveX0GqGc/MWMNxEuDh9T4W1FHHt6elfxSxF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733777684; c=relaxed/simple;
	bh=5KfXBcVbCvfr+zrx2MV66aEVn1+Z1mtFmhLoEyn9t3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q1oL5k/IXGRxMpDA83lwbJvnNldLFSQ8Wji0IpzDhwb3Pu4IY/yWsR6VilnMS5xgjCkyLwqC4u4BKnNqIgo+6gN9HCGjTVN3Pmdvx28iLyjkEH93E1sYSQkBhHsC7qBIR50teCuEgFFw2buLY4J6k04FG3sRbh7JjmD0DE+9Kx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=T1lxVTIi; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="T1lxVTIi"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-53e3a5fa6aaso2407471e87.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Dec 2024 12:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733777681; x=1734382481; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N9Vfs2kNt+4OobuLk6Y8aaQXjBCfT1i0vXOy9GUUiJ8=;
        b=T1lxVTIiEGHDd5gbjBsl/DQpohaTM5UDFmBuQAOBf1nYi8VTyxPsxPnTlv6M43HwRO
         5EwLHd7F+9GyU1RbmnSM9sLlh7H0s/txzcpqQ35IVfdSZ0FfMh1iFDK/dXVwtMC24o0d
         LKz3BatPSQ/vJQLf2YM+qjEOD+tI+SIbUoaxOWgOFveOKe5Cq3HeDAyRa+Xtv8GC2yQL
         PBlgECVrYxMX02K42Sv005YTEM3pIRzQo0dpBmEOwIUx9xR0QWXz0DW0bYPiBFcMG7r1
         xp/5HEw5xy3Vh1I60qGq0B7uQ/Z3X9E6Pay3gCjbpXf1i9O8u3Kk1NEfXeqAUts7zxep
         X45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733777681; x=1734382481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N9Vfs2kNt+4OobuLk6Y8aaQXjBCfT1i0vXOy9GUUiJ8=;
        b=cn75EG/l4j4XAnpgInR4H0W8h2bVb/XENRbpMsB8LCGUeHUqX5WaJzWbPbpIY2e9w8
         w0DMaRbH3W6oCeR+sKZnb5lYhwNxyR+ll2tp72dwmKpS6gvTzGZ9WuMR/knqU0ji8Et9
         BU8ebSSawh5yO5UDi2+BHcDjKEhVfmbsOm/hMCBnfLvlZyLYZuEPMYLxPAg+HokFWUqs
         +OrCVZemkgEYgnJvBaP7f4OOzFg+40DqwdmpO9ofONpboGnGna2RQyb1J68FrREBbPe3
         HAl3wLHU3UKUKsr6IvSHIpwSR40/lbuHHXu/8LgmDLjM0I5b56c3w860GD1MXCcmn8Qg
         Rsow==
X-Forwarded-Encrypted: i=1; AJvYcCWlXr2lZXqIhqZEaVj1feS4rR2vMZQfDaPKyK4JU462RTRY1zD7NUyMUimEXt9zUWbmqtAreh3itJ7i@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5+L3iEelHHciBO6aR3yNnGmhZkJQ8fCE4Hjb5msKEIwGu5W48
	X4j6DhnGGmvGtTRdPWS7NBU1W/8Mj3jHiPtgg7qP1wp1iG5s/+BKTcITTltYyr/IcOHDIIeSfc6
	qbkEC6j5lsSfvELw31cwCubHTMVePPOJpnUHO/Q==
X-Gm-Gg: ASbGncuAkubuUINQuP0oX5bKI1FbH8iIkn7FlbHEwXuu6UQHbh5tnfYN/XN7tWbogQq
	BpPHWddfzqvlRZfr6xd2XOkToCQvUQHaf1L6xQrhRtlwzMwVgSUUCoh1ZtuaZEOo=
X-Google-Smtp-Source: AGHT+IHhJNAanpwKh12pYprytEHbQW5ap5zMyZnkI1wPUFNQzwQaF/kkIIwmpFjtqd5lM1j3pLC/ZYN/wl08sYxohj4=
X-Received: by 2002:a05:6512:114c:b0:53e:3c47:4215 with SMTP id
 2adb3069b0e04-540251d01e0mr300875e87.2.1733777680622; Mon, 09 Dec 2024
 12:54:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209045530.507833-1-ebiggers@kernel.org> <CAMRc=MfLzuNjRqURpVwLzVTsdr8OmtK+NQZ6XU4hUsawKWTcqQ@mail.gmail.com>
 <20241209201516.GA1742@sol.localdomain> <CAMRc=Me7kEBHW1BTDkJ6w+3GjucCfC+GNZBch3kX=gsZniFHvA@mail.gmail.com>
In-Reply-To: <CAMRc=Me7kEBHW1BTDkJ6w+3GjucCfC+GNZBch3kX=gsZniFHvA@mail.gmail.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 9 Dec 2024 21:54:29 +0100
Message-ID: <CAMRc=MeFHpB5ckWLToSF8woEpKmGU92K+qFY14HjB8NN_TrBPA@mail.gmail.com>
Subject: Re: [PATCH v9 00/12] Support for hardware-wrapped inline encryption keys
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bjorn Andersson <andersson@kernel.org>, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Jens Axboe <axboe@kernel.dk>, 
	Konrad Dybcio <konradybcio@kernel.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 9, 2024 at 9:35=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.pl> =
wrote:
>
> On Mon, 9 Dec 2024 21:15:16 +0100, Eric Biggers <ebiggers@kernel.org> sai=
d:
> > On Mon, Dec 09, 2024 at 04:00:18PM +0100, Bartosz Golaszewski wrote:
> >>
> >> I haven't gotten to the bottom of this yet but the
> >> FS_IOC_ADD_ENCRYPTION_KEY ioctl doesn't work due to the SCM call
> >> returning EINVAL. Just FYI. I'm still figuring out what's wrong.
> >>
> >> Bart
> >>
> >
> > Can you try the following?
> >
> > diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/q=
com_scm.c
> > index 180220d663f8b..36f3ddcb90207 100644
> > --- a/drivers/firmware/qcom/qcom_scm.c
> > +++ b/drivers/firmware/qcom/qcom_scm.c
> > @@ -1330,11 +1330,11 @@ int qcom_scm_derive_sw_secret(const u8 *eph_key=
, size_t eph_key_size,
> >                                                                 sw_secr=
et_size,
> >                                                                 GFP_KER=
NEL);
> >       if (!sw_secret_buf)
> >               return -ENOMEM;
> >
> > -     memcpy(eph_key_buf, eph_key_buf, eph_key_size);
> > +     memcpy(eph_key_buf, eph_key, eph_key_size);
> >       desc.args[0] =3D qcom_tzmem_to_phys(eph_key_buf);
> >       desc.args[1] =3D eph_key_size;
> >       desc.args[2] =3D qcom_tzmem_to_phys(sw_secret_buf);
> >       desc.args[3] =3D sw_secret_size;
> >
> >
>
> That's better, thanks. Now it's fscryptctl set_policy that fails like thi=
s:
>
> ioctl(3, FS_IOC_SET_ENCRYPTION_POLICY, 0xffffcaf8bb20) =3D -1 EINVAL (Inv=
alid argument)
>
> Bartosz

FYI: It fails the: `if (!fscrypt_supported_policy(policy, inode))`
check in set_encryption_policy() in fs/crypto/policy.c.

Bartosz
