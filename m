Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794923847;
	b=WuEuhwnubtCK72Eputjtt7MMnagKrHAigiMfSYMX95TcgHRo05154t8gje4spDLK3ZeM
	 xZ7n6M5/0OwPvef7NC9+EUhEwkUBWI3LDlUkQhUT8k2B3CepZyjL2faGW4ZJjJ6LsBNKE
	 EdxrMZGZLia5/7aTdEsBML12MJ6wvZL9QD0eDtGsF5fyv7B+kGP+0pZ28TQdFgc+Bgwa+
	 GIxtb+bmQd5hHCMBKYG/9QednOTCVuttn6jXnl9ASkHcmpt9s8RC4fq9KR0a7zy/sXwR0
	 oIbkwVoTklDPeco6HhDKKt/Rv5+tp4RO/Cd030PVetZLrtmX/9IgersfWNUqwoCGHtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794923847;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=q80GOed39i3K3o44CyuWg9RhHd1G09MOvVEVbXHipTg=;
	b=ICvJB1yF6iXZPPs1wpGTm/Fa5hbxTVmOjAjvyts6O/oLbW5rqjA7QLQUtsYsNVUe6c+x
	 DE0t9Qv8mDDJH7jv4tJj0ahiZeT5eAy3ttNfmNK7vNQenwj+BqHy69INe9ayrBOFSY1QU
	 /SZ4wDFVYtHfZ+Ly7HN+7kQ/FeLteKj1orM5JRzrNelj8ZREmm32xV/Nw5JuUpe3QR51O
	 EJZxdk9QlMzh+n42OybwZfVX1GOnjnL8uL7xcVyHBuX1q8tTJA5OO6LwNTjZt6tJ6vY74
	 0/DRRuq59rLfk8Yem3n9ZCMZl8SXln75+wnunf5TrlWnTkiEKfm4lTkk14C5dVZZmxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaNT69xI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1587F606A32C
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 13:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaNT69xI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04E41F000C4;
	Tue, 17 Nov 2026 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794923846;
	bh=q80GOed39i3K3o44CyuWg9RhHd1G09MOvVEVbXHipTg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SaNT69xIo/nHlcy1VJ6KixyBK4JXBIVIQC7wNldyXm3fNPPjyBLKutiebT7I9PvDQ
	 ebfHGzibuONf81tFMUjR4QzEWndrm9TWcQAHmB+6LyCxfh1bwUuLqFwzJfBxwgaUHw
	 u+YUdhkzfB5ddBIVBhoDWIpDgO0jfSC3Hc6nI/T7JmD2jUHhVdpRYMad1FfMOer3Om
	 nwmDSHbxJnL6/xUptoq/2mppWf8gGBGBneRbfv7jRmS6Mj8/N3XVmv9pArfYUVY274
	 KoHRtPKOljhUHRGKEbuwDf8KveLcIHJ7sAElbp75Wszwd0sUKVkNrV/dLRgZask0xd
	 FByDzz9gJXD3Q==
Message-ID: <sashiko-outbox-218911@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/3] scsi: mvumi: flush the event work before the
 host is freed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261117134227.2077013-4-yhlee@isslab.korea.ac.kr>
References: <20261117134227.2077013-1-yhlee@isslab.korea.ac.kr>
 <20261117134227.2077013-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 13:57:26 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] scsi: mvumi: 45s hang draining work_q after free_irq() in
  probe and detach
--

commit fea1f9d38eeeed5d46b0fb512a378a51f64fd086
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: flush the event work before the host is freed

This commit gives mvumi its own per-HBA workqueue for event notifications
and drains or destroys it on probe failure and device removal before the
host is freed.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index fe3f63a1088dc..79086e2dd22e3 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c

[ ... ]

> @@ -2570,9 +2577,14 @@ static int mvumi_probe_one(struct pci_dev *pdev, c=
onst struct pci_device_id *id)
>  fail_io_attach:
>  	mhba->instancet->disable_intr(mhba);
>  	free_irq(mhba->pdev->irq, mhba);
> +	flush_workqueue(mhba->work_q);
>  fail_init_irq:
> +	/* mvumi_release_fw() frees buffers the controller was given */
> +	pci_clear_master(pdev);
>  	mvumi_release_fw(mhba);
>  fail_init_fw:
> +	destroy_workqueue(mhba->work_q);
> +fail_alloc_workqueue:
>  	scsi_host_put(host);
> =20
>  fail_alloc_instance:
> @@ -2600,6 +2612,7 @@ static void mvumi_detach_one(struct pci_dev *pdev)
> =20
>  	mhba->instancet->disable_intr(mhba);
>  	free_irq(mhba->pdev->irq, mhba);
> +	destroy_workqueue(mhba->work_q);
>  	pci_disable_device(pdev);
>  	mvumi_release_fw(mhba);
>  	scsi_host_put(host);

[Severity: Medium]
Does draining mhba->work_q after disable_intr() and free_irq() cause a
45-second hang when an event work item is pending or in flight?

mvumi_scan_events() calls mvumi_get_event() -> mvumi_issue_blocked_cmd(),
which waits on mhba->int_cmd_wait_q for MVUMI_INTERNAL_CMD_WAIT_TIME * HZ
(45 seconds).  That wait queue is only woken by mvumi_complete_internal_cmd=
()
from mvumi_isr_handler().  Because interrupts have already been masked and
freed in both fail_io_attach and mvumi_detach_one(), any queued
mvumi_scan_events() work item cannot receive its completion interrupt and
blocks until the 45-second timeout expires.  In mvumi_detach_one(), a
pending work item will also submit a new APICDB0_EVENT command after
mvumi_flush_cache() has already sent CDB_CORE_SHUTDOWN.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117134227.2077=
013-1-yhlee@isslab.korea.ac.kr?part=3D3
