Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C2B356754;
	Mon, 31 Aug 2026 02:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788142691; cv=none; b=tKSI8rClVptIcIcK5zCxKwR8oRqyxobwnNuI/6mHVnAdPpLPqK8ajFotbs0gVBk9mFSc7kq5/fHOaQ9ZDAi6BCMds7QV+1PmXeR9cbVclQI5r4nFLIF6fa0E5/XdYLCA8kziUJ9/Sr6tuyVP/pQDjC6DXTJmSc/uITqJaMsAy0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788142691; c=relaxed/simple;
	bh=SFpX3MP954KAVujBufUqjMVEP5wiygQK0HhfOnXROMA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=h2ecqDBsDS3TaUeDMzDXQdlBH1ieNcQcyNfXERcDMblBznvmzLDDidvfUeJOI5WCohaPKsN06chQIQ16Ijp5k3NdwmWR62KHs4bkzIhyMbESBQDzYVa04rIuXbrEYbRe9xZ1WhFW3fgaa7Q0TvpSpRGSnnB0HFNveCeYDqf/rWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J8O2Ka2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8O2Ka2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235281F000E9;
	Mon, 31 Aug 2026 02:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788142690;
	bh=rA9xzBXq2nXhB4RMXCMCbKUhehENuytSQMFPqFp9L5k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J8O2Ka2kBma8Mwc9uMNyiniJURlV9UVE4BbEKY1j9BRyCAGNJ+t5mfljDnys2c82S
	 MIVLpxQkErCkpX4EVOKC+x4ainWKKT3R5ROifp4T94+T8oWGkN7EOW1+z1DLVPpbY0
	 +NqyyEzG2g8QZ+L5Lgz4s+AbACMESQv37OD52EDUh0dJsfhr2Fyj6VLm8XDjeGGv6K
	 9E5hGTX8laKnd6Yn/m+YVVO1lMMNiZmZnDtoEQVs0BIXcURKLnliuftME2SE6ov29I
	 MgMFG5dEdFq6kzk6EDkNCl6YJhHl8INjSxauv+S2ZmW82ISfQoGkC1AfaSaP8SyNl4
	 hbt1dxJyGs0tA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 20/37] scsi: leapraid: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, dlemoal@kernel.org
In-Reply-To: <20260831020451.585944-21-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
 <20260831020451.585944-21-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 02:18:09 +0000
Message-Id: <20260831021810.235281F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The driver synthesizes a CHECK_CONDITION for REPORT_LUNS when a da=
ta underrun occurs but fails to update `scmd->result`.
--

commit 909befd157ab89fe2f70728b01ba29158ee9d0b5
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: leapraid: use 16-bits defined sense codes

This refactors the leapraid driver to use the 16-bit sense_code field
of struct scsi_sense_hdr and replaces all hard-coded additional sense
codes with enum values. It deletes the locally defined macros for ASC
and ASCQ values in favor of standard definitions.

> diff --git a/drivers/scsi/leapraid/leapraid_os.c b/drivers/scsi/leapraid/=
leapraid_os.c
> index ee3242779dfdf..eb8b114399231 100644
> --- a/drivers/scsi/leapraid/leapraid_os.c
> +++ b/drivers/scsi/leapraid/leapraid_os.c
[ ... ]
> @@ -382,9 +382,8 @@ static void leapraid_handle_data_underrun(
>  	} else if (!xfer_cnt && scmd->cmnd[0] =3D=3D REPORT_LUNS) {
>  		scsiio_rep->scsi_state =3D LEAPRAID_SCSI_STATE_AUTOSENSE_VALID;
>  		scsiio_rep->scsi_status =3D SAM_STAT_CHECK_CONDITION;
> -		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST,
> -				 LEAPRAID_SCSI_ASC_INVALID_CMD_CODE,
> -				 LEAPRAID_SCSI_ASCQ_DEFAULT);
> +		scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
> +			       INVALID_COMMAND_OP_CODE);

[Severity: High]
This is a pre-existing issue, but should this code also update scmd->result
with the new status?

Because scmd->result is not updated with SAM_STAT_CHECK_CONDITION in
leapraid_handle_data_underrun(), it retains the initial DID_OK | scsi_status
(which is typically 0 here).=20

Doesn't this cause leapraid_scsiio_done_dispatch() to return early, hiding
the synthesized ILLEGAL_REQUEST sense data from the SCSI midlayer and
breaking LUN discovery when a data underrun occurs?

>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831020451.5859=
44-1-dlemoal@kernel.org?part=3D20
