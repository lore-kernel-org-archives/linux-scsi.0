Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9288F4189DC;
	Fri, 24 Jul 2026 22:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784930530; cv=none; b=h2Hwl41vw0ZjG8ezr8jIQbuyzrqa0n0AFRKMvU8RLAJDsPavt8TLwt4c28u6foiKoViPCm79lgZ7zM3tVUMTD8Zka8iN6sZY38wt8kYtXXG8qRdXtQhZTnRAty6DVY9AdCdNK2CJ7366h/xPZpAQYuTbbnOjWkCxmTpKvmv4bmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784930530; c=relaxed/simple;
	bh=01xT/nE994u15jzgsUnckCgDkMS8FuQh1JPVYLWu+Kc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AxjDHREEaK2HQLqsi2Ixkxp3OgiwCkIHAKAPN5TxEX9vtuBbbsYuSCL39p9mam+ftVhW2XAJ+RfwFVNMkIyKDAZU6P0CN/yNqkXaF0CfkkcmqXStxY15ug2yqrqSxHjNSUtGkX4zKrprr4x+WrRYZYKC+v8xX1i7+6SNnLDqflI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PrfSQoQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PrfSQoQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0CF1F000E9;
	Fri, 24 Jul 2026 22:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784930529;
	bh=ns2qRIrk7E9QKu5RFrWUtrc58Tz+FAj0Sm00vns3q4c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PrfSQoQZKbgMeCMJN8jpbGm3NqX5juMQQWlOicAfK88glNzrCTJ7pU2pzCAIJySQ/
	 bCEV8bEL1SEtuzlwybuOqB8PT/O+7f1TLSLByY/748deODtRpbT5FFXg81KC04RZzb
	 nJP9FB4JjClS7/ICtpm3vddv3/QA2UIoW5QwEHGclL4ysdNOGhpC9kOLduO8AYX+7Z
	 0mM6m9ZO53YIMwJZlmsmU0fUm/1rIdyq62gCFHaExKeYjt9Yld7obfdh2NrFA71lrM
	 7nQgLqUpYTrMoPou23u8XJzK2crkCND4as0BIi/NYWcB8HwYC6OiHa6pO5CcKb/KJY
	 yjpCbXpXo2OIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 7/9] PCI: Make pci_match_one_device() match on ID
 instead of device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: linux-scsi@vger.kernel.org, cassel@kernel.org, dlemoal@kernel.org, dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260723-pci_id_fix-v4-7-3580726844e1@garyguo.net>
References: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>
 <20260723-pci_id_fix-v4-7-3580726844e1@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 22:02:08 +0000
Message-Id: <20260724220209.1A0CF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-After-Free in PCI device probe due to unprotected dynamic ID p=
ointer.
--

--- Patch [7]: [PATCH v4 7/9] PCI: Make pci_match_one_device() match on ID =
instead of device ---
commit 6e87a7c82585926a2bb69878be8d34b27c58a215
Author: Gary Guo <gary@garyguo.net>

PCI: Make pci_match_one_device() match on ID instead of device

PCI dynamic ID needs to match IDs against a new ID to see if it already
exists. Existing APIs can only match IDs against devices, causing the
dynamic ID insertion code to create a temporary device only for matching
purpose. Rename pci_match_one_device() to pci_match_one_id() so it can be
used for this purpose instead; add a pci_id_from_device() helper to make it
easy to convert users.

> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index f36778e62ac1a..c9424edb45481 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c

[ ... ]

> @@ -145,10 +162,11 @@ static const struct pci_device_id *pci_match_device=
(struct pci_driver *drv,
>  	if (ret =3D=3D 0)
>  		return NULL;
> =20
> +	dev_id =3D pci_id_from_device(dev);
>  	/* Look at the dynamic ids first, before the static ones */
>  	spin_lock(&drv->dynids.lock);
>  	list_for_each_entry(dynid, &drv->dynids.list, node) {
> -		if (pci_match_one_device(&dynid->id, dev)) {
> +		if (pci_match_one_id(&dynid->id, &dev_id)) {
>  			found_id =3D &dynid->id;
>  			break;
>  		}

[ ... ]

> @@ -158,7 +176,7 @@ static const struct pci_device_id *pci_match_device(s=
truct pci_driver *drv,
>  	if (found_id)
>  		return found_id;

[Severity: High]
This isn't a bug introduced by this patch, but could this returned found_id
pointer lead to a use-after-free?

Looking at pci_match_device(), if it matches a dynamic ID, it sets found_id
to &dynid->id and then drops drv->dynids.lock before returning the pointer.

If a concurrent write to the driver's remove_id sysfs attribute occurs,
remove_id_store() will acquire the same lock, remove the dynamic ID from the
list, and free it:

drivers/pci/pci-driver.c:remove_id_store() {
	...
			list_del(&dynid->node);
			kfree(dynid);
			retval =3D count;
			break;
	...
}

Wouldn't the probe path then pass this dangling pointer to the driver's pro=
be
function?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723-pci_id_fix=
-v4-0-3580726844e1@garyguo.net?part=3D7
