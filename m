Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970E049427B;
	Fri, 16 Oct 2026 18:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792174136; cv=none; b=JmIKWHHooHQQMQlsbOkwSy6HDZadD+jyBhYzJYQ96R1B2LGecbEIkRBVZDD9veK5JL3KHxk0CyG0eOdZMaHJ2AHoNMB1DG12inWctP8pUjP6x1zrloYbOXzWzmwdrP8ACVGVUFn6lizVFTFiw/4/HQESnhw4ZT3Whw+yRMvkJOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792174136; c=relaxed/simple;
	bh=yMHz7QFsOeiusYVHMO5pJXytfYwPkSAUMNbxJK6Bocg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=nEjAbJuHtcM9sArYMPGpW6CyeyUzoTKfMYBL0k4nzxxeoAjuABuEB5N838u1GpMPsf9qfww+xz+l9U/e3K1sIc2QK83WsH2HJhXNdBkP1VW64sqQTEUplGnumTcW7gy49pK2aopsgABhTrfglYer5H7Cwu9rEHFunsr1yck5MJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y8epBy6+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y8epBy6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4881F000C5;
	Fri, 16 Oct 2026 18:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792174131;
	bh=4uY3bq24WlcdJcqM6TBQ0vRhcOMGRDW7qOnUEPGuEOI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y8epBy6+HAXA9fu5HKiitZHuusOPEpEhcmv41TRcVxmRtbVrv+SNCtTuwqFGZ8tJz
	 L0VgUTaN2nhkUmyO1VC8kcecsboHWcM2VdH9nfyK811iw8D/bifOZY+H6pELXXUin/
	 qhg/uvDhK0X9uNSD9GK2Tk3DENmQJ2HxgPgxpS4He+58R0/GLZxIs7IfmDNq1VD3UH
	 2VVQ4834RypHFxsf1X6QWjVT//SCUBKu6UJwDxdoVBR0fnqPf72Q1gJ0htLq4Xc77d
	 rrFvY2i5N9FRDPT0tihRTSBFO2i0PWcZ9YG8s2zFwrWlXRONj3FWbGane5fLFcTXyp
	 epI8mvTy4Pbnw==
Message-ID: <sashiko-outbox-174751@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: target: iscsi: Complete an aborted WRITE
 when a new R2T would be sent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261016175351.126373-3-loberman@redhat.com>
References: <20261016175351.126373-1-loberman@redhat.com>
 <20261016175351.126373-3-loberman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 18:08:51 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] iscsi: double completion due to incomplete CMD_T_ABORTED fix
- [Medium] iscsi: data race on cmd->outstanding_r2ts during abort
--

commit 538cfb5a3bbcee47d2aa78e30d5cf64fe5bed2fe
Author: Laurence Oberman <loberman@redhat.com>

scsi: target: iscsi: Complete an aborted WRITE when a new R2T would be sent

This commit adds a check for aborted commands in the DataOut processing
path when a new R2T is requested. It ensures the command is safely
completed using iscsit_complete_aborted_cmd() to claim the completion.
This prevents a race condition where a connection drop could cause a
double-completion of the aborted command.

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index aab9237a67768..3dad7f69f3bae 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1669,6 +1669,22 @@ iscsit_check_dataout_payload(struct iscsit_cmd *cm=
d, struct iscsi_data *hdr,
>  	if ((rc =3D=3D DATAOUT_NORMAL) || (rc =3D=3D DATAOUT_WITHIN_COMMAND_REC=
OVERY))
>  		return 0;
>  	else if (rc =3D=3D DATAOUT_SEND_R2T) {
> +		/*
> +		 * A new R2T would never be answered for an aborted command.
> +		 * The CMD_T_ABORTED handling in __iscsit_check_dataout_hdr()
> +		 * does not cover this: it only runs for DataOut PDUs
> +		 * belonging to R2Ts that were already issued, and
> +		 * iscsit_dataout_update_r2t() has already decremented
> +		 * outstanding_r2ts for the burst that just finished.  Guard
> +		 * on outstanding_r2ts so that with MaxOutstandingR2T > 1 the
> +		 * completion is still left to the last R2T to drain.
> +		 */
> +		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
> +			if (cmd->outstanding_r2ts < 1)

[Severity: High]
This patch introduces iscsit_complete_aborted_cmd() to fix a double-complet=
ion
race by safely claiming the completion. However, does this still leave two
other paths vulnerable to the same issue?

If cmd->outstanding_r2ts >=3D 1, the patch explicitly leaves completion to
__iscsit_check_dataout_hdr(). But __iscsit_check_dataout_hdr() uses
target_complete_cmd() directly without claiming the completion:

__iscsit_check_dataout_hdr() {
    ...
		if (se_cmd->transport_state & CMD_T_ABORTED) {
			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
			    --cmd->outstanding_r2ts < 1) {
				iscsit_stop_dataout_timer(cmd);
				target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
			}
    ...
}

Similarly, if the final payload for an aborted command is received in this
function, it reaches DATAOUT_SEND_TO_TRANSPORT and calls target_execute_cmd=
(),
which also queues the abort work without claiming the completion:

iscsit_check_dataout_payload() {
    ...
	} else if (rc =3D=3D DATAOUT_SEND_TO_TRANSPORT) {
        ...
		target_execute_cmd(&cmd->se_cmd);
		return 0;
    ...
}

Could a connection drop in either of these windows allow
iscsit_release_commands_from_conn() to complete the command a second time,
resulting in corruption of the target_completion_wq?


[Severity: Medium]
Is it safe to read cmd->outstanding_r2ts without holding cmd->r2t_lock here?

If iscsit_build_r2ts_for_cmd() encounters an allocation failure, the target
core queues the command to qf_work_queue. The worker thread will retry
building the R2T asynchronously via transport_write_pending_qf() ->
iscsit_build_r2ts_for_cmd(), incrementing the counter under cmd->r2t_lock:

iscsit_build_r2ts_for_cmd() {
    ...
		cmd->outstanding_r2ts++;
		first_r2t =3D 0;

		if (iscsit_add_r2t_to_list(cmd, offset, xfer_len, 0, 0) < 0) {
    ...
}

If the command is aborted concurrently, the RX thread processing incoming
DataOut PDUs will locklessly decrement the counter in
__iscsit_check_dataout_hdr() and locklessly read it here. Could this
concurrent non-atomic access cause lost updates, leading to a corrupted
counter and a leaked command?

> +				iscsit_complete_aborted_cmd(cmd);
> +			return 0;
> +		}
> +
>  		iscsit_set_dataout_sequence_values(cmd);
>  		conn->conn_transport->iscsit_get_dataout(conn, cmd, false);
>  	} else if (rc =3D=3D DATAOUT_SEND_TO_TRANSPORT) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016175351.1263=
73-1-loberman@redhat.com?part=3D2
