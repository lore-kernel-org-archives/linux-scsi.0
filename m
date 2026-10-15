Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50472306B3D
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 15:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792077633; cv=none; b=DpDRxvkjemyvdZvmk2/Hgllta6FiEtuDP9T6NJ+AvHAY1ksHMI6DmKXsDrwRnulNhAikHruoi4jEQTJ9QVffkcxVA4Gn2FFE7a74y46u5z+lPhuo7dbP+sv71V0Jfiqtmge2DdQ37TN/4qxqMAyJRy8vetnP30FW5aj5JzJsWY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792077633; c=relaxed/simple;
	bh=rVHoe4/jiF1edJH05AhZZLEzCAhbCNv2U1TC1Yr6haY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=bTBsMiDxpv+00pssVFs+x9iFQRDONQi/nWx4u/BdCwCjSIYBM8Rd7i47dOVVsNsc31ALdgo7vRyC/PUISFteEiMxqxZtrdbShRQaivTZbP4bslt2/l1mbNMzTHUfiUY682VH/pz7JjgaBxaYgKdAL0Yi7MrdlNyfMJ+BgdGrjnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J7iLtWq+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J7iLtWq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8491F000C5;
	Thu, 15 Oct 2026 15:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792077627;
	bh=Dbe0vNTfhnZgxFuzkUjh0GCpIG9rEmaL9KZEFO5vZ5s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J7iLtWq+DeRjzpPWenIuksVoj7FJqmSuSPaL0+MsEe2GbuykdjtRe2FkR0M5xGrF2
	 J4NspPDi+axwk3XlYehAzXl5Xv/V2fKcwfKzqOokx+F8V1jytywIqXXxHkXCRbn99+
	 O5BMtahjSc0oRHp1TAsYkQi/306PT0PP4xFwU252YBNo82SdYKGnpRfj7vSvh1vcu3
	 tokS1UB/coB/5PBqznIGHKXaV9E0OGrfR5jyRujQrj9Deo1IMcoZtblLamsZ2c4kIh
	 IlstTPsD7dpf1MuBCub6DYth4yUG0eqBSLS91gzZGvWmQPLd2nB+9LyXNKzJRk6KeJ
	 W2uIOXl2Pc9EA==
Message-ID: <sashiko-outbox-173052@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 07/11] scsi: ibmvfc: extend async event handlers for
 async sub-CRQ events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015-ibmvfc-fpin-support-v14-7-a0b063b8d825@linux.ibm.com>
References: <20261015-ibmvfc-fpin-support-v14-0-a0b063b8d825@linux.ibm.com>
 <20261015-ibmvfc-fpin-support-v14-7-a0b063b8d825@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 15:20:27 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: UAF and module unload crash due to untracked async w=
ork
--

commit e22506651b699f9db9776870465be492a807fad7
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: extend async event handlers for async sub-CRQ events

This commit refactors async event handling to support both traditional async
CRQs and new asynchronous sub-queue CRQs. It introduces a tagged union
struct ibmvfc_async_crq_event to hold either event type and updates the
corresponding handlers and FPIN processing logic.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 9c710897cd546..87ee19057551e 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -3629,14 +3711,14 @@ static void ibmvfc_handle_async(struct ibmvfc_asy=
nc_crq *crq,
>  			}
>  			INIT_WORK(&aw->async_work_s, ibmvfc_process_async_work);
>  			aw->vhost =3D vhost;
> -			aw->crq =3D *crq;
> +			aw->event =3D *ae;
>  			schedule_work(&aw->async_work_s);

[Severity: High]
Does this code leave the scheduled work item untracked without a cancelation
path during module unload or device removal?

Looking at ibmvfc_remove(), it executes without flushing the system workque=
ue
or canceling these specific work items. It then calls ibmvfc_free_mem() whi=
ch
unconditionally destroys vhost->tgt_pool via mempool_destroy():

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_remove() {
    ...
    flush_work(&vhost->rport_add_work_q);
    fc_remove_host(vhost->host);
    scsi_remove_host(vhost->host);
    ...
    ibmvfc_free_mem(vhost);
    spin_lock(&ibmvfc_driver_lock);
    list_del(&vhost->queue);
    spin_unlock(&ibmvfc_driver_lock);
    scsi_host_put(vhost->host);
}

If the work executes after the target pool is destroyed,
ibmvfc_process_async_work() looks up a target, takes a reference, and
eventually calls ibmvfc_release_tgt(), which triggers a use-after-free
by calling mempool_free() on the already-destroyed pool:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_release_tgt() {
    struct ibmvfc_target *tgt =3D container_of(kref, struct ibmvfc_target, =
kref);
    mempool_free(tgt, tgt->vhost->tgt_pool);
}

Furthermore, since scsi_host_get() does not hold a module reference, rmmod
could complete while the work is still queued. Could this lead to the system
workqueue executing unmapped memory and causing a kernel panic?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015-ibmvfc-fpi=
n-support-v14-0-a0b063b8d825@linux.ibm.com?part=3D7
