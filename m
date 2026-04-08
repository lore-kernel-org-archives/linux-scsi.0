Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B798274B46
	for <linux-scsi@vger.kernel.org>; Wed,  8 Apr 2026 14:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775657813; cv=pass; b=TsdE2u8o3JiT1x8j0I0FvLO2pVMCwVDiVwERgcXivqs5qFamgq4ihWYaI4AaeZLljhL3IzuqQ3XU9pppbm0xEy9WSqboya7bdgSgWRV/XOs8qNMurONJ89gM0JFzqA3THRvt7ddAI86YF+X/8M21aeET1mBEPpJb65f49wWbquE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775657813; c=relaxed/simple;
	bh=BL7bjnfiDc+oze86Z5+hb/JdSfgy0dPrHiccC1cL4co=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qaTcmKUBFvXqg8dKk292+siC+Y+7yBAT4IKWciJ9zoDdB8rypWEPkDC0xJWrll7ogtb1Io3m5LN6TuTFP9WS/JFjyzbBz8iAOrbiSeprz2ACxOYunHjcW478PfTtHdcMb7E15jwAfDgOlbR4XsTHRZhgSv2qk1hD7kuPs9Q0Pc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Veu55jsl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MSC01FxP; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Veu55jsl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MSC01FxP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775657809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RG7NMZgM415BV6Epnr7PY+Cg4TeSFTKlU8/eVWcZm8c=;
	b=Veu55jslWZYxOimOUUxPswlkXIQu31vCZsVfTO3IGpkJfvtjAnrLLSW7T+zKKMCmGYF151
	mexntM7vGN7SAxFlia3ME2XyA44P9IStUWSIw6U7a2BcFkRIf6RNYq2polU6IvjV58GGSV
	NbP/FTrag1bherMAvlIV9rO1JszuDfI=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-PjliBRoyNzauXjviGJfTuQ-1; Wed, 08 Apr 2026 10:16:48 -0400
X-MC-Unique: PjliBRoyNzauXjviGJfTuQ-1
X-Mimecast-MFC-AGG-ID: PjliBRoyNzauXjviGJfTuQ_1775657807
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-38dd62ba050so19464241fa.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2026 07:16:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775657806; cv=none;
        d=google.com; s=arc-20240605;
        b=Fo5jlt0NLrlp0W6nAZdBngfmeA8WhWLXTpvXPw034ZvIhmO6QLmnX1lOPvi/jjQAwu
         RYnSulsBHi8h9GKDYaG84bKsomN0d8TOeXA4MOqsS/xUvJnxb7uQtOSKFYo0+Ioc65TF
         70PKWB5UwcuCuPUE2+fPkEB+N+r60fjAIDAnq65TspF8w1s40XL+OFSYTQX8a9Fr8wVa
         rfyZoXn4Hm2fxkufFikwjbYc3VAajwQhPQ4bml+86sGGTqGV1rg3D6bGqOVPuJZI+k3m
         3oEPLzESIqVzgKg+VvMRIjBs+p6V6oJ6RChHqm1Muhzw/ERoxXQrDnUPv0PNKjYY2Qbf
         cscA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RG7NMZgM415BV6Epnr7PY+Cg4TeSFTKlU8/eVWcZm8c=;
        fh=yCsY1jVrtww1seJ47Xs70zIKlR0Puv6HXGSjZwkg4Nk=;
        b=BurSzVeBCubw+d6NwMUzCo/w/LCWLnIoZ8lucC96NF1e5YyzYhs06Dq+tCBjmbAiRz
         d2r2sNBYchwfowzmxZnqpaET0KlscAghz1S6xoccNch7k2e4HxVZFTUa0i41c37Jfyeo
         JKDDiflAI7Hf79tQCSfFhFedvnyMU0iIM84X6tRr4fPBVPn4wgCRvJsdYNwn16dssPMN
         HnXTj36a/7n4T5Cu7ntbjM5MQr9bPOKe+J3o0c/K9fqmdkon0Kphz4LCjtjD0SaapI21
         EM5hkCMp3Mfi22oHIBz/zp5mOsgUrPeGZc1NrZ4E7zEhwx4OAtbd3jx9/PUpoSiHVNfR
         fwsA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775657806; x=1776262606; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RG7NMZgM415BV6Epnr7PY+Cg4TeSFTKlU8/eVWcZm8c=;
        b=MSC01FxPsLEDBiSavjUhUePJ8HLNBVHaiCMDKZWJ0tEyWso9U4pMZpRQmpHsc888UF
         pW7Zfo6vl3wtAC3mFD0Ua2Y+oTOTQ2nlkAx7Zrg4TuJFsINTUheckFfkC9AI2EisZYU3
         wKbNpd5pdCVBZYumk4EyKVFwCVxYYCpx+u7GKLh8jXeGRhEtb44Lmv6rgIgob551eewi
         7gmGEgmelplueIXCmg/4qs7noPCpfELZ4tBWOWwYQZ4/vlrrB3OJty1JG20HfWXk3ePg
         sOX746Hie80u9bgQYYspJjSVaYd1pzWYREqCCAGW4jQFez0hh46+KoFf0ZWJpgarnFNe
         8Zwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775657806; x=1776262606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RG7NMZgM415BV6Epnr7PY+Cg4TeSFTKlU8/eVWcZm8c=;
        b=Lt3+lCFCqaepevyb9Em5InwRbcl8UFAX5fmDQ1pRWA31laLXZ7sglDcQEEpHk9TJld
         hxlb/v68GUInil/D0UYj+wWoLiywfBa+HCP/Okj64NY2Y/bYj03ZVp1zcDS2V4tKJJTn
         e2S1jL/mRREAGAm1C1a8aUVKg76AjDr+zVkoYPhBIueFaxrAigvXXs0rzQI1An31qPD2
         ztJD3COBrR3UDVXsKAgrYJuzmfRTBVf8HkCvtaKCg72x5chP6pLENV/qI98p4Eya0SIC
         m1FuIQqt35rGbAw/38ms2MY32GcGU1+VNG27kFkGojV9vs7aIcC4moPHlXElb4c4/n21
         4FNw==
X-Forwarded-Encrypted: i=1; AJvYcCXIxX8etLNI7BO6SsqRbTP2hn9mfMmHjQG5KxLTvlOG/DrFvcAFpbWktXa4i9DCXCGYYFXhYL/gXw+q@vger.kernel.org
X-Gm-Message-State: AOJu0YyspMqDfGHQwMFOhHHzrGbO+X+JrlknyEQFXPHTUD4uOKqjkjmx
	UC2NJohCXUv7SW3dvz+J2xiVqW5HWGxnLOU4sTzOx9dOVplKdGJ7O9a0wkDJnlKK4NxbnoMYEyf
	UkOGLCmzv07kJZcY69orJfVpsFSXyaLsd9qwenhxQ+6e20gRVJhh9FHD2q7cDwsKWVyhfH2UMU0
	RAhH/XJVaa+acwEl9UrNmJUgw+/lKtOKVbFJJSgQ==
X-Gm-Gg: AeBDiesdI705uj2IxopwkU5ZVAw86qdt88gOD/2fsJB4CqKnF2LEiCnvtWqKt00uB6k
	m8ruDtilbKM5n7A3ZB6Gnu2S2KrRBVmfa9DI8n70203qbHtN+na24rAETzVVBIaGuwaqjuSUVge
	kKFoxUQEaf18BvOBQdEg3KtamAv0F1N6+29JfZtfwlbiJ0rjCIWVoNplghyXFTDHvphHfeVTBXa
	yGu
X-Received: by 2002:a05:651c:4408:20b0:38a:a7b4:15e8 with SMTP id 38308e7fff4ca-38d8d3856a4mr53298651fa.12.1775657806486;
        Wed, 08 Apr 2026 07:16:46 -0700 (PDT)
X-Received: by 2002:a05:651c:4408:20b0:38a:a7b4:15e8 with SMTP id
 38308e7fff4ca-38d8d3856a4mr53298501fa.12.1775657805980; Wed, 08 Apr 2026
 07:16:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260407153532.6395-1-djeffery@redhat.com> <20260407153532.6395-6-djeffery@redhat.com>
 <c5cb8cf0-9beb-4bc4-8ce6-83b4544beede@oracle.com>
In-Reply-To: <c5cb8cf0-9beb-4bc4-8ce6-83b4544beede@oracle.com>
From: David Jeffery <djeffery@redhat.com>
Date: Wed, 8 Apr 2026 10:16:33 -0400
X-Gm-Features: AQROBzCA9JzhK-STTzQehLHNPnOIWukHHyeEOKbNwvtun8-eFJcP344aRf0ba_A
Message-ID: <CA+-xHTG9tMCCf11NZwKfvE5xvCfjXrttDXhFsyz=SCofAc9Mgw@mail.gmail.com>
Subject: Re: [PATCH 5/5] scsi: enable async shutdown support
To: John Garry <john.g.garry@oracle.com>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <tatashin@google.com>, =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>, 
	John Meneghini <jmeneghi@redhat.com>, "Lombardi, Maurizio" <mlombard@redhat.com>, 
	Stuart Hayes <stuart.w.hayes@gmail.com>, Laurence Oberman <loberman@redhat.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bjorn Helgaas <helgaas@kernel.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 12:35=E2=80=AFPM John Garry <john.g.garry@oracle.com=
> wrote:
>
>
> >   }
> > @@ -1396,6 +1397,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
> >       transport_configure_device(&starget->dev);
> >
> >       device_enable_async_suspend(&sdev->sdev_gendev);
> > +     device_enable_async_shutdown(&sdev->sdev_gendev);
>
> We call device_enable_async_shutdown(&sdev->sdev_gendev) here and
> scsi_sysfs_device_initialize() - any reason for that?
>

It was added to match locations where async suspend is set. But as you
point out, it does appear redundant to use both locations.

David Jeffery

