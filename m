Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02E6269D18
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 04:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791348834; cv=none; b=XOOElxVOlMZEinE7M1VLsrfLlQvHhto3WLPdPa/MG4j11SzvTdx/RGyjuDtGYpVwP2hOGGNQp3d5sC+pFjnFIJIdq9+GHidw3oSgwgQgv0o8XBuWSlx8Oa7csFELZT/iRaZB5kFC59lK5AIj/KtfAZediu4nn9qKWsa9i1fCbvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791348834; c=relaxed/simple;
	bh=lzHeGDgkRrOZY7iEnV33tV34OXd09T7tcaG11N6Yujw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=messo3UGiL/k/fVDd9RGpQNc0zl26uI7q06he8mgfWR/Tnqs1V6HRgQKmrJ9LOMQsHntsOLayj/U3hJ+YNPxonq3p2PE6cyki60CxZxMzesYRvNkvm3jS2XGYNfonWR+TY7/5j9+XWVR+79vYYzLIeRuYq/gQN0e3LadtWLMnd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a32qbsg4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a32qbsg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4701F0089B;
	Wed,  7 Oct 2026 04:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791348833;
	bh=uLQBZZZL7dCXyaXNgjKOLq0DyP2Gdj6PC/BJsN4fVE0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a32qbsg4w2Q7/PPxndy6LuhPghxa5fNA/+3BeantwC+tOBwlrZ6FSoyMdZUSr6Anv
	 M+aGyGxkw2R4uMhA4MsXiVjzg0QtbdTYgtvllzLGOdsoqA5LSaeHDql6oil32ut1Ar
	 9F9pJTARzqkjHH+xyGfNY8dWPVrezcEK6WgV111HxgoT1zEaLXe615bGCcwYX09FrG
	 zS4BY+MPCog+wizE8cpypCgHnA1/9JJ+XHQrnecFTB1ovUf+tQwSUefKlsI/29zQ/6
	 j/znV3RL7RNiK83AwDiOO13DHLSyt9NpWzrTQpI3Bh4Dqv3Y/i20iqo4nR5ov3kxbF
	 JlzMmxAhCOZnQ==
Message-ID: <sashiko-outbox-162623@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] scsi: libiscsi_tcp: check that a read got the data
 the target claimed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007044204.650687-1-yhlee@isslab.korea.ac.kr>
References: <20261007044204.650687-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 04:53:52 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] iscsi: libiscsi_tcp: bypass of short-read validation via CHECK_CON=
DITION
- [Medium] iscsi: libiscsi_tcp: strict offset enforcement breaks out-of-ord=
er Data-In sequences
--

commit c98a9b76c4a9e3b246d783ea606f33c9c6d70d07
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: libiscsi_tcp: check that a read got the data the target claimed

A target can finish a read without sending the data.  iscsi_tcp_data_in()
bounds each Data-In PDU against the command buffer but never adds them up,
so a completion that declares no underflow is believed and the command
ends with DID_OK.  The pages keep whatever they held.

> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -467,6 +467,45 @@ void iscsi_tcp_cleanup_task(struct iscsi_task *task)

[ ... ]

> +static int iscsi_tcp_check_data_in(struct iscsi_task *task, u8 status,
> +				   u32 flags, u32 residual)
> +{
> +	struct iscsi_tcp_task *tcp_task =3D task->dd_data;
> +	struct scsi_cmnd *sc =3D task->sc;
> +	unsigned int expected;
> +
> +	if (!sc || sc->sc_data_direction =3D=3D DMA_TO_DEVICE)
> +		return 0;
> +
> +	/*
> +	 * Only a successful completion promises the whole buffer.  Any other
> +	 * status is handled by the normal status and sense path.
> +	 */
> +	if (status !=3D SAM_STAT_GOOD)
> +		return 0;

[Severity: High]
Does this early return allow a malicious target to bypass the new validatio=
n?

If a target returns a short payload followed by a SCSI Command Response
containing SAM_STAT_CHECK_CONDITION and a RECOVERED_ERROR sense key, the le=
ngth
validation is skipped here.

The SCSI midlayer (such as sd_done() in drivers/scsi/sd.c) explicitly handl=
es
RECOVERED_ERROR by setting:

	good_bytes =3D scsi_bufflen(SCpnt);

treating the entire buffer as successfully read despite the short payload.

Could this leave the short-read vulnerability fully exploitable through this
error path?

> +
> +	expected =3D sc->sdb.length;
> +	if (flags & ISCSI_FLAG_DATA_UNDERFLOW) {
> +		if (residual > expected)
> +			return 0;
> +		expected -=3D residual;
> +	}
> +	if (tcp_task->data_in_bytes =3D=3D expected)
> +		return 0;
> +
> +	return ISCSI_ERR_DATALEN;
> +}

[ ... ]

> @@ -509,7 +548,18 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn=
, struct iscsi_task *task)
>  		return ISCSI_ERR_DATA_OFFSET;
>  	}
> =20
> +	if (tcp_task->data_offset !=3D tcp_task->data_in_bytes)
> +		return ISCSI_ERR_DATA_OFFSET;

[Severity: Medium]
Does this strict monotonic offset check break iSCSI protocol compliance?

The iSCSI protocol (RFC 7143) explicitly permits targets to send Data-In
sequences out of order if negotiated (DataSequenceInOrder=3DNo). Within such
sequences, DataSN strictly increments, but the byte offsets can jump
arbitrarily.

Prior to this patch, out-of-order sequences were correctly handled by relyi=
ng
on iscsi_segment_seek_sg() to seek the scatterlist and write data at the ex=
act
tcp_task->data_offset specified by the PDU header.

Could mandating data_offset =3D=3D data_in_bytes trigger a fatal protocol e=
rror
on perfectly valid out-of-order sequences, terminating the connection?

> +
> +	tcp_task->data_in_bytes +=3D tcp_conn->in.datalen;
> +
>  	conn->datain_pdus_cnt++;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007044204.6506=
87-1-yhlee@isslab.korea.ac.kr?part=3D1
