Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D81473C8C
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786558903; cv=none; b=AdMNX6c3MwtSEkT8lLcAma/HNorfyp7NKycAuvUzSyJdL8L1jKoNqrJreXInjRNAQpkDiOZbdOK6v2uspbACDhmg5t/xAMyO+LgY6nE3mHhIRs0P6P8OcURiPyqe/nNi3TOYRWp93HjxsWWufw8gAv8cyXiqntCL6ucGwMfWeGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786558903; c=relaxed/simple;
	bh=l7z8WLhycRRnO1gXrwJtbla34+O+a0u9VdGAfdy5Cwk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pq7BFnmqymd0Iog726ZfXVRvVhQB2aKkNulPxkcfJW4fleRk6qjU4FSfYthQolpDZP0iintsDJFfm58kEtcYSgGmye51e4tL4MJpb1uAqEEtUYN1E5Ky46PxRd1/6fBNLh409Guc7y9nzo1pHrtaCuggEaSMJF1fQYpvIfvCvB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXgBEyVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXgBEyVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3207A1F00A3E;
	Wed, 12 Aug 2026 18:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786558902;
	bh=QtpByJ+cQdcwQLOAAKQKB1q26w85hfP9P6tFiIuON+g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aXgBEyVJxYDeeSfxLmCZCo7CZbi2gGSJGwVy5SFzCHB/wOsffifxSFfmJIOajXoKA
	 1mrXOlARcjjCoQPOhtdgv0GPVOnO+MvdqQs2eWbS5KlSub6NB2hFxNQBfBYz/hBxqf
	 sfhtnLRKUJ/u1O9boryZ/DxbRHQ+dXqG/40aeC4IPiw3Kd5ZqNc02Fo37yBi9tWAWb
	 lFgsNtHGuVqx+x6C///HgdVpdTuF/n6aaPbUEyrln4ZotwJC7tu87xwIBK6EQk6riF
	 99wDVR4AVqUWJ2stlWZ/5YMChcscHwRe3Uz+Sv7NZjpBP5r7g9URgSVqGhj8QLZoMO
	 hjhZRnOJwRGCg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/13] nvme: add NVME_CTRL_MARGINAL flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812181300.3712426-3-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
 <20260812181300.3712426-3-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:21:41 +0000
Message-Id: <20260812182142.3207A1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The NVME_CTRL_MARGINAL flag is cleared on the wrong structure's fl=
ags field in the Fibre Channel transport.
- [Medium] The NVME_CTRL_MARGINAL flag is not cleared universally on all co=
ntroller resets, leaving non-FC transports and manual resets permanently in=
 a marginal state.
--

--- Patch [2]: [PATCH 02/13] nvme: add NVME_CTRL_MARGINAL flag ---
commit f9c336bbdc7993d3daa484b869cd6845d7fce7a7
Author: Bryan Gurney <bgurney@redhat.com>

nvme: add NVME_CTRL_MARGINAL flag
   =20
Add a new controller flag, NVME_CTRL_MARGINAL, to help multipath I/O
policies to react to a path that is set to a "marginal" state.
The flag is cleared on controller reset, which is often the case when
faulty cabling or transceiver hardware is replaced.

[ ... ]

> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index 04363b9c4489e..d2ca65f70a0c5 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -788,6 +788,10 @@ nvme_fc_ctrl_connectivity_loss(struct nvme_fc_ctrl *=
ctrl)
>  		"Reconnect", ctrl->cnum);
> =20
>  	set_bit(ASSOC_FAILED, &ctrl->flags);
> +
> +	/* clear 'marginal' flag as controller will be reset */
> +	clear_bit(NVME_CTRL_MARGINAL, &ctrl->flags);

[Severity: High]
Does this clear the flag on the wrong structure?

Here, ctrl is a pointer to struct nvme_fc_ctrl. Clearing the bit on
&ctrl->flags will affect the FC-specific flags field instead of the intended
core NVMe controller flags (&ctrl->ctrl.flags).

[Severity: Medium]
Will other transports remain in a marginal state indefinitely?

The commit message mentions the flag is cleared on controller reset, but the
clearing logic is only added here in the FC-specific connectivity loss hand=
ler.

Should this flag instead be cleared universally inside nvme_reset_ctrl() in
drivers/nvme/host/core.c to ensure PCIe, TCP, and RDMA paths also recover
after a reset?

drivers/nvme/host/core.c:nvme_reset_ctrl() {
    if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING))
        return -EBUSY;
    ...

> +
>  	nvme_reset_ctrl(&ctrl->ctrl);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.3712=
426-1-jtaubepe@redhat.com?part=3D2
