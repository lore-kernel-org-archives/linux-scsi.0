Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DD632B132
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 06:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784787557; cv=none; b=CdhdyDDLZsadkZH6wAyUYCDGjZDQVAKa13+834hglUo03qkxmdDKjNbMDO49/hfZt8KwpxjfzKtDtRiMvRkf5GxzlUDpsbbgVGSjsUQFSo5A+1I9UgbZjq2mLeWYEocqoxw1FUct7CTkYABLp9Ov2SDqz8b73xkWuhf8f3sPF1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784787557; c=relaxed/simple;
	bh=BqX94vC3ErCuwebZUm3j/XXcsczaoDEipQjBDa/N/qI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o2u53ndHrI/owssiyXbdttu3IQQU9xwT1zHKIl+i2GHPktopw1eM8VYVpfNFGipGu/SRq94+N6ts2C0eKBbEhLTi++8jifvAL/5ThY+JyNNzGO9YtsqZQQAn7fqnFZi1ywCuvs3bQkaKRw1bfyLuN5fM2kXTUa3Z/q/5W4pSa6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HtIZTAsk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HtIZTAsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB5A1F000E9;
	Thu, 23 Jul 2026 06:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784787555;
	bh=9aENN3rPH0Omq6RUIdzFWXKOeG+OmmXFS9CaOHxmNoA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HtIZTAsk2wv3G6cNt1DYa3QNtOWhCI6eJF0hJNNDdNG3NT7d9TyfTWHRN9MVPTJqS
	 flIcj3eqPXZEQTjKvX9YH5YGqXzhAs9vo68vHg+2CgGFY5pwQOYfnLyC105ddrBmnc
	 Be0nVDrO0M6tkjQwbg3efrEYPArkLD/U5idht5lFUPCbT74WumcVZq0XgwX+2+Vg7/
	 MruCY84+isCiED5CGmc1OBQeETlP6JO/ho+/KQxmtms7yxhETClnk3oj7S7LIcoZTR
	 xv+tXunI6ALhtPWsDepqf+8QvB8Lxp0cPz43bgGi3fdNpfhI/LUN+dYiMM+NuVVuaD
	 lltYs2O1mKg7g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 04/56] scsi: qla2xxx: Add 29xx support in queue
 initialisation path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-5-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-5-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 06:19:14 +0000
Message-Id: <20260723061914.DBB5A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] Base request and response queues (queue index 0) and fallback =
frees ignore the new 128-byte size requirement for 29xx hardware, leading t=
o memory corruption and leaks.
- [High] Ring pointer arithmetic for `out_ptr` and `in_ptr` calculates inco=
rrect offsets for QLA29XX adapters, causing memory corruption and breaking =
bisectability.
- [Medium] The firmware dump logic hardcodes the 64-byte legacy queue sizes=
, which will result in an undersized dump buffer and truncated queue data f=
or 29xx adapters.
--

--- Patch [4]: [PATCH v6 04/56] scsi: qla2xxx: Add 29xx support in queue in=
itialisation path ---
commit 892bfd1ade358d1fd826e15942668d47268a93f3
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add 29xx support in queue initialisation path

This commit extends the queue initialization and multi-queue management mai=
lbox
commands for 29xx adapters. It introduces 128-byte entry structures and
updates DMA allocations to account for the larger entries on 29xx.

> Extend the queue initialisation and multi-queue management mailbox
> commands to include IS_QLA29XX() checks, following the same mailbox
> interface as 27xx/28xx.
>=20
> Unlike earlier adapters that use 64-byte request/response ring entries
> (request_t / response_t), 29xx uses 128-byte entries.  Add struct
> request_ext and struct response_ext, which extend the legacy 64-byte
> layout with a 64-byte reserved area.  The first 64 bytes are
> layout-compatible with the legacy structures, so common header
> accesses remain valid.
>=20
> The enlarged entry stride doubles the DMA ring memory allocated for
> both request and response queues on 29xx, and all ring pointer
> arithmetic must account for the wider entries (handled by later
> patches in this series).

[Severity: Critical]
Does this commit update the base request and response queues (queue index 0)
and fallback frees for 29xx hardware?

Looking at qla2x00_mem_alloc() in drivers/scsi/qla2xxx/qla_os.c, it allocat=
es
the base request queue with a hardcoded 64-byte size:

        (*req)->ring =3D dma_alloc_coherent(&ha->pdev->dev,
                ((*req)->length + 1) * sizeof(request_t),
                &(*req)->dma, GFP_KERNEL);

And similarly in qla2x00_free_req_que(), it uses sizeof(request_t) to free
the queue. Will this cause the hardware to operate with 128-byte entries on=
 a
queue allocated for 64-byte entries, leading to memory corruption and DMA
allocator corruption on 29xx adapters?

[Severity: Medium]
Will the firmware dump logic truncate the 128-byte entries on 29xx adapters?

Looking at qla2x00_alloc_fw_dump() in drivers/scsi/qla2xxx/qla_init.c, it
calculates the dump size assuming 64-byte queue entries:

        req_q_size =3D req->length * sizeof(request_t);
        rsp_q_size =3D rsp->length * sizeof(response_t);

And qla24xx_dump_ram() in drivers/scsi/qla2xxx/qla_dbg.c copies only 64 byt=
es
per entry:

        memcpy(ptr, req->ring, req->length * sizeof(request_t));

Could this result in an undersized dump buffer and truncated queue data for
29xx hardware?

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index c563133f751e8..e75b7ae22bc52 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c

[ ... ]

> @@ -706,6 +715,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16=
_t options,
>  	uint16_t que_id =3D 0;
>  	device_reg_t *reg;
>  	uint32_t cnt;
> +	uint16_t reqsz;
> =20
>  	req =3D kzalloc_obj(struct req_que);
>  	if (req =3D=3D NULL) {
> @@ -714,9 +724,12 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint1=
6_t options,
>  		goto failed;
>  	}
> =20
> +	reqsz =3D IS_QLA29XX(ha) ? sizeof(struct request_ext) :
> +				 sizeof(request_t);
> +
>  	req->length =3D REQUEST_ENTRY_CNT_24XX;
>  	req->ring =3D dma_alloc_coherent(&ha->pdev->dev,
> -			(req->length + 1) * sizeof(request_t),
> +			(req->length + 1) * reqsz,
>  			&req->dma, GFP_KERNEL);

[Severity: High]
Since pointer arithmetic is handled in later patches in this series, does t=
his
break bisectability here?

Looking at qla25xx_create_req_que() in drivers/scsi/qla2xxx/qla_mid.c, the
out_ptr sits after the ring buffer:

        req->out_ptr =3D (uint16_t *)(req->ring + req->length);

Because req->ring is a request_t pointer (64-byte stride), adding req->leng=
th
advances it by length * 64 bytes. For 29xx, the queue stride is 128 bytes, =
so
the shadow pointer will point into the middle of the allocated ring buffer
instead of immediately after it. Will this cause memory corruption when the
driver or hardware accesses the shadow pointers?

The same issue seems to apply to rsp->in_ptr in qla25xx_create_rsp_que().

Is there a way to make this commit safe for bisection?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D4
