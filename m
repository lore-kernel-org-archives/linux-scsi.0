Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795647267;
	b=Yvvr8IQT/+Wb0O2+C0f14UXyrb5DcYN3X5QTCFx7fHtb+z/J13MuNvLa+RzCuAs+6hli
	 wkgZOTSV7ac04bqvsPKdUbtFKM2GU0auy2RlEfVswAa61m+y7ncrnMm47cZsFQ+zhfKc8
	 3/HxWftRkopOQo36XYCAOvCMsj/JjjjsXbVBheO1eaxqoR/SVDY5D6VFEjRsvlAW8ekuV
	 V3c66ZOH2GEsg6vanyYxqwCvgMeiSqdEpZxpPYXnIVKuKRdpwo1o8WUIT5adW0rlpHOSg
	 iyRu7o178iQGXVp0AA2Sk9DJoZMQ+JpYHXiuzb9lxhDRRYWwJt+Z0/OZ8X3SGLLfoFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795647267;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mHzpgAnmTqWxuwEvrt2C9Lc60n+HJf1wOT6ymZCVPa0=;
	b=bFZdmvT9wzTGcrkmC34UmIf+clvWlerlg4rrMPtxPJ8BO5jrdss+BPNNE81doPw47sDd
	 Ou5kfjVz/SM+T45ed2S4g4yGGM8UeA2qcGFPZ9Z58aKVdwQZls1xIUD1aHRTQqPjjDZq3
	 Wkc6ExyY7yinwz2ZGB/QBjUBbCIeyyFfJU0xzHs/72sPmiPe02z9vx+zUOVl+0oKZs2Fo
	 qfmzPi3GmsYkfho2YFsy+wCtZ+6F58J8cyGsxArTMlOwJTEAMpQL1s5dMB+2nS1JoUJYD
	 D6+sODMlc+oekKwuI3w2yUmyYrArX8bgg7rq/cYauSmlLm+QXeJ9usVqRQq4xCFmy2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="K7p/z8D/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0DB606A680
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 22:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K7p/z8D/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA57B1F000C6;
	Wed, 25 Nov 2026 22:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795647267;
	bh=mHzpgAnmTqWxuwEvrt2C9Lc60n+HJf1wOT6ymZCVPa0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K7p/z8D/ki/wyUhf8cJxdWEXJzbgk2uX0oEZNzkeisDNibQS/Rp1CZOlsRgNhBloT
	 VSxRQRYo/HIdfRZCEcoAZnZFns428tMBmZg/Cd6jklOpfj+NpruFpzKph862LUkuvY
	 QEOFSy5mcKRh69TvA4GN+PB1wvtYy/sWq4WELQmlQixOHJvV3UNQWjy5zPOwCASM4D
	 0iq7DY0UuCMfVvm1N+5Mp7iUUqfoeWdaMwg+HFAeATngZx6Z+oDy04fhN0Zs+NunIH
	 8+LIbA/pBt5zg2krfXzck2XXsFqDtXFX6rOFlYnHN7bx5y9NeiONnQUynAq0ZFaln9
	 dH6+VsvvIFpkA==
Message-ID: <sashiko-outbox-234314@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: hisi_sas: Avoid synchronize_irq() under
 task_state_lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Elkin Cruz" <elkin@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261125222029.1429071-1-elkin@google.com>
References: <20261125222029.1429071-1-elkin@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 22:54:26 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] scsi: hisi_sas: TOCTOU race in hisi_sas_slot_task_free()
  [1]
--

commit f4ff37b15758e0c223690d6105b63787d918393e
Author: Elkin Cruz <elkin@google.com>

scsi: hisi_sas: Avoid synchronize_irq() under task_state_lock

This commit releases task->task_state_lock in hisi_sas_abort_task() before
synchronizing the completion queues when SAS_TASK_STATE_DONE is set, and
reads task->lldd_task under task->task_state_lock on the abort path.

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sa=
s/hisi_sas_main.c
> index 06455c7a9e2ad..2a5a34eb1b28b 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -1730,7 +1730,7 @@ static int hisi_sas_abort_task(struct sas_task *tas=
k)
>  	struct hisi_sas_internal_abort_data internal_abort_data =3D { false };
>  	struct domain_device *device =3D task->dev;
>  	struct hisi_sas_device *sas_dev =3D device->lldd_dev;
> -	struct hisi_sas_slot *slot =3D task->lldd_task;
> +	struct hisi_sas_slot *slot;
>  	struct hisi_hba *hisi_hba;
>  	struct device *dev;
>  	int rc =3D TMF_RESP_FUNC_FAILED;
> @@ -1744,21 +1744,18 @@ static int hisi_sas_abort_task(struct sas_task *t=
ask)
> =20
>  	spin_lock_irqsave(&task->task_state_lock, flags);
>  	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
> -		struct hisi_sas_cq *cq;
> -
> -		if (slot) {
> -			/*
> -			 * sync irq or poll queue to avoid free'ing task
> -			 * before using task in IO completion
> -			 */
> -			cq =3D &hisi_hba->cq[slot->dlvry_queue];
> -			hisi_sas_sync_cq(cq);
> -		}
>  		spin_unlock_irqrestore(&task->task_state_lock, flags);
> +		/*
> +		 * Sync all CQs to avoid freeing task before IO completion
> +		 * finishes using it; slot and slot->dlvry_queue may already
> +		 * be cleared or reallocated once SAS_TASK_STATE_DONE is set.
> +		 */
> +		hisi_sas_sync_cqs(hisi_hba);
>  		rc =3D TMF_RESP_FUNC_COMPLETE;
>  		goto out;
>  	}
>  	task->task_state_flags |=3D SAS_TASK_STATE_ABORTED;
> +	slot =3D task->lldd_task;
>  	spin_unlock_irqrestore(&task->task_state_lock, flags);
> =20
>  	if (!slot)

[Severity: Critical]
This problem wasn't introduced by this patch, but can a concurrent
hisi_sas_release_task() and hardware completion race in
hisi_sas_slot_task_free() [1] and double free the slot?

Although hisi_sas_abort_task() now reads task->lldd_task under
task->task_state_lock, hisi_sas_slot_task_free() checks and clears
task->lldd_task without holding any lock:

drivers/scsi/hisi_sas/hisi_sas_main.c:hisi_sas_slot_task_free() {
	...
	if (task) {
		...
		if (!task->lldd_task)
			return;

		task->lldd_task =3D NULL;
	...
}

When hisi_sas_release_task() runs under sas_dev->lock (passing
need_lock=3Dfalse) at the same time as a completion handler (passing
need_lock=3Dtrue), both threads can pass the !task->lldd_task check:

CPU0                                CPU1
hisi_sas_release_task()
  spin_lock(&sas_dev->lock)
  hisi_sas_slot_task_free(..., false)
                                    hisi_sas_slot_task_free(..., true)
    if (!task->lldd_task)             if (!task->lldd_task)
    task->lldd_task =3D NULL;           task->lldd_task =3D NULL;
    // unmap DMA                      // double unmap DMA
    list_del_init(&slot->entry);
                                      spin_lock(&sas_dev->lock)
    memset(slot, 0, ...);
    hisi_sas_slot_index_free(...);
  spin_unlock(&sas_dev->lock)
                                      list_del_init(&slot->entry);
                                      spin_unlock(&sas_dev->lock)
                                      memset(slot, 0, ...);
                                      hisi_sas_slot_index_free(...);
                                        <-- corrupts and double-frees slot

If the slot index is reallocated while CPU1 is waiting on sas_dev->lock,
CPU1 zeroes out the live slot with memset() and frees the slot index a
second time.

[1] https://sashiko.dev/#/bug/linux-5c918a18-1806-4334-a75b-c6fd3a29066d

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125222029.1429=
071-1-elkin@google.com?part=3D1
