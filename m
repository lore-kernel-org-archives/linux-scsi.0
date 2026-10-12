Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3803F20E3
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 09:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791796492; cv=none; b=QdzHDq1+rh3aSeYR6Q4+TIJ2pMYecXQI9IJV+5VBfObnO2dnePniTyvcb/e44lxv1vTGcP+xW5MqZvskvBwQyUGGGUA71vY/TTGHajN5eRdwkfUWsYlkFLzQk92DSe+tWBWI6HrgKjFxu34TE/7kxJFwGtWplYXWMmRovWrLyho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791796492; c=relaxed/simple;
	bh=X12NjU/kr2zJ3EiF5SelFDjQMzSS7AV3sARxqQrfXEo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=TpEdpKgcq1iffDeVk9hAM9rUYOCBbDNVwKhzvRA67tCECHmBpgAUiTSiCwznDVB5RXbAQiUVLqS0s3FXbXTuvhcl30eIPGcAtukGCZ2RP9Ejqe/0jDj1iHkmV2RK9enlSDFUZBiPbnzHyVt1rZ/aK0S7tMT/fC8Yd8pfUvpzF/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lWVud+lN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lWVud+lN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7491F0089B;
	Mon, 12 Oct 2026 09:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791796488;
	bh=1QLLaKenDg2KK+c0SoiWxnzWYgkIJpt6T2LNRHScu1o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lWVud+lNkFg5qE8rkgX9a6S8bBoBtAQFfI//20HMoq8lx7kURRfbosNR4ablQJxjv
	 k1ZNtiseHYyVAihVE/BzFPI7fpal5t2o28Mox9KsRQNUo3EwDQfVLjTJzfhi8CdcAP
	 fImem/QjUPLLxyCKdwlSJBPQUZZRKP/11ze+kp0fU3S/x+MoHUxteIlM92yko6HsY+
	 v/N2L9Gc8y4y+IdMuRpmAqlh3B/DLBlDh8NLdOyErVizfyzANnEFWmWVpfJLJHOJS0
	 gNoQRMAJhz6QqwCE/FR4xeTP4dZwzhbRV8M1sIBzuGZY8YAfa/jUaI/p+qqaFdS/an
	 /BuLKDnKACUwA==
Message-ID: <sashiko-outbox-167888@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] scsi: arcmsr: check the completion index the
 adapter reports
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <a9c7e18a8f392d216301a3e08b69a47d7981e1c9.1791792888.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791792888.git.yhlee@isslab.korea.ac.kr>
 <a9c7e18a8f392d216301a3e08b69a47d7981e1c9.1791792888.git.yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 09:14:48 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] scsi: arcmsr: incomplete bounds check allows NULL pointer dere=
ference
--

commit 12ade927afc5ca1b453d068ce2fc5d1af8777cd0
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: arcmsr: check the completion index the adapter reports

This commit adds bounds checks in the interrupt and polling handlers for
adapter types E and F. It validates that the completion index reported by
the adapter does not exceed ARCMSR_MAX_FREECCB_NUM to prevent out-of-bounds
array accesses when retrieving command control blocks.

> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcms=
r_hba.c
> index 255f1d898079f..9519715883b5a 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -2677,6 +2677,14 @@ static void arcmsr_hbaE_postqueue_isr(struct Adapt=
erControlBlock *acb)
>  	pmu =3D acb->pmuE;
>  	while ((readl(&pmu->reply_post_producer_index) & 0xFFFF) !=3D doneq_ind=
ex) {
>  		cmdSMID =3D acb->pCompletionQ[doneq_index].cmdSMID;
> +		if (cmdSMID >=3D ARCMSR_MAX_FREECCB_NUM) {

[Severity: Critical]
Is this bounds check tight enough?

The commit message notes the choice to bound against ARCMSR_MAX_FREECCB_NUM
(1024) instead of acb->maxFreeCCB. However, the acb->pccb_pool array is
only populated up to acb->maxFreeCCB (which defaults to 192).

This leaves array elements between acb->maxFreeCCB and 1023 uninitialized
and set to NULL. If a malfunctioning or malicious adapter sends a cmdSMID
in this gap (e.g., 200), it bypasses this bounds check.

The driver will then retrieve a NULL pointer for the CCB and blindly
dereference it in arcmsr_drain_donequeue():

drivers/scsi/arcmsr/arcmsr_hba.c:arcmsr_drain_donequeue()
    if ((pCCB->acb !=3D acb) || (pCCB->startdone !=3D ARCMSR_CCB_START)) {
        ...

Could this regression lead to a NULL pointer dereference panic? Would it
make sense to add a check to ensure the retrieved CCB pointer is not NULL
before passing it to arcmsr_drain_donequeue(), or enforce a stricter bound
that correctly handles the uninitialized pool entries?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791792888.gi=
t.yhlee@isslab.korea.ac.kr?part=3D2
