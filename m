Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1BB43F8BA
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 20:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790367207; cv=none; b=I/wAw0IfS0ZdbV9gOqh5Ix4h0r5ujZvqfVcB/3GRsrnySVkD+mlp4FFPPY8lP2Zbul8VWrc3agI7GEQXfhv1v6cPEg9kjllED031JmZ9C6jk4oqycj5oYnq6WecyY1YUNqCsXE+QBClLiL2aY8ZmlUu7YBstthBCJrPrJ9kegrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790367207; c=relaxed/simple;
	bh=rtVKgFof4j7Mge4t5Wqf+g2q8l0mazt0C8AwJgYmw6o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JOR7gPGD1ZWRHpt84CSDIoCcy+Xbo7FgtGNYokG683ypjKf9/o0LuTh85AoM1ezPdF5Cp6N+NwySFrmXWef3NiM0rKWdjrbz6Te/DS5X0wij8zaiMb3o2+Ofo6GrTCBJ5cPcZjaKxOPXggRpHDxzbxfY0apHcjCNAOxSB9QrxdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NyW57ubc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NyW57ubc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61A51F00893;
	Fri, 25 Sep 2026 20:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790367205;
	bh=yJkY8SVrQ4KEvaGTJjUvanm4/ewRNBYed87wqTX1Itw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NyW57ubcLT1Fom2fH1oniLbZ+8JA8jEG/TB3eRhkK6yviFKGOkowC0NwU3bLQAoFr
	 aYi750BxWzMv/ibOObYUYdm//dv94pudH2Ag1E2vNPyGMoIVjV6jOiUljE8FJ8u2zf
	 N9a6RMoHdAU2ACdauWMCMHsW3frQtXUAn6PJE4KFPuyFq8V/28WwiwEMLSK192uvKp
	 6ia2/lkXupKNAaDWj11HFC0Zvx4GNu/CUaPlMxqsWqDQ0dHzjmapNw7Fydj7Jbtc9J
	 HhJJb+7Enj+1/xeNML1cZf83ZmIyiVf1HPxitvAxx6rWM7434ddbH/GSuadyqywsGe
	 Vv4QnRLfeohyg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.1.y] scsi: hisi_sas: Grab sas_dev lock when traversing
 the members of sas_dev.list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Dinaburg" <artem@trailofbits.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260925195622.31558-1-artem@trailofbits.com>
References: <20260925195622.31558-1-artem@trailofbits.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 20:13:25 +0000
Message-Id: <20260925201325.B61A51F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: hisi_sas: AB-BA lock inversion between sas_dev->lock and his=
i_hba->lock
--

commit f12017bc77f1c8af65ce94588bd971006d10081f
Author: Xingui Yang <yangxingui@huawei.com>
scsi: hisi_sas: Grab sas_dev lock when traversing the members of sas_dev.li=
st

This commit fixes a NULL pointer exception during slot completion by grabbi=
ng
sas_dev->lock when traversing the members of sas_dev.list. It adds a need_l=
ock
parameter to hisi_sas_slot_task_free() to avoid re-acquiring the lock when
it is already held by hisi_sas_release_task() or dereg_device_v3_hw().

Link: https://lore.kernel.org/r/1679283265-115066-2-git-send-email-chenxian=
g66@hisilicon.com

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sa=
s/hisi_sas_main.c
> index 10ea1d434c48d..290c9915fb9b2 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -239,9 +239,13 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_h=
ba, struct sas_task *task,
>  		}
>  	}
> =20
> -	spin_lock(&sas_dev->lock);
> -	list_del_init(&slot->entry);
> -	spin_unlock(&sas_dev->lock);
> +	if (need_lock) {
> +		spin_lock(&sas_dev->lock);
> +		list_del_init(&slot->entry);
> +		spin_unlock(&sas_dev->lock);
> +	} else {
> +		list_del_init(&slot->entry);
> +	}

[Severity: High]
Does this code introduce an AB-BA lock inversion deadlock?

When need_lock is false, this code executes while sas_dev->lock is already
held by the caller (hisi_sas_release_task). Shortly after this snippet,
hisi_sas_slot_task_free() calls hisi_sas_slot_index_free() which takes
hisi_hba->lock, establishing a lock dependency of sas_dev->lock ->
hisi_hba->lock.

However, on v1 hardware, the completion interrupt handler cq_interrupt_v1_h=
w()
acquires hisi_hba->lock before calling slot_complete_v1_hw(), which then ca=
lls
hisi_sas_slot_task_free(..., need_lock=3Dtrue). This inner call acquires
sas_dev->lock, establishing a reverse lock order of hisi_hba->lock ->
sas_dev->lock.

If these two paths run concurrently on different CPUs during device error
handling, could this freeze the system? Also, if they run on the same CPU,
could an AA deadlock occur since the EH thread uses spin_lock without disab=
ling
IRQs?

[ ... ]

> @@ -1085,8 +1089,11 @@ static void hisi_sas_release_task(struct hisi_hba =
*hisi_hba,
>  	struct hisi_sas_slot *slot, *slot2;
>  	struct hisi_sas_device *sas_dev =3D device->lldd_dev;
> =20
> +	spin_lock(&sas_dev->lock);
>  	list_for_each_entry_safe(slot, slot2, &sas_dev->list, entry)
> -		hisi_sas_do_release_task(hisi_hba, slot->task, slot);
> +		hisi_sas_do_release_task(hisi_hba, slot->task, slot, false);
> +
> +	spin_unlock(&sas_dev->lock);
>  }

[Severity: High]
This is where the new scope of sas_dev->lock is introduced. Since
hisi_sas_do_release_task() eventually calls hisi_sas_slot_index_free(),
which acquires hisi_hba->lock, we are nesting hisi_hba->lock under
sas_dev->lock.

Could this traversal be modified to avoid holding sas_dev->lock during
the call to hisi_sas_slot_index_free()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925195622.3155=
8-1-artem@trailofbits.com?part=3D1
