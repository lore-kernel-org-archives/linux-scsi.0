Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795194294;
	b=PZOnbHhfdnZ+YYCi9IKzt3htOXFFMYXe9KZOcrZJAcplFF0FxPM2vd80EKNcMhYoEvBj
	 /VB+LjU2eG/5NRq5IAaTkCja7uP7fuc2qvbHmsiqpEC+rh6E+coFCmtbjSGnzt9zvYLOn
	 hf/Ruk4qirUx6Maz0bld8RVtzMkqhXJxQ9k4IfnKbnpeAUCjGHTtPU+VaHrEOQVUJPUlO
	 XJoPiZtSly+hcA+3QthDXi4B8Rp6Cx1yvjIuNRngwPVjftEzgH1/pHZym7TRKKBMvI2+N
	 Y2je1r/jk/08EPqg9zekI6k2Geg3/wYcplUeB4dQunt4J+50afG1htZ9GU6RYd5L0iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795194294;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lipKnOabSwNopL+AKimMQzEMNNxz3J3CxJ5cwaUh5dE=;
	b=00HF7FXduTh96cSwOzp8tbtKhe25HZyEWhSLqUdhWoygNP0mxfWJd2LZ8azZOsonlyIn
	 RS0tKlJP5ZaejQ01pB18LrBbG55udMoY3qBOZWvGK+YbmW+jnTQh0gDZUaAMdw7L/1RHx
	 dzbWnbw2F4CxdxgWSp5myL2KBCTJWPywdX61s38xou2wWzOxsBJpcW+OMiT+tnQr8pSWF
	 10ALHiWDujr0jcYM5fvZsbQh3iCNJtHmBhyYyEhFpThH+SB7WMbPn68QOU9+ZNn8ev/j3
	 D0yUc7IuYJhxprRUMeMy/Kdne+s7heXbZeuLYbgafm6K0WWthBk9F3UQ7MQd3JYkjAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PWrc+g86;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75133606A32C
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 17:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PWrc+g86
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6610C1F000CF;
	Fri, 20 Nov 2026 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795194293;
	bh=lipKnOabSwNopL+AKimMQzEMNNxz3J3CxJ5cwaUh5dE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PWrc+g869Y1LbXuth2UK//zRIAwV/t9hixuIHULSzMcXw8wQ7Cgdo0SqXoFGtdIwC
	 5gnJq2AIVU1hf6P7FuOvRAD0s2m5+Z/o7Y2LW4m5ESPdTdhpQu8CkZXRwi3HRBeWIl
	 pTDjeBpBF1xeg8NuskbfcbjLJRyEqeBmKVdoOnjI5iiD/h/rAMj02Ybn6ccRZaPL90
	 1pOok3Ol2jGWBbvfiRH1EZOzew3B5rW+XfW+syNkG2Powiik44ZK0r7zAA6Y36OUiC
	 w5Gx+swsvDB6zTQ5nXycFwImCtcjs9kO3kT1P70yofBzzdmzk/bjAobH9G4ONFADLp
	 aHubyr6lSBnNA==
Message-ID: <sashiko-outbox-225621@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: libiscsi_tcp: hold back_lock across the copy
 of a Data-In
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261120163857.3238489-1-yhlee@isslab.korea.ac.kr>
References: <20261120163857.3238489-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 17:04:52 +0000
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
- [High] scsi: libiscsi_tcp: race on datain_task after dropping
  back_lock before done()
- [High] scsi: libiscsi_tcp: missing ISCSI_TASK_RUNNING check in
  iscsi_tcp_hdr_dissect()
--

commit 097a9fd448317fa2b4383365f5467a826e8080ac
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: libiscsi_tcp: hold back_lock across the copy of a Data-In

This commit records the active Data-In task in tcp_conn->in.datain_task,
clears it in iscsi_tcp_cleanup_task(), and holds session->back_lock
across the skb copy in iscsi_tcp_recv_skb() to prevent copying into a
freed scatterlist when error handling fails the command.

> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index 20ec3ba45067f..0f0ce902bdc5f 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
[ ... ]
> @@ -744,6 +752,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct=
 iscsi_hdr *hdr)
>  				      tcp_task->data_offset,
>  				      tcp_conn->in.datalen);
>  			task->last_xfer =3D jiffies;
> +			tcp_conn->in.datain_task =3D task;
>  			rc =3D iscsi_segment_seek_sg(&tcp_conn->in.segment,
>  						   sdb->table.sgl,
>  						   sdb->table.nents,

[Severity: High]
Can iscsi_tcp_hdr_dissect() aim tcp_conn->in.datain_task and
tcp_conn->in.segment at a task that is not in ISCSI_TASK_RUNNING?

In this tree, neither iscsi_itt_to_ctask() nor iscsi_tcp_hdr_dissect()
checks task->state =3D=3D ISCSI_TASK_RUNNING.  When a new command is queued
in iscsi_queuecommand() -> iscsi_alloc_task(), its preallocated slot has
a valid task->sc and matching session->age while sitting on
conn->cmdqueue in ISCSI_TASK_PENDING.

If a stray Data-In header arrives for that ITT before iscsi_data_xmit()
runs, iscsi_tcp_hdr_dissect() points tcp_conn->in.datain_task and
tcp_conn->in.segment at the pending command's scatterlist; once
iscsi_prep_scsi_cmd_pdu() transitions the task to ISCSI_TASK_RUNNING,
iscsi_tcp_recv_skb() will see a running datain_task and copy the stale
payload into the new command's buffer.  If the pending task on cxgbi is
 instead aborted or failed before cxgbi_conn_alloc_pdu() sets
tcp_task->dd_data, cxgbi_cleanup_task() returns early without calling
iscsi_tcp_cleanup_task(), leaving tcp_conn->in.datain_task dangling and
allowing a subsequent command in that slot to copy into the freed
scatterlist.  Furthermore, a zero-length Data-In with
ISCSI_FLAG_DATA_STATUS calls __iscsi_complete_pdu() directly from
iscsi_tcp_hdr_dissect(), freeing an ISCSI_TASK_PENDING task while it
remains linked on conn->cmdqueue (causing a NULL task->sc dereference in
iscsi_prep_scsi_cmd_pdu()) or overwriting sc->result with DID_OK on an
ISCSI_TASK_ABRT_TMF task.

[ ... ]
> @@ -925,38 +980,36 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, str=
uct sk_buff *skb,
>  		return 0;
>  	}
> =20
> -	if (offloaded) {
> -		segment->total_copied =3D segment->total_size;
> -		goto segment_done;
> -	}
> -
> -	skb_prepare_seq_read(skb, offset, skb->len, &seq);
> -	while (1) {
> -		unsigned int avail;
> -		const u8 *ptr;
> +	/*
> +	 * Hold back_lock across a Data-In copy so the command cannot be
> +	 * given back while it runs.  _bh: this also runs from a work item.
> +	 */
> +	if (segment->sg) {
> +		struct iscsi_task *task;
> =20
> -		avail =3D skb_seq_read(consumed, &ptr, &seq);
> -		if (avail =3D=3D 0) {
> -			ISCSI_DBG_TCP(conn, "no more data avail. Consumed %d\n",
> -				      consumed);
> -			*status =3D ISCSI_TCP_SKB_DONE;
> -			goto skb_done;
> +		spin_lock_bh(&session->back_lock);
> +		task =3D tcp_conn->in.datain_task;
> +		if (!task || task->state !=3D ISCSI_TASK_RUNNING) {
> +			spin_unlock_bh(&session->back_lock);
> +			iscsi_conn_printk(KERN_ERR, conn,
> +					  "Data-In for a command that is gone\n");
> +			*status =3D ISCSI_TCP_CONN_ERR;
> +			iscsi_conn_failure(conn, ISCSI_ERR_BAD_ITT);
> +			return 0;
>  		}
> -		BUG_ON(segment->copied >=3D segment->size);
> -
> -		ISCSI_DBG_TCP(conn, "skb %p ptr=3D%p avail=3D%u\n", skb, ptr,
> -			      avail);
> -		rc =3D iscsi_tcp_segment_recv(tcp_conn, segment, ptr, avail);
> -		BUG_ON(rc =3D=3D 0);
> -		consumed +=3D rc;
> +		consumed =3D iscsi_tcp_copy_skb(conn, skb, offset, offloaded,
> +					      &segment_done);
> +		spin_unlock_bh(&session->back_lock);
> +	} else {
> +		consumed =3D iscsi_tcp_copy_skb(conn, skb, offset, offloaded,
> +					      &segment_done);
> +	}
> =20
> -		if (segment->total_copied >=3D segment->total_size) {
> -			skb_abort_seq_read(&seq);
> -			goto segment_done;
> -		}
> +	if (!segment_done) {
> +		*status =3D ISCSI_TCP_SKB_DONE;
> +		goto skb_done;
>  	}
> =20
> -segment_done:
>  	*status =3D ISCSI_TCP_SEGMENT_DONE;
>  	ISCSI_DBG_TCP(conn, "segment done\n");
>  	rc =3D segment->done(tcp_conn, segment);

[Severity: High]
Can dropping session->back_lock before segment->done() let
iscsi_tcp_process_data_in() complete an aborted or reused task in the
same slot?

When segment->done() runs iscsi_tcp_process_data_in() for a Data-In PDU
with ISCSI_FLAG_DATA_STATUS set, it never checks
tcp_conn->in.datain_task; instead, it calls iscsi_complete_pdu() ->
__iscsi_complete_pdu(), which re-acquires session->back_lock and looks up
hdr->itt afresh via iscsi_itt_to_ctask().  Because the error handler was
spinning on session->back_lock while the final skb was being copied, it
acquires session->back_lock as soon as the copy unlocks it:

CPU0                                  CPU1
iscsi_tcp_recv_skb()
  spin_lock_bh(&session->back_lock)
  iscsi_tcp_copy_skb()
                                      iscsi_eh_abort()
                                        fail_scsi_task()
                                          spin_lock_bh(&session->back_lock)
  spin_unlock_bh(&session->back_lock)
                                          sc->result =3D DID_ABORT << 16
                                          task->state =3D ISCSI_TASK_ABRT_T=
MF
                                          spin_unlock_bh(&session->back_loc=
k)
  segment->done()
    iscsi_tcp_process_data_in()
      iscsi_complete_pdu()
        __iscsi_complete_pdu()
          iscsi_itt_to_ctask()
          iscsi_data_in_rsp()
            sc->result =3D (DID_OK << 16) | ...
            <-- overwrites DID_ABORT
                                        iscsi_put_task(task)
                                          iscsi_free_task()
                                            scsi_done(sc)

If fail_scsi_tasks() (or iscsi_eh_abort() after iscsi_put_task()) frees
the task during that window and iscsi_queuecommand() reuses the slot for
a new command before iscsi_complete_pdu() takes session->back_lock,
__iscsi_complete_pdu() will look up hdr->itt and complete the new
command instead (freeing it while still on conn->cmdqueue if it is in
ISCSI_TASK_PENDING, or completing it prematurely with the old Data-In's
status if it is already running).

Also, when software data digests are enabled,
iscsi_tcp_segment_splice_digest() sets segment->sg =3D NULL before
receiving the 4-byte digest.  If the digest arrives in a subsequent skb
after the task has been cleaned up, iscsi_tcp_recv_skb() sees
segment->sg =3D=3D NULL, skips both session->back_lock and the
tcp_conn->in.datain_task check, and runs iscsi_tcp_process_data_in().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120163857.3238=
489-1-yhlee@isslab.korea.ac.kr?part=3D1
