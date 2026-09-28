Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035A528505E
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 04:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790568900; cv=none; b=GLOnmfK1tcLZleEWmDs7vDzopi2Rqul7z4c1mFdb07ZQh1v9K5g20rlNl1Yp28W2oovaD04j3G4iJpoExVbhtTHpEVkss+UlqSI+z2YOmSbISErO9q7gPdbONPxia01z49w+S0rkH1yoY0bMAv+G32LQ6R7IgDfu3I8dsARwHfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790568900; c=relaxed/simple;
	bh=JqJspdZSKKOPL5NbA8PYuEk2WfYQ+LqsulejlMCaS6g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pBuAuCden5tWE1pNx0eBrutoKYyxlRe7SRkTb8h2eHk30briw0h8sdDukxEpbstjBkqAiovwLYlNScdxm9IOvmywjMFadoDDwxBuwO303aOpZOM+xDepf1Ms7De5ORNcf/d+cm1mG6m6MmmacrOKug4Gt7LAFbkaP9nNXwmUcEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2HG5+ZV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2HG5+ZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0891F0089A;
	Mon, 28 Sep 2026 04:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790568897;
	bh=jZzahg1OXmmYUcd0IwxZO8QW8dj0qyczZ5EmvPlnK14=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P2HG5+ZVaZKBc9uzTuMZIoHPgtSE/6PgyBxm1EjmIiQSst9qFksZmkBTsK4HFTUu1
	 mjiGtuajHEb8A57AiS1BuAT41AoSJEhGc8ggqQiQgsIK7Z1nCIA9HpZPLu8SFGRN2E
	 rywUWZToqHset2kiMT88TrxN3jalj41yJlzwYn0egI/SIcl2epk3KSNNpAaDNY2lZn
	 j4xmSxP1Cy+E7CkQXlHw3OtAnndn2csaWXThnt3/Q48IxQBZfm+MBuSoquxu8uk89A
	 ec+tG6wfI7uMbCEDGn4qBXK+MPNnUhb5Def7drVcq3FuF/RjJ2R8bfAA3jliSNaXOn
	 CV2zN7vc4ennQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] scsi: libsas: Fix SMP IO deadlock during HA resume
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260928040234.992912-1-yangxingui@huawei.com>
References: <20260928040234.992912-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 04:14:57 +0000
Message-Id: <20260928041457.BA0891F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: libsas: hardware access on suspended host in smp_execute_tas=
k_sg()
--

commit b6ffaa3a7e18a8e3fec2c6c49ebb1c88915b9f8d
Author: Xingui Yang <yangxingui@huawei.com>

scsi: libsas: Fix SMP IO deadlock during HA resume

smp_execute_task_sg() calls pm_runtime_get_sync() on the host before
issuing an SMP command. When that command is itself issued from the
HA resume path, the get_sync() deadlocks: it waits for the ongoing
resume (the device is RPM_RESUMING), while the resume is blocked in
sas_drain_work() waiting for that same SMP IO to complete.

> The usage reference is still required. Discovery work normally runs
> inside an event worker's PM reference, taken at
> sas_notify_port_event() notify time and held until the handler has
> flushed the disco queue. sas_rediscover_ex_phy() however requeues
> DISCE_REVALIDATE_DOMAIN from within the revalidation worker itself,
> and flush_workqueue() does not wait for work items queued during
> execution, so that chained revalidation runs with no outer PM
> reference - without the get_noresume(), its SMP could race
> autosuspend.

[Severity: High]
Does pm_runtime_get_noresume() actually prevent this race if the device
has already autosuspended?

When chained revalidation occurs in sas_discover.c:sas_revalidate_domain(),
it runs without an outer PM reference. If the host autosuspends before
smp_execute_task_sg() runs, pm_runtime_get_noresume() will only increment
the usage counter and leave the device suspended.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index 811c9eb4fef11..26c2099c28b97 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -62,7 +62,11 @@ static int smp_execute_task_sg(struct domain_device *d=
ev,
>  		to_sas_internal(dev->port->ha->shost->transportt);
>  	struct sas_ha_struct *ha =3D dev->port->ha;
> =20
> -	pm_runtime_get_sync(ha->dev);
> +	/*
> +	 * Non-blocking: a sync resume here would deadlock against
> +	 * sas_drain_work() during HA resume.
> +	 */
> +	pm_runtime_get_noresume(ha->dev);

[Severity: High]
If the host has already autosuspended when this is called, will this cause
a crash or hardware fault?

Because pm_runtime_get_noresume() does not wake suspended devices,
when lldd_execute_task() is called later in this function:

drivers/scsi/libsas/sas_expander.c:smp_execute_task_sg() {
    ...
		res =3D i->dft->lldd_execute_task(task, GFP_KERNEL);
    ...
}

hardware commands would be dispatched to a powered-down host.

>  	mutex_lock(&dev->ex_dev.cmd_mutex);
>  	for (retry =3D 0; retry < 3; retry++) {
>  		if (test_bit(SAS_DEV_GONE, &dev->state)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928040234.9929=
12-1-yangxingui@huawei.com?part=3D1
