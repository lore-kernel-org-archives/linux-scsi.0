Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48C35B206
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 03:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791344100; cv=none; b=bzv4wOKLz13nQuMc35L3ZuzaYJ2WAG/HgOsRoYgoJe4wvO3CXvLollypXJKDWRDDGSpRcYH8lfu96TRC/GvShpTwRkUBPuQj5dEQ5n8yL0DMeaF43u/KdMLQmuOUCcEZgC+86i+jIW70kl9UElaxkz5U7t0PD87BIzNwbunRTVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791344100; c=relaxed/simple;
	bh=EShBFTK7AgjOJdRzSChQqKetP99bwVdcoYD2QO60Uy4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=SFlt+97EUJQ5vQaLmIxRA/mQUesDYUkXl43KdgPOL5LyK34Fuy97LrxujVnSelWx/JDMqLLr7t7EQYBMaxGX5idHLg2EBgEQhEx97F+tblECes409/4gHwMBS2Xc8uyoQsjaj0r55x89L4cC69d2iAyJnvSeMarwPqBIYXk/ETU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BMix1RrF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BMix1RrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399231F0089B;
	Wed,  7 Oct 2026 03:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791344099;
	bh=S7ESzFlwNVnn7wgiKnEcj8nYkW0XAwrn4D4osrrW3Qw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BMix1RrFQmqCz4ebvf2gHxJWDBI5UUVBVV4+RCcDeDTnTIWAHlqxadNU/447dUBEP
	 dqBPjgb5yzJKFDEB8WoHnUoWPVYieUnY1bhLGt+S6f8leo4HF7KTjH5RQ2yOvRMgqg
	 xv5zI+MHpiH6yJrAef2PvEUg5Vm/sFHERbsHWBb0yDwJxQ6F2yD1rd+8R0yCtVWx6g
	 DIhcQcDqt1zTIZECCW7PTzVkbzkmv4jbhyonWkvInHn+wXfMtqo6E4rFlinO6PZ5rH
	 5KyZVdHFTMshpyUEVw5tiX22MDUeluR3a7X76bVvVPjvqPX4UVZ2++62vq2ncsOaBt
	 5TGlLN160Dzug==
Message-ID: <sashiko-outbox-162616@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: libiscsi_tcp: check that a read got the data
 the target claimed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007032501.640372-1-yhlee@isslab.korea.ac.kr>
References: <20261007032501.640372-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 03:34:58 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] iscsi: iscsi_tcp_check_data_in drops TCP connection on valid SCSI =
error responses
--

commit 40deb827eba702521931dc06923a07cc37ef617e
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: libiscsi_tcp: check that a read got the data the target claimed

This commit adds per-task payload counting to verify that a read receives
the exact amount of data the target claimed. It compares the total received
bytes against the expected buffer length, returning an error if they do not
match.

> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index d35f93451ee9b..6d8ace85c51ca 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -467,6 +467,37 @@ void iscsi_tcp_cleanup_task(struct iscsi_task *task)

[ ... ]

> +static int iscsi_tcp_check_data_in(struct iscsi_task *task, u32 flags,
> +				   u32 residual)
> +{
> +	struct iscsi_tcp_task *tcp_task =3D task->dd_data;
> +	struct scsi_cmnd *sc =3D task->sc;
> +	unsigned int expected;
> +
> +	if (!sc || sc->sc_data_direction =3D=3D DMA_TO_DEVICE)
> +		return 0;
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

[Severity: High]
Will returning ISCSI_ERR_DATALEN here cause the connection to be dropped on
valid SCSI error responses?

For valid SCSI failures, such as SAM_STAT_CHECK_CONDITION, the target might
not start transferring Data-In PDUs and could optionally omit setting the
ISCSI_FLAG_CMD_UNDERFLOW flag. Under these circumstances, tcp_task->data_in=
_bytes
will be 0 while the expected length remains sc->sdb.length, resulting in an
immediate ISCSI_ERR_DATALEN error rather than allowing upper layers to
process the sense data.

[ ... ]

> @@ -783,6 +824,31 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struc=
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
> +			rc =3D iscsi_tcp_check_data_in(task, rsp->flags,
> +						     be32_to_cpu(rsp->residual_count));
> +			if (rc) {
> +				spin_unlock(&conn->session->back_lock);
> +				return rc;
> +			}

[Severity: High]
Is it safe to perform this validation in iscsi_tcp_hdr_dissect() for every
ISCSI_OP_SCSI_CMD_RSP without first checking the command status?

Because cmd_status (e.g., SAM_STAT_GOOD versus SAM_STAT_CHECK_CONDITION) is
not verified before checking the data length, standard SCSI errors that
safely carry sense data but omit the underflow flag trigger an immediate TCP
connection teardown. Could this lead to endless session recovery loops when
processing normal error conditions?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007032501.6403=
72-1-yhlee@isslab.korea.ac.kr?part=3D1
