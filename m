Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B601C427FB9
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 21:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791840433; cv=none; b=FX2UFo22O33NAH1ql+0QS4yAPrzU/s0P5qF+BdDNSKQG5AkhYOug6/oSttwbStv1Nq/5goKBqWicdqddGJelWA0tFDgdsI8rttQTl/VhlA3YVSViyxVVLHf2AjXqfh6EwJ2RR5ZW7bBdZp/ltO10GAdpkiQDxzgFjmNEwQc8NIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791840433; c=relaxed/simple;
	bh=FMvgrMXQXsjdkQ/cLcKpmfNmyDw0elU8YWMpYrtUVac=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Uj8tXFPRqSlwtGTn4mC4w9b57NRAVCJIrb0lXVdEvs4Wwc8HddpakL0x87dQgmwaD/JRhoO6z4kq4cAQZHMp7Zda6B789YlIHU1rxpST8gqRfFVjbsa/6px38JqSSMrEuMsNlbz2Wf0S+4LoRWj5Y9a4YycMUlOtHHw71FB92NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjY0x7dR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjY0x7dR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0C91F0089B;
	Mon, 12 Oct 2026 21:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791840432;
	bh=5QKwXXiJXqFcfHqxsV9LB7bg11VdazKWJJNmSRjBBQM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fjY0x7dRKuMRHTui88C6MpaEmgeCS73zXbLbDeEMCLQuTlwokyjH34f1D3bUoE8x0
	 6jEEb+omlf16pYOmTHoU1NgyBno3N5+nNyiZLt579XTqk5fcOBsrK9mJHb35UH10Ui
	 4TcEZSQJehtf+p36qugXaMlq0V7ZaqvenIpGXw1fgG3vk9m1zM6uyvsIAcnOg0Yeww
	 mqijE3NTCv4vRDLuucCqsICeoUB6gHnKaj0eZDx3nZ+S9Klv7WCNzKezuz2ef3GcZl
	 glIhH+0xS03avoGQ7zqdgr0V4v2T6J4O0JtULEOz3GgA1mE3m+3GnO+saZIFoTBP+M
	 aTPSPo0/Re3uQ==
Message-ID: <sashiko-outbox-168623@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 4/5] scsi: core: Add device reprobe support to
 scsi_rescan_device()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Brian Bunker" <brian@purestorage.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261012210511.16061-5-brian@purestorage.com>
References: <20261012210511.16061-1-brian@purestorage.com>
 <20261012210511.16061-5-brian@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 21:27:11 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] scsi: error handling skips drv->rescan and returns false success
- [High] scsi: unsynchronized sdev->inquiry_len update causes OOB read in s=
ysfs
- [High] scsi: concurrent lockless access to sdev->inquiry causes UAF durin=
g rescan
- [High] scsi: core: Use-After-Free of dev->mutex on reprobe error path
--

commit 6bb20d3d0d04c11c3c6eb45dfb7bb607811d248f
Author: Brian Bunker <brian@purestorage.com>

scsi: core: Add device reprobe support to scsi_rescan_device()

This patch updates INQUIRY data on rescan and calls device_reprobe() if
the peripheral qualifier or type changed. This handles ALUA unavailable
states.

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 93a8719fcf265..ddb92282d49ff 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
[ ... ]
> @@ -1677,18 +1758,52 @@ int scsi_rescan_device(struct scsi_device *sdev)
>  		goto unlock;
>  	}
> =20
> -	scsi_attach_vpd(sdev);
> -	scsi_cdl_check(sdev);
> -
> -	if (sdev->handler && sdev->handler->rescan)
> -		sdev->handler->rescan(sdev);
> +	/*
> +	 * Rescan standard INQUIRY data to detect changes in device
> +	 * properties (vendor, model, rev, peripheral qualifier, device type, e=
tc.)
> +	 */
> +	inq_result =3D kmalloc(result_len, GFP_KERNEL);
> +	if (inq_result) {

[Severity: High]
Could this inadvertently break error handling by skipping the rescan hooks
and returning a false success?

If the kmalloc() fails, or if the device is unresponsive and scsi_probe_lun=
()
returns an error like -EIO, the function skips the entire block. Because
ret is still initialized to 0, it returns success to the caller.

Crucially, the fallback to drv->rescan(dev) (which was previously executed
unconditionally) is now bypassed. For SCSI disks, sd_rescan() calls
sd_revalidate_disk(). If the device is dead, this revalidation is what
zeroes the disk capacity. Because this patch skips the rescan hook on IO
or memory failure, does this leave dead disks with stale capacity and
geometry data in sysfs and the block layer?

> +		if (scsi_probe_lun(sdev, inq_result, result_len,
> +				   &bflags) =3D=3D 0) {

[Severity: High]
Can calling scsi_probe_lun() on a live, sysfs-exposed device introduce an
out-of-bounds read in sysfs?

scsi_probe_lun() directly mutates sdev->inquiry_len without acquiring
sdev->inquiry_mutex:

drivers/scsi/scsi_scan.c:scsi_probe_lun() {
    ...
    sdev->inquiry_len =3D min(try_inquiry_len, response_len);
    ...
}

If the device responds with more data than previously (e.g., length jumps
from 36 to 255 bytes), sdev->inquiry_len is increased immediately. However,
the actual sdev->inquiry buffer is not reallocated until
scsi_update_inquiry_data() runs later in the flow.

If a concurrent read to the /sys/bus/scsi/devices/.../inquiry sysfs file
occurs, show_inquiry() will acquire the mutex and read the newly increased
sdev->inquiry_len bytes from the old, smaller sdev->inquiry buffer,
potentially leaking adjacent heap memory to userspace.

> +			ret =3D __scsi_reprobe_inquiry(sdev, inq_result,
> +						     max_t(size_t, sdev->inquiry_len, 36),
> +						     &need_reprobe);

[Severity: High]
Is it possible that triggering the INQUIRY buffer replacement on an active
device causes a use-after-free due to concurrent lockless readers?

__scsi_reprobe_inquiry() eventually calls scsi_update_inquiry_data(),
which frees the old buffer using a raw kfree() without RCU deferral:

drivers/scsi/scsi.c:scsi_update_inquiry_data() {
    ...
    kfree(sdev->inquiry);
    sdev->inquiry =3D new_inquiry;
    ...
}

Several kernel paths access sdev->inquiry without acquiring
sdev->inquiry_mutex or using RCU. For example, scsi_device_protection()
(called during block revalidation) reads from sdev->inquiry locklessly:

include/scsi/scsi_device.h:scsi_device_protection() {
    return sdev->scsi_level > SCSI_2 && sdev->inquiry[5] & (1<<0);
}

If one of these lockless readers executes concurrently with
scsi_rescan_device(), it could dereference the sdev->inquiry pointer
exactly as it is being freed.

> +			if (ret < 0) {
> +				kfree(inq_result);
> +				goto unlock;
> +			}
> +		}
> +		kfree(inq_result);
> +	}
[ ... ]
> +	if (need_reprobe) {
> +		get_device(dev);
> +		device_unlock(dev);
> +		ret =3D device_reprobe(dev);
> +		device_lock(dev);
> +
> +		if (sdev->sdev_state =3D=3D SDEV_CANCEL ||
> +		    sdev->sdev_state =3D=3D SDEV_DEL) {
> +			put_device(dev);
> +			ret =3D -ENODEV;
> +			goto unlock;
> +		}

[Severity: High]
Might this error path trigger a use-after-free on dev->mutex?

scsi_evt_thread() (via scsi_evt_emit()) calls scsi_rescan_device() without
holding an explicit get_device() reference, relying solely on
cancel_work_sync(&sdev->event_work) during scsi_device_dev_release() to
prevent device destruction.

If scsi_remove_device() runs concurrently during the unlocked reprobe
window above, it will drop its references. This leaves the temporary
get_device(dev) taken in scsi_rescan_device() as the sole remaining
reference.

When put_device(dev) is called here (or at the end of the block), it
drops that final reference from within the worker thread. This invokes
scsi_device_dev_release() inline, which calls cancel_work_sync() on the
currently executing work. The workqueue core detects the self-flush and
returns immediately, allowing scsi_device_dev_release() to free the sdev.

The code then jumps to the unlock label and executes device_unlock(dev)
on the freed memory.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012210511.1606=
1-1-brian@purestorage.com?part=3D4
