Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B7223183F
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783405900; cv=none; b=oPla+Qo34+h85ES/tHFH1NNOhS7V+vYVZAUiBzpTowGRzClrlQF5h7Opz+qKILuFgjFTwo0KwzcY36yqnNFGHsdab2CxTLApK9TmF6qXe1Jvi2unEUi3A3W1VihUSWyG9GuOXpPR91gjV6qhd44SmsxLdfOMqm35SduIKnTs56g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783405900; c=relaxed/simple;
	bh=QBoILBrADClDsycYTW/aLRr/ULJAwzfVqGUHcf5Ncko=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jjyYP6Ra3XUOFdfIoRhVJYqqODfavWYlIZeQse8o0vLHCZGVhClyszbALrmE5G+gQNc44SVnKZoa+/jOxidGG0alEpBuaXeUpx4eFe2DfzD5ny7yI2x6rofb1VJe4ZDxy5FtCkEtpHWWaFCBO4QyeRU5mNijqzj4N/u3PUAiXoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IoQNwDci; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IoQNwDci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC5E1F000E9;
	Tue,  7 Jul 2026 06:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783405898;
	bh=OQPEVozNhoiENDPtA/SSiLkTdEyPsSZI/A2IfZeLHHU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IoQNwDciFBuMHXwypYQgjIO3Zn58Ix2hl2bXamZ3h4QIbxF4VFzGTp/GXLbK5IbrJ
	 qik2n/wV1Amuwo3ZwuUOMWxgKMBTCBqm7JhfmH+SlZWlNn9K/BYsvyFQV2QZLYDx6J
	 jaQtQ3GaVN0mtFJK03PT4bx0q8aaj9p3betwv4b6zlALJskxoApVEk5RZpkAU1Wy7e
	 qixCr5ImH1Kf6a1E0XzSAz9cQfzifounfBF1sTZ597Mq4qjac/uJLshF4P7z85Hd4x
	 RIgwJq0ZCTFLo5epAX41iEr1z0UnMSmAZjPEz9ngh6kT0cV7/rvHYYLOqiTc5VU5DI
	 XXMOtUEewLGrA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 25/88] scsi: qla2xxx: Handle sts_cont_entry_ext_t for
 29xx adapters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-26-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-26-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:31:38 +0000
Message-Id: <20260707063138.9CC5E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] FORTIFY_SOURCE panic during 128-byte continuation packet proce=
ssing on QLA29XX adapters due to statically tracked source pointer bounds.

Pre-existing issues:
- [Critical] A crafted FPIN, ELS, or SENSE payload containing the `RESPONSE=
_PROCESSED` signature causes a hard lockup or permanently stalls the respon=
se queue.
--

--- Patch [25]: [PATCH v3 25/88] scsi: qla2xxx: Handle sts_cont_entry_ext_t=
 for 29xx adapters ---
commit ba18e4a152f622363daff6c96a006be46727237c
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Handle sts_cont_entry_ext_t for 29xx adapters

This commit updates the QLogic qla2xxx driver to handle 128-byte response
queue entries for 29xx adapters. It introduces a new size calculation
routine and updates the status continuation IOCB processing paths to branch
based on the adapter type, ensuring correct data payload sizes are used.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -271,10 +276,12 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host=
 *vha,
> =20
>  	do {
>  		while ((total_bytes > 0) && (entry_count_remaining > 0)) {
> -			new_pkt =3D (sts_cont_entry_t *)rsp_q->ring_ptr;
> -			*pkt =3D new_pkt;
> +			*pkt =3D rsp_q->ring_ptr;
> +			data =3D ((sts_cont_entry_t *)*pkt)->data;
> +			data_sz =3D qla_sts_cont_data_size(ha);

[Severity: Critical]
Will this trigger a FORTIFY_SOURCE panic on 29xx adapters?

When extracting the data pointer in __qla_copy_purex_to_buffer(), the
packet is explicitly cast to sts_cont_entry_t, which defines the data
array as fixed at 60 bytes. Later in the loop, memcpy() copies up to
data_sz (124 bytes for 29xx) from this pointer.

Since the compiler statically tracks the bounds of the 60-byte array,
won't this cause a panic when processing larger continuation packets?
This same pattern appears to be introduced in qla27xx_copy_multiple_pkt(),
qla27xx_copy_fpin_pkt(), and qla2x00_status_cont_entry().

> =20
> -			if (new_pkt->entry_type !=3D STATUS_CONT_TYPE) {
> +			if (((sts_cont_entry_t *)*pkt)->entry_type !=3D
> +			    STATUS_CONT_TYPE) {
>  				ql_log(ql_log_warn, vha, 0x507a,
>  				    "Unexpected IOCB type, partial data 0x%x\n",
>  				    buffer_copy_offset);
[ ... ]
> -			((response_t *)new_pkt)->signature =3D RESPONSE_PROCESSED;
> +			((response_t *)*pkt)->signature =3D RESPONSE_PROCESSED;

[Severity: Critical]
This is a pre-existing issue, but could a crafted payload cause a hard
lockup or queue stall?

The driver uses the in-band sentinel value RESPONSE_PROCESSED
(0xDEADDEAD) at offset 60 to detect when the hardware has finished DMAing
the slot. However, this offset aliases with the packet payload itself
(for example, bytes 56-59 of sts_cont_entry_t::data).

If a remote target or fabric switch sends an FPIN, ELS frame, or SCSI
SENSE response containing 0xDEADDEAD at this exact offset, the hardware
will write this into the ring slot. When the driver polls the signature
in functions like qla27xx_copy_multiple_pkt() or
qla24xx_process_response_queue():

    if (rsp_q->ring_ptr->signature =3D=3D RESPONSE_PROCESSED) {
        ...
        cpu_relax();
        continue;
    }

Won't it mistakenly assume the slot is unwritten, leading to an infinite
spin loop or a permanently stalled queue?

>  			/* flush signature */
>  			wmb();
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D25
