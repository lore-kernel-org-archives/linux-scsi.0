Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792449145;
	b=E+Q9gxF0eOUGesgQO/R66qZ/47KIBkD1fhav5LOfv1lskxDaFGmOnyDj8m7auEuNDrI+
	 OsI8U8YfFzH+J4BSl7gQN7E/m5I+bKPChGnJYR8axvLEN5nRT7FLYbDi9XwHzpukUKDaW
	 tZTvYUg26IOW1YuAkZQpdpjH4pcS62oV+cG2swERYgOMtAXquvwQKnRlVMB4OcrEGa/fg
	 U1zY7pGCmK1VyJoBDxAMNYQij7S6ivOm7it5K9VHeSPrAu0TRnvL3W3H0BDRZw0vsrHnS
	 +7We28C17eqcSSSsZQYFoMyQuSrgB/lxFPpVBEyVD3tFxxc9Kzue1b0pjXSZAQC/ogg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792449145;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=150+xEi+S5LeRnOud9i2ixNsDlt1/1py/juiLRG1+T0=;
	b=WNbFK+gh3qFIihFdYZAePF7jM7HlnkpUcSQOVdgikG8DLIBy7c2Gtj/SvwHbnSFq/Xmy
	 AqZvTQcNKPl2lI7YTG4oLLCIDX/twy2ZS/NQ8fzM6/NFcS/VNunSxiDHwL1GpsneSRMDU
	 t9psz/VJ90FrhBzW+kRgOCKZPXqaO4WjURLUIJRr764gGoEAF82bZMh77PgdcNlnm0uND
	 R6LfbwwpFe7ujIZMMgXwCTuvTPDt18K4DHTvZnknDKPM47aRoe1bKbIAJPtLfiQJI8jUr
	 tLavApZRFgwvfBF0x8XakcY9VvN4T9tvhRmcQaT8YvLGR9ehvtZqug4LVBaFgcdZKbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="d8n///wR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13C6606A319
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 22:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d8n///wR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4FF1F000C4;
	Mon, 19 Oct 2026 22:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792449144;
	bh=150+xEi+S5LeRnOud9i2ixNsDlt1/1py/juiLRG1+T0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=d8n///wRzQm8gwUJllxQEwFlxQFCM/CImPB1T+UnyUJW5BSX4LU4xcYLAH8rbuzQq
	 nXOi5NE1OlgLojx5IRmTJwik5lKW1TZkKiQ1J6gwmSXg7zwLSBK5KPv2cUZOfBL++g
	 RtzLGjWnZEzEpLH2xl0BT01+rkFnUnlbiFG/O7mmp9mnasvqudV7C0ogzGGkduIXiS
	 trQgtvRguibZD5WUb/FkC5XHhokuZWfbnsTOhgg08EYYuPk04rm5c4UdfaoTzrIIy0
	 04ym/88xicxNrwx+XMk5+kmeFRUH43evJIt6lfwEYXvnTooXCXD43pQ54vfhfGvXB+
	 lchm0Sv6dtwww==
Message-ID: <sashiko-outbox-178323@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 5/5] scsi: core: Handle reprobe for existing devices
 during SCSI scan
Reply-To: sashiko-reviews@lists.linux.dev
To: "Brian Bunker" <brian@purestorage.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261019221405.40614-6-brian@purestorage.com>
References: <20261019221405.40614-1-brian@purestorage.com>
 <20261019221405.40614-6-brian@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 22:32:23 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: core: premature rescan of unregistered sdev in scsi_probe_an=
d_add_lun()
- [Medium] scsi: core: redundant LUN 0 rescan in scsi_probe_and_add_lun()
--

commit 4955c24621465fbad93e330007f0c5daeb098941
Author: Brian Bunker <brian@purestorage.com>

scsi: core: Handle reprobe for existing devices during SCSI scan

This commit updates scsi_probe_and_add_lun() to call scsi_rescan_device()
when a non-initial scan encounters an existing scsi_device that has
finished creation, refreshing its INQUIRY data and reprobing if its
peripheral qualifier or device type changed.

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 87fd3ba5c3cc0..c6424773c3f1c 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1156,6 +1156,16 @@ static int scsi_probe_and_add_lun(struct Scsi_Host=
 *shost,
>  			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
>  				"scsi scan: device exists on %s\n",
>  				dev_name(&sdev->sdev_gendev)));
> +			/*
> +			 * Rescanning a device that has been fully set up:
> +			 * refresh its INQUIRY data so that peripheral
> +			 * qualifier or device type changes (e.g. ALUA state
> +			 * transitions) are picked up.
> +			 */
> +			if (rescan !=3D SCSI_SCAN_INITIAL &&
> +			    !scsi_device_created(sdev) &&
> +			    !scsi_device_is_pseudo_dev(sdev))
> +				scsi_rescan_device(sdev);

[Severity: High]
Can this call scsi_rescan_device() on an sdev before scsi_sysfs_add_sdev()
has registered sdev->sdev_gendev with the driver core?

During an asynchronous host scan (shost->async_scan =3D=3D 1, set by
scsi_prep_async_scan()), scsi_add_lun() transitions sdev->sdev_state out of
SDEV_CREATED/SDEV_CREATED_BLOCK before scsi_sysfs_add_sdev() is called, and
defers scsi_sysfs_add_sdev() until scsi_finish_async_scan() ->
scsi_sysfs_add_devices():

drivers/scsi/scsi_scan.c:scsi_add_lun() {
	...
	mutex_lock(&sdev->state_mutex);
	ret =3D scsi_device_set_state(sdev, SDEV_RUNNING);
	if (ret)
		ret =3D scsi_device_set_state(sdev, SDEV_BLOCK);
	mutex_unlock(&sdev->state_mutex);
	...
	if (!async && scsi_sysfs_add_sdev(sdev) !=3D 0)
		return SCSI_SCAN_NO_RESPONSE;
}

In that window, !scsi_device_created(sdev) is already true, while
sdev->is_visible is still 0 and sdev->sdev_gendev.p is NULL (since
device_private_init() only runs inside device_add()).

For example, when fc_scsi_scan_rport() runs while shost->async_scan is set,
it calls scsi_scan_target(..., SCAN_WILD_CARD, SCSI_SCAN_RESCAN).
__scsi_scan_target() first probes and adds LUN 0 via
scsi_probe_and_add_lun() (setting sdev_state to SDEV_RUNNING with
is_visible =3D=3D 0), and then immediately calls scsi_report_lun_scan(...,
SCSI_SCAN_RESCAN), which calls scsi_probe_and_add_lun() on LUN 0 a second
time. A concurrent scsi_scan_target(), scsi_scan_host_selected(), or
__scsi_add_device() call with rescan !=3D SCSI_SCAN_INITIAL can also acquire
shost->scan_mutex while shost->async_scan is set without waiting in
scsi_complete_async_scans().

If scsi_rescan_device() is called on this unregistered sdev and
scsi_refresh_inquiry() returns true (need_reprobe), the call chain:

  scsi_rescan_device()
    -> device_reprobe()
      -> bus_rescan_devices_helper()
        -> device_attach()
          -> __device_attach()

dereferences dev->p->dead in __device_attach() while dev->p is still NULL.
Should this check sdev->is_visible as well?

[Severity: Medium]
Also, during a wildcard target scan in __scsi_scan_target() with
rescan !=3D SCSI_SCAN_INITIAL, won't LUN 0 be rescanned twice (or rescanned
immediately after initial creation)?

In __scsi_scan_target(), LUN 0 is probed first and then
scsi_report_lun_scan() is called right after with the same rescan value:

drivers/scsi/scsi_scan.c:__scsi_scan_target() {
	...
	res =3D scsi_probe_and_add_lun(shost, starget, 0, &bflags, NULL, rescan,
				     NULL);
	if (res =3D=3D SCSI_SCAN_LUN_PRESENT || res =3D=3D SCSI_SCAN_TARGET_PRESEN=
T) {
		if (scsi_report_lun_scan(shost, starget, bflags, rescan) !=3D 0)
			scsi_sequential_lun_scan(shost, starget, bflags,
						 starget->scsi_level, rescan);
	}
}

Unlike scsi_sequential_lun_scan(), which starts at lun =3D 1,
scsi_report_lun_scan() iterates over all LUNs returned by REPORT LUNS
including LUN 0 and calls scsi_probe_and_add_lun(shost, starget, lun, NULL,
NULL, rescan, NULL) again:

drivers/scsi/scsi_scan.c:scsi_report_lun_scan() {
	...
	for (lunp =3D &lun_data[1]; lunp <=3D &lun_data[num_luns]; lunp++) {
		lun =3D scsilun_to_int(lunp);
		...
			res =3D scsi_probe_and_add_lun(shost, starget,
				lun, NULL, NULL, rescan, NULL);
	}
}

When LUN 0 already exists, __scsi_scan_target() rescans LUN 0 once and
scsi_report_lun_scan() immediately rescans LUN 0 a second time.

When LUN 0 is newly discovered during a scan where rescan !=3D
SCSI_SCAN_INITIAL (such as manual sysfs scans or transport scans like
fc_scsi_scan_rport(), iscsi_scan_session(), and snic_scsi_scan_tgt(), which
always pass SCSI_SCAN_RESCAN), the first scsi_probe_and_add_lun() call in
__scsi_scan_target() adds LUN 0 and sets sdev->sdev_state to SDEV_RUNNING.
Moments later, scsi_report_lun_scan() visits LUN 0 again, sees
!scsi_device_created(sdev), and calls scsi_rescan_device() on the newly
added LUN 0 (which also blocks on device_lock(&sdev->sdev_gendev) waiting
for asynchronous sd_probe() to finish while holding shost->scan_mutex).

>  			if (sdevp)
>  				*sdevp =3D sdev;
>  			else

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019221405.4061=
4-1-brian@purestorage.com?part=3D5
