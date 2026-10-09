Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF4B3BF679
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 04:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791520204; cv=none; b=ma5oFDupSLV2eulayU6g25IuwIS26gpIDSWFmr4ELNGmB5yTLlti19ydhnLfnsYd8tADDhGNV/CSoGcTevNUhC+yuAAC/Uq3zP4Mol5TtrOGSI32n3Rh5xa8Mkiaf+D+KkejA3W91WTt7y79DrmU0rb3hk4MI3Jbg5cs06PbUPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791520204; c=relaxed/simple;
	bh=ZxFy9Ks6hr9y+sK6ocw96HGvPf3rS2Q3AX6EMwyjfds=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=VaWTaV69WidjwaSRifsymu6tKJEvBS+uRe4qbZljUVSD0QaYJf1NKX1Adn4ndYA2S5T4fqKYBS4juIVU2ZcNQZi/GeVsd37sFUPFaP3YDVyPW8G1VcLgjewvbGMKeoG7Iosi0kVg/k6YEzFWbxQWfGRwriVA9DoiUFDDLPeZ/Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KEx2Ocgs; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KEx2Ocgs"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9D5D87A007D;
	Fri,  9 Oct 2026 00:30:00 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 09 Oct 2026 00:30:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791520200; x=1791606600; bh=V5a9/OCCPWacxhkVSOnVTcZO1ek/QwI9y7Q
	wUqqyeGM=; b=KEx2OcgsqrDKlfgORq+/SeBibe08OjzOoq52MuZGkZccFdCsXPj
	f61LrrisyUdHmi/0wWJjZuenV1iGLCliUT6xebTOWkqjxeD8wyaAFflQaxetlakt
	TAgbkou6xZ5pu64JLPJRYqA/yULw+zeWHhZgJcsuf4qfQ5ZpuKVwn/3V4WcuhcMK
	w/R57McSQAJzhFUfnzbtiQCnzuStjX3+CTlX8jOUpqTT8hVQOVdL2RNuWCpHolym
	g9E5DgpwR07Ht41A6Mnq3EtgVArheSdApXtiBqRcoD6F2HCGM0VwI28RULE+hfuK
	ngxRLQqf6o5VW0luHT41WDwF9qzKfGw1ZAA==
X-ME-Sender: <xms:yG3Iaup_VZj7CWpsU8WdWa9DmkOfwvS2nEQdmdaTm4Pv_QQufItpYA>
    <xme:yG3Iaqn75aw77ZsEzwdIfakYdWJIi-7_P2OCQa15eJu1LvDy2-riqbh1ziqS1QoaV
    yIPcGqrb-xdFXPDNjDhjwlyWOUHlfMpySJg_zcCgOtPB3L7_Y87XBA>
X-ME-Received: <xmr:yG3Iaqx6mLXg5_egKuDmwXodXUxJXdeyNdeBxXsj0iqRt2bQyQ2fKAo-AmVyXVSrKqZCL8LyYgcxK3eBtmtuMBuLTBMVH4JrZYo>
X-ME-Proxy-Cause: dmFkZTF4xB3TiXIWyYzufbyBatBGZnc9Y2MKvNcSMamc3PWHBRLLleZg38gcnFlGpiK9zS
    oS8vPC4Cdf3lcCs9LfjMiIYMduw/7Yi5wjxlmbnRBldW1VU+MYpDayGX6ofynq0A1tKBvx
    sUWKp7j7sHmm7hRONChuq/PAHUbjn10aemgm8VxKlBtMC/iOxI+wVYb5rs7QmEYknQLwB7
    5yEr+A3CO7i7BT2HTSV7MeLSHKynqvQ+Z6A6J/t+DMXaYdyI5yhOcZM6Um8dhoNnoB46ej
    x9pTJa/wwT47Oe6cJ3saqfRJJRN8m6Fn1Cbfd1O3mmi7SzK8eFS7FsNg+leLVYie6baUTS
    iVqy0E4CfBi49gSMSyLgaasnbsr3HEWxE5+w615Nripq2RHu7ucVzaQq4iyZaWj5Ez0fBd
    /WkkD/Vbtwj+JRuFkauzxW8hPhjAwE/L/cvZPiPz/KygNx9gF+5TJ+FmYxg9e+ZlpoSbDX
    ldDrcasl98GIRO7QofKS2oHQk8Ti+AcQ7eweJYisd38cR7TZRjfABwFR7QkJY1y4q3myg2
    X0z4fZefTzTmj2ix59q4l2/oub8nwNO9zZ01C9NQ/rJpY4+JazGn43//tYOQzyyNp8Bd+N
    6Jeh8lcpUjNh4R3p85HXbvmu1/KOwx5Ek0I0PeBcyJMfyoEWhBnIzkK55RMw
X-ME-Proxy: <xmx:yG3IaqmuSiykCR3VqB2txLmhCOA8W6oQR6iMkVbdalOZfpUAi6OjBA>
    <xmx:yG3IarfmGGKk5OpWqnfJqdjjYNUtlQaS7LBHNZEpMPgG9RLAIjQwDg>
    <xmx:yG3IaoqdaDiFoSHFp7kySwu1TEKpXp1YB5zyLNylyP6HYSAGVlZMRA>
    <xmx:yG3Iah4Yyx1E4eQpJy4Oqwj8F6HvM6idgT23nFFhg_-kqmAY6fePxA>
    <xmx:yG3Iaohy9MGFJ8urD2mkpQyxLZ-KrxkCFYyCusfilfoQlsR280aeYZUn>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 9 Oct 2026 00:29:57 -0400 (EDT)
Date: Fri, 9 Oct 2026 15:29:52 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: sashiko-reviews@lists.linux.dev
cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Rework BUILD_BUG_ON() assertion
In-Reply-To: <sashiko-outbox-164665@kernel.org>
Message-ID: <93e35f60-e465-7f76-0043-f997fe2ec8c7@linux-m68k.org>
References: <4808a5dc1a71528ffa3360868561009744277450.1791502886.git.fthain@linux-m68k.org> <sashiko-outbox-164665@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii


On Thu, 8 Oct 2026, sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] scsi: qla2xxx: FORTIFY_SOURCE field-spanning write warning in qlt_queue_unknown_atio
> - [High] scsi: qla2xxx: UBSAN/FORTIFY overflow in add_cdb array accesses
> --
> 
> commit 4d96d5f0f41af34ce19bfbd80ce5e059ab28cd98
> Author: Finn Thain <fthain@linux-m68k.org>
> 
> scsi: qla2xxx: Rework BUILD_BUG_ON() assertion
> 
> The LKP bot reported a build failure with CONFIG_COLDFIRE=y together with
> CONFIG_SCSI_QLA_FC=y. The failure is caused by an incorrect BUILD_BUG_ON()
> assertion in qlt_queue_unknown_atio(). To resolve this, a flex array is
> placed at the end of struct qla_tgt_sess_op.
> 
> Closes: https://lore.kernel.org/oe-kbuild-all/202603030747.VX0v4otS-lkp@intel.com/
> Closes: https://lore.kernel.org/oe-kbuild-all/202609301230.CauIUXCF-lkp@intel.com/
> 
> > diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
> > index 71bc1affb1bc9..b27bd3aecbf8e 100644
> > --- a/drivers/scsi/qla2xxx/qla_target.h
> > +++ b/drivers/scsi/qla2xxx/qla_target.h
> > @@ -309,7 +309,8 @@ struct atio7_fcp_cmnd {
> >  	/*
> >  	 * add_cdb is optional and can absent from struct atio7_fcp_cmnd. Size 4
> >  	 * only to make sizeof(struct atio7_fcp_cmnd) be as expected by
> > -	 * BUILD_BUG_ON in qlt_init().
> > +	 * BUILD_BUG_ON in tcm_qla2xxx_init(). See also, BUILD_BUG_ON in
> > +	 * qlt_queue_unknown_atio().
> >  	 */
> >  	uint8_t  add_cdb[4];
> 
> [Severity: High]
> Since add_cdb is explicitly declared as a fixed-size 4-byte array here, does
> the current code cause UBSAN array bounds violations and FORTIFY_SOURCE read
> overflow panics when accessing elements beyond these bounds?
> 
> For instance, in memcpy_atio() when len > 0, it accesses
> &src->u.isp24.fcp_cmnd.add_cdb[len * 4] which is out-of-bounds, and reading
> 4 bytes triggers the overflow panic:
> 
> drivers/scsi/qla2xxx/qla_target.c:memcpy_atio() {
> ...
>     memcpy(&dst->u.isp24.fcp_cmnd.add_cdb[0],
>            &src->u.isp24.fcp_cmnd.add_cdb[len * 4],
>            4);
> ...
> }
> 
> Similarly, get_datalen_for_atio() accesses the array out-of-bounds when
> len > 0:
> 
> drivers/scsi/qla2xxx/qla_target.h:get_datalen_for_atio() {
> ...
>     return get_unaligned_be32(&atio->u.isp24.fcp_cmnd.add_cdb[len * 4]);
> ...
> }
> 
> [ ... ]
> 

Yes, add_cdb[len * 4] is OOB, but it's deliberately OOB so not a bug. This 
patch is not intended to fix either of those pre-existing theoretical 
run-time checker failures. That's out-of-scope and would seem to require 
access to the relevant QLA2xxx hardware as well as appropriate toolchain, 
.config, workload etc.

> > @@ -845,7 +846,11 @@ struct qla_tgt_sess_op {
> >  	struct rsp_que *rsp;
> >  
> >  	struct atio_from_isp atio;
> > -	/* DO NOT ADD ANYTHING ELSE HERE - atio must be last member */
> > +	/*
> > +	 * DO NOT ADD ANYTHING ELSE HERE.
> > +	 * atio.u.isp24.fcp_cmnd.add_cdb may extend past end of atio.
> > +	 */
> > +	uint8_t atio_u_isp24_fcp_cmnd_add_cdb[];
> >  };
> 
> [Severity: High]
> Since this patch introduces the flexible array atio_u_isp24_fcp_cmnd_add_cdb[]
> to legally hold the trailing data, shouldn't the memcpy() in
> qlt_queue_unknown_atio() be updated to target it?
> 

No, because atio_u_isp24_fcp_cmnd_add_cdb[] is only added as a sentinel. 
It's an attempt to coax the compiler into helping discourage the same kind 
of mistake that FORTIFY_SOURCE and UBSAN are supposed to detect.

> drivers/scsi/qla2xxx/qla_target.c:qlt_queue_unknown_atio() {
> ...
>     u = kzalloc(sizeof(*u) + add_cdb_len, GFP_ATOMIC);
>     ...
>     memcpy(&u->atio, atio, sizeof(*atio) + add_cdb_len);
> ...
> }
> 
> Because the destination is typed strictly as &u->atio, copying more than
> 64 bytes (sizeof(*atio)) when add_cdb_len > 0 causes a FORTIFY_SOURCE
> intra-object write overflow panic.
> 

That's also a pre-existing theoretical failure (and not a real bug, since 
it's deliberately OOB) and is also out-of-scope for this patch. This patch 
just addresses the build failure caused by the struct padding change.

Thanks for your review.

P.S. my preferred solution (and the first patch* I sent) to fix this build 
failure simply removed the BUILD_BUG_ON(). Sashiko-bot's criticism seems 
to support that preference, IMHO.

*
https://lore.kernel.org/linux-m68k/550e7d7bb8c2620ca4f6c9e809a4f853bdfa4c67.1772751689.git.fthain@linux-m68k.org/
