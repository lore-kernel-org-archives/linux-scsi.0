Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E96C2022D6
	for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 13:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730207939; cv=none; b=LwgO68dk72zJewF2rfvKu4vGOA5z9SAERsaGHaiGwLX3V5yXwxrEq+xwQaQNlaOUECVnpF2/hIDFa7iB08LqQUMdKheOIawAE0KLVsDpo0UmGm8Inwpj8YtKKp/baLsUnRb+2/K3FjmKmH0RDXP8mlHvph3I5YcTehFmW7V7NyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730207939; c=relaxed/simple;
	bh=W7nIJhe/lijpZ8Dh1LY8cz7gOpHnMfCWaziaEGpuacU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BxuS9ipwhgVEV2fJ1sKrxG9w1ecJomwQ5Fdy4QvfS09po171Gwssp1wdUxX5eAqSIXTepoczO4Dvz6w7PRd3vEcYSq/Oi8XHprBtH2QqHf4uneFUpCcbhRSWSSl8aTPXaspF/K9ZDiBQMAnO5YIvv/K5uOetTj9q27kpuKP9h7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mbeuTd2q; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mbeuTd2q"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a99f629a7aaso865766866b.1
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 06:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730207936; x=1730812736; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W7nIJhe/lijpZ8Dh1LY8cz7gOpHnMfCWaziaEGpuacU=;
        b=mbeuTd2qFNFQTs0xzZ/7NPgvOE1LZUkTgfgkE6L2ZMY2qCTc3l6GIJG6b8h243a+Ju
         BocRxoZO3KwFaYnYVDcpsrSujOJbVzEM37B/IciZLq/ada3oGmSe/Fh1G7u8PWCSTU6Z
         PMNek1JyAhFBLZwas7uUTEpq5gmRQvrpmC+Nx48aLrQy/WJcFWlnZOQfc6zG4cKdDiM8
         UIdJ1RgTHn4EQ0qX2nMUwryq3oWhjxT6a51eGC+30IkFRnoK7xlH0L63xfIgjl2ctKQl
         V+Rh7xsc6SFoCkxs/jqnyQlE9VWLUsuj78OGpC6UKW2moIqBndz+ubqOsVisJppunsoa
         jqBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730207936; x=1730812736;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W7nIJhe/lijpZ8Dh1LY8cz7gOpHnMfCWaziaEGpuacU=;
        b=DO5plZ1NpJstZriXWGNl4MfHy+Pjit/P482dzICd19EkfYvd583lENb9iaM4ZZKTHM
         x0K//xnakOxDIl4a9WXKJ/wLTFqn8kpYCqRmX3yiAfvoXnhjT5fxxmCd40V6e9YVx4d0
         8uKvqZVkLNZ+vdsDYoesGwkwYlsdrdTTJCKuK+Qcf0a4ZoIyO2G22OXd7/JbgqiBAPVc
         aasycrHl/zUFLUlnMW/ZDVRhC13XTIuv51W8VLv9KINnUcvBRv3fbBAAVkKgzPyYNZ3q
         knL3My3pKlqGg+kkPWziLYzhS3zFUL4+ug6aW1E6B3xLQonYBpV8MbJRuzFna35MRcR+
         lT1Q==
X-Forwarded-Encrypted: i=1; AJvYcCV1saYU9mdD6f99d+iAwSVyije5zBZehfZPV4R7XT78ADSuQQs2SlrKowwZ3kjhbMgTqR97k743LG5c@vger.kernel.org
X-Gm-Message-State: AOJu0YxGskp2qH3DyUkwkJr7hFPUv6zqZexKE68l49xabv9EzQw/9GDi
	guYCC2oSy+g4HBU89EcI3toMUuh5wu6RnPZrmx0N1CdMSpZlzFWn
X-Google-Smtp-Source: AGHT+IEhW68YHKzPbeB18Rp83w8YTAznVIggag6dAZ7MM3JbXc27MbvSbeEnUobvcd0X4fetv808Pg==
X-Received: by 2002:a17:907:7f89:b0:a99:3db2:eb00 with SMTP id a640c23a62f3a-a9e2b0138bbmr206161166b.28.1730207935309;
        Tue, 29 Oct 2024 06:18:55 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9b1f2982d4sm475158266b.120.2024.10.29.06.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 06:18:54 -0700 (PDT)
Message-ID: <04ebe6420034ca3d791ea3cac10ebd61970a7093.camel@gmail.com>
Subject: Re: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
From: Bean Huo <huobean@gmail.com>
To: Huan Tang <tanghuan@vivo.com>
Cc: beanhuo@micron.com, bvanassche@acm.org, cang@qti.qualcomm.com, 
 linux-scsi@vger.kernel.org, opensource.kernel@vivo.com,
 richardp@quicinc.com,  luhongfei@vivo.com
Date: Tue, 29 Oct 2024 14:18:53 +0100
In-Reply-To: <20241029120346.591-1-tanghuan@vivo.com>
References: <330e0b7fce03b2970db80c4b73b611af220b6349.camel@gmail.com>
	 <20241029120346.591-1-tanghuan@vivo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-10-29 at 20:03 +0800, Huan Tang wrote:
> > > > On 10/28/24 1:04 PM, Bean Huo wrote:
> > > > > Even though I don't think it's necessary to enable a Sysfs
> > > > > node=20
> > > > > entry for this configuration.
> > > >=20
> > > > Right, a motivation of why this functionality should be
> > > > available in=20
> > > > sysfs is missing. An explanation should be added in the patch=20
> > > > description.
> > > >=20
> > > > Thanks,
> > > >=20
> > > > Bart.
> > >=20
> > > Hi Bean & Bart,
> > >=20
> > > Motivation: Through the sysfs upper layer code, the WB resize
> > > function=20
> > > can be used in some scenarios, or related information can be
> > > obtained=20
> > > indirectly to implement different strategies; What is your
> > > suggestion?=20
> > > sysfs? exception event? or?
> > >=20
> > > Thanks
> > > Huan
> >=20
> > hey Huan,
> >=20
> > What specific scenarios would require enabling a sysfs node to
> > control this function? Dynamically
> > adjusting the WriteBooster (WB) size on the fly doesn=E2=80=99t seem id=
eal
> > to me. From my perspective, the main
> > case for this feature is if the OEM didn=E2=80=99t correctly define or =
set
> > the WriteBooster Buffer size during
> > manufacturing. Even then, adjusting the WB buffer size wouldn=E2=80=99t=
 be
> > a frequent need. If JEDEC has
> > found a reason for this feature to be accepted, isn=E2=80=99t there alr=
eady
> > an interface available to configure it?
> > Why would we need a duplicate interface for the same purpose?
> >=20
> > Kind regards,
> > Bean
>=20
> Hi Bean,
>=20
> Thanks for your reply
>=20
> The scenario I'm thinking of right now=EF=BC=9A when the old phone transf=
ers
> a large
> amount of data to the new phone's APP (vivo calls it easyshare APP),
> we can=20
> explicitly resize the WB buffer.
> Could you please explain this sentence(If JEDEC has found a reason
> for this feature
> to be accepted, isn=E2=80=99t there already an interface available to
> configure it? Why
> would we need a duplicate interface for the same purpose?) more
> simply so I=20
> can understand it better?


I see, easyshare is a case, but we have interface which allows user to
configure UFS attributes, such as ufs-bsg, you can use this interface
to achieve this in your application easily, right?


Kind regares,
Bean

