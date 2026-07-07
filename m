Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FB13AC0D0
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783406982; cv=none; b=T0jPtiUVMgSv2RHc4CYI0XSDhj81NdlOEltffoelm9YGhaMBrFFgsCGA9/0/cph/pbu4WMAhKfju6CdF1KV5hhvg7RbqppJ5lVgYcwdi1Nn4YHyAwBEtG5r8gruL5hMciRni3Z8bo7borwFnyyNq4vGoZlbxqPnL1IfzlQOxDrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783406982; c=relaxed/simple;
	bh=YpZRNbjce6dbwyK5SNvg/SLkw2VcHUmXOpK2+ZjI/gg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l/ybXy3Sy675ZEwBO7FtW/4hFM2FfyEb+VUzTxAAgouqSkU8fpNJdfZaz5WO6iClu4JvoQvL3Ltt7hr8V6FcwDf6RLx83hYXiPcBmUl4VPMvaolwQCI/SV3BW5lMn9hvbLYTflis9Piz2gUXlDC9+FhVbCsTI1rBG0E0stZG3Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Asp0a+wI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Asp0a+wI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ED91F000E9;
	Tue,  7 Jul 2026 06:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783406979;
	bh=U3g1OdbywT9Y9eD10axQQg+n1t5pGNnRS6+UEWfzuNE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Asp0a+wIOiA87W6bfdP4UNdAG9ni+TQId9JlKL0XvDNLtS+MwaHdI4YhfB0a3MzcH
	 WYKfRdSC+4+urDef55oKI7Eh98H1xjIcPgAiw/O2hTkR5EFfy6CYhjGgluky4ddFak
	 x7OKYHE16+7gj97rSjKH09bdiwxR4Hi6erIIBfxf0NZ6t+yEHdPHqi8U6PjVhzpchY
	 JvdVeFxsV8M8dkN8BBjYVtVwrclNlUVIcV2sjY71Zg6dK+7k/yEEL/caPu3v0Pkcs+
	 b6TYn0qwNf7XcYiTlMOb96YuDIIRBbD1Azyfp7LmBdsNJQL2y6QoYbHV6/Qsq/gvgU
	 oDPsT/g26JCvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 43/88] scsi: qla2xxx: Use 64-bit FPM word counters
 for 29xx host stats
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-44-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-44-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:49:39 +0000
Message-Id: <20260707064939.A8ED91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Double byte-swap on 32-bit stats and interleaved byte-swap on 64=
-bit stats on Big Endian architectures causes incorrect statistics.

Pre-existing issues:
- [High] Lockless iteration over queue_pair_map can lead to a Use-After-Fre=
e if a queue pair is deleted concurrently.
--

--- Patch [43]: [PATCH v3 43/88] scsi: qla2xxx: Use 64-bit FPM word counter=
s for 29xx host stats ---
commit 49bea1c486fa84692809036041ccbb835c83caa2
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Use 64-bit FPM word counters for 29xx host stats

This patch updates the statistics retrieval for QLA29XX adapters. It enables
reporting hardware 64-bit FPM transmit and receive word counters instead of
falling back to a software approximation.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 19aa66b8ca521..6cf74f8c9628d 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -2990,7 +2990,8 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)

[Severity: High]
This is a pre-existing issue, but does this function have a use-after-free
race when accessing queue pairs?

Earlier in qla2x00_get_fc_host_stats(), the code iterates over
queue_pair_map without holding ha->mq_lock or using RCU:

    for (i =3D 0; i < vha->hw->max_qpairs; i++) {
        qpair =3D vha->hw->queue_pair_map[i];
        if (!qpair)
            continue;
        ir +=3D qpair->counters.input_requests;

If a user reads sysfs concurrently while a queue pair is being deleted via
qla2xxx_delete_qpair() (which holds mq_lock, removes the map entry, and cal=
ls
kfree), could the sysfs reader be preempted after loading a non-NULL qpair
pointer and then dereference freed memory when it resumes?

>  		p->error_frames =3D
>  		    le32_to_cpu(stats->dropped_frames) +
>  		    le32_to_cpu(stats->discarded_frames);
> -		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
> +		    IS_QLA29XX(ha)) {
>  			p->rx_words =3D le64_to_cpu(stats->fpm_recv_word_cnt);
>  			p->tx_words =3D le64_to_cpu(stats->fpm_xmit_word_cnt);

[Severity: Medium]
Will this result in corrupted 64-bit statistics on big endian architectures?

When qla24xx_get_isp_stats() populates the buffer via DMA, it performs an
in-place byte-swap of the entire buffer as an array of 32-bit words:

    for ( ; dwords--; iter++)
        le32_to_cpus(iter);

If we apply le64_to_cpu() here on the 64-bit fpm_recv_word_cnt and
fpm_xmit_word_cnt fields after they were already in-place swapped as 32-bit
words, won't it result in the two 32-bit halves being swapped, but their
internal bytes being reversed relative to little endian?

This issue seems to exist for older adapters, but this patch now exposes
QLA29XX to the same problem by adding it to the condition.

>  		} else {
>  			p->rx_words =3D ib >> 2;
>  			p->tx_words =3D ob >> 2;
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D43
