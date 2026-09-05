Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6232EEE93;
	Sat,  5 Sep 2026 03:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579581; cv=none; b=WE3j9xUZon+I0tyK7cAgOBbfiZuUdUcsMbySBwp0ubH+nB4V89gBdjfml+7kymkhggzOIQr3r0tl5b8Lk88s2+1AW82UBZO+ndOwf3B9D2O4Dt4fx7pNnPiwBy3JQ/Mv6GhgjD1y4EQ+TYRHrpyaTRKok+EgauvPVattxwq5CmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579581; c=relaxed/simple;
	bh=oe02eUBA7U4JHM9ilkCGPt8USdebAAEb5FgTO0kMqB8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AhWA1nEptN+Z9UvHTwzvDH+qdjpxW/rCTuZpeWDSu7+8kR7liHsr8rslVVLAYq4LFkR1b0czszMAj5XTwNaNJtKek0/m1ZkVVmqBN/k7I9zGKlkR2CmKi5UuZ65HZr+zDkDqckYalxPF6BmBvhYT3g+z3HkwaOv1pyNhNLejnls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h+48rMb8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h+48rMb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59C91F00A3D;
	Sat,  5 Sep 2026 03:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579578;
	bh=333ameadfaz9ms2V836xStUa6x0ea5nk4w98vPx9W+s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h+48rMb83YEgwdOkBlari7eojRxF6aeQxfo0xe56wjLSSc42Fo/kYkvEYBUcaNoL8
	 p2sjeIvso1KF6mDiyQIDhTBWv9EWZXJ1OaxV3d2GBZHx42AmDJSAywKMhZ/lbSbsGM
	 spCIustOJuga2HDiNq1l9XQvvKIS5d0Csr3SH+2+cWDVV6Qi5Bu1B9Q8ZwND3UuQeY
	 EYY1ibic4nt+Q3hY85RKeA1eTBdAsTWky7NnQ2GDFZlD7ALKUcAb3j6ngNKlkrR0oj
	 NIj8szaErtdSiaXMypLPyqDa83x5yxGTfL03XnxxFa1BArfFB86NSoNqdoGKTTZtx3
	 eJVoM2FAK58FA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 24/40] scsi: qla2xxx: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org
In-Reply-To: <20260905032224.509860-25-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-25-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:39:37 +0000
Message-Id: <20260905033937.B59C91F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incomplete refactoring: missed target driver DIF error handling
--

commit d3190174a389898ad4eb14e10e32bf87c60b2ff8
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: qla2xxx: use 16-bits defined sense codes

This refactors the qla2xxx driver to use scsi_set_sense() and replaces
hard-coded additional sense codes with enum values.

>     Refactor the qla2xxx driver to use scsi_set_sense() and replace all
>     hard-coded additional sense codes and additional sense code qualifiers
>     with the enum values defined in include/scsi/scsi_sense.h. This helps=
 with

[Severity: Medium]
The commit message states that all hard-coded additional sense codes and
qualifiers are replaced, but did the refactoring miss the target driver DIF
error handling?

For instance, in drivers/scsi/qla2xxx/qla_target.c:qlt_handle_dif_error(),
the code still hardcodes the ASC and ASCQ values:

	cmd->dif_err_code =3D DIF_ERR_APP;
	scsi_status =3D SAM_STAT_CHECK_CONDITION;
	sense_key =3D ABORTED_COMMAND;
	asc =3D 0x10;
	ascq =3D 0x2;

And in drivers/scsi/qla2xxx/qla_target.c:qlt_print_dif_err(), it continues
to use hardcoded indices and magic numbers to parse sense data:

	if (prm->sense_buffer && (prm->sense_buffer[12] =3D=3D 0x10)) {
		cmd =3D prm->cmd;
		vha =3D cmd->vha;
		/* ASCQ */
		switch (prm->sense_buffer[13]) {

Should these instances also be updated to use the new
LOGICAL_BLOCK_*_CHECK_FAILED enums and scsi_normalize_sense() to keep the
driver consistent?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D24
