Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944934A3F3C;
	Tue,  8 Sep 2026 10:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861929; cv=none; b=MasE4po8qbcBJyKISFYbbAZ8Qk0pzVrum8WAgRNccsxSKp9fDIJgjAnxF9u+lRFqjTwcDfbDkaVz3dAgfS3k3s/ZQNV/fukfMoAuQ7WGCvKivXP6SpxJAr9WZPn8KbQTiJX8lMCS8pKp6ofxEL9fNopBiQc6x3ryzDofxnpMwGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861929; c=relaxed/simple;
	bh=1Je0zau/w16iYwcShQw6n4AdUjDgc0FXeSIMhA44bv4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qgCrrgS0/TybVMdIkIz+mBb+DLcoyjCDmtc9iITMx+GAvhwqi8ZV+I9ek/OUpRgUL53PyIMABNeDuxEOheGBDW73aP+dPWVPPhonKvQW8H9RJsaJSRWSgMirBensbYOh1fOJ7BY5UiqR6CGT6Rv4rr6h89JeyWYFgR8Y9llnOOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obeDzxdF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obeDzxdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E8C1F00A3A;
	Tue,  8 Sep 2026 10:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788861928;
	bh=1llHpjEhYURVq80JPDNlt4eeILq7e+VL7hsr+QqAWVE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=obeDzxdFQEOqki90YSxsNRj0xgOrlcHEHI8fQgqkUyynB04nj4zp8orKTMsW8vQdn
	 KXVjQAq1FwfiHaBQdAY0GilCq4DWQAE406IRx58fvlZmL1rQLZ5QQ7J5vV5xVe2nxz
	 d7nrS8tUGPPgKq3hcLU8PWHCU/K5cofGcLTuL1b3aouxouedQTBhtJHV4vp2gMrUPx
	 7dfQsFB/QccqgB7bXTJDL+KyVJSal2wYk+y/xEjLcaYNIdhwzCdE+sAQxvYgscffxp
	 fPVQ7tXW5xoOV16syyHC7HWveLjrVZwcXLn6Z0OVT5BVDeXjWmjPpJivzL5bmzOHmG
	 CyxEo3Wom7Ajg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 25/40] scsi: ps3rom: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260908090308.1085097-26-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-26-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:05:27 +0000
Message-Id: <20260908100527.F2E8C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Pre-existing cmd->result overwrite clobbers CHECK_CONDITION status
--

commit 4d82cf634e0fe3033c43713286bcedaf5b5d7dae
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: ps3rom: use 16-bits defined sense codes

Refactor the PS3 DVD driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h.

> diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
> index a9c727d229313..c63c581b493c3 100644
> --- a/drivers/scsi/ps3rom.c
> +++ b/drivers/scsi/ps3rom.c
> @@ -233,7 +233,8 @@ static enum scsi_qc_status ps3rom_queuecommand_lck(st=
ruct scsi_cmnd *cmd)
>  	}
> =20
>  	if (res) {
> -		scsi_build_sense(cmd, 0, ILLEGAL_REQUEST, 0, 0);
> +		scsi_set_sense(cmd, 0, ILLEGAL_REQUEST,
> +			       NO_ADDITIONAL_SENSE_INFORMATION);
>  		cmd->result =3D res;

[Severity: High]
This is a pre-existing issue, but does this cmd->result assignment overwrite
the status byte set by the sense functions?

Looking at scsi_set_sense() in scsi_lib.c, it sets the result:

void scsi_set_sense(struct scsi_cmnd *scmd, int desc, u8 key, u16 code)
{
        scsi_set_sense_buffer(desc, scmd->sense_buffer, key, code);
        scmd->result =3D SAM_STAT_CHECK_CONDITION;
}

Immediately assigning cmd->result =3D res in ps3rom_queuecommand_lck()
clobbers this SAM_STAT_CHECK_CONDITION status, which could bypass midlayer
sense processing on failed IO requests. Could this assignment be updated
so the midlayer properly sees the check condition?

>  		priv->curr_cmd =3D NULL;
>  		scsi_done(cmd);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D25
