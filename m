Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C1F64AA4
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 01:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783992622; cv=none; b=CrU2yQjqBdvOnogfi+803KzdhJxCXo+uFtoeJiNE2dfIN0gRplECXtI68hw6JBkQ/V/Ejiq4Pq/05sJWX1A4Kn67Uou9bcUOFS2FeGry9tdiCNGfUO4FxzDRgKp/WfCznA9libyGe7UiK1hrSAWuDQMqRUnilWeO//V5KMqEtPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783992622; c=relaxed/simple;
	bh=a9DWazs9/MC5PYLQ/mCaTV4MuuSwH8woy8xm/jWnw8c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kt8+cq2W8x897t45/kh6j5DQ2PEhy5Ic4cLgsVa+QLDRKyyH7wIwyEj8axx54kAPxQplaeqGz+o6Zlbcut4dLyQp/aaWZk95bcHdjJy2Je0+BUe22Q1woAIPKtVGf/EWp672rNruK+62M1k0YI1k7AIDF39BgbVz8hOZAmKgKoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aA645a01; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aA645a01"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c15deb3377eso336669366b.3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 18:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783992618; x=1784597418; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YKrB3Ft0I68hztrro83NH+VbLgEvLq/HYPor88aI49c=;
        b=aA645a01nIFZh6HAdB3GWVC99WODS4DXkCJ58ebS5fd0sniWOwNr8bjhusHwcx8SNp
         zDZ18aAeK6guiKpLBxP5Wu3TtXsLST1xVzc0QDXp08uyxFB+9zHsm/zDMvfUlgklzffS
         UCEWSwnsAgbAT6U+KVPXKUkwvwgHLaEh/UTnlqTJBIeDuhCZxRIDLe8M8r0/0OWGqnTT
         H54utC5kZSdSTeTAVh2bP8iw6ESMkX0/x4KNH46z4ePgFCh+3QtPCA4Ln0LPSerowxjb
         8Seoojs0qlHEec6pGfXnKfSWUbK+FxuxWdsNDrUddIHIPX3LitKqbwoA1DxOUFij9YHQ
         PohQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783992618; x=1784597418;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YKrB3Ft0I68hztrro83NH+VbLgEvLq/HYPor88aI49c=;
        b=rzG8R5UHe9B7lcrNx4Xi0e8laxWDpiLt3pXDrCXUQFDR3SZYcj5+Xq1CiPNSEwji1B
         Ehcm6a8cd5qvH5EU48ah+N+LY2CqaGtRFQZ54d8O5l+myjY22HbCH957zTTWX+7fb4/i
         naqYm0kuhtMNLyjIPKC2nEfyVLlQQBGyS6mQzBi4sXc3wD+YtfQlvRuhr8RYMAn8plkA
         NvrQYzPn1G4lc32pcukkE4D2Qzj+XvKdYhdQpgn6hlURxJkWLmirhoq969RWhmV4/T01
         43RSwYDxg3PT00Vm9vyHhgpQTzjYoK5/DIy5ZDd8LeCDdYQ04UweajwxzGuhjlnK6JeE
         VQFw==
X-Forwarded-Encrypted: i=1; AFNElJ9bAW2SOm45MVXX6vQ2bu/JWsCVuFZj7cdozT4lC+NbLLejltXVVxQhP3hoKDVp0PGuPIhcfJPvWfNN@vger.kernel.org
X-Gm-Message-State: AOJu0Ywk4fmF2Lqcy5YMcg0fpibq8kLwmvz2PPSdIn22d5O+oKiov03a
	+MmFO06SBFUA0hnb9DpC25gU7EY0qJAOSt5oUSgySw4uLr9v6yTXv9c4HT+UceEXHaCzXFjclNw
	FT9mJv08EvJleKfYytQ==
X-Received: from ede14-n1.prod.google.com ([2002:a05:6402:20ce:10b0:698:572e:ccfe])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:940f:b0:c16:242a:4722 with SMTP id a640c23a62f3a-c16679ee252mr12031666b.22.1783992617943;
 Mon, 13 Jul 2026 18:30:17 -0700 (PDT)
Date: Tue, 14 Jul 2026 01:30:16 +0000
In-Reply-To: <20260701141145.52A611F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260701135015.81937-1-djeffery@redhat.com> <20260701135015.81937-4-djeffery@redhat.com>
 <20260701141145.52A611F000E9@smtp.kernel.org>
Message-ID: <9huzech6xsrb.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH 3/5] driver core: async device shutdown infrastructure
From: tarunsahu@google.com
To: sashiko-reviews@lists.linux.dev, David Jeffery <djeffery@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable


Hello,

These most of the errors are due to the device_add concurrently can add
the device and device_shutdown can access it. One of the reason I think
a device_add will be triggered while being shutdown is inserting the
physical PCI device or USB stick etc.

But During shutdown, addition of a new device is not valid. So we can
add a check something like

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 76ba02c26aa5..c3795fa1cc26 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3650,6 +3650,13 @@ int device_add(struct device *dev)
        if (!dev)
                goto done;

+       if (unlikely(system_state =3D=3D SYSTEM_HALT ||
+                    system_state =3D=3D SYSTEM_POWER_OFF ||
+                    system_state =3D=3D SYSTEM_RESTART)) {
+               error =3D -ESHUTDOWN;
+               goto done;
+       }
+
        if (!dev->p) {
                error =3D device_private_init(dev);
                if (error)

We can also partially resolve the races partially by removing the manual
kfree(dev->p) from device_add() error path. As put_device free it
anyway when reference to devices reaches to 0. So if device_shutdown
path takes reference, dev->p will not be released. And few races will be
taken care of. But this will not resolve the deadlock and other races
like the above change.

removing the kfree(dev->p) from device_add can be a independent patch.
like:

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4d026682944f..76ba02c26aa5 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2614,6 +2614,7 @@ static void device_release(struct kobject *kobj)
        struct device *dev =3D kobj_to_dev(kobj);
        struct device_private *p =3D dev->p;

+       dev->p =3D NULL;
        /*
         * Some platform devices are driven without driver attached
         * and managed resources may have been acquired.  Make sure
@@ -3824,8 +3825,6 @@ int device_add(struct device *dev)
 parent_error:
        put_device(parent);
 name_error:
-       kfree(dev->p);
-       dev->p =3D NULL;
        goto done;
 }
 EXPORT_SYMBOL_GPL(device_add);


~Tarun


sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 4 potential issu=
e(s) to consider:
> - [High] Modifying the core.async_shutdown module parameter during shutdo=
wn causes synchronous suppliers to skip waiting for asynchronous consumers.
> - [High] Unregistered consumer devices will cause a NULL pointer derefere=
nce during async shutdown dependency waiting.
> - [High] Adding a new device with async shutdown enabled while its synchr=
onous supplier is being processed leads to an unresolvable deadlock.
> - [High] Dereferencing `dev->p->dead` without NULL checks causes a crash =
if a concurrent `device_add()` fails.
> --
>
> commit cf98cdf76df805443cc885868cb3d9e13da5501c
> Author: David Jeffery <djeffery@redhat.com>
>
> driver core: async device shutdown infrastructure
>
> This commit allows devices to opt into asynchronous shutdown, executing i=
n
> parallel with unrelated devices after their dependencies shut down. Synch=
ronous
> shutdown devices will wait for their asynchronous dependencies. The featu=
re is
> enabled by default and can be toggled via the core.async_shutdown paramet=
er.
>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
> [ ... ]
>> +static bool wants_async_shutdown(struct device *dev)
>> +{
>> +	return async_shutdown && dev_async_shutdown(dev);
>> +}
>> +
>> +static int wait_for_device_shutdown(struct device *dev, void *data)
>> +{
>> +	bool async =3D *(bool *)data;
>> +
>> +	if (async || wants_async_shutdown(dev))
>> +		wait_for_completion(&dev->p->complete);
>> +
>> +	return 0;
>> +}
>
> [Severity: High]
> If a user-space process toggles the 0644 core.async_shutdown sysfs parame=
ter
> from 1 to 0 during shutdown, could this cause synchronous suppliers to sk=
ip
> waiting for their asynchronous consumers?
>
> If start_async_shutdown_devices() schedules an async consumer, and then t=
he
> parameter is toggled before the sync loop processes its supplier, the cal=
l to
> wants_async_shutdown(dev) here would evaluate to false.=20
>
> This would skip the wait_for_completion(), potentially causing the suppli=
er
> (e.g., a PCI bus) to shut down while its consumer is still active.
>
> [Severity: High]
> Could this result in a NULL pointer dereference if the consumer is not ye=
t
> registered?
>
> The device_link_add() function allows creating links to consumer devices =
that
> haven't been registered yet, meaning their dev->p is NULL because
> device_private_init() hasn't run.
>
> If wait_for_shutdown_dependencies() is called from the async pool, where =
the
> async argument is forced to true, the wait_for_completion() will
> unconditionally evaluate &dev->p->complete, crashing on the NULL pointer.
>
> [ ... ]
>> +static void __shutdown_one_device(struct device *dev)
>>  {
>>  	if (dev->p->dead)
>>  		return;
>
> [Severity: High]
> Could this cause a NULL pointer dereference if a concurrent device_add() =
fails?
>
> If a concurrent device_add() fails after calling kobject_add(), its error=
 path
> calls kobject_del() and then frees and nullifies dev->p. Evaluating
> dev->p->dead without checking if dev->p is valid could crash here.
>
> [ ... ]
>> +static void start_async_shutdown_devices(void)
>> +{
>> +	struct device *dev, *next, *ndev, *needs_put =3D NULL;
> [ ... ]
>> +			needs_put =3D ndev;
>> +			spin_lock(&devices_kset->list_lock);
>> +			/*
>> +			 * If the next device has been marked dead while the
>> +			 * spinlock was released, it may no longer be on the
>> +			 * devices_kset list. Restart the list walk to be safe
>> +			 */
>> +			if (ndev && ndev->p->dead)
>> +				goto restart;
>
> [Severity: High]
> Could ndev->p be NULL if a concurrent device_add() fails?
>
> If start_async_shutdown_devices() obtains a reference to next via
> get_device(), and concurrently device_add() fails and clears dev->p,
> reacquiring the lock and evaluating ndev->p->dead here could result in a =
NULL
> pointer dereference.
>
> [ ... ]
>>  void device_shutdown(void)
>>  {
> [ ... ]
>> -		shutdown_one_device(dev);
>> +		if (!wants_async_shutdown(dev) || !shutdown_device_async(dev)) {
>> +			wait_for_shutdown_dependencies(dev, false);
>> +			shutdown_one_device(dev);
>> +		}
>> =20
>>  		spin_lock(&devices_kset->list_lock);
>>  	}
>>  	spin_unlock(&devices_kset->list_lock);
>
> [Severity: High]
> Can this sequence lead to an unresolvable deadlock if a new device is add=
ed
> concurrently?
>
> If a new device 'C' with DEV_FLAG_ASYNC_SHUTDOWN is added via hotplug
> after its synchronous supplier 'S' has already been popped from
> devices_kset by this loop, 'C' is appended to devices_kset.
>
> 'S' will call wait_for_shutdown_dependencies() and find 'C', blocking on
> wait_for_completion(&C->p->complete) because wants_async_shutdown(C) is t=
rue.
>
> Since 'C' was added after start_async_shutdown_devices() ran, it is not
> running in the async pool. Because the sync loop is blocked on 'S', it wi=
ll
> never reach 'C' to start it, deadlocking the shutdown process permanently=
.
>
> --=20
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260701135015.81=
937-1-djeffery@redhat.com?part=3D3
