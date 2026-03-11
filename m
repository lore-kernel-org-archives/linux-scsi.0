Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A552348463
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 15:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773241757; cv=pass; b=f4Ev5aYQJEMvInNkTbJhIEitwka8ShpM60yhrLqM9OW8QBuqpxgeTszEge5Tiw1xvZVKcyFDhZHmm95ziD8WzIqZCD+xISiZqk8kTHlkvH8RxpLn5lPvbaFlALFesOK2lW5d9FePL5Pu1PEOGNFWquYD05e3zBgvWI9/aUN2sCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773241757; c=relaxed/simple;
	bh=sr8EJ74h+PCWaP6DpleCKt+jfKdqyljjFBE6im8GNXo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EJBPdUIe66aWFBg4GP/LRp6ZfAGkjOVjjxQ9R4tD1ZPJNpxYffFuOz4IOKT0uYUl6LVX1Kjxs0sLvvU1SOY07grNJs+ptSOZExT2ZnJJJVqFmNOooq6dra/+fw3s5dWvxcTK8C91mBQAVa4woD1ATlCvfz2NiUlsrPTLXAEVzTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RL5ZMe+s; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dB0octQG; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RL5ZMe+s";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dB0octQG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773241753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eAixbPiqiWKvxfTtqwLl1ZycNxKKR9XvSIdM8Jl9/1M=;
	b=RL5ZMe+scySmI6MzfpFmiQ/AUch0/RAQh9a0i8rQMWqLtLFeFIgLPBaXuTDNIaI70t4Ufg
	9xibD2hWALCC5foT0fcUG7nGEiXieH8+0h0/kCadEYcMLXMJBvNXtBJk97jL2zntaf7NJz
	9Qu/BjBGHDwdUlbixoHB4dymApb2qzs=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-PbuHLkULN32D4zulH4I_OA-1; Wed, 11 Mar 2026 11:09:12 -0400
X-MC-Unique: PbuHLkULN32D4zulH4I_OA-1
X-Mimecast-MFC-AGG-ID: PbuHLkULN32D4zulH4I_OA_1773241750
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-38a2ad13c07so133261fa.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 08:09:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773241750; cv=none;
        d=google.com; s=arc-20240605;
        b=kjgcnPCmvEmwmowhPPl8ye4OmcIZtVsIhpTVGrAYzXqZthK2n6KXXrcoMsMYXLXtPK
         lbHO6hqYujZUMQqMWtfbjASDPd4jtdRVATyxUZHw+ov/1ygxrQq692evyAvIl7azvb3I
         aSto3du+tx5Mh2q3PfKsvFs76/QsvjIwPyDtO77enP7Id9U0LhbOF1TPnNOy4dRzNR/M
         iAIVJVSJtf8kkI1r5LKIKY0QKH6YHccu+AQDgvkCqkV6YjTM4kgo0paEgDtKSp9H1m00
         /m233uuxjIn7F6C0YfNQ4u2vCE/GwBfKHMjpI+wNNE5zb/kFhvZH0hYmQy4Q5StWf2pC
         jHtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eAixbPiqiWKvxfTtqwLl1ZycNxKKR9XvSIdM8Jl9/1M=;
        fh=eg+unm7iNWO2abph6sCeXWmUb2wgA8Gu0sj3vTod8Qs=;
        b=VhKp8fo6eFv8vHMJfUX2ypZdyMMXd1mtmJ+TtAsYFKUKf1aneS1fxoS8IZAUuF22Ot
         wrscSVjTXPl2Ijv2xbRR3m2fpzPpSDVa/HdfVaD190xbi9a5uoFoofjqICXxV64Vztuj
         0/sh8wgbjaiUW9EOvufPmRAZJs7Iu1HbcSNgJg2z8PmBDOhVBpXz1IfdbURogNmn7pcQ
         JA5dj5g1dCHI1ulLYspvLJBYCA/xy5Po5b1GrRiSgCjIzyah80GZEo5eZjkBIPffFo/k
         us9KpJWahRSflQWbQbYpgU3A7twxc1eMrXNCfgo7tKS2IiBtB/1eweYML49x0ZW89I4+
         IfSw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773241750; x=1773846550; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eAixbPiqiWKvxfTtqwLl1ZycNxKKR9XvSIdM8Jl9/1M=;
        b=dB0octQGlhykp0hEvoSV8X1man1Mt4I+4ZE/XgE4SjsboNvTB/6bVyWyxaQXB84rsG
         xvF/Z9COgnnl3aKEzf2C6yze/8MdP7aFi9+bn3a5x9pyEHCyjXjSDEO5Vz0GDIXDmN5+
         +VuwxTrHf1g3BvXJcogXBDloLqwS3wQuW0r5MaR/g50LEH/miAXwlMv2Cxxj2zAMaihh
         IiPM+vSqOV3utoJc2Ul0QH9CibmbxZAzZg18Czlk6CobBuwLLmQ+YRZUsbcKOG0oTsM8
         MGkzB6UqkvZbEEXw6Ny8xOLpVtnTC3NZWrJi6bXawOZV67ShUqdL838elWDQsx9O008f
         aDzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773241750; x=1773846550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eAixbPiqiWKvxfTtqwLl1ZycNxKKR9XvSIdM8Jl9/1M=;
        b=a6z+NJB9YSvaeCfaZezo3eVdUx2IooVZxw++y8TDmNtbKQZzTNV9b85wxwQaKmtgwB
         NZfG4sLBFTC34HX5Vh7xrFXgcGbb/aUWpsUIxgeJguwH42YP/iRgZ8zPU2FI9nYuV+ct
         9DxvTOe3S8weXmtewYdiRZhPUI2HnQCPvavxwbdzBFHJRbKyTWvwJK0Zpby02TGuqTvC
         fxJ60Ioslt9NPtgLseUgIl0A8Pji+OQaTi8avu+DPtpwEV0/z4nl5r3BinrluQH9MGFN
         uEZDrwN1sp8eiTzsVPGSNxEcz2h+9iEI2GjTQXukOBeHTlbEExam0hU/7CblqPhCUJZQ
         qJkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVgPO1nUqBcKSetVXLNSAx+b+gmG8D6+FapTAaYC2jCFUQmcJmXfO9wmLpe2SwPmdsFONT66kigVk3@vger.kernel.org
X-Gm-Message-State: AOJu0YzlwBrJ5uMxAXYqGRjY97SFURnGaEVS8IZFcZ4gkBEsGrtWk8a/
	yjCAw02CLsW0bugn2VrX4Swl2ZhscbFvVUN2ZaJRb8ijAt2JSRv6iFuZH9sQpyg/GtIX+84dBT4
	iueQ3TsAJtwwOlmUARXdz1dBYgF+blNVDRi504XukRlEdbXhDwGUkgdpZP62Iri6kuCaLpPv6/n
	NgmLJjbQASNkPPCiu+Yo/KJ6eD9EJ2uc4u8AjuoQ==
X-Gm-Gg: ATEYQzxSbz8JzdzJevPcjgLIYhOlmOny4ZSIpkJ73NMFnEwRF11yqQNs9jFJmyx2UYK
	39A9NgHXroeiPNbO0O77yZpOjOrpvjuHeH3USmie6Xt0kESEqYZaQmneCe/gx8JIYySl6T6f2uh
	ZU6C7EWPqnQlu+VxRSj4KjO/55lBh3VUqoJZIEBRZ3ZvMe7leTsg8eVsKUaAhc1xm43yBpR1K88
	o06BHulVfKHN9KXc5XUMQX1NejJCBgXxIGHca7yF/flrWjk6Oc=
X-Received: by 2002:a05:651c:551:b0:389:ee7b:4d4b with SMTP id 38308e7fff4ca-38a67dd60d3mr11561821fa.12.1773241750314;
        Wed, 11 Mar 2026 08:09:10 -0700 (PDT)
X-Received: by 2002:a05:651c:551:b0:389:ee7b:4d4b with SMTP id
 38308e7fff4ca-38a67dd60d3mr11561701fa.12.1773241749845; Wed, 11 Mar 2026
 08:09:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aZ_-cH8euZLySxdD@shinmob> <CAHj4cs8mzSZez+n2qLu5931YAuQ4=RxNt6D6YJCsMEwGrm4UtA@mail.gmail.com>
 <DGZRYXTKC049.1I6QFQSMSD88H@arkamax.eu> <DGZTXRKSHBPC.2B318HF53ZRSN@arkamax.eu>
In-Reply-To: <DGZTXRKSHBPC.2B318HF53ZRSN@arkamax.eu>
From: Yi Zhang <yi.zhang@redhat.com>
Date: Wed, 11 Mar 2026 23:08:41 +0800
X-Gm-Features: AaiRm52s-EH5ucY3yGw_WaFk4XtbskkABtsWUN8MID31uF9eSwnbqLdAEQHevQY
Message-ID: <CAHj4cs_nQEbeyvqvos7pwek8k0rLLXCghdoY9EsL4bCgZrxqtA@mail.gmail.com>
Subject: Re: blktests failures with v7.0-rc1 kernel
To: Maurizio Lombardi <mlombard@arkamax.eu>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "nbd@other.debian.org" <nbd@other.debian.org>, 
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 5:02=E2=80=AFPM Maurizio Lombardi <mlombard@arkamax=
.eu> wrote:
>
> On Wed Mar 11, 2026 at 8:29 AM CET, Maurizio Lombardi wrote:
> > On Wed Mar 11, 2026 at 1:35 AM CET, Yi Zhang wrote:
> >
> > If nvmet_rdma_rw_ctx_init() fails, shouldn't it call
> > nvmet_req_free_sgls() before returning an error?
>
> Possible fix, not tested:
>
Hi Maurizio
The kmemleak still can be reproduced with this patch:

unreferenced object 0xffff88811db23d80 (size 32):
  comm "kworker/16:1H", pid 1360, jiffies 4296118279
  hex dump (first 32 bytes):
    82 3b 85 04 00 ea ff ff 00 00 00 00 00 10 00 00  .;..............
    00 e0 4e 21 81 88 ff ff 00 10 00 00 00 00 00 00  ..N!............
  backtrace (crc 4bb38867):
    __kmalloc_noprof+0x6f1/0xa10
    sgl_alloc_order+0x9e/0x370
    nvmet_req_alloc_sgls+0x294/0x4f0 [nvmet]
    nvmet_rdma_map_sgl_keyed+0x25d/0x9a0 [nvmet_rdma]
    nvmet_rdma_handle_command+0x1ed/0x4e0 [nvmet_rdma]
    __ib_process_cq+0x139/0x4b0 [ib_core]
    ib_cq_poll_work+0x4d/0x160 [ib_core]
    process_one_work+0x8b1/0x15e0
    worker_thread+0x5e9/0xfc0
    kthread+0x36b/0x470
    ret_from_fork+0x5bf/0x910
    ret_from_fork_asm+0x1a/0x30


> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> index 2d6eb89f98af..79ae743bb405 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -892,7 +892,7 @@ static u16 nvmet_rdma_map_sgl_keyed(struct nvmet_rdma=
_rsp *rsp,
>
>         ret =3D nvmet_rdma_rw_ctx_init(rsp, addr, key, &sig_attrs);
>         if (unlikely(ret < 0))
> -               goto error_out;
> +               goto error_free_sgl;
>         rsp->n_rdma +=3D ret;
>
>         if (invalidate)
> @@ -900,6 +900,8 @@ static u16 nvmet_rdma_map_sgl_keyed(struct nvmet_rdma=
_rsp *rsp,
>
>         return 0;
>
> +error_free_sgl:
> +       nvmet_req_free_sgls(&rsp->req);
>  error_out:
>         rsp->req.transfer_len =3D 0;
>         return NVME_SC_INTERNAL;
>
> Maurizio
>


--=20
Best Regards,
  Yi Zhang

