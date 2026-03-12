Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166DD3B776A
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 13:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773322767; cv=pass; b=iSA5e7NUXR6ksdSTIvjyIR+3rTn5qBVu7pXwJX6lcNA8R/uWPsmMMjTyXl8EBd1PmElPiODazmd3XRTW6AtToGLZgNc4u2VH+eXU0SDb+mV99OPKICBqQdcXZLKc9Pup4UQw+7gXKmL+HwdH7XJI3gfZIAtJekqgjNEQN4QAhe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773322767; c=relaxed/simple;
	bh=L69QmC18hapMhcCCM9aOUH8w0vMV/TSuAPEAAljzmjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rEOmxaz3eJA9wp4EVz3HUpX1uyBBm+JEkvKDbPJayukZDz7/QCA6YUcrV3AxPJl/KRQEKkc7odYNmTN2v18dl1D6KD9OtxU6bSzFRDbVe9+sjqLOkEy6Wf6lGo+lEh4dxNVb2xVrOgfSv2SKAYg8GcOpcVpe9YBO72QlZJyKiQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JeKDyBXi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mFrD7SDV; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JeKDyBXi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mFrD7SDV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773322765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P1afq9gHFIfQK6ABVrm5mHYxKeNKd2BXTj6Ir4QwH/s=;
	b=JeKDyBXiP2XS4jeVyyP54Kur1+7q4rX5xHpyhpKXJE+CEe8PF8EUSdEhI6c1Q0I8h0cxdO
	3aWtpavdFwMy9t/lXGbaNe5jVF6Aay5IxwXEDFDN4ShcGrxV0BfVX5LouADHNiOun+ycXD
	fadBqkCtM3NDdeKxkLp6kZ+5Ht9gX1c=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-epAHGO2bNhq-G0HulN8g-w-1; Thu, 12 Mar 2026 09:39:21 -0400
X-MC-Unique: epAHGO2bNhq-G0HulN8g-w-1
X-Mimecast-MFC-AGG-ID: epAHGO2bNhq-G0HulN8g-w_1773322760
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-385c90cbca6so5189481fa.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 06:39:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773322760; cv=none;
        d=google.com; s=arc-20240605;
        b=aDP8FSYFn6921prv6ZQWnoCSHDpnNZcFJYKjV1CSJzAvZut5k4y1L5dJrqB9P5BBKl
         j5BvqmJFZKkqnwl414rtNqyQ8PPacvjElgYfC5BrlZjxJarS2pCqfDtgfMOxqDGM3a4K
         PfBWOjO1K8+8zJLXeeYf6Bsn2cGs3IwczhmQ08AcKYrFGCBsZrhrYf5y9bvPd80EeF2a
         GevQM7MkgmprnB9pPIJO7HaMvNTA+K7RhzlugJs+XggF1A6sgdgUUaPoxj5lcisEdWVN
         lLq2QWg3V2xQtZg+Xi4j5MioFzI0dSfYstZvEoETX1XBt5DXPQfglly/0AtonYUhKaY2
         TzQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P1afq9gHFIfQK6ABVrm5mHYxKeNKd2BXTj6Ir4QwH/s=;
        fh=jhgJNDV3pL3TcjpSOCp+u6IJuI9fsyo2naqpZEfrRhQ=;
        b=UAwf4xIBEoTiDsvkFXKxOrk1lM/8rGVc26ahR2X7VRXmb2OMjuqxxr4xgRyLzDoHxV
         35qpQPjvGksXJhfoWhdw6W/eDbMaGTONQyGctgAJIzUeBifPeGQ1Pb6rIVj62xFq0ldk
         72wuX3uGL6ixySfdoHvNGQVbNUD30r1lRWWiYwjDdVejT3uJuCx9tBPDz2X84Q+lTXt8
         ZuQfEX18Hkj++QbD3n6dhlr4fgftwIEDpquO/tIqNF7NqUnmdQD61SD6nXXTauumArLm
         XWAoFVw/1FMseomeUZm/4/4UXv1sWof3125/81ZtAj0PAiffNheXw7WnlOlG+kuoUXEw
         4urQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773322760; x=1773927560; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P1afq9gHFIfQK6ABVrm5mHYxKeNKd2BXTj6Ir4QwH/s=;
        b=mFrD7SDVKrdE5gTc1qr2gdfcWS/Wnz309/xCpxkYFbwAeth0t56LQz9Q0QwBI7qsko
         bO8qmkUABZ4uZNPSMKbD4NGF59YaQxbsPQ2rQT13sZcHCOId0BBNdaagQOi9x0bBaxdP
         TWYR8uLYUQE3eUOZFFdTbKnnb4GsdlxDjP3zUmWla0BkqP6pExDLb+0R9JGr3oGdajOJ
         0zY87aMjBCQPVK7XRdxOlw+I/kimdz+n5lFjJ2gFgSI7zsNTCriHFfhjGnvhZPPBR0R0
         z4rQnlDanMfkBrzQ+PJdnX0BMMrxDTYyzlwnfZ+9+BWlIKyqGXriD8UeiJLZhZmkBjPl
         JYhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773322760; x=1773927560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P1afq9gHFIfQK6ABVrm5mHYxKeNKd2BXTj6Ir4QwH/s=;
        b=Ega6SeA3raho1a4lfrQVXnQnMYR0fxpr34URg4mMDqZSb7kwfW6W4317EvdI1oIdkp
         IhFEjaa+NxJ7v+/YQI5ymkFpp7Cj9Fk09iVlQFCYc7bNoabDnM3PxPVC8GLQ0ioeTnms
         EgBaGZFfTrmm+PS5cgfyGcpjAAJauF8PvVyZZ5u21jaiIa54/DmUqaaVQG8QNdej2Zji
         KMSpZMTmpJ2I7wNsSdJFzLmpWuE88jLFxqGbd0m9iVnF2M+kbTiHY+uhKaFpL0JzMfi0
         3PyCU0pg0Fe/Omytokr6oJB/5AYUVWjgFsPGeYBQMhqVzlsQ4hV5H7KrNZpDZupgX+SL
         /aPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWx+p2nRUMh6WeCmdnd1uT8lZlIjaG4IL0EdkC27TFkEPz+GcI29UzYEImIaV8foB0w2cYhAKpOx8jc@vger.kernel.org
X-Gm-Message-State: AOJu0Yxef8Pt4SpBvtnMS1yhVUe0BZEYGVSQueBHLSMGgymU8MJk7J7/
	znSnin31qAG0gk4D0v4nxJcoc3c53izW8fn7G/iNWubpSynGblHssBlQiKTwP5XZHqOQo+DUcS7
	bzAoga58UjY4zUY9TTgeDb03KiVnLkbNitwv332cPNQKJ7jNpOYf4Yl049Xf8Gls6LosiDVTjGL
	3qoheARnYEwix2cP2NkHffQVEcO7jutMh21z+Itg==
X-Gm-Gg: ATEYQzzIBSxDXJMY1vNDntGPzKY0z49zFqA2P8uWuQ1WG9hR2VojEBmccitLVRYzzXL
	eNLTfxVrDU6b0SMwvU3kfXwK377cqu13NjIqOCHcHPBvvkw9q1gCCCvH8/ef+njIVWln534Gqa4
	hm3ssqqbDQbcJDwpOKtmiIsqriEeOeJcNWx7tIglMEW+4Z3eGHP/R2qsNd5K8VGdiVwSyebEo62
	L76
X-Received: by 2002:a2e:a991:0:b0:38a:69ae:ed76 with SMTP id 38308e7fff4ca-38a69af0e32mr23484901fa.8.1773322759832;
        Thu, 12 Mar 2026 06:39:19 -0700 (PDT)
X-Received: by 2002:a2e:a991:0:b0:38a:69ae:ed76 with SMTP id
 38308e7fff4ca-38a69af0e32mr23484641fa.8.1773322759293; Thu, 12 Mar 2026
 06:39:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311171209.9205-1-djeffery@redhat.com> <20260311171209.9205-2-djeffery@redhat.com>
 <932d4e59-395f-4022-a2de-874fdea778ac@acm.org>
In-Reply-To: <932d4e59-395f-4022-a2de-874fdea778ac@acm.org>
From: David Jeffery <djeffery@redhat.com>
Date: Thu, 12 Mar 2026 09:39:06 -0400
X-Gm-Features: AaiRm50cC3-HopgnDbEpZBKck8Qg_3xXUFA0iihGZz6Xo1ScI6fOim-Jwqz1X4I
Message-ID: <CA+-xHTFnOtFqFeH=Va1vTC3qaa2J_tDCfpdq-RdHFFbByoNobg@mail.gmail.com>
Subject: Re: [PATCH 2/5] driver core: separate function to shutdown one device
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <tatashin@google.com>, =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>, 
	John Meneghini <jmeneghi@redhat.com>, "Lombardi, Maurizio" <mlombard@redhat.com>, 
	Stuart Hayes <stuart.w.hayes@gmail.com>, Laurence Oberman <loberman@redhat.com>, 
	Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 2:03=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 3/11/26 10:12 AM, David Jeffery wrote:
> > +static void shutdown_one_device(struct device *dev)
> > +{
> > +     /* hold lock to avoid race with probe/release */
> > +     if (dev->parent && dev->bus && dev->bus->need_parent_lock)
> > +             device_lock(dev->parent);
> > +     device_lock(dev);
> > +
> > +     /* Don't allow any more runtime suspends */
> > +     pm_runtime_get_noresume(dev);
> > +     pm_runtime_barrier(dev);
> > +
> > +     if (dev->class && dev->class->shutdown_pre) {
> > +             if (initcall_debug)
> > +                     dev_info(dev, "shutdown_pre\n");
> > +             dev->class->shutdown_pre(dev);
> > +     }
> > +     if (dev->bus && dev->bus->shutdown) {
> > +             if (initcall_debug)
> > +                     dev_info(dev, "shutdown\n");
> > +             dev->bus->shutdown(dev);
> > +     } else if (dev->driver && dev->driver->shutdown) {
> > +             if (initcall_debug)
> > +                     dev_info(dev, "shutdown\n");
> > +             dev->driver->shutdown(dev);
> > +     }
> > +
> > +     device_unlock(dev);
> > +     if (dev->parent && dev->bus && dev->bus->need_parent_lock)
> > +             device_unlock(dev->parent);
> > +
> > +     put_device(dev->parent);
> > +     put_device(dev);
> > +}
>
> Please keep the following code in the caller:
>
>         if (dev->parent && dev->bus && dev->bus->need_parent_lock)
>                 device_lock(dev->parent);
>
>         if (dev->parent && dev->bus && dev->bus->need_parent_lock)
>                 device_unlock(dev->parent);
>
>         put_device(dev->parent);
>         put_device(dev);
>
> Additionally, please make sure that the caller is made compatible with
> lock context analysis (see also
> https://lore.kernel.org/all/20250206181711.1902989-1-elver@google.com/).
> All that is required to make this code compatible with lock context
> analysis is to organize it as follows:
>
>         if (dev->parent && dev->bus && dev->bus->need_parent_lock) {
>                 device_lock(dev->parent);
>                 shutdown_one_device(dev);
>                 device_unlock(dev->parent);
>         } else {
>                 shutdown_one_device(dev);
>         }
>

This would also need to either grab another reference or move the
reference drops since shutdown_one_device may drop the last reference
the task owns to parent and dev. Since shutdown_one_device ends up
called in 2 places in the next patch, perhaps would be best to split
the bulk into another function, then have shutdown_one_device be a
wrapper like:

         if (dev->parent && dev->bus && dev->bus->need_parent_lock) {
                 device_lock(dev->parent);
                 __shutdown_one_device(dev);
                 device_unlock(dev->parent);
         } else {
                 __shutdown_one_device(dev);
         }
         put_device(dev->parent);
         put_device(dev);

David Jeffery

