Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8124305691
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 21:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785880209; cv=none; b=tzSPy+sEkS4PGNo13B73OQU+TDCXIHIKRY03NJcyQJMqXvQGQYkF2R9zknMsN9G9TEDEPSQpMVGa/MF2j7Fg9RbAHvZoL1HeqnVPI5+6GBhUWMZRX9ZXDtyEuPrnKnJARPDuKeV8HCe4dwq31rSgHx+F3fFL7tL8TZCGdRDwHGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785880209; c=relaxed/simple;
	bh=3X8t0fTieamARQiSPg8tpNSrMW09+S+cbI0vjDceBhY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jv6dmm6J/ZT4xCiJC1oXXMiHwgoZIoY78loog0P99lKhPPSLlbr5GNF6gplJTKt/KVP9GYLjsrN/c2X4MA5DMt0u+U6jlL+YAhc+O/QD72SiHqHlE5oYgWVZgzOEH4Volt+909bY5o43tDGkbh1kfunl30T6cIn5QgEkzoZqZAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QQVSyl17; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QQVSyl17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1381F000E9;
	Tue,  4 Aug 2026 21:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785880208;
	bh=pwgdBZh9XMrxK11uxstMwni4hKuWF52YF8TgSKOczC8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QQVSyl17KV0T3x8//wdox9+J/HoFqiz6p2VBJQH8bwT3yQ260nEwHzRlmAZC9KpHQ
	 3XKh+KMKgxDGnJpR5jdm/FUmJyMeD+E6jRsjvBYoToahSzSHC1YZksn9GTVUtvmY8X
	 /Bbctu5lEbR2U0yMx6q+LMKHAtwzWH5HMKJN13CeML1VG/CVOD54JH/aCMMK9OZAv+
	 8i+JHhcraTBfBgZ8rzhZ7evBy8mjG4EyVbj5akVXPvnBYmtyeJOPSToVZ9MDcJHBLW
	 wmJMY4PnvH6OjWUa+tt21P1LA7uaaPfDbfQVevtYI5OXjgOSLyecJLLPEU+iN36Iq4
	 FBlA89adkqInA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: use kref_get_unless_zero() in
 core_get_se_deve_from_rtpi()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yifei Gao" <gyf161023@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260804213726.3411698-1-gyf161023@gmail.com>
References: <20260804213726.3411698-1-gyf161023@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 04 Aug 2026 21:50:07 +0000
Message-Id: <20260804215008.2F1381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch addresses a kref revival race in `core_get_se_deve_from_=
rtpi()`, but identically flawed `kref_get()` patterns remain in `__core_scs=
i3_do_alloc_registration()` and `core_scsi3_check_aptpl_registration()`.
- [High] Fetching `tfc_sess` under RCU using a plain `kref_get()` in `ft_se=
ss_get()` can revive a 0-refcount object, leading to a double free.
--

--- Patch [1]: [PATCH] scsi: target: use kref_get_unless_zero() in core_get=
_se_deve_from_rtpi() ---
commit 1ccb09531fbaa5b4a4d4c2e984295bc9d5b45e8e
Author: Yifei Gao <gyf161023@gmail.com>

scsi: target: use kref_get_unless_zero() in core_get_se_deve_from_rtpi()

This commit fixes a use-after-free vulnerability in core_get_se_deve_from_r=
tpi().
It replaces a plain kref_get() with kref_get_unless_zero() when acquiring a
reference to se_dev_entry under RCU. This prevents the revival of a 0-refco=
unt
object during a concurrent teardown.

> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_=
core_device.c
> index 9db2201aa553f..bff97c6efffbe 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -220,7 +220,8 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
>  		if (lun->lun_tpg->tpg_rtpi !=3D rtpi)
>  			continue;
> =20
> -		kref_get(&deve->pr_kref);
> +		if (!kref_get_unless_zero(&deve->pr_kref))
> +			continue;

[Severity: High]
This isn't a bug introduced by this patch, but since this addresses a kref=
=20
revival race, could the same flaw exist in other places doing lockless RCU
lookups of se_dev_entry?

For example, drivers/target/target_core_pr.c:__core_scsi3_do_alloc_registra=
tion()
does:

		kref_get(&pr_reg->pr_reg_deve->pr_kref);
		rcu_read_unlock();

And similarly in drivers/target/target_core_pr.c:core_scsi3_check_aptpl_reg=
istration():

			kref_get(&pr_reg->pr_reg_deve->pr_kref);
			rcu_read_unlock();

If a concurrent disable path unhashes the entry and drops its final referen=
ce,
could a delayed reader executing the plain kref_get() resurrect the dying
object and cause a use-after-free when the disable path proceeds to free it
via call_rcu()?

[Severity: High]
This is another pre-existing issue, but while looking at plain kref_get()
usage under RCU, could a similar double-free issue occur in
drivers/target/tcm_fc/tfc_sess.c:ft_sess_get()?

			kref_get(&sess->kref);
			rcu_read_unlock();

If a teardown path (like handling a PRLO) calls ft_sess_delete() to unhash
the session and drops the final reference concurrently, could a reader
executing this plain kref_get() resurrect the session?

When the reader later drops its reference, would this lead to=20
target_remove_session() and kfree_rcu() executing a second time?

>  		rcu_read_unlock();
> =20
>  		return deve;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260804213726.3411=
698-1-gyf161023@gmail.com?part=3D1
