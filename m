Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC8A43F0A9
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784306754; cv=none; b=BUhIZ1SbERjFjDOrrZEasbc6W+QLEKQwetw8tKfjpA8l0xR698fIj6qhH5BGIWGaZSl0Xi9pBW2fG/HzzD0ITNoPklaqHp9ZaM16k6zbi+9X6M/d0CKTKFImoxR7Um2xnTjaNzyWnWsg1w+SKi452cobJ5RRBZ2fQnskCTywgY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784306754; c=relaxed/simple;
	bh=0XfnVypvS0MrO7FmO/HArntu85Fu3wVoST23KLAbr8Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CeQi5fqilsBLr+PnwRGQ/olIXz96jTsauPa8mOWlpMKAa8ioqc4bnf//qralgz/SHIbqKWffo3fxTU3bKMAgR7a0vFEzU5tDbEWgDYJ97wcJFijxRJD9qFXsnRPBvmUr7N74lxq7IYSf5+uvMHoMpzeqkwBTOX7v7GP61jeUzU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ERwizvxr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ERwizvxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310C71F000E9;
	Fri, 17 Jul 2026 16:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784306753;
	bh=uePAZ49yuZ8VMNfm1ESWmWCS8aloKzu2j09jemA1w5o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ERwizvxrHl8F1yC8J1yrMuQxlbE9/gp1+XZL2+LPrKgt7Dp9Li50cAwqU7MpQFAJJ
	 gvxZRaAX8z27uj6AvaMe8+xWc3+CKunj7r4bYFj5VQOTD1Rc1fA1jItw1GeuifZmiJ
	 f1RywM9ZF+YZz/50xwn+1jcQNlJBpGSZ366lLthgfBJLg1WM3adhW+hWegiKUQ9vE/
	 d/725iRzVFw9S4GagdFnTH3+nDX3F+Rw2IMA60o2CRz1npW4u1HFJfQj/Ijs7py0As
	 rWlQ/i1rU1QPpj9gWTmDjczpJcQr7qNxUfqILkLZhDYBhYA5CjAHcI+QdeVl00fXdW
	 k7IjxCTuoofmQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 51/56] scsi: qla2xxx: Initialize NVMe abort_work once
 at submission
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-52-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-52-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:45:52 +0000
Message-Id: <20260717164553.310C71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Concurrent calls to qla_nvme_fcp_abort or qla_nvme_ls_abort leak c=
md_kref references because the return value of schedule_work() is ignored, =
leading to a permanent transport hang.
--

--- Patch [51]: [PATCH v5 51/56] scsi: qla2xxx: Initialize NVMe abort_work =
once at submission ---
commit ae623a4cb67f2592c5287e656c5d7842f196c53f
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Initialize NVMe abort_work once at submission

This commit moves the initialization of priv->abort_work from the abort pat=
h to
the command submission path. This prevents workqueue corruption when concur=
rent
aborts are issued for the same command.

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 0038b6274d444..3b2f255a5d7d4 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -463,7 +463,6 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_po=
rt *lport,
>  	}
>  	spin_unlock_irqrestore(&priv->cmd_lock, flags);
> =20
> -	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>  	schedule_work(&priv->abort_work);

[Severity: High]
Does this code leak the cmd_kref reference if schedule_work() returns false?

Since INIT_WORK() was removed, schedule_work() can now return false if the =
work
item is already pending (e.g., from concurrent aborts). However, a referenc=
e was
unconditionally acquired earlier in the function via kref_get_unless_zero().

If schedule_work() returns false, the work function won't execute an extra =
time
to drop this reference, which could permanently hang NVMe-FC transport tear=
down.

>  }
> =20

[ ... ]

> @@ -545,7 +545,6 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_p=
ort *lport,
>  	}
>  	spin_unlock_irqrestore(&priv->cmd_lock, flags);
> =20
> -	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>  	schedule_work(&priv->abort_work);

[Severity: High]
This appears to have the exact same reference leak pattern as qla_nvme_ls_a=
bort()
when schedule_work() returns false. Should we drop the kref if schedule_wor=
k()
fails to queue the work?

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D51
