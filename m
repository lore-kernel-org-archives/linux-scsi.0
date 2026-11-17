Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794912044;
	b=Sijtw694ZSJ0rkt2kK3iM+ZxOV5FM21Ypsu7DHC0mAIh3MnXkgJ00p6PBJgTZ5iq6u7X
	 mtxJmPXK/jc9s3Sm9pHb0F1yWo7t0asvOi5qiNYqmHsIn5K9VMLOatBIhkjtPdLA0UzXO
	 1iL7svW+aeqmCBrc6xpD7SaljqH2H4a6fZpBWzswDDyl605JA43LnaRjFcJGKkDKKpgZ+
	 FjsY9HUpaZbs94OFcEuOgmz+u2n6qDDIXROBCZXolN5JVepssCixkepexRMH9M+8To/Z2
	 s26amxSQWunyT35AVBWFmTs0YzTVik5HC3cRgSEuxPiNJdbwk4XNr9Gz/N24nI2gWvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794912044;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EeNCpptjr1gpGOMu3Dx6bpyw8hDkftyRMTrwJjygCQg=;
	b=ZJOaBBMEtxs98zXmXvealT6f0+NPgiAimX7MnahkLgqCl5/pEgZgTjxSBekLLl3Zsqnh
	 7szGPb0+psaKI5knnj5amoKudEB8QfHsB+wlsszJiZe7H2AV4mtZ23XQRqq7Glx+8xDWY
	 xV5pgelPrmgdShqmUuthv/pwSGB9mzRQVajjyFdp8YsH8d1Txifcp04K7J6PQNow2EFD4
	 E9FOBZB8VFkXzyDWzNVYIkwTQTONQON+CwyrjTM+UI0bFKlFZsegmv/RHdU/3+YhKGdUG
	 bIm1bWWTNVNkjhdDildulPXc//H7L57Mq8MARU5kikYsSSUHVTzgG+XzHtN8XOnzs/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZmBEeUsd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4A9606A31C
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 10:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZmBEeUsd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9B91F000C4;
	Tue, 17 Nov 2026 10:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794912044;
	bh=EeNCpptjr1gpGOMu3Dx6bpyw8hDkftyRMTrwJjygCQg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZmBEeUsdATtQLDTlTInWXL8KoV7GbakJfTKNSvAh9LO780BzvzyryIOK5yE1CeSpp
	 qZLnKcqZEPBeY913K454QfHI5OpvLcWwRezsSSn06yEsohXGIYt7vXoSOFGAzpMtlS
	 pcwXRXv1IXeIxwCgd/FI/sT/odH0vvOTphIFQNaSKw0SXH/vaiD9pjaRzGmB6ng7of
	 pzIaYH5c/u6wZyQ0EWpurfzbO8ST8kJda39ScrlWkA0jR6yUowqMQ5yARfZbW+z7do
	 r2iUpR939zj5j2qcnsJMCCaLH9RxR8iYhOEZvrXIq4f/AVFQ7xP7QUP1+3DHMzOKcp
	 julSX+sOaIH/A==
Message-ID: <sashiko-outbox-218654@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/4] scsi: libiscsi_tcp: do not accept a Data-In for
 a finished command
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261117101500.1894608-5-yhlee@isslab.korea.ac.kr>
References: <20261117101500.1894608-1-yhlee@isslab.korea.ac.kr>
 <20261117101500.1894608-5-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 10:40:44 +0000
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
- [High] scsi: libiscsi_tcp: UAF in iscsi_tcp_segment_done() after TMF
  response
- [Medium] scsi: libiscsi: incomplete task state check in
  __iscsi_complete_pdu()
--

commit 9af7de9bba715ed5449c628822a2ee292f1c78ed
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: libiscsi_tcp: do not accept a Data-In for a finished command

This commit rejects incoming Data-In PDUs in iscsi_tcp_hdr_dissect() when
the command task is not running and rejects completed tasks in
__iscsi_complete_pdu().

> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index af454454c0869..f8b3b597d0154 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1312,7 +1312,7 @@ int __iscsi_complete_pdu(struct iscsi_session *sess=
ion, struct iscsi_conn *conn,
>  	case ISCSI_OP_SCSI_CMD_RSP:
>  	case ISCSI_OP_SCSI_DATA_IN:
>  		task =3D iscsi_itt_to_ctask(session, conn, hdr->itt);
> -		if (!task)
> +		if (!task || task->state =3D=3D ISCSI_TASK_COMPLETED)
>  			return ISCSI_ERR_BAD_ITT;
>  		task->last_xfer =3D jiffies;
>  		break;

[Severity: Medium]
Should this test task->state !=3D ISCSI_TASK_RUNNING rather than only
ISCSI_TASK_COMPLETED?

iscsi_complete_task() also treats ISCSI_TASK_ABRT_TMF,
ISCSI_TASK_ABRT_SESS_RECOV, and ISCSI_TASK_REQUEUE_SCSIQ as terminal
states:

drivers/scsi/libiscsi.c:iscsi_complete_task() {
	if (task->state =3D=3D ISCSI_TASK_COMPLETED ||
	    task->state =3D=3D ISCSI_TASK_ABRT_TMF ||
	    task->state =3D=3D ISCSI_TASK_ABRT_SESS_RECOV ||
	    task->state =3D=3D ISCSI_TASK_REQUEUE_SCSIQ)
		return;

When iscsi_eh_abort() calls fail_scsi_task(session, task, DID_ABORT),
__fail_scsi_task() sets sc->result =3D DID_ABORT << 16 and transitions
task->state to ISCSI_TASK_ABRT_TMF, while the extra task reference held by
iscsi_eh_abort() keeps task->sc live across spin_unlock_bh(&session->frwd_l=
ock).
A late ISCSI_OP_SCSI_CMD_RSP arriving in that window passes this check and
runs iscsi_scsi_cmd_rsp(), overwriting sc->result with
(DID_OK << 16) | rhdr->cmd_status, writing sc->sense_buffer, and updating
the residual count before iscsi_complete_task() ignores the duplicate and
iscsi_put_task() hands the command back via scsi_done().

> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index 20ec3ba45067f..eeb853c6b66d4 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -713,7 +713,8 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct=
 iscsi_hdr *hdr)
>  	case ISCSI_OP_SCSI_DATA_IN:
>  		spin_lock(&session->back_lock);
>  		task =3D iscsi_itt_to_ctask(session, conn, hdr->itt);
> -		if (!task)
> +		/* The copy below outlives back_lock, so the command must be live. */
> +		if (!task || task->state !=3D ISCSI_TASK_RUNNING)
>  			rc =3D ISCSI_ERR_BAD_ITT;
>  		else
>  			rc =3D iscsi_tcp_data_in(conn, task);

[Severity: High]
Can tcp_conn->in.segment still dereference a freed scatterlist if a split
Data-In arrives right after a TMF response?

Unlike a SCSI Command Response, receiving ISCSI_OP_SCSI_TMFUNC_RSP in
iscsi_tmf_rsp() only sets session->tmf_state =3D TMF_SUCCESS and wakes
session->ehwait; it does not change the affected task's state under
session->back_lock.  The task remains in ISCSI_TASK_RUNNING until the EH
thread wakes up and runs fail_scsi_task() or fail_scsi_tasks(), which does
not suspend RX or reset tcp_conn->in.segment:

<softirq> (RX)                    SCSI EH thread
__iscsi_complete_pdu()
  iscsi_tmf_rsp()
    session->tmf_state =3D TMF_SUCCESS
    wake_up(&session->ehwait)
iscsi_tcp_hdr_dissect() (skb 1)
  task->state =3D=3D ISCSI_TASK_RUNNING
  iscsi_segment_seek_sg(...,
    sdb->table.sgl, ...)
  spin_unlock(&session->back_lock)
                                  iscsi_eh_abort()
                                    fail_scsi_task(..., DID_ABORT)
                                    iscsi_put_task(task)
                                      iscsi_free_task()
                                        scsi_done(sc) -> frees sgl
iscsi_tcp_recv_skb() (skb 2)
  iscsi_tcp_segment_done()
    accesses tcp_conn->in.segment.sg  <-- use-after-free

When the second skb of the Data-In arrives, iscsi_tcp_segment_done() reads
the freed scatterlist and copies payload data into freed pages.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117101500.1894=
608-1-yhlee@isslab.korea.ac.kr?part=3D4
