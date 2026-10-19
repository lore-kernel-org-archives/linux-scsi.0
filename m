Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7E336605E;
	Mon, 19 Oct 2026 03:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792381869; cv=none; b=bqveGTlzx40P86kY92ht/wzfk4xka/KfqVsgWeIooUGgqbX5bNLfM10C1+Ce5oV2pp5WwnwM+sl7VoXKXp2bRmLppTegn8UiRF98Ftmzdi31unqzJPoHS6DHP5w3xb7lOzYWHQdeKLWPWcu8aBdG9UiExLEh2Hejh6vZfYyXVKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792381869; c=relaxed/simple;
	bh=bA4e+DBBTLdQVunT4VJf7yi+EcGyyX+aWXluy6Y7Fh4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=EEz5NMuobFibSAtRM/pVEXAKtCS5YIblgd6abZgFn2uFLaQ8NfW6LoTnUEXg16SB1UV3N7mqrLIXx9F97LQaQJEDZ9nN1gLdxqRpqIEkKtvj4omqFWkmmvZMwHu9TPq5gM6kOYuZKZ0Xb2CXOGo89eQg8e1jyI6hbmgUg7TCew8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8xWPCU0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8xWPCU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63AA1F000C4;
	Mon, 19 Oct 2026 03:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792381868;
	bh=s1XJHepx4EvZc1XM+wIkUKjHSBQJ/6xezu32sQYdvNs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W8xWPCU0NJUGFJ8xxZ31uUcHbiN0xG72Xj+t6OVtEmKq5EtOTj5Klrp2bcBcoz+ef
	 ZKvY3MkM4ljTg0u3LATHcPRfLkJCPYxb/n8mUgyHiX165ZbT2x4AiTD8niKzHZP9T4
	 voLxPFDFNu6HLKvBZueL5aYFagZ0Pc36vZkopI4LzpfgTEOX48tbS2boi9SbqlMupR
	 KFrzb//UsfpS6dZcKy2zrW3XDuFmVgvmHy91tEpJRDlm1jOgicL3I8Mr/NzwU5Yjvo
	 knoW1orkQ16zosqmnR0RCsmB0cqryWjpfbVP5E8cHZ8lyN4B/LBE1DM+ETlpBmJ4Al
	 HZoHQw9SAD7rA==
Message-ID: <sashiko-outbox-176590@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: fix list corruption in
 core_alua_free_tg_pt_gp()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Zhang" <yuz08559@gmail.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261019033532.73575-1-yuz08559@gmail.com>
References: <20261019033532.73575-1-yuz08559@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 03:51:07 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] scsi: target: list corruption on next LUN in core_alua_free_tg=
_pt_gp()
- [Critical] scsi: target: use-after-free of se_lun in core_alua_free_tg_pt=
_gp()
--

commit 9207913678d53d80f463a158ebf713e95fda2ea5
Author: Yu Zhang <yuz08559@gmail.com>

scsi: target: fix list corruption in core_alua_free_tg_pt_gp()

This commit attempts to fix a list corruption race in
core_alua_free_tg_pt_gp() by re-checking under lun->lun_tg_pt_gp_lock
whether lun->lun_tg_pt_gp still points to the group being freed before
reattaching the LUN to the default group.

> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_co=
re_alua.c
> index 140154d93c430..24fafcb2809fa 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -1755,16 +1755,23 @@ void core_alua_free_tg_pt_gp(
> =20
>  		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
>  		/*
> -		 * If the passed tg_pt_gp does NOT match the default_tg_pt_gp,
> -		 * assume we want to re-associate a given tg_pt_gp_mem with
> -		 * default_tg_pt_gp.
> +		 * tg_pt_gp_lock was dropped above, so a concurrent
> +		 * core_alua_store_tg_pt_gp_info() may already have moved this
> +		 * lun to another group and re-added lun_tg_pt_gp_link to that
> +		 * group's list.  Reattach to the default group only while the
> +		 * lun still references the group being freed; otherwise the
> +		 * bare list_add_tail() in __target_attach_tg_pt_gp() would add
> +		 * the already-linked node a second time and corrupt the list.
>  		 */
>  		spin_lock(&lun->lun_tg_pt_gp_lock);

[Severity: Critical]
Could this trigger a use-after-free on lun when tg_pt_gp->tg_pt_gp_lock is
dropped?

In drivers/target/target_core_alua.c:core_alua_free_tg_pt_gp(), the loop
unlinks lun from tg_pt_gp_lun_list and drops tg_pt_gp->tg_pt_gp_lock
without holding rcu_read_lock() or pinning lun->lun_ref (unlike
core_alua_queue_state_change_ua(), which pins lun via
percpu_ref_tryget_live(&lun->lun_ref) before dropping tg_pt_gp_lock).

While tg_pt_gp->tg_pt_gp_lock is dropped, a concurrent configfs unlink of
the port symlink and rmdir of the LUN directory can detach and free lun
before core_alua_free_tg_pt_gp() reaches spin_lock(&lun->lun_tg_pt_gp_lock):

  configfs_unlink()
    target_fabric_port_unlink()
      core_dev_del_lun()
        core_tpg_remove_lun()
          transport_clear_lun_ref(lun)
          target_detach_tg_pt_gp(lun)
  configfs_rmdir()
    target_fabric_drop_lun()
      target_fabric_port_release()
        call_rcu(&lun->rcu_head, target_tpg_free_lun)
          target_tpg_free_lun()
            kfree(lun)

When core_alua_free_tg_pt_gp() resumes, wouldn't spin_lock(&lun->lun_tg_pt_=
gp_lock)
and rcu_dereference_check(lun->lun_tg_pt_gp, ...) dereference freed
struct se_lun memory?

> -		if (tg_pt_gp !=3D dev->t10_alua.default_tg_pt_gp) {
> -			__target_attach_tg_pt_gp(lun,
> -					dev->t10_alua.default_tg_pt_gp);
> -		} else
> -			rcu_assign_pointer(lun->lun_tg_pt_gp, NULL);
> +		if (rcu_dereference_check(lun->lun_tg_pt_gp,
> +				lockdep_is_held(&lun->lun_tg_pt_gp_lock)) =3D=3D tg_pt_gp) {
> +			if (tg_pt_gp !=3D dev->t10_alua.default_tg_pt_gp)
> +				__target_attach_tg_pt_gp(lun,
> +						dev->t10_alua.default_tg_pt_gp);
> +			else
> +				rcu_assign_pointer(lun->lun_tg_pt_gp, NULL);
> +		}
>  		spin_unlock(&lun->lun_tg_pt_gp_lock);
> =20
>  		spin_lock(&tg_pt_gp->tg_pt_gp_lock);

[Severity: Critical]
What happens to the pre-fetched next pointer in list_for_each_entry_safe()
when tg_pt_gp->tg_pt_gp_lock is dropped across this window?

In drivers/target/target_core_alua.c:core_alua_free_tg_pt_gp():

	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
	list_for_each_entry_safe(lun, next,
			&tg_pt_gp->tg_pt_gp_lun_list, lun_tg_pt_gp_link) {
		list_del_init(&lun->lun_tg_pt_gp_link);
		tg_pt_gp->tg_pt_gp_members--;

		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);

If tg_pt_gp_lun_list has two LUNs (lun1 and lun2), iteration 1 sets
lun =3D lun1, caches next =3D lun2, and drops tg_pt_gp->tg_pt_gp_lock.

While that lock is dropped, a concurrent core_alua_store_tg_pt_gp_info()
on lun2 can acquire lun2->lun_tg_pt_gp_lock and call
target_swap_tg_pt_gp(lun2, tg_pt_gp, tg_pt_gp_new), which moves
lun2->lun_tg_pt_gp_link into tg_pt_gp_new->tg_pt_gp_lun_list and sets
lun2->lun_tg_pt_gp =3D tg_pt_gp_new.

When core_alua_free_tg_pt_gp() reacquires tg_pt_gp->tg_pt_gp_lock and
advances to iteration 2 with the stale next (lun2):

1. list_for_each_entry_safe() sets next =3D list_next_entry(lun2, lun_tg_pt=
_gp_link),
   which now points into tg_pt_gp_new->tg_pt_gp_lun_list.
2. The loop body runs list_del_init(&lun2->lun_tg_pt_gp_link) and
   tg_pt_gp->tg_pt_gp_members-- without holding tg_pt_gp_new->tg_pt_gp_lock,
   corrupting tg_pt_gp_new->tg_pt_gp_lun_list.
3. Under lun2->lun_tg_pt_gp_lock, lun2->lun_tg_pt_gp =3D=3D tg_pt_gp is fal=
se,
   so reattachment is skipped and lun2 is left unlinked while
   lun2->lun_tg_pt_gp still points to tg_pt_gp_new.
4. Subsequent iterations walk tg_pt_gp_new->tg_pt_gp_lun_list; because
   &tg_pt_gp_new->tg_pt_gp_lun_list !=3D &tg_pt_gp->tg_pt_gp_lun_list, the
   loop does not terminate at tg_pt_gp_new's list head and treats
   container_of(&tg_pt_gp_new->tg_pt_gp_lun_list, struct se_lun, lun_tg_pt_=
gp_link)
   as a struct se_lun.

Similarly, if lun2 is concurrently detached via target_detach_tg_pt_gp(lun2)
while tg_pt_gp->tg_pt_gp_lock is dropped for lun1, list_del_init() points
lun2->lun_tg_pt_gp_link at itself, causing list_for_each_entry_safe() to
spin on lun2 indefinitely.

In addition, even with a single LUN, because list_del_init(&lun->lun_tg_pt_=
gp_link)
and tg_pt_gp->tg_pt_gp_members-- run before dropping tg_pt_gp->tg_pt_gp_lock
while lun->lun_tg_pt_gp still points to tg_pt_gp, won't a concurrent
core_alua_store_tg_pt_gp_info() -> target_swap_tg_pt_gp() ->
__target_detach_tg_pt_gp() in that window still decrement
tg_pt_gp->tg_pt_gp_members a second time?

=E9=9C=B8

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019033532.7357=
5-1-yuz08559@gmail.com?part=3D1
