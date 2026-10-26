Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793044611;
	b=2f2RhaDBVOYfy662D0GsO+hW14WQGcrtXqfTSAhCCfNqS/MmFmKKsfIfKAQuI5PXmjuW
	 X6ERuRUtQX1cauvmMZpXYgT/0KXxS/rBnVhq8DZOB+Hzl5CDSC7tUi59qtYNj+9A+mcvq
	 TIWTJwALQbj14ikrjww4A4Yf+kY76vGooTBx8zi7Aqp8+IYyiFbv0gjUJOWsxC793lMnK
	 LcoF4p8Av+hylIrP6/2V5pgnRrE1uqjj+LTzG82Qi9kQxAjU9q/9EyvV65qOpL/+uRb89
	 AjQQAYAOxlqmmwi4dXU7Iq49gtchUVE4LDnBbMemRfP6XGcfTv52IXsEU7/Uhnblb5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793044611;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zV16S2r/q7B2WiBe6lMyGomfGyDosaEDCJ5qkpQ7r2U=;
	b=zN3SdWxmsdXW7cfuy9uNehIomf02cG5sxp2T/tKnWxwTF9xffGxtXmdppwzTE8cLBZmA
	 6GmgovXpQJes4UQDxRjyMPq7+mFNgZJK2AmLJzK3BZBBDpMHo5TZsrnGU8HSnwbUj8HBS
	 Q8pZII7/jL9qN1Y83sm9aPGp3iWZ82GZ7ML/zL56tJvfTgYCOm7eguTiIGbPVV7AzPFS7
	 UXTWKS2e4lY4TZsDRQUZkhPm2DaT9qXx0L6GIbW6e5hdbp+2nhLC04zdupfCeZ7mQ5tYn
	 1UgXMYkGAyjZ0bpKOpphxZ/iyY3A2B0c2GO3zU9TIa3J/ykQ01/WEmbviqKxmglpDdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b7RGtPkk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDC1606A31A;
	Mon, 26 Oct 2026 19:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b7RGtPkk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084371F01825;
	Mon, 26 Oct 2026 19:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793044611;
	bh=zV16S2r/q7B2WiBe6lMyGomfGyDosaEDCJ5qkpQ7r2U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b7RGtPkkEWi6PXWC14Xf210lh0BMafa497eUXbAjAmGC1M85XzCga77xXhQIm5KrW
	 26oEyvn0pVy9bdjMecGKM9dRjnLaXALn74ykr+3QGDzWlageDjy3fx+ttIiSEV0zb3
	 htcRa0UYFxveH1i9IoOOHCudUBp2en81BR+nQx3psQVpcSxHWVgfoII8dchTxFQGXp
	 Kd1fmMmPWktwxPT6fe6jF9f4A0zC8m2Hly6Y8Tid6bsQiTGHQ48g4TB/XIQI7Lwmjx
	 NdwD9ewXL+dVN+uObwn/AJwNrxfnO0CXDqKpyZ4kqjsdYyKhK8IATSxbWN+6Mj+ZtD
	 MM1GgpE+wza8Q==
Message-ID: <sashiko-outbox-185693@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/2] scsi: target: Complete an aborted command at
 most once
Reply-To: sashiko-reviews@lists.linux.dev
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261026192835.1431767-2-loberman@redhat.com>
References: <20261026192835.1431767-1-loberman@redhat.com>
 <20261026192835.1431767-2-loberman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 19:56:50 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: target: double transport_complete_callback() via CMD_T_STOP
- [High] scsi: target: unguarded abort queueing in transport_generic_reques=
t_failure()
--

commit 9f0a0fc8e2f216b4d0f91c9797ea14d9a91154f8
Author: Laurence Oberman <loberman@redhat.com>

scsi: target: Complete an aborted command at most once

This commit adds the CMD_T_ABORT_QUEUED flag under t_state_lock in
target_cmd_interrupted() so that an aborted command only runs its completion
callback and queues target_abort_work once.

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
> index 927861c30afc4..4896a92392e0e 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -882,24 +882,45 @@ static void target_abort_work(struct work_struct *w=
ork)
>  	target_handle_abort(cmd);
>  }
> =20
> +/*
> + * Returns true if the command has been aborted or stopped, in which cas=
e the
> + * caller must not carry on with normal completion.  For an aborted comm=
and the
> + * work that must not run twice -- the completion callback and the queue=
ing of
> + * target_abort_work -- is done once, under CMD_T_ABORT_QUEUED.
> + */
>  static bool target_cmd_interrupted(struct se_cmd *cmd)
>  {
> +	bool queue_abort =3D false, stop =3D false;
> +	unsigned long flags;
>  	int post_ret;
> =20
> +	spin_lock_irqsave(&cmd->t_state_lock, flags);
>  	if (cmd->transport_state & CMD_T_ABORTED) {
> -		if (cmd->transport_complete_callback)
> -			cmd->transport_complete_callback(cmd, false, &post_ret);
> +		if (cmd->transport_state & CMD_T_ABORT_QUEUED) {
> +			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
> +			return true;
> +		}
> +		cmd->transport_state |=3D CMD_T_ABORT_QUEUED;
> +		queue_abort =3D true;
> +	} else if (cmd->transport_state & CMD_T_STOP) {
> +		stop =3D true;
> +	}
> +	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
> +
> +	if (!queue_abort && !stop)
> +		return false;
> +
> +	if (cmd->transport_complete_callback)
> +		cmd->transport_complete_callback(cmd, false, &post_ret);

[Severity: High]
Can cmd->transport_complete_callback() still be called more than once when a
command hits the CMD_T_STOP path first?

The commit message notes that leaving the CMD_T_STOP branch unguarded is
harmless because complete_all() is idempotent, and explains that a first ca=
ll
to target_cmd_interrupted() can take the CMD_T_STOP branch before CMD_T_ABO=
RTED
is set afterwards.

However, target_cmd_interrupted() executes cmd->transport_complete_callback=
()
when either queue_abort or stop is true, without clearing the callback poin=
ter
or guarding its execution. In drivers/target/target_core_sbc.c, both
compare_and_write_callback() and compare_and_write_post() release dev->caw_=
sem
without clearing cmd->transport_complete_callback:

drivers/target/target_core_sbc.c:compare_and_write_callback() {
    ...
out:
	/*
	 * In the MISCOMPARE or failure case, unlock ->caw_sem obtained in
	 * sbc_compare_and_write() before the original READ I/O submission.
	 */
	up(&dev->caw_sem);
	sg_free_table(&write_tbl);
	return ret;
}

If a first call to target_cmd_interrupted() takes the CMD_T_STOP branch and=
 a
subsequent call takes either the CMD_T_ABORTED branch (after CMD_T_ABORTED =
is
set) or the CMD_T_STOP branch a second time, won't
cmd->transport_complete_callback() run twice and call up(&dev->caw_sem) a
second time?

> +
> +	if (queue_abort) {
>  		INIT_WORK(&cmd->work, target_abort_work);
>  		queue_work(target_completion_wq, &cmd->work);
> -		return true;
> -	} else if (cmd->transport_state & CMD_T_STOP) {
> -		if (cmd->transport_complete_callback)
> -			cmd->transport_complete_callback(cmd, false, &post_ret);
> +	} else {
>  		complete_all(&cmd->t_transport_stop_comp);
> -		return true;
>  	}
> =20
> -	return false;
> +	return true;
>  }

[Severity: High]
Does transport_generic_request_failure() in
drivers/target/target_core_transport.c also need to test and set
CMD_T_ABORT_QUEUED under cmd->t_state_lock?

Commit 2c9fa49e100f ("scsi: target/core: Make ABORT and LUN RESET handling
synchronous") added the same abort handling pattern to both
target_cmd_interrupted() and transport_generic_request_failure():

drivers/target/target_core_transport.c:transport_generic_request_failure() {
    ...
	if (cmd->transport_complete_callback)
		cmd->transport_complete_callback(cmd, false, &post_ret);

	if (cmd->transport_state & CMD_T_ABORTED) {
		INIT_WORK(&cmd->work, target_abort_work);
		queue_work(target_completion_wq, &cmd->work);
		return;
	}
    ...
}

Because transport_generic_request_failure() does not check or set
CMD_T_ABORT_QUEUED under cmd->t_state_lock, if CMD_T_ABORTED is set after
target_cmd_interrupted() returns false in target_execute_cmd(), and executi=
on
then fails in target_write_prot_action() or __target_execute_cmd() (for
example, when tcmu_queue_cmd() sees CMD_T_ABORTED and returns
TCM_CHECK_CONDITION_ABORT_CMD, or when target_scsi3_ua_check() fails):

drivers/target/target_core_transport.c:__target_execute_cmd() {
    ...
err:
	spin_lock_irq(&cmd->t_state_lock);
	cmd->transport_state &=3D ~CMD_T_SENT;
	spin_unlock_irq(&cmd->t_state_lock);

	transport_generic_request_failure(cmd, ret);
}

transport_generic_request_failure() will invoke
cmd->transport_complete_callback(), queue target_abort_work on cmd->work, a=
nd
return early without setting CMD_T_ABORT_QUEUED or SCF_SENT_CHECK_CONDITION.

If an iSCSI ERL=3D2 TMR TASK_REASSIGN then runs
iscsit_task_reassign_complete_write() in
drivers/target/iscsi/iscsi_target_tmr.c, it sees ICF_GOT_LAST_DATAOUT set a=
nd
CMD_T_SENT cleared, and calls target_execute_cmd() ->
target_cmd_interrupted():

drivers/target/iscsi/iscsi_target_tmr.c:iscsit_task_reassign_complete_write=
() {
    ...
	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
		if (!(cmd->se_cmd.transport_state & CMD_T_SENT)) {
			pr_debug("WRITE ITT: 0x%08x: t_state: %d"
				" never sent to transport\n",
				cmd->init_task_tag, cmd->se_cmd.t_state);
			target_execute_cmd(se_cmd);
			return 0;
		}
    ...
}

Similarly, fabric error paths such as tcm_qla2xxx_write_pending(),
tcm_qla2xxx_handle_data_work(), and isert_rdma_read_done() call
transport_generic_request_failure() directly. Could these paths reach both
transport_generic_request_failure() and target_cmd_interrupted() (or
transport_generic_request_failure() twice) for the same aborted command,
re-initializing cmd->work while queued and running
cmd->transport_complete_callback() and target_handle_abort() a second time?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026192835.1431=
767-1-loberman@redhat.com?part=3D1
