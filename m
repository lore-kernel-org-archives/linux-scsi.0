Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794353915;
	b=qZbCSEpetHcjbgGAwEttzTPZLY3J8flzmB+SEuz3ZuSQA/ywCqnfWBk2iNDRHfuyQBqY
	 wLDA8VWjMOJ2Xu/IWN68GsLSZdVgyRbTsaz9khaSfiNrHqegacMJya/snJrt/hCfm38TS
	 OvDugLXD3KHcwQtEwBLaT3OqyZ320+FT0PYBRE2s94m7xqC001z25NYQu2FmxoLcD1xaI
	 v6prmuEhaP9wBM+ATNsRZZJEjsTqWSg0jCt6ANHkOrNFxlheob3VxnL0arTs0KgXvhtbw
	 JSfEd4dDbUwTzoxJcXopAPnx4+hd36zT/EzewT8phuZu2vdtXdQLnWAHilD0hiwh1dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794353915;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fqaHER8gwQjVJ8rckZ7avUGQkcvZZ2ptBV6g37b7qHQ=;
	b=l3oczrTiJIzVnVHxf91ipziiHaHVCP1jt2t1Yj6poi6c6V8Cq1PQvxR4dwAOQbSKkXnQ
	 AZrhq0BSV2ro50x461M0iNOmJgwDoi+ENr5oBlUeCWOQty+EZJHwDRyzQwrIOzeqJmv1e
	 0tZG7kAajaEeiC3bJVPpJeSYCuBqZ5B+ctXCxSf6Jxq0qK+1kSSsTkER9cH709vluAc2e
	 RzZt2gnOzv5a+wtkssaWmTFgf9Pz15naYlYmlqoKDSJuLylKkVJkbjRf0Ll04mWjt4GFo
	 U7l8WIprrRmWgM5STE/xnpzQ5hd+JKGP1YNb2lXFtTvrupLD6TZxmjCL3kmJsLm3u+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kYTzCfrs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE9C606A321;
	Tue, 10 Nov 2026 23:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kYTzCfrs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE551F0093C;
	Tue, 10 Nov 2026 23:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794353914;
	bh=fqaHER8gwQjVJ8rckZ7avUGQkcvZZ2ptBV6g37b7qHQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kYTzCfrsmTHxn8Y2ChWJtLlRl0nPvvw6sjTJe3xf2x3Mb5gSf4Ps0+GxS/mpZSX9M
	 1T1D8zN00K6GQXIAy+e/U8PWWbMJO1MXSs8+gobXZj1l1ZLDSzNdnRyAjOoC+UcIPv
	 0xjZvNXF/Rl4WkF8ejUf3eR580s+tO9ibcsgQXB5XrQktcUbb1n5xHGlonnH0YBkyn
	 DSEcI3rTlRh/GkTxaKgIX04vLGUjEIUSY1Jy2KK6+9Ciy6XtTgbyof6eg+8I+uT4Vh
	 MtdhDYsS2ouxfCR8rsGpHKN24xZ43cPq8F+p2aWue7GER0wRHI6R6tAKsfh8b1dIw4
	 H6dGnCxW6h5rQ==
Message-ID: <sashiko-outbox-207946@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/1] scsi: target: Skip zero-length protection SG
 allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: liuyong <pkfxxxing@gmail.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261109092744.822646-2-pkfxxxing@gmail.com>
References: <20261109092744.822646-1-pkfxxxing@gmail.com>
 <20261109092744.822646-2-pkfxxxing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 23:38:33 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] scsi: target: single-word handle in Author and Signed-off-by
  trailers
- [High] scsi: target: non-normal prot_op left set on zero-length
  commands
--

commit 7f7b93239c5a185f4d00d18137620ec5fea68e08
Author: liuyong <pkfxxxing@gmail.com>

> scsi: target: Skip zero-length protection SG allocation
>
> A READ(10) command with its TRANSFER LENGTH field set to zero, sent to a
> LUN with protection information enabled, can select TARGET_PROT_DIN_STRIP
> while leaving cmd->prot_length at zero. transport_generic_new_cmd() then
> passes that zero length to target_alloc_sgl(). This reaches
> sg_init_table() with no entries, so sg_init_marker() accesses an invalid
> last entry and causes a target-side Oops, which can also lead to
> use-after-free during subsequent iSCSI connection cleanup. A logged-in
> iSCSI initiator can trigger this on a FILEIO LUN with protection
> information enabled.
>
> Require a nonzero protection length before allocating its SG list,
> allowing commands with no protection payload to proceed without an
> empty allocation.
>
> These issues were discovered and fixed by Qihoo 360's Tulongfeng
> multi-agent system.
>
> Fixes: 5835812f13e5 ("target: ensure se_cmd->t_prot_sg is allocated when =
required")
> Cc: stable@vger.kernel.org
> Signed-off-by: liuyong <pkfxxxing@gmail.com>

[Severity: High]
The Author header and Signed-off-by trailer use a single-word handle
(liuyong) instead of a full real name as required by the Developer's
Certificate of Origin.

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
> index 9819515ce9674..67f71d739b158 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2839,7 +2839,7 @@ transport_generic_new_cmd(struct se_cmd *cmd)
>  	int ret =3D 0;
>  	bool zero_flag =3D !(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB);
> =20
> -	if (cmd->prot_op !=3D TARGET_PROT_NORMAL &&
> +	if (cmd->prot_length && cmd->prot_op !=3D TARGET_PROT_NORMAL &&
>  	    !(cmd->se_cmd_flags & SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC)) {
>  		ret =3D target_alloc_sgl(&cmd->t_prot_sg, &cmd->t_prot_nents,
>  				       cmd->prot_length, true, false);

[Severity: High]
Does skipping only the scatterlist allocation leave cmd->prot_op set to a
non-normal value while cmd->t_prot_sg and cmd->t_data_sg are NULL?

sbc_check_prot() sets cmd->prot_op and cmd->prot_type before computing
cmd->prot_length =3D dev->prot_length * sectors, even when sectors is 0.
When the zero-length READ completes, fabric drivers that branch on
cmd->prot_op in queue_data_in() assume protection and data scatterlists
exist:

drivers/scsi/qla2xxx/qla_target.c:qlt_xmit_response() {
    ...
	if (cmd->se_cmd.prot_op && (xmit_type & QLA_TGT_XMIT_DATA))
		res =3D qlt_build_ctio_crc2_pkt(qpair, &prm);
	else
		res =3D qlt_24xx_build_ctio_pkt(qpair, &prm);
    ...
	if (qlt_has_data(cmd)) {
        ...
	} else
		qlt_24xx_init_ctio_to_isp((struct ctio7_to_24xx *)pkt,
		    &prm);
    ...
}

In qla2xxx, qlt_build_ctio_crc2_pkt() allocates cmd->ctx from
ha->dl_dma_pool (which leaks because cmd->sg_mapped is 0) and builds a
CTIO_CRC2 IOCB that qlt_24xx_init_ctio_to_isp() then overwrites as a Mode 1
status IOCB before submitting it to firmware.  In ib_isert,
isert_rdma_rw_ctx_post() sees isert_prot_cmd() as true and passes NULL
scatterlists to rdma_rw_ctx_signature_init().

Would it be better to skip setting cmd->prot_op in sbc_check_prot() when
sectors is 0?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109092744.8226=
46-1-pkfxxxing@gmail.com?part=3D1
