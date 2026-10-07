Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6B73932FC
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 19:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791402283; cv=none; b=QBrzFxdtcVRryUAnFCK7WofEQfLzHHqMduoLcVq/UYRahXJtXlmwFJROaR80jckO7h9Pdk44RhJSHJQa5U/0g8wBBqXF7ypq42q+SgunwwkMwghFMT6t/0RToqalJdCgMpYKPHPR1oGQtmOSdbY4v6sqFN+iM08F6tsdE/ADs7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791402283; c=relaxed/simple;
	bh=d28uebsZKbL2KjhOO6MjBYPFZ/slH2/+oq+zxrYTHeI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VfhLnd2ZHbKVL01Bnh/gebPjq6rgqqqK9edXk389PqpzR68FNJ05EqmfRmVy3FL+bMSQQYqlzNuQH3/gg2jvjQSSgOby4e+F/C60vMb+h7xkGV0miKd4Z3D4iVgDDUFufZtQxT74frpF+BlC0IAVj4J5aalnHqnieITKTtaRXlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dk6eoM7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dk6eoM7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356661F000FF;
	Wed,  7 Oct 2026 19:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791402282;
	bh=UXkiEtwfV5a2spDsP5OdUzo0kyOrWFWWPlc6V3sR74w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dk6eoM7RROILm3/78yXOPx7JTqH+1Ak0qxi8X8YIs3OMetAV8Euvu/BnXQqVlUB50
	 A5UGmqF1HyQtl1lE/ZBBOzrSBkxBr/hyvdnzrAAoqbOZbjxg6MSQjY4bvByeYjodoR
	 w4OVZ0mQqlPqJQhr/IFOk6B+uzwRNE93RcJ3xy0PVY2LOtvOpxgAT9+0JOxrde7P9m
	 sEiVrTOQ3vqO+ECa9gNRFiBLq9baZq86w3VI2IKzMB261a6YPoOZ8TjcmtiG6mzB+1
	 sbK9CKl9dJmrXBpR1LZ4QzBwdt0Dv/BCQlD4fvNRbIv5oUa19EcNR9LAP4ysB56vVj
	 BlIMxvj2iBeyQ==
Message-ID: <sashiko-outbox-163321@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 03/11] scsi: ibmvfc: fix potential NULL pointer
 dereference on failed queue allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007-ibmvfc-fpin-support-v13-3-b816abfa4fcc@linux.ibm.com>
References: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
 <20261007-ibmvfc-fpin-support-v13-3-b816abfa4fcc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 19:44:41 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: double free of sub-CRQs on partial registration fail=
ure
- [Low] scsi: ibmvfc: unprotected H_FREE_SUB_CRQ on uninitialized or double=
-freed queues
--

commit 0fde5959dd5d7f8887aa67ee2fa7032b0dd6353a
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: fix potential NULL pointer dereference on failed queue alloca=
tion

Guard the memset() in ibmvfc_deregister_channel() behind a check of
scrq->msgs.handle to prevent a NULL dereference when the function is
called on a queue that was never allocated, such as async_sub_crq when
multi-queue is disabled or initialization failed before
ibmvfc_alloc_queue() was reached.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 145d559041f12..6a42d15db9ec5 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -6480,8 +6480,10 @@ static void ibmvfc_deregister_channel(struct ibmvf=
c_host *vhost,
>  		dev_err(dev, "Failed to free sub-crq[%d]: rc=3D%ld\n", index, rc);

[Severity: High]
Can a partial registration failure lead to a double-free of the sub-CRQ
resource?

In ibmvfc_reg_sub_crqs(), if registration fails midway, it deregisters the
already registered queues by calling ibmvfc_deregister_channel():

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_reg_sub_crqs() {
    ...
	for (i =3D 0; i < channels->max_queues; i++) {
		if (ibmvfc_register_channel(vhost, channels, i)) {
			for (j =3D i; j > 0; j--)
				ibmvfc_deregister_channel(vhost, channels, j - 1);
    ...
}

However, ibmvfc_deregister_channel() doesn't zero scrq->cookie, and
vhost->mq_enabled remains true.=20

When a subsequent adapter reset or teardown occurs, ibmvfc_dereg_sub_crqs()
loops over all queues and calls ibmvfc_deregister_channel() again on the
same queues, potentially causing a double-free at the hypervisor level.

Could scrq->cookie be cleared after successfully freeing the sub-CRQ to
prevent this?

>  	/* Clean out the queue */
> -	memset(scrq->msgs.crq, 0, PAGE_SIZE);
> -	scrq->cur =3D 0;
> +	if (scrq->msgs.handle) {

[Severity: Low]
Is the H_FREE_SUB_CRQ hypercall safe to execute on uninitialized queues?

The memset() is now properly guarded by scrq->msgs.handle, but the
H_FREE_SUB_CRQ hypercall just above this block continues to run
unconditionally.

If a queue was never registered or was already deregistered (such as during
the ibmvfc_reg_sub_crqs() rollback), the unconditional hypercall will fail
and generate a spurious "Failed to free sub-crq..." error message.

Should the hypercall logic also be protected against uninitialized or alrea=
dy
freed queues?

> +		memset(scrq->msgs.crq, 0, PAGE_SIZE);
> +		scrq->cur =3D 0;
> +	}
> =20
>  	LEAVE;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-ibmvfc-fpi=
n-support-v13-0-b816abfa4fcc@linux.ibm.com?part=3D3
