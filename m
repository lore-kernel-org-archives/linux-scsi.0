Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46E02BD0B
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 07:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791791553; cv=none; b=Np+RcoJ2RqjyVvk/qDdpVI6FlYgO0+Pe0O+GfoPpE1EDbuUtJhovM9EZSZImXgzZRsdkfMh5bLquMjPtyRVwh7pJN0tYMHFu7LGXwAYvvuGy20Wi7WquYOZBQLIXClo+1kTfdcwJuRGeQzbN3NdbwRs+3hVcgFnsHXy5sGiPESk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791791553; c=relaxed/simple;
	bh=Yjvfpzm4K+cl7+a5orrpni4XzrVKo24SDISDCrIpwkM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=CpjicGF8nZPn2rnGFyuw//YDsRsFu44G0fc7o4h/lRAwBeYXFaczAjz/Ny4xmNAfIMPAN+5svpAZWDD9eqCwBrtu6O8bVlwDmV/An7AbH/DgvZSYCZv5N7PMf93+4CeMs3MAWVl8932mFtfSu0ovX0gzj6Vd0u2xRpK3rGc3W9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ARY7syxI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ARY7syxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA251F0089B;
	Mon, 12 Oct 2026 07:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791791552;
	bh=MZg/TrtJ6P5tnq2xxm58hb4Y0X1G0uk2JVhhw22CZbo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ARY7syxIhqm7B9fuNhgSrbS2x929dmEbdJfe0KEcx+ZzcxEwNICTh6sGi0QuDW7zY
	 8RoSHX8pHqobPMHPOuqlzIscMRm7A23iQy484cmvrer0Mbp5C9+/A/uLxoscJfPR75
	 v9eWEWm8976yseT8oBuySuzt2EYVsbo5cckAyebJQ9Mngtj6DX7BCM8mUib/eOErn6
	 i8uHcE3ljPUoSWHnc10b2UmQ1OT4Col1lyy39hbXQmc5UZ/mTU7AVaozWqG9/P1sG+
	 aPVQUZ3emWJ6P5oVFF1yJ2kfH3BoMLR40dBqSGWHH2qGGVTNyAK92AKhVIlJAq5n7u
	 FBOh2FdMWjSgQ==
Message-ID: <sashiko-outbox-167808@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] scsi: arcmsr: check the completion index the
 adapter reports
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <f0e71746bcdaabb1e105297ed86ddcf2245b0c86.1791789900.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791789900.git.yhlee@isslab.korea.ac.kr>
 <f0e71746bcdaabb1e105297ed86ddcf2245b0c86.1791789900.git.yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 07:52:31 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi: arcmsr: break in arcmsr_hbaE_postqueue_isr() causes infinite=
 loop
- [High] scsi: arcmsr: incomplete bounds check allows OOB access if maxFree=
CCB > 1024
- [High] scsi: arcmsr: stale cmdSMID left by polling causes double completi=
on on Type F
--

commit f85581f7a747516fc341895f5cc040241896d71c
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: arcmsr: check the completion index the adapter reports

This commit adds bounds checking for the cmdSMID read from the completion
queue on adapter types E and F. It prevents out-of-bounds array indexing
when the adapter reports invalid or out-of-range slot numbers.

> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcms=
r_hba.c
> index 255f1d898079f..1381420d9fbd7 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c

[ ... ]

> @@ -2677,6 +2677,11 @@ static void arcmsr_hbaE_postqueue_isr(struct Adapt=
erControlBlock *acb)
>  	pmu =3D acb->pmuE;
>  	while ((readl(&pmu->reply_post_producer_index) & 0xFFFF) !=3D doneq_ind=
ex) {
>  		cmdSMID =3D acb->pCompletionQ[doneq_index].cmdSMID;
> +		if (cmdSMID >=3D acb->maxFreeCCB) {
> +			pr_err_ratelimited("arcmsr%d: bad cmdSMID %u from iop\n",
> +					   acb->host->host_no, cmdSMID);
> +			break;
> +		}

[Severity: High]
Does this code risk causing an infinite interrupt loop?

By breaking out of the loop early, the function exits without incrementing
doneq_index. As a result, the unincremented doneq_index is written to the
adapter's consumer index register.=20

Because the consumer index is not advanced past the bad entry, the hardware
continues to assert the postqueue interrupt. When the ISR returns, the
interrupt remains asserted, causing an immediate IRQ storm that loops
infinitely on the same invalid entry.

Should the driver instead advance the consumer index, clear the entry if
necessary, and use continue?

[Severity: High]
Can this still overflow acb->pccb_pool if acb->maxFreeCCB exceeds 1024?

If the user sets the host_can_queue module parameter between 961 and 1023,
arcmsr_get_firmware_spec() executes:

    if (acb->maxFreeCCB < ARCMSR_MAX_FREECCB_NUM)
        acb->maxFreeCCB +=3D 64;

This can result in acb->maxFreeCCB being greater than ARCMSR_MAX_FREECCB_NUM
(1024).

If the adapter reports a cmdSMID that is between 1024 and maxFreeCCB, it
passes this check but still overflows the statically sized 1024-element
acb->pccb_pool array.

Should the check use ARRAY_SIZE(acb->pccb_pool) or ARCMSR_MAX_FREECCB_NUM
instead of maxFreeCCB?

>  		ccb =3D acb->pccb_pool[cmdSMID];
>  		error =3D (acb->pCompletionQ[doneq_index].cmdFlag
> 			& ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;

[ ... ]

> @@ -2706,6 +2711,11 @@ static void arcmsr_hbaF_postqueue_isr(struct Adapt=
erControlBlock *acb)
>  		cmdSMID =3D acb->pCompletionQ[doneq_index].cmdSMID;
>  		if (cmdSMID =3D=3D 0xffff)
>  			break;
> +		if (cmdSMID >=3D acb->maxFreeCCB) {
> +			pr_err_ratelimited("arcmsr%d: bad cmdSMID %u from iop\n",
> +					   acb->host->host_no, cmdSMID);
> +			break;
> +		}

[Severity: High]
Does breaking here prevent doneq_index from advancing and clearing the queue
entry?

Type F adapters rely on the queue entry being cleared to 0xffff. By breakin=
g,
the entry is never cleared, which will permanently stall the completion que=
ue.

[Severity: High]
Does this bounds check share the same issue with maxFreeCCB exceeding 1024 =
as
mentioned above?

>  		ccb =3D acb->pccb_pool[cmdSMID];
>  		error =3D (acb->pCompletionQ[doneq_index].cmdFlag &

[ ... ]

> @@ -3880,6 +3890,11 @@ static int arcmsr_hbaE_polling_ccbdone(struct Adap=
terControlBlock *acb,
>  			doneq_index =3D 0;
>  		acb->doneq_index =3D doneq_index;
>  		spin_unlock_irqrestore(&acb->doneq_lock, flags);
> +		if (cmdSMID >=3D acb->maxFreeCCB) {
> +			pr_err_ratelimited("arcmsr%d: bad cmdSMID %u from iop\n",
> +					   acb->host->host_no, cmdSMID);
> +			continue;
> +		}

[Severity: High]
Does this bounds check also suffer from the maxFreeCCB overflow issue?

[Severity: High]
Does this code risk leaving a stale cmdSMID that poisons the ring buffer for
Type F adapters?

When a SCSI command times out, arcmsr_abort() uses this function (which ser=
ves
both Type E and Type F adapters) to poll completions.=20

It successfully processes completions and advances doneq_index:

    cmdSMID =3D acb->pCompletionQ[doneq_index].cmdSMID;
    doneq_index++;
    if (doneq_index >=3D acb->completionQ_entry)
        doneq_index =3D 0;
    acb->doneq_index =3D doneq_index;
    spin_unlock_irqrestore(&acb->doneq_lock, flags);

However, it fails to clear cmdSMID to 0xffff after consuming the entry.

Later, as normal I/O continues and doneq_index wraps around,
arcmsr_hbaF_postqueue_isr() (which strictly relies on checking
cmdSMID =3D=3D 0xffff to find empty slots) will encounter the uncleared cmd=
SMID
and misinterpret it as a new completion.=20

Can this lead to double CCB completions, list corruption, or use-after-free
if the CCB has already been reused?

>  		pCCB =3D acb->pccb_pool[cmdSMID];
>  		poll_ccb_done |=3D (pCCB =3D=3D poll_ccb) ? 1 : 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791789900.gi=
t.yhlee@isslab.korea.ac.kr?part=3D2
