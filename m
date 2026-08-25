Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ECF33CE80
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 16:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787673937; cv=none; b=jW3TrpgyKXoT/tIQs/kl/Hy/q9Byzte8HjbCjL+nUX+CUwNXHdNVD3sBNmFEtIvHPI4fdGkm+grWZ5Vc+J0RJP486fk6RuEIueTbyUCi9XLxAQckGmlUxVQGm/FViJW857JGyyJuoWo6z+Gy0+rm5JSqCqORTVKq2BvamuXC7Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787673937; c=relaxed/simple;
	bh=MqcVRQHXCs7eu0kAKoSS0vdccFI9yiYJiH6Slq5d8sM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DlO5ABnbSLpQfp2yWwEtk+lJ0oMxvFklSJXD2/U2VfNMsLMx2K8cLjoMW+8XGoRoc4E26l4KpM8HF7gcSlEslF0/dfqjrGY/SAn6AGldcNbihlyINJF1am5B4EDuSz3aP8Hzaw777JU2YU/DlG1bvAUSuavRWvDrUOvFhluOPMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VvU2pLrU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VvU2pLrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD3E1F00A3A;
	Tue, 25 Aug 2026 16:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673935;
	bh=3PLo6w6PwGFI0MKhf6ig3idh1FHdQSrZzGsAn6sxWFs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VvU2pLrU04O1xF7DLbzQZJEg9Ob/NtEsGWUBcXt2RgBADGY5+7KEZ3lRH8H+LNZmk
	 8Rzn3lkhg8vaGIH7hLI6XGc6ujXzZOgLFWg5rqgHGqsJEpcv+omMa4Hd3pLBpxSyfU
	 0G0wG434Y9MBVx/WrnX9JP220Zo7h4mygx/9nkgf7RQyUfc4tKFkFkfl/JegB9/kD0
	 4IOpm73/UfE0y3b0fRVQ9DF1uRUQxDQr2LrjGPAUEzXg9itrxouC0wOzE4zHh/RaKs
	 jE/knFXED78y+gG+LPdLv4vM/QQVMnTeYOi6b+5z0yB4RimyTP67kizZnDcEkrDMbg
	 jKkto3oQioApw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/17] mpi3mr: Fix target device reference leak in
 BSG task management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-5-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-5-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 16:05:34 +0000
Message-Id: <20260825160534.CAD3E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Time-of-check to time-of-use (TOCTOU) race condition leading to a =
Use-After-Free on `stgt_priv`.
- [High] Data race between BSG timeout handling and admin reply ISR causing=
 a Use-After-Free on `sense_buff_k`.
- [Medium] Missing endianness conversion when reading `dev_handle` from `mp=
i3_scsi_task_mgmt_request`.
--

commit da89cfba68bbe3f0b3052ef72f3e8e056a2cdb4d
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix target device reference leak in BSG task management

This commit fixes a reference leak for the target device in the BSG task
management path. It ensures the reference is dropped whenever the device
lookup succeeds, regardless of whether the SCSI target data is fully set up.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index a4fe10a05cb3a..94b992acb2330 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -2745,10 +2745,12 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bs=
g_job *job)
>  	}
>  	if (block_io) {
>  		tgtdev =3D mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);

[Severity: Medium]
This isn't a bug introduced by this patch, but is dev_handle missing an
endianness conversion here?

It appears dev_handle is read natively from the request structure:

mpi3mr_bsg_process_mpt_cmds() {
    ...
    dev_handle =3D tm_req->dev_handle;
    ...
}

Since dev_handle is defined as little-endian (__le16) in
struct mpi3_scsi_task_mgmt_request, could Big-Endian systems read a
byte-swapped value, causing mpi3mr_get_tgtdev_by_handle() to look up the
wrong device?

> -		if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata) {
> -			stgt_priv =3D (struct mpi3mr_stgt_priv_data *)
> -			    tgtdev->starget->hostdata;
> -			atomic_inc(&stgt_priv->block_io);
> +		if (tgtdev) {
> +			if (tgtdev->starget && tgtdev->starget->hostdata) {
> +				stgt_priv =3D (struct mpi3mr_stgt_priv_data *)
> +				    tgtdev->starget->hostdata;
> +				atomic_inc(&stgt_priv->block_io);

[Severity: High]
This is a pre-existing issue, but does caching stgt_priv here create a
use-after-free risk later in the function?

When a user-space process issues a blocking command, the thread will wait
for completion:

mpi3mr_bsg_process_mpt_cmds() {
    ...
    wait_for_completion_timeout(&mrioc->bsg_cmds.done, ...);
    if (block_io && stgt_priv)
        atomic_dec(&stgt_priv->block_io);
    ...
}

If the target device and its hostdata are concurrently destroyed while the
thread is blocked, tgt_dev->starget is cleared:

mpi3mr_target_destroy() {
    ...
    tgt_dev->starget =3D NULL;
    ...
}

If this race occurs, wouldn't the BSG thread wake up and dereference the
freed stgt_priv pointer when calling atomic_dec()?

> +			}
>  			mpi3mr_tgtdev_put(tgtdev);
>  		}

[Severity: High]
This is also a pre-existing issue, but is there a data race in the BSG
timeout handling that can cause a use-after-free on the sense buffer?

In the timeout path, the user thread locklessly clears the pointer and
frees the memory:

mpi3mr_bsg_process_mpt_cmds() {
    ...
    mrioc->bsg_cmds.sensebuf =3D NULL;
    mrioc->bsg_cmds.state =3D MPI3MR_CMD_NOTUSED;
    ...
    kfree(sense_buff_k);
    ...
}

If the admin reply ISR executes concurrently and checks the cmdptr->sensebuf
condition before it is cleared:

mpi3mr_fw.c:mpi3mr_process_admin_reply_desc() {
    if (sense_buf && cmdptr->sensebuf) {
        cmdptr->is_sense =3D 1;
        memcpy(cmdptr->sensebuf, sense_buf, MPI3MR_SENSE_BUF_SZ);
    }
    ...
}

Could the ISR execute memcpy() into the freed sense_buff_k memory block?

>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D4
