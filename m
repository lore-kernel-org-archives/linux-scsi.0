Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A373274B4A
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 15:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782143817; cv=none; b=Yjs1dBIm7uWY6+iCHja3jGKXGD8BAxCk+2YcfvbArzjyeGNA1cSAhsvWJr9gWbzqk0kZerz1xP6aXucqcoP94idXSlwnUbTvU8Qi30AFSbhOPRpV2G9ZoqahLRW0i708B/1B4FiKL58pV5Ue67aZwHf+qniuU5c2LjHunPpHnPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782143817; c=relaxed/simple;
	bh=Q+5nw1J4B0HQ7gpbva6AvLELh2z+tcjaNDBVMYVOREk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=POJzWDg3jKE9uDgJsOpSNtpldHNNWQL0pwfUykMyztP/spGOSPY5jOrHoi0Ghn1cEFf//NSMDDOSJ6rlEUFFHmjuvlcOurqkqc2h3tplTrDfNCaD7rEMveBNTprYRJCVJ4xVG6P96NrpxmJ4D/njrMLIFs/jnqUQy+TGAVbKjL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQ9X3F2M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQ9X3F2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BF11F000E9;
	Mon, 22 Jun 2026 15:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782143815;
	bh=JfuqDvxxglJSRqSGv33/ERggACBKCK8spAxra9v9NN8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IQ9X3F2MPdXDNL4dGU71cgcrlheji+6xhPzYFVZiWCo5duwzCRVTAQTzNrwmgQQSA
	 mWpwXUlfZhzMqsZ/mV2I0J3/o0nJX6OZAmKWuX/iSe925vFNA+jxaZ94i6Dw3148eR
	 hCWNRw4hQq7bzzc1y8dfETlfUH2qKpYiP8bRJCXZlHiNbSW68QhUSt6/dFnGgt0jxc
	 Oq6GOZoBnJp5cFP9BgpUziWSTFZEXEqMppkDYpY6QSFWsT+l4o53L9qPVkBX2+E9Gi
	 NmhND31omIjLouIxaf3PpqFgTUjKS0mrgV36USUKPj/IfLwvMvObjjqnyFzSikoII0
	 8DBDPd3yRH/kg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi_sysfs: Fix runtime PM usage count leak on device
 add failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Haoxiang Li" <haoxiang_li2024@163.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260622153721.1220711-1-haoxiang_li2024@163.com>
References: <20260622153721.1220711-1-haoxiang_li2024@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 22 Jun 2026 15:56:55 +0000
Message-Id: <20260622155655.90BF11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Dropping the runtime PM reference on the early device_add() error =
path queues an autosuspend timer that fires after the device is freed, caus=
ing a Use-After-Free.
--

commit 5af0e5ca0dba89028b4307b4434ee1726ec0169d
Author: Haoxiang Li <haoxiang_li2024@163.com>

scsi_sysfs: Fix runtime PM usage count leak on device add failure

This commit balances the scsi_autopm_get_device() call on the error paths of
scsi_sysfs_add_sdev() by releasing the runtime PM reference before returnin=
g.

> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index dfc3559e7e04f..6b009e4f4b9e9 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1427,7 +1427,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  	if (error) {
>  		sdev_printk(KERN_INFO, sdev,
>  				"failed to add device: %d\n", error);
> -		return error;
> +		goto out_autopm_put;

[Severity: High]
Could jumping to out_autopm_put here lead to a use-after-free when the first
device_add() fails?

If device_add(&sdev->sdev_gendev) fails early, for example in kobject_add()
or bus_add_device(), device_pm_remove() is not called internally. This leav=
es
runtime PM actively enabled on the device.

When scsi_autopm_put_device() is then called at the out_autopm_put label,
it drops the usage count to 0 while PM is still enabled. This can trigger
the scsi_runtime_idle() callback, which arms the background autosuspend
timer via pm_runtime_autosuspend().

If the caller subsequently frees the sdev struct without calling
pm_runtime_disable() to cancel the pending timers, could the autosuspend ti=
mer
fire and access the freed sdev memory?

>  	}
> =20
>  	device_enable_async_suspend(&sdev->sdev_dev);

[ ... ]

> @@ -1452,6 +1452,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  		}
>  	}
> =20
> +out_autopm_put:
>  	scsi_autopm_put_device(sdev);
>  	return error;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260622153721.1220=
711-1-haoxiang_li2024@163.com?part=3D1
