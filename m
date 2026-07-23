Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F9B376A0E
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 08:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784795154; cv=none; b=BbdyX0gvEWTzi9whu0xE0znJ9x+vzQVF5mO3wzkscxpZindm8rx7L6BPlbUeio6THtz5pU1oXBx+XUvEfM0jx90MdfSKnM5L4aEIQPxFIJZiRry2vueO0DgzTYccvJws7TEAL6UzJXwWVw+GcdpN/6mCTpZx2G67BiGLvZTU90M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784795154; c=relaxed/simple;
	bh=Wh/rd6HZ7+v3g05Erehx4qoTVE4HwC51j7INkW/0Bqs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E2j3P1lu6Ik9eEHku2FRtbr5/WkAcm98eajzmxy8C7a+HNF2uac1xdjQBZiJxTUHuQ59HuMVnsCnCBNMVnZvokgCDyMBaRR+xjMwegTJ78XHD+IhMYQVnx6Oj1ixdycF/vqfpf/ju7288R0IQGCKshaL0ps2o3ZF4IqvXQdHybw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=drUfz6EA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="drUfz6EA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8571F000E9;
	Thu, 23 Jul 2026 08:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784795152;
	bh=kI8TZKN3r1XskLUudoKixDdX/USc8VQEnxSE8nigAGw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=drUfz6EA6HYe5ppF2ksQt9yYXkb8omGOnjTnl/o7w8S0BUhMuzc1S5/xsAHlp/+/P
	 QROdl9/tvPrwXt8DOvBGZm0f7S0V4nMbOXgym5JpUjO6aFEb13QMhhL5q/AKvyosDI
	 3uJcscpg9XucCETuh07jwaT8PT2faRMz7eyjizPXPo+7KG2A7/Od145VtRosdFiRRz
	 dHjJLtgbShwHRrfKTynXyHJM3PiALdEEBplXf9gEvRi19ET/PM+C+x+dbgCIwCpKA9
	 /GmoJakqzo/XKA8TIX5cqiVlZEnzC2xq0fN99Z7at8IB3d68SETUOkji5tApU7TjUb
	 b5cmHjs1IZNKg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 11/56] scsi: qla2xxx: Update IO path to use 128-byte
 IOCBs for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-12-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-12-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 08:25:52 +0000
Message-Id: <20260723082552.AE8571F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [Critical] `qla27xx_copy_multiple_pkt` uses `rsp_q->ring_ptr++` instead o=
f `qla_rsp_ring_advance()`, immediately corrupting the 128-byte response ri=
ng on 29xx.
- [High] Target mode scatter-gather transfers > 6 segments will fail on 29x=
x due to hardcoded continuation DSD limits, and target mode unconditionally=
 uses 64-byte `ctio7_to_24xx` offsets for 128-byte IOCBs.
- [High] Payload extraction paths for PUREX, FPIN, and STATUS_CONT_TYPE res=
ponse IOCBs fail to use the extended 128-byte struct layouts on 29xx adapte=
rs, silently truncating data.
- [High] The completion path (ISR) unconditionally parses 128-byte 29xx sta=
tus IOCBs using the legacy 64-byte `sts_entry_24xx` layout, reading critica=
l fields from the wrong offsets.
- [High] `qla24xx_tm_iocb` builds Task Management IOCBs using the 24xx layo=
ut, corrupting the `vp_index` on 29xx.

Pre-existing issues:
- [High] The 24xx path in `qla24xx_dif_start_scsi` and `qla2xxx_dif_start_s=
csi_mq` fails to initialize the `vp_index` field of the `cmd_type_crc_2` IO=
CB, leaving it at 0. This breaks NPIV for DIF/PI commands on 24xx adapters.
--

--- Patch [11]: [PATCH v6 11/56] scsi: qla2xxx: Update IO path to use 128-b=
yte IOCBs for 29xx ---
commit 6d84675eb563d48a8c7790164426bd51a8bdfb65
Author: Anil Gurumurthy <agurumurthy@marvell.com>

scsi: qla2xxx: Update IO path to use 128-byte IOCBs for 29xx

This patch updates the IO submission, completion, and queue-management paths
to support 128-byte extended IOCBs on 29xx adapters. It introduces helpers
for dynamic ring entry size and pointer advancement to support both legacy
and extended layouts.

Link: https://lore.kernel.org/oe-kbuild-all/202607141827.R9mpeMZx-lkp@intel=
.com/

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index dbe3cd4e274c8..aab7905c0d6ca 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
[ ... ]
> @@ -1829,17 +1901,24 @@ qla24xx_dif_start_scsi(srb_t *sp)
>  	req->cnt -=3D req_cnt;
> =20
>  	/* Fill-in common area */
> -	cmd_pkt =3D (struct cmd_type_crc_2 *)req->ring_ptr;
> +	cmd_pkt =3D (struct cmd_type_crc_2 *)qla_req_ring_slot(ha, req);
>  	cmd_pkt->handle =3D make_handle(req->id, handle);
> =20
>  	clr_ptr =3D (uint32_t *)cmd_pkt + 2;
> -	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
> +	memset(clr_ptr, 0, qla_req_entry_size(ha) - 8);
> =20
>  	/* Set NPORT-ID and LUN number*/
>  	cmd_pkt->nport_handle =3D cpu_to_le16(sp->fcport->loop_id);
> -	cmd_pkt->port_id[0] =3D sp->fcport->d_id.b.al_pa;
> -	cmd_pkt->port_id[1] =3D sp->fcport->d_id.b.area;
> -	cmd_pkt->port_id[2] =3D sp->fcport->d_id.b.domain;
> +	if (!IS_QLA29XX(ha)) {
> +		cmd_pkt->port_id[0] =3D sp->fcport->d_id.b.al_pa;
> +		cmd_pkt->port_id[1] =3D sp->fcport->d_id.b.area;
> +		cmd_pkt->port_id[2] =3D sp->fcport->d_id.b.domain;
> +	}

[Severity: High]
This is a pre-existing issue, but does the 24xx branch fail to initialize
the vp_index field here?

Because vp_index is not assigned, it remains at the zeroed default. This
breaks NPIV for DIF/PI commands on 24xx adapters, as the switch will receive
frames from the base port's WWPN instead of the virtual port's WWPN.

This same pre-existing issue appears in qla2xxx_dif_start_scsi_mq() as well.

> +	/*
> +	 * vp_index: 24xx uses a uint8_t field at offset 51 (in port_id
> +	 * group); 29xx replaces that region with control_flags_2/vp_index as
> +	 * __le16s starting at offset 48.
> +	 */
[ ... ]
> @@ -4289,8 +4529,15 @@ qla_start_scsi_type6(srb_t *sp)

[Severity: High]
Are Task Management IOCBs built correctly for 29xx hardware?

When issuing an abort or reset, qla24xx_tm_iocb() fills the 128-byte slot
assuming the 64-byte tsk_mgmt_entry layout. It writes port_id to offset 48
and vp_index to offset 51, but on 29xx (tsk_mgmt_entry_ext), vp_index is a
16-bit field at offset 28.

Could this cause TMF commands to be routed to the wrong virtual port and
overwrite reserved fields?

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index c47c38e099ff8..e95fb0e59f387 100644
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
Does this code truncate the payload extraction on 29xx adapters?

sizeof(new_pkt->data) evaluates to 60 bytes (for sts_cont_entry_t), but a
29xx continuation slot holds 124 bytes of data. It appears the remaining
64 bytes will be skipped and lost here.

The same truncation issue exists in qla27xx_copy_fpin_pkt() and
qla2x00_status_cont_entry() where SCSI sense data extraction is also
limited to sizeof(pkt->data).

>  			if ((buffer_copy_offset + no_bytes) <=3D total_bytes) {
[ ... ]
> @@ -4003,13 +3980,7 @@ void qla24xx_process_response_queue(struct scsi_ql=
a_host *vha,
>  		pkt =3D (struct sts_entry_24xx *)rsp->ring_ptr;
>  		cur_ring_index =3D rsp->ring_index;
> =20
> -		rsp->ring_index++;
> -		if (rsp->ring_index =3D=3D rsp->length) {
> -			rsp->ring_index =3D 0;
> -			rsp->ring_ptr =3D rsp->ring;
> -		} else {
> -			rsp->ring_ptr++;
> -		}
> +		qla_rsp_ring_advance(rsp);

[Severity: High]
Will the completion path correctly parse 128-byte 29xx status IOCBs?

The main loop processes completions using the legacy 64-byte sts_entry_24xx
layout. For example, qla2x00_status_entry() reads scsi_status from
offset 22, but on 29xx (sts_entry_24xx_ext), scsi_status is located at
offset 54. Could this result in misinterpreting completion status and
residual counts?

[Severity: Critical]
Did we miss converting a manual pointer increment in
qla27xx_copy_multiple_pkt()?

If rsp_q->ring_ptr++ is used there instead of qla_rsp_ring_advance(), the
pointer will advance by 64 bytes instead of 128 bytes on 29xx hardware,
permanently desynchronizing the driver's view of the ring from the firmware.

> =20
>  		if (pkt->entry_status !=3D 0) {
>  			if (qla2x00_error_entry(vha, rsp, (sts_entry_t *) pkt))
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index e47da45e93a01..53a505df8da0a 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
[ ... ]
> @@ -2549,9 +2545,9 @@ static int qlt_24xx_build_ctio_pkt(struct qla_qpair=
 *qpair,
>  	uint16_t temp;
>  	struct qla_tgt_cmd      *cmd =3D prm->cmd;
> =20
> -	pkt =3D (struct ctio7_to_24xx *)qpair->req->ring_ptr;
> +	pkt =3D (struct ctio7_to_24xx *)qla_req_ring_slot(qpair->hw, qpair->req=
);
>  	prm->pkt =3D pkt;
> -	memset(pkt, 0, sizeof(*pkt));
> +	memset(pkt, 0, qla_req_entry_size(qpair->hw));
> =20
>  	pkt->entry_type =3D CTIO_TYPE7;
>  	pkt->entry_count =3D (uint8_t)prm->req_cnt;

[Severity: High]
Are we sure it is safe to cast the 128-byte slot to the legacy 64-byte
ctio7_to_24xx struct here?

On 29xx hardware, qla_req_ring_slot() will return a 128-byte slot, but
writing to it with the 64-byte struct offsets will misalign critical fields
like vp_index.

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

[Severity: High]
Does this continuation logic correctly handle the 29xx hardware requirement=
s?

Looking at the loop below, only 5 DSDs are populated into the 128-byte
extended continuation IOCB here, but 29xx hardware expects 10 DSDs. Will
the firmware terminate the transfer early when it encounters the zeroed 6th
DSD?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D11
