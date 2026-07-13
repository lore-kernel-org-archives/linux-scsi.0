Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F485199E89;
	Mon, 13 Jul 2026 04:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783916868; cv=none; b=ImCeeKZwwNZSHdRG024089yrAnW4FgjK7AvFVITm5orUG/mde8FuAF3aLxfb77FQTrk9yjSDHvrZV/clOgoseywkOS4WIA2Ei5nqMCiD6FSGsCzTR0xFsl0eGffcPXBGPW2KRlL0ajBmEO9QSByXjtu+G7oaVQo+RoD0TVeN5F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783916868; c=relaxed/simple;
	bh=P6JPsuWbnp1/BNgdwkE6Bs73iA+0varB/s4LkJRhdxQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l256mODy48upJpU7hxAfuSZtOMWjO1prZUzkCEowK/RfpVb06/JKwRJbPIzSlnu6rtvk7jBZxNCDeUW6WaumYlZAqDYq10Gh98bXSPg8CZJoCoQI6Cd5y8G6edbf8E6RaqQNoElczrg3feHT83pJoR5SCpqx/0yc10l12XlpzxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJ89+ux+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJ89+ux+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD74E1F000E9;
	Mon, 13 Jul 2026 04:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783916867;
	bh=FlmJ36f7F9Av+KQkZus7sl3l5/UMwIXpDdSXoY1a7jM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FJ89+ux+YtaiacuRKlhqpm8wWqnj+TitVC5o2+dM7XLqwHpthinCbqfyW59JD2fVv
	 SGV2LmmjkceqNZ9mGnJ+yxD8+WNe2HplrCp2TsIMxu38eNQHb0Aoy1b0VitQbVPjeJ
	 T70TlAOPtKv9wF2fC36gIPB8tjVJSUfkSSYLxUXI1QmeM2IrNKSzcCnVRlnp/cxgSM
	 hjmZeLQmWRnA0r3IimV6v68crvt4QudyN5eElK0gSFAcIKWVSEE1LvaAyLhgu7FJzr
	 03/PzHDhuffkHeuXGMBau9rI3mrg1kEh4Q5ZxotHmjWMyoWPlPzqiYDA/DsrvFQHtn
	 AcdmBp64eafkA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] scsi: libsas: terminate deferred commands on
 time out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org
In-Reply-To: <20260713041252.463401-3-dlemoal@kernel.org>
References: <20260713041252.463401-1-dlemoal@kernel.org>
 <20260713041252.463401-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 13 Jul 2026 04:27:46 +0000
Message-Id: <20260713042746.CD74E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Missing function declaration for `ata_eh_schedule_deferred_qc_retry=
()` when `CONFIG_SATA_HOST` is disabled, leading to a build failure.
--

--- Patch [2]: [PATCH v3 2/2] scsi: libsas: terminate deferred commands on =
time out ---
commit 3af8343f458da773cfa43a85c2e86949acf28cc1
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: libsas: terminate deferred commands on time out

If a command timeout occurs while we have a deferred non-NCQ command waiting
to be issued, the SCSI EH task is not immediately woken up. This patch avoi=
ds
this unnecessary wait by using the eh_timed_out SCSI host template operatio=
n.

> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sa=
s_scsi_host.c
> index c83282733ec4c..6b62522bd0b2e 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
[ ... ]
> @@ -502,6 +502,23 @@ int sas_eh_target_reset_handler(struct scsi_cmnd *cm=
d)
>  }
>  EXPORT_SYMBOL_GPL(sas_eh_target_reset_handler);
> =20
> +/*
> + * Handle deferred QCs in case of a command timeout.
> + * See ata_scsi_eh_timed_out() for details.
> + */
> +enum scsi_timeout_action sas_eh_timed_out(struct scsi_cmnd *cmd)
> +{
> +	struct domain_device *dev =3D NULL;
> +
> +	if (cmd)
> +		dev =3D cmd_to_domain_dev(cmd);
> +	if (dev && dev_is_sata(dev))
> +		ata_eh_schedule_deferred_qc_retry(dev->sata_dev.ap, cmd);
> +
> +	return SCSI_EH_NOT_HANDLED;
> +}
> +EXPORT_SYMBOL_GPL(sas_eh_timed_out);
> +
[ ... ]
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 327da43d74967..2ea7bfbdd867b 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1261,6 +1261,8 @@ extern int sata_link_hardreset(struct ata_link *lin=
k,
>  extern int sata_link_resume(struct ata_link *link, const unsigned int *p=
arams,
>  			    unsigned long deadline);
>  extern void ata_eh_analyze_ncq_error(struct ata_link *link);
> +void ata_eh_schedule_deferred_qc_retry(struct ata_port *ap,
> +				       struct scsi_cmnd *scmd);
>  #else

[Severity: Low]
Will this result in a build failure when CONFIG_SATA_HOST is disabled?

The declaration for ata_eh_schedule_deferred_qc_retry() is placed inside
this conditional block. When CONFIG_SATA_HOST is disabled, this declaration
is omitted, but the function is still called unconditionally by
sas_eh_timed_out() in sas_scsi_host.c (as well as ata_scsi_eh_timed_out()
in libata-scsi.c).=20

Since modern compilers treat implicit function declarations as errors, could
this break the build under these configurations?

>  static inline const unsigned int *
>  sata_ehc_deb_timing(struct ata_eh_context *ehc)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260713041252.4634=
01-1-dlemoal@kernel.org?part=3D2
