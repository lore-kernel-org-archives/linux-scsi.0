Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8E438887C
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2026 20:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781728925; cv=none; b=Br3ORfu4/Fnz6l6yH41noOvoQrmmlLa8p6c2O/UqvLB3oroNQ2Aju1Pm2Xmx8iyvJrwoZbd78Ud22hwcR5E3w2GYtxJHDVVM5ZVfXu8iR0LxGJ43ukOgDWuM30o/wJioa46Z8wh3N0jbPxMbfBmXJdLV/5KLCx8P3KQk7YuRUz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781728925; c=relaxed/simple;
	bh=fGvdfUGijxInyP7L1Xc/27w+AjI5QVGJL17osRMFtZk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IbBbPHVKYWhv+TGOn5z9xrkmaI0lM6JaYUFApVqGYOdwnx44ltzt9mKUHZREjRpGL9TWstw5KT9zcsryOVQcYnnDxLzOSe2uaCR0llrA7dDW69BZSsdJwT0EerJs9cHyLV8vAFDuC1MimsSTA+2K+6DW+ImIP/yx95ZY2vq5El4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H7/WS67K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7/WS67K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A3B1F000E9;
	Wed, 17 Jun 2026 20:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781728923;
	bh=z2/q+LrE+p4ef494GB6kgpjXqi6mSn7keNkhZqs4nto=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H7/WS67K3SYxN6PEKFo7AAYkGlmO02O6sByJfcgLcqIF8+eKIVlIAJ1z9VCaM1fyC
	 JTSVHsx+3TbFTnyhwr/ltWOhynBnCeV0ayLMm21huHAQFgriMmB9aPvncaTcLhpDWS
	 fTdr//lSvAjIH1Mavc70bIvgaI5IPIVwDUaXMYAEy0PK7QM5lgM8JdQn63bqdRcz+4
	 Lz899MI94YF1MnCT5cJHA619xLT5STE3ZJUTm6f/p1sSs3djPaUsmlRwht7/aVEKkP
	 iPStaFF/2GGRJ/tkZFl5mFRQByIxFH0CDiVrwIl2Gs69tPqjJNFAcbhdFC03kOnaHJ
	 guFfXUQK1r71A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: iscsi: publish endpoints after transport setup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ruoyu Wang" <ruoyuw560@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260617182135.957230-1-ruoyuw560@gmail.com>
References: <20260617182135.957230-1-ruoyuw560@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Jun 2026 20:42:03 +0000
Message-Id: <20260617204203.91A3B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The `iscsi_iser` transport driver was not updated to call `iscsi_r=
egister_endpoint()`, completely breaking connection binding.

Pre-existing issues:
- [High] If `device_register()` fails inside `iscsi_create_endpoint()`, a d=
ouble `idr_remove()` occurs with a dropped lock in between, incorrectly del=
eting a concurrent allocation.
--

commit d4c9226c25ea1f5ce70c62be37b16435ed05458c
Author: Ruoyu Wang <ruoyuw560@gmail.com>

scsi: iscsi: publish endpoints after transport setup

iscsi_create_endpoint() inserts a new endpoint into iscsi_ep_idr before
transport drivers have initialized their endpoint-private data. The
endpoint handle is returned only after ep_connect() completes, but handles
are allocated from a predictable IDR and iscsi_lookup_endpoint() looks
them up directly.

Reserve the endpoint ID with a NULL IDR entry, add
iscsi_register_endpoint() for the publish step, and call it from the
in-tree transport drivers after private endpoint setup has completed.
Until registration, endpoint lookup keeps returning NULL for the reserved
handle.

> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_tran=
sport_iscsi.c
> index 8aa76f813bcdb..a8c2a32c0f134 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -217,7 +217,7 @@ iscsi_create_endpoint(int dd_size)
>  	 * First endpoint id should be 1 to comply with user space
>  	 * applications (iscsid).
>  	 */
> -	id =3D idr_alloc(&iscsi_ep_idr, ep, 1, -1, GFP_NOIO);
> +	id =3D idr_alloc(&iscsi_ep_idr, NULL, 1, -1, GFP_NOIO);
>  	if (id < 0) {

[Severity: High]
This is a pre-existing issue, but does the put_dev error path in
iscsi_create_endpoint() result in a double idr_remove() for the same ID?

If device_register() fails, the code jumps to put_dev:

	put_dev:
		mutex_lock(&iscsi_ep_idr_mutex);
		idr_remove(&iscsi_ep_idr, id);
		mutex_unlock(&iscsi_ep_idr_mutex);
		put_device(&ep->dev);
		return NULL;

Calling put_device() drops the kobject refcount to zero, which triggers the
release callback:

drivers/scsi/scsi_transport_iscsi.c:iscsi_endpoint_release() {
	...
	mutex_lock(&iscsi_ep_idr_mutex);
	idr_remove(&iscsi_ep_idr, ep->id);
	mutex_unlock(&iscsi_ep_idr_mutex);
	...
}

Since the lock is dropped before put_device(), could a concurrent thread
successfully allocate the same ID via iscsi_create_endpoint(), only for the
second idr_remove() to incorrectly delete the newly allocated ID belonging
to the concurrent thread?

[ ... ]
> @@ -257,6 +257,28 @@ iscsi_create_endpoint(int dd_size)
>  }
>  EXPORT_SYMBOL_GPL(iscsi_create_endpoint);
> =20
> +int iscsi_register_endpoint(struct iscsi_endpoint *ep)
> +{
> +	void *old;
> +	int err =3D 0;

[Severity: High]
Does the iscsi_iser transport driver need to be updated to call
iscsi_register_endpoint()?

The iscsi_iser driver in drivers/infiniband/ulp/iser/iscsi_iser.c allocates
the endpoint:

drivers/infiniband/ulp/iser/iscsi_iser.c:iscsi_iser_ep_connect() {
	...
	ep =3D iscsi_create_endpoint(0);
	if (!ep)
		return ERR_PTR(-ENOMEM);
	...
	return ep;
}

But it doesn't seem to publish it to the IDR. When userspace subsequently
calls iscsi_iser_conn_bind() to bind the connection, the lookup uses
idr_find(), which correctly returns NULL:

drivers/infiniband/ulp/iser/iscsi_iser.c:iscsi_iser_conn_bind() {
	...
	ep =3D iscsi_lookup_endpoint(transport_eph);
	if (!ep) {
		iser_err("can't bind eph %llx\n",
			 (unsigned long long)transport_eph);
		return -EINVAL;
	}
	...
}

Would this cause the binding lookup to always fail with -EINVAL, preventing
the iSER transport from working?

> +
> +	mutex_lock(&iscsi_ep_idr_mutex);
> +	old =3D idr_find(&iscsi_ep_idr, ep->id);
> +	if (old) {
> +		err =3D -EBUSY;
> +		goto unlock;
> +	}
> +
> +	old =3D idr_replace(&iscsi_ep_idr, ep, ep->id);
> +	if (IS_ERR(old))
> +		err =3D PTR_ERR(old);
> +unlock:
> +	mutex_unlock(&iscsi_ep_idr_mutex);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(iscsi_register_endpoint);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260617182135.9572=
30-1-ruoyuw560@gmail.com?part=3D1
