Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6212BB17;
	Thu,  3 Sep 2026 03:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407625; cv=none; b=eyuT32zxb6yoG5rUoTzaY5S1KkS9NE1wpFJOUS5Kfl5g7/19WLqKvntdeHOnrVOECgc3dYWImw3lq2OUvmBxQwikbRtdgCx53uDLNhu6gxO/cva8S3hKAB2Y4kT6SxAQceZ/IpCIKtJ7lDcz624Oi9n9wUXfJM/F80r5zgkp94Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407625; c=relaxed/simple;
	bh=tIOwEXixskK6A9szu4GfaUDeY6UW7PAtvRjHApUzOwQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YzRsmf9A0NYVzf8f1MXBru5Hu0H0uhvD0bVW4HtuQgYWGPxRk/WbgVt+KDF9GlOasOreHNibg81JN+zfsRTqRil6XmevvsPOGYg/CiuEGnk7OMjxPS9c0+NsHMwsUEt7niKBomPwCPC887awR0UpEN6NNo8iCfRUlzJY6H3WmI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mv5H6N1/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mv5H6N1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AE71F000E9;
	Thu,  3 Sep 2026 03:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407623;
	bh=1dUo9w9eSusJU/CLCiaoOyF9EO9WZnD8eOYo1veRCL4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mv5H6N1/ENQoZiHUxlYOp2Lwik4BakFsG7ZFViejDP/uDgUflwCzxNvSO0d5VJbqV
	 ImfaIEH2TiHF//0RmftY6nHhEHE5xZEmKi/yjAeVTelZNpS3gvgPV5gquy0w/z1is0
	 N+BL9OXbC+XKJ+9xXJOe49d1RcyE8lb63CndQZizZXk/HEMS8zUxKdYCM8BgQxEh3w
	 WIvM/m5c6MIZnkSZip7f5bPlDlPJo/lJrZ3vn190pVzEzi/m519th131Np4DpJgK44
	 kedfdzl5EZHPTWxdLLH7SAX6wLLnnfVjUMKys+gqVrE+FP3V8Np5j9GEx0HXd9CAhc
	 JClKbZdKVssog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/40] scsi: prepare for using 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260903034201.112211-6-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:53:42 +0000
Message-Id: <20260903035342.C2AE71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> In preparation for handling sense codes and their qualifiers as a single
> 16-bits sense code field, with the values  defined as macros in
> include/scsi/scsi_sense.h, modify the definition of the structures
> scsi_failure and scsi_sense_hdr to introduce a 16-bits sense_code field
> as a union with the existing 8-bits asc and ascq fields.
>=20
> This temporary modification allows accessing either the asc and ascq
> fields individually, or their combination as the 16-bits sense_code field.
>=20
> The helper functions scsi_sense_asc(), scsi_sense_ascq() are defined to
> allow accessing the 8-bits ASC and ASCQ values from the sense_code filed
> of struct scsi_sense_hdr. The helper functions scsi_failure_asc() and
> scsi_failure_ascq() provide the same for the sense code field of struct
> scsi_failure.
>=20
> The helper functions scsi_set_sense_buffer() and scsi_set_sense() are also
> added to wrap calls to scsi_build_sense_buffer() and scsi_build_sense()
> using a 16-bits sense code aregument instead of the 8-bits ASC and ASCQ
> arguments.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D5

