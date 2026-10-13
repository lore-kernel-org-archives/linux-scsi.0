Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7A227D786;
	Tue, 13 Oct 2026 12:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894612; cv=none; b=CiEwQl6HlQcOvH+TXbw65l+1w9ZarYAhTiD+KHi/SqotzRLPH8EQqOCJSdvjA6diRO3fsGi+ANF7IdYDpayC76Wd+gAleFj3VeLwu0mKOR9AqGSlv7rV/sUcnFlLJ34XR9ZL2p9QUcE0Pc8mJU+9xijeph0iaS1Xc12BR3BygNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894612; c=relaxed/simple;
	bh=3VHdSX9CFC5pbuHL1NK4NY19DJOav+fJ7o1JTCmjrxc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=CasM4dFEgTSUcg9c+Re1T6BgLv63YpKcISdhsyct7vvODnJS8/HXv5KnYdh3jNLrzeECj3D0BUWYu/8xvxLWtGU+J1XjfBu+pmnG7JiGVs93hWKvLPmq52aLQEnJVh15M7mHEriKrvQVMw2wUlv4JGjMp+07MRO3w2dJj6BvhHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obykmp7N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obykmp7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368A01F000FF;
	Tue, 13 Oct 2026 12:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791894611;
	bh=Kl5WJUbsR/YqzZwK0EGbYgzX++AkWzSQo7aydTnoxoc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=obykmp7NzZoasItnVQ3iD8DKgeJ1WY5iF8YitWaRLk7QhAGhH4Edwo3T7Hv1Oz+Aj
	 c1dCPqquLjTrS7jsjliCQbKKeIOVKdzywp4PhOjpw4QCPv/vFvr7sbMmBKN7kRhgbp
	 vZSu6tvjvhsQJXwcMswPs6vhQ3q+4THkuimEbjsuMNKiKbo5p6Ss7KfiM00Hrx3d/6
	 BpSyXWQHk/Yk5Y70nOY4F4zJqAvRfj5XHpwKlcRigXmHortZdP3mQAxdRFVD/oX6an
	 uXWYugZIbq0om+Yw8vf9wCAflKJDU+dfne48yytUspVj407GwJ3bZ0knIXBFxxAi4p
	 M2TXJB9K/advw==
Message-ID: <sashiko-outbox-169711@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: fix demo-mode dynamic ACL dev-entry UAF
 vs LUN teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Zhang" <yuz08559@gmail.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261013120528.37749-1-yuz08559@gmail.com>
References: <20261013120528.37749-1-yuz08559@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 12:30:10 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: target: TOCTOU race in core_enable_device_list_for_node caus=
es UAF
--

commit fe6f881325b9fa3f70c9e7a80a2d042d342f070d
Author: Yu Zhang <yuz08559@gmail.com>
scsi: target: fix demo-mode dynamic ACL dev-entry UAF vs LUN teardown

This commit addresses a use-after-free triggered by a race between a demo-m=
ode
login creating dynamic node acls and a concurrent lun teardown. It attempts=
 to
fix the issue by publishing the node acl before populating its dev entries,=
 and
refusing to attach new dev entries to a shutting down se_lun.

> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_=
core_device.c
> index 9db2201aa553f..5eef87aa3b674 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -349,6 +349,19 @@ int core_enable_device_list_for_node(
>  	new->attach_count++;
> =20
>  	mutex_lock(&nacl->lun_entry_mutex);
> +	/*
> +	 * Do not attach a new dev entry to an se_lun that is being torn down.
> +	 * lun_shutdown is set by core_tpg_remove_lun() before its
> +	 * core_clear_lun_from_tpg() sweep; checking it here under the same
> +	 * nacl->lun_entry_mutex the sweep takes guarantees that once the sweep
> +	 * has passed this ACL no dev entry can be left dangling on the
> +	 * se_lun->lun_deve_list that is about to be freed.
> +	 */
> +	if (lun->lun_shutdown) {
> +		mutex_unlock(&nacl->lun_entry_mutex);
> +		ret =3D -ENODEV;
> +		goto free_stats;
> +	}

[Severity: High]
Can a time-of-check to time-of-use race condition regression occur here?

Because the target_core_tpg.c portion of this patch publishes the dynamic
node acl before creating its dev entries, a concurrent lun teardown sweep c=
an
now observe the dev entry while it is being added in
core_enable_device_list_for_node().

If the teardown sweep sets lun->lun_shutdown =3D true right after we check =
it
here, the sweep can run and wait on nacl->lun_entry_mutex.

When core_enable_device_list_for_node() later drops that mutex:

drivers/target/target_core_device.c:core_enable_device_list_for_node() {
    ...
    hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
    mutex_unlock(&nacl->lun_entry_mutex);

    spin_lock(&lun->lun_deve_lock);
    list_add_tail(&new->lun_link, &lun->lun_deve_list);
    spin_unlock(&lun->lun_deve_lock);
    ...
}

The teardown sweep takes the mutex and calls
core_disable_device_list_for_node(), which performs:

    list_del(&orig->lun_link);

Because new->lun_link is merely INIT_LIST_HEAD'ed at this point, list_del()
silently succeeds and sets list poisoning rather than preventing the
concurrent thread from linking it.

Then, the original thread resumes, takes lun->lun_deve_lock, and calls
list_add_tail(&new->lun_link, &lun->lun_deve_list), overwriting the poison
and successfully linking the doomed entry.

When the rcu grace period expires, the entry is freed, leaving a dangling
pointer in lun->lun_deve_list. Iterating lun->lun_deve_list subsequently can
trigger a use-after-free.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013120528.3774=
9-1-yuz08559@gmail.com?part=3D1
