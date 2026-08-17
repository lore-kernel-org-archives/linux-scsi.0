Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8498B3BA225
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 20:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786999830; cv=none; b=qGBL6u7ZoMo7loqfrt0DEtgGpJgBAzFZxZ7MBa4AByyFBW0qZ+bx/cEV33nhdXe1Lw2wq5/RzeVQ1VubcvADiailGNVkwX6SYTCzwk5naGAZZGSYLC1Yr4qWfqgclBx5SuxjUXAmb9uWmFPxlP/XFGu05Cmys/+C8KGoXaKbH+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786999830; c=relaxed/simple;
	bh=Zx4PfzXkOUe7jCZA2R0y4AXFuSwwjlm85rQ6RRVrWNo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UbAuDRgagz5ybMm8IGWaZTtRduDxM74i/ELi20HchNhrY0aqMqSWkLBIA4XYGg8WcMpuBjDOQO9TFdz579ZhLOpBgLLZgf5EYT4MkFeEBmBhau4+WVeYVXYWtgvUeokjQRFhZxTdJ3xtHEIY+p8t7dxTdpXKDz6Zf+dPDf8LZwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qqz0wgQP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qqz0wgQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DB41F000E9;
	Mon, 17 Aug 2026 20:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786999822;
	bh=1sDDMW+VnY2ZlXJ0VDK+cXjHt9htvgG94r3jcAm31gk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qqz0wgQPpveMSh74AQhwWx8iOSwU0JFvPs0CfmI5ny+vb9mn+V9MDpCL/Iynza86g
	 0w9F2QJr/Kxh+0NCo+ZlfGKAT6Sm8x03X/JMTjffu2kqBQcEZMZAFuE0nUGt2MgyNe
	 64iJDX9HUHDihoFU6vc/0HR61PgpS9b6HuTCM3y8VV3oJbBJAav0aXXdK2rYtjT4ZG
	 gwWIiFAbmhfyob/jFk2DPHRHU5Tl/XHjySiMe31bwy1YOefUPUR1Ym1mcEUKEvuD+O
	 ubs+ZifDAeO7zRJnmRpcrNCn9r68HX1ilRGvVkAXWtexrouOPh7hJoRwcCStbhgrrM
	 arG74uHRB3dIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 6/8] scsi: ibmvfc: extend channel registration and
 deregistration for async subq
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260817-ibmvfc-fpin-support-v6-6-62a2d525e70d@linux.ibm.com>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
 <20260817-ibmvfc-fpin-support-v6-6-62a2d525e70d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 20:50:21 +0000
Message-Id: <20260817205022.18DB41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] Kernel panic due to workqueue use-after-free during device tea=
rdown.
- [Medium] Silent behavioral mutations: Undocumented parsing changes and te=
st alterations.
- [Low] Dead code and incomplete feature: async_sub_crq is never registered=
 and lacks allocation.
--

--- Patch [6]: [PATCH v6 6/8] scsi: ibmvfc: extend channel registration and=
 deregistration for async subq ---
commit 31a5fe949f10ffb5d84b0f4c1f35d59e3b5dc785
Author: Dave Marquardt <davemarq@linux.ibm.com>
Subject: scsi: ibmvfc: extend channel registration and deregistration for a=
sync subq

This patch extends ibmvfc_register_channel() and ibmvfc_deregister_channel()
to accept a negative index. This convention signals that the async sub-CRQ
should be operated on instead of an indexed scrq entry.

> Extend both functions to accept a negative index as a sentinel value
> signalling that the async sub-CRQ should be operated on instead of an
> indexed scrq entry. When index < 0, the queue pointer is set to
> &vhost->async_sub_crq, the IRQ is named "ibmvfc-<addr>-async", and the
> handler is set to ibmvfc_interrupt_async_subq rather than the per-protocol
> ibmvfc_interrupt_mq handler. hwq_id assignment is skipped for the async
> queue since it has no meaningful hardware queue index.

[Severity: Medium]
Could the commit message be updated to mention the behavioral updates?

The commit message thoroughly explains the new channel registration logic,
but the patch also introduces undocumented parsing changes to node_name
handling using IBMVFC_ASYNC_ID_IS_ASSOC_ID in ibmvfc_process_async_work(),
along with silent alterations to the KUnit tests checking
cn_device_specific.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 3b5732f2fb6ec..4e6d2ff190751 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -3593,7 +3593,7 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_async(void *crq,
>  		link_state =3D subq->link_state;
>  		scsi_id =3D 0;
>  		wwpn =3D subq->wwpn;
> -		node_name =3D subq->id.node_name;
> +		node_name =3D subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID ? 0 : subq->id=
.node_name;

[Severity: Critical]
Could this lead to a use-after-free regression during device teardown?

If ibmvfc_remove() destroys and nullifies vhost->fpin_workq before the
adapter interrupts are disabled via ibmvfc_release_crq_queue(), and an
asynchronous FPIN event is received during this window,
ibmvfc_handle_async() will invoke:

    queue_work(vhost->fpin_workq, &aw->async_work_s);

Since the workqueue pointer is already NULL, this would cause a fatal
dereference.

[ ... ]
> @@ -6798,13 +6791,29 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vh=
ost)
>  	return retrc;
>  }
> =20
> +/**
> + * ibmvfc_register_channel - Register a sub-CRQ channel with the hypervi=
sor
> + * @vhost:	ibmvfc host struct
> + * @channels:	ibmvfc channels struct containing the channel array and pr=
otocol
> + * @index:	index into the channels array for the queue to register, or
> + *		a negative value to register the async sub-CRQ
> + *
> + * Register a sub-CRQ with the hypervisor via h_reg_sub_crq, map its har=
dware
> + * IRQ to a Linux IRQ, and bind an interrupt handler to it. The handler =
is
> + * selected based on the channel protocol (SCSI or NVMe) for normal queu=
es, or
> + * set to the async sub-CRQ handler when @index is negative.
> + *
> + * Return value:
> + *	0 on success / non-zero on failure
> + **/
>  static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>  				   struct ibmvfc_channels *channels,
>  				   int index)
>  {
>  	struct device *dev =3D vhost->dev;
>  	struct vio_dev *vdev =3D to_vio_dev(dev);
> -	struct ibmvfc_queue *scrq =3D &channels->scrqs[index];
> +	bool is_async =3D index < 0;
> +	struct ibmvfc_queue *scrq =3D !is_async ? &channels->scrqs[index] : &vh=
ost->async_sub_crq;

[Severity: Low]
Is this negative index path reachable?

Searching the codebase, it doesn't appear that any callers pass a negative
index into ibmvfc_register_channel() or ibmvfc_deregister_channel().

Additionally, if this path were reached, it looks like vhost->async_sub_crq
is never initialized via ibmvfc_alloc_queue(). This could lead to passing an
uninitialized msg_token to the hypervisor and a null pointer dereference
during memset().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817-ibmvfc-fpi=
n-support-v6-0-62a2d525e70d@linux.ibm.com?part=3D6
