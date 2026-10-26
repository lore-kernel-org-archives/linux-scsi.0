Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793045719;
	b=jAbGSg3ubcY5ytkoaUH3g+lW/GbTEDNE+AR7Eyv8r1wevE9IKQSTspA/cvJ+w7QdUZu/
	 K/i5b4I5rwhrbFCOBsP6A8A1/MuBctSlMPdqE2y/R6gFTOYvSyx+aGKs91wUDWGQ6Z5E3
	 BLQm+XmrKnWLqKA/lKFhVfnV52WOIDd0aouz3dj9UjCCZ88Sg9Wvo0yfDaaJ8eQ9gi14D
	 kkLCTR/ZJxL4O6oxVdQjBqGhYGSEeyRl5GH3nraU/0H18HBY4KCdkGagfdiSU8hASS/1i
	 LfXh4RVg2ikVmzuY56KtRodlszKAzeAZTzm8EzYo1RiRAi+2sYQm7Ph8THNievIytiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793045719;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Subject:From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=qBc5XRyll88oDqHTAiSqDmpJCercJbqZIVuAcy1oYe4=;
	b=MzFDWn3wyLO/9RYEL79sMHvsCa3X5R2i5XvnK5BnqONp42HSKOKN6XbGFNZMPQJUYuah
	 ZMDjqtWFu9hhGmRPIHOEgJg9IPYV+wscGvDfqtLsD6AxySna0worPWtjcKRZhlZ8LdC+C
	 6blWEdTehnU7h5Ag2QYPmk+PIIdIHQ7hWTtUKAACw0/vFdql+Q6XA9+AlbmS5uAZhRrA/
	 CPdAs/iElYh6LDJZdFYAjuqHufmuhzeo7IEBfq2b3kJWivfciZyhe87EGzCX5XJkdLY+8
	 0NrA2KtXHfzm51EHM//TjFH7OGNGcrP7NRiv6ZCd3hO/Y7UtNrKgmgnbieWlw1tv3Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LQDMl5ED;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=aHUmOGTx;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47459606A31E
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 20:15:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47459606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LQDMl5ED;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=aHUmOGTx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793045718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qBc5XRyll88oDqHTAiSqDmpJCercJbqZIVuAcy1oYe4=;
	b=LQDMl5EDBjTA5EC+UotUVF6eFSEziM3zrk1eFMeGnu+oSNy0T5c2AKmRHkuThiPPFAXhAf
	HBDkm24o2tj/nIPHbwcRjDaaTGbCZ0sNp1ndwdauu2CKt2yw8Ip4VFIa3yU875J/Sjvf3T
	NwEtzjOsRGv2H10jjtz+DlHiuKVZ8v8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-xDkC2Zg4Nk-feaE-ml1ebA-1; Mon, 26 Oct 2026 16:15:16 -0400
X-MC-Unique: xDkC2Zg4Nk-feaE-ml1ebA-1
X-Mimecast-MFC-AGG-ID: xDkC2Zg4Nk-feaE-ml1ebA_1793045716
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-9196b477c4cso6635146d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 13:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793045716; x=1793650516; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=qBc5XRyll88oDqHTAiSqDmpJCercJbqZIVuAcy1oYe4=;
        b=aHUmOGTxkvRLKkPprOHOfT7TnvwPi8xMyQw7elsf44mRm5mykr+gwr4OVisQhYhJ5n
         tflyUewIsqcgft4qopKkM5ERldUjT00XVc4xvjYS1ITuR8vtAeI3I6o9UiQHrS8rrcmB
         pKm0KgCt7ZycSq+PU8EFR6fQOcYVjhUYnIxwI1f8uVa99UsoO3mqh7z4o6egC9DcISB0
         rFjGf/SSbA/YLDNfpocMSS6bMLD95LqABUxUmOeZXygOCLJByLpEn4hPj0GVJ7m2wX4Q
         AwQ5XvAgKPLDccsPe9v6T4x9QjMTyDBhObBVqExVWhQKHSFlXBZU27PXN5/UKwP+ZqfW
         E8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793045716; x=1793650516;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qBc5XRyll88oDqHTAiSqDmpJCercJbqZIVuAcy1oYe4=;
        b=tB069L3Htl3ItAdrZr4RR1i0JTJPSAYw+PIIWy9hq+5282Ob3kbqEGbHLKk+F1l9xS
         ue8kQZmHnfiE19hrXyxkdxN4WQvExSUEMIIx+DLGT7sb0OzB2Ay8egCpUXUXOwf3ztT1
         cwjh6sa1tMT4HubbgxqJMQB2a4pRT+gDqPPn17vzJ/rKoaiHYm0ldlrC5bdPdBvjslDw
         qcdqijoeAsh9AjAFOwE21vj4jtifIs1yVL8lJiVGe9j16SGWqChwAK486fk1ZQMTRFp6
         Qs3RTsB1s8qovXPsiPc9aQt834kcZASpGRDae8hJvn9eDK9z5iSgPYSZvJt4VveO4jSI
         jWqw==
X-Gm-Message-State: AFq9FYJLB0BY2WgbuJ0f57vcaNbmJEc+uCQ6tNyaib154Solsvy+ijzc
	3q9angVu2lxtjGBaUPlsEKCKgJPTthf6yrt/a33KqBuDXrNvFmE/qrs+ufkcf1U9ipkz3JQBaFU
	RWultrJUD+X4tXqSlokNrAc4bPm3BBuT46pY7BUb0EllulH9Gq6l3b9D29ZB9b14zSJ82v74=
X-Gm-Gg: AYBFou32C0KExm7AZmQ955ZBTEE24+P/IR8vry+8KD/1KZe4s+PmPjSKCkdlH9gBJlP
	ILrf6P/n81vNF235i4aI5gdwAUe7yI3+S1xDfRNuLzuMwjWFMVvNouFk0Gdn5HiCDF0+C+69+zq
	68MRORJN/vIOGRQCP1GpZ4zL60dwl0YVebVzYukgZs5NH8P6ByUvNloNWWezFTq8FgN0E+hw1Hk
	nlfjv8mrcs+FfrxVPnCIMO7YyVvXJcVxjyNENDYk574FhnU5IeQKNYn4aYV9Jn1IKAfNsvgPO8Q
	8MZS0sKYcPZ5PNEmbk2WvcLIkvQ5twm1hQMdPgZRDXskMU+i9tc3eVmVrTF3M6Ywpon5+qH/II5
	M92CxMyH3edzg7Y0pgB8XuhVM9aUB1VbKNHOWZFSblO1B1TLKOikQJvCB9L/LXTxGPwKAku16Yp
	2CJRJWrtqy+BjK5vAd2hQUZw==
X-Received: by 2002:a05:6214:8447:b0:917:7e2b:d732 with SMTP id 6a1803df08f44-91c6d30f601mr9080186d6.21.1793045715328;
        Mon, 26 Oct 2026 13:15:15 -0700 (PDT)
X-Received: by 2002:a05:6214:8447:b0:917:7e2b:d732 with SMTP id 6a1803df08f44-91c6d30f601mr9079356d6.21.1793045714566;
        Mon, 26 Oct 2026 13:15:14 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c129b2sm81631796d6.20.2026.10.26.13.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 13:15:13 -0700 (PDT)
Message-ID: <caf736526f8ff4dee2fb4e05200844ec02d641b6.camel@redhat.com>
Subject: Re: [PATCH v5 1/2] scsi: target: Complete an aborted command at
 most once
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Van Assche,
 Bart" <bvanassche@acm.org>
Date: Mon, 26 Oct 2026 16:15:13 -0400
In-Reply-To: <d0f9945fb5338ef81796e97777a5a8c4b7f8600b.camel@redhat.com>
References: <20261026192835.1431767-1-loberman@redhat.com>
		 <20261026192835.1431767-2-loberman@redhat.com>
		 <sashiko-outbox-185693@kernel.org>
	 <d0f9945fb5338ef81796e97777a5a8c4b7f8600b.camel@redhat.com>
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

On Mon, 2026-10-26 at 16:04 -0400, Laurence Oberman wrote:
> On Mon, 2026-10-26 at 19:56 +0000, sashiko-bot@kernel.org=C2=A0wrote:
> > Thank you for your contribution! Sashiko AI review found 2
> > potential
> > issue(s) to consider:
> > - [High] scsi: target: double transport_complete_callback() via
> > CMD_T_STOP
> > - [High] scsi: target: unguarded abort queueing in
> > transport_generic_request_failure()
> > --
> >=20
> > commit 9f0a0fc8e2f216b4d0f91c9797ea14d9a91154f8
> > Author: Laurence Oberman <loberman@redhat.com>
> >=20
> > scsi: target: Complete an aborted command at most once
> >=20
> > This commit adds the CMD_T_ABORT_QUEUED flag under t_state_lock in
> > target_cmd_interrupted() so that an aborted command only runs its
> > completion
> > callback and queues target_abort_work once.
> >=20
> > > diff --git a/drivers/target/target_core_transport.c
> > > b/drivers/target/target_core_transport.c
> > > index 927861c30afc4..4896a92392e0e 100644
> > > --- a/drivers/target/target_core_transport.c
> > > +++ b/drivers/target/target_core_transport.c
> > > @@ -882,24 +882,45 @@ static void target_abort_work(struct
> > > work_struct *work)
> > > =C2=A0	target_handle_abort(cmd);
> > > =C2=A0}
> > > =C2=A0
> > > +/*
> > > + * Returns true if the command has been aborted or stopped, in
> > > which case the
> > > + * caller must not carry on with normal completion.=C2=A0 For an
> > > aborted command the
> > > + * work that must not run twice -- the completion callback and
> > > the
> > > queueing of
> > > + * target_abort_work -- is done once, under CMD_T_ABORT_QUEUED.
> > > + */
> > > =C2=A0static bool target_cmd_interrupted(struct se_cmd *cmd)
> > > =C2=A0{
> > > +	bool queue_abort =3D false, stop =3D false;
> > > +	unsigned long flags;
> > > =C2=A0	int post_ret;
> > > =C2=A0
> > > +	spin_lock_irqsave(&cmd->t_state_lock, flags);
> > > =C2=A0	if (cmd->transport_state & CMD_T_ABORTED) {
> > > -		if (cmd->transport_complete_callback)
> > > -			cmd->transport_complete_callback(cmd,
> > > false, &post_ret);
> > > +		if (cmd->transport_state & CMD_T_ABORT_QUEUED) {
> > > +			spin_unlock_irqrestore(&cmd-
> > > >t_state_lock,
> > > flags);
> > > +			return true;
> > > +		}
> > > +		cmd->transport_state |=3D CMD_T_ABORT_QUEUED;
> > > +		queue_abort =3D true;
> > > +	} else if (cmd->transport_state & CMD_T_STOP) {
> > > +		stop =3D true;
> > > +	}
> > > +	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
> > > +
> > > +	if (!queue_abort && !stop)
> > > +		return false;
> > > +
> > > +	if (cmd->transport_complete_callback)
> > > +		cmd->transport_complete_callback(cmd, false,
> > > &post_ret);
> >=20
> > [Severity: High]
> > Can cmd->transport_complete_callback() still be called more than
> > once
> > when a
> > command hits the CMD_T_STOP path first?
> >=20
> > The commit message notes that leaving the CMD_T_STOP branch
> > unguarded
> > is
> > harmless because complete_all() is idempotent, and explains that a
> > first call
> > to target_cmd_interrupted() can take the CMD_T_STOP branch before
> > CMD_T_ABORTED
> > is set afterwards.
> >=20
> > However, target_cmd_interrupted() executes cmd-
> > > transport_complete_callback()
> > when either queue_abort or stop is true, without clearing the
> > callback pointer
> > or guarding its execution. In drivers/target/target_core_sbc.c,
> > both
> > compare_and_write_callback() and compare_and_write_post() release
> > dev->caw_sem
> > without clearing cmd->transport_complete_callback:
> >=20
> > drivers/target/target_core_sbc.c:compare_and_write_callback() {
> > =C2=A0=C2=A0=C2=A0 ...
> > out:
> > 	/*
> > 	 * In the MISCOMPARE or failure case, unlock ->caw_sem
> > obtained in
> > 	 * sbc_compare_and_write() before the original READ I/O
> > submission.
> > 	 */
> > 	up(&dev->caw_sem);
> > 	sg_free_table(&write_tbl);
> > 	return ret;
> > }
> >=20
> > If a first call to target_cmd_interrupted() takes the CMD_T_STOP
> > branch and a
> > subsequent call takes either the CMD_T_ABORTED branch (after
> > CMD_T_ABORTED is
> > set) or the CMD_T_STOP branch a second time, won't
> > cmd->transport_complete_callback() run twice and call up(&dev-
> > > caw_sem) a
> > second time?
> >=20
> > > +
> > > +	if (queue_abort) {
> > > =C2=A0		INIT_WORK(&cmd->work, target_abort_work);
> > > =C2=A0		queue_work(target_completion_wq, &cmd->work);
> > > -		return true;
> > > -	} else if (cmd->transport_state & CMD_T_STOP) {
> > > -		if (cmd->transport_complete_callback)
> > > -			cmd->transport_complete_callback(cmd,
> > > false, &post_ret);
> > > +	} else {
> > > =C2=A0		complete_all(&cmd->t_transport_stop_comp);
> > > -		return true;
> > > =C2=A0	}
> > > =C2=A0
> > > -	return false;
> > > +	return true;
> > > =C2=A0}
> >=20
> > [Severity: High]
> > Does transport_generic_request_failure() in
> > drivers/target/target_core_transport.c also need to test and set
> > CMD_T_ABORT_QUEUED under cmd->t_state_lock?
> >=20
> > Commit 2c9fa49e100f ("scsi: target/core: Make ABORT and LUN RESET
> > handling
> > synchronous") added the same abort handling pattern to both
> > target_cmd_interrupted() and transport_generic_request_failure():
> >=20
> > drivers/target/target_core_transport.c:transport_generic_request_fa
> > il
> > ure() {
> > =C2=A0=C2=A0=C2=A0 ...
> > 	if (cmd->transport_complete_callback)
> > 		cmd->transport_complete_callback(cmd, false,
> > &post_ret);
> >=20
> > 	if (cmd->transport_state & CMD_T_ABORTED) {
> > 		INIT_WORK(&cmd->work, target_abort_work);
> > 		queue_work(target_completion_wq, &cmd->work);
> > 		return;
> > 	}
> > =C2=A0=C2=A0=C2=A0 ...
> > }
> >=20
> > Because transport_generic_request_failure() does not check or set
> > CMD_T_ABORT_QUEUED under cmd->t_state_lock, if CMD_T_ABORTED is set
> > after
> > target_cmd_interrupted() returns false in target_execute_cmd(), and
> > execution
> > then fails in target_write_prot_action() or __target_execute_cmd()
> > (for
> > example, when tcmu_queue_cmd() sees CMD_T_ABORTED and returns
> > TCM_CHECK_CONDITION_ABORT_CMD, or when target_scsi3_ua_check()
> > fails):
> >=20
> > drivers/target/target_core_transport.c:__target_execute_cmd() {
> > =C2=A0=C2=A0=C2=A0 ...
> > err:
> > 	spin_lock_irq(&cmd->t_state_lock);
> > 	cmd->transport_state &=3D ~CMD_T_SENT;
> > 	spin_unlock_irq(&cmd->t_state_lock);
> >=20
> > 	transport_generic_request_failure(cmd, ret);
> > }
> >=20
> > transport_generic_request_failure() will invoke
> > cmd->transport_complete_callback(), queue target_abort_work on cmd-
> > > work, and
> > return early without setting CMD_T_ABORT_QUEUED or
> > SCF_SENT_CHECK_CONDITION.
> >=20
> > If an iSCSI ERL=3D2 TMR TASK_REASSIGN then runs
> > iscsit_task_reassign_complete_write() in
> > drivers/target/iscsi/iscsi_target_tmr.c, it sees
> > ICF_GOT_LAST_DATAOUT
> > set and
> > CMD_T_SENT cleared, and calls target_execute_cmd() ->
> > target_cmd_interrupted():
> >=20
> > drivers/target/iscsi/iscsi_target_tmr.c:iscsit_task_reassign_comple
> > te
> > _write() {
> > =C2=A0=C2=A0=C2=A0 ...
> > 	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
> > 		if (!(cmd->se_cmd.transport_state & CMD_T_SENT)) {
> > 			pr_debug("WRITE ITT: 0x%08x: t_state: %d"
> > 				" never sent to transport\n",
> > 				cmd->init_task_tag, cmd-
> > > se_cmd.t_state);
> > 			target_execute_cmd(se_cmd);
> > 			return 0;
> > 		}
> > =C2=A0=C2=A0=C2=A0 ...
> > }
> >=20
> > Similarly, fabric error paths such as tcm_qla2xxx_write_pending(),
> > tcm_qla2xxx_handle_data_work(), and isert_rdma_read_done() call
> > transport_generic_request_failure() directly. Could these paths
> > reach
> > both
> > transport_generic_request_failure() and target_cmd_interrupted()
> > (or
> > transport_generic_request_failure() twice) for the same aborted
> > command,
> > re-initializing cmd->work while queued and running
> > cmd->transport_complete_callback() and target_handle_abort() a
> > second
> > time?
>=20
> Let me wait on Bart's review but I do see validity in what Sashiko is
> reporting. The complexity in this target code is really hard to deal
> with but I am doing my best. I will also see if I can get AI to check
> it fully first should I come up with a good response to the latest
> sashiko review
>=20
> Regards
> Laurence


Hello Bart
I decided to send this along to get some guidance before I finalize
something to deal with Sashiko's latest report.

The Sashiko review of v5 found two things against patch 1. I checked
both against the tree and the second one is a real hole in the patch,
so v6 will follow/

1. transport_generic_request_failure() queues target_abort_work too.

There are exactly two sites in target_core_transport.c that queue
target_abort_work -- target_cmd_interrupted() and
transport_generic_request_failure() -- and v5 guarded only the first.
2c9fa49e100f added the same pattern to both, so guarding one is half a
fix, and the path the review gives is reachable:
target_cmd_interrupted()
returns false because CMD_T_ABORTED is not set yet, execution then
fails
and transport_generic_request_failure() queues the work with nothing
recorded, and a later target_execute_cmd() -- from
iscsit_task_reassign_complete_write(), say -- queues it again. That is
the
re-queue-while-queued this series is supposed to prevent, so patch 1 as
posted did not hold up its own subject line.

v6 factors the test-and-set into __target_claim_abort() and uses it at
both sites. Patch 1's subject is now "Queue the abort of a command at
most
once", which is what it actually guarantees.

2. transport_complete_callback() is still not one-shot.

Also correct. It runs on both branches of target_cmd_interrupted() and
again in transport_generic_request_failure(), so a CMD_T_STOP call
followed by a CMD_T_ABORTED call runs it twice, as does a failure
arriving
after an abort has already been claimed. For COMPARE AND WRITE that is
a
second up(&dev->caw_sem).

This is existing behaviour rather than something the series introduces
--
mainline runs the callback on both branches today -- but patch 1 cites
the
caw_sem double release as part of its rationale, so it is fair to say
the
fix does not match its own description. I have not tried to close it in
v6, because the options are a second flag alongside CMD_T_ABORT_QUEUED
or
clearing cmd->transport_complete_callback after the first success=3Dfalse
call, and the latter affects target_complete_ok_work(), which calls the
same callback with success=3Dtrue.

Bart, since the claim is your design: which way would you want that
done, and should it be part of this series or a follow-up? Patch 1
describes the gap explicitly at the end so it is not left implied.

Thanks as always
Laurence


