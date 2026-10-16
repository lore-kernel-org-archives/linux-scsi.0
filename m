Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF06A4A482F
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 12:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154871; cv=none; b=uZJGm++KEc90KYqN4sL2TUlzPAM2e6AAEhL1qDutruhf9tL4XzPaS7n+vG1LjRY3EmEofeLSLlmwvF1sd72URmYF/ZzCWc9S04HelGNPuN/E95e7fL24MvQgaHHMy4ESOTpDtYqi7ZRtkeG69e8k7vqDtx9tA3W/8OAfI9VTqTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154871; c=relaxed/simple;
	bh=RtR2kz7qz30JVH45MnZuD7Tt4pcBoGmgqSHzEiVw1To=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lzrtY+HXLUaX/7xja0Ug1gQ5BwkQfQ9ej3F4o5NuHJF3FWZ/bq8fkZ7XqOASreTphKSK5z3RC2c3R7SZ+P3rQ/Q9a8EPUmm7ig+ENWxCeU0OJzNzBHSzmvQStIN9x+EfVL+8Qe49Z3ZTkzpZMNl1kQvPqRHmWNugLyate7PMNe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CkSggiiy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IfUdHryv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CkSggiiy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IfUdHryv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792154868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Vb6qcm8agLiGe0PZ+zUn2KiSsmzJFEb3kjQ/6YcLrk=;
	b=CkSggiiy6VxAHx+nYtT6vvEGW5C44VAsVZmRuDukVNsHCkubb880gNaNEBgMhdUpUqH5YC
	jANWkYayIK8/7hqw1WsBJTnmw84bU2eyCU8K8wMGRD5Cpmpxth6u34ZfEFVhcVeydOxEYJ
	wWRocW2yAMr1Up7XHgpMVYPMafCUkCw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-TvO_2tq-OzGHdwLV5a6_Aw-1; Fri, 16 Oct 2026 12:47:47 +0000
X-MC-Unique: TvO_2tq-OzGHdwLV5a6_Aw-1
X-Mimecast-MFC-AGG-ID: TvO_2tq-OzGHdwLV5a6_Aw_1792154867
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91961d4b31bso131666576d6.0
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 05:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792154867; x=1792759667; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=3Vb6qcm8agLiGe0PZ+zUn2KiSsmzJFEb3kjQ/6YcLrk=;
        b=IfUdHryvLHM94XR9hXGcI7uPxKAIFaazI5Iz8ZHrsvVVYiRODSLoLQgNaMj5NbAMn2
         p4oWsGvFK1oCV15HwumNTqRCoihlEuZCbeS7zJrMzdytKR+fuIgNV7+UwlNxipcxk+/v
         KJq4A7JLSGWVJ/v5kF25DnugXZgx0DNMClUXj/Rxoc7FpnZCJpby8ixcJ6Z7VZAnbE2r
         1ZtBbW1BElWhJmlB5lAGk4GlIOuVEUpTPldEdwmhHzSwfAkYL/+wDbJnn4q2zqt35k7I
         NeqVaDZfzjkph0WbdY8lKQnR3BV7ZjV97SIvRydPaZdf2n1rwpiqg1KgkFfh/To8aTzo
         6lzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792154867; x=1792759667;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Vb6qcm8agLiGe0PZ+zUn2KiSsmzJFEb3kjQ/6YcLrk=;
        b=yJlQRch/BVRPWEKrlxKpciP1ynEWDLOt1YAhPJAOMEWTUqJtIQ9BDdZ6rQUt3A6YNC
         /c0gmTOTTx2vs+GF+zaS6qlT7tCo+5QcU6I3VOc1fQnLtQhxMYuZmQB/hig4Re7TyUXU
         nGUJGm7H8GIw2V7LYZq+wTvOqZHFRzBxYHhmloxIoO2MjwjIshmDw6oD+nPQAhb88C7A
         qs2U4VNEqrsUlJA4/BPHwmpop4etha+zRe3qc3l/V0yWZzFYRoHiEObM8QlFcacNET9Q
         iGKqSmNGlZcEwDmgfKJybj1RSq8rV6Tyive+nuX2eoQzkmLvTkF0G+niACwhFPcUqG9S
         rAWA==
X-Gm-Message-State: AFq9FYJohkI42vXJyp6hTIOyRKLJpm9DkIug9xxjjaGgx5HSauUGPnnN
	T88y2NDNuJDTtUb/smKbi39pI9aEwnqIliFQX1ToK3m69T2dCKhu7hEXneWKVmCynj+ldG1gKcH
	BJ2NMxXaFRDT4bKb4TYOkQWCQ1QORomSIAJPiT+MKHI/9PELzyAvinCWBLMStCwtGW1RHj3k=
X-Gm-Gg: AYBFou3NgLZnHWu4CNrr7h75mDKlxdfqvKgnu6NNHhAyMQOLMT1S9Q7XAL+p/CCIP7D
	ug6m7mC+nMsc5nvKSsVJ+Tj3SttMYqm+vbUo+OQb4hGlL/6ks50JuoXEuC1xhdKSDt1jlD+Tfux
	6cY+1fzTUyngZ7brGohuW/Mig+STJlBZOMvxhUgCsllea7iC/5+NjinxVReFR+USaz9adOuwntW
	x5lk7z0DDosUZJfq3pryFzTB1LYtaYc0ajz/gHTDHDL72G3bdKVeYqihfzR4w3w0sQ6WT2yJXvj
	rOgxLZdMTe9Ekk9xX3RIuUq6uoFE5REBescIux/dCstMBGOcIsC+ET++CzWFwYrGBczA+0PkDWW
	ID6FeXZGLP8DXPU5B/nfp+Qfi8KgC5Fb1vxU=
X-Received: by 2002:a05:6214:b6e:b0:91b:8870:3931 with SMTP id 6a1803df08f44-91b88703a2amr244836596d6.34.1792154866836;
        Fri, 16 Oct 2026 05:47:46 -0700 (PDT)
X-Received: by 2002:a05:6214:b6e:b0:91b:8870:3931 with SMTP id 6a1803df08f44-91b88703a2amr244836066d6.34.1792154866215;
        Fri, 16 Oct 2026 05:47:46 -0700 (PDT)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([2600:6c65:2440:d8c:929c:b769:6def:faa3])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcbae22d0sm22168846d6.28.2026.10.16.05.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 05:47:45 -0700 (PDT)
Message-ID: <bfe54bc7b8fdc023903933410c851576c00bea16.camel@redhat.com>
Subject: Re: [PATCH 2/2] scsi: target: iscsi: Complete an aborted WRITE when
 a new R2T would be sent
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Date: Fri, 16 Oct 2026 08:47:44 -0400
In-Reply-To: <sashiko-outbox-171452@kernel.org>
References: <20261014143932.39453-1-loberman@redhat.com>
	 <20261014143932.39453-3-loberman@redhat.com>
	 <sashiko-outbox-171452@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-10-14 at 15:00 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> - [High] iscsi: workqueue corruption via double completion of aborted
> cmd
> --
>=20
> commit 1cef49db01d5c1eb5e9670fc6f016dfd14ddd5cd
> Author: Laurence Oberman <loberman@redhat.com>
>=20
> scsi: target: iscsi: Complete an aborted WRITE when a new R2T would
> be sent
>=20
> iscsit_check_dataout_payload() hands a command to
> iscsit_get_dataout() to
> request the next burst whenever iscsit_check_post_dataout() returns
> DATAOUT_SEND_R2T, without checking CMD_T_ABORTED first. This patch
> guards
> for aborted commands by stopping the dataout timer and completing the
> command.
>=20
> > diff --git a/drivers/target/iscsi/iscsi_target.c
> > b/drivers/target/iscsi/iscsi_target.c
> > index aab9237a67768..87b215b18034e 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -1669,6 +1669,25 @@ iscsit_check_dataout_payload(struct
> > iscsit_cmd *cmd, struct iscsi_data *hdr,
> > =C2=A0	if ((rc =3D=3D DATAOUT_NORMAL) || (rc =3D=3D
> > DATAOUT_WITHIN_COMMAND_RECOVERY))
> > =C2=A0		return 0;
> > =C2=A0	else if (rc =3D=3D DATAOUT_SEND_R2T) {
> [ ... ]
> > +		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
> > +			if (cmd->outstanding_r2ts < 1) {
> > +				iscsit_stop_dataout_timer(cmd);
> > +				target_complete_cmd(&cmd->se_cmd,
> > +						=C2=A0=C2=A0=C2=A0
> > SAM_STAT_TASK_ABORTED);
>=20
> [Severity: High]
> Can calling target_complete_cmd() directly on an aborted command
> bypass the
> synchronization wrapper iscsit_complete_aborted_cmd()?
>=20
> Because this bypasses iscsit_claim_completion_locked(), could
> concurrent
> session teardown or other abort paths also claim the command and call
> target_complete_cmd()?
>=20
> This concurrent modification could lead to target_cmd_interrupted()
> executing
> INIT_WORK(&cmd->work, target_abort_work) and queue_work()
> concurrently on an
> already active work item, which might destroy the workqueue linked
> list.
>=20
> There is also a preexisting location in the header parsing path that
> exposes
> the same unsynchronized completion race, which appears to have been
> copied
> here and left unfixed:
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
> Would it be safer to use iscsit_complete_aborted_cmd() in both places
> to
> ensure the completion is safely claimed?
>=20
> > +			}
> > +			return 0;
> > +		}
> > +
> > =C2=A0		iscsit_set_dataout_sequence_values(cmd);

Thanks for the review - you are right, and unlike the companion finding
against patch 1 this one is a defect this series introduces rather than
inherits.

The new completion in the DATAOUT_SEND_R2T branch calls
target_complete_cmd() directly and so never sets completion_claimed.
After it runs, the command is still in TRANSPORT_WRITE_PENDING and
still
on conn->conn_cmd_list until target_abort_work reaches
iscsit_aborted_task(). A connection drop in that window lets
iscsit_release_commands_from_conn() claim the command successfully and
complete it a second time, which is exactly the sequence you describe.

v2 will route it through iscsit_complete_aborted_cmd():

	if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
		if (cmd->outstanding_r2ts < 1)
			iscsit_complete_aborted_cmd(cmd);
		return 0;
	}

The helper already performs iscsit_stop_dataout_timer() followed by
target_complete_cmd(), so the claimed path is unchanged and only the
second completion is suppressed. It also gives the helper a second
caller, which it should have had in this version.

Worth noting for the record that instrumented kernels logged this site
firing zero times across two independent 300-cycle validation runs, so
the change does not disturb the path that was actually exercised during
testing. The validated fix is the iscsit_execute_cmd() site in patch 1,
which v2 leaves alone.

On the pre-existing location in __iscsit_check_dataout_hdr(): I agree
it
has the same shape, and the lock context there allows the helper
(iscsit_stop_dataout_timer() sleeps at that point, so t_state_lock is
already dropped). I would prefer to handle it in a separate patch
rather
than fold it into this series - it is a distinct pre-existing race in
code this series does not otherwise touch. I have replied on the patch
1 thread with the reasoning.

Thanks
Laurence

