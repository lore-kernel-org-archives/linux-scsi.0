Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794746560;
	b=JdUNlMyAfV5/lpHLF+szAJCmR7Vadll4Jq/DpRN5ilrmVzBwqfoFk8RrTds4m1at9GCC
	 9EOheAvQzzwfnubnQ7SA2IAoMPG/uxzfPDEO4kCQW0FrSUFny/IY8cWzmgLLSxYcQeJOE
	 VRZRLSqKBnhzccO9RsO4pb2d6xjAs0XZU/pU55QFouot415l+pL9TdSJ8NiRRMtnPSATa
	 TSo+kTm/QPazTWNwyUBVzCXsQtcU789GyPsgSrzetkRwY0cZP7VcSWsclQ/BxqipSh/I9
	 1kQUJGeHrNY9jNiQICqLjbiSCO0auvweTAvbTJTDXEGVwYVcANRjjoMFq+YVWcye+Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794746560;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4Z+4567/QWUOqxO9Q+A6yXUFz2TTKjM5ijC4fu+iGq0=;
	b=Ja9BW/emhGCWsfUjggcHJqCk2RsBg0GSnlcHuLiY7dOIWj/hnbTeW1NcRXwMcLvkg1cs
	 3fN2ZWukVr0AR7h6oPC10IT3zMYGKKvi46/jtoJROVZqKIMIQn46EAGbNRcSwItq3ceTg
	 DiwpewN7ooucNmK5v7a9WvOcILEtjXi2dXBGvinF3AA/6ge2NBkBMILaRCG26kmNVLiHG
	 jjQ1TMM4VSE6P61FLlyX1H4b+2rQhcfE6YJZe06D6VUVmjtBcbBJwVcGlFOxOt1IFSTIp
	 sFErRb2FDAbdnIL5fLRtYmo+r7Z7cfdQcvzZSu9Kc0ogVO1a/O7LnaH8Y1tZoQe7FsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="B3cTwy/4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9768606A32D;
	Sun, 15 Nov 2026 12:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B3cTwy/4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B4F1F000C4;
	Sun, 15 Nov 2026 12:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794746559;
	bh=4Z+4567/QWUOqxO9Q+A6yXUFz2TTKjM5ijC4fu+iGq0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B3cTwy/4fdHnnwfsQLpWqFs7RmQbJLPon/RNZhz4rfrZZOp9Dwd5R/sJIEueANd1C
	 SbKOEsT4T6EhWSZABpib43IO3U6C4la5/jfmwpp/FJ46isly7cI+84BkiIzSu5Asje
	 RBPIwCYvqF9Gj0GqIq9HxcbOGtl1aUP7SLaY8AP8bFuX96B9W9ET8wFHIEZ/huU0nl
	 sGfeHk06J/M03rJeRWQ1dmFbsi1q3/2j+KjCfFN+DPprJo+/2oKHfbJFdA4TO/aQc4
	 HCtJ1/y3CcTwCbHdbGuqCFDIH7yhmLh8tQ3bG5SpnW0gs3pd/jZ2nbpQfimq4RA4o4
	 t9BK4eF72l08Q==
Message-ID: <sashiko-outbox-215504@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: run the Time2Retain handler in
 process context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261115121943.1446744-1-yhlee@isslab.korea.ac.kr>
References: <20261115121943.1446744-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 12:42:38 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] scsi: target: iscsi: UAF race in
  iscsit_stop_time2retain_timer() on restart
- [High] scsi: target: iscsi: session leak in iscsit_close_session()
  when !can_sleep
- [High] scsi: target: iscsi: UAF in iscsit_close_connection() when
  Time2Retain is 0
- [Medium] scsi: target: iscsi: session_lock dropped in
  iscsit_stop_time2retain_timer()
--

commit cd2ff8f1169a8e47b09d7eb1b677944735610f1c
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: target: iscsi: run the Time2Retain handler in process context

This commit converts the session Time2Retain timer into a delayed work item=
 on
system_dfl_wq so that iscsit_handle_time2retain_timeout() closes the session
and acquires se_tpg->session_lock in process context rather than timer soft=
irq
context.

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 03d618cd76721..4c6579eb803f3 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4485,8 +4485,8 @@ int iscsit_close_session(struct iscsit_session *ses=
s, bool can_sleep)
> =20
>  	/*
>  	 * If any other processes are accessing this session pointer we must
> -	 * wait until they have completed.  If we are in an interrupt (the
> -	 * time2retain handler) and contain and active session usage count we
> +	 * wait until they have completed.  If we are the Time2Retain work
> +	 * (can_sleep is false) and contain and active session usage count we
>  	 * restart the timer and exit.
>  	 */
>  	if (iscsit_check_session_usage_count(sess, can_sleep)) {

[Severity: High]
Can keeping can_sleep as false when iscsit_handle_time2retain_timeout() cal=
ls
iscsit_close_session() leak the session if session_usage_count is non-zero?

In iscsi_target_login_sess_out(), the old_sess_out path starts the Time2Ret=
ain
handler and drops se_tpg->session_lock before calling
iscsit_dec_session_usage_count().  When DefaultTime2Retain is 0,
mod_delayed_work() queues time2retain_work with zero delay, so
iscsit_handle_time2retain_timeout() can run on another CPU while
session_usage_count is still elevated.

iscsit_handle_time2retain_timeout() sets ISCSI_TF_EXPIRED (with
ISCSI_TF_RUNNING still set) and calls iscsit_close_session(sess, false).
iscsit_close_session() sets session_reinstatement to 1, fails to stop the
timer because ISCSI_TF_EXPIRED is set, deregisters configfs, and enters the
!can_sleep branch above because session_usage_count is non-zero.  There,
iscsit_start_time2retain_handler() returns immediately without re-arming the
work because ISCSI_TF_RUNNING was never cleared, leaving the half-closed
session leaked with ISCSI_TF_EXPIRED and session_reinstatement set.

Since iscsit_handle_time2retain_timeout() now runs in process context, could
it wait on session_waiting_on_uc_comp instead of taking the non-sleeping
restart path?

[ ... ]

> diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/is=
csi/iscsi_target_erl0.c
> index 24db6b07493e6..9db833f3eeaec 100644
> --- a/drivers/target/iscsi/iscsi_target_erl0.c
> +++ b/drivers/target/iscsi/iscsi_target_erl0.c

[ ... ]

> @@ -791,8 +791,8 @@ void iscsit_start_time2retain_handler(struct iscsit_s=
ession *sess)
> =20
>  	sess->time2retain_timer_flags &=3D ~ISCSI_TF_STOP;
>  	sess->time2retain_timer_flags |=3D ISCSI_TF_RUNNING;
> -	mod_timer(&sess->time2retain_timer,
> -		  jiffies + sess->sess_ops->DefaultTime2Retain * HZ);
> +	mod_delayed_work(system_dfl_wq, &sess->time2retain_work,
> +			 sess->sess_ops->DefaultTime2Retain * HZ);
>  }
> =20
>  int iscsit_stop_time2retain_timer(struct iscsit_session *sess)

[Severity: High]
Can this cause a use-after-free in iscsit_close_connection() when
DefaultTime2Retain is 0?

drivers/target/iscsi/iscsi_target.c:iscsit_close_connection() {
    ...
		if (!atomic_read(&sess->session_continuation))
			iscsit_start_time2retain_handler(sess);

		if (atomic_read(&sess->session_close)) {
			spin_unlock_bh(&sess->conn_lock);
			complete_all(&sess->session_wait_comp);
			iscsit_close_session(sess, true);
		} else {
			spin_unlock_bh(&sess->conn_lock);
		}
    ...
}

Previously, mod_timer() armed a softirq timer while spin_lock_bh() kept loc=
al
softirqs disabled across iscsit_start_time2retain_handler() and the subsequ=
ent
sess accesses.  With mod_delayed_work(), a zero delay bypasses the timer wh=
eel
and queues time2retain_work immediately on an unbound worker, and neither
iscsit_handle_time2retain_timeout() nor iscsit_close_session() takes
sess->conn_lock:

CPU0                                  CPU1 (kworker)
iscsit_close_connection()
  spin_lock_bh(&sess->conn_lock)
  iscsit_start_time2retain_handler(sess)
    mod_delayed_work(..., 0)
                                      iscsit_handle_time2retain_timeout()
                                        iscsit_close_session(sess, false)
                                          kfree(sess)
  atomic_read(&sess->session_close)
  spin_unlock_bh(&sess->conn_lock)  <-- use-after-free

> @@ -811,7 +811,7 @@ int iscsit_stop_time2retain_timer(struct iscsit_sessi=
on *sess)
>  	sess->time2retain_timer_flags |=3D ISCSI_TF_STOP;
>  	spin_unlock(&se_tpg->session_lock);
> =20
> -	timer_delete_sync(&sess->time2retain_timer);
> +	cancel_delayed_work(&sess->time2retain_work);
> =20
>  	spin_lock(&se_tpg->session_lock);
>  	sess->time2retain_timer_flags &=3D ~ISCSI_TF_RUNNING;

[Severity: High]
Can replacing timer_delete_sync() with cancel_delayed_work() here allow an
already-dispatched work item to close and free the session after the timer =
is
stopped and restarted?

Because cancel_delayed_work() does not wait for a running work item,
iscsit_stop_time2retain_timer() clears ISCSI_TF_RUNNING while a worker thre=
ad
can still be preempted before taking se_tpg->session_lock.  If the timer is
then restarted (for example via the old_sess_out path in
iscsi_target_login_sess_out() when a continuation login fails),
iscsit_start_time2retain_handler() clears ISCSI_TF_STOP and re-queues
sess->time2retain_work:

CPU0 (kworker)                        CPU1
iscsit_handle_time2retain_timeout()
  /* preempted before session_lock */
                                      iscsi_login_non_zero_tsih_s2()
                                        iscsit_stop_time2retain_timer()
                                          flags |=3D ISCSI_TF_STOP
                                          cancel_delayed_work()
                                          flags &=3D ~ISCSI_TF_RUNNING
                                      ...
                                      iscsi_target_login_sess_out()
                                        iscsit_start_time2retain_handler()
                                          flags &=3D ~ISCSI_TF_STOP
                                          flags |=3D ISCSI_TF_RUNNING
                                          mod_delayed_work()
  spin_lock_bh(&se_tpg->session_lock)
  /* ISCSI_TF_STOP is now clear */
  flags |=3D ISCSI_TF_EXPIRED
  spin_unlock_bh(&se_tpg->session_lock)
  iscsit_close_session(sess, false)
    iscsit_stop_time2retain_timer()   <-- returns -1 (ISCSI_TF_EXPIRED)
    /* cancel_delayed_work_sync() skipped because !can_sleep */
    kfree(sess)                       <-- time2retain_work still queued

When CPU0 acquires se_tpg->session_lock, ISCSI_TF_STOP is no longer set, so
the stale work sets ISCSI_TF_EXPIRED and calls iscsit_close_session(sess,
false).  Because ISCSI_TF_EXPIRED is set and can_sleep is false, neither
iscsit_stop_time2retain_timer() nor cancel_delayed_work_sync() cancels the
newly armed time2retain_work before kfree(sess) frees the session (or if a
new connection is already active on the session, iscsit_close_session() hits
BUG() on sess->nconn).

[Severity: Medium]
Why does iscsit_stop_time2retain_timer() still drop and re-acquire
se_tpg->session_lock around cancel_delayed_work()?

The commit message notes that cancel_delayed_work() is called with
se_tpg->session_lock held because it does not sleep, but the unlock and lock
around it remain from timer_delete_sync().  Dropping se_tpg->session_lock
splits the update of time2retain_timer_flags across two critical sections, =
so
an unlocked caller of iscsit_start_time2retain_handler() such as
iscsit_close_connection() can observe ISCSI_TF_RUNNING still set in that
window and return without arming the work just before ISCSI_TF_RUNNING is
cleared.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115121943.1446=
744-1-yhlee@isslab.korea.ac.kr?part=3D1
