Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2E53CB2FD
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 23:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791503946; cv=none; b=Y/q8YEaMBnxKx10yNbcpBKBhZWkNOMZgSvWwjsiD51R/+sGp/nQ0kyAyLG31P7Hz9uKzKz70WKIdVVZhG7Wav0A9gF3O3m8w91feV50i0mfkGMybJ0k0lfM5uK62Uiim6cgXXmXWlkj0RE74BEYGukCUR6frFGsM+Bv5bAFYVeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791503946; c=relaxed/simple;
	bh=CwOY/ilH6/PBsDIiONCrMpm+Js3VgSAoxqzmANFC4f0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=rIixYusM/ZxBWV0trwCOZgamoMxGzjsyP7A2BMuEVl0h8Zq58EiDLdSLWsVoPGjtPqzHApN3zu3099+xkIp5snfA9Vsdz+mQTOUmHpT4bVkrG6FA6mvHncmGBzrGvd+qvabZr0P3yyyKD2LWoQwV6v1e0AO8o8MA//DyIHExnvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdAME+fw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdAME+fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931091F000FF;
	Thu,  8 Oct 2026 23:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791503944;
	bh=cEsYhdXfrB+AZUDKFjcE+fEKOyBn7b2LWMjv12O6ZWs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XdAME+fweKojyNcRZaGM7SwWCAQvh+iU4YTZ7uc4U3mOOYD3/ADXYP3pZFp4kJ+0y
	 CrZR16BPnCxHuxKVQGsqo5MNoEoeRn4CuD0g2KWtnF1sePjcGMOvMatvTNHbJsnPqw
	 gSjGSlf86bbXa4WDeWpd7v6cz8aT4VGs9b8MXh8dTc6ak+eT0a2jL2RDAZoMHC3g28
	 nZIvP78B1H1SLOwzsd7Cx2o6Ozk30TT2oAWtYUwOSQWzJz0MCGx8liIbkUCspbqFN1
	 YyJwQ9UT1vyb6D4k2d5KnZ8UScW29FK3im1rINiatXME3/tjnryDFqu4d3lAK4Mvl2
	 dXp1/DiRvvvig==
Message-ID: <sashiko-outbox-164665@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Rework BUILD_BUG_ON() assertion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Finn Thain" <fthain@linux-m68k.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <4808a5dc1a71528ffa3360868561009744277450.1791502886.git.fthain@linux-m68k.org>
References: <4808a5dc1a71528ffa3360868561009744277450.1791502886.git.fthain@linux-m68k.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 23:59:03 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: qla2xxx: FORTIFY_SOURCE field-spanning write warning in qlt_=
queue_unknown_atio
- [High] scsi: qla2xxx: UBSAN/FORTIFY overflow in add_cdb array accesses
--

commit 4d96d5f0f41af34ce19bfbd80ce5e059ab28cd98
Author: Finn Thain <fthain@linux-m68k.org>

scsi: qla2xxx: Rework BUILD_BUG_ON() assertion

The LKP bot reported a build failure with CONFIG_COLDFIRE=3Dy together with
CONFIG_SCSI_QLA_FC=3Dy. The failure is caused by an incorrect BUILD_BUG_ON()
assertion in qlt_queue_unknown_atio(). To resolve this, a flex array is
placed at the end of struct qla_tgt_sess_op.

Closes: https://lore.kernel.org/oe-kbuild-all/202603030747.VX0v4otS-lkp@int=
el.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202609301230.CauIUXCF-lkp@int=
el.com/

> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla=
_target.h
> index 71bc1affb1bc9..b27bd3aecbf8e 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -309,7 +309,8 @@ struct atio7_fcp_cmnd {
>  	/*
>  	 * add_cdb is optional and can absent from struct atio7_fcp_cmnd. Size 4
>  	 * only to make sizeof(struct atio7_fcp_cmnd) be as expected by
> -	 * BUILD_BUG_ON in qlt_init().
> +	 * BUILD_BUG_ON in tcm_qla2xxx_init(). See also, BUILD_BUG_ON in
> +	 * qlt_queue_unknown_atio().
>  	 */
>  	uint8_t  add_cdb[4];

[Severity: High]
Since add_cdb is explicitly declared as a fixed-size 4-byte array here, does
the current code cause UBSAN array bounds violations and FORTIFY_SOURCE read
overflow panics when accessing elements beyond these bounds?

For instance, in memcpy_atio() when len > 0, it accesses
&src->u.isp24.fcp_cmnd.add_cdb[len * 4] which is out-of-bounds, and reading
4 bytes triggers the overflow panic:

drivers/scsi/qla2xxx/qla_target.c:memcpy_atio() {
...
    memcpy(&dst->u.isp24.fcp_cmnd.add_cdb[0],
           &src->u.isp24.fcp_cmnd.add_cdb[len * 4],
           4);
...
}

Similarly, get_datalen_for_atio() accesses the array out-of-bounds when
len > 0:

drivers/scsi/qla2xxx/qla_target.h:get_datalen_for_atio() {
...
    return get_unaligned_be32(&atio->u.isp24.fcp_cmnd.add_cdb[len * 4]);
...
}

[ ... ]

> @@ -845,7 +846,11 @@ struct qla_tgt_sess_op {
>  	struct rsp_que *rsp;
> =20
>  	struct atio_from_isp atio;
> -	/* DO NOT ADD ANYTHING ELSE HERE - atio must be last member */
> +	/*
> +	 * DO NOT ADD ANYTHING ELSE HERE.
> +	 * atio.u.isp24.fcp_cmnd.add_cdb may extend past end of atio.
> +	 */
> +	uint8_t atio_u_isp24_fcp_cmnd_add_cdb[];
>  };

[Severity: High]
Since this patch introduces the flexible array atio_u_isp24_fcp_cmnd_add_cd=
b[]
to legally hold the trailing data, shouldn't the memcpy() in
qlt_queue_unknown_atio() be updated to target it?

drivers/scsi/qla2xxx/qla_target.c:qlt_queue_unknown_atio() {
...
    u =3D kzalloc(sizeof(*u) + add_cdb_len, GFP_ATOMIC);
    ...
    memcpy(&u->atio, atio, sizeof(*atio) + add_cdb_len);
...
}

Because the destination is typed strictly as &u->atio, copying more than
64 bytes (sizeof(*atio)) when add_cdb_len > 0 causes a FORTIFY_SOURCE
intra-object write overflow panic.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/4808a5dc1a71528ffa3=
360868561009744277450.1791502886.git.fthain@linux-m68k.org?part=3D1
