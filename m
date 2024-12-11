Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5716A1D6DA5
	for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2024 08:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733905112; cv=none; b=fL6AzJVP8Wvm2PfA6E4UySEABexlj9WtEIDl3l2Q8AVt7LboHl6IceeqyPOd44k93Sd1lwhG10aSQTatIJAcRCAX3mVg9ldo6dJpnq1fkXiGHKo6UnWUBnR+groPKOwOB63MC3ZWDf/buI0kjL7ntw/2XM1hb+V8xBqvBOPGm6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733905112; c=relaxed/simple;
	bh=XskHzUQ0wP3xisQAsDVTIVaMiwmap3TuSXWv2UwOOoE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dnuEDGWSHWhth9mJAP9OkhfTbHE3PDroMRJXwnUMKaCeYqQkLYtrHNmBWt7J2y04wc9hd98RTkdwkz9uT2nT/E9AV9rLadjnMggcL0xqzXJSIHLDdbphzlVIJ9CWnMDYktF+A/YXWUg97+dNS+pLNRAQv0+LJlRw/r6jjHz3+1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=IoekGvcc; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="IoekGvcc"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3004028c714so38042071fa.2
        for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2024 00:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733905108; x=1734509908; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XskHzUQ0wP3xisQAsDVTIVaMiwmap3TuSXWv2UwOOoE=;
        b=IoekGvccNyR3/8I0UHPuhLZecAyr4HJw3FrGwOlZnUyrpVBWhfdQVmXdzzu49yqvat
         1uMWuL6AJP5/rHSQRtmBLqHoP4gdsWWeZX0hoU3V3P71fSlzxMZgUpqiIfkxvkR77BeS
         HB2xqPsWS8TK4jmjivCUlpiXyZ4ZzdD5LuqQ/owoA4WnFLVodhfbCCKM3l9NTxUREITk
         P+r9yEoGDmBSLyznzXbHDdK8AsE9XAVrjfESe+flsVXPOaEqUoLluDMtFzHk2eSi1PX5
         CEl5D7XkONCmF1YX4dvA2bh965GgrnYMeJWeZpPCkJLGaqTSacwNZp2FhgKA2BKqQdu2
         zQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733905108; x=1734509908;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XskHzUQ0wP3xisQAsDVTIVaMiwmap3TuSXWv2UwOOoE=;
        b=voMg0Rg0M5pS+7v3ap6TtXhErJJ8F72ozljYWZn6JLdqxrfwUvky5D3eR9PP4yAJdA
         z2U6m+dmK+6a2gTfM8Md9Mz11QrzbmEHGNElw0Yga4GJyPn58myOXkd1qjZQrOuCUkmf
         6T0JK/n//IJkmiSJOxixBufTupMY9ZPLMvl8KtcwcyjP8bd4CIr5BOWn4lZjUi35fLRA
         OkBh0roinEIBm+kabm36YtYehJqrg/MT3n4i9XhIGVWkSmxpVme+RDZjxaNtgrOSA/Bk
         j0pRIZzncAu0sd0ie3jMIbRZDsQMKTJiVUqj54RVY/UdLqzCBiExjliNLo8iWly8HiEE
         cZTw==
X-Forwarded-Encrypted: i=1; AJvYcCX4y4xXuEmUarBcwci0fIDPq5Vo0VP0cj26ns4DypoHapk3S1wcXXTfpyGiqFHEqibZ96pkAJsa94b2@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwd49O2t0NsxtNEMvRPuk8GOLWEllhS4/DWx7z7y6H9BtQYcOS
	QQN8keMryu3DvjmCj4xfcl45KdGsyrJH8aX4OeenklFb64+sfCBeLviUSKm1KcjK9VQOTqmbciO
	M+CqokKnXBkfdyNOs5xXlHloSwPVmOz8sA1+BKA==
X-Gm-Gg: ASbGncsK+YzOx3jsVXIG6KZtyqhE6SxDATCQ5l4EBK7CUhp08Gu34kzHbWZGeJn4y+w
	ZRi4OAYxezCcFp0hPbg8P8HwrfChKXnirVzZG3NdkU4twXfxtH8clGRMUNL/zDOTaDw8=
X-Google-Smtp-Source: AGHT+IEyqSnEBMMtZyEj5jF6bo6/CxMQUAS8l/Vem+Q0Tg0zwJltPimb/BXxYNi4dNa8OIsM4j3xdj7bHzlce3zdJRY=
X-Received: by 2002:a2e:bcc6:0:b0:2ff:c95a:a067 with SMTP id
 38308e7fff4ca-30240d08829mr5734311fa.13.1733905108362; Wed, 11 Dec 2024
 00:18:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241211-const_dfc_done-v4-0-583cc60329df@quicinc.com> <20241211-const_dfc_done-v4-8-583cc60329df@quicinc.com>
In-Reply-To: <20241211-const_dfc_done-v4-8-583cc60329df@quicinc.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 11 Dec 2024 09:18:17 +0100
Message-ID: <CAMRc=MdJuy9ghgLHxbygdHME2EkttZ7zBMJzCis=t94EUMbGiQ@mail.gmail.com>
Subject: Re: [PATCH v4 08/11] gpio: sim: Remove gpio_sim_dev_match_fwnode()
To: Zijun Hu <zijun_hu@icloud.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Walleij <linus.walleij@linaro.org>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@kernel.org>, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-sound@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-cxl@vger.kernel.org, 
	linux1394-devel@lists.sourceforge.net, arm-scmi@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-gpio@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-mediatek@lists.infradead.org, 
	linux-hwmon@vger.kernel.org, linux-media@vger.kernel.org, 
	linux-pwm@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-serial@vger.kernel.org, netdev@vger.kernel.org, 
	Zijun Hu <quic_zijuhu@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 11, 2024 at 1:10=E2=80=AFAM Zijun Hu <zijun_hu@icloud.com> wrot=
e:
>
> From: Zijun Hu <quic_zijuhu@quicinc.com>
>
> gpio_sim_dev_match_fwnode() is a simple wrapper of API
> device_match_fwnode().
>
> Remove the needless wrapper and use the API instead.
>
> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> ---

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
