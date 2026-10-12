Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7664427FB9
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 21:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791840422; cv=none; b=bB4EdP/ZusODcvTh4P3tlvWP3ej+FfUu5YvQYeNmqB45npThYlMV6yIhtswYjjtaq4hUMwPUmx2SWUDLi14tCp/h31oQDfyKPDfrxCmY+W2VvGIUJc8oLNNfL81r8O4cRstmGzD/hqk7QQwHSfhT4iifnUYGMU9B/FmbdrtfTs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791840422; c=relaxed/simple;
	bh=+zhcSzxb96glPY1hHeffW/EXU7+hX5fFCT254k4WWb0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=TYlweY2qVZT81tbfPiPtJD7Iu2AZoHWkOg241E7EL+Uwg5tpbxsc7RrdhVv0YLMnq/j6r46x+qtwnddU2dsaJR9YKcprF2spj2Fp6yWXyaSRpolUX6IL3pe4VHbdaZu5WL4ElQJuuBfmiU6KNwmlanQz3sH9RqAmgSG/rUm4PeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fTaaeOzb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fTaaeOzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E7D1F0089B;
	Mon, 12 Oct 2026 21:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791840421;
	bh=qOXCT8pJf8nH1h85aNLzWk7vA1XZS/hbS2mnV1wmfA8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fTaaeOzbFbCVkEswiwrvYJB/d8N2+7FhNOWlqErRd+DKlI3fI+Juk1FG/XgTlP1Ul
	 Hb18XMiGCqKJeat9A7ZUSyS93QqCDA2xSxDiTdmajBYtMXu522uB1W/AbzPfGmmyv8
	 Ithvi1ssojrJAEPXfFc8RDkeFaiVHFAOjsV1+QvMFTopG+Qv3wA7kkkMxfQEVY9pPS
	 Lv98/JqLxfjXKeB9vqz928+CHyUKduvt3u4+xJbOm+7CZjohqi2ZsXWAEKNYF8FZdY
	 zcnCn5govjW+F+j02+4g7soZJsf1rHZ6x7qTnREaZ7oQqCrjJUt6KCY17R5n0xzuGC
	 iQuTgdKjOU8OQ==
Message-ID: <sashiko-outbox-168622@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 3/5] scsi: core: Refactor scsi_add_lun() to use
 scsi_update_inquiry_data()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Brian Bunker" <brian@purestorage.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261012210511.16061-4-brian@purestorage.com>
References: <20261012210511.16061-1-brian@purestorage.com>
 <20261012210511.16061-4-brian@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 21:27:00 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi: core: Use-After-Free in lockless INQUIRY readers during resc=
an
- [High] scsi: core: Bitfield data race between INQUIRY capability updates =
and SCSI Error Handler
- [Medium] scsi: core: scsi_update_inquiry_data clobbers BLIST_NOT_LOCKABLE=
 workaround during rescan
--

commit 2b976e6e6ffef889b4ec5235ed09392acc7c67db
Author: Brian Bunker <brian@purestorage.com>

scsi: core: Refactor scsi_add_lun() to use scsi_update_inquiry_data()

This commit refactors scsi_add_lun() to use a new helper,
scsi_update_inquiry_data(), which centralizes INQUIRY parsing. It moves
several capability and identity assignments into the new helper and ensures
consistent handling between initial probe and runtime rescans.

> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 3af9e77847f70..b80378ecf4856 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
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

[Severity: High]
Does this expose concurrent lockless readers to a use-after-free?

During a rescan, the old INQUIRY buffer is freed directly with kfree().

However, there are multiple helpers (like scsi_device_enclosure() used by
SES sysfs traversal, and scsi_device_tpgs() used by ALUA workqueues) that
dereference sdev->inquiry locklessly:

include/scsi/scsi_device.h:scsi_device_enclosure() {
    return sdev->inquiry ? (sdev->inquiry[6] & (1<<6)) : 1;
}

If a rescan is triggered concurrently with ALUA background polling or SES
sysfs reads, these lockless readers could dereference the freed memory.

> +	sdev->inquiry_len =3D inq_len;
[ ... ]
> +	/*
> +	 * Check if this is an ATA device (SATA emulation layer).
> +	 * ATA devices need allow_restart set to work around SATL power
> +	 * management specifications.
> +	 */
> +	if (strncmp(sdev->vendor, "ATA     ", 8) =3D=3D 0) {
> +		sdev->is_ata =3D 1;
> +		sdev->allow_restart =3D 1;
> +	} else
> +		sdev->is_ata =3D 0;
> +
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
Can modifying these bitfields during a rescan corrupt other bitfields via
a data race?

scsi_update_inquiry_data() modifies capability bitfields like is_ata,
removable, and lockable under sdev->inquiry_mutex.=20

However, the SCSI Error Handler modifies operational state bitfields
asynchronously without this lock:

drivers/scsi/scsi_error.c:__scsi_report_device_reset() {
    sdev->was_reset =3D 1;
    sdev->expecting_cc_ua =3D 1;
}

All of these bitfields (is_ata, removable, was_reset, expecting_cc_ua) are
packed into the same machine word in struct scsi_device.

If a device rescan runs concurrently with a bus reset report, the compiler's
read-modify-write operations will race, potentially clobbering either the
device capabilities or the critical error recovery state.

[ ... ]
> +		}
> +	}
> +
> +	/*
> +	 * Set lockable to match removable. Devices with removable media
> +	 * can typically have their media locked/unlocked via the
> +	 * ALLOW_MEDIUM_REMOVAL command.
> +	 */
> +	sdev->lockable =3D sdev->removable;

[Severity: Medium]
Will this unconditionally clobber the BLIST_NOT_LOCKABLE workaround during
a rescan?

During initial device setup in scsi_scan.c:scsi_add_lun(), if a device has
BLIST_NOT_LOCKABLE set, the code forces sdev->lockable =3D 0. However, that
blacklist guard was not moved into scsi_update_inquiry_data() with the rest
of the logic.

When a blacklisted removable device is rescanned, this assignment will
unconditionally overwrite the blacklist override, setting lockable back to =
1.

This could expose broken hardware to ALLOW_MEDIUM_REMOVAL commands,
potentially causing hardware hangs or I/O timeouts.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012210511.1606=
1-1-brian@purestorage.com?part=3D3
