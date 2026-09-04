Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6773A28373;
	Fri,  4 Sep 2026 02:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788489707; cv=none; b=oPTFGz7XAYgY3AIVXJaxdjk5QExxoqGQ9spRoYNUNUBqVwU8pHrXgz7aKvEtYMPm8AKfw5I1KRc/YyU/HDeX7Tggaf/woQjb48MaF7m9mzPtfjauyHW2QG9wEE29fx6H8gonC1SUBoj5HGUyP4wjEVtTybGCveiG+yg71Vnb538=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788489707; c=relaxed/simple;
	bh=YK3Rc3TOaBMW4dCR3pIdmel7esO/dYFA5TnDb4CEefI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Q79cu9Z6XBSNyehxs7awHKuZc6yZ4LLRuc5WfeBb4obs4SFAGG/k939RXQn/K0Vuk9nDvWhIDvEzqFaQJLXZPj7dUimWAS8ADqY0DSKlMmyUQ9cRWovq5M3Y4kLwHGUDd0B7dCBamdYYIGeo7skieU2Y8bHDJdF/30n8Pw0A/Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=erhm8fiZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="erhm8fiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8111F000E9;
	Fri,  4 Sep 2026 02:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788489706;
	bh=Q8ifSXZEBc+KgNtG3dGwgxSVio/DdYEJuTtAu0+uIqY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=erhm8fiZ8wpRKOvxxFSZpvzR9+AuHf2FuG+yAxZZ2DFGjnJbHmX0pEL82FHcShwWm
	 cX/tIjKOCbIQIwTuBkGCMJ+Jw4Rm403LVEw8p50Pr1n1QruK8u8wo9d1U9wUCQELZu
	 ssWI2TY4K0k1ZG3jwcGsDFoFJQs/S4WHWNBu+0KtnD7L6QFJwX8UtlD5chQGkoROa/
	 T071vf5jR65uMoQEyPU2saW3ApcwXIxIoBIruAQCKgVLhQcZdoyDdYyEljblvNJpT/
	 1VCmn1jf+LWiAF6W9RwUoqS6+4Xm2hZGqmqVy/2Oj/NrJ187NGqTs9wJjS7FTp9oCy
	 8BUM/ees1/qzA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 33/40] scsi: storvsc: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260904002644.157668-34-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-34-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:41:45 +0000
Message-Id: <20260904024145.CD8111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Uninitialized stack variable `sense_hdr` is read in `storvsc_handl=
e_error()` if a command completes with `scmnd->result =3D=3D 0` but `vm_srb=
->srb_status` triggers an error.
--

commit d3f92ba91ef108f8874548b0b418a3d64212ceaf
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: storvsc: use 16-bits defined sense codes

This commit refactors the storvsc driver to use the 16-bit sense_code field
from struct scsi_sense_hdr instead of hardcoded additional sense codes. This
improves code clarity by using defined enum values from scsi_sense.h.

> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index ef3cd3bc7390e..625db97d1a03e 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c

[ ... ]

> @@ -1141,8 +1145,7 @@ static void storvsc_command_completion(struct storv=
sc_cmd_request *cmd_request,
>  	}
> =20
>  	if (vm_srb->srb_status !=3D SRB_STATUS_SUCCESS) {
> -		storvsc_handle_error(vm_srb, scmnd, host, sense_hdr.asc,
> -					 sense_hdr.ascq);
> +		storvsc_handle_error(vm_srb, scmnd, host, &sense_hdr);

[Severity: High]
This isn't a bug introduced by this patch, but does this pass an
uninitialized stack variable to the error handler?

Looking earlier in storvsc_command_completion() in
drivers/scsi/storvsc_drv.c, the sense_hdr stack variable is only populated
if scmnd->result is non-zero:

        struct scsi_sense_hdr sense_hdr;
        ...
        if (scmnd->result) {
                sense_ok =3D scsi_normalize_sense(scmnd->sense_buffer,
                                SCSI_SENSE_BUFFERSIZE, &sense_hdr);
        ...

If an error occurs where vm_srb->srb_status triggers an error
(e.g., SRB_STATUS_INTERNAL_ERROR) with SRB_STATUS_AUTOSENSE_VALID set,
but scsi_status is 0, then scmnd->result will also be 0.

Because scsi_normalize_sense() is bypassed, sense_hdr remains completely
uninitialized. storvsc_handle_error() will then evaluate this uninitialized
memory:

storvsc_handle_error()
    if (sshdr->sense_code =3D=3D CAPACITY_DATA_HAS_CHANGED) {
        ...

If the garbage data doesn't randomly match the checked sense codes, the
function returns without setting DID_ERROR.=20

Can this result in the SCSI midlayer receiving a supposedly successful comm=
and
with 0 bytes transferred, resulting in an infinite IO retry loop for that
request?

>  		/*
>  		 * The Windows driver set data_transfer_length on
>  		 * SRB_STATUS_DATA_OVERRUN. On other errors, this value

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D33
