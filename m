Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE22753D9E5
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 15:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792077653; cv=none; b=h+PlLhHVNTdC8uIiiOGH3RldeUlcBI8XNKPRCwS6QDfkULelrBrG1vaX20h8ktRZCFHgS9aZP1KW2UtkNqbvTuAC1agTh848yhNw58uMWdK6fsJXkTGN8Fax+JYVK/foaO34bR3UwOkDSDFjegehkloJrGm5H04HJsowe0HEQ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792077653; c=relaxed/simple;
	bh=SKXBawRB5lkh2dzqqUcG+1+WAWnvcK3JON9A/WZLQzg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BYMZYJu13aEjxAqlHxbV6tdTNPbYg+WZ0Wz0kOb41/agpr++80xXfAL5op2Jo8ZbYyQkVTJMo8MJlz2J1b8j/ZtDbpWekt4mInH9v59WKbMeYMUyd2WaPNmiJ/vspCtzQ2tk+HG9OBA64lMpHg2N1QF8BNqW+ooy5J+yNLB27GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JahKE94S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JahKE94S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0E51F000C4;
	Thu, 15 Oct 2026 15:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792077650;
	bh=vHvFePU12uE0z0Rf+NENnxDCRyRjgKKoDGFI66v3X5M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JahKE94SRHnQDTljZeM4rsoHBb4ccz6tJ7Q+KhPaowKh0wXrDGib/Mxw3G1zgmMh7
	 gmJA3fipXqiO2YoTvlQYnG/2LNrmp0HQ4RTtTllwZe8aRtVv7SUpl/rvftBoUrlW8G
	 ip1Nns1hn+RAEAcHVz2pJtUCVYBpVOJzkdjbtTSkD6jgRYsvngSzVJZJZipHrIDbhr
	 6od+tawovTLfc5sBy4f/DdPTGmQtl0i9W6r+EYMhJGR/sKWSbZ8Pd9lbPCLozQTmRP
	 JELwV6EN1rvHsnHpm7XybBuJHW49wvgkuQrFLyZJwRHwNlX2f0sRATulw8Cqwg7gjY
	 RqMHggmbYGiqg==
Message-ID: <sashiko-outbox-173054@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 03/11] scsi: ibmvfc: fix potential NULL pointer
 dereference on failed queue allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015-ibmvfc-fpin-support-v14-3-a0b063b8d825@linux.ibm.com>
References: <20261015-ibmvfc-fpin-support-v14-0-a0b063b8d825@linux.ibm.com>
 <20261015-ibmvfc-fpin-support-v14-3-a0b063b8d825@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 15:20:49 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] scsi: ibmvfc: Build failure due to un-guarded KUnit visibility macr=
os
--

commit 79ff3803bf62c41db84d726eab4c3cdbd582546c
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: fix potential NULL pointer dereference on failed queue alloca=
tion

This commit guards ibmvfc_deregister_channel() against operating on unalloc=
ated
queues and exposes it for KUnit testing. It also adds a new KUnit test modu=
le
for the IBM POWER Virtual FC Client.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 145d559041f12..0fe6b6f4260ba 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> -static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
> +/**
> + * ibmvfc_deregister_channel - Deregister a sub-CRQ channel with the hyp=
ervisor
> + * @vhost:	ibmvfc host struct
> + * @channels:	ibmvfc channels struct containing the sub-CRQ array
> + * @index:	index into the sub-CRQ array
> + *
> + * Frees the IRQ, disposes of the IRQ mapping, and calls H_FREE_SUB_CRQ =
to
> + * release the sub-CRQ with the hypervisor. On success the queue message
> + * buffer is zeroed and the current index is reset. If H_FREE_SUB_CRQ fa=
ils,
> + * an error is logged but the channel resources are cleaned up regardles=
s.
> + */
> +VISIBLE_IF_KUNIT void ibmvfc_deregister_channel(struct ibmvfc_host *vhos=
t,
>  				      struct ibmvfc_channels *channels,
>  				      int index)
>  {

[Severity: Low]
Does this cause a build failure when CONFIG_KUNIT is disabled?

Since <kunit/visibility.h> is only included conditionally in ibmvfc.h under
#if IS_ENABLED(CONFIG_KUNIT), won't the unconditional use of VISIBLE_IF_KUN=
IT
here (and EXPORT_SYMBOL_IF_KUNIT below) result in syntax errors during a
standard build without KUnit?

[ ... ]

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvf=
c.h
> index ca80ceffe53a5..421ce8bc3ea33 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h

[ ... ]

> +#if IS_ENABLED(CONFIG_KUNIT)
> +#include <kunit/visibility.h>
> +VISIBLE_IF_KUNIT void ibmvfc_deregister_channel(struct ibmvfc_host *vhos=
t,
> +						struct ibmvfc_channels *channels,
> +						int index);
> +VISIBLE_IF_KUNIT struct ibmvfc_host *ibmvfc_get_first_vhost(void);
> +#endif

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015-ibmvfc-fpi=
n-support-v14-0-a0b063b8d825@linux.ibm.com?part=3D3
