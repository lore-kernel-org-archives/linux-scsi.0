Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF2036C5A9
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 20:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786739930; cv=none; b=pe7lFIl2RN3Jt20eV9+iVWs6cOBoex50Ua8dPZ0f0eC8c+O0LS/2pdHhtxn+kFkdkyMFKb59AO/EyO5zlI5wBF5l4Y11wFjrExRniu6BwyBnW0l3nWqL8Mckye0un9QuTkJM5qX3FB6uAlkAMcQhdMnZB1yfwHOo4RX48cugCAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786739930; c=relaxed/simple;
	bh=VZSVEO8DKcq3UFJsnFv0hanoLULgbJTcaF/zlOa28ms=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uRteehlPHS487ODlVSHeM6o1AuGQy7TVwm1ycH0Hba2pkYmvlF1Z/0nBNpUx4EgRAT43UFd+zO+fbMANYwRyBnJQg6Cy9dzTJMR2Rccz86ZAZg6SztnKChAp4dSVvKsv4eoAN1oyrnROSEC6Z7xuGiAuVvqwPwGUwgeuNbDzDBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xr80gVcn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xr80gVcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4B11F000E9;
	Fri, 14 Aug 2026 20:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786739929;
	bh=L87e0K9m8OjKjHnwQ7m12N3fDH8zowuPJ7jmcgVPVIY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xr80gVcnMLdsmKQTKEHE2R/0Pjh+nieyBy/ngu88pLU9yy7zL/sBHh2Zci0afqlhR
	 l8k9VrsdHA45t2qYHwB3eCYujoNBnLbx5MRiEn+nZmMrdK/ufYzWcrjj1X+wQkEyqI
	 GUhsAnt726s5zqJ+qfeycCLOyclBusVpzi9S+DbeD8WhagUTVCxdAydVMcucZZu4YR
	 YKS0jmYFlUkyQOoMQYX8Ivl6IPWMVyxljJ23Dom/ccurVGx46ulfLmAe2yq1oHTfHt
	 55fH/X5ZV5rUiRvsB2bfSo0DCG9cufDLx9/sjZgDcqS92zw0lgbJsVUkb4AC+BOSrT
	 GLa6gvtbIS9OQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: core: Eliminate
 scsi_log_{reserve,release}_buffer()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <0b34db4ad0baadcdf2e223cc1a2c134b4f67ea1a.1786739033.git.bvanassche@acm.org>
References: <0b34db4ad0baadcdf2e223cc1a2c134b4f67ea1a.1786739033.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 20:38:48 +0000
Message-Id: <20260814203849.0E4B11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The newly introduced stack buffers `extd_sense[64]` and `hb_buf[=
32]` are too small for some valid strings, causing unintended log truncatio=
ns that contradict the patch's stated goal of eliminating truncation.
--

--- Patch [1]: [PATCH] scsi: core: Eliminate scsi_log_{reserve,release}_buf=
fer() ---
commit 677007193ec0d6990c587a8dbcce949ece4341ff
Author: Bart Van Assche <bvanassche@acm.org>

scsi: core: Eliminate scsi_log_{reserve,release}_buffer()

This patch eliminates temporary buffer allocations in SCSI logging by using
struct va_format (%pV) and formatting directly with dev_printk(). Helper
functions and stack buffers are introduced for CDB formatting, sense header=
s,
and result strings.

> diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
> index 3cd0d30740855..5bf2f1c74ec70 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c

[ ... ]

> @@ -292,51 +253,29 @@ static void
>  scsi_log_print_sense_hdr(const struct scsi_device *sdev, const char *nam=
e,
>  			 int tag, const struct scsi_sense_hdr *sshdr)
>  {
> -	char *logbuf;
> -	size_t off, logbuf_len;
> +	char sense_hdr[64];
> +	char extd_sense[64];
        ^^^^

[Severity: Medium]
Will the extd_sense array truncate valid additional sense codes?

The commit message notes this patch resolves the truncation of log messages,
but it seems this 64-byte stack buffer might be too small. When formatting
long Additional Sense strings such as "Invalid token operation, remote rod
token creation not supported" (64 characters) plus the "Add. Sense: " prefix
added in scsi_format_extd_sense(), the result requires 77 bytes including t=
he
null terminator.

Could this array be expanded to prevent truncation?

> =20
> -	logbuf =3D scsi_log_reserve_buffer(&logbuf_len);
> -	if (!logbuf)
> -		return;
> -	off =3D sdev_format_header(logbuf, logbuf_len, name, tag);
> -	off +=3D scsi_format_sense_hdr(logbuf + off, logbuf_len - off, sshdr);
> -	dev_printk(KERN_INFO, &sdev->sdev_gendev, "%s", logbuf);
> -	scsi_log_release_buffer(logbuf);
> +	scsi_format_sense_hdr(sense_hdr, sizeof(sense_hdr), sshdr);
> +	sdev_tag_prefix_printk(KERN_INFO, sdev, name, tag, "%s", sense_hdr);
> =20
> -	logbuf =3D scsi_log_reserve_buffer(&logbuf_len);
> -	if (!logbuf)
> -		return;
> -	off =3D sdev_format_header(logbuf, logbuf_len, name, tag);
> -	off +=3D scsi_format_extd_sense(logbuf + off, logbuf_len - off,
> -				      sshdr->asc, sshdr->ascq);
> -	dev_printk(KERN_INFO, &sdev->sdev_gendev, "%s", logbuf);
> -	scsi_log_release_buffer(logbuf);
> +	scsi_format_extd_sense(extd_sense, sizeof(extd_sense), sshdr->asc,
> +			       sshdr->ascq);

[ ... ]

> @@ -381,58 +320,35 @@ EXPORT_SYMBOL(scsi_print_sense);
> =20
>  void scsi_print_result(struct scsi_cmnd *cmd, const char *msg, int dispo=
sition)
>  {
> -	char *logbuf;
> -	size_t off, logbuf_len;
>  	const char *mlret_string =3D scsi_mlreturn_string(disposition);
>  	const char *hb_string =3D scsi_hostbyte_string(cmd->result);
>  	unsigned long cmd_age =3D (jiffies - cmd->jiffies_at_alloc) / HZ;
> +	char mlret_buf[32];
> +	char hb_buf[32];
        ^^^^

[Severity: Medium]
Does this code truncate hb_buf when formatting DID_TRANSPORT_DISRUPTED?

If scsi_hostbyte_string() returns "DID_TRANSPORT_DISRUPTED", formatting it =
as
"hostbyte=3DDID_TRANSPORT_DISRUPTED" requires 33 bytes including the null
terminator. This will be truncated by the 32-byte array.

Should this array size be increased to comfortably fit the longest possible
hostbyte string?

> =20
> -	logbuf =3D scsi_log_reserve_buffer(&logbuf_len);
> -	if (!logbuf)
> -		return;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0b34db4ad0baadcdf2e=
223cc1a2c134b4f67ea1a.1786739033.git.bvanassche@acm.org?part=3D1
