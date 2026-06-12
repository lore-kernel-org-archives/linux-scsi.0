Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C032E286419
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781261681; cv=none; b=oXgHadxwYjvR1ypK6V3VxeVL833nfacTVsGUVtaI3hOOeQgPOaTzKYc2/U+ezm1AsRFB5e3g1HI5rrHQsOkN6MWJZ1r8EuK8DIeR5vPa+qZxb4AH++df7ijqp2u06N+G2OiYPSvbVbqvIVYjLGAqkqawbKOEYAG7nlOhu2zDL0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781261681; c=relaxed/simple;
	bh=30A6haPaVPpbh6XQ7C337ijL5F5Q+XJFEySsLUac91M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ns7GbOZK5+4iSIua9S4KmwLq8rJKgYHqkIZ+oVGY8iXVrRM7GXWhvsSmNwA6h/KsJcnYjcNXrmr7L1R0/fHqQQN9H1hBgEau4HRldhnRfVOVTpUCCa5r5LOEmtqG5BjAR7OedSZyzxYqnHZeZUWpulmEFcFJyf/YI2GmEYPhLKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YAoHt5W7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YAoHt5W7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538911F000E9;
	Fri, 12 Jun 2026 10:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781261680;
	bh=qkrC5+WEILZ2CvxtgoJqR/yxY/8Vrb5Dvh+DAPnikZU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YAoHt5W7rIjGVGjgeT8e4x3dncFRbhz5yGXzef2cD77sFL9a8NdYR7VpuzLqpaVl+
	 kb6ljqL7E6BK8CoKCrzoipOBkoFRRgbtY5XD/tFPinPcIb4yRWFyJnDsEuc7h+9wDb
	 4wphpLWuhFUOedDpNsZReBEi6YvONwBPOAaO7EXvefSes+cy2hJsbXqs8Sjup5p2DA
	 rufPaXsUfSL7d68ACSgxg7IwdEJ7jTUXGKketpndQTZL2pYH5LA+3wCxRI6qBeNzHk
	 S0L3wDVlMrcNsdeeYuFtbx8rcBVmsBgrATAOn4cv2wMr0I71lNntlpqTJ402tAFEXS
	 DRUmLtr0OnqFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 28/60] scsi: qla2xxx: Handle sts_cont_entry_ext_t for
 29xx adapters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-29-njavali@marvell.com>
References: <20260612095333.1666592-29-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:54:40 +0000
Message-Id: <20260612105440.538911F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] An attacker can remotely hang the kernel CPU by sending a craf=
ted FC packet (such as an FPIN, PUREX, or NVMe LS request) that contains th=
e signature value 0xDEADDEAD at the offset corresponding to the continuatio=
n entry's signature field, causing the driver's polling loop to spin indefi=
nitely.
- [High] `__qla_consume_iocb` over-consumes response queue entries by faili=
ng to account for the head IOCB, which leads to the silent dropping of an u=
nrelated firmware response and potential corruption of the response ring.
--

commit b27f896ba52e64377e7afd0984134a443ff7ed05
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Handle sts_cont_entry_ext_t for 29xx adapters
   =20
29xx adapters use 128-byte response queue entries
(sts_cont_entry_ext_t) instead of 64-byte (sts_cont_entry_t).  Update
all status continuation IOCB processing paths to branch on
IS_QLA29XX() and use the correct entry type and data payload size.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index e95fb0e59f387..c18ee2459f5bd 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -231,8 +231,15 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host =
*vha,

[Severity: High]
This is a pre-existing issue, but does __qla_consume_iocb() over-consume
response queue entries?

When skipping a multi-IOCB sequence, the function loops without accounting
for the head IOCB already being advanced:

void __qla_consume_iocb(...) {
    entry_count_remaining =3D purex->entry_count;
    while (entry_count_remaining > 0) {
        new_pkt =3D rsp_q->ring_ptr;
        ...
        qla_rsp_ring_advance(rsp_q);
        ...
        --entry_count_remaining;
    }
}

Since entry_count includes the head IOCB, but the caller already advanced
ring_ptr past it, this loop consumes exactly one extra, unrelated IOCB from
the response queue. Could this lead to silently dropping a legitimate
firmware response?

>  	void **pkt, struct rsp_que **rsp, u8 *buf, u32 buf_len)
>  {
>  	struct purex_entry_24xx *purex =3D *pkt;

[ ... ]

> @@ -906,28 +936,33 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha=
, void **pkt,
>  				continue;
>  			}

[Severity: Critical]
This is a pre-existing issue, but can this loop run infinitely if the
hardware DMA aliases payload data with the signature field?

In qla27xx_copy_multiple_pkt() (and qla27xx_copy_fpin_pkt()), the code
polls for continuation IOCBs:

    if (rsp_q->ring_ptr->signature =3D=3D RESPONSE_PROCESSED) {
        cpu_relax();
        continue;
    }

RESPONSE_PROCESSED is 0xDEADDEAD. Because the signature field in
sts_cont_entry_t and sts_cont_entry_ext aliases directly with raw payload
data, a received FC frame with 0xDEADDEAD at this offset could cause the
payload to overwrite the placeholder, resulting in a CPU lockup in interrupt
or DPC context.

Is this polling loop strictly necessary given qla_chk_cont_iocb_avail()
already validates the availability of continuation IOCBs?

> -			new_pkt =3D (sts_cont_entry_t *)rsp_q->ring_ptr;
> -			*pkt =3D new_pkt;
> +			*pkt =3D rsp_q->ring_ptr;
> +			if (IS_QLA29XX(ha)) {
> +				struct sts_cont_entry_ext *p =3D *pkt;
> +
> +				data =3D p->data;
> +				data_sz =3D sizeof(p->data);
> +			} else {
> +				sts_cont_entry_t *p =3D *pkt;
> +
> +				data =3D p->data;
> +				data_sz =3D sizeof(p->data);
> +			}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D28
