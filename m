Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B453E3DA8
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 07:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785914723; cv=none; b=LPUO0lpf4E2MvlFXAQpbuHy/SZxkn2aG/dY6EIAmkoh+/HinBoo3bOkIsBkRmgLMRLrnr9q4lkyOE0zhV40rO1xQTChNlpwZQBEykNaX8N42U6OemwmTYMBx1soaVbTYIktqW40qGnLrnvPZ+dTBbXTh4VE/m9cv5pFarfxRkKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785914723; c=relaxed/simple;
	bh=G8JXc3R4nR9vcWh1ltSLvpwRyKldY/oZ5Nu5ZlcAesc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Vwdbdl0rhN2V0zGZd9x2reEuMLNyA0PMk+ijkeezoa5JbETPY6e6cBy53SocS/Ai9nAYMZr7tF4ggfyheoyzbW1qLt1duWoLt+q/rZFA7hYSsTEbeANaqXEVZGJUB/vObd998xTb4HVyjfpZUcD4eB4C3B12QLgfYKnyeEH0ksw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuCzR1t/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuCzR1t/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0612F1F000E9;
	Wed,  5 Aug 2026 07:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785914721;
	bh=u2r7V1O7cdZOn4r+0Jq5Tztd+TsVzflpZDqHSVxTsMw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NuCzR1t/HmgmQG858sc/D2ru9md9nZFpTobFkTwQKz0Zb4qU4mq9SZF7bkFij4X6v
	 LTZBOCtXugp1YK/F8ubjOsV1oF2/HHAEDMQhQqMShb1OQKszTzq9K6nzNa1B+0nEwc
	 m5uot8KdZDNTnq1jDpm7f1Bfghj79xeq9ohBmbTXdUybu0LN/a+QbJ48iAF7kkwIW/
	 QV7SgaABQrOdSwkuZzXn4nHwRYf/msX5d9OQDVXB1jnJB9G3BQde/NxO0+6hJ5K8tp
	 bR4oT0b1l8anaYFepDiTQvaw9iHWHPBml0suTH8Mxv8Fpsbe3yZiN3Tykg3e/ayMr9
	 GIUhiu6xADspQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: iscsi_tcp: Fix null-pointer dereference in
 iscsi_sw_tcp_conn_restore_callbacks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Liang" <ljykernel@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260805065326.1952-1-ljykernel@gmail.com>
References: <20260805065326.1952-1-ljykernel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 05 Aug 2026 07:25:20 +0000
Message-Id: <20260805072521.0612F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The newly added NULL pointer check introduces a Time-Of-Check to T=
ime-Of-Use (TOCTOU) vulnerability that fails to completely prevent the NULL=
 pointer dereference.

Pre-existing issues:
- [Critical] The patch fails to address the root cause of the race conditio=
n, leaving a severe double free / file refcount underflow and use-after-fre=
e vulnerability.
--

--- Patch [1]: [PATCH] scsi: iscsi_tcp: Fix null-pointer dereference in isc=
si_sw_tcp_conn_restore_callbacks ---
commit a6e54310fce25391e4b63d84129f6076f40ca758
Author: Jiayuan Liang <ljykernel@gmail.com>

scsi: iscsi_tcp: Fix null-pointer dereference in iscsi_sw_tcp_conn_restore_=
callbacks

The commit message states this fixes a null pointer dereference in
iscsi_sw_tcp_conn_restore_callbacks caused by a race condition leading to
concurrent invocations of iscsi_sw_tcp_release_conn. The patch adds a null
check for the socket pointer before accessing its internal fields.

> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 9260b1c9b0e05..0eabb8b59f46d 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -265,8 +265,12 @@ iscsi_sw_tcp_conn_restore_callbacks(struct iscsi_con=
n *conn)
>  {
>  	struct iscsi_tcp_conn *tcp_conn =3D conn->dd_data;
>  	struct iscsi_sw_tcp_conn *tcp_sw_conn =3D tcp_conn->dd_data;
> -	struct sock *sk =3D tcp_sw_conn->sock->sk;
> +	struct sock *sk;
> =20
> +	if (!tcp_sw_conn->sock)
> +		return;
> +
> +	sk =3D tcp_sw_conn->sock->sk;

[Severity: High]
Does this new check fully prevent the null pointer dereference?

Because the check and the subsequent read are lockless and not protected
by READ_ONCE(), the compiler could fetch the tcp_sw_conn->sock pointer
twice.=20

If another thread sets tcp_sw_conn->sock to null under sock_lock right after
the check, could the second fetch result in dereferencing null here?

[Severity: Critical]
This is a pre-existing issue, but does this patch fully address the root
cause of the race condition?

If two threads concurrently execute iscsi_sw_tcp_release_conn, they both
read tcp_sw_conn->sock into a local variable:

iscsi_sw_tcp_release_conn() {
	...
	struct socket *sock =3D tcp_sw_conn->sock;

	if (!sock)
		return;
	...

Since both threads can read the non-null pointer before either thread takes
the sock_lock to set it to null, both will bypass this check.

Later in the same function, both threads will call:

	...
	mutex_lock(&tcp_sw_conn->sock_lock);
	tcp_sw_conn->sock =3D NULL;
	mutex_unlock(&tcp_sw_conn->sock_lock);
	sockfd_put(sock);
}

Will this cause a double free of the socket file refcount, since both
concurrent threads call sockfd_put on the same locally cached sock pointer?

Similarly, in iscsi_sw_tcp_conn_stop, both threads might use the locally
cached sock pointer after it has already been released by the first thread:

iscsi_sw_tcp_conn_stop() {
	...
	struct socket *sock =3D tcp_sw_conn->sock;

	if (!sock)
		return;

	sock->sk->sk_err =3D EIO;
	...

If one thread finishes iscsi_sw_tcp_release_conn first, will the second
thread dereference a freed socket here?

>  	/* restore socket callbacks, see also: iscsi_sw_tcp_conn_set_callbacks(=
) */
>  	write_lock_bh(&sk->sk_callback_lock);
>  	sk->sk_user_data    =3D NULL;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260805065326.1952=
-1-ljykernel@gmail.com?part=3D1
