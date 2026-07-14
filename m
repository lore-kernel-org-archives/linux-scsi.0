Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285352FBE1F
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 11:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784030091; cv=none; b=SIFQB82XfsJ3jFfflzWT4p7lnjfuy2N5JUyvZvcoJWv5bgCpNRxGiW0HsSISVCBX95dNHtGHCIECuwnYLmFwcXWxQJidbBpvjmb9IocMLIbIBrx3zjnBLWRry4Aqb3MjARG2F/7UW7N2y93TrFS08fOmf3BPaDqR7a55fQjKlrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784030091; c=relaxed/simple;
	bh=k9yfeUhewwgJUBeJY/yrdrh0Hll4f4Kd0W9iPViAwf8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CPjSD7Cii11k9pW+Ax9qE/TO4PpAZbfXd03s8yUVXfAPFYuQ1tNe3DeKCLQKfjd9ydrEowLtsJpzsoJoZqcCGpmWUNXdFhT4ZaWWa3LzAmdRb6vPWl+P9NMuhNUACx5r00brKsPvX/iYCXUKq9LP2yRmC/vKUl9w0aX85GjewXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OXe3YFT2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OXe3YFT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FABC1F00A3A;
	Tue, 14 Jul 2026 11:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784030089;
	bh=1pOIiOXIyvOGC0TDp+Jw6Py13OzRj8JM/AoH++YVEZU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OXe3YFT245X10YjNLp9mmvRvyKwYIEMZgwVTiPUeSEERDijRGMBZ3Nw37hoGeHLlj
	 A2JL0fZMVtiUjsm6jIBa6aLC42QgX45mWCjFdfMWybTj29NPsbFnY6NddK6OxbzIqG
	 yulMPzlJOF6ls93xiVb7hM0eACBcbh1sYjHCGWhh6RPQiWKVYL21UudR8xyzSjT3R5
	 b0vwtxEj0AqHh+aluspKjMdea3mC375SxhzhJJkZczDtDuDGsDQ57yoKXXJ3JvLRRx
	 5dcUz9olYwgYj3b8V2UAi/5vVkJj3Lo0524mTvJgQR5acCEAuIAlmQwM9G4Jcu5ykP
	 3+xzwOTuQ92PQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 11/56] scsi: qla2xxx: Update IO path to use 128-byte
 IOCBs for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-12-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-12-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 11:54:49 +0000
Message-Id: <20260714115449.9FABC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Legacy 64-byte IOCB structures are incorrectly used on 29xx hardwa=
re for management, control, and abort paths, causing field corruption and o=
ut-of-bounds writes.
- [High] Response queue payload extraction and continuation processing loop=
s fail to account for the 128-byte extended format on 29xx hardware, droppi=
ng data.
- [High] The driver miscalculates the required IOCB count (`req_cnt`) for s=
tandard SCSI commands on 29xx hardware, causing ring desynchronization.
- [High] Target mode I/O requests with >6 scatter-gather segments on 29xx h=
ardware cause ring desynchronization and zero-length DMA truncation.
- [High] Open-coded legacy response ring advance in `qla27xx_copy_multiple_=
pkt()` incorrectly increments by 64 bytes on 29xx hardware.
--

--- Patch [11]: [PATCH v4 11/56] scsi: qla2xxx: Update IO path to use 128-b=
yte IOCBs for 29xx ---
commit 610d3e25167b47c9d3bb68554aac42ed0e7ff0a5
Author: Anil Gurumurthy <agurumurthy@marvell.com>

scsi: qla2xxx: Update IO path to use 128-byte IOCBs for 29xx

This commit wires the 128-byte extended IOCB structures into the IO
submission, completion, and queue-management paths for the 29xx adapters.
It introduces helpers for determining ring entry sizes and advancing ring
slots while falling back to the existing 64-byte IOCBs for earlier adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
[ ... ]
> @@ -1620,46 +1640,84 @@ qla24xx_start_scsi(srb_t *sp)
>  	cmd->host_scribble =3D (unsigned char *)(unsigned long)handle;
>  	req->cnt -=3D req_cnt;
> =20
> -	cmd_pkt =3D (struct cmd_type_7 *)req->ring_ptr;
> -	cmd_pkt->handle =3D make_handle(req->id, handle);
> +	if (IS_QLA29XX(ha)) {
[ ... ]
> +		/* Build IOCB segments */
> +		qla29xx_build_scsi_iocbs(sp, cmd_pkt_ext, tot_dsds, req);
> +
> +		/* Set total data segment count. */
> +		cmd_pkt_ext->entry_count =3D (uint8_t)req_cnt;

[Severity: High]
Could this miscalculate the required IOCB count for standard SCSI commands =
on
29xx hardware? Earlier in qla24xx_start_scsi(), req_cnt is calculated using
qla24xx_calc_iocbs(). That assumes 1 inline DSD and 5 per continuation, but
29xx extended IOCBs carry 4 inline DSDs and 10 per continuation. Writing the
oversized req_cnt to cmd_pkt_ext->entry_count might desynchronize the ring =
if
it doesn't match the slots built by qla29xx_build_scsi_iocbs().

[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
[ ... ]
> @@ -287,13 +281,7 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host =
*vha,
>  				break;
>  			}
> =20
> -			rsp_q->ring_index++;
> -			if (rsp_q->ring_index =3D=3D rsp_q->length) {
> -				rsp_q->ring_index =3D 0;
> -				rsp_q->ring_ptr =3D rsp_q->ring;
> -			} else {
> -				rsp_q->ring_ptr++;
> -			}
> +			qla_rsp_ring_advance(rsp_q);
>  			no_bytes =3D (pending_bytes > sizeof(new_pkt->data)) ?
>  			    sizeof(new_pkt->data) : pending_bytes;

[Severity: High]
Does this truncate the payload extraction on 29xx hardware? The code caps t=
he
read to sizeof(new_pkt->data) (which is 60 bytes) instead of the 124-byte
capacity of the 29xx sts_cont_entry_ext structure. Because
qla_rsp_ring_advance() moves the pointer by 128 bytes, it seems this might
permanently skip the remaining 68 bytes of data in every extended continuat=
ion
slot. A similar cap exists in qla27xx_copy_fpin_pkt() and
qla2x00_status_cont_entry().

[Severity: High]
Is there a missing update to qla27xx_copy_multiple_pkt() in this patch?
Many open-coded ring advances were replaced with qla_rsp_ring_advance()
to handle the 128-byte stride on 29xx hardware, but it appears
qla27xx_copy_multiple_pkt() still manually increments rsp_q->ring_ptr++.
Advancing by 64 bytes instead of the 29xx 128-byte stride might cause the
firmware to read zeros and drop multi-IOCB unsolicited ELS/FPIN packets.

[Severity: High]
Does this also cause field corruption on 29xx hardware for abort paths? In
qla24xx_process_abts() in drivers/scsi/qla2xxx/qla_isr.c, the 128-byte slot=
 is
cast to the 64-byte els_entry_24xx struct for the ABTS response, which might
corrupt fields like control_flags. Similarly, legacy 64-byte structures are
still used in qla24xx_abort_iocb(), qla24xx_tm_iocb(), and qla_els_pt_iocb(=
),
writing vp_index to offset 51 instead of the 18 or 30 required by the 29xx
extended abort/TM IOCBs.

[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
[ ... ]
> @@ -2600,11 +2596,12 @@ static void qlt_load_cont_data_segments(struct ql=
a_tgt_prm *prm)
>  {
>  	int cnt;
>  	struct dsd64 *cur_dsd;
> +	struct qla_hw_data *ha =3D prm->cmd->qpair->hw;
> =20
>  	/* Build continuation packets */
>  	while (prm->seg_cnt > 0) {
>  		cont_a64_entry_t *cont_pkt64 =3D
> -			(cont_a64_entry_t *)qlt_get_req_pkt(
> +			(cont_a64_entry_t *)qlt_get_req_pkt(ha,
>  			   prm->cmd->qpair->req);
> =20
>  		/*
> @@ -2614,7 +2611,7 @@ static void qlt_load_cont_data_segments(struct qla_=
tgt_prm *prm)
>  		 * that.
>  		 */
> =20
> -		memset(cont_pkt64, 0, sizeof(*cont_pkt64));
> +		memset(cont_pkt64, 0, qla_req_entry_size(ha));

[Severity: High]
Will target mode I/O requests with more than 6 scatter-gather segments cause
ring desynchronization here? The loop right below this initialization still
hardcodes QLA_TGT_DATASEGS_PER_CONT_24XX (5 DSDs) per continuation packet. =
On
29xx hardware, the firmware reads 10 DSDs per continuation packet from the
128-byte slot, which could lead to reading empty DSDs and terminating the
transfer early. qlt_pci_map_calc_cnt() also appears to allocate the number =
of
continuation packets based on 5 DSDs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D11
