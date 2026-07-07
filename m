Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFBB4252CF
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409642; cv=none; b=O0pqrqNdFE6fgxIgE1NIZNTBTb1uucd8y9nSShrbLUFDpbExmj640j3frkOBE17QNL6TDagB4NSfjsfxMzAAwoIG46kZs8vY8j6k6Y77Ru9fcYIUdrYLAsEFEv2HveL7gxLCOaN5UNzgNkqps8TNC0/e2YKx9FGMfknXMzeD5Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409642; c=relaxed/simple;
	bh=tmMouBMBoPhbOG0gRJzJXd5ummrlaEQKdMxaAPNaMK0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pBPTLKaXLvJf4leHFv9BU2bGtNyCyYT3tIA3VM2884OJ1btdAe+FPxe9zfthXfojJgqpPM/yq6y4zInoTUSyCsjdxbmfT4cJlUvQ1OyGu7838ram+4fkC/t3dO549zvq/QUDHg5M6MsKriHDCERo5miI5+j6PonMImZOSfa0Inw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=maWgj1fw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="maWgj1fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E181F000E9;
	Tue,  7 Jul 2026 07:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409641;
	bh=CZqHfS0WN9U1Sa+WGpQxtokDLrWh0SWf9GyTlalRzus=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=maWgj1fw05vRKIgLjc23aigjymj1hz592ktUNHfUuuhLbIfW75YiNnAvd9HO1KbPq
	 j6CAegNNVICDd+fYVt+15VSuM+ZlUIlWArR+i6At2MO+2jdRRYBWFvL85X+azGYH+P
	 5+DXpmy22q6aPmWHQBuf2GWHpcSFv/eD1zHF6ktHaZv0JRuVTgV1lD1oXHXWsH72HY
	 BvuHhupfopipKdoSQbelcRnnYtb9OJkIDj+WT+rMtd8EAtxBwEpUSlUL4mCK0aMfwX
	 AKHTvWfetEOlOoYu61tESkq06udLCFA/6UZ1UpejhsXfF3Fl5NbWEjuCydD1BSJaKB
	 epOx5EEtXI+BQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 81/88] scsi: qla2xxx: Unlink NVMe unsol ctx before
 freeing on LS reject error
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-82-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-82-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:34:00 +0000
Message-Id: <20260707073401.64E181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Lockless list manipulation of `fcport->unsol_ctx_head` leads to da=
ta races and list corruption.
- [High] `fcport` is freed without canceling or synchronizing background pu=
rex tasks, leading to Use-After-Free when those tasks access `uctx->fcport`.
--

--- Patch [81]: [PATCH v3 81/88] scsi: qla2xxx: Unlink NVMe unsol ctx befor=
e freeing on LS reject error ---
commit f4f1b05ef4c1210be894b2dc013ef3b077996e9e
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Unlink NVMe unsol ctx before freeing on LS reject error

This patch addresses a potential list corruption issue in the NVMe
unsolicited context handling. It unlinks the context from the list
before freeing it on the error path. This ensures that subsequent operations
on the fcport list do not interact with freed memory.

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 28a04e0ff660b..36b742f73abf3 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
[ ... ]
> @@ -446,6 +446,7 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_p=
ort *lport,
>  		qla_nvme_ls_reject_iocb(vha, ha->base_qpair, &a, true);
>  		spin_unlock_irqrestore(ha->base_qpair->qp_lock_ptr, flags);
>  	}
> +	list_del(&uctx->elem);

[Severity: High]
This isn't a bug introduced by this patch, but is it safe to manipulate
the list here without any locking?

Elements are added to the list without synchronization in the hardware
response interrupt context:

drivers/scsi/qla2xxx/qla_nvme.c:qla2xxx_process_purls_iocb() {
    ...
    INIT_LIST_HEAD(&uctx->elem);
    list_add_tail(&uctx->elem, &fcport->unsol_ctx_head);
    ...
}

Items are also removed from a workqueue context without locking:

drivers/scsi/qla2xxx/qla_nvme.c:qla_nvme_release_lsrsp_cmd_kref() {
    ...
    list_del(&uctx->elem);
    ...
}

Since operations can execute concurrently across multiple CPUs asynchronous=
ly,
will this unprotected list_del() modification lead to further list
corruption and kernel oops from non-atomic pointer updates?

[Severity: High]
This is a pre-existing issue, but does this code correctly handle the
lifetime of the fcport pointer?

When an fcport logs out, it can be freed directly:

drivers/scsi/qla2xxx/qla_init.c:qla2x00_free_fcport() {
    ...
    qla_edif_list_del(fcport);
    kfree(fcport);
    ...
}

If a background task is simultaneously processing queued items, it might
access the freed structure:

drivers/scsi/qla2xxx/qla_nvme.c:qla2xxx_process_purls_pkt() {
    ...
    ret =3D nvme_fc_rcv_ls_req(uctx->fcport->nvme_remote_port, &uctx->lsrsp,
                 &item->iocb, item->size);
    ...
}

Since qla2x00_free_fcport() doesn't appear to cancel pending work or clear
vha->purex_list, could this sequence cause a use-after-free when the target
drops connection after sending an unsolicited NVMe LS packet?

>  	kfree(uctx);
>  	return rval;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D81
