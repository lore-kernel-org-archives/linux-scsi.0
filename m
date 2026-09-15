Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B742B2E762C
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 05:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450588; cv=none; b=m5Y53V0j0v+72GCCksd8MuL3tx/Uy/3Fuvv38u5iZfmzB17d5qDSFrbAABmLWLwlIGkwfcq5pfbxqTZSgO2d/vu2s+oknwYRaS6Br9+mEN3PPQ9Xz27FzvGD67ae+hjdVEwI0T4u+rwJASLpbflfrEl5A/2kjU/ilb9OKLnBlZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450588; c=relaxed/simple;
	bh=HMj9wk6JPmipO1EEJJ5ZydDQts1LKMyFxVguC6UyrO4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I6iIg3rc/n1lTgXCXElN/BCp/LBcoFZw8DpuC2Cz1n7O3NHiwj/WzTPbhRcI7ypb9GcIoJmMwvdsJCNOrky9719458FQxt+iJI+w7Nkgln/SGl1Vq4QM1IBsOZX+upDLu4Cr6ZNa2pTYfgsb61n2ypOzydTIHOqet7mEpTxaHw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JPOrq/gB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JPOrq/gB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311101F000FF;
	Tue, 15 Sep 2026 05:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789450587;
	bh=Bq9MciWnaQu0BuYvWcr3OwWWuW3TGrI9iSYrJgll2sc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JPOrq/gBto2J0QS3J0u6he9woYY3mfXiVhKd6x4qLTtW4i8ykITQ0YHTrtsMqijf9
	 HWr44Aa0TJYBPIVv4L4RSKoxPddnhqBz74wTpHTTZ9Azz6cLXcjrenGDVwtb5MkdVF
	 1kTwSSHMsT0XmXIs2IXIHVjJ1XAa5MuYqBAPdT12NMj1NkqCnSO03mVbqMoV/AfP0T
	 sBs4DwiufWzbNIt22AYbLW6aJgvSFGCFUywXhL9TkHnr+dj7aU9ZpkAe3QCMf9AcCe
	 qndVPWqEJsKd86HHruez1AMrFye1kQo0JfryZ/ZM7vFVx1eGhwdQdHhlONX7ubsaoA
	 ACkaWaB53EewA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.18.y] scsi: ufs: core: Re-arm the device command
 completion before submitting
Reply-To: sashiko-reviews@lists.linux.dev
To: alice.chao@mediatek.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260915052638.459390-1-alice.chao@mediatek.com>
References: <20260915052638.459390-1-alice.chao@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 05:36:26 +0000
Message-Id: <20260915053627.311101F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ufs: data race on completion.done via reinit_completion()
--

commit bd0e388ed86b6eb0eec312ed2150d925d6dc5c8a
Author: Alice Chao <alice.chao@mediatek.com>
scsi: ufs: core: Re-arm the device command completion before submitting

This patch re-arms the hba->dev_cmd.complete completion immediately before
submitting a device command. This aims to prevent using a stale completion
from a previously timed-out command, particularly in MCQ mode.

> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -3312,6 +3312,15 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hb=
a, struct ufshcd_lrb *lrbp,
>  {
>  	int err;
> =20
> +	/*
> +	 * A device command that timed out may still be completed by the
> +	 * controller later on. hba->dev_cmd.complete is shared by all device
> +	 * commands, so re-arm it here, immediately before submitting, to keep
> +	 * such a late completion from being mistaken for the completion of
> +	 * this command.
> +	 */
> +	reinit_completion(&hba->dev_cmd.complete);

[Severity: Medium]
Could this introduce a data race with concurrent interrupt-driven completio=
ns?

Looking at ufshcd_compl_one_cqe(), if the completion queue entry for a
previously timed-out command arrives right as we submit a new one, the IRQ
handler will call complete() on this shared completion.

The complete() function takes x->wait.lock and performs a read-modify-write
on x->done. However, reinit_completion() performs an unlocked plain write
setting x->done to 0.=20

If these run concurrently:

CPU1 (CQE handler)
ufshcd_compl_one_cqe()
  complete(&hba->dev_cmd.complete)
    spin_lock_irqsave(&x->wait.lock, flags);
    x->done++;
    spin_unlock_irqrestore(&x->wait.lock, flags);

CPU2 (Submitter)
ufshcd_issue_dev_cmd()
  reinit_completion(&hba->dev_cmd.complete)
    x->done =3D 0;

Since ufshcd_issue_dev_cmd() only holds hba->dev_cmd.lock to serialize
submitters but doesn't synchronize with the asynchronous CQE handler, this
concurrent access to x->done violates the memory model and could lead to
lost or spurious completions.

Would it be safer to drain the completion instead, perhaps by looping
with try_wait_for_completion() rather than performing a plain write?

> +
>  	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
>  	ufshcd_send_command(hba, tag, hba->dev_cmd_queue);
>  	err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915052638.4593=
90-1-alice.chao@mediatek.com?part=3D1
