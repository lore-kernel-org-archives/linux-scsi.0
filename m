Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F8538D41A;
	Mon, 31 Aug 2026 02:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788143377; cv=none; b=RPLYX66CwSCFQmMYKR3znjl9Y1oOX7uDtA4OBWGczl0z4S5htR1FaQHHTuJsxaZEs80y8MNAeevATJvxq/alv/pZKc3iR3VRK9VwNUkhN4DazkdtQccKAyGiBngvc73+3e73iJUP0ADQ+ojaqNjtjFe4GRDq9dXKgxNUWt32tcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788143377; c=relaxed/simple;
	bh=XNe86WA5KNBUJ6K1KGwtEm9v8UtXEp9r5kocBxyOM1Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BV2Ek7pduzCkhJl/XRpRhxqiAVE6tt/8v54AGVMIj2y9xNq6qwjzWZByCzLAs6kf2CQw1A6g1HEogtNgIWoTvv8+pCYEyF4l/Ywt/aAUF5PkdL4G7nLDt4GloirZvNClWe/Btr0/0g/PAMpQ1nAcEWUqOpWexu+T3+KTJPbpXZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H5pYzjSx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H5pYzjSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8A21F000E9;
	Mon, 31 Aug 2026 02:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788143362;
	bh=D3bzSeQrHVqSFKy63zc/GamS0tl8N9D62Z1ZbSBWCUk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H5pYzjSxwOoMU9wZfXj9RlJPoUjACEzlEqSVldK94d5rFdgLx7nE1Wmtzu5HRe/gT
	 QnJgDu+3GHjo5ihfp5Rz/MFMQxw02Xr8FUY+28j97SwufwGYJo1xZ8AN6LAv/rMBlN
	 pl1kUTsCCLR6mXJBu6ISh8GT0qrSNzVTAv7vN2h9VjD20iffsxbzqRYhi8WCgTZs16
	 IkvTZPs0dtXCBuc70oGL8uemA6Ld/W6+D3X7RlWJ/RoH6B1814vBMHzQjRUs+k20wq
	 yhSLenBQyCMXvmpv12wKeBRZfVd6EATw2O6/LYXCPgm7GjubFSDBr4hEaCwi1ogXkE
	 D7HEAS+1y1SRA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 35/37] cdrom: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260831020451.585944-36-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
 <20260831020451.585944-36-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 02:29:21 +0000
Message-Id: <20260831022921.AE8A21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Tracepoint scsi_cmd_done_timeout_template incorrectly logs the '=
ascq' field as the 'asc' value.
--

commit 7e6312a47a6eeb4644f3eba5f9acd48a9a7fd4c4
Author: Damien Le Moal <dlemoal@kernel.org>

    cdrom: use 16-bits defined sense codes
   =20
    Refactor the cdrom driver to use the 16-bits sense_code field of
    struct scsi_sense_hdr and replace all hard-coded additional sense codes
    and additional sense code qualifiers with the enum values defined in
    include/scsi/scsi_sense.h. This helps with code clarity as the sense co=
des
    being processed are easier to test and self-documented.

> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index 4f1fd389260f5..c717e35ea2afc 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -345,9 +345,8 @@ int cdrom_dummy_generic_packet(struct cdrom_device_in=
fo *cdi,
>  			       struct packet_command *cgc)
>  {
>  	if (cgc->sshdr) {
> -		cgc->sshdr->sense_key =3D 0x05;
> -		cgc->sshdr->asc =3D 0x20;
> -		cgc->sshdr->ascq =3D 0x00;
> +		cgc->sshdr->sense_key =3D ILLEGAL_REQUEST;
> +		cgc->sshdr->sense_code =3D INVALID_COMMAND_OP_CODE;
>  	}

[Severity: Medium]
While reviewing the sense code changes, I noticed a related issue in
include/trace/events/scsi.h. Does the scsi_cmd_done_timeout_template
tracepoint incorrectly log the 'ascq' field?

include/trace/events/scsi.h:scsi_cmd_done_timeout_template() {
...
		if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
		    scsi_command_normalize_sense(cmd, &sshdr)) {
			__entry->sense_key =3D sshdr.sense_key;
			__entry->asc =3D scsi_sense_asc(&sshdr);
			__entry->ascq =3D scsi_sense_asc(&sshdr);
		} else {
...
}

Any time a tracepoint based on scsi_cmd_done_timeout_template is hit and a
valid SCSI sense buffer is present, it looks like scsi_sense_asc(&sshdr) is
called twice, assigning its return value to both __entry->asc and
__entry->ascq.

Does this irrevocably lose the Additional Sense Code Qualifier (ascq) value
in trace events (like scsi_dispatch_cmd_done and scsi_dispatch_cmd_timeout),
corrupting the trace output and hampering debugging?

> =20
>  	cgc->stat =3D -EIO;
>  	return -EIO;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831020451.5859=
44-1-dlemoal@kernel.org?part=3D35
