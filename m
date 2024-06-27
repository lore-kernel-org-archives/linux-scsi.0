Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED38E178373
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 12:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719492913; cv=none; b=FmrJLF8WFDUW1QxpU4DSPZuAXdjs+kLbhSfxXhnYiSiAscFANhIZGF4Zli3faAXk8YJM/LAZwdPVUuOfNxdye8QjdjWV4q2Lk1e8v64b9FKbd4u/dZsI+BG8TJiIvz2VIs4d+yB4PgHTIFgLcN0T3EZbf3yDcGJsP8Z0YyaEAIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719492913; c=relaxed/simple;
	bh=BzKX2RCxsDLJwDXBUL4bY44QUlPMSz5TOWJt4YxUTco=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N0LvojHwp9F/PUrZLXXSKb7NEXpSXL8EcYIZy+hPU00xzzknx8aEG7sCPBKCVviIvfoJ/zzbksZ/lvT3MVuHN43UOaY8Y8IHCBaHfFiLdIv1QQRUhiIuHEF0MYnW4E6EVUEcn5S0nXT9pH+6P9uo9EGlZ4WAAuAGRZ5DZ1vsijs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=UcqrkKVj; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="UcqrkKVj"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-57d2fc03740so1793073a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 05:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1719492909; x=1720097709; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KV2Jhus+OXpMif6WcrDI5bhMXm30qPlwZGq+tLeLlDc=;
        b=UcqrkKVjOWEZJ6GxNNy7P6WnxHTuxsf6xbSo6623QEarwmhcXWoetdaqMnn+uRVDIL
         MbyRRNeMZXnPk9vj76RaC5byfsogPf9cat7vq1tncm9ELE4k8PTaDMZNzr7tKZGOulTi
         nfEEOQTQNvjIICn+orMzy0Y6tdSA4wKyy+wD19fD0HixuwCtDpwpg5Qds6mgzdNq//3l
         DHOHGVnT6K/Y/pBNH5N4ZlBAXmub9MoJ7Z+WVFtOd1reWNq7Y7v6q24dgL3BvZjXP3mK
         aWngRafES5pyNX2onhK1KBObieJis6pER+FXftlcauA90EaMwrPxbu5n4V2AK0QewCiX
         vefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719492909; x=1720097709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KV2Jhus+OXpMif6WcrDI5bhMXm30qPlwZGq+tLeLlDc=;
        b=MmPjdzTQglE0lveW2IEYvNXxnN/UF0Yj8puKjUpMrJ9lZU8Cm9xhLXMliizLG1phFq
         KU26Zb7ob5ag3qZE8x4Ly99t9MkfaEM1h2Fhj18IUHnMraA+5PM2+0uWpbP3zhBUJqrM
         jMnDh2Ld/ngIyySGHPnAbRPOGiBdiBgFVmRDDu2A0LiCHtRRU3TgqLarUH2D/x41ifMj
         lEi2glVwgdr4CmCczAGX1vmbwpa2Z9qorTQ2dFlDoBnfmKIfvcDOHknIlCTKd4W6bftd
         s/UWdSbeVVI/7EhNSR5LvQ+zpBxR5jg4bGSjAtvgc8C0PnPqWIpxF1Eiac6dV3HvlTQq
         TRkA==
X-Forwarded-Encrypted: i=1; AJvYcCXUJsjxldJnNYjTp5G4iwxVvgj/YyMsd8GIG/3ppHbNiTSo+MDHfzmbdN8jnpZmqAsVzfUlD7qIQdriJvjvbCOISX2H9FoVZhoK3A==
X-Gm-Message-State: AOJu0Yy8HMmImrNcz85/cIYJotLY4d1oG9zsFEud4i+yBSbz2CKaXukZ
	clmCIFxXc9obDtohWqFWcedo5HyEhQ5XrtKVrON8BTNX75aM3kcQeSV4BC3lI516svG3BWYTakn
	vIrcENip7sNJI5uK3cJgh76IYxD5h8Y2r7RHPEA==
X-Google-Smtp-Source: AGHT+IEwk5RD6nihuxTjJ8SQtviL0Wb0/3Jiu4h/ED2HVymctlWOu2V2rnNzMu7+f2Uvx90KsSu2i2wMUPyMVmkskW0=
X-Received: by 2002:a50:9e29:0:b0:57c:6767:e841 with SMTP id
 4fb4d7f45d1cf-57d4bd71015mr8596646a12.13.1719492909356; Thu, 27 Jun 2024
 05:55:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240627124926.512662-1-hch@lst.de> <20240627124926.512662-5-hch@lst.de>
In-Reply-To: <20240627124926.512662-5-hch@lst.de>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Thu, 27 Jun 2024 14:54:58 +0200
Message-ID: <CAMGffEm+8fD-GPwQMHyaDh6+mF7fG97YqYj5VF7i+svu75wJhQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] rnbd: don't set QUEUE_FLAG_SAME_COMP
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, 
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, 
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
	Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Sathya Prakash <sathya.prakash@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, linux-block@vger.kernel.org, 
	megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 27, 2024 at 2:49=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> QUEUE_FLAG_SAME_COMP is already set by default.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

 Acked-by: Jack Wang <jinpu.wang@ionos.com>
Thx!
>
> ---
>  drivers/block/rnbd/rnbd-clt.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.=
c
> index 4918b0f68b46cd..0e3773fe479706 100644
> --- a/drivers/block/rnbd/rnbd-clt.c
> +++ b/drivers/block/rnbd/rnbd-clt.c
> @@ -1397,7 +1397,6 @@ static int rnbd_client_setup_device(struct rnbd_clt=
_dev *dev,
>         dev->queue =3D dev->gd->queue;
>         rnbd_init_mq_hw_queues(dev);
>
> -       blk_queue_flag_set(QUEUE_FLAG_SAME_COMP, dev->queue);
>         blk_queue_flag_set(QUEUE_FLAG_SAME_FORCE, dev->queue);
>         return rnbd_clt_setup_gen_disk(dev, rsp, idx);
>  }
> --
> 2.43.0
>
