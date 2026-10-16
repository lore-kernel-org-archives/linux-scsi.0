Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE844A4400
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 12:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154794; cv=none; b=MXmChvU+r9VPkSxiMgJlbgnAx8uuDCqkUn8/C4325b0mUvIAZ1RZOBU87Vcm7OFIBAO4P+egMlW0YdBoRxsKQtV6MP0ysxgBhPOXTDO6P6iBpGz2nFeQqdju+HXmq924iAp22ByP68J1LP8Swxmt0tBu9H18UfZYlYHodcoigEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154794; c=relaxed/simple;
	bh=vIltqrhtG3fdcxt1zy5N+jmI+wWd2EFikeosnuR84v0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pDOaPa/XSsNoSwwo60HEf1bSxZX8R0Q6Qe5drHsvB/Wk7X31q2Qql6WuRPPp3/RyZuGsXxAN1gNIkXbDzsF4sVqnumK4Ob2H6rVzUW+HWXXE8r0v/M9jJgJwsQ2YlFgU8Ehqyp2RvxcdYuGhxYl3dsOD0nevofQvOFQVObUP49A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i2u5UBbU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fVvYXRyd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i2u5UBbU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fVvYXRyd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792154790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jXE5vMlJLDULz4QabdUZcN7zMUliDBSGHX5ZEXcYJUA=;
	b=i2u5UBbUk9o4R4tmmmbLJi1GAw/Os1H40Ni9lLSJPEyExmT1kIKs7+fSkx3LM9NvuUrmHc
	O6QuuXLsiiGcKYVH3wEJa8iczRKb0gMsdzIr2HxlRtIIIrJS/COBSYJ6/NJmj8f7t81hbi
	nxt3wzf7qvs3oUr4xb2u5ftL6aVlNvg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-UTn2cjfPPuiodJ5ginXqAw-1; Fri, 16 Oct 2026 12:46:29 +0000
X-MC-Unique: UTn2cjfPPuiodJ5ginXqAw-1
X-Mimecast-MFC-AGG-ID: UTn2cjfPPuiodJ5ginXqAw_1792154788
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93cc40759b2so1345803285a.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 05:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792154788; x=1792759588; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=jXE5vMlJLDULz4QabdUZcN7zMUliDBSGHX5ZEXcYJUA=;
        b=fVvYXRydkR18p6nqtrezQ0bchrrm4YbtTVsnMS+Px1ltfHtFDnjrjE0f4Mv+Ynespj
         G2IHv2KDzleyPwLxJv5rlcqp3cTggTRO3DvXEsvvNjaL0lfKhfpPOII+ehBks6fqRAud
         OuE/m4eNqfBuAdtVTr07MmZDRUePaavtWwEN90jE9GfKddijeNUsoyjOYBIwXg7BHscp
         oMOAAMeKmX8uZCvKMhk5UCA9yEqvbTb97HzxlztNnNLIPseRomOQ3T1Z2WFu6eMCZt7i
         osX3STLbHZqvAIpXm8KM/vEq6M0TYA73U+e5gw5fk4JKwXwqxjr55XTQzYPSvyQyTxHY
         7XEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792154788; x=1792759588;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jXE5vMlJLDULz4QabdUZcN7zMUliDBSGHX5ZEXcYJUA=;
        b=NdQFDTXQm4sLe+SCAqBpmbk7NbYBMKT3rM///7ZH9IYkspSdHPNVBVy4T1PU4T7xsn
         UqLzNxWWuE1xvnegE6nzf7V487LKydIcT6ev/CggDeFOjWUuzBOxg63C78T5O7o6749e
         zxQGa8AQRctSPpQDdqC4vcPgqfs5vPdHpCfGkodDWJxDK6hmGdmPE4STkrTFrjYcws6M
         BEEasYPOtgGKWGhZqPWv5RBL/wIb195RH47X7xEDsO8HQJREOxkrcvRDBftORHlZgdYl
         j5h1qGOTee2k4fXV0I1YRCX0XnLWZ//nS/zIhOCvCxbXmKuMcpSiLQ0r+DZvfXAW/rRV
         ZMnA==
X-Gm-Message-State: AFq9FYLaLrNulzVQDrVV66qRtLXL9W5kEVVOq7b/+O27WmJ8p8iJ48Ot
	up2ntEY56YE8Rc0L/MYS7yk+u1BjH1IMz+O4JMoYPJWgxAJ4mX4tRW/A8xywC3yEgRxxikoYTSY
	lXoIKdag/5o07SkFeToe3kyGH52/TYL/CaUJPU47KjGgq4wXHbrc3EWQoAmFQ+Gkw/AUOwmo=
X-Gm-Gg: AYBFou2pYvUTpI14pJXBqPHMg2I7qnZ8bl46hA7MFgJ+Hp6ZlSOAGXkFfb6KZwbMxWq
	ZMSqWItjywJ7ENeiK6F3egBVpfuHbH6ad/eLVLXk6Ou3H5mxSgAxCIUY2XUYqags8Zi3jKvvSje
	0YrcOYFeudA7gBRd0DbsLd9ZjhDp5f+R2bNCfbliiSYdDlRoKYLYNoDUSiMuCb340mj2B4ebEl8
	FHDijKs5jWAyMDiSq2YQXbQ9o5xBAAerWf30kiPMc5nkFjnkiZ2TW9ErIYSmnKR6C7ldpoMebR2
	jHosvkSmYv0BPmRPbi2WqIbmwhsmb+WMLxt+rASLalxZ8xI6px86ovO6IjYs7nFTNTwczZ+QxVg
	tIM4Ur7t0ZT2YShtMsmGwUEaMLMcMfPg8/TA=
X-Received: by 2002:a05:620a:198d:b0:93e:66db:69b9 with SMTP id af79cd13be357-93ebd23ab8emr3416424685a.55.1792154788381;
        Fri, 16 Oct 2026 05:46:28 -0700 (PDT)
X-Received: by 2002:a05:620a:198d:b0:93e:66db:69b9 with SMTP id af79cd13be357-93ebd23ab8emr3416418785a.55.1792154787746;
        Fri, 16 Oct 2026 05:46:27 -0700 (PDT)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([2600:6c65:2440:d8c:929c:b769:6def:faa3])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a16b5e4sm201356085a.14.2026.10.16.05.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 05:46:26 -0700 (PDT)
Message-ID: <8e325cc7ca21d607b3664debcaa5f14b273b91b6.camel@redhat.com>
Subject: Re: [PATCH 1/2] scsi: target: iscsi: Complete an aborted WRITE
 stuck before the first R2T
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Date: Fri, 16 Oct 2026 08:46:25 -0400
In-Reply-To: <sashiko-outbox-171458@kernel.org>
References: <20261014143932.39453-1-loberman@redhat.com>
	 <20261014143932.39453-2-loberman@redhat.com>
	 <sashiko-outbox-171458@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-10-14 at 15:10 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> - [High] iscsi: double completion and workqueue corruption for
> aborted WRITEs on DataOut path
> --
>=20
> commit 7b04f6989363db2c2b75d8c212ee852153982c8d
> Author: Laurence Oberman <loberman@redhat.com>
> =C2=A0=C2=A0=C2=A0=20
> scsi: target: iscsi: Complete an aborted WRITE stuck before the first
> R2T
>=20
> This patch resolves an issue where an aborted WRITE command that
> arrives with
> immediate data exceeding FirstBurstLength gets stuck in
> TRANSPORT_WRITE_PENDING.
> It accomplishes this by completing the command in
> iscsit_execute_cmd() and
> introducing a new iscsit_claim_completion_locked() helper to avoid a
> double
> completion race with iscsit_release_commands_from_conn().
>=20
> > diff --git a/drivers/target/iscsi/iscsi_target.c
> > b/drivers/target/iscsi/iscsi_target.c
> > index 124ff269b8e75..aab9237a67768 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -4198,10 +4198,18 @@ static void
> > iscsit_release_commands_from_conn(struct iscsit_conn *conn)
> > =C2=A0		if (cmd->se_cmd.t_state =3D=3D
> > TRANSPORT_WRITE_PENDING) {
> > =C2=A0			/*
> > =C2=A0			 * We never submitted the cmd to LIO core,
> > so we have
> > -			 * to tell LIO to perform the completion
> > process.
> > +			 * to tell LIO to perform the completion
> > process --
> > +			 * unless iscsit_execute_cmd() already
> > did.=C2=A0 t_state
> > +			 * stays TRANSPORT_WRITE_PENDING across
> > that
> > +			 * completion, so the claim is the only
> > thing that can
> > +			 * tell us.
> > =C2=A0			 */
> > +			bool claimed =3D
> > iscsit_claim_completion_locked(cmd);
> > +
> > =C2=A0			spin_unlock_irq(&se_cmd->t_state_lock);
> > -			target_complete_cmd(&cmd->se_cmd,
> > SAM_STAT_TASK_ABORTED);
> > +			if (claimed)
> > +				target_complete_cmd(&cmd->se_cmd,
> > +						=C2=A0=C2=A0=C2=A0
> > SAM_STAT_TASK_ABORTED);
>=20
> [Severity: High]
> Does this code miss the DataOut paths?
>=20
> Because target_complete_cmd() is called directly in
> __iscsit_check_dataout_hdr()
> and target_execute_cmd() is called in iscsit_check_dataout_payload()
> for aborted
> commands without setting the completion_claimed flag.
>=20
> If a command is aborted on the DataOut path:
>=20
> drivers/target/iscsi/iscsi_target.c:__iscsit_check_dataout_hdr() {
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
> Because completion_claimed is never set, target_complete_cmd()
> delegates
> to target_cmd_interrupted() which queues target_abort_work but leaves
> the command in TRANSPORT_WRITE_PENDING.
>=20
> If the connection drops before target_abort_work removes the command
> from the connection list, iscsit_release_commands_from_conn() will
> find it,
> iscsit_claim_completion_locked() will return true, and it will call
> target_complete_cmd() a second time.
>=20
> Can this double call to target_complete_cmd() cause
> target_cmd_interrupted()
> to re-initialize and re-queue cmd->work while it is already pending
> on the
> workqueue, leading to workqueue linked-list corruption and a use-
> after-free
> when target_handle_abort() runs twice?
>=20
>=20
Thanks for the review. I verified the mechanism and it is accurate:
target_cmd_interrupted() queues target_abort_work and returns true, and
target_complete_cmd_with_sense() then returns before reaching the
"cmd->t_state =3D TRANSPORT_COMPLETE; cmd->transport_state |=3D
CMD_T_COMPLETE" block. The command is left in TRANSPORT_WRITE_PENDING
with nothing recorded to say it has been completed. The window is also
not narrow: iscsit_release_commands_from_conn() holds conn->cmd_lock
across its entire walk and iscsit_aborted_task() needs that same lock
to
unlink, so if the work item has not run yet, teardown is guaranteed to
see the command rather than merely likely to.

Your point about target_execute_cmd() is correct as well, and worth
spelling out: it calls target_cmd_interrupted() before setting
cmd->t_state =3D TRANSPORT_PROCESSING, so an aborted command taking the
DATAOUT_SEND_TO_TRANSPORT path also stays in TRANSPORT_WRITE_PENDING.

However, this exposure is pre-existing rather than introduced here.
Mainline at that site today is:

	if (cmd->se_cmd.t_state =3D=3D TRANSPORT_WRITE_PENDING) {
		spin_unlock_irq(&se_cmd->t_state_lock);
		target_complete_cmd(&cmd->se_cmd,
SAM_STAT_TASK_ABORTED);
		continue;
	}

The call is unconditional, so a command already completed by
__iscsit_check_dataout_hdr() or by target_execute_cmd() is completed a
second time by teardown as the code stands. This patch gates that call
on the claim, and for a command arriving from either of those paths the
claim succeeds, because neither path claims. Behaviour for them is
therefore identical to mainline. The only change is that the site this
patch adds in iscsit_execute_cmd() can no longer be double-completed.

So the patch removes one reachable double completion and adds none. I
would rather not extend it to cover the two pre-existing sites: this
series has 300 reset cycles of customer validation behind it on a
reproducer that previously failed at 95 and 196 cycles, and widening it
would mean shipping code that validation never exercised. I am happy to
post a separate patch for the pre-existing paths, on its own merits.

The companion finding against patch 2 is a real defect introduced by
this series and I am fixing it in v2.

Thanks
Laurence

