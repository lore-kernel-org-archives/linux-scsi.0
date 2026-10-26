Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793045055;
	b=xaK+2NGYuAZGwTUVvUdKD/XJao1hmoB7roUhm6ZyVYkYhUaHWethIdyysWcc7BHDqX8y
	 qH/F4l7yvplbjOqXOD64GxMGvlpTkj1PNDN9K/I2lQ3VM9YA95pmQHLrmn9pFPrfBkJO+
	 jIN4VLuZfVLY/sMVSuJ9Pgfxzm63/YXog4HPxOJ2Q5wDG8LmWpMDCfhFyOIhMr+Ivm9qa
	 J26XJMfgrYt+mB12RuokBeXoCStzcmGmPy+67pHXZ/eyQYFYKMrZyQjPQ4XLa5zY2dUTF
	 iKkpf+OeLyvxPAaZ9eSRHJrtWV3uz8IKeunM7bH/k41fRfJ7FYDmbHkZXg5fkAMPJsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793045055;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Subject:From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=EteNQ3QjnOcsX1B3Urg7UJN4lThZVIxHF8GjAs9LfFk=;
	b=EazgzxWnMENot0WehOSpEmfyxENujR17q1sgsqmDmiht+eMHMPtvBTsHCEoeWTugYBlp
	 RsxpttdPjplKSOQmYH0oowWNeqYXiVsX2IyaTAy/srFrnq2tYRXOhJ0aT3LCxVl8bBfqB
	 3ea3EuAvn6z0WY8Jw8R0PFc11Yg7ge2ylifp0duE46tdSiaqwzEvquJ9BSi5bacF7cnC4
	 5rt/G62atw1oZcqEAZhqQOG+3lxfT0xx4VC1tYPjA+xCMgU+KKufjPuyLoZeubHxt21ZH
	 XUnsvVB5Vqsqum7p6xqdrdYKZHKyTzVHqjSO2rcftFjwjRPe3BoPKoQ0WjlBOw7URpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=T54LVbOP;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=LYibX+bF;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAACB606A31D
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 20:04:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAACB606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=T54LVbOP;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=LYibX+bF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793045053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EteNQ3QjnOcsX1B3Urg7UJN4lThZVIxHF8GjAs9LfFk=;
	b=T54LVbOPv3UU84TZHm5EJ+xPLHFHZ5FFwCUD+Fp8ekba3Vh1N7RiKFPZ7pcu+9NerQGU4R
	U84qKnsH1m7OTc3GrWOdFgTBIdt+qLauXj/vDCSknDFV5rPMSz7muLST7N81qusq3A2erN
	blfR3c57v9pa2wvcPyh1dDuJ10pofgw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-tMoiT_O2M6a4Khjm8V9oRg-1; Mon, 26 Oct 2026 16:04:12 -0400
X-MC-Unique: tMoiT_O2M6a4Khjm8V9oRg-1
X-Mimecast-MFC-AGG-ID: tMoiT_O2M6a4Khjm8V9oRg_1793045052
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-917a7c17166so77344576d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 13:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793045052; x=1793649852; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=EteNQ3QjnOcsX1B3Urg7UJN4lThZVIxHF8GjAs9LfFk=;
        b=LYibX+bFRqvcM1gXNi/Lw024CqtEG1iKT4b/RXPHMhoqGDw1J7FDi1fHpUBqTYkKMH
         lVBbhA2TufKru6sKkfu93sioMTy+JmOm1g3lCVDhuVgRjinq0kukc6rXaLk0hBIiee1s
         Sqk3OxrTbMS/a9/DIy4zNSD7jSV9OZQ9Nc+QYvUmjMHbXP4zz8rT2eH8XAPcgDA3i5i0
         REA/NiIFzo1suFszQYz0hckmP9pK68pD6IC165RPMTF7mc5ahfUVIiEaYhPCqG7n/XD/
         4gUClnjDB1U/wPtsTJTR5hxxhmAUzCJNFLj1wOzO78EGteEBSrnR1p077s6Kf8KkkLdt
         tyBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793045052; x=1793649852;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EteNQ3QjnOcsX1B3Urg7UJN4lThZVIxHF8GjAs9LfFk=;
        b=PzK2B0LYGXj6VsQ0Ktzy3JdfWVPSrL3MtYiZM29PP6jS1pnpWepOxF8FY481Eg1JUc
         L7eQUKf5nXcICIWMVhkun8k2n81qtY/7JtiO+QHth9U6cFPd7C92KgtbrAliCbFZUljd
         CcWfCXZIK1z+mZJypDNNtpWB77Oqi1M41rT057spuFypNTb4GxlyFm2/pUqvQI03dNFN
         IXDd3GW+COl0xzmCfk13N8JVCv+ChNyLdQfp+m9XOk67ZoZfO3jFPZ/kRG+ieV9XOBVK
         oS4saD2DxvG6ll7gDQEoQ6cUmVpkY3lItxnkF0z81Mh4Yh221k+NRv+hbyEod8vAerER
         gfnQ==
X-Gm-Message-State: AFq9FYIHQmZDnMMslsCM4/4aWoywMz+1RyxtW4IDHb70qgq3N0NcKJ01
	8OveCdFcGJyD4KFuG5m5lesMG1DcqjIdvLo3md4nnje0SEIAS4G8oLdJzXqRkQeVNd1vI6f6Idd
	irBl7qEV/Zg9oU97Hty7fGsod7U3SFOhUnQSO0plVkxpU/WY96h1ITOv3VkV6vVKQSfhXTl4=
X-Gm-Gg: AYBFou13BAM1rpMqOArP0i00/LiukQgUXW+54tCq4Ao492AkaAAkE4WW81GF0o+lv1l
	0oI3lYS4cW8lz3k+Cuw7WepbZFoBlLUrmVlIoSwTvn1Bw2OYS86HPuQEq3KBfY+9nqWCrIqyMQh
	Gko9PrOWPfMJoS7RjcAHdHMX5wc+GARlQJuZLazo5wFxtaSeFS2zMKpdL7u9+FcLukyB/YB3ZtS
	yoSKIU6Ou+qbUjxxSVedZ4OS0jcaf4XOqs37/M7tBXYO9ZVBc/UgGtcKCWUdWgp231VXQ+Xw8oZ
	h46dNJiCLBtO7hhkc744lg/ILm30u4SGVATTV++Y5kUW+8F98EdP4oC7znM+WUyrvx60Lxg06/D
	3nRpGn54nCjFBI4+vecQZ7dm0de3HH+DU6mqCGJctLhS6tojS0PseF+VOESM7Onlzlr85A+/Jnt
	+WG3ZfdW5Dwsqe/TjFPIAM6Q==
X-Received: by 2002:a05:620a:3949:b0:93e:7192:191c with SMTP id af79cd13be357-940ef91b69cmr1103804385a.17.1793045051646;
        Mon, 26 Oct 2026 13:04:11 -0700 (PDT)
X-Received: by 2002:a05:620a:3949:b0:93e:7192:191c with SMTP id af79cd13be357-940ef91b69cmr1103796885a.17.1793045050972;
        Mon, 26 Oct 2026 13:04:10 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0a7e5cfsm772481385a.37.2026.10.26.13.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 13:04:10 -0700 (PDT)
Message-ID: <d0f9945fb5338ef81796e97777a5a8c4b7f8600b.camel@redhat.com>
Subject: Re: [PATCH v5 1/2] scsi: target: Complete an aborted command at
 most once
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Date: Mon, 26 Oct 2026 16:04:09 -0400
In-Reply-To: <sashiko-outbox-185693@kernel.org>
References: <20261026192835.1431767-1-loberman@redhat.com>
	 <20261026192835.1431767-2-loberman@redhat.com>
	 <sashiko-outbox-185693@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mon, 2026-10-26 at 19:56 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider:
> - [High] scsi: target: double transport_complete_callback() via
> CMD_T_STOP
> - [High] scsi: target: unguarded abort queueing in
> transport_generic_request_failure()
> --
>=20
> commit 9f0a0fc8e2f216b4d0f91c9797ea14d9a91154f8
> Author: Laurence Oberman <loberman@redhat.com>
>=20
> scsi: target: Complete an aborted command at most once
>=20
> This commit adds the CMD_T_ABORT_QUEUED flag under t_state_lock in
> target_cmd_interrupted() so that an aborted command only runs its
> completion
> callback and queues target_abort_work once.
>=20
> > diff --git a/drivers/target/target_core_transport.c
> > b/drivers/target/target_core_transport.c
> > index 927861c30afc4..4896a92392e0e 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -882,24 +882,45 @@ static void target_abort_work(struct
> > work_struct *work)
> > =C2=A0	target_handle_abort(cmd);
> > =C2=A0}
> > =C2=A0
> > +/*
> > + * Returns true if the command has been aborted or stopped, in
> > which case the
> > + * caller must not carry on with normal completion.=C2=A0 For an
> > aborted command the
> > + * work that must not run twice -- the completion callback and the
> > queueing of
> > + * target_abort_work -- is done once, under CMD_T_ABORT_QUEUED.
> > + */
> > =C2=A0static bool target_cmd_interrupted(struct se_cmd *cmd)
> > =C2=A0{
> > +	bool queue_abort =3D false, stop =3D false;
> > +	unsigned long flags;
> > =C2=A0	int post_ret;
> > =C2=A0
> > +	spin_lock_irqsave(&cmd->t_state_lock, flags);
> > =C2=A0	if (cmd->transport_state & CMD_T_ABORTED) {
> > -		if (cmd->transport_complete_callback)
> > -			cmd->transport_complete_callback(cmd,
> > false, &post_ret);
> > +		if (cmd->transport_state & CMD_T_ABORT_QUEUED) {
> > +			spin_unlock_irqrestore(&cmd->t_state_lock,
> > flags);
> > +			return true;
> > +		}
> > +		cmd->transport_state |=3D CMD_T_ABORT_QUEUED;
> > +		queue_abort =3D true;
> > +	} else if (cmd->transport_state & CMD_T_STOP) {
> > +		stop =3D true;
> > +	}
> > +	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
> > +
> > +	if (!queue_abort && !stop)
> > +		return false;
> > +
> > +	if (cmd->transport_complete_callback)
> > +		cmd->transport_complete_callback(cmd, false,
> > &post_ret);
>=20
> [Severity: High]
> Can cmd->transport_complete_callback() still be called more than once
> when a
> command hits the CMD_T_STOP path first?
>=20
> The commit message notes that leaving the CMD_T_STOP branch unguarded
> is
> harmless because complete_all() is idempotent, and explains that a
> first call
> to target_cmd_interrupted() can take the CMD_T_STOP branch before
> CMD_T_ABORTED
> is set afterwards.
>=20
> However, target_cmd_interrupted() executes cmd-
> >transport_complete_callback()
> when either queue_abort or stop is true, without clearing the
> callback pointer
> or guarding its execution. In drivers/target/target_core_sbc.c, both
> compare_and_write_callback() and compare_and_write_post() release
> dev->caw_sem
> without clearing cmd->transport_complete_callback:
>=20
> drivers/target/target_core_sbc.c:compare_and_write_callback() {
> =C2=A0=C2=A0=C2=A0 ...
> out:
> 	/*
> 	 * In the MISCOMPARE or failure case, unlock ->caw_sem
> obtained in
> 	 * sbc_compare_and_write() before the original READ I/O
> submission.
> 	 */
> 	up(&dev->caw_sem);
> 	sg_free_table(&write_tbl);
> 	return ret;
> }
>=20
> If a first call to target_cmd_interrupted() takes the CMD_T_STOP
> branch and a
> subsequent call takes either the CMD_T_ABORTED branch (after
> CMD_T_ABORTED is
> set) or the CMD_T_STOP branch a second time, won't
> cmd->transport_complete_callback() run twice and call up(&dev-
> >caw_sem) a
> second time?
>=20
> > +
> > +	if (queue_abort) {
> > =C2=A0		INIT_WORK(&cmd->work, target_abort_work);
> > =C2=A0		queue_work(target_completion_wq, &cmd->work);
> > -		return true;
> > -	} else if (cmd->transport_state & CMD_T_STOP) {
> > -		if (cmd->transport_complete_callback)
> > -			cmd->transport_complete_callback(cmd,
> > false, &post_ret);
> > +	} else {
> > =C2=A0		complete_all(&cmd->t_transport_stop_comp);
> > -		return true;
> > =C2=A0	}
> > =C2=A0
> > -	return false;
> > +	return true;
> > =C2=A0}
>=20
> [Severity: High]
> Does transport_generic_request_failure() in
> drivers/target/target_core_transport.c also need to test and set
> CMD_T_ABORT_QUEUED under cmd->t_state_lock?
>=20
> Commit 2c9fa49e100f ("scsi: target/core: Make ABORT and LUN RESET
> handling
> synchronous") added the same abort handling pattern to both
> target_cmd_interrupted() and transport_generic_request_failure():
>=20
> drivers/target/target_core_transport.c:transport_generic_request_fail
> ure() {
> =C2=A0=C2=A0=C2=A0 ...
> 	if (cmd->transport_complete_callback)
> 		cmd->transport_complete_callback(cmd, false,
> &post_ret);
>=20
> 	if (cmd->transport_state & CMD_T_ABORTED) {
> 		INIT_WORK(&cmd->work, target_abort_work);
> 		queue_work(target_completion_wq, &cmd->work);
> 		return;
> 	}
> =C2=A0=C2=A0=C2=A0 ...
> }
>=20
> Because transport_generic_request_failure() does not check or set
> CMD_T_ABORT_QUEUED under cmd->t_state_lock, if CMD_T_ABORTED is set
> after
> target_cmd_interrupted() returns false in target_execute_cmd(), and
> execution
> then fails in target_write_prot_action() or __target_execute_cmd()
> (for
> example, when tcmu_queue_cmd() sees CMD_T_ABORTED and returns
> TCM_CHECK_CONDITION_ABORT_CMD, or when target_scsi3_ua_check()
> fails):
>=20
> drivers/target/target_core_transport.c:__target_execute_cmd() {
> =C2=A0=C2=A0=C2=A0 ...
> err:
> 	spin_lock_irq(&cmd->t_state_lock);
> 	cmd->transport_state &=3D ~CMD_T_SENT;
> 	spin_unlock_irq(&cmd->t_state_lock);
>=20
> 	transport_generic_request_failure(cmd, ret);
> }
>=20
> transport_generic_request_failure() will invoke
> cmd->transport_complete_callback(), queue target_abort_work on cmd-
> >work, and
> return early without setting CMD_T_ABORT_QUEUED or
> SCF_SENT_CHECK_CONDITION.
>=20
> If an iSCSI ERL=3D2 TMR TASK_REASSIGN then runs
> iscsit_task_reassign_complete_write() in
> drivers/target/iscsi/iscsi_target_tmr.c, it sees ICF_GOT_LAST_DATAOUT
> set and
> CMD_T_SENT cleared, and calls target_execute_cmd() ->
> target_cmd_interrupted():
>=20
> drivers/target/iscsi/iscsi_target_tmr.c:iscsit_task_reassign_complete
> _write() {
> =C2=A0=C2=A0=C2=A0 ...
> 	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
> 		if (!(cmd->se_cmd.transport_state & CMD_T_SENT)) {
> 			pr_debug("WRITE ITT: 0x%08x: t_state: %d"
> 				" never sent to transport\n",
> 				cmd->init_task_tag, cmd-
> >se_cmd.t_state);
> 			target_execute_cmd(se_cmd);
> 			return 0;
> 		}
> =C2=A0=C2=A0=C2=A0 ...
> }
>=20
> Similarly, fabric error paths such as tcm_qla2xxx_write_pending(),
> tcm_qla2xxx_handle_data_work(), and isert_rdma_read_done() call
> transport_generic_request_failure() directly. Could these paths reach
> both
> transport_generic_request_failure() and target_cmd_interrupted() (or
> transport_generic_request_failure() twice) for the same aborted
> command,
> re-initializing cmd->work while queued and running
> cmd->transport_complete_callback() and target_handle_abort() a second
> time?

Let me wait on Bart's review but I do see validity in what Sashiko is
reporting. The complexity in this target code is really hard to deal
with but I am doing my best. I will also see if I can get AI to check
it fully first should I come up with a good response to the latest
sashiko review

Regards
Laurence

