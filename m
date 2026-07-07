Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2063C3FDBFD
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409260; cv=none; b=MiqaFR74N7WFf2VL9pd2qor6kabi0T8i7qKY2VIKKy+rlYd+5LTeHDf2+1FFwN+greYhC4gxtL/szG3D5iFfs7baIifHsnBpFp5exYXBQJ4QOjMHxiM4PVF5eibChzRd0qhtAVgrld1xX8Isck1vtY5TsTmOyVATqfyTIiWBn0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409260; c=relaxed/simple;
	bh=k9UFss6FUFuHvdx7Yuvkj14TsQtM6sTQY1+wnrEMs9E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=shcRpcdDJqO6TrSVqMcierashW8+gI29jYxdjWHK0/SmWm95UMgt35DhA3ciAPmkwBNO5Czh5gauwXsyeCYSAnCfHeHo1ZMGdOPCQ+fKyZR819DbmaVZpng2jn2rVA9sAlZI0j2Z2kbcgJdOrcB6D6aqtnOSbexQA0yMciUFSNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izA7Y5jE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izA7Y5jE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D6E1F000E9;
	Tue,  7 Jul 2026 07:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409251;
	bh=Z0XmjSE+DwMj+NwFOV6xxyzurDT6VuamOxFCIr7RDvw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=izA7Y5jERWqaEPjEOjNbdVpfxvjbEhw6pRSKDTr5g7B8pTPrrJiP0ZfHxHIDcVVjn
	 mENr53/iXQR93mbE4r5DnncS5Tf3lBVHEx0aSK5n8+BmLOecgav3FFSOkdQ4lxfHED
	 eN3H8QE4Jy8mgtLTvHOc7aCKy9ReNHXIFsX6jA/I+dDlXL5wi7Nllnmv+w2s3vt5db
	 5D+CHHLeq361rd7XbppmDk6QfxGqtPStSIlCws1vI73mWZFuMa33jhABBErsZQWm8o
	 5/5XQIA4ENlUOW3XAN7p1r+j5x+aTtGDfcj4+Nnb+UNHSuR3WQZ4dIf7o7bezgCvWx
	 i38ZjL7s5n5SQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 79/88] scsi: qla2xxx: Fix NVMe abort reference leak
 on repeated abort
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-80-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-80-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:27:31 +0000
Message-Id: <20260707072731.85D6E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Reference leak of NVMe command kref when abort fails early and asy=
nc TMF is disabled.
--

--- Patch [79]: [PATCH v3 79/88] scsi: qla2xxx: Fix NVMe abort reference le=
ak on repeated abort ---
commit 5145be10a2c483912089116ba7647d2593449e4f
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort

This commit drops the reference taken for a command abort when schedule_wor=
k()
returns false due to the work already being pending. It ensures the command
kref is balanced regardless of whether the work was newly queued or not.

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 8dc6df6c2e1c5..fc8a344ec7d81 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
[ ... ]
> @@ -548,7 +549,8 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_p=
ort *lport,
>  	}
>  	spin_unlock_irqrestore(&priv->cmd_lock, flags);
> =20
> -	schedule_work(&priv->abort_work);
> +	if (!schedule_work(&priv->abort_work))
> +		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
>  }

[Severity: High]
This is a pre-existing issue, but can this lead to a reference leak of the
NVMe command kref when asynchronous TMF is disabled and the abort fails ear=
ly?

When schedule_work() runs qla_nvme_abort_work(), if ql2xasynctmfenable is 0,
the abort falls back to the synchronous qla24xx_abort_command().

If qla24xx_abort_command() returns an early error (for example,
QLA_ERR_NOT_FOUND because the command completed concurrently):

drivers/scsi/qla2xxx/qla_mbx.c:qla24xx_abort_command() {
	...
	if (handle =3D=3D req->num_outstanding_cmds) {
		/* Command not found. */
		return QLA_ERR_NOT_FOUND;
	}
	...
}

It skips calling qla_wait_nvme_release_cmd_kref() at the end of the functio=
n.

Then qla_nvme_abort_work() checks abts_done_called (which remains 1)
and returns early:

drivers/scsi/qla2xxx/qla_nvme.c:qla_nvme_abort_work() {
	...
	if (abts_done_called && io_wait_for_abort_done)
		return;

out:
	/* kref_get was done before work was schedule. */
	kref_put(&sp->cmd_kref, sp->put_fn);
}

Does this skip the out label where the reference is supposed to be dropped,
preventing the command from being returned to the NVMe-FC transport?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D79
