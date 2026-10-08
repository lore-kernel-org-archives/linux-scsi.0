Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6682C87F
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 04:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791432969; cv=none; b=GSrpbooYImPal6Q7HrsY02r4JWXJuI1HIZJ710lPILA2ScciVWAIXDpeBg/fholgDWBPj/GJHA4e6sqhZzrcQ1yzw9Oh4QjZOhRYlW3Royu657RtAo1rsJiK4uCU+UBKI8/gDmYEmmdqLE+Jrcj4YrLgCwYOpiKPmKlcUUIFMnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791432969; c=relaxed/simple;
	bh=6KDND7W5hEmGnFs+aTbEZxKXDwJ4sCyDrurI5CYOPyg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=OTbuhhmHU3q/K0oIR62ynxepl1Wv+CaI47wnVRJhutLJfTBVb/WdmwismgOKXAZ4oyHbxEl8N7k1LUgAkvdug8M4yHrlDQC/vfFu07b9l/PgXsLi/SLxI/+3NQGm8qp0CNnS5jR0WBZb7t5DcEzCo71FxGUjwSbN5CZDshPfB3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XpXfGS0t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XpXfGS0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACDF1F000FF;
	Thu,  8 Oct 2026 04:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791432967;
	bh=z5MfAEhhfpvsViKu5fFsPwS7oBWVcPwhCGbfAwJUh2c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XpXfGS0txStSK+zIlFWqBvMo71czKJxgNY0vdCut5GcQe+aVsRI+HHb29RBiKfBPV
	 0IqtSpMxmmZEUHc9QUZFFIemgDGhWMfKP8JGBkQhxtikOUvy80bELRhcmIPnyNiMC1
	 Or+jbOEwBWx5OESa++AgBMTrPFwEGV0XZmWfo/gZwsg0PwWaP8C/jat/Ds7XHSKfIw
	 bNVVPmLnWTCVpKA9Qb6HgUiYsC7GpLd4OZyu9dL+peF0sRm2rv2P2KIUewzxACJ65l
	 WeP6wQXrygAK5JvFovfRQxlteJNo3yYYfMFFWMsI8I+riMNCG5O5Pl8wet4WyAg90V
	 ZL2isvqJL3pbw==
Message-ID: <sashiko-outbox-163606@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6] scsi: libiscsi_tcp: zero the unsent part of a short
 read
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261008040129.747538-1-yhlee@isslab.korea.ac.kr>
References: <20261008040129.747538-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 04:16:07 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: libiscsi_tcp: breaks cxgbi hardware offload and violates DMA=
 API
--

commit a677da403d374784c9e9272a697dea8be970518e
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: libiscsi_tcp: zero the unsent part of a short read

A target can finish a read without sending the data. iscsi_tcp_data_in()
bounds each Data-In PDU against the command buffer but never adds them up,
so a completion that declares no underflow is believed and the command
ends with DID_OK.

> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index d35f93451ee9b..00bdbcc6e27e3 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -397,6 +397,61 @@ void iscsi_tcp_hdr_recv_prep(struct iscsi_tcp_conn *=
tcp_conn)
>  }
>  EXPORT_SYMBOL_GPL(iscsi_tcp_hdr_recv_prep);
> =20
> +/**
> + * iscsi_tcp_zero_unread - zero the part of a read buffer the target nev=
er sent
> + * @task: scsi command task
> + *
> + * A target can end a read without sending all of the data, in any of th=
e ways
> + * a completion can be reported.  Rather than predict from the status, t=
he
> + * sense and the residual whether the buffer was promised in full, zero =
the
> + * bytes that did not arrive.  Whatever the midlayer then reports as
> + * transferred, the caller sees zeroes and not the previous contents of =
those
> + * pages.
> + *
> + * The continuity check in iscsi_tcp_data_in() means the bytes that did =
not
> + * arrive are exactly the tail, so one range covers them.
> + */
> +static void iscsi_tcp_zero_unread(struct iscsi_task *task)
> +{
> +	struct iscsi_tcp_task *tcp_task =3D task->dd_data;
> +	struct scsi_cmnd *sc =3D task->sc;
> +
> +	if (!sc || sc->sc_data_direction !=3D DMA_FROM_DEVICE ||
> +	    tcp_task->data_in_bytes >=3D sc->sdb.length)
> +		return;
> +
> +	sg_zero_buffer(sc->sdb.table.sgl, sc->sdb.table.nents,
> +		       sc->sdb.length - tcp_task->data_in_bytes,
> +		       tcp_task->data_in_bytes);

[Severity: High]
Does this code violate the DMA API and overwrite hardware-placed data for
offloaded transfers?

For hardware offload drivers like cxgbi that use iscsi_tcp_recv_skb() for
header processing but Direct Data Placement (DDP) for data payloads,
intermediate Data-In PDUs bypass the host stack. This means
tcp_task->data_in_bytes will not be incremented for DDP'd data.

When the final completion PDU is processed and iscsi_tcp_zero_unread() is
invoked, could it zero the entire buffer (sc->sdb.length - 0), destroying t=
he
valid data already placed by the hardware?

Since the buffer is actively mapped DMA_FROM_DEVICE (e.g. via dma_map_sg()
in cxgbi_ddp_reserve()), zeroing it from the CPU without calling
dma_sync_sg_for_cpu() or prior unmapping is a strict DMA API violation. On
non-coherent architectures, cache invalidation during scsi_dma_unmap() would
further discard the CPU's zeroes.

> +}
> +

[ ... ]

> @@ -509,6 +569,11 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn=
, struct iscsi_task *task)
>  		return ISCSI_ERR_DATA_OFFSET;
>  	}
> =20
> +	if (tcp_task->data_offset !=3D tcp_task->data_in_bytes)
> +		return ISCSI_ERR_DATA_OFFSET;

[Severity: High]
Does this strict continuity check incorrectly fail hardware offloaded
transfers?

If the final PDU contains a data segment after intermediate headers bypassed
the software stack (due to offload), tcp_task->data_in_bytes will not accou=
nt
for the offloaded data. Will tcp_task->data_offset !=3D tcp_task->data_in_b=
ytes
then incorrectly evaluate to true, causing the connection to fail with
ISCSI_ERR_DATA_OFFSET?

> +
> +	tcp_task->data_in_bytes +=3D tcp_conn->in.datalen;
> +
>  	conn->datain_pdus_cnt++;
>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008040129.7475=
38-1-yhlee@isslab.korea.ac.kr?part=3D1
