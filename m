Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C09E3769FE
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781260172; cv=none; b=TL8d2pIfzIQ7SrFdy5FSTstfQSj+Wxk6RWhFc6cPDJSPV3IASVzEmUEJqb59Fly8HdNAco4hsfob8mexOhoiP/mwblTnKB7r3Vg7YlYLb57iXXOWdkwuS5GSrn6jB6qDhGEliZsHVhw0zV3CLo/AN9dJXlkSl2aBS4+6zAwgxpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781260172; c=relaxed/simple;
	bh=aw47zPtum57c+j6QKAreGFn49RNJ+SDQLA3zTsQHXXA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bwwJGMvQLHZrz4AtCS9twlaJO1uIITuKQdLyOqepmj/B02ApCZmP9zvYetGI3Qgm91s4qmrKIu4vSthVD5bZNzOcl7XAO0JWPx+gKOhqSJsmJgHURuykEnQfS3A3M8/yayIXM6gaRDnDFqlcyaaFGHdFFi/3TvLtPVFF5WNrpbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AoOExqx7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AoOExqx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E0B1F000E9;
	Fri, 12 Jun 2026 10:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781260171;
	bh=PkhE0+X/rpirQ64yu+SpipVaT5mEzTQuAdLppVr/xnI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AoOExqx7HjN4mNifOsMZG2kUHsvkp6vBZibCVnTE6XezhcKjLnFlie99QC9UeVgOE
	 ihQOrY4jy+48i67OO9vIVdT3XrW1sMj6XM+Lx/DQr2H3u0+2PQMKTsdj2RrirS5S6w
	 VcNS5dsX71YYQJcodbbEy2hD7/+0VgpXAf/f4VVUysLsvvdiGdX50XeLmbIQzdIaJF
	 sdjImwlELs0K5be3Qjc8u33it9C+A3fvfb9WRWGQqRkk0L0+1l58+jTj9YUFNxVoqA
	 621ZSv7bPhPdqZ+exiM9SQTAekh+9N39WG7t3FMlVP9FZkqfchdYecRLxmAhxL+pne
	 4xNqZ9LH710VQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/60] scsi: qla2xxx: Update IO path to use 128-byte
 IOCBs for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-13-njavali@marvell.com>
References: <20260612095333.1666592-13-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:29:30 +0000
Message-Id: <20260612102930.E8E0B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Single-queue SCSI submission paths (`qla24xx_start_scsi` and `qla2=
4xx_dif_start_scsi`) fail to format 128-byte extended IOCBs on 29xx adapter=
s.
- [High] Target mode IOCB builders write 64-byte packets to the frozen `req=
->ring_ptr` on 29xx adapters.
- [High] T10-PI DIF bundling is unconditionally disabled on 29xx adapters i=
n MQ mode.
--

commit 9d1c8cdada293dd8d2e57a08796bee646ebd3d4f
Author: Anil Gurumurthy <agurumurthy@marvell.com>
scsi: qla2xxx: Update IO path to use 128-byte IOCBs for 29xx
   =20
Wire the 128-byte extended IOCB structures into the IO submission,
completion, and queue-management paths. On 29xx adapters the driver
now builds cmd_type_6_ext / cmd_type_7_ext command IOCBs and processes
the corresponding extended status entries.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 948242f0088e7..c79c1cca0b7df 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
[ ... ]
> @@ -2693,6 +2697,7 @@ static struct isp_operations qla29xx_isp_ops =3D {
>  	.read_optrom_region	=3D qla29xx_read_optrom_data,
>  	.write_optrom_region	=3D qla29xx_write_optrom_data,
>  	.get_flash_version	=3D qla24xx_get_flash_version,
> +	.start_scsi		=3D qla24xx_dif_start_scsi,
>  	.start_scsi_mq		=3D qla2xxx_dif_start_scsi_mq,
>  	.abort_isp		=3D qla2x00_abort_isp,
>  	.iospace_config		=3D qla83xx_iospace_config,

[Severity: High]
Does this legacy 24xx function handle the 128-byte extended IOCBs for 29xx?

If MQ is disabled, 29xx adapters fallback to the single-queue handlers like
qla24xx_start_scsi() and qla24xx_dif_start_scsi() registered here.=20

Looking at qla24xx_start_scsi(), it seems to only zero the first 56 bytes:

	cmd_pkt =3D (struct cmd_type_7 *)qla_req_ring_slot(ha, req);
	cmd_pkt->handle =3D make_handle(req->id, handle);

	/* Zero out remaining portion of packet. */
	/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
	clr_ptr =3D (uint32_t *)cmd_pkt + 2;
	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);

Could this leave the latter 64 bytes of the slot (which contain extended
inline DSDs on 29xx) entirely uninitialized, leading the firmware to fetch
and parse uninitialized memory as DMA descriptors?

> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index e47da45e93a01..fd8abdc36a56f 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
[ ... ]
> @@ -2605,6 +2601,7 @@ static void qlt_load_cont_data_segments(struct qla_=
tgt_prm *prm)
>  	while (prm->seg_cnt > 0) {
>  		cont_a64_entry_t *cont_pkt64 =3D
>  			(cont_a64_entry_t *)qlt_get_req_pkt(
> +			   prm->cmd->qpair->vha->hw,
>  			   prm->cmd->qpair->req);
> =20
>  		/*

[Severity: High]
Can the target mode IOCB builders properly initialize the 128-byte slot?

In qlt_load_cont_data_segments(), the slot is cast to the legacy 64-byte
cont_a64_entry_t structure. This results in only 64 bytes being zeroed
out, leaving the remaining 64 bytes of the 29xx extended continuation IOCB
uninitialized.

Additionally, in qlt_24xx_build_ctio_pkt() and qlt_build_ctio_crc2_pkt(),
the code writes to req->ring_ptr directly instead of using
qla_req_ring_slot(). Since qla_req_ring_advance() only advances ring_ext_ptr
on 29xx and leaves ring_ptr frozen at index 0, could this continually overw=
rite
the 0th index of the request ring buffer instead of the active slot?

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index dbe3cd4e274c8..048942986231a 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
[ ... ]
> @@ -2231,29 +2337,41 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
>  	cmd_pkt->dseg_count =3D cpu_to_le16(tot_dsds);
> =20
>  	/* Build IOCB segments and adjust for data protection segments */
> -	if (qla24xx_build_scsi_crc_2_iocbs(sp, (struct cmd_type_crc_2 *)
> -	    req->ring_ptr, tot_dsds, tot_prot_dsds, fw_prot_opts) !=3D
> -		QLA_SUCCESS)
> -		goto queuing_error;
> +	if (IS_QLA29XX(ha)) {
> +		struct cmd_type_crc_2_ext *cmd_pkt_ext =3D
> +			(struct cmd_type_crc_2_ext *)cmd_pkt;
> +
> +		cmd_pkt_ext->vp_index =3D cpu_to_le16(sp->vha->vp_idx);
> +
> +		if (qla29xx_build_scsi_crc_2_iocbs(sp, cmd_pkt_ext, tot_dsds,
> +						   tot_prot_dsds,
> +						   fw_prot_opts, 0) !=3D
> +		    QLA_SUCCESS)
> +			goto queuing_error;

[Severity: High]
Is there a reason the bundling parameter is hardcoded to 0 here?

The 24xx path calculates bundling dynamically based on the SCSI protection
operation, but here for 29xx it is unconditionally 0. This prevents the
29xx extended builder from setting up PO_ENABLE_DIF_BUNDLING.

Will this cause the firmware to use the wrong DSD layout and fail the I/O
or corrupt T10-PI protection data for SCSI operations that require
interleaved protection data?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D12
