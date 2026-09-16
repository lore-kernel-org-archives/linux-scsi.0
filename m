Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3242B37BE75
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 23:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789601226; cv=none; b=KY34/999yeyjvBBhUGeI3XVaGdV+1KVKXAXrSn8+IOHt0qzldCnznafiTxa/mUPVLWO2SHUWQEQQzF6uuMg0zGfvz9SEL+XI+11foCRHi6ZGwstqO/iLQwdedLFtAIc5cBhvTXeHu05xUodEI+6M1vdXo2VBYWTzSx9ehrIZZlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789601226; c=relaxed/simple;
	bh=/1H6US0zX1TDlAGIYzW7DJjalDov0rYGvsnuJakv3Sg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AkfOb+2LJ+BdczeA8I02SY7GwFzhk2wkY+m0xXtdv4YkvBNTlQ6UWmrngCCUR4K/Q7PQgK0GwmtIOAVjHnQbbuV/fl7Wf+TOxFV7rZvT6z8Dy/cPgsQAalUW8mb8x0crs3Zz9vGQt1hjNfmZzvkyZmTsQo9IlJz+fLF1kM9QSkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFtaN5ZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFtaN5ZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8974F1F000FF;
	Wed, 16 Sep 2026 23:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789601224;
	bh=60urq/V14twA/UIyoLKG0UNOoOEmTW8gGLagYScxlko=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oFtaN5ZBjfXWWBTEMgiLDIDhRQd5oPKyqpRDdsrw3uHqGrzZNJjc7G8q53Dn1oQDD
	 qmHzRmb4VdLzm2npWEzl68/TNVcJO1jogawvWM82fxEqQxmjN6N8Vcx5yo6G5cu+RY
	 Cf7dByjka7HNyVqLLnnl3EcgEGKSMhnL613F8CkSoP+7BD+76F59UZnoA6i3JUofZo
	 hVlRZpr5PT1lVrArYvstCpnYwUnSGH47Bt1o+9I8yM6WlgyNfVCggtZA2SBd+hic38
	 IrwcV17VXw7iGD9aBeBF/wn2BriqOwGcPdnQKNKyWEXf+0bafI9PhcOA7yuINQw1Ym
	 KDic1PXcSjKQw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 13/20] scsi: ibmvfc: make NVMe FCP abort callback
 asynchronous
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260916230921.2204729-14-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
 <20260916230921.2204729-14-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 23:27:04 +0000
Message-Id: <20260916232704.8974F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: ibmvfc: target refcount leak in NVMe FCP abort on H_CLOSED
--

commit a157bd312e6543b5cff40822ea7bcdd2ca4fce9c
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: make NVMe FCP abort callback asynchronous

This commit replaces the synchronous NVMe FCP abort callback with a
dedicated asynchronous callback to prevent stalling the timeout workqueue.
It removes the completion waiting logic and allows the transport to wait
independently for the original exchange to complete.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index d9f280c658eb4..52e2621a43424 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
[ ... ]
> @@ -426,27 +434,12 @@ static void ibmvfc_nvme_fcp_abort(struct nvme_fc_lo=
cal_port *lport,
> =20
>  	spin_lock_irqsave(queue->q_lock, flags);
>  	kref_get(&tgt->kref);
> -	ibmvfc_init_event(evt, ibmvfc_sync_nvme_completion, IBMVFC_MAD_FORMAT);
> +	ibmvfc_init_event(evt, ibmvfc_nvme_fcp_abort_done, IBMVFC_MAD_FORMAT);
>  	ibmvfc_init_fcp_abort(evt, abort_req);
> -	evt->sync_iu =3D &rsp;
> -
> -	if (ibmvfc_send_event(evt, vhost, default_timeout))
> -		goto out;
> +	evt->tgt =3D tgt;
> =20
> +	ibmvfc_send_event(evt, vhost, default_timeout);
>  	spin_unlock_irqrestore(queue->q_lock, flags);

[Severity: Medium]
Will this leak the target kref if ibmvfc_send_event() encounters an H_CLOSED
error?

When ibmvfc_send_event() receives an H_CLOSED transport state error, it fre=
es
the event and returns SCSI_MLQUEUE_HOST_BUSY without invoking the evt->done
callback:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_send_event() {
	...
	if (rc) {
		...
		if (rc =3D=3D H_CLOSED) {
			...
			ibmvfc_free_event(evt);
			return SCSI_MLQUEUE_HOST_BUSY;
		}
	...
}

Because ibmvfc_nvme_fcp_abort() now ignores the return value of
ibmvfc_send_event(), the kref incremented earlier in the function will never
be dropped if this H_CLOSED path is taken. Should the return value of
ibmvfc_send_event() be checked so the kref can be released on error?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916230921.2204=
729-1-tyreld@linux.ibm.com?part=3D13
