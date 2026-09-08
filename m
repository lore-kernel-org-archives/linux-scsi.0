Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEB0370D5E;
	Tue,  8 Sep 2026 09:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861087; cv=none; b=joPVr8ZLcoR2FZG/v7N2xOqLUxlC6zDG/s6Zc1HKQ/tL434OoALeWDyCfax52xcF+XIROD+FsAhX7YYwjU+r1qRa5tdclbxOC1Shy+w+CpWsbEZy3dKSZphOcPqvOT5ZB11oiKfWXsSfpfYEi3aNZCyiy63MfrMclDR5F+S4w9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861087; c=relaxed/simple;
	bh=Y6JS1hUvWVzBBXI5iLtdoExgErFbVn5gM+c8Uxoad/c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tJkRkXQYB3ylf+EUOMkOibadrGeOsS/ukpQkU2qkCK8jfP4/UsdYv0rXjiczTC8+5CNnfHTg4uA1insN28Sru/gfrQbhS8MBi27oB77mIm81pSxDNTXFrIsgckg3idgJ2WSCts2ipziLP/x650rmP/DGP5IbA20qZ4wrBXiFdjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+E9puRv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+E9puRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B128A1F00A3D;
	Tue,  8 Sep 2026 09:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788861086;
	bh=guZEeckL3K3wJPD/WG0Yw3HJAheaeZ2nbkpRwKJR9xM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W+E9puRvNkUmMldSYb0q/N+d4/NjICxEKJR09iVT8HuYiUAig/KmXOlGInu3Jm2e1
	 FZAkqB6Re+ydorSIzr40hFx13Lyz9fT0m3PYUanydnuSYbQUYmdR0FLQQoVHCdXS8G
	 IuuQfffu5nPXaCyKV3VMiKr9AStZgakd+55A6nG7SSmFj/mVcQqw3z/g9oM8essPpJ
	 GRvGfPvLwc0K1Tm1PLf6uiIjg5GlZyxN3y57acD+t12ghm5cllsWa9BOLykVg5kVxR
	 NNGV91RJ+NF7XgUXyKDD68GRPbL0eGaDPy64lyu8wDRPGBoJ78JZiV7YQCSbxMy5VZ
	 J2jkc/zuICEyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 19/40] scsi: 3w-xxxx: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, linux-ide@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org
In-Reply-To: <20260908090308.1085097-20-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-20-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:51:25 +0000
Message-Id: <20260908095125.B128A1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A character device ioctl use-after-free exists due to unbalanced l=
ifecycle operations during PCI removal and lack of per-device reference cou=
nting.
--

commit 97249c8ac47fc8b50b4db175724db5a0b515a3d1
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: 3w-xxxx: use 16-bits defined sense codes
   =20
Modify the function tw_scsi_queue_lck() of the 3w-xxxx driver to use
scsi_set_sense() and replace the hard-coded additional sense codes and
additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index c68678fa72c1e..1e1692f776d31 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c

[ ... ]

> @@ -1977,7 +1977,8 @@ static enum scsi_qc_status tw_scsi_queue_lck(struct=
 scsi_cmnd *SCpnt)
>  		printk(KERN_NOTICE "3w-xxxx: scsi%d: Unknown scsi opcode: 0x%x\n", tw_=
dev->host->host_no, *command);
>  		tw_dev->state[request_id] =3D TW_S_COMPLETED;
>  		tw_state_request_finish(tw_dev, request_id);
> -		scsi_build_sense(SCpnt, 1, ILLEGAL_REQUEST, 0x20, 0);
> +		scsi_set_sense(SCpnt, 1, ILLEGAL_REQUEST,
> +			       INVALID_COMMAND_OP_CODE);
>  		done(SCpnt);
>  		retval =3D 0;
>  	}

[Severity: High]
This is a pre-existing issue, but does this driver have a use-after-free
during device removal?

Looking at tw_remove(), when a device is removed, it drops the host refcount
and frees the device extension, but doesn't clear it from the global array:

drivers/scsi/3w-xxxx.c:tw_remove() {
	...
	if (twe_major >=3D 0) {
		unregister_chrdev(twe_major, "twe");
		twe_major =3D -1;
	}
	...
	scsi_host_put(tw_dev->host);
	pci_disable_device(pdev);
	tw_device_extension_count--;
}

If a user with CAP_SYS_ADMIN already has the character device open, can they
trigger a use-after-free by calling an ioctl after removal?

drivers/scsi/3w-xxxx.c:tw_chrdev_ioctl() {
	...
	TW_Device_Extension *tw_dev =3D tw_device_extension_list[iminor(inode)];
	...
	mutex_lock(&tw_mutex);
	/* Only let one of these through at a time */
	if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
	...
}

Will this retrieve the freed tw_dev from tw_device_extension_list and
dereference it? Also, does unregister_chrdev() in tw_remove() break the
character device interface for all other remaining controllers by
unconditionally removing the shared major number?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D19
