Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1711738B12A
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 07:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791357709; cv=none; b=JPXDepfutAJ0p9EAx3kChGYztQIr1XaBbnNWhtxjf7V2XL2OmlwKoMQCh7WIo1IhduaJ282Unou9Jj3mh1mxGL3pHm50Y1vdvoD3WrSnFnPBbyBx8z92zpWcmpfPUAE97SHxW8I5TZbNh19t8Vy0NQpiMEM35U4WUDX0PGJXSjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791357709; c=relaxed/simple;
	bh=nz+vTs2FX7aT7Eu3UmqAIE/Jt1N+/GkquFTThMGxJ7U=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=CyccGpHvB/PCrHJKNXpEsv1oKthdHRo0j+Y41o5GaIeiqA/Jyo8Cuq6athaspLRDegOXKvwavcAt5Loo5cN5GxzDVRPE8WfjzspHCp+soYtiZa163PNCIKreVnWc4OxxD4kF/8yoKjkMSB6qnZbPu432p3uJyUoJtjKWXhWvC/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7WI+qqA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7WI+qqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974B81F0089B;
	Wed,  7 Oct 2026 07:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791357707;
	bh=oOdJdeE8ts93ZXB8cfohSnbGBn77OLxIes9QsVwSfF8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T7WI+qqA7HNbKGW/BI5NYW5jUzrFkM+5gkGFgajRzk8pORlKnjmVYduacwdJvSVSI
	 uERfqOKF61hWlmhudnc+wWqievIQbklUTavZaZOhIAWtQQAZ3opOyp99CGnlkMuad6
	 8egNTrMoJY+zIPq+y9oq9kfbMAENzxqu+UgRiYfFgY/lRCkhBr1v2yczGwE1C/hXKe
	 hHLroAsEJR8Qt8+X7uzC56sbZ7sa0RrXVz5VN51w4hHKVXKGNzg9nt6Hk286LZY8d4
	 +T/bm2Z0BsUxyuLqn50SaNFtl3/rrfGk/H+QKXqW0XTTLw7mczqTzFn2VnyZe4YDTR
	 wk9sby9imCLfg==
Message-ID: <sashiko-outbox-162712@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] scsi: libiscsi_tcp: check that a read got the data
 the target claimed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007070207.666738-1-yhlee@isslab.korea.ac.kr>
References: <20261007070207.666738-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 07:21:47 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] iscsi: integer underflow bypasses payload validation via OVERF=
LOW flag
- [Critical] scsi: iscsi_tcp_check_data_in bypasses length validation on ou=
t-of-band RECOVERED_ERROR
- [High] iscsi: connection drop on target failure due to missing response f=
ield check
--

commit 2fd3a9439d4f7bea0212ce97dd1b8ede74211f4a
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: libiscsi_tcp: check that a read got the data the target claimed

A target can finish a read without sending the data.  iscsi_tcp_data_in()
bounds each Data-In PDU against the command buffer but never adds them up,
so a completion that declares no underflow is believed and the command
ends with DID_OK.  The pages keep whatever they held.
   =20
Over a 1 MiB pread of a file that had never been read, 999424 bytes came
back as the contents of an unrelated file the same process had written
earlier.  pread() returned 1048576 and errno was 0.

> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index d35f93451ee9b..599bfed79847b 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -397,6 +397,62 @@ void iscsi_tcp_hdr_recv_prep(struct iscsi_tcp_conn *=
tcp_conn)
>  }
>  EXPORT_SYMBOL_GPL(iscsi_tcp_hdr_recv_prep);
> =20
> +/**
> + * iscsi_tcp_check_data_in - verify a read received the data the target =
claimed
> + * @task: scsi command task
> + * @status: SCSI status of the PDU carrying the status
> + * @flags: flags of the PDU carrying the status
> + * @residual: residual count of that PDU
> + * @sense: sense data segment of that PDU, if it has one
> + * @senselen: length of @sense
> + *
> + * Check the payload only for a completion that reports the whole buffer=
 as
> + * transferred.  That is SAM_STAT_GOOD, and also CHECK_CONDITION with a =
sense
> + * key of RECOVERED_ERROR, which sd_done() counts as fully transferred. =
 Any
> + * other status means the command failed and the data may legitimately be
> + * absent.
> + *
> + * ISCSI_FLAG_CMD_UNDERFLOW and ISCSI_FLAG_DATA_UNDERFLOW share a value,=
 so the
> + * Data-In and SCSI Response paths both use this.
> + */
> +static int iscsi_tcp_check_data_in(struct iscsi_task *task, u8 status,
> +				   u32 flags, u32 residual,
> +				   const void *sense, u32 senselen)
> +{
> +	struct iscsi_tcp_task *tcp_task =3D task->dd_data;
> +	struct scsi_cmnd *sc =3D task->sc;
> +	unsigned int expected;
> +
> +	if (!sc || sc->sc_data_direction =3D=3D DMA_TO_DEVICE)
> +		return 0;
> +
> +	if (status !=3D SAM_STAT_GOOD) {
[Severity: High]
Does this code need to verify the iSCSI response field before checking stat=
us?

According to RFC 3720, if an iSCSI SCSI Response PDU has a non-zero response
field (indicating an iSCSI-level failure like Target Failure), the cmd_stat=
us
field is undefined and typically set to 0.

If response is non-zero and cmd_status is 0 (SAM_STAT_GOOD), this function
will enforce data_in_bytes =3D=3D expected.

Because the command failed at the transport layer, no data was transferred
(data_in_bytes =3D 0). iscsi_tcp_check_data_in() will incorrectly return
ISCSI_ERR_DATALEN.

This error propagates up and causes the TCP connection to be entirely torn
down, instead of simply failing the individual SCSI command gracefully as t=
he
pre-patch code did.

> +		struct scsi_sense_hdr sshdr;
> +		const u8 *s =3D sense;
> +		u16 len;
> +
> +		if (status !=3D SAM_STAT_CHECK_CONDITION || !s || senselen < 2)
> +			return 0;
[Severity: Critical]
Does this bypass the length validation for out-of-band RECOVERED_ERROR sense
data?

If a target responds to a read command with a short transfer and
SAM_STAT_CHECK_CONDITION, but omits inline sense data (datalen =3D 0), this
code sees !s and returns 0, bypassing the new tcp_task->data_in_bytes =3D=3D
expected payload validation.

The SCSI midlayer error handler will then issue REQUEST SENSE. If the target
replies with RECOVERED_ERROR, sd_done() will force good_bytes =3D
scsi_bufflen(SCpnt) and the midlayer will successfully complete the command.

This can lead to silent data corruption and kernel memory leaks, which matc=
hes
the exact issue this patch aimed to fix.

> +		len =3D get_unaligned_be16(s);
> +		if (len + 2U > senselen)
> +			return 0;
> +		if (!scsi_normalize_sense(s + 2, len, &sshdr) ||
> +		    sshdr.sense_key !=3D RECOVERED_ERROR)
> +			return 0;
> +	}
> +
> +	expected =3D sc->sdb.length;
> +	if (flags & ISCSI_FLAG_DATA_UNDERFLOW) {
> +		if (residual > expected)
> +			return 0;
[Severity: Critical]
Can this early return allow an integer underflow that bypasses the payload
validation?

If the target sets ISCSI_FLAG_DATA_UNDERFLOW, this unconditionally returns 0
if residual > expected, bypassing the new payload length check.

The code assumes the SCSI midlayer will safely reject out-of-bounds residua=
ls.
However, in the preexisting iscsi_scsi_cmd_rsp() and iscsi_data_in_rsp(), t=
he
bounds check res_count <=3D scsi_bufflen(sc) is bypassed using a short-circ=
uit
operator if ISCSI_FLAG_CMD_OVERFLOW is also set (which shares the exact same
bit value 0x04 as ISCSI_FLAG_DATA_OVERFLOW):

drivers/scsi/libiscsi.c:iscsi_scsi_cmd_rsp() {
    ...
    if (res_count > 0 &&
        (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW ||
         res_count <=3D scsi_bufflen(sc)))
            /* write side for bidi or uni-io set_resid */
            scsi_set_resid(sc, res_count);
    ...
}

If a target sends a PDU with BOTH the Underflow and Overflow flags set, alo=
ng
with a residual_count larger than the buffer, scsi_set_resid(sc, residual)
is executed with the malicious count.

In scsi_finish_command(), the calculation good_bytes -=3D scsi_get_resid(cm=
d)
suffers an integer underflow, wrapping good_bytes to an enormous positive
value.

scsi_io_completion() then passes this value to blk_update_request(), which
caps it to the request size and completes the entire buffer as a success.
This completely bypasses the patch's protection.

> +		expected -=3D residual;
> +	}
> +	if (tcp_task->data_in_bytes =3D=3D expected)
> +		return 0;
> +
> +	return ISCSI_ERR_DATALEN;
> +}
> +
>  /*
>   * Handle incoming reply to any other type of command
>   */
> @@ -410,8 +466,30 @@ iscsi_tcp_data_recv_done(struct iscsi_tcp_conn *tcp_=
conn,
>  	if (!iscsi_tcp_dgst_verify(tcp_conn, segment))
>  		return ISCSI_ERR_DATA_DGST;
> =20
> -	rc =3D iscsi_complete_pdu(conn, tcp_conn->in.hdr,
> -			conn->data, tcp_conn->in.datalen);
> +	if ((tcp_conn->in.hdr->opcode & ISCSI_OPCODE_MASK) =3D=3D
> +	    ISCSI_OP_SCSI_CMD_RSP) {
> +		struct iscsi_scsi_rsp *rsp =3D
> +			(struct iscsi_scsi_rsp *)tcp_conn->in.hdr;
> +		struct iscsi_task *task;
> +
> +		spin_lock(&conn->session->back_lock);
> +		task =3D iscsi_itt_to_ctask(conn, rsp->itt);
> +		if (!task) {
> +			spin_unlock(&conn->session->back_lock);
> +			return ISCSI_ERR_BAD_ITT;
> +		}
> +		rc =3D iscsi_tcp_check_data_in(task, rsp->cmd_status, rsp->flags,
> +					     be32_to_cpu(rsp->residual_count),
> +					     conn->data, tcp_conn->in.datalen);
[Severity: High]
Does this code need to pass or verify rsp->response before invoking the
payload length checks?

As mentioned above, if the iSCSI response field indicates a transport failu=
re,
cmd_status is undefined. This caller passes rsp->cmd_status without verifyi=
ng
the response field first.

[ ... ]
> @@ -783,6 +873,37 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struc=
t iscsi_hdr *hdr)
>  			break;
>  		}
> =20
> +		if (opcode =3D=3D ISCSI_OP_SCSI_CMD_RSP) {
> +			struct iscsi_scsi_rsp *rsp =3D (struct iscsi_scsi_rsp *)hdr;
> +
> +			spin_lock(&conn->session->back_lock);
> +			task =3D iscsi_itt_to_ctask(conn, hdr->itt);
> +			if (!task) {
> +				spin_unlock(&conn->session->back_lock);
> +				return ISCSI_ERR_BAD_ITT;
> +			}
> +			if (tcp_conn->in.datalen) {
> +				/*
> +				 * The sense is in the data segment, so the
> +				 * check has to wait for it.
> +				 */
> +				spin_unlock(&conn->session->back_lock);
> +				iscsi_tcp_data_recv_prep(tcp_conn);
> +				return 0;
> +			}
> +			rc =3D iscsi_tcp_check_data_in(task, rsp->cmd_status,
> +						     rsp->flags,
> +						     be32_to_cpu(rsp->residual_count),
> +						     NULL, 0);
[Severity: High]
Is it safe to invoke this validation using the potentially undefined
cmd_status field without verifying if rsp->response is
ISCSI_STATUS_CMD_COMPLETED?

Like the previous caller, this omits checking the response field, leading to
the same connection teardown issue on target failure.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007070207.6667=
38-1-yhlee@isslab.korea.ac.kr?part=3D1
