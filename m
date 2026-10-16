Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FBC42AD77
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 18:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792174777; cv=none; b=ZSIPOIQ+NFNv/WUjsU1FDzb80wQJjr60RkzUyLDz8hfw/onpht9D3DHDNNkYM1EHqALbm1rEVbCWsaqZPluMictdh/zTjpx2QnXgWxckvuL3Ovp89sP48KlCqCGmDvfCVv9wExyxPjRundFoMDpjU8FxxhCezLcXPUBj6Zf0NaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792174777; c=relaxed/simple;
	bh=1evFKOrmXUDEBLwBnHN7EwvxpyuGJwBT5AXcqQ1RzHg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WCKDn1mbiec4OreqpIDQ1NjLSXNSc5s2SdPJGsBF2VOUvBQMBciGaeGeJqxhJRXycydvEpSOGhYc/QFTISZ6KcR4HaMbWu/BcoTn4u3ry57engaglaFL2wXaq16dm5+Uy9yDRFV0CikzSta2E1J9U92cKDqra3ZBAA7PZN0YEyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gxmi48WG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cpcih5Tb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gxmi48WG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cpcih5Tb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792174775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UdkPrYJMoXNxnJJGpG2AJm7Q5jz36VYFDAVyz4PxPS0=;
	b=Gxmi48WGLB9k76IBa1UHampHIm9/hHpvR7Pjz2YKu4bX86mO24VbPsyqcKHfB/wXFbHdcr
	nHKKtfHfzpolvjNp1UH6667hp1eaKLjTedFuLps70fel4loCprUyhUgxVWAqyCy9p3wtKV
	MMQhoxUZg4LffXY3aCY+pG76BBQRvRw=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-570-_autMKaYNIuZAgqsljzFMw-1; Fri, 16 Oct 2026 18:19:32 +0000
X-MC-Unique: _autMKaYNIuZAgqsljzFMw-1
X-Mimecast-MFC-AGG-ID: _autMKaYNIuZAgqsljzFMw_1792174771
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5338ff2cf14so3346131cf.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 11:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792174771; x=1792779571; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UdkPrYJMoXNxnJJGpG2AJm7Q5jz36VYFDAVyz4PxPS0=;
        b=Cpcih5Tbt6ERqY/45PlQjA0P1ZQjPLtlL4p8HCjZbORM4K9h9WTqsdr3Q8U/R/z8DF
         B7YtdEiNXKggKsUAZvCZ57FwVXMFtFH9OT/q9ntJcUAP3mjBFV+ON2zat8FKbHHM/FaT
         oH8xFnKRk+08A7xPSSrG7oiSPTxU1rExPQJwYsDzkU5sjLtAxXNnWBMBCdph0PYMS/6v
         Tbd99TkU+ppY18exuiDoz/eljRlUbV0owZHQqCwcBu4f2E85V09EoubxXD5YvRv1mE+v
         5RmkVcndkMwaVehOEhRcjl4jNoKeVu7N1Uy8Ejr4CL+v7bP/jQyXkHalDSb0pxVquLhQ
         AuCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792174771; x=1792779571;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UdkPrYJMoXNxnJJGpG2AJm7Q5jz36VYFDAVyz4PxPS0=;
        b=uwVqEPXx/U3z5hd5f363HztOwpwdxA7KxxSiEuCjnYg2P4ZrAmwMecZP2VAR/9mk2X
         ARS/5rL4Lo0Mnuzsy7TMmZS7xAXn40v7tCmn+6iiqg3FWGewB+Xk1WuHwILK+4D6ClY7
         E/rGWK3NtWBXP3kcSakVqRB74rE393/HeKuAb4GGOI2ojPYbI5mEFxwAm6pOxFb4GzNy
         J7Qp34uJ0jYDmM6eVHxu2rpFP0ROVHvIYNJw3O77mzit9RlZx2BlUlQ/XqqYSF7Likfr
         FHL4aMAI/tuXicDVfhd1zxvsFE33yVAwF361H9CGEwIxVeqbbqNL7/O/i1tIGIc9Ezp2
         K1uQ==
X-Gm-Message-State: AFq9FYL6oqJcIQAhVORudYhA42hWkdzd6Rq7r3tzuaB52q2LN59EHjlX
	PAadhVSY+uxmimP6i+McdIOZAG+0j0GJdM/RSBP9RM/YY7J/1Dj5rWQSB5pBCPbiao4Z7/gyFZO
	invSbpeG7ZVnEwFF2NyYM8iA7g01qT+XKFPGhF5D3A2eV2RvPjK77BjbcGHdLsCc=
X-Gm-Gg: AYBFou39X9U9OLe+CbCO0BtfLsrjK7952L2FoM56qeU9R/8jaH0atcyuRwCkhukQrSp
	Pne0bGWCB0fquAluinpee+OuDI0diu0UWK7SDr6wV5hpEniDPaMOMpWhws/4mXMXXkMp+S90U/T
	UIitudSiG5yXWhFUg5TFjzHIQIEJ4mA1UXtAjXRfnFHxk3wnajUBR7rvtkxIAbWSonac2YnvKfY
	vXiu8yGtziDv4fnTPScxnSO8H90LC98uPDLLxeyy2gjuy/J8l1Trufb2e24nk853Gx9UIdnl/7h
	aOu4y+E8G86GzyBIHkCPuSJ9lvnl9YYmE2lfTh2zOWNGdAftRGIOBWaENqOdfvUfFqLMigSsuSf
	pD7aJYfq1HnJLprBtZov52rmzXha7nDzNjwop
X-Received: by 2002:a05:622a:4897:b0:533:9753:571c with SMTP id d75a77b69052e-53645f6fec2mr4914841cf.19.1792174771215;
        Fri, 16 Oct 2026 11:19:31 -0700 (PDT)
X-Received: by 2002:a05:622a:4897:b0:533:9753:571c with SMTP id d75a77b69052e-53645f6fec2mr4914251cf.19.1792174770601;
        Fri, 16 Oct 2026 11:19:30 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcbb27839sm28848796d6.35.2026.10.16.11.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 11:19:29 -0700 (PDT)
Message-ID: <4bff10e5c6fd926f81dd65b0373ea25e6c6a3d6d.camel@redhat.com>
Subject: Re: [PATCH v2 2/2] scsi: target: iscsi: Complete an aborted WRITE
 when a new R2T would be sent
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Date: Fri, 16 Oct 2026 14:19:29 -0400
In-Reply-To: <sashiko-outbox-174751@kernel.org>
References: <20261016175351.126373-1-loberman@redhat.com>
	 <20261016175351.126373-3-loberman@redhat.com>
	 <sashiko-outbox-174751@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-10-16 at 18:08 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider:
> - [High] iscsi: double completion due to incomplete CMD_T_ABORTED fix
> - [Medium] iscsi: data race on cmd->outstanding_r2ts during abort
> --
>=20
> commit 538cfb5a3bbcee47d2aa78e30d5cf64fe5bed2fe
> Author: Laurence Oberman <loberman@redhat.com>
>=20
> scsi: target: iscsi: Complete an aborted WRITE when a new R2T would
> be sent
>=20
> This commit adds a check for aborted commands in the DataOut
> processing
> path when a new R2T is requested. It ensures the command is safely
> completed using iscsit_complete_aborted_cmd() to claim the
> completion.
> This prevents a race condition where a connection drop could cause a
> double-completion of the aborted command.
>=20
> > diff --git a/drivers/target/iscsi/iscsi_target.c
> > b/drivers/target/iscsi/iscsi_target.c
> > index aab9237a67768..3dad7f69f3bae 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -1669,6 +1669,22 @@ iscsit_check_dataout_payload(struct
> > iscsit_cmd *cmd, struct iscsi_data *hdr,
> > =C2=A0	if ((rc =3D=3D DATAOUT_NORMAL) || (rc =3D=3D
> > DATAOUT_WITHIN_COMMAND_RECOVERY))
> > =C2=A0		return 0;
> > =C2=A0	else if (rc =3D=3D DATAOUT_SEND_R2T) {
> > +		/*
> > +		 * A new R2T would never be answered for an
> > aborted command.
> > +		 * The CMD_T_ABORTED handling in
> > __iscsit_check_dataout_hdr()
> > +		 * does not cover this: it only runs for DataOut
> > PDUs
> > +		 * belonging to R2Ts that were already issued, and
> > +		 * iscsit_dataout_update_r2t() has already
> > decremented
> > +		 * outstanding_r2ts for the burst that just
> > finished.=C2=A0 Guard
> > +		 * on outstanding_r2ts so that with
> > MaxOutstandingR2T > 1 the
> > +		 * completion is still left to the last R2T to
> > drain.
> > +		 */
> > +		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
> > +			if (cmd->outstanding_r2ts < 1)
>=20
> [Severity: High]
> This patch introduces iscsit_complete_aborted_cmd() to fix a double-
> completion
> race by safely claiming the completion. However, does this still
> leave two
> other paths vulnerable to the same issue?
>=20
> If cmd->outstanding_r2ts >=3D 1, the patch explicitly leaves completion
> to
> __iscsit_check_dataout_hdr(). But __iscsit_check_dataout_hdr() uses
> target_complete_cmd() directly without claiming the completion:
>=20
> __iscsit_check_dataout_hdr() {
> =C2=A0=C2=A0=C2=A0 ...
> 		if (se_cmd->transport_state & CMD_T_ABORTED) {
> 			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
> 			=C2=A0=C2=A0=C2=A0 --cmd->outstanding_r2ts < 1) {
> 				iscsit_stop_dataout_timer(cmd);
> 				target_complete_cmd(se_cmd,
> SAM_STAT_TASK_ABORTED);
> 			}
> =C2=A0=C2=A0=C2=A0 ...
> }
>=20
> Similarly, if the final payload for an aborted command is received in
> this
> function, it reaches DATAOUT_SEND_TO_TRANSPORT and calls
> target_execute_cmd(),
> which also queues the abort work without claiming the completion:
>=20
> iscsit_check_dataout_payload() {
> =C2=A0=C2=A0=C2=A0 ...
> 	} else if (rc =3D=3D DATAOUT_SEND_TO_TRANSPORT) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> 		target_execute_cmd(&cmd->se_cmd);
> 		return 0;
> =C2=A0=C2=A0=C2=A0 ...
> }
>=20
> Could a connection drop in either of these windows allow
> iscsit_release_commands_from_conn() to complete the command a second
> time,
> resulting in corruption of the target_completion_wq?
>=20
>=20
> [Severity: Medium]
> Is it safe to read cmd->outstanding_r2ts without holding cmd-
> >r2t_lock here?
>=20
> If iscsit_build_r2ts_for_cmd() encounters an allocation failure, the
> target
> core queues the command to qf_work_queue. The worker thread will
> retry
> building the R2T asynchronously via transport_write_pending_qf() ->
> iscsit_build_r2ts_for_cmd(), incrementing the counter under cmd-
> >r2t_lock:
>=20
> iscsit_build_r2ts_for_cmd() {
> =C2=A0=C2=A0=C2=A0 ...
> 		cmd->outstanding_r2ts++;
> 		first_r2t =3D 0;
>=20
> 		if (iscsit_add_r2t_to_list(cmd, offset, xfer_len, 0,
> 0) < 0) {
> =C2=A0=C2=A0=C2=A0 ...
> }
>=20
> If the command is aborted concurrently, the RX thread processing
> incoming
> DataOut PDUs will locklessly decrement the counter in
> __iscsit_check_dataout_hdr() and locklessly read it here. Could this
> concurrent non-atomic access cause lost updates, leading to a
> corrupted
> counter and a leaked command?
>=20
> > +				iscsit_complete_aborted_cmd(cmd);
> > +			return 0;
> > +		}
> > +
> > =C2=A0		iscsit_set_dataout_sequence_values(cmd);
> > =C2=A0		conn->conn_transport->iscsit_get_dataout(conn,
> > cmd, false);
> > =C2=A0	} else if (rc =3D=3D DATAOUT_SEND_TO_TRANSPORT) {

Both of these look like repeats or non-issues to me.

On the first: this is the same finding the review raised against patch
1
of v1, which I answered on that thread. The exposure in
__iscsit_check_dataout_hdr() and in the DATAOUT_SEND_TO_TRANSPORT path
into target_execute_cmd() is pre-existing - mainline calls
target_complete_cmd() unconditionally in
iscsit_release_commands_from_conn() today, so both are already
reachable
without this series. v2 does not widen them. I have offered to post a
separate patch routing those two sites through the claim, and that
offer
stands.

On the second: r2t_lock is indeed the lock for outstanding_r2ts, and
six
of the seven accesses in the subsystem hold it - the increment in
iscsit_build_r2ts_for_cmd(), the decrement in
iscsit_dataout_update_r2t(), and the three TMR sites. The one that does
not is the --cmd->outstanding_r2ts in __iscsit_check_dataout_hdr(),
which
is pre-existing and is the only unlocked read-modify-write of the
field.

The line this patch adds is a read, not an RMW, so it cannot contribute
to the lost update described. A stale read is also harmless here: if it
reads low, iscsit_complete_aborted_cmd() takes the claim and the later
completion in __iscsit_check_dataout_hdr() becomes a no-op; if it reads
high, the completion is left to that path or to connection teardown.
Exactly one completion happens either way, which is what the claim is
for.

Taking r2t_lock for the read would not help and cannot be done as
written: iscsit_complete_aborted_cmd() calls
iscsit_stop_dataout_timer(),
which sleeps in timer_delete_sync(), so the lock would have to be
dropped
before the completion and the value could change in that gap
regardless.

The inconsistent locking on that pre-existing decrement is a fair
observation and I will fold it into the follow-up patch for the two
unclaimed sites.

Given how much testing went into this set of two patches, 300 attempts
and was stable I am inclined to just make the v2 change and that's it.

Thanks
Laurence

