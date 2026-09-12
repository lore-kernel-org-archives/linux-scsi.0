Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E9D420898
	for <linux-scsi@vger.kernel.org>; Sat, 12 Sep 2026 10:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207406; cv=none; b=PH0t1FNQm8Ksxff6xtwQEVmStqlDxOrsAh9neUtB+ugLcL2XOZHs+H01l69tayuC4FlX0Mo/M2TVonui25CvFsDzwuR0UNI1zSOKIXHUuIGqz5kmNwO6kgZ3NOkXpVE3iTVBPI3W0NVNrb24/BDWmHnZig/A6O2gcel0+ECBtfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207406; c=relaxed/simple;
	bh=xgjmU/KzfOnf9ogxfC2URlpWM+3AXnuU/fITS/ZI31w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=G5suEZ4sRshFUF1tFxNc2W5Vm9uto7rD75Yk/w/lPbXIx7kO7Q7gkS3XYFyIFWbVs7crnDoKbsCQ/xRNX+vnN7cprFVi+EYXVPWOGH76qIyNra4ZQmTOgDAdaP51iOvLyXXE/JQTu6mwsONdSTnkEUK0hw/3o3L7gefTUPV/B/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j3jhOhGv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j3jhOhGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4835B1F0089A;
	Sat, 12 Sep 2026 10:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789207405;
	bh=CbkkNO3H+9ZzOhv8dMOGW5FI3GAyu/f22naoLWExWuo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j3jhOhGvmC+u9BqFogqE4g0uicU6SPVjW9XW+wV5xzXWB+WV0+PwWXgRLq0NUWC0U
	 lvMn3jXQJb9yz75iUs688MZ+4HI6/alc5XibsFdAyQtADUsh48jlVAZdO56EkR2roO
	 +92aDiUpQ7Y/mehMxtt6sknkGwCbsJ8uvNRZhG71rxuBZF9NiKn6S+X8UrDmD4JQ4a
	 Wrf27XBobnjs/o3mHihhHMRInKH+CaipgGlr6kiW1grTpghUSNRORtDp714jde5x/t
	 B4bQZRJCKlF6MlYH/fwlbd2ktXjz4WHQ1HyVgr+vZ8590ZMa/K7xCvfSt5LkB6TMrI
	 jqjG1dK1b6EVA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: ufs: core: Quiesce SCSI devices instead of
 host tagset during error handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260912094107.2098303-1-stanleyjhu@google.com>
References: <20260912094107.2098303-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 12 Sep 2026 10:03:24 +0000
Message-Id: <20260912100325.4835B1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Switching from blk_mq_unquiesce_tagset() to shost_for_each_device(=
) permanently freezes queues of devices being removed, deadlocking the remo=
val path.
--

commit b89bd79e56222f4a0cb23f7f3bd5ee7ab397b8c4
Author: Stanley Jhu <stanleyjhu@google.com>

scsi: ufs: core: Quiesce SCSI devices instead of host tagset during error h=
andling

This commit changes UFS error handling to quiesce only logical units instead
of the entire host tagset. By iterating over active devices, it allows inte=
rnal
commands to be dispatched on the pseudo SCSI device during error recovery,
preventing a circular wait deadlock.

Link: https://lore.kernel.org/all/6f78c4bd-a70b-402d-abfd-599091b67674@acm.=
org/

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 234e18b5078f2..b5c63e88af140 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
[ ... ]
> @@ -6805,6 +6805,23 @@ static void ufshcd_clk_scaling_suspend(struct ufs_=
hba *hba, bool suspend)
[ ... ]
> +static void ufshcd_unquiesce_all_sdevs(struct ufs_hba *hba)
> +{
> +	struct scsi_device *sdev;
> +
> +	shost_for_each_device(sdev, hba->host)
> +		blk_mq_unquiesce_queue(sdev->request_queue);

[Severity: High]
Will this loop skip devices that are in the process of being removed, leavi=
ng
their request queues permanently quiesced?

Looking at __scsi_iterate_devices(), which is called by shost_for_each_devi=
ce(),
it uses scsi_device_get() to acquire a reference to the next device.

If a device is in the SDEV_CANCEL state due to a concurrent removal event
(such as sysfs or hot-unplug), scsi_device_get() returns a negative error.
This causes __scsi_iterate_devices() to skip the device and continue search=
ing:

drivers/scsi/scsi.c:__scsi_iterate_devices() {
    ...
    if (!scsi_device_is_pseudo_dev(next) && !scsi_device_get(next))
        break;
    ...
}

If a device removal occurs concurrently with an error event,
ufshcd_err_handling_prepare() might successfully quiesce the device's queue
before or during its transition to SDEV_CANCEL.

Later, when ufshcd_err_handling_unprepare() calls ufshcd_unquiesce_all_sdev=
s(),
the removed device is skipped, and its queue is never unquiesced.

The device removal thread will eventually call device_del() -> sd_remove() =
->
sd_shutdown() -> sd_sync_cache(). This issues a SYNCHRONIZE CACHE command v=
ia
blk_execute_rq().

Since the queue is permanently quiesced, the request is never dispatched and
the block layer timeout timer never starts.

Could this cause the removal thread to deadlock indefinitely in blk_wait_io=
()
waiting for the completion of the SYNCHRONIZE CACHE command?

> +}
> +
>  static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>  {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912094107.2098=
303-1-stanleyjhu@google.com?part=3D1
