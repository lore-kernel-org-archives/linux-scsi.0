Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D186B3515EA
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 20:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786564921; cv=none; b=ZZskeptG6Rl4ypVLzVNd8p3qVoLfzgYl6RYDuOySh0EJF61kqvxBLmC/WIwGnJanwA6/r1ZFFC6X6dyksd7ByjQ1s0gWBtaMU/nYsl7dbxDlPUnYE+5Rvy2RDuqs+j7cD/qtulo0IUlRFB6xQYtdudKwgIz5O4nNgWXdvjtbvV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786564921; c=relaxed/simple;
	bh=iryPUlFq53drzNQlePSdxVOhynXbRHAve2NccnUMWBI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sgyFzwwjzO0hLo+Tl+7nskca7ZV76yyFjmvdTarM6uJb4jnAcMXGz7wl8crJ61wHpWh8P4OFFe6vPcff/cm3IezIXIriSFSTzNtngL931j+lYHNXRIF6n0s37eEjBFFzAgv6KPFJCFPdzH5y+peOZJISaJ5QPgCvH6hCBR6m3wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqAC2EwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqAC2EwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF5F1F000E9;
	Wed, 12 Aug 2026 20:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786564919;
	bh=+ojYOQ6V0MBgRtb2PSeX0d2lbKvMEccjarITD+K+kMc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iqAC2EwLjVeIzs0T+gC8CFJ4AAhbQxKNjmmlML710Xz6V5YbcYYM/aoic51qpjl0k
	 FANUmnblZhtTfKrvqs/AH+SRcNiUuPzBv0WHRcHmIip/CzpKurVOFeXDPyz3yQdPPh
	 6qs0x040MMkZF5cpqqTGdSnSmtzHR3qx1wRPyiRUvUdN6z2XotaM3qtPfUgyYgBJZz
	 zVea1GKIIDQHfAahEdjscYG1tVHop+WeiEAIvMA0lPLC46xpTE8/l09wIqzxcm8h7B
	 TdjwEw+mINInU3hLfKQS8bDst8PRh02VoyiMEYUCnNT/FQHgBNt1x/MJf/kI7CH7oM
	 tN3nCJCEY0/BA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/3] scsi: libsas: Handle errors in
  sas_ex_discover_expander()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eshaan Deshmukh" <eshaan2031@icloud.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812194808.576586-4-eshaan2031@icloud.com>
References: <20260812194808.576586-1-eshaan2031@icloud.com>
 <20260812194808.576586-4-eshaan2031@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 20:01:59 +0000
Message-Id: <20260812200159.6EF5F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing check for `sas_expander_alloc()` failure leads to an inval=
id pointer dereference and kernel panic.
- [High] Ignoring the return value of `sas_rphy_add()` leads to a kernel pa=
nic upon teardown.
--

--- Patch [3]: [PATCH v3 3/3] scsi: libsas: Handle errors in  sas_ex_discov=
er_expander() ---
commit ae2723570a72c0c97de94806125a00a3b79e17cd
Author: Eshaan Deshmukh <eshaan2031@icloud.com>

scsi: libsas: Handle errors in sas_ex_discover_expander()
   =20
This commit improves error handling in sas_ex_discover_expander() by checki=
ng
the return values of sas_port_alloc() and sas_port_add(). If either function
fails, it cleans up the child device and port allocations before returning.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index ab6afbad37feb..a83493f574c30 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -911,7 +911,6 @@ static struct domain_device *sas_ex_discover_expander(
>  	struct sas_rphy *rphy;
>  	struct sas_expander_device *edev;
>  	struct asd_sas_port *port;
> -	int res;
> =20
>  	if (phy->routing_attr =3D=3D DIRECT_ROUTING) {
>  		pr_warn("ex %016llx:%02d:D <--> ex %016llx:0x%x is not allowed\n",
> @@ -925,9 +924,13 @@ static struct domain_device *sas_ex_discover_expande=
r(
>  		return NULL;
> =20
>  	phy->port =3D sas_port_alloc(&parent->rphy->dev, phy_id);
> -	/* FIXME: better error handling */
> -	BUG_ON(sas_port_add(phy->port) !=3D 0);
> +	if (!phy->port) {
> +		goto out_put_device;
> +	}
> =20
> +	if (sas_port_add(phy->port)) {
> +		goto out_free_port;
> +	}
> =20
>  	switch (phy->attached_dev_type) {
>  	case SAS_EDGE_EXPANDER_DEVICE:

[Severity: High]
This is a pre-existing issue, but can this lead to an invalid pointer
dereference?

If sas_expander_alloc() fails under memory pressure and returns NULL, it is
assigned to rphy in the switch statement below:

sas_ex_discover_expander() {
    ...
    case SAS_EDGE_EXPANDER_DEVICE:
        rphy =3D sas_expander_alloc(phy->port, SAS_EDGE_EXPANDER_DEVICE);
    ...
}

The code later blindly offsets and dereferences this:

sas_ex_discover_expander() {
    ...
    edev =3D rphy_to_expander_device(rphy);
    ...
    edev->level =3D parent_ex->level + 1;
    ...
}

Since rphy is not at offset 0 within struct sas_expander_device,
container_of creates an invalid pointer for edev. Dereferencing it
causes a kernel panic. Should we check if rphy is NULL before continuing?

[ ... ]

> @@ -966,19 +969,29 @@ static struct domain_device *sas_ex_discover_expand=
er(
>  	list_add_tail(&child->dev_list_node, &parent->port->dev_list);
>  	spin_unlock_irq(&parent->port->dev_list_lock);
> =20
> -	res =3D sas_discover_expander(child);
> -	if (res) {
> -		sas_rphy_delete(rphy);
> -		spin_lock_irq(&parent->port->dev_list_lock);
> -		list_del(&child->dev_list_node);
> -		spin_unlock_irq(&parent->port->dev_list_lock);
> -		sas_put_device(child);
> -		sas_port_delete(phy->port);
> -		phy->port =3D NULL;
> -		return NULL;
> -	}
> +	if (sas_discover_expander(child))
> +		goto out_delete_rphy;
> +

[Severity: High]
This is a pre-existing issue, but can ignoring the return value of
sas_rphy_add() cause a crash during teardown?

Earlier in this function, sas_rphy_add(rphy) is called without checking if =
it
was successful. If it fails, device_add() cleans up and sets dev->p to NULL.

If a subsequent function like sas_discover_expander(child) fails here, the
error path goes to out_delete_rphy:

sas_ex_discover_expander() {
    ...
    out_delete_rphy:
        sas_rphy_delete(rphy);
    ...
}

This path unconditionally calls device_del() inside sas_rphy_delete().
Calling device_del() on a device that was never successfully added will
dereference the NULL dev->p, causing a panic. Does sas_rphy_add() need
error handling?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812194808.5765=
86-1-eshaan2031@icloud.com?part=3D3
