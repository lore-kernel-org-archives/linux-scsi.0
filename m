Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D95F3A1A23
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 21:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785880346; cv=none; b=Y1IKx3oWiij7ttB7SB5zfsBjk8/Jkc/g6SFJXO/RRW1Hy+RScWF0cQPbzBb7Vywx2xfloRRCrikqkrsgOu7l84AwaF9l6vfjqDUQxY70Vax867r6rZpXfwuyVXgR6L5h+vybZTmxvon9VWdf11XuWWD8k4KKsbglpiCHp7Ucx6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785880346; c=relaxed/simple;
	bh=Nlviqz3sjNjTddmKWLCznbQzvVWzTowfAGJuJlDMrv4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rPPmmTXrj1I365EY3rG6tg5vzWFsPk+6noHzRYFtqBW7oTuywj+rxeLjPwt2MRso74x6vzCOwBWU3f3F9pDj8+fqPh+jK+CCU3T69wlW/2WZkAedfdwZ6ZnGlvgk71Vz9huUO4KNqNpYWvovKuzUkpgaG0jRzrddjky0DLxWLrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nm3vYPgr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nm3vYPgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31921F000E9;
	Tue,  4 Aug 2026 21:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785880345;
	bh=2IGr6RibtGUJUzQaxNSP07MDF20iprowsxuUTJ79ofE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nm3vYPgrkepVEHqrngxf6pvX8+3JeossD+lDjhSlg8WVdsWQGC9riOmaJ1xAahkWy
	 NorpR2lWis5onAX2CMS3B0hQZrCqjB+d3RWWMsBByrjUfZcaA8WKTeqj9mc5tjjHS3
	 rICcPkx2l35CI50ZPd1e789M1D3+8EkF5pv2R0lWKLZ5Frx6Lfe9FD/IcOxzISDK3F
	 N7MZ6wch+1iaaA25Qf8nM7nKPkZM2yxBvjAN2v4Em/Q+j5rT1+0BsGI/Q0LPE8J8FY
	 tdLNQLBq/bjS6E6I80Qhm5sxgDcQTqm3c98P5M30oy8HRni9aAorTB2S/4/RCZzTFk
	 zqHfHYEetZDtQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: tcm_fc: use kref_get_unless_zero() in
 ft_sess_get()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yifei Gao" <gyf161023@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260804213703.3411166-1-gyf161023@gmail.com>
References: <20260804213703.3411166-1-gyf161023@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 04 Aug 2026 21:52:24 +0000
Message-Id: <20260804215224.D31921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-after-free in ft_sess_delete_all() due to unsafe RCU list iter=
ation while blocking
--

--- Patch [1]: [PATCH] scsi: target: tcm_fc: use kref_get_unless_zero() in =
ft_sess_get() ---
commit 7c29402c5a3237eba08c6ba5beba9b0842deb5e7
Author: Yifei Gao <gyf161023@gmail.com>

scsi: target: tcm_fc: use kref_get_unless_zero() in ft_sess_get()

ft_sess_get() walks the RCU-protected session hash under rcu_read_lock()
and takes a plain kref_get() on a matching session. Session teardown does
hlist_del_rcu() and then drops ft_lport_lock before the final
ft_sess_put() -> kfree_rcu(). A reader that is preempted between the
port_id comparison and the kref_get() can therefore revive a session whose
refcount has already dropped to zero and is pending free, leading to a
use-after-free and a double target_remove_session().

> diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc=
_sess.c
> index 797be06ab71b8..1bc7d2dcbea36 100644
> --- a/drivers/target/tcm_fc/tfc_sess.c
> +++ b/drivers/target/tcm_fc/tfc_sess.c
> @@ -172,7 +172,8 @@ static struct ft_sess *ft_sess_get(struct fc_lport *l=
port, u32 port_id)
>  	head =3D &tport->hash[ft_sess_hash(port_id)];
>  	hlist_for_each_entry_rcu(sess, head, hash) {
>  		if (sess->port_id =3D=3D port_id) {
> -			kref_get(&sess->kref);
> +			if (!kref_get_unless_zero(&sess->kref))
> +				break;
>  			rcu_read_unlock();
>  			TFC_SESS_DBG(lport, "port_id %x found %p\n",
>  				     port_id, sess);

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing the use of
RCU list iteration in this file, I noticed a pre-existing issue in
ft_sess_delete_all().

During port teardown, the code iterates over the session hash table:

drivers/target/tcm_fc/tfc_sess.c:ft_sess_delete_all() {
    ...
		hlist_for_each_entry_rcu(sess, head, hash) {
			ft_sess_unhash(sess);
			ft_close_sess(sess);	/* release from table */
		}
    ...
}

The iteration uses hlist_for_each_entry_rcu(), but ft_close_sess() calls
target_wait_for_sess_cmds() which blocks, and then drops the final table
reference triggering kfree_rcu(sess).

Because the thread sleeps, an RCU grace period can easily expire before the
loop macro evaluates the next element (sess->hash.next), resulting in a read
of freed memory.

Does this loop need to use a safe iterator that doesn't rely on RCU
while blocking, or restart the iteration after closing a session?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260804213703.3411=
166-1-gyf161023@gmail.com?part=3D1
