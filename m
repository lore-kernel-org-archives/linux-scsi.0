Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D48376BD9;
	Mon,  7 Sep 2026 02:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749858; cv=none; b=rm+mNp7VaaYu5TTNHhJzVbFT5VrX+jjA7ugD1UrFH3uaQykKy6GCE8vaJDiQzfcMEe/2RMWVJBoVfepCll6QU4Eqtwv5yQbNG8/4laHQbYl9MELt2FsiFCgh0IuZmjSAWQwO0Kaouq9ohN3/LPN1JizMFuEa4In03Vy5KW9i22M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749858; c=relaxed/simple;
	bh=7Ga1IbCUJvrbMQGhCfanw9QNNCkpkFVb2ThBYDvBRfM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dVjs8sRExmE94SQSWX8LZ4/KxO2DD/a5JLzv+4oKLdRwZx38ISitXZWG6zHxMeY0Vl8nFEIWAAg2wruvQKG1K55o/JhzyDamBJ1zU/2TRIq/XVsZgCdKZtowgF+WuZxIO+tcBDdUIkTPSBtgHIB8R+dUloFhBsCKg87dRR6fHOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EKJ6Bj5V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EKJ6Bj5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7021F00A3A;
	Mon,  7 Sep 2026 02:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749857;
	bh=ZSfpIfV2hNZ2F1F/W2cZDkI7MtcOYXkV0lSGTzlSIQ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EKJ6Bj5V3LU6gMrWXLrrH6HNEIOc69yHBbkavNdx0CwWBgFEBQGOo29SD7GHS/c7V
	 J9JW3OcagHErFXVlg8u6YdTesyrDYkWw8pDswiSKAvAKkrJBQ4Gk0kJXkl7Cvd9ETA
	 kF6eWw8ybeYgtMW57pqugyPu+bqAfrKC8EImpwTm6/BQfYMBA9saQ2meQXikqeR+VA
	 l6+480onbUgqZQljlIY9mdNown7RFhxbNKKRk7M89L+R5hDHjdw7aZmZONtm9KSUJb
	 1SslFM4UNFu4hT9/qPOOIuhPYcri1iTD39tQ6RE+97cVXDWxpkP+cbpx7kTVycltSk
	 tWKRs/+9jTbHw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 16/40] scsi: device_handlers: alua: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260907024343.1046387-17-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-17-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:57:36 +0000
Message-Id: <20260907025736.CA7021F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Uninitialized stack memory `sense_hdr` is unconditionally evaluate=
d in `alua_tur()` if `scsi_test_unit_ready()` fails locally.
--

commit 8e77c706432e156d81e3b3bd7cdc9af0c2b4cc23
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: device_handlers: alua: use 16-bits defined sense codes

This commit refactors the SCSI ALUA device handler driver to use the 16-bit
sense_code field of struct scsi_sense_hdr. It replaces hard-coded ASC and
ASCQ values with enum constants from include/scsi/scsi_sense.h to improve
code clarity. No functional change is intended.

> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/de=
vice_handler/scsi_dh_alua.c
> index d81ec47a71402..87ac0a6d63e54 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c

[ ... ]

> @@ -517,12 +499,12 @@ static int alua_tur(struct scsi_device *sdev)
>  				      ALUA_FAILOVER_RETRIES, &sense_hdr);
>  	if ((sense_hdr.sense_key =3D=3D NOT_READY ||
>  	     sense_hdr.sense_key =3D=3D UNIT_ATTENTION) &&
> -	    sense_hdr.asc =3D=3D 0x04 && sense_hdr.ascq =3D=3D 0x0a)
> +	    sense_hdr.sense_code =3D=3D
> +	    LU_NOT_ACCESSIBLE_ASYMMETRIC_ACCESS_STATE_TRANSITION)

[Severity: High]
This is a pre-existing issue, but does this evaluate uninitialized stack
memory if scsi_test_unit_ready() fails locally?

Looking at alua_tur() in drivers/scsi/device_handler/scsi_dh_alua.c:

static int alua_tur(struct scsi_device *sdev)
{
        struct scsi_sense_hdr sense_hdr;
        int retval;

        retval =3D scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
                                      ALUA_FAILOVER_RETRIES, &sense_hdr);

The sense_hdr variable is declared on the stack without initialization. If =
the
underlying request allocation fails or the queue is dying,
scsi_test_unit_ready() will return a negative error code (e.g., -ENODEV or
-ENOMEM) without zeroing or populating the sense_hdr buffer.

This condition then unconditionally evaluates sense_hdr.sense_key and
sense_hdr.sense_code before checking if retval indicates a local failure.

If alua_tur() is called from a multipath workqueue thread immediately after=
 a
previous successful ALUA state transition check on another LUN, the stack
memory will identically retain the previous struct's values. This
uninitialized read could match the condition perfectly, causing alua_tur() =
to
wrongly return SCSI_DH_RETRY instead of the expected SCSI_DH_IO for a local
error, severely delaying multipath failover.

>  		return SCSI_DH_RETRY;
> -	else if (retval)
> +	if (retval)
>  		return SCSI_DH_IO;
> -	else
> -		return SCSI_DH_OK;
> +	return SCSI_DH_OK;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D16
