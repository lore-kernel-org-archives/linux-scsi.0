Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DF236DA00
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785452580; cv=none; b=qE+Ks8rZhtUh9Rw9BFQDy634MIcTxC7bvNqcw0SlWP46by/g6mJSIEjx0o+Z4eubNxq2TntDTPwB5ipk4kCA8f7Xn1UemO6He2V6sbQw5XosRjFkG14seMMEiYYvkE8FOYJWwrEfj942+gfo3bgzvyAP+TjlkP4OehIYGbvKsdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785452580; c=relaxed/simple;
	bh=vGeCWNYku5omHbTC9O/m9tEefKb15xfGUwfvoRoBSuc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=q1oQGLyH1m+jk1+jZnwjFWNRP1TSZxjnS9kzTLsqoXtZmom1kZPNRVXIfMVqZQcy/1CoK4rb9uP+rZRFjpjGbUSXTFOKhW4v7Cu0iwIYMUQgNvvi7KiprsErk5cM/d45O5tOKSUOEE5dr368XGKQqY/0egjt+eTKf9uQqRHYiL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M+oiqnb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M+oiqnb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABF31F000E9;
	Thu, 30 Jul 2026 23:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785452578;
	bh=uV6IiAF4rlGiquu1w+MLKtEBB6B+0UZArEn/Gy/k8tk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M+oiqnb7VZ50ai6HR01lU1CcEJClMKnktTUcPfXaUg4x+ZLVdzWeP9SKLBJOem9g9
	 hmXgAprpfSffVt6fIxcnYu2lenpDV5RHW6gr5wndQP3DwYMoWHDyX9rJn022bT0OhK
	 ggtRjCOfxaeho8R7IlYCms+ZrHiIpi5IWJoVdzl1dmCckxWK5GDztGEqi5QCi/yiCf
	 tB38ETRXdZw2otDlh7PB/ju5Vxx+r/PcnJIJ4wqtlWCHdxp+eC0RNNKvErk/prg3Cr
	 v/RPAqoS9Asv/MzBdpqAiiMytM2aq6l8QyEr+7sTqqoWFyPjA/+eIRc531EEgT7E++
	 vRsQo0AHyb5vg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 27/57] scsi: hisi_sas: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <805f885fbac93c01cf2427cc144c48bd7c22a3c9.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <805f885fbac93c01cf2427cc144c48bd7c22a3c9.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:02:57 +0000
Message-Id: <20260730230258.5ABF31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Calling synchronize_irq() inside an irqsave spinlock critical sect=
ion causes a 'scheduling while atomic' bug.
--

--- Patch [27]: [PATCH v3 27/57] scsi: hisi_sas: Enable lock context analys=
is ---
commit 289c0dd12dd00005d6efe11e9c29f7fd715a2464
Author: Bart Van Assche <bvanassche@acm.org>

scsi: hisi_sas: Enable lock context analysis

This commit enables lock context analysis for the hisi_sas driver via the
Makefile.

> diff --git a/drivers/scsi/hisi_sas/Makefile b/drivers/scsi/hisi_sas/Makef=
ile
> index 742e732cd51d5..8576c78d4afe3 100644
> --- a/drivers/scsi/hisi_sas/Makefile
> +++ b/drivers/scsi/hisi_sas/Makefile
> @@ -1,4 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +
> +CONTEXT_ANALYSIS :=3D y

[Severity: High]
This is a pre-existing issue, but enabling context analysis here might
immediately trigger warnings or panics due to a scheduling while atomic bug.

When hardware timeouts or aborts trigger SCSI error handling, and the
task is already complete, hisi_sas_abort_task() calls hisi_sas_sync_cq()
while holding a spinlock with interrupts disabled:

drivers/scsi/hisi_sas/hisi_sas_main.c:hisi_sas_abort_task() {
    ...
    spin_lock_irqsave(&task->task_state_lock, flags);
    if (task->task_state_flags & SAS_TASK_STATE_DONE) {
        struct hisi_sas_cq *cq;

        if (slot) {
            cq =3D &hisi_hba->cq[slot->dlvry_queue];
            hisi_sas_sync_cq(cq);
        }
        spin_unlock_irqrestore(&task->task_state_lock, flags);
    ...
}

The hisi_sas_sync_cq() wrapper then directly calls synchronize_irq() for
non-poll queues:

drivers/scsi/hisi_sas/hisi_sas_main.c:hisi_sas_sync_cq() {
    if (hisi_sas_queue_is_poll(cq))
        hisi_sas_sync_poll_cq(cq);
    else
        synchronize_irq(cq->irq_no);
}

Will this cause a panic or deadlock when synchronize_irq() calls
wait_event() and attempts to sleep while the CPU is holding the
task_state_lock spinlock?

> +
>  obj-$(CONFIG_SCSI_HISI_SAS)		+=3D hisi_sas_main.o
>  obj-$(CONFIG_SCSI_HISI_SAS)		+=3D hisi_sas_v1_hw.o hisi_sas_v2_hw.o
>  obj-$(CONFIG_SCSI_HISI_SAS_PCI)		+=3D hisi_sas_v3_hw.o

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D27
