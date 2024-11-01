Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6914113211F
	for <linux-scsi@vger.kernel.org>; Fri,  1 Nov 2024 02:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730427320; cv=none; b=l1H5DmI4D28/7EUIch/bQ5hOoz9nAR+C6j29VAMcxC2NrtTThhaQ9nGE9l7h4ywF8HvSIAPZ7dC7ekw6MfKeyUj9fRl2C50G5rmi4kzDUVyEirRPzftgN4E5NFhcN9qlVFyJzj1QqFkNnpqKcTRiamirtiAtp21uA8odwvUKSTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730427320; c=relaxed/simple;
	bh=yJdGIwUEYPOmEs8ij3kiy6zzV0QYlQFlQfm8YmlYIbg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RMaXfnttoW1MGywS8kcdsnpLFOZVCAB9Q4sUCky9ArMMSWiidxJkOYkvLRvPv38Ugf3vm8KmV4+HVq+nl6ygAhOI3K2uyz7AXlVsmxlF1UyNElhDtBZtOxz7jReaOI0XIaMlc66MnQaQltLXraF94jFj0YUOH0ng0IfkFlMoK+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KYDxDF4i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KYDxDF4i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730427312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yJdGIwUEYPOmEs8ij3kiy6zzV0QYlQFlQfm8YmlYIbg=;
	b=KYDxDF4i9Kc/wENqJEJaIOi+KtLmaAZev+0Bd7qTUyzDEycsyY2Czv3y7hoS6ceE3Hd6Sn
	TpWCtBPq4zsO3PPwH6fLGfgyIWywLEx7JdrH+j8j0Cp+ecLZzCxUx666zHtK9Tukdjz4+q
	AgmJFP+WhBj+ePeEFI2RIohB/x/QlK0=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-3_F43CulOrubG-HItJK0vg-1; Thu, 31 Oct 2024 22:15:10 -0400
X-MC-Unique: 3_F43CulOrubG-HItJK0vg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2e5c75bee71so1852082a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 19:15:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730427310; x=1731032110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yJdGIwUEYPOmEs8ij3kiy6zzV0QYlQFlQfm8YmlYIbg=;
        b=Z0lozxpjvcoiP+6FSJvxr3mWDEwMZYueamTNcXixO25XS3FuQiRs0dvC6HpJx9q3m1
         yhvNfUBDR6Z6Vw9qZoNW59M1TezJ0gHKJ/oPudjbD587ARpaJh9qOCHGuMtm0ZZI81ml
         sAPEnWIFMH9i2NtcXsXrgnlFOrPPDESgrjPiGH0Ad+HwAW3jtM8oYsI41ZtXU0X5M6SW
         6k0axxwrKiCgwrnUsoWf1rgANsVq1Fo3Hi4SrKFKDZVvNacbJxskSM8u64xnqZLgyBWN
         XEeCMbVBJqBJe3eYDVzm1KoAwm3Fqvx3AUpuNrRSHNc6QEItm0bMoLX119I8VZM/+LYv
         HkzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmUS+dTIKeV5lg5BZVtMsrXT8S86eFLAPtO0SSfzyFRBHWg8mw9rZTU9mVFgKc3aaFbLf7VqjyJokd@vger.kernel.org
X-Gm-Message-State: AOJu0YzhBTbxrFn5IrpvQ9KUUhAY+dTNtlz3t7EmU7C1j/ENQ+lj2znG
	T0YzTMPXBEYPqzvW4P7qCASJxNLh38J2mPWeD/c9h2fruIYrTNh0UCZzHmHsPP5hKX1pt9N/Y32
	AF98e3diBof9bi5bn46o+6RK8c/hqcRw1XBzC9LrkbCUFW3tkbEU15x3ENkFo8w9ajkBbDw6hdP
	HozQ9rttf/0eURRJ+fmOeCQse/U8a1B/t0kQ==
X-Received: by 2002:a17:90b:2d92:b0:2e2:e159:8f7b with SMTP id 98e67ed59e1d1-2e94c29f2cemr2655458a91.3.1730427309720;
        Thu, 31 Oct 2024 19:15:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHy16t0It8M5wuxzMCN0u7b3KxhGxysg7D6J/QWKdLqLpcbAtWiRV69Dq4QwYxCS/HPdiOkYmqXnbjdd/QPCCE=
X-Received: by 2002:a17:90b:2d92:b0:2e2:e159:8f7b with SMTP id
 98e67ed59e1d1-2e94c29f2cemr2655410a91.3.1730427309206; Thu, 31 Oct 2024
 19:15:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241031030847.3253873-1-qiang4.zhang@linux.intel.com> <20241101015101.98111-1-qiang4.zhang@linux.intel.com>
In-Reply-To: <20241101015101.98111-1-qiang4.zhang@linux.intel.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 1 Nov 2024 10:11:11 +0800
Message-ID: <CACGkMEtvrBRd8BaeUiR6bm1xVX4KUGa83s03tPWPHB2U0mYfLA@mail.gmail.com>
Subject: Re: [PATCH v2] virtio: only reset device and restore status if needed
 in device resume
To: qiang4.zhang@linux.intel.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gonglei <arei.gonglei@huawei.com>, 
	"David S. Miller" <davem@davemloft.net>, Viresh Kumar <viresh.kumar@linaro.org>, 
	"Chen, Jian Jun" <jian.jun.chen@intel.com>, Andi Shyti <andi.shyti@kernel.org>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Gerd Hoffmann <kraxel@redhat.com>, Anton Yakovlev <anton.yakovlev@opensynergy.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Qiang Zhang <qiang4.zhang@intel.com>, 
	virtualization@lists.linux.dev, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-i2c@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-sound@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 9:54=E2=80=AFAM <qiang4.zhang@linux.intel.com> wrote=
:
>
> From: Qiang Zhang <qiang4.zhang@intel.com>
>
> Virtio core unconditionally reset and restore status for all virtio
> devices before calling restore method. This breaks some virtio drivers
> which don't need to do anything in suspend and resume because they
> just want to keep device state retained.

The challenge is how can driver know device doesn't need rest.

For example, PCI has no_soft_reset which has been done in the commit
"virtio: Add support for no-reset virtio PCI PM".

And there's a ongoing long discussion of adding suspend support in the
virtio spec, then driver know it's safe to suspend/resume without
reset.

>
> Virtio GPIO is a typical example. GPIO states should be kept unchanged
> after suspend and resume (e.g. output pins keep driving the output) and
> Virtio GPIO driver does nothing in freeze and restore methods. But the
> reset operation in virtio_device_restore breaks this.

Is this mandated by GPIO or virtio spec? If yes, let's quote the revelant p=
art.

>
> Since some devices need reset in suspend and resume while some needn't,
> create a new helper function for the original reset and status restore
> logic so that virtio drivers can invoke it in their restore method
> if necessary.

How are those drivers classified?

>
> Signed-off-by: Qiang Zhang <qiang4.zhang@intel.com>

Thanks

