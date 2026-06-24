Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A653B9DB6
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 15:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313916; cv=none; b=B9azgkijr+3RXb6rbf3shZ2sHMGnDccYxz38bYuYxBreFSpoVfYUl09x/zrNzGk9qTceIcEpddJf7OExw+C2fsXnroIWXbhMPHIYAM9rayEvY6MR4BZPwyJhFo9vnX1e83D+iNtzT0eigniXPDA7NsTQ/8gy0JgvEqKYG6Q64Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313916; c=relaxed/simple;
	bh=rdOwH9L0YQd2AnnVp1t330ND0dmSo6/AgSVnNptXJAU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fvdutg5njpQMEFRcX1xp/K+2aymWEclxhu4BJIt6CZU7C92pxrQK2SEfg2DafUBlKXx6OEbDdRF2YK9N2d/wTapnst8rV0hIyZ/mIUFymIJSoEc1R9SNY0so8c1rxEr3OlgmLsrGsGJwc7h/ewy4WVwZdUCiATGAne4ga8C+xx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iH+TRYBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iH+TRYBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180C41F000E9;
	Wed, 24 Jun 2026 15:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313915;
	bh=oeWkysiGfbwJ+Z3nU08D2pg8MHwiKuHCwDnLzMmjp+Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iH+TRYBIU8b8sdOm1fNGMfP9PcHo1SISHvUzB69HFcU5+flgpzwq7rluoTmpaiKkO
	 KDnWfyF23OO8hvUn594nUZWTFeLxDdE2qPc5GkCXVInX19k5zPcrEIZNTeVxFlDuxo
	 rFBH4HbLt603ZyCerCawnYDGRclcUW6JFnOU25wgd9z0Em7AtRlrLR0vcCjYoiFJs9
	 ZniHOgXTkmyUzG2n5idn3T73TzzhHnQFb6bjFdqUEaSFUULMqEQH7lJD9jxluYK7v0
	 vDgz9V6PyszqGkT7/H/igV3Chm5QJ8oPHy9LGyHlB46jrvZbUrTgA0rXgczY1gWS2F
	 DCGraQjwLQpxw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: tcm_fc: annotate session hash traversals
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624145320.3429431-1-runyu.xiao@seu.edu.cn>
References: <20260624145320.3429431-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 15:11:54 +0000
Message-Id: <20260624151155.180C41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Unsafe RCU list traversal in `ft_sess_delete_all` causing Iter=
ator Use-After-Free.
- [Critical] `ft_sess_get` uses `kref_get` instead of `kref_get_unless_zero=
` during RCU list traversal, causing refcount corruption.
--

commit 3175abadc099d1a62c16806e23dfcc68463481a8
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

scsi: target: tcm_fc: annotate session hash traversals

This commit adds lockdep condition annotations to several RCU hlist
traversals in the TCM FC session hash to document the writer-side
protection under ft_lport_lock.

> diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc=
_sess.c
> index 797be06ab71b8..84a6f29a1b5f8 100644
> --- a/drivers/target/tcm_fc/tfc_sess.c
> +++ b/drivers/target/tcm_fc/tfc_sess.c

[ ... ]

> @@ -291,7 +293,8 @@ static void ft_sess_delete_all(struct ft_tport *tport)
> =20
>  	for (head =3D tport->hash;
>  	     head < &tport->hash[FT_SESS_HASH_SIZE]; head++) {
> -		hlist_for_each_entry_rcu(sess, head, hash) {
> +		hlist_for_each_entry_rcu(sess, head, hash,
> +					 lockdep_is_held(&ft_lport_lock)) {
>  			ft_sess_unhash(sess);
>  			ft_close_sess(sess);	/* release from table */
>  		}

[Severity: Critical]
This isn't a bug introduced by this patch, but is it safe to use the standa=
rd
hlist_for_each_entry_rcu macro here while the elements are being destroyed?

During ft_sess_delete_all(), the code unlinks the session and calls
ft_close_sess(). This drops the final reference and queues the object for R=
CU
freeing.=20

Because the iteration does not hold rcu_read_lock(), the thread can be
preempted after ft_close_sess() returns. If the RCU grace period expires
during this preemption, the session object is freed.

When the thread resumes, the iterator macro will evaluate the next pointer
using the freed object, resulting in a use-after-free:

    rcu_dereference_raw(hlist_next_rcu(&(sess)->hash))
   =20
Should this use a safe iteration mechanism such as a while loop checking
!hlist_empty(head) instead?


While looking at the session hash logic, I noticed another pre-existing
issue in the reader path:

drivers/target/tcm_fc/tfc_sess.c:ft_sess_get() {
        ...
        hlist_for_each_entry_rcu(sess, head, hash) {
                if (sess->port_id =3D=3D port_id) {
                        kref_get(&sess->kref);
                        rcu_read_unlock();
                        return sess;
                }
        }
        ...
}

[Severity: Critical]
This is a pre-existing issue, but does this kref_get() risk reviving a
session that has already dropped its reference count to zero?

If a remote port sends a data frame concurrently with a process logout
request, the reader thread in ft_sess_get() could find the target session
but get preempted before executing kref_get().

Concurrently, the writer thread handling the logout in ft_sess_delete()
removes the session from the list and drops the final kref to 0, queuing
it for freeing.

When the reader thread resumes, it unconditionally increments the zero-ref
kref, resulting in accessing an object queued for destruction.

Does the reader need to use kref_get_unless_zero() here and handle the
failure case appropriately?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624145320.3429=
431-1-runyu.xiao@seu.edu.cn?part=3D1
