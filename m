Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793020394;
	b=roT4E/XrHEmEXp47MPCRt9CpDFqDXFqR9sL4OmwxkpDy9OLa9q1MBTXGls6dJK3rED69
	 hnoSJdqi0KmlSSzGVmlzpfcVIbcD9zObP/+uRXH3GgJGXuMx8zSYr+fsq8JS4FWUKVozm
	 I379dAFG9Lmc5v4gKq2jLXoahSllpTlSAJ0uhNdi5L4EWnxxJKYVp4TBP5GU7CB0xWbio
	 FoeEYI/4dD7zcuAAU6wLwMRArK2EWTta3RPogS5ILIYSh0lKUFNWAe8ncvM17BliCghP3
	 8Mb5fjOGLEWXJFFfybwMEK2tCm7KIHHtsmfJ7XTkEgzqTCVQYrcMQeDghcTy6YQ3YzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793020394;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=v9D9wOQrYrgNP8BU6sBohP3BL2CIYA4r3ZNz3S9setk=;
	b=poHRP45PTNkKhXncSd80IIfORVvc44KNciKg0zO+RZlvGHYSLn6YwdQaImycB3uK1iyy
	 Hdg+DiFj2q662ZfQSBaIjT/OJ8IaSmuO3yVGM9QKh7mJ2ExixA6m+zqwC2Duq5eJ0vYhj
	 oq38spOpgY4pQmjRttHZiVhWaLFgKNB1k01SzGu8zX4z5xL8LxBd2KTfDYdDSxjZ+IL0j
	 jqGmtaQpJhfVTxMNN07snWpKYBylvrbg9wQqxEzrSTrFQpXUsAYc3i2fN1TTx/x3UhFev
	 x+6N/r7A1ovSvPUxf/+dFcQ2AI10P1zMr/pJ0gtPpV19Sm34JN6ysiDu7MpDn1brVcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CkLtRmeL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DB9606A31A;
	Mon, 26 Oct 2026 13:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CkLtRmeL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1121F01828;
	Mon, 26 Oct 2026 13:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793020394;
	bh=v9D9wOQrYrgNP8BU6sBohP3BL2CIYA4r3ZNz3S9setk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CkLtRmeL8EckewDewsqGEDNqIRHgJOlZH8wi7EiJM4+ojKhGXpw1BoF0MLM8Ue53p
	 m9e2UweqlcVQGwPf3dpgRA7mthlHjxSIchXkXnplFK2DIMvwJPUgj6T2BbS494roOS
	 DD91t/g1zYssId6JIvk8XHjOlxsu3mrwJstDTLMXKLEs4skIrdfFPMKwY8ONw+liLE
	 YfpBrhmnvlEIIe2dJMNv1lYQgJ/RuzPj/VkAyeT15c48jyp09MBt7DY7/V9wmg0ilW
	 vVXn8jQ5FueMgRyKKKqkGbvaHrWlUYnSKN1JZPDUzhk8gm4Ra14bCiSxaomxWSG1Rv
	 V+MJ16K469YOw==
Message-ID: <sashiko-outbox-185288@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/4] scsi: target: iscsi: Complete an aborted WRITE
 stuck before the first R2T
Reply-To: sashiko-reviews@lists.linux.dev
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261026124344.745124-2-loberman@redhat.com>
References: <20261026124344.745124-1-loberman@redhat.com>
 <20261026124344.745124-2-loberman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 13:13:13 +0000
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
- [High] scsi: target: iscsi: UAF on cmd after iscsit_sequence_cmd() aborts=
 write
--

commit bf534eddda8811708a661c23a1fc1d455c52b52d
Author: Laurence Oberman <loberman@redhat.com>

scsi: target: iscsi: Complete an aborted WRITE stuck before the first R2T

This commit completes WRITE commands in TRANSPORT_WRITE_PENDING that were
aborted before the first R2T is sent in iscsit_execute_cmd(). It also adds
a completion claim flag under se_cmd.t_state_lock so that only one of
iscsit_execute_cmd() or iscsit_release_commands_from_conn() completes the
command.

> diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/is=
csi/iscsi_target_erl1.c
> index d8ca06e697d63..cf72c79be355a 100644
> --- a/drivers/target/iscsi/iscsi_target_erl1.c
> +++ b/drivers/target/iscsi/iscsi_target_erl1.c
> @@ -927,8 +927,16 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int o=
oo)
> =20
>  			if (!(cmd->cmd_flags &
>  					ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
> -				if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
> +				/*
> +				 * No R2T has been sent for this command yet,
> +				 * so returning here leaves the initiator with
> +				 * nothing to send and no DataOut timer armed.
> +				 * Complete it, or nothing ever will.
> +				 */
> +				if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
> +					iscsit_complete_aborted_cmd(cmd);
>  					return 0;
> +				}

[Severity: High]
Can completing the command here cause a use-after-free on cmd in the
callers of iscsit_sequence_cmd()?

When an iSCSI WRITE arrives with immediate data whose total data length
exceeds FirstBurstLength and with ISCSI_FLAG_CMD_FINAL set on the Command
PDU (so cmd->immediate_data =3D=3D 1 and cmd->unsolicited_data =3D=3D 0),
iscsit_process_scsi_cmd() calls transport_generic_new_cmd(), which adds
cmd->se_cmd to dev->queues[cpuid].state_list with cmd_kref =3D=3D 2 (initial
kref plus SCF_ACK_KREF).

If an ABORT_TASK TMR, a same-session LUN_RESET, or a cross-session
LUN_RESET with emulate_tas =3D=3D 0 aborts the command before
iscsit_execute_cmd() runs, __target_check_io_state() sets CMD_T_ABORTED
without CMD_T_TAS.

When iscsit_get_immediate_data() or cxgbit_get_immediate_data() then calls
iscsit_sequence_cmd() -> iscsit_execute_cmd(), iscsit_complete_aborted_cmd()
calls target_complete_cmd() -> target_cmd_interrupted(), queueing
target_abort_work on target_completion_wq. On another CPU,
target_abort_work -> target_handle_abort() runs iscsit_aborted_task(),
drops SCF_ACK_KREF via target_put_sess_cmd(), and calls
transport_cmd_check_stop_to_fabric() -> lio_check_stop_free() ->
target_put_sess_cmd() -> iscsit_release_cmd() -> target_free_tag(), which
returns the cmd slot to se_sess->sess_tag_pool.

However, after iscsit_sequence_cmd() returns CMDSN_NORMAL_OPERATION (0),
both drivers/target/iscsi/iscsi_target.c:iscsit_get_immediate_data() and
drivers/target/iscsi/cxgbit/cxgbit_target.c:cxgbit_get_immediate_data()
still dereference cmd without holding a reference on cmd->se_cmd:

drivers/target/iscsi/iscsi_target.c:iscsit_get_immediate_data() {
    ...
		cmdsn_ret =3D iscsit_sequence_cmd(cmd->conn, cmd,
					(unsigned char *)hdr, hdr->cmdsn);
		if (cmdsn_ret =3D=3D CMDSN_ERROR_CANNOT_RECOVER)
			return -1;

		if (cmd->sense_reason || cmdsn_ret =3D=3D CMDSN_LOWER_THAN_EXP) {
			target_put_sess_cmd(&cmd->se_cmd);

			return 0;
		} else if (cmd->unsolicited_data)
			iscsit_set_unsolicited_dataout(cmd);
    ...
}

If the tag slot has already been reallocated from se_sess->sess_tag_pool,
wouldn't reading cmd->sense_reason or cmd->unsolicited_data inspect the
new command and potentially call target_put_sess_cmd() or
iscsit_set_unsolicited_dataout() on the reallocated command?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026124344.7451=
24-1-loberman@redhat.com?part=3D1
