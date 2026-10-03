Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEDD3749F5
	for <linux-scsi@vger.kernel.org>; Sat,  3 Oct 2026 01:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991212; cv=none; b=cDbZYsRiLnR9beWfbluk1xLGxDp7eRUeL2dLmR2zzWvdnUvOmKvYBgcbhz0GvxG+lc9DDs2XmB7nsDd3hoh4InvcCT3Vg6PKlwixgZin82vhNtFk8PhAZ3e51p2A0ywZ0vcuHELik799Rs/Q2d9iptEm8NPYJlcwh5HfQybdb5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991212; c=relaxed/simple;
	bh=zcI/xUH1vecTwKPWWx67KtbSEcO+Dur20GJdmM/30YU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gw7idWXd+7lzu0UQOlfNvKC/6qhK7RwuYBPlvDQwh/0D3bYrq6p637X0EaLA2LNw4lTm37jZfbZC+3LAMBkQl1tJMtxBrjO6spTWA2atP2Zh361AzClNhBMbnx0+AzHBAE78skfBx4D02GV1VreZqlmW2lwsxs0GeiOTp5K6DTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QXG0y8NS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QXG0y8NS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5005F1F00893;
	Sat,  3 Oct 2026 01:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991211;
	bh=Se3KcrsvSIvbxyBV7OUZV7wgzQwHjIjJvnlWMxcRNzI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QXG0y8NSW478En3DnboZc57GHwQA6doD7A3zLqG4FR1j6rQOEkO+ZOUWzscrsiZN2
	 sPI0d6Pa5pmnqzCfxcSQ02ZtksWDvMJOiBTX0hHApHiNEuPpi+0KeKvDpWkDQ+B+oA
	 0mQstkDz1J38EhOn0I/zG7HSQWBnj8Z/MgD5uARU45tJv/jpFFC9AhOknYGbhmlnrS
	 5ijushsj1vNQt3N/OyHvJMjLVWXuoSyuyK5xGdAS17W1+J4mKT4lqzu5exJye2GwFv
	 MtXZ6+II9MHFERCe3OVK5+8LsiLa8vyizI0enwu3SV/W7RI+wng0PeDXyq9qPWLa21
	 OpbqE1jfC3+jg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6.y v2 2/2] scsi: lpfc: Handle mailbox timeouts in
 lpfc_get_sfp_info
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Dinaburg" <artem@trailofbits.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261002182205.11550-3-artem@trailofbits.com>
References: <20261002182205.11550-1-artem@trailofbits.com>
 <20261002182205.11550-3-artem@trailofbits.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:33:30 +0000
Message-Id: <20261003013331.5005F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] scsi: lpfc: UAF and double free due to unsafe mbox read on tim=
eout
- [High] scsi: lpfc: memory leak of mailbox resources on MBX_NOT_FINISHED
--

commit 0ed08ec0a3a90cbf8a1c312188b0a42b103960f6
Author: Justin Tee <justin.tee@broadcom.com>

scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info

The MBX_TIMEOUT return code is not handled in lpfc_get_sfp_info and the
routine unconditionally frees submitted mailbox commands regardless of
return status.  The issue is that for MBX_TIMEOUT cases, when firmware
returns SFP information at a later time, that same mailbox memory region
references previously freed memory in its cmpl routine.

Link: https://lore.kernel.org/r/20240628172011.25921-6-justintee8345@gmail.=
com

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 8ef571498d846..aae08ad0f332b 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -7309,13 +7309,13 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
>  	}
>  	mbox->vport =3D phba->pport;
>  	mbox->ctx_ndlp =3D (struct lpfc_rdp_context *)rdp_context;
> -
> -	rc =3D lpfc_sli_issue_mbox_wait(phba, mbox, 30);
> +	rc =3D lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_SLI4_CONFIG_TMO);
>  	if (rc =3D=3D MBX_NOT_FINISHED) {
>  		rc =3D 1;
>  		goto error;
>  	}

[Severity: High]
If lpfc_sli_issue_mbox_wait() returns MBX_NOT_FINISHED, execution jumps to
the error path where the newly introduced check requires the LPFC_MBX_WAKE
flag to be set.

Since MBX_NOT_FINISHED implies the command was not queued, no asynchronous
completion will execute to free it, and LPFC_MBX_WAKE was not set. Does this
cause a permanent memory and DMA buffer leak?

> -
> +	if (rc =3D=3D MBX_TIMEOUT)
> +		goto error;

[ ... ]

> @@ -7380,8 +7383,10 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
>  			     DMP_SFF_PAGE_A2_SIZE);
> =20
>  error:
> -	mbox->ctx_buf =3D mpsave;
> -	lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
> +	if (mbox->mbox_flag & LPFC_MBX_WAKE) {

[Severity: Critical]
If lpfc_sli_issue_mbox_wait() times out, it assigns ownership of the mbox
structure to the asynchronous background handler lpfc_sli_def_mbox_cmpl()
before returning MBX_TIMEOUT.

Can an interrupt handler fire and completely free the mbox memory right aft=
er
the timeout lock is dropped in lpfc_sli_issue_mbox_wait()?

If so, does reading mbox->mbox_flag here result in a use-after-free, and
potentially a double free if the memory is quickly reallocated to another
context that sets the LPFC_MBX_WAKE bit?

> +		mbox->ctx_buf =3D mpsave;
> +		lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
> +	}
> =20
>  	return rc;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002182205.1155=
0-1-artem@trailofbits.com?part=3D2
