Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008F128C5B1;
	Wed,  1 Jul 2026 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782914803; cv=none; b=VA5Ounpc/t30xpY2y8llXrCXs70EnmFXR5bkh1O7kF9nxU0h7+0badR96aqGK6d8kwjVpaWftApCGXTHjVmqjb40cwEPQsOWmmC2j/IA28tF/kubSkQdJMzmN227tsJB78kgTqjGFpIwQXhlDQLSSnCbkMJ0oV7ezLqO9rp1DJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782914803; c=relaxed/simple;
	bh=YATV+YBlZaNE4GbvzOfUO1mOCw5qxp5qqOFyfjbKW3Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XQzn5UE7aPLr2679wGMz+p0lowch9vKJn3OjHhxYP5ObLRkORroCeLevKSPF58l4scx+j04cqNT/L3QaViyyWRaYObInT6nYYOUC2GcY+Ps6BJYu5DL4LRh0rRP46Wvri9r5qLmO28DpcvSVZVg1lGhvSoCAu0u1zXuHlYO7WAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aNU7wFzQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aNU7wFzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EE91F000E9;
	Wed,  1 Jul 2026 14:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914801;
	bh=w4t4QcP8bkYGzv6rUeaVCuONCB/QC3Zl8EinkdjLQkY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aNU7wFzQsMWXQUhdQ8JlEfQnFduhGxlXSZKidv9YYV09n/bRMq0TUS7SLS/VwKves
	 dp7CkaCVSEWJ7udMf+l3jnG4OoeK0Ycxzcm2EWqgCM3996rITv2j+ESZaRdMTKL7Jt
	 fslUucGLNM53U8Q62VmfoYxDPdRf8suhLV28DAcKQ93xmVHxMMSb93KJ+G6nMJywia
	 TM0/yPI4xgwF3qRymPj5B3fkS3z7ySyDGClqrlHBa35YsAOZ4RHlFVVOg/wsXMYswv
	 sWlJ+6/20XqrTQpLKFkKQmE2RWdu0VT0jmKy8Agp/PvErazAcdZLpxnleab81naaYZ
	 sN1w28Po9Wc5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/5] scsi: Enable async shutdown support
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260701135015.81937-6-djeffery@redhat.com>
References: <20260701135015.81937-1-djeffery@redhat.com>
 <20260701135015.81937-6-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 14:06:41 +0000
Message-Id: <20260701140641.92EE91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Runtime PM usage counter and PM state leak on device_add error pat=
h.
- [High] Concurrent lockless bitfield mutations cause Data Race and PM stat=
e corruption.
--

commit 10ebc4309581b7d74ed1d3564b5f1af2a5cf5785
Author: David Jeffery <djeffery@redhat.com>

scsi: Enable async shutdown support

Like scsi's async suspend support, allow scsi devices to be shut down
asynchronously to reduce system shutdown time.

> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index dfc3559e7e04f..8fd317aef37b4 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1386,6 +1386,7 @@ static int scsi_target_add(struct scsi_target *star=
get)
>  	pm_runtime_set_active(&starget->dev);
>  	pm_runtime_enable(&starget->dev);
>  	device_enable_async_suspend(&starget->dev);
> +	dev_set_async_shutdown(&starget->dev);

[Severity: High]
This is a pre-existing issue, but does adding dev_set_async_shutdown() here
exacerbate a data race with system suspend?

In scsi_target_add(), device_add() is called earlier, exposing the device
to the PM core. If a system-wide suspend happens concurrently,
device_prepare() may lock the device and set the is_prepared bitfield.

Since device_enable_async_suspend() and dev_set_async_shutdown() locklessly
mutate bitfields in dev->power in the same memory word, couldn't the
resulting read-modify-write instructions overwrite and clear the is_prepared
flag set by the PM core?

>  	return 0;
>  }

[ ... ]

> @@ -1412,6 +1413,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  	transport_configure_device(&starget->dev);
> =20
>  	device_enable_async_suspend(&sdev->sdev_gendev);
> +	dev_set_async_shutdown(&sdev->sdev_gendev);

[Severity: High]
This isn't a bug introduced by this patch, but could the error path for
device_add(&sdev->sdev_gendev) leak the PM usage counter and runtime state?

When scsi_sysfs_add_sdev() is called, it increments the PM usage count via
scsi_autopm_get_device(sdev) and enables runtime PM. If the subsequent
device_add(&sdev->sdev_gendev) fails, the function returns the error direct=
ly
without dropping the usage counter or disabling runtime PM:

scsi_sysfs_add_sdev() {
    ...
    scsi_autopm_get_device(sdev);
    ...
    error =3D device_add(&sdev->sdev_gendev);
    if (error) {
        sdev_printk(...);
        return error;
    }
}

Would this prevent the device and its parent target from ever entering
runtime suspend, causing unbounded power drain?

>  	scsi_autopm_get_target(starget);
>  	pm_runtime_set_active(&sdev->sdev_gendev);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260701135015.8193=
7-1-djeffery@redhat.com?part=3D5
