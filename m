Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D564133B96B
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 16:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787674265; cv=none; b=c9g84USMGcOYfyevTnDdPlCRJ1kpFwqe6Gd61zrgACdVPVT2XxaqFP692hoakAm0Otp5hMUeD2Xb1DIw6mIz6Obijm8fnv7dPAc1Il2niYaTdA6iVTOfguQuChGnqiGl4QlVBgCuN/vs8AY54JayhHPw/8SJf5I10LxlF8fr6d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787674265; c=relaxed/simple;
	bh=VEVnGISsauwxUMZUuU8kfqfJehQIJbVTX/KCJi6iKQg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kL1iDBy9RFtTkM9B5ZwKVxbcQ28mVRHRHyuyZrXuA8S5O6LlZBLmJx80XwRGN0b+p7s5JuiMyZ8oe72J4Lloa4q61UmDADcFzg+DWks2HpxlQtZ/zLAKiWxGg3BB/7Me2Ih5GJsEZFER/fTi+W8fVfP9v7mnck2p8ozwp0Fct1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ry9pDO7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ry9pDO7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314D81F00A3A;
	Tue, 25 Aug 2026 16:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787674263;
	bh=wUSZCsCN/LEGjx20jCzSuryy5td5x0jLQKnIezGya38=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ry9pDO7iIfOJG9sMJyZxLRwlhlxTDBnL56vcQao+OEc/MSP77kMZhtKeqrbBM+mbM
	 LznV+cW8eqBx5/9PLF3b4s/T5btYdVRvhe0UkwqAM8YjRWF0b/jq5jUAl1KpkNQnZr
	 mVUkklpYnuehxiVfrGd6GCdT7zyBoETpF+safTM8M8LiqGkeVk2+6aVruJq/EIlZlu
	 ZxW5K9KFYMAZrN+6j0hbYCLfyfrOzCm6rUvbVya6toNZ2UMLQhBSpx4kGg8qtYxlCc
	 shtvCq5DInDi91/1D+/IbEdegmZocaESAyNKLdqJT7w5/jPvmaZIk02beNSX36B/YC
	 uajUvmgc2ugEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/17] mpi3mr: Fix out-of-bounds bitmap access during
 device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-9-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-9-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 16:11:02 +0000
Message-Id: <20260825161103.314D81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Failure to dispatch a Task Management request permanently strands =
the delayed device removal queue.
- [High] Silent failure during memory allocation drops device removal reque=
sts.
--

commit caefa471752245fefd26d7a88577789dca45c515
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix out-of-bounds bitmap access during device removal

This commit checks the device handle before indexing the remove pending
bitmap or building a task management request, preventing out-of-bounds
access if the controller reports an invalid handle.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index f80a21ec161b6..2a35f146fe69b 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2401,7 +2401,8 @@ static void mpi3mr_dev_rmhs_complete_iou(struct mpi=
3mr_ioc *mrioc,
>  		ioc_info(mrioc,
>  		    "%s :dev removal handshake completed successfully: handle(0x%04x)\=
n",
>  		    __func__, drv_cmd->dev_handle);
> -		clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
> +		if (drv_cmd->dev_handle < mrioc->facts.max_devhandle)
> +			clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
>  	}
> =20
>  	if (!list_empty(&mrioc->delayed_rmhs_list)) {

[Severity: High]
This is a pre-existing issue, but does a dispatch failure permanently strand
the delayed device removal queue here?

If mpi3mr_dev_rmhs_send_tm() is called to process a delayed TM request, but
mpi3mr_admin_request_post() fails during dispatch:

    retval =3D mpi3mr_admin_request_post(mrioc, &tm_req, sizeof(tm_req), 1);
    if (retval) {
        ...
        goto out_failed;
    }
    ...
out_failed:
    drv_cmd->state =3D MPI3MR_CMD_NOTUSED;
    clear_bit(cmd_idx, mrioc->devrem_bitmap);

The command is marked as unused and dropped. Because
mpi3mr_dev_rmhs_complete_iou() only dequeues one element from
delayed_rmhs_list and does not loop if the dispatch fails, the active
command slot becomes idle.

Does this break the chain of asynchronous completions, leaving any remaining
elements in the delayed list stranded indefinitely?

> @@ -2515,6 +2516,20 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_=
ioc *mrioc, u16 handle,
>  	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
>  	unsigned long flags;
> =20
> +	if (handle >=3D mrioc->facts.max_devhandle) {
> +		ioc_err(mrioc, "dev_remove_hs: handle(0x%04x) >=3D max_devhandle(0x%04=
x)\n",
> +			handle, mrioc->facts.max_devhandle);
> +		if (drv_cmd) {
> +			cmd_idx =3D drv_cmd->host_tag - MPI3MR_HOSTTAG_DEVRMCMD_MIN;
> +			drv_cmd->state =3D MPI3MR_CMD_NOTUSED;
> +			drv_cmd->callback =3D NULL;
> +			drv_cmd->dev_handle =3D MPI3MR_INVALID_DEV_HANDLE;
> +			drv_cmd->retry_count =3D 0;
> +			clear_bit(cmd_idx, mrioc->devrem_bitmap);
> +		}
> +		return;
> +	}
> +
>  	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);

[Severity: High]
This is a pre-existing issue, but does a memory allocation failure silently
drop device removal requests here?

Later in mpi3mr_dev_rmhs_send_tm(), if no slots are available in
devrem_bitmap, the code falls back to adding the request to the delayed
list:

    if (cmd_idx >=3D MPI3MR_NUM_DEVRMCMD) {
        delayed_dev_rmhs =3D kzalloc_obj(*delayed_dev_rmhs, GFP_ATOMIC);
        if (!delayed_dev_rmhs)
            return;

If the atomic allocation fails, the function returns silently without
propagating an error. Can this result in the controller waiting
indefinitely for a handshake if the removal event is lost?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D8
