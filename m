Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794917970;
	b=axbqIaTlbrxfUd2lfqace89s/fahIDdyTi8LnM8FX3llG0g+AyJ1SjFtsANq3lQ4eRyZ
	 DpKiH0R/QLslsiJXysfPgfeJALUAhMsqMXlsv4vFi4lE8HODAskvDSHjdwKEXzsMq2qlg
	 InQ+V1UDIdeHzDnmGKN8G8pUVRe6C3YLdgtxZ6LCTshEOqdH1x7tzhlyeBvAspn9DJjww
	 1AILPZS/z/JTMhcLgcM16vXG8uUTompzQBxaWZ+I2UVNzM0Kx5MbQWfkNZhucqVzqw9wg
	 qcTLUCiMxJOFfOxPtLFtnelgV/9VRTZyaaGcFwTw9AepqOvU0QoHBtZ5dP+dojpAjGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794917970;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bNyXTV87TsW7lSvdozpHhlbZCNJPMug47mWfobVIjaA=;
	b=ysdOuIdu5Y3/xsrziWQLlhAIr8w1/Z3ZemAduF3tQz2sUDXgXDYCj0UU0yKHtgBgwko3
	 0431tBFFRZqecPNKZdJvJlUT0sy0U8rnVqOL61vIJBoLWj8H+JIJTsCTMQpF1lb9AnsbB
	 WAkAMTYwf3ponB1LgvCmbsuqOYc/4ro/UXOG0HWXS7XEGn5ZethW3G4phbAcKtFoX1M6d
	 RW0e5Q7qjdwFVpikf2moR/ke2nQ9grfWMNd+mNNBu1ihicAy50DboFhyAPGXgAJCB8IE9
	 4loWZy/Vd8QUnNv5Mnz/XD70O5grsSYoNaw2tzMZ5fLXWQNRM4p74otH3a96mk85phg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LvDOBnuo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111ED606A8A9;
	Tue, 17 Nov 2026 12:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LvDOBnuo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3891F000C4;
	Tue, 17 Nov 2026 12:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794917969;
	bh=bNyXTV87TsW7lSvdozpHhlbZCNJPMug47mWfobVIjaA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LvDOBnuomF7U+sZKfGtNvTCCjZToZbfAPsOzmdMsl/FGn0eaXSap9jgq1yKjsMu3p
	 lvKJd+6CvSitd6m+ntSKAUWIkn4fsngrVdoGPtHWBcB08IKsWDD9L1DLckQE9zLAb8
	 JQ38G4oWkMEs3TeJRcGJhDUfvcTz9STuucCRTRbDn5n5ELZyN1iaccMBPD2ZJwq6LI
	 yL52roKxEd7DoKcq8Dv9zOGZg0DkNktUl8qpOQqFeLleYRZgVWwV/HvdXotzh5fdPj
	 og7O6uc4dZwplYvrauJhuy3Z1b3CnKPdPnDBBKfyorPtUBFkk7TuPuNy5uPkWoDWuo
	 XQmdg4E6H707A==
Message-ID: <sashiko-outbox-218766@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: target: iscsi: run the Time2Retain handler in
 process context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261117114920.1955697-1-yhlee@isslab.korea.ac.kr>
References: <20261117114920.1955697-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 12:19:29 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] scsi: target: iscsi: use-after-free in iscsit_close_session()
  on timer race
--

commit d4a7bf123031292ded7f0f9fa40305b57dfe90d2
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: target: iscsi: run the Time2Retain handler in process context

This commit moves the Time2Retain timeout handling from the timer callback
into a work item and coordinates cancellation using a time2retain_fired
atomic flag.

Link: https://lore.kernel.org/all/20261115121943.1446744-1-yhlee@isslab.kor=
ea.ac.kr/

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 03d618cd76721..645ac9bd156d3 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4516,6 +4516,15 @@ int iscsit_close_session(struct iscsit_session *se=
ss, bool can_sleep)
>  	sess->sess_ops =3D NULL;
>  	spin_unlock_bh(&se_tpg->session_lock);
> =20
> +	/*
> +	 * No Time2Retain work may outlive the session.  A work item never runs
> +	 * twice at once, so the work itself can only find a queued one.
> +	 */
> +	if (can_sleep)
> +		cancel_work_sync(&sess->time2retain_work);
> +	else
> +		cancel_work(&sess->time2retain_work);
> +
>  	kfree(sess);
>  	return 0;
>  }
> diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/is=
csi/iscsi_target_erl0.c
> index 24db6b07493e6..036ddc1002f6c 100644
> --- a/drivers/target/iscsi/iscsi_target_erl0.c
> +++ b/drivers/target/iscsi/iscsi_target_erl0.c
> @@ -741,15 +741,17 @@ int iscsit_check_post_dataout(
>  	}
>  }
> =20
> -void iscsit_handle_time2retain_timeout(struct timer_list *t)
> +void iscsit_time2retain_work(struct work_struct *work)
>  {
> -	struct iscsit_session *sess =3D timer_container_of(sess, t,
> -							 time2retain_timer);
> +	struct iscsit_session *sess =3D container_of(work, struct iscsit_sessio=
n,
> +						   time2retain_work);
>  	struct iscsi_portal_group *tpg =3D sess->tpg;
>  	struct se_portal_group *se_tpg =3D &tpg->tpg_se_tpg;
> =20
>  	spin_lock_bh(&se_tpg->session_lock);
> -	if (sess->time2retain_timer_flags & ISCSI_TF_STOP) {
> +	/* A stop after the timer fired takes ->time2retain_fired back. */
> +	if (!atomic_xchg(&sess->time2retain_fired, 0) ||
> +	    (sess->time2retain_timer_flags & ISCSI_TF_STOP)) {
>  		spin_unlock_bh(&se_tpg->session_lock);
>  		return;
>  	}
> @@ -769,6 +771,15 @@ void iscsit_handle_time2retain_timeout(struct timer_=
list *t)
>  	iscsit_close_session(sess, false);
>  }
> =20
> +void iscsit_handle_time2retain_timeout(struct timer_list *t)
> +{
> +	struct iscsit_session *sess =3D timer_container_of(sess, t,
> +							 time2retain_timer);
> +
> +	atomic_set(&sess->time2retain_fired, 1);
> +	queue_work(system_dfl_wq, &sess->time2retain_work);
> +}

[Severity: High]
Can an already-started iscsit_time2retain_work() from an earlier timer
expiry consume time2retain_fired from a re-armed timer and free sess while
iscsit_handle_time2retain_timeout() is still running?

If the session is resumed and stops the timer after the first work item has
started (before it takes se_tpg->session_lock), and then re-arms the timer
on a subsequent logout, the second timer expiry sets time2retain_fired =3D 1
before calling queue_work():

CPU0                              CPU1
iscsit_time2retain_work() [1st]
  /* starts before session_lock */
                                  /* timer stopped, then re-armed */
                                  iscsit_handle_time2retain_timeout()
                                    atomic_set(&sess->time2retain_fired, 1)
  spin_lock_bh(&se_tpg->session_lock)
  atomic_xchg(&sess->time2retain_fired, 0)
  sess->time2retain_timer_flags |=3D ISCSI_TF_EXPIRED
  spin_unlock_bh(&se_tpg->session_lock)
  iscsit_close_session(sess, false)
    iscsit_stop_time2retain_timer(sess)
      /* sees ISCSI_TF_EXPIRED, returns -1 */
    ...
    cancel_work(&sess->time2retain_work)
    kfree(sess)
                                    queue_work(..., &sess->time2retain_work)
                                      <-- use-after-free

Because iscsit_time2retain_work() sets ISCSI_TF_EXPIRED before calling
iscsit_close_session(), iscsit_stop_time2retain_timer() returns early
without calling timer_delete_sync(&sess->time2retain_timer):

drivers/target/iscsi/iscsi_target_erl0.c:iscsit_stop_time2retain_timer() {
	...
	if (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)
		return -1;
	...
	timer_delete_sync(&sess->time2retain_timer);
}

As a result, nothing waits for the timer callback on CPU1 to finish
queue_work() before cancel_work() and kfree(sess) run, queueing work on a
freed session.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117114920.1955=
697-1-yhlee@isslab.korea.ac.kr?part=3D1
