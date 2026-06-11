Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6453BA23A
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 08:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168216; cv=none; b=limCRUNNJ7o99IZOSnYxYDCP5VPev9ZlxXBLpcq9rruzF+r/xpZu/KwusbStibq/2W6/YOOQ0ZpFVu6dyQwg0V4qUN85wP3wgykcS8WYkQg82mZR8lB5jmW9VGENA6VOkfL0QlAJQIJFtK55fjbTWrsIh2Q/trbZBDPHM+7zWOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168216; c=relaxed/simple;
	bh=stFawW3M50GltD7pg9Q8opE+0zEsogaqnEsZwyUSCRk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FWvni+FiPC5i/oj9m7AiLoJ9QCOqHD3xldSZsz7pHnZzDsLXvWUrhIVG3NYXVRWC0Njc7yTKsrdDJDLXkhwrQaQtPl2l4/u/CapmwrUZn3d5FkDMGq/xWP7DrSWN2klqYDLnzUWq0nY44mXae5UZDSopjFrz8fqP47GKJ9HqA9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ck4hjhX7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ck4hjhX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3D21F00893;
	Thu, 11 Jun 2026 08:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781168214;
	bh=QzonXp1HbM20IrYcp6qp2qJXF3BTsES+YvMjk1wNCZk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ck4hjhX7y7Jr2OpDzDbv5LscKoLdsMYxfPQ+IACiSSct6rKt+mZ63ueCL9x8XWU6b
	 CUEsA8YcDDOdlR2cWV4UidR0rCssGObMkd9f7/hgP9Bi2o3jZz9WjNqG0G667+FOf+
	 nT6O7eE8HlsgFcDK3um3luBA3XKGC3u/z+gaYA7RkyJD2H1vqevkGHKxLC5aC2J58l
	 o6noTCog8G6Sqtpjw5ECtVMN66Qd0ZnfzTyVUNKi3PwxhBCdkrPkicQfJWG93uU3ei
	 3bOdnf5frs8plxC+QIHBmvdvBZvMdH93jeke1DZrGMnka4LSgzsEIZCsZc5aGJeMwW
	 iqK5NpLOyNIjQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: fix refcount leak in
 mpt3sas_transport_port_add()
Reply-To: sashiko-reviews@lists.linux.dev
To: "WenTao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260611084324.70303-1-vulab@iscas.ac.cn>
References: <20260611084324.70303-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 08:56:54 +0000
Message-Id: <20260611085654.AD3D21F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `phy_belongs_to_port` flag is left set to 1 on PHY objects if =
the port addition fails midway, permanently orphaning the phys.
- [Medium] The allocated `struct sas_port` object is leaked if `sas_port_ad=
d()` fails.
--

commit 9f7a04ec16ac25a146b4b86266e9c7e403ae4717
Author: WenTao Liang <vulab@iscas.ac.cn>

scsi: mpt3sas: fix refcount leak in mpt3sas_transport_port_add()

In mpt3sas_transport_port_add(), after acquiring the sas_device by
calling mpt3sas_get_sdev_by_addr(), several error paths leak the reference.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3=
sas/mpt3sas_transport.c
> index e74a526efa8db..f831d48235031 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> @@ -869,6 +869,8 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *io=
c, u16 handle,
>  	list_for_each_entry_safe(mpt3sas_phy, next, &mpt3sas_port->phy_list,
>  	    port_siblings)
>  		list_del(&mpt3sas_phy->port_siblings);

[Severity: Medium]
This is a pre-existing issue, but does this error path leak the sas_port
object?=20

If sas_port_add(port) fails earlier in mpt3sas_transport_port_add(), the co=
de
jumps here to the out_fail label. It looks like sas_port_free(port) needs
to be called to release the un-added object and its underlying device, but
it appears to be missing from this cleanup block.

[Severity: High]
This is a pre-existing issue, but is the phy_belongs_to_port flag left in
an incorrect state on failure?

Earlier in mpt3sas_transport_port_add(), the phys are added to the port:

    sas_port_add_phy(port, mpt3sas_phy->phy);
    mpt3sas_phy->phy_belongs_to_port =3D 1;

If a subsequent operation like sas_rphy_add() fails, the code falls through=
 to
this block. The phys are removed from mpt3sas_port->phy_list via list_del(),
but the phy_belongs_to_port flag remains set to 1.

Since these phys reside in the persistent sas_node->phy[] array, will they
be permanently ignored during future discovery or port addition attempts
because the flag was not reverted to 0?

> +	if (sas_device)
> +		sas_device_put(sas_device);
>  	kfree(mpt3sas_port);
>  	return NULL;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611084324.7030=
3-1-vulab@iscas.ac.cn?part=3D1
