Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A1B3BCD37
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 20:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786999144; cv=none; b=ndZ1N2CB3iEXXwYcU3eOe6aT1FCeZCzLXEQsTOhMN2r0Ekzp00tY22sLh50MJoXNg2cc+UmLmo5Xpw+xq/B55EZJRPx9knGNSPRXjlbQALK4++DG+JLz3IfkDQbsbR+3g9Ci/xIWaZPerATgfz6Oq2hD0GLiLLTLgC0ObdmT5zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786999144; c=relaxed/simple;
	bh=hoXGFhAUobcitFc5s+BQvfqFSwJq8C4ddkHZIPvxPas=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=O3fURkVuJkqVxC5kS2O68tSuq59JMLPuaki+iwI82E318LR8uObITrpNPnOcfbJ1PW4/S3cp6+fr11V6Wibj+ku8vg2NiDVBAwYC1zRyNdrq7M16DM0LxIpnlDLvk7lsbCr+CzkPJH0Fupwq+6Q1pBsXOOMOWVNPgPUH/z8NDQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5M5tUXD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5M5tUXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEA01F000E9;
	Mon, 17 Aug 2026 20:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786999142;
	bh=IOUudx/tm4qmZaJebjvugTL1npmn5XyFPHmYNINWoJQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d5M5tUXD5wK5DMtDKBJxaJVpYcK4wT9R0BKsHpWLmd6ZolzJ/uPWIH6j6J+PIV6UL
	 4asOKY+4FbkM9MPWxcM6+hdE7fZnJ3/h92etQhvDVFqAVYagx2jTiHz4VKKNwyrQVj
	 haPL3aNI/asbZyDsDplh7XVnSiopJpABPNCJ2tGecrxmOX3iJ36XZ4iVukXfsniuQi
	 uLgr0mnrP7fezVabPt+E6QaHyH1JPe985R84JomjRII8JLYZWjwrtJqXRutU3QOdNk
	 r8Cdy08d6uma/W/3zgIjqpIBOHuLqrBTcTw25yhqZt5/s2x6oUZ2KwP/wkdpvDf/AT
	 OLDxj/ETjDgLQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 3/8] scsi: ibmvfc: define asynchronous sub-queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260817-ibmvfc-fpin-support-v6-3-62a2d525e70d@linux.ibm.com>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
 <20260817-ibmvfc-fpin-support-v6-3-62a2d525e70d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 20:39:01 +0000
Message-Id: <20260817203902.5DEA01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Use-After-Free / NULL Pointer Dereference (Lifecycle Mismatch)
- [Medium] Incomplete Implementation / Commit Message Mismatch
--

--- Patch [3]: [PATCH v6 3/8] scsi: ibmvfc: define asynchronous sub-queue -=
--
commit 4682ac13b0e9a18a4a0d6bd0390528a5ffb87d23
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: define asynchronous sub-queue

Define data structures for asynchronous sub-queue support required for
full and extended FPIN functionality.

> Add ibmvfc_async_subq structure to represent async events received via
> the sub-queue, including FPIN status, link state, event type, and WWPN
> information.
>=20
> Update ibmvfc_channel_setup structure to include async_subq_handle field
> and reduce IBMVFC_MAX_CHANNELS from 502 to 501 to accommodate the async
> sub-queue. Add async_scrq pointer to ibmvfc_channels structure.
>=20
> Add capability flags IBMVFC_USE_ASYNC_SUBQ and IBMVFC_SUPPORT_ASYNC_SUBQ
> for negotiating async sub-queue support with VIOS during login.

[Severity: Medium]
Are these changes missing from the patch? The commit message explicitly cla=
ims
to define the ibmvfc_async_subq structure, update ibmvfc_channel_setup, red=
uce
IBMVFC_MAX_CHANNELS, add an async_scrq pointer, and introduce several
capability flags. However, almost none of these structural changes exist in=
 the
actual patch.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvf=
c.h
> index e8ca0d30f483f..d8880d02685b3 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h

[ ... ]

> @@ -990,6 +990,7 @@ struct ibmvfc_host {
>  	mempool_t *tgt_pool;
>  	struct ibmvfc_queue crq;
>  	struct ibmvfc_queue async_crq;
> +	struct ibmvfc_queue async_sub_crq;

[Severity: Medium]
The commit message claims to add an async_scrq pointer to ibmvfc_channels,
but only async_sub_crq is added to ibmvfc_host here.


[Severity: High]
Does the adapter removal process introduce a NULL pointer dereference
during teardown?

If an FPIN async event interrupt arrives during the adapter removal process
after destroy_workqueue() is called but before free_irq(), the interrupt
handler will schedule the tasklet, which executes ibmvfc_handle_async().

In drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_remove():
    destroy_workqueue(vhost->fpin_workq);
    vhost->fpin_workq =3D NULL;

Then later in drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_release_crq_queue(=
):
    free_irq(vdev->irq, vhost);
    tasklet_kill(&vhost->tasklet);

And the tasklet dereferences the NULL fpin_workq:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_handle_async():
    queue_work(vhost->fpin_workq, &aw->async_work_s);

Because vhost->fpin_workq was destroyed and set to NULL early in
ibmvfc_remove(), calling queue_work(NULL, ...) will immediately panic the
kernel.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817-ibmvfc-fpi=
n-support-v6-0-62a2d525e70d@linux.ibm.com?part=3D3
