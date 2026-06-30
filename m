Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EC7326D65;
	Tue, 30 Jun 2026 20:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782850589; cv=none; b=OG8pMT1pVHQ575ToIGfsgSMxsOU0Ejxmk9TDN1w14wom3PY3z9aBZCKmfE61iuazE0Fio+nB3Gev1wCfMiFw+M7YcMOpSORZA3ruotjJOvmKVcZnW0lAdAnkDwL0ONTnjz2Lr8Yy+qw3U+IumooNle9LlpEHkvgqxqhkxnwiwPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782850589; c=relaxed/simple;
	bh=fijCEL+ZCol4zwQKy1swij4Vs9reYyMa+XiDwC8T8cY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:From:Subject:
	 References:In-Reply-To; b=Dfii/7dRS53da+z+fRIfvHEl/09OfpFfB3u7jUkzkISrXa0c9+WRLa1nlXHKkJkOjw7VU/Qlk8B1ibno7I/onhz10oX+waYhabwUIjL+QmEx0Kkx9RzcD+acuzWQ+wAO1QF0W1QVfyjip33pedBV9IuqmruEMlosLUkrnXpc27A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oiAy+pYg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oiAy+pYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28241F000E9;
	Tue, 30 Jun 2026 20:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782850588;
	bh=Yiv0rscKmYbfa3JPkJvPHxwZQJrcYMfeu4v/Uuk4gTs=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To;
	b=oiAy+pYgiWtbABVQgDNJ9zh/RWJV4Dpiib0GLjYg7X4KM068jy5XYF8zpLtWAxBKK
	 iruoUfyzsqD3q/CtZey+yqbO67OddPNCLU0CrwjMWGHHzaxwAgBj1p83t6IITtfiy4
	 cjx9m0DPOC9vPoGaHyOCp5C5ENrGiU+WEIxYt21AqrEKK+N7ZcaCF7j6TUKAL1IvSw
	 nWzhrSSNM+mbr5VFmRN2jwhvM5+40nxMCP1OzLlm6vJZ8OEquLxaD1QLS3hyEbkzDx
	 ILlNLpxQz6DOrspMAR0o4fZrEb+7HhflqaktgtjxnC+za6658ckFpIhc7Ezq3LA3fL
	 G0XH8BE+nxTzg==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 22:16:21 +0200
Message-Id: <DJMNSA8JSD9Z.3JGVBN740JATW@kernel.org>
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
 <industrypack-devel@lists.sourceforge.net>, <netdev@vger.kernel.org>
To: "Gary Guo" <gary@garyguo.net>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v2 6/7] pci: fix dyn_id add TOCTOU
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
 <20260630-pci_id_fix-v2-6-b834a98c0af2@garyguo.net>
In-Reply-To: <20260630-pci_id_fix-v2-6-b834a98c0af2@garyguo.net>

On Tue Jun 30, 2026 at 1:09 PM CEST, Gary Guo wrote:
> +static int do_pci_add_dynid(struct pci_driver *drv, const struct pci_dev=
ice_id *id, bool check_dup)
> +{
> +	struct pci_dynid *dynid, *existing_dynid;
> +
> +	dynid =3D kzalloc_obj(*dynid);
> +	if (!dynid)
> +		return -ENOMEM;
> +
> +	dynid->id =3D *id;
> +
> +	{
> +		guard(spinlock)(&drv->dynids.lock);
> +		if (check_dup) {
> +			list_for_each_entry(existing_dynid, &drv->dynids.list, node) {
> +				if (pci_match_one_id(&existing_dynid->id, id)) {
> +					kfree(dynid);
> +					return -EEXIST;
> +				}
> +			}
> +		}
> +		list_add_tail(&dynid->node, &drv->dynids.list);
> +	}

This should use scoped_guard(spinlock, &drv->dynids.lock) instead.

>  static const struct pci_device_id *do_pci_match_id(const struct pci_devi=
ce_id *ids,
> -						   const struct pci_device_id *dev_id)
> +						   const struct pci_device_id *dev_id,
> +						   bool match_override_only)

Maybe something along the lines of include_override_only? At a quick glance
match_override_only could be read as "match override-only entries exclusive=
ly".
