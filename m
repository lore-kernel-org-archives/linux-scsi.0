Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3EA349CDC
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 07:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787296299; cv=none; b=E6bNv/AcsTTQIor+YqrJRJxNgBXgs2fh7o1qyYpUdtSJzD9pZ6izrLwYhFShJInzmhXxjQIrGbPBhKH82wMhPcl/7nVm3ggKpJfEddkmQRB2rTnxQ1nd1vg/XuD1DodFKUbw495Gw+6ofHslEzphKlPKtli1NbKHI4txN+B3kuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787296299; c=relaxed/simple;
	bh=qa/oq8V6ZSCn3hOYumf7Yo/rqW1g2KwjB2ie5Qm1rhU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=svLBDiFkM+WoM21V7CXNjqxcRgdwLi+YW4n59Y5Dw9kindu2B1y5voGxUAtHGf15Rz6MuZUpGGgqQlkqhCQyczCnSrXLJxgbMt0cB9yrd4B5Cae5k88s18E+DE6j4FuwKxTEQYHolTuOHau5XLx1qL5JKIRzBtrxz9Hbi821h9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHIOnrNX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHIOnrNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BBB1F000E9;
	Fri, 21 Aug 2026 07:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787296298;
	bh=Yp6T5mtCz01HwcAT+JtXHKr4Pq9tLByMD3NdRhWOBCI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aHIOnrNXGpY2P5afgMn7smWBWF8pGbEuQ649YTbwzBrmCZM96fcDW7933tvJ1pvLw
	 LUNdvLwr0ajSoD/zwkQs33ZnQEn1U7/4CuWeql8HuAZ0UiB1moaDXps+ihaXvgiLcK
	 eRMY7byVfAHT9YW2ARG35Aqii06Vv3rqDcoqSujN2FAt1qYfgl90TBaFboLoqUl8e9
	 kg/Bz4aeAdj/P3YKV5ty5dVp4k5bpcU/gJgHGWB3W3hDfTicD1gW9Bc6JY0E2MbRhg
	 7Y+aIxQ9/OhWCrpOUlNfeSm/YXfboN7YW7UmzvojUhrI/PpGxW+H9OLfxLQUkN0qpG
	 0ueDlCFhi61Dg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: qla2xxx: synchronize EDIF entry teardown with
 timer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260821070021.92448-1-runyu.xiao@seu.edu.cn>
References: <20260821002708.425265-1-runyu.xiao@seu.edu.cn>
 <20260821070021.92448-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 07:11:37 +0000
Message-Id: <20260821071138.15BBB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Uninitialized `fcport` pointer in `edif_list_entry` causes a NULL =
pointer dereference in the deferred freeing workqueue.
--

--- Patch [1]: [PATCH v2] scsi: qla2xxx: synchronize EDIF entry teardown wi=
th timer ---
commit 79fc4cdf869d75c3e6f24287c79efbb79add0bf0
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

scsi: qla2xxx: synchronize EDIF entry teardown with timer

This patch introduces a deferred freeing mechanism for EDIF entries to
prevent teardown races with running timer callbacks. It keeps the entry
linked while teardown is pending and queues a work item to safely free
the entry on the adapter workqueue.

Link: https://lore.kernel.org/r/20260821002708.425265-1-runyu.xiao@seu.edu.=
cn

> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -163,16 +163,19 @@ static int qla_edif_list_add_sa_update_index(fc_por=
t_t *fcport,

[ ... ]

> -	entry =3D kzalloc_obj(struct edif_list_entry, GFP_ATOMIC);
> -	if (!entry)
> +	new_entry =3D kzalloc_obj(struct edif_list_entry, GFP_ATOMIC);
> +	if (!new_entry)
>  		return -ENOMEM;
> =20
> -	INIT_LIST_HEAD(&entry->next);
> -	entry->handle =3D handle;
> -	entry->update_sa_index =3D sa_index;
> -	entry->delete_sa_index =3D INVALID_EDIF_SA_INDEX;
> -	entry->count =3D 0;
> -	entry->flags =3D 0;
> -	timer_setup(&entry->timer, qla2x00_sa_replace_iocb_timeout, 0);
> +	INIT_LIST_HEAD(&new_entry->next);
> +	new_entry->handle =3D handle;
> +	new_entry->update_sa_index =3D sa_index;
> +	new_entry->delete_sa_index =3D INVALID_EDIF_SA_INDEX;
> +	new_entry->count =3D 0;
> +	new_entry->flags =3D 0;
> +	timer_setup(&new_entry->timer, qla2x00_sa_replace_iocb_timeout, 0);
> +	INIT_WORK(&new_entry->free_work, qla_edif_list_free_sa_index_work);

[Severity: High]
Does this code leave new_entry->fcport uninitialized? Looking at
qla_edif_list_add_sa_update_index(), the kzalloc_obj call zero-initializes
the memory, but there doesn't appear to be an assignment to set
new_entry->fcport to the passed-in fcport pointer.

[ ... ]

> +static void qla_edif_list_free_sa_index_work(struct work_struct *work)
> +{
> +	struct edif_list_entry *entry =3D container_of(work,
> +			struct edif_list_entry, free_work);
> +	fc_port_t *fcport =3D entry->fcport;
> +	unsigned long flags =3D 0;
> +	bool free_entry =3D false;
> +
> +	timer_shutdown_sync(&entry->timer);
> +
> +	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);

[Severity: High]
If entry->fcport is not initialized when the entry is created, will this
result in a null pointer dereference?

It looks like the worker thread in qla_edif_list_free_sa_index_work()
extracts the uninitialized fcport and attempts to acquire its spinlock,
which could lead to a crash here.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821070021.9244=
8-1-runyu.xiao@seu.edu.cn?part=3D1
