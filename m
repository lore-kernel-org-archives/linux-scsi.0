Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468AF486E7E
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 21:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791840246; cv=none; b=dRCuYxqzkkAkn4caHXKpCynBjlsUDi0OSrK5VP2rRkfzjmwlLjxP2ChqEgfSSFkqBCikoI2ETxDAa3WwEVjB52rt843Wr38yMBWGg0GzQAeLPYmvSKF2DsF+u0NcgNjVod/d7682b6b2TJiLR/4FAeDaWrxwZ8WLsQ/o49yj8TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791840246; c=relaxed/simple;
	bh=v06i26OedSfhkZAka6TkoEIfzij147eS8Ci5BYUcrrU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=qyPCGIktBSduvRWuBJuI+lZQGPbCiOmoZMOJyweNs/qhmVeCCdioUjru42YKyrqkz+aU+xFAMl4U5pz4LbFSoD1qpRGZvZ1daJ56e0WanvoApzDwQat7acvJrhf3s9NQtfYHudlQgH9uuJsCTx77pJLWcrJ3nBng9ERu6rlGtLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtbiYi0G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtbiYi0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A0A1F0089B;
	Mon, 12 Oct 2026 21:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791840245;
	bh=ZTyL5Y6AU14mYKj6schSxB2wZqf4CVifBBMTd58K7bE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dtbiYi0GvHh9f2haZzkRJ4453jf9SYSNAYoQa99/0kKEguItnZlGHtMdmrkIuAXXy
	 4RbCX17HEQkO3s61d5AEkq7osK2QZdtT4/m1RC3mOof+0pii+1I109A9azCr0Bji3v
	 mOt76SW2MPO/prBvvorojcbvEAP8DtvdHRusYIZVlEhTYVnKVHJEN3wh7A+rCc/g6D
	 vw3FtwaT7EWBSl55BRge1tFcAWLKjQPHHxktqEfa0EJxDYAaLF9imMh+HIXUaTYMT/
	 0GJtsADRxAqNCKiZhF88sSw2i91LEqoljdbzsNXcpt5Cn16mdyiBfa9nXUKLrl7b/w
	 nimNuTTrYZaeg==
Message-ID: <sashiko-outbox-168619@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 5/5] scsi: core: Handle reprobe for existing devices
 during SCSI scan
Reply-To: sashiko-reviews@lists.linux.dev
To: "Brian Bunker" <brian@purestorage.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261012210511.16061-6-brian@purestorage.com>
References: <20261012210511.16061-1-brian@purestorage.com>
 <20261012210511.16061-6-brian@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 21:24:04 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi: sysfs duplicate filename and list corruption from duplicate =
scsi_device allocation
- [High] scsi: UAF and NULL pointer dereference in __scsi_reprobe_inquiry d=
ue to missing device_lock
- [Medium] scsi: scsi_device reference leak on reprobe of pseudo devices
--

commit ba325f494bfb24c08935735dfa22078230cda945
Author: Brian Bunker <brian@purestorage.com>

scsi: core: Handle reprobe for existing devices during SCSI scan

Complement scsi_rescan_device() reprobe by handling the scan path.
Update INQUIRY data and reprobe existing devices when standard INQUIRY
data changed.

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index ddb92282d49ff..6df140d3c7482 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1215,7 +1216,32 @@ static int scsi_probe_and_add_lun(struct Scsi_Host=
 *shost,
>  	 */
>  	sdev =3D scsi_device_lookup_by_target(starget, lun);
>  	if (sdev) {
> -		if (rescan !=3D SCSI_SCAN_INITIAL || !scsi_device_created(sdev)) {
> +		if (rescan =3D=3D SCSI_SCAN_INITIAL && scsi_device_created(sdev)) {
> +			/*
> +			 * Initial scan found device in CREATED state (being probed
> +			 * by another thread). Drop reference and allocate new -
> +			 * the other thread will complete setup of the original.
> +			 */
> +			scsi_device_put(sdev);
> +			sdev =3D scsi_alloc_sdev(starget, lun, hostdata);
> +			if (!sdev)
> +				goto out;

[Severity: High]
Does allocating a new device here create a duplicate device for the same LU=
N?

Since scsi_alloc_sdev() blindly adds the new device to the starget->devices
list and the original device is still on the list, both threads will proceed
to call scsi_add_lun() and invoke device_add(). This guarantees a sysfs
duplicate filename collision and failure. Additionally, subsequent lookups
using __scsi_device_lookup_by_target() will permanently intercept and return
the dummy device at the head of the list instead of the successfully probed
one.

[ ... ]

> +		} else if (rescan !=3D SCSI_SCAN_INITIAL && !scsi_device_created(sdev)=
) {
> +			/*
> +			 * Manual rescan of fully initialized device.
> +			 * Reprobe to detect peripheral qualifier or device type
> +			 * changes (e.g., ALUA state transitions).
> +			 */
> +			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
> +				"scsi scan: device exists (type %d, PQ %d), reprobing\n",
> +				sdev->type, sdev->inq_periph_qual));
> +			is_reprobe =3D true;
> +		} else {

[ ... ]

>  	if (scsi_device_is_pseudo_dev(sdev)) {
>  		if (bflagsp)
>  			*bflagsp =3D BLIST_NOLUN;
>  		return SCSI_SCAN_LUN_PRESENT;
>  	}

[Severity: Medium]
Will this early return leak a scsi_device reference when is_reprobe is true?

When a manual rescan encounters an existing pseudo device, the code sets
is_reprobe to true and retains the extra kobject reference acquired by
scsi_device_lookup_by_target(). By returning directly here, it bypasses the
cleanup block at the end of the function where scsi_device_put(sdev) would
drop the lookup reference.

[ ... ]

> +	/*
> +	 * For reprobe scenarios, update the inquiry data with fresh
> +	 * INQUIRY results. The device already exists in sysfs, so we
> +	 * don't call scsi_add_lun() which would try to add it again.
> +	 */
> +	if (is_reprobe) {
> +		bool need_reprobe =3D false;
> +		int update_ret =3D __scsi_reprobe_inquiry(sdev, result, result_len,
> +							&need_reprobe);

[Severity: High]
Does this __scsi_reprobe_inquiry() call lack the required device_lock()?

This reprobe path calls __scsi_reprobe_inquiry() while holding only
shost->scan_mutex. Inside __scsi_reprobe_inquiry(), dev->driver is checked
and then dev->driver->owner is accessed for try_module_get() before invoking
the driver's rescan callback. Because device_lock(&sdev->sdev_gendev) is
not held, a concurrent sysfs unbind operation or module unload can detach t=
he
driver and clear dev->driver immediately after the check, leading to a NULL
pointer dereference or use-after-free on the freed driver module.

> +
> +		if (update_ret < 0) {
> +			res =3D SCSI_SCAN_NO_RESPONSE;
> +			goto out_free_result;
> +		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012210511.1606=
1-1-brian@purestorage.com?part=3D5
