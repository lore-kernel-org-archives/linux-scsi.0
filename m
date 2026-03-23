Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9B83B52E6
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 14:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274842; cv=pass; b=FkTi8VIyXEH/wrgC1pvXio1ikue8pyFT4zXeeWVwTWL+/37QOj5ffUsNwSmZdgZCtOHPqMwzA/YfD41DJDIbo3eJBPxf5zpC9os/waSjcDvoDJ57ovgaRFKjmOsA//jCrOezhXC/nOKdH3Oj9zjiA+Yt0zMDYzDRhvmE4wZm5q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274842; c=relaxed/simple;
	bh=+hOefeJCWgR/U+foUT9+hsW2imWT1SNNShlzGWxMfH4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C79062bt5wb1T45LVRrYF5rMTPyJrKOusW2ChLD4KUmQRdUpASO9ayA0UxGna47f6BFelthhrXj10NiwWtEppjh97uMSBe1Sbbo9hSCo8j86eL5JEAK193H06RQjfVxDJythkAMYhhLE9xoFVzs50XaVp+EQdBE6r3KlbQ8UHdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WP3zBSkJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dVNVAc1v; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WP3zBSkJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dVNVAc1v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774274839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UEFtNkvxGGVpP1A5Fdy0Wlxh3FGV7miNzvBe6PrAo68=;
	b=WP3zBSkJU1gJbhwp6xRDWjRhG/DaD7F9ud4ifeKSKREAht94X5oYbheTcOeuhC/Cr/VqQh
	gMZAKRJxJoNp8ETg0ZI2emAe1Rd5I4t84CntHKDM6B2JEh6MDqP2efOebqE7r2aJtqBaxX
	mqZAURKO1SUeOU9zlGf8LtmcLg/Oi+w=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-rN1CIxA0MmqBTaAn97jhIQ-1; Mon, 23 Mar 2026 10:07:16 -0400
X-MC-Unique: rN1CIxA0MmqBTaAn97jhIQ-1
X-Mimecast-MFC-AGG-ID: rN1CIxA0MmqBTaAn97jhIQ_1774274835
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-38c22faefe4so888671fa.2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 07:07:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774274834; cv=none;
        d=google.com; s=arc-20240605;
        b=hhm4deSxa0ge5GBBvoNwAizt3HwIibtYwOtSQPKkBRtTnc2VUFr85v16sl6cjvkaGy
         uSGw917ymZfXypf2SmNQJaD7+40wXTs5od8Pf6V85kDA0YtCiKGIoQ32EEwPu0PwExeI
         lTZOTCwCTFOIM3hr/auk769jlX9WGjHjNVqJR0M2ijR2BoT4A8A9042YkDXeXe2Doc3j
         7CtjzMbVlTcy4iYjSkFjvZytUgOr/O399+qbobyA6r26BBWj4KLKNwz/L1vkazT8u3Nu
         7hfxC0CVWxtbT3uEMn6Q9tTrPYjMz9633MAineVtC8PnQLajoh/9ojVqAP0m9r9XYGUR
         XYjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UEFtNkvxGGVpP1A5Fdy0Wlxh3FGV7miNzvBe6PrAo68=;
        fh=v8fn5wpqQwD8yd3tXAebNo8YIU+5btYatiRaz6r/pUs=;
        b=MHJifXoCi5EP2v/0BNJ7awILLZd1+cAvWKxKtuWFjI0FIfVJnJdZGj+qcdU5CH+KXI
         btld2Gcwp3Ph1wWe6zVXnubBDPjivUC9n3pFssHF4CcbDFq4w+anynQ3rpCDc6mPqAX5
         03z81m4EDKOAsQp4DkceJMQfNfi6d4d8nMFt4AxDicisNSFlPBbnqeVm8j0RbX/B2T1O
         Lwm0LCjHurpAvd9c9P19w18Q6HG8Se9JQ9Gqsi9jVo3c5CPmYZSxTRpetH8rTDheesdv
         Q7PzGJjSTpDX4ciPBp9d8kiMnwfQDFzobD4e4T1AS3MHmjgpxnS1KulBlYZzTIM8sTQA
         kIVw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774274834; x=1774879634; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UEFtNkvxGGVpP1A5Fdy0Wlxh3FGV7miNzvBe6PrAo68=;
        b=dVNVAc1vpXtPFwX97ZByS0a+dmMZYMzG9XvtRbhWvMXpO2cXMmwMjSWWCIlsBWI7Ju
         GMspzneN7IBm/eclTkxHuhNjvfK59m90sr+drGCO5eAhim1rlzNJhXsPLEt4DSv4IAiD
         r4FZe7lKQa2346uAY+aB1utVug3yF1zco8hr3f9J/KQjnLbSrs/QDd/IxczV9PiZx7OO
         rnUeit5s+4aWcbIR0Iql12z0ydFkrY5wQ3CDsbTFULnwh2qx8aOSm2rPeRKvBLHY9stF
         XBqVWyXhQN1m4ojr9XuKH0WWuh9TWbq95zFQMto4+tYHn9/B/IeWN8NyKyYHaT6/3NLp
         +EaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774274834; x=1774879634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UEFtNkvxGGVpP1A5Fdy0Wlxh3FGV7miNzvBe6PrAo68=;
        b=oQLHam2nnvoI07StvEeQuOuFAV1TpoujmkT7msPBxby5InIzWSdxEdZxkUy1UIujgT
         ZYDjL12k0qxklWrGh8tOSqm8T+k+1rGqzqtW0ty3W7+MbQPxkAq8Q7yRJg6k78QmJR1w
         TQG1m9BPWXuA3X1WrpAVNcr+TtlwCzen/g5HmgHzJOw6lc9E0bjKTP7aSSpYt7jnDZn8
         EcOllvGTmMBKTwmEbm2vUm285iI0T02pbREBa4qljU+fqj6EkC35sM2j21aW2VRbju4V
         A5FODP5+OZuF9+lvR10OjFBLr0zXSS8tF725LGE4pA42MIhb7P0b2pbazFzbsBclbl1S
         Qf1Q==
X-Forwarded-Encrypted: i=1; AJvYcCV8P/Ym6VmZcrl8riW5Ig/hybcJYatAIAMqMyTB6EvFN6ar+CAvniH5TBSCaq++X/pFmUgIHgCJbb4w@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8MuxRmP8j9h8XhIGL0NLRJ9myAUouyxY8LXZGvY3k1K3gzY6J
	Ndo1WSno3XpziCy6F5Yc93itIe4fvM9O591+fqdH7bYhyYzA2h2fSM6j42f7kN5sw6zTrikkEpI
	cRrCxm61xmwpNUYTZtNXriBFo5KZbCd0HcYtZ6F+IQ+dweh/N2qkmMZDeodnNhhePYNpz9f3eWc
	PLGgY1Jf3SYp9zelmypG3UhQKc0FSf7zwoRk9JzQ==
X-Gm-Gg: ATEYQzwwa/lcHRwoW8/QyLmM/nZSM7WV3CwVKNpu3v//NRUf4JIY8UVegU+HuHK+aW8
	JIBvHO+j/lWWbWnviYGDdDMt5Es2hFuAw2RtOMgs+tOzAq2nbNDoqkmMDkRAm9scbZ8wy1gUjl2
	6GhCYMUAVs8BpdHhu7yiX+p9wEuwkdEwooSqvg2FAArF6UDS8J4isFR9aUchCOw0p391E6Ij1M3
	KAk
X-Received: by 2002:a2e:8a96:0:b0:385:f547:1842 with SMTP id 38308e7fff4ca-38bf973a260mr42601121fa.30.1774274834255;
        Mon, 23 Mar 2026 07:07:14 -0700 (PDT)
X-Received: by 2002:a2e:8a96:0:b0:385:f547:1842 with SMTP id
 38308e7fff4ca-38bf973a260mr42600771fa.30.1774274833522; Mon, 23 Mar 2026
 07:07:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260319141142.5781-1-djeffery@redhat.com> <20260319141142.5781-4-djeffery@redhat.com>
 <DHA2BZE56U6E.3V6HEWOPLHAXX@arkamax.eu>
In-Reply-To: <DHA2BZE56U6E.3V6HEWOPLHAXX@arkamax.eu>
From: David Jeffery <djeffery@redhat.com>
Date: Mon, 23 Mar 2026 10:07:01 -0400
X-Gm-Features: AQROBzCwdHjXflR3qUAR1ggq6kqqMMNrczgzxRgCKQ9x05zGx_1djDn3Vs4FNkE
Message-ID: <CA+-xHTFzajQP+_OWs=-OF-J0rGM3iOYpgL5q9S4Rra5q==Qg2Q@mail.gmail.com>
Subject: Re: [PATCH 3/5] driver core: async device shutdown infrastructure
To: Maurizio Lombardi <mlombard@arkamax.eu>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <tatashin@google.com>, =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>, 
	John Meneghini <jmeneghi@redhat.com>, "Lombardi, Maurizio" <mlombard@redhat.com>, 
	Stuart Hayes <stuart.w.hayes@gmail.com>, Laurence Oberman <loberman@redhat.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bjorn Helgaas <helgaas@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 23, 2026 at 5:50=E2=80=AFAM Maurizio Lombardi <mlombard@arkamax=
.eu> wrote:
>
> On Thu Mar 19, 2026 at 3:11 PM CET, David Jeffery wrote:
> > Patterned after async suspend, allow devices to mark themselves as want=
ing
> > to perform async shutdown. Devices using async shutdown wait only for t=
heir
> > dependencies to shutdown before executing their shutdown routine.
> >
> > Sync shutdown devices are shut down one at a time and will only wait fo=
r an
> > async shutdown device if the async device is a dependency.
> >
> > Signed-off-by: David Jeffery <djeffery@redhat.com>
> > Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> > Tested-by: Laurence Oberman <loberman@redhat.com>
> > ---
> >  drivers/base/base.h    |   2 +
> >  drivers/base/core.c    | 104 ++++++++++++++++++++++++++++++++++++++++-
> >  include/linux/device.h |  13 ++++++
> >  3 files changed, 118 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/base/base.h b/drivers/base/base.h
> > index 79d031d2d845..ea2a039e7907 100644
> > --- a/drivers/base/base.h
> > +++ b/drivers/base/base.h
> > @@ -113,6 +113,7 @@ struct driver_type {
> >   * @device - pointer back to the struct device that this structure is
> >   * associated with.
> >   * @driver_type - The type of the bound Rust driver.
> > + * @complete - completion for device shutdown ordering
> >   * @dead - This device is currently either in the process of or has be=
en
> >   *   removed from the system. Any asynchronous events scheduled for th=
is
> >   *   device should exit without taking any action.
> > @@ -132,6 +133,7 @@ struct device_private {
> >  #ifdef CONFIG_RUST
> >       struct driver_type driver_type;
> >  #endif
> > +     struct completion complete;
> >       u8 dead:1;
> >  };
> >  #define to_device_private_parent(obj)        \
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index 2e9094f5c5aa..53568b820a13 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -9,6 +9,7 @@
> >   */
> >
> >  #include <linux/acpi.h>
> > +#include <linux/async.h>
> >  #include <linux/blkdev.h>
> >  #include <linux/cleanup.h>
> >  #include <linux/cpufreq.h>
> > @@ -37,6 +38,10 @@
> >  #include "physical_location.h"
> >  #include "power/power.h"
> >
> > +static bool async_shutdown =3D true;
> > +module_param(async_shutdown, bool, 0644);
> > +MODULE_PARM_DESC(async_shutdown, "Enable asynchronous device shutdown =
support");
> > +
> >  /* Device links support. */
> >  static LIST_HEAD(deferred_sync);
> >  static unsigned int defer_sync_state_count =3D 1;
> > @@ -3538,6 +3543,7 @@ static int device_private_init(struct device *dev=
)
> >       klist_init(&dev->p->klist_children, klist_children_get,
> >                  klist_children_put);
> >       INIT_LIST_HEAD(&dev->p->deferred_probe);
> > +     init_completion(&dev->p->complete);
> >       return 0;
> >  }
> >
> > @@ -4782,6 +4788,37 @@ int device_change_owner(struct device *dev, kuid=
_t kuid, kgid_t kgid)
> >       return error;
> >  }
> >
> > +static bool wants_async_shutdown(struct device *dev)
> > +{
> > +     return async_shutdown && dev->async_shutdown;
> > +}
> > +
> > +static int wait_for_device_shutdown(struct device *dev, void *data)
> > +{
> > +     bool async =3D *(bool *)data;
> > +
> > +     if (async || wants_async_shutdown(dev))
> > +             wait_for_completion(&dev->p->complete);
> > +
> > +     return 0;
> > +}
> > +
> > +static void wait_for_shutdown_dependencies(struct device *dev, bool as=
ync)
> > +{
> > +     struct device_link *link;
> > +     int idx;
> > +
> > +     device_for_each_child(dev, &async, wait_for_device_shutdown);
> > +
> > +     idx =3D device_links_read_lock();
> > +
> > +     dev_for_each_link_to_consumer(link, dev)
> > +             if (!device_link_flag_is_sync_state_only(link->flags))
> > +                     wait_for_device_shutdown(link->consumer, &async);
> > +
> > +     device_links_read_unlock(idx);
> > +}
> > +
> >  static void __shutdown_one_device(struct device *dev)
> >  {
> >       device_lock(dev);
> > @@ -4805,6 +4842,8 @@ static void __shutdown_one_device(struct device *=
dev)
> >               dev->driver->shutdown(dev);
> >       }
> >
> > +     complete_all(&dev->p->complete);
> > +
> >       device_unlock(dev);
> >  }
> >
> > @@ -4823,6 +4862,58 @@ static void shutdown_one_device(struct device *d=
ev)
> >       put_device(dev);
> >  }
> >
> > +static void async_shutdown_handler(void *data, async_cookie_t cookie)
> > +{
> > +     struct device *dev =3D data;
> > +
> > +     wait_for_shutdown_dependencies(dev, true);
> > +     shutdown_one_device(dev);
> > +}
> > +
> > +static bool shutdown_device_async(struct device *dev)
> > +{
> > +     if (async_schedule_dev_nocall(async_shutdown_handler, dev))
> > +             return true;
> > +     return false;
> > +}
> > +
> > +
> > +static void early_async_shutdown_devices(void)
> > +{
> > +     struct device *dev, *next, *needs_put =3D NULL;
> > +
> > +     if (!async_shutdown)
> > +             return;
> > +
> > +     spin_lock(&devices_kset->list_lock);
> > +
> > +     list_for_each_entry_safe_reverse(dev, next, &devices_kset->list,
> > +                                      kobj.entry) {
> > +             if (wants_async_shutdown(dev)) {
> > +                     get_device(dev->parent);
> > +                     get_device(dev);
> > +
> > +                     if (shutdown_device_async(dev)) {
> > +                             list_del_init(&dev->kobj.entry);
> > +                     } else {
> > +                             /*
> > +                              * async failed, clean up extra reference=
s
> > +                              * and run from the standard shutdown loo=
p
> > +                              */
> > +                             needs_put =3D dev;
> > +                             break;
> > +                     }
> > +             }
> > +     }
> > +
> > +     spin_unlock(&devices_kset->list_lock);
> > +
> > +     if (needs_put) {
> > +             put_device(needs_put->parent);
> > +             put_device(needs_put);
> > +     }
> > +}
> > +
> >  /**
> >   * device_shutdown - call ->shutdown() on each device to shutdown.
> >   */
> > @@ -4835,6 +4926,12 @@ void device_shutdown(void)
> >
> >       cpufreq_suspend();
> >
> > +     /*
> > +      * Start async device threads where possible to maximize potentia=
l
> > +      * parallelism and minimize false dependency on unrelated sync de=
vices
> > +      */
> > +     early_async_shutdown_devices();
> > +
> >       spin_lock(&devices_kset->list_lock);
> >       /*
> >        * Walk the devices list backward, shutting down each in turn.
> > @@ -4859,11 +4956,16 @@ void device_shutdown(void)
> >               list_del_init(&dev->kobj.entry);
> >               spin_unlock(&devices_kset->list_lock);
> >
> > -             shutdown_one_device(dev);
> > +             if (!wants_async_shutdown(dev) || !shutdown_device_async(=
dev)) {
> > +                     wait_for_shutdown_dependencies(dev, false);
> > +                     shutdown_one_device(dev);
> > +             }
> >
> >               spin_lock(&devices_kset->list_lock);
> >       }
> >       spin_unlock(&devices_kset->list_lock);
> > +
> > +     async_synchronize_full();
> >  }
> >
> >  /*
> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index 0be95294b6e6..da1db7d235c9 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -551,6 +551,8 @@ struct device_physical_location {
> >   * @dma_skip_sync: DMA sync operations can be skipped for coherent buf=
fers.
> >   * @dma_iommu: Device is using default IOMMU implementation for DMA an=
d
> >   *           doesn't rely on dma_ops structure.
> > + * @async_shutdown: Device shutdown may be run asynchronously and in p=
arallel
> > + *           to the shutdown of unrelated devices
> >   *
> >   * At the lowest level, every device in a Linux system is represented =
by an
> >   * instance of struct device. The device structure contains the inform=
ation
> > @@ -669,6 +671,7 @@ struct device {
> >  #ifdef CONFIG_IOMMU_DMA
> >       bool                    dma_iommu:1;
> >  #endif
> > +     bool                    async_shutdown:1;
> >  };
> >
> >  /**
> > @@ -824,6 +827,16 @@ static inline bool device_async_suspend_enabled(st=
ruct device *dev)
> >       return !!dev->power.async_suspend;
> >  }
> >
> > +static inline bool device_enable_async_shutdown(struct device *dev)
> > +{
> > +     return dev->async_shutdown =3D true;
> > +}
>
> Shouldn't this function just return void?

Yes, it should just be changed to a void.

David Jeffery

