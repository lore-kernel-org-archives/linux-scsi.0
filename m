Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD91E40DFD5
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 13:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773323674; cv=pass; b=VCdkmBJHrAXIbjFbNWsajdZXNmNZ1NuzcsztduXHkik8DNkXjIfbpwRonOLxdt1fk8TopYCSARiNd+7KPX5N7jzKv8IUyq3cyKQfgdh+lyZ6n52V0EiwUOPmt6+93HqmBJjrd1J9Mb6ndPOv1/XEqRsOoM+gexTNY/KjgjwmU/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773323674; c=relaxed/simple;
	bh=QyuFlbrGA5AQlhnI0HMtrCQprHs6ftmSMcfrRAXjexw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u+TBoJ/uRPlzDNlQco9+BlVOb4YppOwZnmViktDbV34uIgtUzG/msYlZ+5sRAakvBYXYwiAE/+w8Wm2S+AYKyJaw3G1Hi4n8RQmaWB1vCxSbzcZCLhjFXZskX+RFE4oGS9BX28e8h1OPCXDfsNPsmaivrXpwNXhmPiREVmKSIQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OvwCcUHs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fhnd77sc; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OvwCcUHs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fhnd77sc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773323670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XExV6QRKq8SZymtd9B/1tvKMnhGFOwk+2Q9owYWU/z8=;
	b=OvwCcUHs0oTh6eCn/SYOb3EXiH9eLrn3FtWTpMB6s740BgPgA+wvbsiUadOavyuPspvMQH
	MrZxZ5hloOxbCGtBGqssaauYJPpCBBvvmPfLlM8i0qH2ZkqK2wc5beAkd2BK/obT+dHTqw
	Er2TFKa7vvmL0A6G3PDUyb5k9UhrSbA=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-KpqhQKAHOTKqItSYUL4hqA-1; Thu, 12 Mar 2026 09:54:29 -0400
X-MC-Unique: KpqhQKAHOTKqItSYUL4hqA-1
X-Mimecast-MFC-AGG-ID: KpqhQKAHOTKqItSYUL4hqA_1773323668
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-38a3fedc930so5048361fa.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 06:54:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773323667; cv=none;
        d=google.com; s=arc-20240605;
        b=bX0E5K8uvCwPzqEFVu79P8mP8OfmNhwUUgdAo+luBi0Kbcx/AdH2ZIQ61jIIySj2/k
         QMbkjCCUiQYa9rStsPf8nNsyoycqHFVTYr3yI/ftuS6euRqRkimKeVipdwknBheXnfcp
         Zo6msbZ43X0lWu8g8xXEWkVm7Fg7AX7gSSKcR/9n7iFpKGk1gfYWdcWgvAfm2pyKkRvY
         vqLSwBKQBaL7x388LuHZdEyL5ZSrGMDjUBr7CcgEzypX75BhH2RsUWeFE0m+AIg9PoWV
         cYZnbYJXLxAccl9BEY2hDpZ1JjWWvxYwu+oKoCKVcSTOWS9xb3xCFTil9z/HJfUipqJC
         nQog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XExV6QRKq8SZymtd9B/1tvKMnhGFOwk+2Q9owYWU/z8=;
        fh=wC2hXWpq8xmXsmcuoUfklcssrmtVJPzdcxTUNsjYFUA=;
        b=EbacfoixhaMuuGXmfgQhkwzOZB+D77z2aaAM1LIWhHzitkvr1UjHoPccBIaO+iXMet
         86iHohYwQk/qtW2pY6eMCKHK7DwENHAC5jJj5eEoYmIdutVWHHPqiFNbUw0C4JizxLeC
         1zeGhxpslOPb5lblMM6BTy96cBwKkgTO84t2FMGorUkV8Rrb+4iOAMLkShfdAymChUSt
         WD1htVR+/0Y4VgTNiLlcpi4L+2Ym+4c6bbUXwBc1rOl3Sy+153+QgOgWVnWxxf7YdHRj
         Tg1uTQHgmjeRjTY96psnmguBvQTp09bC+6hv0gM5RdLq7I7hqp9M5hw26kA4MXijd3su
         0xMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773323667; x=1773928467; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XExV6QRKq8SZymtd9B/1tvKMnhGFOwk+2Q9owYWU/z8=;
        b=fhnd77scXK2vZ6tbApUOJ5hmiA1NJqbB1Wdkp0sdB17bbmT32tIJpkDjtfwGp27qDc
         VrQV7lho8Pm6HpZsNJsV3BuSvv6JtAzcQIrlzjTU1HAt9qv8H7UijwvKIRaSIGjLJ/rD
         pGRDn4tSbj6izizanEhErkcdfo6v8vHjGHzUgSfD+rVVDnTQFJfAiKSqhu9qCgJpfWBP
         6edabGnstkxK38V0BcPzYaVyxf4MTv45ARfASQKrWqR8Y/MMJB/Br/UjoG4zd3dyLxcG
         aknbiXWSQY62ZDUf5Kpwrn+sprif3C0bb2SLwhF8CgiQTSUeb0aDzVj10k5GCYHaPOvf
         Gawg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773323667; x=1773928467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XExV6QRKq8SZymtd9B/1tvKMnhGFOwk+2Q9owYWU/z8=;
        b=MNFL/+SE9FMXExEIKJW2QfvaUTOpMZP6AskhImQUst2Hw8YWFZ5RbfvIjEMUtjf1Tx
         kmd9AY1EMQVmhMn00A7OCQWeLKkFtKq9VP8BQCc4kgds7iiyyqmkOawiTUmYU7B02RZE
         3v2CSg3fXIOAApyqUWAd+Al9PGnbA14qrIqO1eAx4XhplBuoLIGmDqkJv3jzpS+pnLcK
         gIQ90rC929a5i/HeUpb1hymzHO3QVVXCoQzJTC1lhiIWQu2hzhzQ7cfb0342SGW74GVa
         VgpyXNVmRXi4q8A1xdGVjKuGEwLit+tt47PAlxCKDYNQixYeZn7jXHhX7iHnFyuBIGa6
         0PEw==
X-Forwarded-Encrypted: i=1; AJvYcCXBQ+QK46kMZcr61GjxNErr7JMXTe1WaXf5zQd8JMuIp6MCWHIAwuCa7cgwWKAAupPbIgDRDHd81ed5@vger.kernel.org
X-Gm-Message-State: AOJu0YxM7lxtpVruA8+vHyiJ1WkemsqOnE7p1WZSsBD7tnz2jz73n9yq
	t8NdDGB11EazWdUtxXTPKDnoPDL8Jrt45ngbkdwWWcfTIviBmTxr0AlKhjl07uNeX9nUKJidM+Z
	+ykZmuFlbZKzHxEnl6omJ//ECarZ/q45LcpepvCatfyBGwbkbDEA9Ri5+925nmMpvOj1iiT8Kk6
	eUhwWk841M6R0/IFCUTn9/aQnEseqTh/brH6rxq4FLylLyzTDJOvg=
X-Gm-Gg: ATEYQzzS/9w+safB0XG7Dc1xLy1Q+rhzYYp0nWLg4Njfl5RUSHQSu39nOan4/aoCe8j
	glcXaEjnR3HG1hLAg3zc5KctAhUWGNJspC/wyGlrToYt1NIHwk75L+xlE+HSwArA8eX03O1YrAk
	TYa+AN3ztuhCPWyiJmcjyAvl5GBm6uoOeiU3zJPM1+vqQ5kagKH3AFu6KWsgCip6A7WX4/u10uY
	YEp
X-Received: by 2002:a2e:8a86:0:b0:386:1ce2:11ab with SMTP id 38308e7fff4ca-38a67da3325mr25663091fa.11.1773323667558;
        Thu, 12 Mar 2026 06:54:27 -0700 (PDT)
X-Received: by 2002:a2e:8a86:0:b0:386:1ce2:11ab with SMTP id
 38308e7fff4ca-38a67da3325mr25662881fa.11.1773323667010; Thu, 12 Mar 2026
 06:54:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311171209.9205-1-djeffery@redhat.com> <20260311171209.9205-4-djeffery@redhat.com>
 <2026031229-coastland-ducktail-c4b9@gregkh>
In-Reply-To: <2026031229-coastland-ducktail-c4b9@gregkh>
From: David Jeffery <djeffery@redhat.com>
Date: Thu, 12 Mar 2026 09:54:15 -0400
X-Gm-Features: AaiRm53czMd8xlW_uvkK052fMb3Ujo3XTxm7kNzW6g-GQBO5hD6Lp1oyDE-dXEA
Message-ID: <CA+-xHTHR84gAoz-82CKKEsbwY5npqofUb3=jQ-=OJnqUQZR1yQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] pci: enable async shutdown support
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <tatashin@google.com>, =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>, 
	John Meneghini <jmeneghi@redhat.com>, "Lombardi, Maurizio" <mlombard@redhat.com>, 
	Stuart Hayes <stuart.w.hayes@gmail.com>, Laurence Oberman <loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 1:09=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Mar 11, 2026 at 01:12:08PM -0400, David Jeffery wrote:
> > Like its async suspend support, allow pci device shutdown to be perform=
ed
> > asynchronously to improve shutdown time.
> >
> > Signed-off-by: David Jeffery <djeffery@redhat.com>
> > Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> > Tested-by: Laurence Oberman <loberman@redhat.com>
> > ---
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
>
> For all PCI devices?  Are you sure this is ok?  That feels like it is
> going to be ripe with race conditions...

I did not see or find any issues. PCI already enables async suspend on
all devices, it just does so in a power management specific function
so I didn't put device_enable_async_shutdown next to the
device_enable_async_suspend call.

> How was this tested?

It has been running on various VMs and x86_64 physical machines.

> thanks,
>
> greg k-h
>

David Jeffery

