Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9949351C04;
	Thu,  3 Sep 2026 03:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407932; cv=none; b=PoyCc3qNL4KwqKCvKunrBS16nLfDOkqLR2CGuWQAjc+n0BHSjDb7oQGC44ydJVUQ1dol9v37LFbPAmCCAoRMUvj3c/uMIEsBAI7fnmRgLH7+iViGRcgBVyuBwbHdNdsoMhdUgtzIfp5+fMh2JW8dU2GX0ZIuIAI/ktvy7kIzBss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407932; c=relaxed/simple;
	bh=4lga6W/1bPEuuy1RXxA7BGdWMZh68fZEQlpf0kYZJ0g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JHmWJJ09/k+L194L6egvL602BXjDrRiQquLN3kvcAsahxeP7UC8ClIfBOy+Jqm2xtDff+SWHa95maX71QEQlrzW+Iwy2kN2zN7SNvr0lPst+SEblKMOOQhiZ6xPYNBLxPA9dyIW5kgSFUPNuU7oljvWdL59dsrMld662LbDPbdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+yK2QyK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+yK2QyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9581F000E9;
	Thu,  3 Sep 2026 03:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407931;
	bh=PmNRBLS1fQvJRQ0ED5ctwE5K+Za3+WBNAe1P5LzVgUg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z+yK2QyKpJYUCquLWsBhXOe3qwgRr8hBdtUHuJtVGa9+QUSRPSjuLsWASX0EILDLk
	 QnAgiddZKuzTHk7EGN1kaw+oxf3YvYvuXrc2Ilfnygfz8b9CVMpQ5vXJ/YJqK3v3Fw
	 3A/CU7CBjDGH1tJ3HN+tkS64AM3JnQ/gUNBhfQwLAPWgzxyh8GQdjQ5GwXMQMYIbxL
	 BnkUe7/cAZ4lA+5/J5d6hCC07ROMG2rgHIdgpY1XXhhj+q9blN9lIKf+iv0MBTBv6U
	 THmMu+Gj9+f8DfqCg11tfaWFyPPzsTaTiC9rkDoTYKeeNhrnGtfZRfuu06zarIJtvs
	 /bpCn08r0T3Gw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 33/40] scsi: storvsc: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260903034201.112211-34-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-34-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:58:50 +0000
Message-Id: <20260903035851.0C9581F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `sense_hdr` structure is read uninitialized in `storvsc_handle=
_error` if a command completes with `scsi_status =3D=3D 0` but an SRB error=
 status and the AUTOSENSE_VALID flag set.
--

commit 08f20503dd93893c68326306a042bfdb6e31394b
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: storvsc: use 16-bits defined sense codes

This commit refactors the storvsc driver to use the 16-bit sense_code field
of struct scsi_sense_hdr and replaces hard-coded additional sense codes with
enum values defined in include/scsi/scsi_sense.h.

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
This isn't a bug introduced by this patch, but does passing &sense_hdr here
risk reading uninitialized memory if the command completes with
scsi_status =3D=3D 0?

In storvsc_command_completion(), sense_hdr is declared on the stack without
initialization. It is only populated if scmnd->result is non-zero:

storvsc_command_completion() {
        struct scsi_sense_hdr sense_hdr;
        ...
        if (scmnd->result) {
                sense_ok =3D scsi_normalize_sense(..., &sense_hdr);
                ...
        }

        if (vm_srb->srb_status !=3D SRB_STATUS_SUCCESS) {
                storvsc_handle_error(vm_srb, scmnd, host, &sense_hdr);

If the Hyper-V host returns scsi_status =3D=3D 0 but an SRB error occurred
(for example, with AUTOSENSE_VALID set), storvsc_handle_error() is called
with the uninitialized sense_hdr.

Inside storvsc_handle_error(), this leads directly to evaluating uninitiali=
zed
stack memory when checking sshdr->sense_code for CAPACITY_DATA_HAS_CHANGED
or other statuses.

>  		/*
>  		 * The Windows driver set data_transfer_length on
>  		 * SRB_STATUS_DATA_OVERRUN. On other errors, this value

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D33
