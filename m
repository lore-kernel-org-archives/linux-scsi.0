Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB082C11CA
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 19:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783711942; cv=none; b=bGN4LYUImU9dE5D7bwBOgxbQuj/5CmjbvHN/glW8AIH5hgRZg687DWkwWVx11/HeGpSyjCFNjgtVh/p69+GgVJ1N1VAmPoH47LpWOzDCqAwHIpzSx/kDt4t2XvXc9RHYOOtPNch5Ya+Z6nlcP87koo6tR4FTpRgDmXoCGbjCfnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783711942; c=relaxed/simple;
	bh=pBe/2eb8+dGMjSnpVbIzciOtqgQ4kVQmVHS5+sKqyfg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LL74h5vry1R7TnYC8gNTNNYkAdjVAjTm19daQkqOzVUotVbo6tsRLF8tqPmGFV7yMDAi4qRjZCwuJCAAzPbDcT3y2fIYte81uxOkyC+7d2OlH2gv7wYcP7aS5zyuUZdYDZb2hClMVMfSpDCjm8WP6ltXa9Fkb3YwADGTmu7tFZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y5IKcbGj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y5IKcbGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A227C1F000E9;
	Fri, 10 Jul 2026 19:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783711940;
	bh=iF9tCE1is2nj8QpqAVh/J1/Gno0HK5kf38si3ad79Os=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y5IKcbGj391FTVB2PqwQKM91CfqhLhvu6W306TPzKSCTCOQ3DzmcDCQ3eFSb1+XTT
	 UOHwsiQjuQ7RSMbOOse8nba6Y5jdG9asky9hCfXAERzV1OGCpQvce9C++6BQZsQCPF
	 6NAV6ISMkwKD8dRAocHKjH9eHyjuFxx8sH6eF2+SynwqPPoGV5iREGSu1Pamtek18l
	 6fq//RDkzKXwIM9DAn/BTRz5FX/uMYzKiEOCzk4wuBMDTaRzAhPDPvROXcs9XV4iHE
	 GVOVpD/FAknrV+g21/HXde6ue0nQPlGpeqhKCv7cy38akG7/91xEd3Jr/UiZBOzz7L
	 3Kp2IlyJ3hpGA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 7/8] ibmvfc: register and use asynchronous sub-queue
 for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260710-ibmvfc-fpin-support-v4-7-ef031ac19520@linux.ibm.com>
References: <20260710-ibmvfc-fpin-support-v4-0-ef031ac19520@linux.ibm.com>
 <20260710-ibmvfc-fpin-support-v4-7-ef031ac19520@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 19:32:20 +0000
Message-Id: <20260710193220.A227C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Failure to clear `scrq->irq` on error and unconditional teardown o=
f sub-CRQs causes double-free of IRQs and hypervisor resources.
--

--- Patch [7]: [PATCH v4 7/8] ibmvfc: register and use asynchronous sub-que=
ue for events ---
commit 381f7f27a85750da81e10927e42035d25ca1d22c
Author: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc: register and use asynchronous sub-queue for events

Complete async sub-queue integration by setting up interrupt handling,
registering the queue as a channel, and enabling its use during NPIV login.
Register async_scrq during channel initialization and unregister during
cleanup.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index ee56f13f1a979..eb786ac242745 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
[ ... ]
> @@ -6470,7 +6571,8 @@ static void ibmvfc_dereg_sub_crqs(struct ibmvfc_hos=
t *vhost,
>  		return;
> =20
>  	for (i =3D 0; i < channels->max_queues; i++)
> -		ibmvfc_deregister_channel(vhost, channels, i);
> +		ibmvfc_deregister_channel(vhost, channels, &channels->scrqs[i]);
> +	ibmvfc_deregister_channel(vhost, channels, channels->async_scrq);

[Severity: High]
This isn't a bug introduced by this patch, but does adding the async_scrq to
this unconditional deregistration loop extend a double-free bug?

If request_irq() fails during sub-CRQ registration in
ibmvfc_register_channel_common(), it calls irq_dispose_mapping(scrq->irq)
and goes to irq_failed to free the sub-CRQ. However, it doesn't clear
scrq->irq or scrq->cookie.

Later, ibmvfc_dereg_sub_crqs() iterates unconditionally over all queues
(including the failed one) and calls ibmvfc_deregister_channel(), which
again calls free_irq(), irq_dispose_mapping(), and
plpar_hcall_norets(H_FREE_SUB_CRQ).

Could this lead to IRQ domain corruption and a hypervisor resource
double-free?

> =20
>  	LEAVE;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710-ibmvfc-fpi=
n-support-v4-0-ef031ac19520@linux.ibm.com?part=3D7
