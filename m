Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D873E0C47
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 10:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783420033; cv=none; b=Pd53gRQfPROrOKyyHRavGP9cBsDzx87NjxyC3H52jKaSI1dQ0L1eiG8QmkpJ3ZnAxwFQojOQuXQkm2IDr81KcABg9iSAJK9e1siM8lQrVPx/G3TGc2vFw+40cRraFICcVeVF5idVTxCSNHkmRtIEGgbFnByi0HAjcbDIVUYHiIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783420033; c=relaxed/simple;
	bh=hdg5Q2uUu4w2sllwLaOu1WhfVzD47AQCg705vRgWMiA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M/PRv7eh1yYLeQLVpjV7Y6mGQsI6xpQbYJZ0BPOhl/ZZo+1yd8LN4qLhnbUjrqRoMV8CXdzobyuLEXB9Wdr2XDns+Q5LgrazguQUnHWAZsdIZtRl7dP8TgM1Dv8lDGddhSY/ytrWUaUtpPhmBhfQSlgu/cmDblxzJHn1xzwZoNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPzAUAaC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPzAUAaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869E11F00A3A;
	Tue,  7 Jul 2026 10:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783420028;
	bh=OUJFTEDNjyYUvnV23jNyrxX5PEF4MJIBOVqsw+grRvc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dPzAUAaCX4luS6y2DbP+zt4bTl9gKyIavS3pHO8HvXXtI0idfJyutjV5qdoSlJcxI
	 SKiFMKioPMSkmGL9K8z98EYaVp25QhIJHeAkqXRJCJ8rZLILi6qqv1cVMC3fxY7jzu
	 Hs04hSjlIOLom01B2BdPHRvLXHHfp57ZKxZESAN6Nfqj4HtcnhdxqOMulkCs+AdBpu
	 wkRcHyCl90ZpRu9XnIEzH8tlj62mxblqm7f2M9Z/xF2QjG2kXDo9oxE9vyMJgwRIqJ
	 xifqxZv59fkNNe9CcLG4d0rr2dAOW9We+wRSHPADMK5MxcA8iMxMDfPPKKRgcSGM5a
	 fxIwiupRY8fcQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/88] scsi: qla2xxx: Update IO path to use 128-byte
 IOCBs for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-12-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-12-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 10:27:08 +0000
Message-Id: <20260707102708.869E11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:

New issues:
- [High] Legacy non-MQ `.start_scsi` execution path builds 64-byte IOCB str=
uctures inside 128-byte ring slots on 29xx adapters, corrupting fields.
- [High] Task Management, Abort, and ELS LOGO commands are incorrectly form=
atted using legacy 64-byte builders on 29xx hardware.
- [High] Status continuation (STATUS_CONT_TYPE) payloads and PUREX/FPIN con=
tinuations are truncated to ~60 bytes on 29xx adapters.
- [High] `qla27xx_copy_multiple_pkt()` incorrectly advances the response qu=
eue ring pointer by 64 bytes instead of 128 bytes on 29xx hardware.
- [High] `qla2x00_status_entry()` parses the 128-byte 29xx extended status =
IOCB as a legacy 64-byte IOCB, reading garbage values for SCSI status and s=
ense data.

Pre-existing issues:
- [High] Double free and cross-allocator mismatch of `crc_ctx` in `qla2x00_=
sp_free_dma()`.
- [High] Unprotected access to `ha->req_q_map` and its associated ring stru=
ctures in `qla25xx_copy_mqueues` causes a Use-After-Free during concurrent =
queue teardown.
--

--- Patch [11]: [PATCH v3 11/88] scsi: qla2xxx: Update IO path to use 128-b=
yte IOCBs for 29xx ---
commit b89f951ad304cc6622ae64928f42f9fb462d5532
Author: Anil Gurumurthy <agurumurthy@marvell.com>

scsi: qla2xxx: Update IO path to use 128-byte IOCBs for 29xx

This patch updates the QLogic qla2xxx driver IO path to support 128-byte
extended IOCBs for 29xx-class adapters. It introduces structure definitions
and extended fast-path helpers to manage the new 128-byte ring stride, while
falling back to 64-byte structures for older hardware.

> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_db=
g.c
> index a7e3ec9bba47f..acb58daacf358 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
[ ... ]
> @@ -623,19 +626,19 @@ qla25xx_copy_mqueues(struct qla_hw_data *ha, void *=
ptr, __be32 **last_chain)
>  		q->chain_size =3D htonl(
>  		    sizeof(struct qla2xxx_mqueue_chain) +
>  		    sizeof(struct qla2xxx_mqueue_header) +
> -		    (req->length * sizeof(request_t)));
> +		    (req->length * req_entry_size));
>  		ptr +=3D sizeof(struct qla2xxx_mqueue_chain);
> =20
>  		/* Add header. */
>  		qh =3D ptr;
>  		qh->queue =3D htonl(TYPE_REQUEST_QUEUE);
>  		qh->number =3D htonl(que);
> -		qh->size =3D htonl(req->length * sizeof(request_t));
> +		qh->size =3D htonl(req->length * req_entry_size);
>  		ptr +=3D sizeof(struct qla2xxx_mqueue_header);
> =20
>  		/* Add data. */
> -		memcpy(ptr, req->ring, req->length * sizeof(request_t));
> -		ptr +=3D req->length * sizeof(request_t);
> +		memcpy(ptr, req->ring, req->length * req_entry_size);
> +		ptr +=3D req->length * req_entry_size;

[Severity: High]
This is a pre-existing issue, but is it possible for this unprotected memcp=
y=20
to trigger a Use-After-Free during concurrent queue teardown?

Looking at qla25xx_copy_mqueues(), it iterates over ha->req_q_map and=20
copies req->ring without holding ha->mq_lock. Concurrently,=20
qla25xx_free_req_que() calls dma_free_coherent() on req->ring prior to=20
acquiring ha->mq_lock to clear the map entry. If a firmware dump races with=
=20
queue teardown, it might access already-freed DMA memory.

[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 9038f67234448..13882a399fbc5 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
[ ... ]
> @@ -1620,13 +1640,13 @@ qla24xx_start_scsi(srb_t *sp)
>  	cmd->host_scribble =3D (unsigned char *)(unsigned long)handle;
>  	req->cnt -=3D req_cnt;
> =20
> -	cmd_pkt =3D (struct cmd_type_7 *)req->ring_ptr;
> +	cmd_pkt =3D (struct cmd_type_7 *)qla_req_ring_slot(ha, req);
>  	cmd_pkt->handle =3D make_handle(req->id, handle);
> =20
>  	/* Zero out remaining portion of packet. */
>  	/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
>  	clr_ptr =3D (uint32_t *)cmd_pkt + 2;
> -	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
> +	memset(clr_ptr, 0, qla_req_entry_size(ha) - 8);
>  	cmd_pkt->dseg_count =3D cpu_to_le16(tot_dsds);
> =20
>  	/* Set NPORT-ID and LUN number*/

[Severity: High]
Might this format a 64-byte cmd_type_7 layout into a 128-byte slot on 29xx=
=20
hardware?

Because this legacy non-MQ path doesn't branch to the extended builder, it=
=20
writes the 8-bit vp_index to offset 51 instead of the 16-bit vp_index at=20
offset 48, and places DSDs at offset 56 instead of 80. This could cause=20
the firmware to read empty data segments resulting in DMA faults.

[ ... ]
> @@ -2343,10 +2447,20 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, sr=
b_t *sp)
>  		sp->handle =3D handle;
>  	}
> =20
> -	/* Prep packet */
> +	/*
> +	 * Prep packet.  29xx posts into a 128-byte-strided ring via
> +	 * ring_ext_ptr; the first 8 bytes of struct request_ext overlay the
> +	 * common request_t header, so entry_count/handle writes are
> +	 * layout-compatible once we return the pkt as request_t *.
> +	 */
>  	req->cnt -=3D req_cnt;
> -	pkt =3D req->ring_ptr;
> -	memset(pkt, 0, REQUEST_ENTRY_SIZE);
> +	if (IS_QLA29XX(ha)) {
> +		pkt =3D (request_t *)req->ring_ext_ptr;
> +		memset(pkt, 0, REQUEST_ENTRY_SIZE_EXT);
> +	} else {

[Severity: High]
Does returning a 128-byte slot here for all commands lead to memory=20
corruption in the legacy dispatch paths?

Functions like qla2x00_start_sp() dispatch Task Management, Abort, and ELS=
=20
LOGO commands to legacy 24xx builders (e.g., qla24xx_els_logo_iocb) which=20
cast this 128-byte slot to the 64-byte structs. This causes critical fields=
=20
like vp_index to be written as 8-bit values at incorrect offsets, which=20
could misroute the commands to the physical port instead of the intended=20
NPIV virtual port.

[ ... ]
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
Could this truncate the extended PUREX payload continuations?

The 29xx hardware places up to ~120 bytes of payload per 128-byte extended=
=20
IOCB slot. However, bounding the copy length against sizeof(new_pkt->data)=
=20
uses the legacy 64-byte limit. Because qla_rsp_ring_advance() steps by 128=
=20
bytes, this skips over and permanently drops the remaining ~70 bytes of=20
payload in each extended continuation IOCB. This same truncation issue=20
appears in qla27xx_copy_fpin_pkt().

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
> =20
>  		if (pkt->entry_status !=3D 0) {
>  			if (qla2x00_error_entry(vha, rsp, (sts_entry_t *) pkt))

[Severity: High]
Are we parsing the 128-byte 29xx extended status IOCB as a legacy 64-byte=20
IOCB here?

For standard SCSI completions on 29xx hardware, the firmware generates=20
sts_entry_24xx_ext where fields like scsi_status are at offset 48. Because=
=20
qla2x00_status_entry() was not updated with an IS_QLA29XX() branch, it=20
casts to the 64-byte sts_entry_24xx and reads scsi_status from offset 22.=20
On 29xx, this offset holds the wr_sa_index, causing random SA index values=
=20
to be interpreted as SCSI errors.

Additionally, did we miss updating qla27xx_copy_multiple_pkt() to use the=20
new stride-aware qla_rsp_ring_advance() macro? It appears to still use=20
rsp_q->ring_ptr++ which only increments by 64 bytes on 29xx hardware,=20
desynchronizing the consumer pointer.

[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 948242f0088e7..146701445485f 100644
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
Will assigning the legacy qla24xx_dif_start_scsi handler here corrupt=20
the extended 29xx hardware rings?

If multiqueue is disabled or the block layer invokes this non-MQ hook, it=20
formats 64-byte layouts (cmd_type_7, cmd_type_crc_2) into the 128-byte=20
slots fetched via qla_req_ring_slot(). This writes the 8-bit vp_index to=20
offset 51, corrupting the 16-bit vp_index and ctrl_flags_2 expected by=20
29xx hardware.

[Severity: High]
This is a pre-existing issue, but can qla2x00_sp_free_dma() trigger a doubl=
e=20
free of the crc_ctx buffer?

When cleaning up a T10-DIF protected SCSI command, it frees the context:

qla2x00_sp_free_dma() {
    ...
    if (sp->u.scmd.crc_ctx) {
        dma_pool_free(ha->dl_dma_pool, sp->u.scmd.crc_ctx,
                      sp->u.scmd.crc_ctx->crc_ctx_dma);
    }
    ...
}

The pointer sp->u.scmd.crc_ctx is not set to NULL after being freed to the=
=20
DMA pool. A subsequent check for the same pointer evaluates to true and=20
attempts to free it again via mempool_free(), corrupting the ctx_mempool=20
slab pool.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D11
