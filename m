Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D06378D82
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 11:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782388531; cv=none; b=pYnt4koni40oDPUlELmYPiqWjcNJRCKpi0kSm7iPqhUiF8Db+KIQihWk0EXtck+p1ZVVJZ+qXZ3oa2IR+tfGRxEr0hfHVUbA5QfE7UwnKw6U6rGkJPThhiq8tk2rUZnFPG8z3HyYAz/CCwkmlL3eebR89pz1vgmqoJDBZ/1465g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782388531; c=relaxed/simple;
	bh=qljR1/WOvUoOekScpvRgUTe+A5OQJZI1f2/l1FgNnwM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=roVZOqWcE/iKKcnSB1p4XUizMc/ZMrX5eJm9yUQj4geexk/nCcE4jBIbXlKFh9SIigMOMBuiIFGdCCpDiycSDcYbFrgw2fMRVeE1suoWmISpgf/B1uq9/0Q95P5ZALkSuiRW5s0jKhC7Yz2Kx6D28u6T7TYCNV7A76TdVEQXXXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qdrs9usk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qdrs9usk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7781F000E9;
	Thu, 25 Jun 2026 11:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782388530;
	bh=iZLFcbx4nbg1Mx7KmpAYC7tjAGZaCjXNnqAaKmQFz74=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qdrs9uskwCjmH/mlMPMuc7U4IF/Njv/in5wMOf5hSMbGSJVqyjPECSV02gG4er7bv
	 C+L6op6EDxKRpad7+Yx7k75qo81oUJ7hQd0pjc7x4pw9hdaNXkTZEsyqc5XTRsIGqs
	 aTLxPbRxZBhVa5E/aA+JH4FXpZqQR0ox9knkQihEXGBLOxsZxMG4m22annDqB4SzRu
	 1L0a1SbdEuEVhGJ43lgjTBobMcPhzyngOb606ig6OkV9XW71zte7mYNTz/yhXVKWXW
	 JsXyKlHZc0dFQDWvJYy4DeDUsyxncVM0l3VDy7RmSVJZIaHitASt3zKsR/FzvJqJFf
	 AkULjcCQt6VBg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: core: annotate LUN hlist traversals
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260625113807.574788-1-runyu.xiao@seu.edu.cn>
References: <20260625113807.574788-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 11:55:29 +0000
Message-Id: <20260625115529.BB7781F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Traversing an RCU list using `hlist_for_each_entry_rcu()` without =
`rcu_read_lock()` while concurrently removing and freeing elements leads to=
 a Use-After-Free.
--

commit 0808004d8e16208c69c8bd1b2b9d1e2400a32c51
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

scsi: target: core: annotate LUN hlist traversals

This commit annotates LUN hlist traversals with lockdep conditions where
a mutex is held instead of an RCU read lock. This silences
"RCU-list traversed in non-reader section!!" warnings from
CONFIG_PROVE_RCU_LIST without changing semantics.

> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_=
core_device.c
> index 9db2201aa553f..82aa831c69c9b 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -237,7 +237,8 @@ void core_free_device_list_for_node(
>  	struct se_dev_entry *deve;
> =20
>  	mutex_lock(&nacl->lun_entry_mutex);
> -	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link)
> +	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link,
> +				 lockdep_is_held(&nacl->lun_entry_mutex))
>  		core_disable_device_list_for_node(deve->se_lun, deve, nacl, tpg);

[Severity: High]
This isn't a bug introduced by this patch, but does this loop contain a
potential use-after-free when advancing the iterator?

Inside the loop, core_disable_device_list_for_node() removes the current
element from the list and queues it for deferred freeing:

core_disable_device_list_for_node() {
	...
	hlist_del_rcu(&orig->link);
	...
	call_rcu(&orig->rcu_head, target_free_dev_entry);
	...
}

Because the traversal is protected only by lun_entry_mutex and not by
rcu_read_lock(), the thread is fully preemptible. If preemption occurs
after call_rcu() returns but before the iterator macro evaluates
deve->link.next to advance to the next element, a full RCU grace period
can expire.

This would allow the RCU callback to execute and free the current element,
causing a use-after-free when the thread resumes and dereferences the
freed memory's next pointer.

[ ... ]

> @@ -483,7 +484,8 @@ void core_clear_lun_from_tpg(struct se_lun *lun, stru=
ct se_portal_group *tpg)
>  	list_for_each_entry(nacl, &tpg->acl_node_list, acl_list) {
> =20
>  		mutex_lock(&nacl->lun_entry_mutex);
> -		hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
> +		hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link,
> +					 lockdep_is_held(&nacl->lun_entry_mutex)) {
>  			if (lun !=3D deve->se_lun)
>  				continue;
> =20
>  			core_disable_device_list_for_node(lun, deve, nacl, tpg);

[Severity: High]
This is a pre-existing issue, but does this traversal have the same potenti=
al
use-after-free as above?

It calls core_disable_device_list_for_node() which queues the element for
freeing via call_rcu() while we are not in an RCU read-side critical sectio=
n,
meaning the memory could be freed before we read the next pointer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625113807.5747=
88-1-runyu.xiao@seu.edu.cn?part=3D1
