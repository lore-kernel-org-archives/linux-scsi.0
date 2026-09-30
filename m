Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A03371CF8
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 02:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790736964; cv=none; b=HsY3RF4XT9NlsrJd/f5N3e37j8LFxHPobF/pCAf7f1U+8M9js33n5AwrMj0E6BzCXzLrq6Wb46RcC3V630Mx1rVSLf3oJZCQTnoBClWKGMsxB1NIkmQVDcve+tm8QP/gXx3WIaEDeNHK+ku/KVOfNga9QcFW/xxvppNlpJ/bGWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790736964; c=relaxed/simple;
	bh=Wa2UpW0YART53hpnk8V8plXnSF3zDLPNHGAMKiCBecU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Xb6T66rUi9R81yjfYD2x+PZ9LTSsN1juyXfJnVQmUGCWHOQwsxWHrPnmEyqI70Ez7zuCIq06BwmU7NeA/7Cd0utJPpQvl157zd7XAuTcJyadiEU/bPxZlxQD1QvT12ud78YNNlBSkbKjuPNnCWhTr0IOiUV2BOwTfpM7V8K7h4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OEX7/ZRQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OEX7/ZRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B219A1F000FF;
	Wed, 30 Sep 2026 02:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790736960;
	bh=VGwZnvbCucnYwv7qI7qeNwwPRR35ivAMff8xZrXNSKk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OEX7/ZRQ3pjceZqQH4HYYbB4Ycab5LtkWxZJV1m+X/FOUVQiz7WeMUklw6stmoj6/
	 vZufT2U8SUaxmO7sNvc2A6XDYzdD56PJUZ6c3XBNC0SUuwd7q2ZlTDfWHPuUizWpHr
	 r7mK1HDJAsvRRT6S+gpYwkpVi99+LbZIhZ0034AJrfghO2TFlsX1di4RX8NvJxOijn
	 yEIcAE6k76vnoxyigcKUMQFoYgUHa8gjxG+C0PmrX2mDzG1yUQ8cPZYhF7mQ2UeH+/
	 JNEdI9T9derdj0ex+17jRx/FaQBwHshUXRhmq64TOkcvSM8DF2bpV9BbESHJu3t3/2
	 OehMgsMLfAG3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6.y] scsi: lpfc: Handle mailbox timeouts in
 lpfc_get_sfp_info
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Dinaburg" <artem@trailofbits.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260930024505.96440-1-artem@trailofbits.com>
References: <20260930024505.96440-1-artem@trailofbits.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 02:56:00 +0000
Message-Id: <20260930025600.B219A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: lpfc: Use-After-Free and data race due to lockless mbox assi=
gnment
- [Medium] scsi: lpfc: memory leak of mbox and mpsave on synchronous issue =
failure
--

commit 7e8ff891a4886b3f83580607c0dc5ee36c6f7ce1
Author: Justin Tee <justin.tee@broadcom.com>

scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info

This commit adds checks for the MBX_TIMEOUT return code in lpfc_get_sfp_inf=
o,
avoiding unconditional frees of timed-out mailbox commands. The timeout is
also increased from 30 to 60 seconds to accommodate boot scripts.

Link: https://lore.kernel.org/r/20240628172011.25921-6-justintee8345@gmail.=
com

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 2e9972a587810..d319df7d36137 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -7381,7 +7384,8 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
> =20
>  error:
>  	mbox->ctx_buf =3D mpsave;

[Severity: High]
If lpfc_sli_issue_mbox_wait() times out, it transfers ownership of the mail=
box
by setting:

drivers/scsi/lpfc/lpfc_sli.c:lpfc_sli_issue_mbox_wait() {
    ...
    } else {
        retval =3D MBX_TIMEOUT;
        pmboxq->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
    }
    ...
}

Does modifying mbox->ctx_buf locklessly here introduce a data race with the
asynchronous completion handler?

If the hardware completes the mailbox command and lpfc_sli_def_mbox_cmpl()
runs concurrently, could it read an invalid payload pointer leading to a cr=
ash
in lpfc_mbox_rsrc_cleanup(), or cause a use-after-free write on the freed
mbox struct?

> -	lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
> +	if (mbox->mbox_flag & LPFC_MBX_WAKE)
> +		lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);

[Severity: Medium]
When lpfc_sli_issue_mbox_wait() returns MBX_NOT_FINISHED, the LPFC_MBX_WAKE
flag is not set since the command failed to queue.

Will skipping lpfc_mbox_rsrc_cleanup() here leak the mbox and mpsave memory
on synchronous failures, since the async completion handler will never run =
to
clean them up?

>  	return rc;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930024505.9644=
0-1-artem@trailofbits.com?part=3D1
