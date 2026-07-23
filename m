Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5882E2BB13
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784767996; cv=none; b=PTC2gJwxeNqObtnCGBYVCIn1r4qFnM1UoFIjkueOW2ZdnNwhmxI6gsOx3vMkasnmS1UDTSN3WiU5o59bRv3ClsUmNvQHcQHNaYWmGnesZNONLzstfZakeS9oup+RA+dNi3Zmz6c/mfdGHUEPvxt8nHt4WQx5HYNpUx8VjIzfSTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784767996; c=relaxed/simple;
	bh=rJaVbe3UZiYhcTNJjM1os7utwCJdT5VCgsGgX5nxE4Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=grlVV1Jmn2euWMQErvQThpbIDeDyGfZYDuk5xK2z9oQT3QYa18QgKWZqFjy1c7zIfV0zNNMnkGDo5pFIJ5Am9uStyW0GBZIstPlwfYeCMkchpv4S9sfqjNokzgxLj8i1CGy3bb0UuYLsavh1XOVbfjh/XfthAjAzJzFLAbPOdPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1+3HSv1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1+3HSv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FE91F000E9;
	Thu, 23 Jul 2026 00:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784767995;
	bh=ISV0xBAuWIUVMucKAPF/Csk6iZugt3zFN77YM9nWUYs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T1+3HSv1yT7rKwr8tJvMpzxGkoIfXeuNq260W6MCtNL6S9DUUUJl8/To7bWoTXdQC
	 6XdiBYfehZnTHpZQJksjNW2XwXNkEyWpYfI1fOEy2/CDkUNw2QKnrIWLXj4pBpTIq8
	 B0LRrGs51WtFGpTP6QshS5tO5Q6oKqr/hl3gqe9vExtcuujwlDVffL/d7xriM//k3y
	 Gb4J7kizUZg5uVWCcgESapSuZ8xTnph5h4UxFkI5oITKCoBdT9tRcuerBHlhEg27Bk
	 H1THLopAOxoWX0dykwaxWr3E8OytgqmH4iT4n6cjgivEidutuuWwtS6LMtpBMM+Wo1
	 xLLVO8wZ3e0OA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 24/33] ibmvfc: register local nvme fc port after
 fabric login
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-25-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-25-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:53:14 +0000
Message-Id: <20260723005315.14FE91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Blocking operations (GFP_KERNEL allocations and wait_for_compl=
etion) are executed from atomic context, causing a system panic.
- [High] An unconditional `put_device()` on the `ibmvfc_nvme_unregister()` =
failure path without clearing the local port pointer leads to double-puts a=
nd use-after-free.
- [High] The NVMe local port and device reference are not cleaned up during=
 driver removal, leading to a resource leak and potential use-after-free.
- [High] Re-initializing the host without an explicit adapter reset leaks t=
he active `nvme_local_port` and overwrites its pointer with `NULL`, breakin=
g NVMe functionality.
--

--- Patch [24]: [PATCH v2 24/33] ibmvfc: register local nvme fc port after =
fabric login ---
commit 4eb644adc42ffc19ca6cdbdf0f3e3185c26ee9b7
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: register local nvme fc port after fabric login

This patch delays registering the local nvme fc port until after the fabric
login completes, allowing the client port ID to be populated from the fabric
login response.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -5210,6 +5210,8 @@ static void ibmvfc_fabric_login_nvme_done(struct ib=
mvfc_event *evt)
> =20
>  	switch (mad_status) {
>  	case IBMVFC_MAD_SUCCESS:
> +		fc_host_port_id(vhost->host) =3D be64_to_cpu(rsp->nport_id);
> +		ibmvfc_nvme_register(vhost);

[Severity: Critical]
Can this sequence safely execute under the host lock?

The completion handler ibmvfc_fabric_login_nvme_done() is invoked via
the ibmvfc_locked_done() wrapper, which acquires the vhost->host->host_lock
spinlock and disables interrupts.

However, ibmvfc_nvme_register() calls into nvme_fc_register_localport()
which performs memory allocations using GFP_KERNEL. Could this lead to a
scheduling while atomic regression?

[Severity: High]
What happens to the local port during a fabric link bounce?

If the link bounces, ibmvfc_link_down() deletes targets but doesn't appear
to unregister the local port. When the adapter re-initializes and completes
fabric login, this will unconditionally call ibmvfc_nvme_register() again.

If nvme_fc_register_localport() detects the existing port and returns
-EEXIST, its error path sets the portptr to NULL.

Could this leak the original local port and prevent nvme from functioning
until the driver is reloaded?

>  		ibmvfc_dbg(vhost, "NVMe fabric login succeeded\n");
>  		break;

[ ... ]

> @@ -5653,6 +5656,7 @@ static void ibmvfc_npiv_logout_done(struct ibmvfc_e=
vent *evt)
>  	case IBMVFC_MAD_SUCCESS:
>  		if (list_empty(&vhost->crq.sent) &&
>  		    vhost->action =3D=3D IBMVFC_HOST_ACTION_LOGO_WAIT) {
> +			ibmvfc_nvme_unregister(vhost);

[Severity: Critical]
Is it safe to wait for completion here?

Similar to the registration path, ibmvfc_npiv_logout_done() executes under
the host_lock spinlock with interrupts disabled.

ibmvfc_nvme_unregister() calls wait_for_completion() which sleeps. Can
blocking here while holding the spinlock cause a scheduling while atomic
regression?

>  			ibmvfc_init_host(vhost);
>  			return;
>  		}

[ ... ]

> @@ -5931,6 +5935,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhos=
t)
>  		list_splice_init(&vhost->purge, &purge);
>  		spin_unlock_irqrestore(vhost->host->host_lock, flags);
>  		ibmvfc_complete_purge(&purge);
> +		ibmvfc_nvme_unregister(vhost);

[Severity: High]
Should the driver removal path also unregister the nvme local port?

During device unbind or module removal, ibmvfc_remove() tears down the
adapter but doesn't seem to call ibmvfc_nvme_unregister().

If the port remains registered with the nvme fc transport layer, its
private pointer still points to the vhost structure. After vhost is freed,
could subsequent transport accesses lead to a use-after-free, while also
leaking the device reference acquired during registration?

>  		rc =3D ibmvfc_reset_crq(vhost);
> =20
>  		spin_lock_irqsave(vhost->host->host_lock, flags);

[ ... ]

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> @@ -165,9 +168,17 @@ void ibmvfc_nvme_unregister(struct ibmvfc_host *vhos=
t)
>  		return;
> =20
>  	if (vhost->nvme_local_port) {
> +		ibmvfc_log(vhost, 2, "unregister_localport: host-traddr=3Dnn-0x%llx:pn=
-0x%llx on portID:%x\n",
> +			   vhost->nvme_local_port->node_name,
> +			   vhost->nvme_local_port->port_name,
> +			   vhost->nvme_local_port->port_id);
>  		init_completion(&vhost->nvme_delete_done);
>  		rc =3D nvme_fc_unregister_localport(vhost->nvme_local_port);
> -		if (!rc)
> +		if (!rc) {
>  			wait_for_completion(&vhost->nvme_delete_done);
> +		} else
> +			dev_err(vhost->dev, "Failed to unregister NVMe fc localport (%d)\n", =
rc);
> +
> +		put_device(vhost->dev);

[Severity: High]
If nvme_fc_unregister_localport() fails, vhost->nvme_local_port is not
set to NULL, but put_device() is still called unconditionally.

If ibmvfc_nvme_unregister() is called again later, such as during a
subsequent adapter reset loop, will it attempt to unregister the same port
and drop the device reference a second time? Could this sequence result
in a use-after-free on the device structure?

>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D24
