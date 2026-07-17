Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3E1429CCA
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784304838; cv=none; b=SkPLrkqQJrmRabucqXYRCpaVXCOZlwHUjemxkYQbSmzhAUqgCOfQRd/KR0IntsDCgT/GIttrnqmhjvalrKA2QRRHx6VrnK9Owhw52jn5DpArTSVkjXM6ZHvgk2B/xUhAAeLaTGdLo0XXd0zMG1vq78+bBb6+/GSX8OGmERNsHn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784304838; c=relaxed/simple;
	bh=JxuVE/g17PHw3jIVr7jkrhDV0KhbrLF144e59RAgWtE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JjlA+SyVhqmWIJ6N6YV7YP4w+HGu/qSVy+Y47X95D38MQj85cx1Te8f6sI+98lkp5o98i5Y9oCaoaMXPIkthOlOChKQHAY7qMMIRHDV3uljo02ONM5LPGzRnqWmSgnLLMKOSeSJ0QJPq8ZeNBgQhFDWs6vPlixwi+/otehVLBAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFfBVfHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFfBVfHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69EC1F000E9;
	Fri, 17 Jul 2026 16:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784304832;
	bh=CkI3hHyX3f4WEZt5syq74VwYya+6IZP81FIHq9YoeVY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oFfBVfHDFH1L202NDj+QA+M467qqXFHlj/d6huCZgNo30wHn64hnM6yrWC8prDgB3
	 zZFFM3ExqiiJ+pp+vXJRVUvcWDhldJ1F1Hom9/58KcQCKGMujbnp+iWXiFDyBomm/w
	 qBMQwCLYEhQ8CMJj7NoPkeoLRBlyrfro4ypF04jjybPL+yNfiQ8rXnxFS36cNLaaOC
	 y/KeuRF13N+sQHGMTN7cUvB7whKxG5lU+e6x5ot3FWSQwfroWDoUadiOho+i0/weeW
	 +1Z1b9Ldx/6xnicLVQqPokdQlwPzCr6p9Kw/uxlrSCZ8+uDHm5iZlsd5O5Hi7UZg9Q
	 gXGDAP8LLmNOg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 11/56] scsi: qla2xxx: Update IO path to use 128-byte
 IOCBs for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-12-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-12-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:13:52 +0000
Message-Id: <20260717161352.A69EC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] Non-IO path IOCB builders (Abort, Task Management, ELS, Login,=
 Logout, PRLI) fail to use the extended 128-byte struct layouts on QLA29XX =
adapters, corrupting extended IOCBs and breaking NPIV isolation.
- [Critical] The ISR completion path fails to handle 29xx extended status I=
OCBs, resulting in garbage values being read for SCSI status, sense lengths=
, and NVMe ERSP data.
- [High] Manual 64-byte ring pointer advancement in `qla27xx_copy_multiple_=
pkt()` corrupts the response ring on QLA29XX adapters.
- [High] Continuation IOCB payloads are severely truncated on QLA29XX adapt=
ers due to hardcoded 60-byte copy limits.
- [High] Continuation IOCBs in target mode are under-packed with DSDs on 29=
xx hardware, leading to truncated data transfers.
--

--- Patch [11]: [PATCH v5 11/56] scsi: qla2xxx: Update IO path to use 128-b=
yte IOCBs for 29xx ---
commit 5e78bc810efc46ed3e8aed3841ea031f78694acf
Author: Anil Gurumurthy <agurumurthy@marvell.com>

scsi: qla2xxx: Update IO path to use 128-byte IOCBs for 29xx

This commit updates the driver to support 128-byte extended IOCB
structures for the IO submission, completion, and queue management paths
on 29xx adapters. It introduces helpers for entry size selection and
slot advancement, falling back to 64-byte IOCBs for earlier adapters.

Link: https://lore.kernel.org/oe-kbuild-all/202607141827.R9mpeMZx-lkp@intel=
.com/

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index dbe3cd4e274c8..aab7905c0d6ca 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c

[ ... ]

[Severity: Critical]
Does qla2x00_start_sp() properly dispatch non-IO paths for QLA29XX adapters?

Currently, it seems to dispatch management commands (like Abort, Task
Management, ELS, Login, Logout, PRLI) to legacy 64-byte builders like
qla24xx_tm_iocb() and qla24xx_abort_iocb().

If these builders cast the 128-byte slot to the legacy struct and write to
the old offsets (e.g., vp_index written to offset 51 instead of 18 or 28),
could this result in management commands being sent to the wrong virtual
port (VP 0) and breaking NPIV isolation?

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index c47c38e099ff8..e95fb0e59f387 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c

[ ... ]

> @@ -1212,13 +1200,7 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, v=
oid **pkt,
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
Does this logic truncate extended payloads on 29xx adapters?=20

The advancement helper qla_rsp_ring_advance() steps by 128 bytes for extend=
ed
rings, but the copy size is still bounded by sizeof(new_pkt->data) which is=
 60
bytes. Can this ignore the remaining data the 29xx firmware places in the
extended slot?

Also, is there a similar issue in qla27xx_copy_multiple_pkt() where the man=
ual
rsp_q->ring_index advancement was left behind? Using the old 64-byte stride
logic there could corrupt the response ring on QLA29XX adapters by misalign=
ing
the pointer.

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

[Severity: Critical]
Will reading completion entries through a hardcoded 64-byte structure like
sts_entry_24xx cause problems on 29xx hardware?=20

If functions like qla2x00_status_entry() or qla24xx_nvme_iocb_entry()
unconditionally cast the 128-byte response slot to the legacy 64-byte struc=
t,
wouldn't they read unrelated fields for the SCSI status, sense lengths, and
NVMe ERSP data?

> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index e47da45e93a01..53a505df8da0a 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c

[ ... ]

> @@ -2614,7 +2611,7 @@ static void qlt_load_cont_data_segments(struct qla_=
tgt_prm *prm)
>  		 * that.
>  		 */
> =20
> -		memset(cont_pkt64, 0, sizeof(*cont_pkt64));
> +		memset(cont_pkt64, 0, qla_req_entry_size(ha));
> =20
>  		cont_pkt64->entry_count =3D 1;
>  		cont_pkt64->sys_define =3D 0;

[Severity: High]
Does this loop pack enough DSDs for 29xx hardware?

Looking slightly further down in qlt_load_cont_data_segments():

		for (cnt =3D 0;
		    cnt < QLA_TGT_DATASEGS_PER_CONT_24XX && prm->seg_cnt;
		    cnt++, prm->seg_cnt--) {
			append_dsd64(&cur_dsd, prm->sg);
			prm->sg =3D sg_next(prm->sg);
		}

If the loop strictly limits packing to QLA_TGT_DATASEGS_PER_CONT_24XX (5) D=
SDs,
will the 29xx firmware (which expects 10 DSDs per 128-byte slot) encounter
zero-length DSDs mid-transfer and prematurely terminate target mode data
transfers?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D11
