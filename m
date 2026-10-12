Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F27E3CB55E
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 21:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791840439; cv=none; b=LzsitDzSoLbcxiMVIklf4YA8ynx2XhwUORk+j5SIb6eIq1APkA1t/dzS2ZUi3Hkg72W6z33zH+T7eqrZucYYSk/oayYy7D31891gUtAIDt95cvKHAE44Hes2km4UU60q3ZBWbE+kH2JA2hycCDCZdP+x+Ig0sCwfX2m8sy7ATbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791840439; c=relaxed/simple;
	bh=FcT/Jy+SJnPxzLQFUN14JQDZiGBwWQKBeMo3RaJUEQM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=r+XIbwowIt85hq4OgnlVgBOHviaWUziD7rFg4C1ktJDi2AJTU7MPyHrAbEc3c6tThPISYliTrSxMJV/S0icxgpyEiOM9t8iP7R4hfcT/t39M1sAfsDHXBlAU/QAj6a32mxSCDGqXWepX0xL4gbi501uZVKhShs9Hs6kXN3bZRXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nyfMWymx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nyfMWymx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927131F0089B;
	Mon, 12 Oct 2026 21:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791840437;
	bh=j3PmH53PqXGu7yk94cY62QDoKDlhODDtBa2ju3FWzpg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nyfMWymxF3kkjYze5H60PlFuUJtWuUBZtGlebdnUlisq5a2H1DWuk+qeWLEHgmTlw
	 UE7dFeBKPBizrGBsl8zpWulCAbPd42HwKgqzxtrwqp080cE1uVPy5iSMIyT4KU+Fq+
	 Qh/VYk4ncAQqGZlvDW35I4FJUA9CS69NPm4vOGwdE16yc7xHU1f9jM3yNC/vRoQJm+
	 CzgbmlPl68jKnAD9z4gS5lGVTesRSg1qdYNU92wdK70KfrUDEI6qvRaXq2dsS66JKP
	 6T2PBGX6W3vDiVuKFTMs6gL8FGZkzwNBmmcJnWlXc8XA1248Ocof8ZnbdciRjdl5xR
	 XDHSbBjlBuUaw==
Message-ID: <sashiko-outbox-168624@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 2/5] scsi: core: Add scsi_update_inquiry_data() for
 updating INQUIRY data
Reply-To: sashiko-reviews@lists.linux.dev
To: "Brian Bunker" <brian@purestorage.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261012210511.16061-3-brian@purestorage.com>
References: <20261012210511.16061-1-brian@purestorage.com>
 <20261012210511.16061-3-brian@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 21:27:17 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] scsi: use-after-free on inquiry buffer for concurrent lockless rea=
ders
- [High] scsi: data race on struct scsi_device bitfields corrupts concurren=
t state updates
- [Medium] scsi: torn reads of INQUIRY strings in procfs and target during =
rescan
- [Medium] scsi: core: silent truncation of inq_len in scsi_update_inquiry_=
data()
--

commit 8e9aa2b82f339c1aae88807580c6d0982c8177fa
Author: Brian Bunker <brian@purestorage.com>

    scsi: core: Add scsi_update_inquiry_data() for updating INQUIRY data
   =20
    Add a new function scsi_update_inquiry_data() that can safely update all
    INQUIRY-derived fields for an existing SCSI device:
   =20
    - Vendor, model, revision strings
    - Peripheral qualifier and device type
    - Capability flags (removable, lockable, tagged queuing support, etc.)
    - ATA device detection and allow_restart setting

> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 3af9e77847f70..b80378ecf4856 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
[ ... ]
> @@ -549,6 +550,183 @@ void scsi_attach_vpd(struct scsi_device *sdev)
[ ... ]
> +int scsi_update_inquiry_data(struct scsi_device *sdev,
> +			     unsigned char *inq_result, size_t inq_len)
> +{
[ ... ]
> +	had_prior_inquiry =3D (sdev->inquiry !=3D NULL);
> +	old_type =3D sdev->type;
> +	old_periph_qual =3D sdev->inq_periph_qual;
> +
> +	kfree(sdev->inquiry);
> +	sdev->inquiry =3D new_inquiry;
> +	sdev->inquiry_len =3D inq_len;

[Severity: High]
This frees and replaces the existing sdev->inquiry buffer dynamically on a
live device. However, there are multiple existing paths that read the inqui=
ry
buffer locklessly, such as inline subsystem helpers in
include/scsi/scsi_device.h:

scsi_device_enclosure() {
    return sdev->inquiry ? (sdev->inquiry[6] & (1<<6)) : 1;
}

Since these lockless readers do not acquire inquiry_mutex and there is no R=
CU
protection, can a concurrent I/O path or sysfs read dereference the freed
inquiry pointer, resulting in a use-after-free? Furthermore, do these
non-atomic updates to the pointer and its length expose lockless readers to
torn state?

[Severity: Medium]
sdev->inquiry_len is an unsigned char (8 bits), while inq_len is a size_t.
If a manual rescan passes an inq_len of 256, will this assignment silently
truncate the length to 0, causing the device's sysfs inquiry attribute to
return 0 bytes?

> +	strscpy(sdev->vendor, sdev->inquiry + INQUIRY_VENDOR_OFFSET);
> +	strscpy(sdev->model, sdev->inquiry + INQUIRY_MODEL_OFFSET);
> +	/*
> +	 * memcpy() instead of strscpy() because strscpy() would read past
> +	 * the end of sdev->inquiry if its length is exactly 36 bytes.
> +	 */
> +	memcpy(sdev->rev, sdev->inquiry + INQUIRY_REVISION_OFFSET,
> +	       INQUIRY_REVISION_LEN);

[Severity: Medium]
This patch makes the INQUIRY string arrays mutable at runtime. While the
updates are protected by inquiry_mutex, unprotected readers like procfs and
the PSCSI target read these character arrays without acquiring the newly
introduced inquiry_mutex:

proc_print_scsidevice() {
    for (i =3D 0; i < 8; i++) {
        if (sdev->vendor[i] >=3D 0x20)
            ...
}

Will unprotected readers race with these non-atomic strscpy() updates, caus=
ing
torn reads that expose mixed or garbled strings?

> +	sdev->rev[INQUIRY_REVISION_LEN] =3D '\0';
> +	sdev->inq_periph_qual =3D (inq_result[0] >> 5) & 7;
[ ... ]
> +	/*
> +	 * Update device type from INQUIRY byte 0.
> +	 * BLIST_ISROM is a quirk for devices that report wrong type but should
> +	 * be treated as (removable) CD-ROM. Override to TYPE_ROM as exception.
> +	 */
> +	if (sdev->sdev_bflags & BLIST_ISROM) {
> +		sdev->type =3D TYPE_ROM;
> +		sdev->removable =3D 1;
> +	} else {
> +		sdev->type =3D inq_result[0] & 0x1f;
> +		sdev->removable =3D (inq_result[1] & 0x80) >> 7;

[Severity: High]
These assignments update capability bitfields (e.g., is_ata, removable,
lockable) on a live device while holding only inquiry_mutex. In
struct scsi_device, these capability bitfields are packed into the same mem=
ory
word as highly dynamic operational state bitfields:

unsigned is_ata:1;
unsigned removable:1;
unsigned changed:1;     /* Data invalid due to media change */
unsigned busy:1;        /* Used to prevent races */

Since other subsystems modify the operational bitfields without holding
inquiry_mutex (for example, scsi_test_unit_ready() sets sdev->changed =3D 1=
 in
softirq context), does this cause a non-atomic read-modify-write on the sha=
red
word? Could this race overwrite and lose critical runtime state changes like
media change notifications?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012210511.1606=
1-1-brian@purestorage.com?part=3D2
