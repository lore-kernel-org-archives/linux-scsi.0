Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCCD23504B
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784041229; cv=none; b=bf0wW7h4DObC5n/KNtvWE18XlggeT/d0P4AnKRbTxwdvu7472w+O0iEjP7JYtt6f+/Nd5oq2dkfEUSgeuSXrfIa9s9aMBzG47yS+oNc2CkiOE3MM0lGqGYso04TymAEjdiFCB0XWVGRRnFLd+2krDnLaeTIOC94ko1HJtfTNXWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784041229; c=relaxed/simple;
	bh=nzrts5gDNg8NVrQ86uaOjQ2+zQTfafyOarMJZXbTfLU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EhScN2TVqmw+fLc15f6qq1vNAwKshrbTtjIKNalKPI5Jq7t89JOR3mNXZFaPfgDT3aorC8yyhha1gfWOcO4IjDSPXlIV3RzANr6u84OgeQpw6YD9zHAymtErsSJD/80D1Bjz+J2B6uxKtngH+0W6cVz4xLc5OpDFBRDlggGfNlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DI8OVj34; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DI8OVj34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A2F1F00A3A;
	Tue, 14 Jul 2026 15:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784041228;
	bh=RIpxoNzhYt0FrDWfI3wJYwwZTpy5Ji0mnab6PL2uYIY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DI8OVj3409F6OBsn2hJxmsqayFHY7pTz5phrogOWGKmxjnI+z9pwdPN9ShUFiGKHo
	 0XPmnAJseSVB2uIVmxa/Wopm72fw3H10pcPL83IjVgJ/945X3hKcynVrPuJKp2po60
	 gMUfDfcStP7afEzLZvVV9e2I4QI3WBkPz5oUCBcLi+MxOzwZ7ZcyZ6lWkY3xJAvvkd
	 QhMgcq0p4lw1jPplvPQ0P21YZKthuwbz6l/UgpHLQsdTB2Ht6MEls5O9pwI5oNABjO
	 qUWxFA0mLEWN77fLcfWhzzIHaGoOodg8s/90hoGDHbcuot1NqKC7/viLlpPx8qDgqp
	 OLRcKnYUFG7cA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 29/56] scsi: qla2xxx: Update handling of ELS IOCBs
 for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-30-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-30-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 15:00:27 +0000
Message-Id: <20260714150027.C0A2F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Endian-unsafe use of C bitfields for hardware-facing DMA descripto=
rs in `qla_els_set_vp_sof()`.
--

--- Patch [29]: [PATCH v4 29/56] scsi: qla2xxx: Update handling of ELS IOCB=
s for 29xx series ---
commit c4548b60cd936f5a4a71288b8a287eb9009e46b8
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update handling of ELS IOCBs for 29xx series

Update ELS IOCB handling to support the extended 128-byte
els_entry_24xx_ext structure used by 29xx series adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla=
_inline.h
> index 49b858e7cf2a1..2ade5e8522516 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h

[ ... ]

> @@ -863,3 +863,31 @@ qla_sts_fwi2_extract(struct qla_hw_data *ha, void *p=
kt,
>  		host_to_fcp_swap(s->data, sizeof(s->data));
>  	}
>  }
> +
> +/*
> + * qla_els_set_vp_sof() - write the vp_index / sof_type pair into an ELS
> + *    pass-through IOCB (els_entry_24xx{,_ext}).
> + *
> + * Both layouts have the same 16-bit slot at offset 14, but it is encoded
> + * differently:
> + *   - 24xx: separate u8 vp_index + u8 sof_type with EST_SOFI3 (1 << 4)
> + *   - 29xx: __le16 with bitfields { vp_index:9, reserved_1_sof:3,
> + *           sof_type:4 } and ELS_EXT_EST_SOFI3
> + * so this is the single point in the driver that knows about that
> + * encoding split.
> + */
> +static inline void
> +qla_els_set_vp_sof(struct scsi_qla_host *vha, void *pkt, u16 vp_idx)
> +{
> +	if (IS_QLA29XX(vha->hw)) {
> +		struct els_entry_24xx_ext *ext =3D pkt;
> +
> +		ext->vp_index =3D vp_idx;
> +		ext->sof_type =3D ELS_EXT_EST_SOFI3;
[Severity: High]
Can the use of C bitfields here cause endianness issues on big-endian
architectures?

Since the hardware DMA descriptor struct els_entry_24xx_ext defines these
fields as:

    __le16 vp_index : 9;
    __le16 reserved_1_sof : 3;
    __le16 sof_type : 4;

the compiler will pack the bitfields starting from the most significant bit
of the word on big-endian systems (such as s390x or PowerPC). However, the
little-endian 29xx hardware expects vp_index to occupy the lowest 9 bits.

Could this mismatch cause the adapter firmware to read corrupted Virtual Po=
rt
(VP) indices and SOF types when qla_els_set_vp_sof() is called on the ELS
issue paths, potentially routing ELS commands to the wrong VP and leading to
login failures, cross-VM traffic leakage, or firmware crashes?

> +	} else {
> +		struct els_entry_24xx *e =3D pkt;
> +
> +		e->vp_index =3D vp_idx;
> +		e->sof_type =3D EST_SOFI3;
> +	}
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D29
