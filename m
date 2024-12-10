Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3885230D2C
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2024 09:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733822031; cv=none; b=R4S+/5yvwwT7P73Grg3TSwScmIY8maT0ghiVFI+bJEPFFUGWlP9ICrzXxxvabodDIGEc5L4sRCaJ2TCHdtHHBzEJGNDzmJvAUn/cuvnkVkfO2tUTqJ8pGqUlQYXh9Arfb1MH1VM6qgkeIpup9rv7A3yMGa+2yefdGQyGNRI4OdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733822031; c=relaxed/simple;
	bh=jcAy7slIcGpuWxQPTeOKSm5z2zc/NNEUZ6qqDVcSXCQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YiNnqZ0NYuEYV47jibl/oESXroRDTtIC67DqjixXi34xPc+yJy8IqPpd6yGKBWCHC3Wb+KknE/+Ol1+zJtxg0c5ItolA3Vu4Kl3RVu6hcPTvQB9zEbLysVhPXerMroqUwA3doI0GrgyGwq0q3Cq/3xYVHHKIJJ2fgUt3j0wxFHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=WuEp2und; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="WuEp2und"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5401ab97206so2035199e87.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2024 01:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733822027; x=1734426827; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2XlZtoi6YzM5n0bDbE6udezF/JySf6HZqcQtjtNfkAs=;
        b=WuEp2und3JnixXs54iXHHkzWwuLEkX1kTEQUhHFqeC9/gr9BKy8xrztVRlArWatnuA
         /JzAvJmGpXWzvioUozNMgWhJD1IqDkR1ioL6/anBUwi1iBNWiWR3IDwmujAGLyMGH3j3
         OwWzX4tdsd0E96tthfSL4ZsCm0faqPA96FOo63z4Y6ejL3jorvLfHHHF1cmwtuG9Lx+d
         jIX7oaLQWi6A1+7B7KUh4mda9Rs9+75iKIUuopIc2U5UEXkNqvR5FG/6VyMxAElsyKGG
         yqSTU0IzJMJjTOcgpvO+VlrpmQ3wHyJJjIwi8XQf09vUf3nvXx201kxv1N2eoLdU1d4M
         2/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733822027; x=1734426827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2XlZtoi6YzM5n0bDbE6udezF/JySf6HZqcQtjtNfkAs=;
        b=hBv+YUfHIw4Zoi3VdfND0YQf+0QCyjPe4/smwHyn+irprw1h14yc9dOKSqMqdv3PKa
         U1uxENgTu6WuKqHmPoVcBDPeJHVgacKM7pLNeG90IzNR0rbE57MtIPN6yuRheKDsQF84
         BJwsF0mLaquVe/x9/NSBT4rHuR0BmbZtkU87o0sbx65g6QrzM1F1V+HoqQ/oN0CYwBYY
         vIOHaWGBpCXKda7q578bWX+9C+SSSXKkRFL2JklT9XJn/j3L2vZNYdB9PSghVg62kOJk
         EoAtsSQ4s22YaQKjlA/UrOkdgMsXEk5XlGm+1pN4Tg8vcEjDWxXfDb9btWHJSqNl84hK
         7cPw==
X-Forwarded-Encrypted: i=1; AJvYcCUPxtsidBuqm4czWK0DnRjuSStyn8cbHXi8PvyG+KJ5e96RKLZkvcgpFRHKyu6pCaZE8A2yVsi5cG0E@vger.kernel.org
X-Gm-Message-State: AOJu0YwC2YKKpazOvdbT6H+S+RJLsHkZhobnzCsuRp89u6NpBv7v/dAY
	sb7Xpdba1dy2APCIwww0AD98cMwNYjIO8n8FMHhgH9KH6TKVKTTLHGmhghjyMJcJkWy605da5yq
	YVSAZwd2qvpf3DhdtW85QKp1o4+dRsQH72LcouA==
X-Gm-Gg: ASbGncu/TuJVuqjSNkREIQDARiChitDdf0VSKr8Ra9ud54Hp30VnIYaQ5ceZFshPWYp
	0abKpV4GWXKlJp9otENi5LY9tswQk6J2X8la570UWS9CmizWRTRwCqyX1TF88NfERQGo=
X-Google-Smtp-Source: AGHT+IFjRegof2ukNHU+84c0sXZPqXeN99k3K+KrjVEgjHV3fxYxmBk/8ZtZxdRPpXl74bQebew8g+3ZAX59iNKhK34=
X-Received: by 2002:a05:6512:3988:b0:53e:398c:bf9e with SMTP id
 2adb3069b0e04-5402411a8f4mr1268009e87.55.1733822026680; Tue, 10 Dec 2024
 01:13:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209045530.507833-1-ebiggers@kernel.org> <CAMRc=MfLzuNjRqURpVwLzVTsdr8OmtK+NQZ6XU4hUsawKWTcqQ@mail.gmail.com>
 <20241209201516.GA1742@sol.localdomain> <CAMRc=Me7kEBHW1BTDkJ6w+3GjucCfC+GNZBch3kX=gsZniFHvA@mail.gmail.com>
 <20241209205553.GC1742@sol.localdomain>
In-Reply-To: <20241209205553.GC1742@sol.localdomain>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 10 Dec 2024 10:13:35 +0100
Message-ID: <CAMRc=Meh5dW6oSexiR2riHkbiFcJz1XQ=xA5VEDMgcX4UTb5-Q@mail.gmail.com>
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

On Mon, Dec 9, 2024 at 9:55=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Mon, Dec 09, 2024 at 02:35:29PM -0600, Bartosz Golaszewski wrote:
> > On Mon, 9 Dec 2024 21:15:16 +0100, Eric Biggers <ebiggers@kernel.org> s=
aid:
> > > On Mon, Dec 09, 2024 at 04:00:18PM +0100, Bartosz Golaszewski wrote:
> > >>
> > >> I haven't gotten to the bottom of this yet but the
> > >> FS_IOC_ADD_ENCRYPTION_KEY ioctl doesn't work due to the SCM call
> > >> returning EINVAL. Just FYI. I'm still figuring out what's wrong.
> > >>
> > >> Bart
> > >>
> > >
> > > Can you try the following?
> > >
> > > diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom=
/qcom_scm.c
> > > index 180220d663f8b..36f3ddcb90207 100644
> > > --- a/drivers/firmware/qcom/qcom_scm.c
> > > +++ b/drivers/firmware/qcom/qcom_scm.c
> > > @@ -1330,11 +1330,11 @@ int qcom_scm_derive_sw_secret(const u8 *eph_k=
ey, size_t eph_key_size,
> > >                                                               sw_secr=
et_size,
> > >                                                               GFP_KER=
NEL);
> > >     if (!sw_secret_buf)
> > >             return -ENOMEM;
> > >
> > > -   memcpy(eph_key_buf, eph_key_buf, eph_key_size);
> > > +   memcpy(eph_key_buf, eph_key, eph_key_size);
> > >     desc.args[0] =3D qcom_tzmem_to_phys(eph_key_buf);
> > >     desc.args[1] =3D eph_key_size;
> > >     desc.args[2] =3D qcom_tzmem_to_phys(sw_secret_buf);
> > >     desc.args[3] =3D sw_secret_size;
> > >
> > >
> >
> > That's better, thanks. Now it's fscryptctl set_policy that fails like t=
his:
> >
> > ioctl(3, FS_IOC_SET_ENCRYPTION_POLICY, 0xffffcaf8bb20) =3D -1 EINVAL
> > (Invalid argument)
> >
>
> Yes, as I mentioned I decided to drop the new encryption policy flag and =
go back
> to just relying on the key.  I assume you were using
> https://github.com/ebiggers/fscryptctl/tree/wip-wrapped-keys?  I have pus=
hed out
> an updated version of that that should work.
>
> - Eric

Thanks, with that and the memcpy() fix:

Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org> # sm8650
