Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDA44A8A29
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 10:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542157; cv=none; b=BmE+5GB0ILxRkeWnQS4CTCquJ04x8i149gVuoF3Bb5WDf572hT/CnsuHXhbpFr6repzcBCGckG9LLIBmYIoWJyX0pc2XkfBkwrppuLk3lshIW96Vnfpfl54bTOaw4PgE9dKLYa5Vvzrc7ki9CQDT6Ktq/s2SbxUpFKKWjJkPcEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542157; c=relaxed/simple;
	bh=8UCRJiFep37xxvf0r98EaXYhL7ASzurY3AaH8lAz3j4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mDQR11YW6bAn2WhWUvnZ42vHFHGAhb8nE5emBLqONzzIyiOx8jxqQYigqTbXelfu0gTujgefFr0QT+XE26/72Fz18+4HkE9buolWd8eO/pyNGFjl3cAz3mMiNhDXO8pErU7wLwp0mMdy+WGlqSR8R7ldn1ET3GD6aCPHsNkcIXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aCzFR94u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aCzFR94u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FB51F000FF;
	Fri,  9 Oct 2026 10:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791542153;
	bh=55LLshHD9K45DgdEdFrc6H0EyB1p20+HlJhzU83KB4Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aCzFR94u6SAnNS7oZmSwYcpbNKWuXXzTR7gDadV7v3gvCxqaWBwNQX2AE26m8ZvMD
	 PCXZ9x99DbchKvZyqXNy8aUTPJ3oXnV4aBHJWoL3r8yOHK8ILk+jaZXRHk4Iki7Pzf
	 ag5H5GF/Dfwo1NHmgcwKE31HdLYZzxES3H8Lfo6HS3jVHE9njZYnNB3O73lGhu2JPW
	 qoimoAX/AcPY+oiAKRUsLNLzqLumfUAw0C1+0kXJZguDDQuzHvMcHtDbExPN8dDLeC
	 wWi0UIf/bu+ue5rPlLD5uwazd/o7UtSeaWmqpfbJJJjbQtHcO6TQPWy7SlGQ9JMj1D
	 a0V6YteH6VxzA==
Message-ID: <sashiko-outbox-165239@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] scsi: leapraid: check set_identify result in
 update_links
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shirong Zhao" <shxzhaosr@163.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261009102313.18-4-shxzhaosr@163.com>
References: <20261009102313.18-1-shxzhaosr@163.com>
 <20261009102313.18-4-shxzhaosr@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 10:35:52 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi: leapraid: UAF on card_phy after dropping topo_node_lock
- [High] scsi: leapraid: out-of-bounds array access via unvalidated phy_ind=
ex
- [High] scsi: leapraid: lockless traversal of card_port_list causes UAF
--

commit 4abc139d948d5c745212e888718ff5b93bc978e0
Author: Shirong Zhao <shxzhaosr@163.com>

scsi: leapraid: check set_identify result in update_links

leapraid_transport_update_links() ignores the return value of
leapraid_transport_set_identify(), which leaves the identify struct
untouched on FW query failure. Fold the call into the if condition so a
failed query takes the existing zeroing else path instead of attaching
with stale data.

> diff --git a/drivers/scsi/leapraid/leapraid_transport.c b/drivers/scsi/le=
apraid/leapraid_transport.c
> index 77ffbd6ddce4c..38e63327d89a1 100644
> --- a/drivers/scsi/leapraid/leapraid_transport.c
> +++ b/drivers/scsi/leapraid/leapraid_transport.c
> @@ -1150,9 +1150,9 @@ void leapraid_transport_update_links(
>  	card_phy->attached_hdl =3D hdl;

[Severity: High]
Does this code overflow the topo_node->card_phy array in
leapraid_transport_update_links() in drivers/scsi/leapraid/leapraid_transpo=
rt.c?

Callers like leapraid_sas_pd_add() and leapraid_scan_sas_dev_after_reset()
pass the hardware-provided sas_dev_p0.phy_num directly as phy_index without
validating it against topo_node->phys_num. A malicious or malfunctioning
HBA returning an unexpectedly large phy_num could cause an out-of-bounds
write on card_phy->attached_hdl here.

>  	spin_unlock_irqrestore(&adapter->dev_topo.topo_node_lock, flags);
> =20
> -	if (hdl && link_rate >=3D LEAPRAID_SAS_NEG_LINK_RATE_1_5) {
> -		leapraid_transport_set_identify(adapter, hdl,
> -						&card_phy->remote_identify);
> +	if (hdl && link_rate >=3D LEAPRAID_SAS_NEG_LINK_RATE_1_5 &&
> +	    !leapraid_transport_set_identify(adapter, hdl,
> +					     &card_phy->remote_identify)) {

[Severity: High]
Can this dereference a freed card_phy pointer?

By dropping adapter->dev_topo.topo_node_lock before calling the
blocking hardware query leapraid_transport_set_identify(), the safe lifetime
of topo_node and card_phy ends.

Concurrently, teardown paths like leapraid_exp_rm() can acquire the
topo_node_lock, remove the node, drop the lock, and call kfree() on both
topo_node_exp->card_phy and topo_node_exp. When leapraid_transport_set_iden=
tify()
executes, it would write to the freed card_phy->remote_identify.

>  		if (topo_node->hdl <=3D adapter->dev_topo.card.phys_num &&
>  		    adapter->adapter_attr.enable_mp) {
>  			list_for_each_entry(card_port,

[Severity: High]
Is it safe to iterate adapter->dev_topo.card_port_list without holding
the topo_node_lock?

Since the lock was dropped earlier in this function, this list is traversed
locklessly. Concurrently, leapraid_cleanup_card_port_and_vphys() can be
called (e.g. from leapraid_transport_port_remove()), which removes and
calls kfree() on elements from this same list, potentially causing a
use-after-free in this iterator.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009102313.18-1=
-shxzhaosr@163.com?part=3D3
