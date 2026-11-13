Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794582629;
	b=fey2QwoLzhy6W1dHCUivHqkKmZNWeii2Ne5rDmxf/a772T+TiF53NxOp0HGsyEwLdgky
	 3hPMES1SlLId6Z8zPK/VUJjKY5DegtNOuIpL6/aWnwnwuqSsim/zoXHtMk0Xzui+190UT
	 FE/iNTRseBxQxuiFL1Tne+QzDku8bsG1KLCyrPkWuWUabAl5kmQqzv3n0sMbg5ePE8trm
	 C4HFblZtck5pUiaAqv7VaxistUyb9GrxgFNNWUUxKU5KwY3W0cJSZLaaVkO1fVz/YP6hu
	 +zV+mddXLqW8079O66qAQ6NwTosg0KKUuurbdyC+DNkOkKrrNqLQ8kNOPNiRTen8TfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582629;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KyzSgjwxe7OS5V13XYAGJHDp7TloPDPJw1hDb4iC/8o=;
	b=h/3ToF3AX27S+fgmu912Zj5mY3jNYXsSRGORbJXqNGMucKkN7gxg2z+vR1j3L0yV+d6H
	 bufSOuSTMLJOPMqfjAlqwGpLofyloYbfjQ9wWirl4+hi15xRT/qKoajl2FKWmwfN9tqnH
	 +cJv0tGZPGVU3KfaPsG1PySFlsxxQvHR8wJTxA+bBuBOa4TBNrWrb53Stg2ZzwVEExuaE
	 kaEs+VIRUK8xms0vPnYN5KC4jaM25kSuTZYZSyEG/B8oRSL8pINB1dWEfxjK8wf/nuTbD
	 6lsVCd7pZ4Ba3z3vo2J717+tHH9dHn0jqrYHpJn4pWR3Ihd84pqFyXKskzVMj1y+tDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cSbYzENV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D92606A332
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 15:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cSbYzENV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF8E1F000C5;
	Fri, 13 Nov 2026 15:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794582629;
	bh=KyzSgjwxe7OS5V13XYAGJHDp7TloPDPJw1hDb4iC/8o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cSbYzENVw5PGxcAb4cT463rxUn6eVyTJLxpiPF/Tv5u+36BPy0p6L0I+EGGOGReGv
	 KWM/OdeCHDEB58RARSuc66farOqBAg3QILJWffeJZl54MA0x6J4f9ND5dKXDNA6zKU
	 Rs+hoveKhEqXnp+TGYsCfv50qHLDX8hkPyZ+Zpi7k0WtZdBFtQYRY0OrYMTuXGnosG
	 hvr7U9E84Iy175j8mEp67yrnDrZ58GjaxQxFid13YPMmSIfEOfw/RfKOpwuUq/qy5b
	 VLnYM0P2hvSngu/MncZ707KUV7wW/WZPfXCV0yN9ysnbPS/Bo4OTlvLWdq7DqMHRrs
	 yYheRdcsZzBhA==
Message-ID: <sashiko-outbox-213058@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: libiscsi: only complete a task that has been sent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261113145140.282504-1-yhlee@isslab.korea.ac.kr>
References: <20261113145140.282504-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 15:10:28 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] scsi: libiscsi: premature ISCSI_TASK_RUNNING store before xmit
  ref acquisition
- [High] scsi: libiscsi: RX completion of RESERVED_ITT tasks marked
  ISCSI_TASK_RUNNING
--

commit 2159be71cf354047db675ef637cf1e1cfec39bbe
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: libiscsi: only complete a task that has been sent

This commit pairs smp_store_release() when marking a task
ISCSI_TASK_RUNNING with smp_load_acquire() in the RX task lookups so
management responses and Reject PDUs only complete tasks that have been
prepared for transmission.

> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 2d04448432a77..83d726043d3e8 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c

[ ... ]

> @@ -702,7 +703,8 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *co=
nn,
>  	if ((hdr->opcode & ISCSI_OPCODE_MASK) =3D=3D ISCSI_OP_LOGOUT)
>  		session->state =3D ISCSI_STATE_LOGGING_OUT;
> =20
> -	task->state =3D ISCSI_TASK_RUNNING;
> +	/* Pairs with the acquire in the RX task lookups. */
> +	smp_store_release(&task->state, ISCSI_TASK_RUNNING);
>  	ISCSI_DBG_SESSION(session, "mgmtpdu [op 0x%x hdr->itt 0x%x "
>  			  "datalen %d]\n", hdr->opcode & ISCSI_OPCODE_MASK,
>  			  hdr->itt, task->data_count);

[Severity: High]
Can the RX path still complete and free task after smp_store_release() here
before the transmit path takes its reference?

A management task dequeued in iscsi_data_xmit() has refcount 1 under
session->frwd_lock and only acquires its transmit reference later in
iscsi_xmit_task() via iscsi_get_task():

CPU0 (kworker)                    CPU1 (softirq)
iscsi_data_xmit()
  spin_lock_bh(&session->frwd_lock)
  iscsi_prep_mgmt_task()
    smp_store_release(&task->state,
                      ISCSI_TASK_RUNNING)
                                  __iscsi_complete_pdu()
                                    spin_lock(&session->back_lock)
                                    smp_load_acquire(&task->state)
                                    iscsi_complete_task(task, ...)
                                      __iscsi_put_task()
                                        iscsi_free_task()
  iscsi_xmit_task()
    iscsi_get_task(task)
      WARN_ON_ONCE(1)             <-- refcount already 0

On transports without ihost->workq, iscsi_send_mgmt_task() calls
iscsi_prep_mgmt_task() and session->tt->xmit_task(task) with refcount 1, so
an RX completion in that window frees task during xmit_task() and causes
the caller's error-path iscsi_put_task() to underflow refcount and double
free the slot.

> @@ -1174,7 +1176,8 @@ static int iscsi_handle_reject(struct iscsi_session=
 *session,
>  			if (!iscsi_verify_itt(conn, rejected_pdu.itt))
>  				task =3D iscsi_itt_to_task(session, conn,
>  							 rejected_pdu.itt);
> -			if (!task || task->state =3D=3D ISCSI_TASK_FREE ||
> +			/* Pairs with the release when the task is prepared. */
> +			if (!task || smp_load_acquire(&task->state) !=3D ISCSI_TASK_RUNNING ||
>  			    task->sc) {
>  				iscsi_conn_printk(KERN_ERR, conn,
>  						 "Invalid pdu reject. Could "
> @@ -1314,7 +1317,9 @@ int __iscsi_complete_pdu(struct iscsi_session *sess=
ion, struct iscsi_conn *conn,
>  	case ISCSI_OP_SCSI_TMFUNC_RSP:
>  	case ISCSI_OP_NOOP_IN:
>  		task =3D iscsi_itt_to_task(session, conn, hdr->itt);
> -		if (!task || task->state =3D=3D ISCSI_TASK_FREE || task->sc)
> +		/* Pairs with the release when the task is prepared. */
> +		if (!task || smp_load_acquire(&task->state) !=3D ISCSI_TASK_RUNNING ||
> +		    task->sc)
>  			return ISCSI_ERR_BAD_ITT;
>  		break;
>  	default:

[Severity: High]
Can an incoming management response or Reject PDU complete a management
task that was sent with task->hdr->itt =3D=3D RESERVED_ITT?

When replying to a target NOP-In, iscsi_send_nopout() allocates a task from
session->cmdpool with hdr->itt =3D RESERVED_ITT, and iscsi_prep_mgmt_task()
still sets task->state to ISCSI_TASK_RUNNING.  Transports free RESERVED_ITT
tasks on transmit because no response is expected:

drivers/scsi/libiscsi_tcp.c:iscsi_tcp_task_xmit() {
    ...
	/* mgmt command */
	if (!task->sc) {
		if (task->hdr->itt =3D=3D RESERVED_ITT)
			iscsi_put_task(task);
		return 0;
	}
    ...
}

Because iscsi_itt_to_task() indexes session->cmds[] by the pool index in the
received PDU's ITT without checking task->hdr->itt, a PDU naming that pool
index while iscsi_xmit_task() holds its transmit reference (or while the
task is requeued after -EAGAIN) will pass the ISCSI_TASK_RUNNING check and
call iscsi_complete_task(), dropping a reference that the transport also
drops and causing a refcount underflow and use-after-free.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113145140.2825=
04-1-yhlee@isslab.korea.ac.kr?part=3D1
