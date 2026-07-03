Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16D73C4B71
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 11:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783079632; cv=none; b=M+jRlLRgO3FYfwaFOyMLkXPETnsQIyRpYp9hOruTiyVLQp3Dxgnlchy+Ly/1Efr6pZVgM73ry5jLXzouu8Y7qoyHau8EyChug+6CBLCZVIGYoihe8ZRzDLnZ64f2xw8HP39NSUbmqZdp1B5hmp12syIptsrI6YZRFYF9bjA/9Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783079632; c=relaxed/simple;
	bh=uVCAxvB7hCeYrpj0DXV5RCUo3fcVYEp6vBEy5FCQHaw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nCXRioUDw3q4EtK/pK8vQLQJK/VhziBIwomGUxn8nPidm6LzW7V06sjKRTjRv4Xj/5fbtWeHGk3Xo6Ly9/jH9yOtg4AMlNDTm6c53xFp7aUTEy/cADDh4l6Usm1Lav7pRe2yzL+OFs99Qm6pvr6+5qi5UlY3bLd1Nkyy62Y/2/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VvxYReR+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VvxYReR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2E31F000E9;
	Fri,  3 Jul 2026 11:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783079631;
	bh=B2JRSBc0v5wVPJ1kfZPXH30jY4tvYAKGP+f+08kCDBA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VvxYReR+id+hMlQeSZpprp8unHwpc2vqPDt/879CPZgU4+AGkDyQaKUWHYugCA9l1
	 4/jBQ2EafqnzfqfHYEHl3IZFBv6aL0xlHdZwJQ2NPaNrQpmM/OyR0c526LkNLyBuLI
	 WtBFgTN2Frv64Ew+jx2+mah2oRpU9Nos9kUfNXKuRJzDPXmVRsJvOM0Ry5uszm6+v2
	 WSze55ziqM+ILYkHRQw8d/BoPSnPcVaTkiDLT7qYNg+Ofd8TJaHhV6hKgalU33xkId
	 z93w3gXE7LYFxK2NlPAgX+B4Ab5jP/QBvTxl67UoPWV9t5Ic0gZcs08tzzoRWpHRxF
	 FZghpWjkzRodw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/17] scsi-multipath: add
 scsi_mpath_{start,end}_request()
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103402.3725011-10-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-10-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 11:53:50 +0000
Message-Id: <20260703115351.1C2E31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Requeueing a command causes permanent leaks of `mpath_nr_active` a=
nd block device in-flight I/O statistics because `SCMD_MPATH_*` flags are n=
ot preserved.
- [High] Premature termination of I/O accounting and double-accounting on p=
artial request completions because `scsi_mpath_end_request()` is called bef=
ore `blk_update_request()`.
- [Low] Implicit function declarations of `is_mpath_request` and `mpath_qd_=
iopolicy` cause build failures.
--

commit 6d78b641877657fb26302d1c7965b47fd751383b
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: add scsi_mpath_{start,end}_request()

This patch adds scsi_mpath_start_request() and scsi_mpath_end_request() to
handle updating private multipath request data. It also introduces
mpath_nr_active to Scsi_Host to support queue depth multipath iopolicy.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 3c493068adb98..72ba066235911 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -669,6 +669,9 @@ static bool scsi_end_request(struct request *req, blk=
_status_t error,
>  	struct scsi_device *sdev =3D cmd->device;
>  	struct request_queue *q =3D sdev->request_queue;
> =20
> +	if (is_mpath_request(req))
> +		scsi_mpath_end_request(req);
> +

[Severity: Low]
Are the functions is_mpath_request() and mpath_qd_iopolicy() defined anywhe=
re?
It looks like they are used in this patch but not declared, which would cau=
se
a build failure.

[Severity: High]
Does calling scsi_mpath_end_request() before blk_update_request() cause dou=
ble
accounting on partial completions?

If blk_update_request() returns true for a partial completion, the request =
is
retried. Since scsi_mpath_end_request() has already decremented
mpath_nr_active and called bdev_end_io_acct() without clearing the state
flags, a later completion will decrement these again. Should this be called
after blk_update_request() finishes the entire request?

>  	if (blk_update_request(req, error, bytes))
>  		return true;
> =20
[ ... ]
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 8ecfb94049db5..c6571a36e577b 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -60,6 +60,8 @@ struct scsi_pointer {
>  #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
>  /* flags preserved across unprep / reprep */
>  #define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
> +#define SCMD_MPATH_IO_STATS	(1 << 5)
> +#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)

[Severity: High]
Can we leak mpath_nr_active and in-flight I/O statistics when a command is
requeued?

In scsi_queue_rq(), cmd->flags is masked with SCMD_PRESERVED_FLAGS. Because
SCMD_MPATH_IO_STATS and SCMD_MPATH_CNT_ACTIVE are not added to
SCMD_PRESERVED_FLAGS, they are cleared on every retry.

When scsi_mpath_start_request() runs again on a retry, it will see the flags
as unset, increment mpath_nr_active, and call bdev_start_io_acct() a second
time. Upon completion, scsi_mpath_end_request() only cleans up once, leavin=
g a
permanent leak. Should these new flags be added to SCMD_PRESERVED_FLAGS?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103402.3725=
011-1-john.g.garry@oracle.com?part=3D9
