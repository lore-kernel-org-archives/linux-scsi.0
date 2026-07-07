Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A6E3AA19B
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783406763; cv=none; b=ZeZZg4BeA8eqbCGUx0U+stpJvl2zYFAdjlbLfOqFYWl/uE+H7VCpkackzX7xpwzHHfw4utTvDsgrKoS8uksw2ObJB+VB51gOketWktiJLalz6w0DfU9DkKv7sinLuv28QjoOpUE/rv61KZ3z2MnRuBvFX2cpR923MrPWl+DIeJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783406763; c=relaxed/simple;
	bh=+TxeyI5puhY4IRc3TNoQLjRPrq8EAMpWRfbCEy0kbQA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pS4sAO97JyDwYp+ihI+40VFOL+E71SGDnyHfs0WkBPpBpec3100U3HO5K603uWNcADL1aCcnCOIXDu7G52sTXjETm/7NUU9gnQKvo5M/volZ2z+nTSQ13nj2OSml+7o7Z1vv/KYgS64PRLLdIVaP33lL6Qw6mVEsCtnW2a5lVEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lTvEKmGI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lTvEKmGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62141F000E9;
	Tue,  7 Jul 2026 06:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783406762;
	bh=N+NH4pjK0K1DUUF0OwZfnwvxTn920ZyX6z0uciXPm+8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lTvEKmGIOSB+eXyvuZcd8TKlja2eWaFbtDgkh1aJXFhJfgx2+ASOY6BFaki/7cpwv
	 vGCNND7MqcFFCn4/6RS5A7UFouzTdDG+QXdXCVlZq2TdlVYuoXOedP84vvV5vVunQ5
	 0lD2ZXULU52dgvPoNkucxtY4vtWiwJ7sI+8IA5NtEAuq3Sy1Fpu4nNG4v5n+u4LT2p
	 qRBOfwgJddmxiuhAUxS7adC+geMIoUwXbM3K/pp+YF8ZoUzFB/zPPc5gHtfQXv3nty
	 nMpnt9Ox8mcYspSO9KWP9HI5dquCQ78pdMl25CgLQBhOBRR4YrBGpe3lVM7LL7eZj/
	 Wqc1OBNBjk94A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 37/88] scsi: qla2xxx: Add size check for extended VP
 report ID entry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-38-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-38-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:46:01 +0000
Message-Id: <20260707064601.D62141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Accessing hardware structures via C bitfields defined on `__le16` =
causes silent data corruption on big-endian architectures.

Pre-existing issues:
- [High] Use-after-free of `vp` pointer due to unlocked access without refe=
rence pinning.
--

--- Patch [37]: [PATCH v3 37/88] scsi: qla2xxx: Add size check for extended=
 VP report ID entry ---
commit 4fb51fa003e8fc668f1e298648baf9a8b3e6b47d
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add size check for extended VP report ID entry

This commit adds reserved_end padding to the extended VP report ID entry
structure to match the hardware IOCB stride. It also updates
qla24xx_report_id_acquisition() to handle extracting vp_idx and vp_status
from the larger IOCB format on 29xx series adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 3ebda35dd584f..cec308811d9eb 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c

[ ... ]

> @@ -4102,6 +4105,14 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
>  	if (rptid_entry->entry_status !=3D 0)
>  		return;
> =20
> +	if (IS_QLA29XX(ha)) {
> +		vp_idx =3D rptid_entry_ext->vp_idx;
> +		vp_status =3D rptid_entry_ext->vp_status;

[Severity: High]
Does accessing hardware structures via C bitfields defined on __le16
cause silent data corruption on big-endian architectures?

If the hardware writes this DMA data in little-endian format, reading it
natively without le16_to_cpu() could result in byte-swapped data being
loaded into registers on big-endian systems. The compiler would then extract
bits from this mangled word, which might lead to corrupted values for vport
indexing and state transitions.

Should we use le16_to_cpu() here before extracting the bitfields?

> +	} else {
> +		vp_idx =3D rptid_entry->vp_idx;
> +		vp_status =3D rptid_entry->vp_status;
> +	}
> +
>  	id.b.domain =3D rptid_entry->port_id[2];

[ ... ]

> @@ -4241,18 +4251,18 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vh=
a,
>  			set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
>  			set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
>  		} else {
> -			if (rptid_entry->vp_status !=3D VP_STAT_COMPL &&
> -				rptid_entry->vp_status !=3D VP_STAT_ID_CHG) {
> +			if (vp_status !=3D VP_STAT_COMPL &&
> +				vp_status !=3D VP_STAT_ID_CHG) {
>  				ql_dbg(ql_dbg_mbx, vha, 0x10ba,
>  				    "Could not acquire ID for VP[%d].\n",
> -				    rptid_entry->vp_idx);
> +				    vp_idx);
>  				return;
>  			}
> =20
>  			found =3D 0;
>  			spin_lock_irqsave(&ha->vport_slock, flags);
>  			list_for_each_entry(vp, &ha->vp_list, list) {
> -				if (rptid_entry->vp_idx =3D=3D vp->vp_idx) {
> +				if (vp_idx =3D=3D vp->vp_idx) {
>  					found =3D 1;
>  					break;
>  				}
>  			}
>  			spin_unlock_irqrestore(&ha->vport_slock, flags);

[Severity: High]
This is a pre-existing issue, but is there a potential use-after-free
of the vp pointer after we release the lock?

The code iterates over ha->vp_list while holding ha->vport_slock to find a
matching vp. Once found, it breaks the loop, releases the spinlock, and
subsequently accesses the vp pointer (e.g., calling qla_update_host_map()
and setting flags further down in qla24xx_report_id_acquisition()).

Since no reference count is taken while the lock is held, could a
concurrent vport deletion remove the vp from the list and free it while
this function is still using it?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D37
