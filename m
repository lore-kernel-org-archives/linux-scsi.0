Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A45748A8C2
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 21:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789595223; cv=none; b=WjTJRZxsw/oe80mXYvnEylQGU3BrJfyCdF6T/oLHENe1siCxozbl/5dzHKHDeaxolj4qpsfHNtLnuaB3kEH5NClH3fCBTKazxIs01/934Z06UYEaH6Nj/mqM2+e+aeCw7OzgMwfZY7G3a90VT4IdtzPBdzcf4rKtNzpsns+sA9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789595223; c=relaxed/simple;
	bh=IyF3BrfsdKKAy5MYgZZbuK4fPDib02QLAKMSb/gQKxk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ScjLJoIMP5HVEz1IxCR98zSZiL5fhyY8RQMrc2rx81PQPBp5ebHZNGF4nKMMcL5LjwE2s8RllFErDKFni3+iACtpAH9eVVgWmrQWCWkcSutQC1x5fbUTRyqZ2dzZWus70fooz9WI+OCz/m7TGo8ZRQ52nCMRbFU4EUGY1Nn+0q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nmcAed4b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nmcAed4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3F61F000FF;
	Wed, 16 Sep 2026 21:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789595201;
	bh=7D8GR4cDAFjUYpGQd8uXLtBdl6lDYmB1FsPVxQPVEG4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nmcAed4bvadDaPNCcu+N19IJABr9WpqzP9LHCkRlfUG2mlvkL3Qia0dUUR1RTPY12
	 TiC4IlqHIg5LbdRCfWQMNyvaIq7oD1rKsOP+JUTbPrlh9ZqB/tZf2gxTT/2gQHM9yD
	 igyJWs+jF4r7u/gV8SXd5cZk4KPJjb3HDwexkyeViJqNsFeAi4wP0wq5H9nvUIc9SX
	 kHP0/km2eVPoRrA/sYTf7KL4OJHlhIUZB/LoZHuBxHY1GNb0KuQJnL08fD+xnwOkrS
	 3+k+NSdQlB/8P2+7TGYigKbakGtly4EihL9Aug//UQLYjokAbo5K5gHPdqphk/31YH
	 /NML2CDC1oU7Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ibmvscsi: implement vio driver shutdown call back to
 quiesce ibmvscsi
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260916213359.2144094-1-tyreld@linux.ibm.com>
References: <20260916213359.2144094-1-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 21:46:41 +0000
Message-Id: <20260916214641.AF3F61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ibmvscsi: Use-After-Free in queuecommand due to inverted tea=
rdown
--

commit cb6df094529f08b7b5070579476f4f00c65a9dfd
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvscsi: implement vio driver shutdown call back to quiesce ibmvscsi

Currently during kexec the vio driver implementation calls a drivers
remove function as a big hammer when shutdown isn't implemented. This
results in filesystem errors in the log as a result of the block device
being removed while the filesystem is still mounted. Rectify this noise
by quiescing the ibmvscsi driver and stopping short of tearing down the
full host.

> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibm=
vscsi.c
> index 609bda730b3a8..a8859cd603824 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c

[ ... ]

> +static void ibmvscsi_shutdown(struct vio_dev *vdev)
> +{
> +	struct ibmvscsi_host_data *hostdata =3D dev_get_drvdata(&vdev->dev);
> +
> +	scsi_block_requests(hostdata->host);
> +	ibmvscsi_quiesce(hostdata, DID_REQUEUE);
> +}

[Severity: High]
Can this create a use-after-free race condition with in-flight commands?

While scsi_block_requests() prevents new requests, it does not flush or wai=
t for
in-flight commands. Calling ibmvscsi_quiesce() right after destroys the eve=
nt
pool via release_event_pool(), which frees pool->events.

Any concurrent midlayer commands already in progress could attempt to acces=
s the
freed event pool.

> +
> +static void ibmvscsi_remove(struct vio_dev *vdev)
> +{
> +	struct ibmvscsi_host_data *hostdata =3D dev_get_drvdata(&vdev->dev);
> +
> +	ibmvscsi_quiesce(hostdata, DID_ERROR);
> =20
>  	spin_lock(&ibmvscsi_driver_lock);
>  	list_del(&hostdata->host_list);
>  	spin_unlock(&ibmvscsi_driver_lock);
> =20
> +	srp_remove_host(hostdata->host);
> +	scsi_remove_host(hostdata->host);

[Severity: High]
Does reordering these calls cause a deterministic use-after-free during unb=
ind?

By calling ibmvscsi_quiesce() first, the event pool is destroyed and
pool->events is freed.

When scsi_remove_host() is subsequently called, it removes SCSI devices, wh=
ich
synchronously dispatches a final SYNCHRONIZE CACHE command via the block la=
yer.

This command reaches ibmvscsi_queuecommand_lck(), which attempts to allocat=
e an
event struct from the freed pool:

drivers/scsi/ibmvscsi/ibmvscsi.c:get_event_struct() {
    ...
		if (!atomic_dec_if_positive(&pool->events[offset].free)) {
    ...
}

This will dereference the already freed pool->events array before any reque=
st
limits are checked.

>  	scsi_host_put(hostdata->host);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916213359.2144=
094-1-tyreld@linux.ibm.com?part=3D1
