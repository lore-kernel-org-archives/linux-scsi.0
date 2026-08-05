Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD223A4F51
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 01:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785894755; cv=none; b=EXN2ms3XulJJ9QPu1gFEJQKgUYY6yfm1rTDC2SUbfho5xwPHgy+oTQpyrBTVP40a2e3hob8//rp+UTf8kKOJv3jXVcRzjlLVigJoKTj+s7Ug8wBu+9cvi4E196qlVB7WAgdO6Mw+OoAyz7M2z17QkbB0ins9AMSnmfdQdhioyWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785894755; c=relaxed/simple;
	bh=3rtNBVHc5IJbFQXRXUbrSJdftsZ3uzPtpNsmTIfOM8Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ayMecxV/wmEZQqEGY9cC/nKcmXqoSmmGumKyDlqfX3ZoawMsDLhPnfEphgYFVsls02Q8sHhN4rtgcuObdy26UuBbEEgpGEiMYTts/jwwY0d6mEgqDDGXm1Swotf4Yy+NTF2msOhl7Zey2UKwok/mGDQAg0AHEGajqsajRGjGXpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nq7s7hx9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nq7s7hx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3BD1F000E9;
	Wed,  5 Aug 2026 01:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785894744;
	bh=l/j4H5SgbU4KckbI83gCGoQLtNnVoqtKCgUKdzlQrGU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nq7s7hx9kDFY1FdUPa/Q0oAgkThY9Ic0BfFIT5jIfEvHOG3hlYkAs3btkvrMxD/wG
	 x1/DIr8/67/4FOZaQEpiyRyEX4pw1zrXaSBjav9DncqfTlAbB4DCuzbiePq4JHcLuo
	 RjbNK0Nj8WQj944acah1xJgH1doW4XXyJOLjxu52jZckbxkmAm1Hpnq8luEpE8WWdG
	 Fi3imjJBDCKVRC+xcLitKhag+KQBYVyd3i0EFBINI5GhwHdskS4o3GkxxGsMYB9uWE
	 2A59sc6xJeV0U2gfUaIhBwyPTTwtRjNn5erL8SpFwUAWRxfQ2Jtmiz3XtPbMnfcGDr
	 cNr7cma2BDHmg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: cxgbi: fix retry_timer use-after-free on adapter
 detach
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fan Wu" <fanwu01@zju.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260805013209.418861-1-fanwu01@zju.edu.cn>
References: <20260805013209.418861-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 05 Aug 2026 01:52:23 +0000
Message-Id: <20260805015224.BE3BD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Sockets in CTP_ACTIVE_OPEN state permanently leak ATID resources a=
nd memory on adapter detach.
- [High] Non-synchronous timer_delete() followed by socket destruction lead=
s to a Use-After-Free.
- [High] Missing state check in the retry timer callbacks sends duplicate o=
pen requests, destroying established connections.
--

--- Patch [1]: [PATCH] scsi: cxgbi: fix retry_timer use-after-free on adapt=
er detach ---
commit a8e38255da09728f75742d7fed123ba4827cbc81
Author: Fan Wu <fanwu01@zju.edu.cn>

scsi: cxgbi: fix retry_timer use-after-free on adapter detach

This commit fixes a use-after-free on adapter detach by setting the
CTPF_OFFLOAD_DOWN flag under the socket lock and using timer_delete_sync()
to drain pending callbacks. It also updates the timer callbacks and reply
handlers to check this flag before proceeding.

> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb=
3i/cxgb3i.c
> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> @@ -556,6 +556,11 @@ static void act_open_retry_timer(struct timer_list *=
t)
> =20
>  	cxgbi_sock_get(csk);
>  	spin_lock_bh(&csk->lock);
> +	if (cxgbi_sock_flag(csk, CTPF_OFFLOAD_DOWN)) {
> +		spin_unlock_bh(&csk->lock);
> +		cxgbi_sock_put(csk);
> +		return;
> +	}

[Severity: High]
This is a pre-existing issue, but does this callback send duplicate open
requests that can destroy established connections?

The callback unconditionally sends an open request without verifying if
csk->state is still CTP_ACTIVE_OPEN. If the timer callback executes
immediately after do_act_establish() transitions the socket to
CTP_ESTABLISHED and drops the lock, the callback will acquire the lock
and blindly send a duplicate CPL_ACT_OPEN_REQ.

The hardware will reject this with CPL_ERR_CONN_EXIST, which causes
do_act_open_rpl() to forcibly tear down the valid connection.

[Severity: High]
This is also a pre-existing issue, but can the non-synchronous timer
cancellation in do_act_establish() lead to a use-after-free?

In do_act_establish(), the timer is canceled non-synchronously:

do_act_establish() {
        ...
        if (csk->retry_timer.function) {
                timer_delete(&csk->retry_timer);
                csk->retry_timer.function =3D NULL;
        }
        ...
}

If the timer callback is queued on another CPU, it can execute after
the socket drops its lock. If the new connection is rapidly aborted
(e.g., by receiving CPL_ABORT_REQ_RSS), the socket teardown path releases
all references and frees the socket memory.

When the delayed timer callback eventually runs, it will call
cxgbi_sock_get(csk) on freed memory.

[ ... ]

> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -109,6 +109,7 @@ void cxgbi_device_portmap_cleanup(struct cxgbi_device=
 *cdev)
>  			cxgbi_sock_set_flag(csk, CTPF_OFFLOAD_DOWN);
>  			cxgbi_sock_closed(csk);
>  			spin_unlock_bh(&csk->lock);
> +			timer_delete_sync(&csk->retry_timer);
>  			cxgbi_sock_put(csk);

[Severity: High]
This is a pre-existing issue, but does this leak ATID resources and socket
memory for sockets in the CTP_ACTIVE_OPEN state?

Looking at cxgbi_sock_closed(), it returns early for ACTIVE_OPEN sockets:

cxgbi_sock_closed() {
        ...
        if (csk->state =3D=3D CTP_ACTIVE_OPEN || csk->state =3D=3D CTP_CLOS=
ED)
                return;
}

This early return bypasses csk_release_offload_resources(). If an adapter
is detached while an active-open connection is pending, the timer callbacks
now immediately return upon seeing CTPF_OFFLOAD_DOWN without advancing
the state or failing the connection.

Without further hardware replies to fail the connection, the socket remains
indefinitely trapped in CTP_ACTIVE_OPEN, leaking the ATID and socket memory.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260805013209.4188=
61-1-fanwu01@zju.edu.cn?part=3D1
