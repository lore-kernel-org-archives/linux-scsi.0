Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04154E4C3C;
	Fri,  9 Oct 2026 16:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563906; cv=none; b=dXzYwi1Xvn0jgKgwDBresoD06k7t14OjwUD0GLovua0kgiJYPtRYjBHVsu5QixCroA+F6fjJfnU15FvjQCWg8N7kU12leFBP9ehMyaW/MQCy63GZiMsqJAB3UcuWKB8WsbASXEF2p+h4COeN+Jy72SntEa1vxSUPiW/IzqPDO5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563906; c=relaxed/simple;
	bh=NfSucG79LRADeG7ejg6zfGCYroXlLSquvpyopIhoMrs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LCDeJmHbPp5dx/5yrl4U2v7RQGXH8eStw2wzaop7ThSUuiNkSe7uHMjVFUz3VyapUcQ8pZbttT+cmP+LSQDLWs4RtWL3UA4i4KXEHUFYU+ejj1/TcwS7lHrfXHK7oiK5UhGOAkeMByPqVQfYZrklZdvywHbX90QhZp89gzZTfpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PzVhE99a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PzVhE99a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A462B1F00893;
	Fri,  9 Oct 2026 16:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791563901;
	bh=VfXIBqEIOCnQXRlORVX47ChEpphBC/v1MW44gdTeyUo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PzVhE99agOuK9C9ceCMwfw/yflSYVUOOs2GXdY28Tmo28lV3fH7Vk6JUSIuvut3N7
	 slS18gj14GGbQgNguE3MLyuWM+FIfICa56guD/0lYME7TB5u1poa2Bx+HZHoV9fG7S
	 SVDNj6UQbTpMznL3RRrAW1XCyqbS7NoQW6HJtJf32ik4XuZ4nv03lONbNSjbCbOXQT
	 YezAtp/hQp6ycuvUMDiST+8qNgB9xA6QBqIfj3TF7PEYtIxE0+EBPtchCqL2/m+ZXN
	 vRYjoH3I8ZYILi+TCA3sG7Ub475UYxTPodoqK/dQQVibJk3SMbi7NXWPwq3h3n9aPQ
	 J5Z+hB3Fr781g==
Message-ID: <sashiko-outbox-165837@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 13/15] scsi: add BLIST_NO_LUN_1F blacklist flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Phil Pemberton" <philpem@philpem.me.uk>
Cc: linux-scsi@vger.kernel.org, cassel@kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20261009155522.593045-14-philpem@philpem.me.uk>
References: <20261009155522.593045-1-philpem@philpem.me.uk>
 <20261009155522.593045-14-philpem@philpem.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 16:38:21 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: single_lun bitfield data race with expecting_lun_change
--

commit 15aed878e542873ad45c1f172fe5d87a9c1380de
Author: Phil Pemberton <philpem@philpem.me.uk>

scsi: add BLIST_NO_LUN_1F blacklist flag

This commit adds a new BLIST_NO_LUN_1F blacklist flag to prevent SCSI
scanning from adding spurious "No Device" entries for unpopulated LUNs
reporting PQ=3D0/PDT=3D0x1f. It also safely moves pdt_1f_for_no_lun to a
dedicated boolean to prevent scan-time writes from overwriting concurrent
I/O updates in shared bitfields.

> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 8694eeadd753e..a81a7c8cce18e 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -360,13 +360,13 @@ struct scsi_target {
>  	unsigned int		single_lun:1;	/* Indicates we should only
>  						 * allow I/O to one of the luns
>  						 * for the device at a time. */
> -	unsigned int		pdt_1f_for_no_lun:1;	/* PDT =3D 0x1f
> -						 * means no lun present. */
>  	unsigned int		no_report_luns:1;	/* Don't use
>  						 * REPORT LUNS for scanning. */
>  	unsigned int		expecting_lun_change:1;	/* A device has reported
>  						 * a 3F/0E UA, other devices on
>  						 * the same target will also. */

[Severity: High]
Does leaving single_lun in the same bitfield block as expecting_lun_change
still leave us vulnerable to read-modify-write tearing?

While this patch correctly identifies the tearing risk and moves
pdt_1f_for_no_lun to its own bool, single_lun is also updated at scan time
in scsi_add_lun() under shost->scan_mutex:

drivers/scsi/scsi_scan.c:scsi_add_lun() {
    ...
    if (*bflags & BLIST_SINGLELUN)
        scsi_target(sdev)->single_lun =3D 1;
    ...
}

While LUN 1 (or later) is being scanned, LUN 0 is already visible and can
process I/O. If an I/O on LUN 0 triggers a Unit Attention or completes a
REPORT LUNS command, softirq block completion context updates
expecting_lun_change without holding scan_mutex:

drivers/scsi/scsi_error.c:scsi_report_lun_change() {
    ...
    sdev->sdev_target->expecting_lun_change =3D 1;
    ...
}

Because both fields share the same memory word, the scan-time update to
single_lun can silently overwrite and erase the concurrent I/O update to
expecting_lun_change, leading to dropped I/O retries, spurious I/O errors,
or loss of single_lun serialization.

This race is explicitly triggered by follow-up patch 15 in this series,
which introduces a quirk setting BLIST_SINGLELUN for a multi-LUN device
(COMPAQ PD-1).

Should single_lun also be moved to a separate bool to completely resolve
this bitfield race?

> +	/* Keep scan-time writes separate from I/O-updated bitfields. */
> +	bool			pdt_1f_for_no_lun; /* PDT =3D 0x1f means no LUN. */
>  	/* commands actually active on LLD. */
>  	atomic_t		target_busy;
>  	atomic_t		target_blocked;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009155522.5930=
45-1-philpem@philpem.me.uk?part=3D13
