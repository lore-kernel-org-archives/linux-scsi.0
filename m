Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A9D4D2EEC
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 15:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784819318; cv=none; b=oDyP2ATgTRQpDshfdbnKDhhpoXtu3Awj5WumaRcMAIudyoUW9BRXlOwSiu0MlkRJ7e6lnAycI5GNq3p/lXih7nChWbcBSiidSolV53HScsgrATQwjd7fLBs56s4TJMeTbjeiWXbJVempWCMVOtMvHTi2AZ1/al3mOrfimApG+94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784819318; c=relaxed/simple;
	bh=HMy9CIh+YNeWYky3hB0WlQG73hhDFY0u8LZsebxopUQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N5+u+uHGp21eR8EJtpqphhtlzPRrMqRZ4FuDlsXrTbninAwLI+tYCdvfJPPaRVbv+HS30dlH75c9CU6qx4UNocBMnQKxv+yGD4BONori77W5Ymyl1V1AYvxUHO2m5iWE4Rwq+pnBZ2lcHRqBzJAu986hadD64IYF6VchK+zFXnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKaJ35yk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKaJ35yk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A151F00A3A;
	Thu, 23 Jul 2026 15:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784819317;
	bh=fAdeCO/HLuAFpnrKjz96lYQ3Nw7QjNPmIXAeN7rjq9M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OKaJ35ykKZ1m49chWiR8WlqJbG/KvFLDdaX/OoewHZY5Mcr5oosHKn08wt8WhL3RS
	 J4mJFaRJhSLRtGJiUlhYjF5CDzJaSe3pUw+QLVKPWmmynPhsIImkdEmuVtQrX078uv
	 MrPoNhya19JNPUHmqB6jZhn0/EcAPkod2YN6PM3qQu3nU5SS+0PVkyi5UbJSMq0kNx
	 zm6DgvYSdfp1YGeOWOydoOmGSCC1UXGfAYoM4fccTdQUBdYCbDvm2UiCmbb3ninBvL
	 97nwJrORGBkM5zgxuzJk1+/2qDFnp5KFMwhyjN2A0W/9S3xmLxW1cSXlNfhEo5ohLA
	 kEf0jcgRfEvRg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 32/56] scsi: qla2xxx: Enhance task management IOCB
 handling for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-33-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-33-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 15:08:35 +0000
Message-Id: <20260723150836.F2A151F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] qla24xx_abort_iocb() and qla24xx_abort_command() fail to use the e=
xtended 29xx layout (abort_entry_24xx_ext) for ABORT_IOCB_TYPE commands.
- [High] qla_nvme_abort_set_option() writes to incorrect struct offsets for=
 29xx adapters.
--

--- Patch [32]: [PATCH v6 32/56] scsi: qla2xxx: Enhance task management IOC=
B handling for 29xx series ---
commit f1cddf95aa4847713d2ce2a2f2a175d85c061018
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Enhance task management IOCB handling for 29xx seri=
es

This commit updates qla24xx_tm_iocb() and __qla24xx_issue_tmf() to support
the extended task management structure for 29xx adapters. It introduces a
common view for the IOCB header and branches on IS_QLA29XX() for diverging
port_id and vp_index assignments.

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 4dcacee61e77e..c21d7f418f471 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
[ ... ]
> @@ -2736,26 +2736,39 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry =
*tsk)
>  	struct qla_hw_data *ha =3D vha->hw;
>  	struct srb_iocb *iocb =3D &sp->u.iocb_cmd;
>  	struct req_que *req =3D sp->qpair->req;
> +	struct tsk_mgmt_entry *tsk;
> =20
>  	flags =3D iocb->u.tmf.flags;
>  	lun =3D iocb->u.tmf.lun;
> =20
> +	/*
> +	 * tsk_mgmt_entry_ext overlays tsk_mgmt_entry through control_flags
> +	 * (offsets 0-27 are byte-identical), so the common header writes
> +	 * go through one struct tsk_mgmt_entry * view.  The ext layout
> +	 * has no port_id and uses a wider __le16 vp_index at a different
> +	 * offset, so port_id / vp_index assignments diverge per stride.
> +	 */
> +	tsk =3D pkt;
>  	tsk->entry_type =3D TSK_MGMT_IOCB_TYPE;
>  	tsk->entry_count =3D 1;
>  	tsk->handle =3D make_handle(req->id, tsk->handle);
>  	tsk->nport_handle =3D cpu_to_le16(fcport->loop_id);
>  	tsk->timeout =3D cpu_to_le16(ha->r_a_tov / 10 * 2);
>  	tsk->control_flags =3D cpu_to_le32(flags);
> -	tsk->port_id[0] =3D fcport->d_id.b.al_pa;
> -	tsk->port_id[1] =3D fcport->d_id.b.area;
> -	tsk->port_id[2] =3D fcport->d_id.b.domain;
> -	tsk->vp_index =3D fcport->vha->vp_idx;
> +	if (IS_QLA29XX(ha)) {
> +		((struct tsk_mgmt_entry_ext *)pkt)->vp_index =3D
> +		    cpu_to_le16(fcport->vha->vp_idx);
> +	} else {
> +		tsk->port_id[0] =3D fcport->d_id.b.al_pa;
> +		tsk->port_id[1] =3D fcport->d_id.b.area;
> +		tsk->port_id[2] =3D fcport->d_id.b.domain;
> +		tsk->vp_index =3D fcport->vha->vp_idx;
> +	}

[Severity: High]
Does this same IS_QLA29XX check need to be applied to abort IOCB handling
as well?

In qla24xx_abort_iocb() and qla24xx_abort_command(), for ABORT_IOCB_TYPE
commands, vp_index is written at offset 51. Without an IS_QLA29XX check, it
misses the required offset 18 for the extended 29xx layout
(abort_entry_24xx_ext).

When an asynchronous abort is issued on a 29xx adapter, this could result in
29xx firmware reading a zeroed vp_index and an invalid port ID, potentially
leading to abort failures and host resets.

[Severity: High]
Similarly, does qla_nvme_abort_set_option() need to be updated to write to
the correct struct offsets for 29xx adapters?

It currently writes the retry count to offset 56 (drv.abts_rty_cnt) instead
of the 29xx-expected offset 24. If NVMe command timeouts trigger this path,
the aborts could miss their driver-specified retry counts and response
timeouts on 29xx adapters, corrupting other fields in the 128-byte IOCB.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D32
