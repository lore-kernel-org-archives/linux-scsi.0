Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A2843E9C3;
	Wed,  1 Jul 2026 11:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782904249; cv=none; b=X8MycqMsusfR1Y8a9Ics9K5eNGPvaRG/JrFzLUUGCb1k6ERrpK3D0WIUeFr/SE4dEDGsdYFYsfnrMGEzYkid7faoX/rg45JZYoB80DIRarFo99kdr8M4MZeSmZVdZ2ZkG3Wa201c1Fq83ehj68uFzv6nfWm3I2uvCGO98RRj2I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782904249; c=relaxed/simple;
	bh=A02OTwuJcFy6IZ6SvzDEM5JmH78Et4AQimvBgHEuDwk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rhsySt3ui+MjchZiBGKb3MNVE7czn71xNdyvN2GZrRJYKyptPpJJlkVeIr78fDefdE6BamCUa/W5UzNcU49aEh/B5IoNjVA/YaATmQNO3cBgR9AQKaeAx8aPoMATPDcUpK2raRWN2p+BvAuIVO7FO2J4kWy4GW+EuxboAs1B3DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cU5umbXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cU5umbXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74681F00A3D;
	Wed,  1 Jul 2026 11:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782904248;
	bh=A02OTwuJcFy6IZ6SvzDEM5JmH78Et4AQimvBgHEuDwk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cU5umbXTS2x34USIfXbfxqKudUuSe5Qs9oivgA8zXPFcfnTgHNRZ//RG00r2ql6rS
	 5KzHXklbr0YaFi1qQMT8IpN2GggWafR5meqfalFtJlf/vvQ/4F2dkYafTy+LmvOtby
	 vhm2gRo+dJYpzWP5iIHYj/v2O83/FMtr7jULY/KTeyayei8wcjrlY0+9Uyn1A+CT9y
	 ajpbBTLN0DagAD3l9rGw7s7GNFXh/BNfwD/8pcJ+5nK0coKxSalExUQKqCi02hd63x
	 uhsblcqSmSSG4h1kGAsZ4VWRTxILgQHzvLRT5zT+5WHqsVZv2kUfLQr8FF7ClnBW80
	 WhIAVfGuCoLcQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/7] pci: make pci_match_one_device match on ID
 instead of device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org, linux-pci@vger.kernel.org, cassel@kernel.org
In-Reply-To: <20260630-pci_id_fix-v2-5-b834a98c0af2@garyguo.net>
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
 <20260630-pci_id_fix-v2-5-b834a98c0af2@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 11:10:47 +0000
Message-Id: <20260701111047.C74681F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> There is a need to match just IDs instead of against devices. Thus rename
> this function to pci_match_one_id, and add a pci_id_from_device helper to
> make it easy to convert users.
>=20
> Similar convert pci_match_id to do_pci_match_id, however the existing API
> is kept due to quite a few users.
>=20
> Signed-off-by: Gary Guo <gary@garyguo.net>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630-pci_id_fix=
-v2-0-b834a98c0af2@garyguo.net?part=3D5

