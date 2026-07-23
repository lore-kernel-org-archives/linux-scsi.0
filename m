Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DE93DAAD3
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 07:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784792596; cv=none; b=HRRn2jgxgJqoWTJ/cUcu0a2YS61HzcmASCyXIbip8fodyvQ1xcJ40/A6Qoy/StECS1olxoTDiFKGdi52yrOfwJsanNj2fdzUoGywW21c9aOqVt20hXnqTlwOkS5nHWUhowncEqAGvci0wsCDtWRfLQ6fuheHAOzJziRfGOYUSn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784792596; c=relaxed/simple;
	bh=Cqv9QXvZm+S21UpXv0S8Wl/I3v6mCw36XphEL9Wrwsk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E7xvZhgdXMFEFGG7Z6zHvKRETKkyyqX0TQsdh/C8HLd19Ng9rsSUwIa8skxIBRtxwgRW0Sm35le9dQi49rh58qhYTH76ji5ifkziwnHGYy/rhKhc3YVdgNNplDR1Gyimg9EKLyoAvcPy9IPWoFR1TJoyRIYXSIFp2J+q7Dg6mas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXjRWpxm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXjRWpxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06B41F000E9;
	Thu, 23 Jul 2026 07:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784792594;
	bh=BH1gLdR+ZKIisAnwUDSlp/OPAtDRwb8hSaBhxQUO35w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RXjRWpxm7dI3j9VpCZa1i1gwpAOvpCz0G3RI/w1Bfk1iuJowAlXSWL5srjWZlpJf/
	 7O75k8Wd8smKi2pumDst4+v12X/EUJCDc0nU9oropBPhAOPIE/yuPYDsSch88TlDC0
	 FyStw2fgpuusadx7XJqvpUicToK21WKPrCEBYsW9cswPwfeRxIzJkj3p3l0zcWqdO7
	 kd3B8f5+qrwieJY0FqHQhYlL54xIeBKdZdeQjZC3Lkiym0uGJStvip+P2CwkNRlYgM
	 GSlnYS0N+ZtbRLmv+VAJaSKja94H/SLMG2OcIV2LIULhRM7QAN6WE/XXk8afTjZpT5
	 D5ni1SXCF427Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 10/56] scsi: qla2xxx: Add extended status
 continuation and marker IOCBs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-11-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-11-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 07:43:10 +0000
Message-Id: <20260723074314.B06B41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The commit message claims to add `sts_cont_entry_ext_t` and `mrk=
_entry_ext_t`, but the patch only adds `struct sts_cont_entry_ext` and enti=
rely omits the marker structure.
--

--- Patch [10]: [PATCH v6 10/56] scsi: qla2xxx: Add extended status continu=
ation and marker IOCBs ---
commit e3f382fa4d5aa55c429c51349c5574fdb65d9249
Author: Anil Gurumurthy <agurumurthy@marvell.com>

scsi: qla2xxx: Add extended status continuation and marker IOCBs

This commit adds the 128-byte extended status continuation structure and
includes the new qla_fw29.h header for 29xx firmware support.

> scsi: qla2xxx: Add extended status continuation and marker IOCBs
>=20
> Add the 128-byte sts_cont_entry_ext_t and mrk_entry_ext_t
> structures required by 29xx firmware.

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
[ ... ]
> @@ -2360,6 +2361,15 @@ typedef struct {
>  	uint8_t reserved_2[48];
>  } mrk_entry_t;
> =20
> +/* 29xx definitions */
> +struct sts_cont_entry_ext {
> +	uint8_t entry_type;		/* Entry type. */
> +	uint8_t entry_count;		/* Entry count. */
> +	uint8_t sys_define;		/* System defined. */
> +	uint8_t entry_status;		/* Entry Status. */
> +	uint8_t data[124];		/* data */
> +};

[Severity: Medium]
The commit message states that both sts_cont_entry_ext_t and mrk_entry_ext_t
are being added, but only struct sts_cont_entry_ext is present in the code.

Is the mrk_entry_ext_t structure accidentally missing from this patch, or d=
oes
the commit message need to be updated?

Additionally, should sts_cont_entry_ext use a typedef to match the
sts_cont_entry_ext_t description in the commit message?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D10
