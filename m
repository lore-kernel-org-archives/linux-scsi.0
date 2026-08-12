Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49488481FD6
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559050; cv=none; b=DmW2BztntFQtH8B99MK13GZmjsTufTyuvaztHjE8diIE3Gn2CylC0lbis6HiEY7Vma9SL5aRJAFSCJXWO3Sy8uuCIg4W/gtbD3nFJ1E5WxKujBf46uYbJQKr3mQZJ+EoqwXywmpo0p7OTghPvr76QdCfpIqfJwS6JR8rZTJhAmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559050; c=relaxed/simple;
	bh=wEEZk7gR5PRrRc18U/cMVXH8ut5uOoLwZS95IFxoZ6Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=n6luBqlCjKeUvRzrvIfx8KR8E09n0pCyt4tzSy1X0dq5FjMBohY7t5Rm+gfxo/K86wpiu0tZxOGCO7GYUcuKdwgSVNdn3ypBtNZ/2gBZKHLO7j1w5T+sZ4OvdtICTHvWpKIxD/bGh3cYa4rQkx7UASdKtON1aaH/Vol/xY9PyEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2TaxCwG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2TaxCwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6871F000E9;
	Wed, 12 Aug 2026 18:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786559049;
	bh=u2wnSAzaJIe8aXD7HjF1//W+s+0DhcZn4rw/WHJKgMs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P2TaxCwGc9VH0VyWFIvf57CWi790ggDaZ8263CohLOG++XrjrnUh3vFRR1UdjeupK
	 JOp7o1xQolL3ka3DaLweAjY8jfn9YEk6vQICsX7eW5zXf2SGqCybtX2+DVIiAN4JHy
	 jHJrxvjHYpDWds4XHcoO488Kys6CrELGFru0D/3wNkYxmgfmHIeUuuvx4748nJhNu4
	 Ub6f/4GfRerI6lREJJxhcptd9sqyHmXDog/xBQZg+HqgJFzVMt8Bfww7e1mhm1/g8Y
	 CdzOfM2hfrxedgpXhjcJ9FSHrGeG1BXbJiN/3gbNfZsZDLb/REUNE3aoUlSufj4iya
	 CdJYDRcjajvig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/13] scsi: scsi_transport_fc: user support for
 clearing NVME_CTRL_MARGINAL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812181300.3712426-9-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
 <20260812181300.3712426-9-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:24:08 +0000
Message-Id: <20260812182408.DB6871F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] A TOCTOU / race condition in `fc_rport_set_marginal_state` allows =
the software remote port state (`rport->port_state`) to become permanently =
desynchronized from the low-level driver's hardware state.
- [Medium] Meaningful mismatch between the commit message and the implement=
ed code regarding the callback function used.
--

--- Patch [8]: [PATCH 08/13] scsi: scsi_transport_fc: user support for clea=
ring NVME_CTRL_MARGINAL ---
commit 22fbcc98c1f2a6b4c603d5765d66e355a3468638
Author: John Meneghini <jmeneghi@redhat.com>

scsi: scsi_transport_fc: user support for clearing NVME_CTRL_MARGINAL

This commit refactors fc_rport_set_marginal_state to hold the host_lock
around port_state accesses. It also introduces a callback mechanism to
propagate the marginal state changes to the low-level driver when modified
via sysfs.

> Call nvme_fc_modify_rport_fpin_state() when FC_PORTSTATE_MARGINAL is set
> or cleared.  This allows the user to quickly set or clear the
> NVME_CTRL_MARGINAL state from sysfs.

[Severity: Medium]
Does the commit message match the implemented code?

The message explicitly states that nvme_fc_modify_rport_fpin_state() is
called, but the code relies on the generic transport template callback
set_rport_marginal() instead.

> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transpo=
rt_fc.c
> index df1edf3c23fa8..af309a7bdc221 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
[ ... ]
> @@ -1251,34 +1251,58 @@ static ssize_t fc_rport_set_marginal_state(struct=
 device *dev,
[ ... ]
> +	spin_lock_irqsave(shost->host_lock, flags);
> +
> +	switch (port_state) {
> +	case FC_PORTSTATE_MARGINAL:
>  		/*
>  		 * Change the state to Marginal only if the
>  		 * current rport state is Online
>  		 * Allow only Online->Marginal
>  		 */
> -		if (rport->port_state =3D=3D FC_PORTSTATE_ONLINE)
> +		if (rport->port_state =3D=3D FC_PORTSTATE_ONLINE) {
>  			rport->port_state =3D port_state;
> -		else if (port_state !=3D rport->port_state)
> -			return -EINVAL;
> -	} else if (port_state =3D=3D FC_PORTSTATE_ONLINE) {
> +			spin_unlock_irqrestore(shost->host_lock, flags);
> +			if (i->f->set_rport_marginal)
> +				i->f->set_rport_marginal(rport, true);
> +			return count;

[Severity: High]
Could this sequence introduce a regression where the transport layer state
becomes permanently desynchronized from the hardware state?

By dropping the host_lock before calling set_rport_marginal(), a race window
is opened. If one thread sets the state to FC_PORTSTATE_MARGINAL and drops
the lock, and another thread concurrently sets the state to
FC_PORTSTATE_ONLINE, drops the lock, and executes set_rport_marginal() with
false, the first thread might then execute its callback with true. The
transport software state would be online, but the hardware state would be l=
eft
in a marginal state.

> +		}
> +		break;
> +
> +	case FC_PORTSTATE_ONLINE:
>  		/*
>  		 * Change the state to Online only if the
>  		 * current rport state is Marginal
>  		 * Allow only Marginal->Online
>  		 */
> -		if (rport->port_state =3D=3D FC_PORTSTATE_MARGINAL)
> +		if (rport->port_state =3D=3D FC_PORTSTATE_MARGINAL) {
>  			rport->port_state =3D port_state;
> -		else if (port_state !=3D rport->port_state)
> -			return -EINVAL;
> -	} else
> +			spin_unlock_irqrestore(shost->host_lock, flags);
> +			if (i->f->set_rport_marginal)
> +				i->f->set_rport_marginal(rport, false);
> +			return count;

[Severity: High]
Is this code also vulnerable to the same regression? Dropping the lock prior
to executing set_rport_marginal() permits concurrent sysfs writes to reorder
the callback executions, which can lead to a state mismatch.

> +		}
> +		break;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.3712=
426-1-jtaubepe@redhat.com?part=3D8
