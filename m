Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792516788;
	b=OkYjnPIDQff1C9X4R9wE6nMisYJ+TCFkdH5fynrLL2xibsHrRy4JrlEbFUmdckG+4txw
	 rqQuZN+wc1dfLzJdCQFQpuq7JiKzluOh+gOS6AKjHHmPTNb8DuzxquRLkW5c2NDBZQ/U/
	 TYo2cJdduZ4Dx5CFeaJxFfHtoKPkC1kOWsPWbEvWrTMSA2jMvV+ZOYSx/PKAv4tfR53kI
	 2ep6/c9JX+AfWsdoFTbL9E3WH+C1ZCI/u1DlMxSAka06HT69zTkFD2lDif9jUag1XyBL8
	 Sq6kInOCz/W4eORHS+w83jTswZ31mw1h7FggyAbKEdLcyuYmzOt3JjnCfXv2ocPUZaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792516788;
	h=Received:Message-ID:From:Subject:Reply-To:To:Cc:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bD78txjVe7XGBIsptpU3tzd0BEuwDgRAjGdsmV0nEpk=;
	b=FxgWIiHBWrHaGIFZJzF/qtQDK/z5jrFQHbG/4TMQ96WZV1MXLe5kM1O1WWQXD7Vvrngl
	 0gHWdCLQjcT3zbRIKQ24teCXHXUOImAVhUJUuDWCRd5tADY5s+TMuEhoE86Rjz0xAn8SF
	 uJOj1mVMkDjHvVepPbTYs/aExcizK+VHoV24fU019DXnbl3VNnNXRUmVO550HapYwYGmz
	 B29lRpPZp5cDn7YVQKIE3vRDrwvwpC8dNf3IyS6q6JxeQs6v3Lw06GqT8NA/YVvF+VwhW
	 mRWoJZdzHb1OZKF/yUqvQhZ+O7kV/aY2qHi1hGnjhJ9TvHTvIijTo/BFtiqyZbENpPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15C1606A31D;
	Tue, 20 Oct 2026 17:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9F41F000C9;
	Tue, 20 Oct 2026 17:19:47 +0000 (UTC)
Message-ID: <sashiko-outbox-179411@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/9] driver core: async device shutdown infrastructure
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Danilo Krummrich" <dakr@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, "Tarun Sahu" <tarunsahu@google.com>, "Stuart
 Hayes" <stuart.w.hayes@gmail.com>, "Laurence Oberman" <loberman@redhat.com>, "Bjorn
 Helgaas" <helgaas@kernel.org>, kexec@lists.infradead.org, "Ewan Milne" <emilne@redhat.com>, "John
 Meneghini" <jmeneghi@redhat.com>, =?utf-8?b?TG9tYmFyZGksIE1hdXJpemlv?= <mlombard@redhat.com>, "Bart
 Van Assche" <bvanassche@acm.org>, "John Garry" <john.g.garry@oracle.com>, "Jeremy
 Allison" <jallison@ciq.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "Pasha
 Tatashin" <tatashin@google.com>
In-Reply-To: <20261020164435.80499-7-djeffery@redhat.com>
References: <20261020164435.80499-1-djeffery@redhat.com>
 <20261020164435.80499-7-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 17:19:17 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] driver core: premature completion in kill_device() races with devi=
ce_del()
- [Low] driver core: missing kernel-doc for DEV_FLAG_ASYNC_SHUTDOWN
--

commit 82979b053d4cad6e7ae5134feb8f79f9f979e23e
Author: David Jeffery <djeffery@redhat.com>

driver core: async device shutdown infrastructure

This commit introduces asynchronous device shutdown support, allowing
devices flagged with DEV_FLAG_ASYNC_SHUTDOWN to execute their shutdown
callbacks in parallel after waiting for their child and consumer
dependencies to finish shutting down.

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 93605698affcc..7fee6043dd375 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c

[ ... ]

> @@ -3925,6 +3932,7 @@ bool kill_device(struct device *dev)
>  	if (dev->p->dead)
>  		return false;
>  	dev->p->dead =3D true;
> +	complete_all(&dev->p->complete);
>  	return true;
>  }
>  EXPORT_SYMBOL_GPL(kill_device);

[Severity: High]
Does signaling dev->p->complete in kill_device() wake parent and supplier
devices too early when a child or consumer device is concurrently removed
via device_del()?

In device_del(), kill_device() is called right at the start before dropping
device_lock(dev), while the actual driver unbinding and resource release
happen later:

drivers/base/core.c:device_del() {
	device_lock(dev);
	kill_device(dev);
	device_unlock(dev);
	...
		list_for_each_entry(class_intf, &sp->interfaces, node)
			if (class_intf->remove_dev)
				class_intf->remove_dev(dev);
	...
	bus_remove_device(dev);
	device_pm_remove(dev);
	...
	devres_release_all(dev);
}

During device_shutdown(), parent and supplier devices wait for child and
consumer devices in wait_for_shutdown_dependencies() ->
wait_for_device_shutdown(), which only waits on dev->p->complete:

	if (async || wants_async_shutdown(dev))
		wait_for_completion(&dev->p->complete);

Meanwhile, __shutdown_one_device() returns immediately without waiting if
dev->p->dead is set:

	if (!dev->p || dev->p->dead)
		return;

Before this change, a deleting child or consumer stayed on
devices_kset->list until kobject_del() at the end of device_del(), and
shutdown_one_device() serialized on device_lock(dev) against
bus_remove_device() -> device_release_driver() before device_shutdown()
moved on to the parent or supplier. Similarly, for async suspend,
device_pm_remove() does not call complete_all(&dev->power.completion) until
after bus_remove_device() has completed.

By completing dev->p->complete inside kill_device(), can a parent or
supplier proceed with its ->shutdown() callback and shut down a bus or
controller while its child or consumer is still executing
class_intf->remove_dev(), ->remove(), or devres_release_all()?

[ ... ]

> diff --git a/include/linux/device.h b/include/linux/device.h
> index aee79fd6b32b4..1ebafa7984621 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -612,6 +612,7 @@ enum struct_device_flags {
>  	DEV_FLAG_OF_NODE_REUSED =3D 7,
>  	DEV_FLAG_OFFLINE_DISABLED =3D 8,
>  	DEV_FLAG_OFFLINE =3D 9,
> +	DEV_FLAG_ASYNC_SHUTDOWN =3D 10,
> =20
>  	DEV_FLAG_COUNT
>  };

[Severity: Low]
enum struct_device_flags has a kernel-doc comment immediately above it (whi=
ch
is parsed via the :internal: directive in
Documentation/driver-api/infrastructure.rst). Should an entry for
@DEV_FLAG_ASYNC_SHUTDOWN be added to that comment to avoid a kernel-doc
warning?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261020164435.8049=
9-1-djeffery@redhat.com?part=3D6
