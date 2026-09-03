Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9C132D42B;
	Thu,  3 Sep 2026 03:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407911; cv=none; b=DdQHbAxoZLsYD7WyuQ2fpVzSgPdBjCiONbkuuapVIe3gP3JveHTd3LqmhDDWsyqgHX+GEL9hHhnpHN98SD+kvsQMzHuItAa0jOvWL+WYw3Mu0SWhavTkDEJjmlmQsDf+94y1EWjg8L5lnHYTQcobzJ0d2YVi4oVmOdj6kL5FPT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407911; c=relaxed/simple;
	bh=6c3TIDwREGepSxkpWMcbGs9my0clpOUvUCyT24kxpf0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lESJv+cjdfdhhUgMYuEuL7WUhmZdo6NF2XIRtcQDbzy/1P4m9H7I/3kU2HjR9wZfxOjGqt1GbyghLn0JFZe8ExzZZC1mEVT1RjsnUzhmCJK6a3rCJMlia7AgBEWyE7Gbj/og3L+PqArDSznkEm8cO5htK8Hy7USDCgOls/WMXgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jTM5q+FM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jTM5q+FM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C553D1F000E9;
	Thu,  3 Sep 2026 03:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407910;
	bh=yfWSOFhlpaOpVXHz4smMaG3AGGRLQrY+X4A4F+p/aRo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jTM5q+FMTSYW4hKtww+FOLoPvo3b2hz8IeU+/VpSbZYFF+7Ir0xcVdJQAMNvTUNvJ
	 t3HUXUQbax0jhRuBym1X3C19/sb1vXmYKb/Cgg32vQSu5N03R0IHT4M5aPD9Uhc8Xo
	 mTZCOxUEUDvaGtGUowRHpe+ACjqkCne+02sbQNukMDW/wwfjH/JU1xFdfxtnjEl+l4
	 gJkasX+XgL3I7vMlctzRgpHM3pIciH1ga3FNEa9Nc1eVE4g3t0wEIeJem8dcesfvRA
	 Ku72bq9n0jpQwYgCytK0uv9Zax4ZQ6TzZDH2NoL+BFt+QOJZoXYbhXYw+76ObXrJPK
	 9Bf/Rn98F34LQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 40/40] scsi: remove scsi_build_sense() and
 scsi_build_sense_buffer()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, cassel@kernel.org
In-Reply-To: <20260903034201.112211-41-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-41-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:58:29 +0000
Message-Id: <20260903035829.C553D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The kernel-doc block for scsi_set_sense() is outdated, documenting =
removed parameters instead of the new parameter.
--

commit 346248be55e45fce39f6b6a510b7c29fbb538f5c
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: remove scsi_build_sense() and scsi_build_sense_buffer()

This commit converts the SCSI sense building functions to use a single 16-b=
it
sense code parameter and renames them to scsi_set_sense() and
scsi_set_sense_buffer().

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b58e028a362e2..3fcc4062ad813 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c

[ ... ]

> @@ -3585,7 +3585,7 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *=
rel_id)
>  EXPORT_SYMBOL(scsi_vpd_tpg_id);
> =20
>  /**
> - * scsi_build_sense - build sense data for a command
> + * scsi_set_sense - build sense data for a command
>   * @scmd:	scsi command for which the sense should be formatted
>   * @desc:	Sense format (non-zero =3D=3D descriptor format,
>   *              0 =3D=3D fixed format)
> @@ -3594,12 +3594,12 @@ EXPORT_SYMBOL(scsi_vpd_tpg_id);
>   * @ascq:	Additional sense code qualifier
>   *
>   **/
> -void scsi_build_sense(struct scsi_cmnd *scmd, int desc, u8 key, u8 asc, =
u8 ascq)
> +void scsi_set_sense(struct scsi_cmnd *scmd, int desc, u8 key, u16 code)

[Severity: Low]
Does this kernel-doc block need updating for the new parameter?=20

It looks like the documentation for scsi_set_sense() still lists the removed
@asc and @ascq parameters, but is missing the new @code parameter. This will
likely cause warnings during documentation builds.

>  {
> -	scsi_build_sense_buffer(desc, scmd->sense_buffer, key, asc, ascq);
> +	scsi_set_sense_buffer(desc, scmd->sense_buffer, key, code);
>  	scmd->result =3D SAM_STAT_CHECK_CONDITION;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D40
