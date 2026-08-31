Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530F53E025C;
	Mon, 31 Aug 2026 10:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788171703; cv=none; b=VJxoTB/WncxaEPKcqscLFYit2LXORQt2bdg9Y8FKSyFzcEcGPEe8opBq66N3zYFfEw1U+p6lnPjlx4GZ5t7APfGu2WIG43+oM2sW4zx4CG47e89832MaKJEjmRmYO1Y15YH4PW+DskSMtQOSDLQ/yov5UUCGpfga4TxF3MCeJFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788171703; c=relaxed/simple;
	bh=xh/n9ggdZaZdEYESSVofBTZOm8D7U5HugP31cICKBxY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cgdiW+DqQREDX2qDXb4MbvutzRg0utJfXNcZkI5j0wm7VZ65ntbziuh3zA2LKW3bYwANWuOhLNUgZOzOmytfB30AMZRi7P09O/Yp3tSTBnMB5bRKDaoVwPLe6rrleMfQzXBeve8XjvkUhDC4izFQzISwEM9o4RiHXP45gLp25OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ilQ9HYZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ilQ9HYZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD301F000E9;
	Mon, 31 Aug 2026 10:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788171702;
	bh=482A8wxKWAejqt87IOip5XJWlj6h+c5UsAa4I2hNww0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ilQ9HYZ9Z/2bDYyWwFWqDVA+7VwMDNEwMUfVJIaijcRFM1+DTIuHDKfUdnS73uKq9
	 0Ix0CZ5XqQfBS74nopuge3H37JdrDgp0Iu0zp60DWrwd9vy3eXmpGQX4/jBOM6ixuL
	 IVU3fxW8c1OPkx+S2FsGR4HJCVdDZ4jt83uUKw2yLGwSBaorLg8XG9LFYxjb3EeR4S
	 mKAK/DbER2Is9ZgC8IxDe90j0Qrv8sQKayM79bEcfBw6PSjZj2Ljb+IMPSLVW+WJSy
	 30S3qsGkVDqp4gbK5JmRMn9ePxNjt4blLcK6b9y0E84oxbArV3zleL6xHvDGII8FCm
	 62llXbNNyzrsA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5] scsi: core: Drop Scsi_Host.default_lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260831095821.3486994-1-john.g.garry@oracle.com>
References: <20260831095821.3486994-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 10:21:41 +0000
Message-Id: <20260831102141.7FD301F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Permanent event pool leak in `ibmvfc_cancel_all_mq()` on error pat=
h.
- [High] Unchecked NULL pointer dereference in `ibmvfc_cancel_all_sq()` whe=
n `ibmvfc_init_tmf()` fails.
- [High] Interrupt state corruption in `blogic_qcmd_lck` due to mismatched =
spinlock APIs.
- [High] Device lifecycle violation causing memory leak in `fc_remote_port_=
create` and `fc_vport_setup`.
--

commit 1fa27f7b3e85b7b53dfe21659957115715567c63
Author: John Garry <john.garry@linux.dev>
Subject: scsi: core: Drop Scsi_Host.default_lock

This patch removes the default_lock from Scsi_Host and makes host_lock an
actual lock instead of a pointer. This simplifies the locking mechanism and
removes an unnecessary pointer dereference across the subsystem.

> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 5304d2febd63e..27b446c0c5d0f 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
[ ... ]
> @@ -2915,9 +2915,9 @@ static enum scsi_qc_status blogic_qcmd_lck(struct s=
csi_cmnd *command)
>  	 */
>  	ccb =3D blogic_alloc_ccb(adapter);
>  	if (ccb =3D=3D NULL) {
> -		spin_unlock_irq(adapter->scsi_host->host_lock);
> +		spin_unlock_irq(&adapter->scsi_host->host_lock);
>  		blogic_delay(1);
> -		spin_lock_irq(adapter->scsi_host->host_lock);
> +		spin_lock_irq(&adapter->scsi_host->host_lock);
>  		ccb =3D blogic_alloc_ccb(adapter);
>  		if (ccb =3D=3D NULL) {

[Severity: High]
This isn't a bug introduced by this patch, but does this code corrupt the
hardware interrupt state?=20

The function blogic_qcmd_lck() is called under spin_lock_irqsave() via the
DEF_SCSI_QCMD macro, but here it drops the lock using spin_unlock_irq() when
blogic_alloc_ccb() fails. This unconditionally enables interrupts inside an
irqsave context, which could lead to deadlocks or unexpected re-entrancy.

[ ... ]
> @@ -3062,10 +3062,10 @@ static enum scsi_qc_status blogic_qcmd_lck(struct=
 scsi_cmnd *command)
>  		   be initiated soon.
>  		 */
>  		if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START, ccb)) {
> -			spin_unlock_irq(adapter->scsi_host->host_lock);
> +			spin_unlock_irq(&adapter->scsi_host->host_lock);
>  			blogic_warn("Unable to write Outgoing Mailbox - Pausing for 1 second\=
n", adapter);
>  			blogic_delay(1);
> -			spin_lock_irq(adapter->scsi_host->host_lock);
> +			spin_lock_irq(&adapter->scsi_host->host_lock);
>  			if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START,
>  						ccb)) {

[Severity: High]
This is also a pre-existing issue, but similar to the above, is it safe to
call spin_unlock_irq() here if blogic_write_outbox() fails? It unconditiona=
lly
enables interrupts while the caller expects the context to remain protected=
 by
the original irq_flags from spin_lock_irqsave().

[ ... ]
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index b3bc3ce872d6d..0b154e07299cc 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -2702,7 +2702,7 @@ static int ibmvfc_cancel_all_mq(struct scsi_device =
*sdev, int type)
>  			evt =3D ibmvfc_init_tmf(&queues[i], sdev, type);
>  			if (!evt) {
>  				spin_unlock(queues[i].q_lock);
> -				spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +				spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>  				return -ENOMEM;
>  			}
>  			evt->sync_iu =3D &queues[i].cancel_rsp;

[Severity: High]
This isn't a bug introduced by this patch, but does this early return in
ibmvfc_cancel_all_mq() leak the event pool?

If ibmvfc_init_tmf() fails to allocate an event, the function exits
immediately with -ENOMEM. However, any events that were successfully sent in
previous iterations of the loop and added to the local cancelq list are
abandoned without being freed back to the pool.

[ ... ]
> @@ -2776,7 +2776,7 @@ static int ibmvfc_cancel_all_sq(struct scsi_device =
*sdev, int type)
>  	if (!found_evt) {
>  		if (vhost->log_level > IBMVFC_DEFAULT_LOG_LEVEL)
>  			sdev_printk(KERN_INFO, sdev, "No events found to cancel\n");
> -		spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>  		return 0;
>  	}
> =20
> @@ -2786,7 +2786,7 @@ static int ibmvfc_cancel_all_sq(struct scsi_device =
*sdev, int type)
>  		rsp_rc =3D ibmvfc_send_event(evt, vhost, default_timeout);
>  	}
> =20
> -	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +	spin_unlock_irqrestore(&vhost->host->host_lock, flags);

[Severity: High]
This is a pre-existing issue, but could this result in a NULL pointer
dereference?

Looking at ibmvfc_cancel_all_sq(), just before the spin_unlock_irqrestore,
there is the following sequence:

    if (vhost->logged_in) {
        evt =3D ibmvfc_init_tmf(&vhost->crq, sdev, type);
        evt->sync_iu =3D &rsp;
        rsp_rc =3D ibmvfc_send_event(evt, vhost, default_timeout);
    }

If ibmvfc_init_tmf() fails to allocate an event and returns NULL,
evt->sync_iu =3D &rsp; will dereference a NULL pointer.

[ ... ]
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transpo=
rt_fc.c
> index 173ed6373f04b..be0efffab2fcc 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
[ ... ]
> @@ -3181,10 +3181,10 @@ fc_remote_port_create(struct Scsi_Host *shost, in=
t channel,
> =20
>  delete_rport:
>  	transport_destroy_device(dev);
> -	spin_lock_irqsave(shost->host_lock, flags);
> +	spin_lock_irqsave(&shost->host_lock, flags);
>  	list_del(&rport->peers);
>  	scsi_host_put(shost);			/* for fc_host->rport list */
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> +	spin_unlock_irqrestore(&shost->host_lock, flags);
>  	put_device(dev->parent);
>  	kfree(rport);
>  	return NULL;

[Severity: High]
This isn't a bug introduced by this patch, but does this error path in
fc_remote_port_create() leak core device resources?

After device_initialize(dev) is called earlier in the function, it seems the
error path cleans up by calling kfree(rport) directly instead of using
put_device(dev), which would properly free the device_private structure and
other resources.

[ ... ]
> @@ -3982,11 +3982,11 @@ fc_vport_setup(struct Scsi_Host *shost, int chann=
el, struct device *pdev,
>  	device_del(dev);
>  delete_vport:
>  	transport_destroy_device(dev);
> -	spin_lock_irqsave(shost->host_lock, flags);
> +	spin_lock_irqsave(&shost->host_lock, flags);
>  	list_del(&vport->peers);
>  	scsi_host_put(shost);			/* for fc_host->vport list */
>  	fc_host->npiv_vports_inuse--;
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> +	spin_unlock_irqrestore(&shost->host_lock, flags);
>  	put_device(dev->parent);
>  	kfree(vport);
> =20

[Severity: High]
This is also a pre-existing issue, but does fc_vport_setup() suffer from the
same device lifecycle violation?

It calls kfree(vport) directly on the error path after device_initialize(de=
v)
has already been executed, which would also leave device resources leaked
instead of properly cleaning them up with put_device(dev).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831095821.3486=
994-1-john.g.garry@oracle.com?part=3D1
