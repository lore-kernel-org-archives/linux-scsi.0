Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F97383C7B
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 22:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214718; cv=none; b=ZMgCXBKMMdhgSGVw5l+bexj9lIJhetMV7pybUkaSzSEZ2k7NQSBKppfavfzLiuvif3wZo70CGca1+m2O1O8nrGffiJ9OwXZJSaiBWBsBsyiPVcu22WECF8u8Vk5PzEKHi4OwMNoo6KSquqMY+aZOXGYYs7+37B2x1s5K8y8+OiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214718; c=relaxed/simple;
	bh=wwhMmv4aRQiSjJHH5HFFWg5/riACIxlj3n+TdZgBlhM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XExihVdXgs1qgJESV9GOwNny+2v1PemqAETUmemHkvN1zh1RNMQ2+UVdSl18f/kIDLjmgovpI++9kupmSmH3uigdEZxztMSxLXnl/rNN6CATYqhMqJsVAQts/AQRLQJKSnF2YiFfA5UnCHx/9gtBbuEhtfJEMeR1t3P/xHzWTgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iSXnfvE5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iSXnfvE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C605B1F000E9;
	Mon, 31 Aug 2026 22:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788214717;
	bh=ZdRMbOgclwQFU0WaoOo/y07dgDgBnpIev/i0ESU2cVw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iSXnfvE53I9Fqtzt96y2q6qL17yBovKW0cqcVZ7y75dNKEUAW4l7G5Tu0Sm5JoC9X
	 422g22LYbt2xZsKT3s0NsbuW3D+1lIAMLETq4aYDGMr4eW8IE8ZVYsZLSPO9q8YEIs
	 8OEqPNtMgAiTa4MwOkNS01RlCfEqZ798/AOpCrF5TQvvQ3+EiQQl0SwX7wmz1FJgRn
	 NgBLRLfOqEez+b86fI4plulFCZv5srbX4AyKTRGcUABr4I7e+PdTXHP4xd9ZS8J09i
	 WFgbEKh9lM8na+buQ/+zK/mXOdY/ohpknCZXlg1I9FcLQAblya9rO3muQ/dTTxHNpV
	 WOcIZMH0tOWVA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 5/8] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260831-ibmvfc-fpin-support-v7-5-77d0b9809080@linux.ibm.com>
References: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
 <20260831-ibmvfc-fpin-support-v7-5-77d0b9809080@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 22:18:36 +0000
Message-Id: <20260831221836.C605B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The `ibmvfc_drain_async_subq()` function calls `ibmvfc_handle_asyn=
c()` without holding the primary SCSI host lock (`vhost->host->host_lock`).=
 This leads to severe data races and list corruption because `ibmvfc_handle=
_async()` mutates shared state and iterates over lists that are concurrentl=
y modified by other threads holding the lock.
--

commit d6b23b1e849e5108314e933b9d7ab6b8580d0218
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ

Add ibmvfc_interrupt_async_subq(), an IRQ handler dedicated to
asynchronous sub-CRQ events from the adapter. The handler disables
the sub-CRQ IRQ and then calls ibmvfc_drain_async_subq() to consume
all pending entries before re-enabling interrupts.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 229b06effd4cf..a28875c1f9830 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -4369,6 +4369,56 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct =
ibmvfc_queue *scrq)
>  	return crq;
>  }
> =20
> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
> +{
> +	struct ibmvfc_crq *crq;
> +	int done =3D 0;
> +
> +	spin_lock(scrq->q_lock);
> +	while (!done) {
> +		while ((crq =3D ibmvfc_next_scrq(scrq)) !=3D NULL) {
> +			struct ibmvfc_async_crq_event ae =3D {
> +				.type =3D IBMVFC_ASYNC_CRQ_SUB,
> +				.subq =3D *(struct ibmvfc_async_sub_crq *)crq,
> +			};
> +			ibmvfc_handle_async(&ae, scrq->vhost);

[Severity: High]
Does this code need to hold the host_lock before calling ibmvfc_handle_asyn=
c()?

Calling ibmvfc_handle_async() with only the local queue lock (scrq->q_lock)
held can lead to unprotected list iterations:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_handle_async() {
    ...
		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
    ...
}

It can also lead to unprotected read-modify-write operations on shared stat=
e:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_handle_async() {
    ...
			vhost->events_to_log |=3D IBMVFC_AE_LINKUP;
    ...
}

If it races with normal target initialization, addition, or removal routines
running on other CPUs holding the host_lock, could it result in list corrup=
tion
or use-after-free?

> +			crq->valid =3D 0;
> +			wmb();	/* complete write */
> +		}
> +
> +		ibmvfc_toggle_scrq_irq(scrq, 1);
> +		crq =3D ibmvfc_next_scrq(scrq);
> +		if (crq !=3D NULL) {
> +			struct ibmvfc_async_crq_event ae =3D {
> +				.type =3D IBMVFC_ASYNC_CRQ_SUB,
> +				.subq =3D *(struct ibmvfc_async_sub_crq *)crq,
> +			};
> +			ibmvfc_toggle_scrq_irq(scrq, 0);
> +			ibmvfc_handle_async(&ae, scrq->vhost);

[Severity: High]
Does this call to ibmvfc_handle_async() also need the host_lock for the same
reasons as above?

> +			crq->valid =3D 0;
> +			wmb();	/* complete write */
> +		} else
> +			done =3D 1;
> +	}
> +	spin_unlock(scrq->q_lock);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831-ibmvfc-fpi=
n-support-v7-0-77d0b9809080@linux.ibm.com?part=3D5
