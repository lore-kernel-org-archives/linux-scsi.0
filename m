Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E983E3A254D
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451079; cv=none; b=jyqOLGi0MUE+F9Z9AUcwvdV7VGUfqtPFT7OORF2FNxAniIZFZRNHTd/V5zN95gHVmAHzDfpzx9LGFhFhDhlZWaKgcqTH1inAre4XFYcAuoIGZeJQkY/s4e3oV97sv10cJfWrn1iNnVx6ZgRPxjJu+AAiblLn+JSAxcuv/oZv9do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451079; c=relaxed/simple;
	bh=fg5WVeHAiTk0gRnR1QePiFsnB4CtUWbLlB8VFOG+Ink=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=c2nRLIKPAHnxsElnfs9fDHuKOhOxRCMVZzx+MYPlIzojAJQbrnC1hPl64MmFw8UCiOO7O/uJ7R6QIDOydCDnS8xcaUy++OJ+qR7EPmz3AjjdPmN6a7e+UooF73jHXhwJAiSWIc6ve+w+5wzwK72PjcWy9rZCKeK6oufhvGnX1TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8iSmcmn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8iSmcmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6571F000E9;
	Thu, 30 Jul 2026 22:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785451077;
	bh=k84PrMpxYhSPN2fCXMnX23hrrgqS3sVjqV+Su3PME8U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F8iSmcmndkK0osPBjaQ+lZ1PvD8S5/dXiMehiEWOU/1mQdsvSP6C4moUXDE0bgEWM
	 NdbGgC7VdwPhRPEbZa8gkcqgjaoejpORv3XuKmS7cDwFy2aO4AUQGvp2aJtc6oJmG/
	 SSFrHXQaYWXmG+Yz9E80IdiIu50Vgjfna/MRFo3j0goH74wnZuMW5z4ibrJ0xGIMbw
	 YBz4iZIj0NNdO7Itq2tnV8ZzjY9QhD1OWhoiBi2pNaxeksQBKTm1S8V9U1tgBoUzMq
	 24JxiX9cSYhwFY1RIy6fU8NxS/k2T5VwMjBhog9+M3C9/K8Ghz7N+t6q/1QJP4KWEN
	 RlszhCpNdVtyQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH][next] scsi: ibmvfc: Fix spelling mistake "Deleteing" ->
 "Deleting"
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colin Ian King" <colin.i.king@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260730222951.352872-1-colin.i.king@gmail.com>
References: <20260730222951.352872-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 22:37:56 +0000
Message-Id: <20260730223757.4D6571F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Uninitialized stack variable `rport` is evaluated in the NVMe targ=
et deletion loop, leading to indeterminate execution behavior and skipped t=
arget logout/deletion.
--

--- Patch [1]: [PATCH][next] scsi: ibmvfc: Fix spelling mistake "Deleteing"=
 -> "Deleting" ---
commit 815533f3bf155a641d39add28605656b69fb9ce0
Author: Colin Ian King <colin.i.king@gmail.com>

scsi: ibmvfc: Fix spelling mistake "Deleteing" -> "Deleting"

This commit fixes a spelling mistake in a tgt_dbg message during NVMe rport
deletion.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -6141,7 +6141,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhos=
t)
> =20
>  		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
>  			if (tgt->action =3D=3D IBMVFC_TGT_ACTION_DEL_RPORT) {
> -				tgt_dbg(tgt, "Deleteing NVMe rport\n");
> +				tgt_dbg(tgt, "Deleting NVMe rport\n");
>  				nvme_rport =3D tgt->nvme_remote_port;
>  				list_del(&tgt->queue);
>  				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
>  				spin_unlock_irqrestore(vhost->host->host_lock, flags);
>  				if (nvme_rport)
>  					ibmvfc_nvme_unregister_remoteport(tgt);
>  				timer_delete_sync(&tgt->timer);
>  				kref_put(&tgt->kref, ibmvfc_release_tgt);
>  				return;
>  			} else if (rport && tgt->action =3D=3D IBMVFC_TGT_ACTION_DEL_AND_LOGO=
UT_RPORT) {

[Severity: High]
This isn't a bug introduced by this patch, but is it possible that rport is
uninitialized when evaluated here?

Looking at ibmvfc_do_work(), rport is declared as a stack variable:

static void ibmvfc_do_work(struct ibmvfc_host *vhost)
{
    ...
    struct fc_rport *rport;
    ...

If no SCSI targets match the deletion criteria in the earlier loop during
IBMVFC_HOST_ACTION_TGT_DEL, rport appears to remain completely uninitialize=
d.

When the code later reaches the NVMe loop shown above and encounters a targ=
et
with IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT, it evaluates rport in the
condition.

Could this uninitialized memory evaluation cause the target deletion to be
silently skipped if it evaluates to 0, leaving the NVMe target in the
IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT state forever?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730222951.3528=
72-1-colin.i.king@gmail.com?part=3D1
