Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99789392C42
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 11:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784805173; cv=none; b=rJpeMbuWuvcMaO1okA0aaY4JilmAWe/fMmEzOcJ+LQDXMG/bnHnyOxYnjjH/EAmOkKgFrDOFYA/JQ1g25zGdfwvF5nbT3DIwK2x1AsJ9pTbau60q2hNa5StTU42t9bU0J0DnKZWoYta3MQ5RnXP4KoNQsSU0aiXnvd9ogIEPw0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784805173; c=relaxed/simple;
	bh=JTZwMgDYvc+10Hz/tSI+f9KR6eucGSoPpNkYPqrMRpI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D+45m9zVO7JsH5MAXX3USZrNDB699IukYDRpxrFpW0eaFvLi4xJU187QZ8tdArmpBMYIa3GZDncxD1k6jdxJDp2re+icSA4KDTUQXV2DtUk2Ci3BU1JOxVrGli8+7RGfNd5AAOlzYrXmbvjPkylk2AmclzEBTXFZ5VZyHzZV8Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LXnSSjlQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LXnSSjlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8FA1F000E9;
	Thu, 23 Jul 2026 11:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784805171;
	bh=PFmJgIkwBzjtK6MBbl/aYvhT3U6i8Kyoo4HFCY1hl8g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LXnSSjlQ+8IwH4z20JSdYTe+jW0DJ74b4ICYTSH7RY4cjnWWdpWoOEHelbSmoMbxz
	 8zXd/suQB7w8kvUzbkCMNRXsKu0FuVrD4N6VufwZQdMR3iAfRfxniQaWl63GiZMzuH
	 gUiOhQlIpvO5K+LjHZt7d36hPd16QoBDGVwhgWzIKfjo4NP/rmmMB70BWuwE9eDloe
	 uDeiOMgQ4lSv/pTWik92MGER4wriDX/ko3AFd4DSPrP1PUNpa4lbm4bRzI/XR4to2e
	 Un7u+DJnlV54iwL38M2yFxUVhECkR+SKGHzPsylA1Yi/Ctgki3/Axg4NdzjyvzdWTu
	 qSCt8kEmzuptA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 25/56] scsi: qla2xxx: Handle sts_cont_entry_ext_t for
 29xx adapters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-26-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-26-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 11:12:50 +0000
Message-Id: <20260723111250.EC8FA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] FORTIFY_SOURCE Buffer Over-Read Panic
- [High] DMA Synchronization Hazard
--

--- Patch [25]: [PATCH v6 25/56] scsi: qla2xxx: Handle sts_cont_entry_ext_t=
 for 29xx adapters ---
commit 90b126fb190842b2de74935641902992115ca941
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Handle sts_cont_entry_ext_t for 29xx adapters

29xx adapters use 128-byte response queue entries
(sts_cont_entry_ext_t) instead of 64-byte (sts_cont_entry_t).  Update
all status continuation IOCB processing paths to branch on
IS_QLA29XX() and use the correct entry type and data payload size.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607142020.gqDaApes-lkp@int=
el.com/

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

[Severity: High]
Will this unconditional cast trigger a buffer over-read panic on QLA29XX
adapters?

When CONFIG_FORTIFY_SOURCE is enabled, the compiler tracks object bounds to
prevent buffer overflows. Here, the packet is cast to sts_cont_entry_t,
which limits the compiler's view of the data array to 60 bytes.

Since qla_sts_cont_data_size() returns 124 bytes for 29xx adapters, a
subsequent memcpy() using this data pointer could exceed the 60-byte known
bound and trigger a fortify_panic().

Could this dynamically select the correct pointer type, such as casting to
struct sts_cont_entry_ext, based on the adapter type?

> +			data_sz =3D qla_sts_cont_data_size(ha);

[ ... ]

> @@ -906,28 +915,24 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha=
, void **pkt,
>  				continue;

[Severity: High]
Can this loop condition result in silent data corruption by copying stale
memory?

Looking at qla27xx_copy_multiple_pkt(), the driver polls the signature field
to wait for continuation IOCBs from the hardware:

if (rsp_q->ring_ptr->signature =3D=3D RESPONSE_PROCESSED) {
    ...
    cpu_relax();
    continue;
}

The signature field is located at offset 60, which falls within the first
64-byte cacheline. Since 29xx adapters use 128-byte extended IOCBs, the
data payload extends into the second cacheline (bytes 64-127).

PCIe root complexes and CPU memory controllers do not guarantee ordering
between multiple cacheline writes within a single DMA transaction. If the
CPU observes the updated signature in the first cacheline, could it proceed
to copy the entire 124-byte payload while the second cacheline still
contains stale data?

>  			}
> =20
> -			new_pkt =3D (sts_cont_entry_t *)rsp_q->ring_ptr;
> -			*pkt =3D new_pkt;
> +			*pkt =3D rsp_q->ring_ptr;
> +			data =3D ((sts_cont_entry_t *)*pkt)->data;

[Severity: High]
Similarly, does this cast also restrict the object bounds for FORTIFY_SOURCE
and risk a panic when copying up to 124 bytes during
qla27xx_copy_multiple_pkt()?

> +			data_sz =3D qla_sts_cont_data_size(ha);

[ ... ]

> @@ -1190,10 +1206,12 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, =
void **pkt,
>  				continue;

[Severity: High]
Does this exhibit the same DMA synchronization hazard when polling the
signature field in qla27xx_copy_fpin_pkt() while waiting for 128-byte
entries?

>  			}
> =20
> -			new_pkt =3D (sts_cont_entry_t *)rsp_q->ring_ptr;
> -			*pkt =3D new_pkt;
> +			*pkt =3D rsp_q->ring_ptr;
> +			data =3D ((sts_cont_entry_t *)*pkt)->data;

[Severity: High]
Does this cast also restrict the object bounds for FORTIFY_SOURCE and risk
a panic when copying up to 124 bytes during qla27xx_copy_fpin_pkt()?

> +			data_sz =3D qla_sts_cont_data_size(ha);

[ ... ]

> @@ -3691,6 +3711,7 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_=
cont_entry_t *pkt)
>  	struct scsi_cmnd *cp;
>  	uint32_t sense_len;
>  	uint8_t *sense_ptr;
> +	u8 *data =3D ((sts_cont_entry_t *)pkt)->data;
> =20
>  	if (!sp || !GET_CMD_SENSE_LEN(sp))
>  		return;
> @@ -3707,15 +3728,15 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, st=
s_cont_entry_t *pkt)
>  		return;
>  	}
> =20
> -	if (sense_len > sizeof(pkt->data))
> -		sense_sz =3D sizeof(pkt->data);
> +	if (sense_len > data_sz)
> +		sense_sz =3D data_sz;
>  	else
>  		sense_sz =3D sense_len;
> =20
>  	/* Move sense data. */
>  	if (IS_FWI2_CAPABLE(ha))
> -		host_to_fcp_swap(pkt->data, sizeof(pkt->data));
> -	memcpy(sense_ptr, pkt->data, sense_sz);
> +		host_to_fcp_swap(data, data_sz);
> +	memcpy(sense_ptr, data, sense_sz);

[Severity: High]
Will this trigger a fortify_panic() when handling 128-byte payloads?

The function qla2x00_status_cont_entry() now accepts a void pointer but
hardcodes the data pointer cast to sts_cont_entry_t. This destroys the
compiler's view of the 124-byte payload.

Since sense_sz can evaluate to 124 bytes for 29xx adapters, calling memcpy()
with a data pointer bounded to 60 bytes by the compiler will result in a
buffer over-read panic.

Could the data pointer be derived using the appropriate extended structure
when handling 29xx adapters?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D25
