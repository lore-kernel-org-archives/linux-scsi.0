Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36586C120
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 03:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759893456; cv=none; b=ll4xKvSIH1f9BJifHradttGv5Zmb8gT3hn8bgmr4QPtmroNIdRODN574BfYBfToPvcqkjxCGc+me4/oiT3hCBjtm7iAe5zhKAbmJiwzUAyDNjVA7T2AHqyYY9ZdYG9yu8Jrfkjqs7DBlWkn4mmx8tLAFVn5u7a3WVV8tBo0vKNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759893456; c=relaxed/simple;
	bh=qe93Ixq0d7Bpsro83b9tVt5NsJP9xbSGkq3I73IHNys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PAGpCntKxonYWVQb0L8hjAdMl5eeZ+S1UvKAF1FRGMFxVD6fmAuNlpXgWRnCuM7A0wU5OtyF1TCNBnUcTuIX7zu/osVyhTpV8b0OicZr6rnqYb4YTKxaveC8ogu6fBYoA2GW/MU90IdsKIxxZJJddeXCZmPOygz6g4UBdADWRrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZlZHuj2z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZlZHuj2z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759893452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3xXK6jsciAtc4DngVeI/obr3kbnlsly9xkp8+nSN9Pk=;
	b=ZlZHuj2zZCG4ib34jDiFyKfqUvMgq5N+jrmKirxTEhEly1XgWhhaBFTCMJ8LR9iLYBIqwT
	IRC4l4737o1TRzSgbfvM3E5VqZI/TZLmT0xj57WV4YAiPVjTIT8ovXM7EMTBxgFOrVCabW
	2zoD9CtlI8t4ZfMZxbvCkQ5DgbfiaDo=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-5xP6Dg5kOMyB_Oe4Wn96Vg-1; Tue, 07 Oct 2025 23:17:30 -0400
X-MC-Unique: 5xP6Dg5kOMyB_Oe4Wn96Vg-1
X-Mimecast-MFC-AGG-ID: 5xP6Dg5kOMyB_Oe4Wn96Vg_1759893450
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-54a7a912f1aso3746856e0c.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 Oct 2025 20:17:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759893450; x=1760498250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3xXK6jsciAtc4DngVeI/obr3kbnlsly9xkp8+nSN9Pk=;
        b=LZv5GmXn2s5MQ83upeFYnpoc3NnhmN6Gbb0IaWRz2C7F67t3YmWKqPW3oje5LVCtg3
         NIXOA6OwHLi9aQEE248+qy691IaQZz5Fw0Dj/ZrHnyy2QmP3Fk2I4FlQ03gHTU0xrZHn
         Vw4/vr3vDY2dNjJ+rdITjgX7y+pwntZMt7+7NvK2Hwyk6DYexDhpNuSBaysRmNrF8kLj
         /37x3GWDT94XcEm7mEwaL2ufmUlSPul9iuWKS8FII4bbWmNrJfbnZ8W92nOpjY7SsOnr
         dsPLR2jHiQLpo2loZWs7WfDPXU3P/Tes28em+rVM6GO85Vfki41huK9FilZ7LNcVqKJq
         f2mQ==
X-Forwarded-Encrypted: i=1; AJvYcCUq0flp/iOb3/Mp1oWf1gX1LKshhmjvVvnMUEsPjdJg3Xfk2xUpOfjPOr3Xl0ea1ORhbt3/nBdXCiyp@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/4A7Fipvpx7ubw8S7mbbu8SBhrlK/BrwbsgY+aJguH0S0BByW
	MwKl+0NrVC5u73hsRKKF8uBliAL7gbxYKkj7uLanHcbsntljDMVo1w0sB12mHOPJB8MuecSMMhD
	a5LCHaWuuGMHxIElUYHhZ1Rj7MR7/+9u2H9Z6txWaI73+Odlb7c5DYJzIxdGgmNGSyo8sDXdBEr
	DR0eY3vVJc2a8MO0zO9MpOwRtNoqTiJzT5mccSmQ==
X-Gm-Gg: ASbGncsLmOsjXIsO18GRWnRglSk6qtfxtuUTx7DgO8YMjVkRej2EXOH/aun98SSdN5N
	MyvAJQDihb28/HycC34NmWm35Wliz0Gw2poY70S+6izHbvTYbWJ0fHCJQ7/gC8ji4T/yTdOAbKj
	8QsuOLwpr8FJPBDo9BwQySGs7uaus=
X-Received: by 2002:a05:6122:917:b0:541:fdc4:2547 with SMTP id 71dfb90a1353d-554b8b8f95bmr772253e0c.4.1759893450089;
        Tue, 07 Oct 2025 20:17:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFG+n4/K/N3u3lNS6vammM7FoX0OcN3gtLdE7XeBFTBQRn2doZvOb8S8W1tA9LN0X1guk5h/5CRCCMuRX+CkRs=
X-Received: by 2002:a05:6122:917:b0:541:fdc4:2547 with SMTP id
 71dfb90a1353d-554b8b8f95bmr772251e0c.4.1759893449762; Tue, 07 Oct 2025
 20:17:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251007214800.1678255-1-bvanassche@acm.org>
In-Reply-To: <20251007214800.1678255-1-bvanassche@acm.org>
From: Ming Lei <ming.lei@redhat.com>
Date: Wed, 8 Oct 2025 11:17:18 +0800
X-Gm-Features: AS18NWCAzy1rtuYhnYKdvEjGvOTb3dO8STdjLwXuQzKoLdIZn2jmpnPosyPyJSk
Message-ID: <CAFj5m9K1L7n3C9mL0zgNXmzhttD-B-64LBNbcp=HCPYPNvgjMg@mail.gmail.com>
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by scsi_host_busy()
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	Sebastian Reichel <sebastian.reichel@collabora.com>, Jens Axboe <axboe@kernel.dk>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 8, 2025 at 5:48=E2=80=AFAM Bart Van Assche <bvanassche@acm.org>=
 wrote:
>
> Commit 995412e23bb2 ("blk-mq: Replace tags->lock with SRCU for tag
> iterators") introduced the following regression:
>
> Call trace:
>  __srcu_read_lock+0x30/0x80 (P)
>  blk_mq_tagset_busy_iter+0x44/0x300
>  scsi_host_busy+0x38/0x70
>  ufshcd_print_host_state+0x34/0x1bc
>  ufshcd_link_startup.constprop.0+0xe4/0x2e0
>  ufshcd_init+0x944/0xf80
>  ufshcd_pltfrm_init+0x504/0x820
>  ufs_rockchip_probe+0x2c/0x88
>  platform_probe+0x5c/0xa4
>  really_probe+0xc0/0x38c
>  __driver_probe_device+0x7c/0x150
>  driver_probe_device+0x40/0x120
>  __driver_attach+0xc8/0x1e0
>  bus_for_each_dev+0x7c/0xdc
>  driver_attach+0x24/0x30
>  bus_add_driver+0x110/0x230
>  driver_register+0x68/0x130
>  __platform_driver_register+0x20/0x2c
>  ufs_rockchip_pltform_init+0x1c/0x28
>  do_one_initcall+0x60/0x1e0
>  kernel_init_freeable+0x248/0x2c4
>  kernel_init+0x20/0x140
>  ret_from_fork+0x10/0x20
>
> Fix this regression by making scsi_host_busy() check whether the SCSI
> host tag set has already been initialized. tag_set->ops is set by
> scsi_mq_setup_tags() just before blk_mq_alloc_tag_set() is called. This
> fix is based on the assumption that scsi_host_busy() and
> scsi_mq_setup_tags() calls are serialized. This is the case in the UFS
> driver.
>
> Reported-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> Closes: https://lore.kernel.org/linux-block/pnezafputodmqlpumwfbn644ohjyb=
ouveehcjhz2hmhtcf2rka@sdhoiivync4y/
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/hosts.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index cc5d05dc395c..17173239301e 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -611,8 +611,9 @@ int scsi_host_busy(struct Scsi_Host *shost)
>  {
>         int cnt =3D 0;
>
> -       blk_mq_tagset_busy_iter(&shost->tag_set,
> -                               scsi_host_check_in_flight, &cnt);
> +       if (shost->tag_set.ops)
> +               blk_mq_tagset_busy_iter(&shost->tag_set,
> +                                       scsi_host_check_in_flight, &cnt);
>         return cnt;
>  }
>  EXPORT_SYMBOL(scsi_host_busy);

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Long term, the UFS driver need to be fixed, this or most of scsi core
APIs should
have been called after the scsi host is initialized.

Thanks,
Ming

