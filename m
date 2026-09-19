Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429DE372673
	for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 01:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789783142; cv=none; b=MDAdsVajHw1BCvjTGy4uKL/ZZSFjwDXeCmUWXqHTNUB7ytwcucprmSas/UfvjOF+DYYk5hFYRtpqrAHN0xJqYEIgW6sxNhE6cg/6ok4yaWcSvrfprI/BU1V5JspSwX9k719yngt5caZkEEXqeVKK6KEezMi7PkJzLU3GN11/xhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789783142; c=relaxed/simple;
	bh=OxllwI52KUaL1eZS77lozUcwgkmOWgtS+OirWxqy624=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D7U8HN1qewuJygp+PQ4BVdy0T7Wf9ZICO0bPY7X5metl8tA/34vwsOQFTwbu++Eu6ULU7jTxwZndOh/uKfRKVuF7SuO0kZUNyU/K7tstPYQiRLnDqnxIGrccfidWfEO5a6BPqcbhZCc2to+943TCiboI+6puBfa5LXXUuD+JkGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vt+nlL7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vt+nlL7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E421F000FF;
	Sat, 19 Sep 2026 01:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789783139;
	bh=xhgG78CKQeP78opBA2QPICwBAnDX9IPRIJMEnMwTos8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vt+nlL7FcvyD92Vwm9VSCADI+lI2XwM0PeAUdiljnLLT4c2+6JpFOGIwutOu5ko5g
	 a8ZEKWaLIrukPnVt6nT7i2J3AjgPvXsmqaseoFLDm2yWH4JpKdKNyViL8hkMQca9ur
	 PHtgdfMYhSF4v/RM7DXi87YEzKJy0n4rNi3qsCOdnF9Z+bhWy0k+VAmNZqaQEz5u46
	 1npGUGFTpCbbq7oMgDfh2lLV2tP/cf5daKSS5icPpvZfRJH7jt9Fgg7xoTD9lIBwE3
	 YNX7CCjgLm36x6SiuwbjM6tXEOinc8dzFbvDmj/nxE76A7KguGAkx4BYD5vMg/gJfL
	 ALOYmfiP99ucw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 15/20] scsi: ibmvfc: unregister NVMe local port on
 adapter removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260919013306.2948028-16-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
 <20260919013306.2948028-16-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 19 Sep 2026 01:58:59 +0000
Message-Id: <20260919015859.A8E421F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: lockless list modification in ibmvfc_remove() races =
with tasklet
- [High] scsi: ibmvfc: use-after-free on rport in ibmvfc_remove()
--

commit 64ca41cc44b400a863417867ee490f75b432ff92
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: unregister NVMe local port on adapter removal

This commit ensures the NVMe local port is unregistered during adapter remo=
val
to prevent a use-after-free when the transport subsequently touches the por=
t.
It does this by adding teardown calls for targets and the local port before
host memory is freed.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 080312ff0a93d..e68ed5e79e58c 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -6976,6 +6976,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const=
 struct vio_device_id *id)
>  static void ibmvfc_remove(struct vio_dev *vdev)
>  {
>  	struct ibmvfc_host *vhost =3D dev_get_drvdata(&vdev->dev);
> +	struct ibmvfc_target *tgt, *tgt_tmp;
>  	LIST_HEAD(purge);
>  	unsigned long flags;
> =20
[ ... ]
> @@ -6992,6 +6993,22 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>  	fc_remove_host(vhost->host);
>  	scsi_remove_host(vhost->host);
> =20
> +	list_for_each_entry_safe(tgt, tgt_tmp, &vhost->nvme_scrqs.targets, queu=
e) {
> +		if (tgt->nvme_remote_port)
> +			ibmvfc_nvme_unregister_remoteport(tgt);
> +		list_del(&tgt->queue);

[Severity: High]
Does this list_del() race with concurrent list traversals in the tasklet?

Because this loop modifies the list locklessly without holding vhost->host_=
lock,
and the CRQ is not torn down until ibmvfc_release_crq_queue() is called lat=
er
in this function, an incoming asynchronous event (like IBMVFC_AE_ELS_LOGO)
could trigger the ibmvfc_tasklet.

The tasklet handles the event by locking host_lock and traversing the same =
list:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_handle_async() {
    ...
    list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
    ...
}

Will this concurrent lockless modification lead to list corruption and a ke=
rnel
panic during the traversal?

> +		timer_delete_sync(&tgt->timer);
> +		kref_put(&tgt->kref, ibmvfc_release_tgt);
> +	}
> +
> +	list_for_each_entry_safe(tgt, tgt_tmp, &vhost->scsi_scrqs.targets, queu=
e) {
> +		if (tgt->rport)
> +			fc_remote_port_delete(tgt->rport);

[Severity: High]
Is it possible this dereferences a freed rport?

Right before this loop, fc_remove_host(vhost->host) and
scsi_remove_host(vhost->host) are called. fc_remove_host() synchronously
deletes all remote ports, and scsi_remove_host() removes all SCSI targets,
dropping their final references to the rport structures and causing them to
be freed.

Will dereferencing tgt->rport here (such as reading rport->dev_loss_tmo ins=
ide
fc_remote_port_delete) result in a use-after-free?

> +		list_del(&tgt->queue);
> +		timer_delete_sync(&tgt->timer);
> +		kref_put(&tgt->kref, ibmvfc_release_tgt);
> +	}
> +
>  	spin_lock_irqsave(&vhost->host->host_lock, flags);
>  	ibmvfc_purge_requests(vhost, DID_ERROR);
>  	list_splice_init(&vhost->purge, &purge);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919013306.2948=
028-1-tyreld@linux.ibm.com?part=3D15
