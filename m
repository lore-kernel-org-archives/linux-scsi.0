Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFC71DDC37;
	Tue, 30 Jun 2026 20:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782851159; cv=none; b=ZoUP2iJnAk3aZ2LbqFZXlTBd41TZEtzpZ3MuAPnJKnxhvAY7qAkh5cuQiVaEiVdnYplx5+OSfRg6pakAPly3/INgNo5i3u5IXowdDBJQFZTOLOliOLLZkpYcvbQ1PwoEXNmq5byWXuozVgnfB3ftVIpRfmRx3U8frHwNBLTu3Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782851159; c=relaxed/simple;
	bh=fn0Si16fB/Py5zOnzWA6qcKRxBuEt44wN4T059GbeHQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Subject:Cc:To:
	 References:In-Reply-To; b=gSQ74B2M92EC5oP1wJGzQ9qOQssikos9rbHKDcIpIjkqO8vqXbREa2eX4jUQ1fKoYzjdRWx77k0cfr4CL4IOc0aKeuRbH4ltVRay/ET/nqj3D84biRRGqBgSzJFCRO/ZZ95IDlPazai3V9zYY/gJYERRusLsZSLA22R21N2AWec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WwWjwHhL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WwWjwHhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F5F1F000E9;
	Tue, 30 Jun 2026 20:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782851157;
	bh=trroYMM3IfwYoctVWKL+QncsfIKLFxQDxzxhPjX3+k8=;
	h=Date:From:Subject:Cc:To:References:In-Reply-To;
	b=WwWjwHhL5J1M5x0eOeaEA8FJbRmsSukIX3hRDzcwMjbXAoK8ynCtWlT69RpYJ8Aqh
	 zBE3qudaQ8zjX9cKd/afMNqMWvQF2TUW6q1VfJvBQEsEbK0orAFb5mLR16S4Zi0ga2
	 AGDXke17+/TQBYa8h7LQ2+rRQMKffkAT5BT6DELy50uq5fmdSTDoojik90A9F0Shbj
	 yPX+H1Ex2xFtwwqqj8FPVFZPuFejPE86TnQShkt4nUaYUW85pXW6wHRFmVElHv57gw
	 N+GHTe3PhM/UcXtzhys1ouHvJGV1ptNDzDObepeX5t9j/FJaNr/NKu2DW62TKi7kie
	 L5KwaT3b4t01g==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 22:25:51 +0200
Message-Id: <DJMNZJZYZGAW.2VLN3VNNOH03L@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v2 7/7] pci: fix UAF when probe runs concurrent to dyn
 ID removal
Cc: "Bjorn Helgaas" <bhelgaas@google.com>, "Zhenzhong Duan"
 <zhenzhong.duan@gmail.com>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "Damien Le Moal" <dlemoal@kernel.org>, "Niklas Cassel" <cassel@kernel.org>,
 "GOTO Masanori" <gotom@debian.or.jp>, "YOKOTA Hiroshi"
 <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "Vaibhav Gupta" <vaibhavgupta40@gmail.com>,
 "Jens Taprogge" <jens.taprogge@taprogge.org>, "Ido Schimmel"
 <idosch@nvidia.com>, "Petr Machata" <petrm@nvidia.com>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, <linux-pci@vger.kernel.org>,
 <driver-core@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
 <industrypack-devel@lists.sourceforge.net>, <netdev@vger.kernel.org>,
 "Sashiko" <sashiko-bot@kernel.org>
To: "Gary Guo" <gary@garyguo.net>
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
 <20260630-pci_id_fix-v2-7-b834a98c0af2@garyguo.net>
In-Reply-To: <20260630-pci_id_fix-v2-7-b834a98c0af2@garyguo.net>

On Tue Jun 30, 2026 at 1:09 PM CEST, Gary Guo wrote:
> -static const struct pci_device_id *pci_match_device(struct pci_driver *d=
rv,
> -						    struct pci_dev *dev)
> +static bool pci_match_device(struct pci_driver *drv,
> +			     struct pci_dev *dev,
> +			     struct pci_device_id *id)
>  {
>  	struct pci_dynid *dynid;
>  	const struct pci_device_id *found_id =3D NULL;
> @@ -196,30 +198,33 @@ static const struct pci_device_id *pci_match_device=
(struct pci_driver *drv,
>  	/* When driver_override is set, only bind to the matching driver */
>  	ret =3D device_match_driver_override(&dev->dev, &drv->driver);
>  	if (ret =3D=3D 0)
> -		return NULL;
> +		return false;
> =20
>  	dev_id =3D pci_id_from_device(dev);
>  	/* Look at the dynamic ids first, before the static ones */
> -	spin_lock(&drv->dynids.lock);
> -	list_for_each_entry(dynid, &drv->dynids.list, node) {
> -		if (pci_match_one_id(&dynid->id, &dev_id)) {
> -			found_id =3D &dynid->id;
> -			break;
> +	{
> +		guard(spinlock)(&drv->dynids.lock);
> +		list_for_each_entry(dynid, &drv->dynids.list, node) {
> +			if (pci_match_one_id(&dynid->id, &dev_id)) {
> +				*id =3D dynid->id;
> +				return true;
> +			}
>  		}
>  	}

Should be scoped_guard(spinlock, &drv->dynids.lock). It also looks like dyn=
id
could be moved into the scoped_guard().
