Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7510A54EEC0;
	Wed, 14 Oct 2026 15:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791990612; cv=none; b=a/kmfXKCCnLRas7inIU588aV+KTXrDeBCWTJ01I+yo1RZ5B3ypm2gqyWvVb3b2j6i+oekzjmg8Iy7dnUDNBtCxy0HCOoS3oysKgmpGIHmwHVSjxGWKwIEfrB68HYQblHEcBTzdh54t7W0/luWm1mUxNbLkzffZdy9o98YzRs+Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791990612; c=relaxed/simple;
	bh=rsTqUseG+QlAOrhpSdtsNOVQN5RJ//s66ipruCU8e4U=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=CqLVqgDpyZVVZkaKS0apdEJbULdA0b47pw8bRGteKq9dYkwHojiYw8IFmdY/WP/awdPKhKPvz3/Fxo3jBAljsQ9/rLv/Mcbe4Imo2QBcK6fowdV5mOJLCvrWKt2/veroSzI4PHB0e8e7Ab4h9pcfOj3ya8BBIiyCLu6BCDLhfNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cb0GtEvm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cb0GtEvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00E81F000C4;
	Wed, 14 Oct 2026 15:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791990610;
	bh=MkCHp8W4uApw/EkRbf3AI528FDCwxTvCpzkvndf5nN0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Cb0GtEvmT5W9WdrfcY53qaCisz6eOtp0/5idO+Vs6Tn2KTv42yatfBdum5ktOVNeu
	 3F2fw18+bOHIXSCuAc6Rqcf7I+NhG0sbyoPeR4b/fG8RpSgqbTunGGv6RZKKxVN5Eg
	 3r8tkMwqEyJLu1jtDhPjyr1X3urRoyMWibGgklhsccjaDSygnzaiqtP/ejrwf38oUN
	 NoD3rpjG+jQl1LbrVFlCAJ1I7IAGA99pRVf3ai5Ej+MXFJ2MVHTt28+Q/ffGm8tJQh
	 zcMBgD1sG/L6ID7uSNrDbnNvzAl9a+Y0uiOZFuPwbjeMpRXWo8VRXjo9Myh/lItkO+
	 kqXjZ1XKIzkgg==
Message-ID: <sashiko-outbox-171458@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: target: iscsi: Complete an aborted WRITE
 stuck before the first R2T
Reply-To: sashiko-reviews@lists.linux.dev
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261014143932.39453-2-loberman@redhat.com>
References: <20261014143932.39453-1-loberman@redhat.com>
 <20261014143932.39453-2-loberman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 15:10:09 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] iscsi: double completion and workqueue corruption for aborted WRIT=
Es on DataOut path
--

commit 7b04f6989363db2c2b75d8c212ee852153982c8d
Author: Laurence Oberman <loberman@redhat.com>
   =20
scsi: target: iscsi: Complete an aborted WRITE stuck before the first R2T

This patch resolves an issue where an aborted WRITE command that arrives wi=
th
immediate data exceeding FirstBurstLength gets stuck in TRANSPORT_WRITE_PEN=
DING.
It accomplishes this by completing the command in iscsit_execute_cmd() and
introducing a new iscsit_claim_completion_locked() helper to avoid a double
completion race with iscsit_release_commands_from_conn().

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 124ff269b8e75..aab9237a67768 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4198,10 +4198,18 @@ static void iscsit_release_commands_from_conn(str=
uct iscsit_conn *conn)
>  		if (cmd->se_cmd.t_state =3D=3D TRANSPORT_WRITE_PENDING) {
>  			/*
>  			 * We never submitted the cmd to LIO core, so we have
> -			 * to tell LIO to perform the completion process.
> +			 * to tell LIO to perform the completion process --
> +			 * unless iscsit_execute_cmd() already did.  t_state
> +			 * stays TRANSPORT_WRITE_PENDING across that
> +			 * completion, so the claim is the only thing that can
> +			 * tell us.
>  			 */
> +			bool claimed =3D iscsit_claim_completion_locked(cmd);
> +
>  			spin_unlock_irq(&se_cmd->t_state_lock);
> -			target_complete_cmd(&cmd->se_cmd, SAM_STAT_TASK_ABORTED);
> +			if (claimed)
> +				target_complete_cmd(&cmd->se_cmd,
> +						    SAM_STAT_TASK_ABORTED);

[Severity: High]
Does this code miss the DataOut paths?

Because target_complete_cmd() is called directly in __iscsit_check_dataout_=
hdr()
and target_execute_cmd() is called in iscsit_check_dataout_payload() for ab=
orted
commands without setting the completion_claimed flag.

If a command is aborted on the DataOut path:

drivers/target/iscsi/iscsi_target.c:__iscsit_check_dataout_hdr() {
    ...
		if (se_cmd->transport_state & CMD_T_ABORTED) {
			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
			    --cmd->outstanding_r2ts < 1) {
				iscsit_stop_dataout_timer(cmd);
				target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
			}
    ...
}

Because completion_claimed is never set, target_complete_cmd() delegates
to target_cmd_interrupted() which queues target_abort_work but leaves
the command in TRANSPORT_WRITE_PENDING.

If the connection drops before target_abort_work removes the command
from the connection list, iscsit_release_commands_from_conn() will find it,
iscsit_claim_completion_locked() will return true, and it will call
target_complete_cmd() a second time.

Can this double call to target_complete_cmd() cause target_cmd_interrupted()
to re-initialize and re-queue cmd->work while it is already pending on the
workqueue, leading to workqueue linked-list corruption and a use-after-free
when target_handle_abort() runs twice?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014143932.3945=
3-1-loberman@redhat.com?part=3D1
