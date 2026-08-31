Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73401CA6F;
	Mon, 31 Aug 2026 02:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788142768; cv=none; b=EL70bnev+q4DkVGpV/5rz8Hlubn+vnRLMynr2P+9Gcm8ylQPmBc7lBbynhIPWHnWzp6Ndv/qV/s3LwgbtPIstpu0Btl9YjNMRQqIPv6MWfJIWXWkno8QA0p8FaSHoowQ2bGpXJht1bktBZh3Iaugs7Zoui/bC03/qCHSGa3IAlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788142768; c=relaxed/simple;
	bh=ILSOUD2sU+e5Qaj73r/+7uPRbIlLolGrm1XTaEROp7g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P+DuJNSD7X5NSfoBQhqcYySgr4XKtZ7BQsfwNy4L1TM27wEfOXNyEV9/bvaFgADK5ivqusjfxhUzhyej3bU1rSpasCKHhsmyc+ujix6o8yTe3ZM/AJ/Y3Fc4V1qHE/n3VBn1yYUcYAH0mU5j7usjRh2hFKpxi/7TzW3VZeNqaXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OoWR5Zlx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OoWR5Zlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EBC1F000E9;
	Mon, 31 Aug 2026 02:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788142767;
	bh=fuo49Qfms8JOA+LBe0rAdwrCzYNJN3CyBCBufb0dW1E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OoWR5ZlxkrH3FSridIrN6j4VvS5gSCyTM6Tzm1J/q8OYbGg8cax0pOcobOywaQq00
	 Q3yPy57WKmOeEnVdBUEUnvI5J23FkCSM3Wmb2gO5cUK4U2JLRcNSUwWlpYpMp4q8jE
	 9f8KPUOU6wZlOyGFpVbuHCXttvZV+zvgL6waD/yth8tl4KQzJSyblIXrxFwKm4s2ku
	 PEvvl2oyuBG83Dfw+X3LmACb2t0Cvcwd4Q2tdbjwst/AYdpZHB+3OdCHhkckMIaqa9
	 L3lE8a3UHSVcoQU5iCkn7vCCtmJgmyjBSjMXoodP3A0K9lLm3+Gzf2HsTHQtcy5O/E
	 QGQ1Qf//eYHgg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 17/37] scsi: mpt3sas: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, linux-ide@vger.kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260831020451.585944-18-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
 <20260831020451.585944-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 02:19:26 +0000
Message-Id: <20260831021926.C0EBC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Data race on static local variable 'rc' in _scsih_determine_dispos=
ition causing erratic device discovery states.
--

commit 494f343d73ff2ef15d8e6f7b1ea653d86adb0fd3
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: mpt3sas: use 16-bits defined sense codes

This commit refactors the mpt3sas driver to replace hard-coded sense codes
with the enum values defined in include/scsi/scsi_sense.h. This improves
code clarity and self-documentation.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 0e12009a87f62..085d4672db854 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
[ ... ]
> @@ -7691,38 +7691,41 @@ _scsih_determine_disposition(struct MPT3SAS_ADAPT=
ER *ioc,
> =20
>  	if (check_sense) {
>  		_scsih_normalize_sense(transfer_packet->sense, &sense_info);
> -		if (sense_info.skey =3D=3D UNIT_ATTENTION)
> +		if (sense_info.skey =3D=3D UNIT_ATTENTION) {
>  			rc =3D DEVICE_RETRY_UA;

[Severity: High]
This is a pre-existing issue, but I noticed a potential data race involving
the variable rc in this function. At the beginning of
_scsih_determine_disposition(), it is declared as a static local variable:

static enum device_responsive_state rc;

Because this variable is static, it is shared across all concurrent executi=
ons
of the function. If multiple threads (such as from asynchronous SCSI scanni=
ng
or event handlers) execute this concurrently, could one thread overwrite the
disposition state calculated by another?

If this overwrite occurs, would it cause devices to be incorrectly marked
offline, skipped, or subjected to invalid retry loops? Does this variable
need to be static, or can it be changed to a standard local variable?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831020451.5859=
44-1-dlemoal@kernel.org?part=3D17
