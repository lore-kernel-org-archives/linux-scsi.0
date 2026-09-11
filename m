Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4C118787A
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789094448; cv=none; b=HuULGWiap1TgB7y2pugP2WyIcUxgfJAIXqGkL2w3/DeFwTnpM1XHNFcRmM8q0hfShRTVSb4qLihwJ6YE9hL9b2vijPLGuvneHKG4MaOhdCCc1BMzDTJNhiqE+T+kPTEQM7vifhfJkR/2b7ef2yhYKUDRpRfchgkYFpgRriWPIw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789094448; c=relaxed/simple;
	bh=SllOMPy8Gz0t/lVGzenBa5+kfYxfL9oyXNNPW0mxiC4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Mjgb4e0y+RrT9yEH4q9lz/hzGWeR5/pfQ1gyEktqi/DaGB4E6wQcdsVeBWWq6xE+iKOz23E2XpsgFtDTRJitGyDSgXRlHVzwvJK/vDfzz3aRCIHbCaVgNF5dGTqmaZOlVhxNcrXLjgrmH3+A8MnFf50kG27LBYm0UMNC3JxIi/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hqWemDgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hqWemDgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854931F000FF;
	Fri, 11 Sep 2026 02:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789094446;
	bh=dupPRdEmo7vITIVqUb26jUJftSvvfk2qDfp+hp3QQN8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hqWemDgf1ZiU+xh4UuoAmEMdJwMoMQQk9veKw9DAyv6yZeSTvQRwOXDSewhVQTsyQ
	 xQ6DOLL8RLclqTbibBwmz+AJ/Ub4R+sORGzkyoLQ51nUa6ntUvrLNmRimdOeRhdhPr
	 C8q7i3I8LF4DxEh08Omcfg65DkG0qqUzTZzISyfgOwV+FOZaQqO8o/nQuVmRu8oQxH
	 oXLEVvqBRBeAjVhg3y3EoQMeWIFayK33ZdU+OlLoR7ERdqlairPJOsY37WeWBPr5Th
	 wmVKLsbcVK1PYmG4o6/EIVJktpR+BmYYYAAxZeczAuEICT9K9DJjkcjh4Ep+OEjGR0
	 zfL6khXp8f6UA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 8/9] scsi: ibmvfc: register and use asynchronous sub
 CRQ for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911021910.1038128-9-tyreld@linux.ibm.com>
References: <20260911021910.1038128-1-tyreld@linux.ibm.com>
 <20260911021910.1038128-9-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:40:46 +0000
Message-Id: <20260911024046.854931F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] Unconditional lifecycle management of `async_sub_crq` causes U=
se-After-Free, double-free, and DMA corruption via uninitialized addresses.

Pre-existing issues:
- [Critical] Missing bounds check on VIOS-provided queue counts leads to ou=
t-of-bounds heap writes.
--

commit ba224804598ce14d90bf10ea7c6101dfc09e9780
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: register and use asynchronous sub CRQ for events

This patch wires the async sub-CRQ into the sub-CRQ lifecycle so it is
allocated, registered, and freed alongside the SCSI channel queues. It also
fixes a variable-shadowing bug in channel registration and advertises
capabilities when multi-queue channels are enabled.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -1006,6 +1010,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vho=
st)
>  	struct vio_dev *vdev =3D to_vio_dev(vhost->dev);
>  	struct ibmvfc_queue *crq =3D &vhost->crq;
> =20
> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
>  	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
[ ... ]
> @@ -1042,6 +1047,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vho=
st)
>  	spin_unlock(vhost->crq.q_lock);
>  	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> =20
> +	ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1);

[Severity: Critical]
Does this code unconditionally register the async sub-CRQ during a host res=
et,
even if multi-queue is disabled or the queue was never allocated?=20

If a system boots with multi-queue disabled (or if its initialization fails=
),
the async_sub_crq remains unallocated. When a host reset occurs, this call
reaches h_reg_sub_crq() with an uninitialized msg_token (value 0):

ibmvfc_register_channel() {
        ...
        rc =3D h_reg_sub_crq(vdev->unit_address, scrq->msg_token, PAGE_SIZE,
                           &scrq->cookie, &scrq->hw_irq);
        ...
}

Could this instruct the hypervisor to map and write to guest physical addre=
ss 0,
causing DMA corruption?

>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
[ ... ]
> @@ -5812,6 +5820,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc=
_event *evt)
>  		for (i =3D 0; i < nvme->active_queues; i++)
>  			nvme->scrqs[i].vios_cookie =3D
>  				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
> +		vhost->async_sub_crq.vios_cookie =3D be64_to_cpu(setup->async_sub_crq_=
handle);

[Severity: Critical]
This isn't a bug introduced by this patch, but is it possible for the
untrusted VIOS input in the channel setup response to overflow the queues
array?

In ibmvfc_channel_setup_done(), the driver sets the loop boundaries by read=
ing
active_queues from setup->num_scsi_subq_channels and
setup->num_nvme_subq_channels. If the VIOS returns a count larger than
the array capacity (max_queues), does this loop blindly write
setup->channel_handles[i] past the end of the scrqs array, potentially
causing out-of-bounds writes to the kernel heap?

> =20
>  		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
>  			   scsi->active_queues);
[ ... ]
> @@ -7070,6 +7104,9 @@ static void ibmvfc_release_channels(struct ibmvfc_h=
ost *vhost,
>  static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
>  {
>  	ENTER;
> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
> +	ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
> +

[Severity: Critical]
If ibmvfc_alloc_channels() fails during ibmvfc_init_sub_crqs(), the
async_sub_crq is freed but its state is not cleared. When the driver
later unloads or releases queues, does this unconditional call free the
queue a second time?

Could this lead to a double free of the event pool array and a use-after-fr=
ee
on the event queue list?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911021910.1038=
128-1-tyreld@linux.ibm.com?part=3D8
