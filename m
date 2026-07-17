Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C47374758
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784303923; cv=none; b=Nl4F9JdbJXA8r2fFDkeyzpNOXo2S9b64ENdGr4VTwgn3D2Qo8UbyV+lkk31QLlc3ydxrbIZomRLtQkbWmq47ob219SDcHWLOoF2aKO3ZvNaUs4g7BDHfjgGsnppaOLn/HCUnFayUMB2rQG8Xj2J3yeu7NbD4GFUmz57tCPfCpQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784303923; c=relaxed/simple;
	bh=QFWLVrTQ6jS6+bN0cnfOHskVTOjWJi9CQ1cTnuCu4Sk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r5GzhhcIKzoqrThCkW7qesnAn/YT15ntcKbred3PCU505CH0Z/6/5NqZAWBvDWGWiOiFJ1o/USbG1IyhxsxwlD5t89mpr3ndGoFM3CgUJ50/Oad8i2k6b3WlKfE9cXIbNejoeUzXreuA/fa/9Hu4l0zyNrHztlf+ShdHsi1eo3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOqXUZ7+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOqXUZ7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEB21F000E9;
	Fri, 17 Jul 2026 15:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784303920;
	bh=aJZcMFaYsnGWvvVPUHoxVhPlIdY+ezmRrwfwECAZoiQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iOqXUZ7+xR4Ooe5qEg+ZVwyy6K2wTMnBd/vpsmO40zZdZ+T6pD0gWd1yCr1ulRilf
	 M9jF1ErpLOOxuHhDi/Aj7lsxlyu4QLRlDe5vZ5k13lW7P4hfqj9104jwWQ0IAciaVX
	 Ig95bXl+2Bya+pLjEVYSHt3SON83zXZPZ3YNg2igORreg4heFY5lF3U12/9HHn7UTI
	 fryRFZsCed2XmpEsmFjdV7BxOvRERP6kloPwBsz2PrnIy9aRdJLx6tQgzyRGP5r0Ly
	 0LloJ0nLjCTIamhfnCz/j1kSe6WhecWAvQtFTsqRw8iQkN+pEQVkFpKra9WDoYFVkR
	 7bbqYdc1MCcNA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 06/56] scsi: qla2xxx: Remove redundant VPD flash read
 in sysfs read path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-7-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-7-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 15:58:39 +0000
Message-Id: <20260717155840.2BEB21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Lockless calls to `qla28xx_get_aux_images` and `qla27xx_get_active=
_image` cause data races on hardware flash MMIO registers.
- [Medium] Lockless read of shared buffer `ha->vpd` via `memory_read_from_b=
uffer` allows torn reads from concurrent modifications.
--

--- Patch [6]: [PATCH v5 06/56] scsi: qla2xxx: Remove redundant VPD flash r=
ead in sysfs read path ---
commit 58886d8609178ebe2a5d0c1f553bf284e06082ab
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path

This commit removes a redundant flash read from the qla2x00_sysfs_read_vpd
sysfs read path. The second read executed without holding the optrom_mutex,
exposing flash access to concurrent operations.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 6a05ce195aa05..800751ab562a1 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -580,7 +580,6 @@ qla2x00_sysfs_read_vpd(struct file *filp, struct kobj=
ect *kobj,
>  	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
>  	mutex_unlock(&ha->optrom_mutex);
> =20
> -	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
>  skip:
>  	return memory_read_from_buffer(buf, count, &off, ha->vpd, ha->vpd_size);

[Severity: Medium]
This is a pre-existing issue, but does dropping the optrom_mutex right
before calling memory_read_from_buffer() expose the shared ha->vpd buffer
to torn reads?

If another privileged thread calls qla2x00_sysfs_write_vpd() concurrently,
it acquires optrom_mutex and overwrites the shared ha->vpd buffer.

Because memory_read_from_buffer() executes without the lock here, it might
copy a concurrently mutating buffer to userspace.

>  }

[Severity: High]
This is another pre-existing issue, but can the earlier lockless call to
qla28xx_get_aux_images() cause hardware data races?

The qla28xx_get_aux_images() function is called before optrom_mutex is
acquired in qla2x00_sysfs_read_vpd():

drivers/scsi/qla2xxx/qla_attr.c:qla2x00_sysfs_read_vpd() {
        ...
        if (IS_QLA28XX(ha)) {
                qla28xx_get_aux_images(vha, &active_regions);
        ...
        mutex_lock(&ha->optrom_mutex);
        ...
}

This eventually calls qla24xx_read_flash_dword(), which issues hardware
writes to reg->flash_addr and polling reads from reg->flash_data.

Concurrently executing another flash operation interleaves these hardware
register accesses and can irreparably corrupt the flash operation state
machine for both threads.

A similar lockless access happens in the BSG handler
qla2x00_get_flash_image_status() when it calls qla27xx_get_active_image().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D6
