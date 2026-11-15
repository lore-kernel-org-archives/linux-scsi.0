Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794747616;
	b=nv6DQFpCyLpv1D2SkZNnNlqdM5IQHXVMAQ/CTNN6VEQHgbLeSn0SdHa+Cu9NvAxe2iIJ
	 AMmWHnnp4pNnaUPspIOARY0k10ql34k2/3ljriSC9K1JyvU9wBCvCB0ievwK5naw/wcj2
	 4O7lPnhFNsDsmVrIn86D6syWcXTTzVuDQXCMln9NcL+h7G2jckwWVXQwe6KjcTZmmyn5g
	 FiaBD3ioXeWezVKvag4vO4IyOfnwH4Tcl/DPA10Yf7K/2ewM0yuC4bo0eUTI2+x7ShD9l
	 1KC9Qg3uU4C0+Qz21QWn/o0/YMiYQvkHapZUSiDf6ymvqznswA+nOcbkrDtr85k5muw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794747616;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uqvmQ4pBZFKeyBh0vvo7uLcbqziDZvYbvc2k2mqHESE=;
	b=UYIQJ+eFauRXhn7zNF5M/63n321L76r/rlMlIWJbgF76L7Yc/XYkkSG59+EvjTxCDSfR
	 iEdfKhwskZtvb+FF7E+cgFLehCWDOTN14p7mGJFnuW3lDMQ0xxVPujJYqU+2FBVxjBWCF
	 I7CU/VdHPdatU+6LLJNFMeDImPzJgHTzde0F/cBSNF1E/WKUKwGnFebkx77nluzgTeuwT
	 q/qJOotzAMAcgI7jk4yKo9WzM+4om4u5Sl0F883dRcPqIkWPoeak53FfR4lxTe6FGBRhN
	 0Zy6x/jGxeF32mz946oS2ddky9Ez9LlCgIOuLGg/SW8uJvnG5WsPxf99uJQfH2cB0+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I3RsYdXD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A486606A31F
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 13:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I3RsYdXD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEAD1F000C4;
	Sun, 15 Nov 2026 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794747616;
	bh=uqvmQ4pBZFKeyBh0vvo7uLcbqziDZvYbvc2k2mqHESE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I3RsYdXDuF9nG6Y+1wYbDthc4jWhnmj4TODy5RaxHuLugiKnOI3LytqY1RNQ57KnM
	 d6gYWxpIBB4DUVFnCID8rAA20zmc5A9bqLITissxmS6k0+WyJgaPYpi0FUGH/vZ3EA
	 n5DNjkqH9wSwDNLvygOHYvTGAJ11RN+xqSfT3FOS/MASv15VIXvAfNnSKjdIazj2KI
	 SIoeDAdFU9lF76mirtSqLLKwlyksylb4FPpqGKEHvGngxIE8QQgTs58ebyFOsBAfDf
	 brkB9ThmUHfgeQwFUlITzzNgOjgNAhRk5rGdf3Ed6ATZgC73uovz3nEjXsjwiCXJEG
	 QtDA7sCyV490w==
Message-ID: <sashiko-outbox-215510@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/3] scsi: libiscsi: take a transmit reference before
 a task is published
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261115122122.1446791-4-yhlee@isslab.korea.ac.kr>
References: <20261115122122.1446791-1-yhlee@isslab.korea.ac.kr>
 <20261115122122.1446791-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 13:00:15 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] scsi: libiscsi: UAF on out.segment when iscsi_xmit_task() drops
  completed task
- [High] scsi: libiscsi: incomplete state and ordering check in
  iscsi_itt_to_ctask()
- [High] scsi: libiscsi: completed requeued task sent in
  iscsi_xmit_task()
--

commit 36167e4a6d8cfacb1e2c30d4153e78e02abac811
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: libiscsi: take a transmit reference before a task is published

This commit takes a transmit reference on an iSCSI task before setting its
state to ISCSI_TASK_RUNNING, checks task->state in iscsi_itt_to_ctask(),
and avoids resending or leaking tasks completed by the receive path during
transmission.

> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 220e89d541af6..5045f6f5ca01b 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c

[ ... ]

> @@ -1455,6 +1464,10 @@ struct iscsi_task *iscsi_itt_to_ctask(struct iscsi=
_session *session,
>  	if (!task || !task->sc)
>  		return NULL;
> =20
> +	/* Pairs with the release in the transmit path. */
> +	if (smp_load_acquire(&task->state) =3D=3D ISCSI_TASK_PENDING)
> +		return NULL;
> +
>  	if (iscsi_cmd(task->sc)->age !=3D session->age) {
>  		iscsi_session_printk(KERN_ERR, session,
>  				  "task's session age %d, expected %d\n",

[Severity: High]
Can iscsi_itt_to_ctask() still return an unsent or already-completed task
here?

First, iscsi_alloc_task() writes task->state =3D ISCSI_TASK_PENDING and
task->sc =3D sc under frwd_lock with plain stores and no barrier between
them, while iscsi_itt_to_ctask() reads task->sc before
smp_load_acquire(&task->state):

CPU0 (frwd_lock)                  CPU1 (back_lock)
iscsi_alloc_task()                iscsi_itt_to_ctask()
  task->state =3D ISCSI_TASK_PENDING
  task->sc =3D sc
                                    if (!task || !task->sc)
                                    smp_load_acquire(&task->state)
                                      --> sees ISCSI_TASK_FREE

Because smp_load_acquire() only orders loads after it and
iscsi_alloc_task() has no release or write barrier before setting task->sc,
CPU1 can observe the new task->sc while still reading the prior
ISCSI_TASK_FREE state, bypassing the ISCSI_TASK_PENDING check and freeing
the task while it stays on conn->cmdqueue.

Second, while the transmit path holds a second reference on task (for
example across session->tt->xmit_task() or in conn->task), completing the
task on the receive path sets task->state to ISCSI_TASK_COMPLETED and
decrements refcount from 2 to 1 without clearing task->sc.  Because
iscsi_itt_to_ctask() only rejects ISCSI_TASK_PENDING, a subsequent
ISCSI_OP_SCSI_DATA_IN PDU for that ITT still resolves the completed task:

drivers/scsi/libiscsi_tcp.c:iscsi_tcp_hdr_dissect() {
	...
	case ISCSI_OP_SCSI_DATA_IN:
		spin_lock(&session->back_lock);
		task =3D iscsi_itt_to_ctask(session, conn, hdr->itt);
		if (!task)
			rc =3D ISCSI_ERR_BAD_ITT;
		else
			rc =3D iscsi_tcp_data_in(conn, task);
		spin_unlock(&session->back_lock);
	...
}

iscsi_tcp_data_in() points tcp_conn->in.segment at task->sc->sdb.table.sgl
and drops back_lock without a task reference; when the transmit path then
puts its final reference, iscsi_free_task() calls scsi_done() and frees the
scatterlist while iscsi_tcp_recv_skb() writes payload bytes into it
(use-after-free).  A duplicate ISCSI_OP_SCSI_CMD_RSP in that window will
also overwrite sc->result and sense data before scsi_done() runs.

> @@ -1556,9 +1569,20 @@ static int iscsi_xmit_task(struct iscsi_session *s=
ession, struct iscsi_conn *con
>  			WARN_ON_ONCE(1);
>  			return 0;
>  		}
> +		if (!was_requeue)
> +			/* Pairs with the acquire in the RX task lookups. */
> +			smp_store_release(&task->state, ISCSI_TASK_RUNNING);
>  	} else {
>  		/* Already have a ref from when we failed to send it last call */
>  		conn->task =3D NULL;
> +		/* The RX path may have completed it while the tx was stopped. */
> +		spin_lock_bh(&session->back_lock);
> +		if (task->state !=3D ISCSI_TASK_RUNNING) {
> +			__iscsi_put_task(session, task);
> +			spin_unlock_bh(&session->back_lock);
> +			return 0;
> +		}
> +		spin_unlock_bh(&session->back_lock);
>  	}

[Severity: High]
When conn->task is NULL and was_requeue is true, can iscsi_xmit_task()
still pass a completed task to session->tt->xmit_task()?

When iscsi_tcp_r2t_rsp() queues a task onto conn->requeue, it takes an
extra reference on task.  If an early response completes the task before
iscsi_data_xmit() pops it from conn->requeue, task->state becomes
ISCSI_TASK_COMPLETED while the R2T reference keeps the task alive:

CPU0 (RX, back_lock)              CPU1 (xmit worker, frwd_lock)
iscsi_tcp_r2t_rsp()
  iscsi_get_task(task)
  iscsi_requeue_task(task)
iscsi_complete_task()
  task->state =3D ISCSI_TASK_COMPLETED
  __iscsi_put_task() (refcount 2->1)
                                  iscsi_data_xmit()
                                    iscsi_xmit_task(..., was_requeue=3Dtrue)
                                      if (!conn->task)
                                        iscsi_get_task(task)
                                      if (was_requeue)
                                        iscsi_put_task(task)
                                      session->tt->xmit_task(task)

Because the !conn->task branch does not check task->state under back_lock
when was_requeue is true, it calls session->tt->xmit_task() on the
completed task.  If xmit_task() then returns -EAGAIN after
iscsi_sw_tcp_pdu_init() points tcp_sw_conn->out.segment at task->hdr and
task->sc->sdb.table.sgl, the post-xmit check sees task->state !=3D
ISCSI_TASK_RUNNING, skips saving conn->task, and drops the final reference,
freeing task and task->sc while tcp_sw_conn->out.segment still references
them.

> @@ -1584,10 +1608,12 @@ static int iscsi_xmit_task(struct iscsi_session *=
session, struct iscsi_conn *con
>  	spin_unlock_bh(&session->frwd_lock);
>  	rc =3D session->tt->xmit_task(task);
>  	spin_lock_bh(&session->frwd_lock);
> +	/* regular RX path uses back_lock */
> +	spin_lock_bh(&session->back_lock);
>  	if (!rc) {
>  		/* done with this task */
>  		task->last_xfer =3D jiffies;
> -	} else {
> +	} else if (task->state =3D=3D ISCSI_TASK_RUNNING) {
>  		/*
>  		 * get an extra ref that is released next time we access it
>  		 * as conn->task above.
> @@ -1596,7 +1622,8 @@ static int iscsi_xmit_task(struct iscsi_session *se=
ssion, struct iscsi_conn *con
>  		conn->task =3D task;
>  	}
> =20
> -	iscsi_put_task(task);
> +	__iscsi_put_task(session, task);
> +	spin_unlock_bh(&session->back_lock);
>  	return rc;
>  }

[Severity: High]
On iscsi_tcp, if session->tt->xmit_task() returns -EAGAIN after partially
sending a PDU and the receive path has completed the task in the meantime,
does dropping task here cause a use-after-free on tcp_sw_conn->out.segment?

During session->tt->xmit_task(), iscsi_sw_tcp_pdu_init() sets the
per-connection tcp_sw_conn->out.segment and out.data_segment to point at
task->hdr and task->sc->sdb.table.sgl.  If the socket buffer fills up
mid-PDU (-EAGAIN) and an incoming response completes the task either before
back_lock is taken here or while the task was parked in conn->task,
__iscsi_put_task() drops the last reference:

CPU0 (xmit worker)                CPU1 (RX, back_lock)
iscsi_xmit_task()
  session->tt->xmit_task(task)
    iscsi_sw_tcp_pdu_init()
      out.segment -> task->sc->sdb
    iscsi_sw_tcp_pdu_xmit()
      -> -EAGAIN (unsent bytes left)
                                  iscsi_complete_task(task)
                                    task->state =3D ISCSI_TASK_COMPLETED
                                    __iscsi_put_task() (refcount 2->1)
  spin_lock_bh(&session->back_lock)
  /* task->state !=3D RUNNING:
   * conn->task not set
   */
  __iscsi_put_task() (refcount 1->0)
    iscsi_free_task()
      scsi_done(sc) (frees sgl)
...
iscsi_data_xmit() (next requeued task)
  iscsi_tcp_task_xmit()
    session->tt->xmit_pdu()
      iscsi_sw_tcp_xmit()
        --> reads freed sgl in out.segment  <-- use-after-free

iscsi_tcp_cleanup_task() only drains tcp_task->r2tqueue and does not reset
tcp_sw_conn->out.segment:

drivers/scsi/libiscsi_tcp.c:iscsi_tcp_task_xmit() {
	...
flush:
	/* Flush any pending data first. */
	rc =3D session->tt->xmit_pdu(task);
	if (rc < 0)
		return rc;
	...
}

When the next task on conn->requeue runs iscsi_tcp_task_xmit(), it flushes
the remaining bytes from tcp_sw_conn->out.segment before calling init_pdu(),
reading from the freed scatterlist and pages.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115122122.1446=
791-1-yhlee@isslab.korea.ac.kr?part=3D3
