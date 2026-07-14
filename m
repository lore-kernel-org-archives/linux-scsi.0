Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FDE2E8897
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783990638; cv=none; b=JfrBDGBHI5juMlwhplcjyl1xghw77gxqlh/D6u4MGEE0Wda0kq0/MPQnulMSX3fYAf6+zHE9uVHfqgXt0f+uL7PRmAfTejKKGMFqDefyDC/yWyKmOB8jzF+t7h5OpThmGXUUsiYcB4X+0AlkXwkq1v0PtS9QP1UGc825ohsZPPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783990638; c=relaxed/simple;
	bh=urdL7rUsNGh4B2S88bzekqtJYBDpwzod7gVrOXZlTE4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TCsLUQwqMpGIDpbUKCfcrzD4I4Mn5ihEtoodrcKaNPfdxFa2GOLHZRHkYIqjdsfCL8HcG2B2sOxxGfN+AGWBzah+s5bzDAJPnm7Tz08rd5zlli+SBrcw7zz/2qQ3i38z6vF6XvdvKIskc0NsCMjjT7oqVeCHiPs3Q47uaXpKrSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e6wa7xso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e6wa7xso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEAB1F000E9;
	Tue, 14 Jul 2026 00:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783990637;
	bh=0QJKJKFL9ZuJC/BeZVRuYe/S+N7Tb6jK4ARvvGxy1Io=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e6wa7xsoyWrBbYSgAUxI9TClJo3UedT0BeUA/qjsXkM9MzJ6gugfNnV59Azmuc3x+
	 KNcKEwjlrDde2CcX0DCPmfIxpOBa4q8DZ9eA5RDF5P7VW2LbfEd/dKV04xgJzBtNV9
	 bVt8Hn08vS1xOIzAoZzjzZtVELo2Es3LDh4N5yfAXmllew359JJk5FcspyPAj5dDtz
	 DSvU0A/10Cp+ei/hhX5C7s4j3SbYDZ77CXZaSAhVe/hbtpZ/TP6bFbGbNPn2buXwHj
	 Cs/tn3RafxNL5dm41pXHSYdkRCxCtO8G+J5ApIZKJiSHe9gB7uqsNQsn+eGB5oQIZJ
	 02frRsjEgJvFg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 03/14] lpfc: Fix kernel oops when unmapping scsi dma
 buffers for an aborted cmd
Reply-To: sashiko-reviews@lists.linux.dev
To: "Justin Tee" <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714011812.106753-4-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
 <20260714011812.106753-4-justintee8345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 00:57:16 +0000
Message-Id: <20260714005717.3EEAB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch fails to fully resolve the dma_unmap_sg_attrs oops race =
because the validation logic skips counting the I/O during the critical win=
dow before scsi_done() finishes.
- [High] Unprotected concurrent modifications to the bitfield `cmd_flag` ca=
use a Read-Modify-Write (RMW) data race, which can lead to the loss of the =
`LPFC_DRIVER_ABORTED` flag and completely break the synchronization fix.
--

--- Patch [3]: [PATCH v3 03/14] lpfc: Fix kernel oops when unmapping scsi d=
ma buffers for an aborted cmd ---
commit 6bc9dc760f9e39b87bc318946c28662acdff4498
Author: Justin Tee <justintee8345@gmail.com>

lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted cmd

This commit updates the inflight I/O check in lpfc_sli_sum_iocb() to count
I/Os that have either LPFC_IO_ON_TXCMPLQ or LPFC_DRIVER_ABORTED set. This
is intended to prevent a race with scsi_done() during aborts.

> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 62a30a92b7927..10db07771ccff 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -12725,8 +12725,12 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint=
16_t tgt_id, uint64_t lun_id,
> =20
>  		if (!iocbq || iocbq->vport !=3D vport)
>  			continue;
> -		if (!(iocbq->cmd_flag & LPFC_IO_FCP) ||
> -		    !(iocbq->cmd_flag & LPFC_IO_ON_TXCMPLQ))
> +		/* Only count FCP i/o */
> +		if (!(iocbq->cmd_flag & LPFC_IO_FCP))
> +			continue;
> +		/* Count i/o whilst LLDD retains an interest in the scsi_cmnd */
> +		if (!(iocbq->cmd_flag &
> +				(LPFC_IO_ON_TXCMPLQ | LPFC_DRIVER_ABORTED)))
>  			continue;

[Severity: High]
This isn't a bug introduced by this patch, but does this fully resolve the
dma_unmap_sg_attrs oops if the validation logic still skips the I/O when
pCmd is NULL?

In the completion paths, pCmd is set to NULL prior to calling scsi_done():

drivers/scsi/lpfc/lpfc_scsi.c:lpfc_scsi_cmd_iocb_cmpl() {
    ...
	lpfc_cmd->pCmd =3D NULL;
	spin_unlock(&lpfc_cmd->buf_lock);
    ...
	scsi_done(cmd);
}

When the error handling path calls lpfc_sli_sum_iocb(), it appears to rely
on lpfc_sli_validate_fcp_iocb() which excludes the I/O if pCmd is NULL:

drivers/scsi/lpfc/lpfc_sli.c:lpfc_sli_validate_fcp_iocb() {
    ...
	if (lpfc_cmd->pCmd =3D=3D NULL)
		return rc;
    ...
}

Could this cause the I/O to be ignored during the critical window before
scsi_done() finishes, allowing the counter to reach zero prematurely?

[Severity: High]
This is also a pre-existing issue, but can the LPFC_DRIVER_ABORTED flag be
lost due to a read-modify-write data race on cmd_flag?

The abort path sets LPFC_DRIVER_ABORTED non-atomically under hbalock, but
explicitly drops ring_lock:

drivers/scsi/lpfc/lpfc_scsi.c:lpfc_abort_handler() {
    ...
		spin_unlock(&pring_s4->ring_lock);
		ret_val =3D lpfc_sli4_issue_abort_iotag(phba, iocb,
						      lpfc_sli_abort_fcp_cmpl);
    ...
}

drivers/scsi/lpfc/lpfc_sli.c:lpfc_sli4_issue_abort_iotag() {
    ...
	cmdiocb->cmd_flag |=3D LPFC_DRIVER_ABORTED;
    ...
}

Meanwhile, the completion path clears LPFC_IO_ON_TXCMPLQ non-atomically
under ring_lock but without hbalock:

drivers/scsi/lpfc/lpfc_sli.c:lpfc_sli_iocbq_lookup_by_tag() {
    ...
			cmd_iocb->cmd_flag &=3D ~LPFC_IO_ON_TXCMPLQ;
    ...
}

If an I/O completes exactly as the error handler issues an abort, could one
update overwrite the other, causing LPFC_DRIVER_ABORTED to be unset here
and breaking the synchronization fix?

> =20
>  		/* Include counting outstanding aborts */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714011812.1067=
53-1-justintee8345@gmail.com?part=3D3
