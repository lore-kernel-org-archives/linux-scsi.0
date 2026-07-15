Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD03A3D9691
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 09:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784106071; cv=none; b=Yya5UQZhGDjXiiwOwk/ZrN4vDItxgJKd3LQOW5boumB0XF32nF7A1TTpQt7Avg8pznjC/HIOrl16wLhf2PW/w0bCT4RQh6WkZREG2mLbWT4SgILLNanE+OgtCP1KEf8tBWupD/RcAS1dYTfJEiqJbGz3QRednOSKrpU13qv7Pj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784106071; c=relaxed/simple;
	bh=j5hTIMx0n256/ziK5G6uaBJ80EenlZ1E4plEhSzfxq8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ivmzE1sffjFf8JyPY5iwQd/iqzOzbjMJFTj2NTgseSzjlc9idS1MoubNrFHgFhqM9RdiL/D+f6aVNk8kj0QmgDLrgGhfZaNKHPy/rf3rBrmGjJwXhKKCZxqCTRcupKVUjmzeMpwBNPYAMH37Mzwd6+X3TiNkoB/OcANtQ6x/jps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUnC8xsI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUnC8xsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3D51F000E9;
	Wed, 15 Jul 2026 09:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784106067;
	bh=n1dAe4F9eQ105YNi+IJDHYHwAhqhw7FGf/dHvUX1RD8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OUnC8xsIkS5Rqhkife97rtvE25ekg8RTPu+fNhSWc3sfYfbM1GYAmJDx4BDsc3f11
	 /xOYV96o2DcAq97AVqbQ2F+X4dGqdzmeXM8HXIQwK9pY2a1SK+9qscPMcSXbBm2Mzc
	 zbluyUWCK/y3jmeijHcwaiklir7uRaNHSLKy31WnN22uPiTYUXhU6MXoHDls/yxP89
	 9wlWLDxrtl49dsHm4cRp2iFyiyze/NCTdl1c2CBXyxSUuWWQkSeaik7VNx3AOchJau
	 iBWyr46hAnTAdqfi7DlPGkp6lYYjaiLWhJjFHBy/VSHUlSDLbKMZZrdfgXg11UVw4j
	 J/+aG9ReSECzA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] scsi: 3w-9xxx: bound firmware error strings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260715084652.47248-2-pengpeng@iscas.ac.cn>
References: <20260715084652.47248-1-pengpeng@iscas.ac.cn>
 <20260715084652.47248-2-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 09:01:06 +0000
Message-Id: <20260715090106.EE3D51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete Fix / Missing Sibling Driver Fix
- [High] Use-After-Free / Locking Freed Memory on Device Removal
--

--- Patch [1]: [PATCH v2 1/2] scsi: 3w-9xxx: bound firmware error strings -=
--
commit fea64e8649c4887fbfe30a91a57db19d90edb2d7
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

scsi: 3w-9xxx: bound firmware error strings

This commit replaces unbounded strlen() calls with strnlen() when parsing
the firmware response header in the 3w-9xxx driver. It also adds a shared
helper function to safely NUL-terminate the field before parsing.

> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index 9b93a2440af8f..b2462ee43008e 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
[ ... ]
> @@ -404,10 +422,9 @@ static void twa_aen_queue_event(TW_Device_Extension =
*tw_dev, TW_Command_Apache_H
>  	tw_dev->error_sequence_id++;
> =20
>  	/* Check for embedded error string */
> -	error_str =3D &(header->err_specific_desc[strlen(header->err_specific_d=
esc)+1]);
> -
> -	header->err_specific_desc[sizeof(header->err_specific_desc) - 1] =3D '\=
0';
> -	event->parameter_len =3D strlen(header->err_specific_desc);
> +	error_str =3D twa_error_string(header);
> +	event->parameter_len =3D strnlen(header->err_specific_desc,
> +				       sizeof(header->err_specific_desc));

[Severity: High]
This isn't a bug introduced by this patch, but does the sibling driver 3w-s=
as
need a similar fix?

Looking at twl_aen_queue_event() in drivers/scsi/3w-sas.c, it seems to use =
the
same unbounded strlen() before the array is explicitly NUL-terminated:

drivers/scsi/3w-sas.c:twl_aen_queue_event() {
    ...
    error_str =3D &(header->err_specific_desc[strlen(header->err_specific_d=
esc)+1]);
    header->err_specific_desc[sizeof(header->err_specific_desc) - 1] =3D '\=
0';
    event->parameter_len =3D strlen(header->err_specific_desc);
    memcpy(event->parameter_data, header->err_specific_desc,
           event->parameter_len + 1 + strlen(error_str));
    ...
}

If the firmware response does not contain a NUL terminator, could this lead
to an out-of-bounds read and a subsequent heap buffer overflow in the
memcpy()?

It looks like twl_fill_sense() in drivers/scsi/3w-sas.c also has the same
pattern. Should these be updated as well?

>  	memcpy(event->parameter_data, header->err_specific_desc, event->paramet=
er_len + (error_str[0] =3D=3D '\0' ? 0 : (1 + strlen(error_str))));
>  	if (event->severity !=3D TW_AEN_SEVERITY_DEBUG)

[Severity: High]
This is a pre-existing issue, but is there a use-after-free risk during
device removal in this driver?

Looking at twa_remove() in drivers/scsi/3w-9xxx.c, it frees tw_dev without
clearing the global twa_device_extension_list array or preventing existing
ioctl operations:

drivers/scsi/3w-9xxx.c:twa_remove() {
    ...
    scsi_host_put(tw_dev->host);
    pci_disable_device(pdev);
    twa_device_extension_count--;
}

If a user holds an open file descriptor to /dev/twa0 while the device is
unbound, and then calls ioctl, twa_chrdev_ioctl() retrieves the freed
pointer:

drivers/scsi/3w-9xxx.c:twa_chrdev_ioctl() {
    ...
    TW_Device_Extension *tw_dev =3D twa_device_extension_list[iminor(inode)=
];
    ...
    if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
    ...
}

Would this result in locking freed memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715084652.4724=
8-1-pengpeng@iscas.ac.cn?part=3D1
