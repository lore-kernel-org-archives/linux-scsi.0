Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412CB2BE057
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 13:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773323233; cv=pass; b=aBuBITMGyniaXGyh8xGdqqzKYuyDDooUJvjxjRfVfyJA2ouxX5z6flCGi/euWSeg7UYNUuv7t+WzACBeciMelU4Wd0VGS1SUCsBxdT7Cbwmz8NFJhh2rAscdfhCrrrvfZSu1CDJxTukHikFcukjJ8YEelt2qASoeOT1NbvIDKWI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773323233; c=relaxed/simple;
	bh=ZV3VbZ1mNM0aS2EfUb3caDrCm043ueTXRh1wTOrM/Y4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WzrWp0i/yIZSlGWAUsW1PdHr354fRIVRPVOm/l44es3d/JyscKxXIqx4Xq9u+QgBVaB83BWf2QrGoa8/wpEG5rGCz8ciUcZ+ph1yTmeekZwSz7Dg2m9wq+I2HSh/YQ1Vt2zveQSIPVhak8SfWNfg7jcklpcJIL3q8rKtAZ8Dy+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TNJl/l/H; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lgO31Eej; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TNJl/l/H";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lgO31Eej"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773323231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gdlxH/5WUEaVpOS5WFYwF5v8OUn3hB2b+n1tpHi0S+k=;
	b=TNJl/l/HQe5oTpBpF3keEC2A2zIdmOtadlKl6X8p17HScOhCMgyur4Z/z9ZuUCubltxLan
	WjN9aC7lnQ7z2hcSJEp2Y4SRCxLPoO6L4pINd2vrbv29xr074Fy2dph/T7leLOOB7NW+QO
	SJuXXGg3myGwdzH9NOk698owGs+chQk=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-pbS7cEzPOiqnXbbXLl089w-1; Thu, 12 Mar 2026 09:47:10 -0400
X-MC-Unique: pbS7cEzPOiqnXbbXLl089w-1
X-Mimecast-MFC-AGG-ID: pbS7cEzPOiqnXbbXLl089w_1773323228
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-38a80cbf03cso2689911fa.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 06:47:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773323228; cv=none;
        d=google.com; s=arc-20240605;
        b=EiblovvO8zvVdu7QLMpRyd/IAb1DtRTlcTVordbta3IzHFP9JVf4od7Sm8SrcYG5VM
         q3MHo0kcMCvyIOZ3hjzre3tBAq6EbydYH8FJKSrzwbTQzLKG1lU5gZfFVCJ5nQecHIfB
         k0CuLOe49dFtTy33vd09t/aSeWigqprSmdgCASi9EatjuJO1Wc2rCTHm/91jE7PtFF8k
         Kh71xfR80rFV+Lnd2moVBT1MhHTRHP8iUpldt97nroyyVI3SOyKS/0YXGWleUPAjXE28
         0MHpGFcnv9XzWZKzPcjClZnwAs7GTp/P/ckx5v+tKnaxQOJ8s527zRwWDBpkGXk/Kwni
         8YNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gdlxH/5WUEaVpOS5WFYwF5v8OUn3hB2b+n1tpHi0S+k=;
        fh=CxuwgK6ZRqaY5q5GVVymRl3KxJdWdYgVDl8+gs8jwHY=;
        b=IdAmT3Ij0tfx1wFxADxaXSVJJi+zNlA6tM1hjBwNXMdIhr1GIojhvNUM3ZKiwCnziS
         TMMkcZPuI+ucuKnkPNeTjBvrTAW8NciIysxOYaenWNlSk433YbsPKuQkThsM+TURZbu7
         jmtuIwEleO3uUIHSRqGXxxI2JQ9hL6XZ9CK0Q3gw7+CVSBCLeaiisEqY5OrqTrPE0HRM
         SeXTvdoD1Vhq03kkfDSHAlVcRotONt/4LO01Ip4WktbFtUkTpxGnmIsvc7Q2LaPgUY4n
         MJ7apKhm4nUoO+eFj7qaLASh03boUqdlxrRkm4YeLKrYFVED09JJcft4MNDtAbB3c3up
         Cn1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773323228; x=1773928028; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gdlxH/5WUEaVpOS5WFYwF5v8OUn3hB2b+n1tpHi0S+k=;
        b=lgO31EejrsDVSyJRMnmAsJuX3vE1RlU55aGe+itHS+AM4A0l0fTm7izhrQGUrw9hJB
         zNnNywQdnhXx+jK8rd9CfyETOlV3HU2edV/7Sq9vcPQfhwjnwR6mnP2QrnVKk2aZsd8i
         Gsadd8bzvHllb17MKCIQMl25/vBt5Zk78WKBOxrMCKuRKYLfNgC5RnXSQz60ZQoIEgXU
         QsU8o6Rtu5qLRcucZRmNDR5jCvmvdkSTVhFifjc2muleJo+xcX8Q5QLxO7M9rkjZ+W/F
         GpULG9EMKnv0qqXWtOjOqkz/xgo0JMiTsszP12hG8rTRL+WheL3jASKJRjVMfdU79GVB
         HYrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773323228; x=1773928028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gdlxH/5WUEaVpOS5WFYwF5v8OUn3hB2b+n1tpHi0S+k=;
        b=WalnrPHnmDWCXbZlS0d0w01r5fvPAug9ggc50hq0NgKiWKK6WWGu18hgIRoHUufx+X
         ap12Qe/vAAgcKMVwVdeEM/O0bb8xJtE+YaWdKTd/QOhd0ci+gEWUyiK/EGbUgPvjymwv
         R/Wz0VsJKbUyp18Cxuf6Ylt/7/Z92FfRd3xAn0viFGWfZQ26kVrOq/NyRPbuchj6L2nG
         Dk1ZutNTauj3H8SFBHkDv2xEDu/Dh/8LuXdO0O/fPeVyv2td7jTT6KMoD6UNUX9jCTzh
         jNaWfx9UqzppjZafzaprbIxmEibf8YKR/x9Pj7kDvIvR2UKlmhzdZNE6wWGm3GNoY+Z1
         /4jw==
X-Forwarded-Encrypted: i=1; AJvYcCU7mLjROgxEwe9Bghq7AHu4KfqAN5a5MkByl5ZHBPGnZwLJONfNwycW31fy+2QVHiCudegKLb4ZrnoP@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ9LgvAW2b3Oqqvah4oLe6FmmFUYMOpiH9AMLuNTN4147SDusC
	wFJsVrvQHBdzg0uApxnRpJKmAR4bGefQn/RFrE8KjqEuDY3OzrQuQMpMPDVAhJkoIxwI2vbnXau
	XalVwvIkq+G0Xt7unHKE3rarPyE3UrZml0T3csSKN/hUSHv/8ROkqVQRj+/XNVMCacRRJvFyaZp
	ODDTuWy08fTtz4tC5knBR/tn1OnXFlzL6JtnW/+g==
X-Gm-Gg: ATEYQzxsi8yQMF+DKpAYL1Ugwrps6WeviYkpF5PYaaRecbqH662qLFuse0BgC3YwCzv
	UjI4NtVv2Pr0yMEFDbTVz7xtFSwwWvXF2SPD9V5lDrgrwVNLDuvtnAc7bznYK0qjnucTmtmpKbQ
	WYOYqtodnIolmYRxhu3a83Dop/kjgxRhLFtvcqhW9p/Ra6cNuJoP0OYcakJFPv8Wb6PnPTqJB26
	73Z
X-Received: by 2002:a05:651c:418a:b0:386:9653:5d52 with SMTP id 38308e7fff4ca-38a67e7491amr23214101fa.34.1773323228371;
        Thu, 12 Mar 2026 06:47:08 -0700 (PDT)
X-Received: by 2002:a05:651c:418a:b0:386:9653:5d52 with SMTP id
 38308e7fff4ca-38a67e7491amr23213891fa.34.1773323227890; Thu, 12 Mar 2026
 06:47:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311171209.9205-4-djeffery@redhat.com> <20260311230854.GA1051125@bhelgaas>
In-Reply-To: <20260311230854.GA1051125@bhelgaas>
From: David Jeffery <djeffery@redhat.com>
Date: Thu, 12 Mar 2026 09:46:56 -0400
X-Gm-Features: AaiRm52AtdZGk-qB4SJr26Fu0GESy8t58w0K_vuANNjeyWOVb3Y93GXrhdA1CIU
Message-ID: <CA+-xHTFHCvqqg+_XKyvsWUEVo=hqXYARRMVT_nqZkwJOX+o6yQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] pci: enable async shutdown support
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <tatashin@google.com>, =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>, 
	John Meneghini <jmeneghi@redhat.com>, "Lombardi, Maurizio" <mlombard@redhat.com>, 
	Stuart Hayes <stuart.w.hayes@gmail.com>, Laurence Oberman <loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 7:09=E2=80=AFPM Bjorn Helgaas <helgaas@kernel.org> =
wrote:
>
> In subject, to match history:
>
>   PCI: Enable async shutdown support
>
> On Wed, Mar 11, 2026 at 01:12:08PM -0400, David Jeffery wrote:
> > Like its async suspend support, allow pci device shutdown to be perform=
ed
> > asynchronously to improve shutdown time.
>
> s/pci/PCI/
> s/improve/reduce/

Sure, I can clean up the wording.

> I like how simple this looks, so I hope it all works out.
>
> BTW, something seems messed up in your post threading.  I assume this
> series is supposed to go with the cover letter at
> https://lore.kernel.org/all/20260311170956.9146-1-djeffery@redhat.com,
> but the patches don't seem to be replies to the cover letter.

This was from an email issue I should have handled better. For some
reason, send-email hit an error with smtp after sending the cover
letter and failed to send the rest. When I then sent the rest
separately, I failed to consider the threading and didn't think to use
the option to force it to work as a reply to an ID from the already
sent cover letter.

> >  drivers/pci/probe.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> > index bccc7a4bdd79..4d98bab2163d 100644
> > --- a/drivers/pci/probe.c
> > +++ b/drivers/pci/probe.c
> > @@ -1040,6 +1040,7 @@ static int pci_register_host_bridge(struct pci_ho=
st_bridge *bridge)
> >
> >       bus->bridge =3D get_device(&bridge->dev);
> >       device_enable_async_suspend(bus->bridge);
> > +     device_enable_async_shutdown(bus->bridge);
> >       pci_set_bus_of_node(bus);
> >       pci_set_bus_msi_domain(bus);
> >       if (bridge->msi_domain && !dev_get_msi_domain(&bus->dev) &&
> > @@ -2749,6 +2750,7 @@ void pci_device_add(struct pci_dev *dev, struct p=
ci_bus *bus)
> >       pci_reassigndev_resource_alignment(dev);
> >
> >       pci_init_capabilities(dev);
> > +     device_enable_async_shutdown(&dev->dev);
> >
> >       /*
> >        * Add the device to our list of discovered devices
> > --
> > 2.53.0
> >
>

