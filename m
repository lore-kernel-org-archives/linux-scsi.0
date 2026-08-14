Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F45022D7A1
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 02:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786674787; cv=none; b=bZtXskVTmk1iXnt31JEG8u2KOrCl1vorlBA6L59EWQaXHBO7RSFvyCV6IzrhEt7oN/mJXjkEHuqKEjA7mosJVdR3/7mYiya/ACT8c5QaABWELnzaxGuPHsFtDBNSR8Gdxi3kx8qub9eBxskD+7p2y7qfExudZRBqA2NIVJnJ/6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786674787; c=relaxed/simple;
	bh=1WFhAJYEr6nyPh+gba1s10nLQnTmTMcgOSJtyw8na1w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DTleMtRVim3hQ/qpmdoWcqp2SuzMJFZWN+KCkYXXyk6AORqn7ujt8r+ir56wmEjjI9IlIGqlB0f6lvZvSaOZq7cY40WjZBZW+XvjJfV7nNtmO/kxJE/Z9jdDsu0GKBnJRdYF3XLs4SoMlhXo/QqDdL6NG9gUnTvk+IcU6fzSAR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ii0Wt5OO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ii0Wt5OO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDB31F000E9;
	Fri, 14 Aug 2026 02:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786674785;
	bh=v5jzldB1SONCBdmk3LM2ysU6zIB1yU1a8XshSDp0NkA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ii0Wt5OOAf0Q6uRWSGIK/pLFiXcF4jW1L8zUXj+DqVOph2MQs2yyFnLqiuhUInhuA
	 AWpV7JAERC75inAWoIGNYELWWtPPmr7dSPmMy4OIhZp+Y7IedhlDT0BeMqrI0bYWVf
	 4zYcZSW3+a6aaVEYLEb+PM2eMyzXU0zngrZpH5XGlWLs30KGS7XqubY6S9KnMfXyyg
	 7icW0A7k93DNyo5TL3VdhKSzY3JIqWhN4DD9Ol3TS4Qs6Cf7MSmNiH/LWDQKHKVdCj
	 Q0DodXNPLxWgRINz6tRZoN80c38gMpGUkqSkoEy11s/T77blG40Kr8ztUI70dHvzSX
	 0gdb7AaLnNn4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: cxgbi: fix retry_timer use-after-free on
 adapter detach
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fan Wu" <fanwu01@zju.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260814020948.197655-1-fanwu01@zju.edu.cn>
References: <20260814020948.197655-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 02:33:04 +0000
Message-Id: <20260814023304.DCDB31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Critical] Use-After-Free and Double Free for CTP_ACTIVE_OPEN connections=
 during adapter detach
- [Critical] Race Condition leading to NULL Pointer Dereference in do_act_o=
pen_rpl

Pre-existing issues:
- [High] Memory leak and un-cancelled timer on user-initiated disconnect
--

--- Patch [1]: [PATCH v2] scsi: cxgbi: fix retry_timer use-after-free on ad=
apter detach ---
commit 5cacab0f814551fa10e52ff589125571018e3cee
Author: Fan Wu <fanwu01@zju.edu.cn>

scsi: cxgbi: fix retry_timer use-after-free on adapter detach

This commit attempts to fix a use-after-free on the retry_timer by setting
a new flag CTPF_OFFLOAD_DOWN during portmap cleanup. It rejects new timer
arming and forces connections in CTP_ACTIVE_OPEN to be pushed through
cxgbi_sock_fail_act_open() to release resources.

> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb=
3i/cxgb3i.c
> index 0e2bee937fe81..207c8ffb5f188 100644
> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
[ ... ]
> @@ -584,7 +589,8 @@ static int do_act_open_rpl(struct t3cdev *tdev, struc=
t sk_buff *skb, void *ctx)
> =20
>  	cxgbi_sock_get(csk);
>  	spin_lock_bh(&csk->lock);
> -	if (rpl->status =3D=3D CPL_ERR_CONN_EXIST &&
> +	if (!cxgbi_sock_flag(csk, CTPF_OFFLOAD_DOWN) &&
> +	    rpl->status =3D=3D CPL_ERR_CONN_EXIST &&
>  	    csk->retry_timer.function !=3D act_open_retry_timer) {
>  		csk->retry_timer.function =3D act_open_retry_timer;
>  		mod_timer(&csk->retry_timer, jiffies + HZ / 2);

[Severity: Critical]
If CTPF_OFFLOAD_DOWN is set by a concurrent adapter detach, will this logic
fall through to the else branch and call cxgbi_sock_fail_act_open()?

When cxgbi_device_portmap_cleanup() already called cxgbi_sock_fail_act_open=
(),
csk->cdev gets cleared:

cxgbi_sock_closed()
   csk->cdev->csk_release_offload_resources(csk);=20

If do_act_open_rpl() then calls cxgbi_sock_fail_act_open() again, it will s=
et
the state to CTP_CONNECTING and call cxgbi_sock_closed().

Could this result in a NULL pointer dereference when cxgbi_sock_closed()
tries to access csk->cdev again?


> diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb=
4i/cxgb4i.c
> index 804806e1cbb4b..2e2a10117afcd 100644
> --- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> +++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
[ ... ]
> @@ -892,7 +898,8 @@ static void do_act_open_rpl(struct cxgbi_device *cdev=
, struct sk_buff *skb)
>  	cxgbi_sock_get(csk);
>  	spin_lock_bh(&csk->lock);
> =20
> -	if (status =3D=3D CPL_ERR_CONN_EXIST &&
> +	if (!cxgbi_sock_flag(csk, CTPF_OFFLOAD_DOWN) &&
> +	    status =3D=3D CPL_ERR_CONN_EXIST &&
>  	    csk->retry_timer.function !=3D csk_act_open_retry_timer) {
>  		csk->retry_timer.function =3D csk_act_open_retry_timer;
>  		mod_timer(&csk->retry_timer, jiffies + HZ / 2);

[Severity: Critical]
Is this susceptible to the same concurrent execution issue as cxgb3i above?

If do_act_open_rpl() executes concurrently with cxgbi_device_portmap_cleanu=
p()
and falls into the else branch, it seems we might trigger a redundant teard=
own
and hit a NULL pointer dereference on csk->cdev.


> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index f3bb7af4e984e..7b44d47c03946 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
[ ... ]
> @@ -99,8 +99,12 @@ void cxgbi_device_portmap_cleanup(struct cxgbi_device =
*cdev)
>  				csk, cdev);
>  			spin_lock_bh(&csk->lock);
>  			cxgbi_sock_set_flag(csk, CTPF_OFFLOAD_DOWN);
> -			cxgbi_sock_closed(csk);
> +			if (csk->state =3D=3D CTP_ACTIVE_OPEN)
> +				cxgbi_sock_fail_act_open(csk, -ENODEV);
> +			else
> +				cxgbi_sock_closed(csk);

[Severity: High]
This isn't a bug introduced by this patch, but does the primary user-initia=
ted
disconnect path also need to be fixed for active-open connections?

When the iSCSI daemon initiates a disconnect while the connection is still =
in
CTP_ACTIVE_OPEN, cxgbi_ep_disconnect() calls cxgbi_sock_closed():

cxgbi_ep_disconnect()
    if (likely(csk->state >=3D CTP_ESTABLISHED))
        need_active_close(csk);
    else
        cxgbi_sock_closed(csk);

Because the state is CTP_ACTIVE_OPEN, cxgbi_sock_closed() returns early
without doing anything:

cxgbi_sock_closed()
    if (csk->state =3D=3D CTP_ACTIVE_OPEN || csk->state =3D=3D CTP_CLOSED)
        return;

Does this leave the retry_timer armed and offload resources unreleased,
causing a memory leak and a background timer loop?

[Severity: Critical]
Could calling cxgbi_sock_fail_act_open() here drop too many references and
lead to a use-after-free?

cxgbi_sock_fail_act_open() sets the state to CTP_CONNECTING and calls
cxgbi_sock_closed(). Because the state is no longer CTP_ACTIVE_OPEN, it
bypasses the early return in cxgbi_sock_closed().

This causes cxgbi_sock_closed() to drop references for the port, the offload
resources, and call cxgbi_sock_put(csk).

If the iSCSI daemon already disconnected, the socket's refcount could reach
0 inside cxgbi_sock_closed(), freeing the memory.


>  			spin_unlock_bh(&csk->lock);
> +			timer_delete_sync(&csk->retry_timer);
>  			cxgbi_sock_put(csk);
>  		}
>  	}

[Severity: Critical]
Are we potentially accessing freed memory here?

If csk was already freed during the cxgbi_sock_fail_act_open() call above,
would spin_unlock_bh(), timer_delete_sync(), and cxgbi_sock_put() operate
on freed memory?

Also, doesn't cxgbi_sock_fail_act_open() steal the endpoint's reference by
bypassing the early return in cxgbi_sock_closed(), resulting in a double-fr=
ee
when this cxgbi_sock_put(csk) is called?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814020948.1976=
55-1-fanwu01@zju.edu.cn?part=3D1
