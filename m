Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F181C59B71
	for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 10:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711708054; cv=none; b=FQ0mKL4naIcVwhmVdAH5MEHc7DNaC3Rou+wZS4JSnTjauKQ4zz1EhOWOq/y5NnMh3zdr7TwcMPNO1SXRXK0ES3ZlHRhmI728uC7G/upKIVMshZBnFlGLRyhEOAiK0Z1cr6tuM7wzY7lUPf2tQ1VrHyTaiwAjSSdY5V/rW9Y/IeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711708054; c=relaxed/simple;
	bh=n8h0843dN8D5vA/PkugrZHKUYOVTJ3ipk22+mvTL/rQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pL+YimuJiafnXb0ZoV21NmGcn8ACA9nrq9ymWQXVeiElrUg+cfqZaYsjKxqUhGdpoaHrxGIdpOd4Qd3iQzYR/Ov2kn475IQPVU3NkRLniRao+AzXXVizzDXGCMozdlpuyuOZCJLEhphtBc2Zkyl5aPIfGB8O4m4PibLsCgSKrOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=dyuwjWZU; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="dyuwjWZU"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-513d212f818so1993683e87.2
        for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 03:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1711708050; x=1712312850; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uPUqPHiAYDsvF7c6mpbUarOnTLvyyWG07eUiOIJt2gQ=;
        b=dyuwjWZUfGWzJVysscD30kfuI2gyGOnYyqbGUlDCiWGyqIwspDyRcAC9eFt55TQL4N
         WILwNtOpVmkAH6RhWJ5Env6RPZV06CR7mPyYYVYbhe3cH5Lkf2lHDRGq8DvyUcF8mDZK
         RY4O9ESRZG2Von8kNqG99fYZs1oYfSfZ6QPfSiXa0Whm+GooCBUofQDP8KzW+V2gl/Ks
         m4V83+ciic4KyZm5qF+aYKpJ6koSYpKheZAUuqpjyqFKfTpxRWd+WM0zyf54/DaM9Cfu
         hEIMEmDg629P+tLfaGcJ5JJkJPLzByeLVH5rL9j0QQUHqoxyFDOj2qrT845zjvviERic
         cYOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711708050; x=1712312850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uPUqPHiAYDsvF7c6mpbUarOnTLvyyWG07eUiOIJt2gQ=;
        b=HD3jth0rOjA49iTmaeXZW6tiJ6733ZUSW6NN78Ui/wHN3QPlGADFFefY/ukXAoi/K/
         SdH4oPEY83ichrodGO9oLK3gjitAyJwzGIp6C9rRVNLwNaaRqGIxoE+Ki1o6kNnowafp
         8fotQazifhJlUk5Wh7QArEFsQmIery0sfPo2Il2wTvlfGJuOXDwQUmVXluNpQIv1Kpie
         K/UZNPILLoxk48LCci560H9NV3N5J3zSXJPeCZ6HK7e9LQIE/Kc1THIL5Mkr3Qw3wMg8
         v3PfWjv/8Ni1WTZUA/0dUFMrIL+aCtnOFvQeu16qAE9kPwBFlpFCiY0g8doTXrgIPzf8
         fRpA==
X-Forwarded-Encrypted: i=1; AJvYcCXPfUhBYXMupMkj6JJ87nUa09QVkCmQKUhXizb8iVdx0zglFIH/MdTu1M3JXp/r9rkAPFW4Jf9XDUbI5gdC0S3jsHvd/QqhiYlWRQ==
X-Gm-Message-State: AOJu0YxshT1scdXI0Y0PuXBGhjnvkcdIajtdSe9IDieR0lM8yUsP3+cd
	xegp6BjOMkCqrw61YSUKhIvvana7FSB5mdwqlDa8IJB2RtCZyL6yjLLpQrR0ARsn130wKY1b2zn
	JvwUksC+IsuuQpUfGIt+A/bmf6R3C3GnHbR5L3Q==
X-Google-Smtp-Source: AGHT+IGkJetMoIDH9w2TQurNFFXLK7XsHfl+lPbtCC+0MeMFYTkyF7Alb8el7pzIkiwo9JvBX9h3ULKBGoxrg4XKpUU=
X-Received: by 2002:a05:6512:33ce:b0:513:af27:df1c with SMTP id
 d14-20020a05651233ce00b00513af27df1cmr1559870lfg.11.1711708050041; Fri, 29
 Mar 2024 03:27:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org> <20240327-module-owner-virtio-v1-9-0feffab77d99@linaro.org>
In-Reply-To: <20240327-module-owner-virtio-v1-9-0feffab77d99@linaro.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 29 Mar 2024 11:27:19 +0100
Message-ID: <CAMRc=McY6PJj7fmLkNv07ogcYq=8fUb2o6w2uA1=D9cbzyoRoA@mail.gmail.com>
Subject: Re: [PATCH 09/22] gpio: virtio: drop owner assignment
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gonglei <arei.gonglei@huawei.com>, 
	"David S. Miller" <davem@davemloft.net>, Viresh Kumar <vireshk@kernel.org>, 
	Linus Walleij <linus.walleij@linaro.org>, David Airlie <airlied@redhat.com>, 
	Gerd Hoffmann <kraxel@redhat.com>, Gurchetan Singh <gurchetansingh@chromium.org>, 
	Chia-I Wu <olvaffe@gmail.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	Joerg Roedel <joro@8bytes.org>, Alexander Graf <graf@amazon.com>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Kalle Valo <kvalo@kernel.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Anton Yakovlev <anton.yakovlev@opensynergy.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, virtualization@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, 
	netdev@vger.kernel.org, v9fs@lists.linux.dev, kvm@vger.kernel.org, 
	linux-wireless@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, alsa-devel@alsa-project.org, 
	linux-sound@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2024 at 1:45=E2=80=AFPM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> virtio core already sets the .owner, so driver does not need to.
>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>
> ---
>
> Depends on the first patch.
> ---
>  drivers/gpio/gpio-virtio.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
> index fcc5e8c08973..9fae8e396c58 100644
> --- a/drivers/gpio/gpio-virtio.c
> +++ b/drivers/gpio/gpio-virtio.c
> @@ -653,7 +653,6 @@ static struct virtio_driver virtio_gpio_driver =3D {
>         .remove                 =3D virtio_gpio_remove,
>         .driver                 =3D {
>                 .name           =3D KBUILD_MODNAME,
> -               .owner          =3D THIS_MODULE,
>         },
>  };
>  module_virtio_driver(virtio_gpio_driver);
>
> --
> 2.34.1
>

Applied, thanks!

Bart
