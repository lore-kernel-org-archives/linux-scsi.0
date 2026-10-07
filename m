Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786D430C359
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 19:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791402299; cv=none; b=A+Aa/BkOzc5DKNu0IMkTWZJZ1PrBWSNE/leD7pmFOr0AczlTLjwP3txE0KbsAG5uuTCf4zyROulh2ZCEVQia+ResGhAXfFKa7Yvkbr0bOB0CWOzkfDQ4Tk7SCOCm389C9pSw77F5SxcaTreqVUVrJ8fBaS1ORLHqMr7iCh5eMzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791402299; c=relaxed/simple;
	bh=w2tEQnkYLuqXC6QJmLAhG3Pgw/wHIZ6llBQATbnvD0Q=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Bh7wcjSe0j+YiWIpusDFdCnJXPCcg3xaQd7DYDMuuIze4KTcbx/3STnewoNKdAJwDvmhVOM6mY5fnoqh4WBm8XNDIabbmPmXf0K0FodunpO9yJXdrc41F+dICQATadumVDYtiH5bCK2n/GJBaBZlWBK5J2JBfEIVSg3ANui4n6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBWVPasV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBWVPasV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9DC1F000FF;
	Wed,  7 Oct 2026 19:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791402298;
	bh=thqZgidPQ4QrH2PNHLNautzV+n7GCFeTTnFXHwukH6c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dBWVPasV7BMM70GFlv9/WD0iHmxLayJWUKNtwzgpmZcW3J9upap+iBLphHSVxnQ1V
	 qoTj3YId6NceBKlEqD6F/J3WSVqUgwQ+l6izAnqkUVo+NrG+sbU91Xk26WMLg92VTY
	 zqk4Td2tcZSqdvaGnc7i6QTKZ08WWs9isY3YBEI2l9DsoBEK+VKrrwWDGzRIJZqDLP
	 s9F2NPGdsnN4QEGJeDah3NvnCuuWySbVBrTnduJTlB/xDRejQ6W87kpgpNmI0oPHM5
	 YRb6sfy1PpXeDz9n3ZOw3gJlDLH0WfvnfeYt1GqsepbU4Va62wLugkLMSlqwAUHXY0
	 cM8plJu3WQpZA==
Message-ID: <sashiko-outbox-163322@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 08/11] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007-ibmvfc-fpin-support-v13-8-b816abfa4fcc@linux.ibm.com>
References: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
 <20261007-ibmvfc-fpin-support-v13-8-b816abfa4fcc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 19:44:57 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi/ibmvfc: missing load-store memory barrier allows DMA ring dat=
a corruption
--

commit 69de3faf2b9168cb1feb3f85a48430596c1d9283
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ

This commit introduces an interrupt handler and a drain routine for
asynchronous sub-CRQ events. It adds direct traversal of the async
sub-CRQ ring and processes available entries while managing the queue lock
and hardware interrupts.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 6db9df91e9e68..32bc00a4be7ec 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
> +{
> +	struct ibmvfc_host *vhost =3D scrq->vhost;
> +	struct ibmvfc_async_crq_event ae =3D {
> +		.type =3D IBMVFC_ASYNC_CRQ_SUB,
> +	};
> +	struct ibmvfc_async_sub_crq *crq;
> +	unsigned long flags;
> +	int done =3D 0;
> +
> +	spin_lock_irqsave(&vhost->host->host_lock, flags);
> +	spin_lock(scrq->q_lock);
> +	while (!done) {
> +		while ((crq =3D ibmvfc_next_async_scrq(scrq)) !=3D NULL) {
> +			ae.subq =3D *crq;
> +			ibmvfc_handle_async(&ae, scrq->vhost);
> +			crq->valid =3D 0;

[Severity: High]
Could the store to crq->valid be reordered before the reads from the payload
complete?

On weakly-ordered architectures like PowerPC, a load from memory can be
delayed and executed after a subsequent store unless separated by a memory
barrier.

While ibmvfc_handle_async() takes spinlocks in some paths, it does not
execute any spinlock or hardware barrier before returning in others
(such as IBMVFC_AE_LINK_UP or IBMVFC_AE_SCN_FABRIC).

If the hardware observes valid =3D=3D 0 early, it might overwrite the new e=
vent
while the CPU is still reading it, causing the CPU to ingest corrupted data.
Does this require an smp_mb() or smp_store_release() before clearing the
valid bit?

> +			wmb();	/* complete write */
> +		}
> +
> +		ibmvfc_toggle_scrq_irq(scrq, 1);
> +		crq =3D ibmvfc_next_async_scrq(scrq);
> +		if (crq !=3D NULL) {
> +			ae.subq =3D *crq;
> +			ibmvfc_toggle_scrq_irq(scrq, 0);
> +			ibmvfc_handle_async(&ae, scrq->vhost);
> +			crq->valid =3D 0;

[Severity: High]
Does this race-closure check also suffer from the same missing load-store
barrier before clearing the valid bit?

> +			wmb();	/* complete write */
> +		} else
> +			done =3D 1;
> +	}
> +	spin_unlock(scrq->q_lock);
> +	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-ibmvfc-fpi=
n-support-v13-0-b816abfa4fcc@linux.ibm.com?part=3D8
