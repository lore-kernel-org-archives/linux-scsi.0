Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1BD306768
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2026 22:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785535661; cv=none; b=I1Arh9z2KjiElI7I/BNNFHhqTGqwwkIiiurzSeO1ceG+kN+FOUvcuCD7ejddfKKAt4v+vSzZR+78Gum0NXhopdM4pqxXLK8ijHBYPMtRPaO93BsDtoJADf0cCTaS0v6Msth5qjOKlrq2amaz2eFKlFGO9bSY8OxsV4WSel/qgQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785535661; c=relaxed/simple;
	bh=CRt+NDfnO3FFkMp35EWaDysQ83vfRhPQ2lc8GzztODA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rKs4eXOtrua+SGX66NM23etALsyKibAfzIDsue3Ut261x4NEv3PR+MryDRhMDIepPGBBsqMQQctM21aoGCLRj/NGgR+gzMYuhXmG0dW7mQJp0d+jxNqCo0QBTUkoM/hDOQeXtvnwP/yfoxgTF3sFXkTpkGAkj6YFUdP1zH6O0GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TKdgzE8I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKdgzE8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C6E1F00AC4;
	Fri, 31 Jul 2026 22:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785535659;
	bh=CZrhTWbrUUBtv8dPqMLvY4G5zln4kecKxS850lwoiv0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TKdgzE8IZ8JW6TI83HX13SB2A6PGo4KAdPtp/HlcUkInVppWxRzx41EYfKM3zaRm9
	 CH23cNvlCc0P8RmBzKhD/h87QZCzfbXup12NoaHe+RB+RwmcZZlijWXCVl4TYHmtCr
	 TMPunDPANwfI+izl0wtAih2bgTCkF16qSdbnCcAY+1fP17er74YaKtuFCvUCdBFOqs
	 NbkzSPbSq0wRmz+Ldc9AGYcPO5thRQlypF9Bxr6fUWpG8XFwg5Ex740spwJUYblx0u
	 TW/C4tcjcUfOjD/LKiUqMi+pmpc7DmQPD+vM9mFhgmT/rBMSxgmI5LvjP/7BTQC/jS
	 GJPj6ubPesL0A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/6] scsi: core: Add lock context annotations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <0a289ca5cf0c22588e4ae193acabd1cdfef672f3.1785534721.git.bvanassche@acm.org>
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
 <0a289ca5cf0c22588e4ae193acabd1cdfef672f3.1785534721.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 22:07:39 +0000
Message-Id: <20260731220739.97C6E1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] An integer overflow in the calculation of the REPORT LUNS response=
 length allows a malicious or malformed device to cause an infinite loop or=
 kernel crash.
--

--- Patch [4]: [PATCH v4 4/6] scsi: core: Add lock context annotations ---
commit 548e6f9dc80e81c45d6f26ae1feeb609869a4064
Author: Bart Van Assche <bvanassche@acm.org>

scsi: core: Add lock context annotations

This commit documents which functions expect that shost->scan_mutex is held.

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index d7e0e93931947..3b82e80e807a7 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c

[ ... ]

> @@ -1444,6 +1446,7 @@ static void scsi_sequential_lun_scan(struct Scsi_Ho=
st *shost,
>  static int scsi_report_lun_scan(struct Scsi_Host *shost,
>  			struct scsi_target *starget, blist_flags_t bflags,
>  			enum scsi_scan_mode rescan)
> +	__must_hold(&shost->scan_mutex)
>  {
>  	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
>  	unsigned int length;

[Severity: High]
This isn't a bug introduced by this patch, but while looking at this functi=
on,
I noticed a potential integer overflow when calculating the response length:

drivers/scsi/scsi_scan.c:scsi_report_lun_scan() {
    ...
	if (get_unaligned_be32(lun_data->scsi_lun) +
	    sizeof(struct scsi_lun) > length) {
		length =3D get_unaligned_be32(lun_data->scsi_lun) +
			 sizeof(struct scsi_lun);
		kfree(lun_data);
		goto retry;
	}
    ...
}

If a malicious or malformed device returns a large value like 0xFFFFFFFF
in the first 4 bytes of its response, can the addition of
sizeof(struct scsi_lun) overflow?

On 64-bit systems, would this addition yield a 64-bit value that bypasses
the greater-than length check, but then truncate when assigned back to the
32-bit unsigned int length variable?  Could this cause an infinite retry
loop or an invalid pointer dereference if it truncates to zero?

On 32-bit systems, could the addition directly overflow to a small value,
fail the greater-than length check, and proceed to parse out-of-bounds luns
from the initially allocated buffer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/68f3346cab2be570839=
350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org?part=3D4
