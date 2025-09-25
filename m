Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0035931A555
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 18:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758825832; cv=none; b=FeXCOV0Xn+PArDqy2HuWkPwGb8ieVyi8QBVvSE84GnnfFwAwEhb1vHlpE60JWAIlWFbl86tm5QzW7/7I4F2CSZoyu+ouA3GTAmy7HLrSW/Inm8TygwYYZyyM9dViBJkEmD3mUzNXoSxf6JtJE3FbpcFzPMNCNPsoBk53nZML4Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758825832; c=relaxed/simple;
	bh=/EsSPc0xo+BwHuhAuOwZV2CXIW3EGHEN86sfgis0Rdg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M7ythOxHjBhAgkn6Kud3q1WFMIbrGiigVlCirlaIlSJL6e17SZBGNevWcQ4H0P8UrkoDeFTK/8ei+eix/QV/I3+mOcAdtbglgyDaCBl2zI8oFqM2lC2+KcjxoXAQ0hQEey4bND6PWt+3iT94fAVaV4N7dxEEe/OWrZEjS8alJgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qo8uMwRR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qo8uMwRR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758825829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GCwL8SXUdlfwXeL8qzp+u5OC8lgUfGYR3U0v0leyOhE=;
	b=Qo8uMwRRaLOhYY2N55yDPD1LwOwTst/XQSy+ZuH3qA47iW/dzLwEvlpNQU5tC27DgRAZlN
	7nM2gv7F0R/X/mNb2OYieWfndS0suUZF7FQB40WYBzSA1XAKzDCFsBuCwqk/brAeMlwup8
	mbnkev1GYXjVDIJO46u1vw8EQJj1DEw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-REb99wcyM-q8hr9lU-Ciig-1; Thu, 25 Sep 2025 14:43:18 -0400
X-MC-Unique: REb99wcyM-q8hr9lU-Ciig-1
X-Mimecast-MFC-AGG-ID: REb99wcyM-q8hr9lU-Ciig_1758825797
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ece0cb7c9cso1075269f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 11:43:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758825797; x=1759430597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GCwL8SXUdlfwXeL8qzp+u5OC8lgUfGYR3U0v0leyOhE=;
        b=n8P6TWAq5lJum433/aX6EqgTdn1KJPvO6d3lTDeLIKGExWsv64axMTi1+uOs9KojFo
         fI7zkYqktAWlygHc+IZC1uGCurixdtc0uHQDTsL/uNm2Moh/04dkwpwxzMxG+thha8N4
         8GyGE9VbWtxua8OAMhQ+Ttwezpp3kAMkutyx/SdB1yNuwC/3f33j8Oks/C/stRVslpAV
         32w/Hd+xu/3jv+08UriA39oqPdOhqKnmZG2omK4pLM8kCizsr1F9Kuw8fS5l5IDV4cn8
         rotiqX55/phmtA8Ne73fZ7Nrq6QkR2fhclWqMrhuq824w5oIRwB2gJbv44AJ74Fzr0CE
         dvyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUO99xp5gNpj6j18JQZlLz1Re0G0u+2ZdhYHH2F4WXxzkcOMdA7KnKLHvbR1MQFB86GsOqfBz3Djsmi@vger.kernel.org
X-Gm-Message-State: AOJu0YyUmRWToLjxP+vn+rJQOv7SESRR+yGw+SCOCGhjwRueY8VwEuSs
	7OynMuaNNItDgbGcze4YyTsVxu+dtvsRxYlNVD3rHCrZM9Icc8N3gg+h+xxOVP5Vvo9ElnPmDYF
	3XaJrz5nmWq/jNiZkiFmqOFhYUZFJQcJT0ClrENaVQEs/WKXPFoOcD2YmBMT8IvkXPUcuCE8tZk
	gRpfdzGUdGD3b3ZXG1D65y7sH3uClAccpzzVOYOQ==
X-Gm-Gg: ASbGnculeWK5xVoWlQqXF/Gs7L4K8GUiOYBwt1KhEG/xjI26J0coRKsH80/scLsM/lg
	fKNo1UP17MsQSeuXijPkkOEv+Ivq8xcN++TuyGMvnP7PntCyB0BPuETwasJXvb6AKmHh/oK76hp
	XVLQwHvxaewAZqDsMv/Ah4+w==
X-Received: by 2002:adf:a314:0:b0:40f:5eb7:f234 with SMTP id ffacd0b85a97d-40f5eb7f48cmr2845633f8f.5.1758825796902;
        Thu, 25 Sep 2025 11:43:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGE88PMsbz8pPK3SEua9+FkvwWXj3+M2OYdB33VngMoCil+x4wPGRNDKD5gCmIANA4SBdzwL9F5/1f+LVE1qRc=
X-Received: by 2002:adf:a314:0:b0:40f:5eb7:f234 with SMTP id
 ffacd0b85a97d-40f5eb7f48cmr2845619f8f.5.1758825796463; Thu, 25 Sep 2025
 11:43:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <fbbef12e-fc43-464f-b92d-f42f3692a46c@redhat.com>
 <20250925170223.18238-1-bgurney@redhat.com> <e58d743b-a999-4e00-8f2e-31707744c5bb@embeddedor.com>
In-Reply-To: <e58d743b-a999-4e00-8f2e-31707744c5bb@embeddedor.com>
From: Bryan Gurney <bgurney@redhat.com>
Date: Thu, 25 Sep 2025 14:43:04 -0400
X-Gm-Features: AS18NWCHTZQIxNrKgiFSSzKrwF5EleTnCC_ffWawvQOYJkv4JLiwwoWDLY4SGGs
Message-ID: <CAHhmqcTdC_we4x9e0Q-NT=k-9LM5Q8azFH51_Wbpr4tKgpOzDg@mail.gmail.com>
Subject: Re: [PATCH RFC] scsi: qla2xxx: zero default_item last in qla24xx_free_purex_item
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, kbusch@kernel.org, 
	hch@lst.de, sagi@grimberg.me, axboe@kernel.dk, james.smart@broadcom.com, 
	njavali@marvell.com, linux-scsi@vger.kernel.org, hare@suse.de, 
	linux-hardening@vger.kernel.org, kees@kernel.org, gustavoars@kernel.org, 
	emilne@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2025 at 1:23=E2=80=AFPM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
>
>
> On 9/25/25 19:02, Bryan Gurney wrote:
> > In order to avoid a null pointer dereference, the vha->default_item
> > should be set to 0 last if the item pointer passed to the function
> > matches.
> >
> > BUG: kernel NULL pointer dereference, address: 0000000000000936
> > ...
> > RIP: 0010:qla24xx_free_purex_item+0x5e/0x90 [qla2xxx]
> > ...
> > Call Trace:
> >   <TASK>
> >   qla24xx_process_purex_list+0xda/0x110 [qla2xxx]
> >   qla2x00_do_dpc+0x8ac/0xab0 [qla2xxx]
> >   ? __pfx_qla2x00_do_dpc+0x10/0x10 [qla2xxx]
> >   kthread+0xf9/0x240
> >   ? __pfx_kthread+0x10/0x10
> >   ret_from_fork+0xf1/0x110
> >   ? __pfx_kthread+0x10/0x10
> >
> > Also use a local variable to avoid multiple de-referencing of the item.
> >
> > Fixes: 6f4b10226b6b ("scsi: qla2xxx: Fix memcpy() field-spanning write =
issue")
> > Signed-off-by: Bryan Gurney <bgurney@redhat.com>
> > ---
> >   drivers/scsi/qla2xxx/qla_os.c | 8 +++++---
> >   1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_o=
s.c
> > index 98a5c105fdfd..7e28c7e9aa60 100644
> > --- a/drivers/scsi/qla2xxx/qla_os.c
> > +++ b/drivers/scsi/qla2xxx/qla_os.c
> > @@ -6459,9 +6459,11 @@ void qla24xx_process_purex_rdp(struct scsi_qla_h=
ost *vha,
> >   void
> >   qla24xx_free_purex_item(struct purex_item *item)
> >   {
> > -     if (item =3D=3D &item->vha->default_item) {
> > -             memset(&item->vha->default_item, 0, sizeof(struct purex_i=
tem));
> > -             memset(&item->vha->__default_item_iocb, 0, QLA_DEFAULT_PA=
YLOAD_SIZE);
> > +     scsi_qla_host_t *base_vha =3D item->vha;
> > +
> > +     if (item =3D=3D &base_vha->default_item) {
> > +             memset(&base_vha->__default_item_iocb, 0, QLA_DEFAULT_PAY=
LOAD_SIZE);
> > +             memset(&base_vha->default_item, 0, sizeof(struct purex_it=
em));
> >       } else
> >               kfree(item);
> >   }
>
> I see. I think it's probably better to go ahead with the revert, and then=
 apply
> the patch I proposed in my previous e-mail (it's more straightforward and=
 introduces
> fewer changes).
>
> If you agree with that, I can submit both the revert and the patch.
>
> Thanks
> -Gustavo
>

Hi Gustavo,

I just built a kernel with your patch, on top of the NVMe FPIN link
integrity v9 patch set, and a test run on qla2xxx passes without any
field-spanning write warnings, nor with any null pointer dereference
errors.


Thanks,

Bryan

