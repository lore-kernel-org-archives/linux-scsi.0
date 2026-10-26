Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793020395;
	b=Ljh9oWiYyKz5o2Y9CUilbdEhOPgeH2rqshLlGgqXRfh8ZIvpgg04azZ9VWqqzVvutO5w
	 eXp7dhpUqxIC7Y+yXdkOKa2+y5Qs9rztyeBnE7P2+/XTT/jjgaFebE80tkD9mtS72Mxj8
	 PHfiXUksPHks3rB7Jcshv/zPazZl1iuuV3RuToNunvTkPhOmvW53lfC1Ro0uDvY5wJJc9
	 RJRFjtMa8mnAAZ2HyWmmD8jRkxAvam6GrJvMN9RyTqbi7i5ea56nWBT9RgsLEBdvG/sAx
	 zNioYOxnpWjtmR3DVBEC58qaN+7R95FOLjSVSNgpT5sKphHVxN+nsB6IIANi0l565rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793020395;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GvlBjG1cDdzgzcygkraXNCsstcGHceJweWc8zuLq/Zo=;
	b=ZiSXfVHNGMk0csZsYZLsRahDh2mrU1+afrJk599a44yJMxZDxFASEgweDAXaoF7k0/Il
	 AAzeKQvRlx9JGG7YtK/esCBx8cIIfgRUVco7a+wHgWfIXGzsHk4Ar0T1NkiduirqvuUYX
	 53a2C8/zq+5nbVm0gMksL2pPyT2YzB9EqhNoAtHXfuRDoh+umc11MihELsixEvabZ0Gjw
	 1Shd/p9sjkDoWU4cHmEnQa3RC8UtrDk4Y1TTYxrAQgn7HS2ncjLkGmOoJgV7vK+JisnMz
	 ce5cwGEXYUC8s9u9SltRaGHH6TWQfmq0no8du+5GRTg/oqHXM+u+z/xBTvvvdtLepyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TQWb1yhc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08871606A323;
	Mon, 26 Oct 2026 13:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TQWb1yhc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768E91F01825;
	Mon, 26 Oct 2026 13:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793020394;
	bh=GvlBjG1cDdzgzcygkraXNCsstcGHceJweWc8zuLq/Zo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TQWb1yhcprksQH2XxsQ1J39Gwm+wdmhgR4g1zJU6g5+uW+puJhXz517d296y8WFJD
	 qW4R+sFFpCQEm/f7xwHQfw+auyD6ssHT7khraCvcwxSmOdiP+BP+XIP48RUQKE3iGa
	 DxgUpQErFnoKG7W7lHmhDxbV1ABy9Bk5wjoRWoZ2YX/fTBkMNhwDGI1iWxF5fgnsBd
	 4By54TCnzaPINzAAF7tx70EHTyOeFEHU+dMOd/+rL2VTRZjFM/qr4hefiEnyuRmJLT
	 ioVID8vyhAedjjn2GtI9fFjUi+d+TaRcj5nnx58Qm04GFzGmdhjOWoMTDuLNatj54f
	 4kHzfY3hc/A7Q==
Message-ID: <sashiko-outbox-185289@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/4] scsi: target: iscsi: Complete an aborted WRITE
 when a new R2T would be sent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261026124344.745124-3-loberman@redhat.com>
References: <20261026124344.745124-1-loberman@redhat.com>
 <20261026124344.745124-3-loberman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 13:13:14 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] scsi: target: iscsi: UAF of OOO cmd in iscsit_check_dataout_pa=
yload()
--

commit 93e4d74df05b6ac07e171f5586d09d2036dc2494
Author: Laurence Oberman <loberman@redhat.com>

scsi: target: iscsi: Complete an aborted WRITE when a new R2T would be sent

This commit completes an aborted WRITE command via
iscsit_complete_aborted_cmd() in iscsit_check_dataout_payload() when
iscsit_check_post_dataout() returns DATAOUT_SEND_R2T and no outstanding R2Ts
remain.

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
> +				iscsit_complete_aborted_cmd(cmd);
> +			return 0;
> +		}

[Severity: Critical]
Can completing the command here cause a use-after-free of cmd if
ICF_OOO_CMDSN is set?

When ImmediateData=3DYes and InitialR2T=3DNo, a WRITE command can arrive wi=
th
immediate data and expect additional unsolicited DataOut PDUs in the first
burst followed by R2T-solicited data (payload_length < FirstBurstLength <
se_cmd.data_length, so cmd->unsolicited_data =3D=3D 1 and
ICF_NON_IMMEDIATE_UNSOLICITED_DATA is set).

In drivers/target/iscsi/iscsi_target.c:iscsit_process_scsi_cmd(),
transport_generic_new_cmd(&cmd->se_cmd) is called before CmdSN sequencing:

	cmd->sense_reason =3D transport_generic_new_cmd(&cmd->se_cmd);
	if (cmd->sense_reason)
		return 1;

This places cmd->se_cmd on dev->queues[cpuid].state_list in
TRANSPORT_WRITE_PENDING. When iscsit_get_immediate_data() subsequently calls
iscsit_sequence_cmd() and cmd->cmd_sn > sess->exp_cmd_sn,
drivers/target/iscsi/iscsi_target_erl1.c:iscsit_handle_ooo_cmdsn() queues
an entry on sess->sess_ooo_cmdsn_list holding a raw pointer to cmd:

	cmd->cmd_flags			|=3D ICF_OOO_CMDSN;
	...
	ooo_cmdsn->cmd			=3D cmd;

Because cmd->unsolicited_data is set, iscsit_get_immediate_data() then calls
iscsit_set_unsolicited_dataout(cmd).

If a concurrent TMR aborts cmd while it is still waiting on
sess->sess_ooo_cmdsn_list, __target_check_io_state() sets CMD_T_ABORTED on
cmd->se_cmd. When the final unsolicited DataOut PDU of the first burst
arrives, __iscsit_check_dataout_hdr() takes the cmd->unsolicited_data =3D=
=3D 1
path, and iscsit_dataout_post_crc_passed() clears cmd->unsolicited_data =3D=
 0
and returns DATAOUT_SEND_R2T.

In this new DATAOUT_SEND_R2T branch in iscsit_check_dataout_payload(),
cmd->outstanding_r2ts is 0, so iscsit_complete_aborted_cmd(cmd) is called
without checking ICF_OOO_CMDSN or removing cmd from
sess->sess_ooo_cmdsn_list (unlike the adjacent DATAOUT_SEND_TO_TRANSPORT
branch, which checks cmd->cmd_flags & ICF_OOO_CMDSN).

Once target_complete_cmd() schedules target_abort_work ->
target_handle_abort(), cmd is completed and freed via iscsit_release_cmd().
When the missing ExpCmdSN PDU later arrives,
drivers/target/iscsi/iscsi_target_erl1.c:iscsit_execute_ooo_cmdsns() will
dereference the dangling ooo_cmdsn->cmd pointer:

		cmd =3D ooo_cmdsn->cmd;
		cmd->i_state =3D cmd->deferred_i_state;
		ooo_count++;
		sess->exp_cmd_sn++;
		...
		iscsit_remove_ooo_cmdsn(sess, ooo_cmdsn);

		if (iscsit_execute_cmd(cmd, 1) < 0)
			return -1;

Should the DATAOUT_SEND_R2T abort path also account for commands with
ICF_OOO_CMDSN set before completing cmd?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026124344.7451=
24-1-loberman@redhat.com?part=3D2
