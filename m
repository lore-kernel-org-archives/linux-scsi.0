Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795279807;
	b=WvpUqEDhu5eU1QyWt6H7jWsM2/g6Kp14yyTIppNQZh30tpLH2Ed5URdYyimz84M3Yv/q
	 pUHDrMx2mALelMq3DMrpd0omW2oBMPEcICQDOE9skCwC+8gQYqdH1IFLrACIUz+6mMfrr
	 0Fa/h2JdsQ+kPVcMxfWEatey9wYSrwpr6p7z/daCsz6nv3hgziGCdJ6W0ud0VA3afBZqy
	 xRvrnqazJiDQw/8lu+hOTVIGtE99+U1SRZfL7AzJpAViCVgoYuxh4QfyTkSOotkwG8FLw
	 PGXTnwNNI4FJ82j46z4RqyFPW+wlvbABjoO+6uwibu6FLcogi5vPMrTiqRnLYJFx4pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795279807;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PPN6/wcfgdFlmbqddf2Y0+Se7zg2yRpwLtO4N7Y7rCs=;
	b=mWcAPhVBWFdtbEolzNXpQLW2Kw8EBKPP35IlYUKdXH5MD7mpz1zGHYIyYNkm83dsi7Do
	 5tfmDq/i0hhUEo0zct1Mpyyd2uSiMclXxeR0V6WOI3EpuJdOkJlW3qE2wZjwblAQ3vS7E
	 PXDdS0alqarVqMF1/g9WLkM5jfjR+qEBL6xM/Kherb8vji8Lj+ho+1/ltIn8mJd+Xi88N
	 DmpzOxW7Xq6baCS3iYPjGnc4U3WyRj3vS1FsHOT4/vumGeJHdxyhmn/0Tf5kvoRqigE2k
	 /ZAptNqu0JFzMD8vWV7bX6sQYdTFBKCsfKxI0TQ576V2oxJmQmpTeTEImFjYGcSVZpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g5oTRnHp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFC0606A336;
	Sat, 21 Nov 2026 16:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g5oTRnHp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C101F000D2;
	Sat, 21 Nov 2026 16:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795279806;
	bh=PPN6/wcfgdFlmbqddf2Y0+Se7zg2yRpwLtO4N7Y7rCs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g5oTRnHpZylaEePI6tVooRD6TqKp7enJJE7isfRv8ksVob5PjNP6V3DqrqtgsGHyF
	 ISlAnuElDECkAUGLXNYI3ViAf+Ben8lEMGsgGywWteLYfbo6si8nvZznMTmNLrf5rx
	 iYQjLMFkolkeI92/I8HCLD0i3IH4/wAlvoZIgw4YIWrCkPOeL0FaQxrgwbH6pxhxXJ
	 EgywlyA3r77SSIrDOS5hyp1ZGlbccBkBv+byuQ6DX4YudEJV8Yhn+X55Jlkv24/4/n
	 v/WtAAWYDGHX8HXk/rDIxZnXJTML0HUMAJUinnNEy61HmKdkAiREUmVRhmZsRADNdj
	 ounvMsNnhdx6Q==
Message-ID: <sashiko-outbox-227178@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/1] scsi: target: iscsi: fix use-after-free in
 iscsit_stop_session()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vitalii Dodonov" <dreamer.two@gmail.com>, linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
In-Reply-To: <179527913740.32224.16728687439026782592@gmail.com>
References: <179527913740.32224.2426414360492240680@gmail.com>
 <179527913740.32224.16728687439026782592@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 16:50:05 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] scsi: target: iscsi: session leak when closing failed session
  with nconn =3D=3D 0 [1]
--

commit 29536f098b4fb525d53737f9024a60f1ba499f18
Author: Vitalii Dodonov <dreamer.two@gmail.com>

scsi: target: iscsi: fix use-after-free in iscsit_stop_session()

This commit fixes a use-after-free in iscsit_stop_session() by taking a
reference-counted snapshot of sess->sess_conn_list under sess->conn_lock
before dropping the lock to reinstate connections.

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 03d618cd76721..bd56dc76fbca8 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4669,36 +4669,62 @@ void iscsit_stop_session(
>  	int session_sleep,
>  	int connection_sleep)
>  {
> -	u16 conn_count =3D atomic_read(&sess->nconn);
> -	struct iscsit_conn *conn, *conn_tmp =3D NULL;
> -	int is_last;
> +	struct iscsit_conn *conn, **conns =3D NULL;
> +	unsigned int i, n, conn_count =3D 0;
> +
> +	/*
> +	 * sess_conn_list may only be walked while holding sess->conn_lock: a
> +	 * connection that is being shut down concurrently runs
> +	 * iscsit_close_connection(), which removes itself from that list with
> +	 * list_del() under the same lock and leaves LIST_POISON1 in
> +	 * conn->conn_list.next.  Pinning the connection itself is not enough,
> +	 * because the list links are poisoned as well, so take a snapshot of
> +	 * the connections (with a reference on each) and work on that snapshot
> +	 * only.
> +	 *
> +	 * The sleeping variant is called from process context only --
> +	 * iscsi_target_tx_thread(), the login workqueue (session
> +	 * reinstatement), configfs, iscsit_release_sessions_for_tpg() -- with
> +	 * no locks held, and this function already blocks below in
> +	 * iscsit_cause_connection_reinstatement(conn, 1) and in
> +	 * wait_for_completion(&sess->session_wait_comp), so the GFP_KERNEL
> +	 * allocation does not add a new constraint.
> +	 */
> +	if (connection_sleep) {
> +		conn_count =3D atomic_read(&sess->nconn);

[Severity: High]
This problem wasn't introduced by this patch, but can closing or
reinstating a session in TARG_SESS_STATE_FAILED when sess->nconn is
already 0 leak the session [1]?

When the last connection closes without falling back to ERL=3D0 (for
example on ISCSI_LOGOUT_REASON_CLOSE_CONNECTION),
iscsit_close_connection() moves the session to TARG_SESS_STATE_FAILED
with sess->nconn =3D=3D 0 and starts the Time2Retain timer.  Commit
57c46e9f33da ("scsi: target: fix hang when multiple threads try to
destroy the same iscsi session") removed the direct
iscsit_close_session() calls from iscsi_check_for_session_reinstatement(),
lio_tpg_close_session(), and iscsit_release_sessions_for_tpg(), relying
on iscsit_stop_session() to tear down the remaining connections so the
last connection calls iscsit_close_session().

If one of those paths runs while sess->nconn is already 0, it stops the
Time2Retain timer and either returns early on TARG_SESS_STATE_FAILED:

drivers/target/iscsi/iscsi_target_login.c:iscsi_check_for_session_reinstate=
ment() {
    ...
	spin_lock_bh(&sess->conn_lock);
	if (sess->session_state =3D=3D TARG_SESS_STATE_FAILED) {
		spin_unlock_bh(&sess->conn_lock);
		iscsit_dec_session_usage_count(sess);
		return 0;
	}
	spin_unlock_bh(&sess->conn_lock);

	iscsit_stop_session(sess, 1, 1);
    ...
}

or calls iscsit_stop_session() with an empty sess->sess_conn_list.  With
no connection left to run iscsit_close_connection(),
iscsit_close_session() never runs, leaking struct iscsit_session and
struct se_session and leaving core_tpg_del_initiator_node_acl() hung in
wait_for_completion(&acl->acl_free_comp).

[1] https://sashiko.dev/#/bug/linux-305f6726-98b0-4cd9-9238-5325539f4459

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179527913740.32224.=
2426414360492240680@gmail.com?part=3D1
