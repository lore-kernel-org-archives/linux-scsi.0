Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97329481FCE
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559286; cv=none; b=A1ROmxxb1cFdx1g0TKW/bNh6/MCo8QoLNYQRA4FADU4v29B5g2CuhnGlOF8cOm1/DAKmL3h7MNbSNiy5HJzLr4cR0bktN8BGYTurl8eAsyZnI65OFap78IYnZCWPYaIVztk/fivTqILgQyxo3MXqGF67JWXvwQlNPVvbjsaopU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559286; c=relaxed/simple;
	bh=rBFq51cIx/3RlA3pbjel+LImtcM2Regmh3vWEZ9fJBc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L5e2VYtHhuD9dIx6P9clqCC63HefrAAr57zibkAy3RuG0FeFQoR373jzH+zR1Vc8L9Jg0SQ5nW1rIfhazuJWDA2/OOHBvFDEWCUtfdBVihErh0qPI5rn2l/LDbtC9uJfYJ+fn6Fa757HlCcVDsDAzX1zq8lc4aiRd76xqL0RKQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dc5FeR6Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dc5FeR6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCB01F000E9;
	Wed, 12 Aug 2026 18:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786559284;
	bh=RSj4/qJ1f8NLvxcjZgwrQzsjWQCbJkdXcUdyQgSsnlw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dc5FeR6Q1yXkkB+iesk/VU2eAh0HmsS+uvoZIvnJzC2U6rKWfix2sO+hxPvVube8E
	 L0D7M7hQrm3vY47aOTnx/HTlaexSaPt6GLXCJTWC47RHBTjq0wyndWMCeJjlNYpn8m
	 FCbA3f0MGCj5Dau3Eco6efBJViODcyA6dOdTK0LK70jRpaHStmnckp1Rgy7iF9YEim
	 rqhPcnwCG4VcPIHSQuUYMDrvXfbZxXIGSZQYk2yhkS+mB3f7yqI6Btjcf8YHWiDeLe
	 4b90a1G3tPslzgr0MjPxinJfS2bxNtarRONpGVt/WaGVPabw06Q46rb6/hJylNsfv1
	 QPvz0gR/GPH1w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/13] scsi: scsi_transport_fc: Add set_rport_marginal
 to fc_function_template
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812181300.3712426-8-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
 <20260812181300.3712426-8-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:28:03 +0000
Message-Id: <20260812182803.EDCB01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] The primary affected port (`attach_rport`) in a Link Integrity eve=
nt is excluded from being marked as marginal.
- [High] NVMe targets are erroneously placed into the 'marginal' state duri=
ng Peer Congestion (PC) events.
- [High] The `set_rport_marginal` callback is not invoked when the marginal=
 state is manually cleared or set via sysfs.

Pre-existing issues:
- [Critical] The `fc_rport` pointer returned by `fc_find_rport_by_wwpn` is =
used without a reference count, leading to a Use-After-Free.
- [Critical] Integer underflow in `fc_host_fpin_rcv` when `fpin_len` is sma=
ll, leading to massive OOB read.
--

--- Patch [7]: [PATCH 07/13] scsi: scsi_transport_fc: Add set_rport_margina=
l to fc_function_template ---
commit 978d2e847b2a738287194acf215a8cbbe297f65a
Author: Jesse Taube <jtaubepe@redhat.com>

scsi: scsi_transport_fc: Add set_rport_marginal to fc_function_template

Add fc_fpin_set_marginal function to evaluate the FPIN LI TLV
information and set the 'marginal' path status for all
affected nvme rports. Then call set_rport_marginal() callback added
to fc_function_template.

The implementation of set_rport_marginal() is almost identical to
set_rport_dev_loss_tmo implementation.

> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transpo=
rt_fc.c
> index 02c58f4591d83..df1edf3c23fa8 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -737,6 +737,25 @@ fc_cn_stats_update(u16 event_type, struct fc_fpin_st=
ats *stats)
>  	}
>  }
> =20
> +static void fc_fpin_set_marginal(struct Scsi_Host *shost, struct fc_rpor=
t *rport)
> +{
> +	struct fc_internal *i =3D to_fc_internal(shost->transportt);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +
> +	if (rport->port_state =3D=3D FC_PORTSTATE_ONLINE &&
> +	    rport->roles & FC_PORT_ROLE_NVME_TARGET) {
> +		rport->port_state =3D FC_PORTSTATE_MARGINAL;
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		if (i->f->set_rport_marginal)
> +			i->f->set_rport_marginal(rport, true);

[Severity: Critical]
This is a pre-existing issue, but does passing this rport pointer out to the
driver callback outside of the lock risk a use-after-free?

The rport pointer passed into fc_fpin_set_marginal() is retrieved by
fc_find_rport_by_wwpn(). Looking at fc_find_rport_by_wwpn(), it returns the
pointer without incrementing its reference count (e.g., via get_device()).

If a concurrent fc_remote_port_delete() runs, the rport memory could be
freed as soon as the internal list lock is dropped. When the host_lock is
dropped here, the unreferenced rport pointer is then passed to
set_rport_marginal(), potentially dereferencing freed memory.

> +		return;
> +	}
> +
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +}
> +
>  static void
>  fc_fpin_pname_stats_update(struct Scsi_Host *shost,
>  			   struct fc_rport *attach_rport, u16 event_type,
> @@ -764,6 +783,7 @@ fc_fpin_pname_stats_update(struct Scsi_Host *shost,
>  			if (rport =3D=3D attach_rport)
>  				continue;
>  			stats_update(event_type, &rport->fpin_stats);
> +			fc_fpin_set_marginal(shost, rport);

[Severity: High]
Does this continue statement unintentionally bypass the newly added
fc_fpin_set_marginal() call for the primary attach_rport?

When a Link Integrity FPIN is processed via fc_fpin_li_stats_update(), it
locates the attach_rport and passes it to fc_fpin_pname_stats_update().
Because of this continue, the primary port experiencing the Link Integrity
failure won't be transitioned to the marginal state.

[Severity: High]
Will this also place NVMe targets into the marginal state during Peer
Congestion (PC) events?

fc_fpin_peer_congn_stats_update() processes Peer Congestion events by
calling fc_fpin_pname_stats_update(). Since fc_fpin_set_marginal() is now
called unconditionally here, it seems ports involved in transient congestion
events might be incorrectly marked as marginal, potentially causing
unwarranted path failovers.

>  		}
>  	}
>  }
> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transpo=
rt_fc.h
> index 9f30625aa0d30..bc7c3f8323992 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -684,6 +684,7 @@ struct fc_host_attrs {
>  struct fc_function_template {
>  	void    (*get_rport_dev_loss_tmo)(struct fc_rport *);
>  	void	(*set_rport_dev_loss_tmo)(struct fc_rport *, u32);
> +	void	(*set_rport_marginal)(struct fc_rport *rport, bool marginal);

[Severity: High]
Should this callback also be invoked when the marginal state is manually
cleared or set via sysfs?

When a user writes 'Online' to the port_state sysfs attribute, it calls
fc_rport_set_marginal_state() which modifies rport->port_state, but it does
not call this new set_rport_marginal() callback.

Will this leave the Low-Level Device Driver (LLDD) permanently out of sync
with the transport class state when a path is recovered manually?

> =20
>  	void	(*get_starget_node_name)(struct scsi_target *);
>  	void	(*get_starget_port_name)(struct scsi_target *);

[Severity: Critical]
This is a pre-existing issue, but is there an integer underflow in
fc_host_fpin_rcv() when fpin_len is small?

In fc_host_fpin_rcv(), bytes_remain is calculated without validating that
fpin_len is large enough:

    bytes_remain =3D fpin_len - offsetof(struct fc_els_fpin, fpin_desc);
    bytes_remain =3D min_t(u32, bytes_remain, be32_to_cpu(fpin->desc_len));

Since offsetof(struct fc_els_fpin, fpin_desc) is 8, if an FPIN payload is
received with fpin_len < 8, the subtraction underflows to a massive u32
value. The parsing loop will then read well past the end of fpin_buf,
causing an out-of-bounds read.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.3712=
426-1-jtaubepe@redhat.com?part=3D7
