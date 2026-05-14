Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB902741B6
	for <linux-scsi@vger.kernel.org>; Thu, 14 May 2026 02:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778725588; cv=pass; b=JXHwvmBwdOCgZXk1jgLhLmNaCXFEUj4+/FcMFbJThWkZIJBwsuubged1fABAa+MaH5p6EbhR6hqDp0j1caUtLPmpj+mYGnCOsDhk7faTKn+bRLCcl1XeH2I+dudjngQqdoyTyxV7Rg/ZgC0aUufI9b0UdXqEIy5VYDi0yOau2nM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778725588; c=relaxed/simple;
	bh=P4yfmJJT8N6Nt05n/Tl4I4+mKmWwbD9BE0u/XKoXZZk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z+zbLdCxkjeCJwWrHwjkKiUnwh9MaLZ6zdXlatuEKOBcTIY/Ya8IwiHVKPFgBAtJxmllWLUmQy/z4JaLmr4Q2xATK5g9hohkhFrZsdKwPV+z5i3K79epPy1s/CftYh88cG9pO2tuKpKJm7mBCYiZWigkRurn4D2v91+l0n+tvHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IfBPbO3G; arc=pass smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IfBPbO3G"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-30246cfd41aso2146237eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 19:26:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778725586; cv=none;
        d=google.com; s=arc-20240605;
        b=llr9O9c42xDHPFakTjtG/DdpPVpYOZ7HrycOy7boEAwpDn8GQ2+cx6uyjqpKXmQwOj
         VXJ/HLhUZogMv5O6hzktVpmOwv//xyPl7V1Zn8diauxQuHvYWoHOqQYAMIac7cK1lUjQ
         X0dJVpnSei22QOcWP3NWUz0xsM0Vsd6OP3l280mj/LQFvn1xeIPZrjHXw0l4FR0dO992
         4TBRnAajA/BFglh0P3qo/LjaIzU+Kzw7m3H15CCO3dIj3Gaa+6td30bbfR7qdKu+BsmC
         ZPC7lUMfY1qrtl+rnesJoHNJuRgZI1fspbquyLLwy2iOYAA5Udg9WVebj1OEUMgvXVOn
         EGzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gV5PMxG5gsDWEMyQs3N9vUcvd4wOJ+6kAS8IQe7BwV0=;
        fh=N1dAvOosMxZ7jf/AvM1XnoRQftUdnFVCMnDZk2Xr9sc=;
        b=HE8UU5XZMMdID5rr24l2wUViputOaQ85zSciVh02mht5rmct4AzUBXOYaUUf8e3DQ9
         1jvr7KWufrVUKYaPWjHGLY1Xwe6ZWCTdWVy/doFg9dEfBUYl0Ovrn93izQIHuigTdNvO
         /m7J3/fWazFrGGTPqUF7UelTj6OfC76Gimsk/+9dGZwCqax46jPPsEoEDzolYRLEON8X
         ZTXjzyj6gyvgiU5V1z82FQpj7mlGx5ObZi5oO/QuzN7wL3hZT1dje4dnX7UUiS1btbEo
         s99IgztiQs9M0BU8oG10CyYJ0/ABzZquo9K5vDACz4rJzE2dw6tOFhTyoVfba8K4lVjl
         ripw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778725586; x=1779330386; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gV5PMxG5gsDWEMyQs3N9vUcvd4wOJ+6kAS8IQe7BwV0=;
        b=IfBPbO3GZI0jz/bqGHlgWFW7lov5qJEZs4x2uFJqR2mGgaRHKwb30CgWowkZBSbBEd
         1TUk4H4XDZdnze+C6BWYfH3uZkfgVzRP9APulzUxpc3yZBGWX48WBUQ57a6bl8Gv8Y+O
         zlQKWDgY3dIet1exeVSZOk1Qvy7WrWrOtw0Lejr8lR7y906rCKq9HW27sq//MfaAFVzH
         KHn+AJuQkg+vZTXvXwxSbzdhfxZ2bk9T3ye4mzy/gLkT/usC1a+Cuq5719ZuR4bn8XRw
         FH6pbM1XVQSi4hHmFtAtZw4qoXUHZ2mIADI5GDaefRd7YTCYyu+3w5rpaLOAYc6A3RMi
         ww5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778725586; x=1779330386;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gV5PMxG5gsDWEMyQs3N9vUcvd4wOJ+6kAS8IQe7BwV0=;
        b=Qq9/j0ksN5cxOvbGOlOUFhZWyKIL3MLyacF6mH05zmkv/2Nj4Y1gaglQqrnmdip3Vo
         TTEJPiwQ7SCiU1BRztOMCGY24Vbn0RNOdMk5m1JgSYJzYfE6+k1oKy7UMx5Q+6qifTue
         p5gzImhK/oLniUblUsGkbVOp7iiByK7FK19yRbg7IXB8MN6pHAYq4z0dF6goLZ+Q3jue
         3wTYSObBwIby4OGXAWtpYw4MTOAU+eSFLmgcGId2is6AHfqhQ6Ffc0nzSeGmKv5AQ2vK
         AnGBrA2JJR7V5XOYD7yZw9kw+7wxUN+OhG57T6NbM71aw79SXRq6vIdjnCoKFagTNzKV
         LR+A==
X-Forwarded-Encrypted: i=1; AFNElJ9pH/3grvPZBTUh2yY1IhM3jZWigTmZbn34Jn/cSe6ZD2whKdeYBTEiNP5b73kQ3SFheWT2ERh+MWd2@vger.kernel.org
X-Gm-Message-State: AOJu0YwwYWUNS9KT9VmyTKPg+w+Mb5q7CcNi2EbvpCxSCJ5+oM0F6DZ4
	cZ7pB2QTvLRHgsOoHfJKmB4QneBXBREOigYbvfRqQcJa4/F22h0cEN3RLE6RUgnEFU1eVXhPwgO
	v5IiV4agFT9IA/TyuOsU5VWdt4B2rsjU=
X-Gm-Gg: Acq92OFjGHCNQAkZ3uGPoDVhaww4WT9jtY0wRkPHbuSmecQOFxTm0mffcXKhu1ZDtag
	mQwJ5J1ZWydGpgVpzJ1PFXn3ZUTbNmWQFtek0GaVXdxNeJCVIBMfscL20iCn95y2JvTqSR3vjMY
	ZLfH9twLCnod0SA5y4ZIyx4/QgMo7jzYTOGUZiK4Ab6EzocT6SwQVe5jbbujHI0I4yWkDYo4FiU
	Qrz78wukEkUP4noIp9nZta+y/u4t7LettkzatMVKw19QkGjqLvMCBINdd1X+KIpOWl5+qQI9GAv
	35Zl2n8=
X-Received: by 2002:a05:7301:678d:b0:2ed:e12:3771 with SMTP id
 5a478bee46e88-3015631e31emr3268419eec.33.1778725585647; Wed, 13 May 2026
 19:26:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260408073105.272255-1-tiala@microsoft.com> <SA1PR21MB6683C18151A933242F826BCDCE062@SA1PR21MB6683.namprd21.prod.outlook.com>
In-Reply-To: <SA1PR21MB6683C18151A933242F826BCDCE062@SA1PR21MB6683.namprd21.prod.outlook.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Thu, 14 May 2026 10:26:09 +0800
X-Gm-Features: AVHnY4IQ9hMDl8gCjETyR0UTT1mOf5ZqHvIB_v00hQBTolu0WBptaTv6w-Q71Nk
Message-ID: <CAMvTesAjq4qeociH-ct=YHkf+vNnAMwakFUTZdQE2ru4AweCjg@mail.gmail.com>
Subject: Re: [EXTERNAL] [PATCH] x86/VMBus: Confidential VMBus for dynamic DMA transfers
To: Long Li <longli@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	"wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui <DECUI@microsoft.com>, 
	"James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, Allen Pais <apais@microsoft.com>, 
	Tianyu Lan <Tianyu.Lan@microsoft.com>, 
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "vdso@hexbites.dev" <vdso@hexbites.dev>, 
	"mhklinux@outlook.com" <mhklinux@outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2026 at 2:30=E2=80=AFAM Long Li <longli@microsoft.com> wrot=
e:
>
> > Hyper-V provides Confidential VMBus to communicate between device model
> > and device guest driver via encrypted/private memory in Confidential VM=
. The
> > device model is in OpenHCL
> > (https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fop=
envm
> > m.dev%2Fguide%2Fuser_guide%2Fopenhcl.html&data=3D05%7C02%7Clongli%40mi
> > crosoft.com%7C0ccfea7cda8e4500ae9808de9540d01e%7C72f988bf86f141af91a
> > b2d7cd011db47%7C1%7C0%7C639112302777934798%7CUnknown%7CTWFpbG
> > Zsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIk
> > FOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3D5Uc%2FM4ZVgJT1
> > NAq08cIlNtfF5oW4n%2FTj%2Bqg3YqBUeZg%3D&reserved=3D0) that plays the
> > paravisor role.
> >
> > For a VMBus device, there are two communication methods to talk with
> > Host/Hypervisor. 1) VMBUS Ring buffer 2) Dynamic DMA transfer.
> >
> > The Confidential VMBus Ring buffer has been upstreamed by Roman Kisel(c=
ommit
> > 6802d8af47d1).
> >
> > The dynamic DMA transition of VMBus device normally goes through DMA co=
re
> > and it uses SWIOTLB as bounce buffer in a CoCo VM.
> >
> > The Confidential VMBus device can do DMA directly to private/encrypted
> > memory. Because the swiotlb is decrypted memory, the DMA transfer must =
not
> > be bounced through the swiotlb, so as to preserve confidentiality. This=
 is different
> > from the default for Linux CoCo VMs, so not use DMA(SWIOTLB) API in VMB=
us
> > driver when confidential dynamic DMA transfers capability is present.
> >
> > Signed-off-by: Tianyu Lan <tiala@microsoft.com>
> > ---
> >  drivers/scsi/storvsc_drv.c | 28 +++++++++++++++++++++-------
> >  include/linux/hyperv.h     |  1 +
> >  2 files changed, 22 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c in=
dex
> > ae1abab97835..79b7611518b7 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -1316,7 +1316,8 @@ static void storvsc_on_channel_callback(void *con=
text)
> >                                       continue;
> >                               }
> >                               request =3D (struct storvsc_cmd_request
> > *)scsi_cmd_priv(scmnd);
> > -                             scsi_dma_unmap(scmnd);
> > +                             if (!device->co_external_memory)
> > +                                     scsi_dma_unmap(scmnd);
> >                       }
> >
> >                       storvsc_on_receive(stor_device, packet, request);=
 @@ -
> > 1339,6 +1340,8 @@ static int storvsc_connect_to_vsp(struct hv_device *d=
evice,
> > u32 ring_size,
> >
> >       device->channel->max_pkt_size =3D STORVSC_MAX_PKT_SIZE;
> >       device->channel->next_request_id_callback =3D storvsc_next_reques=
t_id;
> > +     if (device->channel->co_external_memory)
> > +             device->co_external_memory =3D true;
> >
> >       ret =3D vmbus_open(device->channel,
> >                        ring_size,
> > @@ -1805,7 +1808,7 @@ static enum scsi_qc_status
> > storvsc_queuecommand(struct Scsi_Host *host,
> >               unsigned long offset_in_hvpg =3D offset_in_hvpage(sgl->of=
fset);
> >               unsigned int hvpg_count =3D HVPFN_UP(offset_in_hvpg + len=
gth);
> >               struct scatterlist *sg;
> > -             unsigned long hvpfn, hvpfns_to_add;
> > +             unsigned long hvpfn, hvpfns_to_add, hvpgoff;
> >               int j, i =3D 0, sg_count;
> >
> >               payload_sz =3D (hvpg_count * sizeof(u64) + @@ -1821,7 +18=
24,11
> > @@ static enum scsi_qc_status storvsc_queuecommand(struct Scsi_Host *ho=
st,
> >               payload->range.len =3D length;
> >               payload->range.offset =3D offset_in_hvpg;
> >
> > -             sg_count =3D scsi_dma_map(scmnd);
> > +             if (dev->co_external_memory)
> > +                     sg_count =3D scsi_sg_count(scmnd);
>
> scsi_sg_count() returns unsigned int, sg_count can't be negative. The che=
ck for sg_count < 0 below becomes dead code. Add a comment to say this is e=
xpected behavior.
>

Hi Long:
     Thanks for your review. Nice catch and will update.

> > +             else
> > +                     sg_count =3D scsi_dma_map(scmnd);
> > +
> >               if (sg_count < 0) {
> >                       ret =3D SCSI_MLQUEUE_DEVICE_BUSY;
> >                       goto err_free_payload;
> > @@ -1836,9 +1843,16 @@ static enum scsi_qc_status
> > storvsc_queuecommand(struct Scsi_Host *host,
> >                        * Such offsets are handled even on other than th=
e first
> >                        * sgl entry, provided they are a multiple of PAG=
E_SIZE.
> >                        */
> > -                     hvpfn =3D HVPFN_DOWN(sg_dma_address(sg));
> > -                     hvpfns_to_add =3D HVPFN_UP(sg_dma_address(sg) +
> > -                                              sg_dma_len(sg)) - hvpfn;
> > +                     if (dev->co_external_memory) {
> > +                             hvpgoff =3D HVPFN_DOWN(sg->offset);
> > +                             hvpfn =3D page_to_hvpfn(sg_page(sg)) + hv=
pgoff;
> > +                             hvpfns_to_add =3D HVPFN_UP(sg->offset
> > + sg->length) -
> > +                                                     hvpgoff;
> > +                     } else {
> > +                             hvpfn =3D HVPFN_DOWN(sg_dma_address(sg));
> > +                             hvpfns_to_add =3D
> > HVPFN_UP(sg_dma_address(sg) +
> > +                                                      sg_dma_len(sg)) =
-
> > hvpfn;
> > +                     }
> >
> >                       /*
> >                        * Fill the next portion of the PFN array with @@=
 -1860,7
> > +1874,7 @@ static enum scsi_qc_status storvsc_queuecommand(struct
> > Scsi_Host *host,
> >       ret =3D storvsc_do_io(dev, cmd_request, smp_processor_id());
> >       migrate_enable();
> >
> > -     if (ret)
> > +     if (ret && (!dev->co_external_memory))
> >               scsi_dma_unmap(scmnd);
> >
> >       if (ret =3D=3D -EAGAIN) {
> > diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h index
> > dfc516c1c719..bcb143766d6e 100644
> > --- a/include/linux/hyperv.h
> > +++ b/include/linux/hyperv.h
> > @@ -1285,6 +1285,7 @@ struct hv_device {
> >
> >       /* place holder to keep track of the dir for hv device in debugfs=
 */
> >       struct dentry *debug_dir;
> > +     bool co_external_memory;
>
> You don't need to introduce co_external_memory in hv_device, vmbus_channe=
l already has co_external_memory. Is it possible that you can check the vmb=
us_channel->co_external_memory directly? If you can remove this,  you can r=
eword this patch to " scsi: storvsc: Confidential VMBus for dynamic DMA tra=
nsfers".
>

Good idea. Will update in the next version.

--=20
Thanks
Tianyu Lan
