Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811CC3A7F6B
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 22:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792016265; cv=none; b=RCgYUnj/1lq9zxwgLIneK8XKi+bgo6TlFAkdw4tbbEHPL4OYMu5xe69Eggd9Xn/rtvR0lHrUwCkhoGiqWH4YNNYIql19i+heBoFd5/psNUId5FQRjaIOyEfHpad8xCj+jdtwbnhgrqxc8nOYPDlLZNR0LRpHht1HhPJxa7GB/20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792016265; c=relaxed/simple;
	bh=y4EJohW+88Mf3lZ6Voe9atAU6EcjbZfLUad9jB9ICxI=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=BekxA57knSl1uRJD5vIwCpNPGEXkKCLEKwCoHhJcNXH8Qoyu/ArsI2QtXY8OktJoTlpuUk9tinWltNz3u/9jxOpXsgUrRXZvDG/+IkMAiM2zV9ChJJBfIS8oN3apkV7lfJonv87eSNrWyxem4FvglHbptUllZYjmcypVYSaC8t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIoYHv8m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIoYHv8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC611F000C4;
	Wed, 14 Oct 2026 22:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792016264;
	bh=ObDA27xOAUerVVpJWsCNLbL40kN4JhKLExq3Wv5bvbw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=MIoYHv8mkXVsj4u6Fj9rUcxr+E1q5Tmwxvi6RjKTkxZkKyg1aheUL/isfUXIgHQW6
	 pdp3BRM5kpnZIxIJvfys92r9qGhGSvWLMBhePLu9hkOZrBYY1ViYXZTV4VD787miHH
	 L6ungZ+XYR4JlV0trEQswBJ3K9efBmht1msKrQT+1e2c9+KGbfzz2eADazPV92WKJ6
	 4g/ctsNNpHuaANWiECO69n8sGhpZ2rJDdKJaYKMLuqHjAXwj94unuZZXR5QrDVRNMa
	 U5ecpDs0+Mston+OVN8ujtyuasiFLI/y1trzIopqGAHXn0ZHF1uT9qvoUogeIv8TJj
	 WEYmYP5uP68FA==
Message-ID: <sashiko-outbox-171958@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 4/5] scsi: core: Add device reprobe support to
 scsi_rescan_device()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Brian Bunker" <brian@purestorage.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261014220014.94330-5-brian@purestorage.com>
References: <20261014220014.94330-1-brian@purestorage.com>
 <20261014220014.94330-5-brian@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:17:43 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi: data race in scsi_rescan_device() due to missing state_mutex
- [High] scsi: data race on Scsi_Host bitfield in scsi_probe_lun() clobbers=
 tmf_in_progress
- [Medium] scsi: bitfield data race in lun_in_cdb on live device rescan
--

commit 0c2ca40c3d438ceb73cba9f08912149462c2d8ba
Author: Brian Bunker <brian@purestorage.com>
scsi: core: Add device reprobe support to scsi_rescan_device()

Updates INQUIRY data on rescan and calls device_reprobe() if the peripheral
qualifier or device type changes. Handles ALUA unavailable state.

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 93a8719fcf265..2c848265c9b9c 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
[ ... ]
> @@ -815,14 +820,14 @@ static int scsi_probe_lun(struct scsi_device *sdev,=
 unsigned char *inq_result,
[ ... ]
> -	if (sdev->inquiry_len < 36) {
> +	if (inquiry_len < 36) {
>  		if (!sdev->host->short_inquiry) {
>  			shost_printk(KERN_INFO, sdev->host,
>  				    "scsi scan: INQUIRY result too short (%d),"
> -				    " using 36\n", sdev->inquiry_len);
> +				    " using 36\n", inquiry_len);
>  			sdev->host->short_inquiry =3D 1;

[Severity: High]
Because this function is now called for a live device by scsi_rescan_device=
()
(via scsi_refresh_inquiry()), could this assignment to the short_inquiry
bitfield race with updates to adjacent bitfields in struct Scsi_Host?

The short_inquiry bitfield is in the same machine word as tmf_in_progress
and other dynamic host states.

Since we only hold the device_lock() here and not the shost->host_lock, a
concurrent update to tmf_in_progress, such as:

scsi_error.c:scsi_ioctl_reset() {
    ...
    shost->tmf_in_progress =3D 1;
    ...
}

might be clobbered by the unlocked read-modify-write of the bitfield word,
potentially breaking host error recovery.

[ ... ]
> @@ -850,19 +855,25 @@ static int scsi_probe_lun(struct scsi_device *sdev,=
 unsigned char *inq_result,
[ ... ]
> +	/*
> +	 * scsi_rescan_device() calls this function for a live device, so
> +	 * only write lun_in_cdb if it changes. Clearing it first and then
> +	 * setting it again could expose a wrong value to the I/O path.
> +	 */
> +	if (sdev->lun_in_cdb !=3D lun_in_cdb)
> +		sdev->lun_in_cdb =3D lun_in_cdb;

[Severity: Medium]
Could this conditional bitfield assignment cause a data race during a live
rescan?

Although the check avoids writing when the value hasn't changed, if it does
evaluate to true, writing to sdev->lun_in_cdb will perform a non-atomic
read-modify-write of the 32-bit word containing it.=20

This word also holds sdev->cdl_enable, which can be modified concurrently by
sysfs writes without holding the device_lock:

scsi_sysfs.c:sdev_store_cdl_enable() {
    ...
    sdev->cdl_enable =3D enable;
    ...
}

If a sysfs write overlaps with this update, the sysfs state might be
silently overwritten.

[ ... ]
> @@ -1677,12 +1736,42 @@ int scsi_rescan_device(struct scsi_device *sdev)
[ ... ]
> +	if (need_reprobe) {
> +		/*
> +		 * The peripheral qualifier or device type changed, so the
> +		 * driver binding has to be re-evaluated. device_reprobe()
> +		 * takes the device lock itself. sdev stays valid while the
> +		 * lock is dropped because the caller holds a reference;
> +		 * scsi_evt_thread() is covered by the cancel_work_sync() in
> +		 * scsi_device_dev_release().
> +		 */
> +		device_unlock(dev);
> +		ret =3D device_reprobe(dev);
> +		device_lock(dev);
> +
> +		if (sdev->sdev_state =3D=3D SDEV_CANCEL ||
> +		    sdev->sdev_state =3D=3D SDEV_DEL) {
> +			ret =3D -ENODEV;
> +		} else if (ret < 0) {
> +			if (scsi_device_set_state(sdev, SDEV_OFFLINE) =3D=3D 0)

[Severity: High]
Is it safe to call scsi_device_set_state() here without holding the
state_mutex?

scsi_device_set_state() performs a non-atomic read-modify-write of
sdev->sdev_state. If this races with a concurrent device removal
(__scsi_remove_device), the removal path acquires state_mutex and sets
SDEV_CANCEL or SDEV_DEL.

If scsi_rescan_device() concurrently calls scsi_device_set_state() without
state_mutex, it could read SDEV_RUNNING, allow the removal path to transiti=
on
the device to SDEV_CANCEL, and then overwrite that state with SDEV_OFFLINE.

Since SDEV_OFFLINE still permits scsi_device_get(), subsequent callers could
successfully grab a reference to a deleted device and use a destroyed reque=
st
queue, potentially leading to a use-after-free.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014220014.9433=
0-1-brian@purestorage.com?part=3D4
