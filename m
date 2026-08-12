Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0782B1DA62E
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559689; cv=none; b=KMYIIWCmwm6LsBEjXx+f+4cf3t2+4ij8/KKOOrtcSripafQyzurnDaINrYBv0BbM6mld3E5hD+7Xm0+LVjLGcLqVWA+PVUqYMA7GaHX4odLR4VQMxpPGvWO3Jm6sROaOEAscC9wbQ5pqfkRP5m59fVOVz7drmrB4Cw7k30K2pAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559689; c=relaxed/simple;
	bh=lY/pf/RkQpvgAGzwi+SpJwTnbN+Pb2zxbpEsqMEmwIw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l4PBf/0v4+vkwB20Nw63lxJahT3o5Swl1RMougMREuv/r/0UGfqCR1bxTUm/iImDlCxH97nHUxLtkfsWpClSBh5sdEao6iPBzXT7kVa3fgFTORhJhNrmYfqpnx5N0EPGbD8+Jtn+XgiCApFeZQAvSt/pK7Zq3rOJIt6HNcGOc7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0E1W6X0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0E1W6X0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D111F000E9;
	Wed, 12 Aug 2026 18:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786559687;
	bh=ULvms59wwuoKALwu5VjzTpNew/xrRb+iiqud8N0fy9k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X0E1W6X0uuey6V9hj5bNvLBn2BdDcmt0GqBBZExJWvnQrFQNn8nsflgCYi9Y/j+Fn
	 LeNeHWPu8r1Nt+FZ2f2rW0D9QmfHQ+ePdTcgDyl0d85U2w42YrVmeeZyffq4AI7kPL
	 sNm87TVvIbyqrrb0fFC9lRRwccd4EcvzHG4B5mnIxxUGAPyAPGZqT1GbmDJJ5Jghrr
	 ztaAqL4fx53Ald79X/x1KayYMn3aD47FawEPwmf+vbokNsNKQA8GPjjU6Gh3iZ80FI
	 RlV0494HwmosGROgG7Jclsn8ZDk9SqtzRLbADPOBa7uCU25/FNZB6fAgDV5vQmcq3p
	 I4nnx2UG63tCg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/13] scsi: qla2xxx: enable FPIN notification for NVMe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812181300.3712426-11-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
 <20260812181300.3712426-11-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:34:46 +0000
Message-Id: <20260812183447.69D111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Lockless access to `fcport->nvme_remote_port` in `qla2x00_set_rpor=
t_marginal()` introduces TOCTOU Use-After-Free and NULL pointer dereference=
s.
--

--- Patch [10]: [PATCH 10/13] scsi: qla2xxx: enable FPIN notification for N=
VMe ---
commit 1b0bf8a2abd4965d07b3b9fd652b0926356c721b
Author: Jesse Taube <jtaubepe@redhat.com>

scsi: qla2xxx: enable FPIN notification for NVMe

Implement set_rport_marginal callback using nvme_fc_set_remoteport_fpin()
to enable FPIN notifications for NVMe.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index a4ca22024edeb..92db7d584eeb8 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -2789,6 +2789,15 @@ qla2x00_set_rport_loss_tmo(struct fc_rport *rport,=
 uint32_t timeout)
>  					       rport->dev_loss_tmo);
>  }
> =20
> +static inline void
> +qla2x00_set_rport_marginal(struct fc_rport *rport, bool marginal)
> +{
> +	fc_port_t *fcport =3D *(fc_port_t **)rport->dd_data;
> +
> +	if (IS_ENABLED(CONFIG_NVME_FC) && fcport && fcport->nvme_remote_port)
> +		nvme_fc_set_remoteport_fpin(fcport->nvme_remote_port, marginal);

[Severity: High]
Does this code introduce a Time-Of-Check to Time-Of-Use (TOCTOU) race condi=
tion?

The nvme_remote_port pointer is read and dereferenced locklessly here. If a
device loss event triggers qla_nvme_remoteport_delete() concurrently, it se=
ts
fcport->nvme_remote_port =3D NULL and allows the NVMe FC transport to free =
the
remote port memory.

If qla2x00_set_rport_marginal() checks that nvme_remote_port is non-NULL but
is preempted before calling nvme_fc_set_remoteport_fpin(), it will pass a s=
tale
pointer to freed memory, causing a use-after-free.

Alternatively, because the pointer is fetched without READ_ONCE(), the comp=
iler
could reload the now-NULL pointer from memory, leading to a NULL pointer
dereference inside nvme_fc_set_remoteport_fpin().

This pre-existing vulnerability is also present in qla2x00_set_rport_loss_t=
mo()
just above this new function.

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.3712=
426-1-jtaubepe@redhat.com?part=3D10
