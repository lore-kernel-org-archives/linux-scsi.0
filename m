Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A473D891F
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789093393; cv=none; b=FY5OxqQzrOcnfm+Z8KayJmlXp8Q2sHlFmxxmfX9rVcpcP5fswrcepOzAPegW5byxijzMrLce0ZPEQB3nf2olWUQP0tliL/pFpeoCn7Y/43K9NT8oxTixRnmVZNpXJvalUYARNmfxosN/FR98H8CtYiu/L1/6vghq/rytbJ+cy0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789093393; c=relaxed/simple;
	bh=1x6d9L9gofJcyNPvxGct+gO/YJ7l+4ojrSu1LOa9bxk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tE+LLCkin5i0tOKDG676/P91eK0vqxfEoZFfEreep+SORg4JCoMOT87XQwKZexT5nAw7gGOlxOJcUE9fykbl01+6CpGYlzr9T0X9HfHzZEUVsWOCZySal/knkpF8s5BPi3CJgdqkac2KZkVD5ci6RDVTQF8JN7VeYhHxL8Wkrsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kn/UloAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kn/UloAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18011F000FF;
	Fri, 11 Sep 2026 02:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789093392;
	bh=bEO8FS9unOXMxS4SaVXh06P4IsMAHhii89t3Hb2Z2Kw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kn/UloAN455REprAfxXHq2Z6kv486hcHSUCMCl6ZEQoKy1B1sjRMq4Enp0DVwcbQc
	 OOCFdCxEnPbWjeePF5U5NHMXspRV58wkXyVWD7sdqMrTuKNW4L/rkyS11xWgZ484w5
	 ALVUiUdhL7Hkw8jgB+GzE9Zx1GbjH9XDDmNKr7pct7zkc3T9Lpdzf3zS56nzd8vZtT
	 jAucwhzF3F39f3GuMmzvXV75vKe9esAVy6X/zzPBK4lD7yzJ91ksiwkWEEmrod7pBe
	 gcQd1uKZzNA29gkKV7gS9PId1dxik7fGcTUA1BavdSREGrz9V3STVBT4Iew6SN+CPM
	 F4j/5yNKv+wyQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 8/9] scsi: ibmvfc: register and use asynchronous sub
 CRQ for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911020817.1033789-8-tyreld@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260911020817.1033789-8-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:23:11 +0000
Message-Id: <20260911022311.C18011F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Unconditional registration of `async_sub_crq` without checking=
 `vhost->mq_enabled` causes DMA Use-After-Free and memory corruption.
--

commit 1e4cd6f7164c5e678537797bce437ddf017b1c4e
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: register and use asynchronous sub CRQ for events

This commit wires the async sub-CRQ into the sub-CRQ lifecycle, so it is
allocated, registered, and freed alongside the SCSI channel queues. It
adds calls to register and deregister the async sub-CRQ in the reset and
reenable paths.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -986,6 +989,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_ho=
st *vhost)
>  	spin_unlock(vhost->crq.q_lock);
>  	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> =20
> +	ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1);

[Severity: Critical]
Does this code unconditionally register the async sub-CRQ without checking
if vhost->mq_enabled is set?

If mq_enabled is true initially but ibmvfc_init_sub_crqs() fails (for
example, due to a channel allocation failure), async_sub_crq is freed via
ibmvfc_free_queue(). This unmaps the DMA address and frees the page, but
scrq->msg_token retains the stale DMA address, and vhost->mq_enabled is
set to 0.

When a queue re-enable or CRQ reset occurs, this unconditional call to
ibmvfc_register_channel() passes the stale msg_token to the hypervisor:

ibmvfc_register_channel() {
    ...
    rc =3D h_reg_sub_crq(vdev->unit_address, scrq->msg_token, PAGE_SIZE,
                       &scrq->cookie, &scrq->hw_irq);
    ...
}

Can this cause the hypervisor to write async events into a freed memory pag=
e,
resulting in a DMA use-after-free regression? Furthermore, if mq_enabled was
false from the start, could this pass a DMA address of 0 to the hypervisor,
resulting in IOMMU faults or hypervisor errors?

>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
> =20
[ ... ]
> @@ -1042,6 +1047,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vho=
st)
>  	spin_unlock(vhost->crq.q_lock);
>  	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> =20
> +	ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1);

[Severity: Critical]
This unconditional registration appears to raise the same DMA use-after-free
concerns during a CRQ reset as noted in ibmvfc_reenable_crq_queue() above.
Could this be guarded by checking vhost->mq_enabled?

>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-ibmvfc-fpi=
n-support-v8-0-b27183b055af@linux.ibm.com?part=3D8
