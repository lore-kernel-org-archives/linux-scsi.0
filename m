Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65906439F89
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 18:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787076810; cv=none; b=qGXvtPw8GuIq+rk2XgtfXR94p2AUb3cHrYYRmuxV4f8YjC9dAu+rlgtpxbniZGld3+6bxCCgZ4YoNva+fHCwGpsQo31e9g1Ly3IlF5xrkRcYg5n5I1TTJuZIsrpF0zD+F/3ilQZvsmSoWDHgYCBke+DGeLaOBL7qQqMWzTmyfGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787076810; c=relaxed/simple;
	bh=TcirySkIIQn1oCa3qhv0T+btH9/wyyoO4JjL3pBR8Xc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CcdxcUkIB7u6/liTvP+6hRmwyvlw5J0o+jYIQkzZrB1snVjaAMfpO4PPpIWrGSghvuTdYzAJ2wK9cU+pv0HL5l5J+Gau/rNhemg/OahbYSQRMVjmoxZ1T4FnZauFTdKw+dQHc2rA+RaT17rlT7DPNrhlO30pU1rD1q3eeGCryx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K3OpAcZ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K3OpAcZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867D91F00A3A;
	Tue, 18 Aug 2026 18:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787076809;
	bh=kARBBJwXV8QOAjIkPWklGFqGnvpzlOpyc6enyrbDgYU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K3OpAcZ60sntLxvAZ/XM5V+EJe+CBZdx2xAr8BhASaxDUTSFjMizFRWlIb8mbuibJ
	 BtsJXRVVJuKo8O6447r5X27NUlg64iVUPAgu+ubSEUK/E+ib9enifPwmU4ZFizpfc/
	 d5apiW18mhy5GMcGZ4rjo3MVlHW4nMu072BHSEF7geymOuTdN1K2ZZt5KtW1LMCmNo
	 otuEATuxRQ6HtGBQGIcxvRn5UaDvnA6F4SLJIDiXq0xxILjdbzIlLQ9jyGoGuM9SCI
	 OT7glAd8SC+i4fQgwouRzj/f5kGYCu+s5Po7h8nRPQt/Tt+jZM/e0vrkJpgFEiKh8T
	 JGIDHc29AhLhA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/17] mpi3mr: Fix out-of-bounds bitmap access during
 device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818231426.58105-9-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-9-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 18:13:28 +0000
Message-Id: <20260818181328.867D91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Placement of the newly added bounds check introduces a delayed com=
mand queue stall and async chain breakage.

Pre-existing issues:
- [Critical] Concurrent lockless modification of delayed lists from process=
 and IRQ contexts.
- [High] TOCTOU race window during delayed command hardware dispatch allows=
 double-free.
--

--- Patch [8]: [PATCH 08/17] mpi3mr: Fix out-of-bounds bitmap access during=
 device removal ---
commit 498a49c2b9e406ac25107bbe9cd216b5c786f292
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix out-of-bounds bitmap access during device removal

Device handles reported by the controller are used to index the remove
pending bitmap and to build a task management request without being
compared against the maximum handle the controller reported.

Check the handle before using it.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index f80a21ec161b6..7ae4b4fad3f4a 100644
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
This is a pre-existing issue, but is there a race window here if the
hardware request completes extremely quickly?

mpi3mr_dev_rmhs_send_tm() sends the request to hardware. Only after it
returns does the code list_del() and kfree() the delayed_dev_rmhs node:

mpi3mr_dev_rmhs_complete_iou()
{
        ...
        mpi3mr_dev_rmhs_send_tm(mrioc, drv_cmd->dev_handle, drv_cmd,
            drv_cmd->iou_rc);
        list_del(&delayed_dev_rmhs->list);
        kfree(delayed_dev_rmhs);
        return;
}

If the completion executes concurrently and triggers another call to
mpi3mr_dev_rmhs_complete_iou(), could it dequeue and dispatch the exact
same node before the first thread has a chance to remove it, leading to
a double-free?

Similar patterns seem to exist in mpi3mr_complete_evt_ack().

[Severity: Critical]
This is also a pre-existing issue, but I noticed there might be unprotected
list operations on delayed_rmhs_list.

The delayed_rmhs_list is appended to in mpi3mr_dev_rmhs_send_tm():

        list_add_tail(&delayed_dev_rmhs->list,
            &mrioc->delayed_rmhs_list);

And it is removed from in mpi3mr_dev_rmhs_complete_iou():

        list_del(&delayed_dev_rmhs->list);

Are these list operations safe from concurrent modifications between process
and IRQ contexts, or should they be protected by a spinlock to prevent
list corruption? Similar patterns exist for delayed_evtack_cmds_list.

[ ... ]

> @@ -2564,6 +2565,12 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_=
ioc *mrioc, u16 handle,
>  	drv_cmd->callback =3D mpi3mr_dev_rmhs_complete_tm;
>  	drv_cmd->dev_handle =3D handle;
>  	drv_cmd->iou_rc =3D iou_rc;
> +	if (handle >=3D mrioc->facts.max_devhandle) {
> +		ioc_err(mrioc, "dev_remove_hs: handle(0x%04x) >=3D max_devhandle(0x%04=
x)\n",
> +			handle, mrioc->facts.max_devhandle);
> +		goto out_failed;
> +	}
> +

[Severity: High]
If handle >=3D mrioc->facts.max_devhandle, the code goes to out_failed.
This frees the command slot synchronously but does not invoke the
completion callback.

If this was called from mpi3mr_dev_rmhs_complete_iou() to process a delayed
command, would this synchronous failure prevent any subsequent delayed
items from being processed since the completion chain is broken?

Also, because this check is placed here, out-of-bounds handles can still be
appended to the delayed_rmhs_list earlier in this function when command
slots are full:

mpi3mr_dev_rmhs_send_tm()
{
        ...
        if (cmd_idx >=3D MPI3MR_NUM_DEVRMCMD) {
                delayed_dev_rmhs =3D kzalloc_obj(*delayed_dev_rmhs, GFP_ATO=
MIC);
                ...
                delayed_dev_rmhs->handle =3D handle;
                list_add_tail(&delayed_dev_rmhs->list, ...);
                return;
        }
        ...
}

Should the bounds check happen before allocating and adding to the delayed
list?

>  	tm_req.dev_handle =3D cpu_to_le16(handle);
>  	tm_req.task_type =3D MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
>  	tm_req.host_tag =3D cpu_to_le16(drv_cmd->host_tag);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.5810=
5-1-chandrakanth.patil@broadcom.com?part=3D8
