Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE2D3A7F4C
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783406138; cv=none; b=kjLUYBPxdHGWGl45gORQLI6qFup9mQ7xL7MdvmvVwwRmvuBqGUF/0DDux0Ueb5pajkK584hRC/kHfhDurfvAVL99ZizPGrpqOiBKh37lvAXe+gUnD4YqsCKlGFyqhrgSZABonRMZnUiZL6CUSsRRwLN7j0Q3fxB620RzhBCXLOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783406138; c=relaxed/simple;
	bh=HsfRANJ8SZVGiOcgizA995BLaW4naRvkgZTG9haqqG8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tOhQwZTB/HPnj8Kl6lAkx8fGYwWEqWcvngkwu5ZkyjQHav4Pu0sTVv0/maoiXa0ZGZ5t9FOo17fE8bjgMy1XZ9vD17Mikb9+C0XDHV13xUZPgmEOPyeOrQ7pnPo5j4J8RXQuLCkRiVFZK4Sdnusy04slb1e08n7f8OwHx6dMh7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTFUSKDb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTFUSKDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EBA1F00A3A;
	Tue,  7 Jul 2026 06:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783406137;
	bh=0wbni04SwGjBcTdZVrSJzYO9+Jm9+KRGORmshJiZdXU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bTFUSKDb6aJRKRSvPrHpH1+DCwUh+tlZVWP9k3of13pwOD9zXB8rl5VVLFvBN+MhL
	 kEsYoHIDSaIrnKpMiOviWRidpkzRr6Y6NGjm+l6ng7JJVv1wl6b8wq1Rdd1UzkOJpU
	 mOXWyds8+SN97uUg0lfhyxfQ37L65I9Bmewr3UwWJAHeuZ6ENBDT6Bs7Ez0PKIMdtK
	 9d134YgwX537AVnBENMErZAC69w5i4rZ2Txu1N3ChZKHLa9rHq682dkU7fAtccGzmv
	 EXILh0ceP+tK2GMIAEb/I8f5tMvdc4hvFfR0XMDdztg+KTO/+HKCqyAJkS1X9UtIS9
	 kgwoPOc5SLu3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 28/88] scsi: qla2xxx: Enhance purex_entry handling
 for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-29-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-29-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:35:36 +0000
Message-Id: <20260707063536.E6EBA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Copying continuation IOCBs will trigger a runtime panic under CONF=
IG_FORTIFY_SOURCE=3Dy on 29xx hardware because the memcpy source bound is e=
valuated against a 64-byte struct while copying up to 124 bytes.

Pre-existing issues:
- [High] Non-atomic memset of the locklessly shared `default_item` creates =
a race condition that corrupts payload and control structures for concurren=
t PUREX allocations.
--

--- Patch [28]: [PATCH v3 28/88] scsi: qla2xxx: Enhance purex_entry handlin=
g for 29xx series ---
commit 085db48bd7b4d1648d53d6f0f6d5ff0614740cce
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enhance purex_entry handling for 29xx series

Update function signatures and internal logic across qla_edif.c, qla_isr.c,
and qla_os.c to accept a generic pointer for packet data. This differentiat=
es
between standard purex_entry_24xx and the extended purex_entry_24xx_ext
structures based on IS_QLA29XX(). It ensures proper initialization and
processing of command and response data for both 64-byte and 128-byte
PUREX IOCBs.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c

[ ... ]

> @@ -262,14 +275,24 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host=
 *vha,
>  	}
> =20
>  	pending_bytes =3D total_bytes =3D tpad;
> -	no_bytes =3D (pending_bytes > sizeof(purex->els_frame_payload))  ?
> -	    sizeof(purex->els_frame_payload) : pending_bytes;
> +	no_bytes =3D (pending_bytes > payload_size) ?
> +		payload_size : pending_bytes;
> +	if (IS_QLA29XX(ha)) {
> +		struct purex_entry_24xx_ext *purex_ext =3D *pkt;
> =20
> -	memcpy(buf, &purex->els_frame_payload[0], no_bytes);
> +		memcpy(buf, &purex_ext->els_frame_payload[0], no_bytes);
> +	} else {
> +		memcpy(buf, &purex->els_frame_payload[0], no_bytes);
> +	}
>  	buffer_copy_offset +=3D no_bytes;
>  	pending_bytes -=3D no_bytes;
>  	--entry_count_remaining;
> =20
> +	/*
> +	 * response_t::signature and struct response_ext::signature are both u32
> +	 * at offset 60 (handle:4 + data[52]:60), so the 24xx view writes
> +	 * the right slot regardless of stride.
> +	 */
>  	((response_t *)purex)->signature =3D RESPONSE_PROCESSED;
>  	/* flush signature */
>  	wmb();

[Severity: High]
Will this cause a runtime panic under CONFIG_FORTIFY_SOURCE=3Dy on 29xx har=
dware
when processing continuation IOCBs?

Later in __qla_copy_purex_to_buffer() (and similarly in
qla27xx_copy_multiple_pkt() and qla27xx_copy_fpin_pkt()), the continuation
IOCB data is extracted using the 64-byte struct view:

do {
    while ((total_bytes > 0) && (entry_count_remaining > 0)) {
        *pkt =3D rsp_q->ring_ptr;
        data =3D ((sts_cont_entry_t *)*pkt)->data;
        data_sz =3D qla_sts_cont_data_size(ha);
        ...
        memcpy((buf + buffer_copy_offset), data, no_bytes);

The compiler tracks the object size of sts_cont_entry_t::data as exactly
60 bytes. On 29xx hardware, data_sz can be up to 124 bytes. Is it possible
that FORTIFY_SOURCE will intercept this as a deterministic out-of-bounds
read (124 > 60) and panic the kernel?

[ ... ]

> @@ -1075,9 +1110,9 @@ qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint=
16_t size)
>  	struct purex_item *item =3D NULL;
>  	uint8_t item_hdr_size =3D sizeof(*item);
> =20
> -	if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
> +	if (size > QLA_MAX_IOCB_SIZE) {
>  		item =3D kzalloc(item_hdr_size +
> -		    (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
> +		    (size - QLA_MAX_IOCB_SIZE), GFP_ATOMIC);
>  	} else {
>  		if (atomic_inc_return(&vha->default_item.in_use) =3D=3D 1) {
>  			item =3D &vha->default_item;

[Severity: High]
This is a pre-existing issue, but can the non-atomic memset of default_item
create a race condition here?

If heavy I/O exhausts standard PUREX item allocations,
qla24xx_alloc_purex_item() falls back to the locklessly shared default_item:

    if (atomic_inc_return(&vha->default_item.in_use) =3D=3D 1) {
        item =3D &vha->default_item;

When this item is later freed in qla24xx_free_purex_item(), a non-atomic
memset is used to clear it:

drivers/scsi/qla2xxx/qla_os.c:qla24xx_free_purex_item() {
    if (item =3D=3D &item->vha->default_item)
        memset(&item->vha->default_item, 0, sizeof(struct purex_item));
}

If memset clears the in_use atomic flag before finishing zeroing the rest
of the struct, could a concurrent hardware interrupt successfully claim the
item and begin writing its payload, only to have the ongoing memset
overwrite and corrupt the newly written data?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D28
