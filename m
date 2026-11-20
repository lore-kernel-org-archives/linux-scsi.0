Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795187756;
	b=eG+YRBYDNdnmVoDtFTkXHJ5itB4fDvqyHR9mzKhRr5nRxVYFKvwHGygjl8O2WCsYGeTC
	 Kn9bvsjS/saGzViMpt3wyeTscM5zdNwthisXux1j3jdx3aWHaJguxTVyXNbvYej0fi81t
	 FhHHOVaTQC8gSgL+zgSkQO7o0rK34scCGDimaXGoyhd2o7CFryj+OEt7paNGrqFx6MNwL
	 zeNoySauVHKWJs9kdBw7jpo/NvSsnB6afoop8llNM5XwvTKewnbnr1VAZ3Rb8KWogPVUs
	 RnRQsgrch+DyxPsL8bQE+5XcTAMAbzAlPwVfU3FxKGBVgCIRV2StfKqKqttEzYG7X8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795187756;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8IVbOtQKINxok/AHXyWw8Kn4mtW+qPe/6N5Mky8Oq30=;
	b=5P+zaZ8IfLE5atJW/bWPACpPvYjiiDnG6SVoxAkETc6uIql+09bbLmUWkRQkks1bxHKc
	 8gCNs6jOpqwxeFVPhuZ0VY9EH5j/dOoWFCrypb4fM0ao+QAoodcIsgXY4+c12vKCPP19e
	 /6kmC9EraL6+MLEY5NV+Zsx5ZAxC2/8nRU4wlMHz/ga9t5x+/teS1pbW0LBNxtn2NZqL8
	 88fwxQEYNBONsVZg0lT6zOjB7lK6VTOA5YzpqzoVAz+uU8SHfkK4dNn22Xs7hu9ALnCIY
	 kYffuLBdmbn41gz6vhPjoyckutfDi1+VyiFbEGn1WkaWiTuamG8g5CdnLd8WnvRTbqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UCj1yT+e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115AE606A333
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UCj1yT+e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA31D1F000E6;
	Fri, 20 Nov 2026 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795187755;
	bh=8IVbOtQKINxok/AHXyWw8Kn4mtW+qPe/6N5Mky8Oq30=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UCj1yT+eCr/ti9AU8UubzkgrCUaB+JJru6HTTUw07kNhnOSFso5H1+U2iFTiadZ+P
	 Z1+JaAHPGFKNt3IQFJI4cDkMYBGYi59p2E78u9d2Ol+fZ3X3jVPidVm4inMpe6N3xS
	 qxp3sL5Vi1pvp7qFSf7Kh1kTpILdme51sQHTumT4oNfNyp6oCBg61CnQGAjQHpw6cD
	 C+kDGNehBTfbIedWa+r7mFFg3FkoAD99QnLzOqNbt1KGvT2Rbh3ZxnGFya0CMmTMDn
	 ymiAkSyJRnbwP3L9khM6wy0nB3I1VzM+zcwFFR8OLB4PEqGyoGJE0P6LfLlmOVylc1
	 htp+aZ66z0GOg==
Message-ID: <sashiko-outbox-225445@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: libiscsi_tcp: hold back_lock across the copy of a
 Data-In
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261120145243.3124991-1-yhlee@isslab.korea.ac.kr>
References: <20261120145243.3124991-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 15:15:55 +0000
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
- [High] scsi: libiscsi_tcp: race on ITT slot reuse in
  iscsi_tcp_process_data_in()
- [High] scsi: libiscsi_tcp: kmap_atomic() held across back_lock unlock
  at skb_done
- [High] scsi: libiscsi_tcp: missing ISCSI_TASK_RUNNING check in
  iscsi_tcp_hdr_dissect()
- [Low] scsi: libiscsi_tcp: Clang context-analysis warning in
  iscsi_tcp_recv_skb()
--

commit 137946721880763b95233f1c2f065be24dc7e099
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: libiscsi_tcp: hold back_lock across the copy of a Data-In

This commit tracks the active Data-In task in tcp_conn->in.datain_task and
holds session->back_lock across the Data-In scatterlist copy in
iscsi_tcp_recv_skb() so that error handlers cannot free the command's
scatterlist while the copy is in progress.

> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index 20ec3ba45067f..50c58e938321e 100644
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
Should iscsi_tcp_hdr_dissect() verify that task->state =3D=3D
ISCSI_TASK_RUNNING before accepting a Data-In header and setting
tcp_conn->in.datain_task?

iscsi_itt_to_ctask() only checks task->sc and session->age, so it also
returns newly queued commands in ISCSI_TASK_PENDING on conn->cmdqueue.  If
a stray Data-In header arrives for a slot occupied by a pending command and
iscsi_prep_scsi_cmd_pdu() transitions that command to ISCSI_TASK_RUNNING
before the payload skb arrives, iscsi_tcp_recv_skb() sees the matching
datain_task in ISCSI_TASK_RUNNING and copies the stale Data-In payload into
the new command's scatterlist.  In addition, a zero-length Data-In with
ISCSI_FLAG_DATA_STATUS calls __iscsi_complete_pdu() right below without
ever reaching iscsi_tcp_recv_skb(), freeing an ISCSI_TASK_PENDING task
while it is still linked on conn->cmdqueue and causing a NULL task->sc
dereference in iscsi_prep_scsi_cmd_pdu().

> @@ -907,8 +916,10 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, stru=
ct sk_buff *skb,
>  {
>  	struct iscsi_tcp_conn *tcp_conn =3D conn->dd_data;
>  	struct iscsi_segment *segment =3D &tcp_conn->in.segment;
> +	struct iscsi_session *session =3D conn->session;
>  	struct skb_seq_state seq;
>  	unsigned int consumed =3D 0;
> +	bool copy_locked =3D false;
>  	int rc =3D 0;
> =20
>  	ISCSI_DBG_TCP(conn, "in %d bytes\n", skb->len - offset);
> @@ -925,6 +936,26 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, stru=
ct sk_buff *skb,
>  		return 0;
>  	}
> =20
> +	/*
> +	 * Hold back_lock across a Data-In copy so the command cannot be
> +	 * given back while it runs.  _bh: this also runs from a work item.
> +	 */
> +	if (segment->sg) {
> +		struct iscsi_task *task;
> +
> +		spin_lock_bh(&session->back_lock);
> +		task =3D tcp_conn->in.datain_task;
> +		if (!task || task->state !=3D ISCSI_TASK_RUNNING) {
> +			spin_unlock_bh(&session->back_lock);
> +			iscsi_conn_printk(KERN_ERR, conn,
> +					  "Data-In for a command that is gone\n");
> +			*status =3D ISCSI_TCP_CONN_ERR;
> +			iscsi_conn_failure(conn, ISCSI_ERR_BAD_ITT);
> +			return 0;
> +		}
> +		copy_locked =3D true;
> +	}
> +
>  	if (offloaded) {
>  		segment->total_copied =3D segment->total_size;
>  		goto segment_done;
> @@ -957,6 +988,10 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, stru=
ct sk_buff *skb,
>  	}
> =20
>  segment_done:
> +	if (copy_locked) {
> +		spin_unlock_bh(&session->back_lock);
> +		copy_locked =3D false;
> +	}
>  	*status =3D ISCSI_TCP_SEGMENT_DONE;
>  	ISCSI_DBG_TCP(conn, "segment done\n");
>  	rc =3D segment->done(tcp_conn, segment);

[Severity: High]
Can dropping session->back_lock before segment->done() let
iscsi_tcp_process_data_in() complete a newly queued command that reuses
the freed ITT slot?

CPU0 (softirq)                    CPU1 (EH / queuecommand)
iscsi_tcp_recv_skb()
  spin_lock_bh(&back_lock)
  iscsi_tcp_segment_recv()
  spin_unlock_bh(&back_lock)
                                  iscsi_eh_device_reset()
                                    fail_scsi_tasks()
                                      spin_lock_bh(&back_lock)
                                      iscsi_free_task()
                                        datain_task =3D NULL
                                      spin_unlock_bh(&back_lock)
                                  iscsi_queuecommand()
                                    /* reuses the same ITT slot */
  segment->done()
    iscsi_tcp_process_data_in()
      iscsi_complete_pdu()
        spin_lock(&back_lock)
        iscsi_itt_to_ctask()
        iscsi_complete_task()     <-- completes the new command

When ISCSI_FLAG_DATA_STATUS is set on the Data-In header,
iscsi_tcp_process_data_in() calls iscsi_complete_pdu() without checking
tcp_conn->in.datain_task, so __iscsi_complete_pdu() looks up hdr->itt
afresh via iscsi_itt_to_ctask().  If the new command is still in
ISCSI_TASK_PENDING on conn->cmdqueue, completing it frees the task and sets
task->sc =3D NULL while it stays linked on conn->cmdqueue, causing a NULL
pointer dereference in iscsi_prep_scsi_cmd_pdu().  Also, when software data
digests are enabled, iscsi_tcp_segment_splice_digest() sets
segment->sg =3D NULL before receiving the 4-byte digest, so a subsequent skb
carrying the digest skips the if (segment->sg) check and reaches
segment->done() after the task was already freed.

> @@ -969,6 +1004,8 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, stru=
ct sk_buff *skb,
>  	/* The done() functions sets up the next segment. */
> =20
>  skb_done:
> +	if (copy_locked)
> +		spin_unlock_bh(&session->back_lock);
>  	conn->rxdata_octets +=3D consumed;
>  	return consumed;
>  }

[Severity: High]
Does unlocking session->back_lock at skb_done leave segment->sg_mapped
mapped with kmap_atomic()?

When an skb ends before the Data-In payload is finished,
iscsi_tcp_segment_done() calls iscsi_tcp_segment_map(), which calls
kmap_atomic(sg_page(sg)), and the unmap does not happen until
iscsi_sw_tcp_recv_data() finishes tcp_read_sock():

drivers/scsi/libiscsi_tcp.c:iscsi_tcp_segment_done() {
	...
	segment->copied +=3D copied;
	if (segment->copied < segment->size) {
		iscsi_tcp_segment_map(segment, recv);
		return 0;
	}
	...
}

On a multi-skb Data-In, skb_done releases session->back_lock while
kmap_atomic() is still active, allowing an error handler on another CPU to
free the command and its scatterlist pages while segment->sg_mapped remains
mapped, and the next skb in tcp_read_sock() then calls
spin_lock_bh(&session->back_lock) while inside kmap_atomic() /
pagefault_disable() (which violates sleeping spinlock rules on
CONFIG_PREEMPT_RT).

[Severity: Low]
Does the conditional locking across copy_locked trigger a Clang
-Wthread-safety-analysis warning when CONFIG_WARN_CONTEXT_ANALYSIS=3Dy?
drivers/scsi/Makefile enables CONTEXT_ANALYSIS :=3D y, and Clang's thread
safety analyzer does not track boolean lock flags across basic blocks.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120145243.3124=
991-1-yhlee@isslab.korea.ac.kr?part=3D1
