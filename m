Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34F51ABEDE
	for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 01:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789782477; cv=none; b=RtRQ4I4F4pGk4244ug4FSdDg0m2Pbrwi0QWGQ4biI6XKM7uDLm3gdfp16nCkSfMY2AUOyAcRolW+r14x4bGMnqzGRMvXZzRiRKL/szhqFuTUnXn5lGSlqxpOXbW8g/xLj0LZraQbKpB0oj+6Q9OVzM/lQuNoMVjZRiNQQneNyBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789782477; c=relaxed/simple;
	bh=QJDqkz8OCNaZ3mytFoe2PcyPCRSoRcJHQ0j81z2Ori8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kkzNsGj0IrG/e3cvcpsOjtO93mguwU4N6/+7DLqT4RrTR43wycgtxFbbxfBtW83TK5PSzWZOs5CWwAFDwNEafANK/h5QxsLGKPm5MoLcGciDNCauoKJOvuU/bYOUDpYjmxaH5loc7K4WOW8m+DdgMOUhtkBhSPOxqpc+clBCtgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OksL3Y+S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OksL3Y+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1270B1F000FF;
	Sat, 19 Sep 2026 01:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789782476;
	bh=yNVjuPxDXSHBGuis70gGZzIBBWMld+edjPZtA1lt/jM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OksL3Y+SNlZ/rRncYZWGXYM/eiZDTZ87H+HhOcWH9TqO62RmiOaVUoPZMKwH/BbeN
	 T64SnAP1NaCu3QWIxHSJQ37EpCqOFzmI99vrPyyLP2xvKSXIOvL7NBHh6nxxHg292k
	 KLqo+g1teU1Dz4/igrvruW8mtzEytt77mOSDe1xkkBFyqZq6VAQb5Nrt4zU7+H/lLk
	 Gt3Y80Tq9KTYBf9Cs2c4AGBlx0YQgW3EpaXKOf/Vbtt7K7SqknDXZmqSB2bAw6v28O
	 RYWCuqO1s9pdd1Pqba4Spo7czpDuwbW8dwI/7hkL/468+zcsPm+Mqe23sq4lJJFQZl
	 87P+DGUIAZB6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/20] scsi: ibmvfc: fix trace logging for NVMe FCP
 commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260919013306.2948028-3-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
 <20260919013306.2948028-3-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 19 Sep 2026 01:47:55 +0000
Message-Id: <20260919014756.1270B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: UAF of nvmefc_fcp_req in ibmvfc_trc_start()
- [Medium] scsi: ibmvfc: trace data dropped for SCSI TMFs
--

commit d84c85cc97fa932f9084a1571f9d4d47d52e914d
Author: Tyrel Datwyler <tyreld@linux.ibm.com>
scsi: ibmvfc: fix trace logging for NVMe FCP commands

This commit fixes trace logging for NVMe FCP commands by gating SCSI-specif=
ic
field reads on evt->cmnd. It records the NVMe SQE opcode and payload length
from the v3nvme union member for NVMe FCP events.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index aa7ae81df41b1..6558ed3c67c4b 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -257,11 +258,16 @@ static void ibmvfc_trc_start(struct ibmvfc_event *e=
vt)
> =20
>  	switch (entry->fmt) {
>  	case IBMVFC_CMD_FORMAT:
> -		entry->op_code =3D iu->cdb[0];
>  		entry->scsi_id =3D be64_to_cpu(vfc_cmd->tgt_scsi_id);
> -		entry->lun =3D scsilun_to_int(&iu->lun);
> -		entry->tmf_flags =3D iu->tmf_flags;
> -		entry->u.start.xfer_len =3D be32_to_cpu(iu->xfer_len);
> +		if (evt->cmnd) {
> +			entry->op_code =3D iu->cdb[0];
> +			entry->lun =3D scsilun_to_int(&iu->lun);
> +			entry->tmf_flags =3D iu->tmf_flags;
> +			entry->u.start.xfer_len =3D be32_to_cpu(iu->xfer_len);

[Severity: Medium]
Will this drop trace data for SCSI Task Management Functions?

When an internally generated SCSI TMF is processed, evt->cmnd is initialized
to NULL. Since the extraction of LUN and TMF flags is now strictly gated on
evt->cmnd, TMFs will be skipped entirely leaving these trace fields zeroed =
out.

> +		} else if (evt->fcp_req) {
> +			entry->op_code =3D vfc_cmd->v3nvme.iu.sqe.common.opcode;
> +			entry->u.start.xfer_len =3D evt->fcp_req->payload_length;

[Severity: High]
Can this result in a use-after-free on the NVMe FCP request?

The command has already been submitted to the hardware at this point. In
ibmvfc_send_event(), the queue lock is dropped before calling
ibmvfc_trc_start():

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_send_event() {
	...
	spin_unlock_irqrestore(&evt->queue->l_lock, flags);
	ibmvfc_trc_start(evt);
}

Because the lock is dropped, the hardware completion can race and process
the response, calling evt->done(). This hands the NVMe FCP request back to
the block layer where it is completed and freed. Meanwhile, this thread will
locklessly dereference evt->fcp_req->payload_length here, accessing the fre=
ed
memory.

> +		}
>  		break;
>  	case IBMVFC_MAD_FORMAT:

[ ... ]

> @@ -294,15 +301,19 @@ static void ibmvfc_trc_end(struct ibmvfc_event *evt)
> =20
>  	switch (entry->fmt) {
>  	case IBMVFC_CMD_FORMAT:
> -		entry->op_code =3D iu->cdb[0];
>  		entry->scsi_id =3D be64_to_cpu(vfc_cmd->tgt_scsi_id);
> -		entry->lun =3D scsilun_to_int(&iu->lun);
> -		entry->tmf_flags =3D iu->tmf_flags;
>  		entry->u.end.status =3D be16_to_cpu(vfc_cmd->status);
>  		entry->u.end.error =3D be16_to_cpu(vfc_cmd->error);
> -		entry->u.end.fcp_rsp_flags =3D rsp->flags;
> -		entry->u.end.rsp_code =3D rsp->data.info.rsp_code;
> -		entry->u.end.scsi_status =3D rsp->scsi_status;
> +		if (evt->cmnd) {
> +			entry->op_code =3D iu->cdb[0];
> +			entry->lun =3D scsilun_to_int(&iu->lun);
> +			entry->tmf_flags =3D iu->tmf_flags;
> +			entry->u.end.fcp_rsp_flags =3D rsp->flags;
> +			entry->u.end.rsp_code =3D rsp->data.info.rsp_code;
> +			entry->u.end.scsi_status =3D rsp->scsi_status;

[Severity: Medium]
Will this also drop trace data in the end trace for SCSI TMFs?

Similarly to the start trace, since evt->cmnd is NULL for SCSI TMFs, the
response code, FCP response flags, and SCSI status will be left unrecorded
for these events.

> +		} else if (evt->fcp_req) {
> +			entry->op_code =3D vfc_cmd->v3nvme.iu.sqe.common.opcode;
> +		}
>  		break;
>  	case IBMVFC_MAD_FORMAT:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919013306.2948=
028-1-tyreld@linux.ibm.com?part=3D2
