Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955D72F8E86
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 00:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787273645; cv=none; b=ofRjiLx9nFHQ6cR9ShKup6kWa+IuCUcephiE4XN+lgZbWx53mpRJg8cod5DGVEMCYImlS/pHhurkTTcdkNm3xgLOwmDgOoMvTPXKJOaxDLlI+pPUlzOBkpZJHKszOEu/QaB4rhDa9uLLqox3IZ+vAVg86wc6yxzteHCZM6lI7Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787273645; c=relaxed/simple;
	bh=Yq9tlC5SOlAyhEDLHLmrCY4sWYQ3j1jqkHc55yqfDpY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NDScCx20cquxPp53S2/Sxn13fXK4b2M9bH50gV9apW4F6NBBfbQYRA3VTE/O3nuhXnGSu4Is/1K0zGip1a+srqP5pcx6YPeJQWIPO1M2YrjrWwRFGUKAazM+l7+WgXX9R1KA1kns5/g0l4/JdL8iynVkPkkLavwQVCsDVlCDXIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fQwwjp/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQwwjp/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ACD1F000E9;
	Fri, 21 Aug 2026 00:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787273644;
	bh=za7JoVD0XSeEsr7fgy3nuKz5hLXWn8H+2vtcOV8NeTg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fQwwjp/5uVnu8W5L8fZyU5ZCi+COonsAveYrvJcRE7cC04oWbDGNO3s1B7aFt2nyw
	 716hD1vmuBE2FCIOdzGzMYlhHsV67NBSnIOdzQtqTK0zLGYzjWsn2Zadwtl55EoFm4
	 XiFWQA5cpeXM8ToljlCz/Q4rPZ/Cv2Fa9xznIPpR+x7afLYZk471Lv8tBaesD1dqtP
	 RZ3oT0iqUS71Kz+ci0e7sLO5sT6zJrSKBrn/1VTss5yBUhUsL7tDLOcNGZ81wd/Gam
	 U/fRtyw+T14l7t0QBu8qX0uXrcWNPt3L5dNmPcYlT8PqJczGWJcIBkRitQumd2Vsci
	 DdqBP7Y09nK3w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: wait for the EDIF RX timer before
 freeing entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260821002708.425265-1-runyu.xiao@seu.edu.cn>
References: <20260821002708.425265-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 00:54:03 +0000
Message-Id: <20260821005404.16ACD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The patch queues a self-destructing work item on the global `syste=
m_wq` which unlinks itself from tracking structures, leading to a kernel oo=
ps on module unload.

Pre-existing issues:
- [High] Lockless traversal in `qla_edif_list_find_sa_index` results in a T=
ime-of-Check to Time-of-Use (TOCTOU) Use-After-Free and list corruption.
--

--- Patch [1]: [PATCH] scsi: qla2xxx: wait for the EDIF RX timer before fre=
eing entries ---
commit f05ca5fac489b747acb7b49fe085de217cd65141
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

scsi: qla2xxx: wait for the EDIF RX timer before freeing entries

This commit addresses a race condition where the EDIF RX timer callback mig=
ht
run concurrently with entry removal and session teardown. It defers the fre=
eing
of the entry using a work item on the global workqueue, which waits for the
timer to finish using timer_shutdown_sync().

> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index bfa520f936a24..43c7da40a8169 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c

[ ... ]

> @@ -85,7 +87,8 @@ static struct edif_list_entry *qla_edif_list_find_sa_in=
dex(fc_port_t *fcport,
>  	struct list_head *indx_list =3D &fcport->edif.edif_indx_list;
> =20
>  	list_for_each_entry_safe(entry, tentry, indx_list, next) {
> -		if (entry->handle =3D=3D handle)
> +		if (entry->handle =3D=3D handle &&
> +		    !(READ_ONCE(entry->flags) & EDIF_ENTRY_FLAGS_FREE_PENDING))
>  			return entry;
>  	}

[Severity: High]
This is a pre-existing issue, but does this lockless traversal risk a
time-of-check to time-of-use use-after-free?

The list is iterated without holding indx_list_lock or using RCU. A caller
like qla24xx_sadb_update() receives the raw pointer and later uses it for
deletion, oblivious to the fact that it might have already been freed by a
concurrent worker thread or IO completion.

[ ... ]

> @@ -197,7 +201,51 @@ static void qla_edif_list_delete_sa_index(fc_port_t =
*fcport, struct edif_list_en
>  	unsigned long flags =3D 0;
> =20
>  	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
> -	list_del(&entry->next);
> +	if (!list_empty(&entry->next))
> +		list_del_init(&entry->next);
> +	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
> +}
> +
> +static void qla_edif_list_free_sa_index(struct edif_list_entry *entry)
> +{
> +	cancel_work_sync(&entry->free_work);
> +	timer_shutdown_sync(&entry->timer);
> +	kfree(entry);
> +}
> +
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
> +	if (!list_empty(&entry->next)) {
> +		list_del_init(&entry->next);
> +		free_entry =3D true;
> +	}

[Severity: High]
If the driver module is unloaded while this work is pending, is there a
risk of a kernel oops?

The work item unlinks the entry here, making it untrackable by
qla_edif_list_del() during module teardown.

> +	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
> +
> +	if (free_entry)
> +		kfree(entry);
> +}
> +
> +static void qla_edif_list_schedule_free_sa_index(fc_port_t *fcport,
> +						 struct edif_list_entry *entry)
> +{
> +	unsigned long flags =3D 0;
> +
> +	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
> +	if (!list_empty(&entry->next) &&
> +	    !(entry->flags & EDIF_ENTRY_FLAGS_FREE_PENDING)) {
> +		entry->flags |=3D EDIF_ENTRY_FLAGS_FREE_PENDING;
> +		timer_shutdown(&entry->timer);
> +		schedule_work(&entry->free_work);

[Severity: High]
Since this schedules the work on the global system_wq rather than a
driver-specific workqueue that gets flushed during module teardown, couldn't
the module be unloaded before this global work completes?

Because the work unlinks the entry as noted above, the standard module
teardown sequence won't see it to cancel the work, potentially leaving
the worker thread to execute unloaded module code.

> +	}
>  	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821002708.4252=
65-1-runyu.xiao@seu.edu.cn?part=3D1
